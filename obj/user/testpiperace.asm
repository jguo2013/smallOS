
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 e7 01 00 00       	call   800218 <libmain>
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
  800039:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003c:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  800043:	e8 ed 02 00 00       	call   800335 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 4b 27 00 00       	call   80279e <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 f9 2d 80 	movl   $0x802df9,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 02 2e 80 00 	movl   $0x802e02,(%esp)
  800072:	e8 05 02 00 00       	call   80027c <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800077:	e8 aa 11 00 00       	call   801226 <fork>
  80007c:	89 c6                	mov    %eax,%esi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 5a 32 80 	movl   $0x80325a,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 02 2e 80 00 	movl   $0x802e02,(%esp)
  80009d:	e8 da 01 00 00       	call   80027c <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 5c                	jne    800102 <umain+0xce>
		close(p[1]);
  8000a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 79 1a 00 00       	call   801b2a <close>
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 aa 26 00 00       	call   80276b <pipeisclosed>
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	74 11                	je     8000d6 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000c5:	c7 04 24 16 2e 80 00 	movl   $0x802e16,(%esp)
  8000cc:	e8 64 02 00 00       	call   800335 <cprintf>
				exit();
  8000d1:	e8 92 01 00 00       	call   800268 <exit>
			}
			sys_yield();
  8000d6:	e8 62 10 00 00       	call   80113d <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000db:	83 c3 01             	add    $0x1,%ebx
  8000de:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  8000e4:	75 d0                	jne    8000b6 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000fd:	e8 5c 15 00 00       	call   80165e <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800102:	89 74 24 04          	mov    %esi,0x4(%esp)
  800106:	c7 04 24 31 2e 80 00 	movl   $0x802e31,(%esp)
  80010d:	e8 23 02 00 00       	call   800335 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800112:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800118:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  80011b:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800121:	c1 ee 02             	shr    $0x2,%esi
  800124:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  80012a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012e:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  800135:	e8 fb 01 00 00       	call   800335 <cprintf>
	dup(p[0], 10);
  80013a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800141:	00 
  800142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800145:	89 04 24             	mov    %eax,(%esp)
  800148:	e8 7c 1a 00 00       	call   801bc9 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80014d:	eb 13                	jmp    800162 <umain+0x12e>
		dup(p[0], 10);
  80014f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800156:	00 
  800157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 67 1a 00 00       	call   801bc9 <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800162:	8b 43 54             	mov    0x54(%ebx),%eax
  800165:	83 f8 02             	cmp    $0x2,%eax
  800168:	74 e5                	je     80014f <umain+0x11b>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80016a:	c7 04 24 47 2e 80 00 	movl   $0x802e47,(%esp)
  800171:	e8 bf 01 00 00       	call   800335 <cprintf>
	if (pipeisclosed(p[0]))
  800176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800179:	89 04 24             	mov    %eax,(%esp)
  80017c:	e8 ea 25 00 00       	call   80276b <pipeisclosed>
  800181:	85 c0                	test   %eax,%eax
  800183:	74 1c                	je     8001a1 <umain+0x16d>
		panic("somehow the other end of p[0] got closed!");
  800185:	c7 44 24 08 a0 2e 80 	movl   $0x802ea0,0x8(%esp)
  80018c:	00 
  80018d:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800194:	00 
  800195:	c7 04 24 02 2e 80 00 	movl   $0x802e02,(%esp)
  80019c:	e8 db 00 00 00       	call   80027c <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ab:	89 04 24             	mov    %eax,(%esp)
  8001ae:	e8 b9 15 00 00       	call   80176c <fd_lookup>
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	79 20                	jns    8001d7 <umain+0x1a3>
		panic("cannot look up p[0]: %e", r);
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 5d 2e 80 	movl   $0x802e5d,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 02 2e 80 00 	movl   $0x802e02,(%esp)
  8001d2:	e8 a5 00 00 00       	call   80027c <_panic>
	va = fd2data(fd);
  8001d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001da:	89 04 24             	mov    %eax,(%esp)
  8001dd:	e8 16 15 00 00       	call   8016f8 <fd2data>
	if (pageref(va) != 3+1)
  8001e2:	89 04 24             	mov    %eax,(%esp)
  8001e5:	e8 42 1e 00 00       	call   80202c <pageref>
  8001ea:	83 f8 04             	cmp    $0x4,%eax
  8001ed:	74 0e                	je     8001fd <umain+0x1c9>
		cprintf("\nchild detected race\n");
  8001ef:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  8001f6:	e8 3a 01 00 00       	call   800335 <cprintf>
  8001fb:	eb 14                	jmp    800211 <umain+0x1dd>
	else
		cprintf("\nrace didn't happen\n", max);
  8001fd:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  800204:	00 
  800205:	c7 04 24 8b 2e 80 00 	movl   $0x802e8b,(%esp)
  80020c:	e8 24 01 00 00       	call   800335 <cprintf>
}
  800211:	83 c4 20             	add    $0x20,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 18             	sub    $0x18,%esp
  80021e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800221:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800224:	8b 75 08             	mov    0x8(%ebp),%esi
  800227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80022a:	e8 42 0f 00 00       	call   801171 <sys_getenvid>
  80022f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800234:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800237:	2d 00 00 40 11       	sub    $0x11400000,%eax
  80023c:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800241:	85 f6                	test   %esi,%esi
  800243:	7e 07                	jle    80024c <libmain+0x34>
		binaryname = argv[0];
  800245:	8b 03                	mov    (%ebx),%eax
  800247:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80024c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800250:	89 34 24             	mov    %esi,(%esp)
  800253:	e8 dc fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800258:	e8 0b 00 00 00       	call   800268 <exit>
}
  80025d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800260:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800263:	89 ec                	mov    %ebp,%esp
  800265:	5d                   	pop    %ebp
  800266:	c3                   	ret    
	...

00800268 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80026e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800275:	e8 2b 0f 00 00       	call   8011a5 <sys_env_destroy>
}
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800284:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800287:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  80028d:	e8 df 0e 00 00       	call   801171 <sys_getenvid>
  800292:	8b 55 0c             	mov    0xc(%ebp),%edx
  800295:	89 54 24 10          	mov    %edx,0x10(%esp)
  800299:	8b 55 08             	mov    0x8(%ebp),%edx
  80029c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a8:	c7 04 24 d4 2e 80 00 	movl   $0x802ed4,(%esp)
  8002af:	e8 81 00 00 00       	call   800335 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	89 04 24             	mov    %eax,(%esp)
  8002be:	e8 11 00 00 00       	call   8002d4 <vcprintf>
	cprintf("\n");
  8002c3:	c7 04 24 f7 2d 80 00 	movl   $0x802df7,(%esp)
  8002ca:	e8 66 00 00 00       	call   800335 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cf:	cc                   	int3   
  8002d0:	eb fd                	jmp    8002cf <_panic+0x53>
	...

008002d4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e4:	00 00 00 
	b.cnt = 0;
  8002e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800305:	89 44 24 04          	mov    %eax,0x4(%esp)
  800309:	c7 04 24 4f 03 80 00 	movl   $0x80034f,(%esp)
  800310:	e8 be 01 00 00       	call   8004d3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800315:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80031b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	e8 23 0a 00 00       	call   800d50 <sys_cputs>

	return b.cnt;
}
  80032d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80033b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80033e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	e8 87 ff ff ff       	call   8002d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	53                   	push   %ebx
  800353:	83 ec 14             	sub    $0x14,%esp
  800356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800359:	8b 03                	mov    (%ebx),%eax
  80035b:	8b 55 08             	mov    0x8(%ebp),%edx
  80035e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800362:	83 c0 01             	add    $0x1,%eax
  800365:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800367:	3d ff 00 00 00       	cmp    $0xff,%eax
  80036c:	75 19                	jne    800387 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80036e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800375:	00 
  800376:	8d 43 08             	lea    0x8(%ebx),%eax
  800379:	89 04 24             	mov    %eax,(%esp)
  80037c:	e8 cf 09 00 00       	call   800d50 <sys_cputs>
		b->idx = 0;
  800381:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800387:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80038b:	83 c4 14             	add    $0x14,%esp
  80038e:	5b                   	pop    %ebx
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
  800391:	00 00                	add    %al,(%eax)
	...

00800394 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	57                   	push   %edi
  800398:	56                   	push   %esi
  800399:	53                   	push   %ebx
  80039a:	83 ec 4c             	sub    $0x4c,%esp
  80039d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a0:	89 d6                	mov    %edx,%esi
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003b4:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003bf:	39 d1                	cmp    %edx,%ecx
  8003c1:	72 07                	jb     8003ca <printnum+0x36>
  8003c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003c6:	39 d0                	cmp    %edx,%eax
  8003c8:	77 69                	ja     800433 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003ce:	83 eb 01             	sub    $0x1,%ebx
  8003d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003dd:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003e1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003e4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003e7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003ee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003f5:	00 
  8003f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f9:	89 04 24             	mov    %eax,(%esp)
  8003fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ff:	89 54 24 04          	mov    %edx,0x4(%esp)
  800403:	e8 68 27 00 00       	call   802b70 <__udivdi3>
  800408:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80040b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80040e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800412:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800416:	89 04 24             	mov    %eax,(%esp)
  800419:	89 54 24 04          	mov    %edx,0x4(%esp)
  80041d:	89 f2                	mov    %esi,%edx
  80041f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800422:	e8 6d ff ff ff       	call   800394 <printnum>
  800427:	eb 11                	jmp    80043a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800429:	89 74 24 04          	mov    %esi,0x4(%esp)
  80042d:	89 3c 24             	mov    %edi,(%esp)
  800430:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800433:	83 eb 01             	sub    $0x1,%ebx
  800436:	85 db                	test   %ebx,%ebx
  800438:	7f ef                	jg     800429 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800442:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800445:	89 44 24 08          	mov    %eax,0x8(%esp)
  800449:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800450:	00 
  800451:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800454:	89 14 24             	mov    %edx,(%esp)
  800457:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80045e:	e8 3d 28 00 00       	call   802ca0 <__umoddi3>
  800463:	89 74 24 04          	mov    %esi,0x4(%esp)
  800467:	0f be 80 f7 2e 80 00 	movsbl 0x802ef7(%eax),%eax
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800474:	83 c4 4c             	add    $0x4c,%esp
  800477:	5b                   	pop    %ebx
  800478:	5e                   	pop    %esi
  800479:	5f                   	pop    %edi
  80047a:	5d                   	pop    %ebp
  80047b:	c3                   	ret    

0080047c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80047c:	55                   	push   %ebp
  80047d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047f:	83 fa 01             	cmp    $0x1,%edx
  800482:	7e 0e                	jle    800492 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800484:	8b 10                	mov    (%eax),%edx
  800486:	8d 4a 08             	lea    0x8(%edx),%ecx
  800489:	89 08                	mov    %ecx,(%eax)
  80048b:	8b 02                	mov    (%edx),%eax
  80048d:	8b 52 04             	mov    0x4(%edx),%edx
  800490:	eb 22                	jmp    8004b4 <getuint+0x38>
	else if (lflag)
  800492:	85 d2                	test   %edx,%edx
  800494:	74 10                	je     8004a6 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800496:	8b 10                	mov    (%eax),%edx
  800498:	8d 4a 04             	lea    0x4(%edx),%ecx
  80049b:	89 08                	mov    %ecx,(%eax)
  80049d:	8b 02                	mov    (%edx),%eax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	eb 0e                	jmp    8004b4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004a6:	8b 10                	mov    (%eax),%edx
  8004a8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ab:	89 08                	mov    %ecx,(%eax)
  8004ad:	8b 02                	mov    (%edx),%eax
  8004af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004bc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c0:	8b 10                	mov    (%eax),%edx
  8004c2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c5:	73 0a                	jae    8004d1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ca:	88 0a                	mov    %cl,(%edx)
  8004cc:	83 c2 01             	add    $0x1,%edx
  8004cf:	89 10                	mov    %edx,(%eax)
}
  8004d1:	5d                   	pop    %ebp
  8004d2:	c3                   	ret    

