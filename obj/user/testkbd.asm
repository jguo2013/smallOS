
obj/user/testkbd.debug:     file format elf32-i386


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

00800034 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  800040:	e8 98 12 00 00       	call   8012dd <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800045:	83 c3 01             	add    $0x1,%ebx
  800048:	83 fb 0a             	cmp    $0xa,%ebx
  80004b:	75 f3                	jne    800040 <umain+0xc>
		sys_yield();

	close(0);
  80004d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800054:	e8 8d 17 00 00       	call   8017e6 <close>
	if ((r = opencons()) < 0)
  800059:	e8 a9 01 00 00       	call   800207 <opencons>
  80005e:	85 c0                	test   %eax,%eax
  800060:	79 20                	jns    800082 <umain+0x4e>
		panic("opencons: %e", r);
  800062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800066:	c7 44 24 08 c0 2a 80 	movl   $0x802ac0,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800075:	00 
  800076:	c7 04 24 cd 2a 80 00 	movl   $0x802acd,(%esp)
  80007d:	e8 a6 02 00 00       	call   800328 <_panic>
	if (r != 0)
  800082:	85 c0                	test   %eax,%eax
  800084:	74 20                	je     8000a6 <umain+0x72>
		panic("first opencons used fd %d", r);
  800086:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008a:	c7 44 24 08 dc 2a 80 	movl   $0x802adc,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800099:	00 
  80009a:	c7 04 24 cd 2a 80 00 	movl   $0x802acd,(%esp)
  8000a1:	e8 82 02 00 00       	call   800328 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b5:	e8 cb 17 00 00       	call   801885 <dup>
  8000ba:	85 c0                	test   %eax,%eax
  8000bc:	79 20                	jns    8000de <umain+0xaa>
		panic("dup: %e", r);
  8000be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c2:	c7 44 24 08 f6 2a 80 	movl   $0x802af6,0x8(%esp)
  8000c9:	00 
  8000ca:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 cd 2a 80 00 	movl   $0x802acd,(%esp)
  8000d9:	e8 4a 02 00 00       	call   800328 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000de:	c7 04 24 fe 2a 80 00 	movl   $0x802afe,(%esp)
  8000e5:	e8 26 09 00 00       	call   800a10 <readline>
		if (buf != NULL)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	74 1a                	je     800108 <umain+0xd4>
			fprintf(1, "%s\n", buf);
  8000ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000f2:	c7 44 24 04 0c 2b 80 	movl   $0x802b0c,0x4(%esp)
  8000f9:	00 
  8000fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800101:	e8 c3 1c 00 00       	call   801dc9 <fprintf>
  800106:	eb d6                	jmp    8000de <umain+0xaa>
		else
			fprintf(1, "(end of file received)\n");
  800108:	c7 44 24 04 10 2b 80 	movl   $0x802b10,0x4(%esp)
  80010f:	00 
  800110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800117:	e8 ad 1c 00 00       	call   801dc9 <fprintf>
  80011c:	eb c0                	jmp    8000de <umain+0xaa>
	...

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 28 2b 80 	movl   $0x802b28,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 f6 09 00 00       	call   800b39 <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  800156:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80015b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800161:	eb 34                	jmp    800197 <devcons_write+0x4d>
		m = n - tot;
  800163:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800166:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  800168:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  80016e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800173:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800176:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80017a:	03 45 0c             	add    0xc(%ebp),%eax
  80017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800181:	89 3c 24             	mov    %edi,(%esp)
  800184:	e8 56 0b 00 00       	call   800cdf <memmove>
		sys_cputs(buf, m);
  800189:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018d:	89 3c 24             	mov    %edi,(%esp)
  800190:	e8 5b 0d 00 00       	call   800ef0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800195:	01 de                	add    %ebx,%esi
  800197:	89 f0                	mov    %esi,%eax
  800199:	3b 75 10             	cmp    0x10(%ebp),%esi
  80019c:	72 c5                	jb     800163 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80019e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001a4:	5b                   	pop    %ebx
  8001a5:	5e                   	pop    %esi
  8001a6:	5f                   	pop    %edi
  8001a7:	5d                   	pop    %ebp
  8001a8:	c3                   	ret    

008001a9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001bc:	00 
  8001bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c0:	89 04 24             	mov    %eax,(%esp)
  8001c3:	e8 28 0d 00 00       	call   800ef0 <sys_cputs>
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8001d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001d4:	75 07                	jne    8001dd <devcons_read+0x13>
  8001d6:	eb 28                	jmp    800200 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001d8:	e8 00 11 00 00       	call   8012dd <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001dd:	8d 76 00             	lea    0x0(%esi),%esi
  8001e0:	e8 d7 0c 00 00       	call   800ebc <sys_cgetc>
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	74 ef                	je     8001d8 <devcons_read+0xe>
  8001e9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8001eb:	85 c0                	test   %eax,%eax
  8001ed:	78 16                	js     800205 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001ef:	83 f8 04             	cmp    $0x4,%eax
  8001f2:	74 0c                	je     800200 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	88 10                	mov    %dl,(%eax)
  8001f9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8001fe:	eb 05                	jmp    800205 <devcons_read+0x3b>
  800200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80020d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800210:	89 04 24             	mov    %eax,(%esp)
  800213:	e8 b7 11 00 00       	call   8013cf <fd_alloc>
  800218:	85 c0                	test   %eax,%eax
  80021a:	78 3f                	js     80025b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80021c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800223:	00 
  800224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800232:	e8 47 10 00 00       	call   80127e <sys_page_alloc>
  800237:	85 c0                	test   %eax,%eax
  800239:	78 20                	js     80025b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80023b:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800244:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800249:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	e8 49 11 00 00       	call   8013a4 <fd2num>
}
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800266:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026a:	8b 45 08             	mov    0x8(%ebp),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	e8 b3 11 00 00       	call   801428 <fd_lookup>
  800275:	85 c0                	test   %eax,%eax
  800277:	78 11                	js     80028a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027c:	8b 00                	mov    (%eax),%eax
  80027e:	3b 05 00 40 80 00    	cmp    0x804000,%eax
  800284:	0f 94 c0             	sete   %al
  800287:	0f b6 c0             	movzbl %al,%eax
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800292:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800299:	00 
  80029a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80029d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a8:	e8 d2 13 00 00       	call   80167f <read>
	if (r < 0)
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	78 0f                	js     8002c0 <getchar+0x34>
		return r;
	if (r < 1)
  8002b1:	85 c0                	test   %eax,%eax
  8002b3:	7f 07                	jg     8002bc <getchar+0x30>
  8002b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8002ba:	eb 04                	jmp    8002c0 <getchar+0x34>
		return -E_EOF;
	return c;
  8002bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    
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
  8002d6:	e8 36 10 00 00       	call   801311 <sys_getenvid>
  8002db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e3:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8002e8:	a3 08 54 80 00       	mov    %eax,0x805408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ed:	85 f6                	test   %esi,%esi
  8002ef:	7e 07                	jle    8002f8 <libmain+0x34>
		binaryname = argv[0];
  8002f1:	8b 03                	mov    (%ebx),%eax
  8002f3:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8002f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002fc:	89 34 24             	mov    %esi,(%esp)
  8002ff:	e8 30 fd ff ff       	call   800034 <umain>

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
  800321:	e8 1f 10 00 00       	call   801345 <sys_env_destroy>
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
  800333:	8b 1d 1c 40 80 00    	mov    0x80401c,%ebx
  800339:	e8 d3 0f 00 00       	call   801311 <sys_getenvid>
  80033e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800341:	89 54 24 10          	mov    %edx,0x10(%esp)
  800345:	8b 55 08             	mov    0x8(%ebp),%edx
  800348:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80034c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800350:	89 44 24 04          	mov    %eax,0x4(%esp)
  800354:	c7 04 24 40 2b 80 00 	movl   $0x802b40,(%esp)
  80035b:	e8 81 00 00 00       	call   8003e1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800360:	89 74 24 04          	mov    %esi,0x4(%esp)
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	89 04 24             	mov    %eax,(%esp)
  80036a:	e8 11 00 00 00       	call   800380 <vcprintf>
	cprintf("\n");
  80036f:	c7 04 24 26 2b 80 00 	movl   $0x802b26,(%esp)
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
  8003d4:	e8 17 0b 00 00       	call   800ef0 <sys_cputs>

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
  800428:	e8 c3 0a 00 00       	call   800ef0 <sys_cputs>
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
  8004af:	e8 8c 23 00 00       	call   802840 <__udivdi3>
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
  80050a:	e8 61 24 00 00       	call   802970 <__umoddi3>
  80050f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800513:	0f be 80 63 2b 80 00 	movsbl 0x802b63(%eax),%eax
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
  8005f7:	ff 24 8d a0 2c 80 00 	jmp    *0x802ca0(,%ecx,4)
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
  8006b0:	8b 14 85 00 2e 80 00 	mov    0x802e00(,%eax,4),%edx
  8006b7:	85 d2                	test   %edx,%edx
  8006b9:	75 20                	jne    8006db <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8006bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006bf:	c7 44 24 08 74 2b 80 	movl   $0x802b74,0x8(%esp)
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
  8006df:	c7 44 24 08 6a 2f 80 	movl   $0x802f6a,0x8(%esp)
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
  800714:	b8 7d 2b 80 00       	mov    $0x802b7d,%eax
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
  80072f:	e8 e4 03 00 00       	call   800b18 <strnlen>
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

00800a10 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	57                   	push   %edi
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	83 ec 1c             	sub    $0x1c,%esp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	74 18                	je     800a38 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a20:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a24:	c7 44 24 04 6a 2f 80 	movl   $0x802f6a,0x4(%esp)
  800a2b:	00 
  800a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a33:	e8 91 13 00 00       	call   801dc9 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800a38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a3f:	e8 19 f8 ff ff       	call   80025d <iscons>
  800a44:	89 c7                	mov    %eax,%edi
  800a46:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  800a4b:	e8 3c f8 ff ff       	call   80028c <getchar>
  800a50:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a52:	85 c0                	test   %eax,%eax
  800a54:	79 25                	jns    800a7b <readline+0x6b>
			if (c != -E_EOF)
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800a5e:	0f 84 88 00 00 00    	je     800aec <readline+0xdc>
				cprintf("read error: %e\n", c);
  800a64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a68:	c7 04 24 67 2e 80 00 	movl   $0x802e67,(%esp)
  800a6f:	e8 6d f9 ff ff       	call   8003e1 <cprintf>
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	eb 71                	jmp    800aec <readline+0xdc>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a7b:	83 f8 08             	cmp    $0x8,%eax
  800a7e:	74 05                	je     800a85 <readline+0x75>
  800a80:	83 f8 7f             	cmp    $0x7f,%eax
  800a83:	75 19                	jne    800a9e <readline+0x8e>
  800a85:	85 f6                	test   %esi,%esi
  800a87:	7e 15                	jle    800a9e <readline+0x8e>
			if (echoing)
  800a89:	85 ff                	test   %edi,%edi
  800a8b:	74 0c                	je     800a99 <readline+0x89>
				cputchar('\b');
  800a8d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800a94:	e8 10 f7 ff ff       	call   8001a9 <cputchar>
			i--;
  800a99:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a9c:	eb ad                	jmp    800a4b <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a9e:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa1:	7e 1f                	jle    800ac2 <readline+0xb2>
  800aa3:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800aa9:	7f 17                	jg     800ac2 <readline+0xb2>
			if (echoing)
  800aab:	85 ff                	test   %edi,%edi
  800aad:	74 08                	je     800ab7 <readline+0xa7>
				cputchar(c);
  800aaf:	89 1c 24             	mov    %ebx,(%esp)
  800ab2:	e8 f2 f6 ff ff       	call   8001a9 <cputchar>
			buf[i++] = c;
  800ab7:	88 9e 00 50 80 00    	mov    %bl,0x805000(%esi)
  800abd:	83 c6 01             	add    $0x1,%esi
  800ac0:	eb 89                	jmp    800a4b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800ac2:	83 fb 0a             	cmp    $0xa,%ebx
  800ac5:	74 09                	je     800ad0 <readline+0xc0>
  800ac7:	83 fb 0d             	cmp    $0xd,%ebx
  800aca:	0f 85 7b ff ff ff    	jne    800a4b <readline+0x3b>
			if (echoing)
  800ad0:	85 ff                	test   %edi,%edi
  800ad2:	74 0c                	je     800ae0 <readline+0xd0>
				cputchar('\n');
  800ad4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800adb:	e8 c9 f6 ff ff       	call   8001a9 <cputchar>
			buf[i] = 0;
  800ae0:	c6 86 00 50 80 00 00 	movb   $0x0,0x805000(%esi)
  800ae7:	b8 00 50 80 00       	mov    $0x805000,%eax
			return buf;
		}
	}
}
  800aec:	83 c4 1c             	add    $0x1c,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    
	...

