
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e7 02 00 00       	call   800318 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003c:	c7 05 04 40 80 00 40 	movl   $0x802f40,0x804004
  800043:	2f 80 00 

	if ((i = pipe(p)) < 0)
  800046:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 dd 26 00 00       	call   80272e <pipe>
  800051:	89 c6                	mov    %eax,%esi
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", i);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 4c 2f 80 	movl   $0x802f4c,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  800072:	e8 05 03 00 00       	call   80037c <_panic>

	if ((pid = fork()) < 0)
  800077:	e8 aa 12 00 00       	call   801326 <fork>
  80007c:	89 c3                	mov    %eax,%ebx
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", i);
  800082:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800086:	c7 44 24 08 1a 34 80 	movl   $0x80341a,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  80009d:	e8 da 02 00 00       	call   80037c <_panic>

	if (pid == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 85 d5 00 00 00    	jne    80017f <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8000af:	8b 40 48             	mov    0x48(%eax),%eax
  8000b2:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 65 2f 80 00 	movl   $0x802f65,(%esp)
  8000c4:	e8 6c 03 00 00       	call   800435 <cprintf>
		close(p[1]);
  8000c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cc:	89 04 24             	mov    %eax,(%esp)
  8000cf:	e8 2a 1a 00 00       	call   801afe <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d4:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d9:	8b 40 48             	mov    0x48(%eax),%eax
  8000dc:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e7:	c7 04 24 82 2f 80 00 	movl   $0x802f82,(%esp)
  8000ee:	e8 42 03 00 00       	call   800435 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f3:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000fa:	00 
  8000fb:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800105:	89 04 24             	mov    %eax,(%esp)
  800108:	e8 18 19 00 00       	call   801a25 <readn>
  80010d:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0xff>
			panic("read: %e", i);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  80012e:	e8 49 02 00 00       	call   80037c <_panic>
		buf[i] = 0;
  800133:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800138:	a1 00 40 80 00       	mov    0x804000,%eax
  80013d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800141:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 f8 09 00 00       	call   800b44 <strcmp>
  80014c:	85 c0                	test   %eax,%eax
  80014e:	75 0e                	jne    80015e <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  800150:	c7 04 24 a8 2f 80 00 	movl   $0x802fa8,(%esp)
  800157:	e8 d9 02 00 00       	call   800435 <cprintf>
  80015c:	eb 17                	jmp    800175 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800161:	89 44 24 08          	mov    %eax,0x8(%esp)
  800165:	89 74 24 04          	mov    %esi,0x4(%esp)
  800169:	c7 04 24 c4 2f 80 00 	movl   $0x802fc4,(%esp)
  800170:	e8 c0 02 00 00       	call   800435 <cprintf>
		exit();
  800175:	e8 ee 01 00 00       	call   800368 <exit>
  80017a:	e9 ac 00 00 00       	jmp    80022b <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017f:	a1 08 50 80 00       	mov    0x805008,%eax
  800184:	8b 40 48             	mov    0x48(%eax),%eax
  800187:	8b 55 8c             	mov    -0x74(%ebp),%edx
  80018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800192:	c7 04 24 65 2f 80 00 	movl   $0x802f65,(%esp)
  800199:	e8 97 02 00 00       	call   800435 <cprintf>
		close(p[0]);
  80019e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 55 19 00 00       	call   801afe <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	c7 04 24 d7 2f 80 00 	movl   $0x802fd7,(%esp)
  8001c3:	e8 6d 02 00 00       	call   800435 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 8b 08 00 00       	call   800a60 <strlen>
  8001d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d9:	a1 00 40 80 00       	mov    0x804000,%eax
  8001de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	e8 21 17 00 00       	call   80190e <write>
  8001ed:	89 c6                	mov    %eax,%esi
  8001ef:	a1 00 40 80 00       	mov    0x804000,%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 64 08 00 00       	call   800a60 <strlen>
  8001fc:	39 c6                	cmp    %eax,%esi
  8001fe:	74 20                	je     800220 <umain+0x1ec>
			panic("write: %e", i);
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	c7 44 24 08 f4 2f 80 	movl   $0x802ff4,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800213:	00 
  800214:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  80021b:	e8 5c 01 00 00       	call   80037c <_panic>
		close(p[1]);
  800220:	8b 45 90             	mov    -0x70(%ebp),%eax
  800223:	89 04 24             	mov    %eax,(%esp)
  800226:	e8 d3 18 00 00       	call   801afe <close>
	}
	wait(pid);
  80022b:	89 1c 24             	mov    %ebx,(%esp)
  80022e:	e8 75 26 00 00       	call   8028a8 <wait>

	binaryname = "pipewriteeof";
  800233:	c7 05 04 40 80 00 fe 	movl   $0x802ffe,0x804004
  80023a:	2f 80 00 
	if ((i = pipe(p)) < 0)
  80023d:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800240:	89 04 24             	mov    %eax,(%esp)
  800243:	e8 e6 24 00 00       	call   80272e <pipe>
  800248:	89 c6                	mov    %eax,%esi
  80024a:	85 c0                	test   %eax,%eax
  80024c:	79 20                	jns    80026e <umain+0x23a>
		panic("pipe: %e", i);
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	c7 44 24 08 4c 2f 80 	movl   $0x802f4c,0x8(%esp)
  800259:	00 
  80025a:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800261:	00 
  800262:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  800269:	e8 0e 01 00 00       	call   80037c <_panic>

	if ((pid = fork()) < 0)
  80026e:	e8 b3 10 00 00       	call   801326 <fork>
  800273:	89 c3                	mov    %eax,%ebx
  800275:	85 c0                	test   %eax,%eax
  800277:	79 20                	jns    800299 <umain+0x265>
		panic("fork: %e", i);
  800279:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027d:	c7 44 24 08 1a 34 80 	movl   $0x80341a,0x8(%esp)
  800284:	00 
  800285:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028c:	00 
  80028d:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  800294:	e8 e3 00 00 00       	call   80037c <_panic>

	if (pid == 0) {
  800299:	85 c0                	test   %eax,%eax
  80029b:	75 48                	jne    8002e5 <umain+0x2b1>
		close(p[0]);
  80029d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002a0:	89 04 24             	mov    %eax,(%esp)
  8002a3:	e8 56 18 00 00       	call   801afe <close>
		while (1) {
			cprintf(".");
  8002a8:	c7 04 24 0b 30 80 00 	movl   $0x80300b,(%esp)
  8002af:	e8 81 01 00 00       	call   800435 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 0d 30 80 	movl   $0x80300d,0x4(%esp)
  8002c3:	00 
  8002c4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 3f 16 00 00       	call   80190e <write>
  8002cf:	83 f8 01             	cmp    $0x1,%eax
  8002d2:	74 d4                	je     8002a8 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d4:	c7 04 24 0f 30 80 00 	movl   $0x80300f,(%esp)
  8002db:	e8 55 01 00 00       	call   800435 <cprintf>
		exit();
  8002e0:	e8 83 00 00 00       	call   800368 <exit>
	}
	close(p[0]);
  8002e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	e8 0e 18 00 00       	call   801afe <close>
	close(p[1]);
  8002f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f3:	89 04 24             	mov    %eax,(%esp)
  8002f6:	e8 03 18 00 00       	call   801afe <close>
	wait(pid);
  8002fb:	89 1c 24             	mov    %ebx,(%esp)
  8002fe:	e8 a5 25 00 00       	call   8028a8 <wait>

	cprintf("pipe tests passed\n");
  800303:	c7 04 24 2c 30 80 00 	movl   $0x80302c,(%esp)
  80030a:	e8 26 01 00 00       	call   800435 <cprintf>
}
  80030f:	83 ec 80             	sub    $0xffffff80,%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    
	...

00800318 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
  80031e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800321:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80032a:	e8 42 0f 00 00       	call   801271 <sys_getenvid>
  80032f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800334:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800337:	2d 00 00 40 11       	sub    $0x11400000,%eax
  80033c:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800341:	85 f6                	test   %esi,%esi
  800343:	7e 07                	jle    80034c <libmain+0x34>
		binaryname = argv[0];
  800345:	8b 03                	mov    (%ebx),%eax
  800347:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  80034c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800350:	89 34 24             	mov    %esi,(%esp)
  800353:	e8 dc fc ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800358:	e8 0b 00 00 00       	call   800368 <exit>
}
  80035d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800360:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800363:	89 ec                	mov    %ebp,%esp
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    
	...

00800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80036e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800375:	e8 2b 0f 00 00       	call   8012a5 <sys_env_destroy>
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800384:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800387:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  80038d:	e8 df 0e 00 00       	call   801271 <sys_getenvid>
  800392:	8b 55 0c             	mov    0xc(%ebp),%edx
  800395:	89 54 24 10          	mov    %edx,0x10(%esp)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a8:	c7 04 24 90 30 80 00 	movl   $0x803090,(%esp)
  8003af:	e8 81 00 00 00       	call   800435 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 11 00 00 00       	call   8003d4 <vcprintf>
	cprintf("\n");
  8003c3:	c7 04 24 80 2f 80 00 	movl   $0x802f80,(%esp)
  8003ca:	e8 66 00 00 00       	call   800435 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003cf:	cc                   	int3   
  8003d0:	eb fd                	jmp    8003cf <_panic+0x53>
	...

008003d4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e4:	00 00 00 
	b.cnt = 0;
  8003e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800405:	89 44 24 04          	mov    %eax,0x4(%esp)
  800409:	c7 04 24 4f 04 80 00 	movl   $0x80044f,(%esp)
  800410:	e8 be 01 00 00       	call   8005d3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800415:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800425:	89 04 24             	mov    %eax,(%esp)
  800428:	e8 23 0a 00 00       	call   800e50 <sys_cputs>

	return b.cnt;
}
  80042d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80043b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80043e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	e8 87 ff ff ff       	call   8003d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	53                   	push   %ebx
  800453:	83 ec 14             	sub    $0x14,%esp
  800456:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800459:	8b 03                	mov    (%ebx),%eax
  80045b:	8b 55 08             	mov    0x8(%ebp),%edx
  80045e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800462:	83 c0 01             	add    $0x1,%eax
  800465:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800467:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046c:	75 19                	jne    800487 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80046e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800475:	00 
  800476:	8d 43 08             	lea    0x8(%ebx),%eax
  800479:	89 04 24             	mov    %eax,(%esp)
  80047c:	e8 cf 09 00 00       	call   800e50 <sys_cputs>
		b->idx = 0;
  800481:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800487:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80048b:	83 c4 14             	add    $0x14,%esp
  80048e:	5b                   	pop    %ebx
  80048f:	5d                   	pop    %ebp
  800490:	c3                   	ret    
  800491:	00 00                	add    %al,(%eax)
	...

00800494 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	57                   	push   %edi
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 4c             	sub    $0x4c,%esp
  80049d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a0:	89 d6                	mov    %edx,%esi
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004b4:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004bf:	39 d1                	cmp    %edx,%ecx
  8004c1:	72 07                	jb     8004ca <printnum+0x36>
  8004c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004c6:	39 d0                	cmp    %edx,%eax
  8004c8:	77 69                	ja     800533 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ca:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004ce:	83 eb 01             	sub    $0x1,%ebx
  8004d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004dd:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004e1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004e4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004e7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004ee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004f5:	00 
  8004f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f9:	89 04 24             	mov    %eax,(%esp)
  8004fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ff:	89 54 24 04          	mov    %edx,0x4(%esp)
  800503:	e8 c8 27 00 00       	call   802cd0 <__udivdi3>
  800508:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80050b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80050e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800512:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800516:	89 04 24             	mov    %eax,(%esp)
  800519:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051d:	89 f2                	mov    %esi,%edx
  80051f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800522:	e8 6d ff ff ff       	call   800494 <printnum>
  800527:	eb 11                	jmp    80053a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800529:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052d:	89 3c 24             	mov    %edi,(%esp)
  800530:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800533:	83 eb 01             	sub    $0x1,%ebx
  800536:	85 db                	test   %ebx,%ebx
  800538:	7f ef                	jg     800529 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80053e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800545:	89 44 24 08          	mov    %eax,0x8(%esp)
  800549:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800550:	00 
  800551:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800554:	89 14 24             	mov    %edx,(%esp)
  800557:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80055e:	e8 9d 28 00 00       	call   802e00 <__umoddi3>
  800563:	89 74 24 04          	mov    %esi,0x4(%esp)
  800567:	0f be 80 b3 30 80 00 	movsbl 0x8030b3(%eax),%eax
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800574:	83 c4 4c             	add    $0x4c,%esp
  800577:	5b                   	pop    %ebx
  800578:	5e                   	pop    %esi
  800579:	5f                   	pop    %edi
  80057a:	5d                   	pop    %ebp
  80057b:	c3                   	ret    

0080057c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057f:	83 fa 01             	cmp    $0x1,%edx
  800582:	7e 0e                	jle    800592 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800584:	8b 10                	mov    (%eax),%edx
  800586:	8d 4a 08             	lea    0x8(%edx),%ecx
  800589:	89 08                	mov    %ecx,(%eax)
  80058b:	8b 02                	mov    (%edx),%eax
  80058d:	8b 52 04             	mov    0x4(%edx),%edx
  800590:	eb 22                	jmp    8005b4 <getuint+0x38>
	else if (lflag)
  800592:	85 d2                	test   %edx,%edx
  800594:	74 10                	je     8005a6 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800596:	8b 10                	mov    (%eax),%edx
  800598:	8d 4a 04             	lea    0x4(%edx),%ecx
  80059b:	89 08                	mov    %ecx,(%eax)
  80059d:	8b 02                	mov    (%edx),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	eb 0e                	jmp    8005b4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005a6:	8b 10                	mov    (%eax),%edx
  8005a8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ab:	89 08                	mov    %ecx,(%eax)
  8005ad:	8b 02                	mov    (%edx),%eax
  8005af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005b4:	5d                   	pop    %ebp
  8005b5:	c3                   	ret    

008005b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005bc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c0:	8b 10                	mov    (%eax),%edx
  8005c2:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c5:	73 0a                	jae    8005d1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005ca:	88 0a                	mov    %cl,(%edx)
  8005cc:	83 c2 01             	add    $0x1,%edx
  8005cf:	89 10                	mov    %edx,(%eax)
}
  8005d1:	5d                   	pop    %ebp
  8005d2:	c3                   	ret    

