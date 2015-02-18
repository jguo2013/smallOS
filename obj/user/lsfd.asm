
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 23 01 00 00       	call   800154 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800046:	c7 04 24 60 2b 80 00 	movl   $0x802b60,(%esp)
  80004d:	e8 c7 01 00 00       	call   800219 <cprintf>
	exit();
  800052:	e8 4d 01 00 00       	call   8001a4 <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <umain>:

void
umain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800065:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80006b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800072:	89 44 24 04          	mov    %eax,0x4(%esp)
  800076:	8d 45 08             	lea    0x8(%ebp),%eax
  800079:	89 04 24             	mov    %eax,(%esp)
  80007c:	e8 63 10 00 00       	call   8010e4 <argstart>
  800081:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800086:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
  80008c:	be 01 00 00 00       	mov    $0x1,%esi
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800091:	eb 12                	jmp    8000a5 <umain+0x4c>
		if (i == '1')
  800093:	83 f8 31             	cmp    $0x31,%eax
  800096:	75 04                	jne    80009c <umain+0x43>
  800098:	89 f7                	mov    %esi,%edi
  80009a:	eb 09                	jmp    8000a5 <umain+0x4c>
			usefprint = 1;
		else
			usage();
  80009c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8000a0:	e8 9b ff ff ff       	call   800040 <usage>
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 f7 10 00 00       	call   8011a4 <argnext>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	79 e2                	jns    800093 <umain+0x3a>
  8000b1:	e9 80 00 00 00       	jmp    800136 <umain+0xdd>
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000ba:	89 1c 24             	mov    %ebx,(%esp)
  8000bd:	e8 d1 12 00 00       	call   801393 <fstat>
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	78 66                	js     80012c <umain+0xd3>
			if (usefprint)
  8000c6:	85 ff                	test   %edi,%edi
  8000c8:	74 36                	je     800100 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000cd:	8b 40 04             	mov    0x4(%eax),%eax
  8000d0:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d7:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000de:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000e6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000ea:	c7 44 24 04 74 2b 80 	movl   $0x802b74,0x4(%esp)
  8000f1:	00 
  8000f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f9:	e8 63 1b 00 00       	call   801c61 <fprintf>
  8000fe:	eb 2c                	jmp    80012c <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800103:	8b 40 04             	mov    0x4(%eax),%eax
  800106:	89 44 24 14          	mov    %eax,0x14(%esp)
  80010a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80010d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800111:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800114:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800118:	89 74 24 08          	mov    %esi,0x8(%esp)
  80011c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800120:	c7 04 24 74 2b 80 00 	movl   $0x802b74,(%esp)
  800127:	e8 ed 00 00 00       	call   800219 <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80012c:	83 c3 01             	add    $0x1,%ebx
  80012f:	83 fb 20             	cmp    $0x20,%ebx
  800132:	75 82                	jne    8000b6 <umain+0x5d>
  800134:	eb 10                	jmp    800146 <umain+0xed>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800136:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  80013b:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  800141:	e9 70 ff ff ff       	jmp    8000b6 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800146:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    
  800151:	00 00                	add    %al,(%eax)
	...

00800154 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
  80015a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80015d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800160:	8b 75 08             	mov    0x8(%ebp),%esi
  800163:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800166:	e8 e6 0e 00 00       	call   801051 <sys_getenvid>
  80016b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800170:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800173:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800178:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017d:	85 f6                	test   %esi,%esi
  80017f:	7e 07                	jle    800188 <libmain+0x34>
		binaryname = argv[0];
  800181:	8b 03                	mov    (%ebx),%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800188:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018c:	89 34 24             	mov    %esi,(%esp)
  80018f:	e8 c5 fe ff ff       	call   800059 <umain>

	// exit gracefully
	exit();
  800194:	e8 0b 00 00 00       	call   8001a4 <exit>
}
  800199:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80019c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80019f:	89 ec                	mov    %ebp,%esp
  8001a1:	5d                   	pop    %ebp
  8001a2:	c3                   	ret    
	...

008001a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8001aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b1:	e8 cf 0e 00 00       	call   801085 <sys_env_destroy>
}
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c8:	00 00 00 
	b.cnt = 0;
  8001cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ed:	c7 04 24 33 02 80 00 	movl   $0x800233,(%esp)
  8001f4:	e8 be 01 00 00       	call   8003b7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800203:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800209:	89 04 24             	mov    %eax,(%esp)
  80020c:	e8 1f 0a 00 00       	call   800c30 <sys_cputs>

	return b.cnt;
}
  800211:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80021f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800222:	89 44 24 04          	mov    %eax,0x4(%esp)
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	89 04 24             	mov    %eax,(%esp)
  80022c:	e8 87 ff ff ff       	call   8001b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	53                   	push   %ebx
  800237:	83 ec 14             	sub    $0x14,%esp
  80023a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023d:	8b 03                	mov    (%ebx),%eax
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800246:	83 c0 01             	add    $0x1,%eax
  800249:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80024b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800250:	75 19                	jne    80026b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800252:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800259:	00 
  80025a:	8d 43 08             	lea    0x8(%ebx),%eax
  80025d:	89 04 24             	mov    %eax,(%esp)
  800260:	e8 cb 09 00 00       	call   800c30 <sys_cputs>
		b->idx = 0;
  800265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80026b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026f:	83 c4 14             	add    $0x14,%esp
  800272:	5b                   	pop    %ebx
  800273:	5d                   	pop    %ebp
  800274:	c3                   	ret    
  800275:	00 00                	add    %al,(%eax)
	...

