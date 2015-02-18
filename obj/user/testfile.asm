
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 3f 07 00 00       	call   800770 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800041:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800048:	e8 ac 0e 00 00       	call   800ef9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004d:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800053:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80005a:	e8 05 17 00 00       	call   801764 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800066:	00 
  800067:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800076:	00 
  800077:	89 04 24             	mov    %eax,(%esp)
  80007a:	e8 1b 17 00 00       	call   80179a <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008e:	cc 
  80008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800096:	e8 6b 17 00 00       	call   801806 <ipc_recv>
}
  80009b:	83 c4 14             	add    $0x14,%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5d                   	pop    %ebp
  8000a0:	c3                   	ret    

008000a1 <umain>:

void
umain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	57                   	push   %edi
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	81 ec dc 02 00 00    	sub    $0x2dc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b2:	b8 00 2f 80 00       	mov    $0x802f00,%eax
  8000b7:	e8 78 ff ff ff       	call   800034 <xopen>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	79 25                	jns    8000e5 <umain+0x44>
  8000c0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c3:	74 2c                	je     8000f1 <umain+0x50>
		panic("serve_open /not-found: %e", r);
  8000c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c9:	c7 44 24 08 0b 2f 80 	movl   $0x802f0b,0x8(%esp)
  8000d0:	00 
  8000d1:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d8:	00 
  8000d9:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8000e0:	e8 ef 06 00 00       	call   8007d4 <_panic>
	else if (r >= 0)
		cprintf("serve_open /not-found succeeded!\n");
  8000e5:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  8000ec:	e8 9c 07 00 00       	call   80088d <cprintf>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f6:	b8 35 2f 80 00       	mov    $0x802f35,%eax
  8000fb:	e8 34 ff ff ff       	call   800034 <xopen>
  800100:	85 c0                	test   %eax,%eax
  800102:	79 20                	jns    800124 <umain+0x83>
		panic("serve_open /newmotd: %e", r);
  800104:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800108:	c7 44 24 08 3e 2f 80 	movl   $0x802f3e,0x8(%esp)
  80010f:	00 
  800110:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800117:	00 
  800118:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80011f:	e8 b0 06 00 00       	call   8007d4 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800124:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80012b:	75 12                	jne    80013f <umain+0x9e>
  80012d:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800134:	75 09                	jne    80013f <umain+0x9e>
  800136:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80013d:	74 1c                	je     80015b <umain+0xba>
		panic("serve_open did not fill struct Fd correctly\n");
  80013f:	c7 44 24 08 e4 30 80 	movl   $0x8030e4,0x8(%esp)
  800146:	00 
  800147:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80014e:	00 
  80014f:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800156:	e8 79 06 00 00       	call   8007d4 <_panic>
	cprintf("serve_open is good\n");
  80015b:	c7 04 24 56 2f 80 00 	movl   $0x802f56,(%esp)
  800162:	e8 26 07 00 00       	call   80088d <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800167:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80016d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800171:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800178:	ff 15 1c 40 80 00    	call   *0x80401c
  80017e:	85 c0                	test   %eax,%eax
  800180:	79 20                	jns    8001a2 <umain+0x101>
		panic("file_stat: %e", r);
  800182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800186:	c7 44 24 08 6a 2f 80 	movl   $0x802f6a,0x8(%esp)
  80018d:	00 
  80018e:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  800195:	00 
  800196:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80019d:	e8 32 06 00 00       	call   8007d4 <_panic>
	if (strlen(msg) != st.st_size)
  8001a2:	a1 00 40 80 00       	mov    0x804000,%eax
  8001a7:	89 04 24             	mov    %eax,(%esp)
  8001aa:	e8 11 0d 00 00       	call   800ec0 <strlen>
  8001af:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001b2:	74 34                	je     8001e8 <umain+0x147>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001b4:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b9:	89 04 24             	mov    %eax,(%esp)
  8001bc:	e8 ff 0c 00 00       	call   800ec0 <strlen>
  8001c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001cc:	c7 44 24 08 14 31 80 	movl   $0x803114,0x8(%esp)
  8001d3:	00 
  8001d4:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001db:	00 
  8001dc:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8001e3:	e8 ec 05 00 00       	call   8007d4 <_panic>
	cprintf("file_stat is good\n");
  8001e8:	c7 04 24 78 2f 80 00 	movl   $0x802f78,(%esp)
  8001ef:	e8 99 06 00 00       	call   80088d <cprintf>

	memset(buf, 0, sizeof buf);
  8001f4:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001fb:	00 
  8001fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800203:	00 
  800204:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80020a:	89 1c 24             	mov    %ebx,(%esp)
  80020d:	e8 2e 0e 00 00       	call   801040 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800212:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800219:	00 
  80021a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80021e:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800225:	ff 15 10 40 80 00    	call   *0x804010
  80022b:	85 c0                	test   %eax,%eax
  80022d:	79 20                	jns    80024f <umain+0x1ae>
		panic("file_read: %e", r);
  80022f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800233:	c7 44 24 08 8b 2f 80 	movl   $0x802f8b,0x8(%esp)
  80023a:	00 
  80023b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800242:	00 
  800243:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80024a:	e8 85 05 00 00       	call   8007d4 <_panic>
	if (strcmp(buf, msg) != 0)
  80024f:	a1 00 40 80 00       	mov    0x804000,%eax
  800254:	89 44 24 04          	mov    %eax,0x4(%esp)
  800258:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 3e 0d 00 00       	call   800fa4 <strcmp>
  800266:	85 c0                	test   %eax,%eax
  800268:	74 1c                	je     800286 <umain+0x1e5>
		panic("file_read returned wrong data");
  80026a:	c7 44 24 08 99 2f 80 	movl   $0x802f99,0x8(%esp)
  800271:	00 
  800272:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800279:	00 
  80027a:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800281:	e8 4e 05 00 00       	call   8007d4 <_panic>
	cprintf("file_read is good\n");
  800286:	c7 04 24 b7 2f 80 00 	movl   $0x802fb7,(%esp)
  80028d:	e8 fb 05 00 00       	call   80088d <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  800292:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800299:	ff 15 18 40 80 00    	call   *0x804018
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	79 20                	jns    8002c3 <umain+0x222>
		panic("file_close: %e", r);
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	c7 44 24 08 ca 2f 80 	movl   $0x802fca,0x8(%esp)
  8002ae:	00 
  8002af:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8002b6:	00 
  8002b7:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8002be:	e8 11 05 00 00       	call   8007d4 <_panic>
	cprintf("file_close is good\n");
  8002c3:	c7 04 24 d9 2f 80 00 	movl   $0x802fd9,(%esp)
  8002ca:	e8 be 05 00 00       	call   80088d <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002cf:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8002d4:	8b 10                	mov    (%eax),%edx
  8002d6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8002d9:	8b 50 04             	mov    0x4(%eax),%edx
  8002dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8002df:	8b 50 08             	mov    0x8(%eax),%edx
  8002e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8002e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8002eb:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  8002f2:	cc 
  8002f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002fa:	e8 83 12 00 00       	call   801582 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8002ff:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800306:	00 
  800307:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800311:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	ff 15 10 40 80 00    	call   *0x804010
  80031d:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800320:	74 20                	je     800342 <umain+0x2a1>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800322:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800326:	c7 44 24 08 3c 31 80 	movl   $0x80313c,0x8(%esp)
  80032d:	00 
  80032e:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800335:	00 
  800336:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80033d:	e8 92 04 00 00       	call   8007d4 <_panic>
	cprintf("stale fileid is good\n");
  800342:	c7 04 24 ed 2f 80 00 	movl   $0x802fed,(%esp)
  800349:	e8 3f 05 00 00       	call   80088d <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80034e:	ba 02 01 00 00       	mov    $0x102,%edx
  800353:	b8 03 30 80 00       	mov    $0x803003,%eax
  800358:	e8 d7 fc ff ff       	call   800034 <xopen>
  80035d:	85 c0                	test   %eax,%eax
  80035f:	79 20                	jns    800381 <umain+0x2e0>
		panic("serve_open /new-file: %e", r);
  800361:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800365:	c7 44 24 08 0d 30 80 	movl   $0x80300d,0x8(%esp)
  80036c:	00 
  80036d:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800374:	00 
  800375:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80037c:	e8 53 04 00 00       	call   8007d4 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800381:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  800387:	a1 00 40 80 00       	mov    0x804000,%eax
  80038c:	89 04 24             	mov    %eax,(%esp)
  80038f:	e8 2c 0b 00 00       	call   800ec0 <strlen>
  800394:	89 44 24 08          	mov    %eax,0x8(%esp)
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a1:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003a8:	ff d3                	call   *%ebx
  8003aa:	89 c3                	mov    %eax,%ebx
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	89 04 24             	mov    %eax,(%esp)
  8003b4:	e8 07 0b 00 00       	call   800ec0 <strlen>
  8003b9:	39 c3                	cmp    %eax,%ebx
  8003bb:	74 20                	je     8003dd <umain+0x33c>
		panic("file_write: %e", r);
  8003bd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003c1:	c7 44 24 08 26 30 80 	movl   $0x803026,0x8(%esp)
  8003c8:	00 
  8003c9:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8003d0:	00 
  8003d1:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8003d8:	e8 f7 03 00 00       	call   8007d4 <_panic>
	cprintf("file_write is good\n");
  8003dd:	c7 04 24 35 30 80 00 	movl   $0x803035,(%esp)
  8003e4:	e8 a4 04 00 00       	call   80088d <cprintf>

	FVA->fd_offset = 0;
  8003e9:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  8003f0:	00 00 00 
	memset(buf, 0, sizeof buf);
  8003f3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8003fa:	00 
  8003fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800402:	00 
  800403:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800409:	89 1c 24             	mov    %ebx,(%esp)
  80040c:	e8 2f 0c 00 00       	call   801040 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800411:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800418:	00 
  800419:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80041d:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800424:	ff 15 10 40 80 00    	call   *0x804010
  80042a:	89 c3                	mov    %eax,%ebx
  80042c:	85 c0                	test   %eax,%eax
  80042e:	79 20                	jns    800450 <umain+0x3af>
		panic("file_read after file_write: %e", r);
  800430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800434:	c7 44 24 08 74 31 80 	movl   $0x803174,0x8(%esp)
  80043b:	00 
  80043c:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  800443:	00 
  800444:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80044b:	e8 84 03 00 00       	call   8007d4 <_panic>
	if (r != strlen(msg))
  800450:	a1 00 40 80 00       	mov    0x804000,%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	e8 63 0a 00 00       	call   800ec0 <strlen>
  80045d:	39 c3                	cmp    %eax,%ebx
  80045f:	74 20                	je     800481 <umain+0x3e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800461:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800465:	c7 44 24 08 94 31 80 	movl   $0x803194,0x8(%esp)
  80046c:	00 
  80046d:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  800474:	00 
  800475:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80047c:	e8 53 03 00 00       	call   8007d4 <_panic>
	if (strcmp(buf, msg) != 0)
  800481:	a1 00 40 80 00       	mov    0x804000,%eax
  800486:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800490:	89 04 24             	mov    %eax,(%esp)
  800493:	e8 0c 0b 00 00       	call   800fa4 <strcmp>
  800498:	85 c0                	test   %eax,%eax
  80049a:	74 1c                	je     8004b8 <umain+0x417>
		panic("file_read after file_write returned wrong data");
  80049c:	c7 44 24 08 cc 31 80 	movl   $0x8031cc,0x8(%esp)
  8004a3:	00 
  8004a4:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8004ab:	00 
  8004ac:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8004b3:	e8 1c 03 00 00       	call   8007d4 <_panic>
	cprintf("file_read after file_write is good\n");
  8004b8:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  8004bf:	e8 c9 03 00 00       	call   80088d <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004cb:	00 
  8004cc:	c7 04 24 00 2f 80 00 	movl   $0x802f00,(%esp)
  8004d3:	e8 6f 1c 00 00       	call   802147 <open>
  8004d8:	85 c0                	test   %eax,%eax
  8004da:	79 25                	jns    800501 <umain+0x460>
  8004dc:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8004df:	74 3c                	je     80051d <umain+0x47c>
		panic("open /not-found: %e", r);
  8004e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e5:	c7 44 24 08 11 2f 80 	movl   $0x802f11,0x8(%esp)
  8004ec:	00 
  8004ed:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8004f4:	00 
  8004f5:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8004fc:	e8 d3 02 00 00       	call   8007d4 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800501:	c7 44 24 08 49 30 80 	movl   $0x803049,0x8(%esp)
  800508:	00 
  800509:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800510:	00 
  800511:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800518:	e8 b7 02 00 00       	call   8007d4 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80051d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800524:	00 
  800525:	c7 04 24 35 2f 80 00 	movl   $0x802f35,(%esp)
  80052c:	e8 16 1c 00 00       	call   802147 <open>
  800531:	85 c0                	test   %eax,%eax
  800533:	79 20                	jns    800555 <umain+0x4b4>
		panic("open /newmotd: %e", r);
  800535:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800539:	c7 44 24 08 44 2f 80 	movl   $0x802f44,0x8(%esp)
  800540:	00 
  800541:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  800548:	00 
  800549:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800550:	e8 7f 02 00 00       	call   8007d4 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800555:	05 00 00 0d 00       	add    $0xd0000,%eax
  80055a:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80055d:	83 38 66             	cmpl   $0x66,(%eax)
  800560:	75 0c                	jne    80056e <umain+0x4cd>
  800562:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  800566:	75 06                	jne    80056e <umain+0x4cd>
  800568:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
  80056c:	74 1c                	je     80058a <umain+0x4e9>
		panic("open did not fill struct Fd correctly\n");
  80056e:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  800575:	00 
  800576:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80057d:	00 
  80057e:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800585:	e8 4a 02 00 00       	call   8007d4 <_panic>
	cprintf("open is good\n");
  80058a:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800591:	e8 f7 02 00 00       	call   80088d <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  800596:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  80059d:	00 
  80059e:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  8005a5:	e8 9d 1b 00 00       	call   802147 <open>
  8005aa:	89 85 44 fd ff ff    	mov    %eax,-0x2bc(%ebp)
  8005b0:	85 c0                	test   %eax,%eax
  8005b2:	79 20                	jns    8005d4 <umain+0x533>
		panic("creat /big: %e", f);
  8005b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005b8:	c7 44 24 08 69 30 80 	movl   $0x803069,0x8(%esp)
  8005bf:	00 
  8005c0:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8005c7:	00 
  8005c8:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8005cf:	e8 00 02 00 00       	call   8007d4 <_panic>
	memset(buf, 0, sizeof(buf));
  8005d4:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8005db:	00 
  8005dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8005e3:	00 
  8005e4:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8005ea:	89 04 24             	mov    %eax,(%esp)
  8005ed:	e8 4e 0a 00 00       	call   801040 <memset>
  8005f2:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8005f7:	8d b5 4c fd ff ff    	lea    -0x2b4(%ebp),%esi
  8005fd:	89 f7                	mov    %esi,%edi
  8005ff:	89 1e                	mov    %ebx,(%esi)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800601:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800608:	00 
  800609:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060d:	8b 85 44 fd ff ff    	mov    -0x2bc(%ebp),%eax
  800613:	89 04 24             	mov    %eax,(%esp)
  800616:	e8 c7 14 00 00       	call   801ae2 <write>
  80061b:	85 c0                	test   %eax,%eax
  80061d:	79 24                	jns    800643 <umain+0x5a2>
			panic("write /big@%d: %e", i, r);
  80061f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800623:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800627:	c7 44 24 08 78 30 80 	movl   $0x803078,0x8(%esp)
  80062e:	00 
  80062f:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800636:	00 
  800637:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80063e:	e8 91 01 00 00       	call   8007d4 <_panic>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
	return ipc_recv(NULL, FVA, NULL);
}

