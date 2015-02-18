
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 93 02 00 00       	call   8002c4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800040:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800043:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800046:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004d:	00 
  80004e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800052:	89 1c 24             	mov    %ebx,(%esp)
  800055:	e8 7b 19 00 00       	call   8019d5 <readn>
  80005a:	83 f8 04             	cmp    $0x4,%eax
  80005d:	74 2e                	je     80008d <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005f:	85 c0                	test   %eax,%eax
  800061:	ba 00 00 00 00       	mov    $0x0,%edx
  800066:	0f 4e d0             	cmovle %eax,%edx
  800069:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800071:	c7 44 24 08 a0 2e 80 	movl   $0x802ea0,0x8(%esp)
  800078:	00 
  800079:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800080:	00 
  800081:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  800088:	e8 9b 02 00 00       	call   800328 <_panic>

	cprintf("%d\n", p);
  80008d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800090:	89 44 24 04          	mov    %eax,0x4(%esp)
  800094:	c7 04 24 13 35 80 00 	movl   $0x803513,(%esp)
  80009b:	e8 41 03 00 00       	call   8003e1 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000a0:	89 3c 24             	mov    %edi,(%esp)
  8000a3:	e8 36 26 00 00       	call   8026de <pipe>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	79 20                	jns    8000cf <primeproc+0x9b>
		panic("pipe: %e", i);
  8000af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b3:	c7 44 24 08 e1 2e 80 	movl   $0x802ee1,0x8(%esp)
  8000ba:	00 
  8000bb:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c2:	00 
  8000c3:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  8000ca:	e8 59 02 00 00       	call   800328 <_panic>
	if ((id = fork()) < 0)
  8000cf:	e8 02 12 00 00       	call   8012d6 <fork>
  8000d4:	85 c0                	test   %eax,%eax
  8000d6:	79 20                	jns    8000f8 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000dc:	c7 44 24 08 da 32 80 	movl   $0x8032da,0x8(%esp)
  8000e3:	00 
  8000e4:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000eb:	00 
  8000ec:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  8000f3:	e8 30 02 00 00       	call   800328 <_panic>
	if (id == 0) {
  8000f8:	85 c0                	test   %eax,%eax
  8000fa:	75 1b                	jne    800117 <primeproc+0xe3>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 aa 19 00 00       	call   801aae <close>
		close(pfd[1]);
  800104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800107:	89 04 24             	mov    %eax,(%esp)
  80010a:	e8 9f 19 00 00       	call   801aae <close>
		fd = pfd[0];
  80010f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800112:	e9 2f ff ff ff       	jmp    800046 <primeproc+0x12>
	}

	close(pfd[0]);
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 8c 19 00 00       	call   801aae <close>
	wfd = pfd[1];
  800122:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800125:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800128:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012f:	00 
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 99 18 00 00       	call   8019d5 <readn>
  80013c:	83 f8 04             	cmp    $0x4,%eax
  80013f:	74 39                	je     80017a <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800141:	85 c0                	test   %eax,%eax
  800143:	ba 00 00 00 00       	mov    $0x0,%edx
  800148:	0f 4e d0             	cmovle %eax,%edx
  80014b:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014f:	89 44 24 14          	mov    %eax,0x14(%esp)
  800153:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015e:	c7 44 24 08 ea 2e 80 	movl   $0x802eea,0x8(%esp)
  800165:	00 
  800166:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016d:	00 
  80016e:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  800175:	e8 ae 01 00 00       	call   800328 <_panic>
		if (i%p)
  80017a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 fa 1f             	sar    $0x1f,%edx
  800182:	f7 7d e0             	idivl  -0x20(%ebp)
  800185:	85 d2                	test   %edx,%edx
  800187:	74 9f                	je     800128 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800189:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800190:	00 
  800191:	89 74 24 04          	mov    %esi,0x4(%esp)
  800195:	89 3c 24             	mov    %edi,(%esp)
  800198:	e8 21 17 00 00       	call   8018be <write>
  80019d:	83 f8 04             	cmp    $0x4,%eax
  8001a0:	74 86                	je     800128 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a9:	0f 4e d0             	cmovle %eax,%edx
  8001ac:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 06 2f 80 	movl   $0x802f06,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  8001d2:	e8 51 01 00 00       	call   800328 <_panic>

008001d7 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	53                   	push   %ebx
  8001db:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001de:	c7 05 00 40 80 00 20 	movl   $0x802f20,0x804000
  8001e5:	2f 80 00 

	if ((i=pipe(p)) < 0)
  8001e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001eb:	89 04 24             	mov    %eax,(%esp)
  8001ee:	e8 eb 24 00 00       	call   8026de <pipe>
  8001f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	79 20                	jns    80021a <umain+0x43>
		panic("pipe: %e", i);
  8001fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fe:	c7 44 24 08 e1 2e 80 	movl   $0x802ee1,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  800215:	e8 0e 01 00 00       	call   800328 <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80021a:	e8 b7 10 00 00       	call   8012d6 <fork>
  80021f:	85 c0                	test   %eax,%eax
  800221:	79 20                	jns    800243 <umain+0x6c>
		panic("fork: %e", id);
  800223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800227:	c7 44 24 08 da 32 80 	movl   $0x8032da,0x8(%esp)
  80022e:	00 
  80022f:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800236:	00 
  800237:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  80023e:	e8 e5 00 00 00       	call   800328 <_panic>

	if (id == 0) {
  800243:	85 c0                	test   %eax,%eax
  800245:	75 16                	jne    80025d <umain+0x86>
		close(p[1]);
  800247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 5c 18 00 00       	call   801aae <close>
		primeproc(p[0]);
  800252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	e8 d7 fd ff ff       	call   800034 <primeproc>
	}

	close(p[0]);
  80025d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800260:	89 04 24             	mov    %eax,(%esp)
  800263:	e8 46 18 00 00       	call   801aae <close>

	// feed all the integers through
	for (i=2;; i++)
  800268:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026f:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800272:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800279:	00 
  80027a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800281:	89 04 24             	mov    %eax,(%esp)
  800284:	e8 35 16 00 00       	call   8018be <write>
  800289:	83 f8 04             	cmp    $0x4,%eax
  80028c:	74 2e                	je     8002bc <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  80028e:	85 c0                	test   %eax,%eax
  800290:	ba 00 00 00 00       	mov    $0x0,%edx
  800295:	0f 4e d0             	cmovle %eax,%edx
  800298:	89 54 24 10          	mov    %edx,0x10(%esp)
  80029c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a0:	c7 44 24 08 2b 2f 80 	movl   $0x802f2b,0x8(%esp)
  8002a7:	00 
  8002a8:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002af:	00 
  8002b0:	c7 04 24 cf 2e 80 00 	movl   $0x802ecf,(%esp)
  8002b7:	e8 6c 00 00 00       	call   800328 <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002c0:	eb b0                	jmp    800272 <umain+0x9b>
	...

008002c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 18             	sub    $0x18,%esp
  8002ca:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002cd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8002d6:	e8 46 0f 00 00       	call   801221 <sys_getenvid>
  8002db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e3:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8002e8:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ed:	85 f6                	test   %esi,%esi
  8002ef:	7e 07                	jle    8002f8 <libmain+0x34>
		binaryname = argv[0];
  8002f1:	8b 03                	mov    (%ebx),%eax
  8002f3:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8002f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002fc:	89 34 24             	mov    %esi,(%esp)
  8002ff:	e8 d3 fe ff ff       	call   8001d7 <umain>

	// exit gracefully
	exit();
  800304:	e8 0b 00 00 00       	call   800314 <exit>
}
  800309:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80030c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80030f:	89 ec                	mov    %ebp,%esp
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    
	...

00800314 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80031a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800321:	e8 2f 0f 00 00       	call   801255 <sys_env_destroy>
}
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
  80032d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800330:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800333:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  800339:	e8 e3 0e 00 00       	call   801221 <sys_getenvid>
  80033e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800341:	89 54 24 10          	mov    %edx,0x10(%esp)
  800345:	8b 55 08             	mov    0x8(%ebp),%edx
  800348:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80034c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800350:	89 44 24 04          	mov    %eax,0x4(%esp)
  800354:	c7 04 24 50 2f 80 00 	movl   $0x802f50,(%esp)
  80035b:	e8 81 00 00 00       	call   8003e1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800360:	89 74 24 04          	mov    %esi,0x4(%esp)
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	89 04 24             	mov    %eax,(%esp)
  80036a:	e8 11 00 00 00       	call   800380 <vcprintf>
	cprintf("\n");
  80036f:	c7 04 24 15 35 80 00 	movl   $0x803515,(%esp)
  800376:	e8 66 00 00 00       	call   8003e1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037b:	cc                   	int3   
  80037c:	eb fd                	jmp    80037b <_panic+0x53>
	...

00800380 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800389:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800390:	00 00 00 
	b.cnt = 0;
  800393:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80039a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b5:	c7 04 24 fb 03 80 00 	movl   $0x8003fb,(%esp)
  8003bc:	e8 be 01 00 00       	call   80057f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003c1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003d1:	89 04 24             	mov    %eax,(%esp)
  8003d4:	e8 27 0a 00 00       	call   800e00 <sys_cputs>

	return b.cnt;
}
  8003d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8003e7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8003ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 04 24             	mov    %eax,(%esp)
  8003f4:	e8 87 ff ff ff       	call   800380 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	53                   	push   %ebx
  8003ff:	83 ec 14             	sub    $0x14,%esp
  800402:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800405:	8b 03                	mov    (%ebx),%eax
  800407:	8b 55 08             	mov    0x8(%ebp),%edx
  80040a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80040e:	83 c0 01             	add    $0x1,%eax
  800411:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800413:	3d ff 00 00 00       	cmp    $0xff,%eax
  800418:	75 19                	jne    800433 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80041a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800421:	00 
  800422:	8d 43 08             	lea    0x8(%ebx),%eax
  800425:	89 04 24             	mov    %eax,(%esp)
  800428:	e8 d3 09 00 00       	call   800e00 <sys_cputs>
		b->idx = 0;
  80042d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800433:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800437:	83 c4 14             	add    $0x14,%esp
  80043a:	5b                   	pop    %ebx
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    
  80043d:	00 00                	add    %al,(%eax)
	...

00800440 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 4c             	sub    $0x4c,%esp
  800449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044c:	89 d6                	mov    %edx,%esi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800454:	8b 55 0c             	mov    0xc(%ebp),%edx
  800457:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800460:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800463:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800466:	b9 00 00 00 00       	mov    $0x0,%ecx
  80046b:	39 d1                	cmp    %edx,%ecx
  80046d:	72 07                	jb     800476 <printnum+0x36>
  80046f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800472:	39 d0                	cmp    %edx,%eax
  800474:	77 69                	ja     8004df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80047a:	83 eb 01             	sub    $0x1,%ebx
  80047d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800481:	89 44 24 08          	mov    %eax,0x8(%esp)
  800485:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800489:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80048d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800490:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800493:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800496:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80049a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004a1:	00 
  8004a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004af:	e8 6c 27 00 00       	call   802c20 <__udivdi3>
  8004b4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004b7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004ba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004c2:	89 04 24             	mov    %eax,(%esp)
  8004c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c9:	89 f2                	mov    %esi,%edx
  8004cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ce:	e8 6d ff ff ff       	call   800440 <printnum>
  8004d3:	eb 11                	jmp    8004e6 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d9:	89 3c 24             	mov    %edi,(%esp)
  8004dc:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004df:	83 eb 01             	sub    $0x1,%ebx
  8004e2:	85 db                	test   %ebx,%ebx
  8004e4:	7f ef                	jg     8004d5 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ea:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004fc:	00 
  8004fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800500:	89 14 24             	mov    %edx,(%esp)
  800503:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800506:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80050a:	e8 41 28 00 00       	call   802d50 <__umoddi3>
  80050f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800513:	0f be 80 73 2f 80 00 	movsbl 0x802f73(%eax),%eax
  80051a:	89 04 24             	mov    %eax,(%esp)
  80051d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800520:	83 c4 4c             	add    $0x4c,%esp
  800523:	5b                   	pop    %ebx
  800524:	5e                   	pop    %esi
  800525:	5f                   	pop    %edi
  800526:	5d                   	pop    %ebp
  800527:	c3                   	ret    

00800528 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80052b:	83 fa 01             	cmp    $0x1,%edx
  80052e:	7e 0e                	jle    80053e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800530:	8b 10                	mov    (%eax),%edx
  800532:	8d 4a 08             	lea    0x8(%edx),%ecx
  800535:	89 08                	mov    %ecx,(%eax)
  800537:	8b 02                	mov    (%edx),%eax
  800539:	8b 52 04             	mov    0x4(%edx),%edx
  80053c:	eb 22                	jmp    800560 <getuint+0x38>
	else if (lflag)
  80053e:	85 d2                	test   %edx,%edx
  800540:	74 10                	je     800552 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800542:	8b 10                	mov    (%eax),%edx
  800544:	8d 4a 04             	lea    0x4(%edx),%ecx
  800547:	89 08                	mov    %ecx,(%eax)
  800549:	8b 02                	mov    (%edx),%eax
  80054b:	ba 00 00 00 00       	mov    $0x0,%edx
  800550:	eb 0e                	jmp    800560 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800552:	8b 10                	mov    (%eax),%edx
  800554:	8d 4a 04             	lea    0x4(%edx),%ecx
  800557:	89 08                	mov    %ecx,(%eax)
  800559:	8b 02                	mov    (%edx),%eax
  80055b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800560:	5d                   	pop    %ebp
  800561:	c3                   	ret    

