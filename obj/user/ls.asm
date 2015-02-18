
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 ff 02 00 00       	call   800330 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
	printf("\n");
}

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800046:	c7 04 24 40 2d 80 00 	movl   $0x802d40,(%esp)
  80004d:	e8 2d 1e 00 00       	call   801e7f <printf>
	exit();
  800052:	e8 29 03 00 00       	call   800380 <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  800068:	83 3d d0 51 80 00 00 	cmpl   $0x0,0x8051d0
  80006f:	74 23                	je     800094 <ls1+0x3b>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800071:	89 f0                	mov    %esi,%eax
  800073:	3c 01                	cmp    $0x1,%al
  800075:	19 c0                	sbb    %eax,%eax
  800077:	83 e0 c9             	and    $0xffffffc9,%eax
  80007a:	83 c0 64             	add    $0x64,%eax
  80007d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800081:	8b 45 10             	mov    0x10(%ebp),%eax
  800084:	89 44 24 04          	mov    %eax,0x4(%esp)
  800088:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  80008f:	e8 eb 1d 00 00       	call   801e7f <printf>
	if(prefix) {
  800094:	85 db                	test   %ebx,%ebx
  800096:	74 32                	je     8000ca <ls1+0x71>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800098:	80 3b 00             	cmpb   $0x0,(%ebx)
  80009b:	74 14                	je     8000b1 <ls1+0x58>
  80009d:	89 1c 24             	mov    %ebx,(%esp)
  8000a0:	e8 db 09 00 00       	call   800a80 <strlen>
  8000a5:	ba 65 2d 80 00       	mov    $0x802d65,%edx
  8000aa:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000af:	75 05                	jne    8000b6 <ls1+0x5d>
  8000b1:	ba 5b 2d 80 00       	mov    $0x802d5b,%edx
			sep = "/";
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000be:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  8000c5:	e8 b5 1d 00 00       	call   801e7f <printf>
	}
	printf("%s", name);
  8000ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d1:	c7 04 24 fa 31 80 00 	movl   $0x8031fa,(%esp)
  8000d8:	e8 a2 1d 00 00       	call   801e7f <printf>
	if(flag['F'] && isdir)
  8000dd:	83 3d 38 51 80 00 00 	cmpl   $0x0,0x805138
  8000e4:	74 12                	je     8000f8 <ls1+0x9f>
  8000e6:	89 f0                	mov    %esi,%eax
  8000e8:	84 c0                	test   %al,%al
  8000ea:	74 0c                	je     8000f8 <ls1+0x9f>
		printf("/");
  8000ec:	c7 04 24 65 2d 80 00 	movl   $0x802d65,(%esp)
  8000f3:	e8 87 1d 00 00       	call   801e7f <printf>
	printf("\n");
  8000f8:	c7 04 24 5a 2d 80 00 	movl   $0x802d5a,(%esp)
  8000ff:	e8 7b 1d 00 00       	call   801e7f <printf>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	57                   	push   %edi
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800117:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  80011a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800121:	00 
  800122:	8b 45 08             	mov    0x8(%ebp),%eax
  800125:	89 04 24             	mov    %eax,(%esp)
  800128:	e8 06 1c 00 00       	call   801d33 <open>
  80012d:	89 c6                	mov    %eax,%esi
  80012f:	85 c0                	test   %eax,%eax
  800131:	79 59                	jns    80018c <lsdir+0x81>
		panic("open %s: %e", path, fd);
  800133:	89 44 24 10          	mov    %eax,0x10(%esp)
  800137:	8b 45 08             	mov    0x8(%ebp),%eax
  80013a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013e:	c7 44 24 08 6c 2d 80 	movl   $0x802d6c,0x8(%esp)
  800145:	00 
  800146:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80014d:	00 
  80014e:	c7 04 24 78 2d 80 00 	movl   $0x802d78,(%esp)
  800155:	e8 3a 02 00 00       	call   800394 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  80015a:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800161:	74 2f                	je     800192 <lsdir+0x87>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800163:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800167:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80016d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800171:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800178:	0f 94 c0             	sete   %al
  80017b:	0f b6 c0             	movzbl %al,%eax
  80017e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800182:	89 3c 24             	mov    %edi,(%esp)
  800185:	e8 cf fe ff ff       	call   800059 <ls1>
  80018a:	eb 06                	jmp    800192 <lsdir+0x87>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80018c:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  800192:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800199:	00 
  80019a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019e:	89 34 24             	mov    %esi,(%esp)
  8001a1:	e8 3f 16 00 00       	call   8017e5 <readn>
  8001a6:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001ab:	74 ad                	je     80015a <lsdir+0x4f>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	7e 23                	jle    8001d4 <lsdir+0xc9>
		panic("short read in directory %s", path);
  8001b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b8:	c7 44 24 08 82 2d 80 	movl   $0x802d82,0x8(%esp)
  8001bf:	00 
  8001c0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001c7:	00 
  8001c8:	c7 04 24 78 2d 80 00 	movl   $0x802d78,(%esp)
  8001cf:	e8 c0 01 00 00       	call   800394 <_panic>
	if (n < 0)
  8001d4:	85 c0                	test   %eax,%eax
  8001d6:	79 27                	jns    8001ff <lsdir+0xf4>
		panic("error reading directory %s: %e", path, n);
  8001d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e3:	c7 44 24 08 ac 2d 80 	movl   $0x802dac,0x8(%esp)
  8001ea:	00 
  8001eb:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001f2:	00 
  8001f3:	c7 04 24 78 2d 80 00 	movl   $0x802d78,(%esp)
  8001fa:	e8 95 01 00 00       	call   800394 <_panic>
}
  8001ff:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5f                   	pop    %edi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    

0080020a <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	53                   	push   %ebx
  80020e:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  800214:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  800217:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80021d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800221:	89 1c 24             	mov    %ebx,(%esp)
  800224:	e8 c6 16 00 00       	call   8018ef <stat>
  800229:	85 c0                	test   %eax,%eax
  80022b:	79 24                	jns    800251 <ls+0x47>
		panic("stat %s: %e", path, r);
  80022d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800231:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800235:	c7 44 24 08 9d 2d 80 	movl   $0x802d9d,0x8(%esp)
  80023c:	00 
  80023d:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800244:	00 
  800245:	c7 04 24 78 2d 80 00 	movl   $0x802d78,(%esp)
  80024c:	e8 43 01 00 00       	call   800394 <_panic>
	if (st.st_isdir && !flag['d'])
  800251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800254:	85 c0                	test   %eax,%eax
  800256:	74 1a                	je     800272 <ls+0x68>
  800258:	83 3d b0 51 80 00 00 	cmpl   $0x0,0x8051b0
  80025f:	75 11                	jne    800272 <ls+0x68>
		lsdir(path, prefix);
  800261:	8b 45 0c             	mov    0xc(%ebp),%eax
  800264:	89 44 24 04          	mov    %eax,0x4(%esp)
  800268:	89 1c 24             	mov    %ebx,(%esp)
  80026b:	e8 9b fe ff ff       	call   80010b <lsdir>
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
		panic("stat %s: %e", path, r);
	if (st.st_isdir && !flag['d'])
  800270:	eb 23                	jmp    800295 <ls+0x8b>
		lsdir(path, prefix);
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800272:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800276:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800279:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027d:	85 c0                	test   %eax,%eax
  80027f:	0f 95 c0             	setne  %al
  800282:	0f b6 c0             	movzbl %al,%eax
  800285:	89 44 24 04          	mov    %eax,0x4(%esp)
  800289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800290:	e8 c4 fd ff ff       	call   800059 <ls1>
}
  800295:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  80029b:	5b                   	pop    %ebx
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <umain>:
	exit();
}

void
umain(int argc, char **argv)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	57                   	push   %edi
  8002a2:	56                   	push   %esi
  8002a3:	53                   	push   %ebx
  8002a4:	83 ec 2c             	sub    $0x2c,%esp
  8002a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002aa:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8002ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b5:	8d 45 08             	lea    0x8(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	e8 64 10 00 00       	call   801324 <argstart>
	while ((i = argnext(&args)) >= 0)
  8002c0:	8d 7d d8             	lea    -0x28(%ebp),%edi
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002c3:	bb 20 50 80 00       	mov    $0x805020,%ebx
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002c8:	eb 1a                	jmp    8002e4 <umain+0x46>
		switch (i) {
  8002ca:	83 f8 64             	cmp    $0x64,%eax
  8002cd:	74 0a                	je     8002d9 <umain+0x3b>
  8002cf:	83 f8 6c             	cmp    $0x6c,%eax
  8002d2:	74 05                	je     8002d9 <umain+0x3b>
  8002d4:	83 f8 46             	cmp    $0x46,%eax
  8002d7:	75 06                	jne    8002df <umain+0x41>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002d9:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
			break;
  8002dd:	eb 05                	jmp    8002e4 <umain+0x46>
		default:
			usage();
  8002df:	e8 5c fd ff ff       	call   800040 <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002e4:	89 3c 24             	mov    %edi,(%esp)
  8002e7:	e8 f8 10 00 00       	call   8013e4 <argnext>
  8002ec:	85 c0                	test   %eax,%eax
  8002ee:	79 da                	jns    8002ca <umain+0x2c>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  8002f5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002f9:	75 28                	jne    800323 <umain+0x85>
		ls("/", "");
  8002fb:	c7 44 24 04 5b 2d 80 	movl   $0x802d5b,0x4(%esp)
  800302:	00 
  800303:	c7 04 24 65 2d 80 00 	movl   $0x802d65,(%esp)
  80030a:	e8 fb fe ff ff       	call   80020a <ls>
  80030f:	eb 17                	jmp    800328 <umain+0x8a>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  800311:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800314:	89 44 24 04          	mov    %eax,0x4(%esp)
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	e8 ea fe ff ff       	call   80020a <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800320:	83 c3 01             	add    $0x1,%ebx
  800323:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800326:	7c e9                	jl     800311 <umain+0x73>
			ls(argv[i], argv[i]);
	}
}
  800328:	83 c4 2c             	add    $0x2c,%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    

00800330 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	83 ec 18             	sub    $0x18,%esp
  800336:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800339:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80033c:	8b 75 08             	mov    0x8(%ebp),%esi
  80033f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800342:	e8 4a 0f 00 00       	call   801291 <sys_getenvid>
  800347:	25 ff 03 00 00       	and    $0x3ff,%eax
  80034c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80034f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800354:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800359:	85 f6                	test   %esi,%esi
  80035b:	7e 07                	jle    800364 <libmain+0x34>
		binaryname = argv[0];
  80035d:	8b 03                	mov    (%ebx),%eax
  80035f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800368:	89 34 24             	mov    %esi,(%esp)
  80036b:	e8 2e ff ff ff       	call   80029e <umain>

	// exit gracefully
	exit();
  800370:	e8 0b 00 00 00       	call   800380 <exit>
}
  800375:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800378:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80037b:	89 ec                	mov    %ebp,%esp
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    
	...

00800380 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800386:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80038d:	e8 33 0f 00 00       	call   8012c5 <sys_env_destroy>
}
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	56                   	push   %esi
  800398:	53                   	push   %ebx
  800399:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80039c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039f:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  8003a5:	e8 e7 0e 00 00       	call   801291 <sys_getenvid>
  8003aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ad:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c0:	c7 04 24 d8 2d 80 00 	movl   $0x802dd8,(%esp)
  8003c7:	e8 81 00 00 00       	call   80044d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d3:	89 04 24             	mov    %eax,(%esp)
  8003d6:	e8 11 00 00 00       	call   8003ec <vcprintf>
	cprintf("\n");
  8003db:	c7 04 24 5a 2d 80 00 	movl   $0x802d5a,(%esp)
  8003e2:	e8 66 00 00 00       	call   80044d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e7:	cc                   	int3   
  8003e8:	eb fd                	jmp    8003e7 <_panic+0x53>
	...

008003ec <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003fc:	00 00 00 
	b.cnt = 0;
  8003ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800406:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	89 44 24 08          	mov    %eax,0x8(%esp)
  800417:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800421:	c7 04 24 67 04 80 00 	movl   $0x800467,(%esp)
  800428:	e8 be 01 00 00       	call   8005eb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80042d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800433:	89 44 24 04          	mov    %eax,0x4(%esp)
  800437:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80043d:	89 04 24             	mov    %eax,(%esp)
  800440:	e8 2b 0a 00 00       	call   800e70 <sys_cputs>

	return b.cnt;
}
  800445:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80044b:	c9                   	leave  
  80044c:	c3                   	ret    

0080044d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800453:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	89 04 24             	mov    %eax,(%esp)
  800460:	e8 87 ff ff ff       	call   8003ec <vcprintf>
	va_end(ap);

	return cnt;
}
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	53                   	push   %ebx
  80046b:	83 ec 14             	sub    $0x14,%esp
  80046e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800471:	8b 03                	mov    (%ebx),%eax
  800473:	8b 55 08             	mov    0x8(%ebp),%edx
  800476:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80047a:	83 c0 01             	add    $0x1,%eax
  80047d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80047f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800484:	75 19                	jne    80049f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800486:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80048d:	00 
  80048e:	8d 43 08             	lea    0x8(%ebx),%eax
  800491:	89 04 24             	mov    %eax,(%esp)
  800494:	e8 d7 09 00 00       	call   800e70 <sys_cputs>
		b->idx = 0;
  800499:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80049f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004a3:	83 c4 14             	add    $0x14,%esp
  8004a6:	5b                   	pop    %ebx
  8004a7:	5d                   	pop    %ebp
  8004a8:	c3                   	ret    
  8004a9:	00 00                	add    %al,(%eax)
	...

008004ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	57                   	push   %edi
  8004b0:	56                   	push   %esi
  8004b1:	53                   	push   %ebx
  8004b2:	83 ec 4c             	sub    $0x4c,%esp
  8004b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004b8:	89 d6                	mov    %edx,%esi
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004cc:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d7:	39 d1                	cmp    %edx,%ecx
  8004d9:	72 07                	jb     8004e2 <printnum+0x36>
  8004db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004de:	39 d0                	cmp    %edx,%eax
  8004e0:	77 69                	ja     80054b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004e6:	83 eb 01             	sub    $0x1,%ebx
  8004e9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004f5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004f9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004fc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004ff:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800502:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800506:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80050d:	00 
  80050e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800511:	89 04 24             	mov    %eax,(%esp)
  800514:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800517:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051b:	e8 a0 25 00 00       	call   802ac0 <__udivdi3>
  800520:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800523:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800526:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80052a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	89 54 24 04          	mov    %edx,0x4(%esp)
  800535:	89 f2                	mov    %esi,%edx
  800537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053a:	e8 6d ff ff ff       	call   8004ac <printnum>
  80053f:	eb 11                	jmp    800552 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800541:	89 74 24 04          	mov    %esi,0x4(%esp)
  800545:	89 3c 24             	mov    %edi,(%esp)
  800548:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80054b:	83 eb 01             	sub    $0x1,%ebx
  80054e:	85 db                	test   %ebx,%ebx
  800550:	7f ef                	jg     800541 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800552:	89 74 24 04          	mov    %esi,0x4(%esp)
  800556:	8b 74 24 04          	mov    0x4(%esp),%esi
  80055a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800561:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800568:	00 
  800569:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056c:	89 14 24             	mov    %edx,(%esp)
  80056f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800572:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800576:	e8 75 26 00 00       	call   802bf0 <__umoddi3>
  80057b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057f:	0f be 80 fb 2d 80 00 	movsbl 0x802dfb(%eax),%eax
  800586:	89 04 24             	mov    %eax,(%esp)
  800589:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80058c:	83 c4 4c             	add    $0x4c,%esp
  80058f:	5b                   	pop    %ebx
  800590:	5e                   	pop    %esi
  800591:	5f                   	pop    %edi
  800592:	5d                   	pop    %ebp
  800593:	c3                   	ret    