008005d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	57                   	push   %edi
  8005d7:	56                   	push   %esi
  8005d8:	53                   	push   %ebx
  8005d9:	83 ec 4c             	sub    $0x4c,%esp
  8005dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005e5:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8005ec:	eb 11                	jmp    8005ff <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	0f 84 b6 03 00 00    	je     8009ac <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8005f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fa:	89 04 24             	mov    %eax,(%esp)
  8005fd:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ff:	0f b6 03             	movzbl (%ebx),%eax
  800602:	83 c3 01             	add    $0x1,%ebx
  800605:	83 f8 25             	cmp    $0x25,%eax
  800608:	75 e4                	jne    8005ee <vprintfmt+0x1b>
  80060a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80060e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800615:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80061c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800623:	b9 00 00 00 00       	mov    $0x0,%ecx
  800628:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80062b:	eb 06                	jmp    800633 <vprintfmt+0x60>
  80062d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800631:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800633:	0f b6 0b             	movzbl (%ebx),%ecx
  800636:	0f b6 c1             	movzbl %cl,%eax
  800639:	8d 53 01             	lea    0x1(%ebx),%edx
  80063c:	83 e9 23             	sub    $0x23,%ecx
  80063f:	80 f9 55             	cmp    $0x55,%cl
  800642:	0f 87 47 03 00 00    	ja     80098f <vprintfmt+0x3bc>
  800648:	0f b6 c9             	movzbl %cl,%ecx
  80064b:	ff 24 8d 00 32 80 00 	jmp    *0x803200(,%ecx,4)
  800652:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800656:	eb d9                	jmp    800631 <vprintfmt+0x5e>
  800658:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800664:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800667:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80066b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80066e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800671:	83 fb 09             	cmp    $0x9,%ebx
  800674:	77 30                	ja     8006a6 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800676:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800679:	eb e9                	jmp    800664 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 48 04             	lea    0x4(%eax),%ecx
  800681:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800684:	8b 00                	mov    (%eax),%eax
  800686:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800689:	eb 1e                	jmp    8006a9 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80068b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068f:	b8 00 00 00 00       	mov    $0x0,%eax
  800694:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80069b:	eb 94                	jmp    800631 <vprintfmt+0x5e>
  80069d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8006a4:	eb 8b                	jmp    800631 <vprintfmt+0x5e>
  8006a6:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8006a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ad:	79 82                	jns    800631 <vprintfmt+0x5e>
  8006af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006b8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8006bb:	e9 71 ff ff ff       	jmp    800631 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006c0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006c4:	e9 68 ff ff ff       	jmp    800631 <vprintfmt+0x5e>
  8006c9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8d 50 04             	lea    0x4(%eax),%edx
  8006d2:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 04 24             	mov    %eax,(%esp)
  8006de:	ff d7                	call   *%edi
  8006e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006e3:	e9 17 ff ff ff       	jmp    8005ff <vprintfmt+0x2c>
  8006e8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 50 04             	lea    0x4(%eax),%edx
  8006f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 c2                	mov    %eax,%edx
  8006f8:	c1 fa 1f             	sar    $0x1f,%edx
  8006fb:	31 d0                	xor    %edx,%eax
  8006fd:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ff:	83 f8 11             	cmp    $0x11,%eax
  800702:	7f 0b                	jg     80070f <vprintfmt+0x13c>
  800704:	8b 14 85 60 33 80 00 	mov    0x803360(,%eax,4),%edx
  80070b:	85 d2                	test   %edx,%edx
  80070d:	75 20                	jne    80072f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80070f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800713:	c7 44 24 08 c4 30 80 	movl   $0x8030c4,0x8(%esp)
  80071a:	00 
  80071b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80071f:	89 3c 24             	mov    %edi,(%esp)
  800722:	e8 0d 03 00 00       	call   800a34 <printfmt>
  800727:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072a:	e9 d0 fe ff ff       	jmp    8005ff <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80072f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800733:	c7 44 24 08 72 35 80 	movl   $0x803572,0x8(%esp)
  80073a:	00 
  80073b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80073f:	89 3c 24             	mov    %edi,(%esp)
  800742:	e8 ed 02 00 00       	call   800a34 <printfmt>
  800747:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80074a:	e9 b0 fe ff ff       	jmp    8005ff <vprintfmt+0x2c>
  80074f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800752:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800758:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 50 04             	lea    0x4(%eax),%edx
  800761:	89 55 14             	mov    %edx,0x14(%ebp)
  800764:	8b 18                	mov    (%eax),%ebx
  800766:	85 db                	test   %ebx,%ebx
  800768:	b8 cd 30 80 00       	mov    $0x8030cd,%eax
  80076d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800770:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800774:	7e 76                	jle    8007ec <vprintfmt+0x219>
  800776:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80077a:	74 7a                	je     8007f6 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80077c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800780:	89 1c 24             	mov    %ebx,(%esp)
  800783:	e8 f0 02 00 00       	call   800a78 <strnlen>
  800788:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80078b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80078d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800794:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800797:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800799:	eb 0f                	jmp    8007aa <vprintfmt+0x1d7>
					putch(padc, putdat);
  80079b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a2:	89 04 24             	mov    %eax,(%esp)
  8007a5:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a7:	83 eb 01             	sub    $0x1,%ebx
  8007aa:	85 db                	test   %ebx,%ebx
  8007ac:	7f ed                	jg     80079b <vprintfmt+0x1c8>
  8007ae:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007b1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007b4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8007b7:	89 f7                	mov    %esi,%edi
  8007b9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007bc:	eb 40                	jmp    8007fe <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007c2:	74 18                	je     8007dc <vprintfmt+0x209>
  8007c4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007c7:	83 fa 5e             	cmp    $0x5e,%edx
  8007ca:	76 10                	jbe    8007dc <vprintfmt+0x209>
					putch('?', putdat);
  8007cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007d7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007da:	eb 0a                	jmp    8007e6 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8007dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e0:	89 04 24             	mov    %eax,(%esp)
  8007e3:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007ea:	eb 12                	jmp    8007fe <vprintfmt+0x22b>
  8007ec:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8007ef:	89 f7                	mov    %esi,%edi
  8007f1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007f4:	eb 08                	jmp    8007fe <vprintfmt+0x22b>
  8007f6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8007f9:	89 f7                	mov    %esi,%edi
  8007fb:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007fe:	0f be 03             	movsbl (%ebx),%eax
  800801:	83 c3 01             	add    $0x1,%ebx
  800804:	85 c0                	test   %eax,%eax
  800806:	74 25                	je     80082d <vprintfmt+0x25a>
  800808:	85 f6                	test   %esi,%esi
  80080a:	78 b2                	js     8007be <vprintfmt+0x1eb>
  80080c:	83 ee 01             	sub    $0x1,%esi
  80080f:	79 ad                	jns    8007be <vprintfmt+0x1eb>
  800811:	89 fe                	mov    %edi,%esi
  800813:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800816:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800819:	eb 1a                	jmp    800835 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80081b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800826:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800828:	83 eb 01             	sub    $0x1,%ebx
  80082b:	eb 08                	jmp    800835 <vprintfmt+0x262>
  80082d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800830:	89 fe                	mov    %edi,%esi
  800832:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800835:	85 db                	test   %ebx,%ebx
  800837:	7f e2                	jg     80081b <vprintfmt+0x248>
  800839:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80083c:	e9 be fd ff ff       	jmp    8005ff <vprintfmt+0x2c>
  800841:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800844:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800847:	83 f9 01             	cmp    $0x1,%ecx
  80084a:	7e 16                	jle    800862 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8d 50 08             	lea    0x8(%eax),%edx
  800852:	89 55 14             	mov    %edx,0x14(%ebp)
  800855:	8b 10                	mov    (%eax),%edx
  800857:	8b 48 04             	mov    0x4(%eax),%ecx
  80085a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  80085d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800860:	eb 32                	jmp    800894 <vprintfmt+0x2c1>
	else if (lflag)
  800862:	85 c9                	test   %ecx,%ecx
  800864:	74 18                	je     80087e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8d 50 04             	lea    0x4(%eax),%edx
  80086c:	89 55 14             	mov    %edx,0x14(%ebp)
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800874:	89 c1                	mov    %eax,%ecx
  800876:	c1 f9 1f             	sar    $0x1f,%ecx
  800879:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087c:	eb 16                	jmp    800894 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	89 55 14             	mov    %edx,0x14(%ebp)
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088c:	89 c2                	mov    %eax,%edx
  80088e:	c1 fa 1f             	sar    $0x1f,%edx
  800891:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800894:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800897:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80089a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80089f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008a3:	0f 89 a7 00 00 00    	jns    800950 <vprintfmt+0x37d>
				putch('-', putdat);
  8008a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ad:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008b4:	ff d7                	call   *%edi
				num = -(long long) num;
  8008b6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008b9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008bc:	f7 d9                	neg    %ecx
  8008be:	83 d3 00             	adc    $0x0,%ebx
  8008c1:	f7 db                	neg    %ebx
  8008c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c8:	e9 83 00 00 00       	jmp    800950 <vprintfmt+0x37d>
  8008cd:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d3:	89 ca                	mov    %ecx,%edx
  8008d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d8:	e8 9f fc ff ff       	call   80057c <getuint>
  8008dd:	89 c1                	mov    %eax,%ecx
  8008df:	89 d3                	mov    %edx,%ebx
  8008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8008e6:	eb 68                	jmp    800950 <vprintfmt+0x37d>
  8008e8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8008ee:	89 ca                	mov    %ecx,%edx
  8008f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f3:	e8 84 fc ff ff       	call   80057c <getuint>
  8008f8:	89 c1                	mov    %eax,%ecx
  8008fa:	89 d3                	mov    %edx,%ebx
  8008fc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800901:	eb 4d                	jmp    800950 <vprintfmt+0x37d>
  800903:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800906:	89 74 24 04          	mov    %esi,0x4(%esp)
  80090a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800911:	ff d7                	call   *%edi
			putch('x', putdat);
  800913:	89 74 24 04          	mov    %esi,0x4(%esp)
  800917:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80091e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8d 50 04             	lea    0x4(%eax),%edx
  800926:	89 55 14             	mov    %edx,0x14(%ebp)
  800929:	8b 08                	mov    (%eax),%ecx
  80092b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800930:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800935:	eb 19                	jmp    800950 <vprintfmt+0x37d>
  800937:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80093a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80093d:	89 ca                	mov    %ecx,%edx
  80093f:	8d 45 14             	lea    0x14(%ebp),%eax
  800942:	e8 35 fc ff ff       	call   80057c <getuint>
  800947:	89 c1                	mov    %eax,%ecx
  800949:	89 d3                	mov    %edx,%ebx
  80094b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800950:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800954:	89 54 24 10          	mov    %edx,0x10(%esp)
  800958:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80095b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80095f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800963:	89 0c 24             	mov    %ecx,(%esp)
  800966:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80096a:	89 f2                	mov    %esi,%edx
  80096c:	89 f8                	mov    %edi,%eax
  80096e:	e8 21 fb ff ff       	call   800494 <printnum>
  800973:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800976:	e9 84 fc ff ff       	jmp    8005ff <vprintfmt+0x2c>
  80097b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80097e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800982:	89 04 24             	mov    %eax,(%esp)
  800985:	ff d7                	call   *%edi
  800987:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80098a:	e9 70 fc ff ff       	jmp    8005ff <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80098f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800993:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80099a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80099c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80099f:	80 38 25             	cmpb   $0x25,(%eax)
  8009a2:	0f 84 57 fc ff ff    	je     8005ff <vprintfmt+0x2c>
  8009a8:	89 c3                	mov    %eax,%ebx
  8009aa:	eb f0                	jmp    80099c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8009ac:	83 c4 4c             	add    $0x4c,%esp
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 28             	sub    $0x28,%esp
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	74 04                	je     8009c8 <vsnprintf+0x14>
  8009c4:	85 d2                	test   %edx,%edx
  8009c6:	7f 07                	jg     8009cf <vsnprintf+0x1b>
  8009c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cd:	eb 3b                	jmp    800a0a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8009d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f5:	c7 04 24 b6 05 80 00 	movl   $0x8005b6,(%esp)
  8009fc:	e8 d2 fb ff ff       	call   8005d3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a04:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a12:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a19:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 04 24             	mov    %eax,(%esp)
  800a2d:	e8 82 ff ff ff       	call   8009b4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a3a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a41:	8b 45 10             	mov    0x10(%ebp),%eax
  800a44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	89 04 24             	mov    %eax,(%esp)
  800a55:	e8 79 fb ff ff       	call   8005d3 <vprintfmt>
	va_end(ap);
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    
  800a5c:	00 00                	add    %al,(%eax)
	...