00800b00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
  800b06:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0b:	eb 03                	jmp    800b10 <strlen+0x10>
		n++;
  800b0d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b10:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b14:	75 f7                	jne    800b0d <strlen+0xd>
		n++;
	return n;
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	53                   	push   %ebx
  800b1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b27:	eb 03                	jmp    800b2c <strnlen+0x14>
		n++;
  800b29:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2c:	39 c1                	cmp    %eax,%ecx
  800b2e:	74 06                	je     800b36 <strnlen+0x1e>
  800b30:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b34:	75 f3                	jne    800b29 <strnlen+0x11>
		n++;
	return n;
}
  800b36:	5b                   	pop    %ebx
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	53                   	push   %ebx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b48:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b4c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b4f:	83 c2 01             	add    $0x1,%edx
  800b52:	84 c9                	test   %cl,%cl
  800b54:	75 f2                	jne    800b48 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b56:	5b                   	pop    %ebx
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	53                   	push   %ebx
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b63:	89 1c 24             	mov    %ebx,(%esp)
  800b66:	e8 95 ff ff ff       	call   800b00 <strlen>
	strcpy(dst + len, src);
  800b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b72:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800b75:	89 04 24             	mov    %eax,(%esp)
  800b78:	e8 bc ff ff ff       	call   800b39 <strcpy>
	return dst;
}
  800b7d:	89 d8                	mov    %ebx,%eax
  800b7f:	83 c4 08             	add    $0x8,%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b90:	8b 75 10             	mov    0x10(%ebp),%esi
  800b93:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b98:	eb 0f                	jmp    800ba9 <strncpy+0x24>
		*dst++ = *src;
  800b9a:	0f b6 19             	movzbl (%ecx),%ebx
  800b9d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ba0:	80 39 01             	cmpb   $0x1,(%ecx)
  800ba3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	39 f2                	cmp    %esi,%edx
  800bab:	72 ed                	jb     800b9a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	8b 75 08             	mov    0x8(%ebp),%esi
  800bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bbf:	89 f0                	mov    %esi,%eax
  800bc1:	85 d2                	test   %edx,%edx
  800bc3:	75 0a                	jne    800bcf <strlcpy+0x1e>
  800bc5:	eb 17                	jmp    800bde <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bc7:	88 18                	mov    %bl,(%eax)
  800bc9:	83 c0 01             	add    $0x1,%eax
  800bcc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bcf:	83 ea 01             	sub    $0x1,%edx
  800bd2:	74 07                	je     800bdb <strlcpy+0x2a>
  800bd4:	0f b6 19             	movzbl (%ecx),%ebx
  800bd7:	84 db                	test   %bl,%bl
  800bd9:	75 ec                	jne    800bc7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800bdb:	c6 00 00             	movb   $0x0,(%eax)
  800bde:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bed:	eb 06                	jmp    800bf5 <strcmp+0x11>
		p++, q++;
  800bef:	83 c1 01             	add    $0x1,%ecx
  800bf2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf5:	0f b6 01             	movzbl (%ecx),%eax
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 04                	je     800c00 <strcmp+0x1c>
  800bfc:	3a 02                	cmp    (%edx),%al
  800bfe:	74 ef                	je     800bef <strcmp+0xb>
  800c00:	0f b6 c0             	movzbl %al,%eax
  800c03:	0f b6 12             	movzbl (%edx),%edx
  800c06:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	53                   	push   %ebx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c14:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800c17:	eb 09                	jmp    800c22 <strncmp+0x18>
		n--, p++, q++;
  800c19:	83 ea 01             	sub    $0x1,%edx
  800c1c:	83 c0 01             	add    $0x1,%eax
  800c1f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c22:	85 d2                	test   %edx,%edx
  800c24:	75 07                	jne    800c2d <strncmp+0x23>
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	eb 13                	jmp    800c40 <strncmp+0x36>
  800c2d:	0f b6 18             	movzbl (%eax),%ebx
  800c30:	84 db                	test   %bl,%bl
  800c32:	74 04                	je     800c38 <strncmp+0x2e>
  800c34:	3a 19                	cmp    (%ecx),%bl
  800c36:	74 e1                	je     800c19 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c38:	0f b6 00             	movzbl (%eax),%eax
  800c3b:	0f b6 11             	movzbl (%ecx),%edx
  800c3e:	29 d0                	sub    %edx,%eax
}
  800c40:	5b                   	pop    %ebx
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4d:	eb 07                	jmp    800c56 <strchr+0x13>
		if (*s == c)
  800c4f:	38 ca                	cmp    %cl,%dl
  800c51:	74 0f                	je     800c62 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c53:	83 c0 01             	add    $0x1,%eax
  800c56:	0f b6 10             	movzbl (%eax),%edx
  800c59:	84 d2                	test   %dl,%dl
  800c5b:	75 f2                	jne    800c4f <strchr+0xc>
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c6e:	eb 07                	jmp    800c77 <strfind+0x13>
		if (*s == c)
  800c70:	38 ca                	cmp    %cl,%dl
  800c72:	74 0a                	je     800c7e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c74:	83 c0 01             	add    $0x1,%eax
  800c77:	0f b6 10             	movzbl (%eax),%edx
  800c7a:	84 d2                	test   %dl,%dl
  800c7c:	75 f2                	jne    800c70 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	89 1c 24             	mov    %ebx,(%esp)
  800c89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c91:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c9a:	85 c9                	test   %ecx,%ecx
  800c9c:	74 30                	je     800cce <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ca4:	75 25                	jne    800ccb <memset+0x4b>
  800ca6:	f6 c1 03             	test   $0x3,%cl
  800ca9:	75 20                	jne    800ccb <memset+0x4b>
		c &= 0xFF;
  800cab:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cae:	89 d3                	mov    %edx,%ebx
  800cb0:	c1 e3 08             	shl    $0x8,%ebx
  800cb3:	89 d6                	mov    %edx,%esi
  800cb5:	c1 e6 18             	shl    $0x18,%esi
  800cb8:	89 d0                	mov    %edx,%eax
  800cba:	c1 e0 10             	shl    $0x10,%eax
  800cbd:	09 f0                	or     %esi,%eax
  800cbf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800cc1:	09 d8                	or     %ebx,%eax
  800cc3:	c1 e9 02             	shr    $0x2,%ecx
  800cc6:	fc                   	cld    
  800cc7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cc9:	eb 03                	jmp    800cce <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ccb:	fc                   	cld    
  800ccc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cce:	89 f8                	mov    %edi,%eax
  800cd0:	8b 1c 24             	mov    (%esp),%ebx
  800cd3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cd7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cdb:	89 ec                	mov    %ebp,%esp
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	89 34 24             	mov    %esi,(%esp)
  800ce8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800cf2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800cf5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800cf7:	39 c6                	cmp    %eax,%esi
  800cf9:	73 35                	jae    800d30 <memmove+0x51>
  800cfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cfe:	39 d0                	cmp    %edx,%eax
  800d00:	73 2e                	jae    800d30 <memmove+0x51>
		s += n;
		d += n;
  800d02:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d04:	f6 c2 03             	test   $0x3,%dl
  800d07:	75 1b                	jne    800d24 <memmove+0x45>
  800d09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d0f:	75 13                	jne    800d24 <memmove+0x45>
  800d11:	f6 c1 03             	test   $0x3,%cl
  800d14:	75 0e                	jne    800d24 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d16:	83 ef 04             	sub    $0x4,%edi
  800d19:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d1c:	c1 e9 02             	shr    $0x2,%ecx
  800d1f:	fd                   	std    
  800d20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d22:	eb 09                	jmp    800d2d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d24:	83 ef 01             	sub    $0x1,%edi
  800d27:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d2a:	fd                   	std    
  800d2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d2d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2e:	eb 20                	jmp    800d50 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d36:	75 15                	jne    800d4d <memmove+0x6e>
  800d38:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d3e:	75 0d                	jne    800d4d <memmove+0x6e>
  800d40:	f6 c1 03             	test   $0x3,%cl
  800d43:	75 08                	jne    800d4d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800d45:	c1 e9 02             	shr    $0x2,%ecx
  800d48:	fc                   	cld    
  800d49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d4b:	eb 03                	jmp    800d50 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d4d:	fc                   	cld    
  800d4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d50:	8b 34 24             	mov    (%esp),%esi
  800d53:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d57:	89 ec                	mov    %ebp,%esp
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 04 24             	mov    %eax,(%esp)
  800d75:	e8 65 ff ff ff       	call   800cdf <memmove>
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d90:	eb 1c                	jmp    800dae <memcmp+0x32>
		if (*s1 != *s2)
  800d92:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800d96:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800d9a:	83 c2 01             	add    $0x1,%edx
  800d9d:	83 e9 01             	sub    $0x1,%ecx
  800da0:	38 d8                	cmp    %bl,%al
  800da2:	74 0a                	je     800dae <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800da4:	0f b6 c0             	movzbl %al,%eax
  800da7:	0f b6 db             	movzbl %bl,%ebx
  800daa:	29 d8                	sub    %ebx,%eax
  800dac:	eb 09                	jmp    800db7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dae:	85 c9                	test   %ecx,%ecx
  800db0:	75 e0                	jne    800d92 <memcmp+0x16>
  800db2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dc5:	89 c2                	mov    %eax,%edx
  800dc7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dca:	eb 07                	jmp    800dd3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dcc:	38 08                	cmp    %cl,(%eax)
  800dce:	74 07                	je     800dd7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dd0:	83 c0 01             	add    $0x1,%eax
  800dd3:	39 d0                	cmp    %edx,%eax
  800dd5:	72 f5                	jb     800dcc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de8:	eb 03                	jmp    800ded <strtol+0x14>
		s++;
  800dea:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ded:	0f b6 02             	movzbl (%edx),%eax
  800df0:	3c 20                	cmp    $0x20,%al
  800df2:	74 f6                	je     800dea <strtol+0x11>
  800df4:	3c 09                	cmp    $0x9,%al
  800df6:	74 f2                	je     800dea <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800df8:	3c 2b                	cmp    $0x2b,%al
  800dfa:	75 0c                	jne    800e08 <strtol+0x2f>
		s++;
  800dfc:	8d 52 01             	lea    0x1(%edx),%edx
  800dff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e06:	eb 15                	jmp    800e1d <strtol+0x44>
	else if (*s == '-')
  800e08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e0f:	3c 2d                	cmp    $0x2d,%al
  800e11:	75 0a                	jne    800e1d <strtol+0x44>
		s++, neg = 1;
  800e13:	8d 52 01             	lea    0x1(%edx),%edx
  800e16:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1d:	85 db                	test   %ebx,%ebx
  800e1f:	0f 94 c0             	sete   %al
  800e22:	74 05                	je     800e29 <strtol+0x50>
  800e24:	83 fb 10             	cmp    $0x10,%ebx
  800e27:	75 15                	jne    800e3e <strtol+0x65>
  800e29:	80 3a 30             	cmpb   $0x30,(%edx)
  800e2c:	75 10                	jne    800e3e <strtol+0x65>
  800e2e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e32:	75 0a                	jne    800e3e <strtol+0x65>
		s += 2, base = 16;
  800e34:	83 c2 02             	add    $0x2,%edx
  800e37:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e3c:	eb 13                	jmp    800e51 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e3e:	84 c0                	test   %al,%al
  800e40:	74 0f                	je     800e51 <strtol+0x78>
  800e42:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e47:	80 3a 30             	cmpb   $0x30,(%edx)
  800e4a:	75 05                	jne    800e51 <strtol+0x78>
		s++, base = 8;
  800e4c:	83 c2 01             	add    $0x1,%edx
  800e4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
  800e56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e58:	0f b6 0a             	movzbl (%edx),%ecx
  800e5b:	89 cf                	mov    %ecx,%edi
  800e5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e60:	80 fb 09             	cmp    $0x9,%bl
  800e63:	77 08                	ja     800e6d <strtol+0x94>
			dig = *s - '0';
  800e65:	0f be c9             	movsbl %cl,%ecx
  800e68:	83 e9 30             	sub    $0x30,%ecx
  800e6b:	eb 1e                	jmp    800e8b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800e6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800e70:	80 fb 19             	cmp    $0x19,%bl
  800e73:	77 08                	ja     800e7d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800e75:	0f be c9             	movsbl %cl,%ecx
  800e78:	83 e9 57             	sub    $0x57,%ecx
  800e7b:	eb 0e                	jmp    800e8b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800e7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800e80:	80 fb 19             	cmp    $0x19,%bl
  800e83:	77 15                	ja     800e9a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e85:	0f be c9             	movsbl %cl,%ecx
  800e88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e8b:	39 f1                	cmp    %esi,%ecx
  800e8d:	7d 0b                	jge    800e9a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e8f:	83 c2 01             	add    $0x1,%edx
  800e92:	0f af c6             	imul   %esi,%eax
  800e95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800e98:	eb be                	jmp    800e58 <strtol+0x7f>
  800e9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800e9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea0:	74 05                	je     800ea7 <strtol+0xce>
		*endptr = (char *) s;
  800ea2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ea5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ea7:	89 ca                	mov    %ecx,%edx
  800ea9:	f7 da                	neg    %edx
  800eab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eaf:	0f 45 c2             	cmovne %edx,%eax
}
  800eb2:	83 c4 04             	add    $0x4,%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
	...