void
umain(int argc, char **argv)
  800643:	81 c3 00 02 00 00    	add    $0x200,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800649:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80064f:	75 ac                	jne    8005fd <umain+0x55c>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800651:	8b 85 44 fd ff ff    	mov    -0x2bc(%ebp),%eax
  800657:	89 04 24             	mov    %eax,(%esp)
  80065a:	e8 73 16 00 00       	call   801cd2 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80065f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800666:	00 
  800667:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  80066e:	e8 d4 1a 00 00       	call   802147 <open>
  800673:	89 c6                	mov    %eax,%esi
  800675:	85 c0                	test   %eax,%eax
  800677:	79 20                	jns    800699 <umain+0x5f8>
		panic("open /big: %e", f);
  800679:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80067d:	c7 44 24 08 8a 30 80 	movl   $0x80308a,0x8(%esp)
  800684:	00 
  800685:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  80068c:	00 
  80068d:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800694:	e8 3b 01 00 00       	call   8007d4 <_panic>
  800699:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  80069e:	89 1f                	mov    %ebx,(%edi)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006a7:	00 
  8006a8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8006ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b2:	89 34 24             	mov    %esi,(%esp)
  8006b5:	e8 3f 15 00 00       	call   801bf9 <readn>
  8006ba:	85 c0                	test   %eax,%eax
  8006bc:	79 24                	jns    8006e2 <umain+0x641>
			panic("read /big@%d: %e", i, r);
  8006be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006c2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006c6:	c7 44 24 08 98 30 80 	movl   $0x803098,0x8(%esp)
  8006cd:	00 
  8006ce:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006d5:	00 
  8006d6:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8006dd:	e8 f2 00 00 00       	call   8007d4 <_panic>
		if (r != sizeof(buf))
  8006e2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006e7:	74 2c                	je     800715 <umain+0x674>
			panic("read /big from %d returned %d < %d bytes",
  8006e9:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  8006f0:	00 
  8006f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006f5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006f9:	c7 44 24 08 48 32 80 	movl   $0x803248,0x8(%esp)
  800700:	00 
  800701:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800708:	00 
  800709:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  800710:	e8 bf 00 00 00       	call   8007d4 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800715:	8b 07                	mov    (%edi),%eax
  800717:	39 d8                	cmp    %ebx,%eax
  800719:	74 24                	je     80073f <umain+0x69e>
			panic("read /big from %d returned bad data %d",
  80071b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80071f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800723:	c7 44 24 08 74 32 80 	movl   $0x803274,0x8(%esp)
  80072a:	00 
  80072b:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800732:	00 
  800733:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  80073a:	e8 95 00 00 00       	call   8007d4 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80073f:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  800745:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  80074b:	0f 8e 4d ff ff ff    	jle    80069e <umain+0x5fd>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800751:	89 34 24             	mov    %esi,(%esp)
  800754:	e8 79 15 00 00       	call   801cd2 <close>
	cprintf("large file is good\n");
  800759:	c7 04 24 a9 30 80 00 	movl   $0x8030a9,(%esp)
  800760:	e8 28 01 00 00       	call   80088d <cprintf>
}
  800765:	81 c4 dc 02 00 00    	add    $0x2dc,%esp
  80076b:	5b                   	pop    %ebx
  80076c:	5e                   	pop    %esi
  80076d:	5f                   	pop    %edi
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	83 ec 18             	sub    $0x18,%esp
  800776:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800779:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80077c:	8b 75 08             	mov    0x8(%ebp),%esi
  80077f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800782:	e8 4a 0f 00 00       	call   8016d1 <sys_getenvid>
  800787:	25 ff 03 00 00       	and    $0x3ff,%eax
  80078c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80078f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800794:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800799:	85 f6                	test   %esi,%esi
  80079b:	7e 07                	jle    8007a4 <libmain+0x34>
		binaryname = argv[0];
  80079d:	8b 03                	mov    (%ebx),%eax
  80079f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a8:	89 34 24             	mov    %esi,(%esp)
  8007ab:	e8 f1 f8 ff ff       	call   8000a1 <umain>

	// exit gracefully
	exit();
  8007b0:	e8 0b 00 00 00       	call   8007c0 <exit>
}
  8007b5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8007b8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8007bb:	89 ec                	mov    %ebp,%esp
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    
	...

008007c0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8007c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007cd:	e8 33 0f 00 00       	call   801705 <sys_env_destroy>
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	56                   	push   %esi
  8007d8:	53                   	push   %ebx
  8007d9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8007dc:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007df:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  8007e5:	e8 e7 0e 00 00       	call   8016d1 <sys_getenvid>
  8007ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ed:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8007fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800800:	c7 04 24 cc 32 80 00 	movl   $0x8032cc,(%esp)
  800807:	e8 81 00 00 00       	call   80088d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80080c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800810:	8b 45 10             	mov    0x10(%ebp),%eax
  800813:	89 04 24             	mov    %eax,(%esp)
  800816:	e8 11 00 00 00       	call   80082c <vcprintf>
	cprintf("\n");
  80081b:	c7 04 24 43 36 80 00 	movl   $0x803643,(%esp)
  800822:	e8 66 00 00 00       	call   80088d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800827:	cc                   	int3   
  800828:	eb fd                	jmp    800827 <_panic+0x53>
	...

0080082c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800835:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80083c:	00 00 00 
	b.cnt = 0;
  80083f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800846:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	89 44 24 08          	mov    %eax,0x8(%esp)
  800857:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80085d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800861:	c7 04 24 a7 08 80 00 	movl   $0x8008a7,(%esp)
  800868:	e8 be 01 00 00       	call   800a2b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80086d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800873:	89 44 24 04          	mov    %eax,0x4(%esp)
  800877:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80087d:	89 04 24             	mov    %eax,(%esp)
  800880:	e8 2b 0a 00 00       	call   8012b0 <sys_cputs>

	return b.cnt;
}
  800885:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    

0080088d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800893:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 04 24             	mov    %eax,(%esp)
  8008a0:	e8 87 ff ff ff       	call   80082c <vcprintf>
	va_end(ap);

	return cnt;
}
  8008a5:	c9                   	leave  
  8008a6:	c3                   	ret    

008008a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	83 ec 14             	sub    $0x14,%esp
  8008ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8008b1:	8b 03                	mov    (%ebx),%eax
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8008ba:	83 c0 01             	add    $0x1,%eax
  8008bd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8008bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008c4:	75 19                	jne    8008df <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8008c6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8008cd:	00 
  8008ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8008d1:	89 04 24             	mov    %eax,(%esp)
  8008d4:	e8 d7 09 00 00       	call   8012b0 <sys_cputs>
		b->idx = 0;
  8008d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8008df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8008e3:	83 c4 14             	add    $0x14,%esp
  8008e6:	5b                   	pop    %ebx
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    
  8008e9:	00 00                	add    %al,(%eax)
	...

008008ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	57                   	push   %edi
  8008f0:	56                   	push   %esi
  8008f1:	53                   	push   %ebx
  8008f2:	83 ec 4c             	sub    $0x4c,%esp
  8008f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f8:	89 d6                	mov    %edx,%esi
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800900:	8b 55 0c             	mov    0xc(%ebp),%edx
  800903:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80090c:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80090f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800912:	b9 00 00 00 00       	mov    $0x0,%ecx
  800917:	39 d1                	cmp    %edx,%ecx
  800919:	72 07                	jb     800922 <printnum+0x36>
  80091b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80091e:	39 d0                	cmp    %edx,%eax
  800920:	77 69                	ja     80098b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800922:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800926:	83 eb 01             	sub    $0x1,%ebx
  800929:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80092d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800931:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800935:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800939:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80093c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80093f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800942:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800946:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80094d:	00 
  80094e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800951:	89 04 24             	mov    %eax,(%esp)
  800954:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800957:	89 54 24 04          	mov    %edx,0x4(%esp)
  80095b:	e8 20 23 00 00       	call   802c80 <__udivdi3>
  800960:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800963:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800966:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80096a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80096e:	89 04 24             	mov    %eax,(%esp)
  800971:	89 54 24 04          	mov    %edx,0x4(%esp)
  800975:	89 f2                	mov    %esi,%edx
  800977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80097a:	e8 6d ff ff ff       	call   8008ec <printnum>
  80097f:	eb 11                	jmp    800992 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800981:	89 74 24 04          	mov    %esi,0x4(%esp)
  800985:	89 3c 24             	mov    %edi,(%esp)
  800988:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80098b:	83 eb 01             	sub    $0x1,%ebx
  80098e:	85 db                	test   %ebx,%ebx
  800990:	7f ef                	jg     800981 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800992:	89 74 24 04          	mov    %esi,0x4(%esp)
  800996:	8b 74 24 04          	mov    0x4(%esp),%esi
  80099a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80099d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8009a8:	00 
  8009a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009ac:	89 14 24             	mov    %edx,(%esp)
  8009af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009b6:	e8 f5 23 00 00       	call   802db0 <__umoddi3>
  8009bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009bf:	0f be 80 ef 32 80 00 	movsbl 0x8032ef(%eax),%eax
  8009c6:	89 04 24             	mov    %eax,(%esp)
  8009c9:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8009cc:	83 c4 4c             	add    $0x4c,%esp
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5f                   	pop    %edi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009d7:	83 fa 01             	cmp    $0x1,%edx
  8009da:	7e 0e                	jle    8009ea <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8009dc:	8b 10                	mov    (%eax),%edx
  8009de:	8d 4a 08             	lea    0x8(%edx),%ecx
  8009e1:	89 08                	mov    %ecx,(%eax)
  8009e3:	8b 02                	mov    (%edx),%eax
  8009e5:	8b 52 04             	mov    0x4(%edx),%edx
  8009e8:	eb 22                	jmp    800a0c <getuint+0x38>
	else if (lflag)
  8009ea:	85 d2                	test   %edx,%edx
  8009ec:	74 10                	je     8009fe <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8009ee:	8b 10                	mov    (%eax),%edx
  8009f0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8009f3:	89 08                	mov    %ecx,(%eax)
  8009f5:	8b 02                	mov    (%edx),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	eb 0e                	jmp    800a0c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8009fe:	8b 10                	mov    (%eax),%edx
  800a00:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a03:	89 08                	mov    %ecx,(%eax)
  800a05:	8b 02                	mov    (%edx),%eax
  800a07:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a14:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a18:	8b 10                	mov    (%eax),%edx
  800a1a:	3b 50 04             	cmp    0x4(%eax),%edx
  800a1d:	73 0a                	jae    800a29 <sprintputch+0x1b>
		*b->buf++ = ch;
  800a1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a22:	88 0a                	mov    %cl,(%edx)
  800a24:	83 c2 01             	add    $0x1,%edx
  800a27:	89 10                	mov    %edx,(%eax)
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	57                   	push   %edi
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	83 ec 4c             	sub    $0x4c,%esp
  800a34:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a3d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800a44:	eb 11                	jmp    800a57 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800a46:	85 c0                	test   %eax,%eax
  800a48:	0f 84 b6 03 00 00    	je     800e04 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800a4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a52:	89 04 24             	mov    %eax,(%esp)
  800a55:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a57:	0f b6 03             	movzbl (%ebx),%eax
  800a5a:	83 c3 01             	add    $0x1,%ebx
  800a5d:	83 f8 25             	cmp    $0x25,%eax
  800a60:	75 e4                	jne    800a46 <vprintfmt+0x1b>
  800a62:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800a66:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800a6d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800a74:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800a7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a80:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a83:	eb 06                	jmp    800a8b <vprintfmt+0x60>
  800a85:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800a89:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a8b:	0f b6 0b             	movzbl (%ebx),%ecx
  800a8e:	0f b6 c1             	movzbl %cl,%eax
  800a91:	8d 53 01             	lea    0x1(%ebx),%edx
  800a94:	83 e9 23             	sub    $0x23,%ecx
  800a97:	80 f9 55             	cmp    $0x55,%cl
  800a9a:	0f 87 47 03 00 00    	ja     800de7 <vprintfmt+0x3bc>
  800aa0:	0f b6 c9             	movzbl %cl,%ecx
  800aa3:	ff 24 8d 40 34 80 00 	jmp    *0x803440(,%ecx,4)
  800aaa:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800aae:	eb d9                	jmp    800a89 <vprintfmt+0x5e>
  800ab0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800ab7:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800abc:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800abf:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800ac3:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800ac6:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800ac9:	83 fb 09             	cmp    $0x9,%ebx
  800acc:	77 30                	ja     800afe <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ace:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad1:	eb e9                	jmp    800abc <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	8d 48 04             	lea    0x4(%eax),%ecx
  800ad9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800ae1:	eb 1e                	jmp    800b01 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800ae3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aec:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800af0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800af3:	eb 94                	jmp    800a89 <vprintfmt+0x5e>
  800af5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800afc:	eb 8b                	jmp    800a89 <vprintfmt+0x5e>
  800afe:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800b01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b05:	79 82                	jns    800a89 <vprintfmt+0x5e>
  800b07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b0d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800b10:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800b13:	e9 71 ff ff ff       	jmp    800a89 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b18:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800b1c:	e9 68 ff ff ff       	jmp    800a89 <vprintfmt+0x5e>
  800b21:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	8d 50 04             	lea    0x4(%eax),%edx
  800b2a:	89 55 14             	mov    %edx,0x14(%ebp)
  800b2d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 04 24             	mov    %eax,(%esp)
  800b36:	ff d7                	call   *%edi
  800b38:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b3b:	e9 17 ff ff ff       	jmp    800a57 <vprintfmt+0x2c>
  800b40:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b43:	8b 45 14             	mov    0x14(%ebp),%eax
  800b46:	8d 50 04             	lea    0x4(%eax),%edx
  800b49:	89 55 14             	mov    %edx,0x14(%ebp)
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	89 c2                	mov    %eax,%edx
  800b50:	c1 fa 1f             	sar    $0x1f,%edx
  800b53:	31 d0                	xor    %edx,%eax
  800b55:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b57:	83 f8 11             	cmp    $0x11,%eax
  800b5a:	7f 0b                	jg     800b67 <vprintfmt+0x13c>
  800b5c:	8b 14 85 a0 35 80 00 	mov    0x8035a0(,%eax,4),%edx
  800b63:	85 d2                	test   %edx,%edx
  800b65:	75 20                	jne    800b87 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b6b:	c7 44 24 08 00 33 80 	movl   $0x803300,0x8(%esp)
  800b72:	00 
  800b73:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b77:	89 3c 24             	mov    %edi,(%esp)
  800b7a:	e8 0d 03 00 00       	call   800e8c <printfmt>
  800b7f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b82:	e9 d0 fe ff ff       	jmp    800a57 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b87:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b8b:	c7 44 24 08 1e 37 80 	movl   $0x80371e,0x8(%esp)
  800b92:	00 
  800b93:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b97:	89 3c 24             	mov    %edi,(%esp)
  800b9a:	e8 ed 02 00 00       	call   800e8c <printfmt>
  800b9f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800ba2:	e9 b0 fe ff ff       	jmp    800a57 <vprintfmt+0x2c>
  800ba7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800baa:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	8d 50 04             	lea    0x4(%eax),%edx
  800bb9:	89 55 14             	mov    %edx,0x14(%ebp)
  800bbc:	8b 18                	mov    (%eax),%ebx
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	b8 09 33 80 00       	mov    $0x803309,%eax
  800bc5:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800bc8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bcc:	7e 76                	jle    800c44 <vprintfmt+0x219>
  800bce:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800bd2:	74 7a                	je     800c4e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800bd8:	89 1c 24             	mov    %ebx,(%esp)
  800bdb:	e8 f8 02 00 00       	call   800ed8 <strnlen>
  800be0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800be3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800be5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800be9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800bec:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800bef:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf1:	eb 0f                	jmp    800c02 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800bf3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bfa:	89 04 24             	mov    %eax,(%esp)
  800bfd:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bff:	83 eb 01             	sub    $0x1,%ebx
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	7f ed                	jg     800bf3 <vprintfmt+0x1c8>
  800c06:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800c09:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800c0c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800c0f:	89 f7                	mov    %esi,%edi
  800c11:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800c14:	eb 40                	jmp    800c56 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c16:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800c1a:	74 18                	je     800c34 <vprintfmt+0x209>
  800c1c:	8d 50 e0             	lea    -0x20(%eax),%edx
  800c1f:	83 fa 5e             	cmp    $0x5e,%edx
  800c22:	76 10                	jbe    800c34 <vprintfmt+0x209>
					putch('?', putdat);
  800c24:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c28:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800c2f:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c32:	eb 0a                	jmp    800c3e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800c34:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c38:	89 04 24             	mov    %eax,(%esp)
  800c3b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800c42:	eb 12                	jmp    800c56 <vprintfmt+0x22b>
  800c44:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800c47:	89 f7                	mov    %esi,%edi
  800c49:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800c4c:	eb 08                	jmp    800c56 <vprintfmt+0x22b>
  800c4e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800c51:	89 f7                	mov    %esi,%edi
  800c53:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800c56:	0f be 03             	movsbl (%ebx),%eax
  800c59:	83 c3 01             	add    $0x1,%ebx
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	74 25                	je     800c85 <vprintfmt+0x25a>
  800c60:	85 f6                	test   %esi,%esi
  800c62:	78 b2                	js     800c16 <vprintfmt+0x1eb>
  800c64:	83 ee 01             	sub    $0x1,%esi
  800c67:	79 ad                	jns    800c16 <vprintfmt+0x1eb>
  800c69:	89 fe                	mov    %edi,%esi
  800c6b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800c6e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800c71:	eb 1a                	jmp    800c8d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800c73:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c77:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800c7e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c80:	83 eb 01             	sub    $0x1,%ebx
  800c83:	eb 08                	jmp    800c8d <vprintfmt+0x262>
  800c85:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800c88:	89 fe                	mov    %edi,%esi
  800c8a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800c8d:	85 db                	test   %ebx,%ebx
  800c8f:	7f e2                	jg     800c73 <vprintfmt+0x248>
  800c91:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800c94:	e9 be fd ff ff       	jmp    800a57 <vprintfmt+0x2c>
  800c99:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800c9c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800c9f:	83 f9 01             	cmp    $0x1,%ecx
  800ca2:	7e 16                	jle    800cba <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca7:	8d 50 08             	lea    0x8(%eax),%edx
  800caa:	89 55 14             	mov    %edx,0x14(%ebp)
  800cad:	8b 10                	mov    (%eax),%edx
  800caf:	8b 48 04             	mov    0x4(%eax),%ecx
  800cb2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800cb5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800cb8:	eb 32                	jmp    800cec <vprintfmt+0x2c1>
	else if (lflag)
  800cba:	85 c9                	test   %ecx,%ecx
  800cbc:	74 18                	je     800cd6 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc1:	8d 50 04             	lea    0x4(%eax),%edx
  800cc4:	89 55 14             	mov    %edx,0x14(%ebp)
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ccc:	89 c1                	mov    %eax,%ecx
  800cce:	c1 f9 1f             	sar    $0x1f,%ecx
  800cd1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800cd4:	eb 16                	jmp    800cec <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	8d 50 04             	lea    0x4(%eax),%edx
  800cdc:	89 55 14             	mov    %edx,0x14(%ebp)
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ce4:	89 c2                	mov    %eax,%edx
  800ce6:	c1 fa 1f             	sar    $0x1f,%edx
  800ce9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cec:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800cef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800cf2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800cf7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cfb:	0f 89 a7 00 00 00    	jns    800da8 <vprintfmt+0x37d>
				putch('-', putdat);
  800d01:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d05:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800d0c:	ff d7                	call   *%edi
				num = -(long long) num;
  800d0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800d11:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d14:	f7 d9                	neg    %ecx
  800d16:	83 d3 00             	adc    $0x0,%ebx
  800d19:	f7 db                	neg    %ebx
  800d1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d20:	e9 83 00 00 00       	jmp    800da8 <vprintfmt+0x37d>
  800d25:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800d28:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d2b:	89 ca                	mov    %ecx,%edx
  800d2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d30:	e8 9f fc ff ff       	call   8009d4 <getuint>
  800d35:	89 c1                	mov    %eax,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800d3e:	eb 68                	jmp    800da8 <vprintfmt+0x37d>
  800d40:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800d43:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800d46:	89 ca                	mov    %ecx,%edx
  800d48:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4b:	e8 84 fc ff ff       	call   8009d4 <getuint>
  800d50:	89 c1                	mov    %eax,%ecx
  800d52:	89 d3                	mov    %edx,%ebx
  800d54:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800d59:	eb 4d                	jmp    800da8 <vprintfmt+0x37d>
  800d5b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800d5e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d62:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800d69:	ff d7                	call   *%edi
			putch('x', putdat);
  800d6b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d6f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800d76:	ff d7                	call   *%edi
			num = (unsigned long long)
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	8d 50 04             	lea    0x4(%eax),%edx
  800d7e:	89 55 14             	mov    %edx,0x14(%ebp)
  800d81:	8b 08                	mov    (%eax),%ecx
  800d83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d88:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800d8d:	eb 19                	jmp    800da8 <vprintfmt+0x37d>
  800d8f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800d92:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d95:	89 ca                	mov    %ecx,%edx
  800d97:	8d 45 14             	lea    0x14(%ebp),%eax
  800d9a:	e8 35 fc ff ff       	call   8009d4 <getuint>
  800d9f:	89 c1                	mov    %eax,%ecx
  800da1:	89 d3                	mov    %edx,%ebx
  800da3:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da8:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800dac:	89 54 24 10          	mov    %edx,0x10(%esp)
  800db0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800db3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800db7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dbb:	89 0c 24             	mov    %ecx,(%esp)
  800dbe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dc2:	89 f2                	mov    %esi,%edx
  800dc4:	89 f8                	mov    %edi,%eax
  800dc6:	e8 21 fb ff ff       	call   8008ec <printnum>
  800dcb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800dce:	e9 84 fc ff ff       	jmp    800a57 <vprintfmt+0x2c>
  800dd3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dd6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dda:	89 04 24             	mov    %eax,(%esp)
  800ddd:	ff d7                	call   *%edi
  800ddf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800de2:	e9 70 fc ff ff       	jmp    800a57 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800de7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800deb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800df2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800df4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800df7:	80 38 25             	cmpb   $0x25,(%eax)
  800dfa:	0f 84 57 fc ff ff    	je     800a57 <vprintfmt+0x2c>
  800e00:	89 c3                	mov    %eax,%ebx
  800e02:	eb f0                	jmp    800df4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800e04:	83 c4 4c             	add    $0x4c,%esp
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 28             	sub    $0x28,%esp
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	74 04                	je     800e20 <vsnprintf+0x14>
  800e1c:	85 d2                	test   %edx,%edx
  800e1e:	7f 07                	jg     800e27 <vsnprintf+0x1b>
  800e20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e25:	eb 3b                	jmp    800e62 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e2a:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e38:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e4d:	c7 04 24 0e 0a 80 00 	movl   $0x800a0e,(%esp)
  800e54:	e8 d2 fb ff ff       	call   800a2b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e5c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800e6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	89 04 24             	mov    %eax,(%esp)
  800e85:	e8 82 ff ff ff       	call   800e0c <vsnprintf>
	va_end(ap);

	return rc;
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800e92:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800e95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e99:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	89 04 24             	mov    %eax,(%esp)
  800ead:	e8 79 fb ff ff       	call   800a2b <vprintfmt>
	va_end(ap);
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    
	...