00800a60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 55 08             	mov    0x8(%ebp),%edx
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a6b:	eb 03                	jmp    800a70 <strlen+0x10>
		n++;
  800a6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a74:	75 f7                	jne    800a6d <strlen+0xd>
		n++;
	return n;
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	53                   	push   %ebx
  800a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a87:	eb 03                	jmp    800a8c <strnlen+0x14>
		n++;
  800a89:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8c:	39 c1                	cmp    %eax,%ecx
  800a8e:	74 06                	je     800a96 <strnlen+0x1e>
  800a90:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800a94:	75 f3                	jne    800a89 <strnlen+0x11>
		n++;
	return n;
}
  800a96:	5b                   	pop    %ebx
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aa3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aaf:	83 c2 01             	add    $0x1,%edx
  800ab2:	84 c9                	test   %cl,%cl
  800ab4:	75 f2                	jne    800aa8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ab6:	5b                   	pop    %ebx
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	53                   	push   %ebx
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac3:	89 1c 24             	mov    %ebx,(%esp)
  800ac6:	e8 95 ff ff ff       	call   800a60 <strlen>
	strcpy(dst + len, src);
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ace:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ad2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800ad5:	89 04 24             	mov    %eax,(%esp)
  800ad8:	e8 bc ff ff ff       	call   800a99 <strcpy>
	return dst;
}
  800add:	89 d8                	mov    %ebx,%eax
  800adf:	83 c4 08             	add    $0x8,%esp
  800ae2:	5b                   	pop    %ebx
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af0:	8b 75 10             	mov    0x10(%ebp),%esi
  800af3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af8:	eb 0f                	jmp    800b09 <strncpy+0x24>
		*dst++ = *src;
  800afa:	0f b6 19             	movzbl (%ecx),%ebx
  800afd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b00:	80 39 01             	cmpb   $0x1,(%ecx)
  800b03:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b06:	83 c2 01             	add    $0x1,%edx
  800b09:	39 f2                	cmp    %esi,%edx
  800b0b:	72 ed                	jb     800afa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	8b 75 08             	mov    0x8(%ebp),%esi
  800b19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b1f:	89 f0                	mov    %esi,%eax
  800b21:	85 d2                	test   %edx,%edx
  800b23:	75 0a                	jne    800b2f <strlcpy+0x1e>
  800b25:	eb 17                	jmp    800b3e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b27:	88 18                	mov    %bl,(%eax)
  800b29:	83 c0 01             	add    $0x1,%eax
  800b2c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b2f:	83 ea 01             	sub    $0x1,%edx
  800b32:	74 07                	je     800b3b <strlcpy+0x2a>
  800b34:	0f b6 19             	movzbl (%ecx),%ebx
  800b37:	84 db                	test   %bl,%bl
  800b39:	75 ec                	jne    800b27 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800b3b:	c6 00 00             	movb   $0x0,(%eax)
  800b3e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800b40:	5b                   	pop    %ebx
  800b41:	5e                   	pop    %esi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b4d:	eb 06                	jmp    800b55 <strcmp+0x11>
		p++, q++;
  800b4f:	83 c1 01             	add    $0x1,%ecx
  800b52:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b55:	0f b6 01             	movzbl (%ecx),%eax
  800b58:	84 c0                	test   %al,%al
  800b5a:	74 04                	je     800b60 <strcmp+0x1c>
  800b5c:	3a 02                	cmp    (%edx),%al
  800b5e:	74 ef                	je     800b4f <strcmp+0xb>
  800b60:	0f b6 c0             	movzbl %al,%eax
  800b63:	0f b6 12             	movzbl (%edx),%edx
  800b66:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	53                   	push   %ebx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b74:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800b77:	eb 09                	jmp    800b82 <strncmp+0x18>
		n--, p++, q++;
  800b79:	83 ea 01             	sub    $0x1,%edx
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b82:	85 d2                	test   %edx,%edx
  800b84:	75 07                	jne    800b8d <strncmp+0x23>
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8b:	eb 13                	jmp    800ba0 <strncmp+0x36>
  800b8d:	0f b6 18             	movzbl (%eax),%ebx
  800b90:	84 db                	test   %bl,%bl
  800b92:	74 04                	je     800b98 <strncmp+0x2e>
  800b94:	3a 19                	cmp    (%ecx),%bl
  800b96:	74 e1                	je     800b79 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	0f b6 00             	movzbl (%eax),%eax
  800b9b:	0f b6 11             	movzbl (%ecx),%edx
  800b9e:	29 d0                	sub    %edx,%eax
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bad:	eb 07                	jmp    800bb6 <strchr+0x13>
		if (*s == c)
  800baf:	38 ca                	cmp    %cl,%dl
  800bb1:	74 0f                	je     800bc2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bb3:	83 c0 01             	add    $0x1,%eax
  800bb6:	0f b6 10             	movzbl (%eax),%edx
  800bb9:	84 d2                	test   %dl,%dl
  800bbb:	75 f2                	jne    800baf <strchr+0xc>
  800bbd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bce:	eb 07                	jmp    800bd7 <strfind+0x13>
		if (*s == c)
  800bd0:	38 ca                	cmp    %cl,%dl
  800bd2:	74 0a                	je     800bde <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd4:	83 c0 01             	add    $0x1,%eax
  800bd7:	0f b6 10             	movzbl (%eax),%edx
  800bda:	84 d2                	test   %dl,%dl
  800bdc:	75 f2                	jne    800bd0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	89 1c 24             	mov    %ebx,(%esp)
  800be9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bed:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800bf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bfa:	85 c9                	test   %ecx,%ecx
  800bfc:	74 30                	je     800c2e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bfe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c04:	75 25                	jne    800c2b <memset+0x4b>
  800c06:	f6 c1 03             	test   $0x3,%cl
  800c09:	75 20                	jne    800c2b <memset+0x4b>
		c &= 0xFF;
  800c0b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c0e:	89 d3                	mov    %edx,%ebx
  800c10:	c1 e3 08             	shl    $0x8,%ebx
  800c13:	89 d6                	mov    %edx,%esi
  800c15:	c1 e6 18             	shl    $0x18,%esi
  800c18:	89 d0                	mov    %edx,%eax
  800c1a:	c1 e0 10             	shl    $0x10,%eax
  800c1d:	09 f0                	or     %esi,%eax
  800c1f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800c21:	09 d8                	or     %ebx,%eax
  800c23:	c1 e9 02             	shr    $0x2,%ecx
  800c26:	fc                   	cld    
  800c27:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c29:	eb 03                	jmp    800c2e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c2b:	fc                   	cld    
  800c2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2e:	89 f8                	mov    %edi,%eax
  800c30:	8b 1c 24             	mov    (%esp),%ebx
  800c33:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c37:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c3b:	89 ec                	mov    %ebp,%esp
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	89 34 24             	mov    %esi,(%esp)
  800c48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800c52:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c55:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c57:	39 c6                	cmp    %eax,%esi
  800c59:	73 35                	jae    800c90 <memmove+0x51>
  800c5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c5e:	39 d0                	cmp    %edx,%eax
  800c60:	73 2e                	jae    800c90 <memmove+0x51>
		s += n;
		d += n;
  800c62:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c64:	f6 c2 03             	test   $0x3,%dl
  800c67:	75 1b                	jne    800c84 <memmove+0x45>
  800c69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c6f:	75 13                	jne    800c84 <memmove+0x45>
  800c71:	f6 c1 03             	test   $0x3,%cl
  800c74:	75 0e                	jne    800c84 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800c76:	83 ef 04             	sub    $0x4,%edi
  800c79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c7c:	c1 e9 02             	shr    $0x2,%ecx
  800c7f:	fd                   	std    
  800c80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c82:	eb 09                	jmp    800c8d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c84:	83 ef 01             	sub    $0x1,%edi
  800c87:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c8a:	fd                   	std    
  800c8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c8d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c8e:	eb 20                	jmp    800cb0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c90:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c96:	75 15                	jne    800cad <memmove+0x6e>
  800c98:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c9e:	75 0d                	jne    800cad <memmove+0x6e>
  800ca0:	f6 c1 03             	test   $0x3,%cl
  800ca3:	75 08                	jne    800cad <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ca5:	c1 e9 02             	shr    $0x2,%ecx
  800ca8:	fc                   	cld    
  800ca9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cab:	eb 03                	jmp    800cb0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cad:	fc                   	cld    
  800cae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb0:	8b 34 24             	mov    (%esp),%esi
  800cb3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800cb7:	89 ec                	mov    %ebp,%esp
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 04 24             	mov    %eax,(%esp)
  800cd5:	e8 65 ff ff ff       	call   800c3f <memmove>
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ceb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf0:	eb 1c                	jmp    800d0e <memcmp+0x32>
		if (*s1 != *s2)
  800cf2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800cf6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800cfa:	83 c2 01             	add    $0x1,%edx
  800cfd:	83 e9 01             	sub    $0x1,%ecx
  800d00:	38 d8                	cmp    %bl,%al
  800d02:	74 0a                	je     800d0e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800d04:	0f b6 c0             	movzbl %al,%eax
  800d07:	0f b6 db             	movzbl %bl,%ebx
  800d0a:	29 d8                	sub    %ebx,%eax
  800d0c:	eb 09                	jmp    800d17 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0e:	85 c9                	test   %ecx,%ecx
  800d10:	75 e0                	jne    800cf2 <memcmp+0x16>
  800d12:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d25:	89 c2                	mov    %eax,%edx
  800d27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d2a:	eb 07                	jmp    800d33 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d2c:	38 08                	cmp    %cl,(%eax)
  800d2e:	74 07                	je     800d37 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d30:	83 c0 01             	add    $0x1,%eax
  800d33:	39 d0                	cmp    %edx,%eax
  800d35:	72 f5                	jb     800d2c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 04             	sub    $0x4,%esp
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d48:	eb 03                	jmp    800d4d <strtol+0x14>
		s++;
  800d4a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4d:	0f b6 02             	movzbl (%edx),%eax
  800d50:	3c 20                	cmp    $0x20,%al
  800d52:	74 f6                	je     800d4a <strtol+0x11>
  800d54:	3c 09                	cmp    $0x9,%al
  800d56:	74 f2                	je     800d4a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d58:	3c 2b                	cmp    $0x2b,%al
  800d5a:	75 0c                	jne    800d68 <strtol+0x2f>
		s++;
  800d5c:	8d 52 01             	lea    0x1(%edx),%edx
  800d5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d66:	eb 15                	jmp    800d7d <strtol+0x44>
	else if (*s == '-')
  800d68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d6f:	3c 2d                	cmp    $0x2d,%al
  800d71:	75 0a                	jne    800d7d <strtol+0x44>
		s++, neg = 1;
  800d73:	8d 52 01             	lea    0x1(%edx),%edx
  800d76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7d:	85 db                	test   %ebx,%ebx
  800d7f:	0f 94 c0             	sete   %al
  800d82:	74 05                	je     800d89 <strtol+0x50>
  800d84:	83 fb 10             	cmp    $0x10,%ebx
  800d87:	75 15                	jne    800d9e <strtol+0x65>
  800d89:	80 3a 30             	cmpb   $0x30,(%edx)
  800d8c:	75 10                	jne    800d9e <strtol+0x65>
  800d8e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d92:	75 0a                	jne    800d9e <strtol+0x65>
		s += 2, base = 16;
  800d94:	83 c2 02             	add    $0x2,%edx
  800d97:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9c:	eb 13                	jmp    800db1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d9e:	84 c0                	test   %al,%al
  800da0:	74 0f                	je     800db1 <strtol+0x78>
  800da2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800da7:	80 3a 30             	cmpb   $0x30,(%edx)
  800daa:	75 05                	jne    800db1 <strtol+0x78>
		s++, base = 8;
  800dac:	83 c2 01             	add    $0x1,%edx
  800daf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800db1:	b8 00 00 00 00       	mov    $0x0,%eax
  800db6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800db8:	0f b6 0a             	movzbl (%edx),%ecx
  800dbb:	89 cf                	mov    %ecx,%edi
  800dbd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800dc0:	80 fb 09             	cmp    $0x9,%bl
  800dc3:	77 08                	ja     800dcd <strtol+0x94>
			dig = *s - '0';
  800dc5:	0f be c9             	movsbl %cl,%ecx
  800dc8:	83 e9 30             	sub    $0x30,%ecx
  800dcb:	eb 1e                	jmp    800deb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800dcd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800dd0:	80 fb 19             	cmp    $0x19,%bl
  800dd3:	77 08                	ja     800ddd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800dd5:	0f be c9             	movsbl %cl,%ecx
  800dd8:	83 e9 57             	sub    $0x57,%ecx
  800ddb:	eb 0e                	jmp    800deb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800ddd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800de0:	80 fb 19             	cmp    $0x19,%bl
  800de3:	77 15                	ja     800dfa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800de5:	0f be c9             	movsbl %cl,%ecx
  800de8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800deb:	39 f1                	cmp    %esi,%ecx
  800ded:	7d 0b                	jge    800dfa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800def:	83 c2 01             	add    $0x1,%edx
  800df2:	0f af c6             	imul   %esi,%eax
  800df5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800df8:	eb be                	jmp    800db8 <strtol+0x7f>
  800dfa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800dfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e00:	74 05                	je     800e07 <strtol+0xce>
		*endptr = (char *) s;
  800e02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e07:	89 ca                	mov    %ecx,%edx
  800e09:	f7 da                	neg    %edx
  800e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e0f:	0f 45 c2             	cmovne %edx,%eax
}
  800e12:	83 c4 04             	add    $0x4,%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
	...

00800e1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	89 1c 24             	mov    %ebx,(%esp)
  800e25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e32:	b8 01 00 00 00       	mov    $0x1,%eax
  800e37:	89 d1                	mov    %edx,%ecx
  800e39:	89 d3                	mov    %edx,%ebx
  800e3b:	89 d7                	mov    %edx,%edi
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e41:	8b 1c 24             	mov    (%esp),%ebx
  800e44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e4c:	89 ec                	mov    %ebp,%esp
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	89 1c 24             	mov    %ebx,(%esp)
  800e59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e61:	b8 00 00 00 00       	mov    $0x0,%eax
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	89 c3                	mov    %eax,%ebx
  800e6e:	89 c7                	mov    %eax,%edi
  800e70:	89 c6                	mov    %eax,%esi
  800e72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e74:	8b 1c 24             	mov    (%esp),%ebx
  800e77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e7f:	89 ec                	mov    %ebp,%esp
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	89 1c 24             	mov    %ebx,(%esp)
  800e8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e94:	ba 00 00 00 00       	mov    $0x0,%edx
  800e99:	b8 10 00 00 00       	mov    $0x10,%eax
  800e9e:	89 d1                	mov    %edx,%ecx
  800ea0:	89 d3                	mov    %edx,%ebx
  800ea2:	89 d7                	mov    %edx,%edi
  800ea4:	89 d6                	mov    %edx,%esi
  800ea6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ea8:	8b 1c 24             	mov    (%esp),%ebx
  800eab:	8b 74 24 04          	mov    0x4(%esp),%esi
  800eaf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eb3:	89 ec                	mov    %ebp,%esp
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 38             	sub    $0x38,%esp
  800ebd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	89 df                	mov    %ebx,%edi
  800ed8:	89 de                	mov    %ebx,%esi
  800eda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7e 28                	jle    800f08 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  800f03:	e8 74 f4 ff ff       	call   80037c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800f08:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f0b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f0e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f11:	89 ec                	mov    %ebp,%esp
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 38             	sub    $0x38,%esp
  800f1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	89 df                	mov    %ebx,%edi
  800f36:	89 de                	mov    %ebx,%esi
  800f38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	7e 28                	jle    800f66 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f42:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f49:	00 
  800f4a:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  800f51:	00 
  800f52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f59:	00 
  800f5a:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  800f61:	e8 16 f4 ff ff       	call   80037c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800f66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f6f:	89 ec                	mov    %ebp,%esp
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 38             	sub    $0x38,%esp
  800f79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 cb                	mov    %ecx,%ebx
  800f91:	89 cf                	mov    %ecx,%edi
  800f93:	89 ce                	mov    %ecx,%esi
  800f95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7e 28                	jle    800fc3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fa6:	00 
  800fa7:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  800fae:	00 
  800faf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb6:	00 
  800fb7:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  800fbe:	e8 b9 f3 ff ff       	call   80037c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fcc:	89 ec                	mov    %ebp,%esp
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	89 1c 24             	mov    %ebx,(%esp)
  800fd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe1:	be 00 00 00 00       	mov    $0x0,%esi
  800fe6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800feb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff9:	8b 1c 24             	mov    (%esp),%ebx
  800ffc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801000:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801004:	89 ec                	mov    %ebp,%esp
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 38             	sub    $0x38,%esp
  80100e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801011:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801014:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801017:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	89 df                	mov    %ebx,%edi
  801029:	89 de                	mov    %ebx,%esi
  80102b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102d:	85 c0                	test   %eax,%eax
  80102f:	7e 28                	jle    801059 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801031:	89 44 24 10          	mov    %eax,0x10(%esp)
  801035:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80103c:	00 
  80103d:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  801044:	00 
  801045:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104c:	00 
  80104d:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  801054:	e8 23 f3 ff ff       	call   80037c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801059:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80105c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80105f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801062:	89 ec                	mov    %ebp,%esp
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 38             	sub    $0x38,%esp
  80106c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80106f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801072:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801075:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107a:	b8 09 00 00 00       	mov    $0x9,%eax
  80107f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 df                	mov    %ebx,%edi
  801087:	89 de                	mov    %ebx,%esi
  801089:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108b:	85 c0                	test   %eax,%eax
  80108d:	7e 28                	jle    8010b7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80108f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801093:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80109a:	00 
  80109b:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  8010a2:	00 
  8010a3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010aa:	00 
  8010ab:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8010b2:	e8 c5 f2 ff ff       	call   80037c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c0:	89 ec                	mov    %ebp,%esp
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 38             	sub    $0x38,%esp
  8010ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	89 de                	mov    %ebx,%esi
  8010e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	7e 28                	jle    801115 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010f8:	00 
  8010f9:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  801100:	00 
  801101:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801108:	00 
  801109:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  801110:	e8 67 f2 ff ff       	call   80037c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801115:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801118:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80111b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80111e:	89 ec                	mov    %ebp,%esp
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    

00801122 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 38             	sub    $0x38,%esp
  801128:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80112b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80112e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801131:	bb 00 00 00 00       	mov    $0x0,%ebx
  801136:	b8 06 00 00 00       	mov    $0x6,%eax
  80113b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113e:	8b 55 08             	mov    0x8(%ebp),%edx
  801141:	89 df                	mov    %ebx,%edi
  801143:	89 de                	mov    %ebx,%esi
  801145:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801147:	85 c0                	test   %eax,%eax
  801149:	7e 28                	jle    801173 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801156:	00 
  801157:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  80115e:	00 
  80115f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801166:	00 
  801167:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  80116e:	e8 09 f2 ff ff       	call   80037c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801173:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801176:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801179:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80117c:	89 ec                	mov    %ebp,%esp
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 38             	sub    $0x38,%esp
  801186:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801189:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80118c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80118f:	b8 05 00 00 00       	mov    $0x5,%eax
  801194:	8b 75 18             	mov    0x18(%ebp),%esi
  801197:	8b 7d 14             	mov    0x14(%ebp),%edi
  80119a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80119d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	7e 28                	jle    8011d1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011b4:	00 
  8011b5:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  8011bc:	00 
  8011bd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c4:	00 
  8011c5:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8011cc:	e8 ab f1 ff ff       	call   80037c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011d4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011da:	89 ec                	mov    %ebp,%esp
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 38             	sub    $0x38,%esp
  8011e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ed:	be 00 00 00 00       	mov    $0x0,%esi
  8011f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801200:	89 f7                	mov    %esi,%edi
  801202:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801204:	85 c0                	test   %eax,%eax
  801206:	7e 28                	jle    801230 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801208:	89 44 24 10          	mov    %eax,0x10(%esp)
  80120c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801213:	00 
  801214:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  80121b:	00 
  80121c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801223:	00 
  801224:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  80122b:	e8 4c f1 ff ff       	call   80037c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801230:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801233:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801236:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801239:	89 ec                	mov    %ebp,%esp
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	89 1c 24             	mov    %ebx,(%esp)
  801246:	89 74 24 04          	mov    %esi,0x4(%esp)
  80124a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124e:	ba 00 00 00 00       	mov    $0x0,%edx
  801253:	b8 0b 00 00 00       	mov    $0xb,%eax
  801258:	89 d1                	mov    %edx,%ecx
  80125a:	89 d3                	mov    %edx,%ebx
  80125c:	89 d7                	mov    %edx,%edi
  80125e:	89 d6                	mov    %edx,%esi
  801260:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801262:	8b 1c 24             	mov    (%esp),%ebx
  801265:	8b 74 24 04          	mov    0x4(%esp),%esi
  801269:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80126d:	89 ec                	mov    %ebp,%esp
  80126f:	5d                   	pop    %ebp
  801270:	c3                   	ret    