00800562 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800568:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80056c:	8b 10                	mov    (%eax),%edx
  80056e:	3b 50 04             	cmp    0x4(%eax),%edx
  800571:	73 0a                	jae    80057d <sprintputch+0x1b>
		*b->buf++ = ch;
  800573:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800576:	88 0a                	mov    %cl,(%edx)
  800578:	83 c2 01             	add    $0x1,%edx
  80057b:	89 10                	mov    %edx,(%eax)
}
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	57                   	push   %edi
  800583:	56                   	push   %esi
  800584:	53                   	push   %ebx
  800585:	83 ec 4c             	sub    $0x4c,%esp
  800588:	8b 7d 08             	mov    0x8(%ebp),%edi
  80058b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80058e:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800591:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800598:	eb 11                	jmp    8005ab <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80059a:	85 c0                	test   %eax,%eax
  80059c:	0f 84 b6 03 00 00    	je     800958 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8005a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a6:	89 04 24             	mov    %eax,(%esp)
  8005a9:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ab:	0f b6 03             	movzbl (%ebx),%eax
  8005ae:	83 c3 01             	add    $0x1,%ebx
  8005b1:	83 f8 25             	cmp    $0x25,%eax
  8005b4:	75 e4                	jne    80059a <vprintfmt+0x1b>
  8005b6:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8005ba:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8005c1:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8005c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d7:	eb 06                	jmp    8005df <vprintfmt+0x60>
  8005d9:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8005dd:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	0f b6 0b             	movzbl (%ebx),%ecx
  8005e2:	0f b6 c1             	movzbl %cl,%eax
  8005e5:	8d 53 01             	lea    0x1(%ebx),%edx
  8005e8:	83 e9 23             	sub    $0x23,%ecx
  8005eb:	80 f9 55             	cmp    $0x55,%cl
  8005ee:	0f 87 47 03 00 00    	ja     80093b <vprintfmt+0x3bc>
  8005f4:	0f b6 c9             	movzbl %cl,%ecx
  8005f7:	ff 24 8d c0 30 80 00 	jmp    *0x8030c0(,%ecx,4)
  8005fe:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800602:	eb d9                	jmp    8005dd <vprintfmt+0x5e>
  800604:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80060b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800610:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800613:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800617:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80061a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80061d:	83 fb 09             	cmp    $0x9,%ebx
  800620:	77 30                	ja     800652 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800622:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800625:	eb e9                	jmp    800610 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 48 04             	lea    0x4(%eax),%ecx
  80062d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800635:	eb 1e                	jmp    800655 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063b:	b8 00 00 00 00       	mov    $0x0,%eax
  800640:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800644:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800647:	eb 94                	jmp    8005dd <vprintfmt+0x5e>
  800649:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800650:	eb 8b                	jmp    8005dd <vprintfmt+0x5e>
  800652:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800655:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800659:	79 82                	jns    8005dd <vprintfmt+0x5e>
  80065b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80065e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800661:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800664:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800667:	e9 71 ff ff ff       	jmp    8005dd <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80066c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800670:	e9 68 ff ff ff       	jmp    8005dd <vprintfmt+0x5e>
  800675:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 50 04             	lea    0x4(%eax),%edx
  80067e:	89 55 14             	mov    %edx,0x14(%ebp)
  800681:	89 74 24 04          	mov    %esi,0x4(%esp)
  800685:	8b 00                	mov    (%eax),%eax
  800687:	89 04 24             	mov    %eax,(%esp)
  80068a:	ff d7                	call   *%edi
  80068c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80068f:	e9 17 ff ff ff       	jmp    8005ab <vprintfmt+0x2c>
  800694:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 50 04             	lea    0x4(%eax),%edx
  80069d:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 c2                	mov    %eax,%edx
  8006a4:	c1 fa 1f             	sar    $0x1f,%edx
  8006a7:	31 d0                	xor    %edx,%eax
  8006a9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ab:	83 f8 11             	cmp    $0x11,%eax
  8006ae:	7f 0b                	jg     8006bb <vprintfmt+0x13c>
  8006b0:	8b 14 85 20 32 80 00 	mov    0x803220(,%eax,4),%edx
  8006b7:	85 d2                	test   %edx,%edx
  8006b9:	75 20                	jne    8006db <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8006bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006bf:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  8006c6:	00 
  8006c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006cb:	89 3c 24             	mov    %edi,(%esp)
  8006ce:	e8 0d 03 00 00       	call   8009e0 <printfmt>
  8006d3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006d6:	e9 d0 fe ff ff       	jmp    8005ab <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006df:	c7 44 24 08 32 34 80 	movl   $0x803432,0x8(%esp)
  8006e6:	00 
  8006e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006eb:	89 3c 24             	mov    %edi,(%esp)
  8006ee:	e8 ed 02 00 00       	call   8009e0 <printfmt>
  8006f3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006f6:	e9 b0 fe ff ff       	jmp    8005ab <vprintfmt+0x2c>
  8006fb:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006fe:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800704:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	89 55 14             	mov    %edx,0x14(%ebp)
  800710:	8b 18                	mov    (%eax),%ebx
  800712:	85 db                	test   %ebx,%ebx
  800714:	b8 8d 2f 80 00       	mov    $0x802f8d,%eax
  800719:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80071c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800720:	7e 76                	jle    800798 <vprintfmt+0x219>
  800722:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800726:	74 7a                	je     8007a2 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800728:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80072c:	89 1c 24             	mov    %ebx,(%esp)
  80072f:	e8 f4 02 00 00       	call   800a28 <strnlen>
  800734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800739:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80073d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800740:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800743:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800745:	eb 0f                	jmp    800756 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800747:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800753:	83 eb 01             	sub    $0x1,%ebx
  800756:	85 db                	test   %ebx,%ebx
  800758:	7f ed                	jg     800747 <vprintfmt+0x1c8>
  80075a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80075d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800760:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800763:	89 f7                	mov    %esi,%edi
  800765:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800768:	eb 40                	jmp    8007aa <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80076a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80076e:	74 18                	je     800788 <vprintfmt+0x209>
  800770:	8d 50 e0             	lea    -0x20(%eax),%edx
  800773:	83 fa 5e             	cmp    $0x5e,%edx
  800776:	76 10                	jbe    800788 <vprintfmt+0x209>
					putch('?', putdat);
  800778:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800783:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800786:	eb 0a                	jmp    800792 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800788:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078c:	89 04 24             	mov    %eax,(%esp)
  80078f:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800792:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800796:	eb 12                	jmp    8007aa <vprintfmt+0x22b>
  800798:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80079b:	89 f7                	mov    %esi,%edi
  80079d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007a0:	eb 08                	jmp    8007aa <vprintfmt+0x22b>
  8007a2:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8007a5:	89 f7                	mov    %esi,%edi
  8007a7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007aa:	0f be 03             	movsbl (%ebx),%eax
  8007ad:	83 c3 01             	add    $0x1,%ebx
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	74 25                	je     8007d9 <vprintfmt+0x25a>
  8007b4:	85 f6                	test   %esi,%esi
  8007b6:	78 b2                	js     80076a <vprintfmt+0x1eb>
  8007b8:	83 ee 01             	sub    $0x1,%esi
  8007bb:	79 ad                	jns    80076a <vprintfmt+0x1eb>
  8007bd:	89 fe                	mov    %edi,%esi
  8007bf:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8007c2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8007c5:	eb 1a                	jmp    8007e1 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007d2:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d4:	83 eb 01             	sub    $0x1,%ebx
  8007d7:	eb 08                	jmp    8007e1 <vprintfmt+0x262>
  8007d9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8007dc:	89 fe                	mov    %edi,%esi
  8007de:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8007e1:	85 db                	test   %ebx,%ebx
  8007e3:	7f e2                	jg     8007c7 <vprintfmt+0x248>
  8007e5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8007e8:	e9 be fd ff ff       	jmp    8005ab <vprintfmt+0x2c>
  8007ed:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007f3:	83 f9 01             	cmp    $0x1,%ecx
  8007f6:	7e 16                	jle    80080e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8d 50 08             	lea    0x8(%eax),%edx
  8007fe:	89 55 14             	mov    %edx,0x14(%ebp)
  800801:	8b 10                	mov    (%eax),%edx
  800803:	8b 48 04             	mov    0x4(%eax),%ecx
  800806:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800809:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80080c:	eb 32                	jmp    800840 <vprintfmt+0x2c1>
	else if (lflag)
  80080e:	85 c9                	test   %ecx,%ecx
  800810:	74 18                	je     80082a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8d 50 04             	lea    0x4(%eax),%edx
  800818:	89 55 14             	mov    %edx,0x14(%ebp)
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800820:	89 c1                	mov    %eax,%ecx
  800822:	c1 f9 1f             	sar    $0x1f,%ecx
  800825:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800828:	eb 16                	jmp    800840 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8d 50 04             	lea    0x4(%eax),%edx
  800830:	89 55 14             	mov    %edx,0x14(%ebp)
  800833:	8b 00                	mov    (%eax),%eax
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 c2                	mov    %eax,%edx
  80083a:	c1 fa 1f             	sar    $0x1f,%edx
  80083d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800840:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800843:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800846:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80084b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80084f:	0f 89 a7 00 00 00    	jns    8008fc <vprintfmt+0x37d>
				putch('-', putdat);
  800855:	89 74 24 04          	mov    %esi,0x4(%esp)
  800859:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800860:	ff d7                	call   *%edi
				num = -(long long) num;
  800862:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800865:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800868:	f7 d9                	neg    %ecx
  80086a:	83 d3 00             	adc    $0x0,%ebx
  80086d:	f7 db                	neg    %ebx
  80086f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800874:	e9 83 00 00 00       	jmp    8008fc <vprintfmt+0x37d>
  800879:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80087c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80087f:	89 ca                	mov    %ecx,%edx
  800881:	8d 45 14             	lea    0x14(%ebp),%eax
  800884:	e8 9f fc ff ff       	call   800528 <getuint>
  800889:	89 c1                	mov    %eax,%ecx
  80088b:	89 d3                	mov    %edx,%ebx
  80088d:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800892:	eb 68                	jmp    8008fc <vprintfmt+0x37d>
  800894:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800897:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80089a:	89 ca                	mov    %ecx,%edx
  80089c:	8d 45 14             	lea    0x14(%ebp),%eax
  80089f:	e8 84 fc ff ff       	call   800528 <getuint>
  8008a4:	89 c1                	mov    %eax,%ecx
  8008a6:	89 d3                	mov    %edx,%ebx
  8008a8:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8008ad:	eb 4d                	jmp    8008fc <vprintfmt+0x37d>
  8008af:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8008b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008b6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008bd:	ff d7                	call   *%edi
			putch('x', putdat);
  8008bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c3:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008ca:	ff d7                	call   *%edi
			num = (unsigned long long)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8d 50 04             	lea    0x4(%eax),%edx
  8008d2:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d5:	8b 08                	mov    (%eax),%ecx
  8008d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008dc:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8008e1:	eb 19                	jmp    8008fc <vprintfmt+0x37d>
  8008e3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008e6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008e9:	89 ca                	mov    %ecx,%edx
  8008eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ee:	e8 35 fc ff ff       	call   800528 <getuint>
  8008f3:	89 c1                	mov    %eax,%ecx
  8008f5:	89 d3                	mov    %edx,%ebx
  8008f7:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008fc:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800900:	89 54 24 10          	mov    %edx,0x10(%esp)
  800904:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800907:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80090b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80090f:	89 0c 24             	mov    %ecx,(%esp)
  800912:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800916:	89 f2                	mov    %esi,%edx
  800918:	89 f8                	mov    %edi,%eax
  80091a:	e8 21 fb ff ff       	call   800440 <printnum>
  80091f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800922:	e9 84 fc ff ff       	jmp    8005ab <vprintfmt+0x2c>
  800927:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80092a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80092e:	89 04 24             	mov    %eax,(%esp)
  800931:	ff d7                	call   *%edi
  800933:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800936:	e9 70 fc ff ff       	jmp    8005ab <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80093b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80093f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800946:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800948:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80094b:	80 38 25             	cmpb   $0x25,(%eax)
  80094e:	0f 84 57 fc ff ff    	je     8005ab <vprintfmt+0x2c>
  800954:	89 c3                	mov    %eax,%ebx
  800956:	eb f0                	jmp    800948 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800958:	83 c4 4c             	add    $0x4c,%esp
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5f                   	pop    %edi
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 28             	sub    $0x28,%esp
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80096c:	85 c0                	test   %eax,%eax
  80096e:	74 04                	je     800974 <vsnprintf+0x14>
  800970:	85 d2                	test   %edx,%edx
  800972:	7f 07                	jg     80097b <vsnprintf+0x1b>
  800974:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800979:	eb 3b                	jmp    8009b6 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80097e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800993:	8b 45 10             	mov    0x10(%ebp),%eax
  800996:	89 44 24 08          	mov    %eax,0x8(%esp)
  80099a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a1:	c7 04 24 62 05 80 00 	movl   $0x800562,(%esp)
  8009a8:	e8 d2 fb ff ff       	call   80057f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    

008009b8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8009be:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8009c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 04 24             	mov    %eax,(%esp)
  8009d9:	e8 82 ff ff ff       	call   800960 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8009e6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8009e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	89 04 24             	mov    %eax,(%esp)
  800a01:	e8 79 fb ff ff       	call   80057f <vprintfmt>
	va_end(ap);
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    
	...

