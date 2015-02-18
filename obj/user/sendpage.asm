
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 b3 01 00 00       	call   8001e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 28             	sub    $0x28,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  80003a:	e8 57 11 00 00       	call   801196 <fork>
  80003f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800042:	85 c0                	test   %eax,%eax
  800044:	0f 85 bd 00 00 00    	jne    800107 <umain+0xd3>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80004a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800051:	00 
  800052:	c7 44 24 04 00 00 b0 	movl   $0xb00000,0x4(%esp)
  800059:	00 
  80005a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80005d:	89 04 24             	mov    %eax,(%esp)
  800060:	e8 69 15 00 00       	call   8015ce <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800065:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  80006c:	00 
  80006d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800070:	89 44 24 04          	mov    %eax,0x4(%esp)
  800074:	c7 04 24 e0 19 80 00 	movl   $0x8019e0,(%esp)
  80007b:	e8 29 02 00 00       	call   8002a9 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800080:	a1 00 20 80 00       	mov    0x802000,%eax
  800085:	89 04 24             	mov    %eax,(%esp)
  800088:	e8 43 08 00 00       	call   8008d0 <strlen>
  80008d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800091:	a1 00 20 80 00       	mov    0x802000,%eax
  800096:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009a:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000a1:	e8 34 09 00 00       	call   8009da <strncmp>
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	75 0c                	jne    8000b6 <umain+0x82>
			cprintf("child received correct message\n");
  8000aa:	c7 04 24 f4 19 80 00 	movl   $0x8019f4,(%esp)
  8000b1:	e8 f3 01 00 00       	call   8002a9 <cprintf>

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8000b6:	a1 04 20 80 00       	mov    0x802004,%eax
  8000bb:	89 04 24             	mov    %eax,(%esp)
  8000be:	e8 0d 08 00 00       	call   8008d0 <strlen>
  8000c3:	83 c0 01             	add    $0x1,%eax
  8000c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ca:	a1 04 20 80 00       	mov    0x802004,%eax
  8000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d3:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000da:	e8 4c 0a 00 00       	call   800b2b <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000df:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8000e6:	00 
  8000e7:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  8000ee:	00 
  8000ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f6:	00 
  8000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000fa:	89 04 24             	mov    %eax,(%esp)
  8000fd:	e8 60 14 00 00       	call   801562 <ipc_send>
		return;
  800102:	e9 d8 00 00 00       	jmp    8001df <umain+0x1ab>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800107:	a1 0c 20 80 00       	mov    0x80200c,%eax
  80010c:	8b 40 48             	mov    0x48(%eax),%eax
  80010f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800116:	00 
  800117:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  80011e:	00 
  80011f:	89 04 24             	mov    %eax,(%esp)
  800122:	e8 27 0f 00 00       	call   80104e <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800127:	a1 00 20 80 00       	mov    0x802000,%eax
  80012c:	89 04 24             	mov    %eax,(%esp)
  80012f:	e8 9c 07 00 00       	call   8008d0 <strlen>
  800134:	83 c0 01             	add    $0x1,%eax
  800137:	89 44 24 08          	mov    %eax,0x8(%esp)
  80013b:	a1 00 20 80 00       	mov    0x802000,%eax
  800140:	89 44 24 04          	mov    %eax,0x4(%esp)
  800144:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  80014b:	e8 db 09 00 00       	call   800b2b <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800150:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800157:	00 
  800158:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800167:	00 
  800168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016b:	89 04 24             	mov    %eax,(%esp)
  80016e:	e8 ef 13 00 00       	call   801562 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800173:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80017a:	00 
  80017b:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  800182:	00 
  800183:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800186:	89 04 24             	mov    %eax,(%esp)
  800189:	e8 40 14 00 00       	call   8015ce <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  80018e:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  800195:	00 
  800196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019d:	c7 04 24 e0 19 80 00 	movl   $0x8019e0,(%esp)
  8001a4:	e8 00 01 00 00       	call   8002a9 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8001a9:	a1 04 20 80 00       	mov    0x802004,%eax
  8001ae:	89 04 24             	mov    %eax,(%esp)
  8001b1:	e8 1a 07 00 00       	call   8008d0 <strlen>
  8001b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001ba:	a1 04 20 80 00       	mov    0x802004,%eax
  8001bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c3:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  8001ca:	e8 0b 08 00 00       	call   8009da <strncmp>
  8001cf:	85 c0                	test   %eax,%eax
  8001d1:	75 0c                	jne    8001df <umain+0x1ab>
		cprintf("parent received correct message\n");
  8001d3:	c7 04 24 14 1a 80 00 	movl   $0x801a14,(%esp)
  8001da:	e8 ca 00 00 00       	call   8002a9 <cprintf>
	return;
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    
  8001e1:	00 00                	add    %al,(%eax)
	...

008001e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	83 ec 18             	sub    $0x18,%esp
  8001ea:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001ed:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8001f6:	e8 e6 0e 00 00       	call   8010e1 <sys_getenvid>
  8001fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800200:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800203:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800208:	a3 0c 20 80 00       	mov    %eax,0x80200c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020d:	85 f6                	test   %esi,%esi
  80020f:	7e 07                	jle    800218 <libmain+0x34>
		binaryname = argv[0];
  800211:	8b 03                	mov    (%ebx),%eax
  800213:	a3 08 20 80 00       	mov    %eax,0x802008

	// call user main routine
	umain(argc, argv);
  800218:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80021c:	89 34 24             	mov    %esi,(%esp)
  80021f:	e8 10 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800224:	e8 0b 00 00 00       	call   800234 <exit>
}
  800229:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80022c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80022f:	89 ec                	mov    %ebp,%esp
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    
	...

00800234 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80023a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800241:	e8 cf 0e 00 00       	call   801115 <sys_env_destroy>
}
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800251:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800258:	00 00 00 
	b.cnt = 0;
  80025b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800262:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800265:	8b 45 0c             	mov    0xc(%ebp),%eax
  800268:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80026c:	8b 45 08             	mov    0x8(%ebp),%eax
  80026f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800273:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027d:	c7 04 24 c3 02 80 00 	movl   $0x8002c3,(%esp)
  800284:	e8 be 01 00 00       	call   800447 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800289:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80028f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800293:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800299:	89 04 24             	mov    %eax,(%esp)
  80029c:	e8 1f 0a 00 00       	call   800cc0 <sys_cputs>

	return b.cnt;
}
  8002a1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a7:	c9                   	leave  
  8002a8:	c3                   	ret    

008002a9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002af:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 87 ff ff ff       	call   800248 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 14             	sub    $0x14,%esp
  8002ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002cd:	8b 03                	mov    (%ebx),%eax
  8002cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002d6:	83 c0 01             	add    $0x1,%eax
  8002d9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002db:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e0:	75 19                	jne    8002fb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002e2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002e9:	00 
  8002ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ed:	89 04 24             	mov    %eax,(%esp)
  8002f0:	e8 cb 09 00 00       	call   800cc0 <sys_cputs>
		b->idx = 0;
  8002f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002fb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ff:	83 c4 14             	add    $0x14,%esp
  800302:	5b                   	pop    %ebx
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    
  800305:	00 00                	add    %al,(%eax)
	...