008004d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	57                   	push   %edi
  8004d7:	56                   	push   %esi
  8004d8:	53                   	push   %ebx
  8004d9:	83 ec 4c             	sub    $0x4c,%esp
  8004dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004e5:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004ec:	eb 11                	jmp    8004ff <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	0f 84 b6 03 00 00    	je     8008ac <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8004f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004fa:	89 04 24             	mov    %eax,(%esp)
  8004fd:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ff:	0f b6 03             	movzbl (%ebx),%eax
  800502:	83 c3 01             	add    $0x1,%ebx
  800505:	83 f8 25             	cmp    $0x25,%eax
  800508:	75 e4                	jne    8004ee <vprintfmt+0x1b>
  80050a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80050e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800515:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80051c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800523:	b9 00 00 00 00       	mov    $0x0,%ecx
  800528:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80052b:	eb 06                	jmp    800533 <vprintfmt+0x60>
  80052d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800531:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800533:	0f b6 0b             	movzbl (%ebx),%ecx
  800536:	0f b6 c1             	movzbl %cl,%eax
  800539:	8d 53 01             	lea    0x1(%ebx),%edx
  80053c:	83 e9 23             	sub    $0x23,%ecx
  80053f:	80 f9 55             	cmp    $0x55,%cl
  800542:	0f 87 47 03 00 00    	ja     80088f <vprintfmt+0x3bc>
  800548:	0f b6 c9             	movzbl %cl,%ecx
  80054b:	ff 24 8d 40 30 80 00 	jmp    *0x803040(,%ecx,4)
  800552:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800556:	eb d9                	jmp    800531 <vprintfmt+0x5e>
  800558:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80055f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800564:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800567:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80056b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80056e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800571:	83 fb 09             	cmp    $0x9,%ebx
  800574:	77 30                	ja     8005a6 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800576:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800579:	eb e9                	jmp    800564 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8d 48 04             	lea    0x4(%eax),%ecx
  800581:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800589:	eb 1e                	jmp    8005a9 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80058b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059b:	eb 94                	jmp    800531 <vprintfmt+0x5e>
  80059d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005a4:	eb 8b                	jmp    800531 <vprintfmt+0x5e>
  8005a6:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8005a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ad:	79 82                	jns    800531 <vprintfmt+0x5e>
  8005af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005b8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005bb:	e9 71 ff ff ff       	jmp    800531 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005c4:	e9 68 ff ff ff       	jmp    800531 <vprintfmt+0x5e>
  8005c9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8d 50 04             	lea    0x4(%eax),%edx
  8005d2:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	ff d7                	call   *%edi
  8005e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8005e3:	e9 17 ff ff ff       	jmp    8004ff <vprintfmt+0x2c>
  8005e8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 50 04             	lea    0x4(%eax),%edx
  8005f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	89 c2                	mov    %eax,%edx
  8005f8:	c1 fa 1f             	sar    $0x1f,%edx
  8005fb:	31 d0                	xor    %edx,%eax
  8005fd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ff:	83 f8 11             	cmp    $0x11,%eax
  800602:	7f 0b                	jg     80060f <vprintfmt+0x13c>
  800604:	8b 14 85 a0 31 80 00 	mov    0x8031a0(,%eax,4),%edx
  80060b:	85 d2                	test   %edx,%edx
  80060d:	75 20                	jne    80062f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80060f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800613:	c7 44 24 08 08 2f 80 	movl   $0x802f08,0x8(%esp)
  80061a:	00 
  80061b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80061f:	89 3c 24             	mov    %edi,(%esp)
  800622:	e8 0d 03 00 00       	call   800934 <printfmt>
  800627:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062a:	e9 d0 fe ff ff       	jmp    8004ff <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80062f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800633:	c7 44 24 08 d6 33 80 	movl   $0x8033d6,0x8(%esp)
  80063a:	00 
  80063b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063f:	89 3c 24             	mov    %edi,(%esp)
  800642:	e8 ed 02 00 00       	call   800934 <printfmt>
  800647:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80064a:	e9 b0 fe ff ff       	jmp    8004ff <vprintfmt+0x2c>
  80064f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800652:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 50 04             	lea    0x4(%eax),%edx
  800661:	89 55 14             	mov    %edx,0x14(%ebp)
  800664:	8b 18                	mov    (%eax),%ebx
  800666:	85 db                	test   %ebx,%ebx
  800668:	b8 11 2f 80 00       	mov    $0x802f11,%eax
  80066d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800670:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800674:	7e 76                	jle    8006ec <vprintfmt+0x219>
  800676:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80067a:	74 7a                	je     8006f6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800680:	89 1c 24             	mov    %ebx,(%esp)
  800683:	e8 f0 02 00 00       	call   800978 <strnlen>
  800688:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80068b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80068d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800691:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800694:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800697:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800699:	eb 0f                	jmp    8006aa <vprintfmt+0x1d7>
					putch(padc, putdat);
  80069b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80069f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a2:	89 04 24             	mov    %eax,(%esp)
  8006a5:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	83 eb 01             	sub    $0x1,%ebx
  8006aa:	85 db                	test   %ebx,%ebx
  8006ac:	7f ed                	jg     80069b <vprintfmt+0x1c8>
  8006ae:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8006b1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006b4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006b7:	89 f7                	mov    %esi,%edi
  8006b9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006bc:	eb 40                	jmp    8006fe <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c2:	74 18                	je     8006dc <vprintfmt+0x209>
  8006c4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006c7:	83 fa 5e             	cmp    $0x5e,%edx
  8006ca:	76 10                	jbe    8006dc <vprintfmt+0x209>
					putch('?', putdat);
  8006cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006d7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006da:	eb 0a                	jmp    8006e6 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e0:	89 04 24             	mov    %eax,(%esp)
  8006e3:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006ea:	eb 12                	jmp    8006fe <vprintfmt+0x22b>
  8006ec:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006ef:	89 f7                	mov    %esi,%edi
  8006f1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006f4:	eb 08                	jmp    8006fe <vprintfmt+0x22b>
  8006f6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006f9:	89 f7                	mov    %esi,%edi
  8006fb:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006fe:	0f be 03             	movsbl (%ebx),%eax
  800701:	83 c3 01             	add    $0x1,%ebx
  800704:	85 c0                	test   %eax,%eax
  800706:	74 25                	je     80072d <vprintfmt+0x25a>
  800708:	85 f6                	test   %esi,%esi
  80070a:	78 b2                	js     8006be <vprintfmt+0x1eb>
  80070c:	83 ee 01             	sub    $0x1,%esi
  80070f:	79 ad                	jns    8006be <vprintfmt+0x1eb>
  800711:	89 fe                	mov    %edi,%esi
  800713:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800716:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800719:	eb 1a                	jmp    800735 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80071b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80071f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800726:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800728:	83 eb 01             	sub    $0x1,%ebx
  80072b:	eb 08                	jmp    800735 <vprintfmt+0x262>
  80072d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800730:	89 fe                	mov    %edi,%esi
  800732:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800735:	85 db                	test   %ebx,%ebx
  800737:	7f e2                	jg     80071b <vprintfmt+0x248>
  800739:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80073c:	e9 be fd ff ff       	jmp    8004ff <vprintfmt+0x2c>
  800741:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800744:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800747:	83 f9 01             	cmp    $0x1,%ecx
  80074a:	7e 16                	jle    800762 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8d 50 08             	lea    0x8(%eax),%edx
  800752:	89 55 14             	mov    %edx,0x14(%ebp)
  800755:	8b 10                	mov    (%eax),%edx
  800757:	8b 48 04             	mov    0x4(%eax),%ecx
  80075a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80075d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800760:	eb 32                	jmp    800794 <vprintfmt+0x2c1>
	else if (lflag)
  800762:	85 c9                	test   %ecx,%ecx
  800764:	74 18                	je     80077e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8d 50 04             	lea    0x4(%eax),%edx
  80076c:	89 55 14             	mov    %edx,0x14(%ebp)
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 c1                	mov    %eax,%ecx
  800776:	c1 f9 1f             	sar    $0x1f,%ecx
  800779:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80077c:	eb 16                	jmp    800794 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 50 04             	lea    0x4(%eax),%edx
  800784:	89 55 14             	mov    %edx,0x14(%ebp)
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	c1 fa 1f             	sar    $0x1f,%edx
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800794:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800797:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80079a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80079f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a3:	0f 89 a7 00 00 00    	jns    800850 <vprintfmt+0x37d>
				putch('-', putdat);
  8007a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ad:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007b4:	ff d7                	call   *%edi
				num = -(long long) num;
  8007b6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007b9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007bc:	f7 d9                	neg    %ecx
  8007be:	83 d3 00             	adc    $0x0,%ebx
  8007c1:	f7 db                	neg    %ebx
  8007c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c8:	e9 83 00 00 00       	jmp    800850 <vprintfmt+0x37d>
  8007cd:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d3:	89 ca                	mov    %ecx,%edx
  8007d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d8:	e8 9f fc ff ff       	call   80047c <getuint>
  8007dd:	89 c1                	mov    %eax,%ecx
  8007df:	89 d3                	mov    %edx,%ebx
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007e6:	eb 68                	jmp    800850 <vprintfmt+0x37d>
  8007e8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007ee:	89 ca                	mov    %ecx,%edx
  8007f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f3:	e8 84 fc ff ff       	call   80047c <getuint>
  8007f8:	89 c1                	mov    %eax,%ecx
  8007fa:	89 d3                	mov    %edx,%ebx
  8007fc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800801:	eb 4d                	jmp    800850 <vprintfmt+0x37d>
  800803:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800806:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800811:	ff d7                	call   *%edi
			putch('x', putdat);
  800813:	89 74 24 04          	mov    %esi,0x4(%esp)
  800817:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80081e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8d 50 04             	lea    0x4(%eax),%edx
  800826:	89 55 14             	mov    %edx,0x14(%ebp)
  800829:	8b 08                	mov    (%eax),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800835:	eb 19                	jmp    800850 <vprintfmt+0x37d>
  800837:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80083a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80083d:	89 ca                	mov    %ecx,%edx
  80083f:	8d 45 14             	lea    0x14(%ebp),%eax
  800842:	e8 35 fc ff ff       	call   80047c <getuint>
  800847:	89 c1                	mov    %eax,%ecx
  800849:	89 d3                	mov    %edx,%ebx
  80084b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800850:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800854:	89 54 24 10          	mov    %edx,0x10(%esp)
  800858:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80085b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80085f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800863:	89 0c 24             	mov    %ecx,(%esp)
  800866:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80086a:	89 f2                	mov    %esi,%edx
  80086c:	89 f8                	mov    %edi,%eax
  80086e:	e8 21 fb ff ff       	call   800394 <printnum>
  800873:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800876:	e9 84 fc ff ff       	jmp    8004ff <vprintfmt+0x2c>
  80087b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80087e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800882:	89 04 24             	mov    %eax,(%esp)
  800885:	ff d7                	call   *%edi
  800887:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80088a:	e9 70 fc ff ff       	jmp    8004ff <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800893:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80089a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80089f:	80 38 25             	cmpb   $0x25,(%eax)
  8008a2:	0f 84 57 fc ff ff    	je     8004ff <vprintfmt+0x2c>
  8008a8:	89 c3                	mov    %eax,%ebx
  8008aa:	eb f0                	jmp    80089c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8008ac:	83 c4 4c             	add    $0x4c,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5e                   	pop    %esi
  8008b1:	5f                   	pop    %edi
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 28             	sub    $0x28,%esp
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008c0:	85 c0                	test   %eax,%eax
  8008c2:	74 04                	je     8008c8 <vsnprintf+0x14>
  8008c4:	85 d2                	test   %edx,%edx
  8008c6:	7f 07                	jg     8008cf <vsnprintf+0x1b>
  8008c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cd:	eb 3b                	jmp    80090a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f5:	c7 04 24 b6 04 80 00 	movl   $0x8004b6,(%esp)
  8008fc:	e8 d2 fb ff ff       	call   8004d3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800904:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800907:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800912:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800915:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800919:	8b 45 10             	mov    0x10(%ebp),%eax
  80091c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800920:	8b 45 0c             	mov    0xc(%ebp),%eax
  800923:	89 44 24 04          	mov    %eax,0x4(%esp)
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	89 04 24             	mov    %eax,(%esp)
  80092d:	e8 82 ff ff ff       	call   8008b4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80093a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80093d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800941:	8b 45 10             	mov    0x10(%ebp),%eax
  800944:	89 44 24 08          	mov    %eax,0x8(%esp)
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	89 04 24             	mov    %eax,(%esp)
  800955:	e8 79 fb ff ff       	call   8004d3 <vprintfmt>
	va_end(ap);
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    
  80095c:	00 00                	add    %al,(%eax)
	...

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
  800dec:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  800df3:	00 
  800df4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfb:	00 
  800dfc:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  800e03:	e8 74 f4 ff ff       	call   80027c <_panic>

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
  800e4a:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  800e51:	00 
  800e52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e59:	00 
  800e5a:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  800e61:	e8 16 f4 ff ff       	call   80027c <_panic>

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
  800ea7:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  800eae:	00 
  800eaf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb6:	00 
  800eb7:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  800ebe:	e8 b9 f3 ff ff       	call   80027c <_panic>

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
  800f3d:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  800f44:	00 
  800f45:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4c:	00 
  800f4d:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  800f54:	e8 23 f3 ff ff       	call   80027c <_panic>

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
  800f9b:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  800fa2:	00 
  800fa3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800faa:	00 
  800fab:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  800fb2:	e8 c5 f2 ff ff       	call   80027c <_panic>

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
  800ff9:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  801000:	00 
  801001:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801008:	00 
  801009:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  801010:	e8 67 f2 ff ff       	call   80027c <_panic>

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
  801057:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  80105e:	00 
  80105f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801066:	00 
  801067:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  80106e:	e8 09 f2 ff ff       	call   80027c <_panic>

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
  8010b5:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  8010bc:	00 
  8010bd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c4:	00 
  8010c5:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  8010cc:	e8 ab f1 ff ff       	call   80027c <_panic>

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
  801114:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  80111b:	00 
  80111c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801123:	00 
  801124:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  80112b:	e8 4c f1 ff ff       	call   80027c <_panic>

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
  8011d9:	c7 44 24 08 07 32 80 	movl   $0x803207,0x8(%esp)
  8011e0:	00 
  8011e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e8:	00 
  8011e9:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  8011f0:	e8 87 f0 ff ff       	call   80027c <_panic>

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
  80120a:	c7 44 24 08 32 32 80 	movl   $0x803232,0x8(%esp)
  801211:	00 
  801212:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801219:	00 
  80121a:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  801221:	e8 56 f0 ff ff       	call   80027c <_panic>

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
  801236:	e8 89 18 00 00       	call   802ac4 <set_pgfault_handler>
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
  80124f:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  801256:	00 
  801257:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80125e:	00 
  80125f:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  801266:	e8 11 f0 ff ff       	call   80027c <_panic>
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
  80128f:	a3 08 50 80 00       	mov    %eax,0x805008
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
  801374:	c7 04 24 63 32 80 00 	movl   $0x803263,(%esp)
  80137b:	e8 b5 ef ff ff       	call   800335 <cprintf>
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
  80142c:	a1 08 50 80 00       	mov    0x805008,%eax
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
  801467:	c7 44 24 08 7a 32 80 	movl   $0x80327a,0x8(%esp)
  80146e:	00 
  80146f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801476:	00 
  801477:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  80147e:	e8 f9 ed ff ff       	call   80027c <_panic>

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
  8014c9:	c7 44 24 08 c8 32 80 	movl   $0x8032c8,0x8(%esp)
  8014d0:	00 
  8014d1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8014d8:	00 
  8014d9:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  8014e0:	e8 97 ed ff ff       	call   80027c <_panic>
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
  801505:	c7 44 24 08 91 32 80 	movl   $0x803291,0x8(%esp)
  80150c:	00 
  80150d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801514:	00 
  801515:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  80151c:	e8 5b ed ff ff       	call   80027c <_panic>
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
  801564:	c7 44 24 08 a3 32 80 	movl   $0x8032a3,0x8(%esp)
  80156b:	00 
  80156c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801573:	00 
  801574:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  80157b:	e8 fc ec ff ff       	call   80027c <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801580:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801587:	00 
  801588:	89 1c 24             	mov    %ebx,(%esp)
  80158b:	e8 92 fa ff ff       	call   801022 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801590:	85 c0                	test   %eax,%eax
  801592:	74 20                	je     8015b4 <pgfault+0x120>
  801594:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801598:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  80159f:	00 
  8015a0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8015a7:	00 
  8015a8:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  8015af:	e8 c8 ec ff ff       	call   80027c <_panic>

}
  8015b4:	83 c4 20             	add    $0x20,%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    
	...