00800ec0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800ecb:	eb 03                	jmp    800ed0 <strlen+0x10>
		n++;
  800ecd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ed4:	75 f7                	jne    800ecd <strlen+0xd>
		n++;
	return n;
}
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	53                   	push   %ebx
  800edc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee7:	eb 03                	jmp    800eec <strnlen+0x14>
		n++;
  800ee9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eec:	39 c1                	cmp    %eax,%ecx
  800eee:	74 06                	je     800ef6 <strnlen+0x1e>
  800ef0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800ef4:	75 f3                	jne    800ee9 <strnlen+0x11>
		n++;
	return n;
}
  800ef6:	5b                   	pop    %ebx
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	53                   	push   %ebx
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f03:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f08:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800f0c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800f0f:	83 c2 01             	add    $0x1,%edx
  800f12:	84 c9                	test   %cl,%cl
  800f14:	75 f2                	jne    800f08 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800f16:	5b                   	pop    %ebx
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 08             	sub    $0x8,%esp
  800f20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f23:	89 1c 24             	mov    %ebx,(%esp)
  800f26:	e8 95 ff ff ff       	call   800ec0 <strlen>
	strcpy(dst + len, src);
  800f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f32:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800f35:	89 04 24             	mov    %eax,(%esp)
  800f38:	e8 bc ff ff ff       	call   800ef9 <strcpy>
	return dst;
}
  800f3d:	89 d8                	mov    %ebx,%eax
  800f3f:	83 c4 08             	add    $0x8,%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	8b 75 10             	mov    0x10(%ebp),%esi
  800f53:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f58:	eb 0f                	jmp    800f69 <strncpy+0x24>
		*dst++ = *src;
  800f5a:	0f b6 19             	movzbl (%ecx),%ebx
  800f5d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f60:	80 39 01             	cmpb   $0x1,(%ecx)
  800f63:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f66:	83 c2 01             	add    $0x1,%edx
  800f69:	39 f2                	cmp    %esi,%edx
  800f6b:	72 ed                	jb     800f5a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800f6d:	5b                   	pop    %ebx
  800f6e:	5e                   	pop    %esi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
  800f76:	8b 75 08             	mov    0x8(%ebp),%esi
  800f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f7f:	89 f0                	mov    %esi,%eax
  800f81:	85 d2                	test   %edx,%edx
  800f83:	75 0a                	jne    800f8f <strlcpy+0x1e>
  800f85:	eb 17                	jmp    800f9e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f87:	88 18                	mov    %bl,(%eax)
  800f89:	83 c0 01             	add    $0x1,%eax
  800f8c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f8f:	83 ea 01             	sub    $0x1,%edx
  800f92:	74 07                	je     800f9b <strlcpy+0x2a>
  800f94:	0f b6 19             	movzbl (%ecx),%ebx
  800f97:	84 db                	test   %bl,%bl
  800f99:	75 ec                	jne    800f87 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800f9b:	c6 00 00             	movb   $0x0,(%eax)
  800f9e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800faa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fad:	eb 06                	jmp    800fb5 <strcmp+0x11>
		p++, q++;
  800faf:	83 c1 01             	add    $0x1,%ecx
  800fb2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb5:	0f b6 01             	movzbl (%ecx),%eax
  800fb8:	84 c0                	test   %al,%al
  800fba:	74 04                	je     800fc0 <strcmp+0x1c>
  800fbc:	3a 02                	cmp    (%edx),%al
  800fbe:	74 ef                	je     800faf <strcmp+0xb>
  800fc0:	0f b6 c0             	movzbl %al,%eax
  800fc3:	0f b6 12             	movzbl (%edx),%edx
  800fc6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	53                   	push   %ebx
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800fd7:	eb 09                	jmp    800fe2 <strncmp+0x18>
		n--, p++, q++;
  800fd9:	83 ea 01             	sub    $0x1,%edx
  800fdc:	83 c0 01             	add    $0x1,%eax
  800fdf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fe2:	85 d2                	test   %edx,%edx
  800fe4:	75 07                	jne    800fed <strncmp+0x23>
  800fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  800feb:	eb 13                	jmp    801000 <strncmp+0x36>
  800fed:	0f b6 18             	movzbl (%eax),%ebx
  800ff0:	84 db                	test   %bl,%bl
  800ff2:	74 04                	je     800ff8 <strncmp+0x2e>
  800ff4:	3a 19                	cmp    (%ecx),%bl
  800ff6:	74 e1                	je     800fd9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff8:	0f b6 00             	movzbl (%eax),%eax
  800ffb:	0f b6 11             	movzbl (%ecx),%edx
  800ffe:	29 d0                	sub    %edx,%eax
}
  801000:	5b                   	pop    %ebx
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80100d:	eb 07                	jmp    801016 <strchr+0x13>
		if (*s == c)
  80100f:	38 ca                	cmp    %cl,%dl
  801011:	74 0f                	je     801022 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801013:	83 c0 01             	add    $0x1,%eax
  801016:	0f b6 10             	movzbl (%eax),%edx
  801019:	84 d2                	test   %dl,%dl
  80101b:	75 f2                	jne    80100f <strchr+0xc>
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80102e:	eb 07                	jmp    801037 <strfind+0x13>
		if (*s == c)
  801030:	38 ca                	cmp    %cl,%dl
  801032:	74 0a                	je     80103e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801034:	83 c0 01             	add    $0x1,%eax
  801037:	0f b6 10             	movzbl (%eax),%edx
  80103a:	84 d2                	test   %dl,%dl
  80103c:	75 f2                	jne    801030 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	89 1c 24             	mov    %ebx,(%esp)
  801049:	89 74 24 04          	mov    %esi,0x4(%esp)
  80104d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801051:	8b 7d 08             	mov    0x8(%ebp),%edi
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80105a:	85 c9                	test   %ecx,%ecx
  80105c:	74 30                	je     80108e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80105e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801064:	75 25                	jne    80108b <memset+0x4b>
  801066:	f6 c1 03             	test   $0x3,%cl
  801069:	75 20                	jne    80108b <memset+0x4b>
		c &= 0xFF;
  80106b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80106e:	89 d3                	mov    %edx,%ebx
  801070:	c1 e3 08             	shl    $0x8,%ebx
  801073:	89 d6                	mov    %edx,%esi
  801075:	c1 e6 18             	shl    $0x18,%esi
  801078:	89 d0                	mov    %edx,%eax
  80107a:	c1 e0 10             	shl    $0x10,%eax
  80107d:	09 f0                	or     %esi,%eax
  80107f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  801081:	09 d8                	or     %ebx,%eax
  801083:	c1 e9 02             	shr    $0x2,%ecx
  801086:	fc                   	cld    
  801087:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801089:	eb 03                	jmp    80108e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80108b:	fc                   	cld    
  80108c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80108e:	89 f8                	mov    %edi,%eax
  801090:	8b 1c 24             	mov    (%esp),%ebx
  801093:	8b 74 24 04          	mov    0x4(%esp),%esi
  801097:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80109b:	89 ec                	mov    %ebp,%esp
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 08             	sub    $0x8,%esp
  8010a5:	89 34 24             	mov    %esi,(%esp)
  8010a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  8010b2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8010b5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8010b7:	39 c6                	cmp    %eax,%esi
  8010b9:	73 35                	jae    8010f0 <memmove+0x51>
  8010bb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010be:	39 d0                	cmp    %edx,%eax
  8010c0:	73 2e                	jae    8010f0 <memmove+0x51>
		s += n;
		d += n;
  8010c2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c4:	f6 c2 03             	test   $0x3,%dl
  8010c7:	75 1b                	jne    8010e4 <memmove+0x45>
  8010c9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8010cf:	75 13                	jne    8010e4 <memmove+0x45>
  8010d1:	f6 c1 03             	test   $0x3,%cl
  8010d4:	75 0e                	jne    8010e4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8010d6:	83 ef 04             	sub    $0x4,%edi
  8010d9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010dc:	c1 e9 02             	shr    $0x2,%ecx
  8010df:	fd                   	std    
  8010e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010e2:	eb 09                	jmp    8010ed <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8010e4:	83 ef 01             	sub    $0x1,%edi
  8010e7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8010ea:	fd                   	std    
  8010eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010ed:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010ee:	eb 20                	jmp    801110 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010f0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010f6:	75 15                	jne    80110d <memmove+0x6e>
  8010f8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8010fe:	75 0d                	jne    80110d <memmove+0x6e>
  801100:	f6 c1 03             	test   $0x3,%cl
  801103:	75 08                	jne    80110d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  801105:	c1 e9 02             	shr    $0x2,%ecx
  801108:	fc                   	cld    
  801109:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80110b:	eb 03                	jmp    801110 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80110d:	fc                   	cld    
  80110e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801110:	8b 34 24             	mov    (%esp),%esi
  801113:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801117:	89 ec                	mov    %ebp,%esp
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    

