
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 d3 09 00 00       	call   800a04 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
}


void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800046:	c7 04 24 c0 3e 80 00 	movl   $0x803ec0,(%esp)
  80004d:	e8 cf 0a 00 00       	call   800b21 <cprintf>
	exit();
  800052:	e8 fd 09 00 00       	call   800a54 <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	83 ec 1c             	sub    $0x1c,%esp
  800062:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  800065:	85 db                	test   %ebx,%ebx
  800067:	75 23                	jne    80008c <_gettoken+0x33>
		if (debug > 1)
  800069:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800070:	0f 8e 37 01 00 00    	jle    8001ad <_gettoken+0x154>
			cprintf("GETTOKEN NULL\n");
  800076:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  80007d:	e8 9f 0a 00 00       	call   800b21 <cprintf>
  800082:	be 00 00 00 00       	mov    $0x0,%esi
  800087:	e9 26 01 00 00       	jmp    8001b2 <_gettoken+0x159>
		return 0;
	}

	if (debug > 1)
  80008c:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800093:	7e 10                	jle    8000a5 <_gettoken+0x4c>
		cprintf("GETTOKEN: %s\n", s);
  800095:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800099:	c7 04 24 41 3f 80 00 	movl   $0x803f41,(%esp)
  8000a0:	e8 7c 0a 00 00       	call   800b21 <cprintf>

	*p1 = 0;
  8000a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  8000ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8000b1:	c7 02 00 00 00 00    	movl   $0x0,(%edx)

	while (strchr(WHITESPACE, *s))
  8000b7:	eb 06                	jmp    8000bf <_gettoken+0x66>
		*s++ = 0;
  8000b9:	c6 03 00             	movb   $0x0,(%ebx)
  8000bc:	83 c3 01             	add    $0x1,%ebx
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000bf:	0f be 03             	movsbl (%ebx),%eax
  8000c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c6:	c7 04 24 4f 3f 80 00 	movl   $0x803f4f,(%esp)
  8000cd:	e8 b1 12 00 00       	call   801383 <strchr>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 e3                	jne    8000b9 <_gettoken+0x60>
  8000d6:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000d8:	0f b6 03             	movzbl (%ebx),%eax
  8000db:	84 c0                	test   %al,%al
  8000dd:	75 23                	jne    800102 <_gettoken+0xa9>
		if (debug > 1)
  8000df:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000e6:	0f 8e c1 00 00 00    	jle    8001ad <_gettoken+0x154>
			cprintf("EOL\n");
  8000ec:	c7 04 24 54 3f 80 00 	movl   $0x803f54,(%esp)
  8000f3:	e8 29 0a 00 00       	call   800b21 <cprintf>
  8000f8:	be 00 00 00 00       	mov    $0x0,%esi
  8000fd:	e9 b0 00 00 00       	jmp    8001b2 <_gettoken+0x159>
		return 0;
	}
	if (strchr(SYMBOLS, *s)) {
  800102:	0f be c0             	movsbl %al,%eax
  800105:	89 44 24 04          	mov    %eax,0x4(%esp)
  800109:	c7 04 24 65 3f 80 00 	movl   $0x803f65,(%esp)
  800110:	e8 6e 12 00 00       	call   801383 <strchr>
  800115:	85 c0                	test   %eax,%eax
  800117:	74 2e                	je     800147 <_gettoken+0xee>
		t = *s;
  800119:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  80011c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011f:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  800121:	c6 03 00             	movb   $0x0,(%ebx)
		*p2 = s;
  800124:	83 c7 01             	add    $0x1,%edi
  800127:	8b 55 10             	mov    0x10(%ebp),%edx
  80012a:	89 3a                	mov    %edi,(%edx)
		if (debug > 1)
  80012c:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800133:	7e 7d                	jle    8001b2 <_gettoken+0x159>
			cprintf("TOK %c\n", t);
  800135:	89 74 24 04          	mov    %esi,0x4(%esp)
  800139:	c7 04 24 59 3f 80 00 	movl   $0x803f59,(%esp)
  800140:	e8 dc 09 00 00       	call   800b21 <cprintf>
  800145:	eb 6b                	jmp    8001b2 <_gettoken+0x159>
		return t;
	}
	*p1 = s;
  800147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014a:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80014c:	eb 03                	jmp    800151 <_gettoken+0xf8>
		s++;
  80014e:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800151:	0f b6 03             	movzbl (%ebx),%eax
  800154:	84 c0                	test   %al,%al
  800156:	74 17                	je     80016f <_gettoken+0x116>
  800158:	0f be c0             	movsbl %al,%eax
  80015b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015f:	c7 04 24 61 3f 80 00 	movl   $0x803f61,(%esp)
  800166:	e8 18 12 00 00       	call   801383 <strchr>
  80016b:	85 c0                	test   %eax,%eax
  80016d:	74 df                	je     80014e <_gettoken+0xf5>
		s++;
	*p2 = s;
  80016f:	8b 55 10             	mov    0x10(%ebp),%edx
  800172:	89 1a                	mov    %ebx,(%edx)
	if (debug > 1) {
  800174:	be 77 00 00 00       	mov    $0x77,%esi
  800179:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800180:	7e 30                	jle    8001b2 <_gettoken+0x159>
		t = **p2;
  800182:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800185:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	8b 02                	mov    (%edx),%eax
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 6d 3f 80 00 	movl   $0x803f6d,(%esp)
  800198:	e8 84 09 00 00       	call   800b21 <cprintf>
		**p2 = t;
  80019d:	8b 55 10             	mov    0x10(%ebp),%edx
  8001a0:	8b 02                	mov    (%edx),%eax
  8001a2:	89 f2                	mov    %esi,%edx
  8001a4:	88 10                	mov    %dl,(%eax)
  8001a6:	be 77 00 00 00       	mov    $0x77,%esi
  8001ab:	eb 05                	jmp    8001b2 <_gettoken+0x159>
  8001ad:	be 00 00 00 00       	mov    $0x0,%esi
	}
	return 'w';
}
  8001b2:	89 f0                	mov    %esi,%eax
  8001b4:	83 c4 1c             	add    $0x1c,%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    

008001bc <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	83 ec 18             	sub    $0x18,%esp
  8001c2:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 24                	je     8001ed <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001c9:	c7 44 24 08 04 60 80 	movl   $0x806004,0x8(%esp)
  8001d0:	00 
  8001d1:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  8001d8:	00 
  8001d9:	89 04 24             	mov    %eax,(%esp)
  8001dc:	e8 78 fe ff ff       	call   800059 <_gettoken>
  8001e1:	a3 0c 60 80 00       	mov    %eax,0x80600c
  8001e6:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8001eb:	eb 3c                	jmp    800229 <gettoken+0x6d>
	}
	c = nc;
  8001ed:	a1 0c 60 80 00       	mov    0x80600c,%eax
  8001f2:	a3 10 60 80 00       	mov    %eax,0x806010
	*p1 = np1;
  8001f7:	8b 15 08 60 80 00    	mov    0x806008,%edx
  8001fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800200:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  800202:	c7 44 24 08 04 60 80 	movl   $0x806004,0x8(%esp)
  800209:	00 
  80020a:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  800211:	00 
  800212:	a1 04 60 80 00       	mov    0x806004,%eax
  800217:	89 04 24             	mov    %eax,(%esp)
  80021a:	e8 3a fe ff ff       	call   800059 <_gettoken>
  80021f:	a3 0c 60 80 00       	mov    %eax,0x80600c
	return c;
  800224:	a1 10 60 80 00       	mov    0x806010,%eax
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	57                   	push   %edi
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  800237:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80023e:	00 
  80023f:	8b 45 08             	mov    0x8(%ebp),%eax
  800242:	89 04 24             	mov    %eax,(%esp)
  800245:	e8 72 ff ff ff       	call   8001bc <gettoken>
  80024a:	be 00 00 00 00       	mov    $0x0,%esi

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80024f:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  800252:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800256:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80025d:	e8 5a ff ff ff       	call   8001bc <gettoken>
  800262:	83 f8 77             	cmp    $0x77,%eax
  800265:	74 34                	je     80029b <runcmd+0x70>
  800267:	83 f8 77             	cmp    $0x77,%eax
  80026a:	7f 21                	jg     80028d <runcmd+0x62>
  80026c:	83 f8 3c             	cmp    $0x3c,%eax
  80026f:	90                   	nop
  800270:	74 4d                	je     8002bf <runcmd+0x94>
  800272:	83 f8 3e             	cmp    $0x3e,%eax
  800275:	0f 84 c8 00 00 00    	je     800343 <runcmd+0x118>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  80027b:	bf 00 00 00 00       	mov    $0x0,%edi
	gettoken(s, 0);

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800280:	85 c0                	test   %eax,%eax
  800282:	0f 84 49 02 00 00    	je     8004d1 <runcmd+0x2a6>
  800288:	e9 24 02 00 00       	jmp    8004b1 <runcmd+0x286>
  80028d:	83 f8 7c             	cmp    $0x7c,%eax
  800290:	0f 85 1b 02 00 00    	jne    8004b1 <runcmd+0x286>
  800296:	e9 29 01 00 00       	jmp    8003c4 <runcmd+0x199>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  80029b:	83 fe 10             	cmp    $0x10,%esi
  80029e:	66 90                	xchg   %ax,%ax
  8002a0:	75 11                	jne    8002b3 <runcmd+0x88>
				cprintf("too many arguments\n");
  8002a2:	c7 04 24 77 3f 80 00 	movl   $0x803f77,(%esp)
  8002a9:	e8 73 08 00 00       	call   800b21 <cprintf>
				exit();
  8002ae:	e8 a1 07 00 00       	call   800a54 <exit>
			}
			argv[argc++] = t;
  8002b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002b6:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  8002ba:	83 c6 01             	add    $0x1,%esi
			break;
  8002bd:	eb 93                	jmp    800252 <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8002bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002ca:	e8 ed fe ff ff       	call   8001bc <gettoken>
  8002cf:	83 f8 77             	cmp    $0x77,%eax
  8002d2:	74 11                	je     8002e5 <runcmd+0xba>
				cprintf("syntax error: < not followed by word\n");
  8002d4:	c7 04 24 e4 3e 80 00 	movl   $0x803ee4,(%esp)
  8002db:	e8 41 08 00 00       	call   800b21 <cprintf>
				exit();
  8002e0:	e8 6f 07 00 00       	call   800a54 <exit>
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002ec:	00 
  8002ed:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f0:	89 04 24             	mov    %eax,(%esp)
  8002f3:	e8 b3 25 00 00       	call   8028ab <open>
  8002f8:	89 c7                	mov    %eax,%edi
  8002fa:	85 c0                	test   %eax,%eax
  8002fc:	79 1e                	jns    80031c <runcmd+0xf1>
				cprintf("open %s for read: %e", t, fd);
  8002fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800302:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800305:	89 44 24 04          	mov    %eax,0x4(%esp)
  800309:	c7 04 24 8b 3f 80 00 	movl   $0x803f8b,(%esp)
  800310:	e8 0c 08 00 00       	call   800b21 <cprintf>
				exit();
  800315:	e8 3a 07 00 00       	call   800a54 <exit>
  80031a:	eb 0a                	jmp    800326 <runcmd+0xfb>
			}
			if (fd != 0) {
  80031c:	85 c0                	test   %eax,%eax
  80031e:	66 90                	xchg   %ax,%ax
  800320:	0f 84 2c ff ff ff    	je     800252 <runcmd+0x27>
				dup(fd, 0);
  800326:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80032d:	00 
  80032e:	89 3c 24             	mov    %edi,(%esp)
  800331:	e8 9f 21 00 00       	call   8024d5 <dup>
				close(fd);
  800336:	89 3c 24             	mov    %edi,(%esp)
  800339:	e8 f8 20 00 00       	call   802436 <close>
  80033e:	e9 0f ff ff ff       	jmp    800252 <runcmd+0x27>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800343:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800347:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80034e:	e8 69 fe ff ff       	call   8001bc <gettoken>
  800353:	83 f8 77             	cmp    $0x77,%eax
  800356:	74 11                	je     800369 <runcmd+0x13e>
				cprintf("syntax error: > not followed by word\n");
  800358:	c7 04 24 0c 3f 80 00 	movl   $0x803f0c,(%esp)
  80035f:	e8 bd 07 00 00       	call   800b21 <cprintf>
				exit();
  800364:	e8 eb 06 00 00       	call   800a54 <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800369:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800370:	00 
  800371:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800374:	89 04 24             	mov    %eax,(%esp)
  800377:	e8 2f 25 00 00       	call   8028ab <open>
  80037c:	89 c7                	mov    %eax,%edi
  80037e:	85 c0                	test   %eax,%eax
  800380:	79 1c                	jns    80039e <runcmd+0x173>
				cprintf("open %s for write: %e", t, fd);
  800382:	89 44 24 08          	mov    %eax,0x8(%esp)
  800386:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800389:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038d:	c7 04 24 a0 3f 80 00 	movl   $0x803fa0,(%esp)
  800394:	e8 88 07 00 00       	call   800b21 <cprintf>
				exit();
  800399:	e8 b6 06 00 00       	call   800a54 <exit>
			}
			if (fd != 1) {
  80039e:	83 ff 01             	cmp    $0x1,%edi
  8003a1:	0f 84 ab fe ff ff    	je     800252 <runcmd+0x27>
				dup(fd, 1);
  8003a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8003ae:	00 
  8003af:	89 3c 24             	mov    %edi,(%esp)
  8003b2:	e8 1e 21 00 00       	call   8024d5 <dup>
				close(fd);
  8003b7:	89 3c 24             	mov    %edi,(%esp)
  8003ba:	e8 77 20 00 00       	call   802436 <close>
  8003bf:	e9 8e fe ff ff       	jmp    800252 <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003c4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003ca:	89 04 24             	mov    %eax,(%esp)
  8003cd:	e8 8c 34 00 00       	call   80385e <pipe>
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	79 15                	jns    8003eb <runcmd+0x1c0>
				cprintf("pipe: %e", r);
  8003d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003da:	c7 04 24 b6 3f 80 00 	movl   $0x803fb6,(%esp)
  8003e1:	e8 3b 07 00 00       	call   800b21 <cprintf>
				exit();
  8003e6:	e8 69 06 00 00       	call   800a54 <exit>
			}
			if (debug)
  8003eb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003f2:	74 20                	je     800414 <runcmd+0x1e9>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003f4:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fe:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800404:	89 44 24 04          	mov    %eax,0x4(%esp)
  800408:	c7 04 24 bf 3f 80 00 	movl   $0x803fbf,(%esp)
  80040f:	e8 0d 07 00 00       	call   800b21 <cprintf>
			if ((r = fork()) < 0) {
  800414:	e8 ed 16 00 00       	call   801b06 <fork>
  800419:	89 c7                	mov    %eax,%edi
  80041b:	85 c0                	test   %eax,%eax
  80041d:	79 15                	jns    800434 <runcmd+0x209>
				cprintf("fork: %e", r);
  80041f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800423:	c7 04 24 6a 44 80 00 	movl   $0x80446a,(%esp)
  80042a:	e8 f2 06 00 00       	call   800b21 <cprintf>
				exit();
  80042f:	e8 20 06 00 00       	call   800a54 <exit>
			}
			if (r == 0) {
  800434:	85 ff                	test   %edi,%edi
  800436:	75 40                	jne    800478 <runcmd+0x24d>
				if (p[0] != 0) {
  800438:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80043e:	85 c0                	test   %eax,%eax
  800440:	74 1e                	je     800460 <runcmd+0x235>
					dup(p[0], 0);
  800442:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800449:	00 
  80044a:	89 04 24             	mov    %eax,(%esp)
  80044d:	e8 83 20 00 00       	call   8024d5 <dup>
					close(p[0]);
  800452:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800458:	89 04 24             	mov    %eax,(%esp)
  80045b:	e8 d6 1f 00 00       	call   802436 <close>
				}
				close(p[1]);
  800460:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800466:	89 04 24             	mov    %eax,(%esp)
  800469:	e8 c8 1f 00 00       	call   802436 <close>
  80046e:	be 00 00 00 00       	mov    $0x0,%esi
  800473:	e9 da fd ff ff       	jmp    800252 <runcmd+0x27>
				goto again;
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800478:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80047e:	83 f8 01             	cmp    $0x1,%eax
  800481:	74 1e                	je     8004a1 <runcmd+0x276>
					dup(p[1], 1);
  800483:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80048a:	00 
  80048b:	89 04 24             	mov    %eax,(%esp)
  80048e:	e8 42 20 00 00       	call   8024d5 <dup>
					close(p[1]);
  800493:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800499:	89 04 24             	mov    %eax,(%esp)
  80049c:	e8 95 1f 00 00       	call   802436 <close>
				}
				close(p[0]);
  8004a1:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8004a7:	89 04 24             	mov    %eax,(%esp)
  8004aa:	e8 87 1f 00 00       	call   802436 <close>
				goto runit;
  8004af:	eb 20                	jmp    8004d1 <runcmd+0x2a6>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  8004b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004b5:	c7 44 24 08 cc 3f 80 	movl   $0x803fcc,0x8(%esp)
  8004bc:	00 
  8004bd:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  8004c4:	00 
  8004c5:	c7 04 24 e8 3f 80 00 	movl   $0x803fe8,(%esp)
  8004cc:	e8 97 05 00 00       	call   800a68 <_panic>
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004d1:	85 f6                	test   %esi,%esi
  8004d3:	75 1e                	jne    8004f3 <runcmd+0x2c8>
		if (debug)
  8004d5:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004dc:	0f 84 75 01 00 00    	je     800657 <runcmd+0x42c>
			cprintf("EMPTY COMMAND\n");
  8004e2:	c7 04 24 f2 3f 80 00 	movl   $0x803ff2,(%esp)
  8004e9:	e8 33 06 00 00       	call   800b21 <cprintf>
  8004ee:	e9 64 01 00 00       	jmp    800657 <runcmd+0x42c>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f6:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004f9:	74 22                	je     80051d <runcmd+0x2f2>
		argv0buf[0] = '/';
  8004fb:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800502:	89 44 24 04          	mov    %eax,0x4(%esp)
  800506:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  80050c:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800512:	89 04 24             	mov    %eax,(%esp)
  800515:	e8 5f 0d 00 00       	call   801279 <strcpy>
		argv[0] = argv0buf;
  80051a:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  80051d:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800524:	00 

	// Print the command.
	if (debug) {
  800525:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80052c:	74 42                	je     800570 <runcmd+0x345>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80052e:	a1 28 64 80 00       	mov    0x806428,%eax
  800533:	8b 40 48             	mov    0x48(%eax),%eax
  800536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053a:	c7 04 24 01 40 80 00 	movl   $0x804001,(%esp)
  800541:	e8 db 05 00 00       	call   800b21 <cprintf>
  800546:	8d 5d a8             	lea    -0x58(%ebp),%ebx
		for (i = 0; argv[i]; i++)
  800549:	eb 10                	jmp    80055b <runcmd+0x330>
			cprintf(" %s", argv[i]);
  80054b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054f:	c7 04 24 89 40 80 00 	movl   $0x804089,(%esp)
  800556:	e8 c6 05 00 00       	call   800b21 <cprintf>
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  80055b:	8b 03                	mov    (%ebx),%eax
  80055d:	83 c3 04             	add    $0x4,%ebx
  800560:	85 c0                	test   %eax,%eax
  800562:	75 e7                	jne    80054b <runcmd+0x320>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800564:	c7 04 24 52 3f 80 00 	movl   $0x803f52,(%esp)
  80056b:	e8 b1 05 00 00       	call   800b21 <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800570:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800573:	89 44 24 04          	mov    %eax,0x4(%esp)
  800577:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80057a:	89 04 24             	mov    %eax,(%esp)
  80057d:	e8 ee 24 00 00       	call   802a70 <spawn>
  800582:	89 c3                	mov    %eax,%ebx
  800584:	85 c0                	test   %eax,%eax
  800586:	79 1e                	jns    8005a6 <runcmd+0x37b>
		cprintf("spawn %s: %e\n", argv[0], r);
  800588:	89 44 24 08          	mov    %eax,0x8(%esp)
  80058c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800593:	c7 04 24 0f 40 80 00 	movl   $0x80400f,(%esp)
  80059a:	e8 82 05 00 00       	call   800b21 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  80059f:	e8 0f 1f 00 00       	call   8024b3 <close_all>
  8005a4:	eb 5a                	jmp    800600 <runcmd+0x3d5>
  8005a6:	e8 08 1f 00 00       	call   8024b3 <close_all>
	if (r >= 0) {
		if (debug)
  8005ab:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005b2:	74 23                	je     8005d7 <runcmd+0x3ac>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005b4:	a1 28 64 80 00       	mov    0x806428,%eax
  8005b9:	8b 40 48             	mov    0x48(%eax),%eax
  8005bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005c0:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8005c3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005cb:	c7 04 24 1d 40 80 00 	movl   $0x80401d,(%esp)
  8005d2:	e8 4a 05 00 00       	call   800b21 <cprintf>
		wait(r);
  8005d7:	89 1c 24             	mov    %ebx,(%esp)
  8005da:	e8 f9 33 00 00       	call   8039d8 <wait>
		if (debug)
  8005df:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005e6:	74 18                	je     800600 <runcmd+0x3d5>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005e8:	a1 28 64 80 00       	mov    0x806428,%eax
  8005ed:	8b 40 48             	mov    0x48(%eax),%eax
  8005f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f4:	c7 04 24 32 40 80 00 	movl   $0x804032,(%esp)
  8005fb:	e8 21 05 00 00       	call   800b21 <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800600:	85 ff                	test   %edi,%edi
  800602:	74 4e                	je     800652 <runcmd+0x427>
		if (debug)
  800604:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80060b:	74 1c                	je     800629 <runcmd+0x3fe>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80060d:	a1 28 64 80 00       	mov    0x806428,%eax
  800612:	8b 40 48             	mov    0x48(%eax),%eax
  800615:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061d:	c7 04 24 48 40 80 00 	movl   $0x804048,(%esp)
  800624:	e8 f8 04 00 00       	call   800b21 <cprintf>
		wait(pipe_child);
  800629:	89 3c 24             	mov    %edi,(%esp)
  80062c:	e8 a7 33 00 00       	call   8039d8 <wait>
		if (debug)
  800631:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800638:	74 18                	je     800652 <runcmd+0x427>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80063a:	a1 28 64 80 00       	mov    0x806428,%eax
  80063f:	8b 40 48             	mov    0x48(%eax),%eax
  800642:	89 44 24 04          	mov    %eax,0x4(%esp)
  800646:	c7 04 24 32 40 80 00 	movl   $0x804032,(%esp)
  80064d:	e8 cf 04 00 00       	call   800b21 <cprintf>
	}

	// Done!
	exit();
  800652:	e8 fd 03 00 00       	call   800a54 <exit>
}
  800657:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  80065d:	5b                   	pop    %ebx
  80065e:	5e                   	pop    %esi
  80065f:	5f                   	pop    %edi
  800660:	5d                   	pop    %ebp
  800661:	c3                   	ret    

00800662 <umain>:
	exit();
}