00800594 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800597:	83 fa 01             	cmp    $0x1,%edx
  80059a:	7e 0e                	jle    8005aa <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80059c:	8b 10                	mov    (%eax),%edx
  80059e:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005a1:	89 08                	mov    %ecx,(%eax)
  8005a3:	8b 02                	mov    (%edx),%eax
  8005a5:	8b 52 04             	mov    0x4(%edx),%edx
  8005a8:	eb 22                	jmp    8005cc <getuint+0x38>
	else if (lflag)
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	74 10                	je     8005be <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005b3:	89 08                	mov    %ecx,(%eax)
  8005b5:	8b 02                	mov    (%edx),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	eb 0e                	jmp    8005cc <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005be:	8b 10                	mov    (%eax),%edx
  8005c0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005c3:	89 08                	mov    %ecx,(%eax)
  8005c5:	8b 02                	mov    (%edx),%eax
  8005c7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005cc:	5d                   	pop    %ebp
  8005cd:	c3                   	ret    

008005ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005d4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d8:	8b 10                	mov    (%eax),%edx
  8005da:	3b 50 04             	cmp    0x4(%eax),%edx
  8005dd:	73 0a                	jae    8005e9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005e2:	88 0a                	mov    %cl,(%edx)
  8005e4:	83 c2 01             	add    $0x1,%edx
  8005e7:	89 10                	mov    %edx,(%eax)
}
  8005e9:	5d                   	pop    %ebp
  8005ea:	c3                   	ret    

008005eb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	57                   	push   %edi
  8005ef:	56                   	push   %esi
  8005f0:	53                   	push   %ebx
  8005f1:	83 ec 4c             	sub    $0x4c,%esp
  8005f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005fd:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800604:	eb 11                	jmp    800617 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800606:	85 c0                	test   %eax,%eax
  800608:	0f 84 b6 03 00 00    	je     8009c4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80060e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800612:	89 04 24             	mov    %eax,(%esp)
  800615:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800617:	0f b6 03             	movzbl (%ebx),%eax
  80061a:	83 c3 01             	add    $0x1,%ebx
  80061d:	83 f8 25             	cmp    $0x25,%eax
  800620:	75 e4                	jne    800606 <vprintfmt+0x1b>
  800622:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800626:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80062d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800634:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80063b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800640:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800643:	eb 06                	jmp    80064b <vprintfmt+0x60>
  800645:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800649:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	0f b6 0b             	movzbl (%ebx),%ecx
  80064e:	0f b6 c1             	movzbl %cl,%eax
  800651:	8d 53 01             	lea    0x1(%ebx),%edx
  800654:	83 e9 23             	sub    $0x23,%ecx
  800657:	80 f9 55             	cmp    $0x55,%cl
  80065a:	0f 87 47 03 00 00    	ja     8009a7 <vprintfmt+0x3bc>
  800660:	0f b6 c9             	movzbl %cl,%ecx
  800663:	ff 24 8d 40 2f 80 00 	jmp    *0x802f40(,%ecx,4)
  80066a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80066e:	eb d9                	jmp    800649 <vprintfmt+0x5e>
  800670:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800677:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80067c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80067f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800683:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800686:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800689:	83 fb 09             	cmp    $0x9,%ebx
  80068c:	77 30                	ja     8006be <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80068e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800691:	eb e9                	jmp    80067c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 48 04             	lea    0x4(%eax),%ecx
  800699:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8006a1:	eb 1e                	jmp    8006c1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8006a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ac:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b3:	eb 94                	jmp    800649 <vprintfmt+0x5e>
  8006b5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8006bc:	eb 8b                	jmp    800649 <vprintfmt+0x5e>
  8006be:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8006c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c5:	79 82                	jns    800649 <vprintfmt+0x5e>
  8006c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8006d3:	e9 71 ff ff ff       	jmp    800649 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006d8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006dc:	e9 68 ff ff ff       	jmp    800649 <vprintfmt+0x5e>
  8006e1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	89 04 24             	mov    %eax,(%esp)
  8006f6:	ff d7                	call   *%edi
  8006f8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8006fb:	e9 17 ff ff ff       	jmp    800617 <vprintfmt+0x2c>
  800700:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 50 04             	lea    0x4(%eax),%edx
  800709:	89 55 14             	mov    %edx,0x14(%ebp)
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	89 c2                	mov    %eax,%edx
  800710:	c1 fa 1f             	sar    $0x1f,%edx
  800713:	31 d0                	xor    %edx,%eax
  800715:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800717:	83 f8 11             	cmp    $0x11,%eax
  80071a:	7f 0b                	jg     800727 <vprintfmt+0x13c>
  80071c:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  800723:	85 d2                	test   %edx,%edx
  800725:	75 20                	jne    800747 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800727:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072b:	c7 44 24 08 0c 2e 80 	movl   $0x802e0c,0x8(%esp)
  800732:	00 
  800733:	89 74 24 04          	mov    %esi,0x4(%esp)
  800737:	89 3c 24             	mov    %edi,(%esp)
  80073a:	e8 0d 03 00 00       	call   800a4c <printfmt>
  80073f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800742:	e9 d0 fe ff ff       	jmp    800617 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800747:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80074b:	c7 44 24 08 fa 31 80 	movl   $0x8031fa,0x8(%esp)
  800752:	00 
  800753:	89 74 24 04          	mov    %esi,0x4(%esp)
  800757:	89 3c 24             	mov    %edi,(%esp)
  80075a:	e8 ed 02 00 00       	call   800a4c <printfmt>
  80075f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800762:	e9 b0 fe ff ff       	jmp    800617 <vprintfmt+0x2c>
  800767:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80076a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80076d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800770:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	89 55 14             	mov    %edx,0x14(%ebp)
  80077c:	8b 18                	mov    (%eax),%ebx
  80077e:	85 db                	test   %ebx,%ebx
  800780:	b8 15 2e 80 00       	mov    $0x802e15,%eax
  800785:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800788:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078c:	7e 76                	jle    800804 <vprintfmt+0x219>
  80078e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800792:	74 7a                	je     80080e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800794:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800798:	89 1c 24             	mov    %ebx,(%esp)
  80079b:	e8 f8 02 00 00       	call   800a98 <strnlen>
  8007a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8007a5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8007a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007ac:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8007af:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b1:	eb 0f                	jmp    8007c2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8007b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ba:	89 04 24             	mov    %eax,(%esp)
  8007bd:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bf:	83 eb 01             	sub    $0x1,%ebx
  8007c2:	85 db                	test   %ebx,%ebx
  8007c4:	7f ed                	jg     8007b3 <vprintfmt+0x1c8>
  8007c6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007c9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007cc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8007cf:	89 f7                	mov    %esi,%edi
  8007d1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8007d4:	eb 40                	jmp    800816 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007da:	74 18                	je     8007f4 <vprintfmt+0x209>
  8007dc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007df:	83 fa 5e             	cmp    $0x5e,%edx
  8007e2:	76 10                	jbe    8007f4 <vprintfmt+0x209>
					putch('?', putdat);
  8007e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007ef:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007f2:	eb 0a                	jmp    8007fe <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8007f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f8:	89 04 24             	mov    %eax,(%esp)
  8007fb:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007fe:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800802:	eb 12                	jmp    800816 <vprintfmt+0x22b>
  800804:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800807:	89 f7                	mov    %esi,%edi
  800809:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80080c:	eb 08                	jmp    800816 <vprintfmt+0x22b>
  80080e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800811:	89 f7                	mov    %esi,%edi
  800813:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800816:	0f be 03             	movsbl (%ebx),%eax
  800819:	83 c3 01             	add    $0x1,%ebx
  80081c:	85 c0                	test   %eax,%eax
  80081e:	74 25                	je     800845 <vprintfmt+0x25a>
  800820:	85 f6                	test   %esi,%esi
  800822:	78 b2                	js     8007d6 <vprintfmt+0x1eb>
  800824:	83 ee 01             	sub    $0x1,%esi
  800827:	79 ad                	jns    8007d6 <vprintfmt+0x1eb>
  800829:	89 fe                	mov    %edi,%esi
  80082b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80082e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800831:	eb 1a                	jmp    80084d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800833:	89 74 24 04          	mov    %esi,0x4(%esp)
  800837:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80083e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800840:	83 eb 01             	sub    $0x1,%ebx
  800843:	eb 08                	jmp    80084d <vprintfmt+0x262>
  800845:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800848:	89 fe                	mov    %edi,%esi
  80084a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80084d:	85 db                	test   %ebx,%ebx
  80084f:	7f e2                	jg     800833 <vprintfmt+0x248>
  800851:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800854:	e9 be fd ff ff       	jmp    800617 <vprintfmt+0x2c>
  800859:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80085c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80085f:	83 f9 01             	cmp    $0x1,%ecx
  800862:	7e 16                	jle    80087a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 50 08             	lea    0x8(%eax),%edx
  80086a:	89 55 14             	mov    %edx,0x14(%ebp)
  80086d:	8b 10                	mov    (%eax),%edx
  80086f:	8b 48 04             	mov    0x4(%eax),%ecx
  800872:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800875:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800878:	eb 32                	jmp    8008ac <vprintfmt+0x2c1>
	else if (lflag)
  80087a:	85 c9                	test   %ecx,%ecx
  80087c:	74 18                	je     800896 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	89 55 14             	mov    %edx,0x14(%ebp)
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088c:	89 c1                	mov    %eax,%ecx
  80088e:	c1 f9 1f             	sar    $0x1f,%ecx
  800891:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800894:	eb 16                	jmp    8008ac <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	8d 50 04             	lea    0x4(%eax),%edx
  80089c:	89 55 14             	mov    %edx,0x14(%ebp)
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a4:	89 c2                	mov    %eax,%edx
  8008a6:	c1 fa 1f             	sar    $0x1f,%edx
  8008a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ac:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008b2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8008b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008bb:	0f 89 a7 00 00 00    	jns    800968 <vprintfmt+0x37d>
				putch('-', putdat);
  8008c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008cc:	ff d7                	call   *%edi
				num = -(long long) num;
  8008ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008d1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008d4:	f7 d9                	neg    %ecx
  8008d6:	83 d3 00             	adc    $0x0,%ebx
  8008d9:	f7 db                	neg    %ebx
  8008db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e0:	e9 83 00 00 00       	jmp    800968 <vprintfmt+0x37d>
  8008e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008eb:	89 ca                	mov    %ecx,%edx
  8008ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f0:	e8 9f fc ff ff       	call   800594 <getuint>
  8008f5:	89 c1                	mov    %eax,%ecx
  8008f7:	89 d3                	mov    %edx,%ebx
  8008f9:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8008fe:	eb 68                	jmp    800968 <vprintfmt+0x37d>
  800900:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800903:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800906:	89 ca                	mov    %ecx,%edx
  800908:	8d 45 14             	lea    0x14(%ebp),%eax
  80090b:	e8 84 fc ff ff       	call   800594 <getuint>
  800910:	89 c1                	mov    %eax,%ecx
  800912:	89 d3                	mov    %edx,%ebx
  800914:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800919:	eb 4d                	jmp    800968 <vprintfmt+0x37d>
  80091b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80091e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800922:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800929:	ff d7                	call   *%edi
			putch('x', putdat);
  80092b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80092f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800936:	ff d7                	call   *%edi
			num = (unsigned long long)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8d 50 04             	lea    0x4(%eax),%edx
  80093e:	89 55 14             	mov    %edx,0x14(%ebp)
  800941:	8b 08                	mov    (%eax),%ecx
  800943:	bb 00 00 00 00       	mov    $0x0,%ebx
  800948:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80094d:	eb 19                	jmp    800968 <vprintfmt+0x37d>
  80094f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800952:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800955:	89 ca                	mov    %ecx,%edx
  800957:	8d 45 14             	lea    0x14(%ebp),%eax
  80095a:	e8 35 fc ff ff       	call   800594 <getuint>
  80095f:	89 c1                	mov    %eax,%ecx
  800961:	89 d3                	mov    %edx,%ebx
  800963:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800968:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  80096c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800973:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800977:	89 44 24 08          	mov    %eax,0x8(%esp)
  80097b:	89 0c 24             	mov    %ecx,(%esp)
  80097e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800982:	89 f2                	mov    %esi,%edx
  800984:	89 f8                	mov    %edi,%eax
  800986:	e8 21 fb ff ff       	call   8004ac <printnum>
  80098b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80098e:	e9 84 fc ff ff       	jmp    800617 <vprintfmt+0x2c>
  800993:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800996:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099a:	89 04 24             	mov    %eax,(%esp)
  80099d:	ff d7                	call   *%edi
  80099f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8009a2:	e9 70 fc ff ff       	jmp    800617 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ab:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009b2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009b7:	80 38 25             	cmpb   $0x25,(%eax)
  8009ba:	0f 84 57 fc ff ff    	je     800617 <vprintfmt+0x2c>
  8009c0:	89 c3                	mov    %eax,%ebx
  8009c2:	eb f0                	jmp    8009b4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8009c4:	83 c4 4c             	add    $0x4c,%esp
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 28             	sub    $0x28,%esp
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8009d8:	85 c0                	test   %eax,%eax
  8009da:	74 04                	je     8009e0 <vsnprintf+0x14>
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	7f 07                	jg     8009e7 <vsnprintf+0x1b>
  8009e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e5:	eb 3b                	jmp    800a22 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ea:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8009ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800a02:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0d:	c7 04 24 ce 05 80 00 	movl   $0x8005ce,(%esp)
  800a14:	e8 d2 fb ff ff       	call   8005eb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a2a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a31:	8b 45 10             	mov    0x10(%ebp),%eax
  800a34:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	89 04 24             	mov    %eax,(%esp)
  800a45:	e8 82 ff ff ff       	call   8009cc <vsnprintf>
	va_end(ap);

	return rc;
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a52:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a59:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	89 04 24             	mov    %eax,(%esp)
  800a6d:	e8 79 fb ff ff       	call   8005eb <vprintfmt>
	va_end(ap);
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    
	...