00800308 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	57                   	push   %edi
  80030c:	56                   	push   %esi
  80030d:	53                   	push   %ebx
  80030e:	83 ec 4c             	sub    $0x4c,%esp
  800311:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800314:	89 d6                	mov    %edx,%esi
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800322:	8b 45 10             	mov    0x10(%ebp),%eax
  800325:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800328:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80032e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800333:	39 d1                	cmp    %edx,%ecx
  800335:	72 07                	jb     80033e <printnum+0x36>
  800337:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80033a:	39 d0                	cmp    %edx,%eax
  80033c:	77 69                	ja     8003a7 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80033e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800342:	83 eb 01             	sub    $0x1,%ebx
  800345:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800349:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800351:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800355:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800358:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80035b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80035e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800362:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800369:	00 
  80036a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80036d:	89 04 24             	mov    %eax,(%esp)
  800370:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800373:	89 54 24 04          	mov    %edx,0x4(%esp)
  800377:	e8 e4 13 00 00       	call   801760 <__udivdi3>
  80037c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80037f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800382:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800386:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80038a:	89 04 24             	mov    %eax,(%esp)
  80038d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800391:	89 f2                	mov    %esi,%edx
  800393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800396:	e8 6d ff ff ff       	call   800308 <printnum>
  80039b:	eb 11                	jmp    8003ae <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003a1:	89 3c 24             	mov    %edi,(%esp)
  8003a4:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a7:	83 eb 01             	sub    $0x1,%ebx
  8003aa:	85 db                	test   %ebx,%ebx
  8003ac:	7f ef                	jg     80039d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003bd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003c4:	00 
  8003c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003c8:	89 14 24             	mov    %edx,(%esp)
  8003cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003d2:	e8 b9 14 00 00       	call   801890 <__umoddi3>
  8003d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003db:	0f be 80 8e 1a 80 00 	movsbl 0x801a8e(%eax),%eax
  8003e2:	89 04 24             	mov    %eax,(%esp)
  8003e5:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003e8:	83 c4 4c             	add    $0x4c,%esp
  8003eb:	5b                   	pop    %ebx
  8003ec:	5e                   	pop    %esi
  8003ed:	5f                   	pop    %edi
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f3:	83 fa 01             	cmp    $0x1,%edx
  8003f6:	7e 0e                	jle    800406 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003fd:	89 08                	mov    %ecx,(%eax)
  8003ff:	8b 02                	mov    (%edx),%eax
  800401:	8b 52 04             	mov    0x4(%edx),%edx
  800404:	eb 22                	jmp    800428 <getuint+0x38>
	else if (lflag)
  800406:	85 d2                	test   %edx,%edx
  800408:	74 10                	je     80041a <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80040a:	8b 10                	mov    (%eax),%edx
  80040c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80040f:	89 08                	mov    %ecx,(%eax)
  800411:	8b 02                	mov    (%edx),%eax
  800413:	ba 00 00 00 00       	mov    $0x0,%edx
  800418:	eb 0e                	jmp    800428 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80041a:	8b 10                	mov    (%eax),%edx
  80041c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80041f:	89 08                	mov    %ecx,(%eax)
  800421:	8b 02                	mov    (%edx),%eax
  800423:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800430:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800434:	8b 10                	mov    (%eax),%edx
  800436:	3b 50 04             	cmp    0x4(%eax),%edx
  800439:	73 0a                	jae    800445 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043e:	88 0a                	mov    %cl,(%edx)
  800440:	83 c2 01             	add    $0x1,%edx
  800443:	89 10                	mov    %edx,(%eax)
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	57                   	push   %edi
  80044b:	56                   	push   %esi
  80044c:	53                   	push   %ebx
  80044d:	83 ec 4c             	sub    $0x4c,%esp
  800450:	8b 7d 08             	mov    0x8(%ebp),%edi
  800453:	8b 75 0c             	mov    0xc(%ebp),%esi
  800456:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800459:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800460:	eb 11                	jmp    800473 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800462:	85 c0                	test   %eax,%eax
  800464:	0f 84 b6 03 00 00    	je     800820 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80046a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800473:	0f b6 03             	movzbl (%ebx),%eax
  800476:	83 c3 01             	add    $0x1,%ebx
  800479:	83 f8 25             	cmp    $0x25,%eax
  80047c:	75 e4                	jne    800462 <vprintfmt+0x1b>
  80047e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800482:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800489:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800490:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800497:	b9 00 00 00 00       	mov    $0x0,%ecx
  80049c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80049f:	eb 06                	jmp    8004a7 <vprintfmt+0x60>
  8004a1:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8004a5:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	0f b6 0b             	movzbl (%ebx),%ecx
  8004aa:	0f b6 c1             	movzbl %cl,%eax
  8004ad:	8d 53 01             	lea    0x1(%ebx),%edx
  8004b0:	83 e9 23             	sub    $0x23,%ecx
  8004b3:	80 f9 55             	cmp    $0x55,%cl
  8004b6:	0f 87 47 03 00 00    	ja     800803 <vprintfmt+0x3bc>
  8004bc:	0f b6 c9             	movzbl %cl,%ecx
  8004bf:	ff 24 8d e0 1b 80 00 	jmp    *0x801be0(,%ecx,4)
  8004c6:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8004ca:	eb d9                	jmp    8004a5 <vprintfmt+0x5e>
  8004cc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004d3:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004d8:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004db:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004df:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8004e2:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004e5:	83 fb 09             	cmp    $0x9,%ebx
  8004e8:	77 30                	ja     80051a <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ea:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ed:	eb e9                	jmp    8004d8 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8d 48 04             	lea    0x4(%eax),%ecx
  8004f5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8004fd:	eb 1e                	jmp    80051d <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8004ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800503:	b8 00 00 00 00       	mov    $0x0,%eax
  800508:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  80050c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050f:	eb 94                	jmp    8004a5 <vprintfmt+0x5e>
  800511:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800518:	eb 8b                	jmp    8004a5 <vprintfmt+0x5e>
  80051a:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  80051d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800521:	79 82                	jns    8004a5 <vprintfmt+0x5e>
  800523:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800529:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80052c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80052f:	e9 71 ff ff ff       	jmp    8004a5 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800534:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800538:	e9 68 ff ff ff       	jmp    8004a5 <vprintfmt+0x5e>
  80053d:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8d 50 04             	lea    0x4(%eax),%edx
  800546:	89 55 14             	mov    %edx,0x14(%ebp)
  800549:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 04 24             	mov    %eax,(%esp)
  800552:	ff d7                	call   *%edi
  800554:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800557:	e9 17 ff ff ff       	jmp    800473 <vprintfmt+0x2c>
  80055c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8d 50 04             	lea    0x4(%eax),%edx
  800565:	89 55 14             	mov    %edx,0x14(%ebp)
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 c2                	mov    %eax,%edx
  80056c:	c1 fa 1f             	sar    $0x1f,%edx
  80056f:	31 d0                	xor    %edx,%eax
  800571:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800573:	83 f8 11             	cmp    $0x11,%eax
  800576:	7f 0b                	jg     800583 <vprintfmt+0x13c>
  800578:	8b 14 85 40 1d 80 00 	mov    0x801d40(,%eax,4),%edx
  80057f:	85 d2                	test   %edx,%edx
  800581:	75 20                	jne    8005a3 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800583:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800587:	c7 44 24 08 9f 1a 80 	movl   $0x801a9f,0x8(%esp)
  80058e:	00 
  80058f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800593:	89 3c 24             	mov    %edi,(%esp)
  800596:	e8 0d 03 00 00       	call   8008a8 <printfmt>
  80059b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80059e:	e9 d0 fe ff ff       	jmp    800473 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005a7:	c7 44 24 08 a8 1a 80 	movl   $0x801aa8,0x8(%esp)
  8005ae:	00 
  8005af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005b3:	89 3c 24             	mov    %edi,(%esp)
  8005b6:	e8 ed 02 00 00       	call   8008a8 <printfmt>
  8005bb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005be:	e9 b0 fe ff ff       	jmp    800473 <vprintfmt+0x2c>
  8005c3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005c6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d8:	8b 18                	mov    (%eax),%ebx
  8005da:	85 db                	test   %ebx,%ebx
  8005dc:	b8 ab 1a 80 00       	mov    $0x801aab,%eax
  8005e1:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8005e4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005e8:	7e 76                	jle    800660 <vprintfmt+0x219>
  8005ea:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8005ee:	74 7a                	je     80066a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f4:	89 1c 24             	mov    %ebx,(%esp)
  8005f7:	e8 ec 02 00 00       	call   8008e8 <strnlen>
  8005fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800601:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800605:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800608:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80060b:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80060d:	eb 0f                	jmp    80061e <vprintfmt+0x1d7>
					putch(padc, putdat);
  80060f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800616:	89 04 24             	mov    %eax,(%esp)
  800619:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061b:	83 eb 01             	sub    $0x1,%ebx
  80061e:	85 db                	test   %ebx,%ebx
  800620:	7f ed                	jg     80060f <vprintfmt+0x1c8>
  800622:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800625:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800628:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80062b:	89 f7                	mov    %esi,%edi
  80062d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800630:	eb 40                	jmp    800672 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800632:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800636:	74 18                	je     800650 <vprintfmt+0x209>
  800638:	8d 50 e0             	lea    -0x20(%eax),%edx
  80063b:	83 fa 5e             	cmp    $0x5e,%edx
  80063e:	76 10                	jbe    800650 <vprintfmt+0x209>
					putch('?', putdat);
  800640:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800644:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80064b:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80064e:	eb 0a                	jmp    80065a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800650:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800654:	89 04 24             	mov    %eax,(%esp)
  800657:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80065e:	eb 12                	jmp    800672 <vprintfmt+0x22b>
  800660:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800663:	89 f7                	mov    %esi,%edi
  800665:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800668:	eb 08                	jmp    800672 <vprintfmt+0x22b>
  80066a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80066d:	89 f7                	mov    %esi,%edi
  80066f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800672:	0f be 03             	movsbl (%ebx),%eax
  800675:	83 c3 01             	add    $0x1,%ebx
  800678:	85 c0                	test   %eax,%eax
  80067a:	74 25                	je     8006a1 <vprintfmt+0x25a>
  80067c:	85 f6                	test   %esi,%esi
  80067e:	78 b2                	js     800632 <vprintfmt+0x1eb>
  800680:	83 ee 01             	sub    $0x1,%esi
  800683:	79 ad                	jns    800632 <vprintfmt+0x1eb>
  800685:	89 fe                	mov    %edi,%esi
  800687:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80068a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80068d:	eb 1a                	jmp    8006a9 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80068f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800693:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80069a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80069c:	83 eb 01             	sub    $0x1,%ebx
  80069f:	eb 08                	jmp    8006a9 <vprintfmt+0x262>
  8006a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006a4:	89 fe                	mov    %edi,%esi
  8006a6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006a9:	85 db                	test   %ebx,%ebx
  8006ab:	7f e2                	jg     80068f <vprintfmt+0x248>
  8006ad:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006b0:	e9 be fd ff ff       	jmp    800473 <vprintfmt+0x2c>
  8006b5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006bb:	83 f9 01             	cmp    $0x1,%ecx
  8006be:	7e 16                	jle    8006d6 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 50 08             	lea    0x8(%eax),%edx
  8006c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c9:	8b 10                	mov    (%eax),%edx
  8006cb:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ce:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8006d1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d4:	eb 32                	jmp    800708 <vprintfmt+0x2c1>
	else if (lflag)
  8006d6:	85 c9                	test   %ecx,%ecx
  8006d8:	74 18                	je     8006f2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 50 04             	lea    0x4(%eax),%edx
  8006e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 c1                	mov    %eax,%ecx
  8006ea:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ed:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006f0:	eb 16                	jmp    800708 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 50 04             	lea    0x4(%eax),%edx
  8006f8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800700:	89 c2                	mov    %eax,%edx
  800702:	c1 fa 1f             	sar    $0x1f,%edx
  800705:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800708:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80070b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80070e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800713:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800717:	0f 89 a7 00 00 00    	jns    8007c4 <vprintfmt+0x37d>
				putch('-', putdat);
  80071d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800721:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800728:	ff d7                	call   *%edi
				num = -(long long) num;
  80072a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80072d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800730:	f7 d9                	neg    %ecx
  800732:	83 d3 00             	adc    $0x0,%ebx
  800735:	f7 db                	neg    %ebx
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073c:	e9 83 00 00 00       	jmp    8007c4 <vprintfmt+0x37d>
  800741:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800744:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800747:	89 ca                	mov    %ecx,%edx
  800749:	8d 45 14             	lea    0x14(%ebp),%eax
  80074c:	e8 9f fc ff ff       	call   8003f0 <getuint>
  800751:	89 c1                	mov    %eax,%ecx
  800753:	89 d3                	mov    %edx,%ebx
  800755:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80075a:	eb 68                	jmp    8007c4 <vprintfmt+0x37d>
  80075c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80075f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800762:	89 ca                	mov    %ecx,%edx
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
  800767:	e8 84 fc ff ff       	call   8003f0 <getuint>
  80076c:	89 c1                	mov    %eax,%ecx
  80076e:	89 d3                	mov    %edx,%ebx
  800770:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800775:	eb 4d                	jmp    8007c4 <vprintfmt+0x37d>
  800777:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80077a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800785:	ff d7                	call   *%edi
			putch('x', putdat);
  800787:	89 74 24 04          	mov    %esi,0x4(%esp)
  80078b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800792:	ff d7                	call   *%edi
			num = (unsigned long long)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	89 55 14             	mov    %edx,0x14(%ebp)
  80079d:	8b 08                	mov    (%eax),%ecx
  80079f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a4:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007a9:	eb 19                	jmp    8007c4 <vprintfmt+0x37d>
  8007ab:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007ae:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007b1:	89 ca                	mov    %ecx,%edx
  8007b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b6:	e8 35 fc ff ff       	call   8003f0 <getuint>
  8007bb:	89 c1                	mov    %eax,%ecx
  8007bd:	89 d3                	mov    %edx,%ebx
  8007bf:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c4:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8007c8:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d7:	89 0c 24             	mov    %ecx,(%esp)
  8007da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007de:	89 f2                	mov    %esi,%edx
  8007e0:	89 f8                	mov    %edi,%eax
  8007e2:	e8 21 fb ff ff       	call   800308 <printnum>
  8007e7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007ea:	e9 84 fc ff ff       	jmp    800473 <vprintfmt+0x2c>
  8007ef:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007f6:	89 04 24             	mov    %eax,(%esp)
  8007f9:	ff d7                	call   *%edi
  8007fb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007fe:	e9 70 fc ff ff       	jmp    800473 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800803:	89 74 24 04          	mov    %esi,0x4(%esp)
  800807:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80080e:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800813:	80 38 25             	cmpb   $0x25,(%eax)
  800816:	0f 84 57 fc ff ff    	je     800473 <vprintfmt+0x2c>
  80081c:	89 c3                	mov    %eax,%ebx
  80081e:	eb f0                	jmp    800810 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800820:	83 c4 4c             	add    $0x4c,%esp
  800823:	5b                   	pop    %ebx
  800824:	5e                   	pop    %esi
  800825:	5f                   	pop    %edi
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 28             	sub    $0x28,%esp
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800834:	85 c0                	test   %eax,%eax
  800836:	74 04                	je     80083c <vsnprintf+0x14>
  800838:	85 d2                	test   %edx,%edx
  80083a:	7f 07                	jg     800843 <vsnprintf+0x1b>
  80083c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800841:	eb 3b                	jmp    80087e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800843:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800846:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  80084a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80085b:	8b 45 10             	mov    0x10(%ebp),%eax
  80085e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800862:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800865:	89 44 24 04          	mov    %eax,0x4(%esp)
  800869:	c7 04 24 2a 04 80 00 	movl   $0x80042a,(%esp)
  800870:	e8 d2 fb ff ff       	call   800447 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800878:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800886:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800889:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	89 44 24 08          	mov    %eax,0x8(%esp)
  800894:	8b 45 0c             	mov    0xc(%ebp),%eax
  800897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	89 04 24             	mov    %eax,(%esp)
  8008a1:	e8 82 ff ff ff       	call   800828 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    