void
umain(int argc, char **argv)
{
  800662:	55                   	push   %ebp
  800663:	89 e5                	mov    %esp,%ebp
  800665:	57                   	push   %edi
  800666:	56                   	push   %esi
  800667:	53                   	push   %ebx
  800668:	83 ec 4c             	sub    $0x4c,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  80066b:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80066e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800672:	8b 45 0c             	mov    0xc(%ebp),%eax
  800675:	89 44 24 04          	mov    %eax,0x4(%esp)
  800679:	8d 55 08             	lea    0x8(%ebp),%edx
  80067c:	89 14 24             	mov    %edx,(%esp)
  80067f:	e8 18 18 00 00       	call   801e9c <argstart>
  800684:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80068b:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  800690:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
  800693:	be 01 00 00 00       	mov    $0x1,%esi
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800698:	eb 2b                	jmp    8006c5 <umain+0x63>
		switch (r) {
  80069a:	83 f8 69             	cmp    $0x69,%eax
  80069d:	74 0c                	je     8006ab <umain+0x49>
  80069f:	83 f8 78             	cmp    $0x78,%eax
  8006a2:	74 0e                	je     8006b2 <umain+0x50>
  8006a4:	83 f8 64             	cmp    $0x64,%eax
  8006a7:	75 17                	jne    8006c0 <umain+0x5e>
  8006a9:	eb 0c                	jmp    8006b7 <umain+0x55>
  8006ab:	89 f7                	mov    %esi,%edi
  8006ad:	8d 76 00             	lea    0x0(%esi),%esi
  8006b0:	eb 13                	jmp    8006c5 <umain+0x63>
  8006b2:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8006b5:	eb 0e                	jmp    8006c5 <umain+0x63>
		case 'd':
			debug++;
  8006b7:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006be:	eb 05                	jmp    8006c5 <umain+0x63>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006c0:	e8 7b f9 ff ff       	call   800040 <usage>
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006c5:	89 1c 24             	mov    %ebx,(%esp)
  8006c8:	e8 8f 18 00 00       	call   801f5c <argnext>
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	79 c9                	jns    80069a <umain+0x38>
  8006d1:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006d3:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006d7:	7e 05                	jle    8006de <umain+0x7c>
		usage();
  8006d9:	e8 62 f9 ff ff       	call   800040 <usage>
	if (argc == 2) {
  8006de:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006e2:	75 76                	jne    80075a <umain+0xf8>
		close(0);
  8006e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006eb:	e8 46 1d 00 00       	call   802436 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006f3:	83 c6 04             	add    $0x4,%esi
  8006f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8006fd:	00 
  8006fe:	8b 06                	mov    (%esi),%eax
  800700:	89 04 24             	mov    %eax,(%esp)
  800703:	e8 a3 21 00 00       	call   8028ab <open>
  800708:	85 c0                	test   %eax,%eax
  80070a:	79 26                	jns    800732 <umain+0xd0>
			panic("open %s: %e", argv[1], r);
  80070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800710:	8b 06                	mov    (%esi),%eax
  800712:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800716:	c7 44 24 08 65 40 80 	movl   $0x804065,0x8(%esp)
  80071d:	00 
  80071e:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  800725:	00 
  800726:	c7 04 24 e8 3f 80 00 	movl   $0x803fe8,(%esp)
  80072d:	e8 36 03 00 00       	call   800a68 <_panic>
		assert(r == 0);
  800732:	85 c0                	test   %eax,%eax
  800734:	74 24                	je     80075a <umain+0xf8>
  800736:	c7 44 24 0c 71 40 80 	movl   $0x804071,0xc(%esp)
  80073d:	00 
  80073e:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  800745:	00 
  800746:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  80074d:	00 
  80074e:	c7 04 24 e8 3f 80 00 	movl   $0x803fe8,(%esp)
  800755:	e8 0e 03 00 00       	call   800a68 <_panic>
	}
	if (interactive == '?')
  80075a:	83 fb 3f             	cmp    $0x3f,%ebx
  80075d:	75 0e                	jne    80076d <umain+0x10b>
		interactive = iscons(0);
  80075f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800766:	e8 32 02 00 00       	call   80099d <iscons>
  80076b:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  80076d:	85 ff                	test   %edi,%edi
  80076f:	b8 00 00 00 00       	mov    $0x0,%eax
  800774:	ba 8d 40 80 00       	mov    $0x80408d,%edx
  800779:	0f 45 c2             	cmovne %edx,%eax
  80077c:	89 04 24             	mov    %eax,(%esp)
  80077f:	e8 cc 09 00 00       	call   801150 <readline>
  800784:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800786:	85 c0                	test   %eax,%eax
  800788:	75 1a                	jne    8007a4 <umain+0x142>
			if (debug)
  80078a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800791:	74 0c                	je     80079f <umain+0x13d>
				cprintf("EXITING\n");
  800793:	c7 04 24 90 40 80 00 	movl   $0x804090,(%esp)
  80079a:	e8 82 03 00 00       	call   800b21 <cprintf>
			exit();	// end of file
  80079f:	e8 b0 02 00 00       	call   800a54 <exit>
		}
		if (debug)
  8007a4:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007ab:	74 10                	je     8007bd <umain+0x15b>
			cprintf("LINE: %s\n", buf);
  8007ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b1:	c7 04 24 99 40 80 00 	movl   $0x804099,(%esp)
  8007b8:	e8 64 03 00 00       	call   800b21 <cprintf>
		if (buf[0] == '#')
  8007bd:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007c0:	74 ab                	je     80076d <umain+0x10b>
			continue;
		if (echocmds)
  8007c2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007c6:	74 10                	je     8007d8 <umain+0x176>
			printf("# %s\n", buf);
  8007c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007cc:	c7 04 24 a3 40 80 00 	movl   $0x8040a3,(%esp)
  8007d3:	e8 1f 22 00 00       	call   8029f7 <printf>
		if (debug)
  8007d8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007df:	74 0c                	je     8007ed <umain+0x18b>
			cprintf("BEFORE FORK\n");
  8007e1:	c7 04 24 a9 40 80 00 	movl   $0x8040a9,(%esp)
  8007e8:	e8 34 03 00 00       	call   800b21 <cprintf>
		if ((r = fork()) < 0)
  8007ed:	e8 14 13 00 00       	call   801b06 <fork>
  8007f2:	89 c6                	mov    %eax,%esi
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	79 20                	jns    800818 <umain+0x1b6>
			panic("fork: %e", r);
  8007f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fc:	c7 44 24 08 6a 44 80 	movl   $0x80446a,0x8(%esp)
  800803:	00 
  800804:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  80080b:	00 
  80080c:	c7 04 24 e8 3f 80 00 	movl   $0x803fe8,(%esp)
  800813:	e8 50 02 00 00       	call   800a68 <_panic>
		if (debug)
  800818:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80081f:	74 10                	je     800831 <umain+0x1cf>
			cprintf("FORK: %d\n", r);
  800821:	89 44 24 04          	mov    %eax,0x4(%esp)
  800825:	c7 04 24 b6 40 80 00 	movl   $0x8040b6,(%esp)
  80082c:	e8 f0 02 00 00       	call   800b21 <cprintf>
		if (r == 0) {
  800831:	85 f6                	test   %esi,%esi
  800833:	75 12                	jne    800847 <umain+0x1e5>
			runcmd(buf);
  800835:	89 1c 24             	mov    %ebx,(%esp)
  800838:	e8 ee f9 ff ff       	call   80022b <runcmd>
			exit();
  80083d:	e8 12 02 00 00       	call   800a54 <exit>
  800842:	e9 26 ff ff ff       	jmp    80076d <umain+0x10b>
		} else
			wait(r);
  800847:	89 34 24             	mov    %esi,(%esp)
  80084a:	e8 89 31 00 00       	call   8039d8 <wait>
  80084f:	90                   	nop
  800850:	e9 18 ff ff ff       	jmp    80076d <umain+0x10b>
	...

00800860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800870:	c7 44 24 04 c0 40 80 	movl   $0x8040c0,0x4(%esp)
  800877:	00 
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	89 04 24             	mov    %eax,(%esp)
  80087e:	e8 f6 09 00 00       	call   801279 <strcpy>
	return 0;
}
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	57                   	push   %edi
  80088e:	56                   	push   %esi
  80088f:	53                   	push   %ebx
  800890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  800896:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80089b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008a1:	eb 34                	jmp    8008d7 <devcons_write+0x4d>
		m = n - tot;
  8008a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008a6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8008a8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8008ae:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8008b3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008ba:	03 45 0c             	add    0xc(%ebp),%eax
  8008bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c1:	89 3c 24             	mov    %edi,(%esp)
  8008c4:	e8 56 0b 00 00       	call   80141f <memmove>
		sys_cputs(buf, m);
  8008c9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008cd:	89 3c 24             	mov    %edi,(%esp)
  8008d0:	e8 5b 0d 00 00       	call   801630 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008d5:	01 de                	add    %ebx,%esi
  8008d7:	89 f0                	mov    %esi,%eax
  8008d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008dc:	72 c5                	jb     8008a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008de:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5f                   	pop    %edi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8008f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8008fc:	00 
  8008fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800900:	89 04 24             	mov    %eax,(%esp)
  800903:	e8 28 0d 00 00       	call   801630 <sys_cputs>
}
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  800910:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800914:	75 07                	jne    80091d <devcons_read+0x13>
  800916:	eb 28                	jmp    800940 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800918:	e8 00 11 00 00       	call   801a1d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80091d:	8d 76 00             	lea    0x0(%esi),%esi
  800920:	e8 d7 0c 00 00       	call   8015fc <sys_cgetc>
  800925:	85 c0                	test   %eax,%eax
  800927:	74 ef                	je     800918 <devcons_read+0xe>
  800929:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80092b:	85 c0                	test   %eax,%eax
  80092d:	78 16                	js     800945 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80092f:	83 f8 04             	cmp    $0x4,%eax
  800932:	74 0c                	je     800940 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800934:	8b 45 0c             	mov    0xc(%ebp),%eax
  800937:	88 10                	mov    %dl,(%eax)
  800939:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80093e:	eb 05                	jmp    800945 <devcons_read+0x3b>
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800945:	c9                   	leave  
  800946:	c3                   	ret    

00800947 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80094d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800950:	89 04 24             	mov    %eax,(%esp)
  800953:	e8 c7 16 00 00       	call   80201f <fd_alloc>
  800958:	85 c0                	test   %eax,%eax
  80095a:	78 3f                	js     80099b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80095c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800963:	00 
  800964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800972:	e8 47 10 00 00       	call   8019be <sys_page_alloc>
  800977:	85 c0                	test   %eax,%eax
  800979:	78 20                	js     80099b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80097b:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800984:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800989:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800993:	89 04 24             	mov    %eax,(%esp)
  800996:	e8 59 16 00 00       	call   801ff4 <fd2num>
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 04 24             	mov    %eax,(%esp)
  8009b0:	e8 c3 16 00 00       	call   802078 <fd_lookup>
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	78 11                	js     8009ca <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8009b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	3b 05 00 50 80 00    	cmp    0x805000,%eax
  8009c4:	0f 94 c0             	sete   %al
  8009c7:	0f b6 c0             	movzbl %al,%eax
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8009d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8009d9:	00 
  8009da:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009e8:	e8 e2 18 00 00       	call   8022cf <read>
	if (r < 0)
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	78 0f                	js     800a00 <getchar+0x34>
		return r;
	if (r < 1)
  8009f1:	85 c0                	test   %eax,%eax
  8009f3:	7f 07                	jg     8009fc <getchar+0x30>
  8009f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8009fa:	eb 04                	jmp    800a00 <getchar+0x34>
		return -E_EOF;
	return c;
  8009fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    
	...

00800a04 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 18             	sub    $0x18,%esp
  800a0a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a0d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800a10:	8b 75 08             	mov    0x8(%ebp),%esi
  800a13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800a16:	e8 36 10 00 00       	call   801a51 <sys_getenvid>
  800a1b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a20:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a23:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800a28:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2d:	85 f6                	test   %esi,%esi
  800a2f:	7e 07                	jle    800a38 <libmain+0x34>
		binaryname = argv[0];
  800a31:	8b 03                	mov    (%ebx),%eax
  800a33:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a38:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a3c:	89 34 24             	mov    %esi,(%esp)
  800a3f:	e8 1e fc ff ff       	call   800662 <umain>

	// exit gracefully
	exit();
  800a44:	e8 0b 00 00 00       	call   800a54 <exit>
}
  800a49:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800a4c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800a4f:	89 ec                	mov    %ebp,%esp
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    
	...

00800a54 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800a5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a61:	e8 1f 10 00 00       	call   801a85 <sys_env_destroy>
}
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	56                   	push   %esi
  800a6c:	53                   	push   %ebx
  800a6d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800a70:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a73:	8b 1d 1c 50 80 00    	mov    0x80501c,%ebx
  800a79:	e8 d3 0f 00 00       	call   801a51 <sys_getenvid>
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a81:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a85:	8b 55 08             	mov    0x8(%ebp),%edx
  800a88:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a94:	c7 04 24 d8 40 80 00 	movl   $0x8040d8,(%esp)
  800a9b:	e8 81 00 00 00       	call   800b21 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800aa0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa7:	89 04 24             	mov    %eax,(%esp)
  800aaa:	e8 11 00 00 00       	call   800ac0 <vcprintf>
	cprintf("\n");
  800aaf:	c7 04 24 52 3f 80 00 	movl   $0x803f52,(%esp)
  800ab6:	e8 66 00 00 00       	call   800b21 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800abb:	cc                   	int3   
  800abc:	eb fd                	jmp    800abb <_panic+0x53>
	...

00800ac0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800ac9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ad0:	00 00 00 
	b.cnt = 0;
  800ad3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ada:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aeb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af5:	c7 04 24 3b 0b 80 00 	movl   $0x800b3b,(%esp)
  800afc:	e8 be 01 00 00       	call   800cbf <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b01:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b11:	89 04 24             	mov    %eax,(%esp)
  800b14:	e8 17 0b 00 00       	call   801630 <sys_cputs>

	return b.cnt;
}
  800b19:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800b27:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	89 04 24             	mov    %eax,(%esp)
  800b34:	e8 87 ff ff ff       	call   800ac0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	53                   	push   %ebx
  800b3f:	83 ec 14             	sub    $0x14,%esp
  800b42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b45:	8b 03                	mov    (%ebx),%eax
  800b47:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800b53:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b58:	75 19                	jne    800b73 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800b5a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800b61:	00 
  800b62:	8d 43 08             	lea    0x8(%ebx),%eax
  800b65:	89 04 24             	mov    %eax,(%esp)
  800b68:	e8 c3 0a 00 00       	call   801630 <sys_cputs>
		b->idx = 0;
  800b6d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800b73:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b77:	83 c4 14             	add    $0x14,%esp
  800b7a:	5b                   	pop    %ebx
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    
  800b7d:	00 00                	add    %al,(%eax)
	...

00800b80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	83 ec 4c             	sub    $0x4c,%esp
  800b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b8c:	89 d6                	mov    %edx,%esi
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b97:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800ba0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ba6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bab:	39 d1                	cmp    %edx,%ecx
  800bad:	72 07                	jb     800bb6 <printnum+0x36>
  800baf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bb2:	39 d0                	cmp    %edx,%eax
  800bb4:	77 69                	ja     800c1f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bb6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800bba:	83 eb 01             	sub    $0x1,%ebx
  800bbd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800bc9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800bcd:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800bd0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800bd3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800bd6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800bda:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800be1:	00 
  800be2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800be5:	89 04 24             	mov    %eax,(%esp)
  800be8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800beb:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bef:	e8 5c 30 00 00       	call   803c50 <__udivdi3>
  800bf4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800bf7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800bfa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bfe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800c02:	89 04 24             	mov    %eax,(%esp)
  800c05:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c09:	89 f2                	mov    %esi,%edx
  800c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c0e:	e8 6d ff ff ff       	call   800b80 <printnum>
  800c13:	eb 11                	jmp    800c26 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c19:	89 3c 24             	mov    %edi,(%esp)
  800c1c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c1f:	83 eb 01             	sub    $0x1,%ebx
  800c22:	85 db                	test   %ebx,%ebx
  800c24:	7f ef                	jg     800c15 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c26:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c2a:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c31:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c35:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800c3c:	00 
  800c3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c40:	89 14 24             	mov    %edx,(%esp)
  800c43:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c4a:	e8 31 31 00 00       	call   803d80 <__umoddi3>
  800c4f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c53:	0f be 80 fb 40 80 00 	movsbl 0x8040fb(%eax),%eax
  800c5a:	89 04 24             	mov    %eax,(%esp)
  800c5d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800c60:	83 c4 4c             	add    $0x4c,%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c6b:	83 fa 01             	cmp    $0x1,%edx
  800c6e:	7e 0e                	jle    800c7e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c70:	8b 10                	mov    (%eax),%edx
  800c72:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c75:	89 08                	mov    %ecx,(%eax)
  800c77:	8b 02                	mov    (%edx),%eax
  800c79:	8b 52 04             	mov    0x4(%edx),%edx
  800c7c:	eb 22                	jmp    800ca0 <getuint+0x38>
	else if (lflag)
  800c7e:	85 d2                	test   %edx,%edx
  800c80:	74 10                	je     800c92 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c82:	8b 10                	mov    (%eax),%edx
  800c84:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c87:	89 08                	mov    %ecx,(%eax)
  800c89:	8b 02                	mov    (%edx),%eax
  800c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c90:	eb 0e                	jmp    800ca0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800c92:	8b 10                	mov    (%eax),%edx
  800c94:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c97:	89 08                	mov    %ecx,(%eax)
  800c99:	8b 02                	mov    (%edx),%eax
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800ca8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800cac:	8b 10                	mov    (%eax),%edx
  800cae:	3b 50 04             	cmp    0x4(%eax),%edx
  800cb1:	73 0a                	jae    800cbd <sprintputch+0x1b>
		*b->buf++ = ch;
  800cb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb6:	88 0a                	mov    %cl,(%edx)
  800cb8:	83 c2 01             	add    $0x1,%edx
  800cbb:	89 10                	mov    %edx,(%eax)
}
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
  800cc5:	83 ec 4c             	sub    $0x4c,%esp
  800cc8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ccb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cce:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800cd8:	eb 11                	jmp    800ceb <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	0f 84 b6 03 00 00    	je     801098 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800ce2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ce6:	89 04 24             	mov    %eax,(%esp)
  800ce9:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ceb:	0f b6 03             	movzbl (%ebx),%eax
  800cee:	83 c3 01             	add    $0x1,%ebx
  800cf1:	83 f8 25             	cmp    $0x25,%eax
  800cf4:	75 e4                	jne    800cda <vprintfmt+0x1b>
  800cf6:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800cfa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800d01:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800d08:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800d0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d14:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d17:	eb 06                	jmp    800d1f <vprintfmt+0x60>
  800d19:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800d1d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d1f:	0f b6 0b             	movzbl (%ebx),%ecx
  800d22:	0f b6 c1             	movzbl %cl,%eax
  800d25:	8d 53 01             	lea    0x1(%ebx),%edx
  800d28:	83 e9 23             	sub    $0x23,%ecx
  800d2b:	80 f9 55             	cmp    $0x55,%cl
  800d2e:	0f 87 47 03 00 00    	ja     80107b <vprintfmt+0x3bc>
  800d34:	0f b6 c9             	movzbl %cl,%ecx
  800d37:	ff 24 8d 40 42 80 00 	jmp    *0x804240(,%ecx,4)
  800d3e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800d42:	eb d9                	jmp    800d1d <vprintfmt+0x5e>
  800d44:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800d4b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d50:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800d53:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800d57:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800d5a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800d5d:	83 fb 09             	cmp    $0x9,%ebx
  800d60:	77 30                	ja     800d92 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d62:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d65:	eb e9                	jmp    800d50 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	8d 48 04             	lea    0x4(%eax),%ecx
  800d6d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800d75:	eb 1e                	jmp    800d95 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800d77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d80:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800d84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d87:	eb 94                	jmp    800d1d <vprintfmt+0x5e>
  800d89:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800d90:	eb 8b                	jmp    800d1d <vprintfmt+0x5e>
  800d92:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800d95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d99:	79 82                	jns    800d1d <vprintfmt+0x5e>
  800d9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800da1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800da4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800da7:	e9 71 ff ff ff       	jmp    800d1d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dac:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800db0:	e9 68 ff ff ff       	jmp    800d1d <vprintfmt+0x5e>
  800db5:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800db8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbb:	8d 50 04             	lea    0x4(%eax),%edx
  800dbe:	89 55 14             	mov    %edx,0x14(%ebp)
  800dc1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dc5:	8b 00                	mov    (%eax),%eax
  800dc7:	89 04 24             	mov    %eax,(%esp)
  800dca:	ff d7                	call   *%edi
  800dcc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800dcf:	e9 17 ff ff ff       	jmp    800ceb <vprintfmt+0x2c>
  800dd4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	8d 50 04             	lea    0x4(%eax),%edx
  800ddd:	89 55 14             	mov    %edx,0x14(%ebp)
  800de0:	8b 00                	mov    (%eax),%eax
  800de2:	89 c2                	mov    %eax,%edx
  800de4:	c1 fa 1f             	sar    $0x1f,%edx
  800de7:	31 d0                	xor    %edx,%eax
  800de9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800deb:	83 f8 11             	cmp    $0x11,%eax
  800dee:	7f 0b                	jg     800dfb <vprintfmt+0x13c>
  800df0:	8b 14 85 a0 43 80 00 	mov    0x8043a0(,%eax,4),%edx
  800df7:	85 d2                	test   %edx,%edx
  800df9:	75 20                	jne    800e1b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800dfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800dff:	c7 44 24 08 0c 41 80 	movl   $0x80410c,0x8(%esp)
  800e06:	00 
  800e07:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e0b:	89 3c 24             	mov    %edi,(%esp)
  800e0e:	e8 0d 03 00 00       	call   801120 <printfmt>
  800e13:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e16:	e9 d0 fe ff ff       	jmp    800ceb <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e1f:	c7 44 24 08 8a 40 80 	movl   $0x80408a,0x8(%esp)
  800e26:	00 
  800e27:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e2b:	89 3c 24             	mov    %edi,(%esp)
  800e2e:	e8 ed 02 00 00       	call   801120 <printfmt>
  800e33:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800e36:	e9 b0 fe ff ff       	jmp    800ceb <vprintfmt+0x2c>
  800e3b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800e3e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e47:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4a:	8d 50 04             	lea    0x4(%eax),%edx
  800e4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800e50:	8b 18                	mov    (%eax),%ebx
  800e52:	85 db                	test   %ebx,%ebx
  800e54:	b8 15 41 80 00       	mov    $0x804115,%eax
  800e59:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800e5c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e60:	7e 76                	jle    800ed8 <vprintfmt+0x219>
  800e62:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800e66:	74 7a                	je     800ee2 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e68:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e6c:	89 1c 24             	mov    %ebx,(%esp)
  800e6f:	e8 e4 03 00 00       	call   801258 <strnlen>
  800e74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e77:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800e79:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800e7d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e80:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800e83:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e85:	eb 0f                	jmp    800e96 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800e87:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e8e:	89 04 24             	mov    %eax,(%esp)
  800e91:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e93:	83 eb 01             	sub    $0x1,%ebx
  800e96:	85 db                	test   %ebx,%ebx
  800e98:	7f ed                	jg     800e87 <vprintfmt+0x1c8>
  800e9a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800e9d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ea0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800ea3:	89 f7                	mov    %esi,%edi
  800ea5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800ea8:	eb 40                	jmp    800eea <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800eaa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800eae:	74 18                	je     800ec8 <vprintfmt+0x209>
  800eb0:	8d 50 e0             	lea    -0x20(%eax),%edx
  800eb3:	83 fa 5e             	cmp    $0x5e,%edx
  800eb6:	76 10                	jbe    800ec8 <vprintfmt+0x209>
					putch('?', putdat);
  800eb8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ebc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ec3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ec6:	eb 0a                	jmp    800ed2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800ec8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ecc:	89 04 24             	mov    %eax,(%esp)
  800ecf:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800ed6:	eb 12                	jmp    800eea <vprintfmt+0x22b>
  800ed8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800edb:	89 f7                	mov    %esi,%edi
  800edd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800ee0:	eb 08                	jmp    800eea <vprintfmt+0x22b>
  800ee2:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800ee5:	89 f7                	mov    %esi,%edi
  800ee7:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800eea:	0f be 03             	movsbl (%ebx),%eax
  800eed:	83 c3 01             	add    $0x1,%ebx
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	74 25                	je     800f19 <vprintfmt+0x25a>
  800ef4:	85 f6                	test   %esi,%esi
  800ef6:	78 b2                	js     800eaa <vprintfmt+0x1eb>
  800ef8:	83 ee 01             	sub    $0x1,%esi
  800efb:	79 ad                	jns    800eaa <vprintfmt+0x1eb>
  800efd:	89 fe                	mov    %edi,%esi
  800eff:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800f02:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800f05:	eb 1a                	jmp    800f21 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f07:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f0b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f12:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f14:	83 eb 01             	sub    $0x1,%ebx
  800f17:	eb 08                	jmp    800f21 <vprintfmt+0x262>
  800f19:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800f1c:	89 fe                	mov    %edi,%esi
  800f1e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800f21:	85 db                	test   %ebx,%ebx
  800f23:	7f e2                	jg     800f07 <vprintfmt+0x248>
  800f25:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800f28:	e9 be fd ff ff       	jmp    800ceb <vprintfmt+0x2c>
  800f2d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800f30:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f33:	83 f9 01             	cmp    $0x1,%ecx
  800f36:	7e 16                	jle    800f4e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800f38:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3b:	8d 50 08             	lea    0x8(%eax),%edx
  800f3e:	89 55 14             	mov    %edx,0x14(%ebp)
  800f41:	8b 10                	mov    (%eax),%edx
  800f43:	8b 48 04             	mov    0x4(%eax),%ecx
  800f46:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800f49:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f4c:	eb 32                	jmp    800f80 <vprintfmt+0x2c1>
	else if (lflag)
  800f4e:	85 c9                	test   %ecx,%ecx
  800f50:	74 18                	je     800f6a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	8d 50 04             	lea    0x4(%eax),%edx
  800f58:	89 55 14             	mov    %edx,0x14(%ebp)
  800f5b:	8b 00                	mov    (%eax),%eax
  800f5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f60:	89 c1                	mov    %eax,%ecx
  800f62:	c1 f9 1f             	sar    $0x1f,%ecx
  800f65:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f68:	eb 16                	jmp    800f80 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	8d 50 04             	lea    0x4(%eax),%edx
  800f70:	89 55 14             	mov    %edx,0x14(%ebp)
  800f73:	8b 00                	mov    (%eax),%eax
  800f75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f78:	89 c2                	mov    %eax,%edx
  800f7a:	c1 fa 1f             	sar    $0x1f,%edx
  800f7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f80:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800f83:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f86:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800f8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f8f:	0f 89 a7 00 00 00    	jns    80103c <vprintfmt+0x37d>
				putch('-', putdat);
  800f95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f99:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800fa0:	ff d7                	call   *%edi
				num = -(long long) num;
  800fa2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800fa5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fa8:	f7 d9                	neg    %ecx
  800faa:	83 d3 00             	adc    $0x0,%ebx
  800fad:	f7 db                	neg    %ebx
  800faf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb4:	e9 83 00 00 00       	jmp    80103c <vprintfmt+0x37d>
  800fb9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800fbc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fbf:	89 ca                	mov    %ecx,%edx
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	e8 9f fc ff ff       	call   800c68 <getuint>
  800fc9:	89 c1                	mov    %eax,%ecx
  800fcb:	89 d3                	mov    %edx,%ebx
  800fcd:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800fd2:	eb 68                	jmp    80103c <vprintfmt+0x37d>
  800fd4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800fd7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800fda:	89 ca                	mov    %ecx,%edx
  800fdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdf:	e8 84 fc ff ff       	call   800c68 <getuint>
  800fe4:	89 c1                	mov    %eax,%ecx
  800fe6:	89 d3                	mov    %edx,%ebx
  800fe8:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800fed:	eb 4d                	jmp    80103c <vprintfmt+0x37d>
  800fef:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800ff2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ff6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800ffd:	ff d7                	call   *%edi
			putch('x', putdat);
  800fff:	89 74 24 04          	mov    %esi,0x4(%esp)
  801003:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80100a:	ff d7                	call   *%edi
			num = (unsigned long long)
  80100c:	8b 45 14             	mov    0x14(%ebp),%eax
  80100f:	8d 50 04             	lea    0x4(%eax),%edx
  801012:	89 55 14             	mov    %edx,0x14(%ebp)
  801015:	8b 08                	mov    (%eax),%ecx
  801017:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801021:	eb 19                	jmp    80103c <vprintfmt+0x37d>
  801023:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801026:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801029:	89 ca                	mov    %ecx,%edx
  80102b:	8d 45 14             	lea    0x14(%ebp),%eax
  80102e:	e8 35 fc ff ff       	call   800c68 <getuint>
  801033:	89 c1                	mov    %eax,%ecx
  801035:	89 d3                	mov    %edx,%ebx
  801037:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80103c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  801040:	89 54 24 10          	mov    %edx,0x10(%esp)
  801044:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801047:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80104b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80104f:	89 0c 24             	mov    %ecx,(%esp)
  801052:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801056:	89 f2                	mov    %esi,%edx
  801058:	89 f8                	mov    %edi,%eax
  80105a:	e8 21 fb ff ff       	call   800b80 <printnum>
  80105f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  801062:	e9 84 fc ff ff       	jmp    800ceb <vprintfmt+0x2c>
  801067:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80106a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80106e:	89 04 24             	mov    %eax,(%esp)
  801071:	ff d7                	call   *%edi
  801073:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  801076:	e9 70 fc ff ff       	jmp    800ceb <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80107b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80107f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801086:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801088:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80108b:	80 38 25             	cmpb   $0x25,(%eax)
  80108e:	0f 84 57 fc ff ff    	je     800ceb <vprintfmt+0x2c>
  801094:	89 c3                	mov    %eax,%ebx
  801096:	eb f0                	jmp    801088 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  801098:	83 c4 4c             	add    $0x4c,%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 28             	sub    $0x28,%esp
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	74 04                	je     8010b4 <vsnprintf+0x14>
  8010b0:	85 d2                	test   %edx,%edx
  8010b2:	7f 07                	jg     8010bb <vsnprintf+0x1b>
  8010b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b9:	eb 3b                	jmp    8010f6 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010be:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8010c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010e1:	c7 04 24 a2 0c 80 00 	movl   $0x800ca2,(%esp)
  8010e8:	e8 d2 fb ff ff       	call   800cbf <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010f6:	c9                   	leave  
  8010f7:	c3                   	ret    

