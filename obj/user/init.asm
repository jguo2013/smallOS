
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 d3 03 00 00       	call   800404 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800055:	eb 0c                	jmp    800063 <sum+0x23>
		tot ^= i * s[i];
  800057:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005b:	0f af ca             	imul   %edx,%ecx
  80005e:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800060:	83 c2 01             	add    $0x1,%edx
  800063:	39 da                	cmp    %ebx,%edx
  800065:	7c f0                	jl     800057 <sum+0x17>
		tot ^= i * s[i];
	return tot;
}
  800067:	5b                   	pop    %ebx
  800068:	5e                   	pop    %esi
  800069:	5d                   	pop    %ebp
  80006a:	c3                   	ret    

0080006b <umain>:

void
umain(int argc, char **argv)
{
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	57                   	push   %edi
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800077:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80007a:	c7 04 24 e0 30 80 00 	movl   $0x8030e0,(%esp)
  800081:	e8 9b 04 00 00       	call   800521 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800086:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  800095:	e8 a6 ff ff ff       	call   800040 <sum>
  80009a:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009f:	74 1a                	je     8000bb <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000a8:	00 
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  8000b4:	e8 68 04 00 00       	call   800521 <cprintf>
  8000b9:	eb 0c                	jmp    8000c7 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bb:	c7 04 24 ef 30 80 00 	movl   $0x8030ef,(%esp)
  8000c2:	e8 5a 04 00 00       	call   800521 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c7:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000d6:	e8 65 ff ff ff       	call   800040 <sum>
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 12                	je     8000f1 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e3:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  8000ea:	e8 32 04 00 00       	call   800521 <cprintf>
  8000ef:	eb 0c                	jmp    8000fd <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f1:	c7 04 24 06 31 80 00 	movl   $0x803106,(%esp)
  8000f8:	e8 24 04 00 00       	call   800521 <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000fd:	c7 44 24 04 1c 31 80 	movl   $0x80311c,0x4(%esp)
  800104:	00 
  800105:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80010b:	89 04 24             	mov    %eax,(%esp)
  80010e:	e8 96 0a 00 00       	call   800ba9 <strcat>
  800113:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < argc; i++) {
		strcat(args, " '");
  800118:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80011e:	eb 32                	jmp    800152 <umain+0xe7>
		strcat(args, " '");
  800120:	c7 44 24 04 28 31 80 	movl   $0x803128,0x4(%esp)
  800127:	00 
  800128:	89 34 24             	mov    %esi,(%esp)
  80012b:	e8 79 0a 00 00       	call   800ba9 <strcat>
		strcat(args, argv[i]);
  800130:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 6a 0a 00 00       	call   800ba9 <strcat>
		strcat(args, "'");
  80013f:	c7 44 24 04 29 31 80 	movl   $0x803129,0x4(%esp)
  800146:	00 
  800147:	89 34 24             	mov    %esi,(%esp)
  80014a:	e8 5a 0a 00 00       	call   800ba9 <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80014f:	83 c3 01             	add    $0x1,%ebx
  800152:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800155:	7c c9                	jl     800120 <umain+0xb5>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  800157:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	c7 04 24 2b 31 80 00 	movl   $0x80312b,(%esp)
  800168:	e8 b4 03 00 00       	call   800521 <cprintf>

	cprintf("init: running sh\n");
  80016d:	c7 04 24 2f 31 80 00 	movl   $0x80312f,(%esp)
  800174:	e8 a8 03 00 00       	call   800521 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800180:	e8 b1 16 00 00       	call   801836 <close>
	if ((r = opencons()) < 0)
  800185:	e8 bd 01 00 00       	call   800347 <opencons>
  80018a:	85 c0                	test   %eax,%eax
  80018c:	79 20                	jns    8001ae <umain+0x143>
		panic("opencons: %e", r);
  80018e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800192:	c7 44 24 08 41 31 80 	movl   $0x803141,0x8(%esp)
  800199:	00 
  80019a:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001a1:	00 
  8001a2:	c7 04 24 4e 31 80 00 	movl   $0x80314e,(%esp)
  8001a9:	e8 ba 02 00 00       	call   800468 <_panic>
	if (r != 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	74 20                	je     8001d2 <umain+0x167>
		panic("first opencons used fd %d", r);
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 5a 31 80 	movl   $0x80315a,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 4e 31 80 00 	movl   $0x80314e,(%esp)
  8001cd:	e8 96 02 00 00       	call   800468 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001d9:	00 
  8001da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e1:	e8 ef 16 00 00       	call   8018d5 <dup>
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	79 20                	jns    80020a <umain+0x19f>
		panic("dup: %e", r);
  8001ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ee:	c7 44 24 08 74 31 80 	movl   $0x803174,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 4e 31 80 00 	movl   $0x80314e,(%esp)
  800205:	e8 5e 02 00 00       	call   800468 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  80020a:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  800211:	e8 0b 03 00 00       	call   800521 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80021d:	00 
  80021e:	c7 44 24 04 90 31 80 	movl   $0x803190,0x4(%esp)
  800225:	00 
  800226:	c7 04 24 8f 31 80 00 	movl   $0x80318f,(%esp)
  80022d:	e8 4f 21 00 00       	call   802381 <spawnl>
		if (r < 0) {
  800232:	85 c0                	test   %eax,%eax
  800234:	79 12                	jns    800248 <umain+0x1dd>
			cprintf("init: spawn sh: %e\n", r);
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	c7 04 24 93 31 80 00 	movl   $0x803193,(%esp)
  800241:	e8 db 02 00 00       	call   800521 <cprintf>
			continue;
  800246:	eb c2                	jmp    80020a <umain+0x19f>
		}
		wait(r);
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 48 2a 00 00       	call   802c98 <wait>
  800250:	eb b8                	jmp    80020a <umain+0x19f>
	...

00800260 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800270:	c7 44 24 04 13 32 80 	movl   $0x803213,0x4(%esp)
  800277:	00 
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 06 09 00 00       	call   800b89 <strcpy>
	return 0;
}
  800283:	b8 00 00 00 00       	mov    $0x0,%eax
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  800296:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80029b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002a1:	eb 34                	jmp    8002d7 <devcons_write+0x4d>
		m = n - tot;
  8002a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002a6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8002a8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8002ae:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002b3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002ba:	03 45 0c             	add    0xc(%ebp),%eax
  8002bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c1:	89 3c 24             	mov    %edi,(%esp)
  8002c4:	e8 66 0a 00 00       	call   800d2f <memmove>
		sys_cputs(buf, m);
  8002c9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002cd:	89 3c 24             	mov    %edi,(%esp)
  8002d0:	e8 6b 0c 00 00       	call   800f40 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002d5:	01 de                	add    %ebx,%esi
  8002d7:	89 f0                	mov    %esi,%eax
  8002d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8002dc:	72 c5                	jb     8002a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002de:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8002f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8002fc:	00 
  8002fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800300:	89 04 24             	mov    %eax,(%esp)
  800303:	e8 38 0c 00 00       	call   800f40 <sys_cputs>
}
  800308:	c9                   	leave  
  800309:	c3                   	ret    

0080030a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  800310:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800314:	75 07                	jne    80031d <devcons_read+0x13>
  800316:	eb 28                	jmp    800340 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800318:	e8 10 10 00 00       	call   80132d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80031d:	8d 76 00             	lea    0x0(%esi),%esi
  800320:	e8 e7 0b 00 00       	call   800f0c <sys_cgetc>
  800325:	85 c0                	test   %eax,%eax
  800327:	74 ef                	je     800318 <devcons_read+0xe>
  800329:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80032b:	85 c0                	test   %eax,%eax
  80032d:	78 16                	js     800345 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80032f:	83 f8 04             	cmp    $0x4,%eax
  800332:	74 0c                	je     800340 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800334:	8b 45 0c             	mov    0xc(%ebp),%eax
  800337:	88 10                	mov    %dl,(%eax)
  800339:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80033e:	eb 05                	jmp    800345 <devcons_read+0x3b>
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800345:	c9                   	leave  
  800346:	c3                   	ret    

00800347 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80034d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800350:	89 04 24             	mov    %eax,(%esp)
  800353:	e8 c7 10 00 00       	call   80141f <fd_alloc>
  800358:	85 c0                	test   %eax,%eax
  80035a:	78 3f                	js     80039b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800363:	00 
  800364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800372:	e8 57 0f 00 00       	call   8012ce <sys_page_alloc>
  800377:	85 c0                	test   %eax,%eax
  800379:	78 20                	js     80039b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80037b:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800384:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800389:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800393:	89 04 24             	mov    %eax,(%esp)
  800396:	e8 59 10 00 00       	call   8013f4 <fd2num>
}
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8003a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	89 04 24             	mov    %eax,(%esp)
  8003b0:	e8 c3 10 00 00       	call   801478 <fd_lookup>
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	78 11                	js     8003ca <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	3b 05 70 57 80 00    	cmp    0x805770,%eax
  8003c4:	0f 94 c0             	sete   %al
  8003c7:	0f b6 c0             	movzbl %al,%eax
}
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    

008003cc <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8003d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8003d9:	00 
  8003da:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003e8:	e8 e2 12 00 00       	call   8016cf <read>
	if (r < 0)
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	78 0f                	js     800400 <getchar+0x34>
		return r;
	if (r < 1)
  8003f1:	85 c0                	test   %eax,%eax
  8003f3:	7f 07                	jg     8003fc <getchar+0x30>
  8003f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8003fa:	eb 04                	jmp    800400 <getchar+0x34>
		return -E_EOF;
	return c;
  8003fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800400:	c9                   	leave  
  800401:	c3                   	ret    
	...

00800404 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	83 ec 18             	sub    $0x18,%esp
  80040a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80040d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800410:	8b 75 08             	mov    0x8(%ebp),%esi
  800413:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800416:	e8 46 0f 00 00       	call   801361 <sys_getenvid>
  80041b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800420:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800423:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800428:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80042d:	85 f6                	test   %esi,%esi
  80042f:	7e 07                	jle    800438 <libmain+0x34>
		binaryname = argv[0];
  800431:	8b 03                	mov    (%ebx),%eax
  800433:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  800438:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80043c:	89 34 24             	mov    %esi,(%esp)
  80043f:	e8 27 fc ff ff       	call   80006b <umain>

	// exit gracefully
	exit();
  800444:	e8 0b 00 00 00       	call   800454 <exit>
}
  800449:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80044c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80044f:	89 ec                	mov    %ebp,%esp
  800451:	5d                   	pop    %ebp
  800452:	c3                   	ret    
	...

00800454 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80045a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800461:	e8 2f 0f 00 00       	call   801395 <sys_env_destroy>
}
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	56                   	push   %esi
  80046c:	53                   	push   %ebx
  80046d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800470:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800473:	8b 1d 8c 57 80 00    	mov    0x80578c,%ebx
  800479:	e8 e3 0e 00 00       	call   801361 <sys_getenvid>
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 54 24 10          	mov    %edx,0x10(%esp)
  800485:	8b 55 08             	mov    0x8(%ebp),%edx
  800488:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800490:	89 44 24 04          	mov    %eax,0x4(%esp)
  800494:	c7 04 24 2c 32 80 00 	movl   $0x80322c,(%esp)
  80049b:	e8 81 00 00 00       	call   800521 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a7:	89 04 24             	mov    %eax,(%esp)
  8004aa:	e8 11 00 00 00       	call   8004c0 <vcprintf>
	cprintf("\n");
  8004af:	c7 04 24 d7 37 80 00 	movl   $0x8037d7,(%esp)
  8004b6:	e8 66 00 00 00       	call   800521 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004bb:	cc                   	int3   
  8004bc:	eb fd                	jmp    8004bb <_panic+0x53>
	...

008004c0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f5:	c7 04 24 3b 05 80 00 	movl   $0x80053b,(%esp)
  8004fc:	e8 be 01 00 00       	call   8006bf <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800501:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800507:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800511:	89 04 24             	mov    %eax,(%esp)
  800514:	e8 27 0a 00 00       	call   800f40 <sys_cputs>

	return b.cnt;
}
  800519:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800527:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80052a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	89 04 24             	mov    %eax,(%esp)
  800534:	e8 87 ff ff ff       	call   8004c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800539:	c9                   	leave  
  80053a:	c3                   	ret    

0080053b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	53                   	push   %ebx
  80053f:	83 ec 14             	sub    $0x14,%esp
  800542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800545:	8b 03                	mov    (%ebx),%eax
  800547:	8b 55 08             	mov    0x8(%ebp),%edx
  80054a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80054e:	83 c0 01             	add    $0x1,%eax
  800551:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800553:	3d ff 00 00 00       	cmp    $0xff,%eax
  800558:	75 19                	jne    800573 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80055a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800561:	00 
  800562:	8d 43 08             	lea    0x8(%ebx),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	e8 d3 09 00 00       	call   800f40 <sys_cputs>
		b->idx = 0;
  80056d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800573:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800577:	83 c4 14             	add    $0x14,%esp
  80057a:	5b                   	pop    %ebx
  80057b:	5d                   	pop    %ebp
  80057c:	c3                   	ret    
  80057d:	00 00                	add    %al,(%eax)
	...

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 4c             	sub    $0x4c,%esp
  800589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058c:	89 d6                	mov    %edx,%esi
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800594:	8b 55 0c             	mov    0xc(%ebp),%edx
  800597:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005a0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ab:	39 d1                	cmp    %edx,%ecx
  8005ad:	72 07                	jb     8005b6 <printnum+0x36>
  8005af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b2:	39 d0                	cmp    %edx,%eax
  8005b4:	77 69                	ja     80061f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005ba:	83 eb 01             	sub    $0x1,%ebx
  8005bd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8005c9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8005cd:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005d0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005d3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005e1:	00 
  8005e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e5:	89 04 24             	mov    %eax,(%esp)
  8005e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ef:	e8 7c 28 00 00       	call   802e70 <__udivdi3>
  8005f4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800602:	89 04 24             	mov    %eax,(%esp)
  800605:	89 54 24 04          	mov    %edx,0x4(%esp)
  800609:	89 f2                	mov    %esi,%edx
  80060b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060e:	e8 6d ff ff ff       	call   800580 <printnum>
  800613:	eb 11                	jmp    800626 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800615:	89 74 24 04          	mov    %esi,0x4(%esp)
  800619:	89 3c 24             	mov    %edi,(%esp)
  80061c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061f:	83 eb 01             	sub    $0x1,%ebx
  800622:	85 db                	test   %ebx,%ebx
  800624:	7f ef                	jg     800615 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80062e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800631:	89 44 24 08          	mov    %eax,0x8(%esp)
  800635:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80063c:	00 
  80063d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800640:	89 14 24             	mov    %edx,(%esp)
  800643:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800646:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80064a:	e8 51 29 00 00       	call   802fa0 <__umoddi3>
  80064f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800653:	0f be 80 4f 32 80 00 	movsbl 0x80324f(%eax),%eax
  80065a:	89 04 24             	mov    %eax,(%esp)
  80065d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800660:	83 c4 4c             	add    $0x4c,%esp
  800663:	5b                   	pop    %ebx
  800664:	5e                   	pop    %esi
  800665:	5f                   	pop    %edi
  800666:	5d                   	pop    %ebp
  800667:	c3                   	ret    

00800668 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066b:	83 fa 01             	cmp    $0x1,%edx
  80066e:	7e 0e                	jle    80067e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800670:	8b 10                	mov    (%eax),%edx
  800672:	8d 4a 08             	lea    0x8(%edx),%ecx
  800675:	89 08                	mov    %ecx,(%eax)
  800677:	8b 02                	mov    (%edx),%eax
  800679:	8b 52 04             	mov    0x4(%edx),%edx
  80067c:	eb 22                	jmp    8006a0 <getuint+0x38>
	else if (lflag)
  80067e:	85 d2                	test   %edx,%edx
  800680:	74 10                	je     800692 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800682:	8b 10                	mov    (%eax),%edx
  800684:	8d 4a 04             	lea    0x4(%edx),%ecx
  800687:	89 08                	mov    %ecx,(%eax)
  800689:	8b 02                	mov    (%edx),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	eb 0e                	jmp    8006a0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800692:	8b 10                	mov    (%eax),%edx
  800694:	8d 4a 04             	lea    0x4(%edx),%ecx
  800697:	89 08                	mov    %ecx,(%eax)
  800699:	8b 02                	mov    (%edx),%eax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a0:	5d                   	pop    %ebp
  8006a1:	c3                   	ret    