00800a10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 55 08             	mov    0x8(%ebp),%edx
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1b:	eb 03                	jmp    800a20 <strlen+0x10>
		n++;
  800a1d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a24:	75 f7                	jne    800a1d <strlen+0xd>
		n++;
	return n;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	53                   	push   %ebx
  800a2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a37:	eb 03                	jmp    800a3c <strnlen+0x14>
		n++;
  800a39:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3c:	39 c1                	cmp    %eax,%ecx
  800a3e:	74 06                	je     800a46 <strnlen+0x1e>
  800a40:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800a44:	75 f3                	jne    800a39 <strnlen+0x11>
		n++;
	return n;
}
  800a46:	5b                   	pop    %ebx
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	53                   	push   %ebx
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a53:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a58:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a5c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a5f:	83 c2 01             	add    $0x1,%edx
  800a62:	84 c9                	test   %cl,%cl
  800a64:	75 f2                	jne    800a58 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	53                   	push   %ebx
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a73:	89 1c 24             	mov    %ebx,(%esp)
  800a76:	e8 95 ff ff ff       	call   800a10 <strlen>
	strcpy(dst + len, src);
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a82:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800a85:	89 04 24             	mov    %eax,(%esp)
  800a88:	e8 bc ff ff ff       	call   800a49 <strcpy>
	return dst;
}
  800a8d:	89 d8                	mov    %ebx,%eax
  800a8f:	83 c4 08             	add    $0x8,%esp
  800a92:	5b                   	pop    %ebx
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	56                   	push   %esi
  800a99:	53                   	push   %ebx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa0:	8b 75 10             	mov    0x10(%ebp),%esi
  800aa3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa8:	eb 0f                	jmp    800ab9 <strncpy+0x24>
		*dst++ = *src;
  800aaa:	0f b6 19             	movzbl (%ecx),%ebx
  800aad:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab0:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab6:	83 c2 01             	add    $0x1,%edx
  800ab9:	39 f2                	cmp    %esi,%edx
  800abb:	72 ed                	jb     800aaa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800abd:	5b                   	pop    %ebx
  800abe:	5e                   	pop    %esi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800acf:	89 f0                	mov    %esi,%eax
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	75 0a                	jne    800adf <strlcpy+0x1e>
  800ad5:	eb 17                	jmp    800aee <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad7:	88 18                	mov    %bl,(%eax)
  800ad9:	83 c0 01             	add    $0x1,%eax
  800adc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800adf:	83 ea 01             	sub    $0x1,%edx
  800ae2:	74 07                	je     800aeb <strlcpy+0x2a>
  800ae4:	0f b6 19             	movzbl (%ecx),%ebx
  800ae7:	84 db                	test   %bl,%bl
  800ae9:	75 ec                	jne    800ad7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800aeb:	c6 00 00             	movb   $0x0,(%eax)
  800aee:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afd:	eb 06                	jmp    800b05 <strcmp+0x11>
		p++, q++;
  800aff:	83 c1 01             	add    $0x1,%ecx
  800b02:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b05:	0f b6 01             	movzbl (%ecx),%eax
  800b08:	84 c0                	test   %al,%al
  800b0a:	74 04                	je     800b10 <strcmp+0x1c>
  800b0c:	3a 02                	cmp    (%edx),%al
  800b0e:	74 ef                	je     800aff <strcmp+0xb>
  800b10:	0f b6 c0             	movzbl %al,%eax
  800b13:	0f b6 12             	movzbl (%edx),%edx
  800b16:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	53                   	push   %ebx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b24:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800b27:	eb 09                	jmp    800b32 <strncmp+0x18>
		n--, p++, q++;
  800b29:	83 ea 01             	sub    $0x1,%edx
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b32:	85 d2                	test   %edx,%edx
  800b34:	75 07                	jne    800b3d <strncmp+0x23>
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3b:	eb 13                	jmp    800b50 <strncmp+0x36>
  800b3d:	0f b6 18             	movzbl (%eax),%ebx
  800b40:	84 db                	test   %bl,%bl
  800b42:	74 04                	je     800b48 <strncmp+0x2e>
  800b44:	3a 19                	cmp    (%ecx),%bl
  800b46:	74 e1                	je     800b29 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b48:	0f b6 00             	movzbl (%eax),%eax
  800b4b:	0f b6 11             	movzbl (%ecx),%edx
  800b4e:	29 d0                	sub    %edx,%eax
}
  800b50:	5b                   	pop    %ebx
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5d:	eb 07                	jmp    800b66 <strchr+0x13>
		if (*s == c)
  800b5f:	38 ca                	cmp    %cl,%dl
  800b61:	74 0f                	je     800b72 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b63:	83 c0 01             	add    $0x1,%eax
  800b66:	0f b6 10             	movzbl (%eax),%edx
  800b69:	84 d2                	test   %dl,%dl
  800b6b:	75 f2                	jne    800b5f <strchr+0xc>
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7e:	eb 07                	jmp    800b87 <strfind+0x13>
		if (*s == c)
  800b80:	38 ca                	cmp    %cl,%dl
  800b82:	74 0a                	je     800b8e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	0f b6 10             	movzbl (%eax),%edx
  800b8a:	84 d2                	test   %dl,%dl
  800b8c:	75 f2                	jne    800b80 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 0c             	sub    $0xc,%esp
  800b96:	89 1c 24             	mov    %ebx,(%esp)
  800b99:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b9d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ba1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800baa:	85 c9                	test   %ecx,%ecx
  800bac:	74 30                	je     800bde <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bae:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bb4:	75 25                	jne    800bdb <memset+0x4b>
  800bb6:	f6 c1 03             	test   $0x3,%cl
  800bb9:	75 20                	jne    800bdb <memset+0x4b>
		c &= 0xFF;
  800bbb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bbe:	89 d3                	mov    %edx,%ebx
  800bc0:	c1 e3 08             	shl    $0x8,%ebx
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	c1 e6 18             	shl    $0x18,%esi
  800bc8:	89 d0                	mov    %edx,%eax
  800bca:	c1 e0 10             	shl    $0x10,%eax
  800bcd:	09 f0                	or     %esi,%eax
  800bcf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800bd1:	09 d8                	or     %ebx,%eax
  800bd3:	c1 e9 02             	shr    $0x2,%ecx
  800bd6:	fc                   	cld    
  800bd7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bd9:	eb 03                	jmp    800bde <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bdb:	fc                   	cld    
  800bdc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bde:	89 f8                	mov    %edi,%eax
  800be0:	8b 1c 24             	mov    (%esp),%ebx
  800be3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800be7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800beb:	89 ec                	mov    %ebp,%esp
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	89 34 24             	mov    %esi,(%esp)
  800bf8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800c02:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c05:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c07:	39 c6                	cmp    %eax,%esi
  800c09:	73 35                	jae    800c40 <memmove+0x51>
  800c0b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c0e:	39 d0                	cmp    %edx,%eax
  800c10:	73 2e                	jae    800c40 <memmove+0x51>
		s += n;
		d += n;
  800c12:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c14:	f6 c2 03             	test   $0x3,%dl
  800c17:	75 1b                	jne    800c34 <memmove+0x45>
  800c19:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1f:	75 13                	jne    800c34 <memmove+0x45>
  800c21:	f6 c1 03             	test   $0x3,%cl
  800c24:	75 0e                	jne    800c34 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800c26:	83 ef 04             	sub    $0x4,%edi
  800c29:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c2c:	c1 e9 02             	shr    $0x2,%ecx
  800c2f:	fd                   	std    
  800c30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c32:	eb 09                	jmp    800c3d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c34:	83 ef 01             	sub    $0x1,%edi
  800c37:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c3a:	fd                   	std    
  800c3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c3d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c3e:	eb 20                	jmp    800c60 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c40:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c46:	75 15                	jne    800c5d <memmove+0x6e>
  800c48:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c4e:	75 0d                	jne    800c5d <memmove+0x6e>
  800c50:	f6 c1 03             	test   $0x3,%cl
  800c53:	75 08                	jne    800c5d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800c55:	c1 e9 02             	shr    $0x2,%ecx
  800c58:	fc                   	cld    
  800c59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c5b:	eb 03                	jmp    800c60 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c5d:	fc                   	cld    
  800c5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c60:	8b 34 24             	mov    (%esp),%esi
  800c63:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c67:	89 ec                	mov    %ebp,%esp
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c71:	8b 45 10             	mov    0x10(%ebp),%eax
  800c74:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 04 24             	mov    %eax,(%esp)
  800c85:	e8 65 ff ff ff       	call   800bef <memmove>
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca0:	eb 1c                	jmp    800cbe <memcmp+0x32>
		if (*s1 != *s2)
  800ca2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800ca6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800caa:	83 c2 01             	add    $0x1,%edx
  800cad:	83 e9 01             	sub    $0x1,%ecx
  800cb0:	38 d8                	cmp    %bl,%al
  800cb2:	74 0a                	je     800cbe <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800cb4:	0f b6 c0             	movzbl %al,%eax
  800cb7:	0f b6 db             	movzbl %bl,%ebx
  800cba:	29 d8                	sub    %ebx,%eax
  800cbc:	eb 09                	jmp    800cc7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbe:	85 c9                	test   %ecx,%ecx
  800cc0:	75 e0                	jne    800ca2 <memcmp+0x16>
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cd5:	89 c2                	mov    %eax,%edx
  800cd7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cda:	eb 07                	jmp    800ce3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cdc:	38 08                	cmp    %cl,(%eax)
  800cde:	74 07                	je     800ce7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ce0:	83 c0 01             	add    $0x1,%eax
  800ce3:	39 d0                	cmp    %edx,%eax
  800ce5:	72 f5                	jb     800cdc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 04             	sub    $0x4,%esp
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf8:	eb 03                	jmp    800cfd <strtol+0x14>
		s++;
  800cfa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cfd:	0f b6 02             	movzbl (%edx),%eax
  800d00:	3c 20                	cmp    $0x20,%al
  800d02:	74 f6                	je     800cfa <strtol+0x11>
  800d04:	3c 09                	cmp    $0x9,%al
  800d06:	74 f2                	je     800cfa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d08:	3c 2b                	cmp    $0x2b,%al
  800d0a:	75 0c                	jne    800d18 <strtol+0x2f>
		s++;
  800d0c:	8d 52 01             	lea    0x1(%edx),%edx
  800d0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d16:	eb 15                	jmp    800d2d <strtol+0x44>
	else if (*s == '-')
  800d18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d1f:	3c 2d                	cmp    $0x2d,%al
  800d21:	75 0a                	jne    800d2d <strtol+0x44>
		s++, neg = 1;
  800d23:	8d 52 01             	lea    0x1(%edx),%edx
  800d26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2d:	85 db                	test   %ebx,%ebx
  800d2f:	0f 94 c0             	sete   %al
  800d32:	74 05                	je     800d39 <strtol+0x50>
  800d34:	83 fb 10             	cmp    $0x10,%ebx
  800d37:	75 15                	jne    800d4e <strtol+0x65>
  800d39:	80 3a 30             	cmpb   $0x30,(%edx)
  800d3c:	75 10                	jne    800d4e <strtol+0x65>
  800d3e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d42:	75 0a                	jne    800d4e <strtol+0x65>
		s += 2, base = 16;
  800d44:	83 c2 02             	add    $0x2,%edx
  800d47:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4c:	eb 13                	jmp    800d61 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 0f                	je     800d61 <strtol+0x78>
  800d52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d57:	80 3a 30             	cmpb   $0x30,(%edx)
  800d5a:	75 05                	jne    800d61 <strtol+0x78>
		s++, base = 8;
  800d5c:	83 c2 01             	add    $0x1,%edx
  800d5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d68:	0f b6 0a             	movzbl (%edx),%ecx
  800d6b:	89 cf                	mov    %ecx,%edi
  800d6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d70:	80 fb 09             	cmp    $0x9,%bl
  800d73:	77 08                	ja     800d7d <strtol+0x94>
			dig = *s - '0';
  800d75:	0f be c9             	movsbl %cl,%ecx
  800d78:	83 e9 30             	sub    $0x30,%ecx
  800d7b:	eb 1e                	jmp    800d9b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800d7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d80:	80 fb 19             	cmp    $0x19,%bl
  800d83:	77 08                	ja     800d8d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800d85:	0f be c9             	movsbl %cl,%ecx
  800d88:	83 e9 57             	sub    $0x57,%ecx
  800d8b:	eb 0e                	jmp    800d9b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800d8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d90:	80 fb 19             	cmp    $0x19,%bl
  800d93:	77 15                	ja     800daa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d95:	0f be c9             	movsbl %cl,%ecx
  800d98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d9b:	39 f1                	cmp    %esi,%ecx
  800d9d:	7d 0b                	jge    800daa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d9f:	83 c2 01             	add    $0x1,%edx
  800da2:	0f af c6             	imul   %esi,%eax
  800da5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800da8:	eb be                	jmp    800d68 <strtol+0x7f>
  800daa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800dac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db0:	74 05                	je     800db7 <strtol+0xce>
		*endptr = (char *) s;
  800db2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800db5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800db7:	89 ca                	mov    %ecx,%edx
  800db9:	f7 da                	neg    %edx
  800dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dbf:	0f 45 c2             	cmovne %edx,%eax
}
  800dc2:	83 c4 04             	add    $0x4,%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
	...

00800dcc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	89 1c 24             	mov    %ebx,(%esp)
  800dd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  800de2:	b8 01 00 00 00       	mov    $0x1,%eax
  800de7:	89 d1                	mov    %edx,%ecx
  800de9:	89 d3                	mov    %edx,%ebx
  800deb:	89 d7                	mov    %edx,%edi
  800ded:	89 d6                	mov    %edx,%esi
  800def:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800df1:	8b 1c 24             	mov    (%esp),%ebx
  800df4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800df8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dfc:	89 ec                	mov    %ebp,%esp
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	89 1c 24             	mov    %ebx,(%esp)
  800e09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	89 c3                	mov    %eax,%ebx
  800e1e:	89 c7                	mov    %eax,%edi
  800e20:	89 c6                	mov    %eax,%esi
  800e22:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e24:	8b 1c 24             	mov    (%esp),%ebx
  800e27:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e2b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e2f:	89 ec                	mov    %ebp,%esp
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 0c             	sub    $0xc,%esp
  800e39:	89 1c 24             	mov    %ebx,(%esp)
  800e3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e40:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e44:	ba 00 00 00 00       	mov    $0x0,%edx
  800e49:	b8 10 00 00 00       	mov    $0x10,%eax
  800e4e:	89 d1                	mov    %edx,%ecx
  800e50:	89 d3                	mov    %edx,%ebx
  800e52:	89 d7                	mov    %edx,%edi
  800e54:	89 d6                	mov    %edx,%esi
  800e56:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e58:	8b 1c 24             	mov    (%esp),%ebx
  800e5b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e5f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e63:	89 ec                	mov    %ebp,%esp
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 38             	sub    $0x38,%esp
  800e6d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e70:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e73:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	89 df                	mov    %ebx,%edi
  800e88:	89 de                	mov    %ebx,%esi
  800e8a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	7e 28                	jle    800eb8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e94:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e9b:	00 
  800e9c:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  800ea3:	00 
  800ea4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eab:	00 
  800eac:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  800eb3:	e8 70 f4 ff ff       	call   800328 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800eb8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ebb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ebe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec1:	89 ec                	mov    %ebp,%esp
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 38             	sub    $0x38,%esp
  800ecb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ece:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	89 df                	mov    %ebx,%edi
  800ee6:	89 de                	mov    %ebx,%esi
  800ee8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7e 28                	jle    800f16 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eee:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800ef9:	00 
  800efa:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  800f01:	00 
  800f02:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f09:	00 
  800f0a:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  800f11:	e8 12 f4 ff ff       	call   800328 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800f16:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f19:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f1c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f1f:	89 ec                	mov    %ebp,%esp
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 38             	sub    $0x38,%esp
  800f29:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f2c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	89 cb                	mov    %ecx,%ebx
  800f41:	89 cf                	mov    %ecx,%edi
  800f43:	89 ce                	mov    %ecx,%esi
  800f45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f47:	85 c0                	test   %eax,%eax
  800f49:	7e 28                	jle    800f73 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f56:	00 
  800f57:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  800f5e:	00 
  800f5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f66:	00 
  800f67:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  800f6e:	e8 b5 f3 ff ff       	call   800328 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f73:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f76:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f79:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f7c:	89 ec                	mov    %ebp,%esp
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	89 1c 24             	mov    %ebx,(%esp)
  800f89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f91:	be 00 00 00 00       	mov    $0x0,%esi
  800f96:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa9:	8b 1c 24             	mov    (%esp),%ebx
  800fac:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fb0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fb4:	89 ec                	mov    %ebp,%esp
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 38             	sub    $0x38,%esp
  800fbe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	89 df                	mov    %ebx,%edi
  800fd9:	89 de                	mov    %ebx,%esi
  800fdb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	7e 28                	jle    801009 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fec:	00 
  800fed:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  800ff4:	00 
  800ff5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffc:	00 
  800ffd:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  801004:	e8 1f f3 ff ff       	call   800328 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801009:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80100c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801012:	89 ec                	mov    %ebp,%esp
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 38             	sub    $0x38,%esp
  80101c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801022:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801025:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102a:	b8 09 00 00 00       	mov    $0x9,%eax
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	89 df                	mov    %ebx,%edi
  801037:	89 de                	mov    %ebx,%esi
  801039:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103b:	85 c0                	test   %eax,%eax
  80103d:	7e 28                	jle    801067 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801043:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80104a:	00 
  80104b:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  801052:	00 
  801053:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105a:	00 
  80105b:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  801062:	e8 c1 f2 ff ff       	call   800328 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801067:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80106a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801070:	89 ec                	mov    %ebp,%esp
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 38             	sub    $0x38,%esp
  80107a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80107d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801080:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801083:	bb 00 00 00 00       	mov    $0x0,%ebx
  801088:	b8 08 00 00 00       	mov    $0x8,%eax
  80108d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801090:	8b 55 08             	mov    0x8(%ebp),%edx
  801093:	89 df                	mov    %ebx,%edi
  801095:	89 de                	mov    %ebx,%esi
  801097:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801099:	85 c0                	test   %eax,%eax
  80109b:	7e 28                	jle    8010c5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010a8:	00 
  8010a9:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  8010b0:	00 
  8010b1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b8:	00 
  8010b9:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  8010c0:	e8 63 f2 ff ff       	call   800328 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010c5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010cb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ce:	89 ec                	mov    %ebp,%esp
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 38             	sub    $0x38,%esp
  8010d8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010db:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010de:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8010eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	89 df                	mov    %ebx,%edi
  8010f3:	89 de                	mov    %ebx,%esi
  8010f5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	7e 28                	jle    801123 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ff:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801106:	00 
  801107:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  80110e:	00 
  80110f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801116:	00 
  801117:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  80111e:	e8 05 f2 ff ff       	call   800328 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801123:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801126:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801129:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80112c:	89 ec                	mov    %ebp,%esp
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 38             	sub    $0x38,%esp
  801136:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801139:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80113c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113f:	b8 05 00 00 00       	mov    $0x5,%eax
  801144:	8b 75 18             	mov    0x18(%ebp),%esi
  801147:	8b 7d 14             	mov    0x14(%ebp),%edi
  80114a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
  801153:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801155:	85 c0                	test   %eax,%eax
  801157:	7e 28                	jle    801181 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801159:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801164:	00 
  801165:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  80116c:	00 
  80116d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801174:	00 
  801175:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  80117c:	e8 a7 f1 ff ff       	call   800328 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801181:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801184:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801187:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80118a:	89 ec                	mov    %ebp,%esp
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 38             	sub    $0x38,%esp
  801194:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801197:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119d:	be 00 00 00 00       	mov    $0x0,%esi
  8011a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	89 f7                	mov    %esi,%edi
  8011b2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	7e 28                	jle    8011e0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8011c3:	00 
  8011c4:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d3:	00 
  8011d4:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  8011db:	e8 48 f1 ff ff       	call   800328 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e9:	89 ec                	mov    %ebp,%esp
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	89 1c 24             	mov    %ebx,(%esp)
  8011f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011fa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801203:	b8 0b 00 00 00       	mov    $0xb,%eax
  801208:	89 d1                	mov    %edx,%ecx
  80120a:	89 d3                	mov    %edx,%ebx
  80120c:	89 d7                	mov    %edx,%edi
  80120e:	89 d6                	mov    %edx,%esi
  801210:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801212:	8b 1c 24             	mov    (%esp),%ebx
  801215:	8b 74 24 04          	mov    0x4(%esp),%esi
  801219:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80121d:	89 ec                	mov    %ebp,%esp
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	89 1c 24             	mov    %ebx,(%esp)
  80122a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80122e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801232:	ba 00 00 00 00       	mov    $0x0,%edx
  801237:	b8 02 00 00 00       	mov    $0x2,%eax
  80123c:	89 d1                	mov    %edx,%ecx
  80123e:	89 d3                	mov    %edx,%ebx
  801240:	89 d7                	mov    %edx,%edi
  801242:	89 d6                	mov    %edx,%esi
  801244:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801246:	8b 1c 24             	mov    (%esp),%ebx
  801249:	8b 74 24 04          	mov    0x4(%esp),%esi
  80124d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801251:	89 ec                	mov    %ebp,%esp
  801253:	5d                   	pop    %ebp
  801254:	c3                   	ret    