00800278 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 4c             	sub    $0x4c,%esp
  800281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800284:	89 d6                	mov    %edx,%esi
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800292:	8b 45 10             	mov    0x10(%ebp),%eax
  800295:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800298:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80029e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a3:	39 d1                	cmp    %edx,%ecx
  8002a5:	72 07                	jb     8002ae <printnum+0x36>
  8002a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002aa:	39 d0                	cmp    %edx,%eax
  8002ac:	77 69                	ja     800317 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ae:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002c1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002c5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002cb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002d9:	00 
  8002da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002dd:	89 04 24             	mov    %eax,(%esp)
  8002e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e7:	e8 f4 25 00 00       	call   8028e0 <__udivdi3>
  8002ec:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002fa:	89 04 24             	mov    %eax,(%esp)
  8002fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  800301:	89 f2                	mov    %esi,%edx
  800303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800306:	e8 6d ff ff ff       	call   800278 <printnum>
  80030b:	eb 11                	jmp    80031e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800311:	89 3c 24             	mov    %edi,(%esp)
  800314:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800317:	83 eb 01             	sub    $0x1,%ebx
  80031a:	85 db                	test   %ebx,%ebx
  80031c:	7f ef                	jg     80030d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800322:	8b 74 24 04          	mov    0x4(%esp),%esi
  800326:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800329:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800334:	00 
  800335:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800338:	89 14 24             	mov    %edx,(%esp)
  80033b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80033e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800342:	e8 c9 26 00 00       	call   802a10 <__umoddi3>
  800347:	89 74 24 04          	mov    %esi,0x4(%esp)
  80034b:	0f be 80 a6 2b 80 00 	movsbl 0x802ba6(%eax),%eax
  800352:	89 04 24             	mov    %eax,(%esp)
  800355:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800358:	83 c4 4c             	add    $0x4c,%esp
  80035b:	5b                   	pop    %ebx
  80035c:	5e                   	pop    %esi
  80035d:	5f                   	pop    %edi
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800363:	83 fa 01             	cmp    $0x1,%edx
  800366:	7e 0e                	jle    800376 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800368:	8b 10                	mov    (%eax),%edx
  80036a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80036d:	89 08                	mov    %ecx,(%eax)
  80036f:	8b 02                	mov    (%edx),%eax
  800371:	8b 52 04             	mov    0x4(%edx),%edx
  800374:	eb 22                	jmp    800398 <getuint+0x38>
	else if (lflag)
  800376:	85 d2                	test   %edx,%edx
  800378:	74 10                	je     80038a <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80037a:	8b 10                	mov    (%eax),%edx
  80037c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037f:	89 08                	mov    %ecx,(%eax)
  800381:	8b 02                	mov    (%edx),%eax
  800383:	ba 00 00 00 00       	mov    $0x0,%edx
  800388:	eb 0e                	jmp    800398 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80038a:	8b 10                	mov    (%eax),%edx
  80038c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038f:	89 08                	mov    %ecx,(%eax)
  800391:	8b 02                	mov    (%edx),%eax
  800393:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a4:	8b 10                	mov    (%eax),%edx
  8003a6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a9:	73 0a                	jae    8003b5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ae:	88 0a                	mov    %cl,(%edx)
  8003b0:	83 c2 01             	add    $0x1,%edx
  8003b3:	89 10                	mov    %edx,(%eax)
}
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	57                   	push   %edi
  8003bb:	56                   	push   %esi
  8003bc:	53                   	push   %ebx
  8003bd:	83 ec 4c             	sub    $0x4c,%esp
  8003c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003c9:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003d0:	eb 11                	jmp    8003e3 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	0f 84 b6 03 00 00    	je     800790 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8003da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e3:	0f b6 03             	movzbl (%ebx),%eax
  8003e6:	83 c3 01             	add    $0x1,%ebx
  8003e9:	83 f8 25             	cmp    $0x25,%eax
  8003ec:	75 e4                	jne    8003d2 <vprintfmt+0x1b>
  8003ee:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003f2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003f9:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800400:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800407:	b9 00 00 00 00       	mov    $0x0,%ecx
  80040c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80040f:	eb 06                	jmp    800417 <vprintfmt+0x60>
  800411:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800415:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800417:	0f b6 0b             	movzbl (%ebx),%ecx
  80041a:	0f b6 c1             	movzbl %cl,%eax
  80041d:	8d 53 01             	lea    0x1(%ebx),%edx
  800420:	83 e9 23             	sub    $0x23,%ecx
  800423:	80 f9 55             	cmp    $0x55,%cl
  800426:	0f 87 47 03 00 00    	ja     800773 <vprintfmt+0x3bc>
  80042c:	0f b6 c9             	movzbl %cl,%ecx
  80042f:	ff 24 8d e0 2c 80 00 	jmp    *0x802ce0(,%ecx,4)
  800436:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80043a:	eb d9                	jmp    800415 <vprintfmt+0x5e>
  80043c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800443:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800448:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80044b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80044f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800452:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800455:	83 fb 09             	cmp    $0x9,%ebx
  800458:	77 30                	ja     80048a <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80045a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80045d:	eb e9                	jmp    800448 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	8d 48 04             	lea    0x4(%eax),%ecx
  800465:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  80046d:	eb 1e                	jmp    80048d <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80046f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  80047c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047f:	eb 94                	jmp    800415 <vprintfmt+0x5e>
  800481:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800488:	eb 8b                	jmp    800415 <vprintfmt+0x5e>
  80048a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  80048d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800491:	79 82                	jns    800415 <vprintfmt+0x5e>
  800493:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800499:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80049c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80049f:	e9 71 ff ff ff       	jmp    800415 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004a4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004a8:	e9 68 ff ff ff       	jmp    800415 <vprintfmt+0x5e>
  8004ad:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	89 04 24             	mov    %eax,(%esp)
  8004c2:	ff d7                	call   *%edi
  8004c4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8004c7:	e9 17 ff ff ff       	jmp    8003e3 <vprintfmt+0x2c>
  8004cc:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8d 50 04             	lea    0x4(%eax),%edx
  8004d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	89 c2                	mov    %eax,%edx
  8004dc:	c1 fa 1f             	sar    $0x1f,%edx
  8004df:	31 d0                	xor    %edx,%eax
  8004e1:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e3:	83 f8 11             	cmp    $0x11,%eax
  8004e6:	7f 0b                	jg     8004f3 <vprintfmt+0x13c>
  8004e8:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  8004ef:	85 d2                	test   %edx,%edx
  8004f1:	75 20                	jne    800513 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8004f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f7:	c7 44 24 08 b7 2b 80 	movl   $0x802bb7,0x8(%esp)
  8004fe:	00 
  8004ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800503:	89 3c 24             	mov    %edi,(%esp)
  800506:	e8 0d 03 00 00       	call   800818 <printfmt>
  80050b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050e:	e9 d0 fe ff ff       	jmp    8003e3 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800513:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800517:	c7 44 24 08 96 2f 80 	movl   $0x802f96,0x8(%esp)
  80051e:	00 
  80051f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800523:	89 3c 24             	mov    %edi,(%esp)
  800526:	e8 ed 02 00 00       	call   800818 <printfmt>
  80052b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80052e:	e9 b0 fe ff ff       	jmp    8003e3 <vprintfmt+0x2c>
  800533:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800536:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8d 50 04             	lea    0x4(%eax),%edx
  800545:	89 55 14             	mov    %edx,0x14(%ebp)
  800548:	8b 18                	mov    (%eax),%ebx
  80054a:	85 db                	test   %ebx,%ebx
  80054c:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  800551:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800554:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800558:	7e 76                	jle    8005d0 <vprintfmt+0x219>
  80055a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80055e:	74 7a                	je     8005da <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800560:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800564:	89 1c 24             	mov    %ebx,(%esp)
  800567:	e8 ec 02 00 00       	call   800858 <strnlen>
  80056c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056f:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800571:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800575:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800578:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80057b:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	eb 0f                	jmp    80058e <vprintfmt+0x1d7>
					putch(padc, putdat);
  80057f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800586:	89 04 24             	mov    %eax,(%esp)
  800589:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	83 eb 01             	sub    $0x1,%ebx
  80058e:	85 db                	test   %ebx,%ebx
  800590:	7f ed                	jg     80057f <vprintfmt+0x1c8>
  800592:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800595:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800598:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80059b:	89 f7                	mov    %esi,%edi
  80059d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005a0:	eb 40                	jmp    8005e2 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a6:	74 18                	je     8005c0 <vprintfmt+0x209>
  8005a8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005ab:	83 fa 5e             	cmp    $0x5e,%edx
  8005ae:	76 10                	jbe    8005c0 <vprintfmt+0x209>
					putch('?', putdat);
  8005b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005bb:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005be:	eb 0a                	jmp    8005ca <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c4:	89 04 24             	mov    %eax,(%esp)
  8005c7:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ca:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005ce:	eb 12                	jmp    8005e2 <vprintfmt+0x22b>
  8005d0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005d3:	89 f7                	mov    %esi,%edi
  8005d5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005d8:	eb 08                	jmp    8005e2 <vprintfmt+0x22b>
  8005da:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005dd:	89 f7                	mov    %esi,%edi
  8005df:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005e2:	0f be 03             	movsbl (%ebx),%eax
  8005e5:	83 c3 01             	add    $0x1,%ebx
  8005e8:	85 c0                	test   %eax,%eax
  8005ea:	74 25                	je     800611 <vprintfmt+0x25a>
  8005ec:	85 f6                	test   %esi,%esi
  8005ee:	78 b2                	js     8005a2 <vprintfmt+0x1eb>
  8005f0:	83 ee 01             	sub    $0x1,%esi
  8005f3:	79 ad                	jns    8005a2 <vprintfmt+0x1eb>
  8005f5:	89 fe                	mov    %edi,%esi
  8005f7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8005fd:	eb 1a                	jmp    800619 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800603:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80060a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80060c:	83 eb 01             	sub    $0x1,%ebx
  80060f:	eb 08                	jmp    800619 <vprintfmt+0x262>
  800611:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800614:	89 fe                	mov    %edi,%esi
  800616:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800619:	85 db                	test   %ebx,%ebx
  80061b:	7f e2                	jg     8005ff <vprintfmt+0x248>
  80061d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800620:	e9 be fd ff ff       	jmp    8003e3 <vprintfmt+0x2c>
  800625:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800628:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80062b:	83 f9 01             	cmp    $0x1,%ecx
  80062e:	7e 16                	jle    800646 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8d 50 08             	lea    0x8(%eax),%edx
  800636:	89 55 14             	mov    %edx,0x14(%ebp)
  800639:	8b 10                	mov    (%eax),%edx
  80063b:	8b 48 04             	mov    0x4(%eax),%ecx
  80063e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800641:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800644:	eb 32                	jmp    800678 <vprintfmt+0x2c1>
	else if (lflag)
  800646:	85 c9                	test   %ecx,%ecx
  800648:	74 18                	je     800662 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 50 04             	lea    0x4(%eax),%edx
  800650:	89 55 14             	mov    %edx,0x14(%ebp)
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 c1                	mov    %eax,%ecx
  80065a:	c1 f9 1f             	sar    $0x1f,%ecx
  80065d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800660:	eb 16                	jmp    800678 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 50 04             	lea    0x4(%eax),%edx
  800668:	89 55 14             	mov    %edx,0x14(%ebp)
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800670:	89 c2                	mov    %eax,%edx
  800672:	c1 fa 1f             	sar    $0x1f,%edx
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800678:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80067b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80067e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800683:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800687:	0f 89 a7 00 00 00    	jns    800734 <vprintfmt+0x37d>
				putch('-', putdat);
  80068d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800691:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800698:	ff d7                	call   *%edi
				num = -(long long) num;
  80069a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80069d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006a0:	f7 d9                	neg    %ecx
  8006a2:	83 d3 00             	adc    $0x0,%ebx
  8006a5:	f7 db                	neg    %ebx
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ac:	e9 83 00 00 00       	jmp    800734 <vprintfmt+0x37d>
  8006b1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006b4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b7:	89 ca                	mov    %ecx,%edx
  8006b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bc:	e8 9f fc ff ff       	call   800360 <getuint>
  8006c1:	89 c1                	mov    %eax,%ecx
  8006c3:	89 d3                	mov    %edx,%ebx
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006ca:	eb 68                	jmp    800734 <vprintfmt+0x37d>
  8006cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006cf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006d2:	89 ca                	mov    %ecx,%edx
  8006d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d7:	e8 84 fc ff ff       	call   800360 <getuint>
  8006dc:	89 c1                	mov    %eax,%ecx
  8006de:	89 d3                	mov    %edx,%ebx
  8006e0:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006e5:	eb 4d                	jmp    800734 <vprintfmt+0x37d>
  8006e7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8006ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ee:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006f5:	ff d7                	call   *%edi
			putch('x', putdat);
  8006f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006fb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800702:	ff d7                	call   *%edi
			num = (unsigned long long)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 50 04             	lea    0x4(%eax),%edx
  80070a:	89 55 14             	mov    %edx,0x14(%ebp)
  80070d:	8b 08                	mov    (%eax),%ecx
  80070f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800714:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800719:	eb 19                	jmp    800734 <vprintfmt+0x37d>
  80071b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80071e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800721:	89 ca                	mov    %ecx,%edx
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 35 fc ff ff       	call   800360 <getuint>
  80072b:	89 c1                	mov    %eax,%ecx
  80072d:	89 d3                	mov    %edx,%ebx
  80072f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800734:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800738:	89 54 24 10          	mov    %edx,0x10(%esp)
  80073c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80073f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800743:	89 44 24 08          	mov    %eax,0x8(%esp)
  800747:	89 0c 24             	mov    %ecx,(%esp)
  80074a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80074e:	89 f2                	mov    %esi,%edx
  800750:	89 f8                	mov    %edi,%eax
  800752:	e8 21 fb ff ff       	call   800278 <printnum>
  800757:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80075a:	e9 84 fc ff ff       	jmp    8003e3 <vprintfmt+0x2c>
  80075f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800762:	89 74 24 04          	mov    %esi,0x4(%esp)
  800766:	89 04 24             	mov    %eax,(%esp)
  800769:	ff d7                	call   *%edi
  80076b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80076e:	e9 70 fc ff ff       	jmp    8003e3 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800773:	89 74 24 04          	mov    %esi,0x4(%esp)
  800777:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80077e:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800780:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800783:	80 38 25             	cmpb   $0x25,(%eax)
  800786:	0f 84 57 fc ff ff    	je     8003e3 <vprintfmt+0x2c>
  80078c:	89 c3                	mov    %eax,%ebx
  80078e:	eb f0                	jmp    800780 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800790:	83 c4 4c             	add    $0x4c,%esp
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	74 04                	je     8007ac <vsnprintf+0x14>
  8007a8:	85 d2                	test   %edx,%edx
  8007aa:	7f 07                	jg     8007b3 <vsnprintf+0x1b>
  8007ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b1:	eb 3b                	jmp    8007ee <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d9:	c7 04 24 9a 03 80 00 	movl   $0x80039a,(%esp)
  8007e0:	e8 d2 fb ff ff       	call   8003b7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007f6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	89 44 24 08          	mov    %eax,0x8(%esp)
  800804:	8b 45 0c             	mov    0xc(%ebp),%eax
  800807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	89 04 24             	mov    %eax,(%esp)
  800811:	e8 82 ff ff ff       	call   800798 <vsnprintf>
	va_end(ap);

	return rc;
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80081e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800821:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800825:	8b 45 10             	mov    0x10(%ebp),%eax
  800828:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	89 04 24             	mov    %eax,(%esp)
  800839:	e8 79 fb ff ff       	call   8003b7 <vprintfmt>
	va_end(ap);
}
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

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
  800ccc:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800cd3:	00 
  800cd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cdb:	00 
  800cdc:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800ce3:	e8 2c 1a 00 00       	call   802714 <_panic>

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
  800d2a:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800d31:	00 
  800d32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d39:	00 
  800d3a:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800d41:	e8 ce 19 00 00       	call   802714 <_panic>

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
  800d87:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d96:	00 
  800d97:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800d9e:	e8 71 19 00 00       	call   802714 <_panic>

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
  800e1d:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800e24:	00 
  800e25:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2c:	00 
  800e2d:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800e34:	e8 db 18 00 00       	call   802714 <_panic>

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
  800e7b:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800e82:	00 
  800e83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8a:	00 
  800e8b:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800e92:	e8 7d 18 00 00       	call   802714 <_panic>

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
  800ed9:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee8:	00 
  800ee9:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800ef0:	e8 1f 18 00 00       	call   802714 <_panic>

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
  800f37:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f46:	00 
  800f47:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800f4e:	e8 c1 17 00 00       	call   802714 <_panic>

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
  800f95:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa4:	00 
  800fa5:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800fac:	e8 63 17 00 00       	call   802714 <_panic>

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
  800ff4:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  80100b:	e8 04 17 00 00       	call   802714 <_panic>

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
  8010b9:	c7 44 24 08 a7 2e 80 	movl   $0x802ea7,0x8(%esp)
  8010c0:	00 
  8010c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c8:	00 
  8010c9:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  8010d0:	e8 3f 16 00 00       	call   802714 <_panic>

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