00800ebc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	89 1c 24             	mov    %ebx,(%esp)
  800ec5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ec9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ed7:	89 d1                	mov    %edx,%ecx
  800ed9:	89 d3                	mov    %edx,%ebx
  800edb:	89 d7                	mov    %edx,%edi
  800edd:	89 d6                	mov    %edx,%esi
  800edf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ee1:	8b 1c 24             	mov    (%esp),%ebx
  800ee4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ee8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eec:	89 ec                	mov    %ebp,%esp
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	89 1c 24             	mov    %ebx,(%esp)
  800ef9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800efd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	89 c3                	mov    %eax,%ebx
  800f0e:	89 c7                	mov    %eax,%edi
  800f10:	89 c6                	mov    %eax,%esi
  800f12:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f14:	8b 1c 24             	mov    (%esp),%ebx
  800f17:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f1b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f1f:	89 ec                	mov    %ebp,%esp
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 0c             	sub    $0xc,%esp
  800f29:	89 1c 24             	mov    %ebx,(%esp)
  800f2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f30:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f34:	ba 00 00 00 00       	mov    $0x0,%edx
  800f39:	b8 10 00 00 00       	mov    $0x10,%eax
  800f3e:	89 d1                	mov    %edx,%ecx
  800f40:	89 d3                	mov    %edx,%ebx
  800f42:	89 d7                	mov    %edx,%edi
  800f44:	89 d6                	mov    %edx,%esi
  800f46:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f48:	8b 1c 24             	mov    (%esp),%ebx
  800f4b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f4f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f53:	89 ec                	mov    %ebp,%esp
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 38             	sub    $0x38,%esp
  800f5d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f60:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f63:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  800fa3:	e8 80 f3 ff ff       	call   800328 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800fa8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb1:	89 ec                	mov    %ebp,%esp
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 38             	sub    $0x38,%esp
  800fbb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fbe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	89 df                	mov    %ebx,%edi
  800fd6:	89 de                	mov    %ebx,%esi
  800fd8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	7e 28                	jle    801006 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800fe9:	00 
  800fea:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  800ff1:	00 
  800ff2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff9:	00 
  800ffa:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  801001:	e8 22 f3 ff ff       	call   800328 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801006:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801009:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100f:	89 ec                	mov    %ebp,%esp
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 38             	sub    $0x38,%esp
  801019:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801022:	b9 00 00 00 00       	mov    $0x0,%ecx
  801027:	b8 0d 00 00 00       	mov    $0xd,%eax
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	89 cb                	mov    %ecx,%ebx
  801031:	89 cf                	mov    %ecx,%edi
  801033:	89 ce                	mov    %ecx,%esi
  801035:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801037:	85 c0                	test   %eax,%eax
  801039:	7e 28                	jle    801063 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801046:	00 
  801047:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  80104e:	00 
  80104f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801056:	00 
  801057:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  80105e:	e8 c5 f2 ff ff       	call   800328 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801063:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801066:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801069:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106c:	89 ec                	mov    %ebp,%esp
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	89 1c 24             	mov    %ebx,(%esp)
  801079:	89 74 24 04          	mov    %esi,0x4(%esp)
  80107d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801081:	be 00 00 00 00       	mov    $0x0,%esi
  801086:	b8 0c 00 00 00       	mov    $0xc,%eax
  80108b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80108e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801091:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801094:	8b 55 08             	mov    0x8(%ebp),%edx
  801097:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801099:	8b 1c 24             	mov    (%esp),%ebx
  80109c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010a4:	89 ec                	mov    %ebp,%esp
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 38             	sub    $0x38,%esp
  8010ae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c7:	89 df                	mov    %ebx,%edi
  8010c9:	89 de                	mov    %ebx,%esi
  8010cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	7e 28                	jle    8010f9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010dc:	00 
  8010dd:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  8010e4:	00 
  8010e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ec:	00 
  8010ed:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  8010f4:	e8 2f f2 ff ff       	call   800328 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801102:	89 ec                	mov    %ebp,%esp
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 38             	sub    $0x38,%esp
  80110c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80110f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801112:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111a:	b8 09 00 00 00       	mov    $0x9,%eax
  80111f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	89 df                	mov    %ebx,%edi
  801127:	89 de                	mov    %ebx,%esi
  801129:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80112b:	85 c0                	test   %eax,%eax
  80112d:	7e 28                	jle    801157 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80112f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801133:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80113a:	00 
  80113b:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  801142:	00 
  801143:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80114a:	00 
  80114b:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  801152:	e8 d1 f1 ff ff       	call   800328 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801157:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80115a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80115d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801160:	89 ec                	mov    %ebp,%esp
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    

00801164 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 38             	sub    $0x38,%esp
  80116a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80116d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801170:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801173:	bb 00 00 00 00       	mov    $0x0,%ebx
  801178:	b8 08 00 00 00       	mov    $0x8,%eax
  80117d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801180:	8b 55 08             	mov    0x8(%ebp),%edx
  801183:	89 df                	mov    %ebx,%edi
  801185:	89 de                	mov    %ebx,%esi
  801187:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801189:	85 c0                	test   %eax,%eax
  80118b:	7e 28                	jle    8011b5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801191:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801198:	00 
  801199:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  8011a0:	00 
  8011a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a8:	00 
  8011a9:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  8011b0:	e8 73 f1 ff ff       	call   800328 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011b5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011b8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011bb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011be:	89 ec                	mov    %ebp,%esp
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    

008011c2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	83 ec 38             	sub    $0x38,%esp
  8011c8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011cb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ce:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8011db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011de:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e1:	89 df                	mov    %ebx,%edi
  8011e3:	89 de                	mov    %ebx,%esi
  8011e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	7e 28                	jle    801213 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ef:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011f6:	00 
  8011f7:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801206:	00 
  801207:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  80120e:	e8 15 f1 ff ff       	call   800328 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801213:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801216:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801219:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80121c:	89 ec                	mov    %ebp,%esp
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 38             	sub    $0x38,%esp
  801226:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801229:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80122c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80122f:	b8 05 00 00 00       	mov    $0x5,%eax
  801234:	8b 75 18             	mov    0x18(%ebp),%esi
  801237:	8b 7d 14             	mov    0x14(%ebp),%edi
  80123a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80123d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801245:	85 c0                	test   %eax,%eax
  801247:	7e 28                	jle    801271 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801249:	89 44 24 10          	mov    %eax,0x10(%esp)
  80124d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801254:	00 
  801255:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  80125c:	00 
  80125d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801264:	00 
  801265:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  80126c:	e8 b7 f0 ff ff       	call   800328 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801271:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801274:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801277:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127a:	89 ec                	mov    %ebp,%esp
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 38             	sub    $0x38,%esp
  801284:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801287:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80128a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128d:	be 00 00 00 00       	mov    $0x0,%esi
  801292:	b8 04 00 00 00       	mov    $0x4,%eax
  801297:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80129a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129d:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a0:	89 f7                	mov    %esi,%edi
  8012a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	7e 28                	jle    8012d0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ac:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c3:	00 
  8012c4:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  8012cb:	e8 58 f0 ff ff       	call   800328 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012d9:	89 ec                	mov    %ebp,%esp
  8012db:	5d                   	pop    %ebp
  8012dc:	c3                   	ret    

008012dd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	89 1c 24             	mov    %ebx,(%esp)
  8012e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012f8:	89 d1                	mov    %edx,%ecx
  8012fa:	89 d3                	mov    %edx,%ebx
  8012fc:	89 d7                	mov    %edx,%edi
  8012fe:	89 d6                	mov    %edx,%esi
  801300:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801302:	8b 1c 24             	mov    (%esp),%ebx
  801305:	8b 74 24 04          	mov    0x4(%esp),%esi
  801309:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80130d:	89 ec                	mov    %ebp,%esp
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    

00801311 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	89 1c 24             	mov    %ebx,(%esp)
  80131a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801322:	ba 00 00 00 00       	mov    $0x0,%edx
  801327:	b8 02 00 00 00       	mov    $0x2,%eax
  80132c:	89 d1                	mov    %edx,%ecx
  80132e:	89 d3                	mov    %edx,%ebx
  801330:	89 d7                	mov    %edx,%edi
  801332:	89 d6                	mov    %edx,%esi
  801334:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801336:	8b 1c 24             	mov    (%esp),%ebx
  801339:	8b 74 24 04          	mov    0x4(%esp),%esi
  80133d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801341:	89 ec                	mov    %ebp,%esp
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 38             	sub    $0x38,%esp
  80134b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80134e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801351:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801354:	b9 00 00 00 00       	mov    $0x0,%ecx
  801359:	b8 03 00 00 00       	mov    $0x3,%eax
  80135e:	8b 55 08             	mov    0x8(%ebp),%edx
  801361:	89 cb                	mov    %ecx,%ebx
  801363:	89 cf                	mov    %ecx,%edi
  801365:	89 ce                	mov    %ecx,%esi
  801367:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801369:	85 c0                	test   %eax,%eax
  80136b:	7e 28                	jle    801395 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80136d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801371:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801378:	00 
  801379:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  801380:	00 
  801381:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801388:	00 
  801389:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  801390:	e8 93 ef ff ff       	call   800328 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801395:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801398:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80139b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80139e:	89 ec                	mov    %ebp,%esp
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    
	...

008013a4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8013af:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	89 04 24             	mov    %eax,(%esp)
  8013c0:	e8 df ff ff ff       	call   8013a4 <fd2num>
  8013c5:	05 20 00 0d 00       	add    $0xd0020,%eax
  8013ca:	c1 e0 0c             	shl    $0xc,%eax
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	57                   	push   %edi
  8013d3:	56                   	push   %esi
  8013d4:	53                   	push   %ebx
  8013d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013d8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013dd:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8013e2:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013e7:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013e9:	89 c2                	mov    %eax,%edx
  8013eb:	c1 ea 16             	shr    $0x16,%edx
  8013ee:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8013f1:	f6 c2 01             	test   $0x1,%dl
  8013f4:	74 0d                	je     801403 <fd_alloc+0x34>
  8013f6:	89 c2                	mov    %eax,%edx
  8013f8:	c1 ea 0c             	shr    $0xc,%edx
  8013fb:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8013fe:	f6 c2 01             	test   $0x1,%dl
  801401:	75 09                	jne    80140c <fd_alloc+0x3d>
			*fd_store = fd;
  801403:	89 37                	mov    %esi,(%edi)
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80140a:	eb 17                	jmp    801423 <fd_alloc+0x54>
  80140c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801411:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801416:	75 cf                	jne    8013e7 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801418:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  80141e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801423:	5b                   	pop    %ebx
  801424:	5e                   	pop    %esi
  801425:	5f                   	pop    %edi
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    