008006a2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006ac:	8b 10                	mov    (%eax),%edx
  8006ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8006b1:	73 0a                	jae    8006bd <sprintputch+0x1b>
		*b->buf++ = ch;
  8006b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b6:	88 0a                	mov    %cl,(%edx)
  8006b8:	83 c2 01             	add    $0x1,%edx
  8006bb:	89 10                	mov    %edx,(%eax)
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	57                   	push   %edi
  8006c3:	56                   	push   %esi
  8006c4:	53                   	push   %ebx
  8006c5:	83 ec 4c             	sub    $0x4c,%esp
  8006c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006d1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8006d8:	eb 11                	jmp    8006eb <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	0f 84 b6 03 00 00    	je     800a98 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8006e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e6:	89 04 24             	mov    %eax,(%esp)
  8006e9:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006eb:	0f b6 03             	movzbl (%ebx),%eax
  8006ee:	83 c3 01             	add    $0x1,%ebx
  8006f1:	83 f8 25             	cmp    $0x25,%eax
  8006f4:	75 e4                	jne    8006da <vprintfmt+0x1b>
  8006f6:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8006fa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800701:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800708:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800717:	eb 06                	jmp    80071f <vprintfmt+0x60>
  800719:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  80071d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071f:	0f b6 0b             	movzbl (%ebx),%ecx
  800722:	0f b6 c1             	movzbl %cl,%eax
  800725:	8d 53 01             	lea    0x1(%ebx),%edx
  800728:	83 e9 23             	sub    $0x23,%ecx
  80072b:	80 f9 55             	cmp    $0x55,%cl
  80072e:	0f 87 47 03 00 00    	ja     800a7b <vprintfmt+0x3bc>
  800734:	0f b6 c9             	movzbl %cl,%ecx
  800737:	ff 24 8d a0 33 80 00 	jmp    *0x8033a0(,%ecx,4)
  80073e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800742:	eb d9                	jmp    80071d <vprintfmt+0x5e>
  800744:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80074b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800750:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800753:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800757:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80075a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80075d:	83 fb 09             	cmp    $0x9,%ebx
  800760:	77 30                	ja     800792 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800762:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800765:	eb e9                	jmp    800750 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 48 04             	lea    0x4(%eax),%ecx
  80076d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800770:	8b 00                	mov    (%eax),%eax
  800772:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800775:	eb 1e                	jmp    800795 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800787:	eb 94                	jmp    80071d <vprintfmt+0x5e>
  800789:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800790:	eb 8b                	jmp    80071d <vprintfmt+0x5e>
  800792:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800795:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800799:	79 82                	jns    80071d <vprintfmt+0x5e>
  80079b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80079e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007a4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8007a7:	e9 71 ff ff ff       	jmp    80071d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ac:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007b0:	e9 68 ff ff ff       	jmp    80071d <vprintfmt+0x5e>
  8007b5:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	89 04 24             	mov    %eax,(%esp)
  8007ca:	ff d7                	call   *%edi
  8007cc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007cf:	e9 17 ff ff ff       	jmp    8006eb <vprintfmt+0x2c>
  8007d4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	89 c2                	mov    %eax,%edx
  8007e4:	c1 fa 1f             	sar    $0x1f,%edx
  8007e7:	31 d0                	xor    %edx,%eax
  8007e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007eb:	83 f8 11             	cmp    $0x11,%eax
  8007ee:	7f 0b                	jg     8007fb <vprintfmt+0x13c>
  8007f0:	8b 14 85 00 35 80 00 	mov    0x803500(,%eax,4),%edx
  8007f7:	85 d2                	test   %edx,%edx
  8007f9:	75 20                	jne    80081b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8007fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ff:	c7 44 24 08 60 32 80 	movl   $0x803260,0x8(%esp)
  800806:	00 
  800807:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080b:	89 3c 24             	mov    %edi,(%esp)
  80080e:	e8 0d 03 00 00       	call   800b20 <printfmt>
  800813:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800816:	e9 d0 fe ff ff       	jmp    8006eb <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80081b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80081f:	c7 44 24 08 56 36 80 	movl   $0x803656,0x8(%esp)
  800826:	00 
  800827:	89 74 24 04          	mov    %esi,0x4(%esp)
  80082b:	89 3c 24             	mov    %edi,(%esp)
  80082e:	e8 ed 02 00 00       	call   800b20 <printfmt>
  800833:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800836:	e9 b0 fe ff ff       	jmp    8006eb <vprintfmt+0x2c>
  80083b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80083e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800844:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8d 50 04             	lea    0x4(%eax),%edx
  80084d:	89 55 14             	mov    %edx,0x14(%ebp)
  800850:	8b 18                	mov    (%eax),%ebx
  800852:	85 db                	test   %ebx,%ebx
  800854:	b8 69 32 80 00       	mov    $0x803269,%eax
  800859:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80085c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800860:	7e 76                	jle    8008d8 <vprintfmt+0x219>
  800862:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800866:	74 7a                	je     8008e2 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800868:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80086c:	89 1c 24             	mov    %ebx,(%esp)
  80086f:	e8 f4 02 00 00       	call   800b68 <strnlen>
  800874:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800877:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800879:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80087d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800880:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800883:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800885:	eb 0f                	jmp    800896 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800887:	89 74 24 04          	mov    %esi,0x4(%esp)
  80088b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088e:	89 04 24             	mov    %eax,(%esp)
  800891:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800893:	83 eb 01             	sub    $0x1,%ebx
  800896:	85 db                	test   %ebx,%ebx
  800898:	7f ed                	jg     800887 <vprintfmt+0x1c8>
  80089a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80089d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008a0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008a3:	89 f7                	mov    %esi,%edi
  8008a5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008a8:	eb 40                	jmp    8008ea <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008ae:	74 18                	je     8008c8 <vprintfmt+0x209>
  8008b0:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008b3:	83 fa 5e             	cmp    $0x5e,%edx
  8008b6:	76 10                	jbe    8008c8 <vprintfmt+0x209>
					putch('?', putdat);
  8008b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008c3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008c6:	eb 0a                	jmp    8008d2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8008c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008cc:	89 04 24             	mov    %eax,(%esp)
  8008cf:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008d6:	eb 12                	jmp    8008ea <vprintfmt+0x22b>
  8008d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008db:	89 f7                	mov    %esi,%edi
  8008dd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008e0:	eb 08                	jmp    8008ea <vprintfmt+0x22b>
  8008e2:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008e5:	89 f7                	mov    %esi,%edi
  8008e7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008ea:	0f be 03             	movsbl (%ebx),%eax
  8008ed:	83 c3 01             	add    $0x1,%ebx
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	74 25                	je     800919 <vprintfmt+0x25a>
  8008f4:	85 f6                	test   %esi,%esi
  8008f6:	78 b2                	js     8008aa <vprintfmt+0x1eb>
  8008f8:	83 ee 01             	sub    $0x1,%esi
  8008fb:	79 ad                	jns    8008aa <vprintfmt+0x1eb>
  8008fd:	89 fe                	mov    %edi,%esi
  8008ff:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800902:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800905:	eb 1a                	jmp    800921 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800907:	89 74 24 04          	mov    %esi,0x4(%esp)
  80090b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800912:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800914:	83 eb 01             	sub    $0x1,%ebx
  800917:	eb 08                	jmp    800921 <vprintfmt+0x262>
  800919:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80091c:	89 fe                	mov    %edi,%esi
  80091e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800921:	85 db                	test   %ebx,%ebx
  800923:	7f e2                	jg     800907 <vprintfmt+0x248>
  800925:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800928:	e9 be fd ff ff       	jmp    8006eb <vprintfmt+0x2c>
  80092d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800930:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800933:	83 f9 01             	cmp    $0x1,%ecx
  800936:	7e 16                	jle    80094e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8d 50 08             	lea    0x8(%eax),%edx
  80093e:	89 55 14             	mov    %edx,0x14(%ebp)
  800941:	8b 10                	mov    (%eax),%edx
  800943:	8b 48 04             	mov    0x4(%eax),%ecx
  800946:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800949:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80094c:	eb 32                	jmp    800980 <vprintfmt+0x2c1>
	else if (lflag)
  80094e:	85 c9                	test   %ecx,%ecx
  800950:	74 18                	je     80096a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8d 50 04             	lea    0x4(%eax),%edx
  800958:	89 55 14             	mov    %edx,0x14(%ebp)
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800960:	89 c1                	mov    %eax,%ecx
  800962:	c1 f9 1f             	sar    $0x1f,%ecx
  800965:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8d 50 04             	lea    0x4(%eax),%edx
  800970:	89 55 14             	mov    %edx,0x14(%ebp)
  800973:	8b 00                	mov    (%eax),%eax
  800975:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800978:	89 c2                	mov    %eax,%edx
  80097a:	c1 fa 1f             	sar    $0x1f,%edx
  80097d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800980:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800983:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800986:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80098b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098f:	0f 89 a7 00 00 00    	jns    800a3c <vprintfmt+0x37d>
				putch('-', putdat);
  800995:	89 74 24 04          	mov    %esi,0x4(%esp)
  800999:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009a0:	ff d7                	call   *%edi
				num = -(long long) num;
  8009a2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009a5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009a8:	f7 d9                	neg    %ecx
  8009aa:	83 d3 00             	adc    $0x0,%ebx
  8009ad:	f7 db                	neg    %ebx
  8009af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b4:	e9 83 00 00 00       	jmp    800a3c <vprintfmt+0x37d>
  8009b9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009bf:	89 ca                	mov    %ecx,%edx
  8009c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c4:	e8 9f fc ff ff       	call   800668 <getuint>
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	89 d3                	mov    %edx,%ebx
  8009cd:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8009d2:	eb 68                	jmp    800a3c <vprintfmt+0x37d>
  8009d4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8009da:	89 ca                	mov    %ecx,%edx
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	e8 84 fc ff ff       	call   800668 <getuint>
  8009e4:	89 c1                	mov    %eax,%ecx
  8009e6:	89 d3                	mov    %edx,%ebx
  8009e8:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8009ed:	eb 4d                	jmp    800a3c <vprintfmt+0x37d>
  8009ef:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8009f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8009fd:	ff d7                	call   *%edi
			putch('x', putdat);
  8009ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a03:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a0a:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8d 50 04             	lea    0x4(%eax),%edx
  800a12:	89 55 14             	mov    %edx,0x14(%ebp)
  800a15:	8b 08                	mov    (%eax),%ecx
  800a17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a1c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a21:	eb 19                	jmp    800a3c <vprintfmt+0x37d>
  800a23:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a26:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a29:	89 ca                	mov    %ecx,%edx
  800a2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2e:	e8 35 fc ff ff       	call   800668 <getuint>
  800a33:	89 c1                	mov    %eax,%ecx
  800a35:	89 d3                	mov    %edx,%ebx
  800a37:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a3c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800a40:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a47:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4f:	89 0c 24             	mov    %ecx,(%esp)
  800a52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a56:	89 f2                	mov    %esi,%edx
  800a58:	89 f8                	mov    %edi,%eax
  800a5a:	e8 21 fb ff ff       	call   800580 <printnum>
  800a5f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800a62:	e9 84 fc ff ff       	jmp    8006eb <vprintfmt+0x2c>
  800a67:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a6a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a6e:	89 04 24             	mov    %eax,(%esp)
  800a71:	ff d7                	call   *%edi
  800a73:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800a76:	e9 70 fc ff ff       	jmp    8006eb <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a86:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800a8b:	80 38 25             	cmpb   $0x25,(%eax)
  800a8e:	0f 84 57 fc ff ff    	je     8006eb <vprintfmt+0x2c>
  800a94:	89 c3                	mov    %eax,%ebx
  800a96:	eb f0                	jmp    800a88 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800a98:	83 c4 4c             	add    $0x4c,%esp
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5f                   	pop    %edi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 28             	sub    $0x28,%esp
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800aac:	85 c0                	test   %eax,%eax
  800aae:	74 04                	je     800ab4 <vsnprintf+0x14>
  800ab0:	85 d2                	test   %edx,%edx
  800ab2:	7f 07                	jg     800abb <vsnprintf+0x1b>
  800ab4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab9:	eb 3b                	jmp    800af6 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800abb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800abe:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ada:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800add:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae1:	c7 04 24 a2 06 80 00 	movl   $0x8006a2,(%esp)
  800ae8:	e8 d2 fb ff ff       	call   8006bf <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b01:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	89 04 24             	mov    %eax,(%esp)
  800b19:	e8 82 ff ff ff       	call   800aa0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b26:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 04 24             	mov    %eax,(%esp)
  800b41:	e8 79 fb ff ff       	call   8006bf <vprintfmt>
	va_end(ap);
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    
	...