008010f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8010fe:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  801101:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	89 44 24 08          	mov    %eax,0x8(%esp)
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	89 04 24             	mov    %eax,(%esp)
  801119:	e8 82 ff ff ff       	call   8010a0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  801126:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  801129:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	89 44 24 08          	mov    %eax,0x8(%esp)
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	89 04 24             	mov    %eax,(%esp)
  801141:	e8 79 fb ff ff       	call   800cbf <vprintfmt>
	va_end(ap);
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    
	...

00801150 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	57                   	push   %edi
  801154:	56                   	push   %esi
  801155:	53                   	push   %ebx
  801156:	83 ec 1c             	sub    $0x1c,%esp
  801159:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	74 18                	je     801178 <readline+0x28>
		fprintf(1, "%s", prompt);
  801160:	89 44 24 08          	mov    %eax,0x8(%esp)
  801164:	c7 44 24 04 8a 40 80 	movl   $0x80408a,0x4(%esp)
  80116b:	00 
  80116c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801173:	e8 a1 18 00 00       	call   802a19 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  801178:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80117f:	e8 19 f8 ff ff       	call   80099d <iscons>
  801184:	89 c7                	mov    %eax,%edi
  801186:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  80118b:	e8 3c f8 ff ff       	call   8009cc <getchar>
  801190:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801192:	85 c0                	test   %eax,%eax
  801194:	79 25                	jns    8011bb <readline+0x6b>
			if (c != -E_EOF)
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
  80119b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80119e:	0f 84 88 00 00 00    	je     80122c <readline+0xdc>
				cprintf("read error: %e\n", c);
  8011a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a8:	c7 04 24 07 44 80 00 	movl   $0x804407,(%esp)
  8011af:	e8 6d f9 ff ff       	call   800b21 <cprintf>
  8011b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b9:	eb 71                	jmp    80122c <readline+0xdc>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011bb:	83 f8 08             	cmp    $0x8,%eax
  8011be:	74 05                	je     8011c5 <readline+0x75>
  8011c0:	83 f8 7f             	cmp    $0x7f,%eax
  8011c3:	75 19                	jne    8011de <readline+0x8e>
  8011c5:	85 f6                	test   %esi,%esi
  8011c7:	7e 15                	jle    8011de <readline+0x8e>
			if (echoing)
  8011c9:	85 ff                	test   %edi,%edi
  8011cb:	74 0c                	je     8011d9 <readline+0x89>
				cputchar('\b');
  8011cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8011d4:	e8 10 f7 ff ff       	call   8008e9 <cputchar>
			i--;
  8011d9:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011dc:	eb ad                	jmp    80118b <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011de:	83 fb 1f             	cmp    $0x1f,%ebx
  8011e1:	7e 1f                	jle    801202 <readline+0xb2>
  8011e3:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011e9:	7f 17                	jg     801202 <readline+0xb2>
			if (echoing)
  8011eb:	85 ff                	test   %edi,%edi
  8011ed:	74 08                	je     8011f7 <readline+0xa7>
				cputchar(c);
  8011ef:	89 1c 24             	mov    %ebx,(%esp)
  8011f2:	e8 f2 f6 ff ff       	call   8008e9 <cputchar>
			buf[i++] = c;
  8011f7:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8011fd:	83 c6 01             	add    $0x1,%esi
  801200:	eb 89                	jmp    80118b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801202:	83 fb 0a             	cmp    $0xa,%ebx
  801205:	74 09                	je     801210 <readline+0xc0>
  801207:	83 fb 0d             	cmp    $0xd,%ebx
  80120a:	0f 85 7b ff ff ff    	jne    80118b <readline+0x3b>
			if (echoing)
  801210:	85 ff                	test   %edi,%edi
  801212:	74 0c                	je     801220 <readline+0xd0>
				cputchar('\n');
  801214:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80121b:	e8 c9 f6 ff ff       	call   8008e9 <cputchar>
			buf[i] = 0;
  801220:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
  801227:	b8 20 60 80 00       	mov    $0x806020,%eax
			return buf;
		}
	}
}
  80122c:	83 c4 1c             	add    $0x1c,%esp
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    
	...

00801240 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80124b:	eb 03                	jmp    801250 <strlen+0x10>
		n++;
  80124d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801250:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801254:	75 f7                	jne    80124d <strlen+0xd>
		n++;
	return n;
}
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	53                   	push   %ebx
  80125c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80125f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801262:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801267:	eb 03                	jmp    80126c <strnlen+0x14>
		n++;
  801269:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126c:	39 c1                	cmp    %eax,%ecx
  80126e:	74 06                	je     801276 <strnlen+0x1e>
  801270:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  801274:	75 f3                	jne    801269 <strnlen+0x11>
		n++;
	return n;
}
  801276:	5b                   	pop    %ebx
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801283:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801288:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80128c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80128f:	83 c2 01             	add    $0x1,%edx
  801292:	84 c9                	test   %cl,%cl
  801294:	75 f2                	jne    801288 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801296:	5b                   	pop    %ebx
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	53                   	push   %ebx
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012a3:	89 1c 24             	mov    %ebx,(%esp)
  8012a6:	e8 95 ff ff ff       	call   801240 <strlen>
	strcpy(dst + len, src);
  8012ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012b2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8012b5:	89 04 24             	mov    %eax,(%esp)
  8012b8:	e8 bc ff ff ff       	call   801279 <strcpy>
	return dst;
}
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	83 c4 08             	add    $0x8,%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d0:	8b 75 10             	mov    0x10(%ebp),%esi
  8012d3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d8:	eb 0f                	jmp    8012e9 <strncpy+0x24>
		*dst++ = *src;
  8012da:	0f b6 19             	movzbl (%ecx),%ebx
  8012dd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012e0:	80 39 01             	cmpb   $0x1,(%ecx)
  8012e3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e6:	83 c2 01             	add    $0x1,%edx
  8012e9:	39 f2                	cmp    %esi,%edx
  8012eb:	72 ed                	jb     8012da <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	56                   	push   %esi
  8012f5:	53                   	push   %ebx
  8012f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012ff:	89 f0                	mov    %esi,%eax
  801301:	85 d2                	test   %edx,%edx
  801303:	75 0a                	jne    80130f <strlcpy+0x1e>
  801305:	eb 17                	jmp    80131e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801307:	88 18                	mov    %bl,(%eax)
  801309:	83 c0 01             	add    $0x1,%eax
  80130c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80130f:	83 ea 01             	sub    $0x1,%edx
  801312:	74 07                	je     80131b <strlcpy+0x2a>
  801314:	0f b6 19             	movzbl (%ecx),%ebx
  801317:	84 db                	test   %bl,%bl
  801319:	75 ec                	jne    801307 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80131b:	c6 00 00             	movb   $0x0,(%eax)
  80131e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80132d:	eb 06                	jmp    801335 <strcmp+0x11>
		p++, q++;
  80132f:	83 c1 01             	add    $0x1,%ecx
  801332:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801335:	0f b6 01             	movzbl (%ecx),%eax
  801338:	84 c0                	test   %al,%al
  80133a:	74 04                	je     801340 <strcmp+0x1c>
  80133c:	3a 02                	cmp    (%edx),%al
  80133e:	74 ef                	je     80132f <strcmp+0xb>
  801340:	0f b6 c0             	movzbl %al,%eax
  801343:	0f b6 12             	movzbl (%edx),%edx
  801346:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801354:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  801357:	eb 09                	jmp    801362 <strncmp+0x18>
		n--, p++, q++;
  801359:	83 ea 01             	sub    $0x1,%edx
  80135c:	83 c0 01             	add    $0x1,%eax
  80135f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801362:	85 d2                	test   %edx,%edx
  801364:	75 07                	jne    80136d <strncmp+0x23>
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	eb 13                	jmp    801380 <strncmp+0x36>
  80136d:	0f b6 18             	movzbl (%eax),%ebx
  801370:	84 db                	test   %bl,%bl
  801372:	74 04                	je     801378 <strncmp+0x2e>
  801374:	3a 19                	cmp    (%ecx),%bl
  801376:	74 e1                	je     801359 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801378:	0f b6 00             	movzbl (%eax),%eax
  80137b:	0f b6 11             	movzbl (%ecx),%edx
  80137e:	29 d0                	sub    %edx,%eax
}
  801380:	5b                   	pop    %ebx
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80138d:	eb 07                	jmp    801396 <strchr+0x13>
		if (*s == c)
  80138f:	38 ca                	cmp    %cl,%dl
  801391:	74 0f                	je     8013a2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801393:	83 c0 01             	add    $0x1,%eax
  801396:	0f b6 10             	movzbl (%eax),%edx
  801399:	84 d2                	test   %dl,%dl
  80139b:	75 f2                	jne    80138f <strchr+0xc>
  80139d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    

008013a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013ae:	eb 07                	jmp    8013b7 <strfind+0x13>
		if (*s == c)
  8013b0:	38 ca                	cmp    %cl,%dl
  8013b2:	74 0a                	je     8013be <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013b4:	83 c0 01             	add    $0x1,%eax
  8013b7:	0f b6 10             	movzbl (%eax),%edx
  8013ba:	84 d2                	test   %dl,%dl
  8013bc:	75 f2                	jne    8013b0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    

008013c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	89 1c 24             	mov    %ebx,(%esp)
  8013c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013da:	85 c9                	test   %ecx,%ecx
  8013dc:	74 30                	je     80140e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013de:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013e4:	75 25                	jne    80140b <memset+0x4b>
  8013e6:	f6 c1 03             	test   $0x3,%cl
  8013e9:	75 20                	jne    80140b <memset+0x4b>
		c &= 0xFF;
  8013eb:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013ee:	89 d3                	mov    %edx,%ebx
  8013f0:	c1 e3 08             	shl    $0x8,%ebx
  8013f3:	89 d6                	mov    %edx,%esi
  8013f5:	c1 e6 18             	shl    $0x18,%esi
  8013f8:	89 d0                	mov    %edx,%eax
  8013fa:	c1 e0 10             	shl    $0x10,%eax
  8013fd:	09 f0                	or     %esi,%eax
  8013ff:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  801401:	09 d8                	or     %ebx,%eax
  801403:	c1 e9 02             	shr    $0x2,%ecx
  801406:	fc                   	cld    
  801407:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801409:	eb 03                	jmp    80140e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80140b:	fc                   	cld    
  80140c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80140e:	89 f8                	mov    %edi,%eax
  801410:	8b 1c 24             	mov    (%esp),%ebx
  801413:	8b 74 24 04          	mov    0x4(%esp),%esi
  801417:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80141b:	89 ec                	mov    %ebp,%esp
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 08             	sub    $0x8,%esp
  801425:	89 34 24             	mov    %esi,(%esp)
  801428:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  801432:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  801435:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  801437:	39 c6                	cmp    %eax,%esi
  801439:	73 35                	jae    801470 <memmove+0x51>
  80143b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80143e:	39 d0                	cmp    %edx,%eax
  801440:	73 2e                	jae    801470 <memmove+0x51>
		s += n;
		d += n;
  801442:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801444:	f6 c2 03             	test   $0x3,%dl
  801447:	75 1b                	jne    801464 <memmove+0x45>
  801449:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80144f:	75 13                	jne    801464 <memmove+0x45>
  801451:	f6 c1 03             	test   $0x3,%cl
  801454:	75 0e                	jne    801464 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  801456:	83 ef 04             	sub    $0x4,%edi
  801459:	8d 72 fc             	lea    -0x4(%edx),%esi
  80145c:	c1 e9 02             	shr    $0x2,%ecx
  80145f:	fd                   	std    
  801460:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801462:	eb 09                	jmp    80146d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801464:	83 ef 01             	sub    $0x1,%edi
  801467:	8d 72 ff             	lea    -0x1(%edx),%esi
  80146a:	fd                   	std    
  80146b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80146d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80146e:	eb 20                	jmp    801490 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801470:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801476:	75 15                	jne    80148d <memmove+0x6e>
  801478:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80147e:	75 0d                	jne    80148d <memmove+0x6e>
  801480:	f6 c1 03             	test   $0x3,%cl
  801483:	75 08                	jne    80148d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  801485:	c1 e9 02             	shr    $0x2,%ecx
  801488:	fc                   	cld    
  801489:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80148b:	eb 03                	jmp    801490 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80148d:	fc                   	cld    
  80148e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801490:	8b 34 24             	mov    (%esp),%esi
  801493:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801497:	89 ec                	mov    %ebp,%esp
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	e8 65 ff ff ff       	call   80141f <memmove>
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	57                   	push   %edi
  8014c0:	56                   	push   %esi
  8014c1:	53                   	push   %ebx
  8014c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014d0:	eb 1c                	jmp    8014ee <memcmp+0x32>
		if (*s1 != *s2)
  8014d2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  8014d6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  8014da:	83 c2 01             	add    $0x1,%edx
  8014dd:	83 e9 01             	sub    $0x1,%ecx
  8014e0:	38 d8                	cmp    %bl,%al
  8014e2:	74 0a                	je     8014ee <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  8014e4:	0f b6 c0             	movzbl %al,%eax
  8014e7:	0f b6 db             	movzbl %bl,%ebx
  8014ea:	29 d8                	sub    %ebx,%eax
  8014ec:	eb 09                	jmp    8014f7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ee:	85 c9                	test   %ecx,%ecx
  8014f0:	75 e0                	jne    8014d2 <memcmp+0x16>
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5f                   	pop    %edi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801505:	89 c2                	mov    %eax,%edx
  801507:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80150a:	eb 07                	jmp    801513 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  80150c:	38 08                	cmp    %cl,(%eax)
  80150e:	74 07                	je     801517 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801510:	83 c0 01             	add    $0x1,%eax
  801513:	39 d0                	cmp    %edx,%eax
  801515:	72 f5                	jb     80150c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	57                   	push   %edi
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	8b 55 08             	mov    0x8(%ebp),%edx
  801525:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801528:	eb 03                	jmp    80152d <strtol+0x14>
		s++;
  80152a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80152d:	0f b6 02             	movzbl (%edx),%eax
  801530:	3c 20                	cmp    $0x20,%al
  801532:	74 f6                	je     80152a <strtol+0x11>
  801534:	3c 09                	cmp    $0x9,%al
  801536:	74 f2                	je     80152a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  801538:	3c 2b                	cmp    $0x2b,%al
  80153a:	75 0c                	jne    801548 <strtol+0x2f>
		s++;
  80153c:	8d 52 01             	lea    0x1(%edx),%edx
  80153f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801546:	eb 15                	jmp    80155d <strtol+0x44>
	else if (*s == '-')
  801548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80154f:	3c 2d                	cmp    $0x2d,%al
  801551:	75 0a                	jne    80155d <strtol+0x44>
		s++, neg = 1;
  801553:	8d 52 01             	lea    0x1(%edx),%edx
  801556:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80155d:	85 db                	test   %ebx,%ebx
  80155f:	0f 94 c0             	sete   %al
  801562:	74 05                	je     801569 <strtol+0x50>
  801564:	83 fb 10             	cmp    $0x10,%ebx
  801567:	75 15                	jne    80157e <strtol+0x65>
  801569:	80 3a 30             	cmpb   $0x30,(%edx)
  80156c:	75 10                	jne    80157e <strtol+0x65>
  80156e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801572:	75 0a                	jne    80157e <strtol+0x65>
		s += 2, base = 16;
  801574:	83 c2 02             	add    $0x2,%edx
  801577:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80157c:	eb 13                	jmp    801591 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80157e:	84 c0                	test   %al,%al
  801580:	74 0f                	je     801591 <strtol+0x78>
  801582:	bb 0a 00 00 00       	mov    $0xa,%ebx
  801587:	80 3a 30             	cmpb   $0x30,(%edx)
  80158a:	75 05                	jne    801591 <strtol+0x78>
		s++, base = 8;
  80158c:	83 c2 01             	add    $0x1,%edx
  80158f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801598:	0f b6 0a             	movzbl (%edx),%ecx
  80159b:	89 cf                	mov    %ecx,%edi
  80159d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8015a0:	80 fb 09             	cmp    $0x9,%bl
  8015a3:	77 08                	ja     8015ad <strtol+0x94>
			dig = *s - '0';
  8015a5:	0f be c9             	movsbl %cl,%ecx
  8015a8:	83 e9 30             	sub    $0x30,%ecx
  8015ab:	eb 1e                	jmp    8015cb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  8015ad:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8015b0:	80 fb 19             	cmp    $0x19,%bl
  8015b3:	77 08                	ja     8015bd <strtol+0xa4>
			dig = *s - 'a' + 10;
  8015b5:	0f be c9             	movsbl %cl,%ecx
  8015b8:	83 e9 57             	sub    $0x57,%ecx
  8015bb:	eb 0e                	jmp    8015cb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  8015bd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  8015c0:	80 fb 19             	cmp    $0x19,%bl
  8015c3:	77 15                	ja     8015da <strtol+0xc1>
			dig = *s - 'A' + 10;
  8015c5:	0f be c9             	movsbl %cl,%ecx
  8015c8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8015cb:	39 f1                	cmp    %esi,%ecx
  8015cd:	7d 0b                	jge    8015da <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8015cf:	83 c2 01             	add    $0x1,%edx
  8015d2:	0f af c6             	imul   %esi,%eax
  8015d5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  8015d8:	eb be                	jmp    801598 <strtol+0x7f>
  8015da:	89 c1                	mov    %eax,%ecx

	if (endptr)
  8015dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e0:	74 05                	je     8015e7 <strtol+0xce>
		*endptr = (char *) s;
  8015e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015e5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8015e7:	89 ca                	mov    %ecx,%edx
  8015e9:	f7 da                	neg    %edx
  8015eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ef:	0f 45 c2             	cmovne %edx,%eax
}
  8015f2:	83 c4 04             	add    $0x4,%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5f                   	pop    %edi
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    
	...

008015fc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	89 1c 24             	mov    %ebx,(%esp)
  801605:	89 74 24 04          	mov    %esi,0x4(%esp)
  801609:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80160d:	ba 00 00 00 00       	mov    $0x0,%edx
  801612:	b8 01 00 00 00       	mov    $0x1,%eax
  801617:	89 d1                	mov    %edx,%ecx
  801619:	89 d3                	mov    %edx,%ebx
  80161b:	89 d7                	mov    %edx,%edi
  80161d:	89 d6                	mov    %edx,%esi
  80161f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801621:	8b 1c 24             	mov    (%esp),%ebx
  801624:	8b 74 24 04          	mov    0x4(%esp),%esi
  801628:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80162c:	89 ec                	mov    %ebp,%esp
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	89 1c 24             	mov    %ebx,(%esp)
  801639:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
  801646:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801649:	8b 55 08             	mov    0x8(%ebp),%edx
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	89 c7                	mov    %eax,%edi
  801650:	89 c6                	mov    %eax,%esi
  801652:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801654:	8b 1c 24             	mov    (%esp),%ebx
  801657:	8b 74 24 04          	mov    0x4(%esp),%esi
  80165b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80165f:	89 ec                	mov    %ebp,%esp
  801661:	5d                   	pop    %ebp
  801662:	c3                   	ret    