00801255 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 38             	sub    $0x38,%esp
  80125b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80125e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801261:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801264:	b9 00 00 00 00       	mov    $0x0,%ecx
  801269:	b8 03 00 00 00       	mov    $0x3,%eax
  80126e:	8b 55 08             	mov    0x8(%ebp),%edx
  801271:	89 cb                	mov    %ecx,%ebx
  801273:	89 cf                	mov    %ecx,%edi
  801275:	89 ce                	mov    %ecx,%esi
  801277:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801279:	85 c0                	test   %eax,%eax
  80127b:	7e 28                	jle    8012a5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80127d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801281:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801288:	00 
  801289:	c7 44 24 08 87 32 80 	movl   $0x803287,0x8(%esp)
  801290:	00 
  801291:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801298:	00 
  801299:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  8012a0:	e8 83 f0 ff ff       	call   800328 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012a5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012ae:	89 ec                	mov    %ebp,%esp
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
	...

008012b4 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012ba:	c7 44 24 08 b2 32 80 	movl   $0x8032b2,0x8(%esp)
  8012c1:	00 
  8012c2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  8012c9:	00 
  8012ca:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  8012d1:	e8 52 f0 ff ff       	call   800328 <_panic>

008012d6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	57                   	push   %edi
  8012da:	56                   	push   %esi
  8012db:	53                   	push   %ebx
  8012dc:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  8012df:	c7 04 24 44 15 80 00 	movl   $0x801544,(%esp)
  8012e6:	e8 19 17 00 00       	call   802a04 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012eb:	ba 07 00 00 00       	mov    $0x7,%edx
  8012f0:	89 d0                	mov    %edx,%eax
  8012f2:	cd 30                	int    $0x30
  8012f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	79 20                	jns    80131b <fork+0x45>
		panic("sys_exofork: %e", envid);
  8012fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ff:	c7 44 24 08 d3 32 80 	movl   $0x8032d3,0x8(%esp)
  801306:	00 
  801307:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80130e:	00 
  80130f:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801316:	e8 0d f0 ff ff       	call   800328 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80131b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801322:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801327:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80132b:	75 21                	jne    80134e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80132d:	e8 ef fe ff ff       	call   801221 <sys_getenvid>
  801332:	25 ff 03 00 00       	and    $0x3ff,%eax
  801337:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80133a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80133f:	a3 08 50 80 00       	mov    %eax,0x805008
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801349:	e9 e5 01 00 00       	jmp    801533 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80134e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801351:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801358:	a8 01                	test   $0x1,%al
  80135a:	0f 84 4c 01 00 00    	je     8014ac <fork+0x1d6>
  801360:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801366:	0f 84 cf 01 00 00    	je     80153b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80136c:	c1 e2 16             	shl    $0x16,%edx
  80136f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801372:	89 d3                	mov    %edx,%ebx
  801374:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80137b:	00 
  80137c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801383:	89 04 24             	mov    %eax,(%esp)
  801386:	e8 03 fe ff ff       	call   80118e <sys_page_alloc>
			if(ret < 0) return ret;
  80138b:	85 c0                	test   %eax,%eax
  80138d:	0f 88 a0 01 00 00    	js     801533 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801393:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801397:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80139a:	89 14 24             	mov    %edx,(%esp)
  80139d:	e8 30 fd ff ff       	call   8010d2 <sys_page_unmap>
			if(ret < 0) return ret;
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	0f 88 89 01 00 00    	js     801533 <fork+0x25d>
  8013aa:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8013af:	89 de                	mov    %ebx,%esi
  8013b1:	c1 e6 0c             	shl    $0xc,%esi
  8013b4:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  8013b7:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  8013bd:	0f 84 da 00 00 00    	je     80149d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8013c3:	c1 ee 0c             	shr    $0xc,%esi
  8013c6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8013c9:	a8 01                	test   $0x1,%al
  8013cb:	0f 84 cc 00 00 00    	je     80149d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  8013d1:	89 f0                	mov    %esi,%eax
  8013d3:	c1 e0 0c             	shl    $0xc,%eax
  8013d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  8013d9:	e8 43 fe ff ff       	call   801221 <sys_getenvid>
  8013de:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  8013e1:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  8013e4:	89 c6                	mov    %eax,%esi
  8013e6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  8013ec:	25 01 04 00 00       	and    $0x401,%eax
  8013f1:	3d 01 04 00 00       	cmp    $0x401,%eax
  8013f6:	75 3a                	jne    801432 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  8013f8:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8013ff:	00 
  801400:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801403:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801407:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80140a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801412:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801415:	89 14 24             	mov    %edx,(%esp)
  801418:	e8 13 fd ff ff       	call   801130 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80141d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801420:	89 44 24 04          	mov    %eax,0x4(%esp)
  801424:	c7 04 24 e3 32 80 00 	movl   $0x8032e3,(%esp)
  80142b:	e8 b1 ef ff ff       	call   8003e1 <cprintf>
  801430:	eb 6b                	jmp    80149d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801432:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801438:	74 14                	je     80144e <fork+0x178>
  80143a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801440:	74 0c                	je     80144e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801442:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801448:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80144e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801451:	89 74 24 10          	mov    %esi,0x10(%esp)
  801455:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80145c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801460:	89 54 24 04          	mov    %edx,0x4(%esp)
  801464:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801467:	89 14 24             	mov    %edx,(%esp)
  80146a:	e8 c1 fc ff ff       	call   801130 <sys_page_map>
	if(ret<0) return ret;
  80146f:	85 c0                	test   %eax,%eax
  801471:	0f 88 bc 00 00 00    	js     801533 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801477:	89 74 24 10          	mov    %esi,0x10(%esp)
  80147b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801482:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801485:	89 54 24 08          	mov    %edx,0x8(%esp)
  801489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148d:	89 14 24             	mov    %edx,(%esp)
  801490:	e8 9b fc ff ff       	call   801130 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801495:	85 c0                	test   %eax,%eax
  801497:	0f 88 96 00 00 00    	js     801533 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80149d:	83 c3 01             	add    $0x1,%ebx
  8014a0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8014a6:	0f 85 03 ff ff ff    	jne    8013af <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8014ac:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8014b0:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  8014b7:	0f 85 91 fe ff ff    	jne    80134e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  8014bd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014c4:	00 
  8014c5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014cc:	ee 
  8014cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014d0:	89 04 24             	mov    %eax,(%esp)
  8014d3:	e8 b6 fc ff ff       	call   80118e <sys_page_alloc>
	if(ret < 0) return ret;
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 57                	js     801533 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  8014dc:	a1 08 50 80 00       	mov    0x805008,%eax
  8014e1:	8b 40 64             	mov    0x64(%eax),%eax
  8014e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8014eb:	89 14 24             	mov    %edx,(%esp)
  8014ee:	e8 c5 fa ff ff       	call   800fb8 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 3c                	js     801533 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014f7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014fe:	00 
  8014ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	e8 6a fb ff ff       	call   801074 <sys_env_set_status>
  80150a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80150c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80150f:	85 d2                	test   %edx,%edx
  801511:	79 20                	jns    801533 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801513:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801517:	c7 44 24 08 fa 32 80 	movl   $0x8032fa,0x8(%esp)
  80151e:	00 
  80151f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801526:	00 
  801527:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  80152e:	e8 f5 ed ff ff       	call   800328 <_panic>

	return envid;
}
  801533:	83 c4 4c             	add    $0x4c,%esp
  801536:	5b                   	pop    %ebx
  801537:	5e                   	pop    %esi
  801538:	5f                   	pop    %edi
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80153b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80153f:	e9 0a fe ff ff       	jmp    80134e <fork+0x78>

00801544 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80154c:	e8 d0 fc ff ff       	call   801221 <sys_getenvid>
  801551:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8b 00                	mov    (%eax),%eax
  801558:	89 c6                	mov    %eax,%esi
  80155a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80155d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801564:	f6 c2 02             	test   $0x2,%dl
  801567:	75 2c                	jne    801595 <pgfault+0x51>
  801569:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801570:	f6 c6 08             	test   $0x8,%dh
  801573:	75 20                	jne    801595 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801575:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801579:	c7 44 24 08 48 33 80 	movl   $0x803348,0x8(%esp)
  801580:	00 
  801581:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801588:	00 
  801589:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801590:	e8 93 ed ff ff       	call   800328 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801595:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80159c:	00 
  80159d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8015a4:	00 
  8015a5:	89 1c 24             	mov    %ebx,(%esp)
  8015a8:	e8 e1 fb ff ff       	call   80118e <sys_page_alloc>
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	79 20                	jns    8015d1 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  8015b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015b5:	c7 44 24 08 11 33 80 	movl   $0x803311,0x8(%esp)
  8015bc:	00 
  8015bd:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8015c4:	00 
  8015c5:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  8015cc:	e8 57 ed ff ff       	call   800328 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  8015d1:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  8015d4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8015db:	00 
  8015dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e0:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8015e7:	e8 03 f6 ff ff       	call   800bef <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8015ec:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8015f3:	00 
  8015f4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801603:	00 
  801604:	89 1c 24             	mov    %ebx,(%esp)
  801607:	e8 24 fb ff ff       	call   801130 <sys_page_map>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	79 20                	jns    801630 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801610:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801614:	c7 44 24 08 23 33 80 	movl   $0x803323,0x8(%esp)
  80161b:	00 
  80161c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801623:	00 
  801624:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  80162b:	e8 f8 ec ff ff       	call   800328 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801630:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801637:	00 
  801638:	89 1c 24             	mov    %ebx,(%esp)
  80163b:	e8 92 fa ff ff       	call   8010d2 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801640:	85 c0                	test   %eax,%eax
  801642:	74 20                	je     801664 <pgfault+0x120>
  801644:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801648:	c7 44 24 08 33 33 80 	movl   $0x803333,0x8(%esp)
  80164f:	00 
  801650:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801657:	00 
  801658:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  80165f:	e8 c4 ec ff ff       	call   800328 <_panic>

}
  801664:	83 c4 20             	add    $0x20,%esp
  801667:	5b                   	pop    %ebx
  801668:	5e                   	pop    %esi
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    
	...

0080166c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	05 00 00 00 30       	add    $0x30000000,%eax
  801677:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 df ff ff ff       	call   80166c <fd2num>
  80168d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801692:	c1 e0 0c             	shl    $0xc,%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	57                   	push   %edi
  80169b:	56                   	push   %esi
  80169c:	53                   	push   %ebx
  80169d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016a0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016a5:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8016aa:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016af:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016b1:	89 c2                	mov    %eax,%edx
  8016b3:	c1 ea 16             	shr    $0x16,%edx
  8016b6:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8016b9:	f6 c2 01             	test   $0x1,%dl
  8016bc:	74 0d                	je     8016cb <fd_alloc+0x34>
  8016be:	89 c2                	mov    %eax,%edx
  8016c0:	c1 ea 0c             	shr    $0xc,%edx
  8016c3:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8016c6:	f6 c2 01             	test   $0x1,%dl
  8016c9:	75 09                	jne    8016d4 <fd_alloc+0x3d>
			*fd_store = fd;
  8016cb:	89 37                	mov    %esi,(%edi)
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016d2:	eb 17                	jmp    8016eb <fd_alloc+0x54>
  8016d4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016d9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016de:	75 cf                	jne    8016af <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016e0:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8016e6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5f                   	pop    %edi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	83 f8 1f             	cmp    $0x1f,%eax
  8016f9:	77 36                	ja     801731 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016fb:	05 00 00 0d 00       	add    $0xd0000,%eax
  801700:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801703:	89 c2                	mov    %eax,%edx
  801705:	c1 ea 16             	shr    $0x16,%edx
  801708:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80170f:	f6 c2 01             	test   $0x1,%dl
  801712:	74 1d                	je     801731 <fd_lookup+0x41>
  801714:	89 c2                	mov    %eax,%edx
  801716:	c1 ea 0c             	shr    $0xc,%edx
  801719:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801720:	f6 c2 01             	test   $0x1,%dl
  801723:	74 0c                	je     801731 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	89 02                	mov    %eax,(%edx)
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80172f:	eb 05                	jmp    801736 <fd_lookup+0x46>
  801731:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80173e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801741:	89 44 24 04          	mov    %eax,0x4(%esp)
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	89 04 24             	mov    %eax,(%esp)
  80174b:	e8 a0 ff ff ff       	call   8016f0 <fd_lookup>
  801750:	85 c0                	test   %eax,%eax
  801752:	78 0e                	js     801762 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801754:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175a:	89 50 04             	mov    %edx,0x4(%eax)
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
  801769:	83 ec 10             	sub    $0x10,%esp
  80176c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801777:	be ec 33 80 00       	mov    $0x8033ec,%esi
  80177c:	eb 10                	jmp    80178e <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  80177e:	39 08                	cmp    %ecx,(%eax)
  801780:	75 09                	jne    80178b <dev_lookup+0x27>
			*dev = devtab[i];
  801782:	89 03                	mov    %eax,(%ebx)
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801789:	eb 31                	jmp    8017bc <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80178b:	83 c2 01             	add    $0x1,%edx
  80178e:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801791:	85 c0                	test   %eax,%eax
  801793:	75 e9                	jne    80177e <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801795:	a1 08 50 80 00       	mov    0x805008,%eax
  80179a:	8b 40 48             	mov    0x48(%eax),%eax
  80179d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a5:	c7 04 24 6c 33 80 00 	movl   $0x80336c,(%esp)
  8017ac:	e8 30 ec ff ff       	call   8003e1 <cprintf>
	*dev = 0;
  8017b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8017b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	5b                   	pop    %ebx
  8017c0:	5e                   	pop    %esi
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 24             	sub    $0x24,%esp
  8017ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	e8 11 ff ff ff       	call   8016f0 <fd_lookup>
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 53                	js     801836 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ed:	8b 00                	mov    (%eax),%eax
  8017ef:	89 04 24             	mov    %eax,(%esp)
  8017f2:	e8 6d ff ff ff       	call   801764 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 3b                	js     801836 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8017fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801803:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801807:	74 2d                	je     801836 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801809:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80180c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801813:	00 00 00 
	stat->st_isdir = 0;
  801816:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80181d:	00 00 00 
	stat->st_dev = dev;
  801820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801823:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801829:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80182d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801830:	89 14 24             	mov    %edx,(%esp)
  801833:	ff 50 14             	call   *0x14(%eax)
}
  801836:	83 c4 24             	add    $0x24,%esp
  801839:	5b                   	pop    %ebx
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	53                   	push   %ebx
  801840:	83 ec 24             	sub    $0x24,%esp
  801843:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801846:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184d:	89 1c 24             	mov    %ebx,(%esp)
  801850:	e8 9b fe ff ff       	call   8016f0 <fd_lookup>
  801855:	85 c0                	test   %eax,%eax
  801857:	78 5f                	js     8018b8 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801859:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	8b 00                	mov    (%eax),%eax
  801865:	89 04 24             	mov    %eax,(%esp)
  801868:	e8 f7 fe ff ff       	call   801764 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 47                	js     8018b8 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801871:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801874:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801878:	75 23                	jne    80189d <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80187a:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80187f:	8b 40 48             	mov    0x48(%eax),%eax
  801882:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801886:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188a:	c7 04 24 8c 33 80 00 	movl   $0x80338c,(%esp)
  801891:	e8 4b eb ff ff       	call   8003e1 <cprintf>
  801896:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80189b:	eb 1b                	jmp    8018b8 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  80189d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a0:	8b 48 18             	mov    0x18(%eax),%ecx
  8018a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a8:	85 c9                	test   %ecx,%ecx
  8018aa:	74 0c                	je     8018b8 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	89 14 24             	mov    %edx,(%esp)
  8018b6:	ff d1                	call   *%ecx
}
  8018b8:	83 c4 24             	add    $0x24,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    