00800a80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 55 08             	mov    0x8(%ebp),%edx
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a8b:	eb 03                	jmp    800a90 <strlen+0x10>
		n++;
  800a8d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a94:	75 f7                	jne    800a8d <strlen+0xd>
		n++;
	return n;
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	53                   	push   %ebx
  800a9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa7:	eb 03                	jmp    800aac <strnlen+0x14>
		n++;
  800aa9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aac:	39 c1                	cmp    %eax,%ecx
  800aae:	74 06                	je     800ab6 <strnlen+0x1e>
  800ab0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800ab4:	75 f3                	jne    800aa9 <strnlen+0x11>
		n++;
	return n;
}
  800ab6:	5b                   	pop    %ebx
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	53                   	push   %ebx
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800acc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800acf:	83 c2 01             	add    $0x1,%edx
  800ad2:	84 c9                	test   %cl,%cl
  800ad4:	75 f2                	jne    800ac8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	53                   	push   %ebx
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ae3:	89 1c 24             	mov    %ebx,(%esp)
  800ae6:	e8 95 ff ff ff       	call   800a80 <strlen>
	strcpy(dst + len, src);
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	89 54 24 04          	mov    %edx,0x4(%esp)
  800af2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800af5:	89 04 24             	mov    %eax,(%esp)
  800af8:	e8 bc ff ff ff       	call   800ab9 <strcpy>
	return dst;
}
  800afd:	89 d8                	mov    %ebx,%eax
  800aff:	83 c4 08             	add    $0x8,%esp
  800b02:	5b                   	pop    %ebx
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b10:	8b 75 10             	mov    0x10(%ebp),%esi
  800b13:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b18:	eb 0f                	jmp    800b29 <strncpy+0x24>
		*dst++ = *src;
  800b1a:	0f b6 19             	movzbl (%ecx),%ebx
  800b1d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b20:	80 39 01             	cmpb   $0x1,(%ecx)
  800b23:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b26:	83 c2 01             	add    $0x1,%edx
  800b29:	39 f2                	cmp    %esi,%edx
  800b2b:	72 ed                	jb     800b1a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
  800b36:	8b 75 08             	mov    0x8(%ebp),%esi
  800b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b3f:	89 f0                	mov    %esi,%eax
  800b41:	85 d2                	test   %edx,%edx
  800b43:	75 0a                	jne    800b4f <strlcpy+0x1e>
  800b45:	eb 17                	jmp    800b5e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b47:	88 18                	mov    %bl,(%eax)
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b4f:	83 ea 01             	sub    $0x1,%edx
  800b52:	74 07                	je     800b5b <strlcpy+0x2a>
  800b54:	0f b6 19             	movzbl (%ecx),%ebx
  800b57:	84 db                	test   %bl,%bl
  800b59:	75 ec                	jne    800b47 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800b5b:	c6 00 00             	movb   $0x0,(%eax)
  800b5e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b6d:	eb 06                	jmp    800b75 <strcmp+0x11>
		p++, q++;
  800b6f:	83 c1 01             	add    $0x1,%ecx
  800b72:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b75:	0f b6 01             	movzbl (%ecx),%eax
  800b78:	84 c0                	test   %al,%al
  800b7a:	74 04                	je     800b80 <strcmp+0x1c>
  800b7c:	3a 02                	cmp    (%edx),%al
  800b7e:	74 ef                	je     800b6f <strcmp+0xb>
  800b80:	0f b6 c0             	movzbl %al,%eax
  800b83:	0f b6 12             	movzbl (%edx),%edx
  800b86:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b94:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800b97:	eb 09                	jmp    800ba2 <strncmp+0x18>
		n--, p++, q++;
  800b99:	83 ea 01             	sub    $0x1,%edx
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ba2:	85 d2                	test   %edx,%edx
  800ba4:	75 07                	jne    800bad <strncmp+0x23>
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	eb 13                	jmp    800bc0 <strncmp+0x36>
  800bad:	0f b6 18             	movzbl (%eax),%ebx
  800bb0:	84 db                	test   %bl,%bl
  800bb2:	74 04                	je     800bb8 <strncmp+0x2e>
  800bb4:	3a 19                	cmp    (%ecx),%bl
  800bb6:	74 e1                	je     800b99 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb8:	0f b6 00             	movzbl (%eax),%eax
  800bbb:	0f b6 11             	movzbl (%ecx),%edx
  800bbe:	29 d0                	sub    %edx,%eax
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bcd:	eb 07                	jmp    800bd6 <strchr+0x13>
		if (*s == c)
  800bcf:	38 ca                	cmp    %cl,%dl
  800bd1:	74 0f                	je     800be2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bd3:	83 c0 01             	add    $0x1,%eax
  800bd6:	0f b6 10             	movzbl (%eax),%edx
  800bd9:	84 d2                	test   %dl,%dl
  800bdb:	75 f2                	jne    800bcf <strchr+0xc>
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bee:	eb 07                	jmp    800bf7 <strfind+0x13>
		if (*s == c)
  800bf0:	38 ca                	cmp    %cl,%dl
  800bf2:	74 0a                	je     800bfe <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bf4:	83 c0 01             	add    $0x1,%eax
  800bf7:	0f b6 10             	movzbl (%eax),%edx
  800bfa:	84 d2                	test   %dl,%dl
  800bfc:	75 f2                	jne    800bf0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	89 1c 24             	mov    %ebx,(%esp)
  800c09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c11:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c1a:	85 c9                	test   %ecx,%ecx
  800c1c:	74 30                	je     800c4e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c1e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c24:	75 25                	jne    800c4b <memset+0x4b>
  800c26:	f6 c1 03             	test   $0x3,%cl
  800c29:	75 20                	jne    800c4b <memset+0x4b>
		c &= 0xFF;
  800c2b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c2e:	89 d3                	mov    %edx,%ebx
  800c30:	c1 e3 08             	shl    $0x8,%ebx
  800c33:	89 d6                	mov    %edx,%esi
  800c35:	c1 e6 18             	shl    $0x18,%esi
  800c38:	89 d0                	mov    %edx,%eax
  800c3a:	c1 e0 10             	shl    $0x10,%eax
  800c3d:	09 f0                	or     %esi,%eax
  800c3f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800c41:	09 d8                	or     %ebx,%eax
  800c43:	c1 e9 02             	shr    $0x2,%ecx
  800c46:	fc                   	cld    
  800c47:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c49:	eb 03                	jmp    800c4e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c4b:	fc                   	cld    
  800c4c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4e:	89 f8                	mov    %edi,%eax
  800c50:	8b 1c 24             	mov    (%esp),%ebx
  800c53:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c57:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c5b:	89 ec                	mov    %ebp,%esp
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	89 34 24             	mov    %esi,(%esp)
  800c68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800c72:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c75:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c77:	39 c6                	cmp    %eax,%esi
  800c79:	73 35                	jae    800cb0 <memmove+0x51>
  800c7b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c7e:	39 d0                	cmp    %edx,%eax
  800c80:	73 2e                	jae    800cb0 <memmove+0x51>
		s += n;
		d += n;
  800c82:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c84:	f6 c2 03             	test   $0x3,%dl
  800c87:	75 1b                	jne    800ca4 <memmove+0x45>
  800c89:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c8f:	75 13                	jne    800ca4 <memmove+0x45>
  800c91:	f6 c1 03             	test   $0x3,%cl
  800c94:	75 0e                	jne    800ca4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800c96:	83 ef 04             	sub    $0x4,%edi
  800c99:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c9c:	c1 e9 02             	shr    $0x2,%ecx
  800c9f:	fd                   	std    
  800ca0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca2:	eb 09                	jmp    800cad <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ca4:	83 ef 01             	sub    $0x1,%edi
  800ca7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800caa:	fd                   	std    
  800cab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cad:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cae:	eb 20                	jmp    800cd0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cb6:	75 15                	jne    800ccd <memmove+0x6e>
  800cb8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cbe:	75 0d                	jne    800ccd <memmove+0x6e>
  800cc0:	f6 c1 03             	test   $0x3,%cl
  800cc3:	75 08                	jne    800ccd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800cc5:	c1 e9 02             	shr    $0x2,%ecx
  800cc8:	fc                   	cld    
  800cc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccb:	eb 03                	jmp    800cd0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ccd:	fc                   	cld    
  800cce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cd0:	8b 34 24             	mov    (%esp),%esi
  800cd3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800cd7:	89 ec                	mov    %ebp,%esp
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	89 04 24             	mov    %eax,(%esp)
  800cf5:	e8 65 ff ff ff       	call   800c5f <memmove>
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d10:	eb 1c                	jmp    800d2e <memcmp+0x32>
		if (*s1 != *s2)
  800d12:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800d16:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800d1a:	83 c2 01             	add    $0x1,%edx
  800d1d:	83 e9 01             	sub    $0x1,%ecx
  800d20:	38 d8                	cmp    %bl,%al
  800d22:	74 0a                	je     800d2e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800d24:	0f b6 c0             	movzbl %al,%eax
  800d27:	0f b6 db             	movzbl %bl,%ebx
  800d2a:	29 d8                	sub    %ebx,%eax
  800d2c:	eb 09                	jmp    800d37 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d2e:	85 c9                	test   %ecx,%ecx
  800d30:	75 e0                	jne    800d12 <memcmp+0x16>
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d45:	89 c2                	mov    %eax,%edx
  800d47:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d4a:	eb 07                	jmp    800d53 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d4c:	38 08                	cmp    %cl,(%eax)
  800d4e:	74 07                	je     800d57 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d50:	83 c0 01             	add    $0x1,%eax
  800d53:	39 d0                	cmp    %edx,%eax
  800d55:	72 f5                	jb     800d4c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 04             	sub    $0x4,%esp
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d68:	eb 03                	jmp    800d6d <strtol+0x14>
		s++;
  800d6a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6d:	0f b6 02             	movzbl (%edx),%eax
  800d70:	3c 20                	cmp    $0x20,%al
  800d72:	74 f6                	je     800d6a <strtol+0x11>
  800d74:	3c 09                	cmp    $0x9,%al
  800d76:	74 f2                	je     800d6a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d78:	3c 2b                	cmp    $0x2b,%al
  800d7a:	75 0c                	jne    800d88 <strtol+0x2f>
		s++;
  800d7c:	8d 52 01             	lea    0x1(%edx),%edx
  800d7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d86:	eb 15                	jmp    800d9d <strtol+0x44>
	else if (*s == '-')
  800d88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d8f:	3c 2d                	cmp    $0x2d,%al
  800d91:	75 0a                	jne    800d9d <strtol+0x44>
		s++, neg = 1;
  800d93:	8d 52 01             	lea    0x1(%edx),%edx
  800d96:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9d:	85 db                	test   %ebx,%ebx
  800d9f:	0f 94 c0             	sete   %al
  800da2:	74 05                	je     800da9 <strtol+0x50>
  800da4:	83 fb 10             	cmp    $0x10,%ebx
  800da7:	75 15                	jne    800dbe <strtol+0x65>
  800da9:	80 3a 30             	cmpb   $0x30,(%edx)
  800dac:	75 10                	jne    800dbe <strtol+0x65>
  800dae:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800db2:	75 0a                	jne    800dbe <strtol+0x65>
		s += 2, base = 16;
  800db4:	83 c2 02             	add    $0x2,%edx
  800db7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dbc:	eb 13                	jmp    800dd1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dbe:	84 c0                	test   %al,%al
  800dc0:	74 0f                	je     800dd1 <strtol+0x78>
  800dc2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800dc7:	80 3a 30             	cmpb   $0x30,(%edx)
  800dca:	75 05                	jne    800dd1 <strtol+0x78>
		s++, base = 8;
  800dcc:	83 c2 01             	add    $0x1,%edx
  800dcf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd8:	0f b6 0a             	movzbl (%edx),%ecx
  800ddb:	89 cf                	mov    %ecx,%edi
  800ddd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800de0:	80 fb 09             	cmp    $0x9,%bl
  800de3:	77 08                	ja     800ded <strtol+0x94>
			dig = *s - '0';
  800de5:	0f be c9             	movsbl %cl,%ecx
  800de8:	83 e9 30             	sub    $0x30,%ecx
  800deb:	eb 1e                	jmp    800e0b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800ded:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800df0:	80 fb 19             	cmp    $0x19,%bl
  800df3:	77 08                	ja     800dfd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800df5:	0f be c9             	movsbl %cl,%ecx
  800df8:	83 e9 57             	sub    $0x57,%ecx
  800dfb:	eb 0e                	jmp    800e0b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800dfd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800e00:	80 fb 19             	cmp    $0x19,%bl
  800e03:	77 15                	ja     800e1a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e05:	0f be c9             	movsbl %cl,%ecx
  800e08:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e0b:	39 f1                	cmp    %esi,%ecx
  800e0d:	7d 0b                	jge    800e1a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e0f:	83 c2 01             	add    $0x1,%edx
  800e12:	0f af c6             	imul   %esi,%eax
  800e15:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800e18:	eb be                	jmp    800dd8 <strtol+0x7f>
  800e1a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800e1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e20:	74 05                	je     800e27 <strtol+0xce>
		*endptr = (char *) s;
  800e22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e25:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e27:	89 ca                	mov    %ecx,%edx
  800e29:	f7 da                	neg    %edx
  800e2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e2f:	0f 45 c2             	cmovne %edx,%eax
}
  800e32:	83 c4 04             	add    $0x4,%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
	...

00800e3c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	89 1c 24             	mov    %ebx,(%esp)
  800e45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e49:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e52:	b8 01 00 00 00       	mov    $0x1,%eax
  800e57:	89 d1                	mov    %edx,%ecx
  800e59:	89 d3                	mov    %edx,%ebx
  800e5b:	89 d7                	mov    %edx,%edi
  800e5d:	89 d6                	mov    %edx,%esi
  800e5f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e61:	8b 1c 24             	mov    (%esp),%ebx
  800e64:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e68:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e6c:	89 ec                	mov    %ebp,%esp
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	89 1c 24             	mov    %ebx,(%esp)
  800e79:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e7d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	89 c3                	mov    %eax,%ebx
  800e8e:	89 c7                	mov    %eax,%edi
  800e90:	89 c6                	mov    %eax,%esi
  800e92:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e94:	8b 1c 24             	mov    (%esp),%ebx
  800e97:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e9b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e9f:	89 ec                	mov    %ebp,%esp
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 0c             	sub    $0xc,%esp
  800ea9:	89 1c 24             	mov    %ebx,(%esp)
  800eac:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eb0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb9:	b8 10 00 00 00       	mov    $0x10,%eax
  800ebe:	89 d1                	mov    %edx,%ecx
  800ec0:	89 d3                	mov    %edx,%ebx
  800ec2:	89 d7                	mov    %edx,%edi
  800ec4:	89 d6                	mov    %edx,%esi
  800ec6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec8:	8b 1c 24             	mov    (%esp),%ebx
  800ecb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ecf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ed3:	89 ec                	mov    %ebp,%esp
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    

00800ed7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 38             	sub    $0x38,%esp
  800edd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eeb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	89 df                	mov    %ebx,%edi
  800ef8:	89 de                	mov    %ebx,%esi
  800efa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	7e 28                	jle    800f28 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f04:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f0b:	00 
  800f0c:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  800f13:	00 
  800f14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1b:	00 
  800f1c:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  800f23:	e8 6c f4 ff ff       	call   800394 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800f28:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f31:	89 ec                	mov    %ebp,%esp
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 38             	sub    $0x38,%esp
  800f3b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f41:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f49:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	89 df                	mov    %ebx,%edi
  800f56:	89 de                	mov    %ebx,%esi
  800f58:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	7e 28                	jle    800f86 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f62:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f69:	00 
  800f6a:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  800f71:	00 
  800f72:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f79:	00 
  800f7a:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  800f81:	e8 0e f4 ff ff       	call   800394 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800f86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f89:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8f:	89 ec                	mov    %ebp,%esp
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 38             	sub    $0x38,%esp
  800f99:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	89 cb                	mov    %ecx,%ebx
  800fb1:	89 cf                	mov    %ecx,%edi
  800fb3:	89 ce                	mov    %ecx,%esi
  800fb5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	7e 28                	jle    800fe3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fc6:	00 
  800fc7:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  800fce:	00 
  800fcf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd6:	00 
  800fd7:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  800fde:	e8 b1 f3 ff ff       	call   800394 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fec:	89 ec                	mov    %ebp,%esp
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	89 1c 24             	mov    %ebx,(%esp)
  800ff9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801001:	be 00 00 00 00       	mov    $0x0,%esi
  801006:	b8 0c 00 00 00       	mov    $0xc,%eax
  80100b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80100e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801011:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801019:	8b 1c 24             	mov    (%esp),%ebx
  80101c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801020:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801024:	89 ec                	mov    %ebp,%esp
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 38             	sub    $0x38,%esp
  80102e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801031:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801034:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801037:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801041:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 df                	mov    %ebx,%edi
  801049:	89 de                	mov    %ebx,%esi
  80104b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80104d:	85 c0                	test   %eax,%eax
  80104f:	7e 28                	jle    801079 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801051:	89 44 24 10          	mov    %eax,0x10(%esp)
  801055:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80105c:	00 
  80105d:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  801064:	00 
  801065:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106c:	00 
  80106d:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  801074:	e8 1b f3 ff ff       	call   800394 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801079:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80107c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80107f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801082:	89 ec                	mov    %ebp,%esp
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 38             	sub    $0x38,%esp
  80108c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80108f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801092:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801095:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109a:	b8 09 00 00 00       	mov    $0x9,%eax
  80109f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a5:	89 df                	mov    %ebx,%edi
  8010a7:	89 de                	mov    %ebx,%esi
  8010a9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	7e 28                	jle    8010d7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010af:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010ba:	00 
  8010bb:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  8010c2:	00 
  8010c3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ca:	00 
  8010cb:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  8010d2:	e8 bd f2 ff ff       	call   800394 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010d7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010da:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e0:	89 ec                	mov    %ebp,%esp
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 38             	sub    $0x38,%esp
  8010ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 df                	mov    %ebx,%edi
  801105:	89 de                	mov    %ebx,%esi
  801107:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801109:	85 c0                	test   %eax,%eax
  80110b:	7e 28                	jle    801135 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801111:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801118:	00 
  801119:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  801120:	00 
  801121:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801128:	00 
  801129:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  801130:	e8 5f f2 ff ff       	call   800394 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801135:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801138:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80113b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80113e:	89 ec                	mov    %ebp,%esp
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    