0080111b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	89 44 24 08          	mov    %eax,0x8(%esp)
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	89 04 24             	mov    %eax,(%esp)
  801135:	e8 65 ff ff ff       	call   80109f <memmove>
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	57                   	push   %edi
  801140:	56                   	push   %esi
  801141:	53                   	push   %ebx
  801142:	8b 7d 08             	mov    0x8(%ebp),%edi
  801145:	8b 75 0c             	mov    0xc(%ebp),%esi
  801148:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80114b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801150:	eb 1c                	jmp    80116e <memcmp+0x32>
		if (*s1 != *s2)
  801152:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  801156:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  80115a:	83 c2 01             	add    $0x1,%edx
  80115d:	83 e9 01             	sub    $0x1,%ecx
  801160:	38 d8                	cmp    %bl,%al
  801162:	74 0a                	je     80116e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  801164:	0f b6 c0             	movzbl %al,%eax
  801167:	0f b6 db             	movzbl %bl,%ebx
  80116a:	29 d8                	sub    %ebx,%eax
  80116c:	eb 09                	jmp    801177 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80116e:	85 c9                	test   %ecx,%ecx
  801170:	75 e0                	jne    801152 <memcmp+0x16>
  801172:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801185:	89 c2                	mov    %eax,%edx
  801187:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80118a:	eb 07                	jmp    801193 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  80118c:	38 08                	cmp    %cl,(%eax)
  80118e:	74 07                	je     801197 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801190:	83 c0 01             	add    $0x1,%eax
  801193:	39 d0                	cmp    %edx,%eax
  801195:	72 f5                	jb     80118c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	57                   	push   %edi
  80119d:	56                   	push   %esi
  80119e:	53                   	push   %ebx
  80119f:	83 ec 04             	sub    $0x4,%esp
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a8:	eb 03                	jmp    8011ad <strtol+0x14>
		s++;
  8011aa:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ad:	0f b6 02             	movzbl (%edx),%eax
  8011b0:	3c 20                	cmp    $0x20,%al
  8011b2:	74 f6                	je     8011aa <strtol+0x11>
  8011b4:	3c 09                	cmp    $0x9,%al
  8011b6:	74 f2                	je     8011aa <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 0c                	jne    8011c8 <strtol+0x2f>
		s++;
  8011bc:	8d 52 01             	lea    0x1(%edx),%edx
  8011bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011c6:	eb 15                	jmp    8011dd <strtol+0x44>
	else if (*s == '-')
  8011c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011cf:	3c 2d                	cmp    $0x2d,%al
  8011d1:	75 0a                	jne    8011dd <strtol+0x44>
		s++, neg = 1;
  8011d3:	8d 52 01             	lea    0x1(%edx),%edx
  8011d6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011dd:	85 db                	test   %ebx,%ebx
  8011df:	0f 94 c0             	sete   %al
  8011e2:	74 05                	je     8011e9 <strtol+0x50>
  8011e4:	83 fb 10             	cmp    $0x10,%ebx
  8011e7:	75 15                	jne    8011fe <strtol+0x65>
  8011e9:	80 3a 30             	cmpb   $0x30,(%edx)
  8011ec:	75 10                	jne    8011fe <strtol+0x65>
  8011ee:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8011f2:	75 0a                	jne    8011fe <strtol+0x65>
		s += 2, base = 16;
  8011f4:	83 c2 02             	add    $0x2,%edx
  8011f7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fc:	eb 13                	jmp    801211 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8011fe:	84 c0                	test   %al,%al
  801200:	74 0f                	je     801211 <strtol+0x78>
  801202:	bb 0a 00 00 00       	mov    $0xa,%ebx
  801207:	80 3a 30             	cmpb   $0x30,(%edx)
  80120a:	75 05                	jne    801211 <strtol+0x78>
		s++, base = 8;
  80120c:	83 c2 01             	add    $0x1,%edx
  80120f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801211:	b8 00 00 00 00       	mov    $0x0,%eax
  801216:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801218:	0f b6 0a             	movzbl (%edx),%ecx
  80121b:	89 cf                	mov    %ecx,%edi
  80121d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801220:	80 fb 09             	cmp    $0x9,%bl
  801223:	77 08                	ja     80122d <strtol+0x94>
			dig = *s - '0';
  801225:	0f be c9             	movsbl %cl,%ecx
  801228:	83 e9 30             	sub    $0x30,%ecx
  80122b:	eb 1e                	jmp    80124b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  80122d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801230:	80 fb 19             	cmp    $0x19,%bl
  801233:	77 08                	ja     80123d <strtol+0xa4>
			dig = *s - 'a' + 10;
  801235:	0f be c9             	movsbl %cl,%ecx
  801238:	83 e9 57             	sub    $0x57,%ecx
  80123b:	eb 0e                	jmp    80124b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  80123d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801240:	80 fb 19             	cmp    $0x19,%bl
  801243:	77 15                	ja     80125a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801245:	0f be c9             	movsbl %cl,%ecx
  801248:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80124b:	39 f1                	cmp    %esi,%ecx
  80124d:	7d 0b                	jge    80125a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80124f:	83 c2 01             	add    $0x1,%edx
  801252:	0f af c6             	imul   %esi,%eax
  801255:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801258:	eb be                	jmp    801218 <strtol+0x7f>
  80125a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80125c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801260:	74 05                	je     801267 <strtol+0xce>
		*endptr = (char *) s;
  801262:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801265:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801267:	89 ca                	mov    %ecx,%edx
  801269:	f7 da                	neg    %edx
  80126b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126f:	0f 45 c2             	cmovne %edx,%eax
}
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    
	...

0080127c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	89 1c 24             	mov    %ebx,(%esp)
  801285:	89 74 24 04          	mov    %esi,0x4(%esp)
  801289:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128d:	ba 00 00 00 00       	mov    $0x0,%edx
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
  801297:	89 d1                	mov    %edx,%ecx
  801299:	89 d3                	mov    %edx,%ebx
  80129b:	89 d7                	mov    %edx,%edi
  80129d:	89 d6                	mov    %edx,%esi
  80129f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8012a1:	8b 1c 24             	mov    (%esp),%ebx
  8012a4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012a8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012ac:	89 ec                	mov    %ebp,%esp
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 0c             	sub    $0xc,%esp
  8012b6:	89 1c 24             	mov    %ebx,(%esp)
  8012b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012bd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cc:	89 c3                	mov    %eax,%ebx
  8012ce:	89 c7                	mov    %eax,%edi
  8012d0:	89 c6                	mov    %eax,%esi
  8012d2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8012d4:	8b 1c 24             	mov    (%esp),%ebx
  8012d7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012db:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012df:	89 ec                	mov    %ebp,%esp
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 0c             	sub    $0xc,%esp
  8012e9:	89 1c 24             	mov    %ebx,(%esp)
  8012ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8012fe:	89 d1                	mov    %edx,%ecx
  801300:	89 d3                	mov    %edx,%ebx
  801302:	89 d7                	mov    %edx,%edi
  801304:	89 d6                	mov    %edx,%esi
  801306:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801308:	8b 1c 24             	mov    (%esp),%ebx
  80130b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80130f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801313:	89 ec                	mov    %ebp,%esp
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 38             	sub    $0x38,%esp
  80131d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801320:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801323:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801326:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	89 df                	mov    %ebx,%edi
  801338:	89 de                	mov    %ebx,%esi
  80133a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80133c:	85 c0                	test   %eax,%eax
  80133e:	7e 28                	jle    801368 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801340:	89 44 24 10          	mov    %eax,0x10(%esp)
  801344:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80134b:	00 
  80134c:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  801353:	00 
  801354:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80135b:	00 
  80135c:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  801363:	e8 6c f4 ff ff       	call   8007d4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801368:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80136b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80136e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801371:	89 ec                	mov    %ebp,%esp
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 38             	sub    $0x38,%esp
  80137b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80137e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801381:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801384:	bb 00 00 00 00       	mov    $0x0,%ebx
  801389:	b8 0e 00 00 00       	mov    $0xe,%eax
  80138e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801391:	8b 55 08             	mov    0x8(%ebp),%edx
  801394:	89 df                	mov    %ebx,%edi
  801396:	89 de                	mov    %ebx,%esi
  801398:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	7e 28                	jle    8013c6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80139e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013a2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8013a9:	00 
  8013aa:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  8013b1:	00 
  8013b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b9:	00 
  8013ba:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  8013c1:	e8 0e f4 ff ff       	call   8007d4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8013c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013c9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013cc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013cf:	89 ec                	mov    %ebp,%esp
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 38             	sub    $0x38,%esp
  8013d9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013df:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013e7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ef:	89 cb                	mov    %ecx,%ebx
  8013f1:	89 cf                	mov    %ecx,%edi
  8013f3:	89 ce                	mov    %ecx,%esi
  8013f5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	7e 28                	jle    801423 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801406:	00 
  801407:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  80141e:	e8 b1 f3 ff ff       	call   8007d4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801423:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801426:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801429:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80142c:	89 ec                	mov    %ebp,%esp
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	89 1c 24             	mov    %ebx,(%esp)
  801439:	89 74 24 04          	mov    %esi,0x4(%esp)
  80143d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801441:	be 00 00 00 00       	mov    $0x0,%esi
  801446:	b8 0c 00 00 00       	mov    $0xc,%eax
  80144b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80144e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801451:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801454:	8b 55 08             	mov    0x8(%ebp),%edx
  801457:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801459:	8b 1c 24             	mov    (%esp),%ebx
  80145c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801460:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801464:	89 ec                	mov    %ebp,%esp
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 38             	sub    $0x38,%esp
  80146e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801471:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801474:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801477:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801481:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801484:	8b 55 08             	mov    0x8(%ebp),%edx
  801487:	89 df                	mov    %ebx,%edi
  801489:	89 de                	mov    %ebx,%esi
  80148b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80148d:	85 c0                	test   %eax,%eax
  80148f:	7e 28                	jle    8014b9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801491:	89 44 24 10          	mov    %eax,0x10(%esp)
  801495:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80149c:	00 
  80149d:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  8014a4:	00 
  8014a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ac:	00 
  8014ad:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  8014b4:	e8 1b f3 ff ff       	call   8007d4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8014b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014c2:	89 ec                	mov    %ebp,%esp
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 38             	sub    $0x38,%esp
  8014cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014da:	b8 09 00 00 00       	mov    $0x9,%eax
  8014df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e5:	89 df                	mov    %ebx,%edi
  8014e7:	89 de                	mov    %ebx,%esi
  8014e9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	7e 28                	jle    801517 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014f3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  801502:	00 
  801503:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80150a:	00 
  80150b:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  801512:	e8 bd f2 ff ff       	call   8007d4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801517:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80151a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80151d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801520:	89 ec                	mov    %ebp,%esp
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 38             	sub    $0x38,%esp
  80152a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80152d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801530:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801533:	bb 00 00 00 00       	mov    $0x0,%ebx
  801538:	b8 08 00 00 00       	mov    $0x8,%eax
  80153d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801540:	8b 55 08             	mov    0x8(%ebp),%edx
  801543:	89 df                	mov    %ebx,%edi
  801545:	89 de                	mov    %ebx,%esi
  801547:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801549:	85 c0                	test   %eax,%eax
  80154b:	7e 28                	jle    801575 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80154d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801551:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801558:	00 
  801559:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  801560:	00 
  801561:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801568:	00 
  801569:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  801570:	e8 5f f2 ff ff       	call   8007d4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801575:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801578:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80157b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80157e:	89 ec                	mov    %ebp,%esp
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 38             	sub    $0x38,%esp
  801588:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80158b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80158e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801591:	bb 00 00 00 00       	mov    $0x0,%ebx
  801596:	b8 06 00 00 00       	mov    $0x6,%eax
  80159b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80159e:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a1:	89 df                	mov    %ebx,%edi
  8015a3:	89 de                	mov    %ebx,%esi
  8015a5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	7e 28                	jle    8015d3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015af:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8015b6:	00 
  8015b7:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  8015be:	00 
  8015bf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015c6:	00 
  8015c7:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  8015ce:	e8 01 f2 ff ff       	call   8007d4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015d6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015d9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015dc:	89 ec                	mov    %ebp,%esp
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 38             	sub    $0x38,%esp
  8015e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8015f7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801600:	8b 55 08             	mov    0x8(%ebp),%edx
  801603:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801605:	85 c0                	test   %eax,%eax
  801607:	7e 28                	jle    801631 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801609:	89 44 24 10          	mov    %eax,0x10(%esp)
  80160d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801614:	00 
  801615:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  80161c:	00 
  80161d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801624:	00 
  801625:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  80162c:	e8 a3 f1 ff ff       	call   8007d4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801631:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801634:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801637:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80163a:	89 ec                	mov    %ebp,%esp
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 38             	sub    $0x38,%esp
  801644:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801647:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80164a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80164d:	be 00 00 00 00       	mov    $0x0,%esi
  801652:	b8 04 00 00 00       	mov    $0x4,%eax
  801657:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80165a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80165d:	8b 55 08             	mov    0x8(%ebp),%edx
  801660:	89 f7                	mov    %esi,%edi
  801662:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801664:	85 c0                	test   %eax,%eax
  801666:	7e 28                	jle    801690 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801668:	89 44 24 10          	mov    %eax,0x10(%esp)
  80166c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801673:	00 
  801674:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  80167b:	00 
  80167c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801683:	00 
  801684:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  80168b:	e8 44 f1 ff ff       	call   8007d4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801690:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801693:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801696:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801699:	89 ec                	mov    %ebp,%esp
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    

0080169d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 0c             	sub    $0xc,%esp
  8016a3:	89 1c 24             	mov    %ebx,(%esp)
  8016a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016b8:	89 d1                	mov    %edx,%ecx
  8016ba:	89 d3                	mov    %edx,%ebx
  8016bc:	89 d7                	mov    %edx,%edi
  8016be:	89 d6                	mov    %edx,%esi
  8016c0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8016c2:	8b 1c 24             	mov    (%esp),%ebx
  8016c5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8016c9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8016cd:	89 ec                	mov    %ebp,%esp
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 0c             	sub    $0xc,%esp
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016de:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ec:	89 d1                	mov    %edx,%ecx
  8016ee:	89 d3                	mov    %edx,%ebx
  8016f0:	89 d7                	mov    %edx,%edi
  8016f2:	89 d6                	mov    %edx,%esi
  8016f4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016f6:	8b 1c 24             	mov    (%esp),%ebx
  8016f9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8016fd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801701:	89 ec                	mov    %ebp,%esp
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 38             	sub    $0x38,%esp
  80170b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80170e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801711:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801714:	b9 00 00 00 00       	mov    $0x0,%ecx
  801719:	b8 03 00 00 00       	mov    $0x3,%eax
  80171e:	8b 55 08             	mov    0x8(%ebp),%edx
  801721:	89 cb                	mov    %ecx,%ebx
  801723:	89 cf                	mov    %ecx,%edi
  801725:	89 ce                	mov    %ecx,%esi
  801727:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801729:	85 c0                	test   %eax,%eax
  80172b:	7e 28                	jle    801755 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80172d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801731:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801738:	00 
  801739:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  801740:	00 
  801741:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801748:	00 
  801749:	c7 04 24 24 36 80 00 	movl   $0x803624,(%esp)
  801750:	e8 7f f0 ff ff       	call   8007d4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801755:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801758:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80175b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80175e:	89 ec                	mov    %ebp,%esp
  801760:	5d                   	pop    %ebp
  801761:	c3                   	ret    
	...

00801764 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80176f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801772:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  801778:	8b 12                	mov    (%edx),%edx
  80177a:	39 ca                	cmp    %ecx,%edx
  80177c:	75 0c                	jne    80178a <ipc_find_env+0x26>
			return envs[i].env_id;
  80177e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801781:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  801786:	8b 00                	mov    (%eax),%eax
  801788:	eb 0e                	jmp    801798 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80178a:	83 c0 01             	add    $0x1,%eax
  80178d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801792:	75 db                	jne    80176f <ipc_find_env+0xb>
  801794:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 2c             	sub    $0x2c,%esp
  8017a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8017a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8017ac:	85 db                	test   %ebx,%ebx
  8017ae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8017b3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8017b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017bd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017c5:	89 34 24             	mov    %esi,(%esp)
  8017c8:	e8 63 fc ff ff       	call   801430 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8017cd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017d0:	74 e4                	je     8017b6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 28                	je     8017fe <ipc_send+0x64>
  8017d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017da:	c7 44 24 0c 4f 36 80 	movl   $0x80364f,0xc(%esp)
  8017e1:	00 
  8017e2:	c7 44 24 08 32 36 80 	movl   $0x803632,0x8(%esp)
  8017e9:	00 
  8017ea:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8017f1:	00 
  8017f2:	c7 04 24 45 36 80 00 	movl   $0x803645,(%esp)
  8017f9:	e8 d6 ef ff ff       	call   8007d4 <_panic>
	//if(!ret) sys_yield();
}
  8017fe:	83 c4 2c             	add    $0x2c,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 28             	sub    $0x28,%esp
  80180c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80180f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801812:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801815:	8b 75 08             	mov    0x8(%ebp),%esi
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  80181e:	85 c0                	test   %eax,%eax
  801820:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801825:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801828:	89 04 24             	mov    %eax,(%esp)
  80182b:	e8 a3 fb ff ff       	call   8013d3 <sys_ipc_recv>
  801830:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  801832:	e8 9a fe ff ff       	call   8016d1 <sys_getenvid>
  801837:	25 ff 03 00 00       	and    $0x3ff,%eax
  80183c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80183f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801844:	a3 08 50 80 00       	mov    %eax,0x805008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  801849:	85 f6                	test   %esi,%esi
  80184b:	74 0e                	je     80185b <ipc_recv+0x55>
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	85 db                	test   %ebx,%ebx
  801854:	75 03                	jne    801859 <ipc_recv+0x53>
  801856:	8b 50 74             	mov    0x74(%eax),%edx
  801859:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  80185b:	85 ff                	test   %edi,%edi
  80185d:	74 13                	je     801872 <ipc_recv+0x6c>
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
  801864:	85 db                	test   %ebx,%ebx
  801866:	75 08                	jne    801870 <ipc_recv+0x6a>
  801868:	a1 08 50 80 00       	mov    0x805008,%eax
  80186d:	8b 40 78             	mov    0x78(%eax),%eax
  801870:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  801872:	85 db                	test   %ebx,%ebx
  801874:	75 08                	jne    80187e <ipc_recv+0x78>
  801876:	a1 08 50 80 00       	mov    0x805008,%eax
  80187b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  80187e:	89 d8                	mov    %ebx,%eax
  801880:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801883:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801886:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801889:	89 ec                	mov    %ebp,%esp
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    
  80188d:	00 00                	add    %al,(%eax)
	...