008010e4 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8010f0:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8010f2:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8010f5:	83 3a 01             	cmpl   $0x1,(%edx)
  8010f8:	7e 09                	jle    801103 <argstart+0x1f>
  8010fa:	ba 71 2b 80 00       	mov    $0x802b71,%edx
  8010ff:	85 c9                	test   %ecx,%ecx
  801101:	75 05                	jne    801108 <argstart+0x24>
  801103:	ba 00 00 00 00       	mov    $0x0,%edx
  801108:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80110b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	53                   	push   %ebx
  801118:	83 ec 14             	sub    $0x14,%esp
  80111b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80111e:	8b 53 08             	mov    0x8(%ebx),%edx
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
  801126:	85 d2                	test   %edx,%edx
  801128:	74 5a                	je     801184 <argnextvalue+0x70>
		return 0;
	if (*args->curarg) {
  80112a:	80 3a 00             	cmpb   $0x0,(%edx)
  80112d:	74 0c                	je     80113b <argnextvalue+0x27>
		args->argvalue = args->curarg;
  80112f:	89 53 0c             	mov    %edx,0xc(%ebx)
		args->curarg = "";
  801132:	c7 43 08 71 2b 80 00 	movl   $0x802b71,0x8(%ebx)
  801139:	eb 46                	jmp    801181 <argnextvalue+0x6d>
	} else if (*args->argc > 1) {
  80113b:	8b 03                	mov    (%ebx),%eax
  80113d:	83 38 01             	cmpl   $0x1,(%eax)
  801140:	7e 31                	jle    801173 <argnextvalue+0x5f>
		args->argvalue = args->argv[1];
  801142:	8b 43 04             	mov    0x4(%ebx),%eax
  801145:	8b 50 04             	mov    0x4(%eax),%edx
  801148:	89 53 0c             	mov    %edx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80114b:	8b 13                	mov    (%ebx),%edx
  80114d:	8b 12                	mov    (%edx),%edx
  80114f:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801156:	89 54 24 08          	mov    %edx,0x8(%esp)
  80115a:	8d 50 08             	lea    0x8(%eax),%edx
  80115d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 04 24             	mov    %eax,(%esp)
  801167:	e8 b3 f8 ff ff       	call   800a1f <memmove>
		(*args->argc)--;
  80116c:	8b 03                	mov    (%ebx),%eax
  80116e:	83 28 01             	subl   $0x1,(%eax)
  801171:	eb 0e                	jmp    801181 <argnextvalue+0x6d>
	} else {
		args->argvalue = 0;
  801173:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80117a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801181:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801184:	83 c4 14             	add    $0x14,%esp
  801187:	5b                   	pop    %ebx
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 18             	sub    $0x18,%esp
  801190:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801193:	8b 42 0c             	mov    0xc(%edx),%eax
  801196:	85 c0                	test   %eax,%eax
  801198:	75 08                	jne    8011a2 <argvalue+0x18>
  80119a:	89 14 24             	mov    %edx,(%esp)
  80119d:	e8 72 ff ff ff       	call   801114 <argnextvalue>
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <argnext>:
	args->argvalue = 0;
}

int
argnext(struct Argstate *args)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	53                   	push   %ebx
  8011a8:	83 ec 14             	sub    $0x14,%esp
  8011ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8011ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8011b5:	8b 53 08             	mov    0x8(%ebx),%edx
  8011b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011bd:	85 d2                	test   %edx,%edx
  8011bf:	74 73                	je     801234 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  8011c1:	80 3a 00             	cmpb   $0x0,(%edx)
  8011c4:	75 54                	jne    80121a <argnext+0x76>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8011c6:	8b 03                	mov    (%ebx),%eax
  8011c8:	83 38 01             	cmpl   $0x1,(%eax)
  8011cb:	74 5b                	je     801228 <argnext+0x84>
		    || args->argv[1][0] != '-'
  8011cd:	8b 43 04             	mov    0x4(%ebx),%eax
  8011d0:	8b 40 04             	mov    0x4(%eax),%eax
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8011d3:	80 38 2d             	cmpb   $0x2d,(%eax)
  8011d6:	75 50                	jne    801228 <argnext+0x84>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
  8011d8:	83 c0 01             	add    $0x1,%eax
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8011db:	80 38 00             	cmpb   $0x0,(%eax)
  8011de:	74 48                	je     801228 <argnext+0x84>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8011e0:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011e3:	8b 43 04             	mov    0x4(%ebx),%eax
  8011e6:	8b 13                	mov    (%ebx),%edx
  8011e8:	8b 12                	mov    (%edx),%edx
  8011ea:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8011f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8011f5:	8d 50 08             	lea    0x8(%eax),%edx
  8011f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011fc:	83 c0 04             	add    $0x4,%eax
  8011ff:	89 04 24             	mov    %eax,(%esp)
  801202:	e8 18 f8 ff ff       	call   800a1f <memmove>
		(*args->argc)--;
  801207:	8b 03                	mov    (%ebx),%eax
  801209:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80120c:	8b 43 08             	mov    0x8(%ebx),%eax
  80120f:	80 38 2d             	cmpb   $0x2d,(%eax)
  801212:	75 06                	jne    80121a <argnext+0x76>
  801214:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801218:	74 0e                	je     801228 <argnext+0x84>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80121a:	8b 53 08             	mov    0x8(%ebx),%edx
  80121d:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801220:	83 c2 01             	add    $0x1,%edx
  801223:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801226:	eb 0c                	jmp    801234 <argnext+0x90>

    endofargs:
	args->curarg = 0;
  801228:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80122f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return -1;
}
  801234:	83 c4 14             	add    $0x14,%esp
  801237:	5b                   	pop    %ebx
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    
	...

0080123c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	05 00 00 00 30       	add    $0x30000000,%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	89 04 24             	mov    %eax,(%esp)
  801258:	e8 df ff ff ff       	call   80123c <fd2num>
  80125d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801262:	c1 e0 0c             	shl    $0xc,%eax
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801270:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801275:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  80127a:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80127f:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 ea 16             	shr    $0x16,%edx
  801286:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801289:	f6 c2 01             	test   $0x1,%dl
  80128c:	74 0d                	je     80129b <fd_alloc+0x34>
  80128e:	89 c2                	mov    %eax,%edx
  801290:	c1 ea 0c             	shr    $0xc,%edx
  801293:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801296:	f6 c2 01             	test   $0x1,%dl
  801299:	75 09                	jne    8012a4 <fd_alloc+0x3d>
			*fd_store = fd;
  80129b:	89 37                	mov    %esi,(%edi)
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012a2:	eb 17                	jmp    8012bb <fd_alloc+0x54>
  8012a4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ae:	75 cf                	jne    80127f <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012b0:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8012b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5f                   	pop    %edi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	83 f8 1f             	cmp    $0x1f,%eax
  8012c9:	77 36                	ja     801301 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012cb:	05 00 00 0d 00       	add    $0xd0000,%eax
  8012d0:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d3:	89 c2                	mov    %eax,%edx
  8012d5:	c1 ea 16             	shr    $0x16,%edx
  8012d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012df:	f6 c2 01             	test   $0x1,%dl
  8012e2:	74 1d                	je     801301 <fd_lookup+0x41>
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	c1 ea 0c             	shr    $0xc,%edx
  8012e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f0:	f6 c2 01             	test   $0x1,%dl
  8012f3:	74 0c                	je     801301 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f8:	89 02                	mov    %eax,(%edx)
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8012ff:	eb 05                	jmp    801306 <fd_lookup+0x46>
  801301:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801311:	89 44 24 04          	mov    %eax,0x4(%esp)
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 04 24             	mov    %eax,(%esp)
  80131b:	e8 a0 ff ff ff       	call   8012c0 <fd_lookup>
  801320:	85 c0                	test   %eax,%eax
  801322:	78 0e                	js     801332 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132a:	89 50 04             	mov    %edx,0x4(%eax)
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	56                   	push   %esi
  801338:	53                   	push   %ebx
  801339:	83 ec 10             	sub    $0x10,%esp
  80133c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801342:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801347:	be 50 2f 80 00       	mov    $0x802f50,%esi
  80134c:	eb 10                	jmp    80135e <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  80134e:	39 08                	cmp    %ecx,(%eax)
  801350:	75 09                	jne    80135b <dev_lookup+0x27>
			*dev = devtab[i];
  801352:	89 03                	mov    %eax,(%ebx)
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801359:	eb 31                	jmp    80138c <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80135b:	83 c2 01             	add    $0x1,%edx
  80135e:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801361:	85 c0                	test   %eax,%eax
  801363:	75 e9                	jne    80134e <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801365:	a1 08 50 80 00       	mov    0x805008,%eax
  80136a:	8b 40 48             	mov    0x48(%eax),%eax
  80136d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801371:	89 44 24 04          	mov    %eax,0x4(%esp)
  801375:	c7 04 24 d4 2e 80 00 	movl   $0x802ed4,(%esp)
  80137c:	e8 98 ee ff ff       	call   800219 <cprintf>
	*dev = 0;
  801381:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801387:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	53                   	push   %ebx
  801397:	83 ec 24             	sub    $0x24,%esp
  80139a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 04 24             	mov    %eax,(%esp)
  8013aa:	e8 11 ff ff ff       	call   8012c0 <fd_lookup>
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 53                	js     801406 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	89 04 24             	mov    %eax,(%esp)
  8013c2:	e8 6d ff ff ff       	call   801334 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 3b                	js     801406 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8013cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d3:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8013d7:	74 2d                	je     801406 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e3:	00 00 00 
	stat->st_isdir = 0;
  8013e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013ed:	00 00 00 
	stat->st_dev = dev;
  8013f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801400:	89 14 24             	mov    %edx,(%esp)
  801403:	ff 50 14             	call   *0x14(%eax)
}
  801406:	83 c4 24             	add    $0x24,%esp
  801409:	5b                   	pop    %ebx
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	53                   	push   %ebx
  801410:	83 ec 24             	sub    $0x24,%esp
  801413:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801416:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801419:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141d:	89 1c 24             	mov    %ebx,(%esp)
  801420:	e8 9b fe ff ff       	call   8012c0 <fd_lookup>
  801425:	85 c0                	test   %eax,%eax
  801427:	78 5f                	js     801488 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801429:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801433:	8b 00                	mov    (%eax),%eax
  801435:	89 04 24             	mov    %eax,(%esp)
  801438:	e8 f7 fe ff ff       	call   801334 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 47                	js     801488 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801444:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801448:	75 23                	jne    80146d <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80144a:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80144f:	8b 40 48             	mov    0x48(%eax),%eax
  801452:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145a:	c7 04 24 f4 2e 80 00 	movl   $0x802ef4,(%esp)
  801461:	e8 b3 ed ff ff       	call   800219 <cprintf>
  801466:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80146b:	eb 1b                	jmp    801488 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	8b 48 18             	mov    0x18(%eax),%ecx
  801473:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801478:	85 c9                	test   %ecx,%ecx
  80147a:	74 0c                	je     801488 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80147c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801483:	89 14 24             	mov    %edx,(%esp)
  801486:	ff d1                	call   *%ecx
}
  801488:	83 c4 24             	add    $0x24,%esp
  80148b:	5b                   	pop    %ebx
  80148c:	5d                   	pop    %ebp
  80148d:	c3                   	ret    

