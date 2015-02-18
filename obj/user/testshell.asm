
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 43 05 00 00       	call   800574 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80004c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800052:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800055:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800059:	89 3c 24             	mov    %edi,(%esp)
  80005c:	e8 87 19 00 00       	call   8019e8 <seek>
	seek(kfd, off);
  800061:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800065:	89 34 24             	mov    %esi,(%esp)
  800068:	e8 7b 19 00 00       	call   8019e8 <seek>

	cprintf("shell produced incorrect output.\n");
  80006d:	c7 04 24 c0 36 80 00 	movl   $0x8036c0,(%esp)
  800074:	e8 18 06 00 00       	call   800691 <cprintf>
	cprintf("expected:\n===\n");
  800079:	c7 04 24 2b 37 80 00 	movl   $0x80372b,(%esp)
  800080:	e8 0c 06 00 00       	call   800691 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800085:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800088:	eb 0c                	jmp    800096 <wrong+0x56>
		sys_cputs(buf, n);
  80008a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008e:	89 1c 24             	mov    %ebx,(%esp)
  800091:	e8 1a 10 00 00       	call   8010b0 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800096:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 4d 1b 00 00       	call   801bf7 <read>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	7f dc                	jg     80008a <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000ae:	c7 04 24 3a 37 80 00 	movl   $0x80373a,(%esp)
  8000b5:	e8 d7 05 00 00       	call   800691 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ba:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000bd:	eb 0c                	jmp    8000cb <wrong+0x8b>
		sys_cputs(buf, n);
  8000bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c3:	89 1c 24             	mov    %ebx,(%esp)
  8000c6:	e8 e5 0f 00 00       	call   8010b0 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000cb:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000d2:	00 
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	89 3c 24             	mov    %edi,(%esp)
  8000da:	e8 18 1b 00 00       	call   801bf7 <read>
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	7f dc                	jg     8000bf <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000e3:	c7 04 24 35 37 80 00 	movl   $0x803735,(%esp)
  8000ea:	e8 a2 05 00 00       	call   800691 <cprintf>
	exit();
  8000ef:	e8 d0 04 00 00       	call   8005c4 <exit>
}
  8000f4:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5f                   	pop    %edi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010f:	e8 4a 1c 00 00       	call   801d5e <close>
	close(1);
  800114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80011b:	e8 3e 1c 00 00       	call   801d5e <close>
	opencons();
  800120:	e8 92 03 00 00       	call   8004b7 <opencons>
	opencons();
  800125:	e8 8d 03 00 00       	call   8004b7 <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80012a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800131:	00 
  800132:	c7 04 24 48 37 80 00 	movl   $0x803748,(%esp)
  800139:	e8 95 20 00 00       	call   8021d3 <open>
  80013e:	89 c3                	mov    %eax,%ebx
  800140:	85 c0                	test   %eax,%eax
  800142:	79 20                	jns    800164 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800144:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800148:	c7 44 24 08 55 37 80 	movl   $0x803755,0x8(%esp)
  80014f:	00 
  800150:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  800157:	00 
  800158:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  80015f:	e8 74 04 00 00       	call   8005d8 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800164:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800167:	89 04 24             	mov    %eax,(%esp)
  80016a:	e8 df 2e 00 00       	call   80304e <pipe>
  80016f:	85 c0                	test   %eax,%eax
  800171:	79 20                	jns    800193 <umain+0x94>
		panic("pipe: %e", wfd);
  800173:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800177:	c7 44 24 08 7c 37 80 	movl   $0x80377c,0x8(%esp)
  80017e:	00 
  80017f:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800186:	00 
  800187:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  80018e:	e8 45 04 00 00       	call   8005d8 <_panic>
	wfd = pfds[1];
  800193:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800196:	c7 04 24 e4 36 80 00 	movl   $0x8036e4,(%esp)
  80019d:	e8 ef 04 00 00       	call   800691 <cprintf>
	if ((r = fork()) < 0)
  8001a2:	e8 df 13 00 00       	call   801586 <fork>
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 20                	jns    8001cb <umain+0xcc>
		panic("fork: %e", r);
  8001ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001af:	c7 44 24 08 ba 3b 80 	movl   $0x803bba,0x8(%esp)
  8001b6:	00 
  8001b7:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001be:	00 
  8001bf:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  8001c6:	e8 0d 04 00 00       	call   8005d8 <_panic>
	if (r == 0) {
  8001cb:	85 c0                	test   %eax,%eax
  8001cd:	0f 85 b7 00 00 00    	jne    80028a <umain+0x18b>
		cprintf("child already here1\n");		
  8001d3:	c7 04 24 85 37 80 00 	movl   $0x803785,(%esp)
  8001da:	e8 b2 04 00 00       	call   800691 <cprintf>
		dup(rfd, 0);
  8001df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001e6:	00 
  8001e7:	89 1c 24             	mov    %ebx,(%esp)
  8001ea:	e8 0e 1c 00 00       	call   801dfd <dup>
		dup(wfd, 1);
  8001ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f6:	00 
  8001f7:	89 34 24             	mov    %esi,(%esp)
  8001fa:	e8 fe 1b 00 00       	call   801dfd <dup>
		close(rfd);
  8001ff:	89 1c 24             	mov    %ebx,(%esp)
  800202:	e8 57 1b 00 00       	call   801d5e <close>
		close(wfd);
  800207:	89 34 24             	mov    %esi,(%esp)
  80020a:	e8 4f 1b 00 00       	call   801d5e <close>
		cprintf("child already here\n");
  80020f:	c7 04 24 9a 37 80 00 	movl   $0x80379a,(%esp)
  800216:	e8 76 04 00 00       	call   800691 <cprintf>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80021b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800222:	00 
  800223:	c7 44 24 08 ae 37 80 	movl   $0x8037ae,0x8(%esp)
  80022a:	00 
  80022b:	c7 44 24 04 52 37 80 	movl   $0x803752,0x4(%esp)
  800232:	00 
  800233:	c7 04 24 b1 37 80 00 	movl   $0x8037b1,(%esp)
  80023a:	e8 6a 26 00 00       	call   8028a9 <spawnl>
  80023f:	89 c7                	mov    %eax,%edi
  800241:	85 c0                	test   %eax,%eax
  800243:	79 20                	jns    800265 <umain+0x166>
			panic("spawn: %e", r);
  800245:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800249:	c7 44 24 08 b5 37 80 	movl   $0x8037b5,0x8(%esp)
  800250:	00 
  800251:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800258:	00 
  800259:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  800260:	e8 73 03 00 00       	call   8005d8 <_panic>
		close(0);
  800265:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80026c:	e8 ed 1a 00 00       	call   801d5e <close>
		close(1);
  800271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800278:	e8 e1 1a 00 00       	call   801d5e <close>
		wait(r);
  80027d:	89 3c 24             	mov    %edi,(%esp)
  800280:	e8 43 2f 00 00       	call   8031c8 <wait>
		exit();
  800285:	e8 3a 03 00 00       	call   8005c4 <exit>
	}
	
	close(rfd);
  80028a:	89 1c 24             	mov    %ebx,(%esp)
  80028d:	e8 cc 1a 00 00       	call   801d5e <close>
	close(wfd);
  800292:	89 34 24             	mov    %esi,(%esp)
  800295:	e8 c4 1a 00 00       	call   801d5e <close>

	rfd = pfds[0];
  80029a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002a7:	00 
  8002a8:	c7 04 24 bf 37 80 00 	movl   $0x8037bf,(%esp)
  8002af:	e8 1f 1f 00 00       	call   8021d3 <open>
  8002b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002b7:	85 c0                	test   %eax,%eax
  8002b9:	79 20                	jns    8002db <umain+0x1dc>
		panic("open testshell.key for reading: %e", kfd);
  8002bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002bf:	c7 44 24 08 08 37 80 	movl   $0x803708,0x8(%esp)
  8002c6:	00 
  8002c7:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  8002ce:	00 
  8002cf:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  8002d6:	e8 fd 02 00 00       	call   8005d8 <_panic>

	cprintf("parent finish here\n");
  8002db:	c7 04 24 cd 37 80 00 	movl   $0x8037cd,(%esp)
  8002e2:	e8 aa 03 00 00       	call   800691 <cprintf>
  8002e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8002ec:	be 00 00 00 00       	mov    $0x0,%esi

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002f8:	00 
  8002f9:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 04 24             	mov    %eax,(%esp)
  800306:	e8 ec 18 00 00       	call   801bf7 <read>
  80030b:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  80030d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800314:	00 
  800315:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  800318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80031f:	89 04 24             	mov    %eax,(%esp)
  800322:	e8 d0 18 00 00       	call   801bf7 <read>
		if (n1 < 0)
  800327:	85 db                	test   %ebx,%ebx
  800329:	79 20                	jns    80034b <umain+0x24c>
			panic("reading testshell.out: %e", n1);
  80032b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80032f:	c7 44 24 08 e1 37 80 	movl   $0x8037e1,0x8(%esp)
  800336:	00 
  800337:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80033e:	00 
  80033f:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  800346:	e8 8d 02 00 00       	call   8005d8 <_panic>
		if (n2 < 0)
  80034b:	85 c0                	test   %eax,%eax
  80034d:	79 20                	jns    80036f <umain+0x270>
			panic("reading testshell.key: %e", n2);
  80034f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800353:	c7 44 24 08 fb 37 80 	movl   $0x8037fb,0x8(%esp)
  80035a:	00 
  80035b:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800362:	00 
  800363:	c7 04 24 6b 37 80 00 	movl   $0x80376b,(%esp)
  80036a:	e8 69 02 00 00       	call   8005d8 <_panic>
		if (n1 == 0 && n2 == 0)
  80036f:	85 c0                	test   %eax,%eax
  800371:	75 04                	jne    800377 <umain+0x278>
  800373:	85 db                	test   %ebx,%ebx
  800375:	74 39                	je     8003b0 <umain+0x2b1>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800377:	83 fb 01             	cmp    $0x1,%ebx
  80037a:	75 0f                	jne    80038b <umain+0x28c>
  80037c:	83 f8 01             	cmp    $0x1,%eax
  80037f:	90                   	nop
  800380:	75 09                	jne    80038b <umain+0x28c>
  800382:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  800386:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800389:	74 16                	je     8003a1 <umain+0x2a2>
			wrong(rfd, kfd, nloff);
  80038b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80038f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800392:	89 44 24 04          	mov    %eax,0x4(%esp)
  800396:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800399:	89 04 24             	mov    %eax,(%esp)
  80039c:	e8 9f fc ff ff       	call   800040 <wrong>
		if (c1 == '\n')
  8003a1:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8003a5:	0f 44 f7             	cmove  %edi,%esi
  8003a8:	83 c7 01             	add    $0x1,%edi
			nloff = off+1;
	}
  8003ab:	e9 41 ff ff ff       	jmp    8002f1 <umain+0x1f2>
	cprintf("shell ran correctly\n");
  8003b0:	c7 04 24 15 38 80 00 	movl   $0x803815,(%esp)
  8003b7:	e8 d5 02 00 00       	call   800691 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003bc:	cc                   	int3   

	breakpoint();
}
  8003bd:	83 c4 3c             	add    $0x3c,%esp
  8003c0:	5b                   	pop    %ebx
  8003c1:	5e                   	pop    %esi
  8003c2:	5f                   	pop    %edi
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    
	...

008003d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003e0:	c7 44 24 04 2a 38 80 	movl   $0x80382a,0x4(%esp)
  8003e7:	00 
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	e8 06 09 00 00       	call   800cf9 <strcpy>
	return 0;
}
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	57                   	push   %edi
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  800406:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80040b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800411:	eb 34                	jmp    800447 <devcons_write+0x4d>
		m = n - tot;
  800413:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800416:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  800418:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80041e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800423:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800426:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80042a:	03 45 0c             	add    0xc(%ebp),%eax
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	89 3c 24             	mov    %edi,(%esp)
  800434:	e8 66 0a 00 00       	call   800e9f <memmove>
		sys_cputs(buf, m);
  800439:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80043d:	89 3c 24             	mov    %edi,(%esp)
  800440:	e8 6b 0c 00 00       	call   8010b0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800445:	01 de                	add    %ebx,%esi
  800447:	89 f0                	mov    %esi,%eax
  800449:	3b 75 10             	cmp    0x10(%ebp),%esi
  80044c:	72 c5                	jb     800413 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80044e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800454:	5b                   	pop    %ebx
  800455:	5e                   	pop    %esi
  800456:	5f                   	pop    %edi
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800465:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80046c:	00 
  80046d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800470:	89 04 24             	mov    %eax,(%esp)
  800473:	e8 38 0c 00 00       	call   8010b0 <sys_cputs>
}
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  800480:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800484:	75 07                	jne    80048d <devcons_read+0x13>
  800486:	eb 28                	jmp    8004b0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800488:	e8 10 10 00 00       	call   80149d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80048d:	8d 76 00             	lea    0x0(%esi),%esi
  800490:	e8 e7 0b 00 00       	call   80107c <sys_cgetc>
  800495:	85 c0                	test   %eax,%eax
  800497:	74 ef                	je     800488 <devcons_read+0xe>
  800499:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80049b:	85 c0                	test   %eax,%eax
  80049d:	78 16                	js     8004b5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80049f:	83 f8 04             	cmp    $0x4,%eax
  8004a2:	74 0c                	je     8004b0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	88 10                	mov    %dl,(%eax)
  8004a9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8004ae:	eb 05                	jmp    8004b5 <devcons_read+0x3b>
  8004b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c0:	89 04 24             	mov    %eax,(%esp)
  8004c3:	e8 7f 14 00 00       	call   801947 <fd_alloc>
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	78 3f                	js     80050b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004cc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8004d3:	00 
  8004d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004e2:	e8 57 0f 00 00       	call   80143e <sys_page_alloc>
  8004e7:	85 c0                	test   %eax,%eax
  8004e9:	78 20                	js     80050b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8004eb:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8004f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800503:	89 04 24             	mov    %eax,(%esp)
  800506:	e8 11 14 00 00       	call   80191c <fd2num>
}
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 7b 14 00 00       	call   8019a0 <fd_lookup>
  800525:	85 c0                	test   %eax,%eax
  800527:	78 11                	js     80053a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	3b 05 00 40 80 00    	cmp    0x804000,%eax
  800534:	0f 94 c0             	sete   %al
  800537:	0f b6 c0             	movzbl %al,%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800542:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800549:	00 
  80054a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80054d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800551:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800558:	e8 9a 16 00 00       	call   801bf7 <read>
	if (r < 0)
  80055d:	85 c0                	test   %eax,%eax
  80055f:	78 0f                	js     800570 <getchar+0x34>
		return r;
	if (r < 1)
  800561:	85 c0                	test   %eax,%eax
  800563:	7f 07                	jg     80056c <getchar+0x30>
  800565:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80056a:	eb 04                	jmp    800570 <getchar+0x34>
		return -E_EOF;
	return c;
  80056c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800570:	c9                   	leave  
  800571:	c3                   	ret    
	...

00800574 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	83 ec 18             	sub    $0x18,%esp
  80057a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80057d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800580:	8b 75 08             	mov    0x8(%ebp),%esi
  800583:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800586:	e8 46 0f 00 00       	call   8014d1 <sys_getenvid>
  80058b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800590:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800593:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800598:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80059d:	85 f6                	test   %esi,%esi
  80059f:	7e 07                	jle    8005a8 <libmain+0x34>
		binaryname = argv[0];
  8005a1:	8b 03                	mov    (%ebx),%eax
  8005a3:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8005a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005ac:	89 34 24             	mov    %esi,(%esp)
  8005af:	e8 4b fb ff ff       	call   8000ff <umain>

	// exit gracefully
	exit();
  8005b4:	e8 0b 00 00 00       	call   8005c4 <exit>
}
  8005b9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8005bc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8005bf:	89 ec                	mov    %ebp,%esp
  8005c1:	5d                   	pop    %ebp
  8005c2:	c3                   	ret    
	...

008005c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8005ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005d1:	e8 2f 0f 00 00       	call   801505 <sys_env_destroy>
}
  8005d6:	c9                   	leave  
  8005d7:	c3                   	ret    

008005d8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	56                   	push   %esi
  8005dc:	53                   	push   %ebx
  8005dd:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8005e0:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005e3:	8b 1d 1c 40 80 00    	mov    0x80401c,%ebx
  8005e9:	e8 e3 0e 00 00       	call   8014d1 <sys_getenvid>
  8005ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800600:	89 44 24 04          	mov    %eax,0x4(%esp)
  800604:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  80060b:	e8 81 00 00 00       	call   800691 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800610:	89 74 24 04          	mov    %esi,0x4(%esp)
  800614:	8b 45 10             	mov    0x10(%ebp),%eax
  800617:	89 04 24             	mov    %eax,(%esp)
  80061a:	e8 11 00 00 00       	call   800630 <vcprintf>
	cprintf("\n");
  80061f:	c7 04 24 98 37 80 00 	movl   $0x803798,(%esp)
  800626:	e8 66 00 00 00       	call   800691 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062b:	cc                   	int3   
  80062c:	eb fd                	jmp    80062b <_panic+0x53>
	...

00800630 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800639:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800640:	00 00 00 
	b.cnt = 0;
  800643:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80064a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80064d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800650:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	89 44 24 08          	mov    %eax,0x8(%esp)
  80065b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800661:	89 44 24 04          	mov    %eax,0x4(%esp)
  800665:	c7 04 24 ab 06 80 00 	movl   $0x8006ab,(%esp)
  80066c:	e8 be 01 00 00       	call   80082f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800671:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80067b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800681:	89 04 24             	mov    %eax,(%esp)
  800684:	e8 27 0a 00 00       	call   8010b0 <sys_cputs>

	return b.cnt;
}
  800689:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800697:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80069a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	89 04 24             	mov    %eax,(%esp)
  8006a4:	e8 87 ff ff ff       	call   800630 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	53                   	push   %ebx
  8006af:	83 ec 14             	sub    $0x14,%esp
  8006b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006b5:	8b 03                	mov    (%ebx),%eax
  8006b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ba:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006be:	83 c0 01             	add    $0x1,%eax
  8006c1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c8:	75 19                	jne    8006e3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8006ca:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006d1:	00 
  8006d2:	8d 43 08             	lea    0x8(%ebx),%eax
  8006d5:	89 04 24             	mov    %eax,(%esp)
  8006d8:	e8 d3 09 00 00       	call   8010b0 <sys_cputs>
		b->idx = 0;
  8006dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006e7:	83 c4 14             	add    $0x14,%esp
  8006ea:	5b                   	pop    %ebx
  8006eb:	5d                   	pop    %ebp
  8006ec:	c3                   	ret    
  8006ed:	00 00                	add    %al,(%eax)
	...