00800b50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800b5b:	eb 03                	jmp    800b60 <strlen+0x10>
		n++;
  800b5d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b64:	75 f7                	jne    800b5d <strlen+0xd>
		n++;
	return n;
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	53                   	push   %ebx
  800b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b77:	eb 03                	jmp    800b7c <strnlen+0x14>
		n++;
  800b79:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7c:	39 c1                	cmp    %eax,%ecx
  800b7e:	74 06                	je     800b86 <strnlen+0x1e>
  800b80:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b84:	75 f3                	jne    800b79 <strnlen+0x11>
		n++;
	return n;
}
  800b86:	5b                   	pop    %ebx
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	53                   	push   %ebx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b93:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b98:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b9c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b9f:	83 c2 01             	add    $0x1,%edx
  800ba2:	84 c9                	test   %cl,%cl
  800ba4:	75 f2                	jne    800b98 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	53                   	push   %ebx
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb3:	89 1c 24             	mov    %ebx,(%esp)
  800bb6:	e8 95 ff ff ff       	call   800b50 <strlen>
	strcpy(dst + len, src);
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbe:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bc2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800bc5:	89 04 24             	mov    %eax,(%esp)
  800bc8:	e8 bc ff ff ff       	call   800b89 <strcpy>
	return dst;
}
  800bcd:	89 d8                	mov    %ebx,%eax
  800bcf:	83 c4 08             	add    $0x8,%esp
  800bd2:	5b                   	pop    %ebx
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be0:	8b 75 10             	mov    0x10(%ebp),%esi
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be8:	eb 0f                	jmp    800bf9 <strncpy+0x24>
		*dst++ = *src;
  800bea:	0f b6 19             	movzbl (%ecx),%ebx
  800bed:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf0:	80 39 01             	cmpb   $0x1,(%ecx)
  800bf3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf6:	83 c2 01             	add    $0x1,%edx
  800bf9:	39 f2                	cmp    %esi,%edx
  800bfb:	72 ed                	jb     800bea <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	8b 75 08             	mov    0x8(%ebp),%esi
  800c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c0f:	89 f0                	mov    %esi,%eax
  800c11:	85 d2                	test   %edx,%edx
  800c13:	75 0a                	jne    800c1f <strlcpy+0x1e>
  800c15:	eb 17                	jmp    800c2e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c17:	88 18                	mov    %bl,(%eax)
  800c19:	83 c0 01             	add    $0x1,%eax
  800c1c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c1f:	83 ea 01             	sub    $0x1,%edx
  800c22:	74 07                	je     800c2b <strlcpy+0x2a>
  800c24:	0f b6 19             	movzbl (%ecx),%ebx
  800c27:	84 db                	test   %bl,%bl
  800c29:	75 ec                	jne    800c17 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800c2b:	c6 00 00             	movb   $0x0,(%eax)
  800c2e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c3d:	eb 06                	jmp    800c45 <strcmp+0x11>
		p++, q++;
  800c3f:	83 c1 01             	add    $0x1,%ecx
  800c42:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c45:	0f b6 01             	movzbl (%ecx),%eax
  800c48:	84 c0                	test   %al,%al
  800c4a:	74 04                	je     800c50 <strcmp+0x1c>
  800c4c:	3a 02                	cmp    (%edx),%al
  800c4e:	74 ef                	je     800c3f <strcmp+0xb>
  800c50:	0f b6 c0             	movzbl %al,%eax
  800c53:	0f b6 12             	movzbl (%edx),%edx
  800c56:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	53                   	push   %ebx
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800c67:	eb 09                	jmp    800c72 <strncmp+0x18>
		n--, p++, q++;
  800c69:	83 ea 01             	sub    $0x1,%edx
  800c6c:	83 c0 01             	add    $0x1,%eax
  800c6f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c72:	85 d2                	test   %edx,%edx
  800c74:	75 07                	jne    800c7d <strncmp+0x23>
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	eb 13                	jmp    800c90 <strncmp+0x36>
  800c7d:	0f b6 18             	movzbl (%eax),%ebx
  800c80:	84 db                	test   %bl,%bl
  800c82:	74 04                	je     800c88 <strncmp+0x2e>
  800c84:	3a 19                	cmp    (%ecx),%bl
  800c86:	74 e1                	je     800c69 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c88:	0f b6 00             	movzbl (%eax),%eax
  800c8b:	0f b6 11             	movzbl (%ecx),%edx
  800c8e:	29 d0                	sub    %edx,%eax
}
  800c90:	5b                   	pop    %ebx
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c9d:	eb 07                	jmp    800ca6 <strchr+0x13>
		if (*s == c)
  800c9f:	38 ca                	cmp    %cl,%dl
  800ca1:	74 0f                	je     800cb2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca3:	83 c0 01             	add    $0x1,%eax
  800ca6:	0f b6 10             	movzbl (%eax),%edx
  800ca9:	84 d2                	test   %dl,%dl
  800cab:	75 f2                	jne    800c9f <strchr+0xc>
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cbe:	eb 07                	jmp    800cc7 <strfind+0x13>
		if (*s == c)
  800cc0:	38 ca                	cmp    %cl,%dl
  800cc2:	74 0a                	je     800cce <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cc4:	83 c0 01             	add    $0x1,%eax
  800cc7:	0f b6 10             	movzbl (%eax),%edx
  800cca:	84 d2                	test   %dl,%dl
  800ccc:	75 f2                	jne    800cc0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	89 1c 24             	mov    %ebx,(%esp)
  800cd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ce1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cea:	85 c9                	test   %ecx,%ecx
  800cec:	74 30                	je     800d1e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cf4:	75 25                	jne    800d1b <memset+0x4b>
  800cf6:	f6 c1 03             	test   $0x3,%cl
  800cf9:	75 20                	jne    800d1b <memset+0x4b>
		c &= 0xFF;
  800cfb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cfe:	89 d3                	mov    %edx,%ebx
  800d00:	c1 e3 08             	shl    $0x8,%ebx
  800d03:	89 d6                	mov    %edx,%esi
  800d05:	c1 e6 18             	shl    $0x18,%esi
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	c1 e0 10             	shl    $0x10,%eax
  800d0d:	09 f0                	or     %esi,%eax
  800d0f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d11:	09 d8                	or     %ebx,%eax
  800d13:	c1 e9 02             	shr    $0x2,%ecx
  800d16:	fc                   	cld    
  800d17:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d19:	eb 03                	jmp    800d1e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d1b:	fc                   	cld    
  800d1c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1e:	89 f8                	mov    %edi,%eax
  800d20:	8b 1c 24             	mov    (%esp),%ebx
  800d23:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d27:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d2b:	89 ec                	mov    %ebp,%esp
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 08             	sub    $0x8,%esp
  800d35:	89 34 24             	mov    %esi,(%esp)
  800d38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800d42:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d45:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d47:	39 c6                	cmp    %eax,%esi
  800d49:	73 35                	jae    800d80 <memmove+0x51>
  800d4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d4e:	39 d0                	cmp    %edx,%eax
  800d50:	73 2e                	jae    800d80 <memmove+0x51>
		s += n;
		d += n;
  800d52:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d54:	f6 c2 03             	test   $0x3,%dl
  800d57:	75 1b                	jne    800d74 <memmove+0x45>
  800d59:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d5f:	75 13                	jne    800d74 <memmove+0x45>
  800d61:	f6 c1 03             	test   $0x3,%cl
  800d64:	75 0e                	jne    800d74 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d66:	83 ef 04             	sub    $0x4,%edi
  800d69:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d6c:	c1 e9 02             	shr    $0x2,%ecx
  800d6f:	fd                   	std    
  800d70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d72:	eb 09                	jmp    800d7d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d74:	83 ef 01             	sub    $0x1,%edi
  800d77:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d7a:	fd                   	std    
  800d7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d7d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d7e:	eb 20                	jmp    800da0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d80:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d86:	75 15                	jne    800d9d <memmove+0x6e>
  800d88:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d8e:	75 0d                	jne    800d9d <memmove+0x6e>
  800d90:	f6 c1 03             	test   $0x3,%cl
  800d93:	75 08                	jne    800d9d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800d95:	c1 e9 02             	shr    $0x2,%ecx
  800d98:	fc                   	cld    
  800d99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d9b:	eb 03                	jmp    800da0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d9d:	fc                   	cld    
  800d9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800da0:	8b 34 24             	mov    (%esp),%esi
  800da3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800da7:	89 ec                	mov    %ebp,%esp
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800db1:	8b 45 10             	mov    0x10(%ebp),%eax
  800db4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	89 04 24             	mov    %eax,(%esp)
  800dc5:	e8 65 ff ff ff       	call   800d2f <memmove>
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ddb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800de0:	eb 1c                	jmp    800dfe <memcmp+0x32>
		if (*s1 != *s2)
  800de2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800de6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800dea:	83 c2 01             	add    $0x1,%edx
  800ded:	83 e9 01             	sub    $0x1,%ecx
  800df0:	38 d8                	cmp    %bl,%al
  800df2:	74 0a                	je     800dfe <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	0f b6 db             	movzbl %bl,%ebx
  800dfa:	29 d8                	sub    %ebx,%eax
  800dfc:	eb 09                	jmp    800e07 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dfe:	85 c9                	test   %ecx,%ecx
  800e00:	75 e0                	jne    800de2 <memcmp+0x16>
  800e02:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e15:	89 c2                	mov    %eax,%edx
  800e17:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e1a:	eb 07                	jmp    800e23 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e1c:	38 08                	cmp    %cl,(%eax)
  800e1e:	74 07                	je     800e27 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e20:	83 c0 01             	add    $0x1,%eax
  800e23:	39 d0                	cmp    %edx,%eax
  800e25:	72 f5                	jb     800e1c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 04             	sub    $0x4,%esp
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e38:	eb 03                	jmp    800e3d <strtol+0x14>
		s++;
  800e3a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e3d:	0f b6 02             	movzbl (%edx),%eax
  800e40:	3c 20                	cmp    $0x20,%al
  800e42:	74 f6                	je     800e3a <strtol+0x11>
  800e44:	3c 09                	cmp    $0x9,%al
  800e46:	74 f2                	je     800e3a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e48:	3c 2b                	cmp    $0x2b,%al
  800e4a:	75 0c                	jne    800e58 <strtol+0x2f>
		s++;
  800e4c:	8d 52 01             	lea    0x1(%edx),%edx
  800e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e56:	eb 15                	jmp    800e6d <strtol+0x44>
	else if (*s == '-')
  800e58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e5f:	3c 2d                	cmp    $0x2d,%al
  800e61:	75 0a                	jne    800e6d <strtol+0x44>
		s++, neg = 1;
  800e63:	8d 52 01             	lea    0x1(%edx),%edx
  800e66:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	0f 94 c0             	sete   %al
  800e72:	74 05                	je     800e79 <strtol+0x50>
  800e74:	83 fb 10             	cmp    $0x10,%ebx
  800e77:	75 15                	jne    800e8e <strtol+0x65>
  800e79:	80 3a 30             	cmpb   $0x30,(%edx)
  800e7c:	75 10                	jne    800e8e <strtol+0x65>
  800e7e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e82:	75 0a                	jne    800e8e <strtol+0x65>
		s += 2, base = 16;
  800e84:	83 c2 02             	add    $0x2,%edx
  800e87:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e8c:	eb 13                	jmp    800ea1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e8e:	84 c0                	test   %al,%al
  800e90:	74 0f                	je     800ea1 <strtol+0x78>
  800e92:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e97:	80 3a 30             	cmpb   $0x30,(%edx)
  800e9a:	75 05                	jne    800ea1 <strtol+0x78>
		s++, base = 8;
  800e9c:	83 c2 01             	add    $0x1,%edx
  800e9f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ea8:	0f b6 0a             	movzbl (%edx),%ecx
  800eab:	89 cf                	mov    %ecx,%edi
  800ead:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800eb0:	80 fb 09             	cmp    $0x9,%bl
  800eb3:	77 08                	ja     800ebd <strtol+0x94>
			dig = *s - '0';
  800eb5:	0f be c9             	movsbl %cl,%ecx
  800eb8:	83 e9 30             	sub    $0x30,%ecx
  800ebb:	eb 1e                	jmp    800edb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800ebd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ec0:	80 fb 19             	cmp    $0x19,%bl
  800ec3:	77 08                	ja     800ecd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ec5:	0f be c9             	movsbl %cl,%ecx
  800ec8:	83 e9 57             	sub    $0x57,%ecx
  800ecb:	eb 0e                	jmp    800edb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800ecd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ed0:	80 fb 19             	cmp    $0x19,%bl
  800ed3:	77 15                	ja     800eea <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ed5:	0f be c9             	movsbl %cl,%ecx
  800ed8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800edb:	39 f1                	cmp    %esi,%ecx
  800edd:	7d 0b                	jge    800eea <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800edf:	83 c2 01             	add    $0x1,%edx
  800ee2:	0f af c6             	imul   %esi,%eax
  800ee5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ee8:	eb be                	jmp    800ea8 <strtol+0x7f>
  800eea:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800eec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef0:	74 05                	je     800ef7 <strtol+0xce>
		*endptr = (char *) s;
  800ef2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ef5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ef7:	89 ca                	mov    %ecx,%edx
  800ef9:	f7 da                	neg    %edx
  800efb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eff:	0f 45 c2             	cmovne %edx,%eax
}
  800f02:	83 c4 04             	add    $0x4,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
	...

00800f0c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 0c             	sub    $0xc,%esp
  800f12:	89 1c 24             	mov    %ebx,(%esp)
  800f15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f19:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f22:	b8 01 00 00 00       	mov    $0x1,%eax
  800f27:	89 d1                	mov    %edx,%ecx
  800f29:	89 d3                	mov    %edx,%ebx
  800f2b:	89 d7                	mov    %edx,%edi
  800f2d:	89 d6                	mov    %edx,%esi
  800f2f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f31:	8b 1c 24             	mov    (%esp),%ebx
  800f34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f3c:	89 ec                	mov    %ebp,%esp
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	89 1c 24             	mov    %ebx,(%esp)
  800f49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	89 c3                	mov    %eax,%ebx
  800f5e:	89 c7                	mov    %eax,%edi
  800f60:	89 c6                	mov    %eax,%esi
  800f62:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f64:	8b 1c 24             	mov    (%esp),%ebx
  800f67:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f6b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f6f:	89 ec                	mov    %ebp,%esp
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	89 1c 24             	mov    %ebx,(%esp)
  800f7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f80:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f84:	ba 00 00 00 00       	mov    $0x0,%edx
  800f89:	b8 10 00 00 00       	mov    $0x10,%eax
  800f8e:	89 d1                	mov    %edx,%ecx
  800f90:	89 d3                	mov    %edx,%ebx
  800f92:	89 d7                	mov    %edx,%edi
  800f94:	89 d6                	mov    %edx,%esi
  800f96:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f98:	8b 1c 24             	mov    (%esp),%ebx
  800f9b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f9f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fa3:	89 ec                	mov    %ebp,%esp
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 38             	sub    $0x38,%esp
  800fad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	89 df                	mov    %ebx,%edi
  800fc8:	89 de                	mov    %ebx,%esi
  800fca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	7e 28                	jle    800ff8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fdb:	00 
  800fdc:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800feb:	00 
  800fec:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800ff3:	e8 70 f4 ff ff       	call   800468 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800ff8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ffb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ffe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801001:	89 ec                	mov    %ebp,%esp
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 38             	sub    $0x38,%esp
  80100b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80100e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801011:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
  801019:	b8 0e 00 00 00       	mov    $0xe,%eax
  80101e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	89 df                	mov    %ebx,%edi
  801026:	89 de                	mov    %ebx,%esi
  801028:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102a:	85 c0                	test   %eax,%eax
  80102c:	7e 28                	jle    801056 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801032:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801039:	00 
  80103a:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  801041:	00 
  801042:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801049:	00 
  80104a:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  801051:	e8 12 f4 ff ff       	call   800468 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801056:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801059:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80105c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80105f:	89 ec                	mov    %ebp,%esp
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 38             	sub    $0x38,%esp
  801069:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80106c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80106f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801072:	b9 00 00 00 00       	mov    $0x0,%ecx
  801077:	b8 0d 00 00 00       	mov    $0xd,%eax
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	89 cb                	mov    %ecx,%ebx
  801081:	89 cf                	mov    %ecx,%edi
  801083:	89 ce                	mov    %ecx,%esi
  801085:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801087:	85 c0                	test   %eax,%eax
  801089:	7e 28                	jle    8010b3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80108b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801096:	00 
  801097:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  80109e:	00 
  80109f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a6:	00 
  8010a7:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  8010ae:	e8 b5 f3 ff ff       	call   800468 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010b3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010b6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010bc:	89 ec                	mov    %ebp,%esp
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 0c             	sub    $0xc,%esp
  8010c6:	89 1c 24             	mov    %ebx,(%esp)
  8010c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d1:	be 00 00 00 00       	mov    $0x0,%esi
  8010d6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010db:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e9:	8b 1c 24             	mov    (%esp),%ebx
  8010ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010f0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010f4:	89 ec                	mov    %ebp,%esp
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 38             	sub    $0x38,%esp
  8010fe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801101:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801104:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801107:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801111:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801114:	8b 55 08             	mov    0x8(%ebp),%edx
  801117:	89 df                	mov    %ebx,%edi
  801119:	89 de                	mov    %ebx,%esi
  80111b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80111d:	85 c0                	test   %eax,%eax
  80111f:	7e 28                	jle    801149 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801121:	89 44 24 10          	mov    %eax,0x10(%esp)
  801125:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80112c:	00 
  80112d:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  801134:	00 
  801135:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80113c:	00 
  80113d:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  801144:	e8 1f f3 ff ff       	call   800468 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801149:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80114c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80114f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801152:	89 ec                	mov    %ebp,%esp
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 38             	sub    $0x38,%esp
  80115c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80115f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801162:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801165:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116a:	b8 09 00 00 00       	mov    $0x9,%eax
  80116f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801172:	8b 55 08             	mov    0x8(%ebp),%edx
  801175:	89 df                	mov    %ebx,%edi
  801177:	89 de                	mov    %ebx,%esi
  801179:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80117b:	85 c0                	test   %eax,%eax
  80117d:	7e 28                	jle    8011a7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80117f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801183:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80118a:	00 
  80118b:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  801192:	00 
  801193:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80119a:	00 
  80119b:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  8011a2:	e8 c1 f2 ff ff       	call   800468 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011a7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011aa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ad:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b0:	89 ec                	mov    %ebp,%esp
  8011b2:	5d                   	pop    %ebp
  8011b3:	c3                   	ret    

008011b4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 38             	sub    $0x38,%esp
  8011ba:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011bd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011c0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8011cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d3:	89 df                	mov    %ebx,%edi
  8011d5:	89 de                	mov    %ebx,%esi
  8011d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	7e 28                	jle    801205 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  8011f0:	00 
  8011f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f8:	00 
  8011f9:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  801200:	e8 63 f2 ff ff       	call   800468 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801205:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801208:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80120b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80120e:	89 ec                	mov    %ebp,%esp
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    

00801212 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 38             	sub    $0x38,%esp
  801218:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80121b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80121e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
  801226:	b8 06 00 00 00       	mov    $0x6,%eax
  80122b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122e:	8b 55 08             	mov    0x8(%ebp),%edx
  801231:	89 df                	mov    %ebx,%edi
  801233:	89 de                	mov    %ebx,%esi
  801235:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7e 28                	jle    801263 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80123b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80123f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801246:	00 
  801247:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  80124e:	00 
  80124f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801256:	00 
  801257:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  80125e:	e8 05 f2 ff ff       	call   800468 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801263:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801266:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801269:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80126c:	89 ec                	mov    %ebp,%esp
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    

00801270 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	83 ec 38             	sub    $0x38,%esp
  801276:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801279:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80127c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80127f:	b8 05 00 00 00       	mov    $0x5,%eax
  801284:	8b 75 18             	mov    0x18(%ebp),%esi
  801287:	8b 7d 14             	mov    0x14(%ebp),%edi
  80128a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80128d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801290:	8b 55 08             	mov    0x8(%ebp),%edx
  801293:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801295:	85 c0                	test   %eax,%eax
  801297:	7e 28                	jle    8012c1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801299:	89 44 24 10          	mov    %eax,0x10(%esp)
  80129d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  8012ac:	00 
  8012ad:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012b4:	00 
  8012b5:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  8012bc:	e8 a7 f1 ff ff       	call   800468 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012ca:	89 ec                	mov    %ebp,%esp
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 38             	sub    $0x38,%esp
  8012d4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012d7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012da:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dd:	be 00 00 00 00       	mov    $0x0,%esi
  8012e2:	b8 04 00 00 00       	mov    $0x4,%eax
  8012e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f0:	89 f7                	mov    %esi,%edi
  8012f2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	7e 28                	jle    801320 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012fc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801303:	00 
  801304:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  80130b:	00 
  80130c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801313:	00 
  801314:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  80131b:	e8 48 f1 ff ff       	call   800468 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801320:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801323:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801326:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801329:	89 ec                	mov    %ebp,%esp
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 0c             	sub    $0xc,%esp
  801333:	89 1c 24             	mov    %ebx,(%esp)
  801336:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133e:	ba 00 00 00 00       	mov    $0x0,%edx
  801343:	b8 0b 00 00 00       	mov    $0xb,%eax
  801348:	89 d1                	mov    %edx,%ecx
  80134a:	89 d3                	mov    %edx,%ebx
  80134c:	89 d7                	mov    %edx,%edi
  80134e:	89 d6                	mov    %edx,%esi
  801350:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801352:	8b 1c 24             	mov    (%esp),%ebx
  801355:	8b 74 24 04          	mov    0x4(%esp),%esi
  801359:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80135d:	89 ec                	mov    %ebp,%esp
  80135f:	5d                   	pop    %ebp
  801360:	c3                   	ret    

00801361 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 0c             	sub    $0xc,%esp
  801367:	89 1c 24             	mov    %ebx,(%esp)
  80136a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80136e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	b8 02 00 00 00       	mov    $0x2,%eax
  80137c:	89 d1                	mov    %edx,%ecx
  80137e:	89 d3                	mov    %edx,%ebx
  801380:	89 d7                	mov    %edx,%edi
  801382:	89 d6                	mov    %edx,%esi
  801384:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801386:	8b 1c 24             	mov    (%esp),%ebx
  801389:	8b 74 24 04          	mov    0x4(%esp),%esi
  80138d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801391:	89 ec                	mov    %ebp,%esp
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 38             	sub    $0x38,%esp
  80139b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80139e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8013ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b1:	89 cb                	mov    %ecx,%ebx
  8013b3:	89 cf                	mov    %ecx,%edi
  8013b5:	89 ce                	mov    %ecx,%esi
  8013b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	7e 28                	jle    8013e5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013c8:	00 
  8013c9:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  8013d0:	00 
  8013d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013d8:	00 
  8013d9:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  8013e0:	e8 83 f0 ff ff       	call   800468 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013e8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013ee:	89 ec                	mov    %ebp,%esp
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    
	...