008018be <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 24             	sub    $0x24,%esp
  8018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cf:	89 1c 24             	mov    %ebx,(%esp)
  8018d2:	e8 19 fe ff ff       	call   8016f0 <fd_lookup>
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 66                	js     801941 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	89 04 24             	mov    %eax,(%esp)
  8018ea:	e8 75 fe ff ff       	call   801764 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 4e                	js     801941 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f6:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018fa:	75 23                	jne    80191f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018fc:	a1 08 50 80 00       	mov    0x805008,%eax
  801901:	8b 40 48             	mov    0x48(%eax),%eax
  801904:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190c:	c7 04 24 b0 33 80 00 	movl   $0x8033b0,(%esp)
  801913:	e8 c9 ea ff ff       	call   8003e1 <cprintf>
  801918:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  80191d:	eb 22                	jmp    801941 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	8b 48 0c             	mov    0xc(%eax),%ecx
  801925:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192a:	85 c9                	test   %ecx,%ecx
  80192c:	74 13                	je     801941 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80192e:	8b 45 10             	mov    0x10(%ebp),%eax
  801931:	89 44 24 08          	mov    %eax,0x8(%esp)
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193c:	89 14 24             	mov    %edx,(%esp)
  80193f:	ff d1                	call   *%ecx
}
  801941:	83 c4 24             	add    $0x24,%esp
  801944:	5b                   	pop    %ebx
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 24             	sub    $0x24,%esp
  80194e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801951:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	89 1c 24             	mov    %ebx,(%esp)
  80195b:	e8 90 fd ff ff       	call   8016f0 <fd_lookup>
  801960:	85 c0                	test   %eax,%eax
  801962:	78 6b                	js     8019cf <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801964:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196e:	8b 00                	mov    (%eax),%eax
  801970:	89 04 24             	mov    %eax,(%esp)
  801973:	e8 ec fd ff ff       	call   801764 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 53                	js     8019cf <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80197c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197f:	8b 42 08             	mov    0x8(%edx),%eax
  801982:	83 e0 03             	and    $0x3,%eax
  801985:	83 f8 01             	cmp    $0x1,%eax
  801988:	75 23                	jne    8019ad <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80198a:	a1 08 50 80 00       	mov    0x805008,%eax
  80198f:	8b 40 48             	mov    0x48(%eax),%eax
  801992:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199a:	c7 04 24 cd 33 80 00 	movl   $0x8033cd,(%esp)
  8019a1:	e8 3b ea ff ff       	call   8003e1 <cprintf>
  8019a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019ab:	eb 22                	jmp    8019cf <read+0x88>
	}
	if (!dev->dev_read)
  8019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b0:	8b 48 08             	mov    0x8(%eax),%ecx
  8019b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b8:	85 c9                	test   %ecx,%ecx
  8019ba:	74 13                	je     8019cf <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ca:	89 14 24             	mov    %edx,(%esp)
  8019cd:	ff d1                	call   *%ecx
}
  8019cf:	83 c4 24             	add    $0x24,%esp
  8019d2:	5b                   	pop    %ebx
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    

008019d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	57                   	push   %edi
  8019d9:	56                   	push   %esi
  8019da:	53                   	push   %ebx
  8019db:	83 ec 1c             	sub    $0x1c,%esp
  8019de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e1:	8b 75 10             	mov    0x10(%ebp),%esi
  8019e4:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019e9:	eb 21                	jmp    801a0c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019eb:	89 f2                	mov    %esi,%edx
  8019ed:	29 c2                	sub    %eax,%edx
  8019ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019f3:	03 45 0c             	add    0xc(%ebp),%eax
  8019f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fa:	89 3c 24             	mov    %edi,(%esp)
  8019fd:	e8 45 ff ff ff       	call   801947 <read>
		if (m < 0)
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 0e                	js     801a14 <readn+0x3f>
			return m;
		if (m == 0)
  801a06:	85 c0                	test   %eax,%eax
  801a08:	74 08                	je     801a12 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0a:	01 c3                	add    %eax,%ebx
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	39 f3                	cmp    %esi,%ebx
  801a10:	72 d9                	jb     8019eb <readn+0x16>
  801a12:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    

00801a1c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 38             	sub    $0x38,%esp
  801a22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a25:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a28:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a2e:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a32:	89 3c 24             	mov    %edi,(%esp)
  801a35:	e8 32 fc ff ff       	call   80166c <fd2num>
  801a3a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a41:	89 04 24             	mov    %eax,(%esp)
  801a44:	e8 a7 fc ff ff       	call   8016f0 <fd_lookup>
  801a49:	89 c3                	mov    %eax,%ebx
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 05                	js     801a54 <fd_close+0x38>
  801a4f:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801a52:	74 0e                	je     801a62 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801a54:	89 f0                	mov    %esi,%eax
  801a56:	84 c0                	test   %al,%al
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5d:	0f 44 d8             	cmove  %eax,%ebx
  801a60:	eb 3d                	jmp    801a9f <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a62:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a69:	8b 07                	mov    (%edi),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 f1 fc ff ff       	call   801764 <dev_lookup>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 16                	js     801a8f <fd_close+0x73>
		if (dev->dev_close)
  801a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7c:	8b 40 10             	mov    0x10(%eax),%eax
  801a7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a84:	85 c0                	test   %eax,%eax
  801a86:	74 07                	je     801a8f <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801a88:	89 3c 24             	mov    %edi,(%esp)
  801a8b:	ff d0                	call   *%eax
  801a8d:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a8f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9a:	e8 33 f6 ff ff       	call   8010d2 <sys_page_unmap>
	return r;
}
  801a9f:	89 d8                	mov    %ebx,%eax
  801aa1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801aa4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801aa7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801aaa:	89 ec                	mov    %ebp,%esp
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    

00801aae <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	89 04 24             	mov    %eax,(%esp)
  801ac1:	e8 2a fc ff ff       	call   8016f0 <fd_lookup>
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 13                	js     801add <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801aca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ad1:	00 
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	89 04 24             	mov    %eax,(%esp)
  801ad8:	e8 3f ff ff ff       	call   801a1c <fd_close>
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 18             	sub    $0x18,%esp
  801ae5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ae8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aeb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801af2:	00 
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	89 04 24             	mov    %eax,(%esp)
  801af9:	e8 25 04 00 00       	call   801f23 <open>
  801afe:	89 c3                	mov    %eax,%ebx
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 1b                	js     801b1f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	89 1c 24             	mov    %ebx,(%esp)
  801b0e:	e8 b0 fc ff ff       	call   8017c3 <fstat>
  801b13:	89 c6                	mov    %eax,%esi
	close(fd);
  801b15:	89 1c 24             	mov    %ebx,(%esp)
  801b18:	e8 91 ff ff ff       	call   801aae <close>
  801b1d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801b1f:	89 d8                	mov    %ebx,%eax
  801b21:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b24:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b27:	89 ec                	mov    %ebp,%esp
  801b29:	5d                   	pop    %ebp
  801b2a:	c3                   	ret    

00801b2b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	53                   	push   %ebx
  801b2f:	83 ec 14             	sub    $0x14,%esp
  801b32:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801b37:	89 1c 24             	mov    %ebx,(%esp)
  801b3a:	e8 6f ff ff ff       	call   801aae <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b3f:	83 c3 01             	add    $0x1,%ebx
  801b42:	83 fb 20             	cmp    $0x20,%ebx
  801b45:	75 f0                	jne    801b37 <close_all+0xc>
		close(i);
}
  801b47:	83 c4 14             	add    $0x14,%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5d                   	pop    %ebp
  801b4c:	c3                   	ret    

00801b4d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 58             	sub    $0x58,%esp
  801b53:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b56:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b59:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	89 04 24             	mov    %eax,(%esp)
  801b6c:	e8 7f fb ff ff       	call   8016f0 <fd_lookup>
  801b71:	89 c3                	mov    %eax,%ebx
  801b73:	85 c0                	test   %eax,%eax
  801b75:	0f 88 e0 00 00 00    	js     801c5b <dup+0x10e>
		return r;
	close(newfdnum);
  801b7b:	89 3c 24             	mov    %edi,(%esp)
  801b7e:	e8 2b ff ff ff       	call   801aae <close>

	newfd = INDEX2FD(newfdnum);
  801b83:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801b89:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 e5 fa ff ff       	call   80167c <fd2data>
  801b97:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b99:	89 34 24             	mov    %esi,(%esp)
  801b9c:	e8 db fa ff ff       	call   80167c <fd2data>
  801ba1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ba4:	89 da                	mov    %ebx,%edx
  801ba6:	89 d8                	mov    %ebx,%eax
  801ba8:	c1 e8 16             	shr    $0x16,%eax
  801bab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bb2:	a8 01                	test   $0x1,%al
  801bb4:	74 43                	je     801bf9 <dup+0xac>
  801bb6:	c1 ea 0c             	shr    $0xc,%edx
  801bb9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bc0:	a8 01                	test   $0x1,%al
  801bc2:	74 35                	je     801bf9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bc4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bcb:	25 07 0e 00 00       	and    $0xe07,%eax
  801bd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801be2:	00 
  801be3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801be7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bee:	e8 3d f5 ff ff       	call   801130 <sys_page_map>
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 3f                	js     801c38 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bfc:	89 c2                	mov    %eax,%edx
  801bfe:	c1 ea 0c             	shr    $0xc,%edx
  801c01:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c08:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c0e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c12:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c1d:	00 
  801c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c29:	e8 02 f5 ff ff       	call   801130 <sys_page_map>
  801c2e:	89 c3                	mov    %eax,%ebx
  801c30:	85 c0                	test   %eax,%eax
  801c32:	78 04                	js     801c38 <dup+0xeb>
  801c34:	89 fb                	mov    %edi,%ebx
  801c36:	eb 23                	jmp    801c5b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c38:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c43:	e8 8a f4 ff ff       	call   8010d2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c56:	e8 77 f4 ff ff       	call   8010d2 <sys_page_unmap>
	return r;
}
  801c5b:	89 d8                	mov    %ebx,%eax
  801c5d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c60:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c63:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c66:	89 ec                	mov    %ebp,%esp
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    
	...

00801c6c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 10             	sub    $0x10,%esp
  801c74:	89 c3                	mov    %eax,%ebx
  801c76:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801c78:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c7f:	75 11                	jne    801c92 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c88:	e8 1b 0e 00 00       	call   802aa8 <ipc_find_env>
  801c8d:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801c92:	a1 08 50 80 00       	mov    0x805008,%eax
  801c97:	8b 40 48             	mov    0x48(%eax),%eax
  801c9a:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801ca0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ca4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cac:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  801cb3:	e8 29 e7 ff ff       	call   8003e1 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cb8:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cbf:	00 
  801cc0:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801cc7:	00 
  801cc8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ccc:	a1 00 50 80 00       	mov    0x805000,%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 05 0e 00 00       	call   802ade <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cd9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ce0:	00 
  801ce1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ce5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cec:	e8 59 0e 00 00       	call   802b4a <ipc_recv>
}
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    

00801cf8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	8b 40 0c             	mov    0xc(%eax),%eax
  801d04:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d11:	ba 00 00 00 00       	mov    $0x0,%edx
  801d16:	b8 02 00 00 00       	mov    $0x2,%eax
  801d1b:	e8 4c ff ff ff       	call   801c6c <fsipc>
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d33:	ba 00 00 00 00       	mov    $0x0,%edx
  801d38:	b8 06 00 00 00       	mov    $0x6,%eax
  801d3d:	e8 2a ff ff ff       	call   801c6c <fsipc>
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4f:	b8 08 00 00 00       	mov    $0x8,%eax
  801d54:	e8 13 ff ff ff       	call   801c6c <fsipc>
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	53                   	push   %ebx
  801d5f:	83 ec 14             	sub    $0x14,%esp
  801d62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	b8 05 00 00 00       	mov    $0x5,%eax
  801d7a:	e8 ed fe ff ff       	call   801c6c <fsipc>
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	78 2b                	js     801dae <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d83:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d8a:	00 
  801d8b:	89 1c 24             	mov    %ebx,(%esp)
  801d8e:	e8 b6 ec ff ff       	call   800a49 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d93:	a1 80 60 80 00       	mov    0x806080,%eax
  801d98:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d9e:	a1 84 60 80 00       	mov    0x806084,%eax
  801da3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801dae:	83 c4 14             	add    $0x14,%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    