0080148e <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	53                   	push   %ebx
  801492:	83 ec 24             	sub    $0x24,%esp
  801495:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801498:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149f:	89 1c 24             	mov    %ebx,(%esp)
  8014a2:	e8 19 fe ff ff       	call   8012c0 <fd_lookup>
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 66                	js     801511 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	89 04 24             	mov    %eax,(%esp)
  8014ba:	e8 75 fe ff ff       	call   801334 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 4e                	js     801511 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c6:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014ca:	75 23                	jne    8014ef <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014cc:	a1 08 50 80 00       	mov    0x805008,%eax
  8014d1:	8b 40 48             	mov    0x48(%eax),%eax
  8014d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014dc:	c7 04 24 15 2f 80 00 	movl   $0x802f15,(%esp)
  8014e3:	e8 31 ed ff ff       	call   800219 <cprintf>
  8014e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014ed:	eb 22                	jmp    801511 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f2:	8b 48 0c             	mov    0xc(%eax),%ecx
  8014f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fa:	85 c9                	test   %ecx,%ecx
  8014fc:	74 13                	je     801511 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801501:	89 44 24 08          	mov    %eax,0x8(%esp)
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150c:	89 14 24             	mov    %edx,(%esp)
  80150f:	ff d1                	call   *%ecx
}
  801511:	83 c4 24             	add    $0x24,%esp
  801514:	5b                   	pop    %ebx
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	53                   	push   %ebx
  80151b:	83 ec 24             	sub    $0x24,%esp
  80151e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801521:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801524:	89 44 24 04          	mov    %eax,0x4(%esp)
  801528:	89 1c 24             	mov    %ebx,(%esp)
  80152b:	e8 90 fd ff ff       	call   8012c0 <fd_lookup>
  801530:	85 c0                	test   %eax,%eax
  801532:	78 6b                	js     80159f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801537:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	89 04 24             	mov    %eax,(%esp)
  801543:	e8 ec fd ff ff       	call   801334 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 53                	js     80159f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80154c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154f:	8b 42 08             	mov    0x8(%edx),%eax
  801552:	83 e0 03             	and    $0x3,%eax
  801555:	83 f8 01             	cmp    $0x1,%eax
  801558:	75 23                	jne    80157d <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80155a:	a1 08 50 80 00       	mov    0x805008,%eax
  80155f:	8b 40 48             	mov    0x48(%eax),%eax
  801562:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156a:	c7 04 24 32 2f 80 00 	movl   $0x802f32,(%esp)
  801571:	e8 a3 ec ff ff       	call   800219 <cprintf>
  801576:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  80157b:	eb 22                	jmp    80159f <read+0x88>
	}
	if (!dev->dev_read)
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	8b 48 08             	mov    0x8(%eax),%ecx
  801583:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801588:	85 c9                	test   %ecx,%ecx
  80158a:	74 13                	je     80159f <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80158c:	8b 45 10             	mov    0x10(%ebp),%eax
  80158f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801593:	8b 45 0c             	mov    0xc(%ebp),%eax
  801596:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159a:	89 14 24             	mov    %edx,(%esp)
  80159d:	ff d1                	call   *%ecx
}
  80159f:	83 c4 24             	add    $0x24,%esp
  8015a2:	5b                   	pop    %ebx
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	57                   	push   %edi
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	83 ec 1c             	sub    $0x1c,%esp
  8015ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b1:	8b 75 10             	mov    0x10(%ebp),%esi
  8015b4:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b9:	eb 21                	jmp    8015dc <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015bb:	89 f2                	mov    %esi,%edx
  8015bd:	29 c2                	sub    %eax,%edx
  8015bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015c3:	03 45 0c             	add    0xc(%ebp),%eax
  8015c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ca:	89 3c 24             	mov    %edi,(%esp)
  8015cd:	e8 45 ff ff ff       	call   801517 <read>
		if (m < 0)
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 0e                	js     8015e4 <readn+0x3f>
			return m;
		if (m == 0)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 08                	je     8015e2 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015da:	01 c3                	add    %eax,%ebx
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	39 f3                	cmp    %esi,%ebx
  8015e0:	72 d9                	jb     8015bb <readn+0x16>
  8015e2:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015e4:	83 c4 1c             	add    $0x1c,%esp
  8015e7:	5b                   	pop    %ebx
  8015e8:	5e                   	pop    %esi
  8015e9:	5f                   	pop    %edi
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 38             	sub    $0x38,%esp
  8015f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015fe:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801602:	89 3c 24             	mov    %edi,(%esp)
  801605:	e8 32 fc ff ff       	call   80123c <fd2num>
  80160a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80160d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801611:	89 04 24             	mov    %eax,(%esp)
  801614:	e8 a7 fc ff ff       	call   8012c0 <fd_lookup>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 05                	js     801624 <fd_close+0x38>
  80161f:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801622:	74 0e                	je     801632 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801624:	89 f0                	mov    %esi,%eax
  801626:	84 c0                	test   %al,%al
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
  80162d:	0f 44 d8             	cmove  %eax,%ebx
  801630:	eb 3d                	jmp    80166f <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801632:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801635:	89 44 24 04          	mov    %eax,0x4(%esp)
  801639:	8b 07                	mov    (%edi),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 f1 fc ff ff       	call   801334 <dev_lookup>
  801643:	89 c3                	mov    %eax,%ebx
  801645:	85 c0                	test   %eax,%eax
  801647:	78 16                	js     80165f <fd_close+0x73>
		if (dev->dev_close)
  801649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164c:	8b 40 10             	mov    0x10(%eax),%eax
  80164f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801654:	85 c0                	test   %eax,%eax
  801656:	74 07                	je     80165f <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801658:	89 3c 24             	mov    %edi,(%esp)
  80165b:	ff d0                	call   *%eax
  80165d:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80165f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801663:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166a:	e8 93 f8 ff ff       	call   800f02 <sys_page_unmap>
	return r;
}
  80166f:	89 d8                	mov    %ebx,%eax
  801671:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801674:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801677:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80167a:	89 ec                	mov    %ebp,%esp
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801684:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	89 04 24             	mov    %eax,(%esp)
  801691:	e8 2a fc ff ff       	call   8012c0 <fd_lookup>
  801696:	85 c0                	test   %eax,%eax
  801698:	78 13                	js     8016ad <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80169a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016a1:	00 
  8016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a5:	89 04 24             	mov    %eax,(%esp)
  8016a8:	e8 3f ff ff ff       	call   8015ec <fd_close>
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 18             	sub    $0x18,%esp
  8016b5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016b8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016c2:	00 
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 04 24             	mov    %eax,(%esp)
  8016c9:	e8 25 04 00 00       	call   801af3 <open>
  8016ce:	89 c3                	mov    %eax,%ebx
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	78 1b                	js     8016ef <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016db:	89 1c 24             	mov    %ebx,(%esp)
  8016de:	e8 b0 fc ff ff       	call   801393 <fstat>
  8016e3:	89 c6                	mov    %eax,%esi
	close(fd);
  8016e5:	89 1c 24             	mov    %ebx,(%esp)
  8016e8:	e8 91 ff ff ff       	call   80167e <close>
  8016ed:	89 f3                	mov    %esi,%ebx
	return r;
}
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016f4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016f7:	89 ec                	mov    %ebp,%esp
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    

008016fb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 14             	sub    $0x14,%esp
  801702:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 6f ff ff ff       	call   80167e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80170f:	83 c3 01             	add    $0x1,%ebx
  801712:	83 fb 20             	cmp    $0x20,%ebx
  801715:	75 f0                	jne    801707 <close_all+0xc>
		close(i);
}
  801717:	83 c4 14             	add    $0x14,%esp
  80171a:	5b                   	pop    %ebx
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    

0080171d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 58             	sub    $0x58,%esp
  801723:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801726:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801729:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80172c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80172f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801732:	89 44 24 04          	mov    %eax,0x4(%esp)
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	89 04 24             	mov    %eax,(%esp)
  80173c:	e8 7f fb ff ff       	call   8012c0 <fd_lookup>
  801741:	89 c3                	mov    %eax,%ebx
  801743:	85 c0                	test   %eax,%eax
  801745:	0f 88 e0 00 00 00    	js     80182b <dup+0x10e>
		return r;
	close(newfdnum);
  80174b:	89 3c 24             	mov    %edi,(%esp)
  80174e:	e8 2b ff ff ff       	call   80167e <close>

	newfd = INDEX2FD(newfdnum);
  801753:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801759:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80175c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80175f:	89 04 24             	mov    %eax,(%esp)
  801762:	e8 e5 fa ff ff       	call   80124c <fd2data>
  801767:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801769:	89 34 24             	mov    %esi,(%esp)
  80176c:	e8 db fa ff ff       	call   80124c <fd2data>
  801771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801774:	89 da                	mov    %ebx,%edx
  801776:	89 d8                	mov    %ebx,%eax
  801778:	c1 e8 16             	shr    $0x16,%eax
  80177b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801782:	a8 01                	test   $0x1,%al
  801784:	74 43                	je     8017c9 <dup+0xac>
  801786:	c1 ea 0c             	shr    $0xc,%edx
  801789:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801790:	a8 01                	test   $0x1,%al
  801792:	74 35                	je     8017c9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801794:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80179b:	25 07 0e 00 00       	and    $0xe07,%eax
  8017a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b2:	00 
  8017b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017be:	e8 9d f7 ff ff       	call   800f60 <sys_page_map>
  8017c3:	89 c3                	mov    %eax,%ebx
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 3f                	js     801808 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017cc:	89 c2                	mov    %eax,%edx
  8017ce:	c1 ea 0c             	shr    $0xc,%edx
  8017d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017d8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017de:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017ed:	00 
  8017ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f9:	e8 62 f7 ff ff       	call   800f60 <sys_page_map>
  8017fe:	89 c3                	mov    %eax,%ebx
  801800:	85 c0                	test   %eax,%eax
  801802:	78 04                	js     801808 <dup+0xeb>
  801804:	89 fb                	mov    %edi,%ebx
  801806:	eb 23                	jmp    80182b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801808:	89 74 24 04          	mov    %esi,0x4(%esp)
  80180c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801813:	e8 ea f6 ff ff       	call   800f02 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80181b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801826:	e8 d7 f6 ff ff       	call   800f02 <sys_page_unmap>
	return r;
}
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801830:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801833:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801836:	89 ec                	mov    %ebp,%esp
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    
	...

0080183c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	83 ec 10             	sub    $0x10,%esp
  801844:	89 c3                	mov    %eax,%ebx
  801846:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801848:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80184f:	75 11                	jne    801862 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801851:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801858:	e8 0f 0f 00 00       	call   80276c <ipc_find_env>
  80185d:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801862:	a1 08 50 80 00       	mov    0x805008,%eax
  801867:	8b 40 48             	mov    0x48(%eax),%eax
  80186a:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801870:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801874:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187c:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  801883:	e8 91 e9 ff ff       	call   800219 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801888:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80188f:	00 
  801890:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801897:	00 
  801898:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80189c:	a1 00 50 80 00       	mov    0x805000,%eax
  8018a1:	89 04 24             	mov    %eax,(%esp)
  8018a4:	e8 f9 0e 00 00       	call   8027a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018b0:	00 
  8018b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018bc:	e8 4d 0f 00 00       	call   80280e <ipc_recv>
}
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	5b                   	pop    %ebx
  8018c5:	5e                   	pop    %esi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    

008018c8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dc:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8018eb:	e8 4c ff ff ff       	call   80183c <fsipc>
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fe:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801903:	ba 00 00 00 00       	mov    $0x0,%edx
  801908:	b8 06 00 00 00       	mov    $0x6,%eax
  80190d:	e8 2a ff ff ff       	call   80183c <fsipc>
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80191a:	ba 00 00 00 00       	mov    $0x0,%edx
  80191f:	b8 08 00 00 00       	mov    $0x8,%eax
  801924:	e8 13 ff ff ff       	call   80183c <fsipc>
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	53                   	push   %ebx
  80192f:	83 ec 14             	sub    $0x14,%esp
  801932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
  80193b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801940:	ba 00 00 00 00       	mov    $0x0,%edx
  801945:	b8 05 00 00 00       	mov    $0x5,%eax
  80194a:	e8 ed fe ff ff       	call   80183c <fsipc>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 2b                	js     80197e <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801953:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80195a:	00 
  80195b:	89 1c 24             	mov    %ebx,(%esp)
  80195e:	e8 16 ef ff ff       	call   800879 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801963:	a1 80 60 80 00       	mov    0x806080,%eax
  801968:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80196e:	a1 84 60 80 00       	mov    0x806084,%eax
  801973:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80197e:	83 c4 14             	add    $0x14,%esp
  801981:	5b                   	pop    %ebx
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    

00801984 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	53                   	push   %ebx
  801988:	83 ec 14             	sub    $0x14,%esp
  80198b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	8b 40 0c             	mov    0xc(%eax),%eax
  801994:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801999:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  80199f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8019a5:	76 24                	jbe    8019cb <devfile_write+0x47>
  8019a7:	c7 44 24 0c 7a 2f 80 	movl   $0x802f7a,0xc(%esp)
  8019ae:	00 
  8019af:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  8019b6:	00 
  8019b7:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  8019be:	00 
  8019bf:	c7 04 24 99 2f 80 00 	movl   $0x802f99,(%esp)
  8019c6:	e8 49 0d 00 00       	call   802714 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  8019cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d6:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8019dd:	e8 3d f0 ff ff       	call   800a1f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  8019e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8019ec:	e8 4b fe ff ff       	call   80183c <fsipc>
	if(ret<0) return ret;
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 53                	js     801a48 <devfile_write+0xc4>
	
	assert(ret <= n);
  8019f5:	39 c3                	cmp    %eax,%ebx
  8019f7:	73 24                	jae    801a1d <devfile_write+0x99>
  8019f9:	c7 44 24 0c a4 2f 80 	movl   $0x802fa4,0xc(%esp)
  801a00:	00 
  801a01:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  801a08:	00 
  801a09:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801a10:	00 
  801a11:	c7 04 24 99 2f 80 00 	movl   $0x802f99,(%esp)
  801a18:	e8 f7 0c 00 00       	call   802714 <_panic>
	assert(ret <= PGSIZE);
  801a1d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a22:	7e 24                	jle    801a48 <devfile_write+0xc4>
  801a24:	c7 44 24 0c ad 2f 80 	movl   $0x802fad,0xc(%esp)
  801a2b:	00 
  801a2c:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  801a33:	00 
  801a34:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801a3b:	00 
  801a3c:	c7 04 24 99 2f 80 00 	movl   $0x802f99,(%esp)
  801a43:	e8 cc 0c 00 00       	call   802714 <_panic>
	return ret;
}
  801a48:	83 c4 14             	add    $0x14,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    