008006f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	57                   	push   %edi
  8006f4:	56                   	push   %esi
  8006f5:	53                   	push   %ebx
  8006f6:	83 ec 4c             	sub    $0x4c,%esp
  8006f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006fc:	89 d6                	mov    %edx,%esi
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800704:	8b 55 0c             	mov    0xc(%ebp),%edx
  800707:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800710:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800713:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	39 d1                	cmp    %edx,%ecx
  80071d:	72 07                	jb     800726 <printnum+0x36>
  80071f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800722:	39 d0                	cmp    %edx,%eax
  800724:	77 69                	ja     80078f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800726:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80072a:	83 eb 01             	sub    $0x1,%ebx
  80072d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800731:	89 44 24 08          	mov    %eax,0x8(%esp)
  800735:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800739:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80073d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800740:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800743:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800746:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80074a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800751:	00 
  800752:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80075b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075f:	e8 dc 2c 00 00       	call   803440 <__udivdi3>
  800764:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800767:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80076a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80076e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800772:	89 04 24             	mov    %eax,(%esp)
  800775:	89 54 24 04          	mov    %edx,0x4(%esp)
  800779:	89 f2                	mov    %esi,%edx
  80077b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80077e:	e8 6d ff ff ff       	call   8006f0 <printnum>
  800783:	eb 11                	jmp    800796 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800785:	89 74 24 04          	mov    %esi,0x4(%esp)
  800789:	89 3c 24             	mov    %edi,(%esp)
  80078c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078f:	83 eb 01             	sub    $0x1,%ebx
  800792:	85 db                	test   %ebx,%ebx
  800794:	7f ef                	jg     800785 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800796:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80079e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007ac:	00 
  8007ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b0:	89 14 24             	mov    %edx,(%esp)
  8007b3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007ba:	e8 b1 2d 00 00       	call   803570 <__umoddi3>
  8007bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c3:	0f be 80 63 38 80 00 	movsbl 0x803863(%eax),%eax
  8007ca:	89 04 24             	mov    %eax,(%esp)
  8007cd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8007d0:	83 c4 4c             	add    $0x4c,%esp
  8007d3:	5b                   	pop    %ebx
  8007d4:	5e                   	pop    %esi
  8007d5:	5f                   	pop    %edi
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007db:	83 fa 01             	cmp    $0x1,%edx
  8007de:	7e 0e                	jle    8007ee <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007e0:	8b 10                	mov    (%eax),%edx
  8007e2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007e5:	89 08                	mov    %ecx,(%eax)
  8007e7:	8b 02                	mov    (%edx),%eax
  8007e9:	8b 52 04             	mov    0x4(%edx),%edx
  8007ec:	eb 22                	jmp    800810 <getuint+0x38>
	else if (lflag)
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	74 10                	je     800802 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007f2:	8b 10                	mov    (%eax),%edx
  8007f4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007f7:	89 08                	mov    %ecx,(%eax)
  8007f9:	8b 02                	mov    (%edx),%eax
  8007fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800800:	eb 0e                	jmp    800810 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800802:	8b 10                	mov    (%eax),%edx
  800804:	8d 4a 04             	lea    0x4(%edx),%ecx
  800807:	89 08                	mov    %ecx,(%eax)
  800809:	8b 02                	mov    (%edx),%eax
  80080b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800818:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80081c:	8b 10                	mov    (%eax),%edx
  80081e:	3b 50 04             	cmp    0x4(%eax),%edx
  800821:	73 0a                	jae    80082d <sprintputch+0x1b>
		*b->buf++ = ch;
  800823:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800826:	88 0a                	mov    %cl,(%edx)
  800828:	83 c2 01             	add    $0x1,%edx
  80082b:	89 10                	mov    %edx,(%eax)
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	57                   	push   %edi
  800833:	56                   	push   %esi
  800834:	53                   	push   %ebx
  800835:	83 ec 4c             	sub    $0x4c,%esp
  800838:	8b 7d 08             	mov    0x8(%ebp),%edi
  80083b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80083e:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800841:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800848:	eb 11                	jmp    80085b <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80084a:	85 c0                	test   %eax,%eax
  80084c:	0f 84 b6 03 00 00    	je     800c08 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800852:	89 74 24 04          	mov    %esi,0x4(%esp)
  800856:	89 04 24             	mov    %eax,(%esp)
  800859:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085b:	0f b6 03             	movzbl (%ebx),%eax
  80085e:	83 c3 01             	add    $0x1,%ebx
  800861:	83 f8 25             	cmp    $0x25,%eax
  800864:	75 e4                	jne    80084a <vprintfmt+0x1b>
  800866:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80086a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800871:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800878:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80087f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800884:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800887:	eb 06                	jmp    80088f <vprintfmt+0x60>
  800889:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  80088d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088f:	0f b6 0b             	movzbl (%ebx),%ecx
  800892:	0f b6 c1             	movzbl %cl,%eax
  800895:	8d 53 01             	lea    0x1(%ebx),%edx
  800898:	83 e9 23             	sub    $0x23,%ecx
  80089b:	80 f9 55             	cmp    $0x55,%cl
  80089e:	0f 87 47 03 00 00    	ja     800beb <vprintfmt+0x3bc>
  8008a4:	0f b6 c9             	movzbl %cl,%ecx
  8008a7:	ff 24 8d a0 39 80 00 	jmp    *0x8039a0(,%ecx,4)
  8008ae:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8008b2:	eb d9                	jmp    80088d <vprintfmt+0x5e>
  8008b4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8008bb:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008c0:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008c3:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008c7:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8008ca:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008cd:	83 fb 09             	cmp    $0x9,%ebx
  8008d0:	77 30                	ja     800902 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d2:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d5:	eb e9                	jmp    8008c0 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 48 04             	lea    0x4(%eax),%ecx
  8008dd:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8008e5:	eb 1e                	jmp    800905 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8008e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f0:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f7:	eb 94                	jmp    80088d <vprintfmt+0x5e>
  8008f9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800900:	eb 8b                	jmp    80088d <vprintfmt+0x5e>
  800902:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	79 82                	jns    80088d <vprintfmt+0x5e>
  80090b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80090e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800911:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800914:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800917:	e9 71 ff ff ff       	jmp    80088d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800920:	e9 68 ff ff ff       	jmp    80088d <vprintfmt+0x5e>
  800925:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 50 04             	lea    0x4(%eax),%edx
  80092e:	89 55 14             	mov    %edx,0x14(%ebp)
  800931:	89 74 24 04          	mov    %esi,0x4(%esp)
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 04 24             	mov    %eax,(%esp)
  80093a:	ff d7                	call   *%edi
  80093c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80093f:	e9 17 ff ff ff       	jmp    80085b <vprintfmt+0x2c>
  800944:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 50 04             	lea    0x4(%eax),%edx
  80094d:	89 55 14             	mov    %edx,0x14(%ebp)
  800950:	8b 00                	mov    (%eax),%eax
  800952:	89 c2                	mov    %eax,%edx
  800954:	c1 fa 1f             	sar    $0x1f,%edx
  800957:	31 d0                	xor    %edx,%eax
  800959:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80095b:	83 f8 11             	cmp    $0x11,%eax
  80095e:	7f 0b                	jg     80096b <vprintfmt+0x13c>
  800960:	8b 14 85 00 3b 80 00 	mov    0x803b00(,%eax,4),%edx
  800967:	85 d2                	test   %edx,%edx
  800969:	75 20                	jne    80098b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80096b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80096f:	c7 44 24 08 74 38 80 	movl   $0x803874,0x8(%esp)
  800976:	00 
  800977:	89 74 24 04          	mov    %esi,0x4(%esp)
  80097b:	89 3c 24             	mov    %edi,(%esp)
  80097e:	e8 0d 03 00 00       	call   800c90 <printfmt>
  800983:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800986:	e9 d0 fe ff ff       	jmp    80085b <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80098f:	c7 44 24 08 0e 3d 80 	movl   $0x803d0e,0x8(%esp)
  800996:	00 
  800997:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099b:	89 3c 24             	mov    %edi,(%esp)
  80099e:	e8 ed 02 00 00       	call   800c90 <printfmt>
  8009a3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8009a6:	e9 b0 fe ff ff       	jmp    80085b <vprintfmt+0x2c>
  8009ab:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009ae:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8009b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8d 50 04             	lea    0x4(%eax),%edx
  8009bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8009c0:	8b 18                	mov    (%eax),%ebx
  8009c2:	85 db                	test   %ebx,%ebx
  8009c4:	b8 7d 38 80 00       	mov    $0x80387d,%eax
  8009c9:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8009cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009d0:	7e 76                	jle    800a48 <vprintfmt+0x219>
  8009d2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8009d6:	74 7a                	je     800a52 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009dc:	89 1c 24             	mov    %ebx,(%esp)
  8009df:	e8 f4 02 00 00       	call   800cd8 <strnlen>
  8009e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009e7:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8009e9:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009f0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009f3:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f5:	eb 0f                	jmp    800a06 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fe:	89 04 24             	mov    %eax,(%esp)
  800a01:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a03:	83 eb 01             	sub    $0x1,%ebx
  800a06:	85 db                	test   %ebx,%ebx
  800a08:	7f ed                	jg     8009f7 <vprintfmt+0x1c8>
  800a0a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800a0d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a13:	89 f7                	mov    %esi,%edi
  800a15:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a18:	eb 40                	jmp    800a5a <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a1a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a1e:	74 18                	je     800a38 <vprintfmt+0x209>
  800a20:	8d 50 e0             	lea    -0x20(%eax),%edx
  800a23:	83 fa 5e             	cmp    $0x5e,%edx
  800a26:	76 10                	jbe    800a38 <vprintfmt+0x209>
					putch('?', putdat);
  800a28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a2c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a33:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a36:	eb 0a                	jmp    800a42 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800a38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a3c:	89 04 24             	mov    %eax,(%esp)
  800a3f:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a42:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a46:	eb 12                	jmp    800a5a <vprintfmt+0x22b>
  800a48:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a4b:	89 f7                	mov    %esi,%edi
  800a4d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a50:	eb 08                	jmp    800a5a <vprintfmt+0x22b>
  800a52:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a55:	89 f7                	mov    %esi,%edi
  800a57:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a5a:	0f be 03             	movsbl (%ebx),%eax
  800a5d:	83 c3 01             	add    $0x1,%ebx
  800a60:	85 c0                	test   %eax,%eax
  800a62:	74 25                	je     800a89 <vprintfmt+0x25a>
  800a64:	85 f6                	test   %esi,%esi
  800a66:	78 b2                	js     800a1a <vprintfmt+0x1eb>
  800a68:	83 ee 01             	sub    $0x1,%esi
  800a6b:	79 ad                	jns    800a1a <vprintfmt+0x1eb>
  800a6d:	89 fe                	mov    %edi,%esi
  800a6f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a72:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a75:	eb 1a                	jmp    800a91 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a77:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a82:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a84:	83 eb 01             	sub    $0x1,%ebx
  800a87:	eb 08                	jmp    800a91 <vprintfmt+0x262>
  800a89:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a8c:	89 fe                	mov    %edi,%esi
  800a8e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a91:	85 db                	test   %ebx,%ebx
  800a93:	7f e2                	jg     800a77 <vprintfmt+0x248>
  800a95:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a98:	e9 be fd ff ff       	jmp    80085b <vprintfmt+0x2c>
  800a9d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800aa0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800aa3:	83 f9 01             	cmp    $0x1,%ecx
  800aa6:	7e 16                	jle    800abe <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	8d 50 08             	lea    0x8(%eax),%edx
  800aae:	89 55 14             	mov    %edx,0x14(%ebp)
  800ab1:	8b 10                	mov    (%eax),%edx
  800ab3:	8b 48 04             	mov    0x4(%eax),%ecx
  800ab6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800ab9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800abc:	eb 32                	jmp    800af0 <vprintfmt+0x2c1>
	else if (lflag)
  800abe:	85 c9                	test   %ecx,%ecx
  800ac0:	74 18                	je     800ada <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac5:	8d 50 04             	lea    0x4(%eax),%edx
  800ac8:	89 55 14             	mov    %edx,0x14(%ebp)
  800acb:	8b 00                	mov    (%eax),%eax
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad0:	89 c1                	mov    %eax,%ecx
  800ad2:	c1 f9 1f             	sar    $0x1f,%ecx
  800ad5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ad8:	eb 16                	jmp    800af0 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	8d 50 04             	lea    0x4(%eax),%edx
  800ae0:	89 55 14             	mov    %edx,0x14(%ebp)
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae8:	89 c2                	mov    %eax,%edx
  800aea:	c1 fa 1f             	sar    $0x1f,%edx
  800aed:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800af0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800af3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800af6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800afb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aff:	0f 89 a7 00 00 00    	jns    800bac <vprintfmt+0x37d>
				putch('-', putdat);
  800b05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b09:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b10:	ff d7                	call   *%edi
				num = -(long long) num;
  800b12:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800b15:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b18:	f7 d9                	neg    %ecx
  800b1a:	83 d3 00             	adc    $0x0,%ebx
  800b1d:	f7 db                	neg    %ebx
  800b1f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b24:	e9 83 00 00 00       	jmp    800bac <vprintfmt+0x37d>
  800b29:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b2c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b2f:	89 ca                	mov    %ecx,%edx
  800b31:	8d 45 14             	lea    0x14(%ebp),%eax
  800b34:	e8 9f fc ff ff       	call   8007d8 <getuint>
  800b39:	89 c1                	mov    %eax,%ecx
  800b3b:	89 d3                	mov    %edx,%ebx
  800b3d:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800b42:	eb 68                	jmp    800bac <vprintfmt+0x37d>
  800b44:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b47:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b4a:	89 ca                	mov    %ecx,%edx
  800b4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b4f:	e8 84 fc ff ff       	call   8007d8 <getuint>
  800b54:	89 c1                	mov    %eax,%ecx
  800b56:	89 d3                	mov    %edx,%ebx
  800b58:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b5d:	eb 4d                	jmp    800bac <vprintfmt+0x37d>
  800b5f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b62:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b66:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b6d:	ff d7                	call   *%edi
			putch('x', putdat);
  800b6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b73:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b7a:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7f:	8d 50 04             	lea    0x4(%eax),%edx
  800b82:	89 55 14             	mov    %edx,0x14(%ebp)
  800b85:	8b 08                	mov    (%eax),%ecx
  800b87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b8c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b91:	eb 19                	jmp    800bac <vprintfmt+0x37d>
  800b93:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b96:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b99:	89 ca                	mov    %ecx,%edx
  800b9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9e:	e8 35 fc ff ff       	call   8007d8 <getuint>
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	89 d3                	mov    %edx,%ebx
  800ba7:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bac:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800bb0:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800bb7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bbf:	89 0c 24             	mov    %ecx,(%esp)
  800bc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bc6:	89 f2                	mov    %esi,%edx
  800bc8:	89 f8                	mov    %edi,%eax
  800bca:	e8 21 fb ff ff       	call   8006f0 <printnum>
  800bcf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bd2:	e9 84 fc ff ff       	jmp    80085b <vprintfmt+0x2c>
  800bd7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bda:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bde:	89 04 24             	mov    %eax,(%esp)
  800be1:	ff d7                	call   *%edi
  800be3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800be6:	e9 70 fc ff ff       	jmp    80085b <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800beb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bef:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bf6:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800bfb:	80 38 25             	cmpb   $0x25,(%eax)
  800bfe:	0f 84 57 fc ff ff    	je     80085b <vprintfmt+0x2c>
  800c04:	89 c3                	mov    %eax,%ebx
  800c06:	eb f0                	jmp    800bf8 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800c08:	83 c4 4c             	add    $0x4c,%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 28             	sub    $0x28,%esp
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	74 04                	je     800c24 <vsnprintf+0x14>
  800c20:	85 d2                	test   %edx,%edx
  800c22:	7f 07                	jg     800c2b <vsnprintf+0x1b>
  800c24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c29:	eb 3b                	jmp    800c66 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c51:	c7 04 24 12 08 80 00 	movl   $0x800812,(%esp)
  800c58:	e8 d2 fb ff ff       	call   80082f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c60:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c6e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	89 04 24             	mov    %eax,(%esp)
  800c89:	e8 82 ff ff ff       	call   800c10 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c96:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c99:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	89 04 24             	mov    %eax,(%esp)
  800cb1:	e8 79 fb ff ff       	call   80082f <vprintfmt>
	va_end(ap);
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    
	...