00801db4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	53                   	push   %ebx
  801db8:	83 ec 14             	sub    $0x14,%esp
  801dbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dc9:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801dcf:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801dd5:	76 24                	jbe    801dfb <devfile_write+0x47>
  801dd7:	c7 44 24 0c 16 34 80 	movl   $0x803416,0xc(%esp)
  801dde:	00 
  801ddf:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  801de6:	00 
  801de7:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801dee:	00 
  801def:	c7 04 24 35 34 80 00 	movl   $0x803435,(%esp)
  801df6:	e8 2d e5 ff ff       	call   800328 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801dfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e06:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e0d:	e8 dd ed ff ff       	call   800bef <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
  801e17:	b8 04 00 00 00       	mov    $0x4,%eax
  801e1c:	e8 4b fe ff ff       	call   801c6c <fsipc>
	if(ret<0) return ret;
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 53                	js     801e78 <devfile_write+0xc4>
	
	assert(ret <= n);
  801e25:	39 c3                	cmp    %eax,%ebx
  801e27:	73 24                	jae    801e4d <devfile_write+0x99>
  801e29:	c7 44 24 0c 40 34 80 	movl   $0x803440,0xc(%esp)
  801e30:	00 
  801e31:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  801e38:	00 
  801e39:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801e40:	00 
  801e41:	c7 04 24 35 34 80 00 	movl   $0x803435,(%esp)
  801e48:	e8 db e4 ff ff       	call   800328 <_panic>
	assert(ret <= PGSIZE);
  801e4d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e52:	7e 24                	jle    801e78 <devfile_write+0xc4>
  801e54:	c7 44 24 0c 49 34 80 	movl   $0x803449,0xc(%esp)
  801e5b:	00 
  801e5c:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  801e63:	00 
  801e64:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801e6b:	00 
  801e6c:	c7 04 24 35 34 80 00 	movl   $0x803435,(%esp)
  801e73:	e8 b0 e4 ff ff       	call   800328 <_panic>
	return ret;
}
  801e78:	83 c4 14             	add    $0x14,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	56                   	push   %esi
  801e82:	53                   	push   %ebx
  801e83:	83 ec 10             	sub    $0x10,%esp
  801e86:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e94:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9f:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea4:	e8 c3 fd ff ff       	call   801c6c <fsipc>
  801ea9:	89 c3                	mov    %eax,%ebx
  801eab:	85 c0                	test   %eax,%eax
  801ead:	78 6b                	js     801f1a <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801eaf:	39 de                	cmp    %ebx,%esi
  801eb1:	73 24                	jae    801ed7 <devfile_read+0x59>
  801eb3:	c7 44 24 0c 57 34 80 	movl   $0x803457,0xc(%esp)
  801eba:	00 
  801ebb:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  801ec2:	00 
  801ec3:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801eca:	00 
  801ecb:	c7 04 24 35 34 80 00 	movl   $0x803435,(%esp)
  801ed2:	e8 51 e4 ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  801ed7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801edd:	7e 24                	jle    801f03 <devfile_read+0x85>
  801edf:	c7 44 24 0c 5e 34 80 	movl   $0x80345e,0xc(%esp)
  801ee6:	00 
  801ee7:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  801eee:	00 
  801eef:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ef6:	00 
  801ef7:	c7 04 24 35 34 80 00 	movl   $0x803435,(%esp)
  801efe:	e8 25 e4 ff ff       	call   800328 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f07:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f0e:	00 
  801f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f12:	89 04 24             	mov    %eax,(%esp)
  801f15:	e8 d5 ec ff ff       	call   800bef <memmove>
	return r;
}
  801f1a:	89 d8                	mov    %ebx,%eax
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 28             	sub    $0x28,%esp
  801f29:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f2c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801f2f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f32:	89 34 24             	mov    %esi,(%esp)
  801f35:	e8 d6 ea ff ff       	call   800a10 <strlen>
  801f3a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f3f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f44:	7f 5e                	jg     801fa4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f49:	89 04 24             	mov    %eax,(%esp)
  801f4c:	e8 46 f7 ff ff       	call   801697 <fd_alloc>
  801f51:	89 c3                	mov    %eax,%ebx
  801f53:	85 c0                	test   %eax,%eax
  801f55:	78 4d                	js     801fa4 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f57:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f5b:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f62:	e8 e2 ea ff ff       	call   800a49 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f72:	b8 01 00 00 00       	mov    $0x1,%eax
  801f77:	e8 f0 fc ff ff       	call   801c6c <fsipc>
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	79 15                	jns    801f97 <open+0x74>
		fd_close(fd, 0);
  801f82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f89:	00 
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	89 04 24             	mov    %eax,(%esp)
  801f90:	e8 87 fa ff ff       	call   801a1c <fd_close>
		return r;
  801f95:	eb 0d                	jmp    801fa4 <open+0x81>
	}

	return fd2num(fd);
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	89 04 24             	mov    %eax,(%esp)
  801f9d:	e8 ca f6 ff ff       	call   80166c <fd2num>
  801fa2:	89 c3                	mov    %eax,%ebx
}
  801fa4:	89 d8                	mov    %ebx,%eax
  801fa6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801fa9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801fac:	89 ec                	mov    %ebp,%esp
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801fb6:	c7 44 24 04 6a 34 80 	movl   $0x80346a,0x4(%esp)
  801fbd:	00 
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	89 04 24             	mov    %eax,(%esp)
  801fc4:	e8 80 ea ff ff       	call   800a49 <strcpy>
	return 0;
}
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 14             	sub    $0x14,%esp
  801fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fda:	89 1c 24             	mov    %ebx,(%esp)
  801fdd:	e8 f2 0b 00 00       	call   802bd4 <pageref>
  801fe2:	89 c2                	mov    %eax,%edx
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe9:	83 fa 01             	cmp    $0x1,%edx
  801fec:	75 0b                	jne    801ff9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801fee:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ff1:	89 04 24             	mov    %eax,(%esp)
  801ff4:	e8 b1 02 00 00       	call   8022aa <nsipc_close>
	else
		return 0;
}
  801ff9:	83 c4 14             	add    $0x14,%esp
  801ffc:	5b                   	pop    %ebx
  801ffd:	5d                   	pop    %ebp
  801ffe:	c3                   	ret    

00801fff <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802005:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80200c:	00 
  80200d:	8b 45 10             	mov    0x10(%ebp),%eax
  802010:	89 44 24 08          	mov    %eax,0x8(%esp)
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	8b 40 0c             	mov    0xc(%eax),%eax
  802021:	89 04 24             	mov    %eax,(%esp)
  802024:	e8 bd 02 00 00       	call   8022e6 <nsipc_send>
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802031:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802038:	00 
  802039:	8b 45 10             	mov    0x10(%ebp),%eax
  80203c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802040:	8b 45 0c             	mov    0xc(%ebp),%eax
  802043:	89 44 24 04          	mov    %eax,0x4(%esp)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	8b 40 0c             	mov    0xc(%eax),%eax
  80204d:	89 04 24             	mov    %eax,(%esp)
  802050:	e8 04 03 00 00       	call   802359 <nsipc_recv>
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	56                   	push   %esi
  80205b:	53                   	push   %ebx
  80205c:	83 ec 20             	sub    $0x20,%esp
  80205f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802061:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802064:	89 04 24             	mov    %eax,(%esp)
  802067:	e8 2b f6 ff ff       	call   801697 <fd_alloc>
  80206c:	89 c3                	mov    %eax,%ebx
  80206e:	85 c0                	test   %eax,%eax
  802070:	78 21                	js     802093 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802072:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802079:	00 
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802081:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802088:	e8 01 f1 ff ff       	call   80118e <sys_page_alloc>
  80208d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80208f:	85 c0                	test   %eax,%eax
  802091:	79 0a                	jns    80209d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802093:	89 34 24             	mov    %esi,(%esp)
  802096:	e8 0f 02 00 00       	call   8022aa <nsipc_close>
		return r;
  80209b:	eb 28                	jmp    8020c5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80209d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 a9 f5 ff ff       	call   80166c <fd2num>
  8020c3:	89 c3                	mov    %eax,%ebx
}
  8020c5:	89 d8                	mov    %ebx,%eax
  8020c7:	83 c4 20             	add    $0x20,%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5e                   	pop    %esi
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	89 04 24             	mov    %eax,(%esp)
  8020e8:	e8 71 01 00 00       	call   80225e <nsipc_socket>
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 05                	js     8020f6 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8020f1:	e8 61 ff ff ff       	call   802057 <alloc_sockfd>
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020fe:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802101:	89 54 24 04          	mov    %edx,0x4(%esp)
  802105:	89 04 24             	mov    %eax,(%esp)
  802108:	e8 e3 f5 ff ff       	call   8016f0 <fd_lookup>
  80210d:	85 c0                	test   %eax,%eax
  80210f:	78 15                	js     802126 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802114:	8b 0a                	mov    (%edx),%ecx
  802116:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80211b:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  802121:	75 03                	jne    802126 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802123:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	e8 c2 ff ff ff       	call   8020f8 <fd2sockid>
  802136:	85 c0                	test   %eax,%eax
  802138:	78 0f                	js     802149 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 3f 01 00 00       	call   802288 <nsipc_listen>
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	e8 9f ff ff ff       	call   8020f8 <fd2sockid>
  802159:	85 c0                	test   %eax,%eax
  80215b:	78 16                	js     802173 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80215d:	8b 55 10             	mov    0x10(%ebp),%edx
  802160:	89 54 24 08          	mov    %edx,0x8(%esp)
  802164:	8b 55 0c             	mov    0xc(%ebp),%edx
  802167:	89 54 24 04          	mov    %edx,0x4(%esp)
  80216b:	89 04 24             	mov    %eax,(%esp)
  80216e:	e8 66 02 00 00       	call   8023d9 <nsipc_connect>
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	e8 75 ff ff ff       	call   8020f8 <fd2sockid>
  802183:	85 c0                	test   %eax,%eax
  802185:	78 0f                	js     802196 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80218e:	89 04 24             	mov    %eax,(%esp)
  802191:	e8 2e 01 00 00       	call   8022c4 <nsipc_shutdown>
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	e8 52 ff ff ff       	call   8020f8 <fd2sockid>
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 16                	js     8021c0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8021aa:	8b 55 10             	mov    0x10(%ebp),%edx
  8021ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021b8:	89 04 24             	mov    %eax,(%esp)
  8021bb:	e8 58 02 00 00       	call   802418 <nsipc_bind>
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	e8 28 ff ff ff       	call   8020f8 <fd2sockid>
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	78 1f                	js     8021f3 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021d4:	8b 55 10             	mov    0x10(%ebp),%edx
  8021d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e2:	89 04 24             	mov    %eax,(%esp)
  8021e5:	e8 6d 02 00 00       	call   802457 <nsipc_accept>
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 05                	js     8021f3 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8021ee:	e8 64 fe ff ff       	call   802057 <alloc_sockfd>
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    
  8021f5:	00 00                	add    %al,(%eax)
	...

008021f8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	53                   	push   %ebx
  8021fc:	83 ec 14             	sub    $0x14,%esp
  8021ff:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802201:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802208:	75 11                	jne    80221b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80220a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802211:	e8 92 08 00 00       	call   802aa8 <ipc_find_env>
  802216:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80221b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802222:	00 
  802223:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80222a:	00 
  80222b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80222f:	a1 04 50 80 00       	mov    0x805004,%eax
  802234:	89 04 24             	mov    %eax,(%esp)
  802237:	e8 a2 08 00 00       	call   802ade <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80223c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802243:	00 
  802244:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80224b:	00 
  80224c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802253:	e8 f2 08 00 00       	call   802b4a <ipc_recv>
}
  802258:	83 c4 14             	add    $0x14,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802274:	8b 45 10             	mov    0x10(%ebp),%eax
  802277:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80227c:	b8 09 00 00 00       	mov    $0x9,%eax
  802281:	e8 72 ff ff ff       	call   8021f8 <nsipc>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802296:	8b 45 0c             	mov    0xc(%ebp),%eax
  802299:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80229e:	b8 06 00 00 00       	mov    $0x6,%eax
  8022a3:	e8 50 ff ff ff       	call   8021f8 <nsipc>
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8022b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8022bd:	e8 36 ff ff ff       	call   8021f8 <nsipc>
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8022d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d5:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8022da:	b8 03 00 00 00       	mov    $0x3,%eax
  8022df:	e8 14 ff ff ff       	call   8021f8 <nsipc>
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	53                   	push   %ebx
  8022ea:	83 ec 14             	sub    $0x14,%esp
  8022ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8022f8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022fe:	7e 24                	jle    802324 <nsipc_send+0x3e>
  802300:	c7 44 24 0c 76 34 80 	movl   $0x803476,0xc(%esp)
  802307:	00 
  802308:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  80230f:	00 
  802310:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802317:	00 
  802318:	c7 04 24 82 34 80 00 	movl   $0x803482,(%esp)
  80231f:	e8 04 e0 ff ff       	call   800328 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802324:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802336:	e8 b4 e8 ff ff       	call   800bef <memmove>
	nsipcbuf.send.req_size = size;
  80233b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802341:	8b 45 14             	mov    0x14(%ebp),%eax
  802344:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802349:	b8 08 00 00 00       	mov    $0x8,%eax
  80234e:	e8 a5 fe ff ff       	call   8021f8 <nsipc>
}
  802353:	83 c4 14             	add    $0x14,%esp
  802356:	5b                   	pop    %ebx
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    

00802359 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	56                   	push   %esi
  80235d:	53                   	push   %ebx
  80235e:	83 ec 10             	sub    $0x10,%esp
  802361:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80236c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802372:	8b 45 14             	mov    0x14(%ebp),%eax
  802375:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80237a:	b8 07 00 00 00       	mov    $0x7,%eax
  80237f:	e8 74 fe ff ff       	call   8021f8 <nsipc>
  802384:	89 c3                	mov    %eax,%ebx
  802386:	85 c0                	test   %eax,%eax
  802388:	78 46                	js     8023d0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80238a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80238f:	7f 04                	jg     802395 <nsipc_recv+0x3c>
  802391:	39 c6                	cmp    %eax,%esi
  802393:	7d 24                	jge    8023b9 <nsipc_recv+0x60>
  802395:	c7 44 24 0c 8e 34 80 	movl   $0x80348e,0xc(%esp)
  80239c:	00 
  80239d:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  8023a4:	00 
  8023a5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8023ac:	00 
  8023ad:	c7 04 24 82 34 80 00 	movl   $0x803482,(%esp)
  8023b4:	e8 6f df ff ff       	call   800328 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023bd:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8023c4:	00 
  8023c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c8:	89 04 24             	mov    %eax,(%esp)
  8023cb:	e8 1f e8 ff ff       	call   800bef <memmove>
	}

	return r;
}
  8023d0:	89 d8                	mov    %ebx,%eax
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    

008023d9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	53                   	push   %ebx
  8023dd:	83 ec 14             	sub    $0x14,%esp
  8023e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f6:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8023fd:	e8 ed e7 ff ff       	call   800bef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802402:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802408:	b8 05 00 00 00       	mov    $0x5,%eax
  80240d:	e8 e6 fd ff ff       	call   8021f8 <nsipc>
}
  802412:	83 c4 14             	add    $0x14,%esp
  802415:	5b                   	pop    %ebx
  802416:	5d                   	pop    %ebp
  802417:	c3                   	ret    

00802418 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	53                   	push   %ebx
  80241c:	83 ec 14             	sub    $0x14,%esp
  80241f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80242a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80242e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802431:	89 44 24 04          	mov    %eax,0x4(%esp)
  802435:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80243c:	e8 ae e7 ff ff       	call   800bef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802441:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802447:	b8 02 00 00 00       	mov    $0x2,%eax
  80244c:	e8 a7 fd ff ff       	call   8021f8 <nsipc>
}
  802451:	83 c4 14             	add    $0x14,%esp
  802454:	5b                   	pop    %ebx
  802455:	5d                   	pop    %ebp
  802456:	c3                   	ret    

00802457 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 28             	sub    $0x28,%esp
  80245d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802460:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802463:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802466:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802471:	8b 07                	mov    (%edi),%eax
  802473:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802478:	b8 01 00 00 00       	mov    $0x1,%eax
  80247d:	e8 76 fd ff ff       	call   8021f8 <nsipc>
  802482:	89 c6                	mov    %eax,%esi
  802484:	85 c0                	test   %eax,%eax
  802486:	78 22                	js     8024aa <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802488:	bb 10 80 80 00       	mov    $0x808010,%ebx
  80248d:	8b 03                	mov    (%ebx),%eax
  80248f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802493:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80249a:	00 
  80249b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249e:	89 04 24             	mov    %eax,(%esp)
  8024a1:	e8 49 e7 ff ff       	call   800bef <memmove>
		*addrlen = ret->ret_addrlen;
  8024a6:	8b 03                	mov    (%ebx),%eax
  8024a8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8024aa:	89 f0                	mov    %esi,%eax
  8024ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8024af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8024b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8024b5:	89 ec                	mov    %ebp,%esp
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    
  8024b9:	00 00                	add    %al,(%eax)
	...

008024bc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 18             	sub    $0x18,%esp
  8024c2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024c5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8024c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	89 04 24             	mov    %eax,(%esp)
  8024d1:	e8 a6 f1 ff ff       	call   80167c <fd2data>
  8024d6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8024d8:	c7 44 24 04 a3 34 80 	movl   $0x8034a3,0x4(%esp)
  8024df:	00 
  8024e0:	89 34 24             	mov    %esi,(%esp)
  8024e3:	e8 61 e5 ff ff       	call   800a49 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024e8:	8b 43 04             	mov    0x4(%ebx),%eax
  8024eb:	2b 03                	sub    (%ebx),%eax
  8024ed:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8024f3:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8024fa:	00 00 00 
	stat->st_dev = &devpipe;
  8024fd:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802504:	40 80 00 
	return 0;
}
  802507:	b8 00 00 00 00       	mov    $0x0,%eax
  80250c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80250f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802512:	89 ec                	mov    %ebp,%esp
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    

00802516 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	53                   	push   %ebx
  80251a:	83 ec 14             	sub    $0x14,%esp
  80251d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802520:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802524:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80252b:	e8 a2 eb ff ff       	call   8010d2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802530:	89 1c 24             	mov    %ebx,(%esp)
  802533:	e8 44 f1 ff ff       	call   80167c <fd2data>
  802538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802543:	e8 8a eb ff ff       	call   8010d2 <sys_page_unmap>
}
  802548:	83 c4 14             	add    $0x14,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    

