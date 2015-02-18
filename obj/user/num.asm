
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 97 01 00 00       	call   8001c8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800043:	8d 5d e7             	lea    -0x19(%ebp),%ebx
  800046:	e9 81 00 00 00       	jmp    8000cc <num+0x98>
		if (bol) {
  80004b:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800052:	74 27                	je     80007b <num+0x47>
			printf("%5d ", ++line);
  800054:	a1 00 40 80 00       	mov    0x804000,%eax
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	a3 00 40 80 00       	mov    %eax,0x804000
  800061:	89 44 24 04          	mov    %eax,0x4(%esp)
  800065:	c7 04 24 60 2a 80 00 	movl   $0x802a60,(%esp)
  80006c:	e8 46 1b 00 00       	call   801bb7 <printf>
			bol = 0;
  800071:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800078:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  80007b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800082:	00 
  800083:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80008e:	e8 73 13 00 00       	call   801406 <write>
  800093:	83 f8 01             	cmp    $0x1,%eax
  800096:	74 24                	je     8000bc <num+0x88>
			panic("write error copying %s: %e", s, r);
  800098:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000a0:	c7 44 24 08 65 2a 80 	movl   $0x802a65,0x8(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000af:	00 
  8000b0:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  8000b7:	e8 70 01 00 00       	call   80022c <_panic>
		if (c == '\n')
  8000bc:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8000c0:	75 0a                	jne    8000cc <num+0x98>
			bol = 1;
  8000c2:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c9:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d3:	00 
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 af 13 00 00       	call   80148f <read>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 8f 63 ff ff ff    	jg     80004b <num+0x17>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	79 24                	jns    800110 <num+0xdc>
		panic("error reading %s: %e", s, n);
  8000ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000f4:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  8000fb:	00 
  8000fc:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  80010b:	e8 1c 01 00 00       	call   80022c <_panic>
}
  800110:	83 c4 3c             	add    $0x3c,%esp
  800113:	5b                   	pop    %ebx
  800114:	5e                   	pop    %esi
  800115:	5f                   	pop    %edi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 3c             	sub    $0x3c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 a0 	movl   $0x802aa0,0x803004
  800128:	2a 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0d                	je     80013e <umain+0x26>
  800131:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800134:	83 c3 04             	add    $0x4,%ebx
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
  80013c:	eb 76                	jmp    8001b4 <umain+0x9c>
		num(0, "<stdin>");
  80013e:	c7 44 24 04 a4 2a 80 	movl   $0x802aa4,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 e2 fe ff ff       	call   800034 <num>
  800152:	eb 65                	jmp    8001b9 <umain+0xa1>
  800154:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80015e:	00 
  80015f:	8b 03                	mov    (%ebx),%eax
  800161:	89 04 24             	mov    %eax,(%esp)
  800164:	e8 02 19 00 00       	call   801a6b <open>
  800169:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80016b:	85 c0                	test   %eax,%eax
  80016d:	79 29                	jns    800198 <umain+0x80>
				panic("can't open %s: %e", argv[i], f);
  80016f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800173:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800176:	8b 02                	mov    (%edx),%eax
  800178:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80017c:	c7 44 24 08 ac 2a 80 	movl   $0x802aac,0x8(%esp)
  800183:	00 
  800184:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80018b:	00 
  80018c:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  800193:	e8 94 00 00 00       	call   80022c <_panic>
			else {
				num(f, argv[i]);
  800198:	8b 03                	mov    (%ebx),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	89 34 24             	mov    %esi,(%esp)
  8001a1:	e8 8e fe ff ff       	call   800034 <num>
				close(f);
  8001a6:	89 34 24             	mov    %esi,(%esp)
  8001a9:	e8 48 14 00 00       	call   8015f6 <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001ae:	83 c7 01             	add    $0x1,%edi
  8001b1:	83 c3 04             	add    $0x4,%ebx
  8001b4:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001b7:	7c 9b                	jl     800154 <umain+0x3c>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001b9:	e8 5a 00 00 00       	call   800218 <exit>
}
  8001be:	83 c4 3c             	add    $0x3c,%esp
  8001c1:	5b                   	pop    %ebx
  8001c2:	5e                   	pop    %esi
  8001c3:	5f                   	pop    %edi
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    
	...

008001c8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	83 ec 18             	sub    $0x18,%esp
  8001ce:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001d1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8001d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8001da:	e8 42 0f 00 00       	call   801121 <sys_getenvid>
  8001df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e7:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8001ec:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f1:	85 f6                	test   %esi,%esi
  8001f3:	7e 07                	jle    8001fc <libmain+0x34>
		binaryname = argv[0];
  8001f5:	8b 03                	mov    (%ebx),%eax
  8001f7:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800200:	89 34 24             	mov    %esi,(%esp)
  800203:	e8 10 ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800208:	e8 0b 00 00 00       	call   800218 <exit>
}
  80020d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800210:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800213:	89 ec                	mov    %ebp,%esp
  800215:	5d                   	pop    %ebp
  800216:	c3                   	ret    
	...

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80021e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800225:	e8 2b 0f 00 00       	call   801155 <sys_env_destroy>
}
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800234:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800237:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  80023d:	e8 df 0e 00 00       	call   801121 <sys_getenvid>
  800242:	8b 55 0c             	mov    0xc(%ebp),%edx
  800245:	89 54 24 10          	mov    %edx,0x10(%esp)
  800249:	8b 55 08             	mov    0x8(%ebp),%edx
  80024c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800250:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800254:	89 44 24 04          	mov    %eax,0x4(%esp)
  800258:	c7 04 24 c8 2a 80 00 	movl   $0x802ac8,(%esp)
  80025f:	e8 81 00 00 00       	call   8002e5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800264:	89 74 24 04          	mov    %esi,0x4(%esp)
  800268:	8b 45 10             	mov    0x10(%ebp),%eax
  80026b:	89 04 24             	mov    %eax,(%esp)
  80026e:	e8 11 00 00 00       	call   800284 <vcprintf>
	cprintf("\n");
  800273:	c7 04 24 87 2f 80 00 	movl   $0x802f87,(%esp)
  80027a:	e8 66 00 00 00       	call   8002e5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027f:	cc                   	int3   
  800280:	eb fd                	jmp    80027f <_panic+0x53>
	...

00800284 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80028d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800294:	00 00 00 
	b.cnt = 0;
  800297:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b9:	c7 04 24 ff 02 80 00 	movl   $0x8002ff,(%esp)
  8002c0:	e8 be 01 00 00       	call   800483 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	e8 23 0a 00 00       	call   800d00 <sys_cputs>

	return b.cnt;
}
  8002dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002eb:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	e8 87 ff ff ff       	call   800284 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	53                   	push   %ebx
  800303:	83 ec 14             	sub    $0x14,%esp
  800306:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800309:	8b 03                	mov    (%ebx),%eax
  80030b:	8b 55 08             	mov    0x8(%ebp),%edx
  80030e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800312:	83 c0 01             	add    $0x1,%eax
  800315:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800317:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031c:	75 19                	jne    800337 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80031e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800325:	00 
  800326:	8d 43 08             	lea    0x8(%ebx),%eax
  800329:	89 04 24             	mov    %eax,(%esp)
  80032c:	e8 cf 09 00 00       	call   800d00 <sys_cputs>
		b->idx = 0;
  800331:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800337:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80033b:	83 c4 14             	add    $0x14,%esp
  80033e:	5b                   	pop    %ebx
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    
  800341:	00 00                	add    %al,(%eax)
	...

00800344 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	57                   	push   %edi
  800348:	56                   	push   %esi
  800349:	53                   	push   %ebx
  80034a:	83 ec 4c             	sub    $0x4c,%esp
  80034d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800350:	89 d6                	mov    %edx,%esi
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80035b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80035e:	8b 45 10             	mov    0x10(%ebp),%eax
  800361:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800364:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800367:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80036a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036f:	39 d1                	cmp    %edx,%ecx
  800371:	72 07                	jb     80037a <printnum+0x36>
  800373:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800376:	39 d0                	cmp    %edx,%eax
  800378:	77 69                	ja     8003e3 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80037e:	83 eb 01             	sub    $0x1,%ebx
  800381:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800385:	89 44 24 08          	mov    %eax,0x8(%esp)
  800389:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80038d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800391:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800394:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800397:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80039a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80039e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003a5:	00 
  8003a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a9:	89 04 24             	mov    %eax,(%esp)
  8003ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003af:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003b3:	e8 38 24 00 00       	call   8027f0 <__udivdi3>
  8003b8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003bb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003be:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003c6:	89 04 24             	mov    %eax,(%esp)
  8003c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003cd:	89 f2                	mov    %esi,%edx
  8003cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d2:	e8 6d ff ff ff       	call   800344 <printnum>
  8003d7:	eb 11                	jmp    8003ea <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003dd:	89 3c 24             	mov    %edi,(%esp)
  8003e0:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e3:	83 eb 01             	sub    $0x1,%ebx
  8003e6:	85 db                	test   %ebx,%ebx
  8003e8:	7f ef                	jg     8003d9 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003ee:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800400:	00 
  800401:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800404:	89 14 24             	mov    %edx,(%esp)
  800407:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80040e:	e8 0d 25 00 00       	call   802920 <__umoddi3>
  800413:	89 74 24 04          	mov    %esi,0x4(%esp)
  800417:	0f be 80 eb 2a 80 00 	movsbl 0x802aeb(%eax),%eax
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800424:	83 c4 4c             	add    $0x4c,%esp
  800427:	5b                   	pop    %ebx
  800428:	5e                   	pop    %esi
  800429:	5f                   	pop    %edi
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042f:	83 fa 01             	cmp    $0x1,%edx
  800432:	7e 0e                	jle    800442 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800434:	8b 10                	mov    (%eax),%edx
  800436:	8d 4a 08             	lea    0x8(%edx),%ecx
  800439:	89 08                	mov    %ecx,(%eax)
  80043b:	8b 02                	mov    (%edx),%eax
  80043d:	8b 52 04             	mov    0x4(%edx),%edx
  800440:	eb 22                	jmp    800464 <getuint+0x38>
	else if (lflag)
  800442:	85 d2                	test   %edx,%edx
  800444:	74 10                	je     800456 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800446:	8b 10                	mov    (%eax),%edx
  800448:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044b:	89 08                	mov    %ecx,(%eax)
  80044d:	8b 02                	mov    (%edx),%eax
  80044f:	ba 00 00 00 00       	mov    $0x0,%edx
  800454:	eb 0e                	jmp    800464 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800456:	8b 10                	mov    (%eax),%edx
  800458:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045b:	89 08                	mov    %ecx,(%eax)
  80045d:	8b 02                	mov    (%edx),%eax
  80045f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800464:	5d                   	pop    %ebp
  800465:	c3                   	ret    

00800466 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80046c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800470:	8b 10                	mov    (%eax),%edx
  800472:	3b 50 04             	cmp    0x4(%eax),%edx
  800475:	73 0a                	jae    800481 <sprintputch+0x1b>
		*b->buf++ = ch;
  800477:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80047a:	88 0a                	mov    %cl,(%edx)
  80047c:	83 c2 01             	add    $0x1,%edx
  80047f:	89 10                	mov    %edx,(%eax)
}
  800481:	5d                   	pop    %ebp
  800482:	c3                   	ret    