00800cc0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccb:	eb 03                	jmp    800cd0 <strlen+0x10>
		n++;
  800ccd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cd4:	75 f7                	jne    800ccd <strlen+0xd>
		n++;
	return n;
}
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	53                   	push   %ebx
  800cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce7:	eb 03                	jmp    800cec <strnlen+0x14>
		n++;
  800ce9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cec:	39 c1                	cmp    %eax,%ecx
  800cee:	74 06                	je     800cf6 <strnlen+0x1e>
  800cf0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800cf4:	75 f3                	jne    800ce9 <strnlen+0x11>
		n++;
	return n;
}
  800cf6:	5b                   	pop    %ebx
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	53                   	push   %ebx
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d03:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d08:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d0c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d0f:	83 c2 01             	add    $0x1,%edx
  800d12:	84 c9                	test   %cl,%cl
  800d14:	75 f2                	jne    800d08 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d16:	5b                   	pop    %ebx
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d23:	89 1c 24             	mov    %ebx,(%esp)
  800d26:	e8 95 ff ff ff       	call   800cc0 <strlen>
	strcpy(dst + len, src);
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d32:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800d35:	89 04 24             	mov    %eax,(%esp)
  800d38:	e8 bc ff ff ff       	call   800cf9 <strcpy>
	return dst;
}
  800d3d:	89 d8                	mov    %ebx,%eax
  800d3f:	83 c4 08             	add    $0x8,%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	8b 75 10             	mov    0x10(%ebp),%esi
  800d53:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d58:	eb 0f                	jmp    800d69 <strncpy+0x24>
		*dst++ = *src;
  800d5a:	0f b6 19             	movzbl (%ecx),%ebx
  800d5d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d60:	80 39 01             	cmpb   $0x1,(%ecx)
  800d63:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d66:	83 c2 01             	add    $0x1,%edx
  800d69:	39 f2                	cmp    %esi,%edx
  800d6b:	72 ed                	jb     800d5a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	8b 75 08             	mov    0x8(%ebp),%esi
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d7f:	89 f0                	mov    %esi,%eax
  800d81:	85 d2                	test   %edx,%edx
  800d83:	75 0a                	jne    800d8f <strlcpy+0x1e>
  800d85:	eb 17                	jmp    800d9e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d87:	88 18                	mov    %bl,(%eax)
  800d89:	83 c0 01             	add    $0x1,%eax
  800d8c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8f:	83 ea 01             	sub    $0x1,%edx
  800d92:	74 07                	je     800d9b <strlcpy+0x2a>
  800d94:	0f b6 19             	movzbl (%ecx),%ebx
  800d97:	84 db                	test   %bl,%bl
  800d99:	75 ec                	jne    800d87 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800d9b:	c6 00 00             	movb   $0x0,(%eax)
  800d9e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800daa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dad:	eb 06                	jmp    800db5 <strcmp+0x11>
		p++, q++;
  800daf:	83 c1 01             	add    $0x1,%ecx
  800db2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db5:	0f b6 01             	movzbl (%ecx),%eax
  800db8:	84 c0                	test   %al,%al
  800dba:	74 04                	je     800dc0 <strcmp+0x1c>
  800dbc:	3a 02                	cmp    (%edx),%al
  800dbe:	74 ef                	je     800daf <strcmp+0xb>
  800dc0:	0f b6 c0             	movzbl %al,%eax
  800dc3:	0f b6 12             	movzbl (%edx),%edx
  800dc6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	53                   	push   %ebx
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800dd7:	eb 09                	jmp    800de2 <strncmp+0x18>
		n--, p++, q++;
  800dd9:	83 ea 01             	sub    $0x1,%edx
  800ddc:	83 c0 01             	add    $0x1,%eax
  800ddf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800de2:	85 d2                	test   %edx,%edx
  800de4:	75 07                	jne    800ded <strncmp+0x23>
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	eb 13                	jmp    800e00 <strncmp+0x36>
  800ded:	0f b6 18             	movzbl (%eax),%ebx
  800df0:	84 db                	test   %bl,%bl
  800df2:	74 04                	je     800df8 <strncmp+0x2e>
  800df4:	3a 19                	cmp    (%ecx),%bl
  800df6:	74 e1                	je     800dd9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df8:	0f b6 00             	movzbl (%eax),%eax
  800dfb:	0f b6 11             	movzbl (%ecx),%edx
  800dfe:	29 d0                	sub    %edx,%eax
}
  800e00:	5b                   	pop    %ebx
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e0d:	eb 07                	jmp    800e16 <strchr+0x13>
		if (*s == c)
  800e0f:	38 ca                	cmp    %cl,%dl
  800e11:	74 0f                	je     800e22 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e13:	83 c0 01             	add    $0x1,%eax
  800e16:	0f b6 10             	movzbl (%eax),%edx
  800e19:	84 d2                	test   %dl,%dl
  800e1b:	75 f2                	jne    800e0f <strchr+0xc>
  800e1d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e2e:	eb 07                	jmp    800e37 <strfind+0x13>
		if (*s == c)
  800e30:	38 ca                	cmp    %cl,%dl
  800e32:	74 0a                	je     800e3e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e34:	83 c0 01             	add    $0x1,%eax
  800e37:	0f b6 10             	movzbl (%eax),%edx
  800e3a:	84 d2                	test   %dl,%dl
  800e3c:	75 f2                	jne    800e30 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 0c             	sub    $0xc,%esp
  800e46:	89 1c 24             	mov    %ebx,(%esp)
  800e49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e51:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e5a:	85 c9                	test   %ecx,%ecx
  800e5c:	74 30                	je     800e8e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e5e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e64:	75 25                	jne    800e8b <memset+0x4b>
  800e66:	f6 c1 03             	test   $0x3,%cl
  800e69:	75 20                	jne    800e8b <memset+0x4b>
		c &= 0xFF;
  800e6b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e6e:	89 d3                	mov    %edx,%ebx
  800e70:	c1 e3 08             	shl    $0x8,%ebx
  800e73:	89 d6                	mov    %edx,%esi
  800e75:	c1 e6 18             	shl    $0x18,%esi
  800e78:	89 d0                	mov    %edx,%eax
  800e7a:	c1 e0 10             	shl    $0x10,%eax
  800e7d:	09 f0                	or     %esi,%eax
  800e7f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800e81:	09 d8                	or     %ebx,%eax
  800e83:	c1 e9 02             	shr    $0x2,%ecx
  800e86:	fc                   	cld    
  800e87:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e89:	eb 03                	jmp    800e8e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e8b:	fc                   	cld    
  800e8c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e8e:	89 f8                	mov    %edi,%eax
  800e90:	8b 1c 24             	mov    (%esp),%ebx
  800e93:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e97:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e9b:	89 ec                	mov    %ebp,%esp
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	89 34 24             	mov    %esi,(%esp)
  800ea8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800eb2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800eb5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800eb7:	39 c6                	cmp    %eax,%esi
  800eb9:	73 35                	jae    800ef0 <memmove+0x51>
  800ebb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ebe:	39 d0                	cmp    %edx,%eax
  800ec0:	73 2e                	jae    800ef0 <memmove+0x51>
		s += n;
		d += n;
  800ec2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ec4:	f6 c2 03             	test   $0x3,%dl
  800ec7:	75 1b                	jne    800ee4 <memmove+0x45>
  800ec9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ecf:	75 13                	jne    800ee4 <memmove+0x45>
  800ed1:	f6 c1 03             	test   $0x3,%cl
  800ed4:	75 0e                	jne    800ee4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ed6:	83 ef 04             	sub    $0x4,%edi
  800ed9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800edc:	c1 e9 02             	shr    $0x2,%ecx
  800edf:	fd                   	std    
  800ee0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ee2:	eb 09                	jmp    800eed <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ee4:	83 ef 01             	sub    $0x1,%edi
  800ee7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800eea:	fd                   	std    
  800eeb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800eed:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eee:	eb 20                	jmp    800f10 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ef0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ef6:	75 15                	jne    800f0d <memmove+0x6e>
  800ef8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800efe:	75 0d                	jne    800f0d <memmove+0x6e>
  800f00:	f6 c1 03             	test   $0x3,%cl
  800f03:	75 08                	jne    800f0d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800f05:	c1 e9 02             	shr    $0x2,%ecx
  800f08:	fc                   	cld    
  800f09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f0b:	eb 03                	jmp    800f10 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f0d:	fc                   	cld    
  800f0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f10:	8b 34 24             	mov    (%esp),%esi
  800f13:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800f17:	89 ec                	mov    %ebp,%esp
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 04 24             	mov    %eax,(%esp)
  800f35:	e8 65 ff ff ff       	call   800e9f <memmove>
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f4b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f50:	eb 1c                	jmp    800f6e <memcmp+0x32>
		if (*s1 != *s2)
  800f52:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800f56:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800f5a:	83 c2 01             	add    $0x1,%edx
  800f5d:	83 e9 01             	sub    $0x1,%ecx
  800f60:	38 d8                	cmp    %bl,%al
  800f62:	74 0a                	je     800f6e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800f64:	0f b6 c0             	movzbl %al,%eax
  800f67:	0f b6 db             	movzbl %bl,%ebx
  800f6a:	29 d8                	sub    %ebx,%eax
  800f6c:	eb 09                	jmp    800f77 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f6e:	85 c9                	test   %ecx,%ecx
  800f70:	75 e0                	jne    800f52 <memcmp+0x16>
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f85:	89 c2                	mov    %eax,%edx
  800f87:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f8a:	eb 07                	jmp    800f93 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8c:	38 08                	cmp    %cl,(%eax)
  800f8e:	74 07                	je     800f97 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f90:	83 c0 01             	add    $0x1,%eax
  800f93:	39 d0                	cmp    %edx,%eax
  800f95:	72 f5                	jb     800f8c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    

00800f99 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	57                   	push   %edi
  800f9d:	56                   	push   %esi
  800f9e:	53                   	push   %ebx
  800f9f:	83 ec 04             	sub    $0x4,%esp
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa8:	eb 03                	jmp    800fad <strtol+0x14>
		s++;
  800faa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fad:	0f b6 02             	movzbl (%edx),%eax
  800fb0:	3c 20                	cmp    $0x20,%al
  800fb2:	74 f6                	je     800faa <strtol+0x11>
  800fb4:	3c 09                	cmp    $0x9,%al
  800fb6:	74 f2                	je     800faa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb8:	3c 2b                	cmp    $0x2b,%al
  800fba:	75 0c                	jne    800fc8 <strtol+0x2f>
		s++;
  800fbc:	8d 52 01             	lea    0x1(%edx),%edx
  800fbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fc6:	eb 15                	jmp    800fdd <strtol+0x44>
	else if (*s == '-')
  800fc8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcf:	3c 2d                	cmp    $0x2d,%al
  800fd1:	75 0a                	jne    800fdd <strtol+0x44>
		s++, neg = 1;
  800fd3:	8d 52 01             	lea    0x1(%edx),%edx
  800fd6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fdd:	85 db                	test   %ebx,%ebx
  800fdf:	0f 94 c0             	sete   %al
  800fe2:	74 05                	je     800fe9 <strtol+0x50>
  800fe4:	83 fb 10             	cmp    $0x10,%ebx
  800fe7:	75 15                	jne    800ffe <strtol+0x65>
  800fe9:	80 3a 30             	cmpb   $0x30,(%edx)
  800fec:	75 10                	jne    800ffe <strtol+0x65>
  800fee:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ff2:	75 0a                	jne    800ffe <strtol+0x65>
		s += 2, base = 16;
  800ff4:	83 c2 02             	add    $0x2,%edx
  800ff7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffc:	eb 13                	jmp    801011 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ffe:	84 c0                	test   %al,%al
  801000:	74 0f                	je     801011 <strtol+0x78>
  801002:	bb 0a 00 00 00       	mov    $0xa,%ebx
  801007:	80 3a 30             	cmpb   $0x30,(%edx)
  80100a:	75 05                	jne    801011 <strtol+0x78>
		s++, base = 8;
  80100c:	83 c2 01             	add    $0x1,%edx
  80100f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
  801016:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801018:	0f b6 0a             	movzbl (%edx),%ecx
  80101b:	89 cf                	mov    %ecx,%edi
  80101d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801020:	80 fb 09             	cmp    $0x9,%bl
  801023:	77 08                	ja     80102d <strtol+0x94>
			dig = *s - '0';
  801025:	0f be c9             	movsbl %cl,%ecx
  801028:	83 e9 30             	sub    $0x30,%ecx
  80102b:	eb 1e                	jmp    80104b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  80102d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801030:	80 fb 19             	cmp    $0x19,%bl
  801033:	77 08                	ja     80103d <strtol+0xa4>
			dig = *s - 'a' + 10;
  801035:	0f be c9             	movsbl %cl,%ecx
  801038:	83 e9 57             	sub    $0x57,%ecx
  80103b:	eb 0e                	jmp    80104b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  80103d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801040:	80 fb 19             	cmp    $0x19,%bl
  801043:	77 15                	ja     80105a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801045:	0f be c9             	movsbl %cl,%ecx
  801048:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80104b:	39 f1                	cmp    %esi,%ecx
  80104d:	7d 0b                	jge    80105a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80104f:	83 c2 01             	add    $0x1,%edx
  801052:	0f af c6             	imul   %esi,%eax
  801055:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801058:	eb be                	jmp    801018 <strtol+0x7f>
  80105a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80105c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801060:	74 05                	je     801067 <strtol+0xce>
		*endptr = (char *) s;
  801062:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801065:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801067:	89 ca                	mov    %ecx,%edx
  801069:	f7 da                	neg    %edx
  80106b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80106f:	0f 45 c2             	cmovne %edx,%eax
}
  801072:	83 c4 04             	add    $0x4,%esp
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    
	...

0080107c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 0c             	sub    $0xc,%esp
  801082:	89 1c 24             	mov    %ebx,(%esp)
  801085:	89 74 24 04          	mov    %esi,0x4(%esp)
  801089:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108d:	ba 00 00 00 00       	mov    $0x0,%edx
  801092:	b8 01 00 00 00       	mov    $0x1,%eax
  801097:	89 d1                	mov    %edx,%ecx
  801099:	89 d3                	mov    %edx,%ebx
  80109b:	89 d7                	mov    %edx,%edi
  80109d:	89 d6                	mov    %edx,%esi
  80109f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010a1:	8b 1c 24             	mov    (%esp),%ebx
  8010a4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ac:	89 ec                	mov    %ebp,%esp
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	89 1c 24             	mov    %ebx,(%esp)
  8010b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010bd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	89 c3                	mov    %eax,%ebx
  8010ce:	89 c7                	mov    %eax,%edi
  8010d0:	89 c6                	mov    %eax,%esi
  8010d2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010d4:	8b 1c 24             	mov    (%esp),%ebx
  8010d7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010db:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010df:	89 ec                	mov    %ebp,%esp
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	89 1c 24             	mov    %ebx,(%esp)
  8010ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010f0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8010fe:	89 d1                	mov    %edx,%ecx
  801100:	89 d3                	mov    %edx,%ebx
  801102:	89 d7                	mov    %edx,%edi
  801104:	89 d6                	mov    %edx,%esi
  801106:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801108:	8b 1c 24             	mov    (%esp),%ebx
  80110b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80110f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801113:	89 ec                	mov    %ebp,%esp
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 38             	sub    $0x38,%esp
  80111d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801120:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801123:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801126:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801130:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 df                	mov    %ebx,%edi
  801138:	89 de                	mov    %ebx,%esi
  80113a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	7e 28                	jle    801168 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801140:	89 44 24 10          	mov    %eax,0x10(%esp)
  801144:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80114b:	00 
  80114c:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  801153:	00 
  801154:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80115b:	00 
  80115c:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  801163:	e8 70 f4 ff ff       	call   8005d8 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801168:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80116b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80116e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801171:	89 ec                	mov    %ebp,%esp
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    

00801175 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 38             	sub    $0x38,%esp
  80117b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80117e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801181:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801184:	bb 00 00 00 00       	mov    $0x0,%ebx
  801189:	b8 0e 00 00 00       	mov    $0xe,%eax
  80118e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801191:	8b 55 08             	mov    0x8(%ebp),%edx
  801194:	89 df                	mov    %ebx,%edi
  801196:	89 de                	mov    %ebx,%esi
  801198:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	7e 28                	jle    8011c6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80119e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8011a9:	00 
  8011aa:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  8011b1:	00 
  8011b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b9:	00 
  8011ba:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  8011c1:	e8 12 f4 ff ff       	call   8005d8 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8011c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011cc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011cf:	89 ec                	mov    %ebp,%esp
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 38             	sub    $0x38,%esp
  8011d9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011df:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ef:	89 cb                	mov    %ecx,%ebx
  8011f1:	89 cf                	mov    %ecx,%edi
  8011f3:	89 ce                	mov    %ecx,%esi
  8011f5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	7e 28                	jle    801223 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801206:	00 
  801207:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  80120e:	00 
  80120f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801216:	00 
  801217:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  80121e:	e8 b5 f3 ff ff       	call   8005d8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801223:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801226:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801229:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80122c:	89 ec                	mov    %ebp,%esp
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	89 1c 24             	mov    %ebx,(%esp)
  801239:	89 74 24 04          	mov    %esi,0x4(%esp)
  80123d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801241:	be 00 00 00 00       	mov    $0x0,%esi
  801246:	b8 0c 00 00 00       	mov    $0xc,%eax
  80124b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80124e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801254:	8b 55 08             	mov    0x8(%ebp),%edx
  801257:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801259:	8b 1c 24             	mov    (%esp),%ebx
  80125c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801260:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801264:	89 ec                	mov    %ebp,%esp
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 38             	sub    $0x38,%esp
  80126e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801271:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801274:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801277:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801281:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801284:	8b 55 08             	mov    0x8(%ebp),%edx
  801287:	89 df                	mov    %ebx,%edi
  801289:	89 de                	mov    %ebx,%esi
  80128b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80128d:	85 c0                	test   %eax,%eax
  80128f:	7e 28                	jle    8012b9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801291:	89 44 24 10          	mov    %eax,0x10(%esp)
  801295:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80129c:	00 
  80129d:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ac:	00 
  8012ad:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  8012b4:	e8 1f f3 ff ff       	call   8005d8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012c2:	89 ec                	mov    %ebp,%esp
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 38             	sub    $0x38,%esp
  8012cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012da:	b8 09 00 00 00       	mov    $0x9,%eax
  8012df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e5:	89 df                	mov    %ebx,%edi
  8012e7:	89 de                	mov    %ebx,%esi
  8012e9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	7e 28                	jle    801317 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012fa:	00 
  8012fb:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  801302:	00 
  801303:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80130a:	00 
  80130b:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  801312:	e8 c1 f2 ff ff       	call   8005d8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801317:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80131a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80131d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801320:	89 ec                	mov    %ebp,%esp
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 38             	sub    $0x38,%esp
  80132a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80132d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801330:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801333:	bb 00 00 00 00       	mov    $0x0,%ebx
  801338:	b8 08 00 00 00       	mov    $0x8,%eax
  80133d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801340:	8b 55 08             	mov    0x8(%ebp),%edx
  801343:	89 df                	mov    %ebx,%edi
  801345:	89 de                	mov    %ebx,%esi
  801347:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801349:	85 c0                	test   %eax,%eax
  80134b:	7e 28                	jle    801375 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80134d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801351:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801358:	00 
  801359:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  801360:	00 
  801361:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801368:	00 
  801369:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  801370:	e8 63 f2 ff ff       	call   8005d8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801375:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801378:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80137b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80137e:	89 ec                	mov    %ebp,%esp
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    

00801382 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 38             	sub    $0x38,%esp
  801388:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80138b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80138e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801391:	bb 00 00 00 00       	mov    $0x0,%ebx
  801396:	b8 06 00 00 00       	mov    $0x6,%eax
  80139b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139e:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a1:	89 df                	mov    %ebx,%edi
  8013a3:	89 de                	mov    %ebx,%esi
  8013a5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	7e 28                	jle    8013d3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013af:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8013b6:	00 
  8013b7:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  8013be:	00 
  8013bf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013c6:	00 
  8013c7:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  8013ce:	e8 05 f2 ff ff       	call   8005d8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013d6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013d9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013dc:	89 ec                	mov    %ebp,%esp
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 38             	sub    $0x38,%esp
  8013e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8013f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8013f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801400:	8b 55 08             	mov    0x8(%ebp),%edx
  801403:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801405:	85 c0                	test   %eax,%eax
  801407:	7e 28                	jle    801431 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801409:	89 44 24 10          	mov    %eax,0x10(%esp)
  80140d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801414:	00 
  801415:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  80141c:	00 
  80141d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801424:	00 
  801425:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  80142c:	e8 a7 f1 ff ff       	call   8005d8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801431:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801434:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801437:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80143a:	89 ec                	mov    %ebp,%esp
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 38             	sub    $0x38,%esp
  801444:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801447:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80144a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144d:	be 00 00 00 00       	mov    $0x0,%esi
  801452:	b8 04 00 00 00       	mov    $0x4,%eax
  801457:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80145a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	89 f7                	mov    %esi,%edi
  801462:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801464:	85 c0                	test   %eax,%eax
  801466:	7e 28                	jle    801490 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801468:	89 44 24 10          	mov    %eax,0x10(%esp)
  80146c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801473:	00 
  801474:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  80148b:	e8 48 f1 ff ff       	call   8005d8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801490:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801493:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801496:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801499:	89 ec                	mov    %ebp,%esp
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	89 1c 24             	mov    %ebx,(%esp)
  8014a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8014b8:	89 d1                	mov    %edx,%ecx
  8014ba:	89 d3                	mov    %edx,%ebx
  8014bc:	89 d7                	mov    %edx,%edi
  8014be:	89 d6                	mov    %edx,%esi
  8014c0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8014c2:	8b 1c 24             	mov    (%esp),%ebx
  8014c5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014c9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8014cd:	89 ec                	mov    %ebp,%esp
  8014cf:	5d                   	pop    %ebp
  8014d0:	c3                   	ret    

008014d1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	89 1c 24             	mov    %ebx,(%esp)
  8014da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014de:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8014ec:	89 d1                	mov    %edx,%ecx
  8014ee:	89 d3                	mov    %edx,%ebx
  8014f0:	89 d7                	mov    %edx,%edi
  8014f2:	89 d6                	mov    %edx,%esi
  8014f4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014f6:	8b 1c 24             	mov    (%esp),%ebx
  8014f9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014fd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801501:	89 ec                	mov    %ebp,%esp
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 38             	sub    $0x38,%esp
  80150b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80150e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801511:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801514:	b9 00 00 00 00       	mov    $0x0,%ecx
  801519:	b8 03 00 00 00       	mov    $0x3,%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 cb                	mov    %ecx,%ebx
  801523:	89 cf                	mov    %ecx,%edi
  801525:	89 ce                	mov    %ecx,%esi
  801527:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801529:	85 c0                	test   %eax,%eax
  80152b:	7e 28                	jle    801555 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80152d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801531:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801538:	00 
  801539:	c7 44 24 08 67 3b 80 	movl   $0x803b67,0x8(%esp)
  801540:	00 
  801541:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801548:	00 
  801549:	c7 04 24 84 3b 80 00 	movl   $0x803b84,(%esp)
  801550:	e8 83 f0 ff ff       	call   8005d8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801555:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801558:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80155b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80155e:	89 ec                	mov    %ebp,%esp
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    
	...

00801564 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80156a:	c7 44 24 08 92 3b 80 	movl   $0x803b92,0x8(%esp)
  801571:	00 
  801572:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801579:	00 
  80157a:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  801581:	e8 52 f0 ff ff       	call   8005d8 <_panic>