0080254e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 2c             	sub    $0x2c,%esp
  802557:	89 c7                	mov    %eax,%edi
  802559:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80255c:	a1 08 50 80 00       	mov    0x805008,%eax
  802561:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802564:	89 3c 24             	mov    %edi,(%esp)
  802567:	e8 68 06 00 00       	call   802bd4 <pageref>
  80256c:	89 c6                	mov    %eax,%esi
  80256e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802571:	89 04 24             	mov    %eax,(%esp)
  802574:	e8 5b 06 00 00       	call   802bd4 <pageref>
  802579:	39 c6                	cmp    %eax,%esi
  80257b:	0f 94 c0             	sete   %al
  80257e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802581:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802587:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80258a:	39 cb                	cmp    %ecx,%ebx
  80258c:	75 08                	jne    802596 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80258e:	83 c4 2c             	add    $0x2c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802596:	83 f8 01             	cmp    $0x1,%eax
  802599:	75 c1                	jne    80255c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80259b:	8b 52 58             	mov    0x58(%edx),%edx
  80259e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025a2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025aa:	c7 04 24 aa 34 80 00 	movl   $0x8034aa,(%esp)
  8025b1:	e8 2b de ff ff       	call   8003e1 <cprintf>
  8025b6:	eb a4                	jmp    80255c <_pipeisclosed+0xe>

008025b8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	57                   	push   %edi
  8025bc:	56                   	push   %esi
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 1c             	sub    $0x1c,%esp
  8025c1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8025c4:	89 34 24             	mov    %esi,(%esp)
  8025c7:	e8 b0 f0 ff ff       	call   80167c <fd2data>
  8025cc:	89 c3                	mov    %eax,%ebx
  8025ce:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025d3:	eb 48                	jmp    80261d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8025d5:	89 da                	mov    %ebx,%edx
  8025d7:	89 f0                	mov    %esi,%eax
  8025d9:	e8 70 ff ff ff       	call   80254e <_pipeisclosed>
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	74 07                	je     8025e9 <devpipe_write+0x31>
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e7:	eb 3b                	jmp    802624 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8025e9:	e8 ff eb ff ff       	call   8011ed <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025ee:	8b 43 04             	mov    0x4(%ebx),%eax
  8025f1:	8b 13                	mov    (%ebx),%edx
  8025f3:	83 c2 20             	add    $0x20,%edx
  8025f6:	39 d0                	cmp    %edx,%eax
  8025f8:	73 db                	jae    8025d5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025fa:	89 c2                	mov    %eax,%edx
  8025fc:	c1 fa 1f             	sar    $0x1f,%edx
  8025ff:	c1 ea 1b             	shr    $0x1b,%edx
  802602:	01 d0                	add    %edx,%eax
  802604:	83 e0 1f             	and    $0x1f,%eax
  802607:	29 d0                	sub    %edx,%eax
  802609:	89 c2                	mov    %eax,%edx
  80260b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80260e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802612:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802616:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80261a:	83 c7 01             	add    $0x1,%edi
  80261d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802620:	72 cc                	jb     8025ee <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802622:	89 f8                	mov    %edi,%eax
}
  802624:	83 c4 1c             	add    $0x1c,%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5f                   	pop    %edi
  80262a:	5d                   	pop    %ebp
  80262b:	c3                   	ret    

0080262c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 28             	sub    $0x28,%esp
  802632:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802635:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802638:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80263b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80263e:	89 3c 24             	mov    %edi,(%esp)
  802641:	e8 36 f0 ff ff       	call   80167c <fd2data>
  802646:	89 c3                	mov    %eax,%ebx
  802648:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80264d:	eb 48                	jmp    802697 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80264f:	85 f6                	test   %esi,%esi
  802651:	74 04                	je     802657 <devpipe_read+0x2b>
				return i;
  802653:	89 f0                	mov    %esi,%eax
  802655:	eb 47                	jmp    80269e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802657:	89 da                	mov    %ebx,%edx
  802659:	89 f8                	mov    %edi,%eax
  80265b:	e8 ee fe ff ff       	call   80254e <_pipeisclosed>
  802660:	85 c0                	test   %eax,%eax
  802662:	74 07                	je     80266b <devpipe_read+0x3f>
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
  802669:	eb 33                	jmp    80269e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80266b:	e8 7d eb ff ff       	call   8011ed <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802670:	8b 03                	mov    (%ebx),%eax
  802672:	3b 43 04             	cmp    0x4(%ebx),%eax
  802675:	74 d8                	je     80264f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802677:	89 c2                	mov    %eax,%edx
  802679:	c1 fa 1f             	sar    $0x1f,%edx
  80267c:	c1 ea 1b             	shr    $0x1b,%edx
  80267f:	01 d0                	add    %edx,%eax
  802681:	83 e0 1f             	and    $0x1f,%eax
  802684:	29 d0                	sub    %edx,%eax
  802686:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80268b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802691:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802694:	83 c6 01             	add    $0x1,%esi
  802697:	3b 75 10             	cmp    0x10(%ebp),%esi
  80269a:	72 d4                	jb     802670 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80269c:	89 f0                	mov    %esi,%eax
}
  80269e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8026a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8026a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8026a7:	89 ec                	mov    %ebp,%esp
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    

008026ab <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	89 04 24             	mov    %eax,(%esp)
  8026be:	e8 2d f0 ff ff       	call   8016f0 <fd_lookup>
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	78 15                	js     8026dc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	89 04 24             	mov    %eax,(%esp)
  8026cd:	e8 aa ef ff ff       	call   80167c <fd2data>
	return _pipeisclosed(fd, p);
  8026d2:	89 c2                	mov    %eax,%edx
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	e8 72 fe ff ff       	call   80254e <_pipeisclosed>
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 48             	sub    $0x48,%esp
  8026e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8026f3:	89 04 24             	mov    %eax,(%esp)
  8026f6:	e8 9c ef ff ff       	call   801697 <fd_alloc>
  8026fb:	89 c3                	mov    %eax,%ebx
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	0f 88 42 01 00 00    	js     802847 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802705:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80270c:	00 
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	89 44 24 04          	mov    %eax,0x4(%esp)
  802714:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80271b:	e8 6e ea ff ff       	call   80118e <sys_page_alloc>
  802720:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802722:	85 c0                	test   %eax,%eax
  802724:	0f 88 1d 01 00 00    	js     802847 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80272a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80272d:	89 04 24             	mov    %eax,(%esp)
  802730:	e8 62 ef ff ff       	call   801697 <fd_alloc>
  802735:	89 c3                	mov    %eax,%ebx
  802737:	85 c0                	test   %eax,%eax
  802739:	0f 88 f5 00 00 00    	js     802834 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802746:	00 
  802747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802755:	e8 34 ea ff ff       	call   80118e <sys_page_alloc>
  80275a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80275c:	85 c0                	test   %eax,%eax
  80275e:	0f 88 d0 00 00 00    	js     802834 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802767:	89 04 24             	mov    %eax,(%esp)
  80276a:	e8 0d ef ff ff       	call   80167c <fd2data>
  80276f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802771:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802778:	00 
  802779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802784:	e8 05 ea ff ff       	call   80118e <sys_page_alloc>
  802789:	89 c3                	mov    %eax,%ebx
  80278b:	85 c0                	test   %eax,%eax
  80278d:	0f 88 8e 00 00 00    	js     802821 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802796:	89 04 24             	mov    %eax,(%esp)
  802799:	e8 de ee ff ff       	call   80167c <fd2data>
  80279e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027a5:	00 
  8027a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027b1:	00 
  8027b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027bd:	e8 6e e9 ff ff       	call   801130 <sys_page_map>
  8027c2:	89 c3                	mov    %eax,%ebx
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	78 49                	js     802811 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8027c8:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  8027cd:	8b 08                	mov    (%eax),%ecx
  8027cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8027d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8027de:	8b 10                	mov    (%eax),%edx
  8027e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8027ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f2:	89 04 24             	mov    %eax,(%esp)
  8027f5:	e8 72 ee ff ff       	call   80166c <fd2num>
  8027fa:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8027fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ff:	89 04 24             	mov    %eax,(%esp)
  802802:	e8 65 ee ff ff       	call   80166c <fd2num>
  802807:	89 47 04             	mov    %eax,0x4(%edi)
  80280a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80280f:	eb 36                	jmp    802847 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802811:	89 74 24 04          	mov    %esi,0x4(%esp)
  802815:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80281c:	e8 b1 e8 ff ff       	call   8010d2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802824:	89 44 24 04          	mov    %eax,0x4(%esp)
  802828:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80282f:	e8 9e e8 ff ff       	call   8010d2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802842:	e8 8b e8 ff ff       	call   8010d2 <sys_page_unmap>
    err:
	return r;
}
  802847:	89 d8                	mov    %ebx,%eax
  802849:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80284c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80284f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802852:	89 ec                	mov    %ebp,%esp
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    
	...

00802860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    

0080286a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802870:	c7 44 24 04 bd 34 80 	movl   $0x8034bd,0x4(%esp)
  802877:	00 
  802878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287b:	89 04 24             	mov    %eax,(%esp)
  80287e:	e8 c6 e1 ff ff       	call   800a49 <strcpy>
	return 0;
}
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	57                   	push   %edi
  80288e:	56                   	push   %esi
  80288f:	53                   	push   %ebx
  802890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802896:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80289b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028a1:	eb 34                	jmp    8028d7 <devcons_write+0x4d>
		m = n - tot;
  8028a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028a6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8028a8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8028ae:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028b3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028ba:	03 45 0c             	add    0xc(%ebp),%eax
  8028bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c1:	89 3c 24             	mov    %edi,(%esp)
  8028c4:	e8 26 e3 ff ff       	call   800bef <memmove>
		sys_cputs(buf, m);
  8028c9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028cd:	89 3c 24             	mov    %edi,(%esp)
  8028d0:	e8 2b e5 ff ff       	call   800e00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028d5:	01 de                	add    %ebx,%esi
  8028d7:	89 f0                	mov    %esi,%eax
  8028d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028dc:	72 c5                	jb     8028a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028de:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028e4:	5b                   	pop    %ebx
  8028e5:	5e                   	pop    %esi
  8028e6:	5f                   	pop    %edi
  8028e7:	5d                   	pop    %ebp
  8028e8:	c3                   	ret    

008028e9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028e9:	55                   	push   %ebp
  8028ea:	89 e5                	mov    %esp,%ebp
  8028ec:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028fc:	00 
  8028fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802900:	89 04 24             	mov    %eax,(%esp)
  802903:	e8 f8 e4 ff ff       	call   800e00 <sys_cputs>
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802910:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802914:	75 07                	jne    80291d <devcons_read+0x13>
  802916:	eb 28                	jmp    802940 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802918:	e8 d0 e8 ff ff       	call   8011ed <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80291d:	8d 76 00             	lea    0x0(%esi),%esi
  802920:	e8 a7 e4 ff ff       	call   800dcc <sys_cgetc>
  802925:	85 c0                	test   %eax,%eax
  802927:	74 ef                	je     802918 <devcons_read+0xe>
  802929:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80292b:	85 c0                	test   %eax,%eax
  80292d:	78 16                	js     802945 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80292f:	83 f8 04             	cmp    $0x4,%eax
  802932:	74 0c                	je     802940 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802934:	8b 45 0c             	mov    0xc(%ebp),%eax
  802937:	88 10                	mov    %dl,(%eax)
  802939:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80293e:	eb 05                	jmp    802945 <devcons_read+0x3b>
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
  80294a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80294d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802950:	89 04 24             	mov    %eax,(%esp)
  802953:	e8 3f ed ff ff       	call   801697 <fd_alloc>
  802958:	85 c0                	test   %eax,%eax
  80295a:	78 3f                	js     80299b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80295c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802963:	00 
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80296b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802972:	e8 17 e8 ff ff       	call   80118e <sys_page_alloc>
  802977:	85 c0                	test   %eax,%eax
  802979:	78 20                	js     80299b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80297b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	89 04 24             	mov    %eax,(%esp)
  802996:	e8 d1 ec ff ff       	call   80166c <fd2num>
}
  80299b:	c9                   	leave  
  80299c:	c3                   	ret    

0080299d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
  8029a0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	89 04 24             	mov    %eax,(%esp)
  8029b0:	e8 3b ed ff ff       	call   8016f0 <fd_lookup>
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	78 11                	js     8029ca <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  8029c4:	0f 94 c0             	sete   %al
  8029c7:	0f b6 c0             	movzbl %al,%eax
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
  8029cf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029d9:	00 
  8029da:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e8:	e8 5a ef ff ff       	call   801947 <read>
	if (r < 0)
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	78 0f                	js     802a00 <getchar+0x34>
		return r;
	if (r < 1)
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	7f 07                	jg     8029fc <getchar+0x30>
  8029f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029fa:	eb 04                	jmp    802a00 <getchar+0x34>
		return -E_EOF;
	return c;
  8029fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a00:	c9                   	leave  
  802a01:	c3                   	ret    
	...

00802a04 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	53                   	push   %ebx
  802a08:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  802a0b:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  802a12:	75 5b                	jne    802a6f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  802a14:	e8 08 e8 ff ff       	call   801221 <sys_getenvid>
  802a19:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  802a1b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a22:	00 
  802a23:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a2a:	ee 
  802a2b:	89 04 24             	mov    %eax,(%esp)
  802a2e:	e8 5b e7 ff ff       	call   80118e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 28                	je     802a5f <set_pgfault_handler+0x5b>
  802a37:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a3b:	c7 44 24 0c f0 34 80 	movl   $0x8034f0,0xc(%esp)
  802a42:	00 
  802a43:	c7 44 24 08 c9 34 80 	movl   $0x8034c9,0x8(%esp)
  802a4a:	00 
  802a4b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802a52:	00 
  802a53:	c7 04 24 e2 34 80 00 	movl   $0x8034e2,(%esp)
  802a5a:	e8 c9 d8 ff ff       	call   800328 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802a5f:	c7 44 24 04 80 2a 80 	movl   $0x802a80,0x4(%esp)
  802a66:	00 
  802a67:	89 1c 24             	mov    %ebx,(%esp)
  802a6a:	e8 49 e5 ff ff       	call   800fb8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	a3 00 90 80 00       	mov    %eax,0x809000
	
}
  802a77:	83 c4 24             	add    $0x24,%esp
  802a7a:	5b                   	pop    %ebx
  802a7b:	5d                   	pop    %ebp
  802a7c:	c3                   	ret    
  802a7d:	00 00                	add    %al,(%eax)
	...

00802a80 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a80:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a81:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  802a86:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a88:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  802a8b:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  802a8e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  802a92:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  802a96:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  802a99:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  802a9c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  802aa0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  802aa1:	83 c4 04             	add    $0x4,%esp
	popfl ;
  802aa4:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802aa5:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802aa6:	c3                   	ret    
	...

00802aa8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
  802aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802aae:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802ab3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ab6:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802abc:	8b 12                	mov    (%edx),%edx
  802abe:	39 ca                	cmp    %ecx,%edx
  802ac0:	75 0c                	jne    802ace <ipc_find_env+0x26>
			return envs[i].env_id;
  802ac2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802ac5:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	eb 0e                	jmp    802adc <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ace:	83 c0 01             	add    $0x1,%eax
  802ad1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ad6:	75 db                	jne    802ab3 <ipc_find_env+0xb>
  802ad8:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802adc:	5d                   	pop    %ebp
  802add:	c3                   	ret    