00801428 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	83 f8 1f             	cmp    $0x1f,%eax
  801431:	77 36                	ja     801469 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801433:	05 00 00 0d 00       	add    $0xd0000,%eax
  801438:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80143b:	89 c2                	mov    %eax,%edx
  80143d:	c1 ea 16             	shr    $0x16,%edx
  801440:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801447:	f6 c2 01             	test   $0x1,%dl
  80144a:	74 1d                	je     801469 <fd_lookup+0x41>
  80144c:	89 c2                	mov    %eax,%edx
  80144e:	c1 ea 0c             	shr    $0xc,%edx
  801451:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801458:	f6 c2 01             	test   $0x1,%dl
  80145b:	74 0c                	je     801469 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80145d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801460:	89 02                	mov    %eax,(%edx)
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801467:	eb 05                	jmp    80146e <fd_lookup+0x46>
  801469:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801476:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	89 04 24             	mov    %eax,(%esp)
  801483:	e8 a0 ff ff ff       	call   801428 <fd_lookup>
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 0e                	js     80149a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80148c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801492:	89 50 04             	mov    %edx,0x4(%eax)
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
  8014a1:	83 ec 10             	sub    $0x10,%esp
  8014a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014aa:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014af:	be 24 2f 80 00       	mov    $0x802f24,%esi
  8014b4:	eb 10                	jmp    8014c6 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8014b6:	39 08                	cmp    %ecx,(%eax)
  8014b8:	75 09                	jne    8014c3 <dev_lookup+0x27>
			*dev = devtab[i];
  8014ba:	89 03                	mov    %eax,(%ebx)
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8014c1:	eb 31                	jmp    8014f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014c3:	83 c2 01             	add    $0x1,%edx
  8014c6:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	75 e9                	jne    8014b6 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014cd:	a1 08 54 80 00       	mov    0x805408,%eax
  8014d2:	8b 40 48             	mov    0x48(%eax),%eax
  8014d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014dd:	c7 04 24 a4 2e 80 00 	movl   $0x802ea4,(%esp)
  8014e4:	e8 f8 ee ff ff       	call   8003e1 <cprintf>
	*dev = 0;
  8014e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    

008014fb <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	53                   	push   %ebx
  8014ff:	83 ec 24             	sub    $0x24,%esp
  801502:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801505:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	89 04 24             	mov    %eax,(%esp)
  801512:	e8 11 ff ff ff       	call   801428 <fd_lookup>
  801517:	85 c0                	test   %eax,%eax
  801519:	78 53                	js     80156e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	e8 6d ff ff ff       	call   80149c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 3b                	js     80156e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801533:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801538:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80153f:	74 2d                	je     80156e <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801541:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801544:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80154b:	00 00 00 
	stat->st_isdir = 0;
  80154e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801555:	00 00 00 
	stat->st_dev = dev;
  801558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801561:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801565:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801568:	89 14 24             	mov    %edx,(%esp)
  80156b:	ff 50 14             	call   *0x14(%eax)
}
  80156e:	83 c4 24             	add    $0x24,%esp
  801571:	5b                   	pop    %ebx
  801572:	5d                   	pop    %ebp
  801573:	c3                   	ret    

00801574 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	53                   	push   %ebx
  801578:	83 ec 24             	sub    $0x24,%esp
  80157b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801581:	89 44 24 04          	mov    %eax,0x4(%esp)
  801585:	89 1c 24             	mov    %ebx,(%esp)
  801588:	e8 9b fe ff ff       	call   801428 <fd_lookup>
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 5f                	js     8015f0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801591:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801594:	89 44 24 04          	mov    %eax,0x4(%esp)
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	89 04 24             	mov    %eax,(%esp)
  8015a0:	e8 f7 fe ff ff       	call   80149c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 47                	js     8015f0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ac:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8015b0:	75 23                	jne    8015d5 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015b2:	a1 08 54 80 00       	mov    0x805408,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015b7:	8b 40 48             	mov    0x48(%eax),%eax
  8015ba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c2:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  8015c9:	e8 13 ee ff ff       	call   8003e1 <cprintf>
  8015ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015d3:	eb 1b                	jmp    8015f0 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8015d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d8:	8b 48 18             	mov    0x18(%eax),%ecx
  8015db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e0:	85 c9                	test   %ecx,%ecx
  8015e2:	74 0c                	je     8015f0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015eb:	89 14 24             	mov    %edx,(%esp)
  8015ee:	ff d1                	call   *%ecx
}
  8015f0:	83 c4 24             	add    $0x24,%esp
  8015f3:	5b                   	pop    %ebx
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 24             	sub    $0x24,%esp
  8015fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801600:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801603:	89 44 24 04          	mov    %eax,0x4(%esp)
  801607:	89 1c 24             	mov    %ebx,(%esp)
  80160a:	e8 19 fe ff ff       	call   801428 <fd_lookup>
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 66                	js     801679 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161d:	8b 00                	mov    (%eax),%eax
  80161f:	89 04 24             	mov    %eax,(%esp)
  801622:	e8 75 fe ff ff       	call   80149c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801627:	85 c0                	test   %eax,%eax
  801629:	78 4e                	js     801679 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80162b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80162e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801632:	75 23                	jne    801657 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801634:	a1 08 54 80 00       	mov    0x805408,%eax
  801639:	8b 40 48             	mov    0x48(%eax),%eax
  80163c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801640:	89 44 24 04          	mov    %eax,0x4(%esp)
  801644:	c7 04 24 e8 2e 80 00 	movl   $0x802ee8,(%esp)
  80164b:	e8 91 ed ff ff       	call   8003e1 <cprintf>
  801650:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801655:	eb 22                	jmp    801679 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80165d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801662:	85 c9                	test   %ecx,%ecx
  801664:	74 13                	je     801679 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	89 44 24 08          	mov    %eax,0x8(%esp)
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801670:	89 44 24 04          	mov    %eax,0x4(%esp)
  801674:	89 14 24             	mov    %edx,(%esp)
  801677:	ff d1                	call   *%ecx
}
  801679:	83 c4 24             	add    $0x24,%esp
  80167c:	5b                   	pop    %ebx
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	53                   	push   %ebx
  801683:	83 ec 24             	sub    $0x24,%esp
  801686:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801689:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801690:	89 1c 24             	mov    %ebx,(%esp)
  801693:	e8 90 fd ff ff       	call   801428 <fd_lookup>
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 6b                	js     801707 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a6:	8b 00                	mov    (%eax),%eax
  8016a8:	89 04 24             	mov    %eax,(%esp)
  8016ab:	e8 ec fd ff ff       	call   80149c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 53                	js     801707 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b7:	8b 42 08             	mov    0x8(%edx),%eax
  8016ba:	83 e0 03             	and    $0x3,%eax
  8016bd:	83 f8 01             	cmp    $0x1,%eax
  8016c0:	75 23                	jne    8016e5 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c2:	a1 08 54 80 00       	mov    0x805408,%eax
  8016c7:	8b 40 48             	mov    0x48(%eax),%eax
  8016ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d2:	c7 04 24 05 2f 80 00 	movl   $0x802f05,(%esp)
  8016d9:	e8 03 ed ff ff       	call   8003e1 <cprintf>
  8016de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8016e3:	eb 22                	jmp    801707 <read+0x88>
	}
	if (!dev->dev_read)
  8016e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8016eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f0:	85 c9                	test   %ecx,%ecx
  8016f2:	74 13                	je     801707 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801702:	89 14 24             	mov    %edx,(%esp)
  801705:	ff d1                	call   *%ecx
}
  801707:	83 c4 24             	add    $0x24,%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	57                   	push   %edi
  801711:	56                   	push   %esi
  801712:	53                   	push   %ebx
  801713:	83 ec 1c             	sub    $0x1c,%esp
  801716:	8b 7d 08             	mov    0x8(%ebp),%edi
  801719:	8b 75 10             	mov    0x10(%ebp),%esi
  80171c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801721:	eb 21                	jmp    801744 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801723:	89 f2                	mov    %esi,%edx
  801725:	29 c2                	sub    %eax,%edx
  801727:	89 54 24 08          	mov    %edx,0x8(%esp)
  80172b:	03 45 0c             	add    0xc(%ebp),%eax
  80172e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801732:	89 3c 24             	mov    %edi,(%esp)
  801735:	e8 45 ff ff ff       	call   80167f <read>
		if (m < 0)
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 0e                	js     80174c <readn+0x3f>
			return m;
		if (m == 0)
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 08                	je     80174a <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801742:	01 c3                	add    %eax,%ebx
  801744:	89 d8                	mov    %ebx,%eax
  801746:	39 f3                	cmp    %esi,%ebx
  801748:	72 d9                	jb     801723 <readn+0x16>
  80174a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80174c:	83 c4 1c             	add    $0x1c,%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 38             	sub    $0x38,%esp
  80175a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80175d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801760:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801763:	8b 7d 08             	mov    0x8(%ebp),%edi
  801766:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80176a:	89 3c 24             	mov    %edi,(%esp)
  80176d:	e8 32 fc ff ff       	call   8013a4 <fd2num>
  801772:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801775:	89 54 24 04          	mov    %edx,0x4(%esp)
  801779:	89 04 24             	mov    %eax,(%esp)
  80177c:	e8 a7 fc ff ff       	call   801428 <fd_lookup>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	85 c0                	test   %eax,%eax
  801785:	78 05                	js     80178c <fd_close+0x38>
  801787:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  80178a:	74 0e                	je     80179a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80178c:	89 f0                	mov    %esi,%eax
  80178e:	84 c0                	test   %al,%al
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	0f 44 d8             	cmove  %eax,%ebx
  801798:	eb 3d                	jmp    8017d7 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80179a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80179d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a1:	8b 07                	mov    (%edi),%eax
  8017a3:	89 04 24             	mov    %eax,(%esp)
  8017a6:	e8 f1 fc ff ff       	call   80149c <dev_lookup>
  8017ab:	89 c3                	mov    %eax,%ebx
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 16                	js     8017c7 <fd_close+0x73>
		if (dev->dev_close)
  8017b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b4:	8b 40 10             	mov    0x10(%eax),%eax
  8017b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	74 07                	je     8017c7 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8017c0:	89 3c 24             	mov    %edi,(%esp)
  8017c3:	ff d0                	call   *%eax
  8017c5:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8017c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d2:	e8 eb f9 ff ff       	call   8011c2 <sys_page_unmap>
	return r;
}
  8017d7:	89 d8                	mov    %ebx,%eax
  8017d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017e2:	89 ec                	mov    %ebp,%esp
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	89 04 24             	mov    %eax,(%esp)
  8017f9:	e8 2a fc ff ff       	call   801428 <fd_lookup>
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 13                	js     801815 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801809:	00 
  80180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180d:	89 04 24             	mov    %eax,(%esp)
  801810:	e8 3f ff ff ff       	call   801754 <fd_close>
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 18             	sub    $0x18,%esp
  80181d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801820:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801823:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80182a:	00 
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	89 04 24             	mov    %eax,(%esp)
  801831:	e8 25 04 00 00       	call   801c5b <open>
  801836:	89 c3                	mov    %eax,%ebx
  801838:	85 c0                	test   %eax,%eax
  80183a:	78 1b                	js     801857 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80183c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801843:	89 1c 24             	mov    %ebx,(%esp)
  801846:	e8 b0 fc ff ff       	call   8014fb <fstat>
  80184b:	89 c6                	mov    %eax,%esi
	close(fd);
  80184d:	89 1c 24             	mov    %ebx,(%esp)
  801850:	e8 91 ff ff ff       	call   8017e6 <close>
  801855:	89 f3                	mov    %esi,%ebx
	return r;
}
  801857:	89 d8                	mov    %ebx,%eax
  801859:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80185c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80185f:	89 ec                	mov    %ebp,%esp
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	83 ec 14             	sub    $0x14,%esp
  80186a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  80186f:	89 1c 24             	mov    %ebx,(%esp)
  801872:	e8 6f ff ff ff       	call   8017e6 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801877:	83 c3 01             	add    $0x1,%ebx
  80187a:	83 fb 20             	cmp    $0x20,%ebx
  80187d:	75 f0                	jne    80186f <close_all+0xc>
		close(i);
}
  80187f:	83 c4 14             	add    $0x14,%esp
  801882:	5b                   	pop    %ebx
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 58             	sub    $0x58,%esp
  80188b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80188e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801891:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801894:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801897:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80189a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 04 24             	mov    %eax,(%esp)
  8018a4:	e8 7f fb ff ff       	call   801428 <fd_lookup>
  8018a9:	89 c3                	mov    %eax,%ebx
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	0f 88 e0 00 00 00    	js     801993 <dup+0x10e>
		return r;
	close(newfdnum);
  8018b3:	89 3c 24             	mov    %edi,(%esp)
  8018b6:	e8 2b ff ff ff       	call   8017e6 <close>

	newfd = INDEX2FD(newfdnum);
  8018bb:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8018c1:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8018c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c7:	89 04 24             	mov    %eax,(%esp)
  8018ca:	e8 e5 fa ff ff       	call   8013b4 <fd2data>
  8018cf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018d1:	89 34 24             	mov    %esi,(%esp)
  8018d4:	e8 db fa ff ff       	call   8013b4 <fd2data>
  8018d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018dc:	89 da                	mov    %ebx,%edx
  8018de:	89 d8                	mov    %ebx,%eax
  8018e0:	c1 e8 16             	shr    $0x16,%eax
  8018e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018ea:	a8 01                	test   $0x1,%al
  8018ec:	74 43                	je     801931 <dup+0xac>
  8018ee:	c1 ea 0c             	shr    $0xc,%edx
  8018f1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8018f8:	a8 01                	test   $0x1,%al
  8018fa:	74 35                	je     801931 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018fc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801903:	25 07 0e 00 00       	and    $0xe07,%eax
  801908:	89 44 24 10          	mov    %eax,0x10(%esp)
  80190c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80190f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801913:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80191a:	00 
  80191b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80191f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801926:	e8 f5 f8 ff ff       	call   801220 <sys_page_map>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 3f                	js     801970 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801934:	89 c2                	mov    %eax,%edx
  801936:	c1 ea 0c             	shr    $0xc,%edx
  801939:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801940:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801946:	89 54 24 10          	mov    %edx,0x10(%esp)
  80194a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80194e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801955:	00 
  801956:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801961:	e8 ba f8 ff ff       	call   801220 <sys_page_map>
  801966:	89 c3                	mov    %eax,%ebx
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 04                	js     801970 <dup+0xeb>
  80196c:	89 fb                	mov    %edi,%ebx
  80196e:	eb 23                	jmp    801993 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801970:	89 74 24 04          	mov    %esi,0x4(%esp)
  801974:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197b:	e8 42 f8 ff ff       	call   8011c2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801980:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198e:	e8 2f f8 ff ff       	call   8011c2 <sys_page_unmap>
	return r;
}
  801993:	89 d8                	mov    %ebx,%eax
  801995:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801998:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80199b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80199e:	89 ec                	mov    %ebp,%esp
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    
	...