00801663 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 0c             	sub    $0xc,%esp
  801669:	89 1c 24             	mov    %ebx,(%esp)
  80166c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801670:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	b8 10 00 00 00       	mov    $0x10,%eax
  80167e:	89 d1                	mov    %edx,%ecx
  801680:	89 d3                	mov    %edx,%ebx
  801682:	89 d7                	mov    %edx,%edi
  801684:	89 d6                	mov    %edx,%esi
  801686:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801688:	8b 1c 24             	mov    (%esp),%ebx
  80168b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80168f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801693:	89 ec                	mov    %ebp,%esp
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 38             	sub    $0x38,%esp
  80169d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016a0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016a3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ab:	b8 0f 00 00 00       	mov    $0xf,%eax
  8016b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b6:	89 df                	mov    %ebx,%edi
  8016b8:	89 de                	mov    %ebx,%esi
  8016ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	7e 28                	jle    8016e8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016c4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8016cb:	00 
  8016cc:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  8016d3:	00 
  8016d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016db:	00 
  8016dc:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  8016e3:	e8 80 f3 ff ff       	call   800a68 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  8016e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016f1:	89 ec                	mov    %ebp,%esp
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 38             	sub    $0x38,%esp
  8016fb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016fe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801701:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801704:	bb 00 00 00 00       	mov    $0x0,%ebx
  801709:	b8 0e 00 00 00       	mov    $0xe,%eax
  80170e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801711:	8b 55 08             	mov    0x8(%ebp),%edx
  801714:	89 df                	mov    %ebx,%edi
  801716:	89 de                	mov    %ebx,%esi
  801718:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80171a:	85 c0                	test   %eax,%eax
  80171c:	7e 28                	jle    801746 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80171e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801722:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801729:	00 
  80172a:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  801731:	00 
  801732:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801739:	00 
  80173a:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  801741:	e8 22 f3 ff ff       	call   800a68 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801746:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801749:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80174c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80174f:	89 ec                	mov    %ebp,%esp
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 38             	sub    $0x38,%esp
  801759:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80175c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80175f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	b8 0d 00 00 00       	mov    $0xd,%eax
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	89 cb                	mov    %ecx,%ebx
  801771:	89 cf                	mov    %ecx,%edi
  801773:	89 ce                	mov    %ecx,%esi
  801775:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801777:	85 c0                	test   %eax,%eax
  801779:	7e 28                	jle    8017a3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80177b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80177f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801786:	00 
  801787:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  80178e:	00 
  80178f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801796:	00 
  801797:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  80179e:	e8 c5 f2 ff ff       	call   800a68 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8017a3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017a6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017a9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017ac:	89 ec                	mov    %ebp,%esp
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 0c             	sub    $0xc,%esp
  8017b6:	89 1c 24             	mov    %ebx,(%esp)
  8017b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017bd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c1:	be 00 00 00 00       	mov    $0x0,%esi
  8017c6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017cb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8017d9:	8b 1c 24             	mov    (%esp),%ebx
  8017dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8017e0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8017e4:	89 ec                	mov    %ebp,%esp
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 38             	sub    $0x38,%esp
  8017ee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017f1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017f4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  801801:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801804:	8b 55 08             	mov    0x8(%ebp),%edx
  801807:	89 df                	mov    %ebx,%edi
  801809:	89 de                	mov    %ebx,%esi
  80180b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	7e 28                	jle    801839 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801811:	89 44 24 10          	mov    %eax,0x10(%esp)
  801815:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80181c:	00 
  80181d:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  801824:	00 
  801825:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80182c:	00 
  80182d:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  801834:	e8 2f f2 ff ff       	call   800a68 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801839:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80183c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80183f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801842:	89 ec                	mov    %ebp,%esp
  801844:	5d                   	pop    %ebp
  801845:	c3                   	ret    

00801846 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 38             	sub    $0x38,%esp
  80184c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80184f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801852:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801855:	bb 00 00 00 00       	mov    $0x0,%ebx
  80185a:	b8 09 00 00 00       	mov    $0x9,%eax
  80185f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801862:	8b 55 08             	mov    0x8(%ebp),%edx
  801865:	89 df                	mov    %ebx,%edi
  801867:	89 de                	mov    %ebx,%esi
  801869:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80186b:	85 c0                	test   %eax,%eax
  80186d:	7e 28                	jle    801897 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80186f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801873:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80187a:	00 
  80187b:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  801882:	00 
  801883:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80188a:	00 
  80188b:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  801892:	e8 d1 f1 ff ff       	call   800a68 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801897:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80189a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80189d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018a0:	89 ec                	mov    %ebp,%esp
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 38             	sub    $0x38,%esp
  8018aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8018bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c3:	89 df                	mov    %ebx,%edi
  8018c5:	89 de                	mov    %ebx,%esi
  8018c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	7e 28                	jle    8018f5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018d1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8018d8:	00 
  8018d9:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  8018e0:	00 
  8018e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018e8:	00 
  8018e9:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  8018f0:	e8 73 f1 ff ff       	call   800a68 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8018f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018fe:	89 ec                	mov    %ebp,%esp
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 38             	sub    $0x38,%esp
  801908:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80190b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80190e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801911:	bb 00 00 00 00       	mov    $0x0,%ebx
  801916:	b8 06 00 00 00       	mov    $0x6,%eax
  80191b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191e:	8b 55 08             	mov    0x8(%ebp),%edx
  801921:	89 df                	mov    %ebx,%edi
  801923:	89 de                	mov    %ebx,%esi
  801925:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801927:	85 c0                	test   %eax,%eax
  801929:	7e 28                	jle    801953 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80192b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80192f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801936:	00 
  801937:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  80193e:	00 
  80193f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801946:	00 
  801947:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  80194e:	e8 15 f1 ff ff       	call   800a68 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801953:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801956:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801959:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80195c:	89 ec                	mov    %ebp,%esp
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 38             	sub    $0x38,%esp
  801966:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801969:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80196c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80196f:	b8 05 00 00 00       	mov    $0x5,%eax
  801974:	8b 75 18             	mov    0x18(%ebp),%esi
  801977:	8b 7d 14             	mov    0x14(%ebp),%edi
  80197a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80197d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801980:	8b 55 08             	mov    0x8(%ebp),%edx
  801983:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801985:	85 c0                	test   %eax,%eax
  801987:	7e 28                	jle    8019b1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801989:	89 44 24 10          	mov    %eax,0x10(%esp)
  80198d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801994:	00 
  801995:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  80199c:	00 
  80199d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019a4:	00 
  8019a5:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  8019ac:	e8 b7 f0 ff ff       	call   800a68 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8019b1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019b4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019ba:	89 ec                	mov    %ebp,%esp
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 38             	sub    $0x38,%esp
  8019c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019cd:	be 00 00 00 00       	mov    $0x0,%esi
  8019d2:	b8 04 00 00 00       	mov    $0x4,%eax
  8019d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e0:	89 f7                	mov    %esi,%edi
  8019e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	7e 28                	jle    801a10 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019ec:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8019f3:	00 
  8019f4:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  8019fb:	00 
  8019fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a03:	00 
  801a04:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  801a0b:	e8 58 f0 ff ff       	call   800a68 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801a10:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a13:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a16:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a19:	89 ec                	mov    %ebp,%esp
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	89 1c 24             	mov    %ebx,(%esp)
  801a26:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a2a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a33:	b8 0b 00 00 00       	mov    $0xb,%eax
  801a38:	89 d1                	mov    %edx,%ecx
  801a3a:	89 d3                	mov    %edx,%ebx
  801a3c:	89 d7                	mov    %edx,%edi
  801a3e:	89 d6                	mov    %edx,%esi
  801a40:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801a42:	8b 1c 24             	mov    (%esp),%ebx
  801a45:	8b 74 24 04          	mov    0x4(%esp),%esi
  801a49:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801a4d:	89 ec                	mov    %ebp,%esp
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	89 1c 24             	mov    %ebx,(%esp)
  801a5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	b8 02 00 00 00       	mov    $0x2,%eax
  801a6c:	89 d1                	mov    %edx,%ecx
  801a6e:	89 d3                	mov    %edx,%ebx
  801a70:	89 d7                	mov    %edx,%edi
  801a72:	89 d6                	mov    %edx,%esi
  801a74:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801a76:	8b 1c 24             	mov    (%esp),%ebx
  801a79:	8b 74 24 04          	mov    0x4(%esp),%esi
  801a7d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801a81:	89 ec                	mov    %ebp,%esp
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    

00801a85 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 38             	sub    $0x38,%esp
  801a8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a91:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a99:	b8 03 00 00 00       	mov    $0x3,%eax
  801a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa1:	89 cb                	mov    %ecx,%ebx
  801aa3:	89 cf                	mov    %ecx,%edi
  801aa5:	89 ce                	mov    %ecx,%esi
  801aa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	7e 28                	jle    801ad5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801aad:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ab1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801ab8:	00 
  801ab9:	c7 44 24 08 17 44 80 	movl   $0x804417,0x8(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801ac8:	00 
  801ac9:	c7 04 24 34 44 80 00 	movl   $0x804434,(%esp)
  801ad0:	e8 93 ef ff ff       	call   800a68 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801ad5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ad8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801adb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ade:	89 ec                	mov    %ebp,%esp
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    
	...

00801ae4 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801aea:	c7 44 24 08 42 44 80 	movl   $0x804442,0x8(%esp)
  801af1:	00 
  801af2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801af9:	00 
  801afa:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801b01:	e8 62 ef ff ff       	call   800a68 <_panic>

00801b06 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	57                   	push   %edi
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  801b0f:	c7 04 24 74 1d 80 00 	movl   $0x801d74,(%esp)
  801b16:	e8 1d 1f 00 00       	call   803a38 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801b1b:	ba 07 00 00 00       	mov    $0x7,%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	cd 30                	int    $0x30
  801b24:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801b27:	85 c0                	test   %eax,%eax
  801b29:	79 20                	jns    801b4b <fork+0x45>
		panic("sys_exofork: %e", envid);
  801b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2f:	c7 44 24 08 63 44 80 	movl   $0x804463,0x8(%esp)
  801b36:	00 
  801b37:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801b3e:	00 
  801b3f:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801b46:	e8 1d ef ff ff       	call   800a68 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  801b4b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801b52:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801b57:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801b5b:	75 21                	jne    801b7e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  801b5d:	e8 ef fe ff ff       	call   801a51 <sys_getenvid>
  801b62:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b67:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b6a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b6f:	a3 28 64 80 00       	mov    %eax,0x806428
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801b79:	e9 e5 01 00 00       	jmp    801d63 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  801b7e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b81:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801b88:	a8 01                	test   $0x1,%al
  801b8a:	0f 84 4c 01 00 00    	je     801cdc <fork+0x1d6>
  801b90:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801b96:	0f 84 cf 01 00 00    	je     801d6b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  801b9c:	c1 e2 16             	shl    $0x16,%edx
  801b9f:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801ba2:	89 d3                	mov    %edx,%ebx
  801ba4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bab:	00 
  801bac:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	e8 03 fe ff ff       	call   8019be <sys_page_alloc>
			if(ret < 0) return ret;
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	0f 88 a0 01 00 00    	js     801d63 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801bc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bca:	89 14 24             	mov    %edx,(%esp)
  801bcd:	e8 30 fd ff ff       	call   801902 <sys_page_unmap>
			if(ret < 0) return ret;
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	0f 88 89 01 00 00    	js     801d63 <fork+0x25d>
  801bda:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  801bdf:	89 de                	mov    %ebx,%esi
  801be1:	c1 e6 0c             	shl    $0xc,%esi
  801be4:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801be7:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  801bed:	0f 84 da 00 00 00    	je     801ccd <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801bf3:	c1 ee 0c             	shr    $0xc,%esi
  801bf6:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801bf9:	a8 01                	test   $0x1,%al
  801bfb:	0f 84 cc 00 00 00    	je     801ccd <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801c01:	89 f0                	mov    %esi,%eax
  801c03:	c1 e0 0c             	shl    $0xc,%eax
  801c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801c09:	e8 43 fe ff ff       	call   801a51 <sys_getenvid>
  801c0e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801c11:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801c14:	89 c6                	mov    %eax,%esi
  801c16:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  801c1c:	25 01 04 00 00       	and    $0x401,%eax
  801c21:	3d 01 04 00 00       	cmp    $0x401,%eax
  801c26:	75 3a                	jne    801c62 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801c28:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  801c2f:	00 
  801c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c33:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c45:	89 14 24             	mov    %edx,(%esp)
  801c48:	e8 13 fd ff ff       	call   801960 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  801c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c54:	c7 04 24 73 44 80 00 	movl   $0x804473,(%esp)
  801c5b:	e8 c1 ee ff ff       	call   800b21 <cprintf>
  801c60:	eb 6b                	jmp    801ccd <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801c62:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801c68:	74 14                	je     801c7e <fork+0x178>
  801c6a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801c70:	74 0c                	je     801c7e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801c72:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801c78:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  801c7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c81:	89 74 24 10          	mov    %esi,0x10(%esp)
  801c85:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c90:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c97:	89 14 24             	mov    %edx,(%esp)
  801c9a:	e8 c1 fc ff ff       	call   801960 <sys_page_map>
	if(ret<0) return ret;
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	0f 88 bc 00 00 00    	js     801d63 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801ca7:	89 74 24 10          	mov    %esi,0x10(%esp)
  801cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801cb5:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbd:	89 14 24             	mov    %edx,(%esp)
  801cc0:	e8 9b fc ff ff       	call   801960 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	0f 88 96 00 00 00    	js     801d63 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  801ccd:	83 c3 01             	add    $0x1,%ebx
  801cd0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801cd6:	0f 85 03 ff ff ff    	jne    801bdf <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  801cdc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801ce0:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801ce7:	0f 85 91 fe ff ff    	jne    801b7e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  801ced:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801cf4:	00 
  801cf5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801cfc:	ee 
  801cfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d00:	89 04 24             	mov    %eax,(%esp)
  801d03:	e8 b6 fc ff ff       	call   8019be <sys_page_alloc>
	if(ret < 0) return ret;
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 57                	js     801d63 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  801d0c:	a1 28 64 80 00       	mov    0x806428,%eax
  801d11:	8b 40 64             	mov    0x64(%eax),%eax
  801d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d1b:	89 14 24             	mov    %edx,(%esp)
  801d1e:	e8 c5 fa ff ff       	call   8017e8 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801d23:	85 c0                	test   %eax,%eax
  801d25:	78 3c                	js     801d63 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801d27:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d2e:	00 
  801d2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d32:	89 04 24             	mov    %eax,(%esp)
  801d35:	e8 6a fb ff ff       	call   8018a4 <sys_env_set_status>
  801d3a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  801d3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801d3f:	85 d2                	test   %edx,%edx
  801d41:	79 20                	jns    801d63 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801d43:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d47:	c7 44 24 08 8a 44 80 	movl   $0x80448a,0x8(%esp)
  801d4e:	00 
  801d4f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801d56:	00 
  801d57:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801d5e:	e8 05 ed ff ff       	call   800a68 <_panic>

	return envid;
}
  801d63:	83 c4 4c             	add    $0x4c,%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  801d6b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801d6f:	e9 0a fe ff ff       	jmp    801b7e <fork+0x78>

00801d74 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	56                   	push   %esi
  801d78:	53                   	push   %ebx
  801d79:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  801d7c:	e8 d0 fc ff ff       	call   801a51 <sys_getenvid>
  801d81:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	8b 00                	mov    (%eax),%eax
  801d88:	89 c6                	mov    %eax,%esi
  801d8a:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  801d8d:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801d94:	f6 c2 02             	test   $0x2,%dl
  801d97:	75 2c                	jne    801dc5 <pgfault+0x51>
  801d99:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801da0:	f6 c6 08             	test   $0x8,%dh
  801da3:	75 20                	jne    801dc5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801da5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801da9:	c7 44 24 08 d8 44 80 	movl   $0x8044d8,0x8(%esp)
  801db0:	00 
  801db1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801db8:	00 
  801db9:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801dc0:	e8 a3 ec ff ff       	call   800a68 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801dc5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801dcc:	00 
  801dcd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801dd4:	00 
  801dd5:	89 1c 24             	mov    %ebx,(%esp)
  801dd8:	e8 e1 fb ff ff       	call   8019be <sys_page_alloc>
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	79 20                	jns    801e01 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801de1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801de5:	c7 44 24 08 a1 44 80 	movl   $0x8044a1,0x8(%esp)
  801dec:	00 
  801ded:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801df4:	00 
  801df5:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801dfc:	e8 67 ec ff ff       	call   800a68 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801e01:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801e04:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e0b:	00 
  801e0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e10:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801e17:	e8 03 f6 ff ff       	call   80141f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801e1c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e23:	00 
  801e24:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e2c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e33:	00 
  801e34:	89 1c 24             	mov    %ebx,(%esp)
  801e37:	e8 24 fb ff ff       	call   801960 <sys_page_map>
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	79 20                	jns    801e60 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801e40:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e44:	c7 44 24 08 b3 44 80 	movl   $0x8044b3,0x8(%esp)
  801e4b:	00 
  801e4c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801e53:	00 
  801e54:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801e5b:	e8 08 ec ff ff       	call   800a68 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801e60:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e67:	00 
  801e68:	89 1c 24             	mov    %ebx,(%esp)
  801e6b:	e8 92 fa ff ff       	call   801902 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801e70:	85 c0                	test   %eax,%eax
  801e72:	74 20                	je     801e94 <pgfault+0x120>
  801e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e78:	c7 44 24 08 c3 44 80 	movl   $0x8044c3,0x8(%esp)
  801e7f:	00 
  801e80:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801e87:	00 
  801e88:	c7 04 24 58 44 80 00 	movl   $0x804458,(%esp)
  801e8f:	e8 d4 eb ff ff       	call   800a68 <_panic>

}
  801e94:	83 c4 20             	add    $0x20,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    
	...

00801e9c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea5:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801ea8:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801eaa:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801ead:	83 3a 01             	cmpl   $0x1,(%edx)
  801eb0:	7e 09                	jle    801ebb <argstart+0x1f>
  801eb2:	ba 53 3f 80 00       	mov    $0x803f53,%edx
  801eb7:	85 c9                	test   %ecx,%ecx
  801eb9:	75 05                	jne    801ec0 <argstart+0x24>
  801ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec0:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801ec3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    

00801ecc <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	53                   	push   %ebx
  801ed0:	83 ec 14             	sub    $0x14,%esp
  801ed3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801ed6:	8b 53 08             	mov    0x8(%ebx),%edx
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	85 d2                	test   %edx,%edx
  801ee0:	74 5a                	je     801f3c <argnextvalue+0x70>
		return 0;
	if (*args->curarg) {
  801ee2:	80 3a 00             	cmpb   $0x0,(%edx)
  801ee5:	74 0c                	je     801ef3 <argnextvalue+0x27>
		args->argvalue = args->curarg;
  801ee7:	89 53 0c             	mov    %edx,0xc(%ebx)
		args->curarg = "";
  801eea:	c7 43 08 53 3f 80 00 	movl   $0x803f53,0x8(%ebx)
  801ef1:	eb 46                	jmp    801f39 <argnextvalue+0x6d>
	} else if (*args->argc > 1) {
  801ef3:	8b 03                	mov    (%ebx),%eax
  801ef5:	83 38 01             	cmpl   $0x1,(%eax)
  801ef8:	7e 31                	jle    801f2b <argnextvalue+0x5f>
		args->argvalue = args->argv[1];
  801efa:	8b 43 04             	mov    0x4(%ebx),%eax
  801efd:	8b 50 04             	mov    0x4(%eax),%edx
  801f00:	89 53 0c             	mov    %edx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801f03:	8b 13                	mov    (%ebx),%edx
  801f05:	8b 12                	mov    (%edx),%edx
  801f07:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801f0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f12:	8d 50 08             	lea    0x8(%eax),%edx
  801f15:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f19:	83 c0 04             	add    $0x4,%eax
  801f1c:	89 04 24             	mov    %eax,(%esp)
  801f1f:	e8 fb f4 ff ff       	call   80141f <memmove>
		(*args->argc)--;
  801f24:	8b 03                	mov    (%ebx),%eax
  801f26:	83 28 01             	subl   $0x1,(%eax)
  801f29:	eb 0e                	jmp    801f39 <argnextvalue+0x6d>
	} else {
		args->argvalue = 0;
  801f2b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801f32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801f39:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801f3c:	83 c4 14             	add    $0x14,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 18             	sub    $0x18,%esp
  801f48:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801f4b:	8b 42 0c             	mov    0xc(%edx),%eax
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	75 08                	jne    801f5a <argvalue+0x18>
  801f52:	89 14 24             	mov    %edx,(%esp)
  801f55:	e8 72 ff ff ff       	call   801ecc <argnextvalue>
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <argnext>:
	args->argvalue = 0;
}

int
argnext(struct Argstate *args)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 14             	sub    $0x14,%esp
  801f63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801f66:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801f6d:	8b 53 08             	mov    0x8(%ebx),%edx
  801f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f75:	85 d2                	test   %edx,%edx
  801f77:	74 73                	je     801fec <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801f79:	80 3a 00             	cmpb   $0x0,(%edx)
  801f7c:	75 54                	jne    801fd2 <argnext+0x76>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801f7e:	8b 03                	mov    (%ebx),%eax
  801f80:	83 38 01             	cmpl   $0x1,(%eax)
  801f83:	74 5b                	je     801fe0 <argnext+0x84>
		    || args->argv[1][0] != '-'
  801f85:	8b 43 04             	mov    0x4(%ebx),%eax
  801f88:	8b 40 04             	mov    0x4(%eax),%eax
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801f8b:	80 38 2d             	cmpb   $0x2d,(%eax)
  801f8e:	75 50                	jne    801fe0 <argnext+0x84>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
  801f90:	83 c0 01             	add    $0x1,%eax
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801f93:	80 38 00             	cmpb   $0x0,(%eax)
  801f96:	74 48                	je     801fe0 <argnext+0x84>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801f98:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801f9b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f9e:	8b 13                	mov    (%ebx),%edx
  801fa0:	8b 12                	mov    (%edx),%edx
  801fa2:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801fa9:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fad:	8d 50 08             	lea    0x8(%eax),%edx
  801fb0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fb4:	83 c0 04             	add    $0x4,%eax
  801fb7:	89 04 24             	mov    %eax,(%esp)
  801fba:	e8 60 f4 ff ff       	call   80141f <memmove>
		(*args->argc)--;
  801fbf:	8b 03                	mov    (%ebx),%eax
  801fc1:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801fc4:	8b 43 08             	mov    0x8(%ebx),%eax
  801fc7:	80 38 2d             	cmpb   $0x2d,(%eax)
  801fca:	75 06                	jne    801fd2 <argnext+0x76>
  801fcc:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801fd0:	74 0e                	je     801fe0 <argnext+0x84>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801fd2:	8b 53 08             	mov    0x8(%ebx),%edx
  801fd5:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801fd8:	83 c2 01             	add    $0x1,%edx
  801fdb:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801fde:	eb 0c                	jmp    801fec <argnext+0x90>

    endofargs:
	args->curarg = 0;
  801fe0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return -1;
}
  801fec:	83 c4 14             	add    $0x14,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    
	...

00801ff4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	05 00 00 00 30       	add    $0x30000000,%eax
  801fff:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  802002:	5d                   	pop    %ebp
  802003:	c3                   	ret    

00802004 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	89 04 24             	mov    %eax,(%esp)
  802010:	e8 df ff ff ff       	call   801ff4 <fd2num>
  802015:	05 20 00 0d 00       	add    $0xd0020,%eax
  80201a:	c1 e0 0c             	shl    $0xc,%eax
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	57                   	push   %edi
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	8b 7d 08             	mov    0x8(%ebp),%edi
  802028:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80202d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  802032:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802037:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802039:	89 c2                	mov    %eax,%edx
  80203b:	c1 ea 16             	shr    $0x16,%edx
  80203e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  802041:	f6 c2 01             	test   $0x1,%dl
  802044:	74 0d                	je     802053 <fd_alloc+0x34>
  802046:	89 c2                	mov    %eax,%edx
  802048:	c1 ea 0c             	shr    $0xc,%edx
  80204b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  80204e:	f6 c2 01             	test   $0x1,%dl
  802051:	75 09                	jne    80205c <fd_alloc+0x3d>
			*fd_store = fd;
  802053:	89 37                	mov    %esi,(%edi)
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80205a:	eb 17                	jmp    802073 <fd_alloc+0x54>
  80205c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802061:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802066:	75 cf                	jne    802037 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802068:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  80206e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	83 f8 1f             	cmp    $0x1f,%eax
  802081:	77 36                	ja     8020b9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802083:	05 00 00 0d 00       	add    $0xd0000,%eax
  802088:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80208b:	89 c2                	mov    %eax,%edx
  80208d:	c1 ea 16             	shr    $0x16,%edx
  802090:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802097:	f6 c2 01             	test   $0x1,%dl
  80209a:	74 1d                	je     8020b9 <fd_lookup+0x41>
  80209c:	89 c2                	mov    %eax,%edx
  80209e:	c1 ea 0c             	shr    $0xc,%edx
  8020a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8020a8:	f6 c2 01             	test   $0x1,%dl
  8020ab:	74 0c                	je     8020b9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8020ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b0:	89 02                	mov    %eax,(%edx)
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8020b7:	eb 05                	jmp    8020be <fd_lookup+0x46>
  8020b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    