00801271 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 0c             	sub    $0xc,%esp
  801277:	89 1c 24             	mov    %ebx,(%esp)
  80127a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801282:	ba 00 00 00 00       	mov    $0x0,%edx
  801287:	b8 02 00 00 00       	mov    $0x2,%eax
  80128c:	89 d1                	mov    %edx,%ecx
  80128e:	89 d3                	mov    %edx,%ebx
  801290:	89 d7                	mov    %edx,%edi
  801292:	89 d6                	mov    %edx,%esi
  801294:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801296:	8b 1c 24             	mov    (%esp),%ebx
  801299:	8b 74 24 04          	mov    0x4(%esp),%esi
  80129d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012a1:	89 ec                	mov    %ebp,%esp
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    

008012a5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 38             	sub    $0x38,%esp
  8012ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8012be:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c1:	89 cb                	mov    %ecx,%ebx
  8012c3:	89 cf                	mov    %ecx,%edi
  8012c5:	89 ce                	mov    %ecx,%esi
  8012c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	7e 28                	jle    8012f5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012d8:	00 
  8012d9:	c7 44 24 08 c7 33 80 	movl   $0x8033c7,0x8(%esp)
  8012e0:	00 
  8012e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e8:	00 
  8012e9:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8012f0:	e8 87 f0 ff ff       	call   80037c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012fe:	89 ec                	mov    %ebp,%esp
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    
	...

00801304 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80130a:	c7 44 24 08 f2 33 80 	movl   $0x8033f2,0x8(%esp)
  801311:	00 
  801312:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801319:	00 
  80131a:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801321:	e8 56 f0 ff ff       	call   80037c <_panic>

00801326 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80132f:	c7 04 24 94 15 80 00 	movl   $0x801594,(%esp)
  801336:	e8 79 17 00 00       	call   802ab4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80133b:	ba 07 00 00 00       	mov    $0x7,%edx
  801340:	89 d0                	mov    %edx,%eax
  801342:	cd 30                	int    $0x30
  801344:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801347:	85 c0                	test   %eax,%eax
  801349:	79 20                	jns    80136b <fork+0x45>
		panic("sys_exofork: %e", envid);
  80134b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134f:	c7 44 24 08 13 34 80 	movl   $0x803413,0x8(%esp)
  801356:	00 
  801357:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80135e:	00 
  80135f:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  801366:	e8 11 f0 ff ff       	call   80037c <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80136b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801372:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801377:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80137b:	75 21                	jne    80139e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80137d:	e8 ef fe ff ff       	call   801271 <sys_getenvid>
  801382:	25 ff 03 00 00       	and    $0x3ff,%eax
  801387:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80138a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80138f:	a3 08 50 80 00       	mov    %eax,0x805008
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801399:	e9 e5 01 00 00       	jmp    801583 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80139e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013a1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8013a8:	a8 01                	test   $0x1,%al
  8013aa:	0f 84 4c 01 00 00    	je     8014fc <fork+0x1d6>
  8013b0:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  8013b6:	0f 84 cf 01 00 00    	je     80158b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  8013bc:	c1 e2 16             	shl    $0x16,%edx
  8013bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  8013c2:	89 d3                	mov    %edx,%ebx
  8013c4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013cb:	00 
  8013cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013d3:	89 04 24             	mov    %eax,(%esp)
  8013d6:	e8 03 fe ff ff       	call   8011de <sys_page_alloc>
			if(ret < 0) return ret;
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	0f 88 a0 01 00 00    	js     801583 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  8013e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8013ea:	89 14 24             	mov    %edx,(%esp)
  8013ed:	e8 30 fd ff ff       	call   801122 <sys_page_unmap>
			if(ret < 0) return ret;
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	0f 88 89 01 00 00    	js     801583 <fork+0x25d>
  8013fa:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8013ff:	89 de                	mov    %ebx,%esi
  801401:	c1 e6 0c             	shl    $0xc,%esi
  801404:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801407:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80140d:	0f 84 da 00 00 00    	je     8014ed <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801413:	c1 ee 0c             	shr    $0xc,%esi
  801416:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801419:	a8 01                	test   $0x1,%al
  80141b:	0f 84 cc 00 00 00    	je     8014ed <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801421:	89 f0                	mov    %esi,%eax
  801423:	c1 e0 0c             	shl    $0xc,%eax
  801426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801429:	e8 43 fe ff ff       	call   801271 <sys_getenvid>
  80142e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801431:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801434:	89 c6                	mov    %eax,%esi
  801436:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80143c:	25 01 04 00 00       	and    $0x401,%eax
  801441:	3d 01 04 00 00       	cmp    $0x401,%eax
  801446:	75 3a                	jne    801482 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801448:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80144f:	00 
  801450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801453:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801457:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80145a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80145e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801462:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801465:	89 14 24             	mov    %edx,(%esp)
  801468:	e8 13 fd ff ff       	call   801180 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80146d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801470:	89 44 24 04          	mov    %eax,0x4(%esp)
  801474:	c7 04 24 23 34 80 00 	movl   $0x803423,(%esp)
  80147b:	e8 b5 ef ff ff       	call   800435 <cprintf>
  801480:	eb 6b                	jmp    8014ed <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801482:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801488:	74 14                	je     80149e <fork+0x178>
  80148a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801490:	74 0c                	je     80149e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801492:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801498:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80149e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8014a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014b7:	89 14 24             	mov    %edx,(%esp)
  8014ba:	e8 c1 fc ff ff       	call   801180 <sys_page_map>
	if(ret<0) return ret;
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	0f 88 bc 00 00 00    	js     801583 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  8014c7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8014cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014d5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014dd:	89 14 24             	mov    %edx,(%esp)
  8014e0:	e8 9b fc ff ff       	call   801180 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	0f 88 96 00 00 00    	js     801583 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  8014ed:	83 c3 01             	add    $0x1,%ebx
  8014f0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8014f6:	0f 85 03 ff ff ff    	jne    8013ff <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8014fc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801500:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801507:	0f 85 91 fe ff ff    	jne    80139e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80150d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801514:	00 
  801515:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80151c:	ee 
  80151d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801520:	89 04 24             	mov    %eax,(%esp)
  801523:	e8 b6 fc ff ff       	call   8011de <sys_page_alloc>
	if(ret < 0) return ret;
  801528:	85 c0                	test   %eax,%eax
  80152a:	78 57                	js     801583 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80152c:	a1 08 50 80 00       	mov    0x805008,%eax
  801531:	8b 40 64             	mov    0x64(%eax),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80153b:	89 14 24             	mov    %edx,(%esp)
  80153e:	e8 c5 fa ff ff       	call   801008 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801543:	85 c0                	test   %eax,%eax
  801545:	78 3c                	js     801583 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801547:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80154e:	00 
  80154f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801552:	89 04 24             	mov    %eax,(%esp)
  801555:	e8 6a fb ff ff       	call   8010c4 <sys_env_set_status>
  80155a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80155c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80155f:	85 d2                	test   %edx,%edx
  801561:	79 20                	jns    801583 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801563:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801567:	c7 44 24 08 3a 34 80 	movl   $0x80343a,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801576:	00 
  801577:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  80157e:	e8 f9 ed ff ff       	call   80037c <_panic>

	return envid;
}
  801583:	83 c4 4c             	add    $0x4c,%esp
  801586:	5b                   	pop    %ebx
  801587:	5e                   	pop    %esi
  801588:	5f                   	pop    %edi
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80158b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80158f:	e9 0a fe ff ff       	jmp    80139e <fork+0x78>

00801594 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	56                   	push   %esi
  801598:	53                   	push   %ebx
  801599:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80159c:	e8 d0 fc ff ff       	call   801271 <sys_getenvid>
  8015a1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	89 c6                	mov    %eax,%esi
  8015aa:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  8015ad:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8015b4:	f6 c2 02             	test   $0x2,%dl
  8015b7:	75 2c                	jne    8015e5 <pgfault+0x51>
  8015b9:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8015c0:	f6 c6 08             	test   $0x8,%dh
  8015c3:	75 20                	jne    8015e5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  8015c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015c9:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  8015d0:	00 
  8015d1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8015d8:	00 
  8015d9:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  8015e0:	e8 97 ed ff ff       	call   80037c <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8015e5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015ec:	00 
  8015ed:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8015f4:	00 
  8015f5:	89 1c 24             	mov    %ebx,(%esp)
  8015f8:	e8 e1 fb ff ff       	call   8011de <sys_page_alloc>
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	79 20                	jns    801621 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801601:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801605:	c7 44 24 08 51 34 80 	movl   $0x803451,0x8(%esp)
  80160c:	00 
  80160d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801614:	00 
  801615:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  80161c:	e8 5b ed ff ff       	call   80037c <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801621:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801624:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80162b:	00 
  80162c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801630:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801637:	e8 03 f6 ff ff       	call   800c3f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80163c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801643:	00 
  801644:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801648:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80164c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801653:	00 
  801654:	89 1c 24             	mov    %ebx,(%esp)
  801657:	e8 24 fb ff ff       	call   801180 <sys_page_map>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	79 20                	jns    801680 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801660:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801664:	c7 44 24 08 63 34 80 	movl   $0x803463,0x8(%esp)
  80166b:	00 
  80166c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801673:	00 
  801674:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  80167b:	e8 fc ec ff ff       	call   80037c <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801680:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801687:	00 
  801688:	89 1c 24             	mov    %ebx,(%esp)
  80168b:	e8 92 fa ff ff       	call   801122 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801690:	85 c0                	test   %eax,%eax
  801692:	74 20                	je     8016b4 <pgfault+0x120>
  801694:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801698:	c7 44 24 08 73 34 80 	movl   $0x803473,0x8(%esp)
  80169f:	00 
  8016a0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8016a7:	00 
  8016a8:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  8016af:	e8 c8 ec ff ff       	call   80037c <_panic>

}
  8016b4:	83 c4 20             	add    $0x20,%esp
  8016b7:	5b                   	pop    %ebx
  8016b8:	5e                   	pop    %esi
  8016b9:	5d                   	pop    %ebp
  8016ba:	c3                   	ret    
	...

008016bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	05 00 00 00 30       	add    $0x30000000,%eax
  8016c7:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 04 24             	mov    %eax,(%esp)
  8016d8:	e8 df ff ff ff       	call   8016bc <fd2num>
  8016dd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8016e2:	c1 e0 0c             	shl    $0xc,%eax
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	57                   	push   %edi
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016f5:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8016fa:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016ff:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801701:	89 c2                	mov    %eax,%edx
  801703:	c1 ea 16             	shr    $0x16,%edx
  801706:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801709:	f6 c2 01             	test   $0x1,%dl
  80170c:	74 0d                	je     80171b <fd_alloc+0x34>
  80170e:	89 c2                	mov    %eax,%edx
  801710:	c1 ea 0c             	shr    $0xc,%edx
  801713:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801716:	f6 c2 01             	test   $0x1,%dl
  801719:	75 09                	jne    801724 <fd_alloc+0x3d>
			*fd_store = fd;
  80171b:	89 37                	mov    %esi,(%edi)
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801722:	eb 17                	jmp    80173b <fd_alloc+0x54>
  801724:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801729:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80172e:	75 cf                	jne    8016ff <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801730:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801736:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  80173b:	5b                   	pop    %ebx
  80173c:	5e                   	pop    %esi
  80173d:	5f                   	pop    %edi
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	83 f8 1f             	cmp    $0x1f,%eax
  801749:	77 36                	ja     801781 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80174b:	05 00 00 0d 00       	add    $0xd0000,%eax
  801750:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801753:	89 c2                	mov    %eax,%edx
  801755:	c1 ea 16             	shr    $0x16,%edx
  801758:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80175f:	f6 c2 01             	test   $0x1,%dl
  801762:	74 1d                	je     801781 <fd_lookup+0x41>
  801764:	89 c2                	mov    %eax,%edx
  801766:	c1 ea 0c             	shr    $0xc,%edx
  801769:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801770:	f6 c2 01             	test   $0x1,%dl
  801773:	74 0c                	je     801781 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	89 02                	mov    %eax,(%edx)
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80177f:	eb 05                	jmp    801786 <fd_lookup+0x46>
  801781:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80178e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801791:	89 44 24 04          	mov    %eax,0x4(%esp)
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	89 04 24             	mov    %eax,(%esp)
  80179b:	e8 a0 ff ff ff       	call   801740 <fd_lookup>
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 0e                	js     8017b2 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017aa:	89 50 04             	mov    %edx,0x4(%eax)
  8017ad:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 10             	sub    $0x10,%esp
  8017bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8017c7:	be 2c 35 80 00       	mov    $0x80352c,%esi
  8017cc:	eb 10                	jmp    8017de <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8017ce:	39 08                	cmp    %ecx,(%eax)
  8017d0:	75 09                	jne    8017db <dev_lookup+0x27>
			*dev = devtab[i];
  8017d2:	89 03                	mov    %eax,(%ebx)
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8017d9:	eb 31                	jmp    80180c <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017db:	83 c2 01             	add    $0x1,%edx
  8017de:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	75 e9                	jne    8017ce <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017e5:	a1 08 50 80 00       	mov    0x805008,%eax
  8017ea:	8b 40 48             	mov    0x48(%eax),%eax
  8017ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f5:	c7 04 24 ac 34 80 00 	movl   $0x8034ac,(%esp)
  8017fc:	e8 34 ec ff ff       	call   800435 <cprintf>
	*dev = 0;
  801801:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	53                   	push   %ebx
  801817:	83 ec 24             	sub    $0x24,%esp
  80181a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801820:	89 44 24 04          	mov    %eax,0x4(%esp)
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 04 24             	mov    %eax,(%esp)
  80182a:	e8 11 ff ff ff       	call   801740 <fd_lookup>
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 53                	js     801886 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801836:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	89 04 24             	mov    %eax,(%esp)
  801842:	e8 6d ff ff ff       	call   8017b4 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801847:	85 c0                	test   %eax,%eax
  801849:	78 3b                	js     801886 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  80184b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801853:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801857:	74 2d                	je     801886 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801859:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80185c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801863:	00 00 00 
	stat->st_isdir = 0;
  801866:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80186d:	00 00 00 
	stat->st_dev = dev;
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801879:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80187d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801880:	89 14 24             	mov    %edx,(%esp)
  801883:	ff 50 14             	call   *0x14(%eax)
}
  801886:	83 c4 24             	add    $0x24,%esp
  801889:	5b                   	pop    %ebx
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	53                   	push   %ebx
  801890:	83 ec 24             	sub    $0x24,%esp
  801893:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801896:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801899:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189d:	89 1c 24             	mov    %ebx,(%esp)
  8018a0:	e8 9b fe ff ff       	call   801740 <fd_lookup>
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 5f                	js     801908 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	89 04 24             	mov    %eax,(%esp)
  8018b8:	e8 f7 fe ff ff       	call   8017b4 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	78 47                	js     801908 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c4:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018c8:	75 23                	jne    8018ed <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018ca:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018cf:	8b 40 48             	mov    0x48(%eax),%eax
  8018d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018da:	c7 04 24 cc 34 80 00 	movl   $0x8034cc,(%esp)
  8018e1:	e8 4f eb ff ff       	call   800435 <cprintf>
  8018e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018eb:	eb 1b                	jmp    801908 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f0:	8b 48 18             	mov    0x18(%eax),%ecx
  8018f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f8:	85 c9                	test   %ecx,%ecx
  8018fa:	74 0c                	je     801908 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801903:	89 14 24             	mov    %edx,(%esp)
  801906:	ff d1                	call   *%ecx
}
  801908:	83 c4 24             	add    $0x24,%esp
  80190b:	5b                   	pop    %ebx
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	53                   	push   %ebx
  801912:	83 ec 24             	sub    $0x24,%esp
  801915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801918:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	89 1c 24             	mov    %ebx,(%esp)
  801922:	e8 19 fe ff ff       	call   801740 <fd_lookup>
  801927:	85 c0                	test   %eax,%eax
  801929:	78 66                	js     801991 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	8b 00                	mov    (%eax),%eax
  801937:	89 04 24             	mov    %eax,(%esp)
  80193a:	e8 75 fe ff ff       	call   8017b4 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 4e                	js     801991 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801943:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801946:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80194a:	75 23                	jne    80196f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80194c:	a1 08 50 80 00       	mov    0x805008,%eax
  801951:	8b 40 48             	mov    0x48(%eax),%eax
  801954:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	c7 04 24 f0 34 80 00 	movl   $0x8034f0,(%esp)
  801963:	e8 cd ea ff ff       	call   800435 <cprintf>
  801968:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  80196d:	eb 22                	jmp    801991 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801972:	8b 48 0c             	mov    0xc(%eax),%ecx
  801975:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80197a:	85 c9                	test   %ecx,%ecx
  80197c:	74 13                	je     801991 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80197e:	8b 45 10             	mov    0x10(%ebp),%eax
  801981:	89 44 24 08          	mov    %eax,0x8(%esp)
  801985:	8b 45 0c             	mov    0xc(%ebp),%eax
  801988:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198c:	89 14 24             	mov    %edx,(%esp)
  80198f:	ff d1                	call   *%ecx
}
  801991:	83 c4 24             	add    $0x24,%esp
  801994:	5b                   	pop    %ebx
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 24             	sub    $0x24,%esp
  80199e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a8:	89 1c 24             	mov    %ebx,(%esp)
  8019ab:	e8 90 fd ff ff       	call   801740 <fd_lookup>
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	78 6b                	js     801a1f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019be:	8b 00                	mov    (%eax),%eax
  8019c0:	89 04 24             	mov    %eax,(%esp)
  8019c3:	e8 ec fd ff ff       	call   8017b4 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 53                	js     801a1f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019cf:	8b 42 08             	mov    0x8(%edx),%eax
  8019d2:	83 e0 03             	and    $0x3,%eax
  8019d5:	83 f8 01             	cmp    $0x1,%eax
  8019d8:	75 23                	jne    8019fd <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019da:	a1 08 50 80 00       	mov    0x805008,%eax
  8019df:	8b 40 48             	mov    0x48(%eax),%eax
  8019e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ea:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  8019f1:	e8 3f ea ff ff       	call   800435 <cprintf>
  8019f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019fb:	eb 22                	jmp    801a1f <read+0x88>
	}
	if (!dev->dev_read)
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	8b 48 08             	mov    0x8(%eax),%ecx
  801a03:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a08:	85 c9                	test   %ecx,%ecx
  801a0a:	74 13                	je     801a1f <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1a:	89 14 24             	mov    %edx,(%esp)
  801a1d:	ff d1                	call   *%ecx
}
  801a1f:	83 c4 24             	add    $0x24,%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    