00801142 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 38             	sub    $0x38,%esp
  801148:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80114b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80114e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801151:	bb 00 00 00 00       	mov    $0x0,%ebx
  801156:	b8 06 00 00 00       	mov    $0x6,%eax
  80115b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	89 df                	mov    %ebx,%edi
  801163:	89 de                	mov    %ebx,%esi
  801165:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801167:	85 c0                	test   %eax,%eax
  801169:	7e 28                	jle    801193 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801176:	00 
  801177:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  80117e:	00 
  80117f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801186:	00 
  801187:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  80118e:	e8 01 f2 ff ff       	call   800394 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801193:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801196:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801199:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80119c:	89 ec                	mov    %ebp,%esp
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 38             	sub    $0x38,%esp
  8011a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011af:	b8 05 00 00 00       	mov    $0x5,%eax
  8011b4:	8b 75 18             	mov    0x18(%ebp),%esi
  8011b7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	7e 28                	jle    8011f1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011cd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011d4:	00 
  8011d5:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e4:	00 
  8011e5:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  8011ec:	e8 a3 f1 ff ff       	call   800394 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011fa:	89 ec                	mov    %ebp,%esp
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 38             	sub    $0x38,%esp
  801204:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801207:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80120a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120d:	be 00 00 00 00       	mov    $0x0,%esi
  801212:	b8 04 00 00 00       	mov    $0x4,%eax
  801217:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80121a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121d:	8b 55 08             	mov    0x8(%ebp),%edx
  801220:	89 f7                	mov    %esi,%edi
  801222:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801224:	85 c0                	test   %eax,%eax
  801226:	7e 28                	jle    801250 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801228:	89 44 24 10          	mov    %eax,0x10(%esp)
  80122c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801233:	00 
  801234:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  80124b:	e8 44 f1 ff ff       	call   800394 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801250:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801253:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801256:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801259:	89 ec                	mov    %ebp,%esp
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	89 1c 24             	mov    %ebx,(%esp)
  801266:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126e:	ba 00 00 00 00       	mov    $0x0,%edx
  801273:	b8 0b 00 00 00       	mov    $0xb,%eax
  801278:	89 d1                	mov    %edx,%ecx
  80127a:	89 d3                	mov    %edx,%ebx
  80127c:	89 d7                	mov    %edx,%edi
  80127e:	89 d6                	mov    %edx,%esi
  801280:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801282:	8b 1c 24             	mov    (%esp),%ebx
  801285:	8b 74 24 04          	mov    0x4(%esp),%esi
  801289:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80128d:	89 ec                	mov    %ebp,%esp
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	89 1c 24             	mov    %ebx,(%esp)
  80129a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80129e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8012ac:	89 d1                	mov    %edx,%ecx
  8012ae:	89 d3                	mov    %edx,%ebx
  8012b0:	89 d7                	mov    %edx,%edi
  8012b2:	89 d6                	mov    %edx,%esi
  8012b4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012b6:	8b 1c 24             	mov    (%esp),%ebx
  8012b9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012bd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012c1:	89 ec                	mov    %ebp,%esp
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 38             	sub    $0x38,%esp
  8012cb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012ce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012d1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8012de:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e1:	89 cb                	mov    %ecx,%ebx
  8012e3:	89 cf                	mov    %ecx,%edi
  8012e5:	89 ce                	mov    %ecx,%esi
  8012e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	7e 28                	jle    801315 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012f8:	00 
  8012f9:	c7 44 24 08 07 31 80 	movl   $0x803107,0x8(%esp)
  801300:	00 
  801301:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801308:	00 
  801309:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  801310:	e8 7f f0 ff ff       	call   800394 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801315:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801318:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80131b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80131e:	89 ec                	mov    %ebp,%esp
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    
	...

00801324 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	8b 55 08             	mov    0x8(%ebp),%edx
  80132a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801330:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801332:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801335:	83 3a 01             	cmpl   $0x1,(%edx)
  801338:	7e 09                	jle    801343 <argstart+0x1f>
  80133a:	ba 5b 2d 80 00       	mov    $0x802d5b,%edx
  80133f:	85 c9                	test   %ecx,%ecx
  801341:	75 05                	jne    801348 <argstart+0x24>
  801343:	ba 00 00 00 00       	mov    $0x0,%edx
  801348:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80134b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	53                   	push   %ebx
  801358:	83 ec 14             	sub    $0x14,%esp
  80135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  80135e:	8b 53 08             	mov    0x8(%ebx),%edx
  801361:	b8 00 00 00 00       	mov    $0x0,%eax
  801366:	85 d2                	test   %edx,%edx
  801368:	74 5a                	je     8013c4 <argnextvalue+0x70>
		return 0;
	if (*args->curarg) {
  80136a:	80 3a 00             	cmpb   $0x0,(%edx)
  80136d:	74 0c                	je     80137b <argnextvalue+0x27>
		args->argvalue = args->curarg;
  80136f:	89 53 0c             	mov    %edx,0xc(%ebx)
		args->curarg = "";
  801372:	c7 43 08 5b 2d 80 00 	movl   $0x802d5b,0x8(%ebx)
  801379:	eb 46                	jmp    8013c1 <argnextvalue+0x6d>
	} else if (*args->argc > 1) {
  80137b:	8b 03                	mov    (%ebx),%eax
  80137d:	83 38 01             	cmpl   $0x1,(%eax)
  801380:	7e 31                	jle    8013b3 <argnextvalue+0x5f>
		args->argvalue = args->argv[1];
  801382:	8b 43 04             	mov    0x4(%ebx),%eax
  801385:	8b 50 04             	mov    0x4(%eax),%edx
  801388:	89 53 0c             	mov    %edx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80138b:	8b 13                	mov    (%ebx),%edx
  80138d:	8b 12                	mov    (%edx),%edx
  80138f:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801396:	89 54 24 08          	mov    %edx,0x8(%esp)
  80139a:	8d 50 08             	lea    0x8(%eax),%edx
  80139d:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013a1:	83 c0 04             	add    $0x4,%eax
  8013a4:	89 04 24             	mov    %eax,(%esp)
  8013a7:	e8 b3 f8 ff ff       	call   800c5f <memmove>
		(*args->argc)--;
  8013ac:	8b 03                	mov    (%ebx),%eax
  8013ae:	83 28 01             	subl   $0x1,(%eax)
  8013b1:	eb 0e                	jmp    8013c1 <argnextvalue+0x6d>
	} else {
		args->argvalue = 0;
  8013b3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8013ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8013c1:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8013c4:	83 c4 14             	add    $0x14,%esp
  8013c7:	5b                   	pop    %ebx
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	83 ec 18             	sub    $0x18,%esp
  8013d0:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8013d3:	8b 42 0c             	mov    0xc(%edx),%eax
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	75 08                	jne    8013e2 <argvalue+0x18>
  8013da:	89 14 24             	mov    %edx,(%esp)
  8013dd:	e8 72 ff ff ff       	call   801354 <argnextvalue>
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <argnext>:
	args->argvalue = 0;
}

int
argnext(struct Argstate *args)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	53                   	push   %ebx
  8013e8:	83 ec 14             	sub    $0x14,%esp
  8013eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8013ee:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8013f5:	8b 53 08             	mov    0x8(%ebx),%edx
  8013f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013fd:	85 d2                	test   %edx,%edx
  8013ff:	74 73                	je     801474 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801401:	80 3a 00             	cmpb   $0x0,(%edx)
  801404:	75 54                	jne    80145a <argnext+0x76>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801406:	8b 03                	mov    (%ebx),%eax
  801408:	83 38 01             	cmpl   $0x1,(%eax)
  80140b:	74 5b                	je     801468 <argnext+0x84>
		    || args->argv[1][0] != '-'
  80140d:	8b 43 04             	mov    0x4(%ebx),%eax
  801410:	8b 40 04             	mov    0x4(%eax),%eax
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801413:	80 38 2d             	cmpb   $0x2d,(%eax)
  801416:	75 50                	jne    801468 <argnext+0x84>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
  801418:	83 c0 01             	add    $0x1,%eax
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80141b:	80 38 00             	cmpb   $0x0,(%eax)
  80141e:	74 48                	je     801468 <argnext+0x84>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801420:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801423:	8b 43 04             	mov    0x4(%ebx),%eax
  801426:	8b 13                	mov    (%ebx),%edx
  801428:	8b 12                	mov    (%edx),%edx
  80142a:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801431:	89 54 24 08          	mov    %edx,0x8(%esp)
  801435:	8d 50 08             	lea    0x8(%eax),%edx
  801438:	89 54 24 04          	mov    %edx,0x4(%esp)
  80143c:	83 c0 04             	add    $0x4,%eax
  80143f:	89 04 24             	mov    %eax,(%esp)
  801442:	e8 18 f8 ff ff       	call   800c5f <memmove>
		(*args->argc)--;
  801447:	8b 03                	mov    (%ebx),%eax
  801449:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80144c:	8b 43 08             	mov    0x8(%ebx),%eax
  80144f:	80 38 2d             	cmpb   $0x2d,(%eax)
  801452:	75 06                	jne    80145a <argnext+0x76>
  801454:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801458:	74 0e                	je     801468 <argnext+0x84>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80145a:	8b 53 08             	mov    0x8(%ebx),%edx
  80145d:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801460:	83 c2 01             	add    $0x1,%edx
  801463:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801466:	eb 0c                	jmp    801474 <argnext+0x90>

    endofargs:
	args->curarg = 0;
  801468:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80146f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return -1;
}
  801474:	83 c4 14             	add    $0x14,%esp
  801477:	5b                   	pop    %ebx
  801478:	5d                   	pop    %ebp
  801479:	c3                   	ret    
	...

0080147c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	05 00 00 00 30       	add    $0x30000000,%eax
  801487:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 04 24             	mov    %eax,(%esp)
  801498:	e8 df ff ff ff       	call   80147c <fd2num>
  80149d:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014a2:	c1 e0 0c             	shl    $0xc,%eax
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	57                   	push   %edi
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
  8014ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014b5:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8014ba:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014bf:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014c1:	89 c2                	mov    %eax,%edx
  8014c3:	c1 ea 16             	shr    $0x16,%edx
  8014c6:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8014c9:	f6 c2 01             	test   $0x1,%dl
  8014cc:	74 0d                	je     8014db <fd_alloc+0x34>
  8014ce:	89 c2                	mov    %eax,%edx
  8014d0:	c1 ea 0c             	shr    $0xc,%edx
  8014d3:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8014d6:	f6 c2 01             	test   $0x1,%dl
  8014d9:	75 09                	jne    8014e4 <fd_alloc+0x3d>
			*fd_store = fd;
  8014db:	89 37                	mov    %esi,(%edi)
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8014e2:	eb 17                	jmp    8014fb <fd_alloc+0x54>
  8014e4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014ee:	75 cf                	jne    8014bf <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014f0:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8014f6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8014fb:	5b                   	pop    %ebx
  8014fc:	5e                   	pop    %esi
  8014fd:	5f                   	pop    %edi
  8014fe:	5d                   	pop    %ebp
  8014ff:	c3                   	ret    

00801500 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	83 f8 1f             	cmp    $0x1f,%eax
  801509:	77 36                	ja     801541 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80150b:	05 00 00 0d 00       	add    $0xd0000,%eax
  801510:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801513:	89 c2                	mov    %eax,%edx
  801515:	c1 ea 16             	shr    $0x16,%edx
  801518:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80151f:	f6 c2 01             	test   $0x1,%dl
  801522:	74 1d                	je     801541 <fd_lookup+0x41>
  801524:	89 c2                	mov    %eax,%edx
  801526:	c1 ea 0c             	shr    $0xc,%edx
  801529:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801530:	f6 c2 01             	test   $0x1,%dl
  801533:	74 0c                	je     801541 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801535:	8b 55 0c             	mov    0xc(%ebp),%edx
  801538:	89 02                	mov    %eax,(%edx)
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80153f:	eb 05                	jmp    801546 <fd_lookup+0x46>
  801541:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    

00801548 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80154e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801551:	89 44 24 04          	mov    %eax,0x4(%esp)
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	89 04 24             	mov    %eax,(%esp)
  80155b:	e8 a0 ff ff ff       	call   801500 <fd_lookup>
  801560:	85 c0                	test   %eax,%eax
  801562:	78 0e                	js     801572 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801564:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156a:	89 50 04             	mov    %edx,0x4(%eax)
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	56                   	push   %esi
  801578:	53                   	push   %ebx
  801579:	83 ec 10             	sub    $0x10,%esp
  80157c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801582:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801587:	be b4 31 80 00       	mov    $0x8031b4,%esi
  80158c:	eb 10                	jmp    80159e <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  80158e:	39 08                	cmp    %ecx,(%eax)
  801590:	75 09                	jne    80159b <dev_lookup+0x27>
			*dev = devtab[i];
  801592:	89 03                	mov    %eax,(%ebx)
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801599:	eb 31                	jmp    8015cc <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80159b:	83 c2 01             	add    $0x1,%edx
  80159e:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	75 e9                	jne    80158e <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015a5:	a1 20 54 80 00       	mov    0x805420,%eax
  8015aa:	8b 40 48             	mov    0x48(%eax),%eax
  8015ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b5:	c7 04 24 34 31 80 00 	movl   $0x803134,(%esp)
  8015bc:	e8 8c ee ff ff       	call   80044d <cprintf>
	*dev = 0;
  8015c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	53                   	push   %ebx
  8015d7:	83 ec 24             	sub    $0x24,%esp
  8015da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	89 04 24             	mov    %eax,(%esp)
  8015ea:	e8 11 ff ff ff       	call   801500 <fd_lookup>
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 53                	js     801646 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	8b 00                	mov    (%eax),%eax
  8015ff:	89 04 24             	mov    %eax,(%esp)
  801602:	e8 6d ff ff ff       	call   801574 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801607:	85 c0                	test   %eax,%eax
  801609:	78 3b                	js     801646 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  80160b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801613:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801617:	74 2d                	je     801646 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801619:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80161c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801623:	00 00 00 
	stat->st_isdir = 0;
  801626:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80162d:	00 00 00 
	stat->st_dev = dev;
  801630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801633:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801639:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80163d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801640:	89 14 24             	mov    %edx,(%esp)
  801643:	ff 50 14             	call   *0x14(%eax)
}
  801646:	83 c4 24             	add    $0x24,%esp
  801649:	5b                   	pop    %ebx
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	53                   	push   %ebx
  801650:	83 ec 24             	sub    $0x24,%esp
  801653:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801656:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165d:	89 1c 24             	mov    %ebx,(%esp)
  801660:	e8 9b fe ff ff       	call   801500 <fd_lookup>
  801665:	85 c0                	test   %eax,%eax
  801667:	78 5f                	js     8016c8 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801669:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	8b 00                	mov    (%eax),%eax
  801675:	89 04 24             	mov    %eax,(%esp)
  801678:	e8 f7 fe ff ff       	call   801574 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 47                	js     8016c8 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801681:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801684:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801688:	75 23                	jne    8016ad <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80168a:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80168f:	8b 40 48             	mov    0x48(%eax),%eax
  801692:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801696:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169a:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8016a1:	e8 a7 ed ff ff       	call   80044d <cprintf>
  8016a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ab:	eb 1b                	jmp    8016c8 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	8b 48 18             	mov    0x18(%eax),%ecx
  8016b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b8:	85 c9                	test   %ecx,%ecx
  8016ba:	74 0c                	je     8016c8 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c3:	89 14 24             	mov    %edx,(%esp)
  8016c6:	ff d1                	call   *%ecx
}
  8016c8:	83 c4 24             	add    $0x24,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    