00801586 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	57                   	push   %edi
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
  80158c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80158f:	c7 04 24 f4 17 80 00 	movl   $0x8017f4,(%esp)
  801596:	e8 8d 1c 00 00       	call   803228 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80159b:	ba 07 00 00 00       	mov    $0x7,%edx
  8015a0:	89 d0                	mov    %edx,%eax
  8015a2:	cd 30                	int    $0x30
  8015a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	79 20                	jns    8015cb <fork+0x45>
		panic("sys_exofork: %e", envid);
  8015ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015af:	c7 44 24 08 b3 3b 80 	movl   $0x803bb3,0x8(%esp)
  8015b6:	00 
  8015b7:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8015be:	00 
  8015bf:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  8015c6:	e8 0d f0 ff ff       	call   8005d8 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  8015cb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  8015d2:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  8015d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8015db:	75 21                	jne    8015fe <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  8015dd:	e8 ef fe ff ff       	call   8014d1 <sys_getenvid>
  8015e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015ef:	a3 08 50 80 00       	mov    %eax,0x805008
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8015f9:	e9 e5 01 00 00       	jmp    8017e3 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  8015fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801601:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801608:	a8 01                	test   $0x1,%al
  80160a:	0f 84 4c 01 00 00    	je     80175c <fork+0x1d6>
  801610:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801616:	0f 84 cf 01 00 00    	je     8017eb <fork+0x265>
		{
			addr = i << PDXSHIFT;
  80161c:	c1 e2 16             	shl    $0x16,%edx
  80161f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801622:	89 d3                	mov    %edx,%ebx
  801624:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80162b:	00 
  80162c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801633:	89 04 24             	mov    %eax,(%esp)
  801636:	e8 03 fe ff ff       	call   80143e <sys_page_alloc>
			if(ret < 0) return ret;
  80163b:	85 c0                	test   %eax,%eax
  80163d:	0f 88 a0 01 00 00    	js     8017e3 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801643:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801647:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80164a:	89 14 24             	mov    %edx,(%esp)
  80164d:	e8 30 fd ff ff       	call   801382 <sys_page_unmap>
			if(ret < 0) return ret;
  801652:	85 c0                	test   %eax,%eax
  801654:	0f 88 89 01 00 00    	js     8017e3 <fork+0x25d>
  80165a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80165f:	89 de                	mov    %ebx,%esi
  801661:	c1 e6 0c             	shl    $0xc,%esi
  801664:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801667:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80166d:	0f 84 da 00 00 00    	je     80174d <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801673:	c1 ee 0c             	shr    $0xc,%esi
  801676:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801679:	a8 01                	test   $0x1,%al
  80167b:	0f 84 cc 00 00 00    	je     80174d <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801681:	89 f0                	mov    %esi,%eax
  801683:	c1 e0 0c             	shl    $0xc,%eax
  801686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801689:	e8 43 fe ff ff       	call   8014d1 <sys_getenvid>
  80168e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801691:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801694:	89 c6                	mov    %eax,%esi
  801696:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80169c:	25 01 04 00 00       	and    $0x401,%eax
  8016a1:	3d 01 04 00 00       	cmp    $0x401,%eax
  8016a6:	75 3a                	jne    8016e2 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  8016a8:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8016af:	00 
  8016b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016c5:	89 14 24             	mov    %edx,(%esp)
  8016c8:	e8 13 fd ff ff       	call   8013e0 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  8016cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d4:	c7 04 24 c3 3b 80 00 	movl   $0x803bc3,(%esp)
  8016db:	e8 b1 ef ff ff       	call   800691 <cprintf>
  8016e0:	eb 6b                	jmp    80174d <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  8016e2:	f7 c6 01 00 00 00    	test   $0x1,%esi
  8016e8:	74 14                	je     8016fe <fork+0x178>
  8016ea:	f7 c6 02 08 00 00    	test   $0x802,%esi
  8016f0:	74 0c                	je     8016fe <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  8016f2:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  8016f8:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  8016fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801701:	89 74 24 10          	mov    %esi,0x10(%esp)
  801705:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801709:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80170c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801710:	89 54 24 04          	mov    %edx,0x4(%esp)
  801714:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801717:	89 14 24             	mov    %edx,(%esp)
  80171a:	e8 c1 fc ff ff       	call   8013e0 <sys_page_map>
	if(ret<0) return ret;
  80171f:	85 c0                	test   %eax,%eax
  801721:	0f 88 bc 00 00 00    	js     8017e3 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801727:	89 74 24 10          	mov    %esi,0x10(%esp)
  80172b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801732:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801735:	89 54 24 08          	mov    %edx,0x8(%esp)
  801739:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173d:	89 14 24             	mov    %edx,(%esp)
  801740:	e8 9b fc ff ff       	call   8013e0 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801745:	85 c0                	test   %eax,%eax
  801747:	0f 88 96 00 00 00    	js     8017e3 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  80174d:	83 c3 01             	add    $0x1,%ebx
  801750:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801756:	0f 85 03 ff ff ff    	jne    80165f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80175c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801760:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801767:	0f 85 91 fe ff ff    	jne    8015fe <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80176d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801774:	00 
  801775:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80177c:	ee 
  80177d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801780:	89 04 24             	mov    %eax,(%esp)
  801783:	e8 b6 fc ff ff       	call   80143e <sys_page_alloc>
	if(ret < 0) return ret;
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 57                	js     8017e3 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80178c:	a1 08 50 80 00       	mov    0x805008,%eax
  801791:	8b 40 64             	mov    0x64(%eax),%eax
  801794:	89 44 24 04          	mov    %eax,0x4(%esp)
  801798:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80179b:	89 14 24             	mov    %edx,(%esp)
  80179e:	e8 c5 fa ff ff       	call   801268 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 3c                	js     8017e3 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8017a7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8017ae:	00 
  8017af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b2:	89 04 24             	mov    %eax,(%esp)
  8017b5:	e8 6a fb ff ff       	call   801324 <sys_env_set_status>
  8017ba:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  8017bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8017bf:	85 d2                	test   %edx,%edx
  8017c1:	79 20                	jns    8017e3 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  8017c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017c7:	c7 44 24 08 da 3b 80 	movl   $0x803bda,0x8(%esp)
  8017ce:	00 
  8017cf:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8017d6:	00 
  8017d7:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  8017de:	e8 f5 ed ff ff       	call   8005d8 <_panic>

	return envid;
}
  8017e3:	83 c4 4c             	add    $0x4c,%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5f                   	pop    %edi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8017eb:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  8017ef:	e9 0a fe ff ff       	jmp    8015fe <fork+0x78>

008017f4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  8017fc:	e8 d0 fc ff ff       	call   8014d1 <sys_getenvid>
  801801:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8b 00                	mov    (%eax),%eax
  801808:	89 c6                	mov    %eax,%esi
  80180a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  80180d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801814:	f6 c2 02             	test   $0x2,%dl
  801817:	75 2c                	jne    801845 <pgfault+0x51>
  801819:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801820:	f6 c6 08             	test   $0x8,%dh
  801823:	75 20                	jne    801845 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801825:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801829:	c7 44 24 08 28 3c 80 	movl   $0x803c28,0x8(%esp)
  801830:	00 
  801831:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801838:	00 
  801839:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  801840:	e8 93 ed ff ff       	call   8005d8 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801845:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80184c:	00 
  80184d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801854:	00 
  801855:	89 1c 24             	mov    %ebx,(%esp)
  801858:	e8 e1 fb ff ff       	call   80143e <sys_page_alloc>
  80185d:	85 c0                	test   %eax,%eax
  80185f:	79 20                	jns    801881 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801861:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801865:	c7 44 24 08 f1 3b 80 	movl   $0x803bf1,0x8(%esp)
  80186c:	00 
  80186d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801874:	00 
  801875:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  80187c:	e8 57 ed ff ff       	call   8005d8 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801881:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801884:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80188b:	00 
  80188c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801890:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801897:	e8 03 f6 ff ff       	call   800e9f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80189c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8018a3:	00 
  8018a4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8018a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ac:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8018b3:	00 
  8018b4:	89 1c 24             	mov    %ebx,(%esp)
  8018b7:	e8 24 fb ff ff       	call   8013e0 <sys_page_map>
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	79 20                	jns    8018e0 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  8018c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018c4:	c7 44 24 08 03 3c 80 	movl   $0x803c03,0x8(%esp)
  8018cb:	00 
  8018cc:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  8018d3:	00 
  8018d4:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  8018db:	e8 f8 ec ff ff       	call   8005d8 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  8018e0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8018e7:	00 
  8018e8:	89 1c 24             	mov    %ebx,(%esp)
  8018eb:	e8 92 fa ff ff       	call   801382 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	74 20                	je     801914 <pgfault+0x120>
  8018f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018f8:	c7 44 24 08 13 3c 80 	movl   $0x803c13,0x8(%esp)
  8018ff:	00 
  801900:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801907:	00 
  801908:	c7 04 24 a8 3b 80 00 	movl   $0x803ba8,(%esp)
  80190f:	e8 c4 ec ff ff       	call   8005d8 <_panic>

}
  801914:	83 c4 20             	add    $0x20,%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
	...

0080191c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	05 00 00 00 30       	add    $0x30000000,%eax
  801927:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    

0080192c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	89 04 24             	mov    %eax,(%esp)
  801938:	e8 df ff ff ff       	call   80191c <fd2num>
  80193d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801942:	c1 e0 0c             	shl    $0xc,%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	57                   	push   %edi
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
  80194d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801950:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801955:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  80195a:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80195f:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801961:	89 c2                	mov    %eax,%edx
  801963:	c1 ea 16             	shr    $0x16,%edx
  801966:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801969:	f6 c2 01             	test   $0x1,%dl
  80196c:	74 0d                	je     80197b <fd_alloc+0x34>
  80196e:	89 c2                	mov    %eax,%edx
  801970:	c1 ea 0c             	shr    $0xc,%edx
  801973:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  801976:	f6 c2 01             	test   $0x1,%dl
  801979:	75 09                	jne    801984 <fd_alloc+0x3d>
			*fd_store = fd;
  80197b:	89 37                	mov    %esi,(%edi)
  80197d:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801982:	eb 17                	jmp    80199b <fd_alloc+0x54>
  801984:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801989:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80198e:	75 cf                	jne    80195f <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801990:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801996:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5f                   	pop    %edi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	83 f8 1f             	cmp    $0x1f,%eax
  8019a9:	77 36                	ja     8019e1 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019ab:	05 00 00 0d 00       	add    $0xd0000,%eax
  8019b0:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019b3:	89 c2                	mov    %eax,%edx
  8019b5:	c1 ea 16             	shr    $0x16,%edx
  8019b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019bf:	f6 c2 01             	test   $0x1,%dl
  8019c2:	74 1d                	je     8019e1 <fd_lookup+0x41>
  8019c4:	89 c2                	mov    %eax,%edx
  8019c6:	c1 ea 0c             	shr    $0xc,%edx
  8019c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019d0:	f6 c2 01             	test   $0x1,%dl
  8019d3:	74 0c                	je     8019e1 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	89 02                	mov    %eax,(%edx)
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8019df:	eb 05                	jmp    8019e6 <fd_lookup+0x46>
  8019e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    

008019e8 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ee:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	89 04 24             	mov    %eax,(%esp)
  8019fb:	e8 a0 ff ff ff       	call   8019a0 <fd_lookup>
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 0e                	js     801a12 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0a:	89 50 04             	mov    %edx,0x4(%eax)
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	83 ec 10             	sub    $0x10,%esp
  801a1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a22:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801a27:	be c8 3c 80 00       	mov    $0x803cc8,%esi
  801a2c:	eb 10                	jmp    801a3e <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801a2e:	39 08                	cmp    %ecx,(%eax)
  801a30:	75 09                	jne    801a3b <dev_lookup+0x27>
			*dev = devtab[i];
  801a32:	89 03                	mov    %eax,(%ebx)
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801a39:	eb 31                	jmp    801a6c <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a3b:	83 c2 01             	add    $0x1,%edx
  801a3e:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801a41:	85 c0                	test   %eax,%eax
  801a43:	75 e9                	jne    801a2e <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a45:	a1 08 50 80 00       	mov    0x805008,%eax
  801a4a:	8b 40 48             	mov    0x48(%eax),%eax
  801a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a55:	c7 04 24 4c 3c 80 00 	movl   $0x803c4c,(%esp)
  801a5c:	e8 30 ec ff ff       	call   800691 <cprintf>
	*dev = 0;
  801a61:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    

00801a73 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	53                   	push   %ebx
  801a77:	83 ec 24             	sub    $0x24,%esp
  801a7a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	89 04 24             	mov    %eax,(%esp)
  801a8a:	e8 11 ff ff ff       	call   8019a0 <fd_lookup>
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 53                	js     801ae6 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 6d ff ff ff       	call   801a14 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 3b                	js     801ae6 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801aab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab3:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801ab7:	74 2d                	je     801ae6 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ab9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801abc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ac3:	00 00 00 
	stat->st_isdir = 0;
  801ac6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801acd:	00 00 00 
	stat->st_dev = dev;
  801ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801add:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae0:	89 14 24             	mov    %edx,(%esp)
  801ae3:	ff 50 14             	call   *0x14(%eax)
}
  801ae6:	83 c4 24             	add    $0x24,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	53                   	push   %ebx
  801af0:	83 ec 24             	sub    $0x24,%esp
  801af3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afd:	89 1c 24             	mov    %ebx,(%esp)
  801b00:	e8 9b fe ff ff       	call   8019a0 <fd_lookup>
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 5f                	js     801b68 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	89 04 24             	mov    %eax,(%esp)
  801b18:	e8 f7 fe ff ff       	call   801a14 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	78 47                	js     801b68 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b24:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801b28:	75 23                	jne    801b4d <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b2a:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b2f:	8b 40 48             	mov    0x48(%eax),%eax
  801b32:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3a:	c7 04 24 6c 3c 80 00 	movl   $0x803c6c,(%esp)
  801b41:	e8 4b eb ff ff       	call   800691 <cprintf>
  801b46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b4b:	eb 1b                	jmp    801b68 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b50:	8b 48 18             	mov    0x18(%eax),%ecx
  801b53:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b58:	85 c9                	test   %ecx,%ecx
  801b5a:	74 0c                	je     801b68 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b63:	89 14 24             	mov    %edx,(%esp)
  801b66:	ff d1                	call   *%ecx
}
  801b68:	83 c4 24             	add    $0x24,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    

00801b6e <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 24             	sub    $0x24,%esp
  801b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7f:	89 1c 24             	mov    %ebx,(%esp)
  801b82:	e8 19 fe ff ff       	call   8019a0 <fd_lookup>
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 66                	js     801bf1 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b95:	8b 00                	mov    (%eax),%eax
  801b97:	89 04 24             	mov    %eax,(%esp)
  801b9a:	e8 75 fe ff ff       	call   801a14 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 4e                	js     801bf1 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba6:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801baa:	75 23                	jne    801bcf <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bac:	a1 08 50 80 00       	mov    0x805008,%eax
  801bb1:	8b 40 48             	mov    0x48(%eax),%eax
  801bb4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	c7 04 24 8d 3c 80 00 	movl   $0x803c8d,(%esp)
  801bc3:	e8 c9 ea ff ff       	call   800691 <cprintf>
  801bc8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801bcd:	eb 22                	jmp    801bf1 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	8b 48 0c             	mov    0xc(%eax),%ecx
  801bd5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bda:	85 c9                	test   %ecx,%ecx
  801bdc:	74 13                	je     801bf1 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bde:	8b 45 10             	mov    0x10(%ebp),%eax
  801be1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bec:	89 14 24             	mov    %edx,(%esp)
  801bef:	ff d1                	call   *%ecx
}
  801bf1:	83 c4 24             	add    $0x24,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	53                   	push   %ebx
  801bfb:	83 ec 24             	sub    $0x24,%esp
  801bfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c08:	89 1c 24             	mov    %ebx,(%esp)
  801c0b:	e8 90 fd ff ff       	call   8019a0 <fd_lookup>
  801c10:	85 c0                	test   %eax,%eax
  801c12:	78 6b                	js     801c7f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1e:	8b 00                	mov    (%eax),%eax
  801c20:	89 04 24             	mov    %eax,(%esp)
  801c23:	e8 ec fd ff ff       	call   801a14 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 53                	js     801c7f <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c2f:	8b 42 08             	mov    0x8(%edx),%eax
  801c32:	83 e0 03             	and    $0x3,%eax
  801c35:	83 f8 01             	cmp    $0x1,%eax
  801c38:	75 23                	jne    801c5d <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c3a:	a1 08 50 80 00       	mov    0x805008,%eax
  801c3f:	8b 40 48             	mov    0x48(%eax),%eax
  801c42:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4a:	c7 04 24 aa 3c 80 00 	movl   $0x803caa,(%esp)
  801c51:	e8 3b ea ff ff       	call   800691 <cprintf>
  801c56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801c5b:	eb 22                	jmp    801c7f <read+0x88>
	}
	if (!dev->dev_read)
  801c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c60:	8b 48 08             	mov    0x8(%eax),%ecx
  801c63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c68:	85 c9                	test   %ecx,%ecx
  801c6a:	74 13                	je     801c7f <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7a:	89 14 24             	mov    %edx,(%esp)
  801c7d:	ff d1                	call   *%ecx
}
  801c7f:	83 c4 24             	add    $0x24,%esp
  801c82:	5b                   	pop    %ebx
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    

00801c85 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	57                   	push   %edi
  801c89:	56                   	push   %esi
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 1c             	sub    $0x1c,%esp
  801c8e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c91:	8b 75 10             	mov    0x10(%ebp),%esi
  801c94:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c99:	eb 21                	jmp    801cbc <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c9b:	89 f2                	mov    %esi,%edx
  801c9d:	29 c2                	sub    %eax,%edx
  801c9f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ca3:	03 45 0c             	add    0xc(%ebp),%eax
  801ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801caa:	89 3c 24             	mov    %edi,(%esp)
  801cad:	e8 45 ff ff ff       	call   801bf7 <read>
		if (m < 0)
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 0e                	js     801cc4 <readn+0x3f>
			return m;
		if (m == 0)
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	74 08                	je     801cc2 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cba:	01 c3                	add    %eax,%ebx
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	39 f3                	cmp    %esi,%ebx
  801cc0:	72 d9                	jb     801c9b <readn+0x16>
  801cc2:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801cc4:	83 c4 1c             	add    $0x1c,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    

00801ccc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 38             	sub    $0x38,%esp
  801cd2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cd5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cd8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cdb:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cde:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ce2:	89 3c 24             	mov    %edi,(%esp)
  801ce5:	e8 32 fc ff ff       	call   80191c <fd2num>
  801cea:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801ced:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cf1:	89 04 24             	mov    %eax,(%esp)
  801cf4:	e8 a7 fc ff ff       	call   8019a0 <fd_lookup>
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 05                	js     801d04 <fd_close+0x38>
  801cff:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801d02:	74 0e                	je     801d12 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801d04:	89 f0                	mov    %esi,%eax
  801d06:	84 c0                	test   %al,%al
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	0f 44 d8             	cmove  %eax,%ebx
  801d10:	eb 3d                	jmp    801d4f <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d12:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d19:	8b 07                	mov    (%edi),%eax
  801d1b:	89 04 24             	mov    %eax,(%esp)
  801d1e:	e8 f1 fc ff ff       	call   801a14 <dev_lookup>
  801d23:	89 c3                	mov    %eax,%ebx
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 16                	js     801d3f <fd_close+0x73>
		if (dev->dev_close)
  801d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2c:	8b 40 10             	mov    0x10(%eax),%eax
  801d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 07                	je     801d3f <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801d38:	89 3c 24             	mov    %edi,(%esp)
  801d3b:	ff d0                	call   *%eax
  801d3d:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d3f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4a:	e8 33 f6 ff ff       	call   801382 <sys_page_unmap>
	return r;
}
  801d4f:	89 d8                	mov    %ebx,%eax
  801d51:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d54:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d57:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d5a:	89 ec                	mov    %ebp,%esp
  801d5c:	5d                   	pop    %ebp
  801d5d:	c3                   	ret    