00801a25 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	57                   	push   %edi
  801a29:	56                   	push   %esi
  801a2a:	53                   	push   %ebx
  801a2b:	83 ec 1c             	sub    $0x1c,%esp
  801a2e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a31:	8b 75 10             	mov    0x10(%ebp),%esi
  801a34:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a39:	eb 21                	jmp    801a5c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a3b:	89 f2                	mov    %esi,%edx
  801a3d:	29 c2                	sub    %eax,%edx
  801a3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a43:	03 45 0c             	add    0xc(%ebp),%eax
  801a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4a:	89 3c 24             	mov    %edi,(%esp)
  801a4d:	e8 45 ff ff ff       	call   801997 <read>
		if (m < 0)
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 0e                	js     801a64 <readn+0x3f>
			return m;
		if (m == 0)
  801a56:	85 c0                	test   %eax,%eax
  801a58:	74 08                	je     801a62 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a5a:	01 c3                	add    %eax,%ebx
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	39 f3                	cmp    %esi,%ebx
  801a60:	72 d9                	jb     801a3b <readn+0x16>
  801a62:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a64:	83 c4 1c             	add    $0x1c,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5f                   	pop    %edi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    

00801a6c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 38             	sub    $0x38,%esp
  801a72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a78:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a7e:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a82:	89 3c 24             	mov    %edi,(%esp)
  801a85:	e8 32 fc ff ff       	call   8016bc <fd2num>
  801a8a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801a8d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a91:	89 04 24             	mov    %eax,(%esp)
  801a94:	e8 a7 fc ff ff       	call   801740 <fd_lookup>
  801a99:	89 c3                	mov    %eax,%ebx
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 05                	js     801aa4 <fd_close+0x38>
  801a9f:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801aa2:	74 0e                	je     801ab2 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801aa4:	89 f0                	mov    %esi,%eax
  801aa6:	84 c0                	test   %al,%al
  801aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aad:	0f 44 d8             	cmove  %eax,%ebx
  801ab0:	eb 3d                	jmp    801aef <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ab2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab9:	8b 07                	mov    (%edi),%eax
  801abb:	89 04 24             	mov    %eax,(%esp)
  801abe:	e8 f1 fc ff ff       	call   8017b4 <dev_lookup>
  801ac3:	89 c3                	mov    %eax,%ebx
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	78 16                	js     801adf <fd_close+0x73>
		if (dev->dev_close)
  801ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acc:	8b 40 10             	mov    0x10(%eax),%eax
  801acf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	74 07                	je     801adf <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801ad8:	89 3c 24             	mov    %edi,(%esp)
  801adb:	ff d0                	call   *%eax
  801add:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801adf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ae3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aea:	e8 33 f6 ff ff       	call   801122 <sys_page_unmap>
	return r;
}
  801aef:	89 d8                	mov    %ebx,%eax
  801af1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801af4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801af7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801afa:	89 ec                	mov    %ebp,%esp
  801afc:	5d                   	pop    %ebp
  801afd:	c3                   	ret    

00801afe <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 2a fc ff ff       	call   801740 <fd_lookup>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 13                	js     801b2d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b21:	00 
  801b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b25:	89 04 24             	mov    %eax,(%esp)
  801b28:	e8 3f ff ff ff       	call   801a6c <fd_close>
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 18             	sub    $0x18,%esp
  801b35:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b38:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b42:	00 
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	89 04 24             	mov    %eax,(%esp)
  801b49:	e8 25 04 00 00       	call   801f73 <open>
  801b4e:	89 c3                	mov    %eax,%ebx
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 1b                	js     801b6f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5b:	89 1c 24             	mov    %ebx,(%esp)
  801b5e:	e8 b0 fc ff ff       	call   801813 <fstat>
  801b63:	89 c6                	mov    %eax,%esi
	close(fd);
  801b65:	89 1c 24             	mov    %ebx,(%esp)
  801b68:	e8 91 ff ff ff       	call   801afe <close>
  801b6d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801b6f:	89 d8                	mov    %ebx,%eax
  801b71:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b74:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b77:	89 ec                	mov    %ebp,%esp
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

00801b7b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	53                   	push   %ebx
  801b7f:	83 ec 14             	sub    $0x14,%esp
  801b82:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801b87:	89 1c 24             	mov    %ebx,(%esp)
  801b8a:	e8 6f ff ff ff       	call   801afe <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b8f:	83 c3 01             	add    $0x1,%ebx
  801b92:	83 fb 20             	cmp    $0x20,%ebx
  801b95:	75 f0                	jne    801b87 <close_all+0xc>
		close(i);
}
  801b97:	83 c4 14             	add    $0x14,%esp
  801b9a:	5b                   	pop    %ebx
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    

00801b9d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 58             	sub    $0x58,%esp
  801ba3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ba6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ba9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bac:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801baf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	89 04 24             	mov    %eax,(%esp)
  801bbc:	e8 7f fb ff ff       	call   801740 <fd_lookup>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	0f 88 e0 00 00 00    	js     801cab <dup+0x10e>
		return r;
	close(newfdnum);
  801bcb:	89 3c 24             	mov    %edi,(%esp)
  801bce:	e8 2b ff ff ff       	call   801afe <close>

	newfd = INDEX2FD(newfdnum);
  801bd3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801bd9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 e5 fa ff ff       	call   8016cc <fd2data>
  801be7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801be9:	89 34 24             	mov    %esi,(%esp)
  801bec:	e8 db fa ff ff       	call   8016cc <fd2data>
  801bf1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801bf4:	89 da                	mov    %ebx,%edx
  801bf6:	89 d8                	mov    %ebx,%eax
  801bf8:	c1 e8 16             	shr    $0x16,%eax
  801bfb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c02:	a8 01                	test   $0x1,%al
  801c04:	74 43                	je     801c49 <dup+0xac>
  801c06:	c1 ea 0c             	shr    $0xc,%edx
  801c09:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c10:	a8 01                	test   $0x1,%al
  801c12:	74 35                	je     801c49 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c14:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c1b:	25 07 0e 00 00       	and    $0xe07,%eax
  801c20:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c32:	00 
  801c33:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c3e:	e8 3d f5 ff ff       	call   801180 <sys_page_map>
  801c43:	89 c3                	mov    %eax,%ebx
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 3f                	js     801c88 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4c:	89 c2                	mov    %eax,%edx
  801c4e:	c1 ea 0c             	shr    $0xc,%edx
  801c51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c58:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c5e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c62:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c6d:	00 
  801c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c79:	e8 02 f5 ff ff       	call   801180 <sys_page_map>
  801c7e:	89 c3                	mov    %eax,%ebx
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 04                	js     801c88 <dup+0xeb>
  801c84:	89 fb                	mov    %edi,%ebx
  801c86:	eb 23                	jmp    801cab <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c88:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c93:	e8 8a f4 ff ff       	call   801122 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca6:	e8 77 f4 ff ff       	call   801122 <sys_page_unmap>
	return r;
}
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cb0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cb3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cb6:	89 ec                	mov    %ebp,%esp
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    
	...

00801cbc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 10             	sub    $0x10,%esp
  801cc4:	89 c3                	mov    %eax,%ebx
  801cc6:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801cc8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ccf:	75 11                	jne    801ce2 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801cd8:	e8 7b 0e 00 00       	call   802b58 <ipc_find_env>
  801cdd:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801ce2:	a1 08 50 80 00       	mov    0x805008,%eax
  801ce7:	8b 40 48             	mov    0x48(%eax),%eax
  801cea:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801cf0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cf4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfc:	c7 04 24 40 35 80 00 	movl   $0x803540,(%esp)
  801d03:	e8 2d e7 ff ff       	call   800435 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d08:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d0f:	00 
  801d10:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d17:	00 
  801d18:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d1c:	a1 00 50 80 00       	mov    0x805000,%eax
  801d21:	89 04 24             	mov    %eax,(%esp)
  801d24:	e8 65 0e 00 00       	call   802b8e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d30:	00 
  801d31:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3c:	e8 b9 0e 00 00       	call   802bfa <ipc_recv>
}
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    

00801d48 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	8b 40 0c             	mov    0xc(%eax),%eax
  801d54:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d61:	ba 00 00 00 00       	mov    $0x0,%edx
  801d66:	b8 02 00 00 00       	mov    $0x2,%eax
  801d6b:	e8 4c ff ff ff       	call   801cbc <fsipc>
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d83:	ba 00 00 00 00       	mov    $0x0,%edx
  801d88:	b8 06 00 00 00       	mov    $0x6,%eax
  801d8d:	e8 2a ff ff ff       	call   801cbc <fsipc>
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9f:	b8 08 00 00 00       	mov    $0x8,%eax
  801da4:	e8 13 ff ff ff       	call   801cbc <fsipc>
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	53                   	push   %ebx
  801daf:	83 ec 14             	sub    $0x14,%esp
  801db2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbb:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc5:	b8 05 00 00 00       	mov    $0x5,%eax
  801dca:	e8 ed fe ff ff       	call   801cbc <fsipc>
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	78 2b                	js     801dfe <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dd3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dda:	00 
  801ddb:	89 1c 24             	mov    %ebx,(%esp)
  801dde:	e8 b6 ec ff ff       	call   800a99 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801de3:	a1 80 60 80 00       	mov    0x806080,%eax
  801de8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dee:	a1 84 60 80 00       	mov    0x806084,%eax
  801df3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801dfe:	83 c4 14             	add    $0x14,%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    

00801e04 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	53                   	push   %ebx
  801e08:	83 ec 14             	sub    $0x14,%esp
  801e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8b 40 0c             	mov    0xc(%eax),%eax
  801e14:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e19:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801e1f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801e25:	76 24                	jbe    801e4b <devfile_write+0x47>
  801e27:	c7 44 24 0c 56 35 80 	movl   $0x803556,0xc(%esp)
  801e2e:	00 
  801e2f:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  801e36:	00 
  801e37:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801e3e:	00 
  801e3f:	c7 04 24 75 35 80 00 	movl   $0x803575,(%esp)
  801e46:	e8 31 e5 ff ff       	call   80037c <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801e4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e56:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e5d:	e8 dd ed ff ff       	call   800c3f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801e62:	ba 00 00 00 00       	mov    $0x0,%edx
  801e67:	b8 04 00 00 00       	mov    $0x4,%eax
  801e6c:	e8 4b fe ff ff       	call   801cbc <fsipc>
	if(ret<0) return ret;
  801e71:	85 c0                	test   %eax,%eax
  801e73:	78 53                	js     801ec8 <devfile_write+0xc4>
	
	assert(ret <= n);
  801e75:	39 c3                	cmp    %eax,%ebx
  801e77:	73 24                	jae    801e9d <devfile_write+0x99>
  801e79:	c7 44 24 0c 80 35 80 	movl   $0x803580,0xc(%esp)
  801e80:	00 
  801e81:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  801e88:	00 
  801e89:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801e90:	00 
  801e91:	c7 04 24 75 35 80 00 	movl   $0x803575,(%esp)
  801e98:	e8 df e4 ff ff       	call   80037c <_panic>
	assert(ret <= PGSIZE);
  801e9d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ea2:	7e 24                	jle    801ec8 <devfile_write+0xc4>
  801ea4:	c7 44 24 0c 89 35 80 	movl   $0x803589,0xc(%esp)
  801eab:	00 
  801eac:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  801eb3:	00 
  801eb4:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801ebb:	00 
  801ebc:	c7 04 24 75 35 80 00 	movl   $0x803575,(%esp)
  801ec3:	e8 b4 e4 ff ff       	call   80037c <_panic>
	return ret;
}
  801ec8:	83 c4 14             	add    $0x14,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    