00802ade <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	53                   	push   %ebx
  802ae4:	83 ec 2c             	sub    $0x2c,%esp
  802ae7:	8b 75 08             	mov    0x8(%ebp),%esi
  802aea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802aed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802af0:	85 db                	test   %ebx,%ebx
  802af2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802af7:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802afa:	8b 45 14             	mov    0x14(%ebp),%eax
  802afd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b09:	89 34 24             	mov    %esi,(%esp)
  802b0c:	e8 6f e4 ff ff       	call   800f80 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802b11:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b14:	74 e4                	je     802afa <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 28                	je     802b42 <ipc_send+0x64>
  802b1a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b1e:	c7 44 24 0c 21 35 80 	movl   $0x803521,0xc(%esp)
  802b25:	00 
  802b26:	c7 44 24 08 04 35 80 	movl   $0x803504,0x8(%esp)
  802b2d:	00 
  802b2e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802b35:	00 
  802b36:	c7 04 24 17 35 80 00 	movl   $0x803517,(%esp)
  802b3d:	e8 e6 d7 ff ff       	call   800328 <_panic>
	//if(!ret) sys_yield();
}
  802b42:	83 c4 2c             	add    $0x2c,%esp
  802b45:	5b                   	pop    %ebx
  802b46:	5e                   	pop    %esi
  802b47:	5f                   	pop    %edi
  802b48:	5d                   	pop    %ebp
  802b49:	c3                   	ret    

00802b4a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
  802b4d:	83 ec 28             	sub    $0x28,%esp
  802b50:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b53:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b56:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b59:	8b 75 08             	mov    0x8(%ebp),%esi
  802b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802b62:	85 c0                	test   %eax,%eax
  802b64:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802b69:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802b6c:	89 04 24             	mov    %eax,(%esp)
  802b6f:	e8 af e3 ff ff       	call   800f23 <sys_ipc_recv>
  802b74:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802b76:	e8 a6 e6 ff ff       	call   801221 <sys_getenvid>
  802b7b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b80:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b83:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b88:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802b8d:	85 f6                	test   %esi,%esi
  802b8f:	74 0e                	je     802b9f <ipc_recv+0x55>
  802b91:	ba 00 00 00 00       	mov    $0x0,%edx
  802b96:	85 db                	test   %ebx,%ebx
  802b98:	75 03                	jne    802b9d <ipc_recv+0x53>
  802b9a:	8b 50 74             	mov    0x74(%eax),%edx
  802b9d:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802b9f:	85 ff                	test   %edi,%edi
  802ba1:	74 13                	je     802bb6 <ipc_recv+0x6c>
  802ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba8:	85 db                	test   %ebx,%ebx
  802baa:	75 08                	jne    802bb4 <ipc_recv+0x6a>
  802bac:	a1 08 50 80 00       	mov    0x805008,%eax
  802bb1:	8b 40 78             	mov    0x78(%eax),%eax
  802bb4:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802bb6:	85 db                	test   %ebx,%ebx
  802bb8:	75 08                	jne    802bc2 <ipc_recv+0x78>
  802bba:	a1 08 50 80 00       	mov    0x805008,%eax
  802bbf:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802bc2:	89 d8                	mov    %ebx,%eax
  802bc4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802bc7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802bca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802bcd:	89 ec                	mov    %ebp,%esp
  802bcf:	5d                   	pop    %ebp
  802bd0:	c3                   	ret    
  802bd1:	00 00                	add    %al,(%eax)
	...

00802bd4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bd4:	55                   	push   %ebp
  802bd5:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	89 c2                	mov    %eax,%edx
  802bdc:	c1 ea 16             	shr    $0x16,%edx
  802bdf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802be6:	f6 c2 01             	test   $0x1,%dl
  802be9:	74 20                	je     802c0b <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802beb:	c1 e8 0c             	shr    $0xc,%eax
  802bee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802bf5:	a8 01                	test   $0x1,%al
  802bf7:	74 12                	je     802c0b <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802bf9:	c1 e8 0c             	shr    $0xc,%eax
  802bfc:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802c01:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802c06:	0f b7 c0             	movzwl %ax,%eax
  802c09:	eb 05                	jmp    802c10 <pageref+0x3c>
  802c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c10:	5d                   	pop    %ebp
  802c11:	c3                   	ret    
	...

00802c20 <__udivdi3>:
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
  802c23:	57                   	push   %edi
  802c24:	56                   	push   %esi
  802c25:	83 ec 10             	sub    $0x10,%esp
  802c28:	8b 45 14             	mov    0x14(%ebp),%eax
  802c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2e:	8b 75 10             	mov    0x10(%ebp),%esi
  802c31:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c34:	85 c0                	test   %eax,%eax
  802c36:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802c39:	75 35                	jne    802c70 <__udivdi3+0x50>
  802c3b:	39 fe                	cmp    %edi,%esi
  802c3d:	77 61                	ja     802ca0 <__udivdi3+0x80>
  802c3f:	85 f6                	test   %esi,%esi
  802c41:	75 0b                	jne    802c4e <__udivdi3+0x2e>
  802c43:	b8 01 00 00 00       	mov    $0x1,%eax
  802c48:	31 d2                	xor    %edx,%edx
  802c4a:	f7 f6                	div    %esi
  802c4c:	89 c6                	mov    %eax,%esi
  802c4e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c51:	31 d2                	xor    %edx,%edx
  802c53:	89 f8                	mov    %edi,%eax
  802c55:	f7 f6                	div    %esi
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	89 c8                	mov    %ecx,%eax
  802c5b:	f7 f6                	div    %esi
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	89 fa                	mov    %edi,%edx
  802c61:	89 c8                	mov    %ecx,%eax
  802c63:	83 c4 10             	add    $0x10,%esp
  802c66:	5e                   	pop    %esi
  802c67:	5f                   	pop    %edi
  802c68:	5d                   	pop    %ebp
  802c69:	c3                   	ret    
  802c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c70:	39 f8                	cmp    %edi,%eax
  802c72:	77 1c                	ja     802c90 <__udivdi3+0x70>
  802c74:	0f bd d0             	bsr    %eax,%edx
  802c77:	83 f2 1f             	xor    $0x1f,%edx
  802c7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c7d:	75 39                	jne    802cb8 <__udivdi3+0x98>
  802c7f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802c82:	0f 86 a0 00 00 00    	jbe    802d28 <__udivdi3+0x108>
  802c88:	39 f8                	cmp    %edi,%eax
  802c8a:	0f 82 98 00 00 00    	jb     802d28 <__udivdi3+0x108>
  802c90:	31 ff                	xor    %edi,%edi
  802c92:	31 c9                	xor    %ecx,%ecx
  802c94:	89 c8                	mov    %ecx,%eax
  802c96:	89 fa                	mov    %edi,%edx
  802c98:	83 c4 10             	add    $0x10,%esp
  802c9b:	5e                   	pop    %esi
  802c9c:	5f                   	pop    %edi
  802c9d:	5d                   	pop    %ebp
  802c9e:	c3                   	ret    
  802c9f:	90                   	nop
  802ca0:	89 d1                	mov    %edx,%ecx
  802ca2:	89 fa                	mov    %edi,%edx
  802ca4:	89 c8                	mov    %ecx,%eax
  802ca6:	31 ff                	xor    %edi,%edi
  802ca8:	f7 f6                	div    %esi
  802caa:	89 c1                	mov    %eax,%ecx
  802cac:	89 fa                	mov    %edi,%edx
  802cae:	89 c8                	mov    %ecx,%eax
  802cb0:	83 c4 10             	add    $0x10,%esp
  802cb3:	5e                   	pop    %esi
  802cb4:	5f                   	pop    %edi
  802cb5:	5d                   	pop    %ebp
  802cb6:	c3                   	ret    
  802cb7:	90                   	nop
  802cb8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cbc:	89 f2                	mov    %esi,%edx
  802cbe:	d3 e0                	shl    %cl,%eax
  802cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cc3:	b8 20 00 00 00       	mov    $0x20,%eax
  802cc8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ccb:	89 c1                	mov    %eax,%ecx
  802ccd:	d3 ea                	shr    %cl,%edx
  802ccf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cd3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802cd6:	d3 e6                	shl    %cl,%esi
  802cd8:	89 c1                	mov    %eax,%ecx
  802cda:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802cdd:	89 fe                	mov    %edi,%esi
  802cdf:	d3 ee                	shr    %cl,%esi
  802ce1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ce5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ce8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ceb:	d3 e7                	shl    %cl,%edi
  802ced:	89 c1                	mov    %eax,%ecx
  802cef:	d3 ea                	shr    %cl,%edx
  802cf1:	09 d7                	or     %edx,%edi
  802cf3:	89 f2                	mov    %esi,%edx
  802cf5:	89 f8                	mov    %edi,%eax
  802cf7:	f7 75 ec             	divl   -0x14(%ebp)
  802cfa:	89 d6                	mov    %edx,%esi
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	f7 65 e8             	mull   -0x18(%ebp)
  802d01:	39 d6                	cmp    %edx,%esi
  802d03:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d06:	72 30                	jb     802d38 <__udivdi3+0x118>
  802d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d0f:	d3 e2                	shl    %cl,%edx
  802d11:	39 c2                	cmp    %eax,%edx
  802d13:	73 05                	jae    802d1a <__udivdi3+0xfa>
  802d15:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802d18:	74 1e                	je     802d38 <__udivdi3+0x118>
  802d1a:	89 f9                	mov    %edi,%ecx
  802d1c:	31 ff                	xor    %edi,%edi
  802d1e:	e9 71 ff ff ff       	jmp    802c94 <__udivdi3+0x74>
  802d23:	90                   	nop
  802d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d28:	31 ff                	xor    %edi,%edi
  802d2a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802d2f:	e9 60 ff ff ff       	jmp    802c94 <__udivdi3+0x74>
  802d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d38:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802d3b:	31 ff                	xor    %edi,%edi
  802d3d:	89 c8                	mov    %ecx,%eax
  802d3f:	89 fa                	mov    %edi,%edx
  802d41:	83 c4 10             	add    $0x10,%esp
  802d44:	5e                   	pop    %esi
  802d45:	5f                   	pop    %edi
  802d46:	5d                   	pop    %ebp
  802d47:	c3                   	ret    
	...

00802d50 <__umoddi3>:
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	57                   	push   %edi
  802d54:	56                   	push   %esi
  802d55:	83 ec 20             	sub    $0x20,%esp
  802d58:	8b 55 14             	mov    0x14(%ebp),%edx
  802d5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d5e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802d61:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d64:	85 d2                	test   %edx,%edx
  802d66:	89 c8                	mov    %ecx,%eax
  802d68:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802d6b:	75 13                	jne    802d80 <__umoddi3+0x30>
  802d6d:	39 f7                	cmp    %esi,%edi
  802d6f:	76 3f                	jbe    802db0 <__umoddi3+0x60>
  802d71:	89 f2                	mov    %esi,%edx
  802d73:	f7 f7                	div    %edi
  802d75:	89 d0                	mov    %edx,%eax
  802d77:	31 d2                	xor    %edx,%edx
  802d79:	83 c4 20             	add    $0x20,%esp
  802d7c:	5e                   	pop    %esi
  802d7d:	5f                   	pop    %edi
  802d7e:	5d                   	pop    %ebp
  802d7f:	c3                   	ret    
  802d80:	39 f2                	cmp    %esi,%edx
  802d82:	77 4c                	ja     802dd0 <__umoddi3+0x80>
  802d84:	0f bd ca             	bsr    %edx,%ecx
  802d87:	83 f1 1f             	xor    $0x1f,%ecx
  802d8a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802d8d:	75 51                	jne    802de0 <__umoddi3+0x90>
  802d8f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802d92:	0f 87 e0 00 00 00    	ja     802e78 <__umoddi3+0x128>
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	29 f8                	sub    %edi,%eax
  802d9d:	19 d6                	sbb    %edx,%esi
  802d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	89 f2                	mov    %esi,%edx
  802da7:	83 c4 20             	add    $0x20,%esp
  802daa:	5e                   	pop    %esi
  802dab:	5f                   	pop    %edi
  802dac:	5d                   	pop    %ebp
  802dad:	c3                   	ret    
  802dae:	66 90                	xchg   %ax,%ax
  802db0:	85 ff                	test   %edi,%edi
  802db2:	75 0b                	jne    802dbf <__umoddi3+0x6f>
  802db4:	b8 01 00 00 00       	mov    $0x1,%eax
  802db9:	31 d2                	xor    %edx,%edx
  802dbb:	f7 f7                	div    %edi
  802dbd:	89 c7                	mov    %eax,%edi
  802dbf:	89 f0                	mov    %esi,%eax
  802dc1:	31 d2                	xor    %edx,%edx
  802dc3:	f7 f7                	div    %edi
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	f7 f7                	div    %edi
  802dca:	eb a9                	jmp    802d75 <__umoddi3+0x25>
  802dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dd0:	89 c8                	mov    %ecx,%eax
  802dd2:	89 f2                	mov    %esi,%edx
  802dd4:	83 c4 20             	add    $0x20,%esp
  802dd7:	5e                   	pop    %esi
  802dd8:	5f                   	pop    %edi
  802dd9:	5d                   	pop    %ebp
  802dda:	c3                   	ret    
  802ddb:	90                   	nop
  802ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802de0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802de4:	d3 e2                	shl    %cl,%edx
  802de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802de9:	ba 20 00 00 00       	mov    $0x20,%edx
  802dee:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802df1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802df4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802df8:	89 fa                	mov    %edi,%edx
  802dfa:	d3 ea                	shr    %cl,%edx
  802dfc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e00:	0b 55 f4             	or     -0xc(%ebp),%edx
  802e03:	d3 e7                	shl    %cl,%edi
  802e05:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e09:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e0c:	89 f2                	mov    %esi,%edx
  802e0e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802e11:	89 c7                	mov    %eax,%edi
  802e13:	d3 ea                	shr    %cl,%edx
  802e15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802e1c:	89 c2                	mov    %eax,%edx
  802e1e:	d3 e6                	shl    %cl,%esi
  802e20:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e24:	d3 ea                	shr    %cl,%edx
  802e26:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e2a:	09 d6                	or     %edx,%esi
  802e2c:	89 f0                	mov    %esi,%eax
  802e2e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802e31:	d3 e7                	shl    %cl,%edi
  802e33:	89 f2                	mov    %esi,%edx
  802e35:	f7 75 f4             	divl   -0xc(%ebp)
  802e38:	89 d6                	mov    %edx,%esi
  802e3a:	f7 65 e8             	mull   -0x18(%ebp)
  802e3d:	39 d6                	cmp    %edx,%esi
  802e3f:	72 2b                	jb     802e6c <__umoddi3+0x11c>
  802e41:	39 c7                	cmp    %eax,%edi
  802e43:	72 23                	jb     802e68 <__umoddi3+0x118>
  802e45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e49:	29 c7                	sub    %eax,%edi
  802e4b:	19 d6                	sbb    %edx,%esi
  802e4d:	89 f0                	mov    %esi,%eax
  802e4f:	89 f2                	mov    %esi,%edx
  802e51:	d3 ef                	shr    %cl,%edi
  802e53:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e57:	d3 e0                	shl    %cl,%eax
  802e59:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e5d:	09 f8                	or     %edi,%eax
  802e5f:	d3 ea                	shr    %cl,%edx
  802e61:	83 c4 20             	add    $0x20,%esp
  802e64:	5e                   	pop    %esi
  802e65:	5f                   	pop    %edi
  802e66:	5d                   	pop    %ebp
  802e67:	c3                   	ret    
  802e68:	39 d6                	cmp    %edx,%esi
  802e6a:	75 d9                	jne    802e45 <__umoddi3+0xf5>
  802e6c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e6f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802e72:	eb d1                	jmp    802e45 <__umoddi3+0xf5>
  802e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e78:	39 f2                	cmp    %esi,%edx
  802e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e80:	0f 82 12 ff ff ff    	jb     802d98 <__umoddi3+0x48>
  802e86:	e9 17 ff ff ff       	jmp    802da2 <__umoddi3+0x52>