008019a4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	56                   	push   %esi
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 10             	sub    $0x10,%esp
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8019b0:	83 3d 00 54 80 00 00 	cmpl   $0x0,0x805400
  8019b7:	75 11                	jne    8019ca <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019c0:	e8 03 0d 00 00       	call   8026c8 <ipc_find_env>
  8019c5:	a3 00 54 80 00       	mov    %eax,0x805400

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8019ca:	a1 08 54 80 00       	mov    0x805408,%eax
  8019cf:	8b 40 48             	mov    0x48(%eax),%eax
  8019d2:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8019d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e4:	c7 04 24 38 2f 80 00 	movl   $0x802f38,(%esp)
  8019eb:	e8 f1 e9 ff ff       	call   8003e1 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019f0:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019f7:	00 
  8019f8:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019ff:	00 
  801a00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a04:	a1 00 54 80 00       	mov    0x805400,%eax
  801a09:	89 04 24             	mov    %eax,(%esp)
  801a0c:	e8 ed 0c 00 00       	call   8026fe <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a18:	00 
  801a19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a24:	e8 41 0d 00 00       	call   80276a <ipc_recv>
}
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a49:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801a53:	e8 4c ff ff ff       	call   8019a4 <fsipc>
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8b 40 0c             	mov    0xc(%eax),%eax
  801a66:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	b8 06 00 00 00       	mov    $0x6,%eax
  801a75:	e8 2a ff ff ff       	call   8019a4 <fsipc>
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	b8 08 00 00 00       	mov    $0x8,%eax
  801a8c:	e8 13 ff ff ff       	call   8019a4 <fsipc>
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	53                   	push   %ebx
  801a97:	83 ec 14             	sub    $0x14,%esp
  801a9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  801aad:	b8 05 00 00 00       	mov    $0x5,%eax
  801ab2:	e8 ed fe ff ff       	call   8019a4 <fsipc>
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 2b                	js     801ae6 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801abb:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ac2:	00 
  801ac3:	89 1c 24             	mov    %ebx,(%esp)
  801ac6:	e8 6e f0 ff ff       	call   800b39 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801acb:	a1 80 60 80 00       	mov    0x806080,%eax
  801ad0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ad6:	a1 84 60 80 00       	mov    0x806084,%eax
  801adb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801ae6:	83 c4 14             	add    $0x14,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	53                   	push   %ebx
  801af0:	83 ec 14             	sub    $0x14,%esp
  801af3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	8b 40 0c             	mov    0xc(%eax),%eax
  801afc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b01:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801b07:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801b0d:	76 24                	jbe    801b33 <devfile_write+0x47>
  801b0f:	c7 44 24 0c 4e 2f 80 	movl   $0x802f4e,0xc(%esp)
  801b16:	00 
  801b17:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  801b1e:	00 
  801b1f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801b26:	00 
  801b27:	c7 04 24 6d 2f 80 00 	movl   $0x802f6d,(%esp)
  801b2e:	e8 f5 e7 ff ff       	call   800328 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801b33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3e:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b45:	e8 95 f1 ff ff       	call   800cdf <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	b8 04 00 00 00       	mov    $0x4,%eax
  801b54:	e8 4b fe ff ff       	call   8019a4 <fsipc>
	if(ret<0) return ret;
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	78 53                	js     801bb0 <devfile_write+0xc4>
	
	assert(ret <= n);
  801b5d:	39 c3                	cmp    %eax,%ebx
  801b5f:	73 24                	jae    801b85 <devfile_write+0x99>
  801b61:	c7 44 24 0c 78 2f 80 	movl   $0x802f78,0xc(%esp)
  801b68:	00 
  801b69:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  801b70:	00 
  801b71:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801b78:	00 
  801b79:	c7 04 24 6d 2f 80 00 	movl   $0x802f6d,(%esp)
  801b80:	e8 a3 e7 ff ff       	call   800328 <_panic>
	assert(ret <= PGSIZE);
  801b85:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b8a:	7e 24                	jle    801bb0 <devfile_write+0xc4>
  801b8c:	c7 44 24 0c 81 2f 80 	movl   $0x802f81,0xc(%esp)
  801b93:	00 
  801b94:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  801b9b:	00 
  801b9c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801ba3:	00 
  801ba4:	c7 04 24 6d 2f 80 00 	movl   $0x802f6d,(%esp)
  801bab:	e8 78 e7 ff ff       	call   800328 <_panic>
	return ret;
}
  801bb0:	83 c4 14             	add    $0x14,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5d                   	pop    %ebp
  801bb5:	c3                   	ret    

00801bb6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	56                   	push   %esi
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 10             	sub    $0x10,%esp
  801bbe:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bcc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 03 00 00 00       	mov    $0x3,%eax
  801bdc:	e8 c3 fd ff ff       	call   8019a4 <fsipc>
  801be1:	89 c3                	mov    %eax,%ebx
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 6b                	js     801c52 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801be7:	39 de                	cmp    %ebx,%esi
  801be9:	73 24                	jae    801c0f <devfile_read+0x59>
  801beb:	c7 44 24 0c 8f 2f 80 	movl   $0x802f8f,0xc(%esp)
  801bf2:	00 
  801bf3:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  801bfa:	00 
  801bfb:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c02:	00 
  801c03:	c7 04 24 6d 2f 80 00 	movl   $0x802f6d,(%esp)
  801c0a:	e8 19 e7 ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  801c0f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801c15:	7e 24                	jle    801c3b <devfile_read+0x85>
  801c17:	c7 44 24 0c 96 2f 80 	movl   $0x802f96,0xc(%esp)
  801c1e:	00 
  801c1f:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  801c26:	00 
  801c27:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c2e:	00 
  801c2f:	c7 04 24 6d 2f 80 00 	movl   $0x802f6d,(%esp)
  801c36:	e8 ed e6 ff ff       	call   800328 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c46:	00 
  801c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4a:	89 04 24             	mov    %eax,(%esp)
  801c4d:	e8 8d f0 ff ff       	call   800cdf <memmove>
	return r;
}
  801c52:	89 d8                	mov    %ebx,%eax
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    

00801c5b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 28             	sub    $0x28,%esp
  801c61:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c64:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c67:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c6a:	89 34 24             	mov    %esi,(%esp)
  801c6d:	e8 8e ee ff ff       	call   800b00 <strlen>
  801c72:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c77:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c7c:	7f 5e                	jg     801cdc <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c81:	89 04 24             	mov    %eax,(%esp)
  801c84:	e8 46 f7 ff ff       	call   8013cf <fd_alloc>
  801c89:	89 c3                	mov    %eax,%ebx
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	78 4d                	js     801cdc <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c93:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c9a:	e8 9a ee ff ff       	call   800b39 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	e8 f0 fc ff ff       	call   8019a4 <fsipc>
  801cb4:	89 c3                	mov    %eax,%ebx
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	79 15                	jns    801ccf <open+0x74>
		fd_close(fd, 0);
  801cba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cc1:	00 
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	89 04 24             	mov    %eax,(%esp)
  801cc8:	e8 87 fa ff ff       	call   801754 <fd_close>
		return r;
  801ccd:	eb 0d                	jmp    801cdc <open+0x81>
	}

	return fd2num(fd);
  801ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 ca f6 ff ff       	call   8013a4 <fd2num>
  801cda:	89 c3                	mov    %eax,%ebx
}
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ce1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ce4:	89 ec                	mov    %ebp,%esp
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    

00801ce8 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	53                   	push   %ebx
  801cec:	83 ec 14             	sub    $0x14,%esp
  801cef:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801cf1:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801cf5:	7e 31                	jle    801d28 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801cf7:	8b 40 04             	mov    0x4(%eax),%eax
  801cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cfe:	8d 43 10             	lea    0x10(%ebx),%eax
  801d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d05:	8b 03                	mov    (%ebx),%eax
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	e8 e7 f8 ff ff       	call   8015f6 <write>
		if (result > 0)
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	7e 03                	jle    801d16 <writebuf+0x2e>
			b->result += result;
  801d13:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801d16:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d19:	74 0d                	je     801d28 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d22:	0f 4f c2             	cmovg  %edx,%eax
  801d25:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d28:	83 c4 14             	add    $0x14,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801d40:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801d47:	00 00 00 
	b.result = 0;
  801d4a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d51:	00 00 00 
	b.error = 1;
  801d54:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801d5b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d61:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d6c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d76:	c7 04 24 ea 1d 80 00 	movl   $0x801dea,(%esp)
  801d7d:	e8 fd e7 ff ff       	call   80057f <vprintfmt>
	if (b.idx > 0)
  801d82:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801d89:	7e 0b                	jle    801d96 <vfprintf+0x68>
		writebuf(&b);
  801d8b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d91:	e8 52 ff ff ff       	call   801ce8 <writebuf>

	return (b.result ? b.result : b.error);
  801d96:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801dad:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801db0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801dc2:	e8 67 ff ff ff       	call   801d2e <vfprintf>
	va_end(ap);

	return cnt;
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801dcf:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	89 04 24             	mov    %eax,(%esp)
  801de3:	e8 46 ff ff ff       	call   801d2e <vfprintf>
	va_end(ap);

	return cnt;
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	53                   	push   %ebx
  801dee:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801df1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801df4:	8b 43 04             	mov    0x4(%ebx),%eax
  801df7:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfa:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801dfe:	83 c0 01             	add    $0x1,%eax
  801e01:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801e04:	3d 00 01 00 00       	cmp    $0x100,%eax
  801e09:	75 0e                	jne    801e19 <putch+0x2f>
		writebuf(b);
  801e0b:	89 d8                	mov    %ebx,%eax
  801e0d:	e8 d6 fe ff ff       	call   801ce8 <writebuf>
		b->idx = 0;
  801e12:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801e19:	83 c4 04             	add    $0x4,%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    
	...