008013f4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ff:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	89 04 24             	mov    %eax,(%esp)
  801410:	e8 df ff ff ff       	call   8013f4 <fd2num>
  801415:	05 20 00 0d 00       	add    $0xd0020,%eax
  80141a:	c1 e0 0c             	shl    $0xc,%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
  801425:	8b 7d 08             	mov    0x8(%ebp),%edi
  801428:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801432:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801437:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801439:	89 c2                	mov    %eax,%edx
  80143b:	c1 ea 16             	shr    $0x16,%edx
  80143e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801441:	f6 c2 01             	test   $0x1,%dl
  801444:	74 0d                	je     801453 <fd_alloc+0x34>
  801446:	89 c2                	mov    %eax,%edx
  801448:	c1 ea 0c             	shr    $0xc,%edx
  80144b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  80144e:	f6 c2 01             	test   $0x1,%dl
  801451:	75 09                	jne    80145c <fd_alloc+0x3d>
			*fd_store = fd;
  801453:	89 37                	mov    %esi,(%edi)
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80145a:	eb 17                	jmp    801473 <fd_alloc+0x54>
  80145c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801461:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801466:	75 cf                	jne    801437 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801468:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  80146e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801473:	5b                   	pop    %ebx
  801474:	5e                   	pop    %esi
  801475:	5f                   	pop    %edi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    

00801478 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	83 f8 1f             	cmp    $0x1f,%eax
  801481:	77 36                	ja     8014b9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801483:	05 00 00 0d 00       	add    $0xd0000,%eax
  801488:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80148b:	89 c2                	mov    %eax,%edx
  80148d:	c1 ea 16             	shr    $0x16,%edx
  801490:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801497:	f6 c2 01             	test   $0x1,%dl
  80149a:	74 1d                	je     8014b9 <fd_lookup+0x41>
  80149c:	89 c2                	mov    %eax,%edx
  80149e:	c1 ea 0c             	shr    $0xc,%edx
  8014a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a8:	f6 c2 01             	test   $0x1,%dl
  8014ab:	74 0c                	je     8014b9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b0:	89 02                	mov    %eax,(%edx)
  8014b2:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8014b7:	eb 05                	jmp    8014be <fd_lookup+0x46>
  8014b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	89 04 24             	mov    %eax,(%esp)
  8014d3:	e8 a0 ff ff ff       	call   801478 <fd_lookup>
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 0e                	js     8014ea <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e2:	89 50 04             	mov    %edx,0x4(%eax)
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	56                   	push   %esi
  8014f0:	53                   	push   %ebx
  8014f1:	83 ec 10             	sub    $0x10,%esp
  8014f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014fa:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014ff:	be 10 36 80 00       	mov    $0x803610,%esi
  801504:	eb 10                	jmp    801516 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801506:	39 08                	cmp    %ecx,(%eax)
  801508:	75 09                	jne    801513 <dev_lookup+0x27>
			*dev = devtab[i];
  80150a:	89 03                	mov    %eax,(%ebx)
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801511:	eb 31                	jmp    801544 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801513:	83 c2 01             	add    $0x1,%edx
  801516:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801519:	85 c0                	test   %eax,%eax
  80151b:	75 e9                	jne    801506 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80151d:	a1 90 77 80 00       	mov    0x807790,%eax
  801522:	8b 40 48             	mov    0x48(%eax),%eax
  801525:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152d:	c7 04 24 94 35 80 00 	movl   $0x803594,(%esp)
  801534:	e8 e8 ef ff ff       	call   800521 <cprintf>
	*dev = 0;
  801539:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80153f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    

0080154b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	53                   	push   %ebx
  80154f:	83 ec 24             	sub    $0x24,%esp
  801552:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801555:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	89 04 24             	mov    %eax,(%esp)
  801562:	e8 11 ff ff ff       	call   801478 <fd_lookup>
  801567:	85 c0                	test   %eax,%eax
  801569:	78 53                	js     8015be <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	8b 00                	mov    (%eax),%eax
  801577:	89 04 24             	mov    %eax,(%esp)
  80157a:	e8 6d ff ff ff       	call   8014ec <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 3b                	js     8015be <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801583:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80158f:	74 2d                	je     8015be <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801591:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801594:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80159b:	00 00 00 
	stat->st_isdir = 0;
  80159e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a5:	00 00 00 
	stat->st_dev = dev;
  8015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ab:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b8:	89 14 24             	mov    %edx,(%esp)
  8015bb:	ff 50 14             	call   *0x14(%eax)
}
  8015be:	83 c4 24             	add    $0x24,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 24             	sub    $0x24,%esp
  8015cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d5:	89 1c 24             	mov    %ebx,(%esp)
  8015d8:	e8 9b fe ff ff       	call   801478 <fd_lookup>
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 5f                	js     801640 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	89 04 24             	mov    %eax,(%esp)
  8015f0:	e8 f7 fe ff ff       	call   8014ec <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 47                	js     801640 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fc:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801600:	75 23                	jne    801625 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801602:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801607:	8b 40 48             	mov    0x48(%eax),%eax
  80160a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80160e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801612:	c7 04 24 b4 35 80 00 	movl   $0x8035b4,(%esp)
  801619:	e8 03 ef ff ff       	call   800521 <cprintf>
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801623:	eb 1b                	jmp    801640 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801628:	8b 48 18             	mov    0x18(%eax),%ecx
  80162b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801630:	85 c9                	test   %ecx,%ecx
  801632:	74 0c                	je     801640 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163b:	89 14 24             	mov    %edx,(%esp)
  80163e:	ff d1                	call   *%ecx
}
  801640:	83 c4 24             	add    $0x24,%esp
  801643:	5b                   	pop    %ebx
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    

00801646 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	53                   	push   %ebx
  80164a:	83 ec 24             	sub    $0x24,%esp
  80164d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801650:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801653:	89 44 24 04          	mov    %eax,0x4(%esp)
  801657:	89 1c 24             	mov    %ebx,(%esp)
  80165a:	e8 19 fe ff ff       	call   801478 <fd_lookup>
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 66                	js     8016c9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801663:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801666:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	8b 00                	mov    (%eax),%eax
  80166f:	89 04 24             	mov    %eax,(%esp)
  801672:	e8 75 fe ff ff       	call   8014ec <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801677:	85 c0                	test   %eax,%eax
  801679:	78 4e                	js     8016c9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80167b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801682:	75 23                	jne    8016a7 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801684:	a1 90 77 80 00       	mov    0x807790,%eax
  801689:	8b 40 48             	mov    0x48(%eax),%eax
  80168c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801690:	89 44 24 04          	mov    %eax,0x4(%esp)
  801694:	c7 04 24 d5 35 80 00 	movl   $0x8035d5,(%esp)
  80169b:	e8 81 ee ff ff       	call   800521 <cprintf>
  8016a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8016a5:	eb 22                	jmp    8016c9 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	8b 48 0c             	mov    0xc(%eax),%ecx
  8016ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b2:	85 c9                	test   %ecx,%ecx
  8016b4:	74 13                	je     8016c9 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c4:	89 14 24             	mov    %edx,(%esp)
  8016c7:	ff d1                	call   *%ecx
}
  8016c9:	83 c4 24             	add    $0x24,%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 24             	sub    $0x24,%esp
  8016d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e0:	89 1c 24             	mov    %ebx,(%esp)
  8016e3:	e8 90 fd ff ff       	call   801478 <fd_lookup>
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	78 6b                	js     801757 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	8b 00                	mov    (%eax),%eax
  8016f8:	89 04 24             	mov    %eax,(%esp)
  8016fb:	e8 ec fd ff ff       	call   8014ec <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801700:	85 c0                	test   %eax,%eax
  801702:	78 53                	js     801757 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801704:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801707:	8b 42 08             	mov    0x8(%edx),%eax
  80170a:	83 e0 03             	and    $0x3,%eax
  80170d:	83 f8 01             	cmp    $0x1,%eax
  801710:	75 23                	jne    801735 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801712:	a1 90 77 80 00       	mov    0x807790,%eax
  801717:	8b 40 48             	mov    0x48(%eax),%eax
  80171a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80171e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801722:	c7 04 24 f2 35 80 00 	movl   $0x8035f2,(%esp)
  801729:	e8 f3 ed ff ff       	call   800521 <cprintf>
  80172e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801733:	eb 22                	jmp    801757 <read+0x88>
	}
	if (!dev->dev_read)
  801735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801738:	8b 48 08             	mov    0x8(%eax),%ecx
  80173b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801740:	85 c9                	test   %ecx,%ecx
  801742:	74 13                	je     801757 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801752:	89 14 24             	mov    %edx,(%esp)
  801755:	ff d1                	call   *%ecx
}
  801757:	83 c4 24             	add    $0x24,%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	57                   	push   %edi
  801761:	56                   	push   %esi
  801762:	53                   	push   %ebx
  801763:	83 ec 1c             	sub    $0x1c,%esp
  801766:	8b 7d 08             	mov    0x8(%ebp),%edi
  801769:	8b 75 10             	mov    0x10(%ebp),%esi
  80176c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801771:	eb 21                	jmp    801794 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801773:	89 f2                	mov    %esi,%edx
  801775:	29 c2                	sub    %eax,%edx
  801777:	89 54 24 08          	mov    %edx,0x8(%esp)
  80177b:	03 45 0c             	add    0xc(%ebp),%eax
  80177e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801782:	89 3c 24             	mov    %edi,(%esp)
  801785:	e8 45 ff ff ff       	call   8016cf <read>
		if (m < 0)
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 0e                	js     80179c <readn+0x3f>
			return m;
		if (m == 0)
  80178e:	85 c0                	test   %eax,%eax
  801790:	74 08                	je     80179a <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801792:	01 c3                	add    %eax,%ebx
  801794:	89 d8                	mov    %ebx,%eax
  801796:	39 f3                	cmp    %esi,%ebx
  801798:	72 d9                	jb     801773 <readn+0x16>
  80179a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80179c:	83 c4 1c             	add    $0x1c,%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 38             	sub    $0x38,%esp
  8017aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017b6:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017ba:	89 3c 24             	mov    %edi,(%esp)
  8017bd:	e8 32 fc ff ff       	call   8013f4 <fd2num>
  8017c2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8017c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017c9:	89 04 24             	mov    %eax,(%esp)
  8017cc:	e8 a7 fc ff ff       	call   801478 <fd_lookup>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 05                	js     8017dc <fd_close+0x38>
  8017d7:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8017da:	74 0e                	je     8017ea <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8017dc:	89 f0                	mov    %esi,%eax
  8017de:	84 c0                	test   %al,%al
  8017e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e5:	0f 44 d8             	cmove  %eax,%ebx
  8017e8:	eb 3d                	jmp    801827 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f1:	8b 07                	mov    (%edi),%eax
  8017f3:	89 04 24             	mov    %eax,(%esp)
  8017f6:	e8 f1 fc ff ff       	call   8014ec <dev_lookup>
  8017fb:	89 c3                	mov    %eax,%ebx
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 16                	js     801817 <fd_close+0x73>
		if (dev->dev_close)
  801801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801804:	8b 40 10             	mov    0x10(%eax),%eax
  801807:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180c:	85 c0                	test   %eax,%eax
  80180e:	74 07                	je     801817 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801810:	89 3c 24             	mov    %edi,(%esp)
  801813:	ff d0                	call   *%eax
  801815:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801817:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80181b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801822:	e8 eb f9 ff ff       	call   801212 <sys_page_unmap>
	return r;
}
  801827:	89 d8                	mov    %ebx,%eax
  801829:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80182c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80182f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801832:	89 ec                	mov    %ebp,%esp
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	89 04 24             	mov    %eax,(%esp)
  801849:	e8 2a fc ff ff       	call   801478 <fd_lookup>
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 13                	js     801865 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801852:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801859:	00 
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	89 04 24             	mov    %eax,(%esp)
  801860:	e8 3f ff ff ff       	call   8017a4 <fd_close>
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 18             	sub    $0x18,%esp
  80186d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801870:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801873:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80187a:	00 
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 25 04 00 00       	call   801cab <open>
  801886:	89 c3                	mov    %eax,%ebx
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 1b                	js     8018a7 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80188c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801893:	89 1c 24             	mov    %ebx,(%esp)
  801896:	e8 b0 fc ff ff       	call   80154b <fstat>
  80189b:	89 c6                	mov    %eax,%esi
	close(fd);
  80189d:	89 1c 24             	mov    %ebx,(%esp)
  8018a0:	e8 91 ff ff ff       	call   801836 <close>
  8018a5:	89 f3                	mov    %esi,%ebx
	return r;
}
  8018a7:	89 d8                	mov    %ebx,%eax
  8018a9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018ac:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018af:	89 ec                	mov    %ebp,%esp
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 14             	sub    $0x14,%esp
  8018ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8018bf:	89 1c 24             	mov    %ebx,(%esp)
  8018c2:	e8 6f ff ff ff       	call   801836 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8018c7:	83 c3 01             	add    $0x1,%ebx
  8018ca:	83 fb 20             	cmp    $0x20,%ebx
  8018cd:	75 f0                	jne    8018bf <close_all+0xc>
		close(i);
}
  8018cf:	83 c4 14             	add    $0x14,%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 58             	sub    $0x58,%esp
  8018db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8018e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	89 04 24             	mov    %eax,(%esp)
  8018f4:	e8 7f fb ff ff       	call   801478 <fd_lookup>
  8018f9:	89 c3                	mov    %eax,%ebx
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	0f 88 e0 00 00 00    	js     8019e3 <dup+0x10e>
		return r;
	close(newfdnum);
  801903:	89 3c 24             	mov    %edi,(%esp)
  801906:	e8 2b ff ff ff       	call   801836 <close>

	newfd = INDEX2FD(newfdnum);
  80190b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801911:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801917:	89 04 24             	mov    %eax,(%esp)
  80191a:	e8 e5 fa ff ff       	call   801404 <fd2data>
  80191f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801921:	89 34 24             	mov    %esi,(%esp)
  801924:	e8 db fa ff ff       	call   801404 <fd2data>
  801929:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80192c:	89 da                	mov    %ebx,%edx
  80192e:	89 d8                	mov    %ebx,%eax
  801930:	c1 e8 16             	shr    $0x16,%eax
  801933:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80193a:	a8 01                	test   $0x1,%al
  80193c:	74 43                	je     801981 <dup+0xac>
  80193e:	c1 ea 0c             	shr    $0xc,%edx
  801941:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801948:	a8 01                	test   $0x1,%al
  80194a:	74 35                	je     801981 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80194c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801953:	25 07 0e 00 00       	and    $0xe07,%eax
  801958:	89 44 24 10          	mov    %eax,0x10(%esp)
  80195c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80195f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801963:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80196a:	00 
  80196b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80196f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801976:	e8 f5 f8 ff ff       	call   801270 <sys_page_map>
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 3f                	js     8019c0 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801984:	89 c2                	mov    %eax,%edx
  801986:	c1 ea 0c             	shr    $0xc,%edx
  801989:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801990:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801996:	89 54 24 10          	mov    %edx,0x10(%esp)
  80199a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80199e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019a5:	00 
  8019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b1:	e8 ba f8 ff ff       	call   801270 <sys_page_map>
  8019b6:	89 c3                	mov    %eax,%ebx
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 04                	js     8019c0 <dup+0xeb>
  8019bc:	89 fb                	mov    %edi,%ebx
  8019be:	eb 23                	jmp    8019e3 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cb:	e8 42 f8 ff ff       	call   801212 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019de:	e8 2f f8 ff ff       	call   801212 <sys_page_unmap>
	return r;
}
  8019e3:	89 d8                	mov    %ebx,%eax
  8019e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019e8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019ee:	89 ec                	mov    %ebp,%esp
  8019f0:	5d                   	pop    %ebp
  8019f1:	c3                   	ret    
	...