008016ce <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 24             	sub    $0x24,%esp
  8016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016df:	89 1c 24             	mov    %ebx,(%esp)
  8016e2:	e8 19 fe ff ff       	call   801500 <fd_lookup>
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 66                	js     801751 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	89 04 24             	mov    %eax,(%esp)
  8016fa:	e8 75 fe ff ff       	call   801574 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 4e                	js     801751 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801703:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801706:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80170a:	75 23                	jne    80172f <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80170c:	a1 20 54 80 00       	mov    0x805420,%eax
  801711:	8b 40 48             	mov    0x48(%eax),%eax
  801714:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171c:	c7 04 24 78 31 80 00 	movl   $0x803178,(%esp)
  801723:	e8 25 ed ff ff       	call   80044d <cprintf>
  801728:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  80172d:	eb 22                	jmp    801751 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80172f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801732:	8b 48 0c             	mov    0xc(%eax),%ecx
  801735:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173a:	85 c9                	test   %ecx,%ecx
  80173c:	74 13                	je     801751 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	89 44 24 08          	mov    %eax,0x8(%esp)
  801745:	8b 45 0c             	mov    0xc(%ebp),%eax
  801748:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174c:	89 14 24             	mov    %edx,(%esp)
  80174f:	ff d1                	call   *%ecx
}
  801751:	83 c4 24             	add    $0x24,%esp
  801754:	5b                   	pop    %ebx
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    

00801757 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	53                   	push   %ebx
  80175b:	83 ec 24             	sub    $0x24,%esp
  80175e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801761:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801764:	89 44 24 04          	mov    %eax,0x4(%esp)
  801768:	89 1c 24             	mov    %ebx,(%esp)
  80176b:	e8 90 fd ff ff       	call   801500 <fd_lookup>
  801770:	85 c0                	test   %eax,%eax
  801772:	78 6b                	js     8017df <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801774:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177e:	8b 00                	mov    (%eax),%eax
  801780:	89 04 24             	mov    %eax,(%esp)
  801783:	e8 ec fd ff ff       	call   801574 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 53                	js     8017df <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80178c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178f:	8b 42 08             	mov    0x8(%edx),%eax
  801792:	83 e0 03             	and    $0x3,%eax
  801795:	83 f8 01             	cmp    $0x1,%eax
  801798:	75 23                	jne    8017bd <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80179a:	a1 20 54 80 00       	mov    0x805420,%eax
  80179f:	8b 40 48             	mov    0x48(%eax),%eax
  8017a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017aa:	c7 04 24 95 31 80 00 	movl   $0x803195,(%esp)
  8017b1:	e8 97 ec ff ff       	call   80044d <cprintf>
  8017b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017bb:	eb 22                	jmp    8017df <read+0x88>
	}
	if (!dev->dev_read)
  8017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8017c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c8:	85 c9                	test   %ecx,%ecx
  8017ca:	74 13                	je     8017df <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017da:	89 14 24             	mov    %edx,(%esp)
  8017dd:	ff d1                	call   *%ecx
}
  8017df:	83 c4 24             	add    $0x24,%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5d                   	pop    %ebp
  8017e4:	c3                   	ret    

008017e5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	57                   	push   %edi
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 1c             	sub    $0x1c,%esp
  8017ee:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017f1:	8b 75 10             	mov    0x10(%ebp),%esi
  8017f4:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017f9:	eb 21                	jmp    80181c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017fb:	89 f2                	mov    %esi,%edx
  8017fd:	29 c2                	sub    %eax,%edx
  8017ff:	89 54 24 08          	mov    %edx,0x8(%esp)
  801803:	03 45 0c             	add    0xc(%ebp),%eax
  801806:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180a:	89 3c 24             	mov    %edi,(%esp)
  80180d:	e8 45 ff ff ff       	call   801757 <read>
		if (m < 0)
  801812:	85 c0                	test   %eax,%eax
  801814:	78 0e                	js     801824 <readn+0x3f>
			return m;
		if (m == 0)
  801816:	85 c0                	test   %eax,%eax
  801818:	74 08                	je     801822 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80181a:	01 c3                	add    %eax,%ebx
  80181c:	89 d8                	mov    %ebx,%eax
  80181e:	39 f3                	cmp    %esi,%ebx
  801820:	72 d9                	jb     8017fb <readn+0x16>
  801822:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801824:	83 c4 1c             	add    $0x1c,%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 38             	sub    $0x38,%esp
  801832:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801835:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801838:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80183b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80183e:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801842:	89 3c 24             	mov    %edi,(%esp)
  801845:	e8 32 fc ff ff       	call   80147c <fd2num>
  80184a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80184d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801851:	89 04 24             	mov    %eax,(%esp)
  801854:	e8 a7 fc ff ff       	call   801500 <fd_lookup>
  801859:	89 c3                	mov    %eax,%ebx
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 05                	js     801864 <fd_close+0x38>
  80185f:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801862:	74 0e                	je     801872 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801864:	89 f0                	mov    %esi,%eax
  801866:	84 c0                	test   %al,%al
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
  80186d:	0f 44 d8             	cmove  %eax,%ebx
  801870:	eb 3d                	jmp    8018af <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801872:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801875:	89 44 24 04          	mov    %eax,0x4(%esp)
  801879:	8b 07                	mov    (%edi),%eax
  80187b:	89 04 24             	mov    %eax,(%esp)
  80187e:	e8 f1 fc ff ff       	call   801574 <dev_lookup>
  801883:	89 c3                	mov    %eax,%ebx
  801885:	85 c0                	test   %eax,%eax
  801887:	78 16                	js     80189f <fd_close+0x73>
		if (dev->dev_close)
  801889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188c:	8b 40 10             	mov    0x10(%eax),%eax
  80188f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801894:	85 c0                	test   %eax,%eax
  801896:	74 07                	je     80189f <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801898:	89 3c 24             	mov    %edi,(%esp)
  80189b:	ff d0                	call   *%eax
  80189d:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80189f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018aa:	e8 93 f8 ff ff       	call   801142 <sys_page_unmap>
	return r;
}
  8018af:	89 d8                	mov    %ebx,%eax
  8018b1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018b4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018ba:	89 ec                	mov    %ebp,%esp
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    

008018be <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 2a fc ff ff       	call   801500 <fd_lookup>
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 13                	js     8018ed <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8018da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018e1:	00 
  8018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e5:	89 04 24             	mov    %eax,(%esp)
  8018e8:	e8 3f ff ff ff       	call   80182c <fd_close>
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 18             	sub    $0x18,%esp
  8018f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8018f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801902:	00 
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	89 04 24             	mov    %eax,(%esp)
  801909:	e8 25 04 00 00       	call   801d33 <open>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	85 c0                	test   %eax,%eax
  801912:	78 1b                	js     80192f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801914:	8b 45 0c             	mov    0xc(%ebp),%eax
  801917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191b:	89 1c 24             	mov    %ebx,(%esp)
  80191e:	e8 b0 fc ff ff       	call   8015d3 <fstat>
  801923:	89 c6                	mov    %eax,%esi
	close(fd);
  801925:	89 1c 24             	mov    %ebx,(%esp)
  801928:	e8 91 ff ff ff       	call   8018be <close>
  80192d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801934:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801937:	89 ec                	mov    %ebp,%esp
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	53                   	push   %ebx
  80193f:	83 ec 14             	sub    $0x14,%esp
  801942:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801947:	89 1c 24             	mov    %ebx,(%esp)
  80194a:	e8 6f ff ff ff       	call   8018be <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80194f:	83 c3 01             	add    $0x1,%ebx
  801952:	83 fb 20             	cmp    $0x20,%ebx
  801955:	75 f0                	jne    801947 <close_all+0xc>
		close(i);
}
  801957:	83 c4 14             	add    $0x14,%esp
  80195a:	5b                   	pop    %ebx
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 58             	sub    $0x58,%esp
  801963:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801966:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801969:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80196c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80196f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801972:	89 44 24 04          	mov    %eax,0x4(%esp)
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	89 04 24             	mov    %eax,(%esp)
  80197c:	e8 7f fb ff ff       	call   801500 <fd_lookup>
  801981:	89 c3                	mov    %eax,%ebx
  801983:	85 c0                	test   %eax,%eax
  801985:	0f 88 e0 00 00 00    	js     801a6b <dup+0x10e>
		return r;
	close(newfdnum);
  80198b:	89 3c 24             	mov    %edi,(%esp)
  80198e:	e8 2b ff ff ff       	call   8018be <close>

	newfd = INDEX2FD(newfdnum);
  801993:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801999:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80199c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 e5 fa ff ff       	call   80148c <fd2data>
  8019a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019a9:	89 34 24             	mov    %esi,(%esp)
  8019ac:	e8 db fa ff ff       	call   80148c <fd2data>
  8019b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019b4:	89 da                	mov    %ebx,%edx
  8019b6:	89 d8                	mov    %ebx,%eax
  8019b8:	c1 e8 16             	shr    $0x16,%eax
  8019bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019c2:	a8 01                	test   $0x1,%al
  8019c4:	74 43                	je     801a09 <dup+0xac>
  8019c6:	c1 ea 0c             	shr    $0xc,%edx
  8019c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019d0:	a8 01                	test   $0x1,%al
  8019d2:	74 35                	je     801a09 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019d4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019db:	25 07 0e 00 00       	and    $0xe07,%eax
  8019e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019f2:	00 
  8019f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fe:	e8 9d f7 ff ff       	call   8011a0 <sys_page_map>
  801a03:	89 c3                	mov    %eax,%ebx
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 3f                	js     801a48 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0c:	89 c2                	mov    %eax,%edx
  801a0e:	c1 ea 0c             	shr    $0xc,%edx
  801a11:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a18:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a1e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a22:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a2d:	00 
  801a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a39:	e8 62 f7 ff ff       	call   8011a0 <sys_page_map>
  801a3e:	89 c3                	mov    %eax,%ebx
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 04                	js     801a48 <dup+0xeb>
  801a44:	89 fb                	mov    %edi,%ebx
  801a46:	eb 23                	jmp    801a6b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a48:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a53:	e8 ea f6 ff ff       	call   801142 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a66:	e8 d7 f6 ff ff       	call   801142 <sys_page_unmap>
	return r;
}
  801a6b:	89 d8                	mov    %ebx,%eax
  801a6d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a70:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a73:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a76:	89 ec                	mov    %ebp,%esp
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    
	...

00801a7c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	56                   	push   %esi
  801a80:	53                   	push   %ebx
  801a81:	83 ec 10             	sub    $0x10,%esp
  801a84:	89 c3                	mov    %eax,%ebx
  801a86:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a88:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a8f:	75 11                	jne    801aa2 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a98:	e8 b7 0e 00 00       	call   802954 <ipc_find_env>
  801a9d:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801aa2:	a1 20 54 80 00       	mov    0x805420,%eax
  801aa7:	8b 40 48             	mov    0x48(%eax),%eax
  801aaa:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801ab0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ab4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abc:	c7 04 24 c8 31 80 00 	movl   $0x8031c8,(%esp)
  801ac3:	e8 85 e9 ff ff       	call   80044d <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ac8:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801acf:	00 
  801ad0:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ad7:	00 
  801ad8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801adc:	a1 00 50 80 00       	mov    0x805000,%eax
  801ae1:	89 04 24             	mov    %eax,(%esp)
  801ae4:	e8 a1 0e 00 00       	call   80298a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ae9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801af0:	00 
  801af1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801af5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afc:	e8 f5 0e 00 00       	call   8029f6 <ipc_recv>
}
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    

00801b08 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	8b 40 0c             	mov    0xc(%eax),%eax
  801b14:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b21:	ba 00 00 00 00       	mov    $0x0,%edx
  801b26:	b8 02 00 00 00       	mov    $0x2,%eax
  801b2b:	e8 4c ff ff ff       	call   801a7c <fsipc>
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b43:	ba 00 00 00 00       	mov    $0x0,%edx
  801b48:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4d:	e8 2a ff ff ff       	call   801a7c <fsipc>
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5f:	b8 08 00 00 00       	mov    $0x8,%eax
  801b64:	e8 13 ff ff ff       	call   801a7c <fsipc>
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	53                   	push   %ebx
  801b6f:	83 ec 14             	sub    $0x14,%esp
  801b72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	b8 05 00 00 00       	mov    $0x5,%eax
  801b8a:	e8 ed fe ff ff       	call   801a7c <fsipc>
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 2b                	js     801bbe <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b93:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b9a:	00 
  801b9b:	89 1c 24             	mov    %ebx,(%esp)
  801b9e:	e8 16 ef ff ff       	call   800ab9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ba3:	a1 80 60 80 00       	mov    0x806080,%eax
  801ba8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bae:	a1 84 60 80 00       	mov    0x806084,%eax
  801bb3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801bbe:	83 c4 14             	add    $0x14,%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    