00801ece <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	56                   	push   %esi
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 10             	sub    $0x10,%esp
  801ed6:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	8b 40 0c             	mov    0xc(%eax),%eax
  801edf:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ee4:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801eea:	ba 00 00 00 00       	mov    $0x0,%edx
  801eef:	b8 03 00 00 00       	mov    $0x3,%eax
  801ef4:	e8 c3 fd ff ff       	call   801cbc <fsipc>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 6b                	js     801f6a <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801eff:	39 de                	cmp    %ebx,%esi
  801f01:	73 24                	jae    801f27 <devfile_read+0x59>
  801f03:	c7 44 24 0c 97 35 80 	movl   $0x803597,0xc(%esp)
  801f0a:	00 
  801f0b:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  801f12:	00 
  801f13:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f1a:	00 
  801f1b:	c7 04 24 75 35 80 00 	movl   $0x803575,(%esp)
  801f22:	e8 55 e4 ff ff       	call   80037c <_panic>
	assert(r <= PGSIZE);
  801f27:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801f2d:	7e 24                	jle    801f53 <devfile_read+0x85>
  801f2f:	c7 44 24 0c 9e 35 80 	movl   $0x80359e,0xc(%esp)
  801f36:	00 
  801f37:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  801f3e:	00 
  801f3f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f46:	00 
  801f47:	c7 04 24 75 35 80 00 	movl   $0x803575,(%esp)
  801f4e:	e8 29 e4 ff ff       	call   80037c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f57:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f5e:	00 
  801f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f62:	89 04 24             	mov    %eax,(%esp)
  801f65:	e8 d5 ec ff ff       	call   800c3f <memmove>
	return r;
}
  801f6a:	89 d8                	mov    %ebx,%eax
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 28             	sub    $0x28,%esp
  801f79:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f7c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801f7f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f82:	89 34 24             	mov    %esi,(%esp)
  801f85:	e8 d6 ea ff ff       	call   800a60 <strlen>
  801f8a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f8f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f94:	7f 5e                	jg     801ff4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f99:	89 04 24             	mov    %eax,(%esp)
  801f9c:	e8 46 f7 ff ff       	call   8016e7 <fd_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 4d                	js     801ff4 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801fa7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fab:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801fb2:	e8 e2 ea ff ff       	call   800a99 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc7:	e8 f0 fc ff ff       	call   801cbc <fsipc>
  801fcc:	89 c3                	mov    %eax,%ebx
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	79 15                	jns    801fe7 <open+0x74>
		fd_close(fd, 0);
  801fd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fd9:	00 
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	89 04 24             	mov    %eax,(%esp)
  801fe0:	e8 87 fa ff ff       	call   801a6c <fd_close>
		return r;
  801fe5:	eb 0d                	jmp    801ff4 <open+0x81>
	}

	return fd2num(fd);
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	89 04 24             	mov    %eax,(%esp)
  801fed:	e8 ca f6 ff ff       	call   8016bc <fd2num>
  801ff2:	89 c3                	mov    %eax,%ebx
}
  801ff4:	89 d8                	mov    %ebx,%eax
  801ff6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ff9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ffc:	89 ec                	mov    %ebp,%esp
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802006:	c7 44 24 04 aa 35 80 	movl   $0x8035aa,0x4(%esp)
  80200d:	00 
  80200e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802011:	89 04 24             	mov    %eax,(%esp)
  802014:	e8 80 ea ff ff       	call   800a99 <strcpy>
	return 0;
}
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	53                   	push   %ebx
  802024:	83 ec 14             	sub    $0x14,%esp
  802027:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80202a:	89 1c 24             	mov    %ebx,(%esp)
  80202d:	e8 52 0c 00 00       	call   802c84 <pageref>
  802032:	89 c2                	mov    %eax,%edx
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
  802039:	83 fa 01             	cmp    $0x1,%edx
  80203c:	75 0b                	jne    802049 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80203e:	8b 43 0c             	mov    0xc(%ebx),%eax
  802041:	89 04 24             	mov    %eax,(%esp)
  802044:	e8 b1 02 00 00       	call   8022fa <nsipc_close>
	else
		return 0;
}
  802049:	83 c4 14             	add    $0x14,%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    

0080204f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802055:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80205c:	00 
  80205d:	8b 45 10             	mov    0x10(%ebp),%eax
  802060:	89 44 24 08          	mov    %eax,0x8(%esp)
  802064:	8b 45 0c             	mov    0xc(%ebp),%eax
  802067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8b 40 0c             	mov    0xc(%eax),%eax
  802071:	89 04 24             	mov    %eax,(%esp)
  802074:	e8 bd 02 00 00       	call   802336 <nsipc_send>
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802081:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802088:	00 
  802089:	8b 45 10             	mov    0x10(%ebp),%eax
  80208c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	89 44 24 04          	mov    %eax,0x4(%esp)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	8b 40 0c             	mov    0xc(%eax),%eax
  80209d:	89 04 24             	mov    %eax,(%esp)
  8020a0:	e8 04 03 00 00       	call   8023a9 <nsipc_recv>
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 20             	sub    $0x20,%esp
  8020af:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b4:	89 04 24             	mov    %eax,(%esp)
  8020b7:	e8 2b f6 ff ff       	call   8016e7 <fd_alloc>
  8020bc:	89 c3                	mov    %eax,%ebx
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 21                	js     8020e3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c9:	00 
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d8:	e8 01 f1 ff ff       	call   8011de <sys_page_alloc>
  8020dd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	79 0a                	jns    8020ed <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8020e3:	89 34 24             	mov    %esi,(%esp)
  8020e6:	e8 0f 02 00 00       	call   8022fa <nsipc_close>
		return r;
  8020eb:	eb 28                	jmp    802115 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020ed:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	89 04 24             	mov    %eax,(%esp)
  80210e:	e8 a9 f5 ff ff       	call   8016bc <fd2num>
  802113:	89 c3                	mov    %eax,%ebx
}
  802115:	89 d8                	mov    %ebx,%eax
  802117:	83 c4 20             	add    $0x20,%esp
  80211a:	5b                   	pop    %ebx
  80211b:	5e                   	pop    %esi
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    

0080211e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802124:	8b 45 10             	mov    0x10(%ebp),%eax
  802127:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	89 04 24             	mov    %eax,(%esp)
  802138:	e8 71 01 00 00       	call   8022ae <nsipc_socket>
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 05                	js     802146 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802141:	e8 61 ff ff ff       	call   8020a7 <alloc_sockfd>
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80214e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802151:	89 54 24 04          	mov    %edx,0x4(%esp)
  802155:	89 04 24             	mov    %eax,(%esp)
  802158:	e8 e3 f5 ff ff       	call   801740 <fd_lookup>
  80215d:	85 c0                	test   %eax,%eax
  80215f:	78 15                	js     802176 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802161:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802164:	8b 0a                	mov    (%edx),%ecx
  802166:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80216b:	3b 0d 24 40 80 00    	cmp    0x804024,%ecx
  802171:	75 03                	jne    802176 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802173:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	e8 c2 ff ff ff       	call   802148 <fd2sockid>
  802186:	85 c0                	test   %eax,%eax
  802188:	78 0f                	js     802199 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80218a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 3f 01 00 00       	call   8022d8 <nsipc_listen>
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	e8 9f ff ff ff       	call   802148 <fd2sockid>
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 16                	js     8021c3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8021ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8021b0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021bb:	89 04 24             	mov    %eax,(%esp)
  8021be:	e8 66 02 00 00       	call   802429 <nsipc_connect>
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	e8 75 ff ff ff       	call   802148 <fd2sockid>
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 0f                	js     8021e6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021de:	89 04 24             	mov    %eax,(%esp)
  8021e1:	e8 2e 01 00 00       	call   802314 <nsipc_shutdown>
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	e8 52 ff ff ff       	call   802148 <fd2sockid>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 16                	js     802210 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8021fa:	8b 55 10             	mov    0x10(%ebp),%edx
  8021fd:	89 54 24 08          	mov    %edx,0x8(%esp)
  802201:	8b 55 0c             	mov    0xc(%ebp),%edx
  802204:	89 54 24 04          	mov    %edx,0x4(%esp)
  802208:	89 04 24             	mov    %eax,(%esp)
  80220b:	e8 58 02 00 00       	call   802468 <nsipc_bind>
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	e8 28 ff ff ff       	call   802148 <fd2sockid>
  802220:	85 c0                	test   %eax,%eax
  802222:	78 1f                	js     802243 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802224:	8b 55 10             	mov    0x10(%ebp),%edx
  802227:	89 54 24 08          	mov    %edx,0x8(%esp)
  80222b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802232:	89 04 24             	mov    %eax,(%esp)
  802235:	e8 6d 02 00 00       	call   8024a7 <nsipc_accept>
  80223a:	85 c0                	test   %eax,%eax
  80223c:	78 05                	js     802243 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80223e:	e8 64 fe ff ff       	call   8020a7 <alloc_sockfd>
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    
  802245:	00 00                	add    %al,(%eax)
	...

00802248 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	53                   	push   %ebx
  80224c:	83 ec 14             	sub    $0x14,%esp
  80224f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802251:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802258:	75 11                	jne    80226b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80225a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802261:	e8 f2 08 00 00       	call   802b58 <ipc_find_env>
  802266:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80226b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802272:	00 
  802273:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80227a:	00 
  80227b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80227f:	a1 04 50 80 00       	mov    0x805004,%eax
  802284:	89 04 24             	mov    %eax,(%esp)
  802287:	e8 02 09 00 00       	call   802b8e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80228c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802293:	00 
  802294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80229b:	00 
  80229c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a3:	e8 52 09 00 00       	call   802bfa <ipc_recv>
}
  8022a8:	83 c4 14             	add    $0x14,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8022c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8022cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8022d1:	e8 72 ff ff ff       	call   802248 <nsipc>
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8022ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8022f3:	e8 50 ff ff ff       	call   802248 <nsipc>
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802308:	b8 04 00 00 00       	mov    $0x4,%eax
  80230d:	e8 36 ff ff ff       	call   802248 <nsipc>
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802322:	8b 45 0c             	mov    0xc(%ebp),%eax
  802325:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80232a:	b8 03 00 00 00       	mov    $0x3,%eax
  80232f:	e8 14 ff ff ff       	call   802248 <nsipc>
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	53                   	push   %ebx
  80233a:	83 ec 14             	sub    $0x14,%esp
  80233d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802348:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80234e:	7e 24                	jle    802374 <nsipc_send+0x3e>
  802350:	c7 44 24 0c b6 35 80 	movl   $0x8035b6,0xc(%esp)
  802357:	00 
  802358:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  80235f:	00 
  802360:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802367:	00 
  802368:	c7 04 24 c2 35 80 00 	movl   $0x8035c2,(%esp)
  80236f:	e8 08 e0 ff ff       	call   80037c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802374:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802386:	e8 b4 e8 ff ff       	call   800c3f <memmove>
	nsipcbuf.send.req_size = size;
  80238b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802391:	8b 45 14             	mov    0x14(%ebp),%eax
  802394:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802399:	b8 08 00 00 00       	mov    $0x8,%eax
  80239e:	e8 a5 fe ff ff       	call   802248 <nsipc>
}
  8023a3:	83 c4 14             	add    $0x14,%esp
  8023a6:	5b                   	pop    %ebx
  8023a7:	5d                   	pop    %ebp
  8023a8:	c3                   	ret    

008023a9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	56                   	push   %esi
  8023ad:	53                   	push   %ebx
  8023ae:	83 ec 10             	sub    $0x10,%esp
  8023b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8023bc:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8023c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023ca:	b8 07 00 00 00       	mov    $0x7,%eax
  8023cf:	e8 74 fe ff ff       	call   802248 <nsipc>
  8023d4:	89 c3                	mov    %eax,%ebx
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	78 46                	js     802420 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023da:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023df:	7f 04                	jg     8023e5 <nsipc_recv+0x3c>
  8023e1:	39 c6                	cmp    %eax,%esi
  8023e3:	7d 24                	jge    802409 <nsipc_recv+0x60>
  8023e5:	c7 44 24 0c ce 35 80 	movl   $0x8035ce,0xc(%esp)
  8023ec:	00 
  8023ed:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  8023f4:	00 
  8023f5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8023fc:	00 
  8023fd:	c7 04 24 c2 35 80 00 	movl   $0x8035c2,(%esp)
  802404:	e8 73 df ff ff       	call   80037c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802409:	89 44 24 08          	mov    %eax,0x8(%esp)
  80240d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802414:	00 
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	89 04 24             	mov    %eax,(%esp)
  80241b:	e8 1f e8 ff ff       	call   800c3f <memmove>
	}

	return r;
}
  802420:	89 d8                	mov    %ebx,%eax
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	5b                   	pop    %ebx
  802426:	5e                   	pop    %esi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    

00802429 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	53                   	push   %ebx
  80242d:	83 ec 14             	sub    $0x14,%esp
  802430:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80243b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80243f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802442:	89 44 24 04          	mov    %eax,0x4(%esp)
  802446:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80244d:	e8 ed e7 ff ff       	call   800c3f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802452:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802458:	b8 05 00 00 00       	mov    $0x5,%eax
  80245d:	e8 e6 fd ff ff       	call   802248 <nsipc>
}
  802462:	83 c4 14             	add    $0x14,%esp
  802465:	5b                   	pop    %ebx
  802466:	5d                   	pop    %ebp
  802467:	c3                   	ret    

00802468 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	53                   	push   %ebx
  80246c:	83 ec 14             	sub    $0x14,%esp
  80246f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80247a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80247e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802481:	89 44 24 04          	mov    %eax,0x4(%esp)
  802485:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80248c:	e8 ae e7 ff ff       	call   800c3f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802491:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802497:	b8 02 00 00 00       	mov    $0x2,%eax
  80249c:	e8 a7 fd ff ff       	call   802248 <nsipc>
}
  8024a1:	83 c4 14             	add    $0x14,%esp
  8024a4:	5b                   	pop    %ebx
  8024a5:	5d                   	pop    %ebp
  8024a6:	c3                   	ret    

008024a7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 28             	sub    $0x28,%esp
  8024ad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8024b0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024b3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024b6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8024c1:	8b 07                	mov    (%edi),%eax
  8024c3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8024c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cd:	e8 76 fd ff ff       	call   802248 <nsipc>
  8024d2:	89 c6                	mov    %eax,%esi
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 22                	js     8024fa <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8024d8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8024dd:	8b 03                	mov    (%ebx),%eax
  8024df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8024ea:	00 
  8024eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ee:	89 04 24             	mov    %eax,(%esp)
  8024f1:	e8 49 e7 ff ff       	call   800c3f <memmove>
		*addrlen = ret->ret_addrlen;
  8024f6:	8b 03                	mov    (%ebx),%eax
  8024f8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8024fa:	89 f0                	mov    %esi,%eax
  8024fc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8024ff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802502:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802505:	89 ec                	mov    %ebp,%esp
  802507:	5d                   	pop    %ebp
  802508:	c3                   	ret    
  802509:	00 00                	add    %al,(%eax)
	...

0080250c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 18             	sub    $0x18,%esp
  802512:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802515:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802518:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	89 04 24             	mov    %eax,(%esp)
  802521:	e8 a6 f1 ff ff       	call   8016cc <fd2data>
  802526:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802528:	c7 44 24 04 e3 35 80 	movl   $0x8035e3,0x4(%esp)
  80252f:	00 
  802530:	89 34 24             	mov    %esi,(%esp)
  802533:	e8 61 e5 ff ff       	call   800a99 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802538:	8b 43 04             	mov    0x4(%ebx),%eax
  80253b:	2b 03                	sub    (%ebx),%eax
  80253d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802543:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80254a:	00 00 00 
	stat->st_dev = &devpipe;
  80254d:	c7 86 88 00 00 00 40 	movl   $0x804040,0x88(%esi)
  802554:	40 80 00 
	return 0;
}
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
  80255c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80255f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802562:	89 ec                	mov    %ebp,%esp
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    

00802566 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	53                   	push   %ebx
  80256a:	83 ec 14             	sub    $0x14,%esp
  80256d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802570:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802574:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80257b:	e8 a2 eb ff ff       	call   801122 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802580:	89 1c 24             	mov    %ebx,(%esp)
  802583:	e8 44 f1 ff ff       	call   8016cc <fd2data>
  802588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802593:	e8 8a eb ff ff       	call   801122 <sys_page_unmap>
}
  802598:	83 c4 14             	add    $0x14,%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5d                   	pop    %ebp
  80259d:	c3                   	ret    

0080259e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 2c             	sub    $0x2c,%esp
  8025a7:	89 c7                	mov    %eax,%edi
  8025a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025ac:	a1 08 50 80 00       	mov    0x805008,%eax
  8025b1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025b4:	89 3c 24             	mov    %edi,(%esp)
  8025b7:	e8 c8 06 00 00       	call   802c84 <pageref>
  8025bc:	89 c6                	mov    %eax,%esi
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	89 04 24             	mov    %eax,(%esp)
  8025c4:	e8 bb 06 00 00       	call   802c84 <pageref>
  8025c9:	39 c6                	cmp    %eax,%esi
  8025cb:	0f 94 c0             	sete   %al
  8025ce:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8025d1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8025d7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8025da:	39 cb                	cmp    %ecx,%ebx
  8025dc:	75 08                	jne    8025e6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8025de:	83 c4 2c             	add    $0x2c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8025e6:	83 f8 01             	cmp    $0x1,%eax
  8025e9:	75 c1                	jne    8025ac <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025eb:	8b 52 58             	mov    0x58(%edx),%edx
  8025ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025f2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025fa:	c7 04 24 ea 35 80 00 	movl   $0x8035ea,(%esp)
  802601:	e8 2f de ff ff       	call   800435 <cprintf>
  802606:	eb a4                	jmp    8025ac <_pipeisclosed+0xe>