00800483 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	57                   	push   %edi
  800487:	56                   	push   %esi
  800488:	53                   	push   %ebx
  800489:	83 ec 4c             	sub    $0x4c,%esp
  80048c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80048f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800492:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800495:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80049c:	eb 11                	jmp    8004af <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80049e:	85 c0                	test   %eax,%eax
  8004a0:	0f 84 b6 03 00 00    	je     80085c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8004a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004aa:	89 04 24             	mov    %eax,(%esp)
  8004ad:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004af:	0f b6 03             	movzbl (%ebx),%eax
  8004b2:	83 c3 01             	add    $0x1,%ebx
  8004b5:	83 f8 25             	cmp    $0x25,%eax
  8004b8:	75 e4                	jne    80049e <vprintfmt+0x1b>
  8004ba:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8004be:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004c5:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004db:	eb 06                	jmp    8004e3 <vprintfmt+0x60>
  8004dd:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8004e1:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	0f b6 0b             	movzbl (%ebx),%ecx
  8004e6:	0f b6 c1             	movzbl %cl,%eax
  8004e9:	8d 53 01             	lea    0x1(%ebx),%edx
  8004ec:	83 e9 23             	sub    $0x23,%ecx
  8004ef:	80 f9 55             	cmp    $0x55,%cl
  8004f2:	0f 87 47 03 00 00    	ja     80083f <vprintfmt+0x3bc>
  8004f8:	0f b6 c9             	movzbl %cl,%ecx
  8004fb:	ff 24 8d 20 2c 80 00 	jmp    *0x802c20(,%ecx,4)
  800502:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800506:	eb d9                	jmp    8004e1 <vprintfmt+0x5e>
  800508:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80050f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800514:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800517:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80051b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80051e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800521:	83 fb 09             	cmp    $0x9,%ebx
  800524:	77 30                	ja     800556 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800526:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800529:	eb e9                	jmp    800514 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 48 04             	lea    0x4(%eax),%ecx
  800531:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800534:	8b 00                	mov    (%eax),%eax
  800536:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800539:	eb 1e                	jmp    800559 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80053b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053f:	b8 00 00 00 00       	mov    $0x0,%eax
  800544:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800548:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80054b:	eb 94                	jmp    8004e1 <vprintfmt+0x5e>
  80054d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800554:	eb 8b                	jmp    8004e1 <vprintfmt+0x5e>
  800556:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800559:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80055d:	79 82                	jns    8004e1 <vprintfmt+0x5e>
  80055f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800565:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800568:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80056b:	e9 71 ff ff ff       	jmp    8004e1 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800570:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800574:	e9 68 ff ff ff       	jmp    8004e1 <vprintfmt+0x5e>
  800579:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 50 04             	lea    0x4(%eax),%edx
  800582:	89 55 14             	mov    %edx,0x14(%ebp)
  800585:	89 74 24 04          	mov    %esi,0x4(%esp)
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	89 04 24             	mov    %eax,(%esp)
  80058e:	ff d7                	call   *%edi
  800590:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800593:	e9 17 ff ff ff       	jmp    8004af <vprintfmt+0x2c>
  800598:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 c2                	mov    %eax,%edx
  8005a8:	c1 fa 1f             	sar    $0x1f,%edx
  8005ab:	31 d0                	xor    %edx,%eax
  8005ad:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005af:	83 f8 11             	cmp    $0x11,%eax
  8005b2:	7f 0b                	jg     8005bf <vprintfmt+0x13c>
  8005b4:	8b 14 85 80 2d 80 00 	mov    0x802d80(,%eax,4),%edx
  8005bb:	85 d2                	test   %edx,%edx
  8005bd:	75 20                	jne    8005df <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8005bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005c3:	c7 44 24 08 fc 2a 80 	movl   $0x802afc,0x8(%esp)
  8005ca:	00 
  8005cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cf:	89 3c 24             	mov    %edi,(%esp)
  8005d2:	e8 0d 03 00 00       	call   8008e4 <printfmt>
  8005d7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005da:	e9 d0 fe ff ff       	jmp    8004af <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005e3:	c7 44 24 08 da 2e 80 	movl   $0x802eda,0x8(%esp)
  8005ea:	00 
  8005eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ef:	89 3c 24             	mov    %edi,(%esp)
  8005f2:	e8 ed 02 00 00       	call   8008e4 <printfmt>
  8005f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005fa:	e9 b0 fe ff ff       	jmp    8004af <vprintfmt+0x2c>
  8005ff:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800602:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800608:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 50 04             	lea    0x4(%eax),%edx
  800611:	89 55 14             	mov    %edx,0x14(%ebp)
  800614:	8b 18                	mov    (%eax),%ebx
  800616:	85 db                	test   %ebx,%ebx
  800618:	b8 05 2b 80 00       	mov    $0x802b05,%eax
  80061d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800620:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800624:	7e 76                	jle    80069c <vprintfmt+0x219>
  800626:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80062a:	74 7a                	je     8006a6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80062c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800630:	89 1c 24             	mov    %ebx,(%esp)
  800633:	e8 f0 02 00 00       	call   800928 <strnlen>
  800638:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80063b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80063d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800641:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800644:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800647:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800649:	eb 0f                	jmp    80065a <vprintfmt+0x1d7>
					putch(padc, putdat);
  80064b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80064f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800652:	89 04 24             	mov    %eax,(%esp)
  800655:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800657:	83 eb 01             	sub    $0x1,%ebx
  80065a:	85 db                	test   %ebx,%ebx
  80065c:	7f ed                	jg     80064b <vprintfmt+0x1c8>
  80065e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800661:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800664:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800667:	89 f7                	mov    %esi,%edi
  800669:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80066c:	eb 40                	jmp    8006ae <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80066e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800672:	74 18                	je     80068c <vprintfmt+0x209>
  800674:	8d 50 e0             	lea    -0x20(%eax),%edx
  800677:	83 fa 5e             	cmp    $0x5e,%edx
  80067a:	76 10                	jbe    80068c <vprintfmt+0x209>
					putch('?', putdat);
  80067c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800680:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800687:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80068a:	eb 0a                	jmp    800696 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  80068c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800690:	89 04 24             	mov    %eax,(%esp)
  800693:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800696:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80069a:	eb 12                	jmp    8006ae <vprintfmt+0x22b>
  80069c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80069f:	89 f7                	mov    %esi,%edi
  8006a1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006a4:	eb 08                	jmp    8006ae <vprintfmt+0x22b>
  8006a6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006a9:	89 f7                	mov    %esi,%edi
  8006ab:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006ae:	0f be 03             	movsbl (%ebx),%eax
  8006b1:	83 c3 01             	add    $0x1,%ebx
  8006b4:	85 c0                	test   %eax,%eax
  8006b6:	74 25                	je     8006dd <vprintfmt+0x25a>
  8006b8:	85 f6                	test   %esi,%esi
  8006ba:	78 b2                	js     80066e <vprintfmt+0x1eb>
  8006bc:	83 ee 01             	sub    $0x1,%esi
  8006bf:	79 ad                	jns    80066e <vprintfmt+0x1eb>
  8006c1:	89 fe                	mov    %edi,%esi
  8006c3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006c6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006c9:	eb 1a                	jmp    8006e5 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006cf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006d6:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d8:	83 eb 01             	sub    $0x1,%ebx
  8006db:	eb 08                	jmp    8006e5 <vprintfmt+0x262>
  8006dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006e0:	89 fe                	mov    %edi,%esi
  8006e2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006e5:	85 db                	test   %ebx,%ebx
  8006e7:	7f e2                	jg     8006cb <vprintfmt+0x248>
  8006e9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006ec:	e9 be fd ff ff       	jmp    8004af <vprintfmt+0x2c>
  8006f1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006f7:	83 f9 01             	cmp    $0x1,%ecx
  8006fa:	7e 16                	jle    800712 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 50 08             	lea    0x8(%eax),%edx
  800702:	89 55 14             	mov    %edx,0x14(%ebp)
  800705:	8b 10                	mov    (%eax),%edx
  800707:	8b 48 04             	mov    0x4(%eax),%ecx
  80070a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80070d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800710:	eb 32                	jmp    800744 <vprintfmt+0x2c1>
	else if (lflag)
  800712:	85 c9                	test   %ecx,%ecx
  800714:	74 18                	je     80072e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 50 04             	lea    0x4(%eax),%edx
  80071c:	89 55 14             	mov    %edx,0x14(%ebp)
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 c1                	mov    %eax,%ecx
  800726:	c1 f9 1f             	sar    $0x1f,%ecx
  800729:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80072c:	eb 16                	jmp    800744 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 50 04             	lea    0x4(%eax),%edx
  800734:	89 55 14             	mov    %edx,0x14(%ebp)
  800737:	8b 00                	mov    (%eax),%eax
  800739:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073c:	89 c2                	mov    %eax,%edx
  80073e:	c1 fa 1f             	sar    $0x1f,%edx
  800741:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800744:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800747:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80074a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80074f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800753:	0f 89 a7 00 00 00    	jns    800800 <vprintfmt+0x37d>
				putch('-', putdat);
  800759:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800764:	ff d7                	call   *%edi
				num = -(long long) num;
  800766:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800769:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80076c:	f7 d9                	neg    %ecx
  80076e:	83 d3 00             	adc    $0x0,%ebx
  800771:	f7 db                	neg    %ebx
  800773:	b8 0a 00 00 00       	mov    $0xa,%eax
  800778:	e9 83 00 00 00       	jmp    800800 <vprintfmt+0x37d>
  80077d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800780:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800783:	89 ca                	mov    %ecx,%edx
  800785:	8d 45 14             	lea    0x14(%ebp),%eax
  800788:	e8 9f fc ff ff       	call   80042c <getuint>
  80078d:	89 c1                	mov    %eax,%ecx
  80078f:	89 d3                	mov    %edx,%ebx
  800791:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800796:	eb 68                	jmp    800800 <vprintfmt+0x37d>
  800798:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80079b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80079e:	89 ca                	mov    %ecx,%edx
  8007a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a3:	e8 84 fc ff ff       	call   80042c <getuint>
  8007a8:	89 c1                	mov    %eax,%ecx
  8007aa:	89 d3                	mov    %edx,%ebx
  8007ac:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8007b1:	eb 4d                	jmp    800800 <vprintfmt+0x37d>
  8007b3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8007b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ba:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007c1:	ff d7                	call   *%edi
			putch('x', putdat);
  8007c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007ce:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8d 50 04             	lea    0x4(%eax),%edx
  8007d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d9:	8b 08                	mov    (%eax),%ecx
  8007db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007e5:	eb 19                	jmp    800800 <vprintfmt+0x37d>
  8007e7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007ea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007ed:	89 ca                	mov    %ecx,%edx
  8007ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f2:	e8 35 fc ff ff       	call   80042c <getuint>
  8007f7:	89 c1                	mov    %eax,%ecx
  8007f9:	89 d3                	mov    %edx,%ebx
  8007fb:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800800:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800804:	89 54 24 10          	mov    %edx,0x10(%esp)
  800808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80080b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80080f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800813:	89 0c 24             	mov    %ecx,(%esp)
  800816:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80081a:	89 f2                	mov    %esi,%edx
  80081c:	89 f8                	mov    %edi,%eax
  80081e:	e8 21 fb ff ff       	call   800344 <printnum>
  800823:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800826:	e9 84 fc ff ff       	jmp    8004af <vprintfmt+0x2c>
  80082b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800832:	89 04 24             	mov    %eax,(%esp)
  800835:	ff d7                	call   *%edi
  800837:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80083a:	e9 70 fc ff ff       	jmp    8004af <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80083f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800843:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80084a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80084f:	80 38 25             	cmpb   $0x25,(%eax)
  800852:	0f 84 57 fc ff ff    	je     8004af <vprintfmt+0x2c>
  800858:	89 c3                	mov    %eax,%ebx
  80085a:	eb f0                	jmp    80084c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  80085c:	83 c4 4c             	add    $0x4c,%esp
  80085f:	5b                   	pop    %ebx
  800860:	5e                   	pop    %esi
  800861:	5f                   	pop    %edi
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	83 ec 28             	sub    $0x28,%esp
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800870:	85 c0                	test   %eax,%eax
  800872:	74 04                	je     800878 <vsnprintf+0x14>
  800874:	85 d2                	test   %edx,%edx
  800876:	7f 07                	jg     80087f <vsnprintf+0x1b>
  800878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087d:	eb 3b                	jmp    8008ba <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800882:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800897:	8b 45 10             	mov    0x10(%ebp),%eax
  80089a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a5:	c7 04 24 66 04 80 00 	movl   $0x800466,(%esp)
  8008ac:	e8 d2 fb ff ff       	call   800483 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ba:	c9                   	leave  
  8008bb:	c3                   	ret    

008008bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008c2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	89 04 24             	mov    %eax,(%esp)
  8008dd:	e8 82 ff ff ff       	call   800864 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 79 fb ff ff       	call   800483 <vprintfmt>
	va_end(ap);
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    
  80090c:	00 00                	add    %al,(%eax)
	...