008019f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	56                   	push   %esi
  8019f8:	53                   	push   %ebx
  8019f9:	83 ec 10             	sub    $0x10,%esp
  8019fc:	89 c3                	mov    %eax,%ebx
  8019fe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a00:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801a07:	75 11                	jne    801a1a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a10:	e8 e3 12 00 00       	call   802cf8 <ipc_find_env>
  801a15:	a3 00 60 80 00       	mov    %eax,0x806000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801a1a:	a1 90 77 80 00       	mov    0x807790,%eax
  801a1f:	8b 40 48             	mov    0x48(%eax),%eax
  801a22:	8b 15 00 80 80 00    	mov    0x808000,%edx
  801a28:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a34:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  801a3b:	e8 e1 ea ff ff       	call   800521 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a40:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a47:	00 
  801a48:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801a4f:	00 
  801a50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a54:	a1 00 60 80 00       	mov    0x806000,%eax
  801a59:	89 04 24             	mov    %eax,(%esp)
  801a5c:	e8 cd 12 00 00       	call   802d2e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a68:	00 
  801a69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a6d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a74:	e8 21 13 00 00       	call   802d9a <ipc_recv>
}
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8c:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a99:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa3:	e8 4c ff ff ff       	call   8019f4 <fsipc>
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab6:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801abb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac0:	b8 06 00 00 00       	mov    $0x6,%eax
  801ac5:	e8 2a ff ff ff       	call   8019f4 <fsipc>
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad7:	b8 08 00 00 00       	mov    $0x8,%eax
  801adc:	e8 13 ff ff ff       	call   8019f4 <fsipc>
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 14             	sub    $0x14,%esp
  801aea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	8b 40 0c             	mov    0xc(%eax),%eax
  801af3:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801af8:	ba 00 00 00 00       	mov    $0x0,%edx
  801afd:	b8 05 00 00 00       	mov    $0x5,%eax
  801b02:	e8 ed fe ff ff       	call   8019f4 <fsipc>
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 2b                	js     801b36 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b0b:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801b12:	00 
  801b13:	89 1c 24             	mov    %ebx,(%esp)
  801b16:	e8 6e f0 ff ff       	call   800b89 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b1b:	a1 80 80 80 00       	mov    0x808080,%eax
  801b20:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b26:	a1 84 80 80 00       	mov    0x808084,%eax
  801b2b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801b36:	83 c4 14             	add    $0x14,%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 14             	sub    $0x14,%esp
  801b43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4c:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n;
  801b51:	89 1d 04 80 80 00    	mov    %ebx,0x808004

	assert(n<=PGSIZE);
  801b57:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801b5d:	76 24                	jbe    801b83 <devfile_write+0x47>
  801b5f:	c7 44 24 0c 3a 36 80 	movl   $0x80363a,0xc(%esp)
  801b66:	00 
  801b67:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  801b6e:	00 
  801b6f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801b76:	00 
  801b77:	c7 04 24 59 36 80 00 	movl   $0x803659,(%esp)
  801b7e:	e8 e5 e8 ff ff       	call   800468 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801b83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8e:	c7 04 24 08 80 80 00 	movl   $0x808008,(%esp)
  801b95:	e8 95 f1 ff ff       	call   800d2f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9f:	b8 04 00 00 00       	mov    $0x4,%eax
  801ba4:	e8 4b fe ff ff       	call   8019f4 <fsipc>
	if(ret<0) return ret;
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	78 53                	js     801c00 <devfile_write+0xc4>
	
	assert(ret <= n);
  801bad:	39 c3                	cmp    %eax,%ebx
  801baf:	73 24                	jae    801bd5 <devfile_write+0x99>
  801bb1:	c7 44 24 0c 64 36 80 	movl   $0x803664,0xc(%esp)
  801bb8:	00 
  801bb9:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  801bc0:	00 
  801bc1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801bc8:	00 
  801bc9:	c7 04 24 59 36 80 00 	movl   $0x803659,(%esp)
  801bd0:	e8 93 e8 ff ff       	call   800468 <_panic>
	assert(ret <= PGSIZE);
  801bd5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bda:	7e 24                	jle    801c00 <devfile_write+0xc4>
  801bdc:	c7 44 24 0c 6d 36 80 	movl   $0x80366d,0xc(%esp)
  801be3:	00 
  801be4:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  801beb:	00 
  801bec:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801bf3:	00 
  801bf4:	c7 04 24 59 36 80 00 	movl   $0x803659,(%esp)
  801bfb:	e8 68 e8 ff ff       	call   800468 <_panic>
	return ret;
}
  801c00:	83 c4 14             	add    $0x14,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    

00801c06 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	56                   	push   %esi
  801c0a:	53                   	push   %ebx
  801c0b:	83 ec 10             	sub    $0x10,%esp
  801c0e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	8b 40 0c             	mov    0xc(%eax),%eax
  801c17:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801c1c:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c22:	ba 00 00 00 00       	mov    $0x0,%edx
  801c27:	b8 03 00 00 00       	mov    $0x3,%eax
  801c2c:	e8 c3 fd ff ff       	call   8019f4 <fsipc>
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 6b                	js     801ca2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801c37:	39 de                	cmp    %ebx,%esi
  801c39:	73 24                	jae    801c5f <devfile_read+0x59>
  801c3b:	c7 44 24 0c 7b 36 80 	movl   $0x80367b,0xc(%esp)
  801c42:	00 
  801c43:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  801c4a:	00 
  801c4b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c52:	00 
  801c53:	c7 04 24 59 36 80 00 	movl   $0x803659,(%esp)
  801c5a:	e8 09 e8 ff ff       	call   800468 <_panic>
	assert(r <= PGSIZE);
  801c5f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801c65:	7e 24                	jle    801c8b <devfile_read+0x85>
  801c67:	c7 44 24 0c 82 36 80 	movl   $0x803682,0xc(%esp)
  801c6e:	00 
  801c6f:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  801c76:	00 
  801c77:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c7e:	00 
  801c7f:	c7 04 24 59 36 80 00 	movl   $0x803659,(%esp)
  801c86:	e8 dd e7 ff ff       	call   800468 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c8f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801c96:	00 
  801c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9a:	89 04 24             	mov    %eax,(%esp)
  801c9d:	e8 8d f0 ff ff       	call   800d2f <memmove>
	return r;
}
  801ca2:	89 d8                	mov    %ebx,%eax
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    

00801cab <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 28             	sub    $0x28,%esp
  801cb1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cb4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801cb7:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cba:	89 34 24             	mov    %esi,(%esp)
  801cbd:	e8 8e ee ff ff       	call   800b50 <strlen>
  801cc2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cc7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ccc:	7f 5e                	jg     801d2c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 46 f7 ff ff       	call   80141f <fd_alloc>
  801cd9:	89 c3                	mov    %eax,%ebx
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 4d                	js     801d2c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cdf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ce3:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801cea:	e8 9a ee ff ff       	call   800b89 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf2:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	e8 f0 fc ff ff       	call   8019f4 <fsipc>
  801d04:	89 c3                	mov    %eax,%ebx
  801d06:	85 c0                	test   %eax,%eax
  801d08:	79 15                	jns    801d1f <open+0x74>
		fd_close(fd, 0);
  801d0a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d11:	00 
  801d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d15:	89 04 24             	mov    %eax,(%esp)
  801d18:	e8 87 fa ff ff       	call   8017a4 <fd_close>
		return r;
  801d1d:	eb 0d                	jmp    801d2c <open+0x81>
	}

	return fd2num(fd);
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 ca f6 ff ff       	call   8013f4 <fd2num>
  801d2a:	89 c3                	mov    %eax,%ebx
}
  801d2c:	89 d8                	mov    %ebx,%eax
  801d2e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d31:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d34:	89 ec                	mov    %ebp,%esp
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    