008015bc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8015c7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8015ca:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8015d0:	8b 12                	mov    (%edx),%edx
  8015d2:	39 ca                	cmp    %ecx,%edx
  8015d4:	75 0c                	jne    8015e2 <ipc_find_env+0x26>
			return envs[i].env_id;
  8015d6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015d9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8015de:	8b 00                	mov    (%eax),%eax
  8015e0:	eb 0e                	jmp    8015f0 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8015e2:	83 c0 01             	add    $0x1,%eax
  8015e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015ea:	75 db                	jne    8015c7 <ipc_find_env+0xb>
  8015ec:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	57                   	push   %edi
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 2c             	sub    $0x2c,%esp
  8015fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8015fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801601:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  801604:	85 db                	test   %ebx,%ebx
  801606:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80160b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80160e:	8b 45 14             	mov    0x14(%ebp),%eax
  801611:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801615:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801619:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80161d:	89 34 24             	mov    %esi,(%esp)
  801620:	e8 ab f8 ff ff       	call   800ed0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  801625:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801628:	74 e4                	je     80160e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 28                	je     801656 <ipc_send+0x64>
  80162e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801632:	c7 44 24 0c 06 33 80 	movl   $0x803306,0xc(%esp)
  801639:	00 
  80163a:	c7 44 24 08 e9 32 80 	movl   $0x8032e9,0x8(%esp)
  801641:	00 
  801642:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801649:	00 
  80164a:	c7 04 24 fc 32 80 00 	movl   $0x8032fc,(%esp)
  801651:	e8 26 ec ff ff       	call   80027c <_panic>
	//if(!ret) sys_yield();
}
  801656:	83 c4 2c             	add    $0x2c,%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5f                   	pop    %edi
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    

0080165e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 28             	sub    $0x28,%esp
  801664:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801667:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80166a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80166d:	8b 75 08             	mov    0x8(%ebp),%esi
  801670:	8b 45 0c             	mov    0xc(%ebp),%eax
  801673:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  801676:	85 c0                	test   %eax,%eax
  801678:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80167d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801680:	89 04 24             	mov    %eax,(%esp)
  801683:	e8 eb f7 ff ff       	call   800e73 <sys_ipc_recv>
  801688:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80168a:	e8 e2 fa ff ff       	call   801171 <sys_getenvid>
  80168f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801694:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801697:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80169c:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  8016a1:	85 f6                	test   %esi,%esi
  8016a3:	74 0e                	je     8016b3 <ipc_recv+0x55>
  8016a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016aa:	85 db                	test   %ebx,%ebx
  8016ac:	75 03                	jne    8016b1 <ipc_recv+0x53>
  8016ae:	8b 50 74             	mov    0x74(%eax),%edx
  8016b1:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  8016b3:	85 ff                	test   %edi,%edi
  8016b5:	74 13                	je     8016ca <ipc_recv+0x6c>
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	85 db                	test   %ebx,%ebx
  8016be:	75 08                	jne    8016c8 <ipc_recv+0x6a>
  8016c0:	a1 08 50 80 00       	mov    0x805008,%eax
  8016c5:	8b 40 78             	mov    0x78(%eax),%eax
  8016c8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8016ca:	85 db                	test   %ebx,%ebx
  8016cc:	75 08                	jne    8016d6 <ipc_recv+0x78>
  8016ce:	a1 08 50 80 00       	mov    0x805008,%eax
  8016d3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8016d6:	89 d8                	mov    %ebx,%eax
  8016d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016db:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016de:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016e1:	89 ec                	mov    %ebp,%esp
  8016e3:	5d                   	pop    %ebp
  8016e4:	c3                   	ret    
  8016e5:	00 00                	add    %al,(%eax)
	...

008016e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	05 00 00 00 30       	add    $0x30000000,%eax
  8016f3:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	89 04 24             	mov    %eax,(%esp)
  801704:	e8 df ff ff ff       	call   8016e8 <fd2num>
  801709:	05 20 00 0d 00       	add    $0xd0020,%eax
  80170e:	c1 e0 0c             	shl    $0xc,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	57                   	push   %edi
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
  801719:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801721:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801726:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80172b:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80172d:	89 c2                	mov    %eax,%edx
  80172f:	c1 ea 16             	shr    $0x16,%edx
  801732:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801735:	f6 c2 01             	test   $0x1,%dl
  801738:	74 0d                	je     801747 <fd_alloc+0x34>
  80173a:	89 c2                	mov    %eax,%edx
  80173c:	c1 ea 0c             	shr    $0xc,%edx
  80173f:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801742:	f6 c2 01             	test   $0x1,%dl
  801745:	75 09                	jne    801750 <fd_alloc+0x3d>
			*fd_store = fd;
  801747:	89 37                	mov    %esi,(%edi)
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80174e:	eb 17                	jmp    801767 <fd_alloc+0x54>
  801750:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801755:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80175a:	75 cf                	jne    80172b <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80175c:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801762:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5f                   	pop    %edi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	83 f8 1f             	cmp    $0x1f,%eax
  801775:	77 36                	ja     8017ad <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801777:	05 00 00 0d 00       	add    $0xd0000,%eax
  80177c:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80177f:	89 c2                	mov    %eax,%edx
  801781:	c1 ea 16             	shr    $0x16,%edx
  801784:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80178b:	f6 c2 01             	test   $0x1,%dl
  80178e:	74 1d                	je     8017ad <fd_lookup+0x41>
  801790:	89 c2                	mov    %eax,%edx
  801792:	c1 ea 0c             	shr    $0xc,%edx
  801795:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80179c:	f6 c2 01             	test   $0x1,%dl
  80179f:	74 0c                	je     8017ad <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a4:	89 02                	mov    %eax,(%edx)
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8017ab:	eb 05                	jmp    8017b2 <fd_lookup+0x46>
  8017ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	89 04 24             	mov    %eax,(%esp)
  8017c7:	e8 a0 ff ff ff       	call   80176c <fd_lookup>
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	78 0e                	js     8017de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d6:	89 50 04             	mov    %edx,0x4(%eax)
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	56                   	push   %esi
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 10             	sub    $0x10,%esp
  8017e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8017f3:	be 90 33 80 00       	mov    $0x803390,%esi
  8017f8:	eb 10                	jmp    80180a <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8017fa:	39 08                	cmp    %ecx,(%eax)
  8017fc:	75 09                	jne    801807 <dev_lookup+0x27>
			*dev = devtab[i];
  8017fe:	89 03                	mov    %eax,(%ebx)
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801805:	eb 31                	jmp    801838 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801807:	83 c2 01             	add    $0x1,%edx
  80180a:	8b 04 96             	mov    (%esi,%edx,4),%eax
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e9                	jne    8017fa <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801811:	a1 08 50 80 00       	mov    0x805008,%eax
  801816:	8b 40 48             	mov    0x48(%eax),%eax
  801819:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	c7 04 24 10 33 80 00 	movl   $0x803310,(%esp)
  801828:	e8 08 eb ff ff       	call   800335 <cprintf>
	*dev = 0;
  80182d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5d                   	pop    %ebp
  80183e:	c3                   	ret    

0080183f <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	53                   	push   %ebx
  801843:	83 ec 24             	sub    $0x24,%esp
  801846:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801849:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 11 ff ff ff       	call   80176c <fd_lookup>
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 53                	js     8018b2 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801862:	89 44 24 04          	mov    %eax,0x4(%esp)
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	8b 00                	mov    (%eax),%eax
  80186b:	89 04 24             	mov    %eax,(%esp)
  80186e:	e8 6d ff ff ff       	call   8017e0 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801873:	85 c0                	test   %eax,%eax
  801875:	78 3b                	js     8018b2 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801877:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80187c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187f:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801883:	74 2d                	je     8018b2 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801885:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801888:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80188f:	00 00 00 
	stat->st_isdir = 0;
  801892:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801899:	00 00 00 
	stat->st_dev = dev;
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ac:	89 14 24             	mov    %edx,(%esp)
  8018af:	ff 50 14             	call   *0x14(%eax)
}
  8018b2:	83 c4 24             	add    $0x24,%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    