008008a8 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008ae:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	89 04 24             	mov    %eax,(%esp)
  8008c9:	e8 79 fb ff ff       	call   800447 <vprintfmt>
	va_end(ap);
}
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8008db:	eb 03                	jmp    8008e0 <strlen+0x10>
		n++;
  8008dd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e4:	75 f7                	jne    8008dd <strlen+0xd>
		n++;
	return n;
}
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	53                   	push   %ebx
  8008ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f7:	eb 03                	jmp    8008fc <strnlen+0x14>
		n++;
  8008f9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fc:	39 c1                	cmp    %eax,%ecx
  8008fe:	74 06                	je     800906 <strnlen+0x1e>
  800900:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800904:	75 f3                	jne    8008f9 <strnlen+0x11>
		n++;
	return n;
}
  800906:	5b                   	pop    %ebx
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800918:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80091f:	83 c2 01             	add    $0x1,%edx
  800922:	84 c9                	test   %cl,%cl
  800924:	75 f2                	jne    800918 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800926:	5b                   	pop    %ebx
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	53                   	push   %ebx
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800933:	89 1c 24             	mov    %ebx,(%esp)
  800936:	e8 95 ff ff ff       	call   8008d0 <strlen>
	strcpy(dst + len, src);
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800942:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800945:	89 04 24             	mov    %eax,(%esp)
  800948:	e8 bc ff ff ff       	call   800909 <strcpy>
	return dst;
}
  80094d:	89 d8                	mov    %ebx,%eax
  80094f:	83 c4 08             	add    $0x8,%esp
  800952:	5b                   	pop    %ebx
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800960:	8b 75 10             	mov    0x10(%ebp),%esi
  800963:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800968:	eb 0f                	jmp    800979 <strncpy+0x24>
		*dst++ = *src;
  80096a:	0f b6 19             	movzbl (%ecx),%ebx
  80096d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800970:	80 39 01             	cmpb   $0x1,(%ecx)
  800973:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800976:	83 c2 01             	add    $0x1,%edx
  800979:	39 f2                	cmp    %esi,%edx
  80097b:	72 ed                	jb     80096a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	56                   	push   %esi
  800985:	53                   	push   %ebx
  800986:	8b 75 08             	mov    0x8(%ebp),%esi
  800989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098f:	89 f0                	mov    %esi,%eax
  800991:	85 d2                	test   %edx,%edx
  800993:	75 0a                	jne    80099f <strlcpy+0x1e>
  800995:	eb 17                	jmp    8009ae <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800997:	88 18                	mov    %bl,(%eax)
  800999:	83 c0 01             	add    $0x1,%eax
  80099c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80099f:	83 ea 01             	sub    $0x1,%edx
  8009a2:	74 07                	je     8009ab <strlcpy+0x2a>
  8009a4:	0f b6 19             	movzbl (%ecx),%ebx
  8009a7:	84 db                	test   %bl,%bl
  8009a9:	75 ec                	jne    800997 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8009ab:	c6 00 00             	movb   $0x0,(%eax)
  8009ae:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009bd:	eb 06                	jmp    8009c5 <strcmp+0x11>
		p++, q++;
  8009bf:	83 c1 01             	add    $0x1,%ecx
  8009c2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009c5:	0f b6 01             	movzbl (%ecx),%eax
  8009c8:	84 c0                	test   %al,%al
  8009ca:	74 04                	je     8009d0 <strcmp+0x1c>
  8009cc:	3a 02                	cmp    (%edx),%al
  8009ce:	74 ef                	je     8009bf <strcmp+0xb>
  8009d0:	0f b6 c0             	movzbl %al,%eax
  8009d3:	0f b6 12             	movzbl (%edx),%edx
  8009d6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009e7:	eb 09                	jmp    8009f2 <strncmp+0x18>
		n--, p++, q++;
  8009e9:	83 ea 01             	sub    $0x1,%edx
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009f2:	85 d2                	test   %edx,%edx
  8009f4:	75 07                	jne    8009fd <strncmp+0x23>
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	eb 13                	jmp    800a10 <strncmp+0x36>
  8009fd:	0f b6 18             	movzbl (%eax),%ebx
  800a00:	84 db                	test   %bl,%bl
  800a02:	74 04                	je     800a08 <strncmp+0x2e>
  800a04:	3a 19                	cmp    (%ecx),%bl
  800a06:	74 e1                	je     8009e9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 00             	movzbl (%eax),%eax
  800a0b:	0f b6 11             	movzbl (%ecx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1d:	eb 07                	jmp    800a26 <strchr+0x13>
		if (*s == c)
  800a1f:	38 ca                	cmp    %cl,%dl
  800a21:	74 0f                	je     800a32 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	0f b6 10             	movzbl (%eax),%edx
  800a29:	84 d2                	test   %dl,%dl
  800a2b:	75 f2                	jne    800a1f <strchr+0xc>
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3e:	eb 07                	jmp    800a47 <strfind+0x13>
		if (*s == c)
  800a40:	38 ca                	cmp    %cl,%dl
  800a42:	74 0a                	je     800a4e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	0f b6 10             	movzbl (%eax),%edx
  800a4a:	84 d2                	test   %dl,%dl
  800a4c:	75 f2                	jne    800a40 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 0c             	sub    $0xc,%esp
  800a56:	89 1c 24             	mov    %ebx,(%esp)
  800a59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a61:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6a:	85 c9                	test   %ecx,%ecx
  800a6c:	74 30                	je     800a9e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a6e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a74:	75 25                	jne    800a9b <memset+0x4b>
  800a76:	f6 c1 03             	test   $0x3,%cl
  800a79:	75 20                	jne    800a9b <memset+0x4b>
		c &= 0xFF;
  800a7b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a7e:	89 d3                	mov    %edx,%ebx
  800a80:	c1 e3 08             	shl    $0x8,%ebx
  800a83:	89 d6                	mov    %edx,%esi
  800a85:	c1 e6 18             	shl    $0x18,%esi
  800a88:	89 d0                	mov    %edx,%eax
  800a8a:	c1 e0 10             	shl    $0x10,%eax
  800a8d:	09 f0                	or     %esi,%eax
  800a8f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a91:	09 d8                	or     %ebx,%eax
  800a93:	c1 e9 02             	shr    $0x2,%ecx
  800a96:	fc                   	cld    
  800a97:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a99:	eb 03                	jmp    800a9e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9b:	fc                   	cld    
  800a9c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a9e:	89 f8                	mov    %edi,%eax
  800aa0:	8b 1c 24             	mov    (%esp),%ebx
  800aa3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800aa7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800aab:	89 ec                	mov    %ebp,%esp
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	89 34 24             	mov    %esi,(%esp)
  800ab8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800ac2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800ac5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800ac7:	39 c6                	cmp    %eax,%esi
  800ac9:	73 35                	jae    800b00 <memmove+0x51>
  800acb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ace:	39 d0                	cmp    %edx,%eax
  800ad0:	73 2e                	jae    800b00 <memmove+0x51>
		s += n;
		d += n;
  800ad2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad4:	f6 c2 03             	test   $0x3,%dl
  800ad7:	75 1b                	jne    800af4 <memmove+0x45>
  800ad9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800adf:	75 13                	jne    800af4 <memmove+0x45>
  800ae1:	f6 c1 03             	test   $0x3,%cl
  800ae4:	75 0e                	jne    800af4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ae6:	83 ef 04             	sub    $0x4,%edi
  800ae9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aec:	c1 e9 02             	shr    $0x2,%ecx
  800aef:	fd                   	std    
  800af0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af2:	eb 09                	jmp    800afd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800af4:	83 ef 01             	sub    $0x1,%edi
  800af7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800afa:	fd                   	std    
  800afb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800afd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800afe:	eb 20                	jmp    800b20 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b00:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b06:	75 15                	jne    800b1d <memmove+0x6e>
  800b08:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0e:	75 0d                	jne    800b1d <memmove+0x6e>
  800b10:	f6 c1 03             	test   $0x3,%cl
  800b13:	75 08                	jne    800b1d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b15:	c1 e9 02             	shr    $0x2,%ecx
  800b18:	fc                   	cld    
  800b19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1b:	eb 03                	jmp    800b20 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b1d:	fc                   	cld    
  800b1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b20:	8b 34 24             	mov    (%esp),%esi
  800b23:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b27:	89 ec                	mov    %ebp,%esp
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b31:	8b 45 10             	mov    0x10(%ebp),%eax
  800b34:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 04 24             	mov    %eax,(%esp)
  800b45:	e8 65 ff ff ff       	call   800aaf <memmove>
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
  800b52:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b5b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b60:	eb 1c                	jmp    800b7e <memcmp+0x32>
		if (*s1 != *s2)
  800b62:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800b66:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800b6a:	83 c2 01             	add    $0x1,%edx
  800b6d:	83 e9 01             	sub    $0x1,%ecx
  800b70:	38 d8                	cmp    %bl,%al
  800b72:	74 0a                	je     800b7e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800b74:	0f b6 c0             	movzbl %al,%eax
  800b77:	0f b6 db             	movzbl %bl,%ebx
  800b7a:	29 d8                	sub    %ebx,%eax
  800b7c:	eb 09                	jmp    800b87 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7e:	85 c9                	test   %ecx,%ecx
  800b80:	75 e0                	jne    800b62 <memcmp+0x16>
  800b82:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b87:	5b                   	pop    %ebx
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9a:	eb 07                	jmp    800ba3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9c:	38 08                	cmp    %cl,(%eax)
  800b9e:	74 07                	je     800ba7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ba0:	83 c0 01             	add    $0x1,%eax
  800ba3:	39 d0                	cmp    %edx,%eax
  800ba5:	72 f5                	jb     800b9c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	83 ec 04             	sub    $0x4,%esp
  800bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb8:	eb 03                	jmp    800bbd <strtol+0x14>
		s++;
  800bba:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbd:	0f b6 02             	movzbl (%edx),%eax
  800bc0:	3c 20                	cmp    $0x20,%al
  800bc2:	74 f6                	je     800bba <strtol+0x11>
  800bc4:	3c 09                	cmp    $0x9,%al
  800bc6:	74 f2                	je     800bba <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bc8:	3c 2b                	cmp    $0x2b,%al
  800bca:	75 0c                	jne    800bd8 <strtol+0x2f>
		s++;
  800bcc:	8d 52 01             	lea    0x1(%edx),%edx
  800bcf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bd6:	eb 15                	jmp    800bed <strtol+0x44>
	else if (*s == '-')
  800bd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bdf:	3c 2d                	cmp    $0x2d,%al
  800be1:	75 0a                	jne    800bed <strtol+0x44>
		s++, neg = 1;
  800be3:	8d 52 01             	lea    0x1(%edx),%edx
  800be6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	0f 94 c0             	sete   %al
  800bf2:	74 05                	je     800bf9 <strtol+0x50>
  800bf4:	83 fb 10             	cmp    $0x10,%ebx
  800bf7:	75 15                	jne    800c0e <strtol+0x65>
  800bf9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfc:	75 10                	jne    800c0e <strtol+0x65>
  800bfe:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c02:	75 0a                	jne    800c0e <strtol+0x65>
		s += 2, base = 16;
  800c04:	83 c2 02             	add    $0x2,%edx
  800c07:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0c:	eb 13                	jmp    800c21 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c0e:	84 c0                	test   %al,%al
  800c10:	74 0f                	je     800c21 <strtol+0x78>
  800c12:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c17:	80 3a 30             	cmpb   $0x30,(%edx)
  800c1a:	75 05                	jne    800c21 <strtol+0x78>
		s++, base = 8;
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c28:	0f b6 0a             	movzbl (%edx),%ecx
  800c2b:	89 cf                	mov    %ecx,%edi
  800c2d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c30:	80 fb 09             	cmp    $0x9,%bl
  800c33:	77 08                	ja     800c3d <strtol+0x94>
			dig = *s - '0';
  800c35:	0f be c9             	movsbl %cl,%ecx
  800c38:	83 e9 30             	sub    $0x30,%ecx
  800c3b:	eb 1e                	jmp    800c5b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800c3d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c40:	80 fb 19             	cmp    $0x19,%bl
  800c43:	77 08                	ja     800c4d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800c45:	0f be c9             	movsbl %cl,%ecx
  800c48:	83 e9 57             	sub    $0x57,%ecx
  800c4b:	eb 0e                	jmp    800c5b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800c4d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c50:	80 fb 19             	cmp    $0x19,%bl
  800c53:	77 15                	ja     800c6a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c55:	0f be c9             	movsbl %cl,%ecx
  800c58:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c5b:	39 f1                	cmp    %esi,%ecx
  800c5d:	7d 0b                	jge    800c6a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c5f:	83 c2 01             	add    $0x1,%edx
  800c62:	0f af c6             	imul   %esi,%eax
  800c65:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c68:	eb be                	jmp    800c28 <strtol+0x7f>
  800c6a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c70:	74 05                	je     800c77 <strtol+0xce>
		*endptr = (char *) s;
  800c72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c75:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c77:	89 ca                	mov    %ecx,%edx
  800c79:	f7 da                	neg    %edx
  800c7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c7f:	0f 45 c2             	cmovne %edx,%eax
}
  800c82:	83 c4 04             	add    $0x4,%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    
	...