008020c0 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8020c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	89 04 24             	mov    %eax,(%esp)
  8020d3:	e8 a0 ff ff ff       	call   802078 <fd_lookup>
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 0e                	js     8020ea <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e2:	89 50 04             	mov    %edx,0x4(%eax)
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	56                   	push   %esi
  8020f0:	53                   	push   %ebx
  8020f1:	83 ec 10             	sub    $0x10,%esp
  8020f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8020fa:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8020ff:	be 78 45 80 00       	mov    $0x804578,%esi
  802104:	eb 10                	jmp    802116 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  802106:	39 08                	cmp    %ecx,(%eax)
  802108:	75 09                	jne    802113 <dev_lookup+0x27>
			*dev = devtab[i];
  80210a:	89 03                	mov    %eax,(%ebx)
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  802111:	eb 31                	jmp    802144 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802113:	83 c2 01             	add    $0x1,%edx
  802116:	8b 04 96             	mov    (%esi,%edx,4),%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	75 e9                	jne    802106 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80211d:	a1 28 64 80 00       	mov    0x806428,%eax
  802122:	8b 40 48             	mov    0x48(%eax),%eax
  802125:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802129:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212d:	c7 04 24 fc 44 80 00 	movl   $0x8044fc,(%esp)
  802134:	e8 e8 e9 ff ff       	call   800b21 <cprintf>
	*dev = 0;
  802139:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80213f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5d                   	pop    %ebp
  80214a:	c3                   	ret    

0080214b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	53                   	push   %ebx
  80214f:	83 ec 24             	sub    $0x24,%esp
  802152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802155:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	89 04 24             	mov    %eax,(%esp)
  802162:	e8 11 ff ff ff       	call   802078 <fd_lookup>
  802167:	85 c0                	test   %eax,%eax
  802169:	78 53                	js     8021be <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80216b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80216e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802175:	8b 00                	mov    (%eax),%eax
  802177:	89 04 24             	mov    %eax,(%esp)
  80217a:	e8 6d ff ff ff       	call   8020ec <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80217f:	85 c0                	test   %eax,%eax
  802181:	78 3b                	js     8021be <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802183:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80218f:	74 2d                	je     8021be <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802191:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802194:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80219b:	00 00 00 
	stat->st_isdir = 0;
  80219e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021a5:	00 00 00 
	stat->st_dev = dev;
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8021b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b8:	89 14 24             	mov    %edx,(%esp)
  8021bb:	ff 50 14             	call   *0x14(%eax)
}
  8021be:	83 c4 24             	add    $0x24,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    

008021c4 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 24             	sub    $0x24,%esp
  8021cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d5:	89 1c 24             	mov    %ebx,(%esp)
  8021d8:	e8 9b fe ff ff       	call   802078 <fd_lookup>
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 5f                	js     802240 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	89 04 24             	mov    %eax,(%esp)
  8021f0:	e8 f7 fe ff ff       	call   8020ec <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	78 47                	js     802240 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021fc:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802200:	75 23                	jne    802225 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802202:	a1 28 64 80 00       	mov    0x806428,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802207:	8b 40 48             	mov    0x48(%eax),%eax
  80220a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80220e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802212:	c7 04 24 1c 45 80 00 	movl   $0x80451c,(%esp)
  802219:	e8 03 e9 ff ff       	call   800b21 <cprintf>
  80221e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802223:	eb 1b                	jmp    802240 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 48 18             	mov    0x18(%eax),%ecx
  80222b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802230:	85 c9                	test   %ecx,%ecx
  802232:	74 0c                	je     802240 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223b:	89 14 24             	mov    %edx,(%esp)
  80223e:	ff d1                	call   *%ecx
}
  802240:	83 c4 24             	add    $0x24,%esp
  802243:	5b                   	pop    %ebx
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    

00802246 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	53                   	push   %ebx
  80224a:	83 ec 24             	sub    $0x24,%esp
  80224d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802250:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	89 1c 24             	mov    %ebx,(%esp)
  80225a:	e8 19 fe ff ff       	call   802078 <fd_lookup>
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 66                	js     8022c9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802266:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	89 04 24             	mov    %eax,(%esp)
  802272:	e8 75 fe ff ff       	call   8020ec <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802277:	85 c0                	test   %eax,%eax
  802279:	78 4e                	js     8022c9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80227b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802282:	75 23                	jne    8022a7 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802284:	a1 28 64 80 00       	mov    0x806428,%eax
  802289:	8b 40 48             	mov    0x48(%eax),%eax
  80228c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802290:	89 44 24 04          	mov    %eax,0x4(%esp)
  802294:	c7 04 24 3d 45 80 00 	movl   $0x80453d,(%esp)
  80229b:	e8 81 e8 ff ff       	call   800b21 <cprintf>
  8022a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8022a5:	eb 22                	jmp    8022c9 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 48 0c             	mov    0xc(%eax),%ecx
  8022ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022b2:	85 c9                	test   %ecx,%ecx
  8022b4:	74 13                	je     8022c9 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8022b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c4:	89 14 24             	mov    %edx,(%esp)
  8022c7:	ff d1                	call   *%ecx
}
  8022c9:	83 c4 24             	add    $0x24,%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5d                   	pop    %ebp
  8022ce:	c3                   	ret    

008022cf <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	53                   	push   %ebx
  8022d3:	83 ec 24             	sub    $0x24,%esp
  8022d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e0:	89 1c 24             	mov    %ebx,(%esp)
  8022e3:	e8 90 fd ff ff       	call   802078 <fd_lookup>
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	78 6b                	js     802357 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	89 04 24             	mov    %eax,(%esp)
  8022fb:	e8 ec fd ff ff       	call   8020ec <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802300:	85 c0                	test   %eax,%eax
  802302:	78 53                	js     802357 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802304:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802307:	8b 42 08             	mov    0x8(%edx),%eax
  80230a:	83 e0 03             	and    $0x3,%eax
  80230d:	83 f8 01             	cmp    $0x1,%eax
  802310:	75 23                	jne    802335 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802312:	a1 28 64 80 00       	mov    0x806428,%eax
  802317:	8b 40 48             	mov    0x48(%eax),%eax
  80231a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80231e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802322:	c7 04 24 5a 45 80 00 	movl   $0x80455a,(%esp)
  802329:	e8 f3 e7 ff ff       	call   800b21 <cprintf>
  80232e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  802333:	eb 22                	jmp    802357 <read+0x88>
	}
	if (!dev->dev_read)
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 48 08             	mov    0x8(%eax),%ecx
  80233b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802340:	85 c9                	test   %ecx,%ecx
  802342:	74 13                	je     802357 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	89 44 24 08          	mov    %eax,0x8(%esp)
  80234b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802352:	89 14 24             	mov    %edx,(%esp)
  802355:	ff d1                	call   *%ecx
}
  802357:	83 c4 24             	add    $0x24,%esp
  80235a:	5b                   	pop    %ebx
  80235b:	5d                   	pop    %ebp
  80235c:	c3                   	ret    

0080235d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	57                   	push   %edi
  802361:	56                   	push   %esi
  802362:	53                   	push   %ebx
  802363:	83 ec 1c             	sub    $0x1c,%esp
  802366:	8b 7d 08             	mov    0x8(%ebp),%edi
  802369:	8b 75 10             	mov    0x10(%ebp),%esi
  80236c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802371:	eb 21                	jmp    802394 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802373:	89 f2                	mov    %esi,%edx
  802375:	29 c2                	sub    %eax,%edx
  802377:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237b:	03 45 0c             	add    0xc(%ebp),%eax
  80237e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802382:	89 3c 24             	mov    %edi,(%esp)
  802385:	e8 45 ff ff ff       	call   8022cf <read>
		if (m < 0)
  80238a:	85 c0                	test   %eax,%eax
  80238c:	78 0e                	js     80239c <readn+0x3f>
			return m;
		if (m == 0)
  80238e:	85 c0                	test   %eax,%eax
  802390:	74 08                	je     80239a <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802392:	01 c3                	add    %eax,%ebx
  802394:	89 d8                	mov    %ebx,%eax
  802396:	39 f3                	cmp    %esi,%ebx
  802398:	72 d9                	jb     802373 <readn+0x16>
  80239a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80239c:	83 c4 1c             	add    $0x1c,%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5f                   	pop    %edi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	83 ec 38             	sub    $0x38,%esp
  8023aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023b6:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023ba:	89 3c 24             	mov    %edi,(%esp)
  8023bd:	e8 32 fc ff ff       	call   801ff4 <fd2num>
  8023c2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8023c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023c9:	89 04 24             	mov    %eax,(%esp)
  8023cc:	e8 a7 fc ff ff       	call   802078 <fd_lookup>
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	78 05                	js     8023dc <fd_close+0x38>
  8023d7:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8023da:	74 0e                	je     8023ea <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8023dc:	89 f0                	mov    %esi,%eax
  8023de:	84 c0                	test   %al,%al
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e5:	0f 44 d8             	cmove  %eax,%ebx
  8023e8:	eb 3d                	jmp    802427 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8023ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f1:	8b 07                	mov    (%edi),%eax
  8023f3:	89 04 24             	mov    %eax,(%esp)
  8023f6:	e8 f1 fc ff ff       	call   8020ec <dev_lookup>
  8023fb:	89 c3                	mov    %eax,%ebx
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	78 16                	js     802417 <fd_close+0x73>
		if (dev->dev_close)
  802401:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802404:	8b 40 10             	mov    0x10(%eax),%eax
  802407:	bb 00 00 00 00       	mov    $0x0,%ebx
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 07                	je     802417 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  802410:	89 3c 24             	mov    %edi,(%esp)
  802413:	ff d0                	call   *%eax
  802415:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80241b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802422:	e8 db f4 ff ff       	call   801902 <sys_page_unmap>
	return r;
}
  802427:	89 d8                	mov    %ebx,%eax
  802429:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80242c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80242f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802432:	89 ec                	mov    %ebp,%esp
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    

00802436 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 2a fc ff ff       	call   802078 <fd_lookup>
  80244e:	85 c0                	test   %eax,%eax
  802450:	78 13                	js     802465 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  802452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802459:	00 
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	89 04 24             	mov    %eax,(%esp)
  802460:	e8 3f ff ff ff       	call   8023a4 <fd_close>
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 18             	sub    $0x18,%esp
  80246d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802470:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802473:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80247a:	00 
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	89 04 24             	mov    %eax,(%esp)
  802481:	e8 25 04 00 00       	call   8028ab <open>
  802486:	89 c3                	mov    %eax,%ebx
  802488:	85 c0                	test   %eax,%eax
  80248a:	78 1b                	js     8024a7 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80248c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802493:	89 1c 24             	mov    %ebx,(%esp)
  802496:	e8 b0 fc ff ff       	call   80214b <fstat>
  80249b:	89 c6                	mov    %eax,%esi
	close(fd);
  80249d:	89 1c 24             	mov    %ebx,(%esp)
  8024a0:	e8 91 ff ff ff       	call   802436 <close>
  8024a5:	89 f3                	mov    %esi,%ebx
	return r;
}
  8024a7:	89 d8                	mov    %ebx,%eax
  8024a9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8024ac:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8024af:	89 ec                	mov    %ebp,%esp
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    

008024b3 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	53                   	push   %ebx
  8024b7:	83 ec 14             	sub    $0x14,%esp
  8024ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8024bf:	89 1c 24             	mov    %ebx,(%esp)
  8024c2:	e8 6f ff ff ff       	call   802436 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024c7:	83 c3 01             	add    $0x1,%ebx
  8024ca:	83 fb 20             	cmp    $0x20,%ebx
  8024cd:	75 f0                	jne    8024bf <close_all+0xc>
		close(i);
}
  8024cf:	83 c4 14             	add    $0x14,%esp
  8024d2:	5b                   	pop    %ebx
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 58             	sub    $0x58,%esp
  8024db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8024de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8024ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	89 04 24             	mov    %eax,(%esp)
  8024f4:	e8 7f fb ff ff       	call   802078 <fd_lookup>
  8024f9:	89 c3                	mov    %eax,%ebx
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	0f 88 e0 00 00 00    	js     8025e3 <dup+0x10e>
		return r;
	close(newfdnum);
  802503:	89 3c 24             	mov    %edi,(%esp)
  802506:	e8 2b ff ff ff       	call   802436 <close>

	newfd = INDEX2FD(newfdnum);
  80250b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  802511:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  802514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802517:	89 04 24             	mov    %eax,(%esp)
  80251a:	e8 e5 fa ff ff       	call   802004 <fd2data>
  80251f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802521:	89 34 24             	mov    %esi,(%esp)
  802524:	e8 db fa ff ff       	call   802004 <fd2data>
  802529:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80252c:	89 da                	mov    %ebx,%edx
  80252e:	89 d8                	mov    %ebx,%eax
  802530:	c1 e8 16             	shr    $0x16,%eax
  802533:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80253a:	a8 01                	test   $0x1,%al
  80253c:	74 43                	je     802581 <dup+0xac>
  80253e:	c1 ea 0c             	shr    $0xc,%edx
  802541:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802548:	a8 01                	test   $0x1,%al
  80254a:	74 35                	je     802581 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80254c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802553:	25 07 0e 00 00       	and    $0xe07,%eax
  802558:	89 44 24 10          	mov    %eax,0x10(%esp)
  80255c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80255f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802563:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80256a:	00 
  80256b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80256f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802576:	e8 e5 f3 ff ff       	call   801960 <sys_page_map>
  80257b:	89 c3                	mov    %eax,%ebx
  80257d:	85 c0                	test   %eax,%eax
  80257f:	78 3f                	js     8025c0 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802584:	89 c2                	mov    %eax,%edx
  802586:	c1 ea 0c             	shr    $0xc,%edx
  802589:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802590:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802596:	89 54 24 10          	mov    %edx,0x10(%esp)
  80259a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80259e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025a5:	00 
  8025a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b1:	e8 aa f3 ff ff       	call   801960 <sys_page_map>
  8025b6:	89 c3                	mov    %eax,%ebx
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	78 04                	js     8025c0 <dup+0xeb>
  8025bc:	89 fb                	mov    %edi,%ebx
  8025be:	eb 23                	jmp    8025e3 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8025c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025cb:	e8 32 f3 ff ff       	call   801902 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8025d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025de:	e8 1f f3 ff ff       	call   801902 <sys_page_unmap>
	return r;
}
  8025e3:	89 d8                	mov    %ebx,%eax
  8025e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025e8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025ee:	89 ec                	mov    %ebp,%esp
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    
	...

008025f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	56                   	push   %esi
  8025f8:	53                   	push   %ebx
  8025f9:	83 ec 10             	sub    $0x10,%esp
  8025fc:	89 c3                	mov    %eax,%ebx
  8025fe:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  802600:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802607:	75 11                	jne    80261a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802609:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802610:	e8 c7 14 00 00       	call   803adc <ipc_find_env>
  802615:	a3 20 64 80 00       	mov    %eax,0x806420

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  80261a:	a1 28 64 80 00       	mov    0x806428,%eax
  80261f:	8b 40 48             	mov    0x48(%eax),%eax
  802622:	8b 15 00 70 80 00    	mov    0x807000,%edx
  802628:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80262c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802630:	89 44 24 04          	mov    %eax,0x4(%esp)
  802634:	c7 04 24 8c 45 80 00 	movl   $0x80458c,(%esp)
  80263b:	e8 e1 e4 ff ff       	call   800b21 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802640:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802647:	00 
  802648:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  80264f:	00 
  802650:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802654:	a1 20 64 80 00       	mov    0x806420,%eax
  802659:	89 04 24             	mov    %eax,(%esp)
  80265c:	e8 b1 14 00 00       	call   803b12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802661:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802668:	00 
  802669:	89 74 24 04          	mov    %esi,0x4(%esp)
  80266d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802674:	e8 05 15 00 00       	call   803b7e <ipc_recv>
}
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	5b                   	pop    %ebx
  80267d:	5e                   	pop    %esi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    

00802680 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	8b 40 0c             	mov    0xc(%eax),%eax
  80268c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  802691:	8b 45 0c             	mov    0xc(%ebp),%eax
  802694:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802699:	ba 00 00 00 00       	mov    $0x0,%edx
  80269e:	b8 02 00 00 00       	mov    $0x2,%eax
  8026a3:	e8 4c ff ff ff       	call   8025f4 <fsipc>
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b6:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8026bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c0:	b8 06 00 00 00       	mov    $0x6,%eax
  8026c5:	e8 2a ff ff ff       	call   8025f4 <fsipc>
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8026d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8026dc:	e8 13 ff ff ff       	call   8025f4 <fsipc>
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	53                   	push   %ebx
  8026e7:	83 ec 14             	sub    $0x14,%esp
  8026ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8026f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fd:	b8 05 00 00 00       	mov    $0x5,%eax
  802702:	e8 ed fe ff ff       	call   8025f4 <fsipc>
  802707:	85 c0                	test   %eax,%eax
  802709:	78 2b                	js     802736 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80270b:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802712:	00 
  802713:	89 1c 24             	mov    %ebx,(%esp)
  802716:	e8 5e eb ff ff       	call   801279 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80271b:	a1 80 70 80 00       	mov    0x807080,%eax
  802720:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802726:	a1 84 70 80 00       	mov    0x807084,%eax
  80272b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  802736:	83 c4 14             	add    $0x14,%esp
  802739:	5b                   	pop    %ebx
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    

0080273c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	53                   	push   %ebx
  802740:	83 ec 14             	sub    $0x14,%esp
  802743:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	8b 40 0c             	mov    0xc(%eax),%eax
  80274c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  802751:	89 1d 04 70 80 00    	mov    %ebx,0x807004

	assert(n<=PGSIZE);
  802757:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80275d:	76 24                	jbe    802783 <devfile_write+0x47>
  80275f:	c7 44 24 0c a2 45 80 	movl   $0x8045a2,0xc(%esp)
  802766:	00 
  802767:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  80276e:	00 
  80276f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  802776:	00 
  802777:	c7 04 24 ac 45 80 00 	movl   $0x8045ac,(%esp)
  80277e:	e8 e5 e2 ff ff       	call   800a68 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  802783:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278e:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  802795:	e8 85 ec ff ff       	call   80141f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  80279a:	ba 00 00 00 00       	mov    $0x0,%edx
  80279f:	b8 04 00 00 00       	mov    $0x4,%eax
  8027a4:	e8 4b fe ff ff       	call   8025f4 <fsipc>
	if(ret<0) return ret;
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	78 53                	js     802800 <devfile_write+0xc4>
	
	assert(ret <= n);
  8027ad:	39 c3                	cmp    %eax,%ebx
  8027af:	73 24                	jae    8027d5 <devfile_write+0x99>
  8027b1:	c7 44 24 0c b7 45 80 	movl   $0x8045b7,0xc(%esp)
  8027b8:	00 
  8027b9:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  8027c0:	00 
  8027c1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8027c8:	00 
  8027c9:	c7 04 24 ac 45 80 00 	movl   $0x8045ac,(%esp)
  8027d0:	e8 93 e2 ff ff       	call   800a68 <_panic>
	assert(ret <= PGSIZE);
  8027d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8027da:	7e 24                	jle    802800 <devfile_write+0xc4>
  8027dc:	c7 44 24 0c c0 45 80 	movl   $0x8045c0,0xc(%esp)
  8027e3:	00 
  8027e4:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  8027eb:	00 
  8027ec:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8027f3:	00 
  8027f4:	c7 04 24 ac 45 80 00 	movl   $0x8045ac,(%esp)
  8027fb:	e8 68 e2 ff ff       	call   800a68 <_panic>
	return ret;
}
  802800:	83 c4 14             	add    $0x14,%esp
  802803:	5b                   	pop    %ebx
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    

00802806 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	56                   	push   %esi
  80280a:	53                   	push   %ebx
  80280b:	83 ec 10             	sub    $0x10,%esp
  80280e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	8b 40 0c             	mov    0xc(%eax),%eax
  802817:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80281c:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802822:	ba 00 00 00 00       	mov    $0x0,%edx
  802827:	b8 03 00 00 00       	mov    $0x3,%eax
  80282c:	e8 c3 fd ff ff       	call   8025f4 <fsipc>
  802831:	89 c3                	mov    %eax,%ebx
  802833:	85 c0                	test   %eax,%eax
  802835:	78 6b                	js     8028a2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  802837:	39 de                	cmp    %ebx,%esi
  802839:	73 24                	jae    80285f <devfile_read+0x59>
  80283b:	c7 44 24 0c ce 45 80 	movl   $0x8045ce,0xc(%esp)
  802842:	00 
  802843:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  80284a:	00 
  80284b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  802852:	00 
  802853:	c7 04 24 ac 45 80 00 	movl   $0x8045ac,(%esp)
  80285a:	e8 09 e2 ff ff       	call   800a68 <_panic>
	assert(r <= PGSIZE);
  80285f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802865:	7e 24                	jle    80288b <devfile_read+0x85>
  802867:	c7 44 24 0c d5 45 80 	movl   $0x8045d5,0xc(%esp)
  80286e:	00 
  80286f:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  802876:	00 
  802877:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  80287e:	00 
  80287f:	c7 04 24 ac 45 80 00 	movl   $0x8045ac,(%esp)
  802886:	e8 dd e1 ff ff       	call   800a68 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80288b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80288f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802896:	00 
  802897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289a:	89 04 24             	mov    %eax,(%esp)
  80289d:	e8 7d eb ff ff       	call   80141f <memmove>
	return r;
}
  8028a2:	89 d8                	mov    %ebx,%eax
  8028a4:	83 c4 10             	add    $0x10,%esp
  8028a7:	5b                   	pop    %ebx
  8028a8:	5e                   	pop    %esi
  8028a9:	5d                   	pop    %ebp
  8028aa:	c3                   	ret    

008028ab <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 28             	sub    $0x28,%esp
  8028b1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8028b4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8028b7:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8028ba:	89 34 24             	mov    %esi,(%esp)
  8028bd:	e8 7e e9 ff ff       	call   801240 <strlen>
  8028c2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8028c7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028cc:	7f 5e                	jg     80292c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8028ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028d1:	89 04 24             	mov    %eax,(%esp)
  8028d4:	e8 46 f7 ff ff       	call   80201f <fd_alloc>
  8028d9:	89 c3                	mov    %eax,%ebx
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	78 4d                	js     80292c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8028df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028e3:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8028ea:	e8 8a e9 ff ff       	call   801279 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8028ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f2:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ff:	e8 f0 fc ff ff       	call   8025f4 <fsipc>
  802904:	89 c3                	mov    %eax,%ebx
  802906:	85 c0                	test   %eax,%eax
  802908:	79 15                	jns    80291f <open+0x74>
		fd_close(fd, 0);
  80290a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802911:	00 
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	89 04 24             	mov    %eax,(%esp)
  802918:	e8 87 fa ff ff       	call   8023a4 <fd_close>
		return r;
  80291d:	eb 0d                	jmp    80292c <open+0x81>
	}

	return fd2num(fd);
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	89 04 24             	mov    %eax,(%esp)
  802925:	e8 ca f6 ff ff       	call   801ff4 <fd2num>
  80292a:	89 c3                	mov    %eax,%ebx
}
  80292c:	89 d8                	mov    %ebx,%eax
  80292e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802931:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802934:	89 ec                	mov    %ebp,%esp
  802936:	5d                   	pop    %ebp
  802937:	c3                   	ret    