00801bc4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 14             	sub    $0x14,%esp
  801bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801bd9:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801bdf:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801be5:	76 24                	jbe    801c0b <devfile_write+0x47>
  801be7:	c7 44 24 0c de 31 80 	movl   $0x8031de,0xc(%esp)
  801bee:	00 
  801bef:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  801bf6:	00 
  801bf7:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801bfe:	00 
  801bff:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801c06:	e8 89 e7 ff ff       	call   800394 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801c0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c16:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c1d:	e8 3d f0 ff ff       	call   800c5f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801c22:	ba 00 00 00 00       	mov    $0x0,%edx
  801c27:	b8 04 00 00 00       	mov    $0x4,%eax
  801c2c:	e8 4b fe ff ff       	call   801a7c <fsipc>
	if(ret<0) return ret;
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 53                	js     801c88 <devfile_write+0xc4>
	
	assert(ret <= n);
  801c35:	39 c3                	cmp    %eax,%ebx
  801c37:	73 24                	jae    801c5d <devfile_write+0x99>
  801c39:	c7 44 24 0c 08 32 80 	movl   $0x803208,0xc(%esp)
  801c40:	00 
  801c41:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  801c48:	00 
  801c49:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c50:	00 
  801c51:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801c58:	e8 37 e7 ff ff       	call   800394 <_panic>
	assert(ret <= PGSIZE);
  801c5d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c62:	7e 24                	jle    801c88 <devfile_write+0xc4>
  801c64:	c7 44 24 0c 11 32 80 	movl   $0x803211,0xc(%esp)
  801c6b:	00 
  801c6c:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  801c73:	00 
  801c74:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801c7b:	00 
  801c7c:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801c83:	e8 0c e7 ff ff       	call   800394 <_panic>
	return ret;
}
  801c88:	83 c4 14             	add    $0x14,%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	56                   	push   %esi
  801c92:	53                   	push   %ebx
  801c93:	83 ec 10             	sub    $0x10,%esp
  801c96:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ca4:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801caa:	ba 00 00 00 00       	mov    $0x0,%edx
  801caf:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb4:	e8 c3 fd ff ff       	call   801a7c <fsipc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 6b                	js     801d2a <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801cbf:	39 de                	cmp    %ebx,%esi
  801cc1:	73 24                	jae    801ce7 <devfile_read+0x59>
  801cc3:	c7 44 24 0c 1f 32 80 	movl   $0x80321f,0xc(%esp)
  801cca:	00 
  801ccb:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  801cd2:	00 
  801cd3:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cda:	00 
  801cdb:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801ce2:	e8 ad e6 ff ff       	call   800394 <_panic>
	assert(r <= PGSIZE);
  801ce7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801ced:	7e 24                	jle    801d13 <devfile_read+0x85>
  801cef:	c7 44 24 0c 26 32 80 	movl   $0x803226,0xc(%esp)
  801cf6:	00 
  801cf7:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  801cfe:	00 
  801cff:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d06:	00 
  801d07:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801d0e:	e8 81 e6 ff ff       	call   800394 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d17:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d1e:	00 
  801d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 35 ef ff ff       	call   800c5f <memmove>
	return r;
}
  801d2a:	89 d8                	mov    %ebx,%eax
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 28             	sub    $0x28,%esp
  801d39:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d3c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d3f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d42:	89 34 24             	mov    %esi,(%esp)
  801d45:	e8 36 ed ff ff       	call   800a80 <strlen>
  801d4a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d4f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d54:	7f 5e                	jg     801db4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d59:	89 04 24             	mov    %eax,(%esp)
  801d5c:	e8 46 f7 ff ff       	call   8014a7 <fd_alloc>
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 4d                	js     801db4 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d67:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d6b:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d72:	e8 42 ed ff ff       	call   800ab9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7a:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	e8 f0 fc ff ff       	call   801a7c <fsipc>
  801d8c:	89 c3                	mov    %eax,%ebx
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	79 15                	jns    801da7 <open+0x74>
		fd_close(fd, 0);
  801d92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d99:	00 
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	89 04 24             	mov    %eax,(%esp)
  801da0:	e8 87 fa ff ff       	call   80182c <fd_close>
		return r;
  801da5:	eb 0d                	jmp    801db4 <open+0x81>
	}

	return fd2num(fd);
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	89 04 24             	mov    %eax,(%esp)
  801dad:	e8 ca f6 ff ff       	call   80147c <fd2num>
  801db2:	89 c3                	mov    %eax,%ebx
}
  801db4:	89 d8                	mov    %ebx,%eax
  801db6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801db9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dbc:	89 ec                	mov    %ebp,%esp
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    

00801dc0 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 14             	sub    $0x14,%esp
  801dc7:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801dc9:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801dcd:	7e 31                	jle    801e00 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801dcf:	8b 40 04             	mov    0x4(%eax),%eax
  801dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd6:	8d 43 10             	lea    0x10(%ebx),%eax
  801dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddd:	8b 03                	mov    (%ebx),%eax
  801ddf:	89 04 24             	mov    %eax,(%esp)
  801de2:	e8 e7 f8 ff ff       	call   8016ce <write>
		if (result > 0)
  801de7:	85 c0                	test   %eax,%eax
  801de9:	7e 03                	jle    801dee <writebuf+0x2e>
			b->result += result;
  801deb:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801dee:	3b 43 04             	cmp    0x4(%ebx),%eax
  801df1:	74 0d                	je     801e00 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801df3:	85 c0                	test   %eax,%eax
  801df5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfa:	0f 4f c2             	cmovg  %edx,%eax
  801dfd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801e00:	83 c4 14             	add    $0x14,%esp
  801e03:	5b                   	pop    %ebx
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    

00801e06 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801e18:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801e1f:	00 00 00 
	b.result = 0;
  801e22:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e29:	00 00 00 
	b.error = 1;
  801e2c:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801e33:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801e36:	8b 45 10             	mov    0x10(%ebp),%eax
  801e39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e44:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4e:	c7 04 24 c2 1e 80 00 	movl   $0x801ec2,(%esp)
  801e55:	e8 91 e7 ff ff       	call   8005eb <vprintfmt>
	if (b.idx > 0)
  801e5a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801e61:	7e 0b                	jle    801e6e <vfprintf+0x68>
		writebuf(&b);
  801e63:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e69:	e8 52 ff ff ff       	call   801dc0 <writebuf>

	return (b.result ? b.result : b.error);
  801e6e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e74:	85 c0                	test   %eax,%eax
  801e76:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801e85:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801e88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e9a:	e8 67 ff ff ff       	call   801e06 <vfprintf>
	va_end(ap);

	return cnt;
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801ea7:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801eaa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	89 04 24             	mov    %eax,(%esp)
  801ebb:	e8 46 ff ff ff       	call   801e06 <vfprintf>
	va_end(ap);

	return cnt;
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	53                   	push   %ebx
  801ec6:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801ec9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801ecc:	8b 43 04             	mov    0x4(%ebx),%eax
  801ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed2:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801ed6:	83 c0 01             	add    $0x1,%eax
  801ed9:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801edc:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ee1:	75 0e                	jne    801ef1 <putch+0x2f>
		writebuf(b);
  801ee3:	89 d8                	mov    %ebx,%eax
  801ee5:	e8 d6 fe ff ff       	call   801dc0 <writebuf>
		b->idx = 0;
  801eea:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801ef1:	83 c4 04             	add    $0x4,%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    
	...

00801f00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f06:	c7 44 24 04 32 32 80 	movl   $0x803232,0x4(%esp)
  801f0d:	00 
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	89 04 24             	mov    %eax,(%esp)
  801f14:	e8 a0 eb ff ff       	call   800ab9 <strcpy>
	return 0;
}
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 14             	sub    $0x14,%esp
  801f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f2a:	89 1c 24             	mov    %ebx,(%esp)
  801f2d:	e8 4e 0b 00 00       	call   802a80 <pageref>
  801f32:	89 c2                	mov    %eax,%edx
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	83 fa 01             	cmp    $0x1,%edx
  801f3c:	75 0b                	jne    801f49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f3e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 b1 02 00 00       	call   8021fa <nsipc_close>
	else
		return 0;
}
  801f49:	83 c4 14             	add    $0x14,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5d                   	pop    %ebp
  801f4e:	c3                   	ret    

00801f4f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f55:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f5c:	00 
  801f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f71:	89 04 24             	mov    %eax,(%esp)
  801f74:	e8 bd 02 00 00       	call   802236 <nsipc_send>
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f81:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f88:	00 
  801f89:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9d:	89 04 24             	mov    %eax,(%esp)
  801fa0:	e8 04 03 00 00       	call   8022a9 <nsipc_recv>
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	56                   	push   %esi
  801fab:	53                   	push   %ebx
  801fac:	83 ec 20             	sub    $0x20,%esp
  801faf:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb4:	89 04 24             	mov    %eax,(%esp)
  801fb7:	e8 eb f4 ff ff       	call   8014a7 <fd_alloc>
  801fbc:	89 c3                	mov    %eax,%ebx
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 21                	js     801fe3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fc2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fc9:	00 
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd8:	e8 21 f2 ff ff       	call   8011fe <sys_page_alloc>
  801fdd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	79 0a                	jns    801fed <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801fe3:	89 34 24             	mov    %esi,(%esp)
  801fe6:	e8 0f 02 00 00       	call   8021fa <nsipc_close>
		return r;
  801feb:	eb 28                	jmp    802015 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fed:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	89 04 24             	mov    %eax,(%esp)
  80200e:	e8 69 f4 ff ff       	call   80147c <fd2num>
  802013:	89 c3                	mov    %eax,%ebx
}
  802015:	89 d8                	mov    %ebx,%eax
  802017:	83 c4 20             	add    $0x20,%esp
  80201a:	5b                   	pop    %ebx
  80201b:	5e                   	pop    %esi
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    

0080201e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802024:	8b 45 10             	mov    0x10(%ebp),%eax
  802027:	89 44 24 08          	mov    %eax,0x8(%esp)
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 04 24             	mov    %eax,(%esp)
  802038:	e8 71 01 00 00       	call   8021ae <nsipc_socket>
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 05                	js     802046 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802041:	e8 61 ff ff ff       	call   801fa7 <alloc_sockfd>
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80204e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802051:	89 54 24 04          	mov    %edx,0x4(%esp)
  802055:	89 04 24             	mov    %eax,(%esp)
  802058:	e8 a3 f4 ff ff       	call   801500 <fd_lookup>
  80205d:	85 c0                	test   %eax,%eax
  80205f:	78 15                	js     802076 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802064:	8b 0a                	mov    (%edx),%ecx
  802066:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80206b:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  802071:	75 03                	jne    802076 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802073:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	e8 c2 ff ff ff       	call   802048 <fd2sockid>
  802086:	85 c0                	test   %eax,%eax
  802088:	78 0f                	js     802099 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80208a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 3f 01 00 00       	call   8021d8 <nsipc_listen>
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	e8 9f ff ff ff       	call   802048 <fd2sockid>
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	78 16                	js     8020c3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8020ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8020b0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 66 02 00 00       	call   802329 <nsipc_connect>
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	e8 75 ff ff ff       	call   802048 <fd2sockid>
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 0f                	js     8020e6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	e8 2e 01 00 00       	call   802214 <nsipc_shutdown>
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	e8 52 ff ff ff       	call   802048 <fd2sockid>
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	78 16                	js     802110 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8020fa:	8b 55 10             	mov    0x10(%ebp),%edx
  8020fd:	89 54 24 08          	mov    %edx,0x8(%esp)
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	89 54 24 04          	mov    %edx,0x4(%esp)
  802108:	89 04 24             	mov    %eax,(%esp)
  80210b:	e8 58 02 00 00       	call   802368 <nsipc_bind>
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	e8 28 ff ff ff       	call   802048 <fd2sockid>
  802120:	85 c0                	test   %eax,%eax
  802122:	78 1f                	js     802143 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802124:	8b 55 10             	mov    0x10(%ebp),%edx
  802127:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802132:	89 04 24             	mov    %eax,(%esp)
  802135:	e8 6d 02 00 00       	call   8023a7 <nsipc_accept>
  80213a:	85 c0                	test   %eax,%eax
  80213c:	78 05                	js     802143 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80213e:	e8 64 fe ff ff       	call   801fa7 <alloc_sockfd>
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    
  802145:	00 00                	add    %al,(%eax)
	...

00802148 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	53                   	push   %ebx
  80214c:	83 ec 14             	sub    $0x14,%esp
  80214f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802151:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802158:	75 11                	jne    80216b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80215a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802161:	e8 ee 07 00 00       	call   802954 <ipc_find_env>
  802166:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80216b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802172:	00 
  802173:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80217a:	00 
  80217b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80217f:	a1 04 50 80 00       	mov    0x805004,%eax
  802184:	89 04 24             	mov    %eax,(%esp)
  802187:	e8 fe 07 00 00       	call   80298a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80218c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802193:	00 
  802194:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80219b:	00 
  80219c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a3:	e8 4e 08 00 00       	call   8029f6 <ipc_recv>
}
  8021a8:	83 c4 14             	add    $0x14,%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    

008021ae <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8021bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bf:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8021cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021d1:	e8 72 ff ff ff       	call   802148 <nsipc>
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8021ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f3:	e8 50 ff ff ff       	call   802148 <nsipc>
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802208:	b8 04 00 00 00       	mov    $0x4,%eax
  80220d:	e8 36 ff ff ff       	call   802148 <nsipc>
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80222a:	b8 03 00 00 00       	mov    $0x3,%eax
  80222f:	e8 14 ff ff ff       	call   802148 <nsipc>
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	53                   	push   %ebx
  80223a:	83 ec 14             	sub    $0x14,%esp
  80223d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802248:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80224e:	7e 24                	jle    802274 <nsipc_send+0x3e>
  802250:	c7 44 24 0c 3e 32 80 	movl   $0x80323e,0xc(%esp)
  802257:	00 
  802258:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  80225f:	00 
  802260:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802267:	00 
  802268:	c7 04 24 4a 32 80 00 	movl   $0x80324a,(%esp)
  80226f:	e8 20 e1 ff ff       	call   800394 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802274:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802286:	e8 d4 e9 ff ff       	call   800c5f <memmove>
	nsipcbuf.send.req_size = size;
  80228b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802291:	8b 45 14             	mov    0x14(%ebp),%eax
  802294:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802299:	b8 08 00 00 00       	mov    $0x8,%eax
  80229e:	e8 a5 fe ff ff       	call   802148 <nsipc>
}
  8022a3:	83 c4 14             	add    $0x14,%esp
  8022a6:	5b                   	pop    %ebx
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 10             	sub    $0x10,%esp
  8022b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8022bc:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8022c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022ca:	b8 07 00 00 00       	mov    $0x7,%eax
  8022cf:	e8 74 fe ff ff       	call   802148 <nsipc>
  8022d4:	89 c3                	mov    %eax,%ebx
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	78 46                	js     802320 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022da:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022df:	7f 04                	jg     8022e5 <nsipc_recv+0x3c>
  8022e1:	39 c6                	cmp    %eax,%esi
  8022e3:	7d 24                	jge    802309 <nsipc_recv+0x60>
  8022e5:	c7 44 24 0c 56 32 80 	movl   $0x803256,0xc(%esp)
  8022ec:	00 
  8022ed:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  8022f4:	00 
  8022f5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8022fc:	00 
  8022fd:	c7 04 24 4a 32 80 00 	movl   $0x80324a,(%esp)
  802304:	e8 8b e0 ff ff       	call   800394 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802309:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802314:	00 
  802315:	8b 45 0c             	mov    0xc(%ebp),%eax
  802318:	89 04 24             	mov    %eax,(%esp)
  80231b:	e8 3f e9 ff ff       	call   800c5f <memmove>
	}

	return r;
}
  802320:	89 d8                	mov    %ebx,%eax
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	53                   	push   %ebx
  80232d:	83 ec 14             	sub    $0x14,%esp
  802330:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80233b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802342:	89 44 24 04          	mov    %eax,0x4(%esp)
  802346:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80234d:	e8 0d e9 ff ff       	call   800c5f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802352:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802358:	b8 05 00 00 00       	mov    $0x5,%eax
  80235d:	e8 e6 fd ff ff       	call   802148 <nsipc>
}
  802362:	83 c4 14             	add    $0x14,%esp
  802365:	5b                   	pop    %ebx
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	53                   	push   %ebx
  80236c:	83 ec 14             	sub    $0x14,%esp
  80236f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80237a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802381:	89 44 24 04          	mov    %eax,0x4(%esp)
  802385:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80238c:	e8 ce e8 ff ff       	call   800c5f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802391:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802397:	b8 02 00 00 00       	mov    $0x2,%eax
  80239c:	e8 a7 fd ff ff       	call   802148 <nsipc>
}
  8023a1:	83 c4 14             	add    $0x14,%esp
  8023a4:	5b                   	pop    %ebx
  8023a5:	5d                   	pop    %ebp
  8023a6:	c3                   	ret    