00801a4e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	56                   	push   %esi
  801a52:	53                   	push   %ebx
  801a53:	83 ec 10             	sub    $0x10,%esp
  801a56:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a64:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6f:	b8 03 00 00 00       	mov    $0x3,%eax
  801a74:	e8 c3 fd ff ff       	call   80183c <fsipc>
  801a79:	89 c3                	mov    %eax,%ebx
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 6b                	js     801aea <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801a7f:	39 de                	cmp    %ebx,%esi
  801a81:	73 24                	jae    801aa7 <devfile_read+0x59>
  801a83:	c7 44 24 0c bb 2f 80 	movl   $0x802fbb,0xc(%esp)
  801a8a:	00 
  801a8b:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  801a92:	00 
  801a93:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a9a:	00 
  801a9b:	c7 04 24 99 2f 80 00 	movl   $0x802f99,(%esp)
  801aa2:	e8 6d 0c 00 00       	call   802714 <_panic>
	assert(r <= PGSIZE);
  801aa7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801aad:	7e 24                	jle    801ad3 <devfile_read+0x85>
  801aaf:	c7 44 24 0c c2 2f 80 	movl   $0x802fc2,0xc(%esp)
  801ab6:	00 
  801ab7:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  801abe:	00 
  801abf:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ac6:	00 
  801ac7:	c7 04 24 99 2f 80 00 	movl   $0x802f99,(%esp)
  801ace:	e8 41 0c 00 00       	call   802714 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ad7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ade:	00 
  801adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae2:	89 04 24             	mov    %eax,(%esp)
  801ae5:	e8 35 ef ff ff       	call   800a1f <memmove>
	return r;
}
  801aea:	89 d8                	mov    %ebx,%eax
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 28             	sub    $0x28,%esp
  801af9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801afc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801aff:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b02:	89 34 24             	mov    %esi,(%esp)
  801b05:	e8 36 ed ff ff       	call   800840 <strlen>
  801b0a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b0f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b14:	7f 5e                	jg     801b74 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b19:	89 04 24             	mov    %eax,(%esp)
  801b1c:	e8 46 f7 ff ff       	call   801267 <fd_alloc>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 4d                	js     801b74 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b27:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2b:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801b32:	e8 42 ed ff ff       	call   800879 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b42:	b8 01 00 00 00       	mov    $0x1,%eax
  801b47:	e8 f0 fc ff ff       	call   80183c <fsipc>
  801b4c:	89 c3                	mov    %eax,%ebx
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	79 15                	jns    801b67 <open+0x74>
		fd_close(fd, 0);
  801b52:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b59:	00 
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	89 04 24             	mov    %eax,(%esp)
  801b60:	e8 87 fa ff ff       	call   8015ec <fd_close>
		return r;
  801b65:	eb 0d                	jmp    801b74 <open+0x81>
	}

	return fd2num(fd);
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	89 04 24             	mov    %eax,(%esp)
  801b6d:	e8 ca f6 ff ff       	call   80123c <fd2num>
  801b72:	89 c3                	mov    %eax,%ebx
}
  801b74:	89 d8                	mov    %ebx,%eax
  801b76:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b79:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b7c:	89 ec                	mov    %ebp,%esp
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    

00801b80 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 14             	sub    $0x14,%esp
  801b87:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b89:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b8d:	7e 31                	jle    801bc0 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b8f:	8b 40 04             	mov    0x4(%eax),%eax
  801b92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b96:	8d 43 10             	lea    0x10(%ebx),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	8b 03                	mov    (%ebx),%eax
  801b9f:	89 04 24             	mov    %eax,(%esp)
  801ba2:	e8 e7 f8 ff ff       	call   80148e <write>
		if (result > 0)
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	7e 03                	jle    801bae <writebuf+0x2e>
			b->result += result;
  801bab:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801bae:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bb1:	74 0d                	je     801bc0 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bba:	0f 4f c2             	cmovg  %edx,%eax
  801bbd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bc0:	83 c4 14             	add    $0x14,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    

00801bc6 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801bd8:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801bdf:	00 00 00 
	b.result = 0;
  801be2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801be9:	00 00 00 
	b.error = 1;
  801bec:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bf3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c04:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0e:	c7 04 24 82 1c 80 00 	movl   $0x801c82,(%esp)
  801c15:	e8 9d e7 ff ff       	call   8003b7 <vprintfmt>
	if (b.idx > 0)
  801c1a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c21:	7e 0b                	jle    801c2e <vfprintf+0x68>
		writebuf(&b);
  801c23:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c29:	e8 52 ff ff ff       	call   801b80 <writebuf>

	return (b.result ? b.result : b.error);
  801c2e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c34:	85 c0                	test   %eax,%eax
  801c36:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801c45:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801c48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c5a:	e8 67 ff ff ff       	call   801bc6 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801c67:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	89 04 24             	mov    %eax,(%esp)
  801c7b:	e8 46 ff ff ff       	call   801bc6 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	53                   	push   %ebx
  801c86:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c8c:	8b 43 04             	mov    0x4(%ebx),%eax
  801c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c92:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c96:	83 c0 01             	add    $0x1,%eax
  801c99:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c9c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ca1:	75 0e                	jne    801cb1 <putch+0x2f>
		writebuf(b);
  801ca3:	89 d8                	mov    %ebx,%eax
  801ca5:	e8 d6 fe ff ff       	call   801b80 <writebuf>
		b->idx = 0;
  801caa:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801cb1:	83 c4 04             	add    $0x4,%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
	...

00801cc0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801cc6:	c7 44 24 04 ce 2f 80 	movl   $0x802fce,0x4(%esp)
  801ccd:	00 
  801cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 a0 eb ff ff       	call   800879 <strcpy>
	return 0;
}
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 14             	sub    $0x14,%esp
  801ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cea:	89 1c 24             	mov    %ebx,(%esp)
  801ced:	e8 a6 0b 00 00       	call   802898 <pageref>
  801cf2:	89 c2                	mov    %eax,%edx
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	83 fa 01             	cmp    $0x1,%edx
  801cfc:	75 0b                	jne    801d09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cfe:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d01:	89 04 24             	mov    %eax,(%esp)
  801d04:	e8 b1 02 00 00       	call   801fba <nsipc_close>
	else
		return 0;
}
  801d09:	83 c4 14             	add    $0x14,%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    

00801d0f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d15:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d1c:	00 
  801d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d31:	89 04 24             	mov    %eax,(%esp)
  801d34:	e8 bd 02 00 00       	call   801ff6 <nsipc_send>
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d41:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d48:	00 
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5d:	89 04 24             	mov    %eax,(%esp)
  801d60:	e8 04 03 00 00       	call   802069 <nsipc_recv>
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 20             	sub    $0x20,%esp
  801d6f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d74:	89 04 24             	mov    %eax,(%esp)
  801d77:	e8 eb f4 ff ff       	call   801267 <fd_alloc>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 21                	js     801da3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d89:	00 
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d98:	e8 21 f2 ff ff       	call   800fbe <sys_page_alloc>
  801d9d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	79 0a                	jns    801dad <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801da3:	89 34 24             	mov    %esi,(%esp)
  801da6:	e8 0f 02 00 00       	call   801fba <nsipc_close>
		return r;
  801dab:	eb 28                	jmp    801dd5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801dad:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	89 04 24             	mov    %eax,(%esp)
  801dce:	e8 69 f4 ff ff       	call   80123c <fd2num>
  801dd3:	89 c3                	mov    %eax,%ebx
}
  801dd5:	89 d8                	mov    %ebx,%eax
  801dd7:	83 c4 20             	add    $0x20,%esp
  801dda:	5b                   	pop    %ebx
  801ddb:	5e                   	pop    %esi
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    

00801dde <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801de4:	8b 45 10             	mov    0x10(%ebp),%eax
  801de7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	89 04 24             	mov    %eax,(%esp)
  801df8:	e8 71 01 00 00       	call   801f6e <nsipc_socket>
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 05                	js     801e06 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801e01:	e8 61 ff ff ff       	call   801d67 <alloc_sockfd>
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e0e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e11:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e15:	89 04 24             	mov    %eax,(%esp)
  801e18:	e8 a3 f4 ff ff       	call   8012c0 <fd_lookup>
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 15                	js     801e36 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	8b 0a                	mov    (%edx),%ecx
  801e26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e2b:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  801e31:	75 03                	jne    801e36 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e33:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	e8 c2 ff ff ff       	call   801e08 <fd2sockid>
  801e46:	85 c0                	test   %eax,%eax
  801e48:	78 0f                	js     801e59 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e51:	89 04 24             	mov    %eax,(%esp)
  801e54:	e8 3f 01 00 00       	call   801f98 <nsipc_listen>
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	e8 9f ff ff ff       	call   801e08 <fd2sockid>
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 16                	js     801e83 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801e6d:	8b 55 10             	mov    0x10(%ebp),%edx
  801e70:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e77:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e7b:	89 04 24             	mov    %eax,(%esp)
  801e7e:	e8 66 02 00 00       	call   8020e9 <nsipc_connect>
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	e8 75 ff ff ff       	call   801e08 <fd2sockid>
  801e93:	85 c0                	test   %eax,%eax
  801e95:	78 0f                	js     801ea6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e9e:	89 04 24             	mov    %eax,(%esp)
  801ea1:	e8 2e 01 00 00       	call   801fd4 <nsipc_shutdown>
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	e8 52 ff ff ff       	call   801e08 <fd2sockid>
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 16                	js     801ed0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801eba:	8b 55 10             	mov    0x10(%ebp),%edx
  801ebd:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec8:	89 04 24             	mov    %eax,(%esp)
  801ecb:	e8 58 02 00 00       	call   802128 <nsipc_bind>
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	e8 28 ff ff ff       	call   801e08 <fd2sockid>
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	78 1f                	js     801f03 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ee4:	8b 55 10             	mov    0x10(%ebp),%edx
  801ee7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ef2:	89 04 24             	mov    %eax,(%esp)
  801ef5:	e8 6d 02 00 00       	call   802167 <nsipc_accept>
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 05                	js     801f03 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801efe:	e8 64 fe ff ff       	call   801d67 <alloc_sockfd>
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    
  801f05:	00 00                	add    %al,(%eax)
	...

00801f08 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 14             	sub    $0x14,%esp
  801f0f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f11:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f18:	75 11                	jne    801f2b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f21:	e8 46 08 00 00       	call   80276c <ipc_find_env>
  801f26:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f2b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f32:	00 
  801f33:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801f3a:	00 
  801f3b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f3f:	a1 04 50 80 00       	mov    0x805004,%eax
  801f44:	89 04 24             	mov    %eax,(%esp)
  801f47:	e8 56 08 00 00       	call   8027a2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f53:	00 
  801f54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f5b:	00 
  801f5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f63:	e8 a6 08 00 00       	call   80280e <ipc_recv>
}
  801f68:	83 c4 14             	add    $0x14,%esp
  801f6b:	5b                   	pop    %ebx
  801f6c:	5d                   	pop    %ebp
  801f6d:	c3                   	ret    