008018b8 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 24             	sub    $0x24,%esp
  8018bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c9:	89 1c 24             	mov    %ebx,(%esp)
  8018cc:	e8 9b fe ff ff       	call   80176c <fd_lookup>
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 5f                	js     801934 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018df:	8b 00                	mov    (%eax),%eax
  8018e1:	89 04 24             	mov    %eax,(%esp)
  8018e4:	e8 f7 fe ff ff       	call   8017e0 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 47                	js     801934 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f0:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018f4:	75 23                	jne    801919 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018f6:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018fb:	8b 40 48             	mov    0x48(%eax),%eax
  8018fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801902:	89 44 24 04          	mov    %eax,0x4(%esp)
  801906:	c7 04 24 30 33 80 00 	movl   $0x803330,(%esp)
  80190d:	e8 23 ea ff ff       	call   800335 <cprintf>
  801912:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801917:	eb 1b                	jmp    801934 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191c:	8b 48 18             	mov    0x18(%eax),%ecx
  80191f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801924:	85 c9                	test   %ecx,%ecx
  801926:	74 0c                	je     801934 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192f:	89 14 24             	mov    %edx,(%esp)
  801932:	ff d1                	call   *%ecx
}
  801934:	83 c4 24             	add    $0x24,%esp
  801937:	5b                   	pop    %ebx
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	53                   	push   %ebx
  80193e:	83 ec 24             	sub    $0x24,%esp
  801941:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801944:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801947:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194b:	89 1c 24             	mov    %ebx,(%esp)
  80194e:	e8 19 fe ff ff       	call   80176c <fd_lookup>
  801953:	85 c0                	test   %eax,%eax
  801955:	78 66                	js     8019bd <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801957:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801961:	8b 00                	mov    (%eax),%eax
  801963:	89 04 24             	mov    %eax,(%esp)
  801966:	e8 75 fe ff ff       	call   8017e0 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 4e                	js     8019bd <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80196f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801972:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801976:	75 23                	jne    80199b <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801978:	a1 08 50 80 00       	mov    0x805008,%eax
  80197d:	8b 40 48             	mov    0x48(%eax),%eax
  801980:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801984:	89 44 24 04          	mov    %eax,0x4(%esp)
  801988:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  80198f:	e8 a1 e9 ff ff       	call   800335 <cprintf>
  801994:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801999:	eb 22                	jmp    8019bd <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	8b 48 0c             	mov    0xc(%eax),%ecx
  8019a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a6:	85 c9                	test   %ecx,%ecx
  8019a8:	74 13                	je     8019bd <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b8:	89 14 24             	mov    %edx,(%esp)
  8019bb:	ff d1                	call   *%ecx
}
  8019bd:	83 c4 24             	add    $0x24,%esp
  8019c0:	5b                   	pop    %ebx
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 24             	sub    $0x24,%esp
  8019ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d4:	89 1c 24             	mov    %ebx,(%esp)
  8019d7:	e8 90 fd ff ff       	call   80176c <fd_lookup>
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 6b                	js     801a4b <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ea:	8b 00                	mov    (%eax),%eax
  8019ec:	89 04 24             	mov    %eax,(%esp)
  8019ef:	e8 ec fd ff ff       	call   8017e0 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 53                	js     801a4b <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019fb:	8b 42 08             	mov    0x8(%edx),%eax
  8019fe:	83 e0 03             	and    $0x3,%eax
  801a01:	83 f8 01             	cmp    $0x1,%eax
  801a04:	75 23                	jne    801a29 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a06:	a1 08 50 80 00       	mov    0x805008,%eax
  801a0b:	8b 40 48             	mov    0x48(%eax),%eax
  801a0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a16:	c7 04 24 71 33 80 00 	movl   $0x803371,(%esp)
  801a1d:	e8 13 e9 ff ff       	call   800335 <cprintf>
  801a22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a27:	eb 22                	jmp    801a4b <read+0x88>
	}
	if (!dev->dev_read)
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	8b 48 08             	mov    0x8(%eax),%ecx
  801a2f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a34:	85 c9                	test   %ecx,%ecx
  801a36:	74 13                	je     801a4b <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a38:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a46:	89 14 24             	mov    %edx,(%esp)
  801a49:	ff d1                	call   *%ecx
}
  801a4b:	83 c4 24             	add    $0x24,%esp
  801a4e:	5b                   	pop    %ebx
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	57                   	push   %edi
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
  801a57:	83 ec 1c             	sub    $0x1c,%esp
  801a5a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a5d:	8b 75 10             	mov    0x10(%ebp),%esi
  801a60:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a65:	eb 21                	jmp    801a88 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a67:	89 f2                	mov    %esi,%edx
  801a69:	29 c2                	sub    %eax,%edx
  801a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a6f:	03 45 0c             	add    0xc(%ebp),%eax
  801a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a76:	89 3c 24             	mov    %edi,(%esp)
  801a79:	e8 45 ff ff ff       	call   8019c3 <read>
		if (m < 0)
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 0e                	js     801a90 <readn+0x3f>
			return m;
		if (m == 0)
  801a82:	85 c0                	test   %eax,%eax
  801a84:	74 08                	je     801a8e <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a86:	01 c3                	add    %eax,%ebx
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	39 f3                	cmp    %esi,%ebx
  801a8c:	72 d9                	jb     801a67 <readn+0x16>
  801a8e:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    

00801a98 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 38             	sub    $0x38,%esp
  801a9e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aa1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801aa4:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801aa7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aaa:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801aae:	89 3c 24             	mov    %edi,(%esp)
  801ab1:	e8 32 fc ff ff       	call   8016e8 <fd2num>
  801ab6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801ab9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801abd:	89 04 24             	mov    %eax,(%esp)
  801ac0:	e8 a7 fc ff ff       	call   80176c <fd_lookup>
  801ac5:	89 c3                	mov    %eax,%ebx
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 05                	js     801ad0 <fd_close+0x38>
  801acb:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801ace:	74 0e                	je     801ade <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	84 c0                	test   %al,%al
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	0f 44 d8             	cmove  %eax,%ebx
  801adc:	eb 3d                	jmp    801b1b <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ade:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	8b 07                	mov    (%edi),%eax
  801ae7:	89 04 24             	mov    %eax,(%esp)
  801aea:	e8 f1 fc ff ff       	call   8017e0 <dev_lookup>
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 16                	js     801b0b <fd_close+0x73>
		if (dev->dev_close)
  801af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af8:	8b 40 10             	mov    0x10(%eax),%eax
  801afb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b00:	85 c0                	test   %eax,%eax
  801b02:	74 07                	je     801b0b <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801b04:	89 3c 24             	mov    %edi,(%esp)
  801b07:	ff d0                	call   *%eax
  801b09:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b0b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b16:	e8 07 f5 ff ff       	call   801022 <sys_page_unmap>
	return r;
}
  801b1b:	89 d8                	mov    %ebx,%eax
  801b1d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b20:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b23:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b26:	89 ec                	mov    %ebp,%esp
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    

00801b2a <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	89 04 24             	mov    %eax,(%esp)
  801b3d:	e8 2a fc ff ff       	call   80176c <fd_lookup>
  801b42:	85 c0                	test   %eax,%eax
  801b44:	78 13                	js     801b59 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b4d:	00 
  801b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b51:	89 04 24             	mov    %eax,(%esp)
  801b54:	e8 3f ff ff ff       	call   801a98 <fd_close>
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 18             	sub    $0x18,%esp
  801b61:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b64:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b6e:	00 
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	89 04 24             	mov    %eax,(%esp)
  801b75:	e8 25 04 00 00       	call   801f9f <open>
  801b7a:	89 c3                	mov    %eax,%ebx
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 1b                	js     801b9b <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	89 1c 24             	mov    %ebx,(%esp)
  801b8a:	e8 b0 fc ff ff       	call   80183f <fstat>
  801b8f:	89 c6                	mov    %eax,%esi
	close(fd);
  801b91:	89 1c 24             	mov    %ebx,(%esp)
  801b94:	e8 91 ff ff ff       	call   801b2a <close>
  801b99:	89 f3                	mov    %esi,%ebx
	return r;
}
  801b9b:	89 d8                	mov    %ebx,%eax
  801b9d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ba0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ba3:	89 ec                	mov    %ebp,%esp
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    

00801ba7 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	53                   	push   %ebx
  801bab:	83 ec 14             	sub    $0x14,%esp
  801bae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801bb3:	89 1c 24             	mov    %ebx,(%esp)
  801bb6:	e8 6f ff ff ff       	call   801b2a <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801bbb:	83 c3 01             	add    $0x1,%ebx
  801bbe:	83 fb 20             	cmp    $0x20,%ebx
  801bc1:	75 f0                	jne    801bb3 <close_all+0xc>
		close(i);
}
  801bc3:	83 c4 14             	add    $0x14,%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 58             	sub    $0x58,%esp
  801bcf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bd2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bd5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bd8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bdb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	89 04 24             	mov    %eax,(%esp)
  801be8:	e8 7f fb ff ff       	call   80176c <fd_lookup>
  801bed:	89 c3                	mov    %eax,%ebx
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	0f 88 e0 00 00 00    	js     801cd7 <dup+0x10e>
		return r;
	close(newfdnum);
  801bf7:	89 3c 24             	mov    %edi,(%esp)
  801bfa:	e8 2b ff ff ff       	call   801b2a <close>

	newfd = INDEX2FD(newfdnum);
  801bff:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801c05:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0b:	89 04 24             	mov    %eax,(%esp)
  801c0e:	e8 e5 fa ff ff       	call   8016f8 <fd2data>
  801c13:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c15:	89 34 24             	mov    %esi,(%esp)
  801c18:	e8 db fa ff ff       	call   8016f8 <fd2data>
  801c1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801c20:	89 da                	mov    %ebx,%edx
  801c22:	89 d8                	mov    %ebx,%eax
  801c24:	c1 e8 16             	shr    $0x16,%eax
  801c27:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c2e:	a8 01                	test   $0x1,%al
  801c30:	74 43                	je     801c75 <dup+0xac>
  801c32:	c1 ea 0c             	shr    $0xc,%edx
  801c35:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c3c:	a8 01                	test   $0x1,%al
  801c3e:	74 35                	je     801c75 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c40:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c47:	25 07 0e 00 00       	and    $0xe07,%eax
  801c4c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c5e:	00 
  801c5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6a:	e8 11 f4 ff ff       	call   801080 <sys_page_map>
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 3f                	js     801cb4 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c78:	89 c2                	mov    %eax,%edx
  801c7a:	c1 ea 0c             	shr    $0xc,%edx
  801c7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c84:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c8a:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c8e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c92:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c99:	00 
  801c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca5:	e8 d6 f3 ff ff       	call   801080 <sys_page_map>
  801caa:	89 c3                	mov    %eax,%ebx
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 04                	js     801cb4 <dup+0xeb>
  801cb0:	89 fb                	mov    %edi,%ebx
  801cb2:	eb 23                	jmp    801cd7 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801cb4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cb8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cbf:	e8 5e f3 ff ff       	call   801022 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cd2:	e8 4b f3 ff ff       	call   801022 <sys_page_unmap>
	return r;
}
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cdc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cdf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ce2:	89 ec                	mov    %ebp,%esp
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    
	...