00801890 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	05 00 00 00 30       	add    $0x30000000,%eax
  80189b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    

008018a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	89 04 24             	mov    %eax,(%esp)
  8018ac:	e8 df ff ff ff       	call   801890 <fd2num>
  8018b1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8018b6:	c1 e0 0c             	shl    $0xc,%eax
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	57                   	push   %edi
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018c4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8018c9:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8018ce:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018d3:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	c1 ea 16             	shr    $0x16,%edx
  8018da:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8018dd:	f6 c2 01             	test   $0x1,%dl
  8018e0:	74 0d                	je     8018ef <fd_alloc+0x34>
  8018e2:	89 c2                	mov    %eax,%edx
  8018e4:	c1 ea 0c             	shr    $0xc,%edx
  8018e7:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8018ea:	f6 c2 01             	test   $0x1,%dl
  8018ed:	75 09                	jne    8018f8 <fd_alloc+0x3d>
			*fd_store = fd;
  8018ef:	89 37                	mov    %esi,(%edi)
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8018f6:	eb 17                	jmp    80190f <fd_alloc+0x54>
  8018f8:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8018fd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801902:	75 cf                	jne    8018d3 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801904:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  80190a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	83 f8 1f             	cmp    $0x1f,%eax
  80191d:	77 36                	ja     801955 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80191f:	05 00 00 0d 00       	add    $0xd0000,%eax
  801924:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801927:	89 c2                	mov    %eax,%edx
  801929:	c1 ea 16             	shr    $0x16,%edx
  80192c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801933:	f6 c2 01             	test   $0x1,%dl
  801936:	74 1d                	je     801955 <fd_lookup+0x41>
  801938:	89 c2                	mov    %eax,%edx
  80193a:	c1 ea 0c             	shr    $0xc,%edx
  80193d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801944:	f6 c2 01             	test   $0x1,%dl
  801947:	74 0c                	je     801955 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	89 02                	mov    %eax,(%edx)
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801953:	eb 05                	jmp    80195a <fd_lookup+0x46>
  801955:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801962:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801965:	89 44 24 04          	mov    %eax,0x4(%esp)
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	89 04 24             	mov    %eax,(%esp)
  80196f:	e8 a0 ff ff ff       	call   801914 <fd_lookup>
  801974:	85 c0                	test   %eax,%eax
  801976:	78 0e                	js     801986 <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197e:	89 50 04             	mov    %edx,0x4(%eax)
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	83 ec 10             	sub    $0x10,%esp
  801990:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801996:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80199b:	be d8 36 80 00       	mov    $0x8036d8,%esi
  8019a0:	eb 10                	jmp    8019b2 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8019a2:	39 08                	cmp    %ecx,(%eax)
  8019a4:	75 09                	jne    8019af <dev_lookup+0x27>
			*dev = devtab[i];
  8019a6:	89 03                	mov    %eax,(%ebx)
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8019ad:	eb 31                	jmp    8019e0 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8019af:	83 c2 01             	add    $0x1,%edx
  8019b2:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	75 e9                	jne    8019a2 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019b9:	a1 08 50 80 00       	mov    0x805008,%eax
  8019be:	8b 40 48             	mov    0x48(%eax),%eax
  8019c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c9:	c7 04 24 58 36 80 00 	movl   $0x803658,(%esp)
  8019d0:	e8 b8 ee ff ff       	call   80088d <cprintf>
	*dev = 0;
  8019d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    

008019e7 <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	53                   	push   %ebx
  8019eb:	83 ec 24             	sub    $0x24,%esp
  8019ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	89 04 24             	mov    %eax,(%esp)
  8019fe:	e8 11 ff ff ff       	call   801914 <fd_lookup>
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 53                	js     801a5a <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	89 04 24             	mov    %eax,(%esp)
  801a16:	e8 6d ff ff ff       	call   801988 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 3b                	js     801a5a <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801a1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a27:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801a2b:	74 2d                	je     801a5a <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a2d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a30:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a37:	00 00 00 
	stat->st_isdir = 0;
  801a3a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a41:	00 00 00 
	stat->st_dev = dev;
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a54:	89 14 24             	mov    %edx,(%esp)
  801a57:	ff 50 14             	call   *0x14(%eax)
}
  801a5a:	83 c4 24             	add    $0x24,%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    

00801a60 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	53                   	push   %ebx
  801a64:	83 ec 24             	sub    $0x24,%esp
  801a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a71:	89 1c 24             	mov    %ebx,(%esp)
  801a74:	e8 9b fe ff ff       	call   801914 <fd_lookup>
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 5f                	js     801adc <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	8b 00                	mov    (%eax),%eax
  801a89:	89 04 24             	mov    %eax,(%esp)
  801a8c:	e8 f7 fe ff ff       	call   801988 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 47                	js     801adc <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a98:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a9c:	75 23                	jne    801ac1 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a9e:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aa3:	8b 40 48             	mov    0x48(%eax),%eax
  801aa6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aae:	c7 04 24 78 36 80 00 	movl   $0x803678,(%esp)
  801ab5:	e8 d3 ed ff ff       	call   80088d <cprintf>
  801aba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801abf:	eb 1b                	jmp    801adc <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	8b 48 18             	mov    0x18(%eax),%ecx
  801ac7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801acc:	85 c9                	test   %ecx,%ecx
  801ace:	74 0c                	je     801adc <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad7:	89 14 24             	mov    %edx,(%esp)
  801ada:	ff d1                	call   *%ecx
}
  801adc:	83 c4 24             	add    $0x24,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    

00801ae2 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 24             	sub    $0x24,%esp
  801ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af3:	89 1c 24             	mov    %ebx,(%esp)
  801af6:	e8 19 fe ff ff       	call   801914 <fd_lookup>
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 66                	js     801b65 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b09:	8b 00                	mov    (%eax),%eax
  801b0b:	89 04 24             	mov    %eax,(%esp)
  801b0e:	e8 75 fe ff ff       	call   801988 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 4e                	js     801b65 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b1a:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801b1e:	75 23                	jne    801b43 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b20:	a1 08 50 80 00       	mov    0x805008,%eax
  801b25:	8b 40 48             	mov    0x48(%eax),%eax
  801b28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b30:	c7 04 24 9c 36 80 00 	movl   $0x80369c,(%esp)
  801b37:	e8 51 ed ff ff       	call   80088d <cprintf>
  801b3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b41:	eb 22                	jmp    801b65 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	8b 48 0c             	mov    0xc(%eax),%ecx
  801b49:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4e:	85 c9                	test   %ecx,%ecx
  801b50:	74 13                	je     801b65 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b52:	8b 45 10             	mov    0x10(%ebp),%eax
  801b55:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b60:	89 14 24             	mov    %edx,(%esp)
  801b63:	ff d1                	call   *%ecx
}
  801b65:	83 c4 24             	add    $0x24,%esp
  801b68:	5b                   	pop    %ebx
  801b69:	5d                   	pop    %ebp
  801b6a:	c3                   	ret    

00801b6b <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	53                   	push   %ebx
  801b6f:	83 ec 24             	sub    $0x24,%esp
  801b72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7c:	89 1c 24             	mov    %ebx,(%esp)
  801b7f:	e8 90 fd ff ff       	call   801914 <fd_lookup>
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 6b                	js     801bf3 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b92:	8b 00                	mov    (%eax),%eax
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	e8 ec fd ff ff       	call   801988 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 53                	js     801bf3 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ba0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba3:	8b 42 08             	mov    0x8(%edx),%eax
  801ba6:	83 e0 03             	and    $0x3,%eax
  801ba9:	83 f8 01             	cmp    $0x1,%eax
  801bac:	75 23                	jne    801bd1 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801bae:	a1 08 50 80 00       	mov    0x805008,%eax
  801bb3:	8b 40 48             	mov    0x48(%eax),%eax
  801bb6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbe:	c7 04 24 b9 36 80 00 	movl   $0x8036b9,(%esp)
  801bc5:	e8 c3 ec ff ff       	call   80088d <cprintf>
  801bca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801bcf:	eb 22                	jmp    801bf3 <read+0x88>
	}
	if (!dev->dev_read)
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 48 08             	mov    0x8(%eax),%ecx
  801bd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bdc:	85 c9                	test   %ecx,%ecx
  801bde:	74 13                	je     801bf3 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801be0:	8b 45 10             	mov    0x10(%ebp),%eax
  801be3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bee:	89 14 24             	mov    %edx,(%esp)
  801bf1:	ff d1                	call   *%ecx
}
  801bf3:	83 c4 24             	add    $0x24,%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    

00801bf9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	57                   	push   %edi
  801bfd:	56                   	push   %esi
  801bfe:	53                   	push   %ebx
  801bff:	83 ec 1c             	sub    $0x1c,%esp
  801c02:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c05:	8b 75 10             	mov    0x10(%ebp),%esi
  801c08:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c0d:	eb 21                	jmp    801c30 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c0f:	89 f2                	mov    %esi,%edx
  801c11:	29 c2                	sub    %eax,%edx
  801c13:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c17:	03 45 0c             	add    0xc(%ebp),%eax
  801c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1e:	89 3c 24             	mov    %edi,(%esp)
  801c21:	e8 45 ff ff ff       	call   801b6b <read>
		if (m < 0)
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 0e                	js     801c38 <readn+0x3f>
			return m;
		if (m == 0)
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	74 08                	je     801c36 <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c2e:	01 c3                	add    %eax,%ebx
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	39 f3                	cmp    %esi,%ebx
  801c34:	72 d9                	jb     801c0f <readn+0x16>
  801c36:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801c38:	83 c4 1c             	add    $0x1c,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 38             	sub    $0x38,%esp
  801c46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c49:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c4c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c52:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c56:	89 3c 24             	mov    %edi,(%esp)
  801c59:	e8 32 fc ff ff       	call   801890 <fd2num>
  801c5e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801c61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c65:	89 04 24             	mov    %eax,(%esp)
  801c68:	e8 a7 fc ff ff       	call   801914 <fd_lookup>
  801c6d:	89 c3                	mov    %eax,%ebx
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 05                	js     801c78 <fd_close+0x38>
  801c73:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801c76:	74 0e                	je     801c86 <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801c78:	89 f0                	mov    %esi,%eax
  801c7a:	84 c0                	test   %al,%al
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c81:	0f 44 d8             	cmove  %eax,%ebx
  801c84:	eb 3d                	jmp    801cc3 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c86:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8d:	8b 07                	mov    (%edi),%eax
  801c8f:	89 04 24             	mov    %eax,(%esp)
  801c92:	e8 f1 fc ff ff       	call   801988 <dev_lookup>
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 16                	js     801cb3 <fd_close+0x73>
		if (dev->dev_close)
  801c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca0:	8b 40 10             	mov    0x10(%eax),%eax
  801ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	74 07                	je     801cb3 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801cac:	89 3c 24             	mov    %edi,(%esp)
  801caf:	ff d0                	call   *%eax
  801cb1:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801cb3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cbe:	e8 bf f8 ff ff       	call   801582 <sys_page_unmap>
	return r;
}
  801cc3:	89 d8                	mov    %ebx,%eax
  801cc5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cc8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ccb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cce:	89 ec                	mov    %ebp,%esp
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    

00801cd2 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	89 04 24             	mov    %eax,(%esp)
  801ce5:	e8 2a fc ff ff       	call   801914 <fd_lookup>
  801cea:	85 c0                	test   %eax,%eax
  801cec:	78 13                	js     801d01 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801cee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801cf5:	00 
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	89 04 24             	mov    %eax,(%esp)
  801cfc:	e8 3f ff ff ff       	call   801c40 <fd_close>
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 18             	sub    $0x18,%esp
  801d09:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d0c:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d16:	00 
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 04 24             	mov    %eax,(%esp)
  801d1d:	e8 25 04 00 00       	call   802147 <open>
  801d22:	89 c3                	mov    %eax,%ebx
  801d24:	85 c0                	test   %eax,%eax
  801d26:	78 1b                	js     801d43 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2f:	89 1c 24             	mov    %ebx,(%esp)
  801d32:	e8 b0 fc ff ff       	call   8019e7 <fstat>
  801d37:	89 c6                	mov    %eax,%esi
	close(fd);
  801d39:	89 1c 24             	mov    %ebx,(%esp)
  801d3c:	e8 91 ff ff ff       	call   801cd2 <close>
  801d41:	89 f3                	mov    %esi,%ebx
	return r;
}
  801d43:	89 d8                	mov    %ebx,%eax
  801d45:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d48:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d4b:	89 ec                	mov    %ebp,%esp
  801d4d:	5d                   	pop    %ebp
  801d4e:	c3                   	ret    

00801d4f <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	53                   	push   %ebx
  801d53:	83 ec 14             	sub    $0x14,%esp
  801d56:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801d5b:	89 1c 24             	mov    %ebx,(%esp)
  801d5e:	e8 6f ff ff ff       	call   801cd2 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d63:	83 c3 01             	add    $0x1,%ebx
  801d66:	83 fb 20             	cmp    $0x20,%ebx
  801d69:	75 f0                	jne    801d5b <close_all+0xc>
		close(i);
}
  801d6b:	83 c4 14             	add    $0x14,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 58             	sub    $0x58,%esp
  801d77:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d7a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d7d:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d80:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d86:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	89 04 24             	mov    %eax,(%esp)
  801d90:	e8 7f fb ff ff       	call   801914 <fd_lookup>
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	85 c0                	test   %eax,%eax
  801d99:	0f 88 e0 00 00 00    	js     801e7f <dup+0x10e>
		return r;
	close(newfdnum);
  801d9f:	89 3c 24             	mov    %edi,(%esp)
  801da2:	e8 2b ff ff ff       	call   801cd2 <close>

	newfd = INDEX2FD(newfdnum);
  801da7:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801dad:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db3:	89 04 24             	mov    %eax,(%esp)
  801db6:	e8 e5 fa ff ff       	call   8018a0 <fd2data>
  801dbb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801dbd:	89 34 24             	mov    %esi,(%esp)
  801dc0:	e8 db fa ff ff       	call   8018a0 <fd2data>
  801dc5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dc8:	89 da                	mov    %ebx,%edx
  801dca:	89 d8                	mov    %ebx,%eax
  801dcc:	c1 e8 16             	shr    $0x16,%eax
  801dcf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801dd6:	a8 01                	test   $0x1,%al
  801dd8:	74 43                	je     801e1d <dup+0xac>
  801dda:	c1 ea 0c             	shr    $0xc,%edx
  801ddd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801de4:	a8 01                	test   $0x1,%al
  801de6:	74 35                	je     801e1d <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801de8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801def:	25 07 0e 00 00       	and    $0xe07,%eax
  801df4:	89 44 24 10          	mov    %eax,0x10(%esp)
  801df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e06:	00 
  801e07:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e12:	e8 c9 f7 ff ff       	call   8015e0 <sys_page_map>
  801e17:	89 c3                	mov    %eax,%ebx
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 3f                	js     801e5c <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e20:	89 c2                	mov    %eax,%edx
  801e22:	c1 ea 0c             	shr    $0xc,%edx
  801e25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e2c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801e32:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e36:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e41:	00 
  801e42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e4d:	e8 8e f7 ff ff       	call   8015e0 <sys_page_map>
  801e52:	89 c3                	mov    %eax,%ebx
  801e54:	85 c0                	test   %eax,%eax
  801e56:	78 04                	js     801e5c <dup+0xeb>
  801e58:	89 fb                	mov    %edi,%ebx
  801e5a:	eb 23                	jmp    801e7f <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801e5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e67:	e8 16 f7 ff ff       	call   801582 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e7a:	e8 03 f7 ff ff       	call   801582 <sys_page_unmap>
	return r;
}
  801e7f:	89 d8                	mov    %ebx,%eax
  801e81:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e84:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e87:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e8a:	89 ec                	mov    %ebp,%esp
  801e8c:	5d                   	pop    %ebp
  801e8d:	c3                   	ret    
	...