00801f6e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801f84:	8b 45 10             	mov    0x10(%ebp),%eax
  801f87:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801f8c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f91:	e8 72 ff ff ff       	call   801f08 <nsipc>
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801fae:	b8 06 00 00 00       	mov    $0x6,%eax
  801fb3:	e8 50 ff ff ff       	call   801f08 <nsipc>
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801fc8:	b8 04 00 00 00       	mov    $0x4,%eax
  801fcd:	e8 36 ff ff ff       	call   801f08 <nsipc>
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801fea:	b8 03 00 00 00       	mov    $0x3,%eax
  801fef:	e8 14 ff ff ff       	call   801f08 <nsipc>
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 14             	sub    $0x14,%esp
  801ffd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802008:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80200e:	7e 24                	jle    802034 <nsipc_send+0x3e>
  802010:	c7 44 24 0c da 2f 80 	movl   $0x802fda,0xc(%esp)
  802017:	00 
  802018:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  80201f:	00 
  802020:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802027:	00 
  802028:	c7 04 24 e6 2f 80 00 	movl   $0x802fe6,(%esp)
  80202f:	e8 e0 06 00 00       	call   802714 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802034:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802046:	e8 d4 e9 ff ff       	call   800a1f <memmove>
	nsipcbuf.send.req_size = size;
  80204b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802051:	8b 45 14             	mov    0x14(%ebp),%eax
  802054:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802059:	b8 08 00 00 00       	mov    $0x8,%eax
  80205e:	e8 a5 fe ff ff       	call   801f08 <nsipc>
}
  802063:	83 c4 14             	add    $0x14,%esp
  802066:	5b                   	pop    %ebx
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	56                   	push   %esi
  80206d:	53                   	push   %ebx
  80206e:	83 ec 10             	sub    $0x10,%esp
  802071:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80207c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802082:	8b 45 14             	mov    0x14(%ebp),%eax
  802085:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80208a:	b8 07 00 00 00       	mov    $0x7,%eax
  80208f:	e8 74 fe ff ff       	call   801f08 <nsipc>
  802094:	89 c3                	mov    %eax,%ebx
  802096:	85 c0                	test   %eax,%eax
  802098:	78 46                	js     8020e0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80209a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80209f:	7f 04                	jg     8020a5 <nsipc_recv+0x3c>
  8020a1:	39 c6                	cmp    %eax,%esi
  8020a3:	7d 24                	jge    8020c9 <nsipc_recv+0x60>
  8020a5:	c7 44 24 0c f2 2f 80 	movl   $0x802ff2,0xc(%esp)
  8020ac:	00 
  8020ad:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  8020b4:	00 
  8020b5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8020bc:	00 
  8020bd:	c7 04 24 e6 2f 80 00 	movl   $0x802fe6,(%esp)
  8020c4:	e8 4b 06 00 00       	call   802714 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020cd:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8020d4:	00 
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	89 04 24             	mov    %eax,(%esp)
  8020db:	e8 3f e9 ff ff       	call   800a1f <memmove>
	}

	return r;
}
  8020e0:	89 d8                	mov    %ebx,%eax
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    

008020e9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	53                   	push   %ebx
  8020ed:	83 ec 14             	sub    $0x14,%esp
  8020f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802102:	89 44 24 04          	mov    %eax,0x4(%esp)
  802106:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80210d:	e8 0d e9 ff ff       	call   800a1f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802112:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802118:	b8 05 00 00 00       	mov    $0x5,%eax
  80211d:	e8 e6 fd ff ff       	call   801f08 <nsipc>
}
  802122:	83 c4 14             	add    $0x14,%esp
  802125:	5b                   	pop    %ebx
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    

00802128 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	53                   	push   %ebx
  80212c:	83 ec 14             	sub    $0x14,%esp
  80212f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80213a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80213e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802141:	89 44 24 04          	mov    %eax,0x4(%esp)
  802145:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80214c:	e8 ce e8 ff ff       	call   800a1f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802151:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802157:	b8 02 00 00 00       	mov    $0x2,%eax
  80215c:	e8 a7 fd ff ff       	call   801f08 <nsipc>
}
  802161:	83 c4 14             	add    $0x14,%esp
  802164:	5b                   	pop    %ebx
  802165:	5d                   	pop    %ebp
  802166:	c3                   	ret    

00802167 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 28             	sub    $0x28,%esp
  80216d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802170:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802173:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802176:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802181:	8b 07                	mov    (%edi),%eax
  802183:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802188:	b8 01 00 00 00       	mov    $0x1,%eax
  80218d:	e8 76 fd ff ff       	call   801f08 <nsipc>
  802192:	89 c6                	mov    %eax,%esi
  802194:	85 c0                	test   %eax,%eax
  802196:	78 22                	js     8021ba <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802198:	bb 10 80 80 00       	mov    $0x808010,%ebx
  80219d:	8b 03                	mov    (%ebx),%eax
  80219f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8021aa:	00 
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	89 04 24             	mov    %eax,(%esp)
  8021b1:	e8 69 e8 ff ff       	call   800a1f <memmove>
		*addrlen = ret->ret_addrlen;
  8021b6:	8b 03                	mov    (%ebx),%eax
  8021b8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8021ba:	89 f0                	mov    %esi,%eax
  8021bc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8021bf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8021c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8021c5:	89 ec                	mov    %ebp,%esp
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    
  8021c9:	00 00                	add    %al,(%eax)
	...

008021cc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 18             	sub    $0x18,%esp
  8021d2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8021d5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8021d8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	89 04 24             	mov    %eax,(%esp)
  8021e1:	e8 66 f0 ff ff       	call   80124c <fd2data>
  8021e6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8021e8:	c7 44 24 04 07 30 80 	movl   $0x803007,0x4(%esp)
  8021ef:	00 
  8021f0:	89 34 24             	mov    %esi,(%esp)
  8021f3:	e8 81 e6 ff ff       	call   800879 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021f8:	8b 43 04             	mov    0x4(%ebx),%eax
  8021fb:	2b 03                	sub    (%ebx),%eax
  8021fd:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802203:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80220a:	00 00 00 
	stat->st_dev = &devpipe;
  80220d:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802214:	40 80 00 
	return 0;
}
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80221f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802222:	89 ec                	mov    %ebp,%esp
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    

00802226 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	53                   	push   %ebx
  80222a:	83 ec 14             	sub    $0x14,%esp
  80222d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802230:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223b:	e8 c2 ec ff ff       	call   800f02 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802240:	89 1c 24             	mov    %ebx,(%esp)
  802243:	e8 04 f0 ff ff       	call   80124c <fd2data>
  802248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802253:	e8 aa ec ff ff       	call   800f02 <sys_page_unmap>
}
  802258:	83 c4 14             	add    $0x14,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	57                   	push   %edi
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	83 ec 2c             	sub    $0x2c,%esp
  802267:	89 c7                	mov    %eax,%edi
  802269:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80226c:	a1 08 50 80 00       	mov    0x805008,%eax
  802271:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802274:	89 3c 24             	mov    %edi,(%esp)
  802277:	e8 1c 06 00 00       	call   802898 <pageref>
  80227c:	89 c6                	mov    %eax,%esi
  80227e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802281:	89 04 24             	mov    %eax,(%esp)
  802284:	e8 0f 06 00 00       	call   802898 <pageref>
  802289:	39 c6                	cmp    %eax,%esi
  80228b:	0f 94 c0             	sete   %al
  80228e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802291:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802297:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80229a:	39 cb                	cmp    %ecx,%ebx
  80229c:	75 08                	jne    8022a6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80229e:	83 c4 2c             	add    $0x2c,%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8022a6:	83 f8 01             	cmp    $0x1,%eax
  8022a9:	75 c1                	jne    80226c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022ab:	8b 52 58             	mov    0x58(%edx),%edx
  8022ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022ba:	c7 04 24 0e 30 80 00 	movl   $0x80300e,(%esp)
  8022c1:	e8 53 df ff ff       	call   800219 <cprintf>
  8022c6:	eb a4                	jmp    80226c <_pipeisclosed+0xe>

008022c8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	57                   	push   %edi
  8022cc:	56                   	push   %esi
  8022cd:	53                   	push   %ebx
  8022ce:	83 ec 1c             	sub    $0x1c,%esp
  8022d1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022d4:	89 34 24             	mov    %esi,(%esp)
  8022d7:	e8 70 ef ff ff       	call   80124c <fd2data>
  8022dc:	89 c3                	mov    %eax,%ebx
  8022de:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022e3:	eb 48                	jmp    80232d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022e5:	89 da                	mov    %ebx,%edx
  8022e7:	89 f0                	mov    %esi,%eax
  8022e9:	e8 70 ff ff ff       	call   80225e <_pipeisclosed>
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 07                	je     8022f9 <devpipe_write+0x31>
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	eb 3b                	jmp    802334 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022f9:	e8 1f ed ff ff       	call   80101d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022fe:	8b 43 04             	mov    0x4(%ebx),%eax
  802301:	8b 13                	mov    (%ebx),%edx
  802303:	83 c2 20             	add    $0x20,%edx
  802306:	39 d0                	cmp    %edx,%eax
  802308:	73 db                	jae    8022e5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80230a:	89 c2                	mov    %eax,%edx
  80230c:	c1 fa 1f             	sar    $0x1f,%edx
  80230f:	c1 ea 1b             	shr    $0x1b,%edx
  802312:	01 d0                	add    %edx,%eax
  802314:	83 e0 1f             	and    $0x1f,%eax
  802317:	29 d0                	sub    %edx,%eax
  802319:	89 c2                	mov    %eax,%edx
  80231b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80231e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802322:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802326:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80232a:	83 c7 01             	add    $0x1,%edi
  80232d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802330:	72 cc                	jb     8022fe <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802332:	89 f8                	mov    %edi,%eax
}
  802334:	83 c4 1c             	add    $0x1c,%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 28             	sub    $0x28,%esp
  802342:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802345:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802348:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80234b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80234e:	89 3c 24             	mov    %edi,(%esp)
  802351:	e8 f6 ee ff ff       	call   80124c <fd2data>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80235d:	eb 48                	jmp    8023a7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80235f:	85 f6                	test   %esi,%esi
  802361:	74 04                	je     802367 <devpipe_read+0x2b>
				return i;
  802363:	89 f0                	mov    %esi,%eax
  802365:	eb 47                	jmp    8023ae <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802367:	89 da                	mov    %ebx,%edx
  802369:	89 f8                	mov    %edi,%eax
  80236b:	e8 ee fe ff ff       	call   80225e <_pipeisclosed>
  802370:	85 c0                	test   %eax,%eax
  802372:	74 07                	je     80237b <devpipe_read+0x3f>
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	eb 33                	jmp    8023ae <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80237b:	e8 9d ec ff ff       	call   80101d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802380:	8b 03                	mov    (%ebx),%eax
  802382:	3b 43 04             	cmp    0x4(%ebx),%eax
  802385:	74 d8                	je     80235f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802387:	89 c2                	mov    %eax,%edx
  802389:	c1 fa 1f             	sar    $0x1f,%edx
  80238c:	c1 ea 1b             	shr    $0x1b,%edx
  80238f:	01 d0                	add    %edx,%eax
  802391:	83 e0 1f             	and    $0x1f,%eax
  802394:	29 d0                	sub    %edx,%eax
  802396:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80239b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8023a1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023a4:	83 c6 01             	add    $0x1,%esi
  8023a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023aa:	72 d4                	jb     802380 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023ac:	89 f0                	mov    %esi,%eax
}
  8023ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023b7:	89 ec                	mov    %ebp,%esp
  8023b9:	5d                   	pop    %ebp
  8023ba:	c3                   	ret    