00802608 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	57                   	push   %edi
  80260c:	56                   	push   %esi
  80260d:	53                   	push   %ebx
  80260e:	83 ec 1c             	sub    $0x1c,%esp
  802611:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802614:	89 34 24             	mov    %esi,(%esp)
  802617:	e8 b0 f0 ff ff       	call   8016cc <fd2data>
  80261c:	89 c3                	mov    %eax,%ebx
  80261e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802623:	eb 48                	jmp    80266d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802625:	89 da                	mov    %ebx,%edx
  802627:	89 f0                	mov    %esi,%eax
  802629:	e8 70 ff ff ff       	call   80259e <_pipeisclosed>
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 07                	je     802639 <devpipe_write+0x31>
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	eb 3b                	jmp    802674 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802639:	e8 ff eb ff ff       	call   80123d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80263e:	8b 43 04             	mov    0x4(%ebx),%eax
  802641:	8b 13                	mov    (%ebx),%edx
  802643:	83 c2 20             	add    $0x20,%edx
  802646:	39 d0                	cmp    %edx,%eax
  802648:	73 db                	jae    802625 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80264a:	89 c2                	mov    %eax,%edx
  80264c:	c1 fa 1f             	sar    $0x1f,%edx
  80264f:	c1 ea 1b             	shr    $0x1b,%edx
  802652:	01 d0                	add    %edx,%eax
  802654:	83 e0 1f             	and    $0x1f,%eax
  802657:	29 d0                	sub    %edx,%eax
  802659:	89 c2                	mov    %eax,%edx
  80265b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802662:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802666:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80266a:	83 c7 01             	add    $0x1,%edi
  80266d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802670:	72 cc                	jb     80263e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802672:	89 f8                	mov    %edi,%eax
}
  802674:	83 c4 1c             	add    $0x1c,%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5f                   	pop    %edi
  80267a:	5d                   	pop    %ebp
  80267b:	c3                   	ret    

0080267c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 28             	sub    $0x28,%esp
  802682:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802685:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802688:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80268b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80268e:	89 3c 24             	mov    %edi,(%esp)
  802691:	e8 36 f0 ff ff       	call   8016cc <fd2data>
  802696:	89 c3                	mov    %eax,%ebx
  802698:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80269d:	eb 48                	jmp    8026e7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80269f:	85 f6                	test   %esi,%esi
  8026a1:	74 04                	je     8026a7 <devpipe_read+0x2b>
				return i;
  8026a3:	89 f0                	mov    %esi,%eax
  8026a5:	eb 47                	jmp    8026ee <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026a7:	89 da                	mov    %ebx,%edx
  8026a9:	89 f8                	mov    %edi,%eax
  8026ab:	e8 ee fe ff ff       	call   80259e <_pipeisclosed>
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 07                	je     8026bb <devpipe_read+0x3f>
  8026b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b9:	eb 33                	jmp    8026ee <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026bb:	e8 7d eb ff ff       	call   80123d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026c0:	8b 03                	mov    (%ebx),%eax
  8026c2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026c5:	74 d8                	je     80269f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026c7:	89 c2                	mov    %eax,%edx
  8026c9:	c1 fa 1f             	sar    $0x1f,%edx
  8026cc:	c1 ea 1b             	shr    $0x1b,%edx
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	83 e0 1f             	and    $0x1f,%eax
  8026d4:	29 d0                	sub    %edx,%eax
  8026d6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026de:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8026e1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026e4:	83 c6 01             	add    $0x1,%esi
  8026e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026ea:	72 d4                	jb     8026c0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026ec:	89 f0                	mov    %esi,%eax
}
  8026ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8026f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8026f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8026f7:	89 ec                	mov    %ebp,%esp
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    

008026fb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802701:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	89 04 24             	mov    %eax,(%esp)
  80270e:	e8 2d f0 ff ff       	call   801740 <fd_lookup>
  802713:	85 c0                	test   %eax,%eax
  802715:	78 15                	js     80272c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	89 04 24             	mov    %eax,(%esp)
  80271d:	e8 aa ef ff ff       	call   8016cc <fd2data>
	return _pipeisclosed(fd, p);
  802722:	89 c2                	mov    %eax,%edx
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	e8 72 fe ff ff       	call   80259e <_pipeisclosed>
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 48             	sub    $0x48,%esp
  802734:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802737:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80273a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80273d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802740:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802743:	89 04 24             	mov    %eax,(%esp)
  802746:	e8 9c ef ff ff       	call   8016e7 <fd_alloc>
  80274b:	89 c3                	mov    %eax,%ebx
  80274d:	85 c0                	test   %eax,%eax
  80274f:	0f 88 42 01 00 00    	js     802897 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802755:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80275c:	00 
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	89 44 24 04          	mov    %eax,0x4(%esp)
  802764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276b:	e8 6e ea ff ff       	call   8011de <sys_page_alloc>
  802770:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802772:	85 c0                	test   %eax,%eax
  802774:	0f 88 1d 01 00 00    	js     802897 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80277a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80277d:	89 04 24             	mov    %eax,(%esp)
  802780:	e8 62 ef ff ff       	call   8016e7 <fd_alloc>
  802785:	89 c3                	mov    %eax,%ebx
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 88 f5 00 00 00    	js     802884 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80278f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802796:	00 
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a5:	e8 34 ea ff ff       	call   8011de <sys_page_alloc>
  8027aa:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	0f 88 d0 00 00 00    	js     802884 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b7:	89 04 24             	mov    %eax,(%esp)
  8027ba:	e8 0d ef ff ff       	call   8016cc <fd2data>
  8027bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c8:	00 
  8027c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d4:	e8 05 ea ff ff       	call   8011de <sys_page_alloc>
  8027d9:	89 c3                	mov    %eax,%ebx
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	0f 88 8e 00 00 00    	js     802871 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e6:	89 04 24             	mov    %eax,(%esp)
  8027e9:	e8 de ee ff ff       	call   8016cc <fd2data>
  8027ee:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027f5:	00 
  8027f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802801:	00 
  802802:	89 74 24 04          	mov    %esi,0x4(%esp)
  802806:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80280d:	e8 6e e9 ff ff       	call   801180 <sys_page_map>
  802812:	89 c3                	mov    %eax,%ebx
  802814:	85 c0                	test   %eax,%eax
  802816:	78 49                	js     802861 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802818:	b8 40 40 80 00       	mov    $0x804040,%eax
  80281d:	8b 08                	mov    (%eax),%ecx
  80281f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802822:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802824:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802827:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80282e:	8b 10                	mov    (%eax),%edx
  802830:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802833:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802838:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80283f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802842:	89 04 24             	mov    %eax,(%esp)
  802845:	e8 72 ee ff ff       	call   8016bc <fd2num>
  80284a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80284c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284f:	89 04 24             	mov    %eax,(%esp)
  802852:	e8 65 ee ff ff       	call   8016bc <fd2num>
  802857:	89 47 04             	mov    %eax,0x4(%edi)
  80285a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80285f:	eb 36                	jmp    802897 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802861:	89 74 24 04          	mov    %esi,0x4(%esp)
  802865:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80286c:	e8 b1 e8 ff ff       	call   801122 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802874:	89 44 24 04          	mov    %eax,0x4(%esp)
  802878:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80287f:	e8 9e e8 ff ff       	call   801122 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80288b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802892:	e8 8b e8 ff ff       	call   801122 <sys_page_unmap>
    err:
	return r;
}
  802897:	89 d8                	mov    %ebx,%eax
  802899:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80289c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80289f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028a2:	89 ec                	mov    %ebp,%esp
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
	...

008028a8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	56                   	push   %esi
  8028ac:	53                   	push   %ebx
  8028ad:	83 ec 10             	sub    $0x10,%esp
  8028b0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8028b3:	85 f6                	test   %esi,%esi
  8028b5:	75 24                	jne    8028db <wait+0x33>
  8028b7:	c7 44 24 0c 02 36 80 	movl   $0x803602,0xc(%esp)
  8028be:	00 
  8028bf:	c7 44 24 08 60 35 80 	movl   $0x803560,0x8(%esp)
  8028c6:	00 
  8028c7:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8028ce:	00 
  8028cf:	c7 04 24 0d 36 80 00 	movl   $0x80360d,(%esp)
  8028d6:	e8 a1 da ff ff       	call   80037c <_panic>
	e = &envs[ENVX(envid)];
  8028db:	89 f3                	mov    %esi,%ebx
  8028dd:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8028e3:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8028e6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8028ec:	eb 05                	jmp    8028f3 <wait+0x4b>
		sys_yield();
  8028ee:	e8 4a e9 ff ff       	call   80123d <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8028f3:	8b 43 48             	mov    0x48(%ebx),%eax
  8028f6:	39 f0                	cmp    %esi,%eax
  8028f8:	75 07                	jne    802901 <wait+0x59>
  8028fa:	8b 43 54             	mov    0x54(%ebx),%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	75 ed                	jne    8028ee <wait+0x46>
		sys_yield();
}
  802901:	83 c4 10             	add    $0x10,%esp
  802904:	5b                   	pop    %ebx
  802905:	5e                   	pop    %esi
  802906:	5d                   	pop    %ebp
  802907:	c3                   	ret    
	...

00802910 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802913:	b8 00 00 00 00       	mov    $0x0,%eax
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    

0080291a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802920:	c7 44 24 04 18 36 80 	movl   $0x803618,0x4(%esp)
  802927:	00 
  802928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292b:	89 04 24             	mov    %eax,(%esp)
  80292e:	e8 66 e1 ff ff       	call   800a99 <strcpy>
	return 0;
}
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	57                   	push   %edi
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802946:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80294b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802951:	eb 34                	jmp    802987 <devcons_write+0x4d>
		m = n - tot;
  802953:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802956:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802958:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80295e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802963:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802966:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80296a:	03 45 0c             	add    0xc(%ebp),%eax
  80296d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802971:	89 3c 24             	mov    %edi,(%esp)
  802974:	e8 c6 e2 ff ff       	call   800c3f <memmove>
		sys_cputs(buf, m);
  802979:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80297d:	89 3c 24             	mov    %edi,(%esp)
  802980:	e8 cb e4 ff ff       	call   800e50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802985:	01 de                	add    %ebx,%esi
  802987:	89 f0                	mov    %esi,%eax
  802989:	3b 75 10             	cmp    0x10(%ebp),%esi
  80298c:	72 c5                	jb     802953 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80298e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802994:	5b                   	pop    %ebx
  802995:	5e                   	pop    %esi
  802996:	5f                   	pop    %edi
  802997:	5d                   	pop    %ebp
  802998:	c3                   	ret    

00802999 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029ac:	00 
  8029ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029b0:	89 04 24             	mov    %eax,(%esp)
  8029b3:	e8 98 e4 ff ff       	call   800e50 <sys_cputs>
}
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8029c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029c4:	75 07                	jne    8029cd <devcons_read+0x13>
  8029c6:	eb 28                	jmp    8029f0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029c8:	e8 70 e8 ff ff       	call   80123d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	e8 47 e4 ff ff       	call   800e1c <sys_cgetc>
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 ef                	je     8029c8 <devcons_read+0xe>
  8029d9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	78 16                	js     8029f5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029df:	83 f8 04             	cmp    $0x4,%eax
  8029e2:	74 0c                	je     8029f0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8029e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e7:	88 10                	mov    %dl,(%eax)
  8029e9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8029ee:	eb 05                	jmp    8029f5 <devcons_read+0x3b>
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a00:	89 04 24             	mov    %eax,(%esp)
  802a03:	e8 df ec ff ff       	call   8016e7 <fd_alloc>
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	78 3f                	js     802a4b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a0c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a13:	00 
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a22:	e8 b7 e7 ff ff       	call   8011de <sys_page_alloc>
  802a27:	85 c0                	test   %eax,%eax
  802a29:	78 20                	js     802a4b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a2b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	89 04 24             	mov    %eax,(%esp)
  802a46:	e8 71 ec ff ff       	call   8016bc <fd2num>
}
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    

00802a4d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
  802a50:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	89 04 24             	mov    %eax,(%esp)
  802a60:	e8 db ec ff ff       	call   801740 <fd_lookup>
  802a65:	85 c0                	test   %eax,%eax
  802a67:	78 11                	js     802a7a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	3b 05 5c 40 80 00    	cmp    0x80405c,%eax
  802a74:	0f 94 c0             	sete   %al
  802a77:	0f b6 c0             	movzbl %al,%eax
}
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a82:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a89:	00 
  802a8a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a98:	e8 fa ee ff ff       	call   801997 <read>
	if (r < 0)
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	78 0f                	js     802ab0 <getchar+0x34>
		return r;
	if (r < 1)
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	7f 07                	jg     802aac <getchar+0x30>
  802aa5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802aaa:	eb 04                	jmp    802ab0 <getchar+0x34>
		return -E_EOF;
	return c;
  802aac:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ab0:	c9                   	leave  
  802ab1:	c3                   	ret    
	...

00802ab4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	53                   	push   %ebx
  802ab8:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  802abb:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  802ac2:	75 5b                	jne    802b1f <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  802ac4:	e8 a8 e7 ff ff       	call   801271 <sys_getenvid>
  802ac9:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  802acb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ad2:	00 
  802ad3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ada:	ee 
  802adb:	89 04 24             	mov    %eax,(%esp)
  802ade:	e8 fb e6 ff ff       	call   8011de <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	74 28                	je     802b0f <set_pgfault_handler+0x5b>
  802ae7:	89 44 24 10          	mov    %eax,0x10(%esp)
  802aeb:	c7 44 24 0c 4b 36 80 	movl   $0x80364b,0xc(%esp)
  802af2:	00 
  802af3:	c7 44 24 08 24 36 80 	movl   $0x803624,0x8(%esp)
  802afa:	00 
  802afb:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802b02:	00 
  802b03:	c7 04 24 3d 36 80 00 	movl   $0x80363d,(%esp)
  802b0a:	e8 6d d8 ff ff       	call   80037c <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802b0f:	c7 44 24 04 30 2b 80 	movl   $0x802b30,0x4(%esp)
  802b16:	00 
  802b17:	89 1c 24             	mov    %ebx,(%esp)
  802b1a:	e8 e9 e4 ff ff       	call   801008 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	a3 00 90 80 00       	mov    %eax,0x809000
	
}
  802b27:	83 c4 24             	add    $0x24,%esp
  802b2a:	5b                   	pop    %ebx
  802b2b:	5d                   	pop    %ebp
  802b2c:	c3                   	ret    
  802b2d:	00 00                	add    %al,(%eax)
	...

00802b30 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b30:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b31:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  802b36:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b38:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  802b3b:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  802b3e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  802b42:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  802b46:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  802b49:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  802b4c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  802b50:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  802b51:	83 c4 04             	add    $0x4,%esp
	popfl ;
  802b54:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802b55:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802b56:	c3                   	ret    
	...

00802b58 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b5e:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802b63:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802b66:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802b6c:	8b 12                	mov    (%edx),%edx
  802b6e:	39 ca                	cmp    %ecx,%edx
  802b70:	75 0c                	jne    802b7e <ipc_find_env+0x26>
			return envs[i].env_id;
  802b72:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b75:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	eb 0e                	jmp    802b8c <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b7e:	83 c0 01             	add    $0x1,%eax
  802b81:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b86:	75 db                	jne    802b63 <ipc_find_env+0xb>
  802b88:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802b8c:	5d                   	pop    %ebp
  802b8d:	c3                   	ret    