00802938 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	53                   	push   %ebx
  80293c:	83 ec 14             	sub    $0x14,%esp
  80293f:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  802941:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802945:	7e 31                	jle    802978 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80294e:	8d 43 10             	lea    0x10(%ebx),%eax
  802951:	89 44 24 04          	mov    %eax,0x4(%esp)
  802955:	8b 03                	mov    (%ebx),%eax
  802957:	89 04 24             	mov    %eax,(%esp)
  80295a:	e8 e7 f8 ff ff       	call   802246 <write>
		if (result > 0)
  80295f:	85 c0                	test   %eax,%eax
  802961:	7e 03                	jle    802966 <writebuf+0x2e>
			b->result += result;
  802963:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802966:	3b 43 04             	cmp    0x4(%ebx),%eax
  802969:	74 0d                	je     802978 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80296b:	85 c0                	test   %eax,%eax
  80296d:	ba 00 00 00 00       	mov    $0x0,%edx
  802972:	0f 4f c2             	cmovg  %edx,%eax
  802975:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802978:	83 c4 14             	add    $0x14,%esp
  80297b:	5b                   	pop    %ebx
  80297c:	5d                   	pop    %ebp
  80297d:	c3                   	ret    

0080297e <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80297e:	55                   	push   %ebp
  80297f:	89 e5                	mov    %esp,%ebp
  802981:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802990:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802997:	00 00 00 
	b.result = 0;
  80299a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8029a1:	00 00 00 
	b.error = 1;
  8029a4:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8029ab:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8029ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8029b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029bc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8029c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c6:	c7 04 24 3a 2a 80 00 	movl   $0x802a3a,(%esp)
  8029cd:	e8 ed e2 ff ff       	call   800cbf <vprintfmt>
	if (b.idx > 0)
  8029d2:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8029d9:	7e 0b                	jle    8029e6 <vfprintf+0x68>
		writebuf(&b);
  8029db:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8029e1:	e8 52 ff ff ff       	call   802938 <writebuf>

	return (b.result ? b.result : b.error);
  8029e6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  8029fd:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  802a00:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802a12:	e8 67 ff ff ff       	call   80297e <vfprintf>
	va_end(ap);

	return cnt;
}
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  802a1f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  802a22:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	89 04 24             	mov    %eax,(%esp)
  802a33:	e8 46 ff ff ff       	call   80297e <vfprintf>
	va_end(ap);

	return cnt;
}
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    

00802a3a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  802a3a:	55                   	push   %ebp
  802a3b:	89 e5                	mov    %esp,%ebp
  802a3d:	53                   	push   %ebx
  802a3e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  802a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  802a44:	8b 43 04             	mov    0x4(%ebx),%eax
  802a47:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  802a4e:	83 c0 01             	add    $0x1,%eax
  802a51:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  802a54:	3d 00 01 00 00       	cmp    $0x100,%eax
  802a59:	75 0e                	jne    802a69 <putch+0x2f>
		writebuf(b);
  802a5b:	89 d8                	mov    %ebx,%eax
  802a5d:	e8 d6 fe ff ff       	call   802938 <writebuf>
		b->idx = 0;
  802a62:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802a69:	83 c4 04             	add    $0x4,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5d                   	pop    %ebp
  802a6e:	c3                   	ret    
	...

00802a70 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
  802a73:	57                   	push   %edi
  802a74:	56                   	push   %esi
  802a75:	53                   	push   %ebx
  802a76:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a83:	00 
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	89 04 24             	mov    %eax,(%esp)
  802a8a:	e8 1c fe ff ff       	call   8028ab <open>
  802a8f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802a95:	85 c0                	test   %eax,%eax
  802a97:	0f 88 f7 05 00 00    	js     803094 <spawn+0x624>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  802a9d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802aa4:	00 
  802aa5:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aaf:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802ab5:	89 14 24             	mov    %edx,(%esp)
  802ab8:	e8 a0 f8 ff ff       	call   80235d <readn>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802abd:	3d 00 02 00 00       	cmp    $0x200,%eax
  802ac2:	75 0c                	jne    802ad0 <spawn+0x60>
  802ac4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802acb:	45 4c 46 
  802ace:	74 3b                	je     802b0b <spawn+0x9b>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  802ad0:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802ad6:	89 04 24             	mov    %eax,(%esp)
  802ad9:	e8 58 f9 ff ff       	call   802436 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802ade:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802ae5:	46 
  802ae6:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af0:	c7 04 24 e1 45 80 00 	movl   $0x8045e1,(%esp)
  802af7:	e8 25 e0 ff ff       	call   800b21 <cprintf>
  802afc:	c7 85 8c fd ff ff f2 	movl   $0xfffffff2,-0x274(%ebp)
  802b03:	ff ff ff 
		return -E_NOT_EXEC;
  802b06:	e9 89 05 00 00       	jmp    803094 <spawn+0x624>
  802b0b:	ba 07 00 00 00       	mov    $0x7,%edx
  802b10:	89 d0                	mov    %edx,%eax
  802b12:	cd 30                	int    $0x30
  802b14:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	0f 88 66 05 00 00    	js     803088 <spawn+0x618>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b22:	89 c6                	mov    %eax,%esi
  802b24:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802b2a:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802b2d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802b33:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802b39:	b9 11 00 00 00       	mov    $0x11,%ecx
  802b3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802b40:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802b46:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  802b4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b51:	be 00 00 00 00       	mov    $0x0,%esi
  802b56:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b59:	eb 0f                	jmp    802b6a <spawn+0xfa>

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802b5b:	89 04 24             	mov    %eax,(%esp)
  802b5e:	e8 dd e6 ff ff       	call   801240 <strlen>
  802b63:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b67:	83 c3 01             	add    $0x1,%ebx
  802b6a:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  802b71:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	75 e3                	jne    802b5b <spawn+0xeb>
  802b78:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  802b7e:	89 9d 7c fd ff ff    	mov    %ebx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802b84:	f7 de                	neg    %esi
  802b86:	81 c6 00 10 40 00    	add    $0x401000,%esi
  802b8c:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802b92:	89 f2                	mov    %esi,%edx
  802b94:	83 e2 fc             	and    $0xfffffffc,%edx
  802b97:	89 d8                	mov    %ebx,%eax
  802b99:	f7 d0                	not    %eax
  802b9b:	8d 3c 82             	lea    (%edx,%eax,4),%edi

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b9e:	8d 57 f8             	lea    -0x8(%edi),%edx
  802ba1:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802ba7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802bac:	81 fa ff ff 3f 00    	cmp    $0x3fffff,%edx
  802bb2:	0f 86 ed 04 00 00    	jbe    8030a5 <spawn+0x635>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802bb8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802bbf:	00 
  802bc0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802bc7:	00 
  802bc8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bcf:	e8 ea ed ff ff       	call   8019be <sys_page_alloc>
  802bd4:	be 00 00 00 00       	mov    $0x0,%esi
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	79 4c                	jns    802c29 <spawn+0x1b9>
  802bdd:	e9 c3 04 00 00       	jmp    8030a5 <spawn+0x635>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  802be2:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802be8:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802bed:	89 04 b7             	mov    %eax,(%edi,%esi,4)
		strcpy(string_store, argv[i]);
  802bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf3:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  802bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bfa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c00:	89 04 24             	mov    %eax,(%esp)
  802c03:	e8 71 e6 ff ff       	call   801279 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c0b:	8b 04 b2             	mov    (%edx,%esi,4),%eax
  802c0e:	89 04 24             	mov    %eax,(%esp)
  802c11:	e8 2a e6 ff ff       	call   801240 <strlen>
  802c16:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802c1c:	8d 54 02 01          	lea    0x1(%edx,%eax,1),%edx
  802c20:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802c26:	83 c6 01             	add    $0x1,%esi
  802c29:	39 de                	cmp    %ebx,%esi
  802c2b:	7c b5                	jl     802be2 <spawn+0x172>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802c2d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802c33:	c7 04 07 00 00 00 00 	movl   $0x0,(%edi,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c3a:	81 bd 94 fd ff ff 00 	cmpl   $0x401000,-0x26c(%ebp)
  802c41:	10 40 00 
  802c44:	74 24                	je     802c6a <spawn+0x1fa>
  802c46:	c7 44 24 0c 6c 46 80 	movl   $0x80466c,0xc(%esp)
  802c4d:	00 
  802c4e:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  802c55:	00 
  802c56:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  802c5d:	00 
  802c5e:	c7 04 24 fb 45 80 00 	movl   $0x8045fb,(%esp)
  802c65:	e8 fe dd ff ff       	call   800a68 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c6a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802c70:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  802c73:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802c79:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802c7f:	89 02                	mov    %eax,(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802c81:	81 ef 08 30 80 11    	sub    $0x11803008,%edi
  802c87:	89 bd e0 fd ff ff    	mov    %edi,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802c8d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802c94:	00 
  802c95:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802c9c:	ee 
  802c9d:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802ca3:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ca7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cae:	00 
  802caf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cb6:	e8 a5 ec ff ff       	call   801960 <sys_page_map>
  802cbb:	89 c3                	mov    %eax,%ebx
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	78 1a                	js     802cdb <spawn+0x26b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802cc1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cc8:	00 
  802cc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cd0:	e8 2d ec ff ff       	call   801902 <sys_page_unmap>
  802cd5:	89 c3                	mov    %eax,%ebx
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	79 1f                	jns    802cfa <spawn+0x28a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802cdb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ce2:	00 
  802ce3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cea:	e8 13 ec ff ff       	call   801902 <sys_page_unmap>
  802cef:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802cf5:	e9 9a 03 00 00       	jmp    803094 <spawn+0x624>

	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cfa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802d00:	03 85 04 fe ff ff    	add    -0x1fc(%ebp),%eax
  802d06:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  802d0c:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802d13:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d16:	e9 c1 01 00 00       	jmp    802edc <spawn+0x46c>
		if (ph->p_type != ELF_PROG_LOAD)
  802d1b:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d21:	83 38 01             	cmpl   $0x1,(%eax)
  802d24:	0f 85 a4 01 00 00    	jne    802ece <spawn+0x45e>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802d2a:	89 c2                	mov    %eax,%edx
  802d2c:	8b 40 18             	mov    0x18(%eax),%eax
  802d2f:	83 e0 02             	and    $0x2,%eax
  802d32:	83 f8 01             	cmp    $0x1,%eax
  802d35:	19 c0                	sbb    %eax,%eax
  802d37:	83 e0 fe             	and    $0xfffffffe,%eax
  802d3a:	83 c0 07             	add    $0x7,%eax
  802d3d:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802d43:	8b 52 04             	mov    0x4(%edx),%edx
  802d46:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802d4c:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d52:	8b 40 10             	mov    0x10(%eax),%eax
  802d55:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802d5b:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802d61:	8b 52 14             	mov    0x14(%edx),%edx
  802d64:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
  802d6a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d70:	8b 58 08             	mov    0x8(%eax),%ebx
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802d73:	89 d8                	mov    %ebx,%eax
  802d75:	25 ff 0f 00 00       	and    $0xfff,%eax
  802d7a:	74 16                	je     802d92 <spawn+0x322>
		va -= i;
  802d7c:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802d7e:	01 c2                	add    %eax,%edx
  802d80:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		filesz += i;
  802d86:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802d8c:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
  802d92:	be 00 00 00 00       	mov    $0x0,%esi
  802d97:	89 df                	mov    %ebx,%edi
  802d99:	e9 22 01 00 00       	jmp    802ec0 <spawn+0x450>
	}

	for (i = 0; i < memsz; i += PGSIZE) {
		if (i >= filesz) {
  802d9e:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802da4:	77 2b                	ja     802dd1 <spawn+0x361>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802da6:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802dac:	89 54 24 08          	mov    %edx,0x8(%esp)
  802db0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802db4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802dba:	89 04 24             	mov    %eax,(%esp)
  802dbd:	e8 fc eb ff ff       	call   8019be <sys_page_alloc>
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	0f 89 ea 00 00 00    	jns    802eb4 <spawn+0x444>
  802dca:	89 c3                	mov    %eax,%ebx
  802dcc:	e9 93 02 00 00       	jmp    803064 <spawn+0x5f4>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802dd1:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802dd8:	00 
  802dd9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802de0:	00 
  802de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802de8:	e8 d1 eb ff ff       	call   8019be <sys_page_alloc>
  802ded:	85 c0                	test   %eax,%eax
  802def:	0f 88 65 02 00 00    	js     80305a <spawn+0x5ea>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802df5:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
  802dfb:	01 d8                	add    %ebx,%eax
  802dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e01:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802e07:	89 14 24             	mov    %edx,(%esp)
  802e0a:	e8 b1 f2 ff ff       	call   8020c0 <seek>
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	0f 88 47 02 00 00    	js     80305e <spawn+0x5ee>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802e17:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802e1d:	29 d8                	sub    %ebx,%eax
  802e1f:	89 c3                	mov    %eax,%ebx
  802e21:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802e26:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e2b:	0f 47 da             	cmova  %edx,%ebx
  802e2e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e32:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e39:	00 
  802e3a:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802e40:	89 04 24             	mov    %eax,(%esp)
  802e43:	e8 15 f5 ff ff       	call   80235d <readn>
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	0f 88 12 02 00 00    	js     803062 <spawn+0x5f2>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802e50:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802e56:	89 54 24 10          	mov    %edx,0x10(%esp)
  802e5a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e5e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802e64:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e68:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e6f:	00 
  802e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e77:	e8 e4 ea ff ff       	call   801960 <sys_page_map>
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	79 20                	jns    802ea0 <spawn+0x430>
				panic("spawn: sys_page_map data: %e", r);
  802e80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e84:	c7 44 24 08 07 46 80 	movl   $0x804607,0x8(%esp)
  802e8b:	00 
  802e8c:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  802e93:	00 
  802e94:	c7 04 24 fb 45 80 00 	movl   $0x8045fb,(%esp)
  802e9b:	e8 c8 db ff ff       	call   800a68 <_panic>
			sys_page_unmap(0, UTEMP);
  802ea0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ea7:	00 
  802ea8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802eaf:	e8 4e ea ff ff       	call   801902 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802eb4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802eba:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802ec0:	89 f3                	mov    %esi,%ebx
  802ec2:	39 b5 84 fd ff ff    	cmp    %esi,-0x27c(%ebp)
  802ec8:	0f 87 d0 fe ff ff    	ja     802d9e <spawn+0x32e>
	if ((r = init_stack(child, argv, &(child_tf.tf_esp))) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ece:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802ed5:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802edc:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802ee3:	39 85 7c fd ff ff    	cmp    %eax,-0x284(%ebp)
  802ee9:	0f 8c 2c fe ff ff    	jl     802d1b <spawn+0x2ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802eef:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802ef5:	89 14 24             	mov    %edx,(%esp)
  802ef8:	e8 39 f5 ff ff       	call   802436 <close>
	fd = -1;

	cprintf("copy sharing pages\n");
  802efd:	c7 04 24 3e 46 80 00 	movl   $0x80463e,(%esp)
  802f04:	e8 18 dc ff ff       	call   800b21 <cprintf>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
  802f09:	e8 43 eb ff ff       	call   801a51 <sys_getenvid>
  802f0e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802f14:	c7 85 8c fd ff ff 00 	movl   $0x0,-0x274(%ebp)
  802f1b:	00 00 00 

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  802f1e:	be 00 00 40 ef       	mov    $0xef400000,%esi
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  802f23:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802f29:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  802f30:	a8 01                	test   $0x1,%al
  802f32:	0f 84 89 00 00 00    	je     802fc1 <spawn+0x551>
  802f38:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  802f3e:	0f 84 69 01 00 00    	je     8030ad <spawn+0x63d>
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  802f44:	89 d7                	mov    %edx,%edi
  802f46:	c1 e7 16             	shl    $0x16,%edi
  802f49:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f4e:	89 da                	mov    %ebx,%edx
  802f50:	c1 e2 0c             	shl    $0xc,%edx
  802f53:	01 fa                	add    %edi,%edx
				
				if((uvpt[addr>>PGSHIFT] & PTE_P) && (uvpt[addr>>PGSHIFT] & PTE_SHARE))
  802f55:	89 d0                	mov    %edx,%eax
  802f57:	c1 e8 0c             	shr    $0xc,%eax
  802f5a:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
  802f5d:	f6 c1 01             	test   $0x1,%cl
  802f60:	74 54                	je     802fb6 <spawn+0x546>
  802f62:	8b 04 86             	mov    (%esi,%eax,4),%eax
  802f65:	f6 c4 04             	test   $0x4,%ah
  802f68:	74 4c                	je     802fb6 <spawn+0x546>
				{
					ret = sys_page_map(curr_envid, (void *)addr, child,(void *)addr,PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  802f6a:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  802f71:	00 
  802f72:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f76:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802f7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f80:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f84:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802f8a:	89 14 24             	mov    %edx,(%esp)
  802f8d:	e8 ce e9 ff ff       	call   801960 <sys_page_map>
					if(ret) panic("sys_page_map: %e", ret);
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 20                	je     802fb6 <spawn+0x546>
  802f96:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f9a:	c7 44 24 08 24 46 80 	movl   $0x804624,0x8(%esp)
  802fa1:	00 
  802fa2:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  802fa9:	00 
  802faa:	c7 04 24 fb 45 80 00 	movl   $0x8045fb,(%esp)
  802fb1:	e8 b2 da ff ff       	call   800a68 <_panic>
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
		{
			addr = i << PDXSHIFT;

			for(j=0;j<NPTENTRIES;j++)
  802fb6:	83 c3 01             	add    $0x1,%ebx
  802fb9:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802fbf:	75 8d                	jne    802f4e <spawn+0x4de>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  802fc1:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  802fc8:	81 bd 8c fd ff ff bb 	cmpl   $0x3bb,-0x274(%ebp)
  802fcf:	03 00 00 
  802fd2:	0f 85 4b ff ff ff    	jne    802f23 <spawn+0x4b3>

	cprintf("copy sharing pages\n");
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
	cprintf("complete copy sharing pages\n");	
  802fd8:	c7 04 24 35 46 80 00 	movl   $0x804635,(%esp)
  802fdf:	e8 3d db ff ff       	call   800b21 <cprintf>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802fe4:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fee:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802ff4:	89 04 24             	mov    %eax,(%esp)
  802ff7:	e8 4a e8 ff ff       	call   801846 <sys_env_set_trapframe>
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	79 20                	jns    803020 <spawn+0x5b0>
		panic("sys_env_set_trapframe: %e", r);
  803000:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803004:	c7 44 24 08 52 46 80 	movl   $0x804652,0x8(%esp)
  80300b:	00 
  80300c:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  803013:	00 
  803014:	c7 04 24 fb 45 80 00 	movl   $0x8045fb,(%esp)
  80301b:	e8 48 da ff ff       	call   800a68 <_panic>
	
	//thisenv = &envs[ENVX(child)];
	//cprintf("%s %x\n",__func__,thisenv->env_id);
	
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803020:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  803027:	00 
  803028:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80302e:	89 14 24             	mov    %edx,(%esp)
  803031:	e8 6e e8 ff ff       	call   8018a4 <sys_env_set_status>
  803036:	85 c0                	test   %eax,%eax
  803038:	79 4e                	jns    803088 <spawn+0x618>
		panic("sys_env_set_status: %e", r);
  80303a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80303e:	c7 44 24 08 8a 44 80 	movl   $0x80448a,0x8(%esp)
  803045:	00 
  803046:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  80304d:	00 
  80304e:	c7 04 24 fb 45 80 00 	movl   $0x8045fb,(%esp)
  803055:	e8 0e da ff ff       	call   800a68 <_panic>
  80305a:	89 c3                	mov    %eax,%ebx
  80305c:	eb 06                	jmp    803064 <spawn+0x5f4>
  80305e:	89 c3                	mov    %eax,%ebx
  803060:	eb 02                	jmp    803064 <spawn+0x5f4>
  803062:	89 c3                	mov    %eax,%ebx
	
	return child;

error:
	sys_env_destroy(child);
  803064:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80306a:	89 04 24             	mov    %eax,(%esp)
  80306d:	e8 13 ea ff ff       	call   801a85 <sys_env_destroy>
	close(fd);
  803072:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  803078:	89 14 24             	mov    %edx,(%esp)
  80307b:	e8 b6 f3 ff ff       	call   802436 <close>
  803080:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
	return r;
  803086:	eb 0c                	jmp    803094 <spawn+0x624>
  803088:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80308e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
}
  803094:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80309a:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8030a0:	5b                   	pop    %ebx
  8030a1:	5e                   	pop    %esi
  8030a2:	5f                   	pop    %edi
  8030a3:	5d                   	pop    %ebp
  8030a4:	c3                   	ret    
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8030a5:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8030ab:	eb e7                	jmp    803094 <spawn+0x624>
	// LAB 5: Your code here.
	int i,j,ret;
	uintptr_t addr;
	envid_t curr_envid = sys_getenvid();
	
	for(i=0;i<PDX(UTOP);i++)
  8030ad:	83 85 8c fd ff ff 01 	addl   $0x1,-0x274(%ebp)
  8030b4:	e9 6a fe ff ff       	jmp    802f23 <spawn+0x4b3>

008030b9 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8030b9:	55                   	push   %ebp
  8030ba:	89 e5                	mov    %esp,%ebp
  8030bc:	56                   	push   %esi
  8030bd:	53                   	push   %ebx
  8030be:	83 ec 10             	sub    $0x10,%esp

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8030c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8030c4:	ba 00 00 00 00       	mov    $0x0,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8030c9:	eb 03                	jmp    8030ce <spawnl+0x15>
		argc++;
  8030cb:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8030ce:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  8030d2:	75 f7                	jne    8030cb <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8030d4:	8d 04 95 26 00 00 00 	lea    0x26(,%edx,4),%eax
  8030db:	83 e0 f0             	and    $0xfffffff0,%eax
  8030de:	29 c4                	sub    %eax,%esp
  8030e0:	8d 5c 24 17          	lea    0x17(%esp),%ebx
  8030e4:	83 e3 f0             	and    $0xfffffff0,%ebx
	argv[0] = arg0;
  8030e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ea:	89 03                	mov    %eax,(%ebx)
	argv[argc+1] = NULL;
  8030ec:	c7 44 93 04 00 00 00 	movl   $0x0,0x4(%ebx,%edx,4)
  8030f3:	00 

// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
  8030f4:	8d 75 10             	lea    0x10(%ebp),%esi
  8030f7:	b8 00 00 00 00       	mov    $0x0,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8030fc:	eb 0a                	jmp    803108 <spawnl+0x4f>
		argv[i+1] = va_arg(vl, const char *);
  8030fe:	83 c0 01             	add    $0x1,%eax
  803101:	8b 4c 86 fc          	mov    -0x4(%esi,%eax,4),%ecx
  803105:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803108:	39 d0                	cmp    %edx,%eax
  80310a:	72 f2                	jb     8030fe <spawnl+0x45>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80310c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	89 04 24             	mov    %eax,(%esp)
  803116:	e8 55 f9 ff ff       	call   802a70 <spawn>
}
  80311b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80311e:	5b                   	pop    %ebx
  80311f:	5e                   	pop    %esi
  803120:	5d                   	pop    %ebp
  803121:	c3                   	ret    
	...

00803130 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803130:	55                   	push   %ebp
  803131:	89 e5                	mov    %esp,%ebp
  803133:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803136:	c7 44 24 04 94 46 80 	movl   $0x804694,0x4(%esp)
  80313d:	00 
  80313e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803141:	89 04 24             	mov    %eax,(%esp)
  803144:	e8 30 e1 ff ff       	call   801279 <strcpy>
	return 0;
}
  803149:	b8 00 00 00 00       	mov    $0x0,%eax
  80314e:	c9                   	leave  
  80314f:	c3                   	ret    

00803150 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
  803153:	53                   	push   %ebx
  803154:	83 ec 14             	sub    $0x14,%esp
  803157:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80315a:	89 1c 24             	mov    %ebx,(%esp)
  80315d:	e8 a6 0a 00 00       	call   803c08 <pageref>
  803162:	89 c2                	mov    %eax,%edx
  803164:	b8 00 00 00 00       	mov    $0x0,%eax
  803169:	83 fa 01             	cmp    $0x1,%edx
  80316c:	75 0b                	jne    803179 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80316e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803171:	89 04 24             	mov    %eax,(%esp)
  803174:	e8 b1 02 00 00       	call   80342a <nsipc_close>
	else
		return 0;
}
  803179:	83 c4 14             	add    $0x14,%esp
  80317c:	5b                   	pop    %ebx
  80317d:	5d                   	pop    %ebp
  80317e:	c3                   	ret    

0080317f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80317f:	55                   	push   %ebp
  803180:	89 e5                	mov    %esp,%ebp
  803182:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803185:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80318c:	00 
  80318d:	8b 45 10             	mov    0x10(%ebp),%eax
  803190:	89 44 24 08          	mov    %eax,0x8(%esp)
  803194:	8b 45 0c             	mov    0xc(%ebp),%eax
  803197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a1:	89 04 24             	mov    %eax,(%esp)
  8031a4:	e8 bd 02 00 00       	call   803466 <nsipc_send>
}
  8031a9:	c9                   	leave  
  8031aa:	c3                   	ret    

008031ab <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
  8031ae:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8031b8:	00 
  8031b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8031bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cd:	89 04 24             	mov    %eax,(%esp)
  8031d0:	e8 04 03 00 00       	call   8034d9 <nsipc_recv>
}
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8031d7:	55                   	push   %ebp
  8031d8:	89 e5                	mov    %esp,%ebp
  8031da:	56                   	push   %esi
  8031db:	53                   	push   %ebx
  8031dc:	83 ec 20             	sub    $0x20,%esp
  8031df:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8031e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031e4:	89 04 24             	mov    %eax,(%esp)
  8031e7:	e8 33 ee ff ff       	call   80201f <fd_alloc>
  8031ec:	89 c3                	mov    %eax,%ebx
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	78 21                	js     803213 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8031f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031f9:	00 
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803208:	e8 b1 e7 ff ff       	call   8019be <sys_page_alloc>
  80320d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80320f:	85 c0                	test   %eax,%eax
  803211:	79 0a                	jns    80321d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803213:	89 34 24             	mov    %esi,(%esp)
  803216:	e8 0f 02 00 00       	call   80342a <nsipc_close>
		return r;
  80321b:	eb 28                	jmp    803245 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80321d:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	89 04 24             	mov    %eax,(%esp)
  80323e:	e8 b1 ed ff ff       	call   801ff4 <fd2num>
  803243:	89 c3                	mov    %eax,%ebx
}
  803245:	89 d8                	mov    %ebx,%eax
  803247:	83 c4 20             	add    $0x20,%esp
  80324a:	5b                   	pop    %ebx
  80324b:	5e                   	pop    %esi
  80324c:	5d                   	pop    %ebp
  80324d:	c3                   	ret    