00801ce8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 10             	sub    $0x10,%esp
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801cf4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cfb:	75 11                	jne    801d0e <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d04:	e8 b3 f8 ff ff       	call   8015bc <ipc_find_env>
  801d09:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801d0e:	a1 08 50 80 00       	mov    0x805008,%eax
  801d13:	8b 40 48             	mov    0x48(%eax),%eax
  801d16:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801d1c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d20:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  801d2f:	e8 01 e6 ff ff       	call   800335 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d34:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d3b:	00 
  801d3c:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d43:	00 
  801d44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d48:	a1 00 50 80 00       	mov    0x805000,%eax
  801d4d:	89 04 24             	mov    %eax,(%esp)
  801d50:	e8 9d f8 ff ff       	call   8015f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d5c:	00 
  801d5d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d68:	e8 f1 f8 ff ff       	call   80165e <ipc_recv>
}
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d80:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d92:	b8 02 00 00 00       	mov    $0x2,%eax
  801d97:	e8 4c ff ff ff       	call   801ce8 <fsipc>
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	8b 40 0c             	mov    0xc(%eax),%eax
  801daa:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801daf:	ba 00 00 00 00       	mov    $0x0,%edx
  801db4:	b8 06 00 00 00       	mov    $0x6,%eax
  801db9:	e8 2a ff ff ff       	call   801ce8 <fsipc>
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801dcb:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd0:	e8 13 ff ff ff       	call   801ce8 <fsipc>
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	53                   	push   %ebx
  801ddb:	83 ec 14             	sub    $0x14,%esp
  801dde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	8b 40 0c             	mov    0xc(%eax),%eax
  801de7:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dec:	ba 00 00 00 00       	mov    $0x0,%edx
  801df1:	b8 05 00 00 00       	mov    $0x5,%eax
  801df6:	e8 ed fe ff ff       	call   801ce8 <fsipc>
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	78 2b                	js     801e2a <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e06:	00 
  801e07:	89 1c 24             	mov    %ebx,(%esp)
  801e0a:	e8 8a eb ff ff       	call   800999 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e0f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e1a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801e25:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801e2a:	83 c4 14             	add    $0x14,%esp
  801e2d:	5b                   	pop    %ebx
  801e2e:	5d                   	pop    %ebp
  801e2f:	c3                   	ret    

00801e30 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	53                   	push   %ebx
  801e34:	83 ec 14             	sub    $0x14,%esp
  801e37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e40:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e45:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801e4b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801e51:	76 24                	jbe    801e77 <devfile_write+0x47>
  801e53:	c7 44 24 0c ba 33 80 	movl   $0x8033ba,0xc(%esp)
  801e5a:	00 
  801e5b:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  801e62:	00 
  801e63:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801e6a:	00 
  801e6b:	c7 04 24 d9 33 80 00 	movl   $0x8033d9,(%esp)
  801e72:	e8 05 e4 ff ff       	call   80027c <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801e77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e82:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e89:	e8 b1 ec ff ff       	call   800b3f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e93:	b8 04 00 00 00       	mov    $0x4,%eax
  801e98:	e8 4b fe ff ff       	call   801ce8 <fsipc>
	if(ret<0) return ret;
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	78 53                	js     801ef4 <devfile_write+0xc4>
	
	assert(ret <= n);
  801ea1:	39 c3                	cmp    %eax,%ebx
  801ea3:	73 24                	jae    801ec9 <devfile_write+0x99>
  801ea5:	c7 44 24 0c e4 33 80 	movl   $0x8033e4,0xc(%esp)
  801eac:	00 
  801ead:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  801eb4:	00 
  801eb5:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801ebc:	00 
  801ebd:	c7 04 24 d9 33 80 00 	movl   $0x8033d9,(%esp)
  801ec4:	e8 b3 e3 ff ff       	call   80027c <_panic>
	assert(ret <= PGSIZE);
  801ec9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ece:	7e 24                	jle    801ef4 <devfile_write+0xc4>
  801ed0:	c7 44 24 0c ed 33 80 	movl   $0x8033ed,0xc(%esp)
  801ed7:	00 
  801ed8:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  801edf:	00 
  801ee0:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801ee7:	00 
  801ee8:	c7 04 24 d9 33 80 00 	movl   $0x8033d9,(%esp)
  801eef:	e8 88 e3 ff ff       	call   80027c <_panic>
	return ret;
}
  801ef4:	83 c4 14             	add    $0x14,%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	56                   	push   %esi
  801efe:	53                   	push   %ebx
  801eff:	83 ec 10             	sub    $0x10,%esp
  801f02:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f10:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f16:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1b:	b8 03 00 00 00       	mov    $0x3,%eax
  801f20:	e8 c3 fd ff ff       	call   801ce8 <fsipc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	85 c0                	test   %eax,%eax
  801f29:	78 6b                	js     801f96 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801f2b:	39 de                	cmp    %ebx,%esi
  801f2d:	73 24                	jae    801f53 <devfile_read+0x59>
  801f2f:	c7 44 24 0c fb 33 80 	movl   $0x8033fb,0xc(%esp)
  801f36:	00 
  801f37:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  801f3e:	00 
  801f3f:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f46:	00 
  801f47:	c7 04 24 d9 33 80 00 	movl   $0x8033d9,(%esp)
  801f4e:	e8 29 e3 ff ff       	call   80027c <_panic>
	assert(r <= PGSIZE);
  801f53:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801f59:	7e 24                	jle    801f7f <devfile_read+0x85>
  801f5b:	c7 44 24 0c 02 34 80 	movl   $0x803402,0xc(%esp)
  801f62:	00 
  801f63:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  801f6a:	00 
  801f6b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f72:	00 
  801f73:	c7 04 24 d9 33 80 00 	movl   $0x8033d9,(%esp)
  801f7a:	e8 fd e2 ff ff       	call   80027c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f83:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f8a:	00 
  801f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8e:	89 04 24             	mov    %eax,(%esp)
  801f91:	e8 a9 eb ff ff       	call   800b3f <memmove>
	return r;
}
  801f96:	89 d8                	mov    %ebx,%eax
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	5b                   	pop    %ebx
  801f9c:	5e                   	pop    %esi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 28             	sub    $0x28,%esp
  801fa5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fa8:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801fab:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fae:	89 34 24             	mov    %esi,(%esp)
  801fb1:	e8 aa e9 ff ff       	call   800960 <strlen>
  801fb6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fbb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fc0:	7f 5e                	jg     802020 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc5:	89 04 24             	mov    %eax,(%esp)
  801fc8:	e8 46 f7 ff ff       	call   801713 <fd_alloc>
  801fcd:	89 c3                	mov    %eax,%ebx
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	78 4d                	js     802020 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801fd3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fd7:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801fde:	e8 b6 e9 ff ff       	call   800999 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe6:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	e8 f0 fc ff ff       	call   801ce8 <fsipc>
  801ff8:	89 c3                	mov    %eax,%ebx
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	79 15                	jns    802013 <open+0x74>
		fd_close(fd, 0);
  801ffe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802005:	00 
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	89 04 24             	mov    %eax,(%esp)
  80200c:	e8 87 fa ff ff       	call   801a98 <fd_close>
		return r;
  802011:	eb 0d                	jmp    802020 <open+0x81>
	}

	return fd2num(fd);
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	89 04 24             	mov    %eax,(%esp)
  802019:	e8 ca f6 ff ff       	call   8016e8 <fd2num>
  80201e:	89 c3                	mov    %eax,%ebx
}
  802020:	89 d8                	mov    %ebx,%eax
  802022:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802025:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802028:	89 ec                	mov    %ebp,%esp
  80202a:	5d                   	pop    %ebp
  80202b:	c3                   	ret    

0080202c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	89 c2                	mov    %eax,%edx
  802034:	c1 ea 16             	shr    $0x16,%edx
  802037:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80203e:	f6 c2 01             	test   $0x1,%dl
  802041:	74 20                	je     802063 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802043:	c1 e8 0c             	shr    $0xc,%eax
  802046:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80204d:	a8 01                	test   $0x1,%al
  80204f:	74 12                	je     802063 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802051:	c1 e8 0c             	shr    $0xc,%eax
  802054:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802059:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  80205e:	0f b7 c0             	movzwl %ax,%eax
  802061:	eb 05                	jmp    802068 <pageref+0x3c>
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802068:	5d                   	pop    %ebp
  802069:	c3                   	ret    
  80206a:	00 00                	add    %al,(%eax)
  80206c:	00 00                	add    %al,(%eax)
	...

00802070 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802076:	c7 44 24 04 0e 34 80 	movl   $0x80340e,0x4(%esp)
  80207d:	00 
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 10 e9 ff ff       	call   800999 <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	53                   	push   %ebx
  802094:	83 ec 14             	sub    $0x14,%esp
  802097:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80209a:	89 1c 24             	mov    %ebx,(%esp)
  80209d:	e8 8a ff ff ff       	call   80202c <pageref>
  8020a2:	89 c2                	mov    %eax,%edx
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	83 fa 01             	cmp    $0x1,%edx
  8020ac:	75 0b                	jne    8020b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020ae:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020b1:	89 04 24             	mov    %eax,(%esp)
  8020b4:	e8 b1 02 00 00       	call   80236a <nsipc_close>
	else
		return 0;
}
  8020b9:	83 c4 14             	add    $0x14,%esp
  8020bc:	5b                   	pop    %ebx
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020cc:	00 
  8020cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e1:	89 04 24             	mov    %eax,(%esp)
  8020e4:	e8 bd 02 00 00       	call   8023a6 <nsipc_send>
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020f8:	00 
  8020f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802100:	8b 45 0c             	mov    0xc(%ebp),%eax
  802103:	89 44 24 04          	mov    %eax,0x4(%esp)
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	8b 40 0c             	mov    0xc(%eax),%eax
  80210d:	89 04 24             	mov    %eax,(%esp)
  802110:	e8 04 03 00 00       	call   802419 <nsipc_recv>
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
  80211c:	83 ec 20             	sub    $0x20,%esp
  80211f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802121:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802124:	89 04 24             	mov    %eax,(%esp)
  802127:	e8 e7 f5 ff ff       	call   801713 <fd_alloc>
  80212c:	89 c3                	mov    %eax,%ebx
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 21                	js     802153 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802132:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802139:	00 
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802148:	e8 91 ef ff ff       	call   8010de <sys_page_alloc>
  80214d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80214f:	85 c0                	test   %eax,%eax
  802151:	79 0a                	jns    80215d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802153:	89 34 24             	mov    %esi,(%esp)
  802156:	e8 0f 02 00 00       	call   80236a <nsipc_close>
		return r;
  80215b:	eb 28                	jmp    802185 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80215d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	89 04 24             	mov    %eax,(%esp)
  80217e:	e8 65 f5 ff ff       	call   8016e8 <fd2num>
  802183:	89 c3                	mov    %eax,%ebx
}
  802185:	89 d8                	mov    %ebx,%eax
  802187:	83 c4 20             	add    $0x20,%esp
  80218a:	5b                   	pop    %ebx
  80218b:	5e                   	pop    %esi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    

0080218e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	89 44 24 08          	mov    %eax,0x8(%esp)
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	89 04 24             	mov    %eax,(%esp)
  8021a8:	e8 71 01 00 00       	call   80231e <nsipc_socket>
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	78 05                	js     8021b6 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8021b1:	e8 61 ff ff ff       	call   802117 <alloc_sockfd>
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021be:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c5:	89 04 24             	mov    %eax,(%esp)
  8021c8:	e8 9f f5 ff ff       	call   80176c <fd_lookup>
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 15                	js     8021e6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d4:	8b 0a                	mov    (%edx),%ecx
  8021d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021db:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  8021e1:	75 03                	jne    8021e6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021e3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	e8 c2 ff ff ff       	call   8021b8 <fd2sockid>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 0f                	js     802209 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8021fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802201:	89 04 24             	mov    %eax,(%esp)
  802204:	e8 3f 01 00 00       	call   802348 <nsipc_listen>
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	e8 9f ff ff ff       	call   8021b8 <fd2sockid>
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 16                	js     802233 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80221d:	8b 55 10             	mov    0x10(%ebp),%edx
  802220:	89 54 24 08          	mov    %edx,0x8(%esp)
  802224:	8b 55 0c             	mov    0xc(%ebp),%edx
  802227:	89 54 24 04          	mov    %edx,0x4(%esp)
  80222b:	89 04 24             	mov    %eax,(%esp)
  80222e:	e8 66 02 00 00       	call   802499 <nsipc_connect>
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	e8 75 ff ff ff       	call   8021b8 <fd2sockid>
  802243:	85 c0                	test   %eax,%eax
  802245:	78 0f                	js     802256 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80224e:	89 04 24             	mov    %eax,(%esp)
  802251:	e8 2e 01 00 00       	call   802384 <nsipc_shutdown>
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	e8 52 ff ff ff       	call   8021b8 <fd2sockid>
  802266:	85 c0                	test   %eax,%eax
  802268:	78 16                	js     802280 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80226a:	8b 55 10             	mov    0x10(%ebp),%edx
  80226d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802271:	8b 55 0c             	mov    0xc(%ebp),%edx
  802274:	89 54 24 04          	mov    %edx,0x4(%esp)
  802278:	89 04 24             	mov    %eax,(%esp)
  80227b:	e8 58 02 00 00       	call   8024d8 <nsipc_bind>
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	e8 28 ff ff ff       	call   8021b8 <fd2sockid>
  802290:	85 c0                	test   %eax,%eax
  802292:	78 1f                	js     8022b3 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802294:	8b 55 10             	mov    0x10(%ebp),%edx
  802297:	89 54 24 08          	mov    %edx,0x8(%esp)
  80229b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022a2:	89 04 24             	mov    %eax,(%esp)
  8022a5:	e8 6d 02 00 00       	call   802517 <nsipc_accept>
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	78 05                	js     8022b3 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8022ae:	e8 64 fe ff ff       	call   802117 <alloc_sockfd>
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    
  8022b5:	00 00                	add    %al,(%eax)
	...