00800910 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 55 08             	mov    0x8(%ebp),%edx
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80091b:	eb 03                	jmp    800920 <strlen+0x10>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800924:	75 f7                	jne    80091d <strlen+0xd>
		n++;
	return n;
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	53                   	push   %ebx
  80092c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80092f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800937:	eb 03                	jmp    80093c <strnlen+0x14>
		n++;
  800939:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093c:	39 c1                	cmp    %eax,%ecx
  80093e:	74 06                	je     800946 <strnlen+0x1e>
  800940:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800944:	75 f3                	jne    800939 <strnlen+0x11>
		n++;
	return n;
}
  800946:	5b                   	pop    %ebx
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	53                   	push   %ebx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800958:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80095f:	83 c2 01             	add    $0x1,%edx
  800962:	84 c9                	test   %cl,%cl
  800964:	75 f2                	jne    800958 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800966:	5b                   	pop    %ebx
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	53                   	push   %ebx
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800973:	89 1c 24             	mov    %ebx,(%esp)
  800976:	e8 95 ff ff ff       	call   800910 <strlen>
	strcpy(dst + len, src);
  80097b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800982:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800985:	89 04 24             	mov    %eax,(%esp)
  800988:	e8 bc ff ff ff       	call   800949 <strcpy>
	return dst;
}
  80098d:	89 d8                	mov    %ebx,%eax
  80098f:	83 c4 08             	add    $0x8,%esp
  800992:	5b                   	pop    %ebx
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a0:	8b 75 10             	mov    0x10(%ebp),%esi
  8009a3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a8:	eb 0f                	jmp    8009b9 <strncpy+0x24>
		*dst++ = *src;
  8009aa:	0f b6 19             	movzbl (%ecx),%ebx
  8009ad:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b0:	80 39 01             	cmpb   $0x1,(%ecx)
  8009b3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b6:	83 c2 01             	add    $0x1,%edx
  8009b9:	39 f2                	cmp    %esi,%edx
  8009bb:	72 ed                	jb     8009aa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	56                   	push   %esi
  8009c5:	53                   	push   %ebx
  8009c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cf:	89 f0                	mov    %esi,%eax
  8009d1:	85 d2                	test   %edx,%edx
  8009d3:	75 0a                	jne    8009df <strlcpy+0x1e>
  8009d5:	eb 17                	jmp    8009ee <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009d7:	88 18                	mov    %bl,(%eax)
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009df:	83 ea 01             	sub    $0x1,%edx
  8009e2:	74 07                	je     8009eb <strlcpy+0x2a>
  8009e4:	0f b6 19             	movzbl (%ecx),%ebx
  8009e7:	84 db                	test   %bl,%bl
  8009e9:	75 ec                	jne    8009d7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8009eb:	c6 00 00             	movb   $0x0,(%eax)
  8009ee:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009f0:	5b                   	pop    %ebx
  8009f1:	5e                   	pop    %esi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009fd:	eb 06                	jmp    800a05 <strcmp+0x11>
		p++, q++;
  8009ff:	83 c1 01             	add    $0x1,%ecx
  800a02:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a05:	0f b6 01             	movzbl (%ecx),%eax
  800a08:	84 c0                	test   %al,%al
  800a0a:	74 04                	je     800a10 <strcmp+0x1c>
  800a0c:	3a 02                	cmp    (%edx),%al
  800a0e:	74 ef                	je     8009ff <strcmp+0xb>
  800a10:	0f b6 c0             	movzbl %al,%eax
  800a13:	0f b6 12             	movzbl (%edx),%edx
  800a16:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	53                   	push   %ebx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a24:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a27:	eb 09                	jmp    800a32 <strncmp+0x18>
		n--, p++, q++;
  800a29:	83 ea 01             	sub    $0x1,%edx
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a32:	85 d2                	test   %edx,%edx
  800a34:	75 07                	jne    800a3d <strncmp+0x23>
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	eb 13                	jmp    800a50 <strncmp+0x36>
  800a3d:	0f b6 18             	movzbl (%eax),%ebx
  800a40:	84 db                	test   %bl,%bl
  800a42:	74 04                	je     800a48 <strncmp+0x2e>
  800a44:	3a 19                	cmp    (%ecx),%bl
  800a46:	74 e1                	je     800a29 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 00             	movzbl (%eax),%eax
  800a4b:	0f b6 11             	movzbl (%ecx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
}
  800a50:	5b                   	pop    %ebx
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5d:	eb 07                	jmp    800a66 <strchr+0x13>
		if (*s == c)
  800a5f:	38 ca                	cmp    %cl,%dl
  800a61:	74 0f                	je     800a72 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a63:	83 c0 01             	add    $0x1,%eax
  800a66:	0f b6 10             	movzbl (%eax),%edx
  800a69:	84 d2                	test   %dl,%dl
  800a6b:	75 f2                	jne    800a5f <strchr+0xc>
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7e:	eb 07                	jmp    800a87 <strfind+0x13>
		if (*s == c)
  800a80:	38 ca                	cmp    %cl,%dl
  800a82:	74 0a                	je     800a8e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	0f b6 10             	movzbl (%eax),%edx
  800a8a:	84 d2                	test   %dl,%dl
  800a8c:	75 f2                	jne    800a80 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 0c             	sub    $0xc,%esp
  800a96:	89 1c 24             	mov    %ebx,(%esp)
  800a99:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a9d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800aa1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aaa:	85 c9                	test   %ecx,%ecx
  800aac:	74 30                	je     800ade <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aae:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ab4:	75 25                	jne    800adb <memset+0x4b>
  800ab6:	f6 c1 03             	test   $0x3,%cl
  800ab9:	75 20                	jne    800adb <memset+0x4b>
		c &= 0xFF;
  800abb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800abe:	89 d3                	mov    %edx,%ebx
  800ac0:	c1 e3 08             	shl    $0x8,%ebx
  800ac3:	89 d6                	mov    %edx,%esi
  800ac5:	c1 e6 18             	shl    $0x18,%esi
  800ac8:	89 d0                	mov    %edx,%eax
  800aca:	c1 e0 10             	shl    $0x10,%eax
  800acd:	09 f0                	or     %esi,%eax
  800acf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ad1:	09 d8                	or     %ebx,%eax
  800ad3:	c1 e9 02             	shr    $0x2,%ecx
  800ad6:	fc                   	cld    
  800ad7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad9:	eb 03                	jmp    800ade <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800adb:	fc                   	cld    
  800adc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ade:	89 f8                	mov    %edi,%eax
  800ae0:	8b 1c 24             	mov    (%esp),%ebx
  800ae3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ae7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800aeb:	89 ec                	mov    %ebp,%esp
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	89 34 24             	mov    %esi,(%esp)
  800af8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800b02:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b05:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b07:	39 c6                	cmp    %eax,%esi
  800b09:	73 35                	jae    800b40 <memmove+0x51>
  800b0b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b0e:	39 d0                	cmp    %edx,%eax
  800b10:	73 2e                	jae    800b40 <memmove+0x51>
		s += n;
		d += n;
  800b12:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b14:	f6 c2 03             	test   $0x3,%dl
  800b17:	75 1b                	jne    800b34 <memmove+0x45>
  800b19:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b1f:	75 13                	jne    800b34 <memmove+0x45>
  800b21:	f6 c1 03             	test   $0x3,%cl
  800b24:	75 0e                	jne    800b34 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b26:	83 ef 04             	sub    $0x4,%edi
  800b29:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b2c:	c1 e9 02             	shr    $0x2,%ecx
  800b2f:	fd                   	std    
  800b30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b32:	eb 09                	jmp    800b3d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b34:	83 ef 01             	sub    $0x1,%edi
  800b37:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b3a:	fd                   	std    
  800b3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b3d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b3e:	eb 20                	jmp    800b60 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b40:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b46:	75 15                	jne    800b5d <memmove+0x6e>
  800b48:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b4e:	75 0d                	jne    800b5d <memmove+0x6e>
  800b50:	f6 c1 03             	test   $0x3,%cl
  800b53:	75 08                	jne    800b5d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b55:	c1 e9 02             	shr    $0x2,%ecx
  800b58:	fc                   	cld    
  800b59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5b:	eb 03                	jmp    800b60 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b5d:	fc                   	cld    
  800b5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b60:	8b 34 24             	mov    (%esp),%esi
  800b63:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b67:	89 ec                	mov    %ebp,%esp
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b71:	8b 45 10             	mov    0x10(%ebp),%eax
  800b74:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	89 04 24             	mov    %eax,(%esp)
  800b85:	e8 65 ff ff ff       	call   800aef <memmove>
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba0:	eb 1c                	jmp    800bbe <memcmp+0x32>
		if (*s1 != *s2)
  800ba2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800ba6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800baa:	83 c2 01             	add    $0x1,%edx
  800bad:	83 e9 01             	sub    $0x1,%ecx
  800bb0:	38 d8                	cmp    %bl,%al
  800bb2:	74 0a                	je     800bbe <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800bb4:	0f b6 c0             	movzbl %al,%eax
  800bb7:	0f b6 db             	movzbl %bl,%ebx
  800bba:	29 d8                	sub    %ebx,%eax
  800bbc:	eb 09                	jmp    800bc7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bbe:	85 c9                	test   %ecx,%ecx
  800bc0:	75 e0                	jne    800ba2 <memcmp+0x16>
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd5:	89 c2                	mov    %eax,%edx
  800bd7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bda:	eb 07                	jmp    800be3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bdc:	38 08                	cmp    %cl,(%eax)
  800bde:	74 07                	je     800be7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800be0:	83 c0 01             	add    $0x1,%eax
  800be3:	39 d0                	cmp    %edx,%eax
  800be5:	72 f5                	jb     800bdc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 04             	sub    $0x4,%esp
  800bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf8:	eb 03                	jmp    800bfd <strtol+0x14>
		s++;
  800bfa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfd:	0f b6 02             	movzbl (%edx),%eax
  800c00:	3c 20                	cmp    $0x20,%al
  800c02:	74 f6                	je     800bfa <strtol+0x11>
  800c04:	3c 09                	cmp    $0x9,%al
  800c06:	74 f2                	je     800bfa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c08:	3c 2b                	cmp    $0x2b,%al
  800c0a:	75 0c                	jne    800c18 <strtol+0x2f>
		s++;
  800c0c:	8d 52 01             	lea    0x1(%edx),%edx
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	eb 15                	jmp    800c2d <strtol+0x44>
	else if (*s == '-')
  800c18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c1f:	3c 2d                	cmp    $0x2d,%al
  800c21:	75 0a                	jne    800c2d <strtol+0x44>
		s++, neg = 1;
  800c23:	8d 52 01             	lea    0x1(%edx),%edx
  800c26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2d:	85 db                	test   %ebx,%ebx
  800c2f:	0f 94 c0             	sete   %al
  800c32:	74 05                	je     800c39 <strtol+0x50>
  800c34:	83 fb 10             	cmp    $0x10,%ebx
  800c37:	75 15                	jne    800c4e <strtol+0x65>
  800c39:	80 3a 30             	cmpb   $0x30,(%edx)
  800c3c:	75 10                	jne    800c4e <strtol+0x65>
  800c3e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c42:	75 0a                	jne    800c4e <strtol+0x65>
		s += 2, base = 16;
  800c44:	83 c2 02             	add    $0x2,%edx
  800c47:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4c:	eb 13                	jmp    800c61 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 0f                	je     800c61 <strtol+0x78>
  800c52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c57:	80 3a 30             	cmpb   $0x30,(%edx)
  800c5a:	75 05                	jne    800c61 <strtol+0x78>
		s++, base = 8;
  800c5c:	83 c2 01             	add    $0x1,%edx
  800c5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
  800c66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c68:	0f b6 0a             	movzbl (%edx),%ecx
  800c6b:	89 cf                	mov    %ecx,%edi
  800c6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c70:	80 fb 09             	cmp    $0x9,%bl
  800c73:	77 08                	ja     800c7d <strtol+0x94>
			dig = *s - '0';
  800c75:	0f be c9             	movsbl %cl,%ecx
  800c78:	83 e9 30             	sub    $0x30,%ecx
  800c7b:	eb 1e                	jmp    800c9b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c80:	80 fb 19             	cmp    $0x19,%bl
  800c83:	77 08                	ja     800c8d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800c85:	0f be c9             	movsbl %cl,%ecx
  800c88:	83 e9 57             	sub    $0x57,%ecx
  800c8b:	eb 0e                	jmp    800c9b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800c8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c90:	80 fb 19             	cmp    $0x19,%bl
  800c93:	77 15                	ja     800caa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c95:	0f be c9             	movsbl %cl,%ecx
  800c98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c9b:	39 f1                	cmp    %esi,%ecx
  800c9d:	7d 0b                	jge    800caa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c9f:	83 c2 01             	add    $0x1,%edx
  800ca2:	0f af c6             	imul   %esi,%eax
  800ca5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ca8:	eb be                	jmp    800c68 <strtol+0x7f>
  800caa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800cac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb0:	74 05                	je     800cb7 <strtol+0xce>
		*endptr = (char *) s;
  800cb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cb5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800cb7:	89 ca                	mov    %ecx,%edx
  800cb9:	f7 da                	neg    %edx
  800cbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cbf:	0f 45 c2             	cmovne %edx,%eax
}
  800cc2:	83 c4 04             	add    $0x4,%esp
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    
	...

00800ccc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 0c             	sub    $0xc,%esp
  800cd2:	89 1c 24             	mov    %ebx,(%esp)
  800cd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce7:	89 d1                	mov    %edx,%ecx
  800ce9:	89 d3                	mov    %edx,%ebx
  800ceb:	89 d7                	mov    %edx,%edi
  800ced:	89 d6                	mov    %edx,%esi
  800cef:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf1:	8b 1c 24             	mov    (%esp),%ebx
  800cf4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cf8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cfc:	89 ec                	mov    %ebp,%esp
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	89 c3                	mov    %eax,%ebx
  800d1e:	89 c7                	mov    %eax,%edi
  800d20:	89 c6                	mov    %eax,%esi
  800d22:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d24:	8b 1c 24             	mov    (%esp),%ebx
  800d27:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d2b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d2f:	89 ec                	mov    %ebp,%esp
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	89 1c 24             	mov    %ebx,(%esp)
  800d3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d40:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d44:	ba 00 00 00 00       	mov    $0x0,%edx
  800d49:	b8 10 00 00 00       	mov    $0x10,%eax
  800d4e:	89 d1                	mov    %edx,%ecx
  800d50:	89 d3                	mov    %edx,%ebx
  800d52:	89 d7                	mov    %edx,%edi
  800d54:	89 d6                	mov    %edx,%esi
  800d56:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d58:	8b 1c 24             	mov    (%esp),%ebx
  800d5b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d5f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d63:	89 ec                	mov    %ebp,%esp
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 38             	sub    $0x38,%esp
  800d6d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d70:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d73:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7e 28                	jle    800db8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d94:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d9b:	00 
  800d9c:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  800da3:	00 
  800da4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dab:	00 
  800dac:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800db3:	e8 74 f4 ff ff       	call   80022c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800db8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dbb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dbe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dc1:	89 ec                	mov    %ebp,%esp
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 38             	sub    $0x38,%esp
  800dcb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dd1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	89 df                	mov    %ebx,%edi
  800de6:	89 de                	mov    %ebx,%esi
  800de8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7e 28                	jle    800e16 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dee:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800df9:	00 
  800dfa:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  800e01:	00 
  800e02:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e09:	00 
  800e0a:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800e11:	e8 16 f4 ff ff       	call   80022c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800e16:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e19:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e1c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e1f:	89 ec                	mov    %ebp,%esp
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 38             	sub    $0x38,%esp
  800e29:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e2c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	89 cb                	mov    %ecx,%ebx
  800e41:	89 cf                	mov    %ecx,%edi
  800e43:	89 ce                	mov    %ecx,%esi
  800e45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7e 28                	jle    800e73 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e56:	00 
  800e57:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e66:	00 
  800e67:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800e6e:	e8 b9 f3 ff ff       	call   80022c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e73:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e76:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e79:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e7c:	89 ec                	mov    %ebp,%esp
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	89 1c 24             	mov    %ebx,(%esp)
  800e89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e91:	be 00 00 00 00       	mov    $0x0,%esi
  800e96:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea9:	8b 1c 24             	mov    (%esp),%ebx
  800eac:	8b 74 24 04          	mov    0x4(%esp),%esi
  800eb0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eb4:	89 ec                	mov    %ebp,%esp
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 38             	sub    $0x38,%esp
  800ebe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	89 df                	mov    %ebx,%edi
  800ed9:	89 de                	mov    %ebx,%esi
  800edb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	7e 28                	jle    800f09 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800eec:	00 
  800eed:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  800ef4:	00 
  800ef5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efc:	00 
  800efd:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800f04:	e8 23 f3 ff ff       	call   80022c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f09:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f0c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f0f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f12:	89 ec                	mov    %ebp,%esp
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 38             	sub    $0x38,%esp
  800f1c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f1f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f22:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	7e 28                	jle    800f67 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f43:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f4a:	00 
  800f4b:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  800f52:	00 
  800f53:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5a:	00 
  800f5b:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800f62:	e8 c5 f2 ff ff       	call   80022c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f67:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f6a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f6d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f70:	89 ec                	mov    %ebp,%esp
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	83 ec 38             	sub    $0x38,%esp
  800f7a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f7d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f80:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	b8 08 00 00 00       	mov    $0x8,%eax
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	89 df                	mov    %ebx,%edi
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7e 28                	jle    800fc5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800fc0:	e8 67 f2 ff ff       	call   80022c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fc5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fcb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fce:	89 ec                	mov    %ebp,%esp
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 38             	sub    $0x38,%esp
  800fd8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fdb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fde:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe6:	b8 06 00 00 00       	mov    $0x6,%eax
  800feb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	89 df                	mov    %ebx,%edi
  800ff3:	89 de                	mov    %ebx,%esi
  800ff5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7e 28                	jle    801023 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fff:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801006:	00 
  801007:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  80101e:	e8 09 f2 ff ff       	call   80022c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801023:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801026:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801029:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102c:	89 ec                	mov    %ebp,%esp
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 38             	sub    $0x38,%esp
  801036:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801039:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80103c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103f:	b8 05 00 00 00       	mov    $0x5,%eax
  801044:	8b 75 18             	mov    0x18(%ebp),%esi
  801047:	8b 7d 14             	mov    0x14(%ebp),%edi
  80104a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80104d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801050:	8b 55 08             	mov    0x8(%ebp),%edx
  801053:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801055:	85 c0                	test   %eax,%eax
  801057:	7e 28                	jle    801081 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801059:	89 44 24 10          	mov    %eax,0x10(%esp)
  80105d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801064:	00 
  801065:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  80106c:	00 
  80106d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801074:	00 
  801075:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  80107c:	e8 ab f1 ff ff       	call   80022c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801081:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801084:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801087:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80108a:	89 ec                	mov    %ebp,%esp
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 38             	sub    $0x38,%esp
  801094:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801097:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80109a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109d:	be 00 00 00 00       	mov    $0x0,%esi
  8010a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8010a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	89 f7                	mov    %esi,%edi
  8010b2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	7e 28                	jle    8010e0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010bc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010c3:	00 
  8010c4:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d3:	00 
  8010d4:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  8010db:	e8 4c f1 ff ff       	call   80022c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e9:	89 ec                	mov    %ebp,%esp
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	89 1c 24             	mov    %ebx,(%esp)
  8010f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010fa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801103:	b8 0b 00 00 00       	mov    $0xb,%eax
  801108:	89 d1                	mov    %edx,%ecx
  80110a:	89 d3                	mov    %edx,%ebx
  80110c:	89 d7                	mov    %edx,%edi
  80110e:	89 d6                	mov    %edx,%esi
  801110:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801112:	8b 1c 24             	mov    (%esp),%ebx
  801115:	8b 74 24 04          	mov    0x4(%esp),%esi
  801119:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80111d:	89 ec                	mov    %ebp,%esp
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	89 1c 24             	mov    %ebx,(%esp)
  80112a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80112e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	b8 02 00 00 00       	mov    $0x2,%eax
  80113c:	89 d1                	mov    %edx,%ecx
  80113e:	89 d3                	mov    %edx,%ebx
  801140:	89 d7                	mov    %edx,%edi
  801142:	89 d6                	mov    %edx,%esi
  801144:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801146:	8b 1c 24             	mov    (%esp),%ebx
  801149:	8b 74 24 04          	mov    0x4(%esp),%esi
  80114d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801151:	89 ec                	mov    %ebp,%esp
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    