00800c8c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 0c             	sub    $0xc,%esp
  800c92:	89 1c 24             	mov    %ebx,(%esp)
  800c95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c99:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca7:	89 d1                	mov    %edx,%ecx
  800ca9:	89 d3                	mov    %edx,%ebx
  800cab:	89 d7                	mov    %edx,%edi
  800cad:	89 d6                	mov    %edx,%esi
  800caf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb1:	8b 1c 24             	mov    (%esp),%ebx
  800cb4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cb8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cbc:	89 ec                	mov    %ebp,%esp
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 0c             	sub    $0xc,%esp
  800cc6:	89 1c 24             	mov    %ebx,(%esp)
  800cc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ccd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdc:	89 c3                	mov    %eax,%ebx
  800cde:	89 c7                	mov    %eax,%edi
  800ce0:	89 c6                	mov    %eax,%esi
  800ce2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ce4:	8b 1c 24             	mov    (%esp),%ebx
  800ce7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ceb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cef:	89 ec                	mov    %ebp,%esp
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 0c             	sub    $0xc,%esp
  800cf9:	89 1c 24             	mov    %ebx,(%esp)
  800cfc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d00:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	b8 10 00 00 00       	mov    $0x10,%eax
  800d0e:	89 d1                	mov    %edx,%ecx
  800d10:	89 d3                	mov    %edx,%ebx
  800d12:	89 d7                	mov    %edx,%edi
  800d14:	89 d6                	mov    %edx,%esi
  800d16:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d18:	8b 1c 24             	mov    (%esp),%ebx
  800d1b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d1f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d23:	89 ec                	mov    %ebp,%esp
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 38             	sub    $0x38,%esp
  800d2d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d30:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d33:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	89 df                	mov    %ebx,%edi
  800d48:	89 de                	mov    %ebx,%esi
  800d4a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7e 28                	jle    800d78 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d54:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d5b:	00 
  800d5c:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800d63:	00 
  800d64:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6b:	00 
  800d6c:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800d73:	e8 e0 08 00 00       	call   801658 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800d78:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d7e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d81:	89 ec                	mov    %ebp,%esp
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 38             	sub    $0x38,%esp
  800d8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d91:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	89 df                	mov    %ebx,%edi
  800da6:	89 de                	mov    %ebx,%esi
  800da8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7e 28                	jle    800dd6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dae:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800db9:	00 
  800dba:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800dc1:	00 
  800dc2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc9:	00 
  800dca:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800dd1:	e8 82 08 00 00       	call   801658 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800dd6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ddc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ddf:	89 ec                	mov    %ebp,%esp
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 38             	sub    $0x38,%esp
  800de9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800def:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	89 cb                	mov    %ecx,%ebx
  800e01:	89 cf                	mov    %ecx,%edi
  800e03:	89 ce                	mov    %ecx,%esi
  800e05:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7e 28                	jle    800e33 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e16:	00 
  800e17:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800e1e:	00 
  800e1f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e26:	00 
  800e27:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800e2e:	e8 25 08 00 00       	call   801658 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e33:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e36:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e39:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e3c:	89 ec                	mov    %ebp,%esp
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 0c             	sub    $0xc,%esp
  800e46:	89 1c 24             	mov    %ebx,(%esp)
  800e49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e51:	be 00 00 00 00       	mov    $0x0,%esi
  800e56:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e69:	8b 1c 24             	mov    (%esp),%ebx
  800e6c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e70:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e74:	89 ec                	mov    %ebp,%esp
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 38             	sub    $0x38,%esp
  800e7e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e81:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e84:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	89 df                	mov    %ebx,%edi
  800e99:	89 de                	mov    %ebx,%esi
  800e9b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	7e 28                	jle    800ec9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800eac:	00 
  800ead:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800eb4:	00 
  800eb5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ebc:	00 
  800ebd:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800ec4:	e8 8f 07 00 00       	call   801658 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ecc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ecf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed2:	89 ec                	mov    %ebp,%esp
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 38             	sub    $0x38,%esp
  800edc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800edf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eea:	b8 09 00 00 00       	mov    $0x9,%eax
  800eef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	89 de                	mov    %ebx,%esi
  800ef9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7e 28                	jle    800f27 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eff:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f03:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800f12:	00 
  800f13:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1a:	00 
  800f1b:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800f22:	e8 31 07 00 00       	call   801658 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f30:	89 ec                	mov    %ebp,%esp
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 38             	sub    $0x38,%esp
  800f3a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f40:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	b8 08 00 00 00       	mov    $0x8,%eax
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	7e 28                	jle    800f85 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f61:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f68:	00 
  800f69:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800f70:	00 
  800f71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f78:	00 
  800f79:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800f80:	e8 d3 06 00 00       	call   801658 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f85:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f88:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8e:	89 ec                	mov    %ebp,%esp
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 38             	sub    $0x38,%esp
  800f98:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	b8 06 00 00 00       	mov    $0x6,%eax
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	89 de                	mov    %ebx,%esi
  800fb5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	7e 28                	jle    800fe3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fc6:	00 
  800fc7:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  800fce:	00 
  800fcf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd6:	00 
  800fd7:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  800fde:	e8 75 06 00 00       	call   801658 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fec:	89 ec                	mov    %ebp,%esp
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 38             	sub    $0x38,%esp
  800ff6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ffc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fff:	b8 05 00 00 00       	mov    $0x5,%eax
  801004:	8b 75 18             	mov    0x18(%ebp),%esi
  801007:	8b 7d 14             	mov    0x14(%ebp),%edi
  80100a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801015:	85 c0                	test   %eax,%eax
  801017:	7e 28                	jle    801041 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801019:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801024:	00 
  801025:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  80102c:	00 
  80102d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801034:	00 
  801035:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  80103c:	e8 17 06 00 00       	call   801658 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801041:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801044:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801047:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104a:	89 ec                	mov    %ebp,%esp
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    