008022b8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	53                   	push   %ebx
  8022bc:	83 ec 14             	sub    $0x14,%esp
  8022bf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022c1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022c8:	75 11                	jne    8022db <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022ca:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022d1:	e8 e6 f2 ff ff       	call   8015bc <ipc_find_env>
  8022d6:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022db:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022e2:	00 
  8022e3:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8022ea:	00 
  8022eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022ef:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f4:	89 04 24             	mov    %eax,(%esp)
  8022f7:	e8 f6 f2 ff ff       	call   8015f2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802303:	00 
  802304:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80230b:	00 
  80230c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802313:	e8 46 f3 ff ff       	call   80165e <ipc_recv>
}
  802318:	83 c4 14             	add    $0x14,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802334:	8b 45 10             	mov    0x10(%ebp),%eax
  802337:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80233c:	b8 09 00 00 00       	mov    $0x9,%eax
  802341:	e8 72 ff ff ff       	call   8022b8 <nsipc>
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802356:	8b 45 0c             	mov    0xc(%ebp),%eax
  802359:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80235e:	b8 06 00 00 00       	mov    $0x6,%eax
  802363:	e8 50 ff ff ff       	call   8022b8 <nsipc>
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802378:	b8 04 00 00 00       	mov    $0x4,%eax
  80237d:	e8 36 ff ff ff       	call   8022b8 <nsipc>
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802392:	8b 45 0c             	mov    0xc(%ebp),%eax
  802395:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80239a:	b8 03 00 00 00       	mov    $0x3,%eax
  80239f:	e8 14 ff ff ff       	call   8022b8 <nsipc>
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	53                   	push   %ebx
  8023aa:	83 ec 14             	sub    $0x14,%esp
  8023ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8023b8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023be:	7e 24                	jle    8023e4 <nsipc_send+0x3e>
  8023c0:	c7 44 24 0c 1a 34 80 	movl   $0x80341a,0xc(%esp)
  8023c7:	00 
  8023c8:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  8023cf:	00 
  8023d0:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8023d7:	00 
  8023d8:	c7 04 24 26 34 80 00 	movl   $0x803426,(%esp)
  8023df:	e8 98 de ff ff       	call   80027c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ef:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8023f6:	e8 44 e7 ff ff       	call   800b3f <memmove>
	nsipcbuf.send.req_size = size;
  8023fb:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802401:	8b 45 14             	mov    0x14(%ebp),%eax
  802404:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802409:	b8 08 00 00 00       	mov    $0x8,%eax
  80240e:	e8 a5 fe ff ff       	call   8022b8 <nsipc>
}
  802413:	83 c4 14             	add    $0x14,%esp
  802416:	5b                   	pop    %ebx
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    

00802419 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	56                   	push   %esi
  80241d:	53                   	push   %ebx
  80241e:	83 ec 10             	sub    $0x10,%esp
  802421:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80242c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802432:	8b 45 14             	mov    0x14(%ebp),%eax
  802435:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80243a:	b8 07 00 00 00       	mov    $0x7,%eax
  80243f:	e8 74 fe ff ff       	call   8022b8 <nsipc>
  802444:	89 c3                	mov    %eax,%ebx
  802446:	85 c0                	test   %eax,%eax
  802448:	78 46                	js     802490 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80244a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80244f:	7f 04                	jg     802455 <nsipc_recv+0x3c>
  802451:	39 c6                	cmp    %eax,%esi
  802453:	7d 24                	jge    802479 <nsipc_recv+0x60>
  802455:	c7 44 24 0c 32 34 80 	movl   $0x803432,0xc(%esp)
  80245c:	00 
  80245d:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  802464:	00 
  802465:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80246c:	00 
  80246d:	c7 04 24 26 34 80 00 	movl   $0x803426,(%esp)
  802474:	e8 03 de ff ff       	call   80027c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802479:	89 44 24 08          	mov    %eax,0x8(%esp)
  80247d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802484:	00 
  802485:	8b 45 0c             	mov    0xc(%ebp),%eax
  802488:	89 04 24             	mov    %eax,(%esp)
  80248b:	e8 af e6 ff ff       	call   800b3f <memmove>
	}

	return r;
}
  802490:	89 d8                	mov    %ebx,%eax
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	5b                   	pop    %ebx
  802496:	5e                   	pop    %esi
  802497:	5d                   	pop    %ebp
  802498:	c3                   	ret    

00802499 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	53                   	push   %ebx
  80249d:	83 ec 14             	sub    $0x14,%esp
  8024a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b6:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8024bd:	e8 7d e6 ff ff       	call   800b3f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024c2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8024c8:	b8 05 00 00 00       	mov    $0x5,%eax
  8024cd:	e8 e6 fd ff ff       	call   8022b8 <nsipc>
}
  8024d2:	83 c4 14             	add    $0x14,%esp
  8024d5:	5b                   	pop    %ebx
  8024d6:	5d                   	pop    %ebp
  8024d7:	c3                   	ret    

008024d8 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	53                   	push   %ebx
  8024dc:	83 ec 14             	sub    $0x14,%esp
  8024df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f5:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8024fc:	e8 3e e6 ff ff       	call   800b3f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802501:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802507:	b8 02 00 00 00       	mov    $0x2,%eax
  80250c:	e8 a7 fd ff ff       	call   8022b8 <nsipc>
}
  802511:	83 c4 14             	add    $0x14,%esp
  802514:	5b                   	pop    %ebx
  802515:	5d                   	pop    %ebp
  802516:	c3                   	ret    

00802517 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 28             	sub    $0x28,%esp
  80251d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802520:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802523:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802526:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802531:	8b 07                	mov    (%edi),%eax
  802533:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802538:	b8 01 00 00 00       	mov    $0x1,%eax
  80253d:	e8 76 fd ff ff       	call   8022b8 <nsipc>
  802542:	89 c6                	mov    %eax,%esi
  802544:	85 c0                	test   %eax,%eax
  802546:	78 22                	js     80256a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802548:	bb 10 80 80 00       	mov    $0x808010,%ebx
  80254d:	8b 03                	mov    (%ebx),%eax
  80254f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802553:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80255a:	00 
  80255b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255e:	89 04 24             	mov    %eax,(%esp)
  802561:	e8 d9 e5 ff ff       	call   800b3f <memmove>
		*addrlen = ret->ret_addrlen;
  802566:	8b 03                	mov    (%ebx),%eax
  802568:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80256a:	89 f0                	mov    %esi,%eax
  80256c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80256f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802572:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802575:	89 ec                	mov    %ebp,%esp
  802577:	5d                   	pop    %ebp
  802578:	c3                   	ret    
  802579:	00 00                	add    %al,(%eax)
	...

0080257c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 18             	sub    $0x18,%esp
  802582:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802585:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802588:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	89 04 24             	mov    %eax,(%esp)
  802591:	e8 62 f1 ff ff       	call   8016f8 <fd2data>
  802596:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802598:	c7 44 24 04 47 34 80 	movl   $0x803447,0x4(%esp)
  80259f:	00 
  8025a0:	89 34 24             	mov    %esi,(%esp)
  8025a3:	e8 f1 e3 ff ff       	call   800999 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025a8:	8b 43 04             	mov    0x4(%ebx),%eax
  8025ab:	2b 03                	sub    (%ebx),%eax
  8025ad:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8025b3:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8025ba:	00 00 00 
	stat->st_dev = &devpipe;
  8025bd:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  8025c4:	40 80 00 
	return 0;
}
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025cf:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025d2:	89 ec                	mov    %ebp,%esp
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    

008025d6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	53                   	push   %ebx
  8025da:	83 ec 14             	sub    $0x14,%esp
  8025dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025eb:	e8 32 ea ff ff       	call   801022 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025f0:	89 1c 24             	mov    %ebx,(%esp)
  8025f3:	e8 00 f1 ff ff       	call   8016f8 <fd2data>
  8025f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802603:	e8 1a ea ff ff       	call   801022 <sys_page_unmap>
}
  802608:	83 c4 14             	add    $0x14,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5d                   	pop    %ebp
  80260d:	c3                   	ret    

0080260e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	57                   	push   %edi
  802612:	56                   	push   %esi
  802613:	53                   	push   %ebx
  802614:	83 ec 2c             	sub    $0x2c,%esp
  802617:	89 c7                	mov    %eax,%edi
  802619:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80261c:	a1 08 50 80 00       	mov    0x805008,%eax
  802621:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802624:	89 3c 24             	mov    %edi,(%esp)
  802627:	e8 00 fa ff ff       	call   80202c <pageref>
  80262c:	89 c6                	mov    %eax,%esi
  80262e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802631:	89 04 24             	mov    %eax,(%esp)
  802634:	e8 f3 f9 ff ff       	call   80202c <pageref>
  802639:	39 c6                	cmp    %eax,%esi
  80263b:	0f 94 c0             	sete   %al
  80263e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802641:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802647:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80264a:	39 cb                	cmp    %ecx,%ebx
  80264c:	75 08                	jne    802656 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80264e:	83 c4 2c             	add    $0x2c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802656:	83 f8 01             	cmp    $0x1,%eax
  802659:	75 c1                	jne    80261c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80265b:	8b 52 58             	mov    0x58(%edx),%edx
  80265e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802662:	89 54 24 08          	mov    %edx,0x8(%esp)
  802666:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80266a:	c7 04 24 4e 34 80 00 	movl   $0x80344e,(%esp)
  802671:	e8 bf dc ff ff       	call   800335 <cprintf>
  802676:	eb a4                	jmp    80261c <_pipeisclosed+0xe>

00802678 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	57                   	push   %edi
  80267c:	56                   	push   %esi
  80267d:	53                   	push   %ebx
  80267e:	83 ec 1c             	sub    $0x1c,%esp
  802681:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802684:	89 34 24             	mov    %esi,(%esp)
  802687:	e8 6c f0 ff ff       	call   8016f8 <fd2data>
  80268c:	89 c3                	mov    %eax,%ebx
  80268e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802693:	eb 48                	jmp    8026dd <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802695:	89 da                	mov    %ebx,%edx
  802697:	89 f0                	mov    %esi,%eax
  802699:	e8 70 ff ff ff       	call   80260e <_pipeisclosed>
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 07                	je     8026a9 <devpipe_write+0x31>
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a7:	eb 3b                	jmp    8026e4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026a9:	e8 8f ea ff ff       	call   80113d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026ae:	8b 43 04             	mov    0x4(%ebx),%eax
  8026b1:	8b 13                	mov    (%ebx),%edx
  8026b3:	83 c2 20             	add    $0x20,%edx
  8026b6:	39 d0                	cmp    %edx,%eax
  8026b8:	73 db                	jae    802695 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026ba:	89 c2                	mov    %eax,%edx
  8026bc:	c1 fa 1f             	sar    $0x1f,%edx
  8026bf:	c1 ea 1b             	shr    $0x1b,%edx
  8026c2:	01 d0                	add    %edx,%eax
  8026c4:	83 e0 1f             	and    $0x1f,%eax
  8026c7:	29 d0                	sub    %edx,%eax
  8026c9:	89 c2                	mov    %eax,%edx
  8026cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ce:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8026d2:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026d6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026da:	83 c7 01             	add    $0x1,%edi
  8026dd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026e0:	72 cc                	jb     8026ae <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026e2:	89 f8                	mov    %edi,%eax
}
  8026e4:	83 c4 1c             	add    $0x1c,%esp
  8026e7:	5b                   	pop    %ebx
  8026e8:	5e                   	pop    %esi
  8026e9:	5f                   	pop    %edi
  8026ea:	5d                   	pop    %ebp
  8026eb:	c3                   	ret    