0080324e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
  803251:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803254:	8b 45 10             	mov    0x10(%ebp),%eax
  803257:	89 44 24 08          	mov    %eax,0x8(%esp)
  80325b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	89 04 24             	mov    %eax,(%esp)
  803268:	e8 71 01 00 00       	call   8033de <nsipc_socket>
  80326d:	85 c0                	test   %eax,%eax
  80326f:	78 05                	js     803276 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  803271:	e8 61 ff ff ff       	call   8031d7 <alloc_sockfd>
}
  803276:	c9                   	leave  
  803277:	c3                   	ret    

00803278 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803278:	55                   	push   %ebp
  803279:	89 e5                	mov    %esp,%ebp
  80327b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80327e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803281:	89 54 24 04          	mov    %edx,0x4(%esp)
  803285:	89 04 24             	mov    %eax,(%esp)
  803288:	e8 eb ed ff ff       	call   802078 <fd_lookup>
  80328d:	85 c0                	test   %eax,%eax
  80328f:	78 15                	js     8032a6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803294:	8b 0a                	mov    (%edx),%ecx
  803296:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80329b:	3b 0d 3c 50 80 00    	cmp    0x80503c,%ecx
  8032a1:	75 03                	jne    8032a6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8032a3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
  8032ab:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	e8 c2 ff ff ff       	call   803278 <fd2sockid>
  8032b6:	85 c0                	test   %eax,%eax
  8032b8:	78 0f                	js     8032c9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8032ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032c1:	89 04 24             	mov    %eax,(%esp)
  8032c4:	e8 3f 01 00 00       	call   803408 <nsipc_listen>
}
  8032c9:	c9                   	leave  
  8032ca:	c3                   	ret    

008032cb <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032cb:	55                   	push   %ebp
  8032cc:	89 e5                	mov    %esp,%ebp
  8032ce:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	e8 9f ff ff ff       	call   803278 <fd2sockid>
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	78 16                	js     8032f3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8032dd:	8b 55 10             	mov    0x10(%ebp),%edx
  8032e0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032e7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032eb:	89 04 24             	mov    %eax,(%esp)
  8032ee:	e8 66 02 00 00       	call   803559 <nsipc_connect>
}
  8032f3:	c9                   	leave  
  8032f4:	c3                   	ret    

008032f5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8032f5:	55                   	push   %ebp
  8032f6:	89 e5                	mov    %esp,%ebp
  8032f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	e8 75 ff ff ff       	call   803278 <fd2sockid>
  803303:	85 c0                	test   %eax,%eax
  803305:	78 0f                	js     803316 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80330a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80330e:	89 04 24             	mov    %eax,(%esp)
  803311:	e8 2e 01 00 00       	call   803444 <nsipc_shutdown>
}
  803316:	c9                   	leave  
  803317:	c3                   	ret    

00803318 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803318:	55                   	push   %ebp
  803319:	89 e5                	mov    %esp,%ebp
  80331b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	e8 52 ff ff ff       	call   803278 <fd2sockid>
  803326:	85 c0                	test   %eax,%eax
  803328:	78 16                	js     803340 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80332a:	8b 55 10             	mov    0x10(%ebp),%edx
  80332d:	89 54 24 08          	mov    %edx,0x8(%esp)
  803331:	8b 55 0c             	mov    0xc(%ebp),%edx
  803334:	89 54 24 04          	mov    %edx,0x4(%esp)
  803338:	89 04 24             	mov    %eax,(%esp)
  80333b:	e8 58 02 00 00       	call   803598 <nsipc_bind>
}
  803340:	c9                   	leave  
  803341:	c3                   	ret    

00803342 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803342:	55                   	push   %ebp
  803343:	89 e5                	mov    %esp,%ebp
  803345:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	e8 28 ff ff ff       	call   803278 <fd2sockid>
  803350:	85 c0                	test   %eax,%eax
  803352:	78 1f                	js     803373 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803354:	8b 55 10             	mov    0x10(%ebp),%edx
  803357:	89 54 24 08          	mov    %edx,0x8(%esp)
  80335b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80335e:	89 54 24 04          	mov    %edx,0x4(%esp)
  803362:	89 04 24             	mov    %eax,(%esp)
  803365:	e8 6d 02 00 00       	call   8035d7 <nsipc_accept>
  80336a:	85 c0                	test   %eax,%eax
  80336c:	78 05                	js     803373 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80336e:	e8 64 fe ff ff       	call   8031d7 <alloc_sockfd>
}
  803373:	c9                   	leave  
  803374:	c3                   	ret    
  803375:	00 00                	add    %al,(%eax)
	...

00803378 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803378:	55                   	push   %ebp
  803379:	89 e5                	mov    %esp,%ebp
  80337b:	53                   	push   %ebx
  80337c:	83 ec 14             	sub    $0x14,%esp
  80337f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803381:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  803388:	75 11                	jne    80339b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80338a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  803391:	e8 46 07 00 00       	call   803adc <ipc_find_env>
  803396:	a3 24 64 80 00       	mov    %eax,0x806424
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80339b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8033a2:	00 
  8033a3:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  8033aa:	00 
  8033ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033af:	a1 24 64 80 00       	mov    0x806424,%eax
  8033b4:	89 04 24             	mov    %eax,(%esp)
  8033b7:	e8 56 07 00 00       	call   803b12 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8033bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8033c3:	00 
  8033c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8033cb:	00 
  8033cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033d3:	e8 a6 07 00 00       	call   803b7e <ipc_recv>
}
  8033d8:	83 c4 14             	add    $0x14,%esp
  8033db:	5b                   	pop    %ebx
  8033dc:	5d                   	pop    %ebp
  8033dd:	c3                   	ret    

008033de <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8033de:	55                   	push   %ebp
  8033df:	89 e5                	mov    %esp,%ebp
  8033e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  8033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ef:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  8033f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8033f7:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  8033fc:	b8 09 00 00 00       	mov    $0x9,%eax
  803401:	e8 72 ff ff ff       	call   803378 <nsipc>
}
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  803416:	8b 45 0c             	mov    0xc(%ebp),%eax
  803419:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80341e:	b8 06 00 00 00       	mov    $0x6,%eax
  803423:	e8 50 ff ff ff       	call   803378 <nsipc>
}
  803428:	c9                   	leave  
  803429:	c3                   	ret    

0080342a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80342a:	55                   	push   %ebp
  80342b:	89 e5                	mov    %esp,%ebp
  80342d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  803438:	b8 04 00 00 00       	mov    $0x4,%eax
  80343d:	e8 36 ff ff ff       	call   803378 <nsipc>
}
  803442:	c9                   	leave  
  803443:	c3                   	ret    

00803444 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
  803447:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  803452:	8b 45 0c             	mov    0xc(%ebp),%eax
  803455:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  80345a:	b8 03 00 00 00       	mov    $0x3,%eax
  80345f:	e8 14 ff ff ff       	call   803378 <nsipc>
}
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
  803469:	53                   	push   %ebx
  80346a:	83 ec 14             	sub    $0x14,%esp
  80346d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  803478:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80347e:	7e 24                	jle    8034a4 <nsipc_send+0x3e>
  803480:	c7 44 24 0c a0 46 80 	movl   $0x8046a0,0xc(%esp)
  803487:	00 
  803488:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  80348f:	00 
  803490:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  803497:	00 
  803498:	c7 04 24 ac 46 80 00 	movl   $0x8046ac,(%esp)
  80349f:	e8 c4 d5 ff ff       	call   800a68 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034af:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  8034b6:	e8 64 df ff ff       	call   80141f <memmove>
	nsipcbuf.send.req_size = size;
  8034bb:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  8034c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8034c4:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  8034c9:	b8 08 00 00 00       	mov    $0x8,%eax
  8034ce:	e8 a5 fe ff ff       	call   803378 <nsipc>
}
  8034d3:	83 c4 14             	add    $0x14,%esp
  8034d6:	5b                   	pop    %ebx
  8034d7:	5d                   	pop    %ebp
  8034d8:	c3                   	ret    

008034d9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8034d9:	55                   	push   %ebp
  8034da:	89 e5                	mov    %esp,%ebp
  8034dc:	56                   	push   %esi
  8034dd:	53                   	push   %ebx
  8034de:	83 ec 10             	sub    $0x10,%esp
  8034e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8034ec:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  8034f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8034f5:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034fa:	b8 07 00 00 00       	mov    $0x7,%eax
  8034ff:	e8 74 fe ff ff       	call   803378 <nsipc>
  803504:	89 c3                	mov    %eax,%ebx
  803506:	85 c0                	test   %eax,%eax
  803508:	78 46                	js     803550 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80350a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80350f:	7f 04                	jg     803515 <nsipc_recv+0x3c>
  803511:	39 c6                	cmp    %eax,%esi
  803513:	7d 24                	jge    803539 <nsipc_recv+0x60>
  803515:	c7 44 24 0c b8 46 80 	movl   $0x8046b8,0xc(%esp)
  80351c:	00 
  80351d:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  803524:	00 
  803525:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80352c:	00 
  80352d:	c7 04 24 ac 46 80 00 	movl   $0x8046ac,(%esp)
  803534:	e8 2f d5 ff ff       	call   800a68 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803539:	89 44 24 08          	mov    %eax,0x8(%esp)
  80353d:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  803544:	00 
  803545:	8b 45 0c             	mov    0xc(%ebp),%eax
  803548:	89 04 24             	mov    %eax,(%esp)
  80354b:	e8 cf de ff ff       	call   80141f <memmove>
	}

	return r;
}
  803550:	89 d8                	mov    %ebx,%eax
  803552:	83 c4 10             	add    $0x10,%esp
  803555:	5b                   	pop    %ebx
  803556:	5e                   	pop    %esi
  803557:	5d                   	pop    %ebp
  803558:	c3                   	ret    

00803559 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803559:	55                   	push   %ebp
  80355a:	89 e5                	mov    %esp,%ebp
  80355c:	53                   	push   %ebx
  80355d:	83 ec 14             	sub    $0x14,%esp
  803560:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80356b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80356f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803572:	89 44 24 04          	mov    %eax,0x4(%esp)
  803576:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  80357d:	e8 9d de ff ff       	call   80141f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803582:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  803588:	b8 05 00 00 00       	mov    $0x5,%eax
  80358d:	e8 e6 fd ff ff       	call   803378 <nsipc>
}
  803592:	83 c4 14             	add    $0x14,%esp
  803595:	5b                   	pop    %ebx
  803596:	5d                   	pop    %ebp
  803597:	c3                   	ret    

00803598 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803598:	55                   	push   %ebp
  803599:	89 e5                	mov    %esp,%ebp
  80359b:	53                   	push   %ebx
  80359c:	83 ec 14             	sub    $0x14,%esp
  80359f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8035aa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b5:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  8035bc:	e8 5e de ff ff       	call   80141f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8035c1:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8035c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8035cc:	e8 a7 fd ff ff       	call   803378 <nsipc>
}
  8035d1:	83 c4 14             	add    $0x14,%esp
  8035d4:	5b                   	pop    %ebx
  8035d5:	5d                   	pop    %ebp
  8035d6:	c3                   	ret    

008035d7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035d7:	55                   	push   %ebp
  8035d8:	89 e5                	mov    %esp,%ebp
  8035da:	83 ec 28             	sub    $0x28,%esp
  8035dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8035e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8035e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8035e6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8035e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ec:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8035f1:	8b 07                	mov    (%edi),%eax
  8035f3:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8035f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fd:	e8 76 fd ff ff       	call   803378 <nsipc>
  803602:	89 c6                	mov    %eax,%esi
  803604:	85 c0                	test   %eax,%eax
  803606:	78 22                	js     80362a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803608:	bb 10 90 80 00       	mov    $0x809010,%ebx
  80360d:	8b 03                	mov    (%ebx),%eax
  80360f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803613:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  80361a:	00 
  80361b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361e:	89 04 24             	mov    %eax,(%esp)
  803621:	e8 f9 dd ff ff       	call   80141f <memmove>
		*addrlen = ret->ret_addrlen;
  803626:	8b 03                	mov    (%ebx),%eax
  803628:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80362a:	89 f0                	mov    %esi,%eax
  80362c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80362f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803632:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803635:	89 ec                	mov    %ebp,%esp
  803637:	5d                   	pop    %ebp
  803638:	c3                   	ret    
  803639:	00 00                	add    %al,(%eax)
	...

0080363c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
  80363f:	83 ec 18             	sub    $0x18,%esp
  803642:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803645:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803648:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	89 04 24             	mov    %eax,(%esp)
  803651:	e8 ae e9 ff ff       	call   802004 <fd2data>
  803656:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  803658:	c7 44 24 04 cd 46 80 	movl   $0x8046cd,0x4(%esp)
  80365f:	00 
  803660:	89 34 24             	mov    %esi,(%esp)
  803663:	e8 11 dc ff ff       	call   801279 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803668:	8b 43 04             	mov    0x4(%ebx),%eax
  80366b:	2b 03                	sub    (%ebx),%eax
  80366d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  803673:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80367a:	00 00 00 
	stat->st_dev = &devpipe;
  80367d:	c7 86 88 00 00 00 58 	movl   $0x805058,0x88(%esi)
  803684:	50 80 00 
	return 0;
}
  803687:	b8 00 00 00 00       	mov    $0x0,%eax
  80368c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80368f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803692:	89 ec                	mov    %ebp,%esp
  803694:	5d                   	pop    %ebp
  803695:	c3                   	ret    

00803696 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803696:	55                   	push   %ebp
  803697:	89 e5                	mov    %esp,%ebp
  803699:	53                   	push   %ebx
  80369a:	83 ec 14             	sub    $0x14,%esp
  80369d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8036a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8036a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036ab:	e8 52 e2 ff ff       	call   801902 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8036b0:	89 1c 24             	mov    %ebx,(%esp)
  8036b3:	e8 4c e9 ff ff       	call   802004 <fd2data>
  8036b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036c3:	e8 3a e2 ff ff       	call   801902 <sys_page_unmap>
}
  8036c8:	83 c4 14             	add    $0x14,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5d                   	pop    %ebp
  8036cd:	c3                   	ret    

008036ce <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
  8036d1:	57                   	push   %edi
  8036d2:	56                   	push   %esi
  8036d3:	53                   	push   %ebx
  8036d4:	83 ec 2c             	sub    $0x2c,%esp
  8036d7:	89 c7                	mov    %eax,%edi
  8036d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036dc:	a1 28 64 80 00       	mov    0x806428,%eax
  8036e1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8036e4:	89 3c 24             	mov    %edi,(%esp)
  8036e7:	e8 1c 05 00 00       	call   803c08 <pageref>
  8036ec:	89 c6                	mov    %eax,%esi
  8036ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f1:	89 04 24             	mov    %eax,(%esp)
  8036f4:	e8 0f 05 00 00       	call   803c08 <pageref>
  8036f9:	39 c6                	cmp    %eax,%esi
  8036fb:	0f 94 c0             	sete   %al
  8036fe:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  803701:	8b 15 28 64 80 00    	mov    0x806428,%edx
  803707:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80370a:	39 cb                	cmp    %ecx,%ebx
  80370c:	75 08                	jne    803716 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80370e:	83 c4 2c             	add    $0x2c,%esp
  803711:	5b                   	pop    %ebx
  803712:	5e                   	pop    %esi
  803713:	5f                   	pop    %edi
  803714:	5d                   	pop    %ebp
  803715:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803716:	83 f8 01             	cmp    $0x1,%eax
  803719:	75 c1                	jne    8036dc <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80371b:	8b 52 58             	mov    0x58(%edx),%edx
  80371e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803722:	89 54 24 08          	mov    %edx,0x8(%esp)
  803726:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80372a:	c7 04 24 d4 46 80 00 	movl   $0x8046d4,(%esp)
  803731:	e8 eb d3 ff ff       	call   800b21 <cprintf>
  803736:	eb a4                	jmp    8036dc <_pipeisclosed+0xe>

00803738 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803738:	55                   	push   %ebp
  803739:	89 e5                	mov    %esp,%ebp
  80373b:	57                   	push   %edi
  80373c:	56                   	push   %esi
  80373d:	53                   	push   %ebx
  80373e:	83 ec 1c             	sub    $0x1c,%esp
  803741:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803744:	89 34 24             	mov    %esi,(%esp)
  803747:	e8 b8 e8 ff ff       	call   802004 <fd2data>
  80374c:	89 c3                	mov    %eax,%ebx
  80374e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803753:	eb 48                	jmp    80379d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803755:	89 da                	mov    %ebx,%edx
  803757:	89 f0                	mov    %esi,%eax
  803759:	e8 70 ff ff ff       	call   8036ce <_pipeisclosed>
  80375e:	85 c0                	test   %eax,%eax
  803760:	74 07                	je     803769 <devpipe_write+0x31>
  803762:	b8 00 00 00 00       	mov    $0x0,%eax
  803767:	eb 3b                	jmp    8037a4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803769:	e8 af e2 ff ff       	call   801a1d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80376e:	8b 43 04             	mov    0x4(%ebx),%eax
  803771:	8b 13                	mov    (%ebx),%edx
  803773:	83 c2 20             	add    $0x20,%edx
  803776:	39 d0                	cmp    %edx,%eax
  803778:	73 db                	jae    803755 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80377a:	89 c2                	mov    %eax,%edx
  80377c:	c1 fa 1f             	sar    $0x1f,%edx
  80377f:	c1 ea 1b             	shr    $0x1b,%edx
  803782:	01 d0                	add    %edx,%eax
  803784:	83 e0 1f             	and    $0x1f,%eax
  803787:	29 d0                	sub    %edx,%eax
  803789:	89 c2                	mov    %eax,%edx
  80378b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80378e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  803792:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803796:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80379a:	83 c7 01             	add    $0x1,%edi
  80379d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8037a0:	72 cc                	jb     80376e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037a2:	89 f8                	mov    %edi,%eax
}
  8037a4:	83 c4 1c             	add    $0x1c,%esp
  8037a7:	5b                   	pop    %ebx
  8037a8:	5e                   	pop    %esi
  8037a9:	5f                   	pop    %edi
  8037aa:	5d                   	pop    %ebp
  8037ab:	c3                   	ret    

008037ac <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037ac:	55                   	push   %ebp
  8037ad:	89 e5                	mov    %esp,%ebp
  8037af:	83 ec 28             	sub    $0x28,%esp
  8037b2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8037b5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8037b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8037bb:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037be:	89 3c 24             	mov    %edi,(%esp)
  8037c1:	e8 3e e8 ff ff       	call   802004 <fd2data>
  8037c6:	89 c3                	mov    %eax,%ebx
  8037c8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037cd:	eb 48                	jmp    803817 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8037cf:	85 f6                	test   %esi,%esi
  8037d1:	74 04                	je     8037d7 <devpipe_read+0x2b>
				return i;
  8037d3:	89 f0                	mov    %esi,%eax
  8037d5:	eb 47                	jmp    80381e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8037d7:	89 da                	mov    %ebx,%edx
  8037d9:	89 f8                	mov    %edi,%eax
  8037db:	e8 ee fe ff ff       	call   8036ce <_pipeisclosed>
  8037e0:	85 c0                	test   %eax,%eax
  8037e2:	74 07                	je     8037eb <devpipe_read+0x3f>
  8037e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e9:	eb 33                	jmp    80381e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8037eb:	e8 2d e2 ff ff       	call   801a1d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037f0:	8b 03                	mov    (%ebx),%eax
  8037f2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8037f5:	74 d8                	je     8037cf <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037f7:	89 c2                	mov    %eax,%edx
  8037f9:	c1 fa 1f             	sar    $0x1f,%edx
  8037fc:	c1 ea 1b             	shr    $0x1b,%edx
  8037ff:	01 d0                	add    %edx,%eax
  803801:	83 e0 1f             	and    $0x1f,%eax
  803804:	29 d0                	sub    %edx,%eax
  803806:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80380b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80380e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803811:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803814:	83 c6 01             	add    $0x1,%esi
  803817:	3b 75 10             	cmp    0x10(%ebp),%esi
  80381a:	72 d4                	jb     8037f0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80381c:	89 f0                	mov    %esi,%eax
}
  80381e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803821:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803824:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803827:	89 ec                	mov    %ebp,%esp
  803829:	5d                   	pop    %ebp
  80382a:	c3                   	ret    

0080382b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80382b:	55                   	push   %ebp
  80382c:	89 e5                	mov    %esp,%ebp
  80382e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803831:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803834:	89 44 24 04          	mov    %eax,0x4(%esp)
  803838:	8b 45 08             	mov    0x8(%ebp),%eax
  80383b:	89 04 24             	mov    %eax,(%esp)
  80383e:	e8 35 e8 ff ff       	call   802078 <fd_lookup>
  803843:	85 c0                	test   %eax,%eax
  803845:	78 15                	js     80385c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	89 04 24             	mov    %eax,(%esp)
  80384d:	e8 b2 e7 ff ff       	call   802004 <fd2data>
	return _pipeisclosed(fd, p);
  803852:	89 c2                	mov    %eax,%edx
  803854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803857:	e8 72 fe ff ff       	call   8036ce <_pipeisclosed>
}
  80385c:	c9                   	leave  
  80385d:	c3                   	ret    