00801e20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e26:	c7 44 24 04 a2 2f 80 	movl   $0x802fa2,0x4(%esp)
  801e2d:	00 
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	89 04 24             	mov    %eax,(%esp)
  801e34:	e8 00 ed ff ff       	call   800b39 <strcpy>
	return 0;
}
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	53                   	push   %ebx
  801e44:	83 ec 14             	sub    $0x14,%esp
  801e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e4a:	89 1c 24             	mov    %ebx,(%esp)
  801e4d:	e8 a2 09 00 00       	call   8027f4 <pageref>
  801e52:	89 c2                	mov    %eax,%edx
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	83 fa 01             	cmp    $0x1,%edx
  801e5c:	75 0b                	jne    801e69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e5e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e61:	89 04 24             	mov    %eax,(%esp)
  801e64:	e8 b1 02 00 00       	call   80211a <nsipc_close>
	else
		return 0;
}
  801e69:	83 c4 14             	add    $0x14,%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e75:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e7c:	00 
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 bd 02 00 00       	call   802156 <nsipc_send>
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ea1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ea8:	00 
  801ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebd:	89 04 24             	mov    %eax,(%esp)
  801ec0:	e8 04 03 00 00       	call   8021c9 <nsipc_recv>
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
  801ecc:	83 ec 20             	sub    $0x20,%esp
  801ecf:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ed1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed4:	89 04 24             	mov    %eax,(%esp)
  801ed7:	e8 f3 f4 ff ff       	call   8013cf <fd_alloc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 21                	js     801f03 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ee2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee9:	00 
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef8:	e8 81 f3 ff ff       	call   80127e <sys_page_alloc>
  801efd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801eff:	85 c0                	test   %eax,%eax
  801f01:	79 0a                	jns    801f0d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801f03:	89 34 24             	mov    %esi,(%esp)
  801f06:	e8 0f 02 00 00       	call   80211a <nsipc_close>
		return r;
  801f0b:	eb 28                	jmp    801f35 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f0d:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	89 04 24             	mov    %eax,(%esp)
  801f2e:	e8 71 f4 ff ff       	call   8013a4 <fd2num>
  801f33:	89 c3                	mov    %eax,%ebx
}
  801f35:	89 d8                	mov    %ebx,%eax
  801f37:	83 c4 20             	add    $0x20,%esp
  801f3a:	5b                   	pop    %ebx
  801f3b:	5e                   	pop    %esi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    

00801f3e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f44:	8b 45 10             	mov    0x10(%ebp),%eax
  801f47:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	89 04 24             	mov    %eax,(%esp)
  801f58:	e8 71 01 00 00       	call   8020ce <nsipc_socket>
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	78 05                	js     801f66 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801f61:	e8 61 ff ff ff       	call   801ec7 <alloc_sockfd>
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f6e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f75:	89 04 24             	mov    %eax,(%esp)
  801f78:	e8 ab f4 ff ff       	call   801428 <fd_lookup>
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 15                	js     801f96 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f84:	8b 0a                	mov    (%edx),%ecx
  801f86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f8b:	3b 0d 3c 40 80 00    	cmp    0x80403c,%ecx
  801f91:	75 03                	jne    801f96 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f93:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	e8 c2 ff ff ff       	call   801f68 <fd2sockid>
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	78 0f                	js     801fb9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fad:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fb1:	89 04 24             	mov    %eax,(%esp)
  801fb4:	e8 3f 01 00 00       	call   8020f8 <nsipc_listen>
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc4:	e8 9f ff ff ff       	call   801f68 <fd2sockid>
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	78 16                	js     801fe3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801fcd:	8b 55 10             	mov    0x10(%ebp),%edx
  801fd0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fdb:	89 04 24             	mov    %eax,(%esp)
  801fde:	e8 66 02 00 00       	call   802249 <nsipc_connect>
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	e8 75 ff ff ff       	call   801f68 <fd2sockid>
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 0f                	js     802006 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ffe:	89 04 24             	mov    %eax,(%esp)
  802001:	e8 2e 01 00 00       	call   802134 <nsipc_shutdown>
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	e8 52 ff ff ff       	call   801f68 <fd2sockid>
  802016:	85 c0                	test   %eax,%eax
  802018:	78 16                	js     802030 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80201a:	8b 55 10             	mov    0x10(%ebp),%edx
  80201d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	89 54 24 04          	mov    %edx,0x4(%esp)
  802028:	89 04 24             	mov    %eax,(%esp)
  80202b:	e8 58 02 00 00       	call   802288 <nsipc_bind>
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	e8 28 ff ff ff       	call   801f68 <fd2sockid>
  802040:	85 c0                	test   %eax,%eax
  802042:	78 1f                	js     802063 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802044:	8b 55 10             	mov    0x10(%ebp),%edx
  802047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802052:	89 04 24             	mov    %eax,(%esp)
  802055:	e8 6d 02 00 00       	call   8022c7 <nsipc_accept>
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 05                	js     802063 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80205e:	e8 64 fe ff ff       	call   801ec7 <alloc_sockfd>
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    
  802065:	00 00                	add    %al,(%eax)
	...

00802068 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	53                   	push   %ebx
  80206c:	83 ec 14             	sub    $0x14,%esp
  80206f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802071:	83 3d 04 54 80 00 00 	cmpl   $0x0,0x805404
  802078:	75 11                	jne    80208b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80207a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802081:	e8 42 06 00 00       	call   8026c8 <ipc_find_env>
  802086:	a3 04 54 80 00       	mov    %eax,0x805404
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80208b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802092:	00 
  802093:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80209a:	00 
  80209b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80209f:	a1 04 54 80 00       	mov    0x805404,%eax
  8020a4:	89 04 24             	mov    %eax,(%esp)
  8020a7:	e8 52 06 00 00       	call   8026fe <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020b3:	00 
  8020b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020bb:	00 
  8020bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c3:	e8 a2 06 00 00       	call   80276a <ipc_recv>
}
  8020c8:	83 c4 14             	add    $0x14,%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020df:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8020e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8020ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8020f1:	e8 72 ff ff ff       	call   802068 <nsipc>
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802106:	8b 45 0c             	mov    0xc(%ebp),%eax
  802109:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80210e:	b8 06 00 00 00       	mov    $0x6,%eax
  802113:	e8 50 ff ff ff       	call   802068 <nsipc>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802128:	b8 04 00 00 00       	mov    $0x4,%eax
  80212d:	e8 36 ff ff ff       	call   802068 <nsipc>
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802142:	8b 45 0c             	mov    0xc(%ebp),%eax
  802145:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80214a:	b8 03 00 00 00       	mov    $0x3,%eax
  80214f:	e8 14 ff ff ff       	call   802068 <nsipc>
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	53                   	push   %ebx
  80215a:	83 ec 14             	sub    $0x14,%esp
  80215d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802168:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80216e:	7e 24                	jle    802194 <nsipc_send+0x3e>
  802170:	c7 44 24 0c ae 2f 80 	movl   $0x802fae,0xc(%esp)
  802177:	00 
  802178:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  80217f:	00 
  802180:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802187:	00 
  802188:	c7 04 24 ba 2f 80 00 	movl   $0x802fba,(%esp)
  80218f:	e8 94 e1 ff ff       	call   800328 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802194:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8021a6:	e8 34 eb ff ff       	call   800cdf <memmove>
	nsipcbuf.send.req_size = size;
  8021ab:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8021b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b4:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8021b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8021be:	e8 a5 fe ff ff       	call   802068 <nsipc>
}
  8021c3:	83 c4 14             	add    $0x14,%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	56                   	push   %esi
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 10             	sub    $0x10,%esp
  8021d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8021dc:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8021e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021ea:	b8 07 00 00 00       	mov    $0x7,%eax
  8021ef:	e8 74 fe ff ff       	call   802068 <nsipc>
  8021f4:	89 c3                	mov    %eax,%ebx
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 46                	js     802240 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021fa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021ff:	7f 04                	jg     802205 <nsipc_recv+0x3c>
  802201:	39 c6                	cmp    %eax,%esi
  802203:	7d 24                	jge    802229 <nsipc_recv+0x60>
  802205:	c7 44 24 0c c6 2f 80 	movl   $0x802fc6,0xc(%esp)
  80220c:	00 
  80220d:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  802214:	00 
  802215:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80221c:	00 
  80221d:	c7 04 24 ba 2f 80 00 	movl   $0x802fba,(%esp)
  802224:	e8 ff e0 ff ff       	call   800328 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802229:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802234:	00 
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	89 04 24             	mov    %eax,(%esp)
  80223b:	e8 9f ea ff ff       	call   800cdf <memmove>
	}

	return r;
}
  802240:	89 d8                	mov    %ebx,%eax
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    

00802249 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	53                   	push   %ebx
  80224d:	83 ec 14             	sub    $0x14,%esp
  802250:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80225b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80225f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802262:	89 44 24 04          	mov    %eax,0x4(%esp)
  802266:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80226d:	e8 6d ea ff ff       	call   800cdf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802272:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802278:	b8 05 00 00 00       	mov    $0x5,%eax
  80227d:	e8 e6 fd ff ff       	call   802068 <nsipc>
}
  802282:	83 c4 14             	add    $0x14,%esp
  802285:	5b                   	pop    %ebx
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    

00802288 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	53                   	push   %ebx
  80228c:	83 ec 14             	sub    $0x14,%esp
  80228f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80229a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a5:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8022ac:	e8 2e ea ff ff       	call   800cdf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022b1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8022b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8022bc:	e8 a7 fd ff ff       	call   802068 <nsipc>
}
  8022c1:	83 c4 14             	add    $0x14,%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5d                   	pop    %ebp
  8022c6:	c3                   	ret    

008022c7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 28             	sub    $0x28,%esp
  8022cd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022d0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022d3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022d6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022e1:	8b 07                	mov    (%edi),%eax
  8022e3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ed:	e8 76 fd ff ff       	call   802068 <nsipc>
  8022f2:	89 c6                	mov    %eax,%esi
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	78 22                	js     80231a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022f8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8022fd:	8b 03                	mov    (%ebx),%eax
  8022ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  802303:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80230a:	00 
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	89 04 24             	mov    %eax,(%esp)
  802311:	e8 c9 e9 ff ff       	call   800cdf <memmove>
		*addrlen = ret->ret_addrlen;
  802316:	8b 03                	mov    (%ebx),%eax
  802318:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80231a:	89 f0                	mov    %esi,%eax
  80231c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80231f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802322:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802325:	89 ec                	mov    %ebp,%esp
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    
  802329:	00 00                	add    %al,(%eax)
	...

0080232c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 18             	sub    $0x18,%esp
  802332:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802335:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802338:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	89 04 24             	mov    %eax,(%esp)
  802341:	e8 6e f0 ff ff       	call   8013b4 <fd2data>
  802346:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802348:	c7 44 24 04 db 2f 80 	movl   $0x802fdb,0x4(%esp)
  80234f:	00 
  802350:	89 34 24             	mov    %esi,(%esp)
  802353:	e8 e1 e7 ff ff       	call   800b39 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802358:	8b 43 04             	mov    0x4(%ebx),%eax
  80235b:	2b 03                	sub    (%ebx),%eax
  80235d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802363:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80236a:	00 00 00 
	stat->st_dev = &devpipe;
  80236d:	c7 86 88 00 00 00 58 	movl   $0x804058,0x88(%esi)
  802374:	40 80 00 
	return 0;
}
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
  80237c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80237f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802382:	89 ec                	mov    %ebp,%esp
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    