00801d5e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	89 04 24             	mov    %eax,(%esp)
  801d71:	e8 2a fc ff ff       	call   8019a0 <fd_lookup>
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 13                	js     801d8d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801d7a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d81:	00 
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	89 04 24             	mov    %eax,(%esp)
  801d88:	e8 3f ff ff ff       	call   801ccc <fd_close>
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 18             	sub    $0x18,%esp
  801d95:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d98:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801da2:	00 
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	89 04 24             	mov    %eax,(%esp)
  801da9:	e8 25 04 00 00       	call   8021d3 <open>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 1b                	js     801dcf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbb:	89 1c 24             	mov    %ebx,(%esp)
  801dbe:	e8 b0 fc ff ff       	call   801a73 <fstat>
  801dc3:	89 c6                	mov    %eax,%esi
	close(fd);
  801dc5:	89 1c 24             	mov    %ebx,(%esp)
  801dc8:	e8 91 ff ff ff       	call   801d5e <close>
  801dcd:	89 f3                	mov    %esi,%ebx
	return r;
}
  801dcf:	89 d8                	mov    %ebx,%eax
  801dd1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dd4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dd7:	89 ec                	mov    %ebp,%esp
  801dd9:	5d                   	pop    %ebp
  801dda:	c3                   	ret    

00801ddb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 14             	sub    $0x14,%esp
  801de2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801de7:	89 1c 24             	mov    %ebx,(%esp)
  801dea:	e8 6f ff ff ff       	call   801d5e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801def:	83 c3 01             	add    $0x1,%ebx
  801df2:	83 fb 20             	cmp    $0x20,%ebx
  801df5:	75 f0                	jne    801de7 <close_all+0xc>
		close(i);
}
  801df7:	83 c4 14             	add    $0x14,%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    

00801dfd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 58             	sub    $0x58,%esp
  801e03:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801e06:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801e09:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801e0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e0f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	89 04 24             	mov    %eax,(%esp)
  801e1c:	e8 7f fb ff ff       	call   8019a0 <fd_lookup>
  801e21:	89 c3                	mov    %eax,%ebx
  801e23:	85 c0                	test   %eax,%eax
  801e25:	0f 88 e0 00 00 00    	js     801f0b <dup+0x10e>
		return r;
	close(newfdnum);
  801e2b:	89 3c 24             	mov    %edi,(%esp)
  801e2e:	e8 2b ff ff ff       	call   801d5e <close>

	newfd = INDEX2FD(newfdnum);
  801e33:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801e39:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3f:	89 04 24             	mov    %eax,(%esp)
  801e42:	e8 e5 fa ff ff       	call   80192c <fd2data>
  801e47:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801e49:	89 34 24             	mov    %esi,(%esp)
  801e4c:	e8 db fa ff ff       	call   80192c <fd2data>
  801e51:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e54:	89 da                	mov    %ebx,%edx
  801e56:	89 d8                	mov    %ebx,%eax
  801e58:	c1 e8 16             	shr    $0x16,%eax
  801e5b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e62:	a8 01                	test   $0x1,%al
  801e64:	74 43                	je     801ea9 <dup+0xac>
  801e66:	c1 ea 0c             	shr    $0xc,%edx
  801e69:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e70:	a8 01                	test   $0x1,%al
  801e72:	74 35                	je     801ea9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e74:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e7b:	25 07 0e 00 00       	and    $0xe07,%eax
  801e80:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e92:	00 
  801e93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e9e:	e8 3d f5 ff ff       	call   8013e0 <sys_page_map>
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 3f                	js     801ee8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	c1 ea 0c             	shr    $0xc,%edx
  801eb1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801eb8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801ebe:	89 54 24 10          	mov    %edx,0x10(%esp)
  801ec2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ec6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ecd:	00 
  801ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed9:	e8 02 f5 ff ff       	call   8013e0 <sys_page_map>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	78 04                	js     801ee8 <dup+0xeb>
  801ee4:	89 fb                	mov    %edi,%ebx
  801ee6:	eb 23                	jmp    801f0b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ee8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef3:	e8 8a f4 ff ff       	call   801382 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ef8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f06:	e8 77 f4 ff ff       	call   801382 <sys_page_unmap>
	return r;
}
  801f0b:	89 d8                	mov    %ebx,%eax
  801f0d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f10:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f13:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f16:	89 ec                	mov    %ebp,%esp
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    
	...

00801f1c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	56                   	push   %esi
  801f20:	53                   	push   %ebx
  801f21:	83 ec 10             	sub    $0x10,%esp
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801f28:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801f2f:	75 11                	jne    801f42 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801f38:	e8 8f 13 00 00       	call   8032cc <ipc_find_env>
  801f3d:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801f42:	a1 08 50 80 00       	mov    0x805008,%eax
  801f47:	8b 40 48             	mov    0x48(%eax),%eax
  801f4a:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801f50:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f54:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5c:	c7 04 24 dc 3c 80 00 	movl   $0x803cdc,(%esp)
  801f63:	e8 29 e7 ff ff       	call   800691 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f68:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f6f:	00 
  801f70:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801f77:	00 
  801f78:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f7c:	a1 00 50 80 00       	mov    0x805000,%eax
  801f81:	89 04 24             	mov    %eax,(%esp)
  801f84:	e8 79 13 00 00       	call   803302 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f89:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f90:	00 
  801f91:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f9c:	e8 cd 13 00 00       	call   80336e <ipc_recv>
}
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	5b                   	pop    %ebx
  801fa5:	5e                   	pop    %esi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbc:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc6:	b8 02 00 00 00       	mov    $0x2,%eax
  801fcb:	e8 4c ff ff ff       	call   801f1c <fsipc>
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fde:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe8:	b8 06 00 00 00       	mov    $0x6,%eax
  801fed:	e8 2a ff ff ff       	call   801f1c <fsipc>
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ffa:	ba 00 00 00 00       	mov    $0x0,%edx
  801fff:	b8 08 00 00 00       	mov    $0x8,%eax
  802004:	e8 13 ff ff ff       	call   801f1c <fsipc>
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	53                   	push   %ebx
  80200f:	83 ec 14             	sub    $0x14,%esp
  802012:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8b 40 0c             	mov    0xc(%eax),%eax
  80201b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802020:	ba 00 00 00 00       	mov    $0x0,%edx
  802025:	b8 05 00 00 00       	mov    $0x5,%eax
  80202a:	e8 ed fe ff ff       	call   801f1c <fsipc>
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 2b                	js     80205e <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802033:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80203a:	00 
  80203b:	89 1c 24             	mov    %ebx,(%esp)
  80203e:	e8 b6 ec ff ff       	call   800cf9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802043:	a1 80 60 80 00       	mov    0x806080,%eax
  802048:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80204e:	a1 84 60 80 00       	mov    0x806084,%eax
  802053:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80205e:	83 c4 14             	add    $0x14,%esp
  802061:	5b                   	pop    %ebx
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    

00802064 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	53                   	push   %ebx
  802068:	83 ec 14             	sub    $0x14,%esp
  80206b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8b 40 0c             	mov    0xc(%eax),%eax
  802074:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802079:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  80207f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802085:	76 24                	jbe    8020ab <devfile_write+0x47>
  802087:	c7 44 24 0c f2 3c 80 	movl   $0x803cf2,0xc(%esp)
  80208e:	00 
  80208f:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  802096:	00 
  802097:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  80209e:	00 
  80209f:	c7 04 24 11 3d 80 00 	movl   $0x803d11,(%esp)
  8020a6:	e8 2d e5 ff ff       	call   8005d8 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  8020ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b6:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8020bd:	e8 dd ed ff ff       	call   800e9f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  8020c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8020cc:	e8 4b fe ff ff       	call   801f1c <fsipc>
	if(ret<0) return ret;
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 53                	js     802128 <devfile_write+0xc4>
	
	assert(ret <= n);
  8020d5:	39 c3                	cmp    %eax,%ebx
  8020d7:	73 24                	jae    8020fd <devfile_write+0x99>
  8020d9:	c7 44 24 0c 1c 3d 80 	movl   $0x803d1c,0xc(%esp)
  8020e0:	00 
  8020e1:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  8020e8:	00 
  8020e9:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8020f0:	00 
  8020f1:	c7 04 24 11 3d 80 00 	movl   $0x803d11,(%esp)
  8020f8:	e8 db e4 ff ff       	call   8005d8 <_panic>
	assert(ret <= PGSIZE);
  8020fd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802102:	7e 24                	jle    802128 <devfile_write+0xc4>
  802104:	c7 44 24 0c 25 3d 80 	movl   $0x803d25,0xc(%esp)
  80210b:	00 
  80210c:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  802113:	00 
  802114:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  80211b:	00 
  80211c:	c7 04 24 11 3d 80 00 	movl   $0x803d11,(%esp)
  802123:	e8 b0 e4 ff ff       	call   8005d8 <_panic>
	return ret;
}
  802128:	83 c4 14             	add    $0x14,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	56                   	push   %esi
  802132:	53                   	push   %ebx
  802133:	83 ec 10             	sub    $0x10,%esp
  802136:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 40 0c             	mov    0xc(%eax),%eax
  80213f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802144:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80214a:	ba 00 00 00 00       	mov    $0x0,%edx
  80214f:	b8 03 00 00 00       	mov    $0x3,%eax
  802154:	e8 c3 fd ff ff       	call   801f1c <fsipc>
  802159:	89 c3                	mov    %eax,%ebx
  80215b:	85 c0                	test   %eax,%eax
  80215d:	78 6b                	js     8021ca <devfile_read+0x9c>
		return r;
	assert(r <= n);
  80215f:	39 de                	cmp    %ebx,%esi
  802161:	73 24                	jae    802187 <devfile_read+0x59>
  802163:	c7 44 24 0c 33 3d 80 	movl   $0x803d33,0xc(%esp)
  80216a:	00 
  80216b:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  802172:	00 
  802173:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80217a:	00 
  80217b:	c7 04 24 11 3d 80 00 	movl   $0x803d11,(%esp)
  802182:	e8 51 e4 ff ff       	call   8005d8 <_panic>
	assert(r <= PGSIZE);
  802187:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80218d:	7e 24                	jle    8021b3 <devfile_read+0x85>
  80218f:	c7 44 24 0c 3a 3d 80 	movl   $0x803d3a,0xc(%esp)
  802196:	00 
  802197:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  80219e:	00 
  80219f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8021a6:	00 
  8021a7:	c7 04 24 11 3d 80 00 	movl   $0x803d11,(%esp)
  8021ae:	e8 25 e4 ff ff       	call   8005d8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8021b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8021be:	00 
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	89 04 24             	mov    %eax,(%esp)
  8021c5:	e8 d5 ec ff ff       	call   800e9f <memmove>
	return r;
}
  8021ca:	89 d8                	mov    %ebx,%eax
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	5b                   	pop    %ebx
  8021d0:	5e                   	pop    %esi
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    

008021d3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 28             	sub    $0x28,%esp
  8021d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8021dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8021df:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8021e2:	89 34 24             	mov    %esi,(%esp)
  8021e5:	e8 d6 ea ff ff       	call   800cc0 <strlen>
  8021ea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8021ef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8021f4:	7f 5e                	jg     802254 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8021f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f9:	89 04 24             	mov    %eax,(%esp)
  8021fc:	e8 46 f7 ff ff       	call   801947 <fd_alloc>
  802201:	89 c3                	mov    %eax,%ebx
  802203:	85 c0                	test   %eax,%eax
  802205:	78 4d                	js     802254 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802207:	89 74 24 04          	mov    %esi,0x4(%esp)
  80220b:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802212:	e8 e2 ea ff ff       	call   800cf9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221a:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80221f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	e8 f0 fc ff ff       	call   801f1c <fsipc>
  80222c:	89 c3                	mov    %eax,%ebx
  80222e:	85 c0                	test   %eax,%eax
  802230:	79 15                	jns    802247 <open+0x74>
		fd_close(fd, 0);
  802232:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802239:	00 
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	89 04 24             	mov    %eax,(%esp)
  802240:	e8 87 fa ff ff       	call   801ccc <fd_close>
		return r;
  802245:	eb 0d                	jmp    802254 <open+0x81>
	}

	return fd2num(fd);
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	89 04 24             	mov    %eax,(%esp)
  80224d:	e8 ca f6 ff ff       	call   80191c <fd2num>
  802252:	89 c3                	mov    %eax,%ebx
}
  802254:	89 d8                	mov    %ebx,%eax
  802256:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802259:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80225c:	89 ec                	mov    %ebp,%esp
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    