008023a7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 28             	sub    $0x28,%esp
  8023ad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023b0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023b3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023b6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023c1:	8b 07                	mov    (%edi),%eax
  8023c3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cd:	e8 76 fd ff ff       	call   802148 <nsipc>
  8023d2:	89 c6                	mov    %eax,%esi
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 22                	js     8023fa <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023d8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8023dd:	8b 03                	mov    (%ebx),%eax
  8023df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8023ea:	00 
  8023eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ee:	89 04 24             	mov    %eax,(%esp)
  8023f1:	e8 69 e8 ff ff       	call   800c5f <memmove>
		*addrlen = ret->ret_addrlen;
  8023f6:	8b 03                	mov    (%ebx),%eax
  8023f8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8023fa:	89 f0                	mov    %esi,%eax
  8023fc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023ff:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802402:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802405:	89 ec                	mov    %ebp,%esp
  802407:	5d                   	pop    %ebp
  802408:	c3                   	ret    
  802409:	00 00                	add    %al,(%eax)
	...

0080240c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 18             	sub    $0x18,%esp
  802412:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802415:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802418:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	89 04 24             	mov    %eax,(%esp)
  802421:	e8 66 f0 ff ff       	call   80148c <fd2data>
  802426:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802428:	c7 44 24 04 6b 32 80 	movl   $0x80326b,0x4(%esp)
  80242f:	00 
  802430:	89 34 24             	mov    %esi,(%esp)
  802433:	e8 81 e6 ff ff       	call   800ab9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802438:	8b 43 04             	mov    0x4(%ebx),%eax
  80243b:	2b 03                	sub    (%ebx),%eax
  80243d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802443:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80244a:	00 00 00 
	stat->st_dev = &devpipe;
  80244d:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802454:	40 80 00 
	return 0;
}
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
  80245c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80245f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802462:	89 ec                	mov    %ebp,%esp
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	53                   	push   %ebx
  80246a:	83 ec 14             	sub    $0x14,%esp
  80246d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802470:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247b:	e8 c2 ec ff ff       	call   801142 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802480:	89 1c 24             	mov    %ebx,(%esp)
  802483:	e8 04 f0 ff ff       	call   80148c <fd2data>
  802488:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802493:	e8 aa ec ff ff       	call   801142 <sys_page_unmap>
}
  802498:	83 c4 14             	add    $0x14,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    

0080249e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	57                   	push   %edi
  8024a2:	56                   	push   %esi
  8024a3:	53                   	push   %ebx
  8024a4:	83 ec 2c             	sub    $0x2c,%esp
  8024a7:	89 c7                	mov    %eax,%edi
  8024a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8024ac:	a1 20 54 80 00       	mov    0x805420,%eax
  8024b1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024b4:	89 3c 24             	mov    %edi,(%esp)
  8024b7:	e8 c4 05 00 00       	call   802a80 <pageref>
  8024bc:	89 c6                	mov    %eax,%esi
  8024be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c1:	89 04 24             	mov    %eax,(%esp)
  8024c4:	e8 b7 05 00 00       	call   802a80 <pageref>
  8024c9:	39 c6                	cmp    %eax,%esi
  8024cb:	0f 94 c0             	sete   %al
  8024ce:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8024d1:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8024d7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024da:	39 cb                	cmp    %ecx,%ebx
  8024dc:	75 08                	jne    8024e6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8024de:	83 c4 2c             	add    $0x2c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8024e6:	83 f8 01             	cmp    $0x1,%eax
  8024e9:	75 c1                	jne    8024ac <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024eb:	8b 52 58             	mov    0x58(%edx),%edx
  8024ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024fa:	c7 04 24 72 32 80 00 	movl   $0x803272,(%esp)
  802501:	e8 47 df ff ff       	call   80044d <cprintf>
  802506:	eb a4                	jmp    8024ac <_pipeisclosed+0xe>

00802508 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	57                   	push   %edi
  80250c:	56                   	push   %esi
  80250d:	53                   	push   %ebx
  80250e:	83 ec 1c             	sub    $0x1c,%esp
  802511:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802514:	89 34 24             	mov    %esi,(%esp)
  802517:	e8 70 ef ff ff       	call   80148c <fd2data>
  80251c:	89 c3                	mov    %eax,%ebx
  80251e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802523:	eb 48                	jmp    80256d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802525:	89 da                	mov    %ebx,%edx
  802527:	89 f0                	mov    %esi,%eax
  802529:	e8 70 ff ff ff       	call   80249e <_pipeisclosed>
  80252e:	85 c0                	test   %eax,%eax
  802530:	74 07                	je     802539 <devpipe_write+0x31>
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	eb 3b                	jmp    802574 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802539:	e8 1f ed ff ff       	call   80125d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80253e:	8b 43 04             	mov    0x4(%ebx),%eax
  802541:	8b 13                	mov    (%ebx),%edx
  802543:	83 c2 20             	add    $0x20,%edx
  802546:	39 d0                	cmp    %edx,%eax
  802548:	73 db                	jae    802525 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80254a:	89 c2                	mov    %eax,%edx
  80254c:	c1 fa 1f             	sar    $0x1f,%edx
  80254f:	c1 ea 1b             	shr    $0x1b,%edx
  802552:	01 d0                	add    %edx,%eax
  802554:	83 e0 1f             	and    $0x1f,%eax
  802557:	29 d0                	sub    %edx,%eax
  802559:	89 c2                	mov    %eax,%edx
  80255b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80255e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802562:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802566:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80256a:	83 c7 01             	add    $0x1,%edi
  80256d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802570:	72 cc                	jb     80253e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802572:	89 f8                	mov    %edi,%eax
}
  802574:	83 c4 1c             	add    $0x1c,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5f                   	pop    %edi
  80257a:	5d                   	pop    %ebp
  80257b:	c3                   	ret    

0080257c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 28             	sub    $0x28,%esp
  802582:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802585:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802588:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80258b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80258e:	89 3c 24             	mov    %edi,(%esp)
  802591:	e8 f6 ee ff ff       	call   80148c <fd2data>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80259d:	eb 48                	jmp    8025e7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80259f:	85 f6                	test   %esi,%esi
  8025a1:	74 04                	je     8025a7 <devpipe_read+0x2b>
				return i;
  8025a3:	89 f0                	mov    %esi,%eax
  8025a5:	eb 47                	jmp    8025ee <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025a7:	89 da                	mov    %ebx,%edx
  8025a9:	89 f8                	mov    %edi,%eax
  8025ab:	e8 ee fe ff ff       	call   80249e <_pipeisclosed>
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 07                	je     8025bb <devpipe_read+0x3f>
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	eb 33                	jmp    8025ee <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025bb:	e8 9d ec ff ff       	call   80125d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025c0:	8b 03                	mov    (%ebx),%eax
  8025c2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025c5:	74 d8                	je     80259f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	c1 fa 1f             	sar    $0x1f,%edx
  8025cc:	c1 ea 1b             	shr    $0x1b,%edx
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	83 e0 1f             	and    $0x1f,%eax
  8025d4:	29 d0                	sub    %edx,%eax
  8025d6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025de:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8025e1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025e4:	83 c6 01             	add    $0x1,%esi
  8025e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ea:	72 d4                	jb     8025c0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025ec:	89 f0                	mov    %esi,%eax
}
  8025ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025f7:	89 ec                	mov    %ebp,%esp
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    

008025fb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802601:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802604:	89 44 24 04          	mov    %eax,0x4(%esp)
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	89 04 24             	mov    %eax,(%esp)
  80260e:	e8 ed ee ff ff       	call   801500 <fd_lookup>
  802613:	85 c0                	test   %eax,%eax
  802615:	78 15                	js     80262c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	89 04 24             	mov    %eax,(%esp)
  80261d:	e8 6a ee ff ff       	call   80148c <fd2data>
	return _pipeisclosed(fd, p);
  802622:	89 c2                	mov    %eax,%edx
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	e8 72 fe ff ff       	call   80249e <_pipeisclosed>
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 48             	sub    $0x48,%esp
  802634:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802637:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80263a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80263d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802643:	89 04 24             	mov    %eax,(%esp)
  802646:	e8 5c ee ff ff       	call   8014a7 <fd_alloc>
  80264b:	89 c3                	mov    %eax,%ebx
  80264d:	85 c0                	test   %eax,%eax
  80264f:	0f 88 42 01 00 00    	js     802797 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802655:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80265c:	00 
  80265d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802660:	89 44 24 04          	mov    %eax,0x4(%esp)
  802664:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266b:	e8 8e eb ff ff       	call   8011fe <sys_page_alloc>
  802670:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802672:	85 c0                	test   %eax,%eax
  802674:	0f 88 1d 01 00 00    	js     802797 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80267a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80267d:	89 04 24             	mov    %eax,(%esp)
  802680:	e8 22 ee ff ff       	call   8014a7 <fd_alloc>
  802685:	89 c3                	mov    %eax,%ebx
  802687:	85 c0                	test   %eax,%eax
  802689:	0f 88 f5 00 00 00    	js     802784 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802696:	00 
  802697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a5:	e8 54 eb ff ff       	call   8011fe <sys_page_alloc>
  8026aa:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	0f 88 d0 00 00 00    	js     802784 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	89 04 24             	mov    %eax,(%esp)
  8026ba:	e8 cd ed ff ff       	call   80148c <fd2data>
  8026bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026c8:	00 
  8026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d4:	e8 25 eb ff ff       	call   8011fe <sys_page_alloc>
  8026d9:	89 c3                	mov    %eax,%ebx
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	0f 88 8e 00 00 00    	js     802771 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e6:	89 04 24             	mov    %eax,(%esp)
  8026e9:	e8 9e ed ff ff       	call   80148c <fd2data>
  8026ee:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026f5:	00 
  8026f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802701:	00 
  802702:	89 74 24 04          	mov    %esi,0x4(%esp)
  802706:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80270d:	e8 8e ea ff ff       	call   8011a0 <sys_page_map>
  802712:	89 c3                	mov    %eax,%ebx
  802714:	85 c0                	test   %eax,%eax
  802716:	78 49                	js     802761 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802718:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  80271d:	8b 08                	mov    (%eax),%ecx
  80271f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802722:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802724:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802727:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80272e:	8b 10                	mov    (%eax),%edx
  802730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802733:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802735:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802738:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	89 04 24             	mov    %eax,(%esp)
  802745:	e8 32 ed ff ff       	call   80147c <fd2num>
  80274a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80274c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274f:	89 04 24             	mov    %eax,(%esp)
  802752:	e8 25 ed ff ff       	call   80147c <fd2num>
  802757:	89 47 04             	mov    %eax,0x4(%edi)
  80275a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80275f:	eb 36                	jmp    802797 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802761:	89 74 24 04          	mov    %esi,0x4(%esp)
  802765:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276c:	e8 d1 e9 ff ff       	call   801142 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802771:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802774:	89 44 24 04          	mov    %eax,0x4(%esp)
  802778:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80277f:	e8 be e9 ff ff       	call   801142 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802792:	e8 ab e9 ff ff       	call   801142 <sys_page_unmap>
    err:
	return r;
}
  802797:	89 d8                	mov    %ebx,%eax
  802799:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80279c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80279f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8027a2:	89 ec                	mov    %ebp,%esp
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
	...

008027b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b8:	5d                   	pop    %ebp
  8027b9:	c3                   	ret    

008027ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027c0:	c7 44 24 04 8a 32 80 	movl   $0x80328a,0x4(%esp)
  8027c7:	00 
  8027c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cb:	89 04 24             	mov    %eax,(%esp)
  8027ce:	e8 e6 e2 ff ff       	call   800ab9 <strcpy>
	return 0;
}
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	57                   	push   %edi
  8027de:	56                   	push   %esi
  8027df:	53                   	push   %ebx
  8027e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8027e6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027f1:	eb 34                	jmp    802827 <devcons_write+0x4d>
		m = n - tot;
  8027f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027f6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8027f8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8027fe:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802803:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802806:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80280a:	03 45 0c             	add    0xc(%ebp),%eax
  80280d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802811:	89 3c 24             	mov    %edi,(%esp)
  802814:	e8 46 e4 ff ff       	call   800c5f <memmove>
		sys_cputs(buf, m);
  802819:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80281d:	89 3c 24             	mov    %edi,(%esp)
  802820:	e8 4b e6 ff ff       	call   800e70 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802825:	01 de                	add    %ebx,%esi
  802827:	89 f0                	mov    %esi,%eax
  802829:	3b 75 10             	cmp    0x10(%ebp),%esi
  80282c:	72 c5                	jb     8027f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80282e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802834:	5b                   	pop    %ebx
  802835:	5e                   	pop    %esi
  802836:	5f                   	pop    %edi
  802837:	5d                   	pop    %ebp
  802838:	c3                   	ret    

00802839 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802845:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80284c:	00 
  80284d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802850:	89 04 24             	mov    %eax,(%esp)
  802853:	e8 18 e6 ff ff       	call   800e70 <sys_cputs>
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802860:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802864:	75 07                	jne    80286d <devcons_read+0x13>
  802866:	eb 28                	jmp    802890 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802868:	e8 f0 e9 ff ff       	call   80125d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80286d:	8d 76 00             	lea    0x0(%esi),%esi
  802870:	e8 c7 e5 ff ff       	call   800e3c <sys_cgetc>
  802875:	85 c0                	test   %eax,%eax
  802877:	74 ef                	je     802868 <devcons_read+0xe>
  802879:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80287b:	85 c0                	test   %eax,%eax
  80287d:	78 16                	js     802895 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80287f:	83 f8 04             	cmp    $0x4,%eax
  802882:	74 0c                	je     802890 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802884:	8b 45 0c             	mov    0xc(%ebp),%eax
  802887:	88 10                	mov    %dl,(%eax)
  802889:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80288e:	eb 05                	jmp    802895 <devcons_read+0x3b>
  802890:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
  80289a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80289d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a0:	89 04 24             	mov    %eax,(%esp)
  8028a3:	e8 ff eb ff ff       	call   8014a7 <fd_alloc>
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	78 3f                	js     8028eb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028ac:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028b3:	00 
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c2:	e8 37 e9 ff ff       	call   8011fe <sys_page_alloc>
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	78 20                	js     8028eb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028cb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	89 04 24             	mov    %eax,(%esp)
  8028e6:	e8 91 eb ff ff       	call   80147c <fd2num>
}
  8028eb:	c9                   	leave  
  8028ec:	c3                   	ret    

008028ed <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
  8028f0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	89 04 24             	mov    %eax,(%esp)
  802900:	e8 fb eb ff ff       	call   801500 <fd_lookup>
  802905:	85 c0                	test   %eax,%eax
  802907:	78 11                	js     80291a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  802914:	0f 94 c0             	sete   %al
  802917:	0f b6 c0             	movzbl %al,%eax
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802922:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802929:	00 
  80292a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80292d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802931:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802938:	e8 1a ee ff ff       	call   801757 <read>
	if (r < 0)
  80293d:	85 c0                	test   %eax,%eax
  80293f:	78 0f                	js     802950 <getchar+0x34>
		return r;
	if (r < 1)
  802941:	85 c0                	test   %eax,%eax
  802943:	7f 07                	jg     80294c <getchar+0x30>
  802945:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80294a:	eb 04                	jmp    802950 <getchar+0x34>
		return -E_EOF;
	return c;
  80294c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    
	...

00802954 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
  802957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80295f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802962:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802968:	8b 12                	mov    (%edx),%edx
  80296a:	39 ca                	cmp    %ecx,%edx
  80296c:	75 0c                	jne    80297a <ipc_find_env+0x26>
			return envs[i].env_id;
  80296e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802971:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	eb 0e                	jmp    802988 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80297a:	83 c0 01             	add    $0x1,%eax
  80297d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802982:	75 db                	jne    80295f <ipc_find_env+0xb>
  802984:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802988:	5d                   	pop    %ebp
  802989:	c3                   	ret    