008026ec <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 28             	sub    $0x28,%esp
  8026f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026fb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026fe:	89 3c 24             	mov    %edi,(%esp)
  802701:	e8 f2 ef ff ff       	call   8016f8 <fd2data>
  802706:	89 c3                	mov    %eax,%ebx
  802708:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80270d:	eb 48                	jmp    802757 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80270f:	85 f6                	test   %esi,%esi
  802711:	74 04                	je     802717 <devpipe_read+0x2b>
				return i;
  802713:	89 f0                	mov    %esi,%eax
  802715:	eb 47                	jmp    80275e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802717:	89 da                	mov    %ebx,%edx
  802719:	89 f8                	mov    %edi,%eax
  80271b:	e8 ee fe ff ff       	call   80260e <_pipeisclosed>
  802720:	85 c0                	test   %eax,%eax
  802722:	74 07                	je     80272b <devpipe_read+0x3f>
  802724:	b8 00 00 00 00       	mov    $0x0,%eax
  802729:	eb 33                	jmp    80275e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80272b:	e8 0d ea ff ff       	call   80113d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802730:	8b 03                	mov    (%ebx),%eax
  802732:	3b 43 04             	cmp    0x4(%ebx),%eax
  802735:	74 d8                	je     80270f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802737:	89 c2                	mov    %eax,%edx
  802739:	c1 fa 1f             	sar    $0x1f,%edx
  80273c:	c1 ea 1b             	shr    $0x1b,%edx
  80273f:	01 d0                	add    %edx,%eax
  802741:	83 e0 1f             	and    $0x1f,%eax
  802744:	29 d0                	sub    %edx,%eax
  802746:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80274b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802751:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802754:	83 c6 01             	add    $0x1,%esi
  802757:	3b 75 10             	cmp    0x10(%ebp),%esi
  80275a:	72 d4                	jb     802730 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80275c:	89 f0                	mov    %esi,%eax
}
  80275e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802761:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802764:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802767:	89 ec                	mov    %ebp,%esp
  802769:	5d                   	pop    %ebp
  80276a:	c3                   	ret    

0080276b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802774:	89 44 24 04          	mov    %eax,0x4(%esp)
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	89 04 24             	mov    %eax,(%esp)
  80277e:	e8 e9 ef ff ff       	call   80176c <fd_lookup>
  802783:	85 c0                	test   %eax,%eax
  802785:	78 15                	js     80279c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	89 04 24             	mov    %eax,(%esp)
  80278d:	e8 66 ef ff ff       	call   8016f8 <fd2data>
	return _pipeisclosed(fd, p);
  802792:	89 c2                	mov    %eax,%edx
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	e8 72 fe ff ff       	call   80260e <_pipeisclosed>
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
  8027a1:	83 ec 48             	sub    $0x48,%esp
  8027a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8027b3:	89 04 24             	mov    %eax,(%esp)
  8027b6:	e8 58 ef ff ff       	call   801713 <fd_alloc>
  8027bb:	89 c3                	mov    %eax,%ebx
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	0f 88 42 01 00 00    	js     802907 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027c5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027cc:	00 
  8027cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027db:	e8 fe e8 ff ff       	call   8010de <sys_page_alloc>
  8027e0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	0f 88 1d 01 00 00    	js     802907 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027ed:	89 04 24             	mov    %eax,(%esp)
  8027f0:	e8 1e ef ff ff       	call   801713 <fd_alloc>
  8027f5:	89 c3                	mov    %eax,%ebx
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	0f 88 f5 00 00 00    	js     8028f4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ff:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802806:	00 
  802807:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80280e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802815:	e8 c4 e8 ff ff       	call   8010de <sys_page_alloc>
  80281a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80281c:	85 c0                	test   %eax,%eax
  80281e:	0f 88 d0 00 00 00    	js     8028f4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802827:	89 04 24             	mov    %eax,(%esp)
  80282a:	e8 c9 ee ff ff       	call   8016f8 <fd2data>
  80282f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802831:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802838:	00 
  802839:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802844:	e8 95 e8 ff ff       	call   8010de <sys_page_alloc>
  802849:	89 c3                	mov    %eax,%ebx
  80284b:	85 c0                	test   %eax,%eax
  80284d:	0f 88 8e 00 00 00    	js     8028e1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802856:	89 04 24             	mov    %eax,(%esp)
  802859:	e8 9a ee ff ff       	call   8016f8 <fd2data>
  80285e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802865:	00 
  802866:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80286a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802871:	00 
  802872:	89 74 24 04          	mov    %esi,0x4(%esp)
  802876:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80287d:	e8 fe e7 ff ff       	call   801080 <sys_page_map>
  802882:	89 c3                	mov    %eax,%ebx
  802884:	85 c0                	test   %eax,%eax
  802886:	78 49                	js     8028d1 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802888:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  80288d:	8b 08                	mov    (%eax),%ecx
  80288f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802892:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802894:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802897:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80289e:	8b 10                	mov    (%eax),%edx
  8028a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8028af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b2:	89 04 24             	mov    %eax,(%esp)
  8028b5:	e8 2e ee ff ff       	call   8016e8 <fd2num>
  8028ba:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8028bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bf:	89 04 24             	mov    %eax,(%esp)
  8028c2:	e8 21 ee ff ff       	call   8016e8 <fd2num>
  8028c7:	89 47 04             	mov    %eax,0x4(%edi)
  8028ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8028cf:	eb 36                	jmp    802907 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8028d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028dc:	e8 41 e7 ff ff       	call   801022 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ef:	e8 2e e7 ff ff       	call   801022 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802902:	e8 1b e7 ff ff       	call   801022 <sys_page_unmap>
    err:
	return r;
}
  802907:	89 d8                	mov    %ebx,%eax
  802909:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80290c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80290f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802912:	89 ec                	mov    %ebp,%esp
  802914:	5d                   	pop    %ebp
  802915:	c3                   	ret    
	...

00802920 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    

0080292a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802930:	c7 44 24 04 66 34 80 	movl   $0x803466,0x4(%esp)
  802937:	00 
  802938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80293b:	89 04 24             	mov    %eax,(%esp)
  80293e:	e8 56 e0 ff ff       	call   800999 <strcpy>
	return 0;
}
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	57                   	push   %edi
  80294e:	56                   	push   %esi
  80294f:	53                   	push   %ebx
  802950:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802956:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80295b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802961:	eb 34                	jmp    802997 <devcons_write+0x4d>
		m = n - tot;
  802963:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802966:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802968:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80296e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802973:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802976:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80297a:	03 45 0c             	add    0xc(%ebp),%eax
  80297d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802981:	89 3c 24             	mov    %edi,(%esp)
  802984:	e8 b6 e1 ff ff       	call   800b3f <memmove>
		sys_cputs(buf, m);
  802989:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80298d:	89 3c 24             	mov    %edi,(%esp)
  802990:	e8 bb e3 ff ff       	call   800d50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802995:	01 de                	add    %ebx,%esi
  802997:	89 f0                	mov    %esi,%eax
  802999:	3b 75 10             	cmp    0x10(%ebp),%esi
  80299c:	72 c5                	jb     802963 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80299e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029a4:	5b                   	pop    %ebx
  8029a5:	5e                   	pop    %esi
  8029a6:	5f                   	pop    %edi
  8029a7:	5d                   	pop    %ebp
  8029a8:	c3                   	ret    

008029a9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029bc:	00 
  8029bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029c0:	89 04 24             	mov    %eax,(%esp)
  8029c3:	e8 88 e3 ff ff       	call   800d50 <sys_cputs>
}
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8029d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029d4:	75 07                	jne    8029dd <devcons_read+0x13>
  8029d6:	eb 28                	jmp    802a00 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029d8:	e8 60 e7 ff ff       	call   80113d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	e8 37 e3 ff ff       	call   800d1c <sys_cgetc>
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 ef                	je     8029d8 <devcons_read+0xe>
  8029e9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	78 16                	js     802a05 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029ef:	83 f8 04             	cmp    $0x4,%eax
  8029f2:	74 0c                	je     802a00 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8029f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f7:	88 10                	mov    %dl,(%eax)
  8029f9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8029fe:	eb 05                	jmp    802a05 <devcons_read+0x3b>
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    

00802a07 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
  802a0a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a10:	89 04 24             	mov    %eax,(%esp)
  802a13:	e8 fb ec ff ff       	call   801713 <fd_alloc>
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	78 3f                	js     802a5b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a1c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a23:	00 
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a32:	e8 a7 e6 ff ff       	call   8010de <sys_page_alloc>
  802a37:	85 c0                	test   %eax,%eax
  802a39:	78 20                	js     802a5b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a3b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	89 04 24             	mov    %eax,(%esp)
  802a56:	e8 8d ec ff ff       	call   8016e8 <fd2num>
}
  802a5b:	c9                   	leave  
  802a5c:	c3                   	ret    

00802a5d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
  802a60:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	89 04 24             	mov    %eax,(%esp)
  802a70:	e8 f7 ec ff ff       	call   80176c <fd_lookup>
  802a75:	85 c0                	test   %eax,%eax
  802a77:	78 11                	js     802a8a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 00                	mov    (%eax),%eax
  802a7e:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  802a84:	0f 94 c0             	sete   %al
  802a87:	0f b6 c0             	movzbl %al,%eax
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a92:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a99:	00 
  802a9a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aa8:	e8 16 ef ff ff       	call   8019c3 <read>
	if (r < 0)
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	78 0f                	js     802ac0 <getchar+0x34>
		return r;
	if (r < 1)
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	7f 07                	jg     802abc <getchar+0x30>
  802ab5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802aba:	eb 04                	jmp    802ac0 <getchar+0x34>
		return -E_EOF;
	return c;
  802abc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    
	...

00802ac4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
  802ac7:	53                   	push   %ebx
  802ac8:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  802acb:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  802ad2:	75 5b                	jne    802b2f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  802ad4:	e8 98 e6 ff ff       	call   801171 <sys_getenvid>
  802ad9:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  802adb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ae2:	00 
  802ae3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802aea:	ee 
  802aeb:	89 04 24             	mov    %eax,(%esp)
  802aee:	e8 eb e5 ff ff       	call   8010de <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  802af3:	85 c0                	test   %eax,%eax
  802af5:	74 28                	je     802b1f <set_pgfault_handler+0x5b>
  802af7:	89 44 24 10          	mov    %eax,0x10(%esp)
  802afb:	c7 44 24 0c 99 34 80 	movl   $0x803499,0xc(%esp)
  802b02:	00 
  802b03:	c7 44 24 08 72 34 80 	movl   $0x803472,0x8(%esp)
  802b0a:	00 
  802b0b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802b12:	00 
  802b13:	c7 04 24 8b 34 80 00 	movl   $0x80348b,(%esp)
  802b1a:	e8 5d d7 ff ff       	call   80027c <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802b1f:	c7 44 24 04 40 2b 80 	movl   $0x802b40,0x4(%esp)
  802b26:	00 
  802b27:	89 1c 24             	mov    %ebx,(%esp)
  802b2a:	e8 d9 e3 ff ff       	call   800f08 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	a3 00 90 80 00       	mov    %eax,0x809000
	
}
  802b37:	83 c4 24             	add    $0x24,%esp
  802b3a:	5b                   	pop    %ebx
  802b3b:	5d                   	pop    %ebp
  802b3c:	c3                   	ret    
  802b3d:	00 00                	add    %al,(%eax)
	...

00802b40 <_pgfault_upcall>:
  802b40:	54                   	push   %esp
  802b41:	a1 00 90 80 00       	mov    0x809000,%eax
  802b46:	ff d0                	call   *%eax
  802b48:	83 c4 04             	add    $0x4,%esp
  802b4b:	83 c4 08             	add    $0x8,%esp
  802b4e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  802b52:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802b56:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  802b59:	83 e9 04             	sub    $0x4,%ecx
  802b5c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  802b60:	61                   	popa   
  802b61:	83 c4 04             	add    $0x4,%esp
  802b64:	9d                   	popf   
  802b65:	5c                   	pop    %esp
  802b66:	c3                   	ret    
	...