00801d38 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	57                   	push   %edi
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d4b:	00 
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 54 ff ff ff       	call   801cab <open>
  801d57:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	0f 88 f7 05 00 00    	js     80235c <spawn+0x624>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801d65:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801d6c:	00 
  801d6d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d77:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801d7d:	89 14 24             	mov    %edx,(%esp)
  801d80:	e8 d8 f9 ff ff       	call   80175d <readn>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801d85:	3d 00 02 00 00       	cmp    $0x200,%eax
  801d8a:	75 0c                	jne    801d98 <spawn+0x60>
  801d8c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801d93:	45 4c 46 
  801d96:	74 3b                	je     801dd3 <spawn+0x9b>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  801d98:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801d9e:	89 04 24             	mov    %eax,(%esp)
  801da1:	e8 90 fa ff ff       	call   801836 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801da6:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801dad:	46 
  801dae:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	c7 04 24 8e 36 80 00 	movl   $0x80368e,(%esp)
  801dbf:	e8 5d e7 ff ff       	call   800521 <cprintf>
  801dc4:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  801dcb:	ff ff ff 
		return -E_NOT_EXEC;
  801dce:	e9 89 05 00 00       	jmp    80235c <spawn+0x624>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dd3:	ba 07 00 00 00       	mov    $0x7,%edx
  801dd8:	89 d0                	mov    %edx,%eax
  801dda:	cd 30                	int    $0x30
  801ddc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801de2:	85 c0                	test   %eax,%eax
  801de4:	0f 88 66 05 00 00    	js     802350 <spawn+0x618>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801dea:	89 c6                	mov    %eax,%esi
  801dec:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801df2:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801df5:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801dfb:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e01:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e08:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e0e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e19:	be 00 00 00 00       	mov    $0x0,%esi
  801e1e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e21:	eb 0f                	jmp    801e32 <spawn+0xfa>

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801e23:	89 04 24             	mov    %eax,(%esp)
  801e26:	e8 25 ed ff ff       	call   800b50 <strlen>
  801e2b:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e2f:	83 c3 01             	add    $0x1,%ebx
  801e32:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  801e39:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	75 e3                	jne    801e23 <spawn+0xeb>
  801e40:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801e46:	89 9d 7c fd ff ff    	mov    %ebx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e4c:	f7 de                	neg    %esi
  801e4e:	81 c6 00 10 40 00    	add    $0x401000,%esi
  801e54:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e5a:	89 f2                	mov    %esi,%edx
  801e5c:	83 e2 fc             	and    $0xfffffffc,%edx
  801e5f:	89 d8                	mov    %ebx,%eax
  801e61:	f7 d0                	not    %eax
  801e63:	8d 3c 82             	lea    (%edx,%eax,4),%edi

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e66:	8d 57 f8             	lea    -0x8(%edi),%edx
  801e69:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801e6f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e74:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
  801e7a:	0f 86 ed 04 00 00    	jbe    80236d <spawn+0x635>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e80:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e87:	00 
  801e88:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e8f:	00 
  801e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e97:	e8 32 f4 ff ff       	call   8012ce <sys_page_alloc>
  801e9c:	be 00 00 00 00       	mov    $0x0,%esi
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	79 4c                	jns    801ef1 <spawn+0x1b9>
  801ea5:	e9 c3 04 00 00       	jmp    80236d <spawn+0x635>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801eaa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801eb0:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801eb5:	89 04 b7             	mov    %eax,(%edi,%esi,4)
		strcpy(string_store, argv[i]);
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  801ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec2:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ec8:	89 04 24             	mov    %eax,(%esp)
  801ecb:	e8 b9 ec ff ff       	call   800b89 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  801ed6:	89 04 24             	mov    %eax,(%esp)
  801ed9:	e8 72 ec ff ff       	call   800b50 <strlen>
  801ede:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801ee4:	8d 54 02 01          	lea    0x1(%edx,%eax,1),%edx
  801ee8:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801eee:	83 c6 01             	add    $0x1,%esi
  801ef1:	39 de                	cmp    %ebx,%esi
  801ef3:	7c b5                	jl     801eaa <spawn+0x172>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801ef5:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801efb:	c7 04 07 00 00 00 00 	movl   $0x0,(%edi,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f02:	81 bd 94 fd ff ff 00 	cmpl   $0x401000,-0x26c(%ebp)
  801f09:	10 40 00 
  801f0c:	74 24                	je     801f32 <spawn+0x1fa>
  801f0e:	c7 44 24 0c 30 37 80 	movl   $0x803730,0xc(%esp)
  801f15:	00 
  801f16:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  801f1d:	00 
  801f1e:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  801f25:	00 
  801f26:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  801f2d:	e8 36 e5 ff ff       	call   800468 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f32:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f38:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801f3b:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801f41:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801f47:	89 02                	mov    %eax,(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f49:	81 ef 08 30 80 11    	sub    $0x11803008,%edi
  801f4f:	89 bd e0 fd ff ff    	mov    %edi,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f55:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801f5c:	00 
  801f5d:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801f64:	ee 
  801f65:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801f6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f6f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f76:	00 
  801f77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7e:	e8 ed f2 ff ff       	call   801270 <sys_page_map>
  801f83:	89 c3                	mov    %eax,%ebx
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 1a                	js     801fa3 <spawn+0x26b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f89:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f90:	00 
  801f91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f98:	e8 75 f2 ff ff       	call   801212 <sys_page_unmap>
  801f9d:	89 c3                	mov    %eax,%ebx
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	79 1f                	jns    801fc2 <spawn+0x28a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801fa3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801faa:	00 
  801fab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb2:	e8 5b f2 ff ff       	call   801212 <sys_page_unmap>
  801fb7:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801fbd:	e9 9a 03 00 00       	jmp    80235c <spawn+0x624>

	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fc2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801fc8:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  801fce:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  801fd4:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801fdb:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fde:	e9 c1 01 00 00       	jmp    8021a4 <spawn+0x46c>
		if (ph->p_type != ELF_PROG_LOAD)
  801fe3:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801fe9:	83 38 01             	cmpl   $0x1,(%eax)
  801fec:	0f 85 a4 01 00 00    	jne    802196 <spawn+0x45e>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ff2:	89 c2                	mov    %eax,%edx
  801ff4:	8b 40 18             	mov    0x18(%eax),%eax
  801ff7:	83 e0 02             	and    $0x2,%eax
  801ffa:	83 f8 01             	cmp    $0x1,%eax
  801ffd:	19 c0                	sbb    %eax,%eax
  801fff:	83 e0 fe             	and    $0xfffffffe,%eax
  802002:	83 c0 07             	add    $0x7,%eax
  802005:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80200b:	8b 52 04             	mov    0x4(%edx),%edx
  80200e:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802014:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80201a:	8b 40 10             	mov    0x10(%eax),%eax
  80201d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802023:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802029:	8b 52 14             	mov    0x14(%edx),%edx
  80202c:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
  802032:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802038:	8b 58 08             	mov    0x8(%eax),%ebx
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802042:	74 16                	je     80205a <spawn+0x322>
		va -= i;
  802044:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802046:	01 c2                	add    %eax,%edx
  802048:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		filesz += i;
  80204e:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802054:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
  80205a:	be 00 00 00 00       	mov    $0x0,%esi
  80205f:	89 df                	mov    %ebx,%edi
  802061:	e9 22 01 00 00       	jmp    802188 <spawn+0x450>
	}

	for (i = 0; i < memsz; i += PGSIZE) {
		if (i >= filesz) {
  802066:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  80206c:	77 2b                	ja     802099 <spawn+0x361>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80206e:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802074:	89 54 24 08          	mov    %edx,0x8(%esp)
  802078:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80207c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802082:	89 04 24             	mov    %eax,(%esp)
  802085:	e8 44 f2 ff ff       	call   8012ce <sys_page_alloc>
  80208a:	85 c0                	test   %eax,%eax
  80208c:	0f 89 ea 00 00 00    	jns    80217c <spawn+0x444>
  802092:	89 c3                	mov    %eax,%ebx
  802094:	e9 93 02 00 00       	jmp    80232c <spawn+0x5f4>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802099:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020a0:	00 
  8020a1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020a8:	00 
  8020a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b0:	e8 19 f2 ff ff       	call   8012ce <sys_page_alloc>
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	0f 88 65 02 00 00    	js     802322 <spawn+0x5ea>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8020bd:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  8020c3:	01 d8                	add    %ebx,%eax
  8020c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c9:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8020cf:	89 14 24             	mov    %edx,(%esp)
  8020d2:	e8 e9 f3 ff ff       	call   8014c0 <seek>
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	0f 88 47 02 00 00    	js     802326 <spawn+0x5ee>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8020df:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8020e5:	29 d8                	sub    %ebx,%eax
  8020e7:	89 c3                	mov    %eax,%ebx
  8020e9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020f3:	0f 47 da             	cmova  %edx,%ebx
  8020f6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020fa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802101:	00 
  802102:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802108:	89 04 24             	mov    %eax,(%esp)
  80210b:	e8 4d f6 ff ff       	call   80175d <readn>
  802110:	85 c0                	test   %eax,%eax
  802112:	0f 88 12 02 00 00    	js     80232a <spawn+0x5f2>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802118:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  80211e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802122:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802126:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80212c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802130:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802137:	00 
  802138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213f:	e8 2c f1 ff ff       	call   801270 <sys_page_map>
  802144:	85 c0                	test   %eax,%eax
  802146:	79 20                	jns    802168 <spawn+0x430>
				panic("spawn: sys_page_map data: %e", r);
  802148:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80214c:	c7 44 24 08 b4 36 80 	movl   $0x8036b4,0x8(%esp)
  802153:	00 
  802154:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  80215b:	00 
  80215c:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  802163:	e8 00 e3 ff ff       	call   800468 <_panic>
			sys_page_unmap(0, UTEMP);
  802168:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80216f:	00 
  802170:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802177:	e8 96 f0 ff ff       	call   801212 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80217c:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802182:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802188:	89 f3                	mov    %esi,%ebx
  80218a:	39 b5 84 fd ff ff    	cmp    %esi,-0x27c(%ebp)
  802190:	0f 87 d0 fe ff ff    	ja     802066 <spawn+0x32e>
	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802196:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80219d:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  8021a4:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8021ab:	39 85 7c fd ff ff    	cmp    %eax,-0x284(%ebp)
  8021b1:	0f 8c 2c fe ff ff    	jl     801fe3 <spawn+0x2ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8021b7:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8021bd:	89 14 24             	mov    %edx,(%esp)
  8021c0:	e8 71 f6 ff ff       	call   801836 <close>
	fd = -1;

	cprintf("copy sharing pages\n");
  8021c5:	c7 04 24 eb 36 80 00 	movl   $0x8036eb,(%esp)
  8021cc:	e8 50 e3 ff ff       	call   800521 <cprintf>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
  8021d1:	e8 8b f1 ff ff       	call   801361 <sys_getenvid>
  8021d6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8021dc:	c7 85 8c fd ff ff 00 	movl   $0x0,-0x274(%ebp)
  8021e3:	00 00 00 

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  8021e6:	be 00 00 40 ef       	mov    $0xef400000,%esi
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  8021eb:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8021f1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8021f8:	a8 01                	test   $0x1,%al
  8021fa:	0f 84 89 00 00 00    	je     802289 <spawn+0x551>
  802200:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  802206:	0f 84 69 01 00 00    	je     802375 <spawn+0x63d>
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  80220c:	89 d7                	mov    %edx,%edi
  80220e:	c1 e7 16             	shl    $0x16,%edi
  802211:	bb 00 00 00 00       	mov    $0x0,%ebx
  802216:	89 da                	mov    %ebx,%edx
  802218:	c1 e2 0c             	shl    $0xc,%edx
  80221b:	01 fa                	add    %edi,%edx
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  80221d:	89 d0                	mov    %edx,%eax
  80221f:	c1 e8 0c             	shr    $0xc,%eax
  802222:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
  802225:	f6 c1 01             	test   $0x1,%cl
  802228:	74 54                	je     80227e <spawn+0x546>
  80222a:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80222d:	f6 c4 04             	test   $0x4,%ah
  802230:	74 4c                	je     80227e <spawn+0x546>
				{
					ret = sys_page_map(curr_envid, (void *)addr, child,(void *)addr,PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  802232:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  802239:	00 
  80223a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80223e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802244:	89 44 24 08          	mov    %eax,0x8(%esp)
  802248:	89 54 24 04          	mov    %edx,0x4(%esp)
  80224c:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802252:	89 14 24             	mov    %edx,(%esp)
  802255:	e8 16 f0 ff ff       	call   801270 <sys_page_map>
					if(ret) panic("sys_page_map: %e", ret);
  80225a:	85 c0                	test   %eax,%eax
  80225c:	74 20                	je     80227e <spawn+0x546>
  80225e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802262:	c7 44 24 08 d1 36 80 	movl   $0x8036d1,0x8(%esp)
  802269:	00 
  80226a:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  802271:	00 
  802272:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  802279:	e8 ea e1 ff ff       	call   800468 <_panic>
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
  80227e:	83 c3 01             	add    $0x1,%ebx
  802281:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802287:	75 8d                	jne    802216 <spawn+0x4de>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  802289:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  802290:	81 bd 8c fd ff ff bb 	cmpl   $0x3bb,-0x274(%ebp)
  802297:	03 00 00 
  80229a:	0f 85 4b ff ff ff    	jne    8021eb <spawn+0x4b3>

	cprintf("copy sharing pages\n");
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
	cprintf("complete copy sharing pages\n");	
  8022a0:	c7 04 24 e2 36 80 00 	movl   $0x8036e2,(%esp)
  8022a7:	e8 75 e2 ff ff       	call   800521 <cprintf>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022ac:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8022b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b6:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8022bc:	89 04 24             	mov    %eax,(%esp)
  8022bf:	e8 92 ee ff ff       	call   801156 <sys_env_set_trapframe>
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	79 20                	jns    8022e8 <spawn+0x5b0>
		panic("sys_env_set_trapframe: %e", r);
  8022c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022cc:	c7 44 24 08 ff 36 80 	movl   $0x8036ff,0x8(%esp)
  8022d3:	00 
  8022d4:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8022db:	00 
  8022dc:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  8022e3:	e8 80 e1 ff ff       	call   800468 <_panic>
	
	//thisenv = &envs[ENVX(child)];
	//cprintf("%s %x\n",__func__,thisenv->env_id);
	
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8022e8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8022ef:	00 
  8022f0:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8022f6:	89 14 24             	mov    %edx,(%esp)
  8022f9:	e8 b6 ee ff ff       	call   8011b4 <sys_env_set_status>
  8022fe:	85 c0                	test   %eax,%eax
  802300:	79 4e                	jns    802350 <spawn+0x618>
		panic("sys_env_set_status: %e", r);
  802302:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802306:	c7 44 24 08 19 37 80 	movl   $0x803719,0x8(%esp)
  80230d:	00 
  80230e:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  802315:	00 
  802316:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  80231d:	e8 46 e1 ff ff       	call   800468 <_panic>
  802322:	89 c3                	mov    %eax,%ebx
  802324:	eb 06                	jmp    80232c <spawn+0x5f4>
  802326:	89 c3                	mov    %eax,%ebx
  802328:	eb 02                	jmp    80232c <spawn+0x5f4>
  80232a:	89 c3                	mov    %eax,%ebx
	
	return child;

error:
	sys_env_destroy(child);
  80232c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802332:	89 04 24             	mov    %eax,(%esp)
  802335:	e8 5b f0 ff ff       	call   801395 <sys_env_destroy>
	close(fd);
  80233a:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802340:	89 14 24             	mov    %edx,(%esp)
  802343:	e8 ee f4 ff ff       	call   801836 <close>
  802348:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
	return r;
  80234e:	eb 0c                	jmp    80235c <spawn+0x624>
  802350:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802356:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  80235c:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802362:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802368:	5b                   	pop    %ebx
  802369:	5e                   	pop    %esi
  80236a:	5f                   	pop    %edi
  80236b:	5d                   	pop    %ebp
  80236c:	c3                   	ret    
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  80236d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802373:	eb e7                	jmp    80235c <spawn+0x624>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  802375:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  80237c:	e9 6a fe ff ff       	jmp    8021eb <spawn+0x4b3>

00802381 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	56                   	push   %esi
  802385:	53                   	push   %ebx
  802386:	83 ec 10             	sub    $0x10,%esp

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  802389:	8d 45 10             	lea    0x10(%ebp),%eax
  80238c:	ba 00 00 00 00       	mov    $0x0,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802391:	eb 03                	jmp    802396 <spawnl+0x15>
		argc++;
  802393:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802396:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  80239a:	75 f7                	jne    802393 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80239c:	8d 04 95 26 00 00 00 	lea    0x26(,%edx,4),%eax
  8023a3:	83 e0 f0             	and    $0xfffffff0,%eax
  8023a6:	29 c4                	sub    %eax,%esp
  8023a8:	8d 5c 24 17          	lea    0x17(%esp),%ebx
  8023ac:	83 e3 f0             	and    $0xfffffff0,%ebx
	argv[0] = arg0;
  8023af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b2:	89 03                	mov    %eax,(%ebx)
	argv[argc+1] = NULL;
  8023b4:	c7 44 93 04 00 00 00 	movl   $0x0,0x4(%ebx,%edx,4)
  8023bb:	00 

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8023bc:	8d 75 10             	lea    0x10(%ebp),%esi
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8023c4:	eb 0a                	jmp    8023d0 <spawnl+0x4f>
		argv[i+1] = va_arg(vl, const char *);
  8023c6:	83 c0 01             	add    $0x1,%eax
  8023c9:	8b 4c 86 fc          	mov    -0x4(%esi,%eax,4),%ecx
  8023cd:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8023d0:	39 d0                	cmp    %edx,%eax
  8023d2:	72 f2                	jb     8023c6 <spawnl+0x45>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8023d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	89 04 24             	mov    %eax,(%esp)
  8023de:	e8 55 f9 ff ff       	call   801d38 <spawn>
}
  8023e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e6:	5b                   	pop    %ebx
  8023e7:	5e                   	pop    %esi
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    
  8023ea:	00 00                	add    %al,(%eax)
  8023ec:	00 00                	add    %al,(%eax)
	...

008023f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8023f6:	c7 44 24 04 58 37 80 	movl   $0x803758,0x4(%esp)
  8023fd:	00 
  8023fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802401:	89 04 24             	mov    %eax,(%esp)
  802404:	e8 80 e7 ff ff       	call   800b89 <strcpy>
	return 0;
}
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	53                   	push   %ebx
  802414:	83 ec 14             	sub    $0x14,%esp
  802417:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80241a:	89 1c 24             	mov    %ebx,(%esp)
  80241d:	e8 02 0a 00 00       	call   802e24 <pageref>
  802422:	89 c2                	mov    %eax,%edx
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
  802429:	83 fa 01             	cmp    $0x1,%edx
  80242c:	75 0b                	jne    802439 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80242e:	8b 43 0c             	mov    0xc(%ebx),%eax
  802431:	89 04 24             	mov    %eax,(%esp)
  802434:	e8 b1 02 00 00       	call   8026ea <nsipc_close>
	else
		return 0;
}
  802439:	83 c4 14             	add    $0x14,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5d                   	pop    %ebp
  80243e:	c3                   	ret    

0080243f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802445:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80244c:	00 
  80244d:	8b 45 10             	mov    0x10(%ebp),%eax
  802450:	89 44 24 08          	mov    %eax,0x8(%esp)
  802454:	8b 45 0c             	mov    0xc(%ebp),%eax
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	8b 40 0c             	mov    0xc(%eax),%eax
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 bd 02 00 00       	call   802726 <nsipc_send>
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802471:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802478:	00 
  802479:	8b 45 10             	mov    0x10(%ebp),%eax
  80247c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802480:	8b 45 0c             	mov    0xc(%ebp),%eax
  802483:	89 44 24 04          	mov    %eax,0x4(%esp)
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	89 04 24             	mov    %eax,(%esp)
  802490:	e8 04 03 00 00       	call   802799 <nsipc_recv>
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	56                   	push   %esi
  80249b:	53                   	push   %ebx
  80249c:	83 ec 20             	sub    $0x20,%esp
  80249f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8024a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024a4:	89 04 24             	mov    %eax,(%esp)
  8024a7:	e8 73 ef ff ff       	call   80141f <fd_alloc>
  8024ac:	89 c3                	mov    %eax,%ebx
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	78 21                	js     8024d3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8024b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024b9:	00 
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c8:	e8 01 ee ff ff       	call   8012ce <sys_page_alloc>
  8024cd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	79 0a                	jns    8024dd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8024d3:	89 34 24             	mov    %esi,(%esp)
  8024d6:	e8 0f 02 00 00       	call   8026ea <nsipc_close>
		return r;
  8024db:	eb 28                	jmp    802505 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8024dd:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	89 04 24             	mov    %eax,(%esp)
  8024fe:	e8 f1 ee ff ff       	call   8013f4 <fd2num>
  802503:	89 c3                	mov    %eax,%ebx
}
  802505:	89 d8                	mov    %ebx,%eax
  802507:	83 c4 20             	add    $0x20,%esp
  80250a:	5b                   	pop    %ebx
  80250b:	5e                   	pop    %esi
  80250c:	5d                   	pop    %ebp
  80250d:	c3                   	ret    

0080250e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802514:	8b 45 10             	mov    0x10(%ebp),%eax
  802517:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	89 04 24             	mov    %eax,(%esp)
  802528:	e8 71 01 00 00       	call   80269e <nsipc_socket>
  80252d:	85 c0                	test   %eax,%eax
  80252f:	78 05                	js     802536 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802531:	e8 61 ff ff ff       	call   802497 <alloc_sockfd>
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80253e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802541:	89 54 24 04          	mov    %edx,0x4(%esp)
  802545:	89 04 24             	mov    %eax,(%esp)
  802548:	e8 2b ef ff ff       	call   801478 <fd_lookup>
  80254d:	85 c0                	test   %eax,%eax
  80254f:	78 15                	js     802566 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802554:	8b 0a                	mov    (%edx),%ecx
  802556:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80255b:	3b 0d ac 57 80 00    	cmp    0x8057ac,%ecx
  802561:	75 03                	jne    802566 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802563:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	e8 c2 ff ff ff       	call   802538 <fd2sockid>
  802576:	85 c0                	test   %eax,%eax
  802578:	78 0f                	js     802589 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80257a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802581:	89 04 24             	mov    %eax,(%esp)
  802584:	e8 3f 01 00 00       	call   8026c8 <nsipc_listen>
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	e8 9f ff ff ff       	call   802538 <fd2sockid>
  802599:	85 c0                	test   %eax,%eax
  80259b:	78 16                	js     8025b3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80259d:	8b 55 10             	mov    0x10(%ebp),%edx
  8025a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025ab:	89 04 24             	mov    %eax,(%esp)
  8025ae:	e8 66 02 00 00       	call   802819 <nsipc_connect>
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	e8 75 ff ff ff       	call   802538 <fd2sockid>
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	78 0f                	js     8025d6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8025c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025ce:	89 04 24             	mov    %eax,(%esp)
  8025d1:	e8 2e 01 00 00       	call   802704 <nsipc_shutdown>
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	e8 52 ff ff ff       	call   802538 <fd2sockid>
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	78 16                	js     802600 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8025ea:	8b 55 10             	mov    0x10(%ebp),%edx
  8025ed:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025f8:	89 04 24             	mov    %eax,(%esp)
  8025fb:	e8 58 02 00 00       	call   802858 <nsipc_bind>
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	e8 28 ff ff ff       	call   802538 <fd2sockid>
  802610:	85 c0                	test   %eax,%eax
  802612:	78 1f                	js     802633 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802614:	8b 55 10             	mov    0x10(%ebp),%edx
  802617:	89 54 24 08          	mov    %edx,0x8(%esp)
  80261b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 6d 02 00 00       	call   802897 <nsipc_accept>
  80262a:	85 c0                	test   %eax,%eax
  80262c:	78 05                	js     802633 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80262e:	e8 64 fe ff ff       	call   802497 <alloc_sockfd>
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    
  802635:	00 00                	add    %al,(%eax)
	...

00802638 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	53                   	push   %ebx
  80263c:	83 ec 14             	sub    $0x14,%esp
  80263f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802641:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802648:	75 11                	jne    80265b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80264a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802651:	e8 a2 06 00 00       	call   802cf8 <ipc_find_env>
  802656:	a3 04 60 80 00       	mov    %eax,0x806004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80265b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802662:	00 
  802663:	c7 44 24 08 00 a0 80 	movl   $0x80a000,0x8(%esp)
  80266a:	00 
  80266b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80266f:	a1 04 60 80 00       	mov    0x806004,%eax
  802674:	89 04 24             	mov    %eax,(%esp)
  802677:	e8 b2 06 00 00       	call   802d2e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80267c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802683:	00 
  802684:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80268b:	00 
  80268c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802693:	e8 02 07 00 00       	call   802d9a <ipc_recv>
}
  802698:	83 c4 14             	add    $0x14,%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5d                   	pop    %ebp
  80269d:	c3                   	ret    

0080269e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.socket.req_type = type;
  8026ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026af:	a3 04 a0 80 00       	mov    %eax,0x80a004
	nsipcbuf.socket.req_protocol = protocol;
  8026b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b7:	a3 08 a0 80 00       	mov    %eax,0x80a008
	return nsipc(NSREQ_SOCKET);
  8026bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8026c1:	e8 72 ff ff ff       	call   802638 <nsipc>
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.listen.req_backlog = backlog;
  8026d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d9:	a3 04 a0 80 00       	mov    %eax,0x80a004
	return nsipc(NSREQ_LISTEN);
  8026de:	b8 06 00 00 00       	mov    $0x6,%eax
  8026e3:	e8 50 ff ff ff       	call   802638 <nsipc>
}
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return nsipc(NSREQ_CLOSE);
  8026f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8026fd:	e8 36 ff ff ff       	call   802638 <nsipc>
}
  802702:	c9                   	leave  
  802703:	c3                   	ret    

00802704 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
  802707:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.shutdown.req_how = how;
  802712:	8b 45 0c             	mov    0xc(%ebp),%eax
  802715:	a3 04 a0 80 00       	mov    %eax,0x80a004
	return nsipc(NSREQ_SHUTDOWN);
  80271a:	b8 03 00 00 00       	mov    $0x3,%eax
  80271f:	e8 14 ff ff ff       	call   802638 <nsipc>
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	53                   	push   %ebx
  80272a:	83 ec 14             	sub    $0x14,%esp
  80272d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	a3 00 a0 80 00       	mov    %eax,0x80a000
	assert(size < 1600);
  802738:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80273e:	7e 24                	jle    802764 <nsipc_send+0x3e>
  802740:	c7 44 24 0c 64 37 80 	movl   $0x803764,0xc(%esp)
  802747:	00 
  802748:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  80274f:	00 
  802750:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802757:	00 
  802758:	c7 04 24 70 37 80 00 	movl   $0x803770,(%esp)
  80275f:	e8 04 dd ff ff       	call   800468 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802764:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276f:	c7 04 24 0c a0 80 00 	movl   $0x80a00c,(%esp)
  802776:	e8 b4 e5 ff ff       	call   800d2f <memmove>
	nsipcbuf.send.req_size = size;
  80277b:	89 1d 04 a0 80 00    	mov    %ebx,0x80a004
	nsipcbuf.send.req_flags = flags;
  802781:	8b 45 14             	mov    0x14(%ebp),%eax
  802784:	a3 08 a0 80 00       	mov    %eax,0x80a008
	return nsipc(NSREQ_SEND);
  802789:	b8 08 00 00 00       	mov    $0x8,%eax
  80278e:	e8 a5 fe ff ff       	call   802638 <nsipc>
}
  802793:	83 c4 14             	add    $0x14,%esp
  802796:	5b                   	pop    %ebx
  802797:	5d                   	pop    %ebp
  802798:	c3                   	ret    