00802386 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	53                   	push   %ebx
  80238a:	83 ec 14             	sub    $0x14,%esp
  80238d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80239b:	e8 22 ee ff ff       	call   8011c2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023a0:	89 1c 24             	mov    %ebx,(%esp)
  8023a3:	e8 0c f0 ff ff       	call   8013b4 <fd2data>
  8023a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b3:	e8 0a ee ff ff       	call   8011c2 <sys_page_unmap>
}
  8023b8:	83 c4 14             	add    $0x14,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 2c             	sub    $0x2c,%esp
  8023c7:	89 c7                	mov    %eax,%edi
  8023c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023cc:	a1 08 54 80 00       	mov    0x805408,%eax
  8023d1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023d4:	89 3c 24             	mov    %edi,(%esp)
  8023d7:	e8 18 04 00 00       	call   8027f4 <pageref>
  8023dc:	89 c6                	mov    %eax,%esi
  8023de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e1:	89 04 24             	mov    %eax,(%esp)
  8023e4:	e8 0b 04 00 00       	call   8027f4 <pageref>
  8023e9:	39 c6                	cmp    %eax,%esi
  8023eb:	0f 94 c0             	sete   %al
  8023ee:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8023f1:	8b 15 08 54 80 00    	mov    0x805408,%edx
  8023f7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023fa:	39 cb                	cmp    %ecx,%ebx
  8023fc:	75 08                	jne    802406 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8023fe:	83 c4 2c             	add    $0x2c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802406:	83 f8 01             	cmp    $0x1,%eax
  802409:	75 c1                	jne    8023cc <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80240b:	8b 52 58             	mov    0x58(%edx),%edx
  80240e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802412:	89 54 24 08          	mov    %edx,0x8(%esp)
  802416:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80241a:	c7 04 24 e2 2f 80 00 	movl   $0x802fe2,(%esp)
  802421:	e8 bb df ff ff       	call   8003e1 <cprintf>
  802426:	eb a4                	jmp    8023cc <_pipeisclosed+0xe>

00802428 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	57                   	push   %edi
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	83 ec 1c             	sub    $0x1c,%esp
  802431:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802434:	89 34 24             	mov    %esi,(%esp)
  802437:	e8 78 ef ff ff       	call   8013b4 <fd2data>
  80243c:	89 c3                	mov    %eax,%ebx
  80243e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802443:	eb 48                	jmp    80248d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802445:	89 da                	mov    %ebx,%edx
  802447:	89 f0                	mov    %esi,%eax
  802449:	e8 70 ff ff ff       	call   8023be <_pipeisclosed>
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 07                	je     802459 <devpipe_write+0x31>
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
  802457:	eb 3b                	jmp    802494 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802459:	e8 7f ee ff ff       	call   8012dd <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80245e:	8b 43 04             	mov    0x4(%ebx),%eax
  802461:	8b 13                	mov    (%ebx),%edx
  802463:	83 c2 20             	add    $0x20,%edx
  802466:	39 d0                	cmp    %edx,%eax
  802468:	73 db                	jae    802445 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80246a:	89 c2                	mov    %eax,%edx
  80246c:	c1 fa 1f             	sar    $0x1f,%edx
  80246f:	c1 ea 1b             	shr    $0x1b,%edx
  802472:	01 d0                	add    %edx,%eax
  802474:	83 e0 1f             	and    $0x1f,%eax
  802477:	29 d0                	sub    %edx,%eax
  802479:	89 c2                	mov    %eax,%edx
  80247b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80247e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802482:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802486:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80248a:	83 c7 01             	add    $0x1,%edi
  80248d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802490:	72 cc                	jb     80245e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802492:	89 f8                	mov    %edi,%eax
}
  802494:	83 c4 1c             	add    $0x1c,%esp
  802497:	5b                   	pop    %ebx
  802498:	5e                   	pop    %esi
  802499:	5f                   	pop    %edi
  80249a:	5d                   	pop    %ebp
  80249b:	c3                   	ret    

0080249c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	83 ec 28             	sub    $0x28,%esp
  8024a2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8024a5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024a8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024ab:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024ae:	89 3c 24             	mov    %edi,(%esp)
  8024b1:	e8 fe ee ff ff       	call   8013b4 <fd2data>
  8024b6:	89 c3                	mov    %eax,%ebx
  8024b8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024bd:	eb 48                	jmp    802507 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024bf:	85 f6                	test   %esi,%esi
  8024c1:	74 04                	je     8024c7 <devpipe_read+0x2b>
				return i;
  8024c3:	89 f0                	mov    %esi,%eax
  8024c5:	eb 47                	jmp    80250e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024c7:	89 da                	mov    %ebx,%edx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	e8 ee fe ff ff       	call   8023be <_pipeisclosed>
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	74 07                	je     8024db <devpipe_read+0x3f>
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d9:	eb 33                	jmp    80250e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024db:	e8 fd ed ff ff       	call   8012dd <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024e0:	8b 03                	mov    (%ebx),%eax
  8024e2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024e5:	74 d8                	je     8024bf <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024e7:	89 c2                	mov    %eax,%edx
  8024e9:	c1 fa 1f             	sar    $0x1f,%edx
  8024ec:	c1 ea 1b             	shr    $0x1b,%edx
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	83 e0 1f             	and    $0x1f,%eax
  8024f4:	29 d0                	sub    %edx,%eax
  8024f6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fe:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802501:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802504:	83 c6 01             	add    $0x1,%esi
  802507:	3b 75 10             	cmp    0x10(%ebp),%esi
  80250a:	72 d4                	jb     8024e0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80250c:	89 f0                	mov    %esi,%eax
}
  80250e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802511:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802514:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802517:	89 ec                	mov    %ebp,%esp
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    

0080251b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802524:	89 44 24 04          	mov    %eax,0x4(%esp)
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	89 04 24             	mov    %eax,(%esp)
  80252e:	e8 f5 ee ff ff       	call   801428 <fd_lookup>
  802533:	85 c0                	test   %eax,%eax
  802535:	78 15                	js     80254c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	89 04 24             	mov    %eax,(%esp)
  80253d:	e8 72 ee ff ff       	call   8013b4 <fd2data>
	return _pipeisclosed(fd, p);
  802542:	89 c2                	mov    %eax,%edx
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	e8 72 fe ff ff       	call   8023be <_pipeisclosed>
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 48             	sub    $0x48,%esp
  802554:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802557:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80255a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80255d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802560:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802563:	89 04 24             	mov    %eax,(%esp)
  802566:	e8 64 ee ff ff       	call   8013cf <fd_alloc>
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	85 c0                	test   %eax,%eax
  80256f:	0f 88 42 01 00 00    	js     8026b7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802575:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80257c:	00 
  80257d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802580:	89 44 24 04          	mov    %eax,0x4(%esp)
  802584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80258b:	e8 ee ec ff ff       	call   80127e <sys_page_alloc>
  802590:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 88 1d 01 00 00    	js     8026b7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80259a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80259d:	89 04 24             	mov    %eax,(%esp)
  8025a0:	e8 2a ee ff ff       	call   8013cf <fd_alloc>
  8025a5:	89 c3                	mov    %eax,%ebx
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	0f 88 f5 00 00 00    	js     8026a4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025af:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b6:	00 
  8025b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c5:	e8 b4 ec ff ff       	call   80127e <sys_page_alloc>
  8025ca:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	0f 88 d0 00 00 00    	js     8026a4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d7:	89 04 24             	mov    %eax,(%esp)
  8025da:	e8 d5 ed ff ff       	call   8013b4 <fd2data>
  8025df:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025e8:	00 
  8025e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f4:	e8 85 ec ff ff       	call   80127e <sys_page_alloc>
  8025f9:	89 c3                	mov    %eax,%ebx
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	0f 88 8e 00 00 00    	js     802691 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802606:	89 04 24             	mov    %eax,(%esp)
  802609:	e8 a6 ed ff ff       	call   8013b4 <fd2data>
  80260e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802615:	00 
  802616:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80261a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802621:	00 
  802622:	89 74 24 04          	mov    %esi,0x4(%esp)
  802626:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80262d:	e8 ee eb ff ff       	call   801220 <sys_page_map>
  802632:	89 c3                	mov    %eax,%ebx
  802634:	85 c0                	test   %eax,%eax
  802636:	78 49                	js     802681 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802638:	b8 58 40 80 00       	mov    $0x804058,%eax
  80263d:	8b 08                	mov    (%eax),%ecx
  80263f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802642:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802644:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802647:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80264e:	8b 10                	mov    (%eax),%edx
  802650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802653:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802658:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80265f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802662:	89 04 24             	mov    %eax,(%esp)
  802665:	e8 3a ed ff ff       	call   8013a4 <fd2num>
  80266a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80266c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266f:	89 04 24             	mov    %eax,(%esp)
  802672:	e8 2d ed ff ff       	call   8013a4 <fd2num>
  802677:	89 47 04             	mov    %eax,0x4(%edi)
  80267a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80267f:	eb 36                	jmp    8026b7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802681:	89 74 24 04          	mov    %esi,0x4(%esp)
  802685:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80268c:	e8 31 eb ff ff       	call   8011c2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802694:	89 44 24 04          	mov    %eax,0x4(%esp)
  802698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269f:	e8 1e eb ff ff       	call   8011c2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b2:	e8 0b eb ff ff       	call   8011c2 <sys_page_unmap>
    err:
	return r;
}
  8026b7:	89 d8                	mov    %ebx,%eax
  8026b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8026bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8026bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8026c2:	89 ec                	mov    %ebp,%esp
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
	...

008026c8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8026d3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026d6:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8026dc:	8b 12                	mov    (%edx),%edx
  8026de:	39 ca                	cmp    %ecx,%edx
  8026e0:	75 0c                	jne    8026ee <ipc_find_env+0x26>
			return envs[i].env_id;
  8026e2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026e5:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	eb 0e                	jmp    8026fc <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8026ee:	83 c0 01             	add    $0x1,%eax
  8026f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026f6:	75 db                	jne    8026d3 <ipc_find_env+0xb>
  8026f8:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    

008026fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	53                   	push   %ebx
  802704:	83 ec 2c             	sub    $0x2c,%esp
  802707:	8b 75 08             	mov    0x8(%ebp),%esi
  80270a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80270d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802710:	85 db                	test   %ebx,%ebx
  802712:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802717:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80271a:	8b 45 14             	mov    0x14(%ebp),%eax
  80271d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802721:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802725:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802729:	89 34 24             	mov    %esi,(%esp)
  80272c:	e8 3f e9 ff ff       	call   801070 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802731:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802734:	74 e4                	je     80271a <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802736:	85 c0                	test   %eax,%eax
  802738:	74 28                	je     802762 <ipc_send+0x64>
  80273a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80273e:	c7 44 24 0c 17 30 80 	movl   $0x803017,0xc(%esp)
  802745:	00 
  802746:	c7 44 24 08 fa 2f 80 	movl   $0x802ffa,0x8(%esp)
  80274d:	00 
  80274e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802755:	00 
  802756:	c7 04 24 0d 30 80 00 	movl   $0x80300d,(%esp)
  80275d:	e8 c6 db ff ff       	call   800328 <_panic>
	//if(!ret) sys_yield();
}
  802762:	83 c4 2c             	add    $0x2c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    

0080276a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 28             	sub    $0x28,%esp
  802770:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802773:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802776:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802779:	8b 75 08             	mov    0x8(%ebp),%esi
  80277c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802782:	85 c0                	test   %eax,%eax
  802784:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802789:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80278c:	89 04 24             	mov    %eax,(%esp)
  80278f:	e8 7f e8 ff ff       	call   801013 <sys_ipc_recv>
  802794:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802796:	e8 76 eb ff ff       	call   801311 <sys_getenvid>
  80279b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027a0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027a8:	a3 08 54 80 00       	mov    %eax,0x805408
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  8027ad:	85 f6                	test   %esi,%esi
  8027af:	74 0e                	je     8027bf <ipc_recv+0x55>
  8027b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b6:	85 db                	test   %ebx,%ebx
  8027b8:	75 03                	jne    8027bd <ipc_recv+0x53>
  8027ba:	8b 50 74             	mov    0x74(%eax),%edx
  8027bd:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  8027bf:	85 ff                	test   %edi,%edi
  8027c1:	74 13                	je     8027d6 <ipc_recv+0x6c>
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	85 db                	test   %ebx,%ebx
  8027ca:	75 08                	jne    8027d4 <ipc_recv+0x6a>
  8027cc:	a1 08 54 80 00       	mov    0x805408,%eax
  8027d1:	8b 40 78             	mov    0x78(%eax),%eax
  8027d4:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8027d6:	85 db                	test   %ebx,%ebx
  8027d8:	75 08                	jne    8027e2 <ipc_recv+0x78>
  8027da:	a1 08 54 80 00       	mov    0x805408,%eax
  8027df:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8027e2:	89 d8                	mov    %ebx,%eax
  8027e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8027e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8027ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8027ed:	89 ec                	mov    %ebp,%esp
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    
  8027f1:	00 00                	add    %al,(%eax)
	...