00802260 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	57                   	push   %edi
  802264:	56                   	push   %esi
  802265:	53                   	push   %ebx
  802266:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80226c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802273:	00 
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	89 04 24             	mov    %eax,(%esp)
  80227a:	e8 54 ff ff ff       	call   8021d3 <open>
  80227f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802285:	85 c0                	test   %eax,%eax
  802287:	0f 88 f7 05 00 00    	js     802884 <spawn+0x624>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  80228d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802294:	00 
  802295:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80229b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8022a5:	89 14 24             	mov    %edx,(%esp)
  8022a8:	e8 d8 f9 ff ff       	call   801c85 <readn>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8022ad:	3d 00 02 00 00       	cmp    $0x200,%eax
  8022b2:	75 0c                	jne    8022c0 <spawn+0x60>
  8022b4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8022bb:	45 4c 46 
  8022be:	74 3b                	je     8022fb <spawn+0x9b>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  8022c0:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8022c6:	89 04 24             	mov    %eax,(%esp)
  8022c9:	e8 90 fa ff ff       	call   801d5e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8022ce:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8022d5:	46 
  8022d6:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8022dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e0:	c7 04 24 46 3d 80 00 	movl   $0x803d46,(%esp)
  8022e7:	e8 a5 e3 ff ff       	call   800691 <cprintf>
  8022ec:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  8022f3:	ff ff ff 
		return -E_NOT_EXEC;
  8022f6:	e9 89 05 00 00       	jmp    802884 <spawn+0x624>
  8022fb:	ba 07 00 00 00       	mov    $0x7,%edx
  802300:	89 d0                	mov    %edx,%eax
  802302:	cd 30                	int    $0x30
  802304:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80230a:	85 c0                	test   %eax,%eax
  80230c:	0f 88 66 05 00 00    	js     802878 <spawn+0x618>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802312:	89 c6                	mov    %eax,%esi
  802314:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80231a:	6b f6 7c             	imul   $0x7c,%esi,%esi
  80231d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802323:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802329:	b9 11 00 00 00       	mov    $0x11,%ecx
  80232e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802330:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802336:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  80233c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802341:	be 00 00 00 00       	mov    $0x0,%esi
  802346:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802349:	eb 0f                	jmp    80235a <spawn+0xfa>

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  80234b:	89 04 24             	mov    %eax,(%esp)
  80234e:	e8 6d e9 ff ff       	call   800cc0 <strlen>
  802353:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802357:	83 c3 01             	add    $0x1,%ebx
  80235a:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  802361:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802364:	85 c0                	test   %eax,%eax
  802366:	75 e3                	jne    80234b <spawn+0xeb>
  802368:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  80236e:	89 9d 7c fd ff ff    	mov    %ebx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802374:	f7 de                	neg    %esi
  802376:	81 c6 00 10 40 00    	add    $0x401000,%esi
  80237c:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802382:	89 f2                	mov    %esi,%edx
  802384:	83 e2 fc             	and    $0xfffffffc,%edx
  802387:	89 d8                	mov    %ebx,%eax
  802389:	f7 d0                	not    %eax
  80238b:	8d 3c 82             	lea    (%edx,%eax,4),%edi

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80238e:	8d 57 f8             	lea    -0x8(%edi),%edx
  802391:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802397:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80239c:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
  8023a2:	0f 86 ed 04 00 00    	jbe    802895 <spawn+0x635>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8023a8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8023af:	00 
  8023b0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023b7:	00 
  8023b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023bf:	e8 7a f0 ff ff       	call   80143e <sys_page_alloc>
  8023c4:	be 00 00 00 00       	mov    $0x0,%esi
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	79 4c                	jns    802419 <spawn+0x1b9>
  8023cd:	e9 c3 04 00 00       	jmp    802895 <spawn+0x635>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8023d2:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8023d8:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8023dd:	89 04 b7             	mov    %eax,(%edi,%esi,4)
		strcpy(string_store, argv[i]);
  8023e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e3:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  8023e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ea:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8023f0:	89 04 24             	mov    %eax,(%esp)
  8023f3:	e8 01 e9 ff ff       	call   800cf9 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8023f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fb:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  8023fe:	89 04 24             	mov    %eax,(%esp)
  802401:	e8 ba e8 ff ff       	call   800cc0 <strlen>
  802406:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80240c:	8d 54 02 01          	lea    0x1(%edx,%eax,1),%edx
  802410:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802416:	83 c6 01             	add    $0x1,%esi
  802419:	39 de                	cmp    %ebx,%esi
  80241b:	7c b5                	jl     8023d2 <spawn+0x172>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80241d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802423:	c7 04 07 00 00 00 00 	movl   $0x0,(%edi,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80242a:	81 bd 94 fd ff ff 00 	cmpl   $0x401000,-0x26c(%ebp)
  802431:	10 40 00 
  802434:	74 24                	je     80245a <spawn+0x1fa>
  802436:	c7 44 24 0c d4 3d 80 	movl   $0x803dd4,0xc(%esp)
  80243d:	00 
  80243e:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  802445:	00 
  802446:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  80244d:	00 
  80244e:	c7 04 24 60 3d 80 00 	movl   $0x803d60,(%esp)
  802455:	e8 7e e1 ff ff       	call   8005d8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80245a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802460:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  802463:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802469:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  80246f:	89 02                	mov    %eax,(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802471:	81 ef 08 30 80 11    	sub    $0x11803008,%edi
  802477:	89 bd e0 fd ff ff    	mov    %edi,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80247d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802484:	00 
  802485:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  80248c:	ee 
  80248d:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802493:	89 54 24 08          	mov    %edx,0x8(%esp)
  802497:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80249e:	00 
  80249f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a6:	e8 35 ef ff ff       	call   8013e0 <sys_page_map>
  8024ab:	89 c3                	mov    %eax,%ebx
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	78 1a                	js     8024cb <spawn+0x26b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8024b1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024b8:	00 
  8024b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c0:	e8 bd ee ff ff       	call   801382 <sys_page_unmap>
  8024c5:	89 c3                	mov    %eax,%ebx
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	79 1f                	jns    8024ea <spawn+0x28a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8024cb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024d2:	00 
  8024d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024da:	e8 a3 ee ff ff       	call   801382 <sys_page_unmap>
  8024df:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8024e5:	e9 9a 03 00 00       	jmp    802884 <spawn+0x624>

	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8024ea:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8024f0:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  8024f6:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  8024fc:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802503:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802506:	e9 c1 01 00 00       	jmp    8026cc <spawn+0x46c>
		if (ph->p_type != ELF_PROG_LOAD)
  80250b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802511:	83 38 01             	cmpl   $0x1,(%eax)
  802514:	0f 85 a4 01 00 00    	jne    8026be <spawn+0x45e>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80251a:	89 c2                	mov    %eax,%edx
  80251c:	8b 40 18             	mov    0x18(%eax),%eax
  80251f:	83 e0 02             	and    $0x2,%eax
  802522:	83 f8 01             	cmp    $0x1,%eax
  802525:	19 c0                	sbb    %eax,%eax
  802527:	83 e0 fe             	and    $0xfffffffe,%eax
  80252a:	83 c0 07             	add    $0x7,%eax
  80252d:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802533:	8b 52 04             	mov    0x4(%edx),%edx
  802536:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  80253c:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802542:	8b 40 10             	mov    0x10(%eax),%eax
  802545:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80254b:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802551:	8b 52 14             	mov    0x14(%edx),%edx
  802554:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
  80255a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802560:	8b 58 08             	mov    0x8(%eax),%ebx
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802563:	89 d8                	mov    %ebx,%eax
  802565:	25 ff 0f 00 00       	and    $0xfff,%eax
  80256a:	74 16                	je     802582 <spawn+0x322>
		va -= i;
  80256c:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80256e:	01 c2                	add    %eax,%edx
  802570:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		filesz += i;
  802576:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  80257c:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
  802582:	be 00 00 00 00       	mov    $0x0,%esi
  802587:	89 df                	mov    %ebx,%edi
  802589:	e9 22 01 00 00       	jmp    8026b0 <spawn+0x450>
	}

	for (i = 0; i < memsz; i += PGSIZE) {
		if (i >= filesz) {
  80258e:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802594:	77 2b                	ja     8025c1 <spawn+0x361>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802596:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  80259c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025a4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8025aa:	89 04 24             	mov    %eax,(%esp)
  8025ad:	e8 8c ee ff ff       	call   80143e <sys_page_alloc>
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	0f 89 ea 00 00 00    	jns    8026a4 <spawn+0x444>
  8025ba:	89 c3                	mov    %eax,%ebx
  8025bc:	e9 93 02 00 00       	jmp    802854 <spawn+0x5f4>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8025c1:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8025c8:	00 
  8025c9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8025d0:	00 
  8025d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d8:	e8 61 ee ff ff       	call   80143e <sys_page_alloc>
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	0f 88 65 02 00 00    	js     80284a <spawn+0x5ea>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8025e5:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  8025eb:	01 d8                	add    %ebx,%eax
  8025ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f1:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8025f7:	89 14 24             	mov    %edx,(%esp)
  8025fa:	e8 e9 f3 ff ff       	call   8019e8 <seek>
  8025ff:	85 c0                	test   %eax,%eax
  802601:	0f 88 47 02 00 00    	js     80284e <spawn+0x5ee>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802607:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80260d:	29 d8                	sub    %ebx,%eax
  80260f:	89 c3                	mov    %eax,%ebx
  802611:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802616:	ba 00 10 00 00       	mov    $0x1000,%edx
  80261b:	0f 47 da             	cmova  %edx,%ebx
  80261e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802622:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802629:	00 
  80262a:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802630:	89 04 24             	mov    %eax,(%esp)
  802633:	e8 4d f6 ff ff       	call   801c85 <readn>
  802638:	85 c0                	test   %eax,%eax
  80263a:	0f 88 12 02 00 00    	js     802852 <spawn+0x5f2>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802640:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802646:	89 54 24 10          	mov    %edx,0x10(%esp)
  80264a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80264e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802654:	89 44 24 08          	mov    %eax,0x8(%esp)
  802658:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80265f:	00 
  802660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802667:	e8 74 ed ff ff       	call   8013e0 <sys_page_map>
  80266c:	85 c0                	test   %eax,%eax
  80266e:	79 20                	jns    802690 <spawn+0x430>
				panic("spawn: sys_page_map data: %e", r);
  802670:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802674:	c7 44 24 08 6c 3d 80 	movl   $0x803d6c,0x8(%esp)
  80267b:	00 
  80267c:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  802683:	00 
  802684:	c7 04 24 60 3d 80 00 	movl   $0x803d60,(%esp)
  80268b:	e8 48 df ff ff       	call   8005d8 <_panic>
			sys_page_unmap(0, UTEMP);
  802690:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802697:	00 
  802698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269f:	e8 de ec ff ff       	call   801382 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8026a4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8026aa:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8026b0:	89 f3                	mov    %esi,%ebx
  8026b2:	39 b5 84 fd ff ff    	cmp    %esi,-0x27c(%ebp)
  8026b8:	0f 87 d0 fe ff ff    	ja     80258e <spawn+0x32e>
	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8026be:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8026c5:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  8026cc:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8026d3:	39 85 7c fd ff ff    	cmp    %eax,-0x284(%ebp)
  8026d9:	0f 8c 2c fe ff ff    	jl     80250b <spawn+0x2ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8026df:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8026e5:	89 14 24             	mov    %edx,(%esp)
  8026e8:	e8 71 f6 ff ff       	call   801d5e <close>
	fd = -1;

	cprintf("copy sharing pages\n");
  8026ed:	c7 04 24 a3 3d 80 00 	movl   $0x803da3,(%esp)
  8026f4:	e8 98 df ff ff       	call   800691 <cprintf>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
  8026f9:	e8 d3 ed ff ff       	call   8014d1 <sys_getenvid>
  8026fe:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802704:	c7 85 8c fd ff ff 00 	movl   $0x0,-0x274(%ebp)
  80270b:	00 00 00 

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  80270e:	be 00 00 40 ef       	mov    $0xef400000,%esi
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  802713:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802719:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  802720:	a8 01                	test   $0x1,%al
  802722:	0f 84 89 00 00 00    	je     8027b1 <spawn+0x551>
  802728:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  80272e:	0f 84 69 01 00 00    	je     80289d <spawn+0x63d>
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  802734:	89 d7                	mov    %edx,%edi
  802736:	c1 e7 16             	shl    $0x16,%edi
  802739:	bb 00 00 00 00       	mov    $0x0,%ebx
  80273e:	89 da                	mov    %ebx,%edx
  802740:	c1 e2 0c             	shl    $0xc,%edx
  802743:	01 fa                	add    %edi,%edx
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  802745:	89 d0                	mov    %edx,%eax
  802747:	c1 e8 0c             	shr    $0xc,%eax
  80274a:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
  80274d:	f6 c1 01             	test   $0x1,%cl
  802750:	74 54                	je     8027a6 <spawn+0x546>
  802752:	8b 04 86             	mov    (%esi,%eax,4),%eax
  802755:	f6 c4 04             	test   $0x4,%ah
  802758:	74 4c                	je     8027a6 <spawn+0x546>
				{
					ret = sys_page_map(curr_envid, (void *)addr, child,(void *)addr,PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  80275a:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  802761:	00 
  802762:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802766:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80276c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802770:	89 54 24 04          	mov    %edx,0x4(%esp)
  802774:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80277a:	89 14 24             	mov    %edx,(%esp)
  80277d:	e8 5e ec ff ff       	call   8013e0 <sys_page_map>
					if(ret) panic("sys_page_map: %e", ret);
  802782:	85 c0                	test   %eax,%eax
  802784:	74 20                	je     8027a6 <spawn+0x546>
  802786:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80278a:	c7 44 24 08 89 3d 80 	movl   $0x803d89,0x8(%esp)
  802791:	00 
  802792:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  802799:	00 
  80279a:	c7 04 24 60 3d 80 00 	movl   $0x803d60,(%esp)
  8027a1:	e8 32 de ff ff       	call   8005d8 <_panic>
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
  8027a6:	83 c3 01             	add    $0x1,%ebx
  8027a9:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8027af:	75 8d                	jne    80273e <spawn+0x4de>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  8027b1:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  8027b8:	81 bd 8c fd ff ff bb 	cmpl   $0x3bb,-0x274(%ebp)
  8027bf:	03 00 00 
  8027c2:	0f 85 4b ff ff ff    	jne    802713 <spawn+0x4b3>

	cprintf("copy sharing pages\n");
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
	cprintf("complete copy sharing pages\n");	
  8027c8:	c7 04 24 9a 3d 80 00 	movl   $0x803d9a,(%esp)
  8027cf:	e8 bd de ff ff       	call   800691 <cprintf>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8027d4:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8027da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027de:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8027e4:	89 04 24             	mov    %eax,(%esp)
  8027e7:	e8 da ea ff ff       	call   8012c6 <sys_env_set_trapframe>
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	79 20                	jns    802810 <spawn+0x5b0>
		panic("sys_env_set_trapframe: %e", r);
  8027f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027f4:	c7 44 24 08 b7 3d 80 	movl   $0x803db7,0x8(%esp)
  8027fb:	00 
  8027fc:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802803:	00 
  802804:	c7 04 24 60 3d 80 00 	movl   $0x803d60,(%esp)
  80280b:	e8 c8 dd ff ff       	call   8005d8 <_panic>
	
	//thisenv = &envs[ENVX(child)];
	//cprintf("%s %x\n",__func__,thisenv->env_id);
	
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802810:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802817:	00 
  802818:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80281e:	89 14 24             	mov    %edx,(%esp)
  802821:	e8 fe ea ff ff       	call   801324 <sys_env_set_status>
  802826:	85 c0                	test   %eax,%eax
  802828:	79 4e                	jns    802878 <spawn+0x618>
		panic("sys_env_set_status: %e", r);
  80282a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80282e:	c7 44 24 08 da 3b 80 	movl   $0x803bda,0x8(%esp)
  802835:	00 
  802836:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  80283d:	00 
  80283e:	c7 04 24 60 3d 80 00 	movl   $0x803d60,(%esp)
  802845:	e8 8e dd ff ff       	call   8005d8 <_panic>
  80284a:	89 c3                	mov    %eax,%ebx
  80284c:	eb 06                	jmp    802854 <spawn+0x5f4>
  80284e:	89 c3                	mov    %eax,%ebx
  802850:	eb 02                	jmp    802854 <spawn+0x5f4>
  802852:	89 c3                	mov    %eax,%ebx
	
	return child;

error:
	sys_env_destroy(child);
  802854:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80285a:	89 04 24             	mov    %eax,(%esp)
  80285d:	e8 a3 ec ff ff       	call   801505 <sys_env_destroy>
	close(fd);
  802862:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802868:	89 14 24             	mov    %edx,(%esp)
  80286b:	e8 ee f4 ff ff       	call   801d5e <close>
  802870:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
	return r;
  802876:	eb 0c                	jmp    802884 <spawn+0x624>
  802878:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80287e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  802884:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80288a:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802890:	5b                   	pop    %ebx
  802891:	5e                   	pop    %esi
  802892:	5f                   	pop    %edi
  802893:	5d                   	pop    %ebp
  802894:	c3                   	ret    
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802895:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  80289b:	eb e7                	jmp    802884 <spawn+0x624>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  80289d:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  8028a4:	e9 6a fe ff ff       	jmp    802713 <spawn+0x4b3>

008028a9 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
  8028ac:	56                   	push   %esi
  8028ad:	53                   	push   %ebx
  8028ae:	83 ec 10             	sub    $0x10,%esp

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8028b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8028b4:	ba 00 00 00 00       	mov    $0x0,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8028b9:	eb 03                	jmp    8028be <spawnl+0x15>
		argc++;
  8028bb:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8028be:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  8028c2:	75 f7                	jne    8028bb <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8028c4:	8d 04 95 26 00 00 00 	lea    0x26(,%edx,4),%eax
  8028cb:	83 e0 f0             	and    $0xfffffff0,%eax
  8028ce:	29 c4                	sub    %eax,%esp
  8028d0:	8d 5c 24 17          	lea    0x17(%esp),%ebx
  8028d4:	83 e3 f0             	and    $0xfffffff0,%ebx
	argv[0] = arg0;
  8028d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028da:	89 03                	mov    %eax,(%ebx)
	argv[argc+1] = NULL;
  8028dc:	c7 44 93 04 00 00 00 	movl   $0x0,0x4(%ebx,%edx,4)
  8028e3:	00 

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8028e4:	8d 75 10             	lea    0x10(%ebp),%esi
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8028ec:	eb 0a                	jmp    8028f8 <spawnl+0x4f>
		argv[i+1] = va_arg(vl, const char *);
  8028ee:	83 c0 01             	add    $0x1,%eax
  8028f1:	8b 4c 86 fc          	mov    -0x4(%esi,%eax,4),%ecx
  8028f5:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8028f8:	39 d0                	cmp    %edx,%eax
  8028fa:	72 f2                	jb     8028ee <spawnl+0x45>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8028fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	89 04 24             	mov    %eax,(%esp)
  802906:	e8 55 f9 ff ff       	call   802260 <spawn>
}
  80290b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80290e:	5b                   	pop    %ebx
  80290f:	5e                   	pop    %esi
  802910:	5d                   	pop    %ebp
  802911:	c3                   	ret    
	...

00802920 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802926:	c7 44 24 04 fc 3d 80 	movl   $0x803dfc,0x4(%esp)
  80292d:	00 
  80292e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802931:	89 04 24             	mov    %eax,(%esp)
  802934:	e8 c0 e3 ff ff       	call   800cf9 <strcpy>
	return 0;
}
  802939:	b8 00 00 00 00       	mov    $0x0,%eax
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	53                   	push   %ebx
  802944:	83 ec 14             	sub    $0x14,%esp
  802947:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80294a:	89 1c 24             	mov    %ebx,(%esp)
  80294d:	e8 a6 0a 00 00       	call   8033f8 <pageref>
  802952:	89 c2                	mov    %eax,%edx
  802954:	b8 00 00 00 00       	mov    $0x0,%eax
  802959:	83 fa 01             	cmp    $0x1,%edx
  80295c:	75 0b                	jne    802969 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80295e:	8b 43 0c             	mov    0xc(%ebx),%eax
  802961:	89 04 24             	mov    %eax,(%esp)
  802964:	e8 b1 02 00 00       	call   802c1a <nsipc_close>
	else
		return 0;
}
  802969:	83 c4 14             	add    $0x14,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5d                   	pop    %ebp
  80296e:	c3                   	ret    

0080296f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802975:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80297c:	00 
  80297d:	8b 45 10             	mov    0x10(%ebp),%eax
  802980:	89 44 24 08          	mov    %eax,0x8(%esp)
  802984:	8b 45 0c             	mov    0xc(%ebp),%eax
  802987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	89 04 24             	mov    %eax,(%esp)
  802994:	e8 bd 02 00 00       	call   802c56 <nsipc_send>
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8029a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8029a8:	00 
  8029a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bd:	89 04 24             	mov    %eax,(%esp)
  8029c0:	e8 04 03 00 00       	call   802cc9 <nsipc_recv>
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	56                   	push   %esi
  8029cb:	53                   	push   %ebx
  8029cc:	83 ec 20             	sub    $0x20,%esp
  8029cf:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029d4:	89 04 24             	mov    %eax,(%esp)
  8029d7:	e8 6b ef ff ff       	call   801947 <fd_alloc>
  8029dc:	89 c3                	mov    %eax,%ebx
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	78 21                	js     802a03 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8029e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029e9:	00 
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029f8:	e8 41 ea ff ff       	call   80143e <sys_page_alloc>
  8029fd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	79 0a                	jns    802a0d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802a03:	89 34 24             	mov    %esi,(%esp)
  802a06:	e8 0f 02 00 00       	call   802c1a <nsipc_close>
		return r;
  802a0b:	eb 28                	jmp    802a35 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802a0d:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	89 04 24             	mov    %eax,(%esp)
  802a2e:	e8 e9 ee ff ff       	call   80191c <fd2num>
  802a33:	89 c3                	mov    %eax,%ebx
}
  802a35:	89 d8                	mov    %ebx,%eax
  802a37:	83 c4 20             	add    $0x20,%esp
  802a3a:	5b                   	pop    %ebx
  802a3b:	5e                   	pop    %esi
  802a3c:	5d                   	pop    %ebp
  802a3d:	c3                   	ret    

00802a3e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802a3e:	55                   	push   %ebp
  802a3f:	89 e5                	mov    %esp,%ebp
  802a41:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a44:	8b 45 10             	mov    0x10(%ebp),%eax
  802a47:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	89 04 24             	mov    %eax,(%esp)
  802a58:	e8 71 01 00 00       	call   802bce <nsipc_socket>
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	78 05                	js     802a66 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802a61:	e8 61 ff ff ff       	call   8029c7 <alloc_sockfd>
}
  802a66:	c9                   	leave  
  802a67:	c3                   	ret    

00802a68 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
  802a6b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a6e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802a71:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a75:	89 04 24             	mov    %eax,(%esp)
  802a78:	e8 23 ef ff ff       	call   8019a0 <fd_lookup>
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	78 15                	js     802a96 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a84:	8b 0a                	mov    (%edx),%ecx
  802a86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802a8b:	3b 0d 3c 40 80 00    	cmp    0x80403c,%ecx
  802a91:	75 03                	jne    802a96 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802a93:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802a96:	c9                   	leave  
  802a97:	c3                   	ret    

00802a98 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802a98:	55                   	push   %ebp
  802a99:	89 e5                	mov    %esp,%ebp
  802a9b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	e8 c2 ff ff ff       	call   802a68 <fd2sockid>
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	78 0f                	js     802ab9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aad:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ab1:	89 04 24             	mov    %eax,(%esp)
  802ab4:	e8 3f 01 00 00       	call   802bf8 <nsipc_listen>
}
  802ab9:	c9                   	leave  
  802aba:	c3                   	ret    

00802abb <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
  802abe:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	e8 9f ff ff ff       	call   802a68 <fd2sockid>
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	78 16                	js     802ae3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802acd:	8b 55 10             	mov    0x10(%ebp),%edx
  802ad0:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad7:	89 54 24 04          	mov    %edx,0x4(%esp)
  802adb:	89 04 24             	mov    %eax,(%esp)
  802ade:	e8 66 02 00 00       	call   802d49 <nsipc_connect>
}
  802ae3:	c9                   	leave  
  802ae4:	c3                   	ret    

00802ae5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
  802ae8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	e8 75 ff ff ff       	call   802a68 <fd2sockid>
  802af3:	85 c0                	test   %eax,%eax
  802af5:	78 0f                	js     802b06 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802afa:	89 54 24 04          	mov    %edx,0x4(%esp)
  802afe:	89 04 24             	mov    %eax,(%esp)
  802b01:	e8 2e 01 00 00       	call   802c34 <nsipc_shutdown>
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	e8 52 ff ff ff       	call   802a68 <fd2sockid>
  802b16:	85 c0                	test   %eax,%eax
  802b18:	78 16                	js     802b30 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802b1a:	8b 55 10             	mov    0x10(%ebp),%edx
  802b1d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b24:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b28:	89 04 24             	mov    %eax,(%esp)
  802b2b:	e8 58 02 00 00       	call   802d88 <nsipc_bind>
}
  802b30:	c9                   	leave  
  802b31:	c3                   	ret    

00802b32 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b32:	55                   	push   %ebp
  802b33:	89 e5                	mov    %esp,%ebp
  802b35:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	e8 28 ff ff ff       	call   802a68 <fd2sockid>
  802b40:	85 c0                	test   %eax,%eax
  802b42:	78 1f                	js     802b63 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b44:	8b 55 10             	mov    0x10(%ebp),%edx
  802b47:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b52:	89 04 24             	mov    %eax,(%esp)
  802b55:	e8 6d 02 00 00       	call   802dc7 <nsipc_accept>
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	78 05                	js     802b63 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802b5e:	e8 64 fe ff ff       	call   8029c7 <alloc_sockfd>
}
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    
  802b65:	00 00                	add    %al,(%eax)
	...

00802b68 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
  802b6b:	53                   	push   %ebx
  802b6c:	83 ec 14             	sub    $0x14,%esp
  802b6f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802b71:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802b78:	75 11                	jne    802b8b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802b7a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802b81:	e8 46 07 00 00       	call   8032cc <ipc_find_env>
  802b86:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802b8b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802b92:	00 
  802b93:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  802b9a:	00 
  802b9b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b9f:	a1 04 50 80 00       	mov    0x805004,%eax
  802ba4:	89 04 24             	mov    %eax,(%esp)
  802ba7:	e8 56 07 00 00       	call   803302 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802bac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802bb3:	00 
  802bb4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802bbb:	00 
  802bbc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bc3:	e8 a6 07 00 00       	call   80336e <ipc_recv>
}
  802bc8:	83 c4 14             	add    $0x14,%esp
  802bcb:	5b                   	pop    %ebx
  802bcc:	5d                   	pop    %ebp
  802bcd:	c3                   	ret    