00801155 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 38             	sub    $0x38,%esp
  80115b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80115e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801161:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801164:	b9 00 00 00 00       	mov    $0x0,%ecx
  801169:	b8 03 00 00 00       	mov    $0x3,%eax
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	89 cb                	mov    %ecx,%ebx
  801173:	89 cf                	mov    %ecx,%edi
  801175:	89 ce                	mov    %ecx,%esi
  801177:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801179:	85 c0                	test   %eax,%eax
  80117b:	7e 28                	jle    8011a5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80117d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801181:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801188:	00 
  801189:	c7 44 24 08 e7 2d 80 	movl   $0x802de7,0x8(%esp)
  801190:	00 
  801191:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801198:	00 
  801199:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  8011a0:	e8 87 f0 ff ff       	call   80022c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011a5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ae:	89 ec                	mov    %ebp,%esp
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    
	...

008011b4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	05 00 00 00 30       	add    $0x30000000,%eax
  8011bf:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	89 04 24             	mov    %eax,(%esp)
  8011d0:	e8 df ff ff ff       	call   8011b4 <fd2num>
  8011d5:	05 20 00 0d 00       	add    $0xd0020,%eax
  8011da:	c1 e0 0c             	shl    $0xc,%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	57                   	push   %edi
  8011e3:	56                   	push   %esi
  8011e4:	53                   	push   %ebx
  8011e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011e8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ed:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8011f2:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f7:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011f9:	89 c2                	mov    %eax,%edx
  8011fb:	c1 ea 16             	shr    $0x16,%edx
  8011fe:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801201:	f6 c2 01             	test   $0x1,%dl
  801204:	74 0d                	je     801213 <fd_alloc+0x34>
  801206:	89 c2                	mov    %eax,%edx
  801208:	c1 ea 0c             	shr    $0xc,%edx
  80120b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	75 09                	jne    80121c <fd_alloc+0x3d>
			*fd_store = fd;
  801213:	89 37                	mov    %esi,(%edi)
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80121a:	eb 17                	jmp    801233 <fd_alloc+0x54>
  80121c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801221:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801226:	75 cf                	jne    8011f7 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801228:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  80122e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	83 f8 1f             	cmp    $0x1f,%eax
  801241:	77 36                	ja     801279 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801243:	05 00 00 0d 00       	add    $0xd0000,%eax
  801248:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80124b:	89 c2                	mov    %eax,%edx
  80124d:	c1 ea 16             	shr    $0x16,%edx
  801250:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801257:	f6 c2 01             	test   $0x1,%dl
  80125a:	74 1d                	je     801279 <fd_lookup+0x41>
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	c1 ea 0c             	shr    $0xc,%edx
  801261:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801268:	f6 c2 01             	test   $0x1,%dl
  80126b:	74 0c                	je     801279 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80126d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801270:	89 02                	mov    %eax,(%edx)
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801277:	eb 05                	jmp    80127e <fd_lookup+0x46>
  801279:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801286:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	89 04 24             	mov    %eax,(%esp)
  801293:	e8 a0 ff ff ff       	call   801238 <fd_lookup>
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 0e                	js     8012aa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80129c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a2:	89 50 04             	mov    %edx,0x4(%eax)
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
  8012b1:	83 ec 10             	sub    $0x10,%esp
  8012b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012ba:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012bf:	be 94 2e 80 00       	mov    $0x802e94,%esi
  8012c4:	eb 10                	jmp    8012d6 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8012c6:	39 08                	cmp    %ecx,(%eax)
  8012c8:	75 09                	jne    8012d3 <dev_lookup+0x27>
			*dev = devtab[i];
  8012ca:	89 03                	mov    %eax,(%ebx)
  8012cc:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012d1:	eb 31                	jmp    801304 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012d3:	83 c2 01             	add    $0x1,%edx
  8012d6:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 e9                	jne    8012c6 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012dd:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012e2:	8b 40 48             	mov    0x48(%eax),%eax
  8012e5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ed:	c7 04 24 14 2e 80 00 	movl   $0x802e14,(%esp)
  8012f4:	e8 ec ef ff ff       	call   8002e5 <cprintf>
	*dev = 0;
  8012f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8012ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	53                   	push   %ebx
  80130f:	83 ec 24             	sub    $0x24,%esp
  801312:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801315:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 04 24             	mov    %eax,(%esp)
  801322:	e8 11 ff ff ff       	call   801238 <fd_lookup>
  801327:	85 c0                	test   %eax,%eax
  801329:	78 53                	js     80137e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801335:	8b 00                	mov    (%eax),%eax
  801337:	89 04 24             	mov    %eax,(%esp)
  80133a:	e8 6d ff ff ff       	call   8012ac <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 3b                	js     80137e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801343:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801348:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80134f:	74 2d                	je     80137e <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801351:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801354:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80135b:	00 00 00 
	stat->st_isdir = 0;
  80135e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801365:	00 00 00 
	stat->st_dev = dev;
  801368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801371:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801375:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801378:	89 14 24             	mov    %edx,(%esp)
  80137b:	ff 50 14             	call   *0x14(%eax)
}
  80137e:	83 c4 24             	add    $0x24,%esp
  801381:	5b                   	pop    %ebx
  801382:	5d                   	pop    %ebp
  801383:	c3                   	ret    

00801384 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	53                   	push   %ebx
  801388:	83 ec 24             	sub    $0x24,%esp
  80138b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801391:	89 44 24 04          	mov    %eax,0x4(%esp)
  801395:	89 1c 24             	mov    %ebx,(%esp)
  801398:	e8 9b fe ff ff       	call   801238 <fd_lookup>
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 5f                	js     801400 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ab:	8b 00                	mov    (%eax),%eax
  8013ad:	89 04 24             	mov    %eax,(%esp)
  8013b0:	e8 f7 fe ff ff       	call   8012ac <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 47                	js     801400 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bc:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8013c0:	75 23                	jne    8013e5 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8013c2:	a1 0c 40 80 00       	mov    0x80400c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013c7:	8b 40 48             	mov    0x48(%eax),%eax
  8013ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d2:	c7 04 24 34 2e 80 00 	movl   $0x802e34,(%esp)
  8013d9:	e8 07 ef ff ff       	call   8002e5 <cprintf>
  8013de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8013e3:	eb 1b                	jmp    801400 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e8:	8b 48 18             	mov    0x18(%eax),%ecx
  8013eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f0:	85 c9                	test   %ecx,%ecx
  8013f2:	74 0c                	je     801400 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fb:	89 14 24             	mov    %edx,(%esp)
  8013fe:	ff d1                	call   *%ecx
}
  801400:	83 c4 24             	add    $0x24,%esp
  801403:	5b                   	pop    %ebx
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	53                   	push   %ebx
  80140a:	83 ec 24             	sub    $0x24,%esp
  80140d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801410:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801413:	89 44 24 04          	mov    %eax,0x4(%esp)
  801417:	89 1c 24             	mov    %ebx,(%esp)
  80141a:	e8 19 fe ff ff       	call   801238 <fd_lookup>
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 66                	js     801489 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801423:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801426:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	89 04 24             	mov    %eax,(%esp)
  801432:	e8 75 fe ff ff       	call   8012ac <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801437:	85 c0                	test   %eax,%eax
  801439:	78 4e                	js     801489 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80143b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801442:	75 23                	jne    801467 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801444:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801449:	8b 40 48             	mov    0x48(%eax),%eax
  80144c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801450:	89 44 24 04          	mov    %eax,0x4(%esp)
  801454:	c7 04 24 58 2e 80 00 	movl   $0x802e58,(%esp)
  80145b:	e8 85 ee ff ff       	call   8002e5 <cprintf>
  801460:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801465:	eb 22                	jmp    801489 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80146d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801472:	85 c9                	test   %ecx,%ecx
  801474:	74 13                	je     801489 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801476:	8b 45 10             	mov    0x10(%ebp),%eax
  801479:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	89 44 24 04          	mov    %eax,0x4(%esp)
  801484:	89 14 24             	mov    %edx,(%esp)
  801487:	ff d1                	call   *%ecx
}
  801489:	83 c4 24             	add    $0x24,%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	53                   	push   %ebx
  801493:	83 ec 24             	sub    $0x24,%esp
  801496:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801499:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a0:	89 1c 24             	mov    %ebx,(%esp)
  8014a3:	e8 90 fd ff ff       	call   801238 <fd_lookup>
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 6b                	js     801517 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	8b 00                	mov    (%eax),%eax
  8014b8:	89 04 24             	mov    %eax,(%esp)
  8014bb:	e8 ec fd ff ff       	call   8012ac <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 53                	js     801517 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c7:	8b 42 08             	mov    0x8(%edx),%eax
  8014ca:	83 e0 03             	and    $0x3,%eax
  8014cd:	83 f8 01             	cmp    $0x1,%eax
  8014d0:	75 23                	jne    8014f5 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014d7:	8b 40 48             	mov    0x48(%eax),%eax
  8014da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e2:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  8014e9:	e8 f7 ed ff ff       	call   8002e5 <cprintf>
  8014ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014f3:	eb 22                	jmp    801517 <read+0x88>
	}
	if (!dev->dev_read)
  8014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f8:	8b 48 08             	mov    0x8(%eax),%ecx
  8014fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801500:	85 c9                	test   %ecx,%ecx
  801502:	74 13                	je     801517 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	89 44 24 08          	mov    %eax,0x8(%esp)
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801512:	89 14 24             	mov    %edx,(%esp)
  801515:	ff d1                	call   *%ecx
}
  801517:	83 c4 24             	add    $0x24,%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	57                   	push   %edi
  801521:	56                   	push   %esi
  801522:	53                   	push   %ebx
  801523:	83 ec 1c             	sub    $0x1c,%esp
  801526:	8b 7d 08             	mov    0x8(%ebp),%edi
  801529:	8b 75 10             	mov    0x10(%ebp),%esi
  80152c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801531:	eb 21                	jmp    801554 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801533:	89 f2                	mov    %esi,%edx
  801535:	29 c2                	sub    %eax,%edx
  801537:	89 54 24 08          	mov    %edx,0x8(%esp)
  80153b:	03 45 0c             	add    0xc(%ebp),%eax
  80153e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801542:	89 3c 24             	mov    %edi,(%esp)
  801545:	e8 45 ff ff ff       	call   80148f <read>
		if (m < 0)
  80154a:	85 c0                	test   %eax,%eax
  80154c:	78 0e                	js     80155c <readn+0x3f>
			return m;
		if (m == 0)
  80154e:	85 c0                	test   %eax,%eax
  801550:	74 08                	je     80155a <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801552:	01 c3                	add    %eax,%ebx
  801554:	89 d8                	mov    %ebx,%eax
  801556:	39 f3                	cmp    %esi,%ebx
  801558:	72 d9                	jb     801533 <readn+0x16>
  80155a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80155c:	83 c4 1c             	add    $0x1c,%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5f                   	pop    %edi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 38             	sub    $0x38,%esp
  80156a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80156d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801570:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801573:	8b 7d 08             	mov    0x8(%ebp),%edi
  801576:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80157a:	89 3c 24             	mov    %edi,(%esp)
  80157d:	e8 32 fc ff ff       	call   8011b4 <fd2num>
  801582:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801585:	89 54 24 04          	mov    %edx,0x4(%esp)
  801589:	89 04 24             	mov    %eax,(%esp)
  80158c:	e8 a7 fc ff ff       	call   801238 <fd_lookup>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	85 c0                	test   %eax,%eax
  801595:	78 05                	js     80159c <fd_close+0x38>
  801597:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  80159a:	74 0e                	je     8015aa <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80159c:	89 f0                	mov    %esi,%eax
  80159e:	84 c0                	test   %al,%al
  8015a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a5:	0f 44 d8             	cmove  %eax,%ebx
  8015a8:	eb 3d                	jmp    8015e7 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	8b 07                	mov    (%edi),%eax
  8015b3:	89 04 24             	mov    %eax,(%esp)
  8015b6:	e8 f1 fc ff ff       	call   8012ac <dev_lookup>
  8015bb:	89 c3                	mov    %eax,%ebx
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 16                	js     8015d7 <fd_close+0x73>
		if (dev->dev_close)
  8015c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c4:	8b 40 10             	mov    0x10(%eax),%eax
  8015c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	74 07                	je     8015d7 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8015d0:	89 3c 24             	mov    %edi,(%esp)
  8015d3:	ff d0                	call   *%eax
  8015d5:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e2:	e8 eb f9 ff ff       	call   800fd2 <sys_page_unmap>
	return r;
}
  8015e7:	89 d8                	mov    %ebx,%eax
  8015e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015ec:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015ef:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015f2:	89 ec                	mov    %ebp,%esp
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 04 24             	mov    %eax,(%esp)
  801609:	e8 2a fc ff ff       	call   801238 <fd_lookup>
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 13                	js     801625 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801612:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801619:	00 
  80161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161d:	89 04 24             	mov    %eax,(%esp)
  801620:	e8 3f ff ff ff       	call   801564 <fd_close>
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 18             	sub    $0x18,%esp
  80162d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801630:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801633:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80163a:	00 
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	89 04 24             	mov    %eax,(%esp)
  801641:	e8 25 04 00 00       	call   801a6b <open>
  801646:	89 c3                	mov    %eax,%ebx
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 1b                	js     801667 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801653:	89 1c 24             	mov    %ebx,(%esp)
  801656:	e8 b0 fc ff ff       	call   80130b <fstat>
  80165b:	89 c6                	mov    %eax,%esi
	close(fd);
  80165d:	89 1c 24             	mov    %ebx,(%esp)
  801660:	e8 91 ff ff ff       	call   8015f6 <close>
  801665:	89 f3                	mov    %esi,%ebx
	return r;
}
  801667:	89 d8                	mov    %ebx,%eax
  801669:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80166c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80166f:	89 ec                	mov    %ebp,%esp
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
  801677:	83 ec 14             	sub    $0x14,%esp
  80167a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  80167f:	89 1c 24             	mov    %ebx,(%esp)
  801682:	e8 6f ff ff ff       	call   8015f6 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801687:	83 c3 01             	add    $0x1,%ebx
  80168a:	83 fb 20             	cmp    $0x20,%ebx
  80168d:	75 f0                	jne    80167f <close_all+0xc>
		close(i);
}
  80168f:	83 c4 14             	add    $0x14,%esp
  801692:	5b                   	pop    %ebx
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    