0080104e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 38             	sub    $0x38,%esp
  801054:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801057:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80105a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105d:	be 00 00 00 00       	mov    $0x0,%esi
  801062:	b8 04 00 00 00       	mov    $0x4,%eax
  801067:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	89 f7                	mov    %esi,%edi
  801072:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801074:	85 c0                	test   %eax,%eax
  801076:	7e 28                	jle    8010a0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801078:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801083:	00 
  801084:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  80108b:	00 
  80108c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801093:	00 
  801094:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  80109b:	e8 b8 05 00 00       	call   801658 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a9:	89 ec                	mov    %ebp,%esp
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	89 1c 24             	mov    %ebx,(%esp)
  8010b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010be:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010c8:	89 d1                	mov    %edx,%ecx
  8010ca:	89 d3                	mov    %edx,%ebx
  8010cc:	89 d7                	mov    %edx,%edi
  8010ce:	89 d6                	mov    %edx,%esi
  8010d0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010d2:	8b 1c 24             	mov    (%esp),%ebx
  8010d5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010d9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010dd:	89 ec                	mov    %ebp,%esp
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 0c             	sub    $0xc,%esp
  8010e7:	89 1c 24             	mov    %ebx,(%esp)
  8010ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010fc:	89 d1                	mov    %edx,%ecx
  8010fe:	89 d3                	mov    %edx,%ebx
  801100:	89 d7                	mov    %edx,%edi
  801102:	89 d6                	mov    %edx,%esi
  801104:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801106:	8b 1c 24             	mov    (%esp),%ebx
  801109:	8b 74 24 04          	mov    0x4(%esp),%esi
  80110d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801111:	89 ec                	mov    %ebp,%esp
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 38             	sub    $0x38,%esp
  80111b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801121:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801124:	b9 00 00 00 00       	mov    $0x0,%ecx
  801129:	b8 03 00 00 00       	mov    $0x3,%eax
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	89 cb                	mov    %ecx,%ebx
  801133:	89 cf                	mov    %ecx,%edi
  801135:	89 ce                	mov    %ecx,%esi
  801137:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801139:	85 c0                	test   %eax,%eax
  80113b:	7e 28                	jle    801165 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801141:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801148:	00 
  801149:	c7 44 24 08 a7 1d 80 	movl   $0x801da7,0x8(%esp)
  801150:	00 
  801151:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801158:	00 
  801159:	c7 04 24 c4 1d 80 00 	movl   $0x801dc4,(%esp)
  801160:	e8 f3 04 00 00       	call   801658 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801165:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801168:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80116b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116e:	89 ec                	mov    %ebp,%esp
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
	...