00802bce <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802bce:	55                   	push   %ebp
  802bcf:	89 e5                	mov    %esp,%ebp
  802bd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  802bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bdf:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802be4:	8b 45 10             	mov    0x10(%ebp),%eax
  802be7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  802bec:	b8 09 00 00 00       	mov    $0x9,%eax
  802bf1:	e8 72 ff ff ff       	call   802b68 <nsipc>
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c09:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  802c0e:	b8 06 00 00 00       	mov    $0x6,%eax
  802c13:	e8 50 ff ff ff       	call   802b68 <nsipc>
}
  802c18:	c9                   	leave  
  802c19:	c3                   	ret    

00802c1a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802c1a:	55                   	push   %ebp
  802c1b:	89 e5                	mov    %esp,%ebp
  802c1d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802c28:	b8 04 00 00 00       	mov    $0x4,%eax
  802c2d:	e8 36 ff ff ff       	call   802b68 <nsipc>
}
  802c32:	c9                   	leave  
  802c33:	c3                   	ret    

00802c34 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802c34:	55                   	push   %ebp
  802c35:	89 e5                	mov    %esp,%ebp
  802c37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c45:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  802c4a:	b8 03 00 00 00       	mov    $0x3,%eax
  802c4f:	e8 14 ff ff ff       	call   802b68 <nsipc>
}
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	53                   	push   %ebx
  802c5a:	83 ec 14             	sub    $0x14,%esp
  802c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802c68:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802c6e:	7e 24                	jle    802c94 <nsipc_send+0x3e>
  802c70:	c7 44 24 0c 08 3e 80 	movl   $0x803e08,0xc(%esp)
  802c77:	00 
  802c78:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  802c7f:	00 
  802c80:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802c87:	00 
  802c88:	c7 04 24 14 3e 80 00 	movl   $0x803e14,(%esp)
  802c8f:	e8 44 d9 ff ff       	call   8005d8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c94:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c9f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802ca6:	e8 f4 e1 ff ff       	call   800e9f <memmove>
	nsipcbuf.send.req_size = size;
  802cab:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  802cb4:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802cb9:	b8 08 00 00 00       	mov    $0x8,%eax
  802cbe:	e8 a5 fe ff ff       	call   802b68 <nsipc>
}
  802cc3:	83 c4 14             	add    $0x14,%esp
  802cc6:	5b                   	pop    %ebx
  802cc7:	5d                   	pop    %ebp
  802cc8:	c3                   	ret    

00802cc9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	56                   	push   %esi
  802ccd:	53                   	push   %ebx
  802cce:	83 ec 10             	sub    $0x10,%esp
  802cd1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  802cdc:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  802ce5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802cea:	b8 07 00 00 00       	mov    $0x7,%eax
  802cef:	e8 74 fe ff ff       	call   802b68 <nsipc>
  802cf4:	89 c3                	mov    %eax,%ebx
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	78 46                	js     802d40 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802cfa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802cff:	7f 04                	jg     802d05 <nsipc_recv+0x3c>
  802d01:	39 c6                	cmp    %eax,%esi
  802d03:	7d 24                	jge    802d29 <nsipc_recv+0x60>
  802d05:	c7 44 24 0c 20 3e 80 	movl   $0x803e20,0xc(%esp)
  802d0c:	00 
  802d0d:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  802d14:	00 
  802d15:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  802d1c:	00 
  802d1d:	c7 04 24 14 3e 80 00 	movl   $0x803e14,(%esp)
  802d24:	e8 af d8 ff ff       	call   8005d8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802d29:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d2d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802d34:	00 
  802d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d38:	89 04 24             	mov    %eax,(%esp)
  802d3b:	e8 5f e1 ff ff       	call   800e9f <memmove>
	}

	return r;
}
  802d40:	89 d8                	mov    %ebx,%eax
  802d42:	83 c4 10             	add    $0x10,%esp
  802d45:	5b                   	pop    %ebx
  802d46:	5e                   	pop    %esi
  802d47:	5d                   	pop    %ebp
  802d48:	c3                   	ret    

00802d49 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	53                   	push   %ebx
  802d4d:	83 ec 14             	sub    $0x14,%esp
  802d50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802d5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d66:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802d6d:	e8 2d e1 ff ff       	call   800e9f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802d72:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802d78:	b8 05 00 00 00       	mov    $0x5,%eax
  802d7d:	e8 e6 fd ff ff       	call   802b68 <nsipc>
}
  802d82:	83 c4 14             	add    $0x14,%esp
  802d85:	5b                   	pop    %ebx
  802d86:	5d                   	pop    %ebp
  802d87:	c3                   	ret    

00802d88 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802d88:	55                   	push   %ebp
  802d89:	89 e5                	mov    %esp,%ebp
  802d8b:	53                   	push   %ebx
  802d8c:	83 ec 14             	sub    $0x14,%esp
  802d8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802d9a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802da5:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802dac:	e8 ee e0 ff ff       	call   800e9f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802db1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802db7:	b8 02 00 00 00       	mov    $0x2,%eax
  802dbc:	e8 a7 fd ff ff       	call   802b68 <nsipc>
}
  802dc1:	83 c4 14             	add    $0x14,%esp
  802dc4:	5b                   	pop    %ebx
  802dc5:	5d                   	pop    %ebp
  802dc6:	c3                   	ret    

00802dc7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802dc7:	55                   	push   %ebp
  802dc8:	89 e5                	mov    %esp,%ebp
  802dca:	83 ec 28             	sub    $0x28,%esp
  802dcd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802dd0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802dd3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802dd6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802de1:	8b 07                	mov    (%edi),%eax
  802de3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802de8:	b8 01 00 00 00       	mov    $0x1,%eax
  802ded:	e8 76 fd ff ff       	call   802b68 <nsipc>
  802df2:	89 c6                	mov    %eax,%esi
  802df4:	85 c0                	test   %eax,%eax
  802df6:	78 22                	js     802e1a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802df8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  802dfd:	8b 03                	mov    (%ebx),%eax
  802dff:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e03:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802e0a:	00 
  802e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0e:	89 04 24             	mov    %eax,(%esp)
  802e11:	e8 89 e0 ff ff       	call   800e9f <memmove>
		*addrlen = ret->ret_addrlen;
  802e16:	8b 03                	mov    (%ebx),%eax
  802e18:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  802e1a:	89 f0                	mov    %esi,%eax
  802e1c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802e1f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802e22:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802e25:	89 ec                	mov    %ebp,%esp
  802e27:	5d                   	pop    %ebp
  802e28:	c3                   	ret    
  802e29:	00 00                	add    %al,(%eax)
	...

00802e2c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
  802e2f:	83 ec 18             	sub    $0x18,%esp
  802e32:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802e35:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802e38:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	89 04 24             	mov    %eax,(%esp)
  802e41:	e8 e6 ea ff ff       	call   80192c <fd2data>
  802e46:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802e48:	c7 44 24 04 35 3e 80 	movl   $0x803e35,0x4(%esp)
  802e4f:	00 
  802e50:	89 34 24             	mov    %esi,(%esp)
  802e53:	e8 a1 de ff ff       	call   800cf9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e58:	8b 43 04             	mov    0x4(%ebx),%eax
  802e5b:	2b 03                	sub    (%ebx),%eax
  802e5d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802e63:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802e6a:	00 00 00 
	stat->st_dev = &devpipe;
  802e6d:	c7 86 88 00 00 00 58 	movl   $0x804058,0x88(%esi)
  802e74:	40 80 00 
	return 0;
}
  802e77:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802e7f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802e82:	89 ec                	mov    %ebp,%esp
  802e84:	5d                   	pop    %ebp
  802e85:	c3                   	ret    

00802e86 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
  802e89:	53                   	push   %ebx
  802e8a:	83 ec 14             	sub    $0x14,%esp
  802e8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802e90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e9b:	e8 e2 e4 ff ff       	call   801382 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802ea0:	89 1c 24             	mov    %ebx,(%esp)
  802ea3:	e8 84 ea ff ff       	call   80192c <fd2data>
  802ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802eb3:	e8 ca e4 ff ff       	call   801382 <sys_page_unmap>
}
  802eb8:	83 c4 14             	add    $0x14,%esp
  802ebb:	5b                   	pop    %ebx
  802ebc:	5d                   	pop    %ebp
  802ebd:	c3                   	ret    

00802ebe <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
  802ec1:	57                   	push   %edi
  802ec2:	56                   	push   %esi
  802ec3:	53                   	push   %ebx
  802ec4:	83 ec 2c             	sub    $0x2c,%esp
  802ec7:	89 c7                	mov    %eax,%edi
  802ec9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802ecc:	a1 08 50 80 00       	mov    0x805008,%eax
  802ed1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ed4:	89 3c 24             	mov    %edi,(%esp)
  802ed7:	e8 1c 05 00 00       	call   8033f8 <pageref>
  802edc:	89 c6                	mov    %eax,%esi
  802ede:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee1:	89 04 24             	mov    %eax,(%esp)
  802ee4:	e8 0f 05 00 00       	call   8033f8 <pageref>
  802ee9:	39 c6                	cmp    %eax,%esi
  802eeb:	0f 94 c0             	sete   %al
  802eee:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  802ef1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802ef7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802efa:	39 cb                	cmp    %ecx,%ebx
  802efc:	75 08                	jne    802f06 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802efe:	83 c4 2c             	add    $0x2c,%esp
  802f01:	5b                   	pop    %ebx
  802f02:	5e                   	pop    %esi
  802f03:	5f                   	pop    %edi
  802f04:	5d                   	pop    %ebp
  802f05:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802f06:	83 f8 01             	cmp    $0x1,%eax
  802f09:	75 c1                	jne    802ecc <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802f0b:	8b 52 58             	mov    0x58(%edx),%edx
  802f0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f12:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f1a:	c7 04 24 3c 3e 80 00 	movl   $0x803e3c,(%esp)
  802f21:	e8 6b d7 ff ff       	call   800691 <cprintf>
  802f26:	eb a4                	jmp    802ecc <_pipeisclosed+0xe>

00802f28 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f28:	55                   	push   %ebp
  802f29:	89 e5                	mov    %esp,%ebp
  802f2b:	57                   	push   %edi
  802f2c:	56                   	push   %esi
  802f2d:	53                   	push   %ebx
  802f2e:	83 ec 1c             	sub    $0x1c,%esp
  802f31:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802f34:	89 34 24             	mov    %esi,(%esp)
  802f37:	e8 f0 e9 ff ff       	call   80192c <fd2data>
  802f3c:	89 c3                	mov    %eax,%ebx
  802f3e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f43:	eb 48                	jmp    802f8d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802f45:	89 da                	mov    %ebx,%edx
  802f47:	89 f0                	mov    %esi,%eax
  802f49:	e8 70 ff ff ff       	call   802ebe <_pipeisclosed>
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 07                	je     802f59 <devpipe_write+0x31>
  802f52:	b8 00 00 00 00       	mov    $0x0,%eax
  802f57:	eb 3b                	jmp    802f94 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802f59:	e8 3f e5 ff ff       	call   80149d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f5e:	8b 43 04             	mov    0x4(%ebx),%eax
  802f61:	8b 13                	mov    (%ebx),%edx
  802f63:	83 c2 20             	add    $0x20,%edx
  802f66:	39 d0                	cmp    %edx,%eax
  802f68:	73 db                	jae    802f45 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f6a:	89 c2                	mov    %eax,%edx
  802f6c:	c1 fa 1f             	sar    $0x1f,%edx
  802f6f:	c1 ea 1b             	shr    $0x1b,%edx
  802f72:	01 d0                	add    %edx,%eax
  802f74:	83 e0 1f             	and    $0x1f,%eax
  802f77:	29 d0                	sub    %edx,%eax
  802f79:	89 c2                	mov    %eax,%edx
  802f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f7e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802f82:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802f86:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f8a:	83 c7 01             	add    $0x1,%edi
  802f8d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802f90:	72 cc                	jb     802f5e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f92:	89 f8                	mov    %edi,%eax
}
  802f94:	83 c4 1c             	add    $0x1c,%esp
  802f97:	5b                   	pop    %ebx
  802f98:	5e                   	pop    %esi
  802f99:	5f                   	pop    %edi
  802f9a:	5d                   	pop    %ebp
  802f9b:	c3                   	ret    

00802f9c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f9c:	55                   	push   %ebp
  802f9d:	89 e5                	mov    %esp,%ebp
  802f9f:	83 ec 28             	sub    $0x28,%esp
  802fa2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802fa5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802fa8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802fab:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802fae:	89 3c 24             	mov    %edi,(%esp)
  802fb1:	e8 76 e9 ff ff       	call   80192c <fd2data>
  802fb6:	89 c3                	mov    %eax,%ebx
  802fb8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802fbd:	eb 48                	jmp    803007 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802fbf:	85 f6                	test   %esi,%esi
  802fc1:	74 04                	je     802fc7 <devpipe_read+0x2b>
				return i;
  802fc3:	89 f0                	mov    %esi,%eax
  802fc5:	eb 47                	jmp    80300e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802fc7:	89 da                	mov    %ebx,%edx
  802fc9:	89 f8                	mov    %edi,%eax
  802fcb:	e8 ee fe ff ff       	call   802ebe <_pipeisclosed>
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 07                	je     802fdb <devpipe_read+0x3f>
  802fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd9:	eb 33                	jmp    80300e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fdb:	e8 bd e4 ff ff       	call   80149d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fe0:	8b 03                	mov    (%ebx),%eax
  802fe2:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fe5:	74 d8                	je     802fbf <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fe7:	89 c2                	mov    %eax,%edx
  802fe9:	c1 fa 1f             	sar    $0x1f,%edx
  802fec:	c1 ea 1b             	shr    $0x1b,%edx
  802fef:	01 d0                	add    %edx,%eax
  802ff1:	83 e0 1f             	and    $0x1f,%eax
  802ff4:	29 d0                	sub    %edx,%eax
  802ff6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffe:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803001:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803004:	83 c6 01             	add    $0x1,%esi
  803007:	3b 75 10             	cmp    0x10(%ebp),%esi
  80300a:	72 d4                	jb     802fe0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80300c:	89 f0                	mov    %esi,%eax
}
  80300e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803011:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803014:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803017:	89 ec                	mov    %ebp,%esp
  803019:	5d                   	pop    %ebp
  80301a:	c3                   	ret    

0080301b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803021:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803024:	89 44 24 04          	mov    %eax,0x4(%esp)
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	89 04 24             	mov    %eax,(%esp)
  80302e:	e8 6d e9 ff ff       	call   8019a0 <fd_lookup>
  803033:	85 c0                	test   %eax,%eax
  803035:	78 15                	js     80304c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	89 04 24             	mov    %eax,(%esp)
  80303d:	e8 ea e8 ff ff       	call   80192c <fd2data>
	return _pipeisclosed(fd, p);
  803042:	89 c2                	mov    %eax,%edx
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	e8 72 fe ff ff       	call   802ebe <_pipeisclosed>
}
  80304c:	c9                   	leave  
  80304d:	c3                   	ret    

0080304e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80304e:	55                   	push   %ebp
  80304f:	89 e5                	mov    %esp,%ebp
  803051:	83 ec 48             	sub    $0x48,%esp
  803054:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803057:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80305a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80305d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803060:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803063:	89 04 24             	mov    %eax,(%esp)
  803066:	e8 dc e8 ff ff       	call   801947 <fd_alloc>
  80306b:	89 c3                	mov    %eax,%ebx
  80306d:	85 c0                	test   %eax,%eax
  80306f:	0f 88 42 01 00 00    	js     8031b7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803075:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80307c:	00 
  80307d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803080:	89 44 24 04          	mov    %eax,0x4(%esp)
  803084:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80308b:	e8 ae e3 ff ff       	call   80143e <sys_page_alloc>
  803090:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803092:	85 c0                	test   %eax,%eax
  803094:	0f 88 1d 01 00 00    	js     8031b7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80309a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80309d:	89 04 24             	mov    %eax,(%esp)
  8030a0:	e8 a2 e8 ff ff       	call   801947 <fd_alloc>
  8030a5:	89 c3                	mov    %eax,%ebx
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	0f 88 f5 00 00 00    	js     8031a4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030af:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030b6:	00 
  8030b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030c5:	e8 74 e3 ff ff       	call   80143e <sys_page_alloc>
  8030ca:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	0f 88 d0 00 00 00    	js     8031a4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d7:	89 04 24             	mov    %eax,(%esp)
  8030da:	e8 4d e8 ff ff       	call   80192c <fd2data>
  8030df:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030e8:	00 
  8030e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030f4:	e8 45 e3 ff ff       	call   80143e <sys_page_alloc>
  8030f9:	89 c3                	mov    %eax,%ebx
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	0f 88 8e 00 00 00    	js     803191 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803106:	89 04 24             	mov    %eax,(%esp)
  803109:	e8 1e e8 ff ff       	call   80192c <fd2data>
  80310e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803115:	00 
  803116:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80311a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803121:	00 
  803122:	89 74 24 04          	mov    %esi,0x4(%esp)
  803126:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80312d:	e8 ae e2 ff ff       	call   8013e0 <sys_page_map>
  803132:	89 c3                	mov    %eax,%ebx
  803134:	85 c0                	test   %eax,%eax
  803136:	78 49                	js     803181 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803138:	b8 58 40 80 00       	mov    $0x804058,%eax
  80313d:	8b 08                	mov    (%eax),%ecx
  80313f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803142:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  803144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803147:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80314e:	8b 10                	mov    (%eax),%edx
  803150:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803153:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803158:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803162:	89 04 24             	mov    %eax,(%esp)
  803165:	e8 b2 e7 ff ff       	call   80191c <fd2num>
  80316a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80316c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80316f:	89 04 24             	mov    %eax,(%esp)
  803172:	e8 a5 e7 ff ff       	call   80191c <fd2num>
  803177:	89 47 04             	mov    %eax,0x4(%edi)
  80317a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80317f:	eb 36                	jmp    8031b7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  803181:	89 74 24 04          	mov    %esi,0x4(%esp)
  803185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80318c:	e8 f1 e1 ff ff       	call   801382 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803191:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803194:	89 44 24 04          	mov    %eax,0x4(%esp)
  803198:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80319f:	e8 de e1 ff ff       	call   801382 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8031a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031b2:	e8 cb e1 ff ff       	call   801382 <sys_page_unmap>
    err:
	return r;
}
  8031b7:	89 d8                	mov    %ebx,%eax
  8031b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8031bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8031bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8031c2:	89 ec                	mov    %ebp,%esp
  8031c4:	5d                   	pop    %ebp
  8031c5:	c3                   	ret    
	...

008031c8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
  8031cb:	56                   	push   %esi
  8031cc:	53                   	push   %ebx
  8031cd:	83 ec 10             	sub    $0x10,%esp
  8031d0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8031d3:	85 f6                	test   %esi,%esi
  8031d5:	75 24                	jne    8031fb <wait+0x33>
  8031d7:	c7 44 24 0c 54 3e 80 	movl   $0x803e54,0xc(%esp)
  8031de:	00 
  8031df:	c7 44 24 08 fc 3c 80 	movl   $0x803cfc,0x8(%esp)
  8031e6:	00 
  8031e7:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8031ee:	00 
  8031ef:	c7 04 24 5f 3e 80 00 	movl   $0x803e5f,(%esp)
  8031f6:	e8 dd d3 ff ff       	call   8005d8 <_panic>
	e = &envs[ENVX(envid)];
  8031fb:	89 f3                	mov    %esi,%ebx
  8031fd:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  803203:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803206:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80320c:	eb 05                	jmp    803213 <wait+0x4b>
		sys_yield();
  80320e:	e8 8a e2 ff ff       	call   80149d <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803213:	8b 43 48             	mov    0x48(%ebx),%eax
  803216:	39 f0                	cmp    %esi,%eax
  803218:	75 07                	jne    803221 <wait+0x59>
  80321a:	8b 43 54             	mov    0x54(%ebx),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	75 ed                	jne    80320e <wait+0x46>
		sys_yield();
}
  803221:	83 c4 10             	add    $0x10,%esp
  803224:	5b                   	pop    %ebx
  803225:	5e                   	pop    %esi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    