00801e90 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	56                   	push   %esi
  801e94:	53                   	push   %ebx
  801e95:	83 ec 10             	sub    $0x10,%esp
  801e98:	89 c3                	mov    %eax,%ebx
  801e9a:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801e9c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ea3:	75 11                	jne    801eb6 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ea5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801eac:	e8 b3 f8 ff ff       	call   801764 <ipc_find_env>
  801eb1:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801eb6:	a1 08 50 80 00       	mov    0x805008,%eax
  801ebb:	8b 40 48             	mov    0x48(%eax),%eax
  801ebe:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801ec4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ec8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed0:	c7 04 24 ec 36 80 00 	movl   $0x8036ec,(%esp)
  801ed7:	e8 b1 e9 ff ff       	call   80088d <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801edc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ee3:	00 
  801ee4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801eeb:	00 
  801eec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  801ef5:	89 04 24             	mov    %eax,(%esp)
  801ef8:	e8 9d f8 ff ff       	call   80179a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801efd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f04:	00 
  801f05:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f10:	e8 f1 f8 ff ff       	call   801806 <ipc_recv>
}
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	5b                   	pop    %ebx
  801f19:	5e                   	pop    %esi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    

00801f1c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	8b 40 0c             	mov    0xc(%eax),%eax
  801f28:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f30:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f35:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3a:	b8 02 00 00 00       	mov    $0x2,%eax
  801f3f:	e8 4c ff ff ff       	call   801e90 <fsipc>
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f52:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5c:	b8 06 00 00 00       	mov    $0x6,%eax
  801f61:	e8 2a ff ff ff       	call   801e90 <fsipc>
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f73:	b8 08 00 00 00       	mov    $0x8,%eax
  801f78:	e8 13 ff ff ff       	call   801e90 <fsipc>
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	53                   	push   %ebx
  801f83:	83 ec 14             	sub    $0x14,%esp
  801f86:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8f:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f94:	ba 00 00 00 00       	mov    $0x0,%edx
  801f99:	b8 05 00 00 00       	mov    $0x5,%eax
  801f9e:	e8 ed fe ff ff       	call   801e90 <fsipc>
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 2b                	js     801fd2 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fa7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fae:	00 
  801faf:	89 1c 24             	mov    %ebx,(%esp)
  801fb2:	e8 42 ef ff ff       	call   800ef9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fb7:	a1 80 60 80 00       	mov    0x806080,%eax
  801fbc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fc2:	a1 84 60 80 00       	mov    0x806084,%eax
  801fc7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801fd2:	83 c4 14             	add    $0x14,%esp
  801fd5:	5b                   	pop    %ebx
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    

00801fd8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	53                   	push   %ebx
  801fdc:	83 ec 14             	sub    $0x14,%esp
  801fdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801fed:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801ff3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801ff9:	76 24                	jbe    80201f <devfile_write+0x47>
  801ffb:	c7 44 24 0c 02 37 80 	movl   $0x803702,0xc(%esp)
  802002:	00 
  802003:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  80200a:	00 
  80200b:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  802012:	00 
  802013:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  80201a:	e8 b5 e7 ff ff       	call   8007d4 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  80201f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802023:	8b 45 0c             	mov    0xc(%ebp),%eax
  802026:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202a:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  802031:	e8 69 f0 ff ff       	call   80109f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  802036:	ba 00 00 00 00       	mov    $0x0,%edx
  80203b:	b8 04 00 00 00       	mov    $0x4,%eax
  802040:	e8 4b fe ff ff       	call   801e90 <fsipc>
	if(ret<0) return ret;
  802045:	85 c0                	test   %eax,%eax
  802047:	78 53                	js     80209c <devfile_write+0xc4>
	
	assert(ret <= n);
  802049:	39 c3                	cmp    %eax,%ebx
  80204b:	73 24                	jae    802071 <devfile_write+0x99>
  80204d:	c7 44 24 0c 2c 37 80 	movl   $0x80372c,0xc(%esp)
  802054:	00 
  802055:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  80205c:	00 
  80205d:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  802064:	00 
  802065:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  80206c:	e8 63 e7 ff ff       	call   8007d4 <_panic>
	assert(ret <= PGSIZE);
  802071:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802076:	7e 24                	jle    80209c <devfile_write+0xc4>
  802078:	c7 44 24 0c 35 37 80 	movl   $0x803735,0xc(%esp)
  80207f:	00 
  802080:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  802087:	00 
  802088:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  80208f:	00 
  802090:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  802097:	e8 38 e7 ff ff       	call   8007d4 <_panic>
	return ret;
}
  80209c:	83 c4 14             	add    $0x14,%esp
  80209f:	5b                   	pop    %ebx
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    

008020a2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	56                   	push   %esi
  8020a6:	53                   	push   %ebx
  8020a7:	83 ec 10             	sub    $0x10,%esp
  8020aa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020b8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020be:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c3:	b8 03 00 00 00       	mov    $0x3,%eax
  8020c8:	e8 c3 fd ff ff       	call   801e90 <fsipc>
  8020cd:	89 c3                	mov    %eax,%ebx
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	78 6b                	js     80213e <devfile_read+0x9c>
		return r;
	assert(r <= n);
  8020d3:	39 de                	cmp    %ebx,%esi
  8020d5:	73 24                	jae    8020fb <devfile_read+0x59>
  8020d7:	c7 44 24 0c 43 37 80 	movl   $0x803743,0xc(%esp)
  8020de:	00 
  8020df:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  8020e6:	00 
  8020e7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8020ee:	00 
  8020ef:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  8020f6:	e8 d9 e6 ff ff       	call   8007d4 <_panic>
	assert(r <= PGSIZE);
  8020fb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802101:	7e 24                	jle    802127 <devfile_read+0x85>
  802103:	c7 44 24 0c 4a 37 80 	movl   $0x80374a,0xc(%esp)
  80210a:	00 
  80210b:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  802112:	00 
  802113:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  80211a:	00 
  80211b:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  802122:	e8 ad e6 ff ff       	call   8007d4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802127:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212b:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802132:	00 
  802133:	8b 45 0c             	mov    0xc(%ebp),%eax
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	e8 61 ef ff ff       	call   80109f <memmove>
	return r;
}
  80213e:	89 d8                	mov    %ebx,%eax
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5d                   	pop    %ebp
  802146:	c3                   	ret    

00802147 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 28             	sub    $0x28,%esp
  80214d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802150:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802153:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802156:	89 34 24             	mov    %esi,(%esp)
  802159:	e8 62 ed ff ff       	call   800ec0 <strlen>
  80215e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802163:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802168:	7f 5e                	jg     8021c8 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80216a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80216d:	89 04 24             	mov    %eax,(%esp)
  802170:	e8 46 f7 ff ff       	call   8018bb <fd_alloc>
  802175:	89 c3                	mov    %eax,%ebx
  802177:	85 c0                	test   %eax,%eax
  802179:	78 4d                	js     8021c8 <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80217b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80217f:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802186:	e8 6e ed ff ff       	call   800ef9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80218b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218e:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802196:	b8 01 00 00 00       	mov    $0x1,%eax
  80219b:	e8 f0 fc ff ff       	call   801e90 <fsipc>
  8021a0:	89 c3                	mov    %eax,%ebx
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	79 15                	jns    8021bb <open+0x74>
		fd_close(fd, 0);
  8021a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021ad:	00 
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	89 04 24             	mov    %eax,(%esp)
  8021b4:	e8 87 fa ff ff       	call   801c40 <fd_close>
		return r;
  8021b9:	eb 0d                	jmp    8021c8 <open+0x81>
	}

	return fd2num(fd);
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	89 04 24             	mov    %eax,(%esp)
  8021c1:	e8 ca f6 ff ff       	call   801890 <fd2num>
  8021c6:	89 c3                	mov    %eax,%ebx
}
  8021c8:	89 d8                	mov    %ebx,%eax
  8021ca:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021cd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021d0:	89 ec                	mov    %ebp,%esp
  8021d2:	5d                   	pop    %ebp
  8021d3:	c3                   	ret    
	...

008021e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8021e6:	c7 44 24 04 56 37 80 	movl   $0x803756,0x4(%esp)
  8021ed:	00 
  8021ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 00 ed ff ff       	call   800ef9 <strcpy>
	return 0;
}
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	53                   	push   %ebx
  802204:	83 ec 14             	sub    $0x14,%esp
  802207:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80220a:	89 1c 24             	mov    %ebx,(%esp)
  80220d:	e8 22 0a 00 00       	call   802c34 <pageref>
  802212:	89 c2                	mov    %eax,%edx
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
  802219:	83 fa 01             	cmp    $0x1,%edx
  80221c:	75 0b                	jne    802229 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80221e:	8b 43 0c             	mov    0xc(%ebx),%eax
  802221:	89 04 24             	mov    %eax,(%esp)
  802224:	e8 b1 02 00 00       	call   8024da <nsipc_close>
	else
		return 0;
}
  802229:	83 c4 14             	add    $0x14,%esp
  80222c:	5b                   	pop    %ebx
  80222d:	5d                   	pop    %ebp
  80222e:	c3                   	ret    

0080222f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802235:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80223c:	00 
  80223d:	8b 45 10             	mov    0x10(%ebp),%eax
  802240:	89 44 24 08          	mov    %eax,0x8(%esp)
  802244:	8b 45 0c             	mov    0xc(%ebp),%eax
  802247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 40 0c             	mov    0xc(%eax),%eax
  802251:	89 04 24             	mov    %eax,(%esp)
  802254:	e8 bd 02 00 00       	call   802516 <nsipc_send>
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802261:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802268:	00 
  802269:	8b 45 10             	mov    0x10(%ebp),%eax
  80226c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	89 44 24 04          	mov    %eax,0x4(%esp)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 40 0c             	mov    0xc(%eax),%eax
  80227d:	89 04 24             	mov    %eax,(%esp)
  802280:	e8 04 03 00 00       	call   802589 <nsipc_recv>
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	56                   	push   %esi
  80228b:	53                   	push   %ebx
  80228c:	83 ec 20             	sub    $0x20,%esp
  80228f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802291:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802294:	89 04 24             	mov    %eax,(%esp)
  802297:	e8 1f f6 ff ff       	call   8018bb <fd_alloc>
  80229c:	89 c3                	mov    %eax,%ebx
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	78 21                	js     8022c3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8022a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022a9:	00 
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b8:	e8 81 f3 ff ff       	call   80163e <sys_page_alloc>
  8022bd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	79 0a                	jns    8022cd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8022c3:	89 34 24             	mov    %esi,(%esp)
  8022c6:	e8 0f 02 00 00       	call   8024da <nsipc_close>
		return r;
  8022cb:	eb 28                	jmp    8022f5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8022cd:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	89 04 24             	mov    %eax,(%esp)
  8022ee:	e8 9d f5 ff ff       	call   801890 <fd2num>
  8022f3:	89 c3                	mov    %eax,%ebx
}
  8022f5:	89 d8                	mov    %ebx,%eax
  8022f7:	83 c4 20             	add    $0x20,%esp
  8022fa:	5b                   	pop    %ebx
  8022fb:	5e                   	pop    %esi
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802304:	8b 45 10             	mov    0x10(%ebp),%eax
  802307:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	89 04 24             	mov    %eax,(%esp)
  802318:	e8 71 01 00 00       	call   80248e <nsipc_socket>
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 05                	js     802326 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802321:	e8 61 ff ff ff       	call   802287 <alloc_sockfd>
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80232e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802331:	89 54 24 04          	mov    %edx,0x4(%esp)
  802335:	89 04 24             	mov    %eax,(%esp)
  802338:	e8 d7 f5 ff ff       	call   801914 <fd_lookup>
  80233d:	85 c0                	test   %eax,%eax
  80233f:	78 15                	js     802356 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802344:	8b 0a                	mov    (%edx),%ecx
  802346:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80234b:	3b 0d 24 40 80 00    	cmp    0x804024,%ecx
  802351:	75 03                	jne    802356 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802353:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	e8 c2 ff ff ff       	call   802328 <fd2sockid>
  802366:	85 c0                	test   %eax,%eax
  802368:	78 0f                	js     802379 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80236a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802371:	89 04 24             	mov    %eax,(%esp)
  802374:	e8 3f 01 00 00       	call   8024b8 <nsipc_listen>
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	e8 9f ff ff ff       	call   802328 <fd2sockid>
  802389:	85 c0                	test   %eax,%eax
  80238b:	78 16                	js     8023a3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80238d:	8b 55 10             	mov    0x10(%ebp),%edx
  802390:	89 54 24 08          	mov    %edx,0x8(%esp)
  802394:	8b 55 0c             	mov    0xc(%ebp),%edx
  802397:	89 54 24 04          	mov    %edx,0x4(%esp)
  80239b:	89 04 24             	mov    %eax,(%esp)
  80239e:	e8 66 02 00 00       	call   802609 <nsipc_connect>
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	e8 75 ff ff ff       	call   802328 <fd2sockid>
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	78 0f                	js     8023c6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8023b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 2e 01 00 00       	call   8024f4 <nsipc_shutdown>
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	e8 52 ff ff ff       	call   802328 <fd2sockid>
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	78 16                	js     8023f0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8023da:	8b 55 10             	mov    0x10(%ebp),%edx
  8023dd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e8:	89 04 24             	mov    %eax,(%esp)
  8023eb:	e8 58 02 00 00       	call   802648 <nsipc_bind>
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	e8 28 ff ff ff       	call   802328 <fd2sockid>
  802400:	85 c0                	test   %eax,%eax
  802402:	78 1f                	js     802423 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802404:	8b 55 10             	mov    0x10(%ebp),%edx
  802407:	89 54 24 08          	mov    %edx,0x8(%esp)
  80240b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802412:	89 04 24             	mov    %eax,(%esp)
  802415:	e8 6d 02 00 00       	call   802687 <nsipc_accept>
  80241a:	85 c0                	test   %eax,%eax
  80241c:	78 05                	js     802423 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80241e:	e8 64 fe ff ff       	call   802287 <alloc_sockfd>
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    
  802425:	00 00                	add    %al,(%eax)
	...

00802428 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	53                   	push   %ebx
  80242c:	83 ec 14             	sub    $0x14,%esp
  80242f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802431:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802438:	75 11                	jne    80244b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80243a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802441:	e8 1e f3 ff ff       	call   801764 <ipc_find_env>
  802446:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80244b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802452:	00 
  802453:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80245a:	00 
  80245b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80245f:	a1 04 50 80 00       	mov    0x805004,%eax
  802464:	89 04 24             	mov    %eax,(%esp)
  802467:	e8 2e f3 ff ff       	call   80179a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80246c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802473:	00 
  802474:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80247b:	00 
  80247c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802483:	e8 7e f3 ff ff       	call   801806 <ipc_recv>
}
  802488:	83 c4 14             	add    $0x14,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5d                   	pop    %ebp
  80248d:	c3                   	ret    

0080248e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80249c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8024a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8024ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8024b1:	e8 72 ff ff ff       	call   802428 <nsipc>
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
  8024bb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8024c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8024ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8024d3:	e8 50 ff ff ff       	call   802428 <nsipc>
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8024e8:	b8 04 00 00 00       	mov    $0x4,%eax
  8024ed:	e8 36 ff ff ff       	call   802428 <nsipc>
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802502:	8b 45 0c             	mov    0xc(%ebp),%eax
  802505:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80250a:	b8 03 00 00 00       	mov    $0x3,%eax
  80250f:	e8 14 ff ff ff       	call   802428 <nsipc>
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	53                   	push   %ebx
  80251a:	83 ec 14             	sub    $0x14,%esp
  80251d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802528:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80252e:	7e 24                	jle    802554 <nsipc_send+0x3e>
  802530:	c7 44 24 0c 62 37 80 	movl   $0x803762,0xc(%esp)
  802537:	00 
  802538:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  80253f:	00 
  802540:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802547:	00 
  802548:	c7 04 24 6e 37 80 00 	movl   $0x80376e,(%esp)
  80254f:	e8 80 e2 ff ff       	call   8007d4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802554:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802566:	e8 34 eb ff ff       	call   80109f <memmove>
	nsipcbuf.send.req_size = size;
  80256b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802571:	8b 45 14             	mov    0x14(%ebp),%eax
  802574:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802579:	b8 08 00 00 00       	mov    $0x8,%eax
  80257e:	e8 a5 fe ff ff       	call   802428 <nsipc>
}
  802583:	83 c4 14             	add    $0x14,%esp
  802586:	5b                   	pop    %ebx
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    