008023bb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	89 04 24             	mov    %eax,(%esp)
  8023ce:	e8 ed ee ff ff       	call   8012c0 <fd_lookup>
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	78 15                	js     8023ec <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	89 04 24             	mov    %eax,(%esp)
  8023dd:	e8 6a ee ff ff       	call   80124c <fd2data>
	return _pipeisclosed(fd, p);
  8023e2:	89 c2                	mov    %eax,%edx
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	e8 72 fe ff ff       	call   80225e <_pipeisclosed>
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 48             	sub    $0x48,%esp
  8023f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802400:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802403:	89 04 24             	mov    %eax,(%esp)
  802406:	e8 5c ee ff ff       	call   801267 <fd_alloc>
  80240b:	89 c3                	mov    %eax,%ebx
  80240d:	85 c0                	test   %eax,%eax
  80240f:	0f 88 42 01 00 00    	js     802557 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802415:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80241c:	00 
  80241d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802420:	89 44 24 04          	mov    %eax,0x4(%esp)
  802424:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242b:	e8 8e eb ff ff       	call   800fbe <sys_page_alloc>
  802430:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 88 1d 01 00 00    	js     802557 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80243a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80243d:	89 04 24             	mov    %eax,(%esp)
  802440:	e8 22 ee ff ff       	call   801267 <fd_alloc>
  802445:	89 c3                	mov    %eax,%ebx
  802447:	85 c0                	test   %eax,%eax
  802449:	0f 88 f5 00 00 00    	js     802544 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802456:	00 
  802457:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802465:	e8 54 eb ff ff       	call   800fbe <sys_page_alloc>
  80246a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80246c:	85 c0                	test   %eax,%eax
  80246e:	0f 88 d0 00 00 00    	js     802544 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802477:	89 04 24             	mov    %eax,(%esp)
  80247a:	e8 cd ed ff ff       	call   80124c <fd2data>
  80247f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802481:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802488:	00 
  802489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802494:	e8 25 eb ff ff       	call   800fbe <sys_page_alloc>
  802499:	89 c3                	mov    %eax,%ebx
  80249b:	85 c0                	test   %eax,%eax
  80249d:	0f 88 8e 00 00 00    	js     802531 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a6:	89 04 24             	mov    %eax,(%esp)
  8024a9:	e8 9e ed ff ff       	call   80124c <fd2data>
  8024ae:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024b5:	00 
  8024b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024c1:	00 
  8024c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024cd:	e8 8e ea ff ff       	call   800f60 <sys_page_map>
  8024d2:	89 c3                	mov    %eax,%ebx
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 49                	js     802521 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024d8:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  8024dd:	8b 08                	mov    (%eax),%ecx
  8024df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024e2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024e7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8024ee:	8b 10                	mov    (%eax),%edx
  8024f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8024ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802502:	89 04 24             	mov    %eax,(%esp)
  802505:	e8 32 ed ff ff       	call   80123c <fd2num>
  80250a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80250c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80250f:	89 04 24             	mov    %eax,(%esp)
  802512:	e8 25 ed ff ff       	call   80123c <fd2num>
  802517:	89 47 04             	mov    %eax,0x4(%edi)
  80251a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80251f:	eb 36                	jmp    802557 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802521:	89 74 24 04          	mov    %esi,0x4(%esp)
  802525:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80252c:	e8 d1 e9 ff ff       	call   800f02 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802531:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802534:	89 44 24 04          	mov    %eax,0x4(%esp)
  802538:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80253f:	e8 be e9 ff ff       	call   800f02 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802547:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802552:	e8 ab e9 ff ff       	call   800f02 <sys_page_unmap>
    err:
	return r;
}
  802557:	89 d8                	mov    %ebx,%eax
  802559:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80255c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80255f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802562:	89 ec                	mov    %ebp,%esp
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
	...

00802570 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	5d                   	pop    %ebp
  802579:	c3                   	ret    

0080257a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802580:	c7 44 24 04 26 30 80 	movl   $0x803026,0x4(%esp)
  802587:	00 
  802588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258b:	89 04 24             	mov    %eax,(%esp)
  80258e:	e8 e6 e2 ff ff       	call   800879 <strcpy>
	return 0;
}
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	57                   	push   %edi
  80259e:	56                   	push   %esi
  80259f:	53                   	push   %ebx
  8025a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8025a6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025b1:	eb 34                	jmp    8025e7 <devcons_write+0x4d>
		m = n - tot;
  8025b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025b6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8025b8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8025be:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8025c3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025c6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025ca:	03 45 0c             	add    0xc(%ebp),%eax
  8025cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d1:	89 3c 24             	mov    %edi,(%esp)
  8025d4:	e8 46 e4 ff ff       	call   800a1f <memmove>
		sys_cputs(buf, m);
  8025d9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025dd:	89 3c 24             	mov    %edi,(%esp)
  8025e0:	e8 4b e6 ff ff       	call   800c30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e5:	01 de                	add    %ebx,%esi
  8025e7:	89 f0                	mov    %esi,%eax
  8025e9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ec:	72 c5                	jb     8025b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025ee:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025f4:	5b                   	pop    %ebx
  8025f5:	5e                   	pop    %esi
  8025f6:	5f                   	pop    %edi
  8025f7:	5d                   	pop    %ebp
  8025f8:	c3                   	ret    

008025f9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802605:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80260c:	00 
  80260d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802610:	89 04 24             	mov    %eax,(%esp)
  802613:	e8 18 e6 ff ff       	call   800c30 <sys_cputs>
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802620:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802624:	75 07                	jne    80262d <devcons_read+0x13>
  802626:	eb 28                	jmp    802650 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802628:	e8 f0 e9 ff ff       	call   80101d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80262d:	8d 76 00             	lea    0x0(%esi),%esi
  802630:	e8 c7 e5 ff ff       	call   800bfc <sys_cgetc>
  802635:	85 c0                	test   %eax,%eax
  802637:	74 ef                	je     802628 <devcons_read+0xe>
  802639:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80263b:	85 c0                	test   %eax,%eax
  80263d:	78 16                	js     802655 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80263f:	83 f8 04             	cmp    $0x4,%eax
  802642:	74 0c                	je     802650 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802644:	8b 45 0c             	mov    0xc(%ebp),%eax
  802647:	88 10                	mov    %dl,(%eax)
  802649:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80264e:	eb 05                	jmp    802655 <devcons_read+0x3b>
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80265d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802660:	89 04 24             	mov    %eax,(%esp)
  802663:	e8 ff eb ff ff       	call   801267 <fd_alloc>
  802668:	85 c0                	test   %eax,%eax
  80266a:	78 3f                	js     8026ab <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80266c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802673:	00 
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80267b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802682:	e8 37 e9 ff ff       	call   800fbe <sys_page_alloc>
  802687:	85 c0                	test   %eax,%eax
  802689:	78 20                	js     8026ab <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80268b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	89 04 24             	mov    %eax,(%esp)
  8026a6:	e8 91 eb ff ff       	call   80123c <fd2num>
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	89 04 24             	mov    %eax,(%esp)
  8026c0:	e8 fb eb ff ff       	call   8012c0 <fd_lookup>
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	78 11                	js     8026da <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  8026d4:	0f 94 c0             	sete   %al
  8026d7:	0f b6 c0             	movzbl %al,%eax
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026e9:	00 
  8026ea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f8:	e8 1a ee ff ff       	call   801517 <read>
	if (r < 0)
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	78 0f                	js     802710 <getchar+0x34>
		return r;
	if (r < 1)
  802701:	85 c0                	test   %eax,%eax
  802703:	7f 07                	jg     80270c <getchar+0x30>
  802705:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80270a:	eb 04                	jmp    802710 <getchar+0x34>
		return -E_EOF;
	return c;
  80270c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    
	...

00802714 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
  802719:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80271c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80271f:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  802725:	e8 27 e9 ff ff       	call   801051 <sys_getenvid>
  80272a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272d:	89 54 24 10          	mov    %edx,0x10(%esp)
  802731:	8b 55 08             	mov    0x8(%ebp),%edx
  802734:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802738:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80273c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802740:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  802747:	e8 cd da ff ff       	call   800219 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80274c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802750:	8b 45 10             	mov    0x10(%ebp),%eax
  802753:	89 04 24             	mov    %eax,(%esp)
  802756:	e8 5d da ff ff       	call   8001b8 <vcprintf>
	cprintf("\n");
  80275b:	c7 04 24 70 2b 80 00 	movl   $0x802b70,(%esp)
  802762:	e8 b2 da ff ff       	call   800219 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802767:	cc                   	int3   
  802768:	eb fd                	jmp    802767 <_panic+0x53>
	...

0080276c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802772:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802777:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80277a:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802780:	8b 12                	mov    (%edx),%edx
  802782:	39 ca                	cmp    %ecx,%edx
  802784:	75 0c                	jne    802792 <ipc_find_env+0x26>
			return envs[i].env_id;
  802786:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802789:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	eb 0e                	jmp    8027a0 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802792:	83 c0 01             	add    $0x1,%eax
  802795:	3d 00 04 00 00       	cmp    $0x400,%eax
  80279a:	75 db                	jne    802777 <ipc_find_env+0xb>
  80279c:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8027a0:	5d                   	pop    %ebp
  8027a1:	c3                   	ret    

008027a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
  8027a5:	57                   	push   %edi
  8027a6:	56                   	push   %esi
  8027a7:	53                   	push   %ebx
  8027a8:	83 ec 2c             	sub    $0x2c,%esp
  8027ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8027ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8027b4:	85 db                	test   %ebx,%ebx
  8027b6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027bb:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8027be:	8b 45 14             	mov    0x14(%ebp),%eax
  8027c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027c5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027cd:	89 34 24             	mov    %esi,(%esp)
  8027d0:	e8 db e5 ff ff       	call   800db0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8027d5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027d8:	74 e4                	je     8027be <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	74 28                	je     802806 <ipc_send+0x64>
  8027de:	89 44 24 10          	mov    %eax,0x10(%esp)
  8027e2:	c7 44 24 0c 75 30 80 	movl   $0x803075,0xc(%esp)
  8027e9:	00 
  8027ea:	c7 44 24 08 58 30 80 	movl   $0x803058,0x8(%esp)
  8027f1:	00 
  8027f2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8027f9:	00 
  8027fa:	c7 04 24 6b 30 80 00 	movl   $0x80306b,(%esp)
  802801:	e8 0e ff ff ff       	call   802714 <_panic>
	//if(!ret) sys_yield();
}
  802806:	83 c4 2c             	add    $0x2c,%esp
  802809:	5b                   	pop    %ebx
  80280a:	5e                   	pop    %esi
  80280b:	5f                   	pop    %edi
  80280c:	5d                   	pop    %ebp
  80280d:	c3                   	ret    

0080280e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 28             	sub    $0x28,%esp
  802814:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802817:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80281a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80281d:	8b 75 08             	mov    0x8(%ebp),%esi
  802820:	8b 45 0c             	mov    0xc(%ebp),%eax
  802823:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802826:	85 c0                	test   %eax,%eax
  802828:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80282d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802830:	89 04 24             	mov    %eax,(%esp)
  802833:	e8 1b e5 ff ff       	call   800d53 <sys_ipc_recv>
  802838:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80283a:	e8 12 e8 ff ff       	call   801051 <sys_getenvid>
  80283f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802844:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802847:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80284c:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802851:	85 f6                	test   %esi,%esi
  802853:	74 0e                	je     802863 <ipc_recv+0x55>
  802855:	ba 00 00 00 00       	mov    $0x0,%edx
  80285a:	85 db                	test   %ebx,%ebx
  80285c:	75 03                	jne    802861 <ipc_recv+0x53>
  80285e:	8b 50 74             	mov    0x74(%eax),%edx
  802861:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802863:	85 ff                	test   %edi,%edi
  802865:	74 13                	je     80287a <ipc_recv+0x6c>
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
  80286c:	85 db                	test   %ebx,%ebx
  80286e:	75 08                	jne    802878 <ipc_recv+0x6a>
  802870:	a1 08 50 80 00       	mov    0x805008,%eax
  802875:	8b 40 78             	mov    0x78(%eax),%eax
  802878:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  80287a:	85 db                	test   %ebx,%ebx
  80287c:	75 08                	jne    802886 <ipc_recv+0x78>
  80287e:	a1 08 50 80 00       	mov    0x805008,%eax
  802883:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802886:	89 d8                	mov    %ebx,%eax
  802888:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80288b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80288e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802891:	89 ec                	mov    %ebp,%esp
  802893:	5d                   	pop    %ebp
  802894:	c3                   	ret    
  802895:	00 00                	add    %al,(%eax)
	...