00801174 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80117a:	c7 44 24 08 d2 1d 80 	movl   $0x801dd2,0x8(%esp)
  801181:	00 
  801182:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801189:	00 
  80118a:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  801191:	e8 c2 04 00 00       	call   801658 <_panic>

00801196 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
  80119c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80119f:	c7 04 24 04 14 80 00 	movl   $0x801404,(%esp)
  8011a6:	e8 05 05 00 00       	call   8016b0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011ab:	ba 07 00 00 00       	mov    $0x7,%edx
  8011b0:	89 d0                	mov    %edx,%eax
  8011b2:	cd 30                	int    $0x30
  8011b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	79 20                	jns    8011db <fork+0x45>
		panic("sys_exofork: %e", envid);
  8011bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011bf:	c7 44 24 08 f3 1d 80 	movl   $0x801df3,0x8(%esp)
  8011c6:	00 
  8011c7:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8011ce:	00 
  8011cf:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  8011d6:	e8 7d 04 00 00       	call   801658 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  8011db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8011e2:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  8011e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8011eb:	75 21                	jne    80120e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ed:	e8 ef fe ff ff       	call   8010e1 <sys_getenvid>
  8011f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ff:	a3 0c 20 80 00       	mov    %eax,0x80200c
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801209:	e9 e5 01 00 00       	jmp    8013f3 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80120e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801211:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801218:	a8 01                	test   $0x1,%al
  80121a:	0f 84 4c 01 00 00    	je     80136c <fork+0x1d6>
  801220:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801226:	0f 84 cf 01 00 00    	je     8013fb <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80122c:	c1 e2 16             	shl    $0x16,%edx
  80122f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801232:	89 d3                	mov    %edx,%ebx
  801234:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80123b:	00 
  80123c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801240:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801243:	89 04 24             	mov    %eax,(%esp)
  801246:	e8 03 fe ff ff       	call   80104e <sys_page_alloc>
			if(ret < 0) return ret;
  80124b:	85 c0                	test   %eax,%eax
  80124d:	0f 88 a0 01 00 00    	js     8013f3 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801253:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801257:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80125a:	89 14 24             	mov    %edx,(%esp)
  80125d:	e8 30 fd ff ff       	call   800f92 <sys_page_unmap>
			if(ret < 0) return ret;
  801262:	85 c0                	test   %eax,%eax
  801264:	0f 88 89 01 00 00    	js     8013f3 <fork+0x25d>
  80126a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80126f:	89 de                	mov    %ebx,%esi
  801271:	c1 e6 0c             	shl    $0xc,%esi
  801274:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801277:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80127d:	0f 84 da 00 00 00    	je     80135d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801283:	c1 ee 0c             	shr    $0xc,%esi
  801286:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801289:	a8 01                	test   $0x1,%al
  80128b:	0f 84 cc 00 00 00    	je     80135d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801291:	89 f0                	mov    %esi,%eax
  801293:	c1 e0 0c             	shl    $0xc,%eax
  801296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801299:	e8 43 fe ff ff       	call   8010e1 <sys_getenvid>
  80129e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  8012a1:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8012a4:	89 c6                	mov    %eax,%esi
  8012a6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  8012ac:	25 01 04 00 00       	and    $0x401,%eax
  8012b1:	3d 01 04 00 00       	cmp    $0x401,%eax
  8012b6:	75 3a                	jne    8012f2 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  8012b8:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8012bf:	00 
  8012c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012d5:	89 14 24             	mov    %edx,(%esp)
  8012d8:	e8 13 fd ff ff       	call   800ff0 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  8012dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e4:	c7 04 24 03 1e 80 00 	movl   $0x801e03,(%esp)
  8012eb:	e8 b9 ef ff ff       	call   8002a9 <cprintf>
  8012f0:	eb 6b                	jmp    80135d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  8012f2:	f7 c6 01 00 00 00    	test   $0x1,%esi
  8012f8:	74 14                	je     80130e <fork+0x178>
  8012fa:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801300:	74 0c                	je     80130e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801302:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801308:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80130e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801311:	89 74 24 10          	mov    %esi,0x10(%esp)
  801315:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801319:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80131c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801320:	89 54 24 04          	mov    %edx,0x4(%esp)
  801324:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801327:	89 14 24             	mov    %edx,(%esp)
  80132a:	e8 c1 fc ff ff       	call   800ff0 <sys_page_map>
	if(ret<0) return ret;
  80132f:	85 c0                	test   %eax,%eax
  801331:	0f 88 bc 00 00 00    	js     8013f3 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801337:	89 74 24 10          	mov    %esi,0x10(%esp)
  80133b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80133e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801342:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801345:	89 54 24 08          	mov    %edx,0x8(%esp)
  801349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134d:	89 14 24             	mov    %edx,(%esp)
  801350:	e8 9b fc ff ff       	call   800ff0 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801355:	85 c0                	test   %eax,%eax
  801357:	0f 88 96 00 00 00    	js     8013f3 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80135d:	83 c3 01             	add    $0x1,%ebx
  801360:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801366:	0f 85 03 ff ff ff    	jne    80126f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80136c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801370:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801377:	0f 85 91 fe ff ff    	jne    80120e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80137d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801384:	00 
  801385:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80138c:	ee 
  80138d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801390:	89 04 24             	mov    %eax,(%esp)
  801393:	e8 b6 fc ff ff       	call   80104e <sys_page_alloc>
	if(ret < 0) return ret;
  801398:	85 c0                	test   %eax,%eax
  80139a:	78 57                	js     8013f3 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80139c:	a1 0c 20 80 00       	mov    0x80200c,%eax
  8013a1:	8b 40 64             	mov    0x64(%eax),%eax
  8013a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8013ab:	89 14 24             	mov    %edx,(%esp)
  8013ae:	e8 c5 fa ff ff       	call   800e78 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	78 3c                	js     8013f3 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013b7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013be:	00 
  8013bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013c2:	89 04 24             	mov    %eax,(%esp)
  8013c5:	e8 6a fb ff ff       	call   800f34 <sys_env_set_status>
  8013ca:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  8013cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013cf:	85 d2                	test   %edx,%edx
  8013d1:	79 20                	jns    8013f3 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  8013d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013d7:	c7 44 24 08 1a 1e 80 	movl   $0x801e1a,0x8(%esp)
  8013de:	00 
  8013df:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8013e6:	00 
  8013e7:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  8013ee:	e8 65 02 00 00       	call   801658 <_panic>

	return envid;
}
  8013f3:	83 c4 4c             	add    $0x4c,%esp
  8013f6:	5b                   	pop    %ebx
  8013f7:	5e                   	pop    %esi
  8013f8:	5f                   	pop    %edi
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8013fb:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8013ff:	e9 0a fe ff ff       	jmp    80120e <fork+0x78>

00801404 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	56                   	push   %esi
  801408:	53                   	push   %ebx
  801409:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80140c:	e8 d0 fc ff ff       	call   8010e1 <sys_getenvid>
  801411:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8b 00                	mov    (%eax),%eax
  801418:	89 c6                	mov    %eax,%esi
  80141a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80141d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801424:	f6 c2 02             	test   $0x2,%dl
  801427:	75 2c                	jne    801455 <pgfault+0x51>
  801429:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801430:	f6 c6 08             	test   $0x8,%dh
  801433:	75 20                	jne    801455 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801435:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801439:	c7 44 24 08 68 1e 80 	movl   $0x801e68,0x8(%esp)
  801440:	00 
  801441:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801448:	00 
  801449:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  801450:	e8 03 02 00 00       	call   801658 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801455:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80145c:	00 
  80145d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801464:	00 
  801465:	89 1c 24             	mov    %ebx,(%esp)
  801468:	e8 e1 fb ff ff       	call   80104e <sys_page_alloc>
  80146d:	85 c0                	test   %eax,%eax
  80146f:	79 20                	jns    801491 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801471:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801475:	c7 44 24 08 31 1e 80 	movl   $0x801e31,0x8(%esp)
  80147c:	00 
  80147d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801484:	00 
  801485:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  80148c:	e8 c7 01 00 00       	call   801658 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801491:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801494:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80149b:	00 
  80149c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a0:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8014a7:	e8 03 f6 ff ff       	call   800aaf <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8014ac:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014b3:	00 
  8014b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014c3:	00 
  8014c4:	89 1c 24             	mov    %ebx,(%esp)
  8014c7:	e8 24 fb ff ff       	call   800ff0 <sys_page_map>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	79 20                	jns    8014f0 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  8014d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d4:	c7 44 24 08 43 1e 80 	movl   $0x801e43,0x8(%esp)
  8014db:	00 
  8014dc:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  8014e3:	00 
  8014e4:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  8014eb:	e8 68 01 00 00       	call   801658 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  8014f0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8014f7:	00 
  8014f8:	89 1c 24             	mov    %ebx,(%esp)
  8014fb:	e8 92 fa ff ff       	call   800f92 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801500:	85 c0                	test   %eax,%eax
  801502:	74 20                	je     801524 <pgfault+0x120>
  801504:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801508:	c7 44 24 08 53 1e 80 	movl   $0x801e53,0x8(%esp)
  80150f:	00 
  801510:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801517:	00 
  801518:	c7 04 24 e8 1d 80 00 	movl   $0x801de8,(%esp)
  80151f:	e8 34 01 00 00       	call   801658 <_panic>

}
  801524:	83 c4 20             	add    $0x20,%esp
  801527:	5b                   	pop    %ebx
  801528:	5e                   	pop    %esi
  801529:	5d                   	pop    %ebp
  80152a:	c3                   	ret    
	...