00802589 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	56                   	push   %esi
  80258d:	53                   	push   %ebx
  80258e:	83 ec 10             	sub    $0x10,%esp
  802591:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80259c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8025a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8025a5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8025aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8025af:	e8 74 fe ff ff       	call   802428 <nsipc>
  8025b4:	89 c3                	mov    %eax,%ebx
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	78 46                	js     802600 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8025ba:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8025bf:	7f 04                	jg     8025c5 <nsipc_recv+0x3c>
  8025c1:	39 c6                	cmp    %eax,%esi
  8025c3:	7d 24                	jge    8025e9 <nsipc_recv+0x60>
  8025c5:	c7 44 24 0c 7a 37 80 	movl   $0x80377a,0xc(%esp)
  8025cc:	00 
  8025cd:	c7 44 24 08 0c 37 80 	movl   $0x80370c,0x8(%esp)
  8025d4:	00 
  8025d5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8025dc:	00 
  8025dd:	c7 04 24 6e 37 80 00 	movl   $0x80376e,(%esp)
  8025e4:	e8 eb e1 ff ff       	call   8007d4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025ed:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8025f4:	00 
  8025f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f8:	89 04 24             	mov    %eax,(%esp)
  8025fb:	e8 9f ea ff ff       	call   80109f <memmove>
	}

	return r;
}
  802600:	89 d8                	mov    %ebx,%eax
  802602:	83 c4 10             	add    $0x10,%esp
  802605:	5b                   	pop    %ebx
  802606:	5e                   	pop    %esi
  802607:	5d                   	pop    %ebp
  802608:	c3                   	ret    

00802609 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	53                   	push   %ebx
  80260d:	83 ec 14             	sub    $0x14,%esp
  802610:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80261b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80261f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802622:	89 44 24 04          	mov    %eax,0x4(%esp)
  802626:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80262d:	e8 6d ea ff ff       	call   80109f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802632:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802638:	b8 05 00 00 00       	mov    $0x5,%eax
  80263d:	e8 e6 fd ff ff       	call   802428 <nsipc>
}
  802642:	83 c4 14             	add    $0x14,%esp
  802645:	5b                   	pop    %ebx
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    

00802648 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	53                   	push   %ebx
  80264c:	83 ec 14             	sub    $0x14,%esp
  80264f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80265a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80265e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802661:	89 44 24 04          	mov    %eax,0x4(%esp)
  802665:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80266c:	e8 2e ea ff ff       	call   80109f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802671:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802677:	b8 02 00 00 00       	mov    $0x2,%eax
  80267c:	e8 a7 fd ff ff       	call   802428 <nsipc>
}
  802681:	83 c4 14             	add    $0x14,%esp
  802684:	5b                   	pop    %ebx
  802685:	5d                   	pop    %ebp
  802686:	c3                   	ret    

00802687 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 28             	sub    $0x28,%esp
  80268d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802690:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802693:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802696:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8026a1:	8b 07                	mov    (%edi),%eax
  8026a3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8026a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ad:	e8 76 fd ff ff       	call   802428 <nsipc>
  8026b2:	89 c6                	mov    %eax,%esi
  8026b4:	85 c0                	test   %eax,%eax
  8026b6:	78 22                	js     8026da <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8026b8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8026bd:	8b 03                	mov    (%ebx),%eax
  8026bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8026ca:	00 
  8026cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ce:	89 04 24             	mov    %eax,(%esp)
  8026d1:	e8 c9 e9 ff ff       	call   80109f <memmove>
		*addrlen = ret->ret_addrlen;
  8026d6:	8b 03                	mov    (%ebx),%eax
  8026d8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8026da:	89 f0                	mov    %esi,%eax
  8026dc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8026df:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8026e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8026e5:	89 ec                	mov    %ebp,%esp
  8026e7:	5d                   	pop    %ebp
  8026e8:	c3                   	ret    
  8026e9:	00 00                	add    %al,(%eax)
	...

008026ec <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 18             	sub    $0x18,%esp
  8026f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8026f5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8026f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	89 04 24             	mov    %eax,(%esp)
  802701:	e8 9a f1 ff ff       	call   8018a0 <fd2data>
  802706:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802708:	c7 44 24 04 8f 37 80 	movl   $0x80378f,0x4(%esp)
  80270f:	00 
  802710:	89 34 24             	mov    %esi,(%esp)
  802713:	e8 e1 e7 ff ff       	call   800ef9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802718:	8b 43 04             	mov    0x4(%ebx),%eax
  80271b:	2b 03                	sub    (%ebx),%eax
  80271d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802723:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80272a:	00 00 00 
	stat->st_dev = &devpipe;
  80272d:	c7 86 88 00 00 00 40 	movl   $0x804040,0x88(%esi)
  802734:	40 80 00 
	return 0;
}
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
  80273c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80273f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802742:	89 ec                	mov    %ebp,%esp
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    

00802746 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	53                   	push   %ebx
  80274a:	83 ec 14             	sub    $0x14,%esp
  80274d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802750:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802754:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80275b:	e8 22 ee ff ff       	call   801582 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802760:	89 1c 24             	mov    %ebx,(%esp)
  802763:	e8 38 f1 ff ff       	call   8018a0 <fd2data>
  802768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802773:	e8 0a ee ff ff       	call   801582 <sys_page_unmap>
}
  802778:	83 c4 14             	add    $0x14,%esp
  80277b:	5b                   	pop    %ebx
  80277c:	5d                   	pop    %ebp
  80277d:	c3                   	ret    

0080277e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	57                   	push   %edi
  802782:	56                   	push   %esi
  802783:	53                   	push   %ebx
  802784:	83 ec 2c             	sub    $0x2c,%esp
  802787:	89 c7                	mov    %eax,%edi
  802789:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80278c:	a1 08 50 80 00       	mov    0x805008,%eax
  802791:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802794:	89 3c 24             	mov    %edi,(%esp)
  802797:	e8 98 04 00 00       	call   802c34 <pageref>
  80279c:	89 c6                	mov    %eax,%esi
  80279e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a1:	89 04 24             	mov    %eax,(%esp)
  8027a4:	e8 8b 04 00 00       	call   802c34 <pageref>
  8027a9:	39 c6                	cmp    %eax,%esi
  8027ab:	0f 94 c0             	sete   %al
  8027ae:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8027b1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8027b7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8027ba:	39 cb                	cmp    %ecx,%ebx
  8027bc:	75 08                	jne    8027c6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8027be:	83 c4 2c             	add    $0x2c,%esp
  8027c1:	5b                   	pop    %ebx
  8027c2:	5e                   	pop    %esi
  8027c3:	5f                   	pop    %edi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8027c6:	83 f8 01             	cmp    $0x1,%eax
  8027c9:	75 c1                	jne    80278c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8027cb:	8b 52 58             	mov    0x58(%edx),%edx
  8027ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027da:	c7 04 24 96 37 80 00 	movl   $0x803796,(%esp)
  8027e1:	e8 a7 e0 ff ff       	call   80088d <cprintf>
  8027e6:	eb a4                	jmp    80278c <_pipeisclosed+0xe>

008027e8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	57                   	push   %edi
  8027ec:	56                   	push   %esi
  8027ed:	53                   	push   %ebx
  8027ee:	83 ec 1c             	sub    $0x1c,%esp
  8027f1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8027f4:	89 34 24             	mov    %esi,(%esp)
  8027f7:	e8 a4 f0 ff ff       	call   8018a0 <fd2data>
  8027fc:	89 c3                	mov    %eax,%ebx
  8027fe:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802803:	eb 48                	jmp    80284d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802805:	89 da                	mov    %ebx,%edx
  802807:	89 f0                	mov    %esi,%eax
  802809:	e8 70 ff ff ff       	call   80277e <_pipeisclosed>
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 07                	je     802819 <devpipe_write+0x31>
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
  802817:	eb 3b                	jmp    802854 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802819:	e8 7f ee ff ff       	call   80169d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80281e:	8b 43 04             	mov    0x4(%ebx),%eax
  802821:	8b 13                	mov    (%ebx),%edx
  802823:	83 c2 20             	add    $0x20,%edx
  802826:	39 d0                	cmp    %edx,%eax
  802828:	73 db                	jae    802805 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80282a:	89 c2                	mov    %eax,%edx
  80282c:	c1 fa 1f             	sar    $0x1f,%edx
  80282f:	c1 ea 1b             	shr    $0x1b,%edx
  802832:	01 d0                	add    %edx,%eax
  802834:	83 e0 1f             	and    $0x1f,%eax
  802837:	29 d0                	sub    %edx,%eax
  802839:	89 c2                	mov    %eax,%edx
  80283b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80283e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802842:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802846:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80284a:	83 c7 01             	add    $0x1,%edi
  80284d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802850:	72 cc                	jb     80281e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802852:	89 f8                	mov    %edi,%eax
}
  802854:	83 c4 1c             	add    $0x1c,%esp
  802857:	5b                   	pop    %ebx
  802858:	5e                   	pop    %esi
  802859:	5f                   	pop    %edi
  80285a:	5d                   	pop    %ebp
  80285b:	c3                   	ret    

0080285c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 28             	sub    $0x28,%esp
  802862:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802865:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802868:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80286b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80286e:	89 3c 24             	mov    %edi,(%esp)
  802871:	e8 2a f0 ff ff       	call   8018a0 <fd2data>
  802876:	89 c3                	mov    %eax,%ebx
  802878:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80287d:	eb 48                	jmp    8028c7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80287f:	85 f6                	test   %esi,%esi
  802881:	74 04                	je     802887 <devpipe_read+0x2b>
				return i;
  802883:	89 f0                	mov    %esi,%eax
  802885:	eb 47                	jmp    8028ce <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802887:	89 da                	mov    %ebx,%edx
  802889:	89 f8                	mov    %edi,%eax
  80288b:	e8 ee fe ff ff       	call   80277e <_pipeisclosed>
  802890:	85 c0                	test   %eax,%eax
  802892:	74 07                	je     80289b <devpipe_read+0x3f>
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
  802899:	eb 33                	jmp    8028ce <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80289b:	e8 fd ed ff ff       	call   80169d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8028a0:	8b 03                	mov    (%ebx),%eax
  8028a2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8028a5:	74 d8                	je     80287f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8028a7:	89 c2                	mov    %eax,%edx
  8028a9:	c1 fa 1f             	sar    $0x1f,%edx
  8028ac:	c1 ea 1b             	shr    $0x1b,%edx
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	83 e0 1f             	and    $0x1f,%eax
  8028b4:	29 d0                	sub    %edx,%eax
  8028b6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8028bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028be:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8028c1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028c4:	83 c6 01             	add    $0x1,%esi
  8028c7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028ca:	72 d4                	jb     8028a0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8028cc:	89 f0                	mov    %esi,%eax
}
  8028ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028d1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028d7:	89 ec                	mov    %ebp,%esp
  8028d9:	5d                   	pop    %ebp
  8028da:	c3                   	ret    

008028db <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
  8028de:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	89 04 24             	mov    %eax,(%esp)
  8028ee:	e8 21 f0 ff ff       	call   801914 <fd_lookup>
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	78 15                	js     80290c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	89 04 24             	mov    %eax,(%esp)
  8028fd:	e8 9e ef ff ff       	call   8018a0 <fd2data>
	return _pipeisclosed(fd, p);
  802902:	89 c2                	mov    %eax,%edx
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	e8 72 fe ff ff       	call   80277e <_pipeisclosed>
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 48             	sub    $0x48,%esp
  802914:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802917:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80291a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80291d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802920:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802923:	89 04 24             	mov    %eax,(%esp)
  802926:	e8 90 ef ff ff       	call   8018bb <fd_alloc>
  80292b:	89 c3                	mov    %eax,%ebx
  80292d:	85 c0                	test   %eax,%eax
  80292f:	0f 88 42 01 00 00    	js     802a77 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802935:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80293c:	00 
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	89 44 24 04          	mov    %eax,0x4(%esp)
  802944:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80294b:	e8 ee ec ff ff       	call   80163e <sys_page_alloc>
  802950:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802952:	85 c0                	test   %eax,%eax
  802954:	0f 88 1d 01 00 00    	js     802a77 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80295a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80295d:	89 04 24             	mov    %eax,(%esp)
  802960:	e8 56 ef ff ff       	call   8018bb <fd_alloc>
  802965:	89 c3                	mov    %eax,%ebx
  802967:	85 c0                	test   %eax,%eax
  802969:	0f 88 f5 00 00 00    	js     802a64 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80296f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802976:	00 
  802977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80297e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802985:	e8 b4 ec ff ff       	call   80163e <sys_page_alloc>
  80298a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80298c:	85 c0                	test   %eax,%eax
  80298e:	0f 88 d0 00 00 00    	js     802a64 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802997:	89 04 24             	mov    %eax,(%esp)
  80299a:	e8 01 ef ff ff       	call   8018a0 <fd2data>
  80299f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029a1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029a8:	00 
  8029a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b4:	e8 85 ec ff ff       	call   80163e <sys_page_alloc>
  8029b9:	89 c3                	mov    %eax,%ebx
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	0f 88 8e 00 00 00    	js     802a51 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c6:	89 04 24             	mov    %eax,(%esp)
  8029c9:	e8 d2 ee ff ff       	call   8018a0 <fd2data>
  8029ce:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8029d5:	00 
  8029d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8029e1:	00 
  8029e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ed:	e8 ee eb ff ff       	call   8015e0 <sys_page_map>
  8029f2:	89 c3                	mov    %eax,%ebx
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	78 49                	js     802a41 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8029f8:	b8 40 40 80 00       	mov    $0x804040,%eax
  8029fd:	8b 08                	mov    (%eax),%ecx
  8029ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a02:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a07:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802a0e:	8b 10                	mov    (%eax),%edx
  802a10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a13:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a22:	89 04 24             	mov    %eax,(%esp)
  802a25:	e8 66 ee ff ff       	call   801890 <fd2num>
  802a2a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2f:	89 04 24             	mov    %eax,(%esp)
  802a32:	e8 59 ee ff ff       	call   801890 <fd2num>
  802a37:	89 47 04             	mov    %eax,0x4(%edi)
  802a3a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802a3f:	eb 36                	jmp    802a77 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802a41:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a4c:	e8 31 eb ff ff       	call   801582 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a5f:	e8 1e eb ff ff       	call   801582 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a72:	e8 0b eb ff ff       	call   801582 <sys_page_unmap>
    err:
	return r;
}
  802a77:	89 d8                	mov    %ebx,%eax
  802a79:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a7c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a7f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a82:	89 ec                	mov    %ebp,%esp
  802a84:	5d                   	pop    %ebp
  802a85:	c3                   	ret    
	...

00802a90 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a93:	b8 00 00 00 00       	mov    $0x0,%eax
  802a98:	5d                   	pop    %ebp
  802a99:	c3                   	ret    

00802a9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802aa0:	c7 44 24 04 ae 37 80 	movl   $0x8037ae,0x4(%esp)
  802aa7:	00 
  802aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aab:	89 04 24             	mov    %eax,(%esp)
  802aae:	e8 46 e4 ff ff       	call   800ef9 <strcpy>
	return 0;
}
  802ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab8:	c9                   	leave  
  802ab9:	c3                   	ret    