00802799 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	56                   	push   %esi
  80279d:	53                   	push   %ebx
  80279e:	83 ec 10             	sub    $0x10,%esp
  8027a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.recv.req_len = len;
  8027ac:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	nsipcbuf.recv.req_flags = flags;
  8027b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8027b5:	a3 08 a0 80 00       	mov    %eax,0x80a008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8027ba:	b8 07 00 00 00       	mov    $0x7,%eax
  8027bf:	e8 74 fe ff ff       	call   802638 <nsipc>
  8027c4:	89 c3                	mov    %eax,%ebx
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	78 46                	js     802810 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8027ca:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8027cf:	7f 04                	jg     8027d5 <nsipc_recv+0x3c>
  8027d1:	39 c6                	cmp    %eax,%esi
  8027d3:	7d 24                	jge    8027f9 <nsipc_recv+0x60>
  8027d5:	c7 44 24 0c 7c 37 80 	movl   $0x80377c,0xc(%esp)
  8027dc:	00 
  8027dd:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  8027e4:	00 
  8027e5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8027ec:	00 
  8027ed:	c7 04 24 70 37 80 00 	movl   $0x803770,(%esp)
  8027f4:	e8 6f dc ff ff       	call   800468 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8027f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027fd:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802804:	00 
  802805:	8b 45 0c             	mov    0xc(%ebp),%eax
  802808:	89 04 24             	mov    %eax,(%esp)
  80280b:	e8 1f e5 ff ff       	call   800d2f <memmove>
	}

	return r;
}
  802810:	89 d8                	mov    %ebx,%eax
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	5b                   	pop    %ebx
  802816:	5e                   	pop    %esi
  802817:	5d                   	pop    %ebp
  802818:	c3                   	ret    

00802819 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	53                   	push   %ebx
  80281d:	83 ec 14             	sub    $0x14,%esp
  802820:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	a3 00 a0 80 00       	mov    %eax,0x80a000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80282b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80282f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802832:	89 44 24 04          	mov    %eax,0x4(%esp)
  802836:	c7 04 24 04 a0 80 00 	movl   $0x80a004,(%esp)
  80283d:	e8 ed e4 ff ff       	call   800d2f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802842:	89 1d 14 a0 80 00    	mov    %ebx,0x80a014
	return nsipc(NSREQ_CONNECT);
  802848:	b8 05 00 00 00       	mov    $0x5,%eax
  80284d:	e8 e6 fd ff ff       	call   802638 <nsipc>
}
  802852:	83 c4 14             	add    $0x14,%esp
  802855:	5b                   	pop    %ebx
  802856:	5d                   	pop    %ebp
  802857:	c3                   	ret    

00802858 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	53                   	push   %ebx
  80285c:	83 ec 14             	sub    $0x14,%esp
  80285f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	a3 00 a0 80 00       	mov    %eax,0x80a000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80286a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80286e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802871:	89 44 24 04          	mov    %eax,0x4(%esp)
  802875:	c7 04 24 04 a0 80 00 	movl   $0x80a004,(%esp)
  80287c:	e8 ae e4 ff ff       	call   800d2f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802881:	89 1d 14 a0 80 00    	mov    %ebx,0x80a014
	return nsipc(NSREQ_BIND);
  802887:	b8 02 00 00 00       	mov    $0x2,%eax
  80288c:	e8 a7 fd ff ff       	call   802638 <nsipc>
}
  802891:	83 c4 14             	add    $0x14,%esp
  802894:	5b                   	pop    %ebx
  802895:	5d                   	pop    %ebp
  802896:	c3                   	ret    

00802897 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
  80289a:	83 ec 28             	sub    $0x28,%esp
  80289d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8028a0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8028a3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8028a6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8028b1:	8b 07                	mov    (%edi),%eax
  8028b3:	a3 04 a0 80 00       	mov    %eax,0x80a004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8028b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bd:	e8 76 fd ff ff       	call   802638 <nsipc>
  8028c2:	89 c6                	mov    %eax,%esi
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	78 22                	js     8028ea <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8028c8:	bb 10 a0 80 00       	mov    $0x80a010,%ebx
  8028cd:	8b 03                	mov    (%ebx),%eax
  8028cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028d3:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  8028da:	00 
  8028db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028de:	89 04 24             	mov    %eax,(%esp)
  8028e1:	e8 49 e4 ff ff       	call   800d2f <memmove>
		*addrlen = ret->ret_addrlen;
  8028e6:	8b 03                	mov    (%ebx),%eax
  8028e8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8028ea:	89 f0                	mov    %esi,%eax
  8028ec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028ef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028f5:	89 ec                	mov    %ebp,%esp
  8028f7:	5d                   	pop    %ebp
  8028f8:	c3                   	ret    
  8028f9:	00 00                	add    %al,(%eax)
	...

008028fc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 18             	sub    $0x18,%esp
  802902:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802905:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802908:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	89 04 24             	mov    %eax,(%esp)
  802911:	e8 ee ea ff ff       	call   801404 <fd2data>
  802916:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802918:	c7 44 24 04 91 37 80 	movl   $0x803791,0x4(%esp)
  80291f:	00 
  802920:	89 34 24             	mov    %esi,(%esp)
  802923:	e8 61 e2 ff ff       	call   800b89 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802928:	8b 43 04             	mov    0x4(%ebx),%eax
  80292b:	2b 03                	sub    (%ebx),%eax
  80292d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802933:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80293a:	00 00 00 
	stat->st_dev = &devpipe;
  80293d:	c7 86 88 00 00 00 c8 	movl   $0x8057c8,0x88(%esi)
  802944:	57 80 00 
	return 0;
}
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
  80294c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80294f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802952:	89 ec                	mov    %ebp,%esp
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    

00802956 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	53                   	push   %ebx
  80295a:	83 ec 14             	sub    $0x14,%esp
  80295d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802960:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802964:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80296b:	e8 a2 e8 ff ff       	call   801212 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802970:	89 1c 24             	mov    %ebx,(%esp)
  802973:	e8 8c ea ff ff       	call   801404 <fd2data>
  802978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80297c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802983:	e8 8a e8 ff ff       	call   801212 <sys_page_unmap>
}
  802988:	83 c4 14             	add    $0x14,%esp
  80298b:	5b                   	pop    %ebx
  80298c:	5d                   	pop    %ebp
  80298d:	c3                   	ret    

0080298e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	53                   	push   %ebx
  802994:	83 ec 2c             	sub    $0x2c,%esp
  802997:	89 c7                	mov    %eax,%edi
  802999:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80299c:	a1 90 77 80 00       	mov    0x807790,%eax
  8029a1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8029a4:	89 3c 24             	mov    %edi,(%esp)
  8029a7:	e8 78 04 00 00       	call   802e24 <pageref>
  8029ac:	89 c6                	mov    %eax,%esi
  8029ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b1:	89 04 24             	mov    %eax,(%esp)
  8029b4:	e8 6b 04 00 00       	call   802e24 <pageref>
  8029b9:	39 c6                	cmp    %eax,%esi
  8029bb:	0f 94 c0             	sete   %al
  8029be:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8029c1:	8b 15 90 77 80 00    	mov    0x807790,%edx
  8029c7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029ca:	39 cb                	cmp    %ecx,%ebx
  8029cc:	75 08                	jne    8029d6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8029ce:	83 c4 2c             	add    $0x2c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8029d6:	83 f8 01             	cmp    $0x1,%eax
  8029d9:	75 c1                	jne    80299c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029db:	8b 52 58             	mov    0x58(%edx),%edx
  8029de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029ea:	c7 04 24 98 37 80 00 	movl   $0x803798,(%esp)
  8029f1:	e8 2b db ff ff       	call   800521 <cprintf>
  8029f6:	eb a4                	jmp    80299c <_pipeisclosed+0xe>

008029f8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	57                   	push   %edi
  8029fc:	56                   	push   %esi
  8029fd:	53                   	push   %ebx
  8029fe:	83 ec 1c             	sub    $0x1c,%esp
  802a01:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802a04:	89 34 24             	mov    %esi,(%esp)
  802a07:	e8 f8 e9 ff ff       	call   801404 <fd2data>
  802a0c:	89 c3                	mov    %eax,%ebx
  802a0e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a13:	eb 48                	jmp    802a5d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802a15:	89 da                	mov    %ebx,%edx
  802a17:	89 f0                	mov    %esi,%eax
  802a19:	e8 70 ff ff ff       	call   80298e <_pipeisclosed>
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 07                	je     802a29 <devpipe_write+0x31>
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	eb 3b                	jmp    802a64 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802a29:	e8 ff e8 ff ff       	call   80132d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a2e:	8b 43 04             	mov    0x4(%ebx),%eax
  802a31:	8b 13                	mov    (%ebx),%edx
  802a33:	83 c2 20             	add    $0x20,%edx
  802a36:	39 d0                	cmp    %edx,%eax
  802a38:	73 db                	jae    802a15 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a3a:	89 c2                	mov    %eax,%edx
  802a3c:	c1 fa 1f             	sar    $0x1f,%edx
  802a3f:	c1 ea 1b             	shr    $0x1b,%edx
  802a42:	01 d0                	add    %edx,%eax
  802a44:	83 e0 1f             	and    $0x1f,%eax
  802a47:	29 d0                	sub    %edx,%eax
  802a49:	89 c2                	mov    %eax,%edx
  802a4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a4e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802a52:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a56:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a5a:	83 c7 01             	add    $0x1,%edi
  802a5d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a60:	72 cc                	jb     802a2e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802a62:	89 f8                	mov    %edi,%eax
}
  802a64:	83 c4 1c             	add    $0x1c,%esp
  802a67:	5b                   	pop    %ebx
  802a68:	5e                   	pop    %esi
  802a69:	5f                   	pop    %edi
  802a6a:	5d                   	pop    %ebp
  802a6b:	c3                   	ret    

00802a6c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
  802a6f:	83 ec 28             	sub    $0x28,%esp
  802a72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a75:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a78:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a7e:	89 3c 24             	mov    %edi,(%esp)
  802a81:	e8 7e e9 ff ff       	call   801404 <fd2data>
  802a86:	89 c3                	mov    %eax,%ebx
  802a88:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a8d:	eb 48                	jmp    802ad7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a8f:	85 f6                	test   %esi,%esi
  802a91:	74 04                	je     802a97 <devpipe_read+0x2b>
				return i;
  802a93:	89 f0                	mov    %esi,%eax
  802a95:	eb 47                	jmp    802ade <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a97:	89 da                	mov    %ebx,%edx
  802a99:	89 f8                	mov    %edi,%eax
  802a9b:	e8 ee fe ff ff       	call   80298e <_pipeisclosed>
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 07                	je     802aab <devpipe_read+0x3f>
  802aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa9:	eb 33                	jmp    802ade <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802aab:	e8 7d e8 ff ff       	call   80132d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ab0:	8b 03                	mov    (%ebx),%eax
  802ab2:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ab5:	74 d8                	je     802a8f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ab7:	89 c2                	mov    %eax,%edx
  802ab9:	c1 fa 1f             	sar    $0x1f,%edx
  802abc:	c1 ea 1b             	shr    $0x1b,%edx
  802abf:	01 d0                	add    %edx,%eax
  802ac1:	83 e0 1f             	and    $0x1f,%eax
  802ac4:	29 d0                	sub    %edx,%eax
  802ac6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ace:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802ad1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ad4:	83 c6 01             	add    $0x1,%esi
  802ad7:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ada:	72 d4                	jb     802ab0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802adc:	89 f0                	mov    %esi,%eax
}
  802ade:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ae1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ae4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ae7:	89 ec                	mov    %ebp,%esp
  802ae9:	5d                   	pop    %ebp
  802aea:	c3                   	ret    

00802aeb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
  802aee:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802af1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	89 04 24             	mov    %eax,(%esp)
  802afe:	e8 75 e9 ff ff       	call   801478 <fd_lookup>
  802b03:	85 c0                	test   %eax,%eax
  802b05:	78 15                	js     802b1c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	89 04 24             	mov    %eax,(%esp)
  802b0d:	e8 f2 e8 ff ff       	call   801404 <fd2data>
	return _pipeisclosed(fd, p);
  802b12:	89 c2                	mov    %eax,%edx
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	e8 72 fe ff ff       	call   80298e <_pipeisclosed>
}
  802b1c:	c9                   	leave  
  802b1d:	c3                   	ret    

00802b1e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b1e:	55                   	push   %ebp
  802b1f:	89 e5                	mov    %esp,%ebp
  802b21:	83 ec 48             	sub    $0x48,%esp
  802b24:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b27:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b2a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b33:	89 04 24             	mov    %eax,(%esp)
  802b36:	e8 e4 e8 ff ff       	call   80141f <fd_alloc>
  802b3b:	89 c3                	mov    %eax,%ebx
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	0f 88 42 01 00 00    	js     802c87 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b45:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b4c:	00 
  802b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b5b:	e8 6e e7 ff ff       	call   8012ce <sys_page_alloc>
  802b60:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b62:	85 c0                	test   %eax,%eax
  802b64:	0f 88 1d 01 00 00    	js     802c87 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b6a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802b6d:	89 04 24             	mov    %eax,(%esp)
  802b70:	e8 aa e8 ff ff       	call   80141f <fd_alloc>
  802b75:	89 c3                	mov    %eax,%ebx
  802b77:	85 c0                	test   %eax,%eax
  802b79:	0f 88 f5 00 00 00    	js     802c74 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b7f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b86:	00 
  802b87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b95:	e8 34 e7 ff ff       	call   8012ce <sys_page_alloc>
  802b9a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	0f 88 d0 00 00 00    	js     802c74 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba7:	89 04 24             	mov    %eax,(%esp)
  802baa:	e8 55 e8 ff ff       	call   801404 <fd2data>
  802baf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bb1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802bb8:	00 
  802bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bc4:	e8 05 e7 ff ff       	call   8012ce <sys_page_alloc>
  802bc9:	89 c3                	mov    %eax,%ebx
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	0f 88 8e 00 00 00    	js     802c61 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd6:	89 04 24             	mov    %eax,(%esp)
  802bd9:	e8 26 e8 ff ff       	call   801404 <fd2data>
  802bde:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802be5:	00 
  802be6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802bf1:	00 
  802bf2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bfd:	e8 6e e6 ff ff       	call   801270 <sys_page_map>
  802c02:	89 c3                	mov    %eax,%ebx
  802c04:	85 c0                	test   %eax,%eax
  802c06:	78 49                	js     802c51 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802c08:	b8 c8 57 80 00       	mov    $0x8057c8,%eax
  802c0d:	8b 08                	mov    (%eax),%ecx
  802c0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c12:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c17:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802c1e:	8b 10                	mov    (%eax),%edx
  802c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c23:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c28:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c32:	89 04 24             	mov    %eax,(%esp)
  802c35:	e8 ba e7 ff ff       	call   8013f4 <fd2num>
  802c3a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3f:	89 04 24             	mov    %eax,(%esp)
  802c42:	e8 ad e7 ff ff       	call   8013f4 <fd2num>
  802c47:	89 47 04             	mov    %eax,0x4(%edi)
  802c4a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802c4f:	eb 36                	jmp    802c87 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802c51:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c5c:	e8 b1 e5 ff ff       	call   801212 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c6f:	e8 9e e5 ff ff       	call   801212 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c82:	e8 8b e5 ff ff       	call   801212 <sys_page_unmap>
    err:
	return r;
}
  802c87:	89 d8                	mov    %ebx,%eax
  802c89:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c8c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c8f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c92:	89 ec                	mov    %ebp,%esp
  802c94:	5d                   	pop    %ebp
  802c95:	c3                   	ret    
	...

00802c98 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
  802c9b:	56                   	push   %esi
  802c9c:	53                   	push   %ebx
  802c9d:	83 ec 10             	sub    $0x10,%esp
  802ca0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802ca3:	85 f6                	test   %esi,%esi
  802ca5:	75 24                	jne    802ccb <wait+0x33>
  802ca7:	c7 44 24 0c b0 37 80 	movl   $0x8037b0,0xc(%esp)
  802cae:	00 
  802caf:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  802cb6:	00 
  802cb7:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802cbe:	00 
  802cbf:	c7 04 24 bb 37 80 00 	movl   $0x8037bb,(%esp)
  802cc6:	e8 9d d7 ff ff       	call   800468 <_panic>
	e = &envs[ENVX(envid)];
  802ccb:	89 f3                	mov    %esi,%ebx
  802ccd:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802cd3:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802cd6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cdc:	eb 05                	jmp    802ce3 <wait+0x4b>
		sys_yield();
  802cde:	e8 4a e6 ff ff       	call   80132d <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802ce3:	8b 43 48             	mov    0x48(%ebx),%eax
  802ce6:	39 f0                	cmp    %esi,%eax
  802ce8:	75 07                	jne    802cf1 <wait+0x59>
  802cea:	8b 43 54             	mov    0x54(%ebx),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	75 ed                	jne    802cde <wait+0x46>
		sys_yield();
}
  802cf1:	83 c4 10             	add    $0x10,%esp
  802cf4:	5b                   	pop    %ebx
  802cf5:	5e                   	pop    %esi
  802cf6:	5d                   	pop    %ebp
  802cf7:	c3                   	ret    