00803228 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803228:	55                   	push   %ebp
  803229:	89 e5                	mov    %esp,%ebp
  80322b:	53                   	push   %ebx
  80322c:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  80322f:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803236:	75 5b                	jne    803293 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  803238:	e8 94 e2 ff ff       	call   8014d1 <sys_getenvid>
  80323d:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80323f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803246:	00 
  803247:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80324e:	ee 
  80324f:	89 04 24             	mov    %eax,(%esp)
  803252:	e8 e7 e1 ff ff       	call   80143e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  803257:	85 c0                	test   %eax,%eax
  803259:	74 28                	je     803283 <set_pgfault_handler+0x5b>
  80325b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80325f:	c7 44 24 0c 91 3e 80 	movl   $0x803e91,0xc(%esp)
  803266:	00 
  803267:	c7 44 24 08 6a 3e 80 	movl   $0x803e6a,0x8(%esp)
  80326e:	00 
  80326f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803276:	00 
  803277:	c7 04 24 83 3e 80 00 	movl   $0x803e83,(%esp)
  80327e:	e8 55 d3 ff ff       	call   8005d8 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  803283:	c7 44 24 04 a4 32 80 	movl   $0x8032a4,0x4(%esp)
  80328a:	00 
  80328b:	89 1c 24             	mov    %ebx,(%esp)
  80328e:	e8 d5 df ff ff       	call   801268 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	a3 00 90 80 00       	mov    %eax,0x809000
	
}
  80329b:	83 c4 24             	add    $0x24,%esp
  80329e:	5b                   	pop    %ebx
  80329f:	5d                   	pop    %ebp
  8032a0:	c3                   	ret    
  8032a1:	00 00                	add    %al,(%eax)
	...

008032a4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8032a4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8032a5:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  8032aa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8032ac:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  8032af:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  8032b2:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  8032b6:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  8032ba:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  8032bd:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  8032c0:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  8032c4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  8032c5:	83 c4 04             	add    $0x4,%esp
	popfl ;
  8032c8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8032c9:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8032ca:	c3                   	ret    
	...

008032cc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8032cc:	55                   	push   %ebp
  8032cd:	89 e5                	mov    %esp,%ebp
  8032cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032d2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8032d7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8032da:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8032e0:	8b 12                	mov    (%edx),%edx
  8032e2:	39 ca                	cmp    %ecx,%edx
  8032e4:	75 0c                	jne    8032f2 <ipc_find_env+0x26>
			return envs[i].env_id;
  8032e6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8032e9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	eb 0e                	jmp    803300 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8032f2:	83 c0 01             	add    $0x1,%eax
  8032f5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8032fa:	75 db                	jne    8032d7 <ipc_find_env+0xb>
  8032fc:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  803300:	5d                   	pop    %ebp
  803301:	c3                   	ret    

00803302 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803302:	55                   	push   %ebp
  803303:	89 e5                	mov    %esp,%ebp
  803305:	57                   	push   %edi
  803306:	56                   	push   %esi
  803307:	53                   	push   %ebx
  803308:	83 ec 2c             	sub    $0x2c,%esp
  80330b:	8b 75 08             	mov    0x8(%ebp),%esi
  80330e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803311:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  803314:	85 db                	test   %ebx,%ebx
  803316:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80331b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80331e:	8b 45 14             	mov    0x14(%ebp),%eax
  803321:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803325:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803329:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80332d:	89 34 24             	mov    %esi,(%esp)
  803330:	e8 fb de ff ff       	call   801230 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  803335:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803338:	74 e4                	je     80331e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 28                	je     803366 <ipc_send+0x64>
  80333e:	89 44 24 10          	mov    %eax,0x10(%esp)
  803342:	c7 44 24 0c c2 3e 80 	movl   $0x803ec2,0xc(%esp)
  803349:	00 
  80334a:	c7 44 24 08 a5 3e 80 	movl   $0x803ea5,0x8(%esp)
  803351:	00 
  803352:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  803359:	00 
  80335a:	c7 04 24 b8 3e 80 00 	movl   $0x803eb8,(%esp)
  803361:	e8 72 d2 ff ff       	call   8005d8 <_panic>
	//if(!ret) sys_yield();
}
  803366:	83 c4 2c             	add    $0x2c,%esp
  803369:	5b                   	pop    %ebx
  80336a:	5e                   	pop    %esi
  80336b:	5f                   	pop    %edi
  80336c:	5d                   	pop    %ebp
  80336d:	c3                   	ret    

0080336e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80336e:	55                   	push   %ebp
  80336f:	89 e5                	mov    %esp,%ebp
  803371:	83 ec 28             	sub    $0x28,%esp
  803374:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803377:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80337a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80337d:	8b 75 08             	mov    0x8(%ebp),%esi
  803380:	8b 45 0c             	mov    0xc(%ebp),%eax
  803383:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  803386:	85 c0                	test   %eax,%eax
  803388:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80338d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803390:	89 04 24             	mov    %eax,(%esp)
  803393:	e8 3b de ff ff       	call   8011d3 <sys_ipc_recv>
  803398:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80339a:	e8 32 e1 ff ff       	call   8014d1 <sys_getenvid>
  80339f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8033a4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8033a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8033ac:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  8033b1:	85 f6                	test   %esi,%esi
  8033b3:	74 0e                	je     8033c3 <ipc_recv+0x55>
  8033b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ba:	85 db                	test   %ebx,%ebx
  8033bc:	75 03                	jne    8033c1 <ipc_recv+0x53>
  8033be:	8b 50 74             	mov    0x74(%eax),%edx
  8033c1:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  8033c3:	85 ff                	test   %edi,%edi
  8033c5:	74 13                	je     8033da <ipc_recv+0x6c>
  8033c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cc:	85 db                	test   %ebx,%ebx
  8033ce:	75 08                	jne    8033d8 <ipc_recv+0x6a>
  8033d0:	a1 08 50 80 00       	mov    0x805008,%eax
  8033d5:	8b 40 78             	mov    0x78(%eax),%eax
  8033d8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8033da:	85 db                	test   %ebx,%ebx
  8033dc:	75 08                	jne    8033e6 <ipc_recv+0x78>
  8033de:	a1 08 50 80 00       	mov    0x805008,%eax
  8033e3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8033e6:	89 d8                	mov    %ebx,%eax
  8033e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8033eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8033ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8033f1:	89 ec                	mov    %ebp,%esp
  8033f3:	5d                   	pop    %ebp
  8033f4:	c3                   	ret    
  8033f5:	00 00                	add    %al,(%eax)
	...

008033f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033f8:	55                   	push   %ebp
  8033f9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	89 c2                	mov    %eax,%edx
  803400:	c1 ea 16             	shr    $0x16,%edx
  803403:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80340a:	f6 c2 01             	test   $0x1,%dl
  80340d:	74 20                	je     80342f <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  80340f:	c1 e8 0c             	shr    $0xc,%eax
  803412:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803419:	a8 01                	test   $0x1,%al
  80341b:	74 12                	je     80342f <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80341d:	c1 e8 0c             	shr    $0xc,%eax
  803420:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803425:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  80342a:	0f b7 c0             	movzwl %ax,%eax
  80342d:	eb 05                	jmp    803434 <pageref+0x3c>
  80342f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803434:	5d                   	pop    %ebp
  803435:	c3                   	ret    
	...

00803440 <__udivdi3>:
  803440:	55                   	push   %ebp
  803441:	89 e5                	mov    %esp,%ebp
  803443:	57                   	push   %edi
  803444:	56                   	push   %esi
  803445:	83 ec 10             	sub    $0x10,%esp
  803448:	8b 45 14             	mov    0x14(%ebp),%eax
  80344b:	8b 55 08             	mov    0x8(%ebp),%edx
  80344e:	8b 75 10             	mov    0x10(%ebp),%esi
  803451:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803454:	85 c0                	test   %eax,%eax
  803456:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803459:	75 35                	jne    803490 <__udivdi3+0x50>
  80345b:	39 fe                	cmp    %edi,%esi
  80345d:	77 61                	ja     8034c0 <__udivdi3+0x80>
  80345f:	85 f6                	test   %esi,%esi
  803461:	75 0b                	jne    80346e <__udivdi3+0x2e>
  803463:	b8 01 00 00 00       	mov    $0x1,%eax
  803468:	31 d2                	xor    %edx,%edx
  80346a:	f7 f6                	div    %esi
  80346c:	89 c6                	mov    %eax,%esi
  80346e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803471:	31 d2                	xor    %edx,%edx
  803473:	89 f8                	mov    %edi,%eax
  803475:	f7 f6                	div    %esi
  803477:	89 c7                	mov    %eax,%edi
  803479:	89 c8                	mov    %ecx,%eax
  80347b:	f7 f6                	div    %esi
  80347d:	89 c1                	mov    %eax,%ecx
  80347f:	89 fa                	mov    %edi,%edx
  803481:	89 c8                	mov    %ecx,%eax
  803483:	83 c4 10             	add    $0x10,%esp
  803486:	5e                   	pop    %esi
  803487:	5f                   	pop    %edi
  803488:	5d                   	pop    %ebp
  803489:	c3                   	ret    
  80348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803490:	39 f8                	cmp    %edi,%eax
  803492:	77 1c                	ja     8034b0 <__udivdi3+0x70>
  803494:	0f bd d0             	bsr    %eax,%edx
  803497:	83 f2 1f             	xor    $0x1f,%edx
  80349a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80349d:	75 39                	jne    8034d8 <__udivdi3+0x98>
  80349f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8034a2:	0f 86 a0 00 00 00    	jbe    803548 <__udivdi3+0x108>
  8034a8:	39 f8                	cmp    %edi,%eax
  8034aa:	0f 82 98 00 00 00    	jb     803548 <__udivdi3+0x108>
  8034b0:	31 ff                	xor    %edi,%edi
  8034b2:	31 c9                	xor    %ecx,%ecx
  8034b4:	89 c8                	mov    %ecx,%eax
  8034b6:	89 fa                	mov    %edi,%edx
  8034b8:	83 c4 10             	add    $0x10,%esp
  8034bb:	5e                   	pop    %esi
  8034bc:	5f                   	pop    %edi
  8034bd:	5d                   	pop    %ebp
  8034be:	c3                   	ret    
  8034bf:	90                   	nop
  8034c0:	89 d1                	mov    %edx,%ecx
  8034c2:	89 fa                	mov    %edi,%edx
  8034c4:	89 c8                	mov    %ecx,%eax
  8034c6:	31 ff                	xor    %edi,%edi
  8034c8:	f7 f6                	div    %esi
  8034ca:	89 c1                	mov    %eax,%ecx
  8034cc:	89 fa                	mov    %edi,%edx
  8034ce:	89 c8                	mov    %ecx,%eax
  8034d0:	83 c4 10             	add    $0x10,%esp
  8034d3:	5e                   	pop    %esi
  8034d4:	5f                   	pop    %edi
  8034d5:	5d                   	pop    %ebp
  8034d6:	c3                   	ret    
  8034d7:	90                   	nop
  8034d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034dc:	89 f2                	mov    %esi,%edx
  8034de:	d3 e0                	shl    %cl,%eax
  8034e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8034e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8034e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8034eb:	89 c1                	mov    %eax,%ecx
  8034ed:	d3 ea                	shr    %cl,%edx
  8034ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8034f6:	d3 e6                	shl    %cl,%esi
  8034f8:	89 c1                	mov    %eax,%ecx
  8034fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8034fd:	89 fe                	mov    %edi,%esi
  8034ff:	d3 ee                	shr    %cl,%esi
  803501:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803505:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350b:	d3 e7                	shl    %cl,%edi
  80350d:	89 c1                	mov    %eax,%ecx
  80350f:	d3 ea                	shr    %cl,%edx
  803511:	09 d7                	or     %edx,%edi
  803513:	89 f2                	mov    %esi,%edx
  803515:	89 f8                	mov    %edi,%eax
  803517:	f7 75 ec             	divl   -0x14(%ebp)
  80351a:	89 d6                	mov    %edx,%esi
  80351c:	89 c7                	mov    %eax,%edi
  80351e:	f7 65 e8             	mull   -0x18(%ebp)
  803521:	39 d6                	cmp    %edx,%esi
  803523:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803526:	72 30                	jb     803558 <__udivdi3+0x118>
  803528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80352b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80352f:	d3 e2                	shl    %cl,%edx
  803531:	39 c2                	cmp    %eax,%edx
  803533:	73 05                	jae    80353a <__udivdi3+0xfa>
  803535:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803538:	74 1e                	je     803558 <__udivdi3+0x118>
  80353a:	89 f9                	mov    %edi,%ecx
  80353c:	31 ff                	xor    %edi,%edi
  80353e:	e9 71 ff ff ff       	jmp    8034b4 <__udivdi3+0x74>
  803543:	90                   	nop
  803544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803548:	31 ff                	xor    %edi,%edi
  80354a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80354f:	e9 60 ff ff ff       	jmp    8034b4 <__udivdi3+0x74>
  803554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803558:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80355b:	31 ff                	xor    %edi,%edi
  80355d:	89 c8                	mov    %ecx,%eax
  80355f:	89 fa                	mov    %edi,%edx
  803561:	83 c4 10             	add    $0x10,%esp
  803564:	5e                   	pop    %esi
  803565:	5f                   	pop    %edi
  803566:	5d                   	pop    %ebp
  803567:	c3                   	ret    
	...

00803570 <__umoddi3>:
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
  803573:	57                   	push   %edi
  803574:	56                   	push   %esi
  803575:	83 ec 20             	sub    $0x20,%esp
  803578:	8b 55 14             	mov    0x14(%ebp),%edx
  80357b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80357e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803581:	8b 75 0c             	mov    0xc(%ebp),%esi
  803584:	85 d2                	test   %edx,%edx
  803586:	89 c8                	mov    %ecx,%eax
  803588:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80358b:	75 13                	jne    8035a0 <__umoddi3+0x30>
  80358d:	39 f7                	cmp    %esi,%edi
  80358f:	76 3f                	jbe    8035d0 <__umoddi3+0x60>
  803591:	89 f2                	mov    %esi,%edx
  803593:	f7 f7                	div    %edi
  803595:	89 d0                	mov    %edx,%eax
  803597:	31 d2                	xor    %edx,%edx
  803599:	83 c4 20             	add    $0x20,%esp
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	39 f2                	cmp    %esi,%edx
  8035a2:	77 4c                	ja     8035f0 <__umoddi3+0x80>
  8035a4:	0f bd ca             	bsr    %edx,%ecx
  8035a7:	83 f1 1f             	xor    $0x1f,%ecx
  8035aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8035ad:	75 51                	jne    803600 <__umoddi3+0x90>
  8035af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8035b2:	0f 87 e0 00 00 00    	ja     803698 <__umoddi3+0x128>
  8035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bb:	29 f8                	sub    %edi,%eax
  8035bd:	19 d6                	sbb    %edx,%esi
  8035bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	89 f2                	mov    %esi,%edx
  8035c7:	83 c4 20             	add    $0x20,%esp
  8035ca:	5e                   	pop    %esi
  8035cb:	5f                   	pop    %edi
  8035cc:	5d                   	pop    %ebp
  8035cd:	c3                   	ret    
  8035ce:	66 90                	xchg   %ax,%ax
  8035d0:	85 ff                	test   %edi,%edi
  8035d2:	75 0b                	jne    8035df <__umoddi3+0x6f>
  8035d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d9:	31 d2                	xor    %edx,%edx
  8035db:	f7 f7                	div    %edi
  8035dd:	89 c7                	mov    %eax,%edi
  8035df:	89 f0                	mov    %esi,%eax
  8035e1:	31 d2                	xor    %edx,%edx
  8035e3:	f7 f7                	div    %edi
  8035e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e8:	f7 f7                	div    %edi
  8035ea:	eb a9                	jmp    803595 <__umoddi3+0x25>
  8035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8035f0:	89 c8                	mov    %ecx,%eax
  8035f2:	89 f2                	mov    %esi,%edx
  8035f4:	83 c4 20             	add    $0x20,%esp
  8035f7:	5e                   	pop    %esi
  8035f8:	5f                   	pop    %edi
  8035f9:	5d                   	pop    %ebp
  8035fa:	c3                   	ret    
  8035fb:	90                   	nop
  8035fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803600:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803604:	d3 e2                	shl    %cl,%edx
  803606:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803609:	ba 20 00 00 00       	mov    $0x20,%edx
  80360e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803611:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803614:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803618:	89 fa                	mov    %edi,%edx
  80361a:	d3 ea                	shr    %cl,%edx
  80361c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803620:	0b 55 f4             	or     -0xc(%ebp),%edx
  803623:	d3 e7                	shl    %cl,%edi
  803625:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803629:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80362c:	89 f2                	mov    %esi,%edx
  80362e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803631:	89 c7                	mov    %eax,%edi
  803633:	d3 ea                	shr    %cl,%edx
  803635:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803639:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80363c:	89 c2                	mov    %eax,%edx
  80363e:	d3 e6                	shl    %cl,%esi
  803640:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803644:	d3 ea                	shr    %cl,%edx
  803646:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80364a:	09 d6                	or     %edx,%esi
  80364c:	89 f0                	mov    %esi,%eax
  80364e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803651:	d3 e7                	shl    %cl,%edi
  803653:	89 f2                	mov    %esi,%edx
  803655:	f7 75 f4             	divl   -0xc(%ebp)
  803658:	89 d6                	mov    %edx,%esi
  80365a:	f7 65 e8             	mull   -0x18(%ebp)
  80365d:	39 d6                	cmp    %edx,%esi
  80365f:	72 2b                	jb     80368c <__umoddi3+0x11c>
  803661:	39 c7                	cmp    %eax,%edi
  803663:	72 23                	jb     803688 <__umoddi3+0x118>
  803665:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803669:	29 c7                	sub    %eax,%edi
  80366b:	19 d6                	sbb    %edx,%esi
  80366d:	89 f0                	mov    %esi,%eax
  80366f:	89 f2                	mov    %esi,%edx
  803671:	d3 ef                	shr    %cl,%edi
  803673:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803677:	d3 e0                	shl    %cl,%eax
  803679:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80367d:	09 f8                	or     %edi,%eax
  80367f:	d3 ea                	shr    %cl,%edx
  803681:	83 c4 20             	add    $0x20,%esp
  803684:	5e                   	pop    %esi
  803685:	5f                   	pop    %edi
  803686:	5d                   	pop    %ebp
  803687:	c3                   	ret    
  803688:	39 d6                	cmp    %edx,%esi
  80368a:	75 d9                	jne    803665 <__umoddi3+0xf5>
  80368c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80368f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803692:	eb d1                	jmp    803665 <__umoddi3+0xf5>
  803694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803698:	39 f2                	cmp    %esi,%edx
  80369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8036a0:	0f 82 12 ff ff ff    	jb     8035b8 <__umoddi3+0x48>
  8036a6:	e9 17 ff ff ff       	jmp    8035c2 <__umoddi3+0x52>