00801695 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 58             	sub    $0x58,%esp
  80169b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80169e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	89 04 24             	mov    %eax,(%esp)
  8016b4:	e8 7f fb ff ff       	call   801238 <fd_lookup>
  8016b9:	89 c3                	mov    %eax,%ebx
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	0f 88 e0 00 00 00    	js     8017a3 <dup+0x10e>
		return r;
	close(newfdnum);
  8016c3:	89 3c 24             	mov    %edi,(%esp)
  8016c6:	e8 2b ff ff ff       	call   8015f6 <close>

	newfd = INDEX2FD(newfdnum);
  8016cb:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8016d1:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8016d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d7:	89 04 24             	mov    %eax,(%esp)
  8016da:	e8 e5 fa ff ff       	call   8011c4 <fd2data>
  8016df:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016e1:	89 34 24             	mov    %esi,(%esp)
  8016e4:	e8 db fa ff ff       	call   8011c4 <fd2data>
  8016e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ec:	89 da                	mov    %ebx,%edx
  8016ee:	89 d8                	mov    %ebx,%eax
  8016f0:	c1 e8 16             	shr    $0x16,%eax
  8016f3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016fa:	a8 01                	test   $0x1,%al
  8016fc:	74 43                	je     801741 <dup+0xac>
  8016fe:	c1 ea 0c             	shr    $0xc,%edx
  801701:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801708:	a8 01                	test   $0x1,%al
  80170a:	74 35                	je     801741 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80170c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801713:	25 07 0e 00 00       	and    $0xe07,%eax
  801718:	89 44 24 10          	mov    %eax,0x10(%esp)
  80171c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80171f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801723:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80172a:	00 
  80172b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80172f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801736:	e8 f5 f8 ff ff       	call   801030 <sys_page_map>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 3f                	js     801780 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801744:	89 c2                	mov    %eax,%edx
  801746:	c1 ea 0c             	shr    $0xc,%edx
  801749:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801750:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801756:	89 54 24 10          	mov    %edx,0x10(%esp)
  80175a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80175e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801765:	00 
  801766:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801771:	e8 ba f8 ff ff       	call   801030 <sys_page_map>
  801776:	89 c3                	mov    %eax,%ebx
  801778:	85 c0                	test   %eax,%eax
  80177a:	78 04                	js     801780 <dup+0xeb>
  80177c:	89 fb                	mov    %edi,%ebx
  80177e:	eb 23                	jmp    8017a3 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801780:	89 74 24 04          	mov    %esi,0x4(%esp)
  801784:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178b:	e8 42 f8 ff ff       	call   800fd2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801790:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801793:	89 44 24 04          	mov    %eax,0x4(%esp)
  801797:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179e:	e8 2f f8 ff ff       	call   800fd2 <sys_page_unmap>
	return r;
}
  8017a3:	89 d8                	mov    %ebx,%eax
  8017a5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017ae:	89 ec                	mov    %ebp,%esp
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    
	...

008017b4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 10             	sub    $0x10,%esp
  8017bc:	89 c3                	mov    %eax,%ebx
  8017be:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8017c0:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8017c7:	75 11                	jne    8017da <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8017d0:	e8 af 0e 00 00       	call   802684 <ipc_find_env>
  8017d5:	a3 04 40 80 00       	mov    %eax,0x804004

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8017da:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8017df:	8b 40 48             	mov    0x48(%eax),%eax
  8017e2:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8017e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f4:	c7 04 24 a8 2e 80 00 	movl   $0x802ea8,(%esp)
  8017fb:	e8 e5 ea ff ff       	call   8002e5 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801800:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801807:	00 
  801808:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80180f:	00 
  801810:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801814:	a1 04 40 80 00       	mov    0x804004,%eax
  801819:	89 04 24             	mov    %eax,(%esp)
  80181c:	e8 99 0e 00 00       	call   8026ba <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801821:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801828:	00 
  801829:	89 74 24 04          	mov    %esi,0x4(%esp)
  80182d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801834:	e8 ed 0e 00 00       	call   802726 <ipc_recv>
}
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	5b                   	pop    %ebx
  80183d:	5e                   	pop    %esi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8b 40 0c             	mov    0xc(%eax),%eax
  80184c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801859:	ba 00 00 00 00       	mov    $0x0,%edx
  80185e:	b8 02 00 00 00       	mov    $0x2,%eax
  801863:	e8 4c ff ff ff       	call   8017b4 <fsipc>
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	8b 40 0c             	mov    0xc(%eax),%eax
  801876:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80187b:	ba 00 00 00 00       	mov    $0x0,%edx
  801880:	b8 06 00 00 00       	mov    $0x6,%eax
  801885:	e8 2a ff ff ff       	call   8017b4 <fsipc>
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801892:	ba 00 00 00 00       	mov    $0x0,%edx
  801897:	b8 08 00 00 00       	mov    $0x8,%eax
  80189c:	e8 13 ff ff ff       	call   8017b4 <fsipc>
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 14             	sub    $0x14,%esp
  8018aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8018c2:	e8 ed fe ff ff       	call   8017b4 <fsipc>
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 2b                	js     8018f6 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018cb:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018d2:	00 
  8018d3:	89 1c 24             	mov    %ebx,(%esp)
  8018d6:	e8 6e f0 ff ff       	call   800949 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018db:	a1 80 50 80 00       	mov    0x805080,%eax
  8018e0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018e6:	a1 84 50 80 00       	mov    0x805084,%eax
  8018eb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8018f6:	83 c4 14             	add    $0x14,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	53                   	push   %ebx
  801900:	83 ec 14             	sub    $0x14,%esp
  801903:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8b 40 0c             	mov    0xc(%eax),%eax
  80190c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801911:	89 1d 04 50 80 00    	mov    %ebx,0x805004

	assert(n<=PGSIZE);
  801917:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80191d:	76 24                	jbe    801943 <devfile_write+0x47>
  80191f:	c7 44 24 0c be 2e 80 	movl   $0x802ebe,0xc(%esp)
  801926:	00 
  801927:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  80192e:	00 
  80192f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801936:	00 
  801937:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  80193e:	e8 e9 e8 ff ff       	call   80022c <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801943:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194e:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801955:	e8 95 f1 ff ff       	call   800aef <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  80195a:	ba 00 00 00 00       	mov    $0x0,%edx
  80195f:	b8 04 00 00 00       	mov    $0x4,%eax
  801964:	e8 4b fe ff ff       	call   8017b4 <fsipc>
	if(ret<0) return ret;
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 53                	js     8019c0 <devfile_write+0xc4>
	
	assert(ret <= n);
  80196d:	39 c3                	cmp    %eax,%ebx
  80196f:	73 24                	jae    801995 <devfile_write+0x99>
  801971:	c7 44 24 0c e8 2e 80 	movl   $0x802ee8,0xc(%esp)
  801978:	00 
  801979:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  801980:	00 
  801981:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801988:	00 
  801989:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  801990:	e8 97 e8 ff ff       	call   80022c <_panic>
	assert(ret <= PGSIZE);
  801995:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80199a:	7e 24                	jle    8019c0 <devfile_write+0xc4>
  80199c:	c7 44 24 0c f1 2e 80 	movl   $0x802ef1,0xc(%esp)
  8019a3:	00 
  8019a4:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  8019ab:	00 
  8019ac:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8019b3:	00 
  8019b4:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  8019bb:	e8 6c e8 ff ff       	call   80022c <_panic>
	return ret;
}
  8019c0:	83 c4 14             	add    $0x14,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	56                   	push   %esi
  8019ca:	53                   	push   %ebx
  8019cb:	83 ec 10             	sub    $0x10,%esp
  8019ce:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019dc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ec:	e8 c3 fd ff ff       	call   8017b4 <fsipc>
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 6b                	js     801a62 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  8019f7:	39 de                	cmp    %ebx,%esi
  8019f9:	73 24                	jae    801a1f <devfile_read+0x59>
  8019fb:	c7 44 24 0c ff 2e 80 	movl   $0x802eff,0xc(%esp)
  801a02:	00 
  801a03:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  801a0a:	00 
  801a0b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a12:	00 
  801a13:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  801a1a:	e8 0d e8 ff ff       	call   80022c <_panic>
	assert(r <= PGSIZE);
  801a1f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801a25:	7e 24                	jle    801a4b <devfile_read+0x85>
  801a27:	c7 44 24 0c 06 2f 80 	movl   $0x802f06,0xc(%esp)
  801a2e:	00 
  801a2f:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  801a36:	00 
  801a37:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801a3e:	00 
  801a3f:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  801a46:	e8 e1 e7 ff ff       	call   80022c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a56:	00 
  801a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5a:	89 04 24             	mov    %eax,(%esp)
  801a5d:	e8 8d f0 ff ff       	call   800aef <memmove>
	return r;
}
  801a62:	89 d8                	mov    %ebx,%eax
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 28             	sub    $0x28,%esp
  801a71:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a74:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a77:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a7a:	89 34 24             	mov    %esi,(%esp)
  801a7d:	e8 8e ee ff ff       	call   800910 <strlen>
  801a82:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a87:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a8c:	7f 5e                	jg     801aec <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a91:	89 04 24             	mov    %eax,(%esp)
  801a94:	e8 46 f7 ff ff       	call   8011df <fd_alloc>
  801a99:	89 c3                	mov    %eax,%ebx
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 4d                	js     801aec <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aa3:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801aaa:	e8 9a ee ff ff       	call   800949 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab2:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aba:	b8 01 00 00 00       	mov    $0x1,%eax
  801abf:	e8 f0 fc ff ff       	call   8017b4 <fsipc>
  801ac4:	89 c3                	mov    %eax,%ebx
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	79 15                	jns    801adf <open+0x74>
		fd_close(fd, 0);
  801aca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ad1:	00 
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	89 04 24             	mov    %eax,(%esp)
  801ad8:	e8 87 fa ff ff       	call   801564 <fd_close>
		return r;
  801add:	eb 0d                	jmp    801aec <open+0x81>
	}

	return fd2num(fd);
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	89 04 24             	mov    %eax,(%esp)
  801ae5:	e8 ca f6 ff ff       	call   8011b4 <fd2num>
  801aea:	89 c3                	mov    %eax,%ebx
}
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801af1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801af4:	89 ec                	mov    %ebp,%esp
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    