00802aba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
  802abd:	57                   	push   %edi
  802abe:	56                   	push   %esi
  802abf:	53                   	push   %ebx
  802ac0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802ac6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802acb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ad1:	eb 34                	jmp    802b07 <devcons_write+0x4d>
		m = n - tot;
  802ad3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802ad6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802ad8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  802ade:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802ae3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ae6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802aea:	03 45 0c             	add    0xc(%ebp),%eax
  802aed:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af1:	89 3c 24             	mov    %edi,(%esp)
  802af4:	e8 a6 e5 ff ff       	call   80109f <memmove>
		sys_cputs(buf, m);
  802af9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802afd:	89 3c 24             	mov    %edi,(%esp)
  802b00:	e8 ab e7 ff ff       	call   8012b0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b05:	01 de                	add    %ebx,%esi
  802b07:	89 f0                	mov    %esi,%eax
  802b09:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b0c:	72 c5                	jb     802ad3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802b0e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802b14:	5b                   	pop    %ebx
  802b15:	5e                   	pop    %esi
  802b16:	5f                   	pop    %edi
  802b17:	5d                   	pop    %ebp
  802b18:	c3                   	ret    

00802b19 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
  802b1c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802b25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802b2c:	00 
  802b2d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b30:	89 04 24             	mov    %eax,(%esp)
  802b33:	e8 78 e7 ff ff       	call   8012b0 <sys_cputs>
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
  802b3d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802b40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b44:	75 07                	jne    802b4d <devcons_read+0x13>
  802b46:	eb 28                	jmp    802b70 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b48:	e8 50 eb ff ff       	call   80169d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b4d:	8d 76 00             	lea    0x0(%esi),%esi
  802b50:	e8 27 e7 ff ff       	call   80127c <sys_cgetc>
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 ef                	je     802b48 <devcons_read+0xe>
  802b59:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	78 16                	js     802b75 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802b5f:	83 f8 04             	cmp    $0x4,%eax
  802b62:	74 0c                	je     802b70 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b67:	88 10                	mov    %dl,(%eax)
  802b69:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802b6e:	eb 05                	jmp    802b75 <devcons_read+0x3b>
  802b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b75:	c9                   	leave  
  802b76:	c3                   	ret    

00802b77 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802b77:	55                   	push   %ebp
  802b78:	89 e5                	mov    %esp,%ebp
  802b7a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b80:	89 04 24             	mov    %eax,(%esp)
  802b83:	e8 33 ed ff ff       	call   8018bb <fd_alloc>
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	78 3f                	js     802bcb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b8c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b93:	00 
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ba2:	e8 97 ea ff ff       	call   80163e <sys_page_alloc>
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	78 20                	js     802bcb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802bab:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	89 04 24             	mov    %eax,(%esp)
  802bc6:	e8 c5 ec ff ff       	call   801890 <fd2num>
}
  802bcb:	c9                   	leave  
  802bcc:	c3                   	ret    

00802bcd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802bcd:	55                   	push   %ebp
  802bce:	89 e5                	mov    %esp,%ebp
  802bd0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	89 04 24             	mov    %eax,(%esp)
  802be0:	e8 2f ed ff ff       	call   801914 <fd_lookup>
  802be5:	85 c0                	test   %eax,%eax
  802be7:	78 11                	js     802bfa <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	3b 05 5c 40 80 00    	cmp    0x80405c,%eax
  802bf4:	0f 94 c0             	sete   %al
  802bf7:	0f b6 c0             	movzbl %al,%eax
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802c02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802c09:	00 
  802c0a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c18:	e8 4e ef ff ff       	call   801b6b <read>
	if (r < 0)
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	78 0f                	js     802c30 <getchar+0x34>
		return r;
	if (r < 1)
  802c21:	85 c0                	test   %eax,%eax
  802c23:	7f 07                	jg     802c2c <getchar+0x30>
  802c25:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802c2a:	eb 04                	jmp    802c30 <getchar+0x34>
		return -E_EOF;
	return c;
  802c2c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    
	...

00802c34 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c34:	55                   	push   %ebp
  802c35:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	89 c2                	mov    %eax,%edx
  802c3c:	c1 ea 16             	shr    $0x16,%edx
  802c3f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c46:	f6 c2 01             	test   $0x1,%dl
  802c49:	74 20                	je     802c6b <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802c4b:	c1 e8 0c             	shr    $0xc,%eax
  802c4e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c55:	a8 01                	test   $0x1,%al
  802c57:	74 12                	je     802c6b <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c59:	c1 e8 0c             	shr    $0xc,%eax
  802c5c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802c61:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802c66:	0f b7 c0             	movzwl %ax,%eax
  802c69:	eb 05                	jmp    802c70 <pageref+0x3c>
  802c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c70:	5d                   	pop    %ebp
  802c71:	c3                   	ret    
	...

00802c80 <__udivdi3>:
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
  802c83:	57                   	push   %edi
  802c84:	56                   	push   %esi
  802c85:	83 ec 10             	sub    $0x10,%esp
  802c88:	8b 45 14             	mov    0x14(%ebp),%eax
  802c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8e:	8b 75 10             	mov    0x10(%ebp),%esi
  802c91:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c94:	85 c0                	test   %eax,%eax
  802c96:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802c99:	75 35                	jne    802cd0 <__udivdi3+0x50>
  802c9b:	39 fe                	cmp    %edi,%esi
  802c9d:	77 61                	ja     802d00 <__udivdi3+0x80>
  802c9f:	85 f6                	test   %esi,%esi
  802ca1:	75 0b                	jne    802cae <__udivdi3+0x2e>
  802ca3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ca8:	31 d2                	xor    %edx,%edx
  802caa:	f7 f6                	div    %esi
  802cac:	89 c6                	mov    %eax,%esi
  802cae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802cb1:	31 d2                	xor    %edx,%edx
  802cb3:	89 f8                	mov    %edi,%eax
  802cb5:	f7 f6                	div    %esi
  802cb7:	89 c7                	mov    %eax,%edi
  802cb9:	89 c8                	mov    %ecx,%eax
  802cbb:	f7 f6                	div    %esi
  802cbd:	89 c1                	mov    %eax,%ecx
  802cbf:	89 fa                	mov    %edi,%edx
  802cc1:	89 c8                	mov    %ecx,%eax
  802cc3:	83 c4 10             	add    $0x10,%esp
  802cc6:	5e                   	pop    %esi
  802cc7:	5f                   	pop    %edi
  802cc8:	5d                   	pop    %ebp
  802cc9:	c3                   	ret    
  802cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cd0:	39 f8                	cmp    %edi,%eax
  802cd2:	77 1c                	ja     802cf0 <__udivdi3+0x70>
  802cd4:	0f bd d0             	bsr    %eax,%edx
  802cd7:	83 f2 1f             	xor    $0x1f,%edx
  802cda:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802cdd:	75 39                	jne    802d18 <__udivdi3+0x98>
  802cdf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802ce2:	0f 86 a0 00 00 00    	jbe    802d88 <__udivdi3+0x108>
  802ce8:	39 f8                	cmp    %edi,%eax
  802cea:	0f 82 98 00 00 00    	jb     802d88 <__udivdi3+0x108>
  802cf0:	31 ff                	xor    %edi,%edi
  802cf2:	31 c9                	xor    %ecx,%ecx
  802cf4:	89 c8                	mov    %ecx,%eax
  802cf6:	89 fa                	mov    %edi,%edx
  802cf8:	83 c4 10             	add    $0x10,%esp
  802cfb:	5e                   	pop    %esi
  802cfc:	5f                   	pop    %edi
  802cfd:	5d                   	pop    %ebp
  802cfe:	c3                   	ret    
  802cff:	90                   	nop
  802d00:	89 d1                	mov    %edx,%ecx
  802d02:	89 fa                	mov    %edi,%edx
  802d04:	89 c8                	mov    %ecx,%eax
  802d06:	31 ff                	xor    %edi,%edi
  802d08:	f7 f6                	div    %esi
  802d0a:	89 c1                	mov    %eax,%ecx
  802d0c:	89 fa                	mov    %edi,%edx
  802d0e:	89 c8                	mov    %ecx,%eax
  802d10:	83 c4 10             	add    $0x10,%esp
  802d13:	5e                   	pop    %esi
  802d14:	5f                   	pop    %edi
  802d15:	5d                   	pop    %ebp
  802d16:	c3                   	ret    
  802d17:	90                   	nop
  802d18:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d1c:	89 f2                	mov    %esi,%edx
  802d1e:	d3 e0                	shl    %cl,%eax
  802d20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d23:	b8 20 00 00 00       	mov    $0x20,%eax
  802d28:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d2b:	89 c1                	mov    %eax,%ecx
  802d2d:	d3 ea                	shr    %cl,%edx
  802d2f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d33:	0b 55 ec             	or     -0x14(%ebp),%edx
  802d36:	d3 e6                	shl    %cl,%esi
  802d38:	89 c1                	mov    %eax,%ecx
  802d3a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802d3d:	89 fe                	mov    %edi,%esi
  802d3f:	d3 ee                	shr    %cl,%esi
  802d41:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d45:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4b:	d3 e7                	shl    %cl,%edi
  802d4d:	89 c1                	mov    %eax,%ecx
  802d4f:	d3 ea                	shr    %cl,%edx
  802d51:	09 d7                	or     %edx,%edi
  802d53:	89 f2                	mov    %esi,%edx
  802d55:	89 f8                	mov    %edi,%eax
  802d57:	f7 75 ec             	divl   -0x14(%ebp)
  802d5a:	89 d6                	mov    %edx,%esi
  802d5c:	89 c7                	mov    %eax,%edi
  802d5e:	f7 65 e8             	mull   -0x18(%ebp)
  802d61:	39 d6                	cmp    %edx,%esi
  802d63:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d66:	72 30                	jb     802d98 <__udivdi3+0x118>
  802d68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d6f:	d3 e2                	shl    %cl,%edx
  802d71:	39 c2                	cmp    %eax,%edx
  802d73:	73 05                	jae    802d7a <__udivdi3+0xfa>
  802d75:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802d78:	74 1e                	je     802d98 <__udivdi3+0x118>
  802d7a:	89 f9                	mov    %edi,%ecx
  802d7c:	31 ff                	xor    %edi,%edi
  802d7e:	e9 71 ff ff ff       	jmp    802cf4 <__udivdi3+0x74>
  802d83:	90                   	nop
  802d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d88:	31 ff                	xor    %edi,%edi
  802d8a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802d8f:	e9 60 ff ff ff       	jmp    802cf4 <__udivdi3+0x74>
  802d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d98:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802d9b:	31 ff                	xor    %edi,%edi
  802d9d:	89 c8                	mov    %ecx,%eax
  802d9f:	89 fa                	mov    %edi,%edx
  802da1:	83 c4 10             	add    $0x10,%esp
  802da4:	5e                   	pop    %esi
  802da5:	5f                   	pop    %edi
  802da6:	5d                   	pop    %ebp
  802da7:	c3                   	ret    
	...

00802db0 <__umoddi3>:
  802db0:	55                   	push   %ebp
  802db1:	89 e5                	mov    %esp,%ebp
  802db3:	57                   	push   %edi
  802db4:	56                   	push   %esi
  802db5:	83 ec 20             	sub    $0x20,%esp
  802db8:	8b 55 14             	mov    0x14(%ebp),%edx
  802dbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dbe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802dc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802dc4:	85 d2                	test   %edx,%edx
  802dc6:	89 c8                	mov    %ecx,%eax
  802dc8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802dcb:	75 13                	jne    802de0 <__umoddi3+0x30>
  802dcd:	39 f7                	cmp    %esi,%edi
  802dcf:	76 3f                	jbe    802e10 <__umoddi3+0x60>
  802dd1:	89 f2                	mov    %esi,%edx
  802dd3:	f7 f7                	div    %edi
  802dd5:	89 d0                	mov    %edx,%eax
  802dd7:	31 d2                	xor    %edx,%edx
  802dd9:	83 c4 20             	add    $0x20,%esp
  802ddc:	5e                   	pop    %esi
  802ddd:	5f                   	pop    %edi
  802dde:	5d                   	pop    %ebp
  802ddf:	c3                   	ret    
  802de0:	39 f2                	cmp    %esi,%edx
  802de2:	77 4c                	ja     802e30 <__umoddi3+0x80>
  802de4:	0f bd ca             	bsr    %edx,%ecx
  802de7:	83 f1 1f             	xor    $0x1f,%ecx
  802dea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802ded:	75 51                	jne    802e40 <__umoddi3+0x90>
  802def:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802df2:	0f 87 e0 00 00 00    	ja     802ed8 <__umoddi3+0x128>
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	29 f8                	sub    %edi,%eax
  802dfd:	19 d6                	sbb    %edx,%esi
  802dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	89 f2                	mov    %esi,%edx
  802e07:	83 c4 20             	add    $0x20,%esp
  802e0a:	5e                   	pop    %esi
  802e0b:	5f                   	pop    %edi
  802e0c:	5d                   	pop    %ebp
  802e0d:	c3                   	ret    
  802e0e:	66 90                	xchg   %ax,%ax
  802e10:	85 ff                	test   %edi,%edi
  802e12:	75 0b                	jne    802e1f <__umoddi3+0x6f>
  802e14:	b8 01 00 00 00       	mov    $0x1,%eax
  802e19:	31 d2                	xor    %edx,%edx
  802e1b:	f7 f7                	div    %edi
  802e1d:	89 c7                	mov    %eax,%edi
  802e1f:	89 f0                	mov    %esi,%eax
  802e21:	31 d2                	xor    %edx,%edx
  802e23:	f7 f7                	div    %edi
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	f7 f7                	div    %edi
  802e2a:	eb a9                	jmp    802dd5 <__umoddi3+0x25>
  802e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e30:	89 c8                	mov    %ecx,%eax
  802e32:	89 f2                	mov    %esi,%edx
  802e34:	83 c4 20             	add    $0x20,%esp
  802e37:	5e                   	pop    %esi
  802e38:	5f                   	pop    %edi
  802e39:	5d                   	pop    %ebp
  802e3a:	c3                   	ret    
  802e3b:	90                   	nop
  802e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e40:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e44:	d3 e2                	shl    %cl,%edx
  802e46:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e49:	ba 20 00 00 00       	mov    $0x20,%edx
  802e4e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e51:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e54:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e58:	89 fa                	mov    %edi,%edx
  802e5a:	d3 ea                	shr    %cl,%edx
  802e5c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e60:	0b 55 f4             	or     -0xc(%ebp),%edx
  802e63:	d3 e7                	shl    %cl,%edi
  802e65:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e69:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e6c:	89 f2                	mov    %esi,%edx
  802e6e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802e71:	89 c7                	mov    %eax,%edi
  802e73:	d3 ea                	shr    %cl,%edx
  802e75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802e7c:	89 c2                	mov    %eax,%edx
  802e7e:	d3 e6                	shl    %cl,%esi
  802e80:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e84:	d3 ea                	shr    %cl,%edx
  802e86:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e8a:	09 d6                	or     %edx,%esi
  802e8c:	89 f0                	mov    %esi,%eax
  802e8e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802e91:	d3 e7                	shl    %cl,%edi
  802e93:	89 f2                	mov    %esi,%edx
  802e95:	f7 75 f4             	divl   -0xc(%ebp)
  802e98:	89 d6                	mov    %edx,%esi
  802e9a:	f7 65 e8             	mull   -0x18(%ebp)
  802e9d:	39 d6                	cmp    %edx,%esi
  802e9f:	72 2b                	jb     802ecc <__umoddi3+0x11c>
  802ea1:	39 c7                	cmp    %eax,%edi
  802ea3:	72 23                	jb     802ec8 <__umoddi3+0x118>
  802ea5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ea9:	29 c7                	sub    %eax,%edi
  802eab:	19 d6                	sbb    %edx,%esi
  802ead:	89 f0                	mov    %esi,%eax
  802eaf:	89 f2                	mov    %esi,%edx
  802eb1:	d3 ef                	shr    %cl,%edi
  802eb3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802eb7:	d3 e0                	shl    %cl,%eax
  802eb9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ebd:	09 f8                	or     %edi,%eax
  802ebf:	d3 ea                	shr    %cl,%edx
  802ec1:	83 c4 20             	add    $0x20,%esp
  802ec4:	5e                   	pop    %esi
  802ec5:	5f                   	pop    %edi
  802ec6:	5d                   	pop    %ebp
  802ec7:	c3                   	ret    
  802ec8:	39 d6                	cmp    %edx,%esi
  802eca:	75 d9                	jne    802ea5 <__umoddi3+0xf5>
  802ecc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ecf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802ed2:	eb d1                	jmp    802ea5 <__umoddi3+0xf5>
  802ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ed8:	39 f2                	cmp    %esi,%edx
  802eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ee0:	0f 82 12 ff ff ff    	jb     802df8 <__umoddi3+0x48>
  802ee6:	e9 17 ff ff ff       	jmp    802e02 <__umoddi3+0x52>