0080385e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
  803861:	83 ec 48             	sub    $0x48,%esp
  803864:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803867:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80386a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80386d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803870:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803873:	89 04 24             	mov    %eax,(%esp)
  803876:	e8 a4 e7 ff ff       	call   80201f <fd_alloc>
  80387b:	89 c3                	mov    %eax,%ebx
  80387d:	85 c0                	test   %eax,%eax
  80387f:	0f 88 42 01 00 00    	js     8039c7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803885:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80388c:	00 
  80388d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803890:	89 44 24 04          	mov    %eax,0x4(%esp)
  803894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80389b:	e8 1e e1 ff ff       	call   8019be <sys_page_alloc>
  8038a0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	0f 88 1d 01 00 00    	js     8039c7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038ad:	89 04 24             	mov    %eax,(%esp)
  8038b0:	e8 6a e7 ff ff       	call   80201f <fd_alloc>
  8038b5:	89 c3                	mov    %eax,%ebx
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	0f 88 f5 00 00 00    	js     8039b4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038bf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038c6:	00 
  8038c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038d5:	e8 e4 e0 ff ff       	call   8019be <sys_page_alloc>
  8038da:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038dc:	85 c0                	test   %eax,%eax
  8038de:	0f 88 d0 00 00 00    	js     8039b4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e7:	89 04 24             	mov    %eax,(%esp)
  8038ea:	e8 15 e7 ff ff       	call   802004 <fd2data>
  8038ef:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038f8:	00 
  8038f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803904:	e8 b5 e0 ff ff       	call   8019be <sys_page_alloc>
  803909:	89 c3                	mov    %eax,%ebx
  80390b:	85 c0                	test   %eax,%eax
  80390d:	0f 88 8e 00 00 00    	js     8039a1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803916:	89 04 24             	mov    %eax,(%esp)
  803919:	e8 e6 e6 ff ff       	call   802004 <fd2data>
  80391e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803925:	00 
  803926:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80392a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803931:	00 
  803932:	89 74 24 04          	mov    %esi,0x4(%esp)
  803936:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80393d:	e8 1e e0 ff ff       	call   801960 <sys_page_map>
  803942:	89 c3                	mov    %eax,%ebx
  803944:	85 c0                	test   %eax,%eax
  803946:	78 49                	js     803991 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803948:	b8 58 50 80 00       	mov    $0x805058,%eax
  80394d:	8b 08                	mov    (%eax),%ecx
  80394f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803952:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  803954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803957:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80395e:	8b 10                	mov    (%eax),%edx
  803960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803963:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803968:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	89 04 24             	mov    %eax,(%esp)
  803975:	e8 7a e6 ff ff       	call   801ff4 <fd2num>
  80397a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80397c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80397f:	89 04 24             	mov    %eax,(%esp)
  803982:	e8 6d e6 ff ff       	call   801ff4 <fd2num>
  803987:	89 47 04             	mov    %eax,0x4(%edi)
  80398a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80398f:	eb 36                	jmp    8039c7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  803991:	89 74 24 04          	mov    %esi,0x4(%esp)
  803995:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80399c:	e8 61 df ff ff       	call   801902 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8039a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039af:	e8 4e df ff ff       	call   801902 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8039b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039c2:	e8 3b df ff ff       	call   801902 <sys_page_unmap>
    err:
	return r;
}
  8039c7:	89 d8                	mov    %ebx,%eax
  8039c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8039cc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8039cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8039d2:	89 ec                	mov    %ebp,%esp
  8039d4:	5d                   	pop    %ebp
  8039d5:	c3                   	ret    
	...

008039d8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
  8039db:	56                   	push   %esi
  8039dc:	53                   	push   %ebx
  8039dd:	83 ec 10             	sub    $0x10,%esp
  8039e0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8039e3:	85 f6                	test   %esi,%esi
  8039e5:	75 24                	jne    803a0b <wait+0x33>
  8039e7:	c7 44 24 0c ec 46 80 	movl   $0x8046ec,0xc(%esp)
  8039ee:	00 
  8039ef:	c7 44 24 08 78 40 80 	movl   $0x804078,0x8(%esp)
  8039f6:	00 
  8039f7:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8039fe:	00 
  8039ff:	c7 04 24 f7 46 80 00 	movl   $0x8046f7,(%esp)
  803a06:	e8 5d d0 ff ff       	call   800a68 <_panic>
	e = &envs[ENVX(envid)];
  803a0b:	89 f3                	mov    %esi,%ebx
  803a0d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  803a13:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803a16:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a1c:	eb 05                	jmp    803a23 <wait+0x4b>
		sys_yield();
  803a1e:	e8 fa df ff ff       	call   801a1d <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a23:	8b 43 48             	mov    0x48(%ebx),%eax
  803a26:	39 f0                	cmp    %esi,%eax
  803a28:	75 07                	jne    803a31 <wait+0x59>
  803a2a:	8b 43 54             	mov    0x54(%ebx),%eax
  803a2d:	85 c0                	test   %eax,%eax
  803a2f:	75 ed                	jne    803a1e <wait+0x46>
		sys_yield();
}
  803a31:	83 c4 10             	add    $0x10,%esp
  803a34:	5b                   	pop    %ebx
  803a35:	5e                   	pop    %esi
  803a36:	5d                   	pop    %ebp
  803a37:	c3                   	ret    

00803a38 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a38:	55                   	push   %ebp
  803a39:	89 e5                	mov    %esp,%ebp
  803a3b:	53                   	push   %ebx
  803a3c:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  803a3f:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803a46:	75 5b                	jne    803aa3 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  803a48:	e8 04 e0 ff ff       	call   801a51 <sys_getenvid>
  803a4d:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  803a4f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803a56:	00 
  803a57:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803a5e:	ee 
  803a5f:	89 04 24             	mov    %eax,(%esp)
  803a62:	e8 57 df ff ff       	call   8019be <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  803a67:	85 c0                	test   %eax,%eax
  803a69:	74 28                	je     803a93 <set_pgfault_handler+0x5b>
  803a6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  803a6f:	c7 44 24 0c 29 47 80 	movl   $0x804729,0xc(%esp)
  803a76:	00 
  803a77:	c7 44 24 08 02 47 80 	movl   $0x804702,0x8(%esp)
  803a7e:	00 
  803a7f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803a86:	00 
  803a87:	c7 04 24 1b 47 80 00 	movl   $0x80471b,(%esp)
  803a8e:	e8 d5 cf ff ff       	call   800a68 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  803a93:	c7 44 24 04 b4 3a 80 	movl   $0x803ab4,0x4(%esp)
  803a9a:	00 
  803a9b:	89 1c 24             	mov    %ebx,(%esp)
  803a9e:	e8 45 dd ff ff       	call   8017e8 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa6:	a3 00 a0 80 00       	mov    %eax,0x80a000
	
}
  803aab:	83 c4 24             	add    $0x24,%esp
  803aae:	5b                   	pop    %ebx
  803aaf:	5d                   	pop    %ebp
  803ab0:	c3                   	ret    
  803ab1:	00 00                	add    %al,(%eax)
	...

00803ab4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803ab4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803ab5:	a1 00 a0 80 00       	mov    0x80a000,%eax
	call *%eax
  803aba:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803abc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  803abf:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  803ac2:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  803ac6:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  803aca:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  803acd:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  803ad0:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  803ad4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  803ad5:	83 c4 04             	add    $0x4,%esp
	popfl ;
  803ad8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  803ad9:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803ada:	c3                   	ret    
	...

00803adc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803adc:	55                   	push   %ebp
  803add:	89 e5                	mov    %esp,%ebp
  803adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803ae2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  803ae7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803aea:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  803af0:	8b 12                	mov    (%edx),%edx
  803af2:	39 ca                	cmp    %ecx,%edx
  803af4:	75 0c                	jne    803b02 <ipc_find_env+0x26>
			return envs[i].env_id;
  803af6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803af9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  803afe:	8b 00                	mov    (%eax),%eax
  803b00:	eb 0e                	jmp    803b10 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803b02:	83 c0 01             	add    $0x1,%eax
  803b05:	3d 00 04 00 00       	cmp    $0x400,%eax
  803b0a:	75 db                	jne    803ae7 <ipc_find_env+0xb>
  803b0c:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  803b10:	5d                   	pop    %ebp
  803b11:	c3                   	ret    

00803b12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b12:	55                   	push   %ebp
  803b13:	89 e5                	mov    %esp,%ebp
  803b15:	57                   	push   %edi
  803b16:	56                   	push   %esi
  803b17:	53                   	push   %ebx
  803b18:	83 ec 2c             	sub    $0x2c,%esp
  803b1b:	8b 75 08             	mov    0x8(%ebp),%esi
  803b1e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803b21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  803b24:	85 db                	test   %ebx,%ebx
  803b26:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803b2b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  803b2e:	8b 45 14             	mov    0x14(%ebp),%eax
  803b31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b35:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b39:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803b3d:	89 34 24             	mov    %esi,(%esp)
  803b40:	e8 6b dc ff ff       	call   8017b0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  803b45:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803b48:	74 e4                	je     803b2e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	74 28                	je     803b76 <ipc_send+0x64>
  803b4e:	89 44 24 10          	mov    %eax,0x10(%esp)
  803b52:	c7 44 24 0c 5a 47 80 	movl   $0x80475a,0xc(%esp)
  803b59:	00 
  803b5a:	c7 44 24 08 3d 47 80 	movl   $0x80473d,0x8(%esp)
  803b61:	00 
  803b62:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  803b69:	00 
  803b6a:	c7 04 24 50 47 80 00 	movl   $0x804750,(%esp)
  803b71:	e8 f2 ce ff ff       	call   800a68 <_panic>
	//if(!ret) sys_yield();
}
  803b76:	83 c4 2c             	add    $0x2c,%esp
  803b79:	5b                   	pop    %ebx
  803b7a:	5e                   	pop    %esi
  803b7b:	5f                   	pop    %edi
  803b7c:	5d                   	pop    %ebp
  803b7d:	c3                   	ret    

00803b7e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b7e:	55                   	push   %ebp
  803b7f:	89 e5                	mov    %esp,%ebp
  803b81:	83 ec 28             	sub    $0x28,%esp
  803b84:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803b87:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803b8a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803b8d:	8b 75 08             	mov    0x8(%ebp),%esi
  803b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b93:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  803b96:	85 c0                	test   %eax,%eax
  803b98:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803b9d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  803ba0:	89 04 24             	mov    %eax,(%esp)
  803ba3:	e8 ab db ff ff       	call   801753 <sys_ipc_recv>
  803ba8:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  803baa:	e8 a2 de ff ff       	call   801a51 <sys_getenvid>
  803baf:	25 ff 03 00 00       	and    $0x3ff,%eax
  803bb4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803bb7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803bbc:	a3 28 64 80 00       	mov    %eax,0x806428
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  803bc1:	85 f6                	test   %esi,%esi
  803bc3:	74 0e                	je     803bd3 <ipc_recv+0x55>
  803bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  803bca:	85 db                	test   %ebx,%ebx
  803bcc:	75 03                	jne    803bd1 <ipc_recv+0x53>
  803bce:	8b 50 74             	mov    0x74(%eax),%edx
  803bd1:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  803bd3:	85 ff                	test   %edi,%edi
  803bd5:	74 13                	je     803bea <ipc_recv+0x6c>
  803bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bdc:	85 db                	test   %ebx,%ebx
  803bde:	75 08                	jne    803be8 <ipc_recv+0x6a>
  803be0:	a1 28 64 80 00       	mov    0x806428,%eax
  803be5:	8b 40 78             	mov    0x78(%eax),%eax
  803be8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  803bea:	85 db                	test   %ebx,%ebx
  803bec:	75 08                	jne    803bf6 <ipc_recv+0x78>
  803bee:	a1 28 64 80 00       	mov    0x806428,%eax
  803bf3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  803bf6:	89 d8                	mov    %ebx,%eax
  803bf8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803bfb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803bfe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803c01:	89 ec                	mov    %ebp,%esp
  803c03:	5d                   	pop    %ebp
  803c04:	c3                   	ret    
  803c05:	00 00                	add    %al,(%eax)
	...

00803c08 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c08:	55                   	push   %ebp
  803c09:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0e:	89 c2                	mov    %eax,%edx
  803c10:	c1 ea 16             	shr    $0x16,%edx
  803c13:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  803c1a:	f6 c2 01             	test   $0x1,%dl
  803c1d:	74 20                	je     803c3f <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  803c1f:	c1 e8 0c             	shr    $0xc,%eax
  803c22:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803c29:	a8 01                	test   $0x1,%al
  803c2b:	74 12                	je     803c3f <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803c2d:	c1 e8 0c             	shr    $0xc,%eax
  803c30:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803c35:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  803c3a:	0f b7 c0             	movzwl %ax,%eax
  803c3d:	eb 05                	jmp    803c44 <pageref+0x3c>
  803c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c44:	5d                   	pop    %ebp
  803c45:	c3                   	ret    
	...

00803c50 <__udivdi3>:
  803c50:	55                   	push   %ebp
  803c51:	89 e5                	mov    %esp,%ebp
  803c53:	57                   	push   %edi
  803c54:	56                   	push   %esi
  803c55:	83 ec 10             	sub    $0x10,%esp
  803c58:	8b 45 14             	mov    0x14(%ebp),%eax
  803c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5e:	8b 75 10             	mov    0x10(%ebp),%esi
  803c61:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803c64:	85 c0                	test   %eax,%eax
  803c66:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803c69:	75 35                	jne    803ca0 <__udivdi3+0x50>
  803c6b:	39 fe                	cmp    %edi,%esi
  803c6d:	77 61                	ja     803cd0 <__udivdi3+0x80>
  803c6f:	85 f6                	test   %esi,%esi
  803c71:	75 0b                	jne    803c7e <__udivdi3+0x2e>
  803c73:	b8 01 00 00 00       	mov    $0x1,%eax
  803c78:	31 d2                	xor    %edx,%edx
  803c7a:	f7 f6                	div    %esi
  803c7c:	89 c6                	mov    %eax,%esi
  803c7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c81:	31 d2                	xor    %edx,%edx
  803c83:	89 f8                	mov    %edi,%eax
  803c85:	f7 f6                	div    %esi
  803c87:	89 c7                	mov    %eax,%edi
  803c89:	89 c8                	mov    %ecx,%eax
  803c8b:	f7 f6                	div    %esi
  803c8d:	89 c1                	mov    %eax,%ecx
  803c8f:	89 fa                	mov    %edi,%edx
  803c91:	89 c8                	mov    %ecx,%eax
  803c93:	83 c4 10             	add    $0x10,%esp
  803c96:	5e                   	pop    %esi
  803c97:	5f                   	pop    %edi
  803c98:	5d                   	pop    %ebp
  803c99:	c3                   	ret    
  803c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803ca0:	39 f8                	cmp    %edi,%eax
  803ca2:	77 1c                	ja     803cc0 <__udivdi3+0x70>
  803ca4:	0f bd d0             	bsr    %eax,%edx
  803ca7:	83 f2 1f             	xor    $0x1f,%edx
  803caa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803cad:	75 39                	jne    803ce8 <__udivdi3+0x98>
  803caf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803cb2:	0f 86 a0 00 00 00    	jbe    803d58 <__udivdi3+0x108>
  803cb8:	39 f8                	cmp    %edi,%eax
  803cba:	0f 82 98 00 00 00    	jb     803d58 <__udivdi3+0x108>
  803cc0:	31 ff                	xor    %edi,%edi
  803cc2:	31 c9                	xor    %ecx,%ecx
  803cc4:	89 c8                	mov    %ecx,%eax
  803cc6:	89 fa                	mov    %edi,%edx
  803cc8:	83 c4 10             	add    $0x10,%esp
  803ccb:	5e                   	pop    %esi
  803ccc:	5f                   	pop    %edi
  803ccd:	5d                   	pop    %ebp
  803cce:	c3                   	ret    
  803ccf:	90                   	nop
  803cd0:	89 d1                	mov    %edx,%ecx
  803cd2:	89 fa                	mov    %edi,%edx
  803cd4:	89 c8                	mov    %ecx,%eax
  803cd6:	31 ff                	xor    %edi,%edi
  803cd8:	f7 f6                	div    %esi
  803cda:	89 c1                	mov    %eax,%ecx
  803cdc:	89 fa                	mov    %edi,%edx
  803cde:	89 c8                	mov    %ecx,%eax
  803ce0:	83 c4 10             	add    $0x10,%esp
  803ce3:	5e                   	pop    %esi
  803ce4:	5f                   	pop    %edi
  803ce5:	5d                   	pop    %ebp
  803ce6:	c3                   	ret    
  803ce7:	90                   	nop
  803ce8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803cec:	89 f2                	mov    %esi,%edx
  803cee:	d3 e0                	shl    %cl,%eax
  803cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803cf3:	b8 20 00 00 00       	mov    $0x20,%eax
  803cf8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803cfb:	89 c1                	mov    %eax,%ecx
  803cfd:	d3 ea                	shr    %cl,%edx
  803cff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803d03:	0b 55 ec             	or     -0x14(%ebp),%edx
  803d06:	d3 e6                	shl    %cl,%esi
  803d08:	89 c1                	mov    %eax,%ecx
  803d0a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803d0d:	89 fe                	mov    %edi,%esi
  803d0f:	d3 ee                	shr    %cl,%esi
  803d11:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803d15:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d1b:	d3 e7                	shl    %cl,%edi
  803d1d:	89 c1                	mov    %eax,%ecx
  803d1f:	d3 ea                	shr    %cl,%edx
  803d21:	09 d7                	or     %edx,%edi
  803d23:	89 f2                	mov    %esi,%edx
  803d25:	89 f8                	mov    %edi,%eax
  803d27:	f7 75 ec             	divl   -0x14(%ebp)
  803d2a:	89 d6                	mov    %edx,%esi
  803d2c:	89 c7                	mov    %eax,%edi
  803d2e:	f7 65 e8             	mull   -0x18(%ebp)
  803d31:	39 d6                	cmp    %edx,%esi
  803d33:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803d36:	72 30                	jb     803d68 <__udivdi3+0x118>
  803d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d3b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803d3f:	d3 e2                	shl    %cl,%edx
  803d41:	39 c2                	cmp    %eax,%edx
  803d43:	73 05                	jae    803d4a <__udivdi3+0xfa>
  803d45:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803d48:	74 1e                	je     803d68 <__udivdi3+0x118>
  803d4a:	89 f9                	mov    %edi,%ecx
  803d4c:	31 ff                	xor    %edi,%edi
  803d4e:	e9 71 ff ff ff       	jmp    803cc4 <__udivdi3+0x74>
  803d53:	90                   	nop
  803d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d58:	31 ff                	xor    %edi,%edi
  803d5a:	b9 01 00 00 00       	mov    $0x1,%ecx
  803d5f:	e9 60 ff ff ff       	jmp    803cc4 <__udivdi3+0x74>
  803d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d68:	8d 4f ff             	lea    -0x1(%edi),%ecx
  803d6b:	31 ff                	xor    %edi,%edi
  803d6d:	89 c8                	mov    %ecx,%eax
  803d6f:	89 fa                	mov    %edi,%edx
  803d71:	83 c4 10             	add    $0x10,%esp
  803d74:	5e                   	pop    %esi
  803d75:	5f                   	pop    %edi
  803d76:	5d                   	pop    %ebp
  803d77:	c3                   	ret    
	...

00803d80 <__umoddi3>:
  803d80:	55                   	push   %ebp
  803d81:	89 e5                	mov    %esp,%ebp
  803d83:	57                   	push   %edi
  803d84:	56                   	push   %esi
  803d85:	83 ec 20             	sub    $0x20,%esp
  803d88:	8b 55 14             	mov    0x14(%ebp),%edx
  803d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803d8e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803d91:	8b 75 0c             	mov    0xc(%ebp),%esi
  803d94:	85 d2                	test   %edx,%edx
  803d96:	89 c8                	mov    %ecx,%eax
  803d98:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803d9b:	75 13                	jne    803db0 <__umoddi3+0x30>
  803d9d:	39 f7                	cmp    %esi,%edi
  803d9f:	76 3f                	jbe    803de0 <__umoddi3+0x60>
  803da1:	89 f2                	mov    %esi,%edx
  803da3:	f7 f7                	div    %edi
  803da5:	89 d0                	mov    %edx,%eax
  803da7:	31 d2                	xor    %edx,%edx
  803da9:	83 c4 20             	add    $0x20,%esp
  803dac:	5e                   	pop    %esi
  803dad:	5f                   	pop    %edi
  803dae:	5d                   	pop    %ebp
  803daf:	c3                   	ret    
  803db0:	39 f2                	cmp    %esi,%edx
  803db2:	77 4c                	ja     803e00 <__umoddi3+0x80>
  803db4:	0f bd ca             	bsr    %edx,%ecx
  803db7:	83 f1 1f             	xor    $0x1f,%ecx
  803dba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803dbd:	75 51                	jne    803e10 <__umoddi3+0x90>
  803dbf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803dc2:	0f 87 e0 00 00 00    	ja     803ea8 <__umoddi3+0x128>
  803dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dcb:	29 f8                	sub    %edi,%eax
  803dcd:	19 d6                	sbb    %edx,%esi
  803dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd5:	89 f2                	mov    %esi,%edx
  803dd7:	83 c4 20             	add    $0x20,%esp
  803dda:	5e                   	pop    %esi
  803ddb:	5f                   	pop    %edi
  803ddc:	5d                   	pop    %ebp
  803ddd:	c3                   	ret    
  803dde:	66 90                	xchg   %ax,%ax
  803de0:	85 ff                	test   %edi,%edi
  803de2:	75 0b                	jne    803def <__umoddi3+0x6f>
  803de4:	b8 01 00 00 00       	mov    $0x1,%eax
  803de9:	31 d2                	xor    %edx,%edx
  803deb:	f7 f7                	div    %edi
  803ded:	89 c7                	mov    %eax,%edi
  803def:	89 f0                	mov    %esi,%eax
  803df1:	31 d2                	xor    %edx,%edx
  803df3:	f7 f7                	div    %edi
  803df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df8:	f7 f7                	div    %edi
  803dfa:	eb a9                	jmp    803da5 <__umoddi3+0x25>
  803dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e00:	89 c8                	mov    %ecx,%eax
  803e02:	89 f2                	mov    %esi,%edx
  803e04:	83 c4 20             	add    $0x20,%esp
  803e07:	5e                   	pop    %esi
  803e08:	5f                   	pop    %edi
  803e09:	5d                   	pop    %ebp
  803e0a:	c3                   	ret    
  803e0b:	90                   	nop
  803e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e10:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e14:	d3 e2                	shl    %cl,%edx
  803e16:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803e19:	ba 20 00 00 00       	mov    $0x20,%edx
  803e1e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803e21:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803e24:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e28:	89 fa                	mov    %edi,%edx
  803e2a:	d3 ea                	shr    %cl,%edx
  803e2c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e30:	0b 55 f4             	or     -0xc(%ebp),%edx
  803e33:	d3 e7                	shl    %cl,%edi
  803e35:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803e3c:	89 f2                	mov    %esi,%edx
  803e3e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803e41:	89 c7                	mov    %eax,%edi
  803e43:	d3 ea                	shr    %cl,%edx
  803e45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803e4c:	89 c2                	mov    %eax,%edx
  803e4e:	d3 e6                	shl    %cl,%esi
  803e50:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e54:	d3 ea                	shr    %cl,%edx
  803e56:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e5a:	09 d6                	or     %edx,%esi
  803e5c:	89 f0                	mov    %esi,%eax
  803e5e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803e61:	d3 e7                	shl    %cl,%edi
  803e63:	89 f2                	mov    %esi,%edx
  803e65:	f7 75 f4             	divl   -0xc(%ebp)
  803e68:	89 d6                	mov    %edx,%esi
  803e6a:	f7 65 e8             	mull   -0x18(%ebp)
  803e6d:	39 d6                	cmp    %edx,%esi
  803e6f:	72 2b                	jb     803e9c <__umoddi3+0x11c>
  803e71:	39 c7                	cmp    %eax,%edi
  803e73:	72 23                	jb     803e98 <__umoddi3+0x118>
  803e75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e79:	29 c7                	sub    %eax,%edi
  803e7b:	19 d6                	sbb    %edx,%esi
  803e7d:	89 f0                	mov    %esi,%eax
  803e7f:	89 f2                	mov    %esi,%edx
  803e81:	d3 ef                	shr    %cl,%edi
  803e83:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e87:	d3 e0                	shl    %cl,%eax
  803e89:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e8d:	09 f8                	or     %edi,%eax
  803e8f:	d3 ea                	shr    %cl,%edx
  803e91:	83 c4 20             	add    $0x20,%esp
  803e94:	5e                   	pop    %esi
  803e95:	5f                   	pop    %edi
  803e96:	5d                   	pop    %ebp
  803e97:	c3                   	ret    
  803e98:	39 d6                	cmp    %edx,%esi
  803e9a:	75 d9                	jne    803e75 <__umoddi3+0xf5>
  803e9c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e9f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803ea2:	eb d1                	jmp    803e75 <__umoddi3+0xf5>
  803ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ea8:	39 f2                	cmp    %esi,%edx
  803eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803eb0:	0f 82 12 ff ff ff    	jb     803dc8 <__umoddi3+0x48>
  803eb6:	e9 17 ff ff ff       	jmp    803dd2 <__umoddi3+0x52>