00801af8 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	53                   	push   %ebx
  801afc:	83 ec 14             	sub    $0x14,%esp
  801aff:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b01:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b05:	7e 31                	jle    801b38 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b07:	8b 40 04             	mov    0x4(%eax),%eax
  801b0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0e:	8d 43 10             	lea    0x10(%ebx),%eax
  801b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b15:	8b 03                	mov    (%ebx),%eax
  801b17:	89 04 24             	mov    %eax,(%esp)
  801b1a:	e8 e7 f8 ff ff       	call   801406 <write>
		if (result > 0)
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	7e 03                	jle    801b26 <writebuf+0x2e>
			b->result += result;
  801b23:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b26:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b29:	74 0d                	je     801b38 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b32:	0f 4f c2             	cmovg  %edx,%eax
  801b35:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b38:	83 c4 14             	add    $0x14,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b50:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b57:	00 00 00 
	b.result = 0;
  801b5a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b61:	00 00 00 
	b.error = 1;
  801b64:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b6b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b7c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b86:	c7 04 24 fa 1b 80 00 	movl   $0x801bfa,(%esp)
  801b8d:	e8 f1 e8 ff ff       	call   800483 <vprintfmt>
	if (b.idx > 0)
  801b92:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b99:	7e 0b                	jle    801ba6 <vfprintf+0x68>
		writebuf(&b);
  801b9b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ba1:	e8 52 ff ff ff       	call   801af8 <writebuf>

	return (b.result ? b.result : b.error);
  801ba6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801bac:	85 c0                	test   %eax,%eax
  801bae:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801bbd:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801bc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bd2:	e8 67 ff ff ff       	call   801b3e <vfprintf>
	va_end(ap);

	return cnt;
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801bdf:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801be2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	89 04 24             	mov    %eax,(%esp)
  801bf3:	e8 46 ff ff ff       	call   801b3e <vfprintf>
	va_end(ap);

	return cnt;
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c04:	8b 43 04             	mov    0x4(%ebx),%eax
  801c07:	8b 55 08             	mov    0x8(%ebp),%edx
  801c0a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c0e:	83 c0 01             	add    $0x1,%eax
  801c11:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c14:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c19:	75 0e                	jne    801c29 <putch+0x2f>
		writebuf(b);
  801c1b:	89 d8                	mov    %ebx,%eax
  801c1d:	e8 d6 fe ff ff       	call   801af8 <writebuf>
		b->idx = 0;
  801c22:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c29:	83 c4 04             	add    $0x4,%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5d                   	pop    %ebp
  801c2e:	c3                   	ret    
	...

00801c30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c36:	c7 44 24 04 12 2f 80 	movl   $0x802f12,0x4(%esp)
  801c3d:	00 
  801c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c41:	89 04 24             	mov    %eax,(%esp)
  801c44:	e8 00 ed ff ff       	call   800949 <strcpy>
	return 0;
}
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	83 ec 14             	sub    $0x14,%esp
  801c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c5a:	89 1c 24             	mov    %ebx,(%esp)
  801c5d:	e8 4e 0b 00 00       	call   8027b0 <pageref>
  801c62:	89 c2                	mov    %eax,%edx
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
  801c69:	83 fa 01             	cmp    $0x1,%edx
  801c6c:	75 0b                	jne    801c79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c6e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c71:	89 04 24             	mov    %eax,(%esp)
  801c74:	e8 b1 02 00 00       	call   801f2a <nsipc_close>
	else
		return 0;
}
  801c79:	83 c4 14             	add    $0x14,%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5d                   	pop    %ebp
  801c7e:	c3                   	ret    

00801c7f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c85:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c8c:	00 
  801c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca1:	89 04 24             	mov    %eax,(%esp)
  801ca4:	e8 bd 02 00 00       	call   801f66 <nsipc_send>
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cb1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cb8:	00 
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccd:	89 04 24             	mov    %eax,(%esp)
  801cd0:	e8 04 03 00 00       	call   801fd9 <nsipc_recv>
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	83 ec 20             	sub    $0x20,%esp
  801cdf:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce4:	89 04 24             	mov    %eax,(%esp)
  801ce7:	e8 f3 f4 ff ff       	call   8011df <fd_alloc>
  801cec:	89 c3                	mov    %eax,%ebx
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 21                	js     801d13 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cf2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cf9:	00 
  801cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d08:	e8 81 f3 ff ff       	call   80108e <sys_page_alloc>
  801d0d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	79 0a                	jns    801d1d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801d13:	89 34 24             	mov    %esi,(%esp)
  801d16:	e8 0f 02 00 00       	call   801f2a <nsipc_close>
		return r;
  801d1b:	eb 28                	jmp    801d45 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d1d:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	89 04 24             	mov    %eax,(%esp)
  801d3e:	e8 71 f4 ff ff       	call   8011b4 <fd2num>
  801d43:	89 c3                	mov    %eax,%ebx
}
  801d45:	89 d8                	mov    %ebx,%eax
  801d47:	83 c4 20             	add    $0x20,%esp
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	89 04 24             	mov    %eax,(%esp)
  801d68:	e8 71 01 00 00       	call   801ede <nsipc_socket>
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 05                	js     801d76 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801d71:	e8 61 ff ff ff       	call   801cd7 <alloc_sockfd>
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d7e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d85:	89 04 24             	mov    %eax,(%esp)
  801d88:	e8 ab f4 ff ff       	call   801238 <fd_lookup>
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	78 15                	js     801da6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d94:	8b 0a                	mov    (%edx),%ecx
  801d96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d9b:	3b 0d 24 30 80 00    	cmp    0x803024,%ecx
  801da1:	75 03                	jne    801da6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801da3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	e8 c2 ff ff ff       	call   801d78 <fd2sockid>
  801db6:	85 c0                	test   %eax,%eax
  801db8:	78 0f                	js     801dc9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dc1:	89 04 24             	mov    %eax,(%esp)
  801dc4:	e8 3f 01 00 00       	call   801f08 <nsipc_listen>
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	e8 9f ff ff ff       	call   801d78 <fd2sockid>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	78 16                	js     801df3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801ddd:	8b 55 10             	mov    0x10(%ebp),%edx
  801de0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801deb:	89 04 24             	mov    %eax,(%esp)
  801dee:	e8 66 02 00 00       	call   802059 <nsipc_connect>
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	e8 75 ff ff ff       	call   801d78 <fd2sockid>
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 0f                	js     801e16 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 2e 01 00 00       	call   801f44 <nsipc_shutdown>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	e8 52 ff ff ff       	call   801d78 <fd2sockid>
  801e26:	85 c0                	test   %eax,%eax
  801e28:	78 16                	js     801e40 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801e2a:	8b 55 10             	mov    0x10(%ebp),%edx
  801e2d:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e38:	89 04 24             	mov    %eax,(%esp)
  801e3b:	e8 58 02 00 00       	call   802098 <nsipc_bind>
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	e8 28 ff ff ff       	call   801d78 <fd2sockid>
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 1f                	js     801e73 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e54:	8b 55 10             	mov    0x10(%ebp),%edx
  801e57:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e62:	89 04 24             	mov    %eax,(%esp)
  801e65:	e8 6d 02 00 00       	call   8020d7 <nsipc_accept>
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	78 05                	js     801e73 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801e6e:	e8 64 fe ff ff       	call   801cd7 <alloc_sockfd>
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    
  801e75:	00 00                	add    %al,(%eax)
	...

00801e78 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 14             	sub    $0x14,%esp
  801e7f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e81:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801e88:	75 11                	jne    801e9b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e8a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e91:	e8 ee 07 00 00       	call   802684 <ipc_find_env>
  801e96:	a3 08 40 80 00       	mov    %eax,0x804008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e9b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ea2:	00 
  801ea3:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801eaa:	00 
  801eab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eaf:	a1 08 40 80 00       	mov    0x804008,%eax
  801eb4:	89 04 24             	mov    %eax,(%esp)
  801eb7:	e8 fe 07 00 00       	call   8026ba <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ebc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ec3:	00 
  801ec4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ecb:	00 
  801ecc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed3:	e8 4e 08 00 00       	call   802726 <ipc_recv>
}
  801ed8:	83 c4 14             	add    $0x14,%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    

00801ede <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801efc:	b8 09 00 00 00       	mov    $0x9,%eax
  801f01:	e8 72 ff ff ff       	call   801e78 <nsipc>
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f19:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f1e:	b8 06 00 00 00       	mov    $0x6,%eax
  801f23:	e8 50 ff ff ff       	call   801e78 <nsipc>
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f38:	b8 04 00 00 00       	mov    $0x4,%eax
  801f3d:	e8 36 ff ff ff       	call   801e78 <nsipc>
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f55:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f5a:	b8 03 00 00 00       	mov    $0x3,%eax
  801f5f:	e8 14 ff ff ff       	call   801e78 <nsipc>
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	53                   	push   %ebx
  801f6a:	83 ec 14             	sub    $0x14,%esp
  801f6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801f78:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f7e:	7e 24                	jle    801fa4 <nsipc_send+0x3e>
  801f80:	c7 44 24 0c 1e 2f 80 	movl   $0x802f1e,0xc(%esp)
  801f87:	00 
  801f88:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  801f8f:	00 
  801f90:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  801f97:	00 
  801f98:	c7 04 24 2a 2f 80 00 	movl   $0x802f2a,(%esp)
  801f9f:	e8 88 e2 ff ff       	call   80022c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fa4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faf:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  801fb6:	e8 34 eb ff ff       	call   800aef <memmove>
	nsipcbuf.send.req_size = size;
  801fbb:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801fc9:	b8 08 00 00 00       	mov    $0x8,%eax
  801fce:	e8 a5 fe ff ff       	call   801e78 <nsipc>
}
  801fd3:	83 c4 14             	add    $0x14,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    

00801fd9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 10             	sub    $0x10,%esp
  801fe1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801fec:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff5:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ffa:	b8 07 00 00 00       	mov    $0x7,%eax
  801fff:	e8 74 fe ff ff       	call   801e78 <nsipc>
  802004:	89 c3                	mov    %eax,%ebx
  802006:	85 c0                	test   %eax,%eax
  802008:	78 46                	js     802050 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80200a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80200f:	7f 04                	jg     802015 <nsipc_recv+0x3c>
  802011:	39 c6                	cmp    %eax,%esi
  802013:	7d 24                	jge    802039 <nsipc_recv+0x60>
  802015:	c7 44 24 0c 36 2f 80 	movl   $0x802f36,0xc(%esp)
  80201c:	00 
  80201d:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  802024:	00 
  802025:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80202c:	00 
  80202d:	c7 04 24 2a 2f 80 00 	movl   $0x802f2a,(%esp)
  802034:	e8 f3 e1 ff ff       	call   80022c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802039:	89 44 24 08          	mov    %eax,0x8(%esp)
  80203d:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802044:	00 
  802045:	8b 45 0c             	mov    0xc(%ebp),%eax
  802048:	89 04 24             	mov    %eax,(%esp)
  80204b:	e8 9f ea ff ff       	call   800aef <memmove>
	}

	return r;
}
  802050:	89 d8                	mov    %ebx,%eax
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	5b                   	pop    %ebx
  802056:	5e                   	pop    %esi
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    

00802059 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	53                   	push   %ebx
  80205d:	83 ec 14             	sub    $0x14,%esp
  802060:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80206b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80206f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802072:	89 44 24 04          	mov    %eax,0x4(%esp)
  802076:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80207d:	e8 6d ea ff ff       	call   800aef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802082:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802088:	b8 05 00 00 00       	mov    $0x5,%eax
  80208d:	e8 e6 fd ff ff       	call   801e78 <nsipc>
}
  802092:	83 c4 14             	add    $0x14,%esp
  802095:	5b                   	pop    %ebx
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    

00802098 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	53                   	push   %ebx
  80209c:	83 ec 14             	sub    $0x14,%esp
  80209f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020aa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b5:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020bc:	e8 2e ea ff ff       	call   800aef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020c1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8020cc:	e8 a7 fd ff ff       	call   801e78 <nsipc>
}
  8020d1:	83 c4 14             	add    $0x14,%esp
  8020d4:	5b                   	pop    %ebx
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 28             	sub    $0x28,%esp
  8020dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020e6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020f1:	8b 07                	mov    (%edi),%eax
  8020f3:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fd:	e8 76 fd ff ff       	call   801e78 <nsipc>
  802102:	89 c6                	mov    %eax,%esi
  802104:	85 c0                	test   %eax,%eax
  802106:	78 22                	js     80212a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802108:	bb 10 70 80 00       	mov    $0x807010,%ebx
  80210d:	8b 03                	mov    (%ebx),%eax
  80210f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802113:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80211a:	00 
  80211b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211e:	89 04 24             	mov    %eax,(%esp)
  802121:	e8 c9 e9 ff ff       	call   800aef <memmove>
		*addrlen = ret->ret_addrlen;
  802126:	8b 03                	mov    (%ebx),%eax
  802128:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80212a:	89 f0                	mov    %esi,%eax
  80212c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80212f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802132:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802135:	89 ec                	mov    %ebp,%esp
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
  802139:	00 00                	add    %al,(%eax)
	...

0080213c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 18             	sub    $0x18,%esp
  802142:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802145:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802148:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	89 04 24             	mov    %eax,(%esp)
  802151:	e8 6e f0 ff ff       	call   8011c4 <fd2data>
  802156:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802158:	c7 44 24 04 4b 2f 80 	movl   $0x802f4b,0x4(%esp)
  80215f:	00 
  802160:	89 34 24             	mov    %esi,(%esp)
  802163:	e8 e1 e7 ff ff       	call   800949 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802168:	8b 43 04             	mov    0x4(%ebx),%eax
  80216b:	2b 03                	sub    (%ebx),%eax
  80216d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802173:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80217a:	00 00 00 
	stat->st_dev = &devpipe;
  80217d:	c7 86 88 00 00 00 40 	movl   $0x803040,0x88(%esi)
  802184:	30 80 00 
	return 0;
}
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80218f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802192:	89 ec                	mov    %ebp,%esp
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    