00802cf8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802d03:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d06:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	39 ca                	cmp    %ecx,%edx
  802d10:	75 0c                	jne    802d1e <ipc_find_env+0x26>
			return envs[i].env_id;
  802d12:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d15:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	eb 0e                	jmp    802d2c <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d1e:	83 c0 01             	add    $0x1,%eax
  802d21:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d26:	75 db                	jne    802d03 <ipc_find_env+0xb>
  802d28:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802d2c:	5d                   	pop    %ebp
  802d2d:	c3                   	ret    

00802d2e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
  802d31:	57                   	push   %edi
  802d32:	56                   	push   %esi
  802d33:	53                   	push   %ebx
  802d34:	83 ec 2c             	sub    $0x2c,%esp
  802d37:	8b 75 08             	mov    0x8(%ebp),%esi
  802d3a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802d3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802d40:	85 db                	test   %ebx,%ebx
  802d42:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d47:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  802d4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d55:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d59:	89 34 24             	mov    %esi,(%esp)
  802d5c:	e8 5f e3 ff ff       	call   8010c0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802d61:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d64:	74 e4                	je     802d4a <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 28                	je     802d92 <ipc_send+0x64>
  802d6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d6e:	c7 44 24 0c e3 37 80 	movl   $0x8037e3,0xc(%esp)
  802d75:	00 
  802d76:	c7 44 24 08 c6 37 80 	movl   $0x8037c6,0x8(%esp)
  802d7d:	00 
  802d7e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802d85:	00 
  802d86:	c7 04 24 d9 37 80 00 	movl   $0x8037d9,(%esp)
  802d8d:	e8 d6 d6 ff ff       	call   800468 <_panic>
	//if(!ret) sys_yield();
}
  802d92:	83 c4 2c             	add    $0x2c,%esp
  802d95:	5b                   	pop    %ebx
  802d96:	5e                   	pop    %esi
  802d97:	5f                   	pop    %edi
  802d98:	5d                   	pop    %ebp
  802d99:	c3                   	ret    

00802d9a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d9a:	55                   	push   %ebp
  802d9b:	89 e5                	mov    %esp,%ebp
  802d9d:	83 ec 28             	sub    $0x28,%esp
  802da0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802da3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802da6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802da9:	8b 75 08             	mov    0x8(%ebp),%esi
  802dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daf:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802db2:	85 c0                	test   %eax,%eax
  802db4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802db9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802dbc:	89 04 24             	mov    %eax,(%esp)
  802dbf:	e8 9f e2 ff ff       	call   801063 <sys_ipc_recv>
  802dc4:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802dc6:	e8 96 e5 ff ff       	call   801361 <sys_getenvid>
  802dcb:	25 ff 03 00 00       	and    $0x3ff,%eax
  802dd0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802dd3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802dd8:	a3 90 77 80 00       	mov    %eax,0x807790
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802ddd:	85 f6                	test   %esi,%esi
  802ddf:	74 0e                	je     802def <ipc_recv+0x55>
  802de1:	ba 00 00 00 00       	mov    $0x0,%edx
  802de6:	85 db                	test   %ebx,%ebx
  802de8:	75 03                	jne    802ded <ipc_recv+0x53>
  802dea:	8b 50 74             	mov    0x74(%eax),%edx
  802ded:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802def:	85 ff                	test   %edi,%edi
  802df1:	74 13                	je     802e06 <ipc_recv+0x6c>
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
  802df8:	85 db                	test   %ebx,%ebx
  802dfa:	75 08                	jne    802e04 <ipc_recv+0x6a>
  802dfc:	a1 90 77 80 00       	mov    0x807790,%eax
  802e01:	8b 40 78             	mov    0x78(%eax),%eax
  802e04:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802e06:	85 db                	test   %ebx,%ebx
  802e08:	75 08                	jne    802e12 <ipc_recv+0x78>
  802e0a:	a1 90 77 80 00       	mov    0x807790,%eax
  802e0f:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802e12:	89 d8                	mov    %ebx,%eax
  802e14:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802e17:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802e1a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802e1d:	89 ec                	mov    %ebp,%esp
  802e1f:	5d                   	pop    %ebp
  802e20:	c3                   	ret    
  802e21:	00 00                	add    %al,(%eax)
	...

00802e24 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802e24:	55                   	push   %ebp
  802e25:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	89 c2                	mov    %eax,%edx
  802e2c:	c1 ea 16             	shr    $0x16,%edx
  802e2f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802e36:	f6 c2 01             	test   $0x1,%dl
  802e39:	74 20                	je     802e5b <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802e3b:	c1 e8 0c             	shr    $0xc,%eax
  802e3e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802e45:	a8 01                	test   $0x1,%al
  802e47:	74 12                	je     802e5b <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802e49:	c1 e8 0c             	shr    $0xc,%eax
  802e4c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802e51:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802e56:	0f b7 c0             	movzwl %ax,%eax
  802e59:	eb 05                	jmp    802e60 <pageref+0x3c>
  802e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e60:	5d                   	pop    %ebp
  802e61:	c3                   	ret    
	...

00802e70 <__udivdi3>:
  802e70:	55                   	push   %ebp
  802e71:	89 e5                	mov    %esp,%ebp
  802e73:	57                   	push   %edi
  802e74:	56                   	push   %esi
  802e75:	83 ec 10             	sub    $0x10,%esp
  802e78:	8b 45 14             	mov    0x14(%ebp),%eax
  802e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7e:	8b 75 10             	mov    0x10(%ebp),%esi
  802e81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e84:	85 c0                	test   %eax,%eax
  802e86:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802e89:	75 35                	jne    802ec0 <__udivdi3+0x50>
  802e8b:	39 fe                	cmp    %edi,%esi
  802e8d:	77 61                	ja     802ef0 <__udivdi3+0x80>
  802e8f:	85 f6                	test   %esi,%esi
  802e91:	75 0b                	jne    802e9e <__udivdi3+0x2e>
  802e93:	b8 01 00 00 00       	mov    $0x1,%eax
  802e98:	31 d2                	xor    %edx,%edx
  802e9a:	f7 f6                	div    %esi
  802e9c:	89 c6                	mov    %eax,%esi
  802e9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ea1:	31 d2                	xor    %edx,%edx
  802ea3:	89 f8                	mov    %edi,%eax
  802ea5:	f7 f6                	div    %esi
  802ea7:	89 c7                	mov    %eax,%edi
  802ea9:	89 c8                	mov    %ecx,%eax
  802eab:	f7 f6                	div    %esi
  802ead:	89 c1                	mov    %eax,%ecx
  802eaf:	89 fa                	mov    %edi,%edx
  802eb1:	89 c8                	mov    %ecx,%eax
  802eb3:	83 c4 10             	add    $0x10,%esp
  802eb6:	5e                   	pop    %esi
  802eb7:	5f                   	pop    %edi
  802eb8:	5d                   	pop    %ebp
  802eb9:	c3                   	ret    
  802eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ec0:	39 f8                	cmp    %edi,%eax
  802ec2:	77 1c                	ja     802ee0 <__udivdi3+0x70>
  802ec4:	0f bd d0             	bsr    %eax,%edx
  802ec7:	83 f2 1f             	xor    $0x1f,%edx
  802eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ecd:	75 39                	jne    802f08 <__udivdi3+0x98>
  802ecf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802ed2:	0f 86 a0 00 00 00    	jbe    802f78 <__udivdi3+0x108>
  802ed8:	39 f8                	cmp    %edi,%eax
  802eda:	0f 82 98 00 00 00    	jb     802f78 <__udivdi3+0x108>
  802ee0:	31 ff                	xor    %edi,%edi
  802ee2:	31 c9                	xor    %ecx,%ecx
  802ee4:	89 c8                	mov    %ecx,%eax
  802ee6:	89 fa                	mov    %edi,%edx
  802ee8:	83 c4 10             	add    $0x10,%esp
  802eeb:	5e                   	pop    %esi
  802eec:	5f                   	pop    %edi
  802eed:	5d                   	pop    %ebp
  802eee:	c3                   	ret    
  802eef:	90                   	nop
  802ef0:	89 d1                	mov    %edx,%ecx
  802ef2:	89 fa                	mov    %edi,%edx
  802ef4:	89 c8                	mov    %ecx,%eax
  802ef6:	31 ff                	xor    %edi,%edi
  802ef8:	f7 f6                	div    %esi
  802efa:	89 c1                	mov    %eax,%ecx
  802efc:	89 fa                	mov    %edi,%edx
  802efe:	89 c8                	mov    %ecx,%eax
  802f00:	83 c4 10             	add    $0x10,%esp
  802f03:	5e                   	pop    %esi
  802f04:	5f                   	pop    %edi
  802f05:	5d                   	pop    %ebp
  802f06:	c3                   	ret    
  802f07:	90                   	nop
  802f08:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802f0c:	89 f2                	mov    %esi,%edx
  802f0e:	d3 e0                	shl    %cl,%eax
  802f10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f13:	b8 20 00 00 00       	mov    $0x20,%eax
  802f18:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f1b:	89 c1                	mov    %eax,%ecx
  802f1d:	d3 ea                	shr    %cl,%edx
  802f1f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802f23:	0b 55 ec             	or     -0x14(%ebp),%edx
  802f26:	d3 e6                	shl    %cl,%esi
  802f28:	89 c1                	mov    %eax,%ecx
  802f2a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802f2d:	89 fe                	mov    %edi,%esi
  802f2f:	d3 ee                	shr    %cl,%esi
  802f31:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802f35:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802f38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3b:	d3 e7                	shl    %cl,%edi
  802f3d:	89 c1                	mov    %eax,%ecx
  802f3f:	d3 ea                	shr    %cl,%edx
  802f41:	09 d7                	or     %edx,%edi
  802f43:	89 f2                	mov    %esi,%edx
  802f45:	89 f8                	mov    %edi,%eax
  802f47:	f7 75 ec             	divl   -0x14(%ebp)
  802f4a:	89 d6                	mov    %edx,%esi
  802f4c:	89 c7                	mov    %eax,%edi
  802f4e:	f7 65 e8             	mull   -0x18(%ebp)
  802f51:	39 d6                	cmp    %edx,%esi
  802f53:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802f56:	72 30                	jb     802f88 <__udivdi3+0x118>
  802f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802f5f:	d3 e2                	shl    %cl,%edx
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	73 05                	jae    802f6a <__udivdi3+0xfa>
  802f65:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802f68:	74 1e                	je     802f88 <__udivdi3+0x118>
  802f6a:	89 f9                	mov    %edi,%ecx
  802f6c:	31 ff                	xor    %edi,%edi
  802f6e:	e9 71 ff ff ff       	jmp    802ee4 <__udivdi3+0x74>
  802f73:	90                   	nop
  802f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f78:	31 ff                	xor    %edi,%edi
  802f7a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802f7f:	e9 60 ff ff ff       	jmp    802ee4 <__udivdi3+0x74>
  802f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f88:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802f8b:	31 ff                	xor    %edi,%edi
  802f8d:	89 c8                	mov    %ecx,%eax
  802f8f:	89 fa                	mov    %edi,%edx
  802f91:	83 c4 10             	add    $0x10,%esp
  802f94:	5e                   	pop    %esi
  802f95:	5f                   	pop    %edi
  802f96:	5d                   	pop    %ebp
  802f97:	c3                   	ret    
	...

00802fa0 <__umoddi3>:
  802fa0:	55                   	push   %ebp
  802fa1:	89 e5                	mov    %esp,%ebp
  802fa3:	57                   	push   %edi
  802fa4:	56                   	push   %esi
  802fa5:	83 ec 20             	sub    $0x20,%esp
  802fa8:	8b 55 14             	mov    0x14(%ebp),%edx
  802fab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fae:	8b 7d 10             	mov    0x10(%ebp),%edi
  802fb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802fb4:	85 d2                	test   %edx,%edx
  802fb6:	89 c8                	mov    %ecx,%eax
  802fb8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802fbb:	75 13                	jne    802fd0 <__umoddi3+0x30>
  802fbd:	39 f7                	cmp    %esi,%edi
  802fbf:	76 3f                	jbe    803000 <__umoddi3+0x60>
  802fc1:	89 f2                	mov    %esi,%edx
  802fc3:	f7 f7                	div    %edi
  802fc5:	89 d0                	mov    %edx,%eax
  802fc7:	31 d2                	xor    %edx,%edx
  802fc9:	83 c4 20             	add    $0x20,%esp
  802fcc:	5e                   	pop    %esi
  802fcd:	5f                   	pop    %edi
  802fce:	5d                   	pop    %ebp
  802fcf:	c3                   	ret    
  802fd0:	39 f2                	cmp    %esi,%edx
  802fd2:	77 4c                	ja     803020 <__umoddi3+0x80>
  802fd4:	0f bd ca             	bsr    %edx,%ecx
  802fd7:	83 f1 1f             	xor    $0x1f,%ecx
  802fda:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802fdd:	75 51                	jne    803030 <__umoddi3+0x90>
  802fdf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802fe2:	0f 87 e0 00 00 00    	ja     8030c8 <__umoddi3+0x128>
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	29 f8                	sub    %edi,%eax
  802fed:	19 d6                	sbb    %edx,%esi
  802fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	89 f2                	mov    %esi,%edx
  802ff7:	83 c4 20             	add    $0x20,%esp
  802ffa:	5e                   	pop    %esi
  802ffb:	5f                   	pop    %edi
  802ffc:	5d                   	pop    %ebp
  802ffd:	c3                   	ret    
  802ffe:	66 90                	xchg   %ax,%ax
  803000:	85 ff                	test   %edi,%edi
  803002:	75 0b                	jne    80300f <__umoddi3+0x6f>
  803004:	b8 01 00 00 00       	mov    $0x1,%eax
  803009:	31 d2                	xor    %edx,%edx
  80300b:	f7 f7                	div    %edi
  80300d:	89 c7                	mov    %eax,%edi
  80300f:	89 f0                	mov    %esi,%eax
  803011:	31 d2                	xor    %edx,%edx
  803013:	f7 f7                	div    %edi
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	f7 f7                	div    %edi
  80301a:	eb a9                	jmp    802fc5 <__umoddi3+0x25>
  80301c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803020:	89 c8                	mov    %ecx,%eax
  803022:	89 f2                	mov    %esi,%edx
  803024:	83 c4 20             	add    $0x20,%esp
  803027:	5e                   	pop    %esi
  803028:	5f                   	pop    %edi
  803029:	5d                   	pop    %ebp
  80302a:	c3                   	ret    
  80302b:	90                   	nop
  80302c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803030:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803034:	d3 e2                	shl    %cl,%edx
  803036:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803039:	ba 20 00 00 00       	mov    $0x20,%edx
  80303e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803041:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803044:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803048:	89 fa                	mov    %edi,%edx
  80304a:	d3 ea                	shr    %cl,%edx
  80304c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803050:	0b 55 f4             	or     -0xc(%ebp),%edx
  803053:	d3 e7                	shl    %cl,%edi
  803055:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803059:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80305c:	89 f2                	mov    %esi,%edx
  80305e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803061:	89 c7                	mov    %eax,%edi
  803063:	d3 ea                	shr    %cl,%edx
  803065:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803069:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80306c:	89 c2                	mov    %eax,%edx
  80306e:	d3 e6                	shl    %cl,%esi
  803070:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803074:	d3 ea                	shr    %cl,%edx
  803076:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80307a:	09 d6                	or     %edx,%esi
  80307c:	89 f0                	mov    %esi,%eax
  80307e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803081:	d3 e7                	shl    %cl,%edi
  803083:	89 f2                	mov    %esi,%edx
  803085:	f7 75 f4             	divl   -0xc(%ebp)
  803088:	89 d6                	mov    %edx,%esi
  80308a:	f7 65 e8             	mull   -0x18(%ebp)
  80308d:	39 d6                	cmp    %edx,%esi
  80308f:	72 2b                	jb     8030bc <__umoddi3+0x11c>
  803091:	39 c7                	cmp    %eax,%edi
  803093:	72 23                	jb     8030b8 <__umoddi3+0x118>
  803095:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803099:	29 c7                	sub    %eax,%edi
  80309b:	19 d6                	sbb    %edx,%esi
  80309d:	89 f0                	mov    %esi,%eax
  80309f:	89 f2                	mov    %esi,%edx
  8030a1:	d3 ef                	shr    %cl,%edi
  8030a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8030a7:	d3 e0                	shl    %cl,%eax
  8030a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8030ad:	09 f8                	or     %edi,%eax
  8030af:	d3 ea                	shr    %cl,%edx
  8030b1:	83 c4 20             	add    $0x20,%esp
  8030b4:	5e                   	pop    %esi
  8030b5:	5f                   	pop    %edi
  8030b6:	5d                   	pop    %ebp
  8030b7:	c3                   	ret    
  8030b8:	39 d6                	cmp    %edx,%esi
  8030ba:	75 d9                	jne    803095 <__umoddi3+0xf5>
  8030bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8030bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8030c2:	eb d1                	jmp    803095 <__umoddi3+0xf5>
  8030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030c8:	39 f2                	cmp    %esi,%edx
  8030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8030d0:	0f 82 12 ff ff ff    	jb     802fe8 <__umoddi3+0x48>
  8030d6:	e9 17 ff ff ff       	jmp    802ff2 <__umoddi3+0x52>