00802b70 <__udivdi3>:
  802b70:	55                   	push   %ebp
  802b71:	89 e5                	mov    %esp,%ebp
  802b73:	57                   	push   %edi
  802b74:	56                   	push   %esi
  802b75:	83 ec 10             	sub    $0x10,%esp
  802b78:	8b 45 14             	mov    0x14(%ebp),%eax
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	8b 75 10             	mov    0x10(%ebp),%esi
  802b81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b84:	85 c0                	test   %eax,%eax
  802b86:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802b89:	75 35                	jne    802bc0 <__udivdi3+0x50>
  802b8b:	39 fe                	cmp    %edi,%esi
  802b8d:	77 61                	ja     802bf0 <__udivdi3+0x80>
  802b8f:	85 f6                	test   %esi,%esi
  802b91:	75 0b                	jne    802b9e <__udivdi3+0x2e>
  802b93:	b8 01 00 00 00       	mov    $0x1,%eax
  802b98:	31 d2                	xor    %edx,%edx
  802b9a:	f7 f6                	div    %esi
  802b9c:	89 c6                	mov    %eax,%esi
  802b9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ba1:	31 d2                	xor    %edx,%edx
  802ba3:	89 f8                	mov    %edi,%eax
  802ba5:	f7 f6                	div    %esi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	89 c8                	mov    %ecx,%eax
  802bab:	f7 f6                	div    %esi
  802bad:	89 c1                	mov    %eax,%ecx
  802baf:	89 fa                	mov    %edi,%edx
  802bb1:	89 c8                	mov    %ecx,%eax
  802bb3:	83 c4 10             	add    $0x10,%esp
  802bb6:	5e                   	pop    %esi
  802bb7:	5f                   	pop    %edi
  802bb8:	5d                   	pop    %ebp
  802bb9:	c3                   	ret    
  802bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bc0:	39 f8                	cmp    %edi,%eax
  802bc2:	77 1c                	ja     802be0 <__udivdi3+0x70>
  802bc4:	0f bd d0             	bsr    %eax,%edx
  802bc7:	83 f2 1f             	xor    $0x1f,%edx
  802bca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bcd:	75 39                	jne    802c08 <__udivdi3+0x98>
  802bcf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802bd2:	0f 86 a0 00 00 00    	jbe    802c78 <__udivdi3+0x108>
  802bd8:	39 f8                	cmp    %edi,%eax
  802bda:	0f 82 98 00 00 00    	jb     802c78 <__udivdi3+0x108>
  802be0:	31 ff                	xor    %edi,%edi
  802be2:	31 c9                	xor    %ecx,%ecx
  802be4:	89 c8                	mov    %ecx,%eax
  802be6:	89 fa                	mov    %edi,%edx
  802be8:	83 c4 10             	add    $0x10,%esp
  802beb:	5e                   	pop    %esi
  802bec:	5f                   	pop    %edi
  802bed:	5d                   	pop    %ebp
  802bee:	c3                   	ret    
  802bef:	90                   	nop
  802bf0:	89 d1                	mov    %edx,%ecx
  802bf2:	89 fa                	mov    %edi,%edx
  802bf4:	89 c8                	mov    %ecx,%eax
  802bf6:	31 ff                	xor    %edi,%edi
  802bf8:	f7 f6                	div    %esi
  802bfa:	89 c1                	mov    %eax,%ecx
  802bfc:	89 fa                	mov    %edi,%edx
  802bfe:	89 c8                	mov    %ecx,%eax
  802c00:	83 c4 10             	add    $0x10,%esp
  802c03:	5e                   	pop    %esi
  802c04:	5f                   	pop    %edi
  802c05:	5d                   	pop    %ebp
  802c06:	c3                   	ret    
  802c07:	90                   	nop
  802c08:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c0c:	89 f2                	mov    %esi,%edx
  802c0e:	d3 e0                	shl    %cl,%eax
  802c10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c13:	b8 20 00 00 00       	mov    $0x20,%eax
  802c18:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c1b:	89 c1                	mov    %eax,%ecx
  802c1d:	d3 ea                	shr    %cl,%edx
  802c1f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c23:	0b 55 ec             	or     -0x14(%ebp),%edx
  802c26:	d3 e6                	shl    %cl,%esi
  802c28:	89 c1                	mov    %eax,%ecx
  802c2a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802c2d:	89 fe                	mov    %edi,%esi
  802c2f:	d3 ee                	shr    %cl,%esi
  802c31:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c35:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	d3 e7                	shl    %cl,%edi
  802c3d:	89 c1                	mov    %eax,%ecx
  802c3f:	d3 ea                	shr    %cl,%edx
  802c41:	09 d7                	or     %edx,%edi
  802c43:	89 f2                	mov    %esi,%edx
  802c45:	89 f8                	mov    %edi,%eax
  802c47:	f7 75 ec             	divl   -0x14(%ebp)
  802c4a:	89 d6                	mov    %edx,%esi
  802c4c:	89 c7                	mov    %eax,%edi
  802c4e:	f7 65 e8             	mull   -0x18(%ebp)
  802c51:	39 d6                	cmp    %edx,%esi
  802c53:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c56:	72 30                	jb     802c88 <__udivdi3+0x118>
  802c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c5f:	d3 e2                	shl    %cl,%edx
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	73 05                	jae    802c6a <__udivdi3+0xfa>
  802c65:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c68:	74 1e                	je     802c88 <__udivdi3+0x118>
  802c6a:	89 f9                	mov    %edi,%ecx
  802c6c:	31 ff                	xor    %edi,%edi
  802c6e:	e9 71 ff ff ff       	jmp    802be4 <__udivdi3+0x74>
  802c73:	90                   	nop
  802c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c78:	31 ff                	xor    %edi,%edi
  802c7a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c7f:	e9 60 ff ff ff       	jmp    802be4 <__udivdi3+0x74>
  802c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c88:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802c8b:	31 ff                	xor    %edi,%edi
  802c8d:	89 c8                	mov    %ecx,%eax
  802c8f:	89 fa                	mov    %edi,%edx
  802c91:	83 c4 10             	add    $0x10,%esp
  802c94:	5e                   	pop    %esi
  802c95:	5f                   	pop    %edi
  802c96:	5d                   	pop    %ebp
  802c97:	c3                   	ret    
	...

00802ca0 <__umoddi3>:
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
  802ca3:	57                   	push   %edi
  802ca4:	56                   	push   %esi
  802ca5:	83 ec 20             	sub    $0x20,%esp
  802ca8:	8b 55 14             	mov    0x14(%ebp),%edx
  802cab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cae:	8b 7d 10             	mov    0x10(%ebp),%edi
  802cb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cb4:	85 d2                	test   %edx,%edx
  802cb6:	89 c8                	mov    %ecx,%eax
  802cb8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802cbb:	75 13                	jne    802cd0 <__umoddi3+0x30>
  802cbd:	39 f7                	cmp    %esi,%edi
  802cbf:	76 3f                	jbe    802d00 <__umoddi3+0x60>
  802cc1:	89 f2                	mov    %esi,%edx
  802cc3:	f7 f7                	div    %edi
  802cc5:	89 d0                	mov    %edx,%eax
  802cc7:	31 d2                	xor    %edx,%edx
  802cc9:	83 c4 20             	add    $0x20,%esp
  802ccc:	5e                   	pop    %esi
  802ccd:	5f                   	pop    %edi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    
  802cd0:	39 f2                	cmp    %esi,%edx
  802cd2:	77 4c                	ja     802d20 <__umoddi3+0x80>
  802cd4:	0f bd ca             	bsr    %edx,%ecx
  802cd7:	83 f1 1f             	xor    $0x1f,%ecx
  802cda:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802cdd:	75 51                	jne    802d30 <__umoddi3+0x90>
  802cdf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802ce2:	0f 87 e0 00 00 00    	ja     802dc8 <__umoddi3+0x128>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	29 f8                	sub    %edi,%eax
  802ced:	19 d6                	sbb    %edx,%esi
  802cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	89 f2                	mov    %esi,%edx
  802cf7:	83 c4 20             	add    $0x20,%esp
  802cfa:	5e                   	pop    %esi
  802cfb:	5f                   	pop    %edi
  802cfc:	5d                   	pop    %ebp
  802cfd:	c3                   	ret    
  802cfe:	66 90                	xchg   %ax,%ax
  802d00:	85 ff                	test   %edi,%edi
  802d02:	75 0b                	jne    802d0f <__umoddi3+0x6f>
  802d04:	b8 01 00 00 00       	mov    $0x1,%eax
  802d09:	31 d2                	xor    %edx,%edx
  802d0b:	f7 f7                	div    %edi
  802d0d:	89 c7                	mov    %eax,%edi
  802d0f:	89 f0                	mov    %esi,%eax
  802d11:	31 d2                	xor    %edx,%edx
  802d13:	f7 f7                	div    %edi
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	f7 f7                	div    %edi
  802d1a:	eb a9                	jmp    802cc5 <__umoddi3+0x25>
  802d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d20:	89 c8                	mov    %ecx,%eax
  802d22:	89 f2                	mov    %esi,%edx
  802d24:	83 c4 20             	add    $0x20,%esp
  802d27:	5e                   	pop    %esi
  802d28:	5f                   	pop    %edi
  802d29:	5d                   	pop    %ebp
  802d2a:	c3                   	ret    
  802d2b:	90                   	nop
  802d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d30:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d34:	d3 e2                	shl    %cl,%edx
  802d36:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d39:	ba 20 00 00 00       	mov    $0x20,%edx
  802d3e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802d41:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d44:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d48:	89 fa                	mov    %edi,%edx
  802d4a:	d3 ea                	shr    %cl,%edx
  802d4c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d50:	0b 55 f4             	or     -0xc(%ebp),%edx
  802d53:	d3 e7                	shl    %cl,%edi
  802d55:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d59:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d5c:	89 f2                	mov    %esi,%edx
  802d5e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	d3 ea                	shr    %cl,%edx
  802d65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d6c:	89 c2                	mov    %eax,%edx
  802d6e:	d3 e6                	shl    %cl,%esi
  802d70:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d74:	d3 ea                	shr    %cl,%edx
  802d76:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d7a:	09 d6                	or     %edx,%esi
  802d7c:	89 f0                	mov    %esi,%eax
  802d7e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802d81:	d3 e7                	shl    %cl,%edi
  802d83:	89 f2                	mov    %esi,%edx
  802d85:	f7 75 f4             	divl   -0xc(%ebp)
  802d88:	89 d6                	mov    %edx,%esi
  802d8a:	f7 65 e8             	mull   -0x18(%ebp)
  802d8d:	39 d6                	cmp    %edx,%esi
  802d8f:	72 2b                	jb     802dbc <__umoddi3+0x11c>
  802d91:	39 c7                	cmp    %eax,%edi
  802d93:	72 23                	jb     802db8 <__umoddi3+0x118>
  802d95:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d99:	29 c7                	sub    %eax,%edi
  802d9b:	19 d6                	sbb    %edx,%esi
  802d9d:	89 f0                	mov    %esi,%eax
  802d9f:	89 f2                	mov    %esi,%edx
  802da1:	d3 ef                	shr    %cl,%edi
  802da3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802da7:	d3 e0                	shl    %cl,%eax
  802da9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dad:	09 f8                	or     %edi,%eax
  802daf:	d3 ea                	shr    %cl,%edx
  802db1:	83 c4 20             	add    $0x20,%esp
  802db4:	5e                   	pop    %esi
  802db5:	5f                   	pop    %edi
  802db6:	5d                   	pop    %ebp
  802db7:	c3                   	ret    
  802db8:	39 d6                	cmp    %edx,%esi
  802dba:	75 d9                	jne    802d95 <__umoddi3+0xf5>
  802dbc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802dbf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802dc2:	eb d1                	jmp    802d95 <__umoddi3+0xf5>
  802dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	39 f2                	cmp    %esi,%edx
  802dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802dd0:	0f 82 12 ff ff ff    	jb     802ce8 <__umoddi3+0x48>
  802dd6:	e9 17 ff ff ff       	jmp    802cf2 <__umoddi3+0x52>