00802898 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	89 c2                	mov    %eax,%edx
  8028a0:	c1 ea 16             	shr    $0x16,%edx
  8028a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8028aa:	f6 c2 01             	test   $0x1,%dl
  8028ad:	74 20                	je     8028cf <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028af:	c1 e8 0c             	shr    $0xc,%eax
  8028b2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8028b9:	a8 01                	test   $0x1,%al
  8028bb:	74 12                	je     8028cf <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028bd:	c1 e8 0c             	shr    $0xc,%eax
  8028c0:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8028c5:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  8028ca:	0f b7 c0             	movzwl %ax,%eax
  8028cd:	eb 05                	jmp    8028d4 <pageref+0x3c>
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d4:	5d                   	pop    %ebp
  8028d5:	c3                   	ret    
	...

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	57                   	push   %edi
  8028e4:	56                   	push   %esi
  8028e5:	83 ec 10             	sub    $0x10,%esp
  8028e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8028eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ee:	8b 75 10             	mov    0x10(%ebp),%esi
  8028f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8028f9:	75 35                	jne    802930 <__udivdi3+0x50>
  8028fb:	39 fe                	cmp    %edi,%esi
  8028fd:	77 61                	ja     802960 <__udivdi3+0x80>
  8028ff:	85 f6                	test   %esi,%esi
  802901:	75 0b                	jne    80290e <__udivdi3+0x2e>
  802903:	b8 01 00 00 00       	mov    $0x1,%eax
  802908:	31 d2                	xor    %edx,%edx
  80290a:	f7 f6                	div    %esi
  80290c:	89 c6                	mov    %eax,%esi
  80290e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802911:	31 d2                	xor    %edx,%edx
  802913:	89 f8                	mov    %edi,%eax
  802915:	f7 f6                	div    %esi
  802917:	89 c7                	mov    %eax,%edi
  802919:	89 c8                	mov    %ecx,%eax
  80291b:	f7 f6                	div    %esi
  80291d:	89 c1                	mov    %eax,%ecx
  80291f:	89 fa                	mov    %edi,%edx
  802921:	89 c8                	mov    %ecx,%eax
  802923:	83 c4 10             	add    $0x10,%esp
  802926:	5e                   	pop    %esi
  802927:	5f                   	pop    %edi
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    
  80292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802930:	39 f8                	cmp    %edi,%eax
  802932:	77 1c                	ja     802950 <__udivdi3+0x70>
  802934:	0f bd d0             	bsr    %eax,%edx
  802937:	83 f2 1f             	xor    $0x1f,%edx
  80293a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80293d:	75 39                	jne    802978 <__udivdi3+0x98>
  80293f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802942:	0f 86 a0 00 00 00    	jbe    8029e8 <__udivdi3+0x108>
  802948:	39 f8                	cmp    %edi,%eax
  80294a:	0f 82 98 00 00 00    	jb     8029e8 <__udivdi3+0x108>
  802950:	31 ff                	xor    %edi,%edi
  802952:	31 c9                	xor    %ecx,%ecx
  802954:	89 c8                	mov    %ecx,%eax
  802956:	89 fa                	mov    %edi,%edx
  802958:	83 c4 10             	add    $0x10,%esp
  80295b:	5e                   	pop    %esi
  80295c:	5f                   	pop    %edi
  80295d:	5d                   	pop    %ebp
  80295e:	c3                   	ret    
  80295f:	90                   	nop
  802960:	89 d1                	mov    %edx,%ecx
  802962:	89 fa                	mov    %edi,%edx
  802964:	89 c8                	mov    %ecx,%eax
  802966:	31 ff                	xor    %edi,%edi
  802968:	f7 f6                	div    %esi
  80296a:	89 c1                	mov    %eax,%ecx
  80296c:	89 fa                	mov    %edi,%edx
  80296e:	89 c8                	mov    %ecx,%eax
  802970:	83 c4 10             	add    $0x10,%esp
  802973:	5e                   	pop    %esi
  802974:	5f                   	pop    %edi
  802975:	5d                   	pop    %ebp
  802976:	c3                   	ret    
  802977:	90                   	nop
  802978:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80297c:	89 f2                	mov    %esi,%edx
  80297e:	d3 e0                	shl    %cl,%eax
  802980:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802983:	b8 20 00 00 00       	mov    $0x20,%eax
  802988:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80298b:	89 c1                	mov    %eax,%ecx
  80298d:	d3 ea                	shr    %cl,%edx
  80298f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802993:	0b 55 ec             	or     -0x14(%ebp),%edx
  802996:	d3 e6                	shl    %cl,%esi
  802998:	89 c1                	mov    %eax,%ecx
  80299a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80299d:	89 fe                	mov    %edi,%esi
  80299f:	d3 ee                	shr    %cl,%esi
  8029a1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8029a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ab:	d3 e7                	shl    %cl,%edi
  8029ad:	89 c1                	mov    %eax,%ecx
  8029af:	d3 ea                	shr    %cl,%edx
  8029b1:	09 d7                	or     %edx,%edi
  8029b3:	89 f2                	mov    %esi,%edx
  8029b5:	89 f8                	mov    %edi,%eax
  8029b7:	f7 75 ec             	divl   -0x14(%ebp)
  8029ba:	89 d6                	mov    %edx,%esi
  8029bc:	89 c7                	mov    %eax,%edi
  8029be:	f7 65 e8             	mull   -0x18(%ebp)
  8029c1:	39 d6                	cmp    %edx,%esi
  8029c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029c6:	72 30                	jb     8029f8 <__udivdi3+0x118>
  8029c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029cb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8029cf:	d3 e2                	shl    %cl,%edx
  8029d1:	39 c2                	cmp    %eax,%edx
  8029d3:	73 05                	jae    8029da <__udivdi3+0xfa>
  8029d5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8029d8:	74 1e                	je     8029f8 <__udivdi3+0x118>
  8029da:	89 f9                	mov    %edi,%ecx
  8029dc:	31 ff                	xor    %edi,%edi
  8029de:	e9 71 ff ff ff       	jmp    802954 <__udivdi3+0x74>
  8029e3:	90                   	nop
  8029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	31 ff                	xor    %edi,%edi
  8029ea:	b9 01 00 00 00       	mov    $0x1,%ecx
  8029ef:	e9 60 ff ff ff       	jmp    802954 <__udivdi3+0x74>
  8029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8029fb:	31 ff                	xor    %edi,%edi
  8029fd:	89 c8                	mov    %ecx,%eax
  8029ff:	89 fa                	mov    %edi,%edx
  802a01:	83 c4 10             	add    $0x10,%esp
  802a04:	5e                   	pop    %esi
  802a05:	5f                   	pop    %edi
  802a06:	5d                   	pop    %ebp
  802a07:	c3                   	ret    
	...

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	57                   	push   %edi
  802a14:	56                   	push   %esi
  802a15:	83 ec 20             	sub    $0x20,%esp
  802a18:	8b 55 14             	mov    0x14(%ebp),%edx
  802a1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a1e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802a21:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a24:	85 d2                	test   %edx,%edx
  802a26:	89 c8                	mov    %ecx,%eax
  802a28:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802a2b:	75 13                	jne    802a40 <__umoddi3+0x30>
  802a2d:	39 f7                	cmp    %esi,%edi
  802a2f:	76 3f                	jbe    802a70 <__umoddi3+0x60>
  802a31:	89 f2                	mov    %esi,%edx
  802a33:	f7 f7                	div    %edi
  802a35:	89 d0                	mov    %edx,%eax
  802a37:	31 d2                	xor    %edx,%edx
  802a39:	83 c4 20             	add    $0x20,%esp
  802a3c:	5e                   	pop    %esi
  802a3d:	5f                   	pop    %edi
  802a3e:	5d                   	pop    %ebp
  802a3f:	c3                   	ret    
  802a40:	39 f2                	cmp    %esi,%edx
  802a42:	77 4c                	ja     802a90 <__umoddi3+0x80>
  802a44:	0f bd ca             	bsr    %edx,%ecx
  802a47:	83 f1 1f             	xor    $0x1f,%ecx
  802a4a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802a4d:	75 51                	jne    802aa0 <__umoddi3+0x90>
  802a4f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802a52:	0f 87 e0 00 00 00    	ja     802b38 <__umoddi3+0x128>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	29 f8                	sub    %edi,%eax
  802a5d:	19 d6                	sbb    %edx,%esi
  802a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	89 f2                	mov    %esi,%edx
  802a67:	83 c4 20             	add    $0x20,%esp
  802a6a:	5e                   	pop    %esi
  802a6b:	5f                   	pop    %edi
  802a6c:	5d                   	pop    %ebp
  802a6d:	c3                   	ret    
  802a6e:	66 90                	xchg   %ax,%ax
  802a70:	85 ff                	test   %edi,%edi
  802a72:	75 0b                	jne    802a7f <__umoddi3+0x6f>
  802a74:	b8 01 00 00 00       	mov    $0x1,%eax
  802a79:	31 d2                	xor    %edx,%edx
  802a7b:	f7 f7                	div    %edi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	89 f0                	mov    %esi,%eax
  802a81:	31 d2                	xor    %edx,%edx
  802a83:	f7 f7                	div    %edi
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	f7 f7                	div    %edi
  802a8a:	eb a9                	jmp    802a35 <__umoddi3+0x25>
  802a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a90:	89 c8                	mov    %ecx,%eax
  802a92:	89 f2                	mov    %esi,%edx
  802a94:	83 c4 20             	add    $0x20,%esp
  802a97:	5e                   	pop    %esi
  802a98:	5f                   	pop    %edi
  802a99:	5d                   	pop    %ebp
  802a9a:	c3                   	ret    
  802a9b:	90                   	nop
  802a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802aa0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802aa4:	d3 e2                	shl    %cl,%edx
  802aa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802aa9:	ba 20 00 00 00       	mov    $0x20,%edx
  802aae:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ab1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ab4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ab8:	89 fa                	mov    %edi,%edx
  802aba:	d3 ea                	shr    %cl,%edx
  802abc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ac0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ac3:	d3 e7                	shl    %cl,%edi
  802ac5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ac9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802acc:	89 f2                	mov    %esi,%edx
  802ace:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802ad1:	89 c7                	mov    %eax,%edi
  802ad3:	d3 ea                	shr    %cl,%edx
  802ad5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ad9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802adc:	89 c2                	mov    %eax,%edx
  802ade:	d3 e6                	shl    %cl,%esi
  802ae0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ae4:	d3 ea                	shr    %cl,%edx
  802ae6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802aea:	09 d6                	or     %edx,%esi
  802aec:	89 f0                	mov    %esi,%eax
  802aee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802af1:	d3 e7                	shl    %cl,%edi
  802af3:	89 f2                	mov    %esi,%edx
  802af5:	f7 75 f4             	divl   -0xc(%ebp)
  802af8:	89 d6                	mov    %edx,%esi
  802afa:	f7 65 e8             	mull   -0x18(%ebp)
  802afd:	39 d6                	cmp    %edx,%esi
  802aff:	72 2b                	jb     802b2c <__umoddi3+0x11c>
  802b01:	39 c7                	cmp    %eax,%edi
  802b03:	72 23                	jb     802b28 <__umoddi3+0x118>
  802b05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802b09:	29 c7                	sub    %eax,%edi
  802b0b:	19 d6                	sbb    %edx,%esi
  802b0d:	89 f0                	mov    %esi,%eax
  802b0f:	89 f2                	mov    %esi,%edx
  802b11:	d3 ef                	shr    %cl,%edi
  802b13:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802b17:	d3 e0                	shl    %cl,%eax
  802b19:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802b1d:	09 f8                	or     %edi,%eax
  802b1f:	d3 ea                	shr    %cl,%edx
  802b21:	83 c4 20             	add    $0x20,%esp
  802b24:	5e                   	pop    %esi
  802b25:	5f                   	pop    %edi
  802b26:	5d                   	pop    %ebp
  802b27:	c3                   	ret    
  802b28:	39 d6                	cmp    %edx,%esi
  802b2a:	75 d9                	jne    802b05 <__umoddi3+0xf5>
  802b2c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b2f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802b32:	eb d1                	jmp    802b05 <__umoddi3+0xf5>
  802b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b38:	39 f2                	cmp    %esi,%edx
  802b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b40:	0f 82 12 ff ff ff    	jb     802a58 <__umoddi3+0x48>
  802b46:	e9 17 ff ff ff       	jmp    802a62 <__umoddi3+0x52>