0080152c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801537:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80153a:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  801540:	8b 12                	mov    (%edx),%edx
  801542:	39 ca                	cmp    %ecx,%edx
  801544:	75 0c                	jne    801552 <ipc_find_env+0x26>
			return envs[i].env_id;
  801546:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801549:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	eb 0e                	jmp    801560 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801552:	83 c0 01             	add    $0x1,%eax
  801555:	3d 00 04 00 00       	cmp    $0x400,%eax
  80155a:	75 db                	jne    801537 <ipc_find_env+0xb>
  80155c:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	57                   	push   %edi
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	83 ec 2c             	sub    $0x2c,%esp
  80156b:	8b 75 08             	mov    0x8(%ebp),%esi
  80156e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801571:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  801574:	85 db                	test   %ebx,%ebx
  801576:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80157b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80157e:	8b 45 14             	mov    0x14(%ebp),%eax
  801581:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801585:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801589:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80158d:	89 34 24             	mov    %esi,(%esp)
  801590:	e8 ab f8 ff ff       	call   800e40 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  801595:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801598:	74 e4                	je     80157e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80159a:	85 c0                	test   %eax,%eax
  80159c:	74 28                	je     8015c6 <ipc_send+0x64>
  80159e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015a2:	c7 44 24 0c a6 1e 80 	movl   $0x801ea6,0xc(%esp)
  8015a9:	00 
  8015aa:	c7 44 24 08 89 1e 80 	movl   $0x801e89,0x8(%esp)
  8015b1:	00 
  8015b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8015b9:	00 
  8015ba:	c7 04 24 9c 1e 80 00 	movl   $0x801e9c,(%esp)
  8015c1:	e8 92 00 00 00       	call   801658 <_panic>
	//if(!ret) sys_yield();
}
  8015c6:	83 c4 2c             	add    $0x2c,%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 28             	sub    $0x28,%esp
  8015d4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015d7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015da:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015ed:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015f0:	89 04 24             	mov    %eax,(%esp)
  8015f3:	e8 eb f7 ff ff       	call   800de3 <sys_ipc_recv>
  8015f8:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  8015fa:	e8 e2 fa ff ff       	call   8010e1 <sys_getenvid>
  8015ff:	25 ff 03 00 00       	and    $0x3ff,%eax
  801604:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801607:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80160c:	a3 0c 20 80 00       	mov    %eax,0x80200c
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  801611:	85 f6                	test   %esi,%esi
  801613:	74 0e                	je     801623 <ipc_recv+0x55>
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	85 db                	test   %ebx,%ebx
  80161c:	75 03                	jne    801621 <ipc_recv+0x53>
  80161e:	8b 50 74             	mov    0x74(%eax),%edx
  801621:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  801623:	85 ff                	test   %edi,%edi
  801625:	74 13                	je     80163a <ipc_recv+0x6c>
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
  80162c:	85 db                	test   %ebx,%ebx
  80162e:	75 08                	jne    801638 <ipc_recv+0x6a>
  801630:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801635:	8b 40 78             	mov    0x78(%eax),%eax
  801638:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  80163a:	85 db                	test   %ebx,%ebx
  80163c:	75 08                	jne    801646 <ipc_recv+0x78>
  80163e:	a1 0c 20 80 00       	mov    0x80200c,%eax
  801643:	8b 58 70             	mov    0x70(%eax),%ebx
}
  801646:	89 d8                	mov    %ebx,%eax
  801648:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80164b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80164e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801651:	89 ec                	mov    %ebp,%esp
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    
  801655:	00 00                	add    %al,(%eax)
	...

00801658 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
  80165d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801660:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801663:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  801669:	e8 73 fa ff ff       	call   8010e1 <sys_getenvid>
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801671:	89 54 24 10          	mov    %edx,0x10(%esp)
  801675:	8b 55 08             	mov    0x8(%ebp),%edx
  801678:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80167c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801680:	89 44 24 04          	mov    %eax,0x4(%esp)
  801684:	c7 04 24 b0 1e 80 00 	movl   $0x801eb0,(%esp)
  80168b:	e8 19 ec ff ff       	call   8002a9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801690:	89 74 24 04          	mov    %esi,0x4(%esp)
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	89 04 24             	mov    %eax,(%esp)
  80169a:	e8 a9 eb ff ff       	call   800248 <vcprintf>
	cprintf("\n");
  80169f:	c7 04 24 9a 1e 80 00 	movl   $0x801e9a,(%esp)
  8016a6:	e8 fe eb ff ff       	call   8002a9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8016ab:	cc                   	int3   
  8016ac:	eb fd                	jmp    8016ab <_panic+0x53>
	...

008016b0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8016b7:	83 3d 10 20 80 00 00 	cmpl   $0x0,0x802010
  8016be:	75 5b                	jne    80171b <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8016c0:	e8 1c fa ff ff       	call   8010e1 <sys_getenvid>
  8016c5:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8016c7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016ce:	00 
  8016cf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8016d6:	ee 
  8016d7:	89 04 24             	mov    %eax,(%esp)
  8016da:	e8 6f f9 ff ff       	call   80104e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	74 28                	je     80170b <set_pgfault_handler+0x5b>
  8016e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016e7:	c7 44 24 0c fb 1e 80 	movl   $0x801efb,0xc(%esp)
  8016ee:	00 
  8016ef:	c7 44 24 08 d4 1e 80 	movl   $0x801ed4,0x8(%esp)
  8016f6:	00 
  8016f7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8016fe:	00 
  8016ff:	c7 04 24 ed 1e 80 00 	movl   $0x801eed,(%esp)
  801706:	e8 4d ff ff ff       	call   801658 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80170b:	c7 44 24 04 2c 17 80 	movl   $0x80172c,0x4(%esp)
  801712:	00 
  801713:	89 1c 24             	mov    %ebx,(%esp)
  801716:	e8 5d f7 ff ff       	call   800e78 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	a3 10 20 80 00       	mov    %eax,0x802010
	
}
  801723:	83 c4 24             	add    $0x24,%esp
  801726:	5b                   	pop    %ebx
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    
  801729:	00 00                	add    %al,(%eax)
	...

0080172c <_pgfault_upcall>:
  80172c:	54                   	push   %esp
  80172d:	a1 10 20 80 00       	mov    0x802010,%eax
  801732:	ff d0                	call   *%eax
  801734:	83 c4 04             	add    $0x4,%esp
  801737:	83 c4 08             	add    $0x8,%esp
  80173a:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  80173e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801742:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  801745:	83 e9 04             	sub    $0x4,%ecx
  801748:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  80174c:	61                   	popa   
  80174d:	83 c4 04             	add    $0x4,%esp
  801750:	9d                   	popf   
  801751:	5c                   	pop    %esp
  801752:	c3                   	ret    
	...