00802196 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	53                   	push   %ebx
  80219a:	83 ec 14             	sub    $0x14,%esp
  80219d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ab:	e8 22 ee ff ff       	call   800fd2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021b0:	89 1c 24             	mov    %ebx,(%esp)
  8021b3:	e8 0c f0 ff ff       	call   8011c4 <fd2data>
  8021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c3:	e8 0a ee ff ff       	call   800fd2 <sys_page_unmap>
}
  8021c8:	83 c4 14             	add    $0x14,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 2c             	sub    $0x2c,%esp
  8021d7:	89 c7                	mov    %eax,%edi
  8021d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8021dc:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021e1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021e4:	89 3c 24             	mov    %edi,(%esp)
  8021e7:	e8 c4 05 00 00       	call   8027b0 <pageref>
  8021ec:	89 c6                	mov    %eax,%esi
  8021ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 b7 05 00 00       	call   8027b0 <pageref>
  8021f9:	39 c6                	cmp    %eax,%esi
  8021fb:	0f 94 c0             	sete   %al
  8021fe:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802201:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802207:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80220a:	39 cb                	cmp    %ecx,%ebx
  80220c:	75 08                	jne    802216 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80220e:	83 c4 2c             	add    $0x2c,%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802216:	83 f8 01             	cmp    $0x1,%eax
  802219:	75 c1                	jne    8021dc <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80221b:	8b 52 58             	mov    0x58(%edx),%edx
  80221e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802222:	89 54 24 08          	mov    %edx,0x8(%esp)
  802226:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80222a:	c7 04 24 52 2f 80 00 	movl   $0x802f52,(%esp)
  802231:	e8 af e0 ff ff       	call   8002e5 <cprintf>
  802236:	eb a4                	jmp    8021dc <_pipeisclosed+0xe>

00802238 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	57                   	push   %edi
  80223c:	56                   	push   %esi
  80223d:	53                   	push   %ebx
  80223e:	83 ec 1c             	sub    $0x1c,%esp
  802241:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802244:	89 34 24             	mov    %esi,(%esp)
  802247:	e8 78 ef ff ff       	call   8011c4 <fd2data>
  80224c:	89 c3                	mov    %eax,%ebx
  80224e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802253:	eb 48                	jmp    80229d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802255:	89 da                	mov    %ebx,%edx
  802257:	89 f0                	mov    %esi,%eax
  802259:	e8 70 ff ff ff       	call   8021ce <_pipeisclosed>
  80225e:	85 c0                	test   %eax,%eax
  802260:	74 07                	je     802269 <devpipe_write+0x31>
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
  802267:	eb 3b                	jmp    8022a4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802269:	e8 7f ee ff ff       	call   8010ed <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80226e:	8b 43 04             	mov    0x4(%ebx),%eax
  802271:	8b 13                	mov    (%ebx),%edx
  802273:	83 c2 20             	add    $0x20,%edx
  802276:	39 d0                	cmp    %edx,%eax
  802278:	73 db                	jae    802255 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80227a:	89 c2                	mov    %eax,%edx
  80227c:	c1 fa 1f             	sar    $0x1f,%edx
  80227f:	c1 ea 1b             	shr    $0x1b,%edx
  802282:	01 d0                	add    %edx,%eax
  802284:	83 e0 1f             	and    $0x1f,%eax
  802287:	29 d0                	sub    %edx,%eax
  802289:	89 c2                	mov    %eax,%edx
  80228b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80228e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802292:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802296:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80229a:	83 c7 01             	add    $0x1,%edi
  80229d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022a0:	72 cc                	jb     80226e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8022a2:	89 f8                	mov    %edi,%eax
}
  8022a4:	83 c4 1c             	add    $0x1c,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5f                   	pop    %edi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    

008022ac <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 28             	sub    $0x28,%esp
  8022b2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022b5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022bb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022be:	89 3c 24             	mov    %edi,(%esp)
  8022c1:	e8 fe ee ff ff       	call   8011c4 <fd2data>
  8022c6:	89 c3                	mov    %eax,%ebx
  8022c8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022cd:	eb 48                	jmp    802317 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022cf:	85 f6                	test   %esi,%esi
  8022d1:	74 04                	je     8022d7 <devpipe_read+0x2b>
				return i;
  8022d3:	89 f0                	mov    %esi,%eax
  8022d5:	eb 47                	jmp    80231e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022d7:	89 da                	mov    %ebx,%edx
  8022d9:	89 f8                	mov    %edi,%eax
  8022db:	e8 ee fe ff ff       	call   8021ce <_pipeisclosed>
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 07                	je     8022eb <devpipe_read+0x3f>
  8022e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e9:	eb 33                	jmp    80231e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8022eb:	e8 fd ed ff ff       	call   8010ed <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8022f0:	8b 03                	mov    (%ebx),%eax
  8022f2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022f5:	74 d8                	je     8022cf <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022f7:	89 c2                	mov    %eax,%edx
  8022f9:	c1 fa 1f             	sar    $0x1f,%edx
  8022fc:	c1 ea 1b             	shr    $0x1b,%edx
  8022ff:	01 d0                	add    %edx,%eax
  802301:	83 e0 1f             	and    $0x1f,%eax
  802304:	29 d0                	sub    %edx,%eax
  802306:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80230b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802311:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802314:	83 c6 01             	add    $0x1,%esi
  802317:	3b 75 10             	cmp    0x10(%ebp),%esi
  80231a:	72 d4                	jb     8022f0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80231c:	89 f0                	mov    %esi,%eax
}
  80231e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802321:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802324:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802327:	89 ec                	mov    %ebp,%esp
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802331:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802334:	89 44 24 04          	mov    %eax,0x4(%esp)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 f5 ee ff ff       	call   801238 <fd_lookup>
  802343:	85 c0                	test   %eax,%eax
  802345:	78 15                	js     80235c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	89 04 24             	mov    %eax,(%esp)
  80234d:	e8 72 ee ff ff       	call   8011c4 <fd2data>
	return _pipeisclosed(fd, p);
  802352:	89 c2                	mov    %eax,%edx
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	e8 72 fe ff ff       	call   8021ce <_pipeisclosed>
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 48             	sub    $0x48,%esp
  802364:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802367:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80236a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80236d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802370:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802373:	89 04 24             	mov    %eax,(%esp)
  802376:	e8 64 ee ff ff       	call   8011df <fd_alloc>
  80237b:	89 c3                	mov    %eax,%ebx
  80237d:	85 c0                	test   %eax,%eax
  80237f:	0f 88 42 01 00 00    	js     8024c7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802385:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80238c:	00 
  80238d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802390:	89 44 24 04          	mov    %eax,0x4(%esp)
  802394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80239b:	e8 ee ec ff ff       	call   80108e <sys_page_alloc>
  8023a0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 88 1d 01 00 00    	js     8024c7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8023ad:	89 04 24             	mov    %eax,(%esp)
  8023b0:	e8 2a ee ff ff       	call   8011df <fd_alloc>
  8023b5:	89 c3                	mov    %eax,%ebx
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	0f 88 f5 00 00 00    	js     8024b4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023bf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023c6:	00 
  8023c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d5:	e8 b4 ec ff ff       	call   80108e <sys_page_alloc>
  8023da:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	0f 88 d0 00 00 00    	js     8024b4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8023e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e7:	89 04 24             	mov    %eax,(%esp)
  8023ea:	e8 d5 ed ff ff       	call   8011c4 <fd2data>
  8023ef:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023f8:	00 
  8023f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802404:	e8 85 ec ff ff       	call   80108e <sys_page_alloc>
  802409:	89 c3                	mov    %eax,%ebx
  80240b:	85 c0                	test   %eax,%eax
  80240d:	0f 88 8e 00 00 00    	js     8024a1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802416:	89 04 24             	mov    %eax,(%esp)
  802419:	e8 a6 ed ff ff       	call   8011c4 <fd2data>
  80241e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802425:	00 
  802426:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80242a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802431:	00 
  802432:	89 74 24 04          	mov    %esi,0x4(%esp)
  802436:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80243d:	e8 ee eb ff ff       	call   801030 <sys_page_map>
  802442:	89 c3                	mov    %eax,%ebx
  802444:	85 c0                	test   %eax,%eax
  802446:	78 49                	js     802491 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802448:	b8 40 30 80 00       	mov    $0x803040,%eax
  80244d:	8b 08                	mov    (%eax),%ecx
  80244f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802452:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802457:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80245e:	8b 10                	mov    (%eax),%edx
  802460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802463:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802468:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80246f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802472:	89 04 24             	mov    %eax,(%esp)
  802475:	e8 3a ed ff ff       	call   8011b4 <fd2num>
  80247a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80247c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80247f:	89 04 24             	mov    %eax,(%esp)
  802482:	e8 2d ed ff ff       	call   8011b4 <fd2num>
  802487:	89 47 04             	mov    %eax,0x4(%edi)
  80248a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80248f:	eb 36                	jmp    8024c7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802491:	89 74 24 04          	mov    %esi,0x4(%esp)
  802495:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80249c:	e8 31 eb ff ff       	call   800fd2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024af:	e8 1e eb ff ff       	call   800fd2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c2:	e8 0b eb ff ff       	call   800fd2 <sys_page_unmap>
    err:
	return r;
}
  8024c7:	89 d8                	mov    %ebx,%eax
  8024c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8024cc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8024cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8024d2:	89 ec                	mov    %ebp,%esp
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
	...

008024e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e8:	5d                   	pop    %ebp
  8024e9:	c3                   	ret    

008024ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8024f0:	c7 44 24 04 6a 2f 80 	movl   $0x802f6a,0x4(%esp)
  8024f7:	00 
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	89 04 24             	mov    %eax,(%esp)
  8024fe:	e8 46 e4 ff ff       	call   800949 <strcpy>
	return 0;
}
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	57                   	push   %edi
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802516:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80251b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802521:	eb 34                	jmp    802557 <devcons_write+0x4d>
		m = n - tot;
  802523:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802526:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802528:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80252e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802533:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802536:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80253a:	03 45 0c             	add    0xc(%ebp),%eax
  80253d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802541:	89 3c 24             	mov    %edi,(%esp)
  802544:	e8 a6 e5 ff ff       	call   800aef <memmove>
		sys_cputs(buf, m);
  802549:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80254d:	89 3c 24             	mov    %edi,(%esp)
  802550:	e8 ab e7 ff ff       	call   800d00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802555:	01 de                	add    %ebx,%esi
  802557:	89 f0                	mov    %esi,%eax
  802559:	3b 75 10             	cmp    0x10(%ebp),%esi
  80255c:	72 c5                	jb     802523 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80255e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802564:	5b                   	pop    %ebx
  802565:	5e                   	pop    %esi
  802566:	5f                   	pop    %edi
  802567:	5d                   	pop    %ebp
  802568:	c3                   	ret    

00802569 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802575:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80257c:	00 
  80257d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802580:	89 04 24             	mov    %eax,(%esp)
  802583:	e8 78 e7 ff ff       	call   800d00 <sys_cputs>
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802590:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802594:	75 07                	jne    80259d <devcons_read+0x13>
  802596:	eb 28                	jmp    8025c0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802598:	e8 50 eb ff ff       	call   8010ed <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	e8 27 e7 ff ff       	call   800ccc <sys_cgetc>
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 ef                	je     802598 <devcons_read+0xe>
  8025a9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	78 16                	js     8025c5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025af:	83 f8 04             	cmp    $0x4,%eax
  8025b2:	74 0c                	je     8025c0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8025b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b7:	88 10                	mov    %dl,(%eax)
  8025b9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8025be:	eb 05                	jmp    8025c5 <devcons_read+0x3b>
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d0:	89 04 24             	mov    %eax,(%esp)
  8025d3:	e8 07 ec ff ff       	call   8011df <fd_alloc>
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	78 3f                	js     80261b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025dc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025e3:	00 
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f2:	e8 97 ea ff ff       	call   80108e <sys_page_alloc>
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	78 20                	js     80261b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8025fb:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	89 04 24             	mov    %eax,(%esp)
  802616:	e8 99 eb ff ff       	call   8011b4 <fd2num>
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802623:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802626:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	89 04 24             	mov    %eax,(%esp)
  802630:	e8 03 ec ff ff       	call   801238 <fd_lookup>
  802635:	85 c0                	test   %eax,%eax
  802637:	78 11                	js     80264a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	3b 05 5c 30 80 00    	cmp    0x80305c,%eax
  802644:	0f 94 c0             	sete   %al
  802647:	0f b6 c0             	movzbl %al,%eax
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802652:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802659:	00 
  80265a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80265d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802661:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802668:	e8 22 ee ff ff       	call   80148f <read>
	if (r < 0)
  80266d:	85 c0                	test   %eax,%eax
  80266f:	78 0f                	js     802680 <getchar+0x34>
		return r;
	if (r < 1)
  802671:	85 c0                	test   %eax,%eax
  802673:	7f 07                	jg     80267c <getchar+0x30>
  802675:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80267a:	eb 04                	jmp    802680 <getchar+0x34>
		return -E_EOF;
	return c;
  80267c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    
	...

00802684 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80268f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802692:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802698:	8b 12                	mov    (%edx),%edx
  80269a:	39 ca                	cmp    %ecx,%edx
  80269c:	75 0c                	jne    8026aa <ipc_find_env+0x26>
			return envs[i].env_id;
  80269e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026a1:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	eb 0e                	jmp    8026b8 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8026aa:	83 c0 01             	add    $0x1,%eax
  8026ad:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026b2:	75 db                	jne    80268f <ipc_find_env+0xb>
  8026b4:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    