0080298a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	57                   	push   %edi
  80298e:	56                   	push   %esi
  80298f:	53                   	push   %ebx
  802990:	83 ec 2c             	sub    $0x2c,%esp
  802993:	8b 75 08             	mov    0x8(%ebp),%esi
  802996:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802999:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  80299c:	85 db                	test   %ebx,%ebx
  80299e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029a3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8029a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8029a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029b5:	89 34 24             	mov    %esi,(%esp)
  8029b8:	e8 33 e6 ff ff       	call   800ff0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8029bd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029c0:	74 e4                	je     8029a6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 28                	je     8029ee <ipc_send+0x64>
  8029c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8029ca:	c7 44 24 0c b3 32 80 	movl   $0x8032b3,0xc(%esp)
  8029d1:	00 
  8029d2:	c7 44 24 08 96 32 80 	movl   $0x803296,0x8(%esp)
  8029d9:	00 
  8029da:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8029e1:	00 
  8029e2:	c7 04 24 a9 32 80 00 	movl   $0x8032a9,(%esp)
  8029e9:	e8 a6 d9 ff ff       	call   800394 <_panic>
	//if(!ret) sys_yield();
}
  8029ee:	83 c4 2c             	add    $0x2c,%esp
  8029f1:	5b                   	pop    %ebx
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    

008029f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	83 ec 28             	sub    $0x28,%esp
  8029fc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8029ff:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a02:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a05:	8b 75 08             	mov    0x8(%ebp),%esi
  802a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a15:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a18:	89 04 24             	mov    %eax,(%esp)
  802a1b:	e8 73 e5 ff ff       	call   800f93 <sys_ipc_recv>
  802a20:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802a22:	e8 6a e8 ff ff       	call   801291 <sys_getenvid>
  802a27:	25 ff 03 00 00       	and    $0x3ff,%eax
  802a2c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802a2f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a34:	a3 20 54 80 00       	mov    %eax,0x805420
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802a39:	85 f6                	test   %esi,%esi
  802a3b:	74 0e                	je     802a4b <ipc_recv+0x55>
  802a3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a42:	85 db                	test   %ebx,%ebx
  802a44:	75 03                	jne    802a49 <ipc_recv+0x53>
  802a46:	8b 50 74             	mov    0x74(%eax),%edx
  802a49:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802a4b:	85 ff                	test   %edi,%edi
  802a4d:	74 13                	je     802a62 <ipc_recv+0x6c>
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	85 db                	test   %ebx,%ebx
  802a56:	75 08                	jne    802a60 <ipc_recv+0x6a>
  802a58:	a1 20 54 80 00       	mov    0x805420,%eax
  802a5d:	8b 40 78             	mov    0x78(%eax),%eax
  802a60:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802a62:	85 db                	test   %ebx,%ebx
  802a64:	75 08                	jne    802a6e <ipc_recv+0x78>
  802a66:	a1 20 54 80 00       	mov    0x805420,%eax
  802a6b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802a6e:	89 d8                	mov    %ebx,%eax
  802a70:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a73:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a76:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a79:	89 ec                	mov    %ebp,%esp
  802a7b:	5d                   	pop    %ebp
  802a7c:	c3                   	ret    
  802a7d:	00 00                	add    %al,(%eax)
	...

00802a80 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	89 c2                	mov    %eax,%edx
  802a88:	c1 ea 16             	shr    $0x16,%edx
  802a8b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a92:	f6 c2 01             	test   $0x1,%dl
  802a95:	74 20                	je     802ab7 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a97:	c1 e8 0c             	shr    $0xc,%eax
  802a9a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802aa1:	a8 01                	test   $0x1,%al
  802aa3:	74 12                	je     802ab7 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802aa5:	c1 e8 0c             	shr    $0xc,%eax
  802aa8:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802aad:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802ab2:	0f b7 c0             	movzwl %ax,%eax
  802ab5:	eb 05                	jmp    802abc <pageref+0x3c>
  802ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abc:	5d                   	pop    %ebp
  802abd:	c3                   	ret    
	...

00802ac0 <__udivdi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
  802ac3:	57                   	push   %edi
  802ac4:	56                   	push   %esi
  802ac5:	83 ec 10             	sub    $0x10,%esp
  802ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	8b 75 10             	mov    0x10(%ebp),%esi
  802ad1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802ad9:	75 35                	jne    802b10 <__udivdi3+0x50>
  802adb:	39 fe                	cmp    %edi,%esi
  802add:	77 61                	ja     802b40 <__udivdi3+0x80>
  802adf:	85 f6                	test   %esi,%esi
  802ae1:	75 0b                	jne    802aee <__udivdi3+0x2e>
  802ae3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae8:	31 d2                	xor    %edx,%edx
  802aea:	f7 f6                	div    %esi
  802aec:	89 c6                	mov    %eax,%esi
  802aee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802af1:	31 d2                	xor    %edx,%edx
  802af3:	89 f8                	mov    %edi,%eax
  802af5:	f7 f6                	div    %esi
  802af7:	89 c7                	mov    %eax,%edi
  802af9:	89 c8                	mov    %ecx,%eax
  802afb:	f7 f6                	div    %esi
  802afd:	89 c1                	mov    %eax,%ecx
  802aff:	89 fa                	mov    %edi,%edx
  802b01:	89 c8                	mov    %ecx,%eax
  802b03:	83 c4 10             	add    $0x10,%esp
  802b06:	5e                   	pop    %esi
  802b07:	5f                   	pop    %edi
  802b08:	5d                   	pop    %ebp
  802b09:	c3                   	ret    
  802b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b10:	39 f8                	cmp    %edi,%eax
  802b12:	77 1c                	ja     802b30 <__udivdi3+0x70>
  802b14:	0f bd d0             	bsr    %eax,%edx
  802b17:	83 f2 1f             	xor    $0x1f,%edx
  802b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802b1d:	75 39                	jne    802b58 <__udivdi3+0x98>
  802b1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802b22:	0f 86 a0 00 00 00    	jbe    802bc8 <__udivdi3+0x108>
  802b28:	39 f8                	cmp    %edi,%eax
  802b2a:	0f 82 98 00 00 00    	jb     802bc8 <__udivdi3+0x108>
  802b30:	31 ff                	xor    %edi,%edi
  802b32:	31 c9                	xor    %ecx,%ecx
  802b34:	89 c8                	mov    %ecx,%eax
  802b36:	89 fa                	mov    %edi,%edx
  802b38:	83 c4 10             	add    $0x10,%esp
  802b3b:	5e                   	pop    %esi
  802b3c:	5f                   	pop    %edi
  802b3d:	5d                   	pop    %ebp
  802b3e:	c3                   	ret    
  802b3f:	90                   	nop
  802b40:	89 d1                	mov    %edx,%ecx
  802b42:	89 fa                	mov    %edi,%edx
  802b44:	89 c8                	mov    %ecx,%eax
  802b46:	31 ff                	xor    %edi,%edi
  802b48:	f7 f6                	div    %esi
  802b4a:	89 c1                	mov    %eax,%ecx
  802b4c:	89 fa                	mov    %edi,%edx
  802b4e:	89 c8                	mov    %ecx,%eax
  802b50:	83 c4 10             	add    $0x10,%esp
  802b53:	5e                   	pop    %esi
  802b54:	5f                   	pop    %edi
  802b55:	5d                   	pop    %ebp
  802b56:	c3                   	ret    
  802b57:	90                   	nop
  802b58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b5c:	89 f2                	mov    %esi,%edx
  802b5e:	d3 e0                	shl    %cl,%eax
  802b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b63:	b8 20 00 00 00       	mov    $0x20,%eax
  802b68:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b6b:	89 c1                	mov    %eax,%ecx
  802b6d:	d3 ea                	shr    %cl,%edx
  802b6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b73:	0b 55 ec             	or     -0x14(%ebp),%edx
  802b76:	d3 e6                	shl    %cl,%esi
  802b78:	89 c1                	mov    %eax,%ecx
  802b7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802b7d:	89 fe                	mov    %edi,%esi
  802b7f:	d3 ee                	shr    %cl,%esi
  802b81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b85:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8b:	d3 e7                	shl    %cl,%edi
  802b8d:	89 c1                	mov    %eax,%ecx
  802b8f:	d3 ea                	shr    %cl,%edx
  802b91:	09 d7                	or     %edx,%edi
  802b93:	89 f2                	mov    %esi,%edx
  802b95:	89 f8                	mov    %edi,%eax
  802b97:	f7 75 ec             	divl   -0x14(%ebp)
  802b9a:	89 d6                	mov    %edx,%esi
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	f7 65 e8             	mull   -0x18(%ebp)
  802ba1:	39 d6                	cmp    %edx,%esi
  802ba3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ba6:	72 30                	jb     802bd8 <__udivdi3+0x118>
  802ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802baf:	d3 e2                	shl    %cl,%edx
  802bb1:	39 c2                	cmp    %eax,%edx
  802bb3:	73 05                	jae    802bba <__udivdi3+0xfa>
  802bb5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802bb8:	74 1e                	je     802bd8 <__udivdi3+0x118>
  802bba:	89 f9                	mov    %edi,%ecx
  802bbc:	31 ff                	xor    %edi,%edi
  802bbe:	e9 71 ff ff ff       	jmp    802b34 <__udivdi3+0x74>
  802bc3:	90                   	nop
  802bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	31 ff                	xor    %edi,%edi
  802bca:	b9 01 00 00 00       	mov    $0x1,%ecx
  802bcf:	e9 60 ff ff ff       	jmp    802b34 <__udivdi3+0x74>
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802bdb:	31 ff                	xor    %edi,%edi
  802bdd:	89 c8                	mov    %ecx,%eax
  802bdf:	89 fa                	mov    %edi,%edx
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	5e                   	pop    %esi
  802be5:	5f                   	pop    %edi
  802be6:	5d                   	pop    %ebp
  802be7:	c3                   	ret    
	...

00802bf0 <__umoddi3>:
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	57                   	push   %edi
  802bf4:	56                   	push   %esi
  802bf5:	83 ec 20             	sub    $0x20,%esp
  802bf8:	8b 55 14             	mov    0x14(%ebp),%edx
  802bfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bfe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802c01:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c04:	85 d2                	test   %edx,%edx
  802c06:	89 c8                	mov    %ecx,%eax
  802c08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802c0b:	75 13                	jne    802c20 <__umoddi3+0x30>
  802c0d:	39 f7                	cmp    %esi,%edi
  802c0f:	76 3f                	jbe    802c50 <__umoddi3+0x60>
  802c11:	89 f2                	mov    %esi,%edx
  802c13:	f7 f7                	div    %edi
  802c15:	89 d0                	mov    %edx,%eax
  802c17:	31 d2                	xor    %edx,%edx
  802c19:	83 c4 20             	add    $0x20,%esp
  802c1c:	5e                   	pop    %esi
  802c1d:	5f                   	pop    %edi
  802c1e:	5d                   	pop    %ebp
  802c1f:	c3                   	ret    
  802c20:	39 f2                	cmp    %esi,%edx
  802c22:	77 4c                	ja     802c70 <__umoddi3+0x80>
  802c24:	0f bd ca             	bsr    %edx,%ecx
  802c27:	83 f1 1f             	xor    $0x1f,%ecx
  802c2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802c2d:	75 51                	jne    802c80 <__umoddi3+0x90>
  802c2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802c32:	0f 87 e0 00 00 00    	ja     802d18 <__umoddi3+0x128>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	29 f8                	sub    %edi,%eax
  802c3d:	19 d6                	sbb    %edx,%esi
  802c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	89 f2                	mov    %esi,%edx
  802c47:	83 c4 20             	add    $0x20,%esp
  802c4a:	5e                   	pop    %esi
  802c4b:	5f                   	pop    %edi
  802c4c:	5d                   	pop    %ebp
  802c4d:	c3                   	ret    
  802c4e:	66 90                	xchg   %ax,%ax
  802c50:	85 ff                	test   %edi,%edi
  802c52:	75 0b                	jne    802c5f <__umoddi3+0x6f>
  802c54:	b8 01 00 00 00       	mov    $0x1,%eax
  802c59:	31 d2                	xor    %edx,%edx
  802c5b:	f7 f7                	div    %edi
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	89 f0                	mov    %esi,%eax
  802c61:	31 d2                	xor    %edx,%edx
  802c63:	f7 f7                	div    %edi
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	f7 f7                	div    %edi
  802c6a:	eb a9                	jmp    802c15 <__umoddi3+0x25>
  802c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c70:	89 c8                	mov    %ecx,%eax
  802c72:	89 f2                	mov    %esi,%edx
  802c74:	83 c4 20             	add    $0x20,%esp
  802c77:	5e                   	pop    %esi
  802c78:	5f                   	pop    %edi
  802c79:	5d                   	pop    %ebp
  802c7a:	c3                   	ret    
  802c7b:	90                   	nop
  802c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c84:	d3 e2                	shl    %cl,%edx
  802c86:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c89:	ba 20 00 00 00       	mov    $0x20,%edx
  802c8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802c91:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c98:	89 fa                	mov    %edi,%edx
  802c9a:	d3 ea                	shr    %cl,%edx
  802c9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ca0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ca3:	d3 e7                	shl    %cl,%edi
  802ca5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ca9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802cac:	89 f2                	mov    %esi,%edx
  802cae:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802cb1:	89 c7                	mov    %eax,%edi
  802cb3:	d3 ea                	shr    %cl,%edx
  802cb5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802cbc:	89 c2                	mov    %eax,%edx
  802cbe:	d3 e6                	shl    %cl,%esi
  802cc0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cc4:	d3 ea                	shr    %cl,%edx
  802cc6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cca:	09 d6                	or     %edx,%esi
  802ccc:	89 f0                	mov    %esi,%eax
  802cce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802cd1:	d3 e7                	shl    %cl,%edi
  802cd3:	89 f2                	mov    %esi,%edx
  802cd5:	f7 75 f4             	divl   -0xc(%ebp)
  802cd8:	89 d6                	mov    %edx,%esi
  802cda:	f7 65 e8             	mull   -0x18(%ebp)
  802cdd:	39 d6                	cmp    %edx,%esi
  802cdf:	72 2b                	jb     802d0c <__umoddi3+0x11c>
  802ce1:	39 c7                	cmp    %eax,%edi
  802ce3:	72 23                	jb     802d08 <__umoddi3+0x118>
  802ce5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ce9:	29 c7                	sub    %eax,%edi
  802ceb:	19 d6                	sbb    %edx,%esi
  802ced:	89 f0                	mov    %esi,%eax
  802cef:	89 f2                	mov    %esi,%edx
  802cf1:	d3 ef                	shr    %cl,%edi
  802cf3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cf7:	d3 e0                	shl    %cl,%eax
  802cf9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cfd:	09 f8                	or     %edi,%eax
  802cff:	d3 ea                	shr    %cl,%edx
  802d01:	83 c4 20             	add    $0x20,%esp
  802d04:	5e                   	pop    %esi
  802d05:	5f                   	pop    %edi
  802d06:	5d                   	pop    %ebp
  802d07:	c3                   	ret    
  802d08:	39 d6                	cmp    %edx,%esi
  802d0a:	75 d9                	jne    802ce5 <__umoddi3+0xf5>
  802d0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802d0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802d12:	eb d1                	jmp    802ce5 <__umoddi3+0xf5>
  802d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d18:	39 f2                	cmp    %esi,%edx
  802d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d20:	0f 82 12 ff ff ff    	jb     802c38 <__umoddi3+0x48>
  802d26:	e9 17 ff ff ff       	jmp    802c42 <__umoddi3+0x52>