00801760 <__udivdi3>:
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	57                   	push   %edi
  801764:	56                   	push   %esi
  801765:	83 ec 10             	sub    $0x10,%esp
  801768:	8b 45 14             	mov    0x14(%ebp),%eax
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 75 10             	mov    0x10(%ebp),%esi
  801771:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801774:	85 c0                	test   %eax,%eax
  801776:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801779:	75 35                	jne    8017b0 <__udivdi3+0x50>
  80177b:	39 fe                	cmp    %edi,%esi
  80177d:	77 61                	ja     8017e0 <__udivdi3+0x80>
  80177f:	85 f6                	test   %esi,%esi
  801781:	75 0b                	jne    80178e <__udivdi3+0x2e>
  801783:	b8 01 00 00 00       	mov    $0x1,%eax
  801788:	31 d2                	xor    %edx,%edx
  80178a:	f7 f6                	div    %esi
  80178c:	89 c6                	mov    %eax,%esi
  80178e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801791:	31 d2                	xor    %edx,%edx
  801793:	89 f8                	mov    %edi,%eax
  801795:	f7 f6                	div    %esi
  801797:	89 c7                	mov    %eax,%edi
  801799:	89 c8                	mov    %ecx,%eax
  80179b:	f7 f6                	div    %esi
  80179d:	89 c1                	mov    %eax,%ecx
  80179f:	89 fa                	mov    %edi,%edx
  8017a1:	89 c8                	mov    %ecx,%eax
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	5e                   	pop    %esi
  8017a7:	5f                   	pop    %edi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    
  8017aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8017b0:	39 f8                	cmp    %edi,%eax
  8017b2:	77 1c                	ja     8017d0 <__udivdi3+0x70>
  8017b4:	0f bd d0             	bsr    %eax,%edx
  8017b7:	83 f2 1f             	xor    $0x1f,%edx
  8017ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8017bd:	75 39                	jne    8017f8 <__udivdi3+0x98>
  8017bf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8017c2:	0f 86 a0 00 00 00    	jbe    801868 <__udivdi3+0x108>
  8017c8:	39 f8                	cmp    %edi,%eax
  8017ca:	0f 82 98 00 00 00    	jb     801868 <__udivdi3+0x108>
  8017d0:	31 ff                	xor    %edi,%edi
  8017d2:	31 c9                	xor    %ecx,%ecx
  8017d4:	89 c8                	mov    %ecx,%eax
  8017d6:	89 fa                	mov    %edi,%edx
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	5e                   	pop    %esi
  8017dc:	5f                   	pop    %edi
  8017dd:	5d                   	pop    %ebp
  8017de:	c3                   	ret    
  8017df:	90                   	nop
  8017e0:	89 d1                	mov    %edx,%ecx
  8017e2:	89 fa                	mov    %edi,%edx
  8017e4:	89 c8                	mov    %ecx,%eax
  8017e6:	31 ff                	xor    %edi,%edi
  8017e8:	f7 f6                	div    %esi
  8017ea:	89 c1                	mov    %eax,%ecx
  8017ec:	89 fa                	mov    %edi,%edx
  8017ee:	89 c8                	mov    %ecx,%eax
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	5e                   	pop    %esi
  8017f4:	5f                   	pop    %edi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    
  8017f7:	90                   	nop
  8017f8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8017fc:	89 f2                	mov    %esi,%edx
  8017fe:	d3 e0                	shl    %cl,%eax
  801800:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801803:	b8 20 00 00 00       	mov    $0x20,%eax
  801808:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80180b:	89 c1                	mov    %eax,%ecx
  80180d:	d3 ea                	shr    %cl,%edx
  80180f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801813:	0b 55 ec             	or     -0x14(%ebp),%edx
  801816:	d3 e6                	shl    %cl,%esi
  801818:	89 c1                	mov    %eax,%ecx
  80181a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80181d:	89 fe                	mov    %edi,%esi
  80181f:	d3 ee                	shr    %cl,%esi
  801821:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801825:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182b:	d3 e7                	shl    %cl,%edi
  80182d:	89 c1                	mov    %eax,%ecx
  80182f:	d3 ea                	shr    %cl,%edx
  801831:	09 d7                	or     %edx,%edi
  801833:	89 f2                	mov    %esi,%edx
  801835:	89 f8                	mov    %edi,%eax
  801837:	f7 75 ec             	divl   -0x14(%ebp)
  80183a:	89 d6                	mov    %edx,%esi
  80183c:	89 c7                	mov    %eax,%edi
  80183e:	f7 65 e8             	mull   -0x18(%ebp)
  801841:	39 d6                	cmp    %edx,%esi
  801843:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801846:	72 30                	jb     801878 <__udivdi3+0x118>
  801848:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80184b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80184f:	d3 e2                	shl    %cl,%edx
  801851:	39 c2                	cmp    %eax,%edx
  801853:	73 05                	jae    80185a <__udivdi3+0xfa>
  801855:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801858:	74 1e                	je     801878 <__udivdi3+0x118>
  80185a:	89 f9                	mov    %edi,%ecx
  80185c:	31 ff                	xor    %edi,%edi
  80185e:	e9 71 ff ff ff       	jmp    8017d4 <__udivdi3+0x74>
  801863:	90                   	nop
  801864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801868:	31 ff                	xor    %edi,%edi
  80186a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80186f:	e9 60 ff ff ff       	jmp    8017d4 <__udivdi3+0x74>
  801874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801878:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80187b:	31 ff                	xor    %edi,%edi
  80187d:	89 c8                	mov    %ecx,%eax
  80187f:	89 fa                	mov    %edi,%edx
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    
	...

00801890 <__umoddi3>:
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	83 ec 20             	sub    $0x20,%esp
  801898:	8b 55 14             	mov    0x14(%ebp),%edx
  80189b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8018a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018a4:	85 d2                	test   %edx,%edx
  8018a6:	89 c8                	mov    %ecx,%eax
  8018a8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8018ab:	75 13                	jne    8018c0 <__umoddi3+0x30>
  8018ad:	39 f7                	cmp    %esi,%edi
  8018af:	76 3f                	jbe    8018f0 <__umoddi3+0x60>
  8018b1:	89 f2                	mov    %esi,%edx
  8018b3:	f7 f7                	div    %edi
  8018b5:	89 d0                	mov    %edx,%eax
  8018b7:	31 d2                	xor    %edx,%edx
  8018b9:	83 c4 20             	add    $0x20,%esp
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    
  8018c0:	39 f2                	cmp    %esi,%edx
  8018c2:	77 4c                	ja     801910 <__umoddi3+0x80>
  8018c4:	0f bd ca             	bsr    %edx,%ecx
  8018c7:	83 f1 1f             	xor    $0x1f,%ecx
  8018ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8018cd:	75 51                	jne    801920 <__umoddi3+0x90>
  8018cf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8018d2:	0f 87 e0 00 00 00    	ja     8019b8 <__umoddi3+0x128>
  8018d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018db:	29 f8                	sub    %edi,%eax
  8018dd:	19 d6                	sbb    %edx,%esi
  8018df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e5:	89 f2                	mov    %esi,%edx
  8018e7:	83 c4 20             	add    $0x20,%esp
  8018ea:	5e                   	pop    %esi
  8018eb:	5f                   	pop    %edi
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    
  8018ee:	66 90                	xchg   %ax,%ax
  8018f0:	85 ff                	test   %edi,%edi
  8018f2:	75 0b                	jne    8018ff <__umoddi3+0x6f>
  8018f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f9:	31 d2                	xor    %edx,%edx
  8018fb:	f7 f7                	div    %edi
  8018fd:	89 c7                	mov    %eax,%edi
  8018ff:	89 f0                	mov    %esi,%eax
  801901:	31 d2                	xor    %edx,%edx
  801903:	f7 f7                	div    %edi
  801905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801908:	f7 f7                	div    %edi
  80190a:	eb a9                	jmp    8018b5 <__umoddi3+0x25>
  80190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801910:	89 c8                	mov    %ecx,%eax
  801912:	89 f2                	mov    %esi,%edx
  801914:	83 c4 20             	add    $0x20,%esp
  801917:	5e                   	pop    %esi
  801918:	5f                   	pop    %edi
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
  80191b:	90                   	nop
  80191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801920:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801924:	d3 e2                	shl    %cl,%edx
  801926:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801929:	ba 20 00 00 00       	mov    $0x20,%edx
  80192e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801931:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801934:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801938:	89 fa                	mov    %edi,%edx
  80193a:	d3 ea                	shr    %cl,%edx
  80193c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801940:	0b 55 f4             	or     -0xc(%ebp),%edx
  801943:	d3 e7                	shl    %cl,%edi
  801945:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801949:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80194c:	89 f2                	mov    %esi,%edx
  80194e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801951:	89 c7                	mov    %eax,%edi
  801953:	d3 ea                	shr    %cl,%edx
  801955:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801959:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80195c:	89 c2                	mov    %eax,%edx
  80195e:	d3 e6                	shl    %cl,%esi
  801960:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801964:	d3 ea                	shr    %cl,%edx
  801966:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80196a:	09 d6                	or     %edx,%esi
  80196c:	89 f0                	mov    %esi,%eax
  80196e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801971:	d3 e7                	shl    %cl,%edi
  801973:	89 f2                	mov    %esi,%edx
  801975:	f7 75 f4             	divl   -0xc(%ebp)
  801978:	89 d6                	mov    %edx,%esi
  80197a:	f7 65 e8             	mull   -0x18(%ebp)
  80197d:	39 d6                	cmp    %edx,%esi
  80197f:	72 2b                	jb     8019ac <__umoddi3+0x11c>
  801981:	39 c7                	cmp    %eax,%edi
  801983:	72 23                	jb     8019a8 <__umoddi3+0x118>
  801985:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801989:	29 c7                	sub    %eax,%edi
  80198b:	19 d6                	sbb    %edx,%esi
  80198d:	89 f0                	mov    %esi,%eax
  80198f:	89 f2                	mov    %esi,%edx
  801991:	d3 ef                	shr    %cl,%edi
  801993:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801997:	d3 e0                	shl    %cl,%eax
  801999:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80199d:	09 f8                	or     %edi,%eax
  80199f:	d3 ea                	shr    %cl,%edx
  8019a1:	83 c4 20             	add    $0x20,%esp
  8019a4:	5e                   	pop    %esi
  8019a5:	5f                   	pop    %edi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
  8019a8:	39 d6                	cmp    %edx,%esi
  8019aa:	75 d9                	jne    801985 <__umoddi3+0xf5>
  8019ac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8019af:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8019b2:	eb d1                	jmp    801985 <__umoddi3+0xf5>
  8019b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8019b8:	39 f2                	cmp    %esi,%edx
  8019ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8019c0:	0f 82 12 ff ff ff    	jb     8018d8 <__umoddi3+0x48>
  8019c6:	e9 17 ff ff ff       	jmp    8018e2 <__umoddi3+0x52>