00802b8e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b8e:	55                   	push   %ebp
  802b8f:	89 e5                	mov    %esp,%ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	53                   	push   %ebx
  802b94:	83 ec 2c             	sub    $0x2c,%esp
  802b97:	8b 75 08             	mov    0x8(%ebp),%esi
  802b9a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802ba0:	85 db                	test   %ebx,%ebx
  802ba2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802ba7:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802baa:	8b 45 14             	mov    0x14(%ebp),%eax
  802bad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bb1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802bb5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bb9:	89 34 24             	mov    %esi,(%esp)
  802bbc:	e8 0f e4 ff ff       	call   800fd0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802bc1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802bc4:	74 e4                	je     802baa <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 28                	je     802bf2 <ipc_send+0x64>
  802bca:	89 44 24 10          	mov    %eax,0x10(%esp)
  802bce:	c7 44 24 0c 7c 36 80 	movl   $0x80367c,0xc(%esp)
  802bd5:	00 
  802bd6:	c7 44 24 08 5f 36 80 	movl   $0x80365f,0x8(%esp)
  802bdd:	00 
  802bde:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802be5:	00 
  802be6:	c7 04 24 72 36 80 00 	movl   $0x803672,(%esp)
  802bed:	e8 8a d7 ff ff       	call   80037c <_panic>
	//if(!ret) sys_yield();
}
  802bf2:	83 c4 2c             	add    $0x2c,%esp
  802bf5:	5b                   	pop    %ebx
  802bf6:	5e                   	pop    %esi
  802bf7:	5f                   	pop    %edi
  802bf8:	5d                   	pop    %ebp
  802bf9:	c3                   	ret    

00802bfa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bfa:	55                   	push   %ebp
  802bfb:	89 e5                	mov    %esp,%ebp
  802bfd:	83 ec 28             	sub    $0x28,%esp
  802c00:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c03:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c06:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802c09:	8b 75 08             	mov    0x8(%ebp),%esi
  802c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c0f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802c12:	85 c0                	test   %eax,%eax
  802c14:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c19:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c1c:	89 04 24             	mov    %eax,(%esp)
  802c1f:	e8 4f e3 ff ff       	call   800f73 <sys_ipc_recv>
  802c24:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802c26:	e8 46 e6 ff ff       	call   801271 <sys_getenvid>
  802c2b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802c30:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802c33:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802c38:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802c3d:	85 f6                	test   %esi,%esi
  802c3f:	74 0e                	je     802c4f <ipc_recv+0x55>
  802c41:	ba 00 00 00 00       	mov    $0x0,%edx
  802c46:	85 db                	test   %ebx,%ebx
  802c48:	75 03                	jne    802c4d <ipc_recv+0x53>
  802c4a:	8b 50 74             	mov    0x74(%eax),%edx
  802c4d:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802c4f:	85 ff                	test   %edi,%edi
  802c51:	74 13                	je     802c66 <ipc_recv+0x6c>
  802c53:	b8 00 00 00 00       	mov    $0x0,%eax
  802c58:	85 db                	test   %ebx,%ebx
  802c5a:	75 08                	jne    802c64 <ipc_recv+0x6a>
  802c5c:	a1 08 50 80 00       	mov    0x805008,%eax
  802c61:	8b 40 78             	mov    0x78(%eax),%eax
  802c64:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802c66:	85 db                	test   %ebx,%ebx
  802c68:	75 08                	jne    802c72 <ipc_recv+0x78>
  802c6a:	a1 08 50 80 00       	mov    0x805008,%eax
  802c6f:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802c72:	89 d8                	mov    %ebx,%eax
  802c74:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c77:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c7a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c7d:	89 ec                	mov    %ebp,%esp
  802c7f:	5d                   	pop    %ebp
  802c80:	c3                   	ret    
  802c81:	00 00                	add    %al,(%eax)
	...

00802c84 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c84:	55                   	push   %ebp
  802c85:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	89 c2                	mov    %eax,%edx
  802c8c:	c1 ea 16             	shr    $0x16,%edx
  802c8f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c96:	f6 c2 01             	test   $0x1,%dl
  802c99:	74 20                	je     802cbb <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802c9b:	c1 e8 0c             	shr    $0xc,%eax
  802c9e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802ca5:	a8 01                	test   $0x1,%al
  802ca7:	74 12                	je     802cbb <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ca9:	c1 e8 0c             	shr    $0xc,%eax
  802cac:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802cb1:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802cb6:	0f b7 c0             	movzwl %ax,%eax
  802cb9:	eb 05                	jmp    802cc0 <pageref+0x3c>
  802cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc0:	5d                   	pop    %ebp
  802cc1:	c3                   	ret    
	...

00802cd0 <__udivdi3>:
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
  802cd3:	57                   	push   %edi
  802cd4:	56                   	push   %esi
  802cd5:	83 ec 10             	sub    $0x10,%esp
  802cd8:	8b 45 14             	mov    0x14(%ebp),%eax
  802cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cde:	8b 75 10             	mov    0x10(%ebp),%esi
  802ce1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802ce9:	75 35                	jne    802d20 <__udivdi3+0x50>
  802ceb:	39 fe                	cmp    %edi,%esi
  802ced:	77 61                	ja     802d50 <__udivdi3+0x80>
  802cef:	85 f6                	test   %esi,%esi
  802cf1:	75 0b                	jne    802cfe <__udivdi3+0x2e>
  802cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  802cf8:	31 d2                	xor    %edx,%edx
  802cfa:	f7 f6                	div    %esi
  802cfc:	89 c6                	mov    %eax,%esi
  802cfe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d01:	31 d2                	xor    %edx,%edx
  802d03:	89 f8                	mov    %edi,%eax
  802d05:	f7 f6                	div    %esi
  802d07:	89 c7                	mov    %eax,%edi
  802d09:	89 c8                	mov    %ecx,%eax
  802d0b:	f7 f6                	div    %esi
  802d0d:	89 c1                	mov    %eax,%ecx
  802d0f:	89 fa                	mov    %edi,%edx
  802d11:	89 c8                	mov    %ecx,%eax
  802d13:	83 c4 10             	add    $0x10,%esp
  802d16:	5e                   	pop    %esi
  802d17:	5f                   	pop    %edi
  802d18:	5d                   	pop    %ebp
  802d19:	c3                   	ret    
  802d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d20:	39 f8                	cmp    %edi,%eax
  802d22:	77 1c                	ja     802d40 <__udivdi3+0x70>
  802d24:	0f bd d0             	bsr    %eax,%edx
  802d27:	83 f2 1f             	xor    $0x1f,%edx
  802d2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d2d:	75 39                	jne    802d68 <__udivdi3+0x98>
  802d2f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d32:	0f 86 a0 00 00 00    	jbe    802dd8 <__udivdi3+0x108>
  802d38:	39 f8                	cmp    %edi,%eax
  802d3a:	0f 82 98 00 00 00    	jb     802dd8 <__udivdi3+0x108>
  802d40:	31 ff                	xor    %edi,%edi
  802d42:	31 c9                	xor    %ecx,%ecx
  802d44:	89 c8                	mov    %ecx,%eax
  802d46:	89 fa                	mov    %edi,%edx
  802d48:	83 c4 10             	add    $0x10,%esp
  802d4b:	5e                   	pop    %esi
  802d4c:	5f                   	pop    %edi
  802d4d:	5d                   	pop    %ebp
  802d4e:	c3                   	ret    
  802d4f:	90                   	nop
  802d50:	89 d1                	mov    %edx,%ecx
  802d52:	89 fa                	mov    %edi,%edx
  802d54:	89 c8                	mov    %ecx,%eax
  802d56:	31 ff                	xor    %edi,%edi
  802d58:	f7 f6                	div    %esi
  802d5a:	89 c1                	mov    %eax,%ecx
  802d5c:	89 fa                	mov    %edi,%edx
  802d5e:	89 c8                	mov    %ecx,%eax
  802d60:	83 c4 10             	add    $0x10,%esp
  802d63:	5e                   	pop    %esi
  802d64:	5f                   	pop    %edi
  802d65:	5d                   	pop    %ebp
  802d66:	c3                   	ret    
  802d67:	90                   	nop
  802d68:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d6c:	89 f2                	mov    %esi,%edx
  802d6e:	d3 e0                	shl    %cl,%eax
  802d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d73:	b8 20 00 00 00       	mov    $0x20,%eax
  802d78:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d7b:	89 c1                	mov    %eax,%ecx
  802d7d:	d3 ea                	shr    %cl,%edx
  802d7f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d83:	0b 55 ec             	or     -0x14(%ebp),%edx
  802d86:	d3 e6                	shl    %cl,%esi
  802d88:	89 c1                	mov    %eax,%ecx
  802d8a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802d8d:	89 fe                	mov    %edi,%esi
  802d8f:	d3 ee                	shr    %cl,%esi
  802d91:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d95:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9b:	d3 e7                	shl    %cl,%edi
  802d9d:	89 c1                	mov    %eax,%ecx
  802d9f:	d3 ea                	shr    %cl,%edx
  802da1:	09 d7                	or     %edx,%edi
  802da3:	89 f2                	mov    %esi,%edx
  802da5:	89 f8                	mov    %edi,%eax
  802da7:	f7 75 ec             	divl   -0x14(%ebp)
  802daa:	89 d6                	mov    %edx,%esi
  802dac:	89 c7                	mov    %eax,%edi
  802dae:	f7 65 e8             	mull   -0x18(%ebp)
  802db1:	39 d6                	cmp    %edx,%esi
  802db3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802db6:	72 30                	jb     802de8 <__udivdi3+0x118>
  802db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802dbf:	d3 e2                	shl    %cl,%edx
  802dc1:	39 c2                	cmp    %eax,%edx
  802dc3:	73 05                	jae    802dca <__udivdi3+0xfa>
  802dc5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802dc8:	74 1e                	je     802de8 <__udivdi3+0x118>
  802dca:	89 f9                	mov    %edi,%ecx
  802dcc:	31 ff                	xor    %edi,%edi
  802dce:	e9 71 ff ff ff       	jmp    802d44 <__udivdi3+0x74>
  802dd3:	90                   	nop
  802dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dd8:	31 ff                	xor    %edi,%edi
  802dda:	b9 01 00 00 00       	mov    $0x1,%ecx
  802ddf:	e9 60 ff ff ff       	jmp    802d44 <__udivdi3+0x74>
  802de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802de8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802deb:	31 ff                	xor    %edi,%edi
  802ded:	89 c8                	mov    %ecx,%eax
  802def:	89 fa                	mov    %edi,%edx
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	5e                   	pop    %esi
  802df5:	5f                   	pop    %edi
  802df6:	5d                   	pop    %ebp
  802df7:	c3                   	ret    
	...

00802e00 <__umoddi3>:
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
  802e03:	57                   	push   %edi
  802e04:	56                   	push   %esi
  802e05:	83 ec 20             	sub    $0x20,%esp
  802e08:	8b 55 14             	mov    0x14(%ebp),%edx
  802e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e0e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e11:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e14:	85 d2                	test   %edx,%edx
  802e16:	89 c8                	mov    %ecx,%eax
  802e18:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e1b:	75 13                	jne    802e30 <__umoddi3+0x30>
  802e1d:	39 f7                	cmp    %esi,%edi
  802e1f:	76 3f                	jbe    802e60 <__umoddi3+0x60>
  802e21:	89 f2                	mov    %esi,%edx
  802e23:	f7 f7                	div    %edi
  802e25:	89 d0                	mov    %edx,%eax
  802e27:	31 d2                	xor    %edx,%edx
  802e29:	83 c4 20             	add    $0x20,%esp
  802e2c:	5e                   	pop    %esi
  802e2d:	5f                   	pop    %edi
  802e2e:	5d                   	pop    %ebp
  802e2f:	c3                   	ret    
  802e30:	39 f2                	cmp    %esi,%edx
  802e32:	77 4c                	ja     802e80 <__umoddi3+0x80>
  802e34:	0f bd ca             	bsr    %edx,%ecx
  802e37:	83 f1 1f             	xor    $0x1f,%ecx
  802e3a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e3d:	75 51                	jne    802e90 <__umoddi3+0x90>
  802e3f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e42:	0f 87 e0 00 00 00    	ja     802f28 <__umoddi3+0x128>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	29 f8                	sub    %edi,%eax
  802e4d:	19 d6                	sbb    %edx,%esi
  802e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	89 f2                	mov    %esi,%edx
  802e57:	83 c4 20             	add    $0x20,%esp
  802e5a:	5e                   	pop    %esi
  802e5b:	5f                   	pop    %edi
  802e5c:	5d                   	pop    %ebp
  802e5d:	c3                   	ret    
  802e5e:	66 90                	xchg   %ax,%ax
  802e60:	85 ff                	test   %edi,%edi
  802e62:	75 0b                	jne    802e6f <__umoddi3+0x6f>
  802e64:	b8 01 00 00 00       	mov    $0x1,%eax
  802e69:	31 d2                	xor    %edx,%edx
  802e6b:	f7 f7                	div    %edi
  802e6d:	89 c7                	mov    %eax,%edi
  802e6f:	89 f0                	mov    %esi,%eax
  802e71:	31 d2                	xor    %edx,%edx
  802e73:	f7 f7                	div    %edi
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	f7 f7                	div    %edi
  802e7a:	eb a9                	jmp    802e25 <__umoddi3+0x25>
  802e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e80:	89 c8                	mov    %ecx,%eax
  802e82:	89 f2                	mov    %esi,%edx
  802e84:	83 c4 20             	add    $0x20,%esp
  802e87:	5e                   	pop    %esi
  802e88:	5f                   	pop    %edi
  802e89:	5d                   	pop    %ebp
  802e8a:	c3                   	ret    
  802e8b:	90                   	nop
  802e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e90:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e94:	d3 e2                	shl    %cl,%edx
  802e96:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e99:	ba 20 00 00 00       	mov    $0x20,%edx
  802e9e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ea1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ea4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ea8:	89 fa                	mov    %edi,%edx
  802eaa:	d3 ea                	shr    %cl,%edx
  802eac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eb0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802eb3:	d3 e7                	shl    %cl,%edi
  802eb5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802eb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ebc:	89 f2                	mov    %esi,%edx
  802ebe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802ec1:	89 c7                	mov    %eax,%edi
  802ec3:	d3 ea                	shr    %cl,%edx
  802ec5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ec9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802ecc:	89 c2                	mov    %eax,%edx
  802ece:	d3 e6                	shl    %cl,%esi
  802ed0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ed4:	d3 ea                	shr    %cl,%edx
  802ed6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eda:	09 d6                	or     %edx,%esi
  802edc:	89 f0                	mov    %esi,%eax
  802ede:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802ee1:	d3 e7                	shl    %cl,%edi
  802ee3:	89 f2                	mov    %esi,%edx
  802ee5:	f7 75 f4             	divl   -0xc(%ebp)
  802ee8:	89 d6                	mov    %edx,%esi
  802eea:	f7 65 e8             	mull   -0x18(%ebp)
  802eed:	39 d6                	cmp    %edx,%esi
  802eef:	72 2b                	jb     802f1c <__umoddi3+0x11c>
  802ef1:	39 c7                	cmp    %eax,%edi
  802ef3:	72 23                	jb     802f18 <__umoddi3+0x118>
  802ef5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ef9:	29 c7                	sub    %eax,%edi
  802efb:	19 d6                	sbb    %edx,%esi
  802efd:	89 f0                	mov    %esi,%eax
  802eff:	89 f2                	mov    %esi,%edx
  802f01:	d3 ef                	shr    %cl,%edi
  802f03:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f07:	d3 e0                	shl    %cl,%eax
  802f09:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f0d:	09 f8                	or     %edi,%eax
  802f0f:	d3 ea                	shr    %cl,%edx
  802f11:	83 c4 20             	add    $0x20,%esp
  802f14:	5e                   	pop    %esi
  802f15:	5f                   	pop    %edi
  802f16:	5d                   	pop    %ebp
  802f17:	c3                   	ret    
  802f18:	39 d6                	cmp    %edx,%esi
  802f1a:	75 d9                	jne    802ef5 <__umoddi3+0xf5>
  802f1c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f1f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f22:	eb d1                	jmp    802ef5 <__umoddi3+0xf5>
  802f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f28:	39 f2                	cmp    %esi,%edx
  802f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f30:	0f 82 12 ff ff ff    	jb     802e48 <__umoddi3+0x48>
  802f36:	e9 17 ff ff ff       	jmp    802e52 <__umoddi3+0x52>