008027f4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	89 c2                	mov    %eax,%edx
  8027fc:	c1 ea 16             	shr    $0x16,%edx
  8027ff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802806:	f6 c2 01             	test   $0x1,%dl
  802809:	74 20                	je     80282b <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  80280b:	c1 e8 0c             	shr    $0xc,%eax
  80280e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802815:	a8 01                	test   $0x1,%al
  802817:	74 12                	je     80282b <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802819:	c1 e8 0c             	shr    $0xc,%eax
  80281c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802821:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802826:	0f b7 c0             	movzwl %ax,%eax
  802829:	eb 05                	jmp    802830 <pageref+0x3c>
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802830:	5d                   	pop    %ebp
  802831:	c3                   	ret    
	...

00802840 <__udivdi3>:
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	57                   	push   %edi
  802844:	56                   	push   %esi
  802845:	83 ec 10             	sub    $0x10,%esp
  802848:	8b 45 14             	mov    0x14(%ebp),%eax
  80284b:	8b 55 08             	mov    0x8(%ebp),%edx
  80284e:	8b 75 10             	mov    0x10(%ebp),%esi
  802851:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802854:	85 c0                	test   %eax,%eax
  802856:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802859:	75 35                	jne    802890 <__udivdi3+0x50>
  80285b:	39 fe                	cmp    %edi,%esi
  80285d:	77 61                	ja     8028c0 <__udivdi3+0x80>
  80285f:	85 f6                	test   %esi,%esi
  802861:	75 0b                	jne    80286e <__udivdi3+0x2e>
  802863:	b8 01 00 00 00       	mov    $0x1,%eax
  802868:	31 d2                	xor    %edx,%edx
  80286a:	f7 f6                	div    %esi
  80286c:	89 c6                	mov    %eax,%esi
  80286e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802871:	31 d2                	xor    %edx,%edx
  802873:	89 f8                	mov    %edi,%eax
  802875:	f7 f6                	div    %esi
  802877:	89 c7                	mov    %eax,%edi
  802879:	89 c8                	mov    %ecx,%eax
  80287b:	f7 f6                	div    %esi
  80287d:	89 c1                	mov    %eax,%ecx
  80287f:	89 fa                	mov    %edi,%edx
  802881:	89 c8                	mov    %ecx,%eax
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	5e                   	pop    %esi
  802887:	5f                   	pop    %edi
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    
  80288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802890:	39 f8                	cmp    %edi,%eax
  802892:	77 1c                	ja     8028b0 <__udivdi3+0x70>
  802894:	0f bd d0             	bsr    %eax,%edx
  802897:	83 f2 1f             	xor    $0x1f,%edx
  80289a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80289d:	75 39                	jne    8028d8 <__udivdi3+0x98>
  80289f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8028a2:	0f 86 a0 00 00 00    	jbe    802948 <__udivdi3+0x108>
  8028a8:	39 f8                	cmp    %edi,%eax
  8028aa:	0f 82 98 00 00 00    	jb     802948 <__udivdi3+0x108>
  8028b0:	31 ff                	xor    %edi,%edi
  8028b2:	31 c9                	xor    %ecx,%ecx
  8028b4:	89 c8                	mov    %ecx,%eax
  8028b6:	89 fa                	mov    %edi,%edx
  8028b8:	83 c4 10             	add    $0x10,%esp
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    
  8028bf:	90                   	nop
  8028c0:	89 d1                	mov    %edx,%ecx
  8028c2:	89 fa                	mov    %edi,%edx
  8028c4:	89 c8                	mov    %ecx,%eax
  8028c6:	31 ff                	xor    %edi,%edi
  8028c8:	f7 f6                	div    %esi
  8028ca:	89 c1                	mov    %eax,%ecx
  8028cc:	89 fa                	mov    %edi,%edx
  8028ce:	89 c8                	mov    %ecx,%eax
  8028d0:	83 c4 10             	add    $0x10,%esp
  8028d3:	5e                   	pop    %esi
  8028d4:	5f                   	pop    %edi
  8028d5:	5d                   	pop    %ebp
  8028d6:	c3                   	ret    
  8028d7:	90                   	nop
  8028d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028dc:	89 f2                	mov    %esi,%edx
  8028de:	d3 e0                	shl    %cl,%eax
  8028e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8028e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028eb:	89 c1                	mov    %eax,%ecx
  8028ed:	d3 ea                	shr    %cl,%edx
  8028ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028f6:	d3 e6                	shl    %cl,%esi
  8028f8:	89 c1                	mov    %eax,%ecx
  8028fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028fd:	89 fe                	mov    %edi,%esi
  8028ff:	d3 ee                	shr    %cl,%esi
  802901:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802905:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290b:	d3 e7                	shl    %cl,%edi
  80290d:	89 c1                	mov    %eax,%ecx
  80290f:	d3 ea                	shr    %cl,%edx
  802911:	09 d7                	or     %edx,%edi
  802913:	89 f2                	mov    %esi,%edx
  802915:	89 f8                	mov    %edi,%eax
  802917:	f7 75 ec             	divl   -0x14(%ebp)
  80291a:	89 d6                	mov    %edx,%esi
  80291c:	89 c7                	mov    %eax,%edi
  80291e:	f7 65 e8             	mull   -0x18(%ebp)
  802921:	39 d6                	cmp    %edx,%esi
  802923:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802926:	72 30                	jb     802958 <__udivdi3+0x118>
  802928:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80292f:	d3 e2                	shl    %cl,%edx
  802931:	39 c2                	cmp    %eax,%edx
  802933:	73 05                	jae    80293a <__udivdi3+0xfa>
  802935:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802938:	74 1e                	je     802958 <__udivdi3+0x118>
  80293a:	89 f9                	mov    %edi,%ecx
  80293c:	31 ff                	xor    %edi,%edi
  80293e:	e9 71 ff ff ff       	jmp    8028b4 <__udivdi3+0x74>
  802943:	90                   	nop
  802944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802948:	31 ff                	xor    %edi,%edi
  80294a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80294f:	e9 60 ff ff ff       	jmp    8028b4 <__udivdi3+0x74>
  802954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802958:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80295b:	31 ff                	xor    %edi,%edi
  80295d:	89 c8                	mov    %ecx,%eax
  80295f:	89 fa                	mov    %edi,%edx
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	5e                   	pop    %esi
  802965:	5f                   	pop    %edi
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    
	...

00802970 <__umoddi3>:
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	57                   	push   %edi
  802974:	56                   	push   %esi
  802975:	83 ec 20             	sub    $0x20,%esp
  802978:	8b 55 14             	mov    0x14(%ebp),%edx
  80297b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80297e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802981:	8b 75 0c             	mov    0xc(%ebp),%esi
  802984:	85 d2                	test   %edx,%edx
  802986:	89 c8                	mov    %ecx,%eax
  802988:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80298b:	75 13                	jne    8029a0 <__umoddi3+0x30>
  80298d:	39 f7                	cmp    %esi,%edi
  80298f:	76 3f                	jbe    8029d0 <__umoddi3+0x60>
  802991:	89 f2                	mov    %esi,%edx
  802993:	f7 f7                	div    %edi
  802995:	89 d0                	mov    %edx,%eax
  802997:	31 d2                	xor    %edx,%edx
  802999:	83 c4 20             	add    $0x20,%esp
  80299c:	5e                   	pop    %esi
  80299d:	5f                   	pop    %edi
  80299e:	5d                   	pop    %ebp
  80299f:	c3                   	ret    
  8029a0:	39 f2                	cmp    %esi,%edx
  8029a2:	77 4c                	ja     8029f0 <__umoddi3+0x80>
  8029a4:	0f bd ca             	bsr    %edx,%ecx
  8029a7:	83 f1 1f             	xor    $0x1f,%ecx
  8029aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8029ad:	75 51                	jne    802a00 <__umoddi3+0x90>
  8029af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8029b2:	0f 87 e0 00 00 00    	ja     802a98 <__umoddi3+0x128>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	29 f8                	sub    %edi,%eax
  8029bd:	19 d6                	sbb    %edx,%esi
  8029bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	89 f2                	mov    %esi,%edx
  8029c7:	83 c4 20             	add    $0x20,%esp
  8029ca:	5e                   	pop    %esi
  8029cb:	5f                   	pop    %edi
  8029cc:	5d                   	pop    %ebp
  8029cd:	c3                   	ret    
  8029ce:	66 90                	xchg   %ax,%ax
  8029d0:	85 ff                	test   %edi,%edi
  8029d2:	75 0b                	jne    8029df <__umoddi3+0x6f>
  8029d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d9:	31 d2                	xor    %edx,%edx
  8029db:	f7 f7                	div    %edi
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	89 f0                	mov    %esi,%eax
  8029e1:	31 d2                	xor    %edx,%edx
  8029e3:	f7 f7                	div    %edi
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	f7 f7                	div    %edi
  8029ea:	eb a9                	jmp    802995 <__umoddi3+0x25>
  8029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	89 c8                	mov    %ecx,%eax
  8029f2:	89 f2                	mov    %esi,%edx
  8029f4:	83 c4 20             	add    $0x20,%esp
  8029f7:	5e                   	pop    %esi
  8029f8:	5f                   	pop    %edi
  8029f9:	5d                   	pop    %ebp
  8029fa:	c3                   	ret    
  8029fb:	90                   	nop
  8029fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a04:	d3 e2                	shl    %cl,%edx
  802a06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a09:	ba 20 00 00 00       	mov    $0x20,%edx
  802a0e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802a11:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802a14:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a18:	89 fa                	mov    %edi,%edx
  802a1a:	d3 ea                	shr    %cl,%edx
  802a1c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a20:	0b 55 f4             	or     -0xc(%ebp),%edx
  802a23:	d3 e7                	shl    %cl,%edi
  802a25:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a29:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a2c:	89 f2                	mov    %esi,%edx
  802a2e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802a31:	89 c7                	mov    %eax,%edi
  802a33:	d3 ea                	shr    %cl,%edx
  802a35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802a3c:	89 c2                	mov    %eax,%edx
  802a3e:	d3 e6                	shl    %cl,%esi
  802a40:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a44:	d3 ea                	shr    %cl,%edx
  802a46:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a4a:	09 d6                	or     %edx,%esi
  802a4c:	89 f0                	mov    %esi,%eax
  802a4e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a51:	d3 e7                	shl    %cl,%edi
  802a53:	89 f2                	mov    %esi,%edx
  802a55:	f7 75 f4             	divl   -0xc(%ebp)
  802a58:	89 d6                	mov    %edx,%esi
  802a5a:	f7 65 e8             	mull   -0x18(%ebp)
  802a5d:	39 d6                	cmp    %edx,%esi
  802a5f:	72 2b                	jb     802a8c <__umoddi3+0x11c>
  802a61:	39 c7                	cmp    %eax,%edi
  802a63:	72 23                	jb     802a88 <__umoddi3+0x118>
  802a65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a69:	29 c7                	sub    %eax,%edi
  802a6b:	19 d6                	sbb    %edx,%esi
  802a6d:	89 f0                	mov    %esi,%eax
  802a6f:	89 f2                	mov    %esi,%edx
  802a71:	d3 ef                	shr    %cl,%edi
  802a73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a77:	d3 e0                	shl    %cl,%eax
  802a79:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a7d:	09 f8                	or     %edi,%eax
  802a7f:	d3 ea                	shr    %cl,%edx
  802a81:	83 c4 20             	add    $0x20,%esp
  802a84:	5e                   	pop    %esi
  802a85:	5f                   	pop    %edi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    
  802a88:	39 d6                	cmp    %edx,%esi
  802a8a:	75 d9                	jne    802a65 <__umoddi3+0xf5>
  802a8c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a8f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a92:	eb d1                	jmp    802a65 <__umoddi3+0xf5>
  802a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a98:	39 f2                	cmp    %esi,%edx
  802a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802aa0:	0f 82 12 ff ff ff    	jb     8029b8 <__umoddi3+0x48>
  802aa6:	e9 17 ff ff ff       	jmp    8029c2 <__umoddi3+0x52>