008026ba <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	57                   	push   %edi
  8026be:	56                   	push   %esi
  8026bf:	53                   	push   %ebx
  8026c0:	83 ec 2c             	sub    $0x2c,%esp
  8026c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8026c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8026cc:	85 db                	test   %ebx,%ebx
  8026ce:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026d3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8026d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8026d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8026e5:	89 34 24             	mov    %esi,(%esp)
  8026e8:	e8 93 e7 ff ff       	call   800e80 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8026ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026f0:	74 e4                	je     8026d6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 28                	je     80271e <ipc_send+0x64>
  8026f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8026fa:	c7 44 24 0c 93 2f 80 	movl   $0x802f93,0xc(%esp)
  802701:	00 
  802702:	c7 44 24 08 76 2f 80 	movl   $0x802f76,0x8(%esp)
  802709:	00 
  80270a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802711:	00 
  802712:	c7 04 24 89 2f 80 00 	movl   $0x802f89,(%esp)
  802719:	e8 0e db ff ff       	call   80022c <_panic>
	//if(!ret) sys_yield();
}
  80271e:	83 c4 2c             	add    $0x2c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 28             	sub    $0x28,%esp
  80272c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80272f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802732:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802735:	8b 75 08             	mov    0x8(%ebp),%esi
  802738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  80273e:	85 c0                	test   %eax,%eax
  802740:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802745:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802748:	89 04 24             	mov    %eax,(%esp)
  80274b:	e8 d3 e6 ff ff       	call   800e23 <sys_ipc_recv>
  802750:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802752:	e8 ca e9 ff ff       	call   801121 <sys_getenvid>
  802757:	25 ff 03 00 00       	and    $0x3ff,%eax
  80275c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80275f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802764:	a3 0c 40 80 00       	mov    %eax,0x80400c
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802769:	85 f6                	test   %esi,%esi
  80276b:	74 0e                	je     80277b <ipc_recv+0x55>
  80276d:	ba 00 00 00 00       	mov    $0x0,%edx
  802772:	85 db                	test   %ebx,%ebx
  802774:	75 03                	jne    802779 <ipc_recv+0x53>
  802776:	8b 50 74             	mov    0x74(%eax),%edx
  802779:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  80277b:	85 ff                	test   %edi,%edi
  80277d:	74 13                	je     802792 <ipc_recv+0x6c>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	85 db                	test   %ebx,%ebx
  802786:	75 08                	jne    802790 <ipc_recv+0x6a>
  802788:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80278d:	8b 40 78             	mov    0x78(%eax),%eax
  802790:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802792:	85 db                	test   %ebx,%ebx
  802794:	75 08                	jne    80279e <ipc_recv+0x78>
  802796:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80279b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  80279e:	89 d8                	mov    %ebx,%eax
  8027a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8027a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8027a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8027a9:	89 ec                	mov    %ebp,%esp
  8027ab:	5d                   	pop    %ebp
  8027ac:	c3                   	ret    
  8027ad:	00 00                	add    %al,(%eax)
	...

008027b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	89 c2                	mov    %eax,%edx
  8027b8:	c1 ea 16             	shr    $0x16,%edx
  8027bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027c2:	f6 c2 01             	test   $0x1,%dl
  8027c5:	74 20                	je     8027e7 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027c7:	c1 e8 0c             	shr    $0xc,%eax
  8027ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027d1:	a8 01                	test   $0x1,%al
  8027d3:	74 12                	je     8027e7 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027d5:	c1 e8 0c             	shr    $0xc,%eax
  8027d8:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8027dd:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  8027e2:	0f b7 c0             	movzwl %ax,%eax
  8027e5:	eb 05                	jmp    8027ec <pageref+0x3c>
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ec:	5d                   	pop    %ebp
  8027ed:	c3                   	ret    
	...

008027f0 <__udivdi3>:
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	57                   	push   %edi
  8027f4:	56                   	push   %esi
  8027f5:	83 ec 10             	sub    $0x10,%esp
  8027f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8027fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fe:	8b 75 10             	mov    0x10(%ebp),%esi
  802801:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802804:	85 c0                	test   %eax,%eax
  802806:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802809:	75 35                	jne    802840 <__udivdi3+0x50>
  80280b:	39 fe                	cmp    %edi,%esi
  80280d:	77 61                	ja     802870 <__udivdi3+0x80>
  80280f:	85 f6                	test   %esi,%esi
  802811:	75 0b                	jne    80281e <__udivdi3+0x2e>
  802813:	b8 01 00 00 00       	mov    $0x1,%eax
  802818:	31 d2                	xor    %edx,%edx
  80281a:	f7 f6                	div    %esi
  80281c:	89 c6                	mov    %eax,%esi
  80281e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802821:	31 d2                	xor    %edx,%edx
  802823:	89 f8                	mov    %edi,%eax
  802825:	f7 f6                	div    %esi
  802827:	89 c7                	mov    %eax,%edi
  802829:	89 c8                	mov    %ecx,%eax
  80282b:	f7 f6                	div    %esi
  80282d:	89 c1                	mov    %eax,%ecx
  80282f:	89 fa                	mov    %edi,%edx
  802831:	89 c8                	mov    %ecx,%eax
  802833:	83 c4 10             	add    $0x10,%esp
  802836:	5e                   	pop    %esi
  802837:	5f                   	pop    %edi
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    
  80283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802840:	39 f8                	cmp    %edi,%eax
  802842:	77 1c                	ja     802860 <__udivdi3+0x70>
  802844:	0f bd d0             	bsr    %eax,%edx
  802847:	83 f2 1f             	xor    $0x1f,%edx
  80284a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80284d:	75 39                	jne    802888 <__udivdi3+0x98>
  80284f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802852:	0f 86 a0 00 00 00    	jbe    8028f8 <__udivdi3+0x108>
  802858:	39 f8                	cmp    %edi,%eax
  80285a:	0f 82 98 00 00 00    	jb     8028f8 <__udivdi3+0x108>
  802860:	31 ff                	xor    %edi,%edi
  802862:	31 c9                	xor    %ecx,%ecx
  802864:	89 c8                	mov    %ecx,%eax
  802866:	89 fa                	mov    %edi,%edx
  802868:	83 c4 10             	add    $0x10,%esp
  80286b:	5e                   	pop    %esi
  80286c:	5f                   	pop    %edi
  80286d:	5d                   	pop    %ebp
  80286e:	c3                   	ret    
  80286f:	90                   	nop
  802870:	89 d1                	mov    %edx,%ecx
  802872:	89 fa                	mov    %edi,%edx
  802874:	89 c8                	mov    %ecx,%eax
  802876:	31 ff                	xor    %edi,%edi
  802878:	f7 f6                	div    %esi
  80287a:	89 c1                	mov    %eax,%ecx
  80287c:	89 fa                	mov    %edi,%edx
  80287e:	89 c8                	mov    %ecx,%eax
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	5e                   	pop    %esi
  802884:	5f                   	pop    %edi
  802885:	5d                   	pop    %ebp
  802886:	c3                   	ret    
  802887:	90                   	nop
  802888:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80288c:	89 f2                	mov    %esi,%edx
  80288e:	d3 e0                	shl    %cl,%eax
  802890:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802893:	b8 20 00 00 00       	mov    $0x20,%eax
  802898:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80289b:	89 c1                	mov    %eax,%ecx
  80289d:	d3 ea                	shr    %cl,%edx
  80289f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028a6:	d3 e6                	shl    %cl,%esi
  8028a8:	89 c1                	mov    %eax,%ecx
  8028aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028ad:	89 fe                	mov    %edi,%esi
  8028af:	d3 ee                	shr    %cl,%esi
  8028b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bb:	d3 e7                	shl    %cl,%edi
  8028bd:	89 c1                	mov    %eax,%ecx
  8028bf:	d3 ea                	shr    %cl,%edx
  8028c1:	09 d7                	or     %edx,%edi
  8028c3:	89 f2                	mov    %esi,%edx
  8028c5:	89 f8                	mov    %edi,%eax
  8028c7:	f7 75 ec             	divl   -0x14(%ebp)
  8028ca:	89 d6                	mov    %edx,%esi
  8028cc:	89 c7                	mov    %eax,%edi
  8028ce:	f7 65 e8             	mull   -0x18(%ebp)
  8028d1:	39 d6                	cmp    %edx,%esi
  8028d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028d6:	72 30                	jb     802908 <__udivdi3+0x118>
  8028d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028df:	d3 e2                	shl    %cl,%edx
  8028e1:	39 c2                	cmp    %eax,%edx
  8028e3:	73 05                	jae    8028ea <__udivdi3+0xfa>
  8028e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8028e8:	74 1e                	je     802908 <__udivdi3+0x118>
  8028ea:	89 f9                	mov    %edi,%ecx
  8028ec:	31 ff                	xor    %edi,%edi
  8028ee:	e9 71 ff ff ff       	jmp    802864 <__udivdi3+0x74>
  8028f3:	90                   	nop
  8028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	31 ff                	xor    %edi,%edi
  8028fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8028ff:	e9 60 ff ff ff       	jmp    802864 <__udivdi3+0x74>
  802904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802908:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80290b:	31 ff                	xor    %edi,%edi
  80290d:	89 c8                	mov    %ecx,%eax
  80290f:	89 fa                	mov    %edi,%edx
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	5e                   	pop    %esi
  802915:	5f                   	pop    %edi
  802916:	5d                   	pop    %ebp
  802917:	c3                   	ret    
	...

00802920 <__umoddi3>:
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	57                   	push   %edi
  802924:	56                   	push   %esi
  802925:	83 ec 20             	sub    $0x20,%esp
  802928:	8b 55 14             	mov    0x14(%ebp),%edx
  80292b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80292e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802931:	8b 75 0c             	mov    0xc(%ebp),%esi
  802934:	85 d2                	test   %edx,%edx
  802936:	89 c8                	mov    %ecx,%eax
  802938:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80293b:	75 13                	jne    802950 <__umoddi3+0x30>
  80293d:	39 f7                	cmp    %esi,%edi
  80293f:	76 3f                	jbe    802980 <__umoddi3+0x60>
  802941:	89 f2                	mov    %esi,%edx
  802943:	f7 f7                	div    %edi
  802945:	89 d0                	mov    %edx,%eax
  802947:	31 d2                	xor    %edx,%edx
  802949:	83 c4 20             	add    $0x20,%esp
  80294c:	5e                   	pop    %esi
  80294d:	5f                   	pop    %edi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    
  802950:	39 f2                	cmp    %esi,%edx
  802952:	77 4c                	ja     8029a0 <__umoddi3+0x80>
  802954:	0f bd ca             	bsr    %edx,%ecx
  802957:	83 f1 1f             	xor    $0x1f,%ecx
  80295a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80295d:	75 51                	jne    8029b0 <__umoddi3+0x90>
  80295f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802962:	0f 87 e0 00 00 00    	ja     802a48 <__umoddi3+0x128>
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	29 f8                	sub    %edi,%eax
  80296d:	19 d6                	sbb    %edx,%esi
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	89 f2                	mov    %esi,%edx
  802977:	83 c4 20             	add    $0x20,%esp
  80297a:	5e                   	pop    %esi
  80297b:	5f                   	pop    %edi
  80297c:	5d                   	pop    %ebp
  80297d:	c3                   	ret    
  80297e:	66 90                	xchg   %ax,%ax
  802980:	85 ff                	test   %edi,%edi
  802982:	75 0b                	jne    80298f <__umoddi3+0x6f>
  802984:	b8 01 00 00 00       	mov    $0x1,%eax
  802989:	31 d2                	xor    %edx,%edx
  80298b:	f7 f7                	div    %edi
  80298d:	89 c7                	mov    %eax,%edi
  80298f:	89 f0                	mov    %esi,%eax
  802991:	31 d2                	xor    %edx,%edx
  802993:	f7 f7                	div    %edi
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	f7 f7                	div    %edi
  80299a:	eb a9                	jmp    802945 <__umoddi3+0x25>
  80299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	89 c8                	mov    %ecx,%eax
  8029a2:	89 f2                	mov    %esi,%edx
  8029a4:	83 c4 20             	add    $0x20,%esp
  8029a7:	5e                   	pop    %esi
  8029a8:	5f                   	pop    %edi
  8029a9:	5d                   	pop    %ebp
  8029aa:	c3                   	ret    
  8029ab:	90                   	nop
  8029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029b4:	d3 e2                	shl    %cl,%edx
  8029b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8029be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8029c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029c8:	89 fa                	mov    %edi,%edx
  8029ca:	d3 ea                	shr    %cl,%edx
  8029cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8029d3:	d3 e7                	shl    %cl,%edi
  8029d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029dc:	89 f2                	mov    %esi,%edx
  8029de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	d3 ea                	shr    %cl,%edx
  8029e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8029ec:	89 c2                	mov    %eax,%edx
  8029ee:	d3 e6                	shl    %cl,%esi
  8029f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029f4:	d3 ea                	shr    %cl,%edx
  8029f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029fa:	09 d6                	or     %edx,%esi
  8029fc:	89 f0                	mov    %esi,%eax
  8029fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a01:	d3 e7                	shl    %cl,%edi
  802a03:	89 f2                	mov    %esi,%edx
  802a05:	f7 75 f4             	divl   -0xc(%ebp)
  802a08:	89 d6                	mov    %edx,%esi
  802a0a:	f7 65 e8             	mull   -0x18(%ebp)
  802a0d:	39 d6                	cmp    %edx,%esi
  802a0f:	72 2b                	jb     802a3c <__umoddi3+0x11c>
  802a11:	39 c7                	cmp    %eax,%edi
  802a13:	72 23                	jb     802a38 <__umoddi3+0x118>
  802a15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a19:	29 c7                	sub    %eax,%edi
  802a1b:	19 d6                	sbb    %edx,%esi
  802a1d:	89 f0                	mov    %esi,%eax
  802a1f:	89 f2                	mov    %esi,%edx
  802a21:	d3 ef                	shr    %cl,%edi
  802a23:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a27:	d3 e0                	shl    %cl,%eax
  802a29:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a2d:	09 f8                	or     %edi,%eax
  802a2f:	d3 ea                	shr    %cl,%edx
  802a31:	83 c4 20             	add    $0x20,%esp
  802a34:	5e                   	pop    %esi
  802a35:	5f                   	pop    %edi
  802a36:	5d                   	pop    %ebp
  802a37:	c3                   	ret    
  802a38:	39 d6                	cmp    %edx,%esi
  802a3a:	75 d9                	jne    802a15 <__umoddi3+0xf5>
  802a3c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a3f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a42:	eb d1                	jmp    802a15 <__umoddi3+0xf5>
  802a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a48:	39 f2                	cmp    %esi,%edx
  802a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a50:	0f 82 12 ff ff ff    	jb     802968 <__umoddi3+0x48>
  802a56:	e9 17 ff ff ff       	jmp    802972 <__umoddi3+0x52>
