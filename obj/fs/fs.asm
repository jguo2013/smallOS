
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 53 1c 00 00       	call   801c84 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80003a:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003f:	ec                   	in     (%dx),%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800040:	0f b6 d8             	movzbl %al,%ebx
  800043:	89 d8                	mov    %ebx,%eax
  800045:	25 c0 00 00 00       	and    $0xc0,%eax
  80004a:	83 f8 40             	cmp    $0x40,%eax
  80004d:	75 f0                	jne    80003f <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004f:	84 c9                	test   %cl,%cl
  800051:	74 0a                	je     80005d <ide_wait_ready+0x29>
  800053:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800058:	f6 c3 21             	test   $0x21,%bl
  80005b:	75 05                	jne    800062 <ide_wait_ready+0x2e>
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
		return -1;
	return 0;
}
  800062:	5b                   	pop    %ebx
  800063:	5d                   	pop    %ebp
  800064:	c3                   	ret    

00800065 <ide_write>:
	return 0;
}

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	57                   	push   %edi
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	83 ec 1c             	sub    $0x1c,%esp
  80006e:	8b 75 08             	mov    0x8(%ebp),%esi
  800071:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800074:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  800077:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  80007d:	76 24                	jbe    8000a3 <ide_write+0x3e>
  80007f:	c7 44 24 0c a0 44 80 	movl   $0x8044a0,0xc(%esp)
  800086:	00 
  800087:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 c2 44 80 00 	movl   $0x8044c2,(%esp)
  80009e:	e8 45 1c 00 00       	call   801ce8 <_panic>

	ide_wait_ready(0);
  8000a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a8:	e8 87 ff ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ad:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8000b2:	89 d8                	mov    %ebx,%eax
  8000b4:	ee                   	out    %al,(%dx)
  8000b5:	b2 f3                	mov    $0xf3,%dl
  8000b7:	89 f0                	mov    %esi,%eax
  8000b9:	ee                   	out    %al,(%dx)
  8000ba:	89 f0                	mov    %esi,%eax
  8000bc:	c1 e8 08             	shr    $0x8,%eax
  8000bf:	b2 f4                	mov    $0xf4,%dl
  8000c1:	ee                   	out    %al,(%dx)
  8000c2:	89 f0                	mov    %esi,%eax
  8000c4:	c1 e8 10             	shr    $0x10,%eax
  8000c7:	b2 f5                	mov    $0xf5,%dl
  8000c9:	ee                   	out    %al,(%dx)
  8000ca:	a1 00 50 80 00       	mov    0x805000,%eax
  8000cf:	83 e0 01             	and    $0x1,%eax
  8000d2:	c1 e0 04             	shl    $0x4,%eax
  8000d5:	83 c8 e0             	or     $0xffffffe0,%eax
  8000d8:	c1 ee 18             	shr    $0x18,%esi
  8000db:	83 e6 0f             	and    $0xf,%esi
  8000de:	09 f0                	or     %esi,%eax
  8000e0:	b2 f6                	mov    $0xf6,%dl
  8000e2:	ee                   	out    %al,(%dx)
  8000e3:	b2 f7                	mov    $0xf7,%dl
  8000e5:	b8 30 00 00 00       	mov    $0x30,%eax
  8000ea:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8000eb:	eb 26                	jmp    800113 <ide_write+0xae>
		if ((r = ide_wait_ready(1)) < 0)
  8000ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f2:	e8 3d ff ff ff       	call   800034 <ide_wait_ready>
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	78 21                	js     80011c <ide_write+0xb7>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  8000fb:	89 fe                	mov    %edi,%esi
  8000fd:	b9 80 00 00 00       	mov    $0x80,%ecx
  800102:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800107:	fc                   	cld    
  800108:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80010a:	83 eb 01             	sub    $0x1,%ebx
  80010d:	81 c7 00 02 00 00    	add    $0x200,%edi
  800113:	85 db                	test   %ebx,%ebx
  800115:	75 d6                	jne    8000ed <ide_write+0x88>
  800117:	b8 00 00 00 00       	mov    $0x0,%eax
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
}
  80011c:	83 c4 1c             	add    $0x1c,%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5f                   	pop    %edi
  800122:	5d                   	pop    %ebp
  800123:	c3                   	ret    

00800124 <ide_read>:
}


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 1c             	sub    $0x1c,%esp
  80012d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800130:	8b 75 0c             	mov    0xc(%ebp),%esi
  800133:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  800136:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  80013c:	76 24                	jbe    800162 <ide_read+0x3e>
  80013e:	c7 44 24 0c a0 44 80 	movl   $0x8044a0,0xc(%esp)
  800145:	00 
  800146:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80014d:	00 
  80014e:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  800155:	00 
  800156:	c7 04 24 c2 44 80 00 	movl   $0x8044c2,(%esp)
  80015d:	e8 86 1b 00 00       	call   801ce8 <_panic>

	ide_wait_ready(0);
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	e8 c8 fe ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80016c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800171:	89 d8                	mov    %ebx,%eax
  800173:	ee                   	out    %al,(%dx)
  800174:	b2 f3                	mov    $0xf3,%dl
  800176:	89 f8                	mov    %edi,%eax
  800178:	ee                   	out    %al,(%dx)
  800179:	89 f8                	mov    %edi,%eax
  80017b:	c1 e8 08             	shr    $0x8,%eax
  80017e:	b2 f4                	mov    $0xf4,%dl
  800180:	ee                   	out    %al,(%dx)
  800181:	89 f8                	mov    %edi,%eax
  800183:	c1 e8 10             	shr    $0x10,%eax
  800186:	b2 f5                	mov    $0xf5,%dl
  800188:	ee                   	out    %al,(%dx)
  800189:	a1 00 50 80 00       	mov    0x805000,%eax
  80018e:	83 e0 01             	and    $0x1,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	83 c8 e0             	or     $0xffffffe0,%eax
  800197:	c1 ef 18             	shr    $0x18,%edi
  80019a:	83 e7 0f             	and    $0xf,%edi
  80019d:	09 f8                	or     %edi,%eax
  80019f:	b2 f6                	mov    $0xf6,%dl
  8001a1:	ee                   	out    %al,(%dx)
  8001a2:	b2 f7                	mov    $0xf7,%dl
  8001a4:	b8 20 00 00 00       	mov    $0x20,%eax
  8001a9:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001aa:	eb 26                	jmp    8001d2 <ide_read+0xae>
		if ((r = ide_wait_ready(1)) < 0)
  8001ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8001b1:	e8 7e fe ff ff       	call   800034 <ide_wait_ready>
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	78 21                	js     8001db <ide_read+0xb7>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8001ba:	89 f7                	mov    %esi,%edi
  8001bc:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001c1:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001c6:	fc                   	cld    
  8001c7:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001c9:	83 eb 01             	sub    $0x1,%ebx
  8001cc:	81 c6 00 02 00 00    	add    $0x200,%esi
  8001d2:	85 db                	test   %ebx,%ebx
  8001d4:	75 d6                	jne    8001ac <ide_read+0x88>
  8001d6:	b8 00 00 00 00       	mov    $0x0,%eax
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
}
  8001db:	83 c4 1c             	add    $0x1c,%esp
  8001de:	5b                   	pop    %ebx
  8001df:	5e                   	pop    %esi
  8001e0:	5f                   	pop    %edi
  8001e1:	5d                   	pop    %ebp
  8001e2:	c3                   	ret    

008001e3 <ide_set_disk>:
	return (x < 1000);
}

void
ide_set_disk(int d)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 18             	sub    $0x18,%esp
  8001e9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8001ec:	83 f8 01             	cmp    $0x1,%eax
  8001ef:	76 1c                	jbe    80020d <ide_set_disk+0x2a>
		panic("bad disk number");
  8001f1:	c7 44 24 08 cb 44 80 	movl   $0x8044cb,0x8(%esp)
  8001f8:	00 
  8001f9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800200:	00 
  800201:	c7 04 24 c2 44 80 00 	movl   $0x8044c2,(%esp)
  800208:	e8 db 1a 00 00       	call   801ce8 <_panic>
	diskno = d;
  80020d:	a3 00 50 80 00       	mov    %eax,0x805000
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <ide_probe_disk1>:
	return 0;
}

bool
ide_probe_disk1(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	53                   	push   %ebx
  800218:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80021b:	b8 00 00 00 00       	mov    $0x0,%eax
  800220:	e8 0f fe ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800225:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80022a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80022f:	ee                   	out    %al,(%dx)
  800230:	b9 00 00 00 00       	mov    $0x0,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800235:	b2 f7                	mov    $0xf7,%dl
  800237:	eb 0b                	jmp    800244 <ide_probe_disk1+0x30>
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  800239:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80023c:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800242:	74 05                	je     800249 <ide_probe_disk1+0x35>
  800244:	ec                   	in     (%dx),%al
  800245:	a8 a1                	test   $0xa1,%al
  800247:	75 f0                	jne    800239 <ide_probe_disk1+0x25>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800249:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80024e:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  800253:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800254:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  80025a:	0f 9e c3             	setle  %bl
  80025d:	0f b6 c3             	movzbl %bl,%eax
  800260:	89 44 24 04          	mov    %eax,0x4(%esp)
  800264:	c7 04 24 db 44 80 00 	movl   $0x8044db,(%esp)
  80026b:	e8 31 1b 00 00       	call   801da1 <cprintf>
	return (x < 1000);
}
  800270:	89 d8                	mov    %ebx,%eax
  800272:	83 c4 14             	add    $0x14,%esp
  800275:	5b                   	pop    %ebx
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <va_is_mapped>:
}

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80027b:	8b 55 08             	mov    0x8(%ebp),%edx
  80027e:	89 d0                	mov    %edx,%eax
  800280:	c1 e8 16             	shr    $0x16,%eax
  800283:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80028a:	b8 00 00 00 00       	mov    $0x0,%eax
  80028f:	f6 c1 01             	test   $0x1,%cl
  800292:	74 0d                	je     8002a1 <va_is_mapped+0x29>
  800294:	c1 ea 0c             	shr    $0xc,%edx
  800297:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80029e:	83 e0 01             	and    $0x1,%eax
}
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a9:	c1 e8 0c             	shr    $0xc,%eax
  8002ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002b3:	c1 e8 06             	shr    $0x6,%eax
  8002b6:	83 e0 01             	and    $0x1,%eax
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 18             	sub    $0x18,%esp
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	74 0f                	je     8002d7 <diskaddr+0x1c>
  8002c8:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8002ce:	85 d2                	test   %edx,%edx
  8002d0:	74 25                	je     8002f7 <diskaddr+0x3c>
  8002d2:	3b 42 04             	cmp    0x4(%edx),%eax
  8002d5:	72 20                	jb     8002f7 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  8002d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002db:	c7 44 24 08 f4 44 80 	movl   $0x8044f4,0x8(%esp)
  8002e2:	00 
  8002e3:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8002ea:	00 
  8002eb:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8002f2:	e8 f1 19 00 00       	call   801ce8 <_panic>
  8002f7:	05 00 00 01 00       	add    $0x10000,%eax
  8002fc:	c1 e0 0c             	shl    $0xc,%eax
	return (char*) (DISKMAP + blockno * BLKSIZE);
}
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	83 ec 2c             	sub    $0x2c,%esp
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80030d:	8b 30                	mov    (%eax),%esi
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80030f:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
  800315:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  80031b:	76 2e                	jbe    80034b <bc_pgfault+0x4a>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80031d:	8b 50 04             	mov    0x4(%eax),%edx
  800320:	89 54 24 14          	mov    %edx,0x14(%esp)
  800324:	89 74 24 10          	mov    %esi,0x10(%esp)
  800328:	8b 40 28             	mov    0x28(%eax),%eax
  80032b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80032f:	c7 44 24 08 18 45 80 	movl   $0x804518,0x8(%esp)
  800336:	00 
  800337:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80033e:	00 
  80033f:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800346:	e8 9d 19 00 00       	call   801ce8 <_panic>
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80034b:	8d be 00 00 00 f0    	lea    -0x10000000(%esi),%edi
  800351:	c1 ef 0c             	shr    $0xc,%edi
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  800354:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800359:	85 c0                	test   %eax,%eax
  80035b:	74 25                	je     800382 <bc_pgfault+0x81>
  80035d:	3b 78 04             	cmp    0x4(%eax),%edi
  800360:	72 20                	jb     800382 <bc_pgfault+0x81>
		panic("reading non-existent block %08x\n", blockno);
  800362:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800366:	c7 44 24 08 48 45 80 	movl   $0x804548,0x8(%esp)
  80036d:	00 
  80036e:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  800375:	00 
  800376:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  80037d:	e8 66 19 00 00       	call   801ce8 <_panic>
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	void * al_va = ROUNDDOWN(addr,PGSIZE);
	envid_t curr_env = sys_getenvid();
  800382:	e8 5a 28 00 00       	call   802be1 <sys_getenvid>
  800387:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(curr_env,(void *)UTEMP,PTE_U|PTE_W|PTE_P);
  800389:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800390:	00 
  800391:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800398:	00 
  800399:	89 04 24             	mov    %eax,(%esp)
  80039c:	e8 ad 27 00 00       	call   802b4e <sys_page_alloc>
	if(r) panic("sys_page_alloc fails %e\n",r);	
  8003a1:	85 c0                	test   %eax,%eax
  8003a3:	74 20                	je     8003c5 <bc_pgfault+0xc4>
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	c7 44 24 08 98 45 80 	movl   $0x804598,0x8(%esp)
  8003b0:	00 
  8003b1:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8003b8:	00 
  8003b9:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8003c0:	e8 23 19 00 00       	call   801ce8 <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	void * al_va = ROUNDDOWN(addr,PGSIZE);
  8003c5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi

	r = sys_page_alloc(curr_env,(void *)UTEMP,PTE_U|PTE_W|PTE_P);
	if(r) panic("sys_page_alloc fails %e\n",r);	
	uint32_t secno = ((uint32_t)al_va - DISKMAP)/SECTSIZE;
	
	ide_read(secno,(void *)UTEMP,PGSIZE/SECTSIZE);
  8003cb:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8003d2:	00 
  8003d3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8003da:	00 
  8003db:	8d 86 00 00 00 f0    	lea    -0x10000000(%esi),%eax
  8003e1:	c1 e8 09             	shr    $0x9,%eax
  8003e4:	89 04 24             	mov    %eax,(%esp)
  8003e7:	e8 38 fd ff ff       	call   800124 <ide_read>

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	r = sys_page_map(curr_env,(void *)UTEMP,curr_env,al_va,PTE_U|PTE_W|PTE_P);
  8003ec:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8003f3:	00 
  8003f4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003fc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800403:	00 
  800404:	89 1c 24             	mov    %ebx,(%esp)
  800407:	e8 e4 26 00 00       	call   802af0 <sys_page_map>
	if(r) panic("sys_page_map fails %e\n",r);	
  80040c:	85 c0                	test   %eax,%eax
  80040e:	74 20                	je     800430 <bc_pgfault+0x12f>
  800410:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800414:	c7 44 24 08 b1 45 80 	movl   $0x8045b1,0x8(%esp)
  80041b:	00 
  80041c:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  800423:	00 
  800424:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  80042b:	e8 b8 18 00 00       	call   801ce8 <_panic>

	r = sys_page_unmap(curr_env,(void *)UTEMP);
  800430:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800437:	00 
  800438:	89 1c 24             	mov    %ebx,(%esp)
  80043b:	e8 52 26 00 00       	call   802a92 <sys_page_unmap>
	if(r) panic("sys_page_unmap fails %e\n",r);	
  800440:	85 c0                	test   %eax,%eax
  800442:	74 20                	je     800464 <bc_pgfault+0x163>
  800444:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800448:	c7 44 24 08 c8 45 80 	movl   $0x8045c8,0x8(%esp)
  80044f:	00 
  800450:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  800457:	00 
  800458:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  80045f:	e8 84 18 00 00       	call   801ce8 <_panic>

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800464:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  80046b:	74 2c                	je     800499 <bc_pgfault+0x198>
  80046d:	89 3c 24             	mov    %edi,(%esp)
  800470:	e8 ef 02 00 00       	call   800764 <block_is_free>
  800475:	84 c0                	test   %al,%al
  800477:	74 20                	je     800499 <bc_pgfault+0x198>
		panic("reading free block %08x\n", blockno);
  800479:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80047d:	c7 44 24 08 e1 45 80 	movl   $0x8045e1,0x8(%esp)
  800484:	00 
  800485:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  80048c:	00 
  80048d:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800494:	e8 4f 18 00 00       	call   801ce8 <_panic>
}
  800499:	83 c4 2c             	add    $0x2c,%esp
  80049c:	5b                   	pop    %ebx
  80049d:	5e                   	pop    %esi
  80049e:	5f                   	pop    %edi
  80049f:	5d                   	pop    %ebp
  8004a0:	c3                   	ret    

008004a1 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	83 ec 38             	sub    $0x38,%esp
  8004a7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8004aa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8004ad:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8004b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8004b3:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8004b9:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8004be:	76 20                	jbe    8004e0 <flush_block+0x3f>
		panic("flush_block of bad va %08x", addr);
  8004c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004c4:	c7 44 24 08 fa 45 80 	movl   $0x8045fa,0x8(%esp)
  8004cb:	00 
  8004cc:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8004d3:	00 
  8004d4:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8004db:	e8 08 18 00 00       	call   801ce8 <_panic>

	// LAB 5: Your code here.
	
	void * al_va = ROUNDDOWN(addr,PGSIZE);
	envid_t curr_env = sys_getenvid();
  8004e0:	e8 fc 26 00 00       	call   802be1 <sys_getenvid>
  8004e5:	89 c7                	mov    %eax,%edi
	uint32_t secno;
	int ret;
	
	if(va_is_mapped(addr) & va_is_dirty(addr))
  8004e7:	89 1c 24             	mov    %ebx,(%esp)
  8004ea:	e8 89 fd ff ff       	call   800278 <va_is_mapped>
  8004ef:	89 c6                	mov    %eax,%esi
  8004f1:	89 1c 24             	mov    %ebx,(%esp)
  8004f4:	e8 aa fd ff ff       	call   8002a3 <va_is_dirty>
  8004f9:	81 e6 ff 00 00 00    	and    $0xff,%esi
  8004ff:	85 c6                	test   %eax,%esi
  800501:	74 67                	je     80056a <flush_block+0xc9>
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	
	void * al_va = ROUNDDOWN(addr,PGSIZE);
  800503:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int ret;
	
	if(va_is_mapped(addr) & va_is_dirty(addr))
	{
		secno = ((uint32_t)al_va - DISKMAP)/SECTSIZE;
		ide_write(secno,al_va,PGSIZE/SECTSIZE);
  800509:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800510:	00 
  800511:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800515:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80051b:	c1 e8 09             	shr    $0x9,%eax
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	e8 3f fb ff ff       	call   800065 <ide_write>
		ret = sys_page_map(curr_env,al_va,curr_env,al_va,PTE_SYSCALL);
  800526:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80052d:	00 
  80052e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800532:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800536:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80053a:	89 3c 24             	mov    %edi,(%esp)
  80053d:	e8 ae 25 00 00       	call   802af0 <sys_page_map>
		if(ret) panic("%s sys_page_map fails\n",__func__);
  800542:	85 c0                	test   %eax,%eax
  800544:	74 24                	je     80056a <flush_block+0xc9>
  800546:	c7 44 24 0c 7d 46 80 	movl   $0x80467d,0xc(%esp)
  80054d:	00 
  80054e:	c7 44 24 08 15 46 80 	movl   $0x804615,0x8(%esp)
  800555:	00 
  800556:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80055d:	00 
  80055e:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800565:	e8 7e 17 00 00       	call   801ce8 <_panic>
	}
}
  80056a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80056d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800570:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800573:	89 ec                	mov    %ebp,%esp
  800575:	5d                   	pop    %ebp
  800576:	c3                   	ret    

00800577 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	81 ec 28 02 00 00    	sub    $0x228,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800580:	c7 04 24 01 03 80 00 	movl   $0x800301,(%esp)
  800587:	e8 e8 26 00 00       	call   802c74 <set_pgfault_handler>
{
	struct Super backup;
	uint32_t data;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  80058c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800593:	e8 23 fd ff ff       	call   8002bb <diskaddr>
  800598:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  80059f:	00 
  8005a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8005aa:	89 04 24             	mov    %eax,(%esp)
  8005ad:	e8 fd 1f 00 00       	call   8025af <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8005b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005b9:	e8 fd fc ff ff       	call   8002bb <diskaddr>
  8005be:	c7 44 24 04 2c 46 80 	movl   $0x80462c,0x4(%esp)
  8005c5:	00 
  8005c6:	89 04 24             	mov    %eax,(%esp)
  8005c9:	e8 3b 1e 00 00       	call   802409 <strcpy>
	flush_block(diskaddr(1));
  8005ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d5:	e8 e1 fc ff ff       	call   8002bb <diskaddr>
  8005da:	89 04 24             	mov    %eax,(%esp)
  8005dd:	e8 bf fe ff ff       	call   8004a1 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8005e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005e9:	e8 cd fc ff ff       	call   8002bb <diskaddr>
  8005ee:	89 04 24             	mov    %eax,(%esp)
  8005f1:	e8 82 fc ff ff       	call   800278 <va_is_mapped>
  8005f6:	84 c0                	test   %al,%al
  8005f8:	75 24                	jne    80061e <bc_init+0xa7>
  8005fa:	c7 44 24 0c 4e 46 80 	movl   $0x80464e,0xc(%esp)
  800601:	00 
  800602:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  800609:	00 
  80060a:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800611:	00 
  800612:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800619:	e8 ca 16 00 00       	call   801ce8 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80061e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800625:	e8 91 fc ff ff       	call   8002bb <diskaddr>
  80062a:	89 04 24             	mov    %eax,(%esp)
  80062d:	e8 71 fc ff ff       	call   8002a3 <va_is_dirty>
  800632:	84 c0                	test   %al,%al
  800634:	74 24                	je     80065a <bc_init+0xe3>
  800636:	c7 44 24 0c 33 46 80 	movl   $0x804633,0xc(%esp)
  80063d:	00 
  80063e:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  800645:	00 
  800646:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80064d:	00 
  80064e:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800655:	e8 8e 16 00 00       	call   801ce8 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  80065a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800661:	e8 55 fc ff ff       	call   8002bb <diskaddr>
  800666:	89 44 24 04          	mov    %eax,0x4(%esp)
  80066a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800671:	e8 1c 24 00 00       	call   802a92 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800676:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80067d:	e8 39 fc ff ff       	call   8002bb <diskaddr>
  800682:	89 04 24             	mov    %eax,(%esp)
  800685:	e8 ee fb ff ff       	call   800278 <va_is_mapped>
  80068a:	84 c0                	test   %al,%al
  80068c:	74 24                	je     8006b2 <bc_init+0x13b>
  80068e:	c7 44 24 0c 4d 46 80 	movl   $0x80464d,0xc(%esp)
  800695:	00 
  800696:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80069d:	00 
  80069e:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8006a5:	00 
  8006a6:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8006ad:	e8 36 16 00 00       	call   801ce8 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006b9:	e8 fd fb ff ff       	call   8002bb <diskaddr>
  8006be:	c7 44 24 04 2c 46 80 	movl   $0x80462c,0x4(%esp)
  8006c5:	00 
  8006c6:	89 04 24             	mov    %eax,(%esp)
  8006c9:	e8 e6 1d 00 00       	call   8024b4 <strcmp>
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	74 24                	je     8006f6 <bc_init+0x17f>
  8006d2:	c7 44 24 0c 6c 45 80 	movl   $0x80456c,0xc(%esp)
  8006d9:	00 
  8006da:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  8006e1:	00 
  8006e2:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8006e9:	00 
  8006ea:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8006f1:	e8 f2 15 00 00       	call   801ce8 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  8006f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006fd:	e8 b9 fb ff ff       	call   8002bb <diskaddr>
  800702:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800709:	00 
  80070a:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  800710:	89 54 24 04          	mov    %edx,0x4(%esp)
  800714:	89 04 24             	mov    %eax,(%esp)
  800717:	e8 93 1e 00 00       	call   8025af <memmove>
	flush_block(diskaddr(1));
  80071c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800723:	e8 93 fb ff ff       	call   8002bb <diskaddr>
  800728:	89 04 24             	mov    %eax,(%esp)
  80072b:	e8 71 fd ff ff       	call   8004a1 <flush_block>

	cprintf("block cache is good\n");
  800730:	c7 04 24 68 46 80 00 	movl   $0x804668,(%esp)
  800737:	e8 65 16 00 00       	call   801da1 <cprintf>
	struct Super super;
	set_pgfault_handler(bc_pgfault);
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  80073c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800743:	e8 73 fb ff ff       	call   8002bb <diskaddr>
  800748:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  80074f:	00 
  800750:	89 44 24 04          	mov    %eax,0x4(%esp)
  800754:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075a:	89 04 24             	mov    %eax,(%esp)
  80075d:	e8 4d 1e 00 00       	call   8025af <memmove>
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	53                   	push   %ebx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
	if (super == 0 || blockno >= super->s_nblocks)
  80076b:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  800771:	85 d2                	test   %edx,%edx
  800773:	74 22                	je     800797 <block_is_free+0x33>
  800775:	39 42 04             	cmp    %eax,0x4(%edx)
  800778:	76 1d                	jbe    800797 <block_is_free+0x33>
// --------------------------------------------------------------

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
  80077a:	89 c1                	mov    %eax,%ecx
  80077c:	83 e1 1f             	and    $0x1f,%ecx
  80077f:	ba 01 00 00 00       	mov    $0x1,%edx
  800784:	d3 e2                	shl    %cl,%edx
  800786:	c1 e8 05             	shr    $0x5,%eax
  800789:	8b 1d 08 a0 80 00    	mov    0x80a008,%ebx
  80078f:	85 14 83             	test   %edx,(%ebx,%eax,4)
  800792:	0f 95 c0             	setne  %al
  800795:	eb 05                	jmp    80079c <block_is_free+0x38>
  800797:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  80079c:	5b                   	pop    %ebx
  80079d:	5d                   	pop    %ebp
  80079e:	c3                   	ret    

0080079f <skip_slash>:
}

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
	while (*p == '/')
  8007a2:	eb 03                	jmp    8007a7 <skip_slash+0x8>
		p++;
  8007a4:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8007a7:	80 38 2f             	cmpb   $0x2f,(%eax)
  8007aa:	74 f8                	je     8007a4 <skip_slash+0x5>
		p++;
	return p;
}
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	53                   	push   %ebx
  8007b2:	83 ec 14             	sub    $0x14,%esp
  8007b5:	bb 01 00 00 00       	mov    $0x1,%ebx
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8007ba:	eb 13                	jmp    8007cf <fs_sync+0x21>
		flush_block(diskaddr(i));
  8007bc:	89 14 24             	mov    %edx,(%esp)
  8007bf:	e8 f7 fa ff ff       	call   8002bb <diskaddr>
  8007c4:	89 04 24             	mov    %eax,(%esp)
  8007c7:	e8 d5 fc ff ff       	call   8004a1 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8007cc:	83 c3 01             	add    $0x1,%ebx
  8007cf:	89 da                	mov    %ebx,%edx
  8007d1:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8007d6:	39 58 04             	cmp    %ebx,0x4(%eax)
  8007d9:	77 e1                	ja     8007bc <fs_sync+0xe>
		flush_block(diskaddr(i));
}
  8007db:	83 c4 14             	add    $0x14,%esp
  8007de:	5b                   	pop    %ebx
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	56                   	push   %esi
  8007e5:	53                   	push   %ebx
  8007e6:	83 ec 10             	sub    $0x10,%esp
  8007e9:	be 02 00 00 00       	mov    $0x2,%esi
  8007ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8007f3:	eb 39                	jmp    80082e <check_bitmap+0x4d>
		assert(!block_is_free(2+i));
  8007f5:	89 34 24             	mov    %esi,(%esp)
  8007f8:	e8 67 ff ff ff       	call   800764 <block_is_free>
  8007fd:	81 c3 00 80 00 00    	add    $0x8000,%ebx
  800803:	83 c6 01             	add    $0x1,%esi
  800806:	84 c0                	test   %al,%al
  800808:	74 24                	je     80082e <check_bitmap+0x4d>
  80080a:	c7 44 24 0c 89 46 80 	movl   $0x804689,0xc(%esp)
  800811:	00 
  800812:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  800819:	00 
  80081a:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
  800821:	00 
  800822:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800829:	e8 ba 14 00 00       	call   801ce8 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80082e:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800833:	39 58 04             	cmp    %ebx,0x4(%eax)
  800836:	77 bd                	ja     8007f5 <check_bitmap+0x14>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800838:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80083f:	e8 20 ff ff ff       	call   800764 <block_is_free>
  800844:	84 c0                	test   %al,%al
  800846:	74 24                	je     80086c <check_bitmap+0x8b>
  800848:	c7 44 24 0c a5 46 80 	movl   $0x8046a5,0xc(%esp)
  80084f:	00 
  800850:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  800857:	00 
  800858:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
  80085f:	00 
  800860:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800867:	e8 7c 14 00 00       	call   801ce8 <_panic>
	assert(!block_is_free(1));
  80086c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800873:	e8 ec fe ff ff       	call   800764 <block_is_free>
  800878:	84 c0                	test   %al,%al
  80087a:	74 24                	je     8008a0 <check_bitmap+0xbf>
  80087c:	c7 44 24 0c b7 46 80 	movl   $0x8046b7,0xc(%esp)
  800883:	00 
  800884:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80088b:	00 
  80088c:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800893:	00 
  800894:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  80089b:	e8 48 14 00 00       	call   801ce8 <_panic>

	cprintf("bitmap is good\n");
  8008a0:	c7 04 24 c9 46 80 00 	movl   $0x8046c9,(%esp)
  8008a7:	e8 f5 14 00 00       	call   801da1 <cprintf>
}
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5e                   	pop    %esi
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <unfree_block>:
//
// Hint: use free_block as an example for manipulating the bitmap.

void
unfree_block(uint32_t blockno)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 18             	sub    $0x18,%esp
  8008b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (blockno == 0) panic("attempt to unfree zero block");
  8008bc:	85 c9                	test   %ecx,%ecx
  8008be:	75 1c                	jne    8008dc <unfree_block+0x29>
  8008c0:	c7 44 24 08 d9 46 80 	movl   $0x8046d9,0x8(%esp)
  8008c7:	00 
  8008c8:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8008cf:	00 
  8008d0:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  8008d7:	e8 0c 14 00 00       	call   801ce8 <_panic>
	bitmap[blockno/32]&= ~(1<<(blockno%32));
  8008dc:	89 c8                	mov    %ecx,%eax
  8008de:	c1 e8 05             	shr    $0x5,%eax
  8008e1:	c1 e0 02             	shl    $0x2,%eax
  8008e4:	03 05 08 a0 80 00    	add    0x80a008,%eax
  8008ea:	83 e1 1f             	and    $0x1f,%ecx
  8008ed:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
  8008f2:	d3 c2                	rol    %cl,%edx
  8008f4:	21 10                	and    %edx,(%eax)
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <alloc_block>:

int
alloc_block(void)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	83 ec 10             	sub    $0x10,%esp

	// LAB 5: Your code here.

	uint32_t i;
	void * addr;
	if(!super)	super = diskaddr(1);
  800900:	83 3d 0c a0 80 00 00 	cmpl   $0x0,0x80a00c
  800907:	75 11                	jne    80091a <alloc_block+0x22>
  800909:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800910:	e8 a6 f9 ff ff       	call   8002bb <diskaddr>
  800915:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	if(!bitmap) bitmap = diskaddr(2);
  80091a:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  800921:	75 11                	jne    800934 <alloc_block+0x3c>
  800923:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80092a:	e8 8c f9 ff ff       	call   8002bb <diskaddr>
  80092f:	a3 08 a0 80 00       	mov    %eax,0x80a008
  800934:	bb 00 00 00 00       	mov    $0x0,%ebx
  800939:	eb 0f                	jmp    80094a <alloc_block+0x52>

	for(i=0;i<super->s_nblocks;i++)
		if(block_is_free(i))break;
  80093b:	89 1c 24             	mov    %ebx,(%esp)
  80093e:	e8 21 fe ff ff       	call   800764 <block_is_free>
  800943:	84 c0                	test   %al,%al
  800945:	75 0f                	jne    800956 <alloc_block+0x5e>
	uint32_t i;
	void * addr;
	if(!super)	super = diskaddr(1);
	if(!bitmap) bitmap = diskaddr(2);

	for(i=0;i<super->s_nblocks;i++)
  800947:	83 c3 01             	add    $0x1,%ebx
  80094a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80094f:	8b 70 04             	mov    0x4(%eax),%esi
  800952:	39 f3                	cmp    %esi,%ebx
  800954:	72 e5                	jb     80093b <alloc_block+0x43>
		if(block_is_free(i))break;

	if(i==super->s_nblocks) return -E_NO_DISK;
  800956:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80095b:	39 f3                	cmp    %esi,%ebx
  80095d:	74 20                	je     80097f <alloc_block+0x87>

	//memset(diskaddr(i),0,BLKSIZE);

	unfree_block(i);
  80095f:	89 1c 24             	mov    %ebx,(%esp)
  800962:	e8 4c ff ff ff       	call   8008b3 <unfree_block>
	addr = bitmap + i/BLKBITSIZE*BLKSIZE;
	flush_block(addr);
  800967:	89 d8                	mov    %ebx,%eax
  800969:	c1 e8 0f             	shr    $0xf,%eax
  80096c:	c1 e0 0e             	shl    $0xe,%eax
  80096f:	03 05 08 a0 80 00    	add    0x80a008,%eax
  800975:	89 04 24             	mov    %eax,(%esp)
  800978:	e8 24 fb ff ff       	call   8004a1 <flush_block>
	return i;
  80097d:	89 d8                	mov    %ebx,%eax
	
}
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	5b                   	pop    %ebx
  800983:	5e                   	pop    %esi
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 28             	sub    $0x28,%esp
  80098c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80098f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800992:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800995:	89 c3                	mov    %eax,%ebx
  800997:	89 d6                	mov    %edx,%esi
  800999:	89 cf                	mov    %ecx,%edi
  80099b:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
       // LAB 5: Your code here.
	   int ret = 0;	

	   if(filebno >= NDIRECT + NINDIRECT)return -E_INVAL;
  80099f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009a4:	81 fe 09 04 00 00    	cmp    $0x409,%esi
  8009aa:	77 78                	ja     800a24 <file_block_walk+0x9e>
	   
	   if(filebno < NDIRECT)
  8009ac:	83 fe 09             	cmp    $0x9,%esi
  8009af:	77 10                	ja     8009c1 <file_block_walk+0x3b>
	   	  *ppdiskbno = &(f->f_direct[filebno]); 	
  8009b1:	8d 84 b3 88 00 00 00 	lea    0x88(%ebx,%esi,4),%eax
  8009b8:	89 01                	mov    %eax,(%ecx)
  8009ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bf:	eb 63                	jmp    800a24 <file_block_walk+0x9e>
	   else
	   {
		  if(!f->f_indirect) 
  8009c1:	83 bb b0 00 00 00 00 	cmpl   $0x0,0xb0(%ebx)
  8009c8:	75 41                	jne    800a0b <file_block_walk+0x85>
		  {	
		  	if(!alloc)return -E_NOT_FOUND;
  8009ca:	84 d2                	test   %dl,%dl
  8009cc:	75 07                	jne    8009d5 <file_block_walk+0x4f>
  8009ce:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009d3:	eb 4f                	jmp    800a24 <file_block_walk+0x9e>

			ret = alloc_block();
  8009d5:	e8 1e ff ff ff       	call   8008f8 <alloc_block>
  8009da:	89 c2                	mov    %eax,%edx
			if(ret<0) return -E_NO_DISK;
  8009dc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8009e1:	85 d2                	test   %edx,%edx
  8009e3:	78 3f                	js     800a24 <file_block_walk+0x9e>

			f->f_indirect = ret;
  8009e5:	89 93 b0 00 00 00    	mov    %edx,0xb0(%ebx)
			memset(diskaddr(f->f_indirect),0,BLKSIZE);
  8009eb:	89 14 24             	mov    %edx,(%esp)
  8009ee:	e8 c8 f8 ff ff       	call   8002bb <diskaddr>
  8009f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8009fa:	00 
  8009fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a02:	00 
  800a03:	89 04 24             	mov    %eax,(%esp)
  800a06:	e8 45 1b 00 00       	call   802550 <memset>
		  }

		  *ppdiskbno = (uint32_t *)diskaddr(f->f_indirect);		  
  800a0b:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800a11:	89 04 24             	mov    %eax,(%esp)
  800a14:	e8 a2 f8 ff ff       	call   8002bb <diskaddr>
		  *ppdiskbno += filebno-NDIRECT;
  800a19:	8d 44 b0 d8          	lea    -0x28(%eax,%esi,4),%eax
  800a1d:	89 07                	mov    %eax,(%edi)
  800a1f:	b8 00 00 00 00       	mov    $0x0,%eax
	   }	   
	   return 0;
}
  800a24:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a27:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a2a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a2d:	89 ec                	mov    %ebp,%esp
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	57                   	push   %edi
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	83 ec 2c             	sub    $0x2c,%esp
  800a3a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3d:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800a42:	8d 7d e4             	lea    -0x1c(%ebp),%edi
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800a45:	eb 36                	jmp    800a7d <file_flush+0x4c>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800a47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a4e:	89 f9                	mov    %edi,%ecx
  800a50:	89 da                	mov    %ebx,%edx
  800a52:	89 f0                	mov    %esi,%eax
  800a54:	e8 2d ff ff ff       	call   800986 <file_block_walk>
  800a59:	85 c0                	test   %eax,%eax
  800a5b:	78 1d                	js     800a7a <file_flush+0x49>
		    pdiskbno == NULL || *pdiskbno == 0)
  800a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800a60:	85 c0                	test   %eax,%eax
  800a62:	74 16                	je     800a7a <file_flush+0x49>
		    pdiskbno == NULL || *pdiskbno == 0)
  800a64:	8b 00                	mov    (%eax),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800a66:	85 c0                	test   %eax,%eax
  800a68:	74 10                	je     800a7a <file_flush+0x49>
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
  800a6a:	89 04 24             	mov    %eax,(%esp)
  800a6d:	e8 49 f8 ff ff       	call   8002bb <diskaddr>
  800a72:	89 04 24             	mov    %eax,(%esp)
  800a75:	e8 27 fa ff ff       	call   8004a1 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800a7a:	83 c3 01             	add    $0x1,%ebx
  800a7d:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800a83:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800a89:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a8e:	0f 48 c2             	cmovs  %edx,%eax
  800a91:	c1 f8 0c             	sar    $0xc,%eax
  800a94:	39 c3                	cmp    %eax,%ebx
  800a96:	7c af                	jl     800a47 <file_flush+0x16>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800a98:	89 34 24             	mov    %esi,(%esp)
  800a9b:	e8 01 fa ff ff       	call   8004a1 <flush_block>
	if (f->f_indirect)
  800aa0:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800aa6:	85 c0                	test   %eax,%eax
  800aa8:	74 10                	je     800aba <file_flush+0x89>
		flush_block(diskaddr(f->f_indirect));
  800aaa:	89 04 24             	mov    %eax,(%esp)
  800aad:	e8 09 f8 ff ff       	call   8002bb <diskaddr>
  800ab2:	89 04 24             	mov    %eax,(%esp)
  800ab5:	e8 e7 f9 ff ff       	call   8004a1 <flush_block>
}
  800aba:	83 c4 2c             	add    $0x2c,%esp
  800abd:	5b                   	pop    %ebx
  800abe:	5e                   	pop    %esi
  800abf:	5f                   	pop    %edi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 28             	sub    $0x28,%esp
  800ac8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800acb:	89 75 fc             	mov    %esi,-0x4(%ebp)
       // LAB 5: Your code here.
	   uint32_t blkno;
	   uint32_t * ppdiskbno;
	   int ret;

	   ret = file_block_walk(f,filebno,&ppdiskbno,1);
  800ace:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800ad1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	e8 a3 fe ff ff       	call   800986 <file_block_walk>
  800ae3:	89 c3                	mov    %eax,%ebx
	   if(ret < 0) panic("block walk error %e",ret);
  800ae5:	85 c0                	test   %eax,%eax
  800ae7:	79 20                	jns    800b09 <file_get_block+0x47>
  800ae9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aed:	c7 44 24 08 f6 46 80 	movl   $0x8046f6,0x8(%esp)
  800af4:	00 
  800af5:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  800afc:	00 
  800afd:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800b04:	e8 df 11 00 00       	call   801ce8 <_panic>

	   //cprintf("%s blk offset %d blkno %x\n",__func__,filebno,*ppdiskbno);
	   
	   if(!*ppdiskbno) *ppdiskbno = alloc_block();
  800b09:	8b 75 f4             	mov    -0xc(%ebp),%esi
  800b0c:	83 3e 00             	cmpl   $0x0,(%esi)
  800b0f:	75 07                	jne    800b18 <file_get_block+0x56>
  800b11:	e8 e2 fd ff ff       	call   8008f8 <alloc_block>
  800b16:	89 06                	mov    %eax,(%esi)
	   if(ret <0) return ret;

	   //cprintf("%s alloc blk offset %d blkno %x\n",__func__,filebno,*ppdiskbno);
	   
	   *blk = (char *)diskaddr(*ppdiskbno);
  800b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b1b:	8b 00                	mov    (%eax),%eax
  800b1d:	89 04 24             	mov    %eax,(%esp)
  800b20:	e8 96 f7 ff ff       	call   8002bb <diskaddr>
  800b25:	8b 55 10             	mov    0x10(%ebp),%edx
  800b28:	89 02                	mov    %eax,(%edx)
	   return ret;
}
  800b2a:	89 d8                	mov    %ebx,%eax
  800b2c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800b2f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800b32:	89 ec                	mov    %ebp,%esp
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	83 ec 3c             	sub    $0x3c,%esp
  800b3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b45:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	39 d3                	cmp    %edx,%ebx
  800b58:	0f 8e 81 00 00 00    	jle    800bdf <file_read+0xa9>
		return 0;

	count = MIN(count, f->f_size - offset);
  800b5e:	29 d3                	sub    %edx,%ebx
  800b60:	39 cb                	cmp    %ecx,%ebx
  800b62:	0f 46 cb             	cmovbe %ebx,%ecx
  800b65:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800b68:	89 d3                	mov    %edx,%ebx

	for (pos = offset; pos < offset + count; ) {
  800b6a:	01 ca                	add    %ecx,%edx
  800b6c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b6f:	eb 63                	jmp    800bd4 <file_read+0x9e>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800b71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800b74:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b78:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800b7e:	85 db                	test   %ebx,%ebx
  800b80:	0f 49 c3             	cmovns %ebx,%eax
  800b83:	c1 f8 0c             	sar    $0xc,%eax
  800b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 04 24             	mov    %eax,(%esp)
  800b90:	e8 2d ff ff ff       	call   800ac2 <file_get_block>
  800b95:	85 c0                	test   %eax,%eax
  800b97:	78 46                	js     800bdf <file_read+0xa9>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800b99:	89 da                	mov    %ebx,%edx
  800b9b:	c1 fa 1f             	sar    $0x1f,%edx
  800b9e:	c1 ea 14             	shr    $0x14,%edx
  800ba1:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800ba4:	25 ff 0f 00 00       	and    $0xfff,%eax
  800ba9:	29 d0                	sub    %edx,%eax
  800bab:	be 00 10 00 00       	mov    $0x1000,%esi
  800bb0:	29 c6                	sub    %eax,%esi
  800bb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bb5:	2b 55 d0             	sub    -0x30(%ebp),%edx
  800bb8:	39 d6                	cmp    %edx,%esi
  800bba:	0f 47 f2             	cmova  %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800bbd:	89 74 24 08          	mov    %esi,0x8(%esp)
  800bc1:	03 45 e4             	add    -0x1c(%ebp),%eax
  800bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc8:	89 3c 24             	mov    %edi,(%esp)
  800bcb:	e8 df 19 00 00       	call   8025af <memmove>
		pos += bn;
  800bd0:	01 f3                	add    %esi,%ebx
		buf += bn;
  800bd2:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800bd4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800bd7:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800bda:	72 95                	jb     800b71 <file_read+0x3b>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800bdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
  800bdf:	83 c4 3c             	add    $0x3c,%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <free_block>:
}

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
  800bed:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800bf0:	85 c9                	test   %ecx,%ecx
  800bf2:	75 1c                	jne    800c10 <free_block+0x29>
		panic("attempt to free zero block");
  800bf4:	c7 44 24 08 0a 47 80 	movl   $0x80470a,0x8(%esp)
  800bfb:	00 
  800bfc:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800c03:	00 
  800c04:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800c0b:	e8 d8 10 00 00       	call   801ce8 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  800c10:	89 c8                	mov    %ecx,%eax
  800c12:	c1 e8 05             	shr    $0x5,%eax
  800c15:	c1 e0 02             	shl    $0x2,%eax
  800c18:	03 05 08 a0 80 00    	add    0x80a008,%eax
  800c1e:	83 e1 1f             	and    $0x1f,%ecx
  800c21:	ba 01 00 00 00       	mov    $0x1,%edx
  800c26:	d3 e2                	shl    %cl,%edx
  800c28:	09 10                	or     %edx,(%eax)
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 3c             	sub    $0x3c,%esp
  800c35:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800c38:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
  800c3e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
  800c41:	0f 8e 9c 00 00 00    	jle    800ce3 <file_set_size+0xb7>
file_truncate_blocks(struct File *f, off_t newsize)
{
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800c47:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800c4d:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  800c53:	0f 48 f8             	cmovs  %eax,%edi
  800c56:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5c:	81 c2 fe 1f 00 00    	add    $0x1ffe,%edx
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	05 ff 0f 00 00       	add    $0xfff,%eax
  800c6a:	0f 48 c2             	cmovs  %edx,%eax
  800c6d:	c1 f8 0c             	sar    $0xc,%eax
  800c70:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800c73:	89 c3                	mov    %eax,%ebx
  800c75:	eb 46                	jmp    800cbd <file_set_size+0x91>
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800c77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c7e:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800c81:	89 da                	mov    %ebx,%edx
  800c83:	89 f0                	mov    %esi,%eax
  800c85:	e8 fc fc ff ff       	call   800986 <file_block_walk>
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	78 1c                	js     800caa <file_set_size+0x7e>
		return r;
	if (*ptr) {
  800c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	85 c0                	test   %eax,%eax
  800c95:	74 23                	je     800cba <file_set_size+0x8e>
		free_block(*ptr);
  800c97:	89 04 24             	mov    %eax,(%esp)
  800c9a:	e8 48 ff ff ff       	call   800be7 <free_block>
		*ptr = 0;
  800c9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ca2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800ca8:	eb 10                	jmp    800cba <file_set_size+0x8e>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  800caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cae:	c7 04 24 25 47 80 00 	movl   $0x804725,(%esp)
  800cb5:	e8 e7 10 00 00       	call   801da1 <cprintf>
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800cba:	83 c3 01             	add    $0x1,%ebx
  800cbd:	39 df                	cmp    %ebx,%edi
  800cbf:	77 b6                	ja     800c77 <file_set_size+0x4b>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800cc1:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800cc5:	77 1c                	ja     800ce3 <file_set_size+0xb7>
  800cc7:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	74 12                	je     800ce3 <file_set_size+0xb7>
		free_block(f->f_indirect);
  800cd1:	89 04 24             	mov    %eax,(%esp)
  800cd4:	e8 0e ff ff ff       	call   800be7 <free_block>
		f->f_indirect = 0;
  800cd9:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ce0:	00 00 00 
int
file_set_size(struct File *f, off_t newsize)
{
	if (f->f_size > newsize)
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800cec:	89 34 24             	mov    %esi,(%esp)
  800cef:	e8 ad f7 ff ff       	call   8004a1 <flush_block>
	return 0;
}
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	83 c4 3c             	add    $0x3c,%esp
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 3c             	sub    $0x3c,%esp
  800d0a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  800d10:	8b 45 10             	mov    0x10(%ebp),%eax
  800d13:	01 d8                	add    %ebx,%eax
  800d15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	3b 82 80 00 00 00    	cmp    0x80(%edx),%eax
  800d21:	76 75                	jbe    800d98 <file_write+0x97>
		if ((r = file_set_size(f, offset + count)) < 0)
  800d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d27:	89 14 24             	mov    %edx,(%esp)
  800d2a:	e8 fd fe ff ff       	call   800c2c <file_set_size>
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	79 65                	jns    800d98 <file_write+0x97>
  800d33:	eb 6e                	jmp    800da3 <file_write+0xa2>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800d35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800d38:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d3c:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	0f 49 c3             	cmovns %ebx,%eax
  800d47:	c1 f8 0c             	sar    $0xc,%eax
  800d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d51:	89 14 24             	mov    %edx,(%esp)
  800d54:	e8 69 fd ff ff       	call   800ac2 <file_get_block>
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	78 46                	js     800da3 <file_write+0xa2>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800d5d:	89 da                	mov    %ebx,%edx
  800d5f:	c1 fa 1f             	sar    $0x1f,%edx
  800d62:	c1 ea 14             	shr    $0x14,%edx
  800d65:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800d68:	25 ff 0f 00 00       	and    $0xfff,%eax
  800d6d:	29 d0                	sub    %edx,%eax
  800d6f:	be 00 10 00 00       	mov    $0x1000,%esi
  800d74:	29 c6                	sub    %eax,%esi
  800d76:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800d79:	2b 55 d0             	sub    -0x30(%ebp),%edx
  800d7c:	39 d6                	cmp    %edx,%esi
  800d7e:	0f 47 f2             	cmova  %edx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800d81:	89 74 24 08          	mov    %esi,0x8(%esp)
  800d85:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d89:	03 45 e4             	add    -0x1c(%ebp),%eax
  800d8c:	89 04 24             	mov    %eax,(%esp)
  800d8f:	e8 1b 18 00 00       	call   8025af <memmove>
		pos += bn;
  800d94:	01 f3                	add    %esi,%ebx
		buf += bn;
  800d96:	01 f7                	add    %esi,%edi
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800d98:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800d9b:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800d9e:	77 95                	ja     800d35 <file_write+0x34>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800da3:	83 c4 3c             	add    $0x3c,%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  800db1:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800db6:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800dbc:	74 1c                	je     800dda <check_super+0x2f>
		panic("bad file system magic number");
  800dbe:	c7 44 24 08 42 47 80 	movl   $0x804742,0x8(%esp)
  800dc5:	00 
  800dc6:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800dcd:	00 
  800dce:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800dd5:	e8 0e 0f 00 00       	call   801ce8 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800dda:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800de1:	76 1c                	jbe    800dff <check_super+0x54>
		panic("file system is too large");
  800de3:	c7 44 24 08 5f 47 80 	movl   $0x80475f,0x8(%esp)
  800dea:	00 
  800deb:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  800df2:	00 
  800df3:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800dfa:	e8 e9 0e 00 00       	call   801ce8 <_panic>

	cprintf("superblock is good\n");
  800dff:	c7 04 24 78 47 80 00 	movl   $0x804778,(%esp)
  800e06:	e8 96 0f 00 00       	call   801da1 <cprintf>
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800e19:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800e1f:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  800e25:	e8 75 f9 ff ff       	call   80079f <skip_slash>
  800e2a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	f = &super->s_root;
  800e30:	a1 0c a0 80 00       	mov    0x80a00c,%eax
	dir = 0;
	name[0] = 0;
  800e35:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800e3c:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  800e43:	74 0c                	je     800e51 <walk_path+0x44>
		*pdir = 0;
  800e45:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800e4b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800e51:	83 c0 08             	add    $0x8,%eax
  800e54:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
  800e5a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800e66:	b8 00 00 00 00       	mov    $0x0,%eax
	while (*path != '\0') {
  800e6b:	e9 9a 01 00 00       	jmp    80100a <walk_path+0x1fd>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800e70:	83 c6 01             	add    $0x1,%esi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800e73:	0f b6 06             	movzbl (%esi),%eax
  800e76:	3c 2f                	cmp    $0x2f,%al
  800e78:	74 04                	je     800e7e <walk_path+0x71>
  800e7a:	84 c0                	test   %al,%al
  800e7c:	75 f2                	jne    800e70 <walk_path+0x63>
			path++;
		if (path - p >= MAXNAMELEN)
  800e7e:	89 f3                	mov    %esi,%ebx
  800e80:	2b 9d 48 ff ff ff    	sub    -0xb8(%ebp),%ebx
  800e86:	83 fb 7f             	cmp    $0x7f,%ebx
  800e89:	7e 0a                	jle    800e95 <walk_path+0x88>
  800e8b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800e90:	e9 b2 01 00 00       	jmp    801047 <walk_path+0x23a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800e95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e99:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  800e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ea3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800ea9:	89 04 24             	mov    %eax,(%esp)
  800eac:	e8 fe 16 00 00       	call   8025af <memmove>
		name[path - p] = '\0';
  800eb1:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800eb8:	00 
		path = skip_slash(path);
  800eb9:	89 f0                	mov    %esi,%eax
  800ebb:	e8 df f8 ff ff       	call   80079f <skip_slash>
  800ec0:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

		if (dir->f_type != FTYPE_DIR)
  800ec6:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800ecc:	83 ba 84 00 00 00 01 	cmpl   $0x1,0x84(%edx)
  800ed3:	0f 85 69 01 00 00    	jne    801042 <walk_path+0x235>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800ed9:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  800edf:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800ee4:	74 24                	je     800f0a <walk_path+0xfd>
  800ee6:	c7 44 24 0c 8c 47 80 	movl   $0x80478c,0xc(%esp)
  800eed:	00 
  800eee:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  800ef5:	00 
  800ef6:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  800efd:	00 
  800efe:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  800f05:	e8 de 0d 00 00       	call   801ce8 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800f0a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800f10:	85 c0                	test   %eax,%eax
  800f12:	0f 48 c2             	cmovs  %edx,%eax
  800f15:	c1 f8 0c             	sar    $0xc,%eax
  800f18:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800f1e:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800f25:	00 00 00 
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800f28:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  800f2e:	eb 61                	jmp    800f91 <walk_path+0x184>
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800f30:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800f36:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f3a:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800f40:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f44:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800f4a:	89 04 24             	mov    %eax,(%esp)
  800f4d:	e8 70 fb ff ff       	call   800ac2 <file_get_block>
  800f52:	85 c0                	test   %eax,%eax
  800f54:	78 4b                	js     800fa1 <walk_path+0x194>
  800f56:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
// and set *pdir to the directory the file is in.
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
  800f5c:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
  800f62:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800f68:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f6c:	89 1c 24             	mov    %ebx,(%esp)
  800f6f:	e8 40 15 00 00       	call   8024b4 <strcmp>
  800f74:	85 c0                	test   %eax,%eax
  800f76:	0f 84 82 00 00 00    	je     800ffe <walk_path+0x1f1>
  800f7c:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800f82:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  800f88:	75 de                	jne    800f68 <walk_path+0x15b>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800f8a:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800f91:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800f97:	39 85 44 ff ff ff    	cmp    %eax,-0xbc(%ebp)
  800f9d:	77 91                	ja     800f30 <walk_path+0x123>
  800f9f:	eb 09                	jmp    800faa <walk_path+0x19d>

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800fa1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800fa4:	0f 85 9d 00 00 00    	jne    801047 <walk_path+0x23a>
  800faa:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  800fb0:	80 3a 00             	cmpb   $0x0,(%edx)
  800fb3:	0f 85 89 00 00 00    	jne    801042 <walk_path+0x235>
				if (pdir)
  800fb9:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  800fc0:	74 0e                	je     800fd0 <walk_path+0x1c3>
					*pdir = dir;
  800fc2:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800fc8:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fce:	89 10                	mov    %edx,(%eax)
				if (lastelem)
  800fd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fd4:	74 15                	je     800feb <walk_path+0x1de>
					strcpy(lastelem, name);
  800fd6:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 04 24             	mov    %eax,(%esp)
  800fe6:	e8 1e 14 00 00       	call   802409 <strcpy>
				*pf = 0;
  800feb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800ff1:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  800ff7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800ffc:	eb 49                	jmp    801047 <walk_path+0x23a>
  800ffe:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801004:	89 9d 4c ff ff ff    	mov    %ebx,-0xb4(%ebp)
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  80100a:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  801010:	80 3a 00             	cmpb   $0x0,(%edx)
  801013:	74 07                	je     80101c <walk_path+0x20f>
  801015:	89 d6                	mov    %edx,%esi
  801017:	e9 57 fe ff ff       	jmp    800e73 <walk_path+0x66>
			}
			return r;
		}
	}

	if (pdir)
  80101c:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  801023:	74 08                	je     80102d <walk_path+0x220>
		*pdir = dir;
  801025:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  80102b:	89 02                	mov    %eax,(%edx)
	*pf = f;
  80102d:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  801033:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801039:	89 10                	mov    %edx,(%eax)
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801040:	eb 05                	jmp    801047 <walk_path+0x23a>
  801042:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801047:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  801058:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	ba 00 00 00 00       	mov    $0x0,%edx
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	e8 9e fd ff ff       	call   800e0d <walk_path>
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	57                   	push   %edi
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  80107d:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  801083:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801089:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80108f:	89 04 24             	mov    %eax,(%esp)
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	e8 73 fd ff ff       	call   800e0d <walk_path>
  80109a:	85 c0                	test   %eax,%eax
  80109c:	75 0a                	jne    8010a8 <file_create+0x37>
  80109e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8010a3:	e9 dc 00 00 00       	jmp    801184 <file_create+0x113>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  8010a8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8010ab:	0f 85 d3 00 00 00    	jne    801184 <file_create+0x113>
  8010b1:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  8010b7:	85 f6                	test   %esi,%esi
  8010b9:	0f 84 c5 00 00 00    	je     801184 <file_create+0x113>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8010bf:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  8010c5:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010ca:	74 24                	je     8010f0 <file_create+0x7f>
  8010cc:	c7 44 24 0c 8c 47 80 	movl   $0x80478c,0xc(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  8010db:	00 
  8010dc:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  8010e3:	00 
  8010e4:	c7 04 24 9d 46 80 00 	movl   $0x80469d,(%esp)
  8010eb:	e8 f8 0b 00 00       	call   801ce8 <_panic>
	nblock = dir->f_size / BLKSIZE;
  8010f0:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	0f 48 c2             	cmovs  %edx,%eax
  8010fb:	c1 f8 0c             	sar    $0xc,%eax
  8010fe:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  801104:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801109:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  80110f:	eb 39                	jmp    80114a <file_create+0xd9>
  801111:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801115:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801119:	89 34 24             	mov    %esi,(%esp)
  80111c:	e8 a1 f9 ff ff       	call   800ac2 <file_get_block>
  801121:	85 c0                	test   %eax,%eax
  801123:	78 5f                	js     801184 <file_create+0x113>
  801125:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
// --------------------------------------------------------------

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
  80112b:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801131:	80 38 00             	cmpb   $0x0,(%eax)
  801134:	75 08                	jne    80113e <file_create+0xcd>
				*file = &f[j];
  801136:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  80113c:	eb 51                	jmp    80118f <file_create+0x11e>
  80113e:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801143:	39 d0                	cmp    %edx,%eax
  801145:	75 ea                	jne    801131 <file_create+0xc0>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801147:	83 c3 01             	add    $0x1,%ebx
  80114a:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  801150:	77 bf                	ja     801111 <file_create+0xa0>
				*file = &f[j];
				return 0;
			}
	}
	//no available space for block
	dir->f_size += BLKSIZE;	
  801152:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  801159:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  80115c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801162:	89 44 24 08          	mov    %eax,0x8(%esp)
  801166:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80116a:	89 34 24             	mov    %esi,(%esp)
  80116d:	e8 50 f9 ff ff       	call   800ac2 <file_get_block>
  801172:	85 c0                	test   %eax,%eax
  801174:	78 0e                	js     801184 <file_create+0x113>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  801176:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80117c:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801182:	eb 0b                	jmp    80118f <file_create+0x11e>

	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}
  801184:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
	if ((r = dir_alloc_file(dir, &f)) < 0)
		return r;

	strcpy(f->f_name, name);
  80118f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801195:	89 44 24 04          	mov    %eax,0x4(%esp)
  801199:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80119f:	89 04 24             	mov    %eax,(%esp)
  8011a2:	e8 62 12 00 00       	call   802409 <strcpy>
	*pf = f;
  8011a7:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8011b2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8011b8:	89 04 24             	mov    %eax,(%esp)
  8011bb:	e8 71 f8 ff ff       	call   800a31 <file_flush>
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8011c5:	eb bd                	jmp    801184 <file_create+0x113>

008011c7 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

       // Find a JOS disk.  Use the second IDE disk (number 1) if availabl
       if (ide_probe_disk1())
  8011cd:	e8 42 f0 ff ff       	call   800214 <ide_probe_disk1>
  8011d2:	84 c0                	test   %al,%al
  8011d4:	74 0e                	je     8011e4 <fs_init+0x1d>
               ide_set_disk(1);
  8011d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011dd:	e8 01 f0 ff ff       	call   8001e3 <ide_set_disk>
  8011e2:	eb 0c                	jmp    8011f0 <fs_init+0x29>
       else
               ide_set_disk(0);
  8011e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011eb:	e8 f3 ef ff ff       	call   8001e3 <ide_set_disk>
	bc_init();
  8011f0:	e8 82 f3 ff ff       	call   800577 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8011f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011fc:	e8 ba f0 ff ff       	call   8002bb <diskaddr>
  801201:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  801206:	e8 a0 fb ff ff       	call   800dab <check_super>

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  80120b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801212:	e8 a4 f0 ff ff       	call   8002bb <diskaddr>
  801217:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  80121c:	e8 c0 f5 ff ff       	call   8007e1 <check_bitmap>
	//fs_test();
	
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    
	...

00801230 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	ba 20 50 80 00       	mov    $0x805020,%edx
  801238:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
		opentab[i].o_fileid = i;
  801242:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801244:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801247:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80124d:	83 c0 01             	add    $0x1,%eax
  801250:	83 c2 10             	add    $0x10,%edx
  801253:	3d 00 04 00 00       	cmp    $0x400,%eax
  801258:	75 e8                	jne    801242 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801262:	e8 47 f5 ff ff       	call   8007ae <fs_sync>
	return 0;
}
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <openfile_lookup>:
}

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 18             	sub    $0x18,%esp
  801274:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801277:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80127a:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80127d:	89 f3                	mov    %esi,%ebx
  80127f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801285:	c1 e3 04             	shl    $0x4,%ebx
  801288:	81 c3 20 50 80 00    	add    $0x805020,%ebx
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80128e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801291:	89 04 24             	mov    %eax,(%esp)
  801294:	e8 ef 1e 00 00       	call   803188 <pageref>
  801299:	83 f8 01             	cmp    $0x1,%eax
  80129c:	7e 10                	jle    8012ae <openfile_lookup+0x40>
  80129e:	39 33                	cmp    %esi,(%ebx)
  8012a0:	75 0c                	jne    8012ae <openfile_lookup+0x40>
		return -E_INVAL;
	*po = o;
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	89 18                	mov    %ebx,(%eax)
  8012a7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8012ac:	eb 05                	jmp    8012b3 <openfile_lookup+0x45>
  8012ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012b3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8012b6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8012b9:	89 ec                	mov    %ebp,%esp
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <serve_flush>:
}

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8012c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	8b 00                	mov    (%eax),%eax
  8012cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	89 04 24             	mov    %eax,(%esp)
  8012d9:	e8 90 ff ff ff       	call   80126e <openfile_lookup>
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 13                	js     8012f5 <serve_flush+0x38>
		return r;
	file_flush(o->o_file);
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	8b 40 04             	mov    0x4(%eax),%eax
  8012e8:	89 04 24             	mov    %eax,(%esp)
  8012eb:	e8 41 f7 ff ff       	call   800a31 <file_flush>
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	53                   	push   %ebx
  8012fb:	83 ec 24             	sub    $0x24,%esp
  8012fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801301:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801304:	89 44 24 08          	mov    %eax,0x8(%esp)
  801308:	8b 03                	mov    (%ebx),%eax
  80130a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	89 04 24             	mov    %eax,(%esp)
  801314:	e8 55 ff ff ff       	call   80126e <openfile_lookup>
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 3f                	js     80135c <serve_stat+0x65>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  80131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801320:	8b 40 04             	mov    0x4(%eax),%eax
  801323:	89 44 24 04          	mov    %eax,0x4(%esp)
  801327:	89 1c 24             	mov    %ebx,(%esp)
  80132a:	e8 da 10 00 00       	call   802409 <strcpy>
	ret->ret_size = o->o_file->f_size;
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	8b 50 04             	mov    0x4(%eax),%edx
  801335:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  80133b:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801341:	8b 40 04             	mov    0x4(%eax),%eax
  801344:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80134b:	0f 94 c0             	sete   %al
  80134e:	0f b6 c0             	movzbl %al,%eax
  801351:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80135c:	83 c4 24             	add    $0x24,%esp
  80135f:	5b                   	pop    %ebx
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	53                   	push   %ebx
  801366:	83 ec 24             	sub    $0x24,%esp
  801369:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 5: Your code here.

	struct OpenFile *o;
	int ret;

	ret = openfile_lookup(envid, req->req_fileid, &o);
  80136c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801373:	8b 03                	mov    (%ebx),%eax
  801375:	89 44 24 04          	mov    %eax,0x4(%esp)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 04 24             	mov    %eax,(%esp)
  80137f:	e8 ea fe ff ff       	call   80126e <openfile_lookup>
	if(ret) return ret;
  801384:	85 c0                	test   %eax,%eax
  801386:	75 33                	jne    8013bb <serve_write+0x59>

	//find read from curr offset
	ret = file_write(o->o_file,req->req_buf,req->req_n,o->o_fd->fd_offset);
  801388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138b:	8b 50 0c             	mov    0xc(%eax),%edx
  80138e:	8b 52 04             	mov    0x4(%edx),%edx
  801391:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801395:	8b 53 04             	mov    0x4(%ebx),%edx
  801398:	89 54 24 08          	mov    %edx,0x8(%esp)
  80139c:	83 c3 08             	add    $0x8,%ebx
  80139f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a3:	8b 40 04             	mov    0x4(%eax),%eax
  8013a6:	89 04 24             	mov    %eax,(%esp)
  8013a9:	e8 53 f9 ff ff       	call   800d01 <file_write>
	if(ret<0) return ret;
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 09                	js     8013bb <serve_write+0x59>
	
	o->o_fd->fd_offset+= ret;
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b8:	01 42 04             	add    %eax,0x4(%edx)
	return ret;	
}
  8013bb:	83 c4 24             	add    $0x24,%esp
  8013be:	5b                   	pop    %ebx
  8013bf:	5d                   	pop    %ebp
  8013c0:	c3                   	ret    

008013c1 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	53                   	push   %ebx
  8013c5:	83 ec 24             	sub    $0x24,%esp
  8013c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	
	r = openfile_lookup(envid, req->req_fileid, &o);
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d2:	8b 03                	mov    (%ebx),%eax
  8013d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 04 24             	mov    %eax,(%esp)
  8013de:	e8 8b fe ff ff       	call   80126e <openfile_lookup>
	if(r<0) return r;
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 30                	js     801417 <serve_read+0x56>

	//find read from curr offset
	r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset);
  8013e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8013ed:	8b 52 04             	mov    0x4(%edx),%edx
  8013f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013f4:	8b 53 04             	mov    0x4(%ebx),%edx
  8013f7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013ff:	8b 40 04             	mov    0x4(%eax),%eax
  801402:	89 04 24             	mov    %eax,(%esp)
  801405:	e8 2c f7 ff ff       	call   800b36 <file_read>
	if(r<0) return r;
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 09                	js     801417 <serve_read+0x56>
	
	o->o_fd->fd_offset += r;
  80140e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801411:	8b 52 0c             	mov    0xc(%edx),%edx
  801414:	01 42 04             	add    %eax,0x4(%edx)
	return r;
}
  801417:	83 c4 24             	add    $0x24,%esp
  80141a:	5b                   	pop    %ebx
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	53                   	push   %ebx
  801421:	83 ec 24             	sub    $0x24,%esp
  801424:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801427:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142e:	8b 03                	mov    (%ebx),%eax
  801430:	89 44 24 04          	mov    %eax,0x4(%esp)
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	89 04 24             	mov    %eax,(%esp)
  80143a:	e8 2f fe ff ff       	call   80126e <openfile_lookup>
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 15                	js     801458 <serve_set_size+0x3b>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  801443:	8b 43 04             	mov    0x4(%ebx),%eax
  801446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144d:	8b 40 04             	mov    0x4(%eax),%eax
  801450:	89 04 24             	mov    %eax,(%esp)
  801453:	e8 d4 f7 ff ff       	call   800c2c <file_set_size>
}
  801458:	83 c4 24             	add    $0x24,%esp
  80145b:	5b                   	pop    %ebx
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    

0080145e <openfile_alloc>:
}

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 28             	sub    $0x28,%esp
  801464:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801467:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80146a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80146d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801470:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
		switch (pageref(opentab[i].o_fd)) {
  801475:	be 2c 50 80 00       	mov    $0x80502c,%esi
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	c1 e0 04             	shl    $0x4,%eax
  80147f:	8b 04 06             	mov    (%esi,%eax,1),%eax
  801482:	89 04 24             	mov    %eax,(%esp)
  801485:	e8 fe 1c 00 00       	call   803188 <pageref>
  80148a:	85 c0                	test   %eax,%eax
  80148c:	74 07                	je     801495 <openfile_alloc+0x37>
  80148e:	83 f8 01             	cmp    $0x1,%eax
  801491:	75 62                	jne    8014f5 <openfile_alloc+0x97>
  801493:	eb 27                	jmp    8014bc <openfile_alloc+0x5e>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801495:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80149c:	00 
  80149d:	89 d8                	mov    %ebx,%eax
  80149f:	c1 e0 04             	shl    $0x4,%eax
  8014a2:	8b 80 2c 50 80 00    	mov    0x80502c(%eax),%eax
  8014a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b3:	e8 96 16 00 00       	call   802b4e <sys_page_alloc>
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 4d                	js     801509 <openfile_alloc+0xab>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  8014bc:	c1 e3 04             	shl    $0x4,%ebx
  8014bf:	81 83 20 50 80 00 00 	addl   $0x400,0x805020(%ebx)
  8014c6:	04 00 00 
			*o = &opentab[i];
  8014c9:	8d 83 20 50 80 00    	lea    0x805020(%ebx),%eax
  8014cf:	89 07                	mov    %eax,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8014d1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014d8:	00 
  8014d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014e0:	00 
  8014e1:	8b 83 2c 50 80 00    	mov    0x80502c(%ebx),%eax
  8014e7:	89 04 24             	mov    %eax,(%esp)
  8014ea:	e8 61 10 00 00       	call   802550 <memset>
			return (*o)->o_fileid;
  8014ef:	8b 07                	mov    (%edi),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	eb 14                	jmp    801509 <openfile_alloc+0xab>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8014f5:	83 c3 01             	add    $0x1,%ebx
  8014f8:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8014fe:	0f 85 76 ff ff ff    	jne    80147a <openfile_alloc+0x1c>
  801504:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
}
  801509:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80150c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80150f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801512:	89 ec                	mov    %ebp,%esp
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	53                   	push   %ebx
  80151a:	81 ec 24 04 00 00    	sub    $0x424,%esp
  801520:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  801523:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  80152a:	00 
  80152b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80152f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801535:	89 04 24             	mov    %eax,(%esp)
  801538:	e8 72 10 00 00       	call   8025af <memmove>
	path[MAXPATHLEN-1] = 0;
  80153d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801541:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 0f ff ff ff       	call   80145e <openfile_alloc>
  80154f:	85 c0                	test   %eax,%eax
  801551:	0f 88 0c 01 00 00    	js     801663 <serve_open+0x14d>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  801557:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  80155e:	74 32                	je     801592 <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  801560:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156a:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801570:	89 04 24             	mov    %eax,(%esp)
  801573:	e8 f9 fa ff ff       	call   801071 <file_create>
  801578:	85 c0                	test   %eax,%eax
  80157a:	79 36                	jns    8015b2 <serve_open+0x9c>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80157c:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801583:	0f 85 da 00 00 00    	jne    801663 <serve_open+0x14d>
  801589:	83 f8 f3             	cmp    $0xfffffff3,%eax
  80158c:	0f 85 d1 00 00 00    	jne    801663 <serve_open+0x14d>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  801592:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159c:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	e8 a8 fa ff ff       	call   801052 <file_open>
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	0f 88 b1 00 00 00    	js     801663 <serve_open+0x14d>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8015b2:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8015b9:	74 1e                	je     8015d9 <serve_open+0xc3>
		if ((r = file_set_size(f, 0)) < 0) {
  8015bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015c2:	00 
  8015c3:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  8015c9:	89 04 24             	mov    %eax,(%esp)
  8015cc:	e8 5b f6 ff ff       	call   800c2c <file_set_size>
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	0f 88 8a 00 00 00    	js     801663 <serve_open+0x14d>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
		}
	}
	if ((r = file_open(path, &f)) < 0) {
  8015d9:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e3:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015e9:	89 04 24             	mov    %eax,(%esp)
  8015ec:	e8 61 fa ff ff       	call   801052 <file_open>
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 6e                	js     801663 <serve_open+0x14d>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  8015f5:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  8015fb:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801601:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  801604:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80160a:	8b 50 0c             	mov    0xc(%eax),%edx
  80160d:	8b 00                	mov    (%eax),%eax
  80160f:	89 42 0c             	mov    %eax,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801612:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801618:	8b 40 0c             	mov    0xc(%eax),%eax
  80161b:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801621:	83 e2 03             	and    $0x3,%edx
  801624:	89 50 08             	mov    %edx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801627:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80162d:	8b 40 0c             	mov    0xc(%eax),%eax
  801630:	8b 15 68 90 80 00    	mov    0x809068,%edx
  801636:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801638:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80163e:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801644:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  801647:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80164d:	8b 50 0c             	mov    0xc(%eax),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801655:	8b 45 14             	mov    0x14(%ebp),%eax
  801658:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax

	return 0;
}
  801663:	81 c4 24 04 00 00    	add    $0x424,%esp
  801669:	5b                   	pop    %ebx
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	57                   	push   %edi
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	83 ec 2c             	sub    $0x2c,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801675:	8d 5d e0             	lea    -0x20(%ebp),%ebx
  801678:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < NHANDLERS && handlers[req]) {
  80167b:	bf 40 90 80 00       	mov    $0x809040,%edi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  801680:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801687:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80168b:	a1 20 90 80 00       	mov    0x809020,%eax
  801690:	89 44 24 04          	mov    %eax,0x4(%esp)
  801694:	89 34 24             	mov    %esi,(%esp)
  801697:	e8 1e 17 00 00       	call   802dba <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  80169c:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  8016a0:	75 15                	jne    8016b7 <serve+0x4b>
			cprintf("Invalid request from %08x: no argument page\n",
  8016a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a9:	c7 04 24 ac 47 80 00 	movl   $0x8047ac,(%esp)
  8016b0:	e8 ec 06 00 00       	call   801da1 <cprintf>
				whom);
			continue; // just leave it hanging...
  8016b5:	eb c9                	jmp    801680 <serve+0x14>
		}

		pg = NULL;
  8016b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		if (req == FSREQ_OPEN) {
  8016be:	83 f8 01             	cmp    $0x1,%eax
  8016c1:	75 21                	jne    8016e4 <serve+0x78>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8016c3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016c7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8016ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ce:	a1 20 90 80 00       	mov    0x809020,%eax
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016da:	89 04 24             	mov    %eax,(%esp)
  8016dd:	e8 34 fe ff ff       	call   801516 <serve_open>
  8016e2:	eb 3d                	jmp    801721 <serve+0xb5>
		} else if (req < NHANDLERS && handlers[req]) {
  8016e4:	83 f8 08             	cmp    $0x8,%eax
  8016e7:	77 1c                	ja     801705 <serve+0x99>
  8016e9:	8b 14 87             	mov    (%edi,%eax,4),%edx
  8016ec:	85 d2                	test   %edx,%edx
  8016ee:	66 90                	xchg   %ax,%ax
  8016f0:	74 13                	je     801705 <serve+0x99>
			r = handlers[req](whom, fsreq);
  8016f2:	a1 20 90 80 00       	mov    0x809020,%eax
  8016f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016fe:	89 04 24             	mov    %eax,(%esp)
  801701:	ff d2                	call   *%edx
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < NHANDLERS && handlers[req]) {
  801703:	eb 1c                	jmp    801721 <serve+0xb5>
			r = handlers[req](whom, fsreq);
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801705:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801708:	89 54 24 08          	mov    %edx,0x8(%esp)
  80170c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801710:	c7 04 24 dc 47 80 00 	movl   $0x8047dc,(%esp)
  801717:	e8 85 06 00 00       	call   801da1 <cprintf>
  80171c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			r = -E_INVAL;
		}
			
		ipc_send(whom, r, pg, perm);
  801721:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801724:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801728:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80172b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80172f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801736:	89 04 24             	mov    %eax,(%esp)
  801739:	e8 10 16 00 00       	call   802d4e <ipc_send>
		sys_page_unmap(0, fsreq);
  80173e:	a1 20 90 80 00       	mov    0x809020,%eax
  801743:	89 44 24 04          	mov    %eax,0x4(%esp)
  801747:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174e:	e8 3f 13 00 00       	call   802a92 <sys_page_unmap>
  801753:	e9 28 ff ff ff       	jmp    801680 <serve+0x14>

00801758 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80175e:	c7 05 64 90 80 00 ff 	movl   $0x8047ff,0x809064
  801765:	47 80 00 
	cprintf("FS is running\n");
  801768:	c7 04 24 02 48 80 00 	movl   $0x804802,(%esp)
  80176f:	e8 2d 06 00 00       	call   801da1 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801774:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801779:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  80177e:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801780:	c7 04 24 11 48 80 00 	movl   $0x804811,(%esp)
  801787:	e8 15 06 00 00       	call   801da1 <cprintf>

	serve_init();
  80178c:	e8 9f fa ff ff       	call   801230 <serve_init>
	fs_init();
  801791:	e8 31 fa ff ff       	call   8011c7 <fs_init>
	serve();
  801796:	e8 d1 fe ff ff       	call   80166c <serve>
}
  80179b:	c9                   	leave  
  80179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017a0:	c3                   	ret    
  8017a1:	00 00                	add    %al,(%eax)
	...

008017a4 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8017ab:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8017b2:	00 
  8017b3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  8017ba:	00 
  8017bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c2:	e8 87 13 00 00       	call   802b4e <sys_page_alloc>
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	79 20                	jns    8017eb <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  8017cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017cf:	c7 44 24 08 20 48 80 	movl   $0x804820,0x8(%esp)
  8017d6:	00 
  8017d7:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8017de:	00 
  8017df:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  8017e6:	e8 fd 04 00 00       	call   801ce8 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8017eb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8017f2:	00 
  8017f3:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8017f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  801803:	e8 a7 0d 00 00       	call   8025af <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801808:	e8 eb f0 ff ff       	call   8008f8 <alloc_block>
  80180d:	85 c0                	test   %eax,%eax
  80180f:	79 20                	jns    801831 <fs_test+0x8d>
		panic("alloc_block: %e", r);
  801811:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801815:	c7 44 24 08 3d 48 80 	movl   $0x80483d,0x8(%esp)
  80181c:	00 
  80181d:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  801824:	00 
  801825:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  80182c:	e8 b7 04 00 00       	call   801ce8 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801831:	8d 50 1f             	lea    0x1f(%eax),%edx
  801834:	85 c0                	test   %eax,%eax
  801836:	0f 49 d0             	cmovns %eax,%edx
  801839:	c1 fa 05             	sar    $0x5,%edx
  80183c:	c1 e2 02             	shl    $0x2,%edx
  80183f:	89 c3                	mov    %eax,%ebx
  801841:	c1 fb 1f             	sar    $0x1f,%ebx
  801844:	c1 eb 1b             	shr    $0x1b,%ebx
  801847:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  80184a:	83 e1 1f             	and    $0x1f,%ecx
  80184d:	29 d9                	sub    %ebx,%ecx
  80184f:	b8 01 00 00 00       	mov    $0x1,%eax
  801854:	d3 e0                	shl    %cl,%eax
  801856:	85 82 00 10 00 00    	test   %eax,0x1000(%edx)
  80185c:	75 24                	jne    801882 <fs_test+0xde>
  80185e:	c7 44 24 0c 4d 48 80 	movl   $0x80484d,0xc(%esp)
  801865:	00 
  801866:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80186d:	00 
  80186e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  801875:	00 
  801876:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  80187d:	e8 66 04 00 00       	call   801ce8 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801882:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  801888:	85 04 11             	test   %eax,(%ecx,%edx,1)
  80188b:	74 24                	je     8018b1 <fs_test+0x10d>
  80188d:	c7 44 24 0c c8 49 80 	movl   $0x8049c8,0xc(%esp)
  801894:	00 
  801895:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80189c:	00 
  80189d:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8018a4:	00 
  8018a5:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  8018ac:	e8 37 04 00 00       	call   801ce8 <_panic>
	cprintf("alloc_block is good\n");
  8018b1:	c7 04 24 68 48 80 00 	movl   $0x804868,(%esp)
  8018b8:	e8 e4 04 00 00       	call   801da1 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8018bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c4:	c7 04 24 7d 48 80 00 	movl   $0x80487d,(%esp)
  8018cb:	e8 82 f7 ff ff       	call   801052 <file_open>
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	79 25                	jns    8018f9 <fs_test+0x155>
  8018d4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018d7:	74 40                	je     801919 <fs_test+0x175>
		panic("file_open /not-found: %e", r);
  8018d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018dd:	c7 44 24 08 88 48 80 	movl   $0x804888,0x8(%esp)
  8018e4:	00 
  8018e5:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8018ec:	00 
  8018ed:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  8018f4:	e8 ef 03 00 00       	call   801ce8 <_panic>
	else if (r == 0)
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	75 1c                	jne    801919 <fs_test+0x175>
		panic("file_open /not-found succeeded!");
  8018fd:	c7 44 24 08 e8 49 80 	movl   $0x8049e8,0x8(%esp)
  801904:	00 
  801905:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  80190c:	00 
  80190d:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801914:	e8 cf 03 00 00       	call   801ce8 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  801919:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801920:	c7 04 24 a1 48 80 00 	movl   $0x8048a1,(%esp)
  801927:	e8 26 f7 ff ff       	call   801052 <file_open>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	79 20                	jns    801950 <fs_test+0x1ac>
		panic("file_open /newmotd: %e", r);
  801930:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801934:	c7 44 24 08 aa 48 80 	movl   $0x8048aa,0x8(%esp)
  80193b:	00 
  80193c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801943:	00 
  801944:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  80194b:	e8 98 03 00 00       	call   801ce8 <_panic>
	cprintf("file_open is good\n");
  801950:	c7 04 24 c1 48 80 00 	movl   $0x8048c1,(%esp)
  801957:	e8 45 04 00 00       	call   801da1 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80195c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801963:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80196a:	00 
  80196b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196e:	89 04 24             	mov    %eax,(%esp)
  801971:	e8 4c f1 ff ff       	call   800ac2 <file_get_block>
  801976:	85 c0                	test   %eax,%eax
  801978:	79 20                	jns    80199a <fs_test+0x1f6>
		panic("file_get_block: %e", r);
  80197a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80197e:	c7 44 24 08 d4 48 80 	movl   $0x8048d4,0x8(%esp)
  801985:	00 
  801986:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80198d:	00 
  80198e:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801995:	e8 4e 03 00 00       	call   801ce8 <_panic>
	if (strcmp(blk, msg) != 0)
  80199a:	8b 1d 54 4a 80 00    	mov    0x804a54,%ebx
  8019a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a7:	89 04 24             	mov    %eax,(%esp)
  8019aa:	e8 05 0b 00 00       	call   8024b4 <strcmp>
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	74 1c                	je     8019cf <fs_test+0x22b>
		panic("file_get_block returned wrong data");
  8019b3:	c7 44 24 08 08 4a 80 	movl   $0x804a08,0x8(%esp)
  8019ba:	00 
  8019bb:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  8019c2:	00 
  8019c3:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  8019ca:	e8 19 03 00 00       	call   801ce8 <_panic>
	cprintf("file_get_block is good\n");
  8019cf:	c7 04 24 e7 48 80 00 	movl   $0x8048e7,(%esp)
  8019d6:	e8 c6 03 00 00       	call   801da1 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019de:	0f b6 10             	movzbl (%eax),%edx
  8019e1:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	c1 e8 0c             	shr    $0xc,%eax
  8019e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019f0:	a8 40                	test   $0x40,%al
  8019f2:	75 24                	jne    801a18 <fs_test+0x274>
  8019f4:	c7 44 24 0c 00 49 80 	movl   $0x804900,0xc(%esp)
  8019fb:	00 
  8019fc:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801a03:	00 
  801a04:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801a0b:	00 
  801a0c:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801a13:	e8 d0 02 00 00       	call   801ce8 <_panic>
	file_flush(f);
  801a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1b:	89 04 24             	mov    %eax,(%esp)
  801a1e:	e8 0e f0 ff ff       	call   800a31 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a26:	c1 e8 0c             	shr    $0xc,%eax
  801a29:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a30:	a8 40                	test   $0x40,%al
  801a32:	74 24                	je     801a58 <fs_test+0x2b4>
  801a34:	c7 44 24 0c ff 48 80 	movl   $0x8048ff,0xc(%esp)
  801a3b:	00 
  801a3c:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801a43:	00 
  801a44:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801a4b:	00 
  801a4c:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801a53:	e8 90 02 00 00       	call   801ce8 <_panic>
	cprintf("file_flush is good\n");
  801a58:	c7 04 24 1b 49 80 00 	movl   $0x80491b,(%esp)
  801a5f:	e8 3d 03 00 00       	call   801da1 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801a64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a6b:	00 
  801a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6f:	89 04 24             	mov    %eax,(%esp)
  801a72:	e8 b5 f1 ff ff       	call   800c2c <file_set_size>
  801a77:	85 c0                	test   %eax,%eax
  801a79:	79 20                	jns    801a9b <fs_test+0x2f7>
		panic("file_set_size: %e", r);
  801a7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a7f:	c7 44 24 08 2f 49 80 	movl   $0x80492f,0x8(%esp)
  801a86:	00 
  801a87:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801a8e:	00 
  801a8f:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801a96:	e8 4d 02 00 00       	call   801ce8 <_panic>
	assert(f->f_direct[0] == 0);
  801a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9e:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801aa5:	74 24                	je     801acb <fs_test+0x327>
  801aa7:	c7 44 24 0c 41 49 80 	movl   $0x804941,0xc(%esp)
  801aae:	00 
  801aaf:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801ab6:	00 
  801ab7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801abe:	00 
  801abf:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801ac6:	e8 1d 02 00 00       	call   801ce8 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801acb:	c1 e8 0c             	shr    $0xc,%eax
  801ace:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ad5:	a8 40                	test   $0x40,%al
  801ad7:	74 24                	je     801afd <fs_test+0x359>
  801ad9:	c7 44 24 0c 55 49 80 	movl   $0x804955,0xc(%esp)
  801ae0:	00 
  801ae1:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801ae8:	00 
  801ae9:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801af0:	00 
  801af1:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801af8:	e8 eb 01 00 00       	call   801ce8 <_panic>
	cprintf("file_truncate is good\n");
  801afd:	c7 04 24 6f 49 80 00 	movl   $0x80496f,(%esp)
  801b04:	e8 98 02 00 00       	call   801da1 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801b09:	89 1c 24             	mov    %ebx,(%esp)
  801b0c:	e8 bf 08 00 00       	call   8023d0 <strlen>
  801b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b18:	89 04 24             	mov    %eax,(%esp)
  801b1b:	e8 0c f1 ff ff       	call   800c2c <file_set_size>
  801b20:	85 c0                	test   %eax,%eax
  801b22:	79 20                	jns    801b44 <fs_test+0x3a0>
		panic("file_set_size 2: %e", r);
  801b24:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b28:	c7 44 24 08 86 49 80 	movl   $0x804986,0x8(%esp)
  801b2f:	00 
  801b30:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801b37:	00 
  801b38:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801b3f:	e8 a4 01 00 00       	call   801ce8 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	89 c2                	mov    %eax,%edx
  801b49:	c1 ea 0c             	shr    $0xc,%edx
  801b4c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b53:	f6 c2 40             	test   $0x40,%dl
  801b56:	74 24                	je     801b7c <fs_test+0x3d8>
  801b58:	c7 44 24 0c 55 49 80 	movl   $0x804955,0xc(%esp)
  801b5f:	00 
  801b60:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801b67:	00 
  801b68:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801b6f:	00 
  801b70:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801b77:	e8 6c 01 00 00       	call   801ce8 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801b7c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b7f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b83:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b8a:	00 
  801b8b:	89 04 24             	mov    %eax,(%esp)
  801b8e:	e8 2f ef ff ff       	call   800ac2 <file_get_block>
  801b93:	85 c0                	test   %eax,%eax
  801b95:	79 20                	jns    801bb7 <fs_test+0x413>
		panic("file_get_block 2: %e", r);
  801b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b9b:	c7 44 24 08 9a 49 80 	movl   $0x80499a,0x8(%esp)
  801ba2:	00 
  801ba3:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  801baa:	00 
  801bab:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801bb2:	e8 31 01 00 00       	call   801ce8 <_panic>
	strcpy(blk, msg);
  801bb7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 43 08 00 00       	call   802409 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc9:	c1 e8 0c             	shr    $0xc,%eax
  801bcc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bd3:	a8 40                	test   $0x40,%al
  801bd5:	75 24                	jne    801bfb <fs_test+0x457>
  801bd7:	c7 44 24 0c 00 49 80 	movl   $0x804900,0xc(%esp)
  801bde:	00 
  801bdf:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801be6:	00 
  801be7:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  801bee:	00 
  801bef:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801bf6:	e8 ed 00 00 00       	call   801ce8 <_panic>
	file_flush(f);
  801bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 2b ee ff ff       	call   800a31 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c09:	c1 e8 0c             	shr    $0xc,%eax
  801c0c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c13:	a8 40                	test   $0x40,%al
  801c15:	74 24                	je     801c3b <fs_test+0x497>
  801c17:	c7 44 24 0c ff 48 80 	movl   $0x8048ff,0xc(%esp)
  801c1e:	00 
  801c1f:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801c26:	00 
  801c27:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  801c2e:	00 
  801c2f:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801c36:	e8 ad 00 00 00       	call   801ce8 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	c1 e8 0c             	shr    $0xc,%eax
  801c41:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c48:	a8 40                	test   $0x40,%al
  801c4a:	74 24                	je     801c70 <fs_test+0x4cc>
  801c4c:	c7 44 24 0c 55 49 80 	movl   $0x804955,0xc(%esp)
  801c53:	00 
  801c54:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  801c5b:	00 
  801c5c:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801c63:	00 
  801c64:	c7 04 24 33 48 80 00 	movl   $0x804833,(%esp)
  801c6b:	e8 78 00 00 00       	call   801ce8 <_panic>
	cprintf("file rewrite is good\n");
  801c70:	c7 04 24 af 49 80 00 	movl   $0x8049af,(%esp)
  801c77:	e8 25 01 00 00       	call   801da1 <cprintf>
}
  801c7c:	83 c4 24             	add    $0x24,%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    
	...

00801c84 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 18             	sub    $0x18,%esp
  801c8a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c8d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c90:	8b 75 08             	mov    0x8(%ebp),%esi
  801c93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  801c96:	e8 46 0f 00 00       	call   802be1 <sys_getenvid>
  801c9b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ca0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ca3:	2d 00 00 40 11       	sub    $0x11400000,%eax
  801ca8:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801cad:	85 f6                	test   %esi,%esi
  801caf:	7e 07                	jle    801cb8 <libmain+0x34>
		binaryname = argv[0];
  801cb1:	8b 03                	mov    (%ebx),%eax
  801cb3:	a3 64 90 80 00       	mov    %eax,0x809064

	// call user main routine
	umain(argc, argv);
  801cb8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cbc:	89 34 24             	mov    %esi,(%esp)
  801cbf:	e8 94 fa ff ff       	call   801758 <umain>

	// exit gracefully
	exit();
  801cc4:	e8 0b 00 00 00       	call   801cd4 <exit>
}
  801cc9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ccc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ccf:	89 ec                	mov    %ebp,%esp
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    
	...

00801cd4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  801cda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce1:	e8 2f 0f 00 00       	call   802c15 <sys_env_destroy>
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801cf0:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cf3:	8b 1d 64 90 80 00    	mov    0x809064,%ebx
  801cf9:	e8 e3 0e 00 00       	call   802be1 <sys_getenvid>
  801cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d01:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d05:	8b 55 08             	mov    0x8(%ebp),%edx
  801d08:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d0c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d14:	c7 04 24 64 4a 80 00 	movl   $0x804a64,(%esp)
  801d1b:	e8 81 00 00 00       	call   801da1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d20:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d24:	8b 45 10             	mov    0x10(%ebp),%eax
  801d27:	89 04 24             	mov    %eax,(%esp)
  801d2a:	e8 11 00 00 00       	call   801d40 <vcprintf>
	cprintf("\n");
  801d2f:	c7 04 24 31 46 80 00 	movl   $0x804631,(%esp)
  801d36:	e8 66 00 00 00       	call   801da1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d3b:	cc                   	int3   
  801d3c:	eb fd                	jmp    801d3b <_panic+0x53>
	...

00801d40 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801d49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d50:	00 00 00 
	b.cnt = 0;
  801d53:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d5a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d60:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d6b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d75:	c7 04 24 bb 1d 80 00 	movl   $0x801dbb,(%esp)
  801d7c:	e8 be 01 00 00       	call   801f3f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d81:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d91:	89 04 24             	mov    %eax,(%esp)
  801d94:	e8 27 0a 00 00       	call   8027c0 <sys_cputs>

	return b.cnt;
}
  801d99:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  801da7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  801daa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	89 04 24             	mov    %eax,(%esp)
  801db4:	e8 87 ff ff ff       	call   801d40 <vcprintf>
	va_end(ap);

	return cnt;
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 14             	sub    $0x14,%esp
  801dc2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801dc5:	8b 03                	mov    (%ebx),%eax
  801dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  801dca:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  801dce:	83 c0 01             	add    $0x1,%eax
  801dd1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801dd3:	3d ff 00 00 00       	cmp    $0xff,%eax
  801dd8:	75 19                	jne    801df3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801dda:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801de1:	00 
  801de2:	8d 43 08             	lea    0x8(%ebx),%eax
  801de5:	89 04 24             	mov    %eax,(%esp)
  801de8:	e8 d3 09 00 00       	call   8027c0 <sys_cputs>
		b->idx = 0;
  801ded:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801df3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801df7:	83 c4 14             	add    $0x14,%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
  801dfd:	00 00                	add    %al,(%eax)
	...

00801e00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	57                   	push   %edi
  801e04:	56                   	push   %esi
  801e05:	53                   	push   %ebx
  801e06:	83 ec 4c             	sub    $0x4c,%esp
  801e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e0c:	89 d6                	mov    %edx,%esi
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e17:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e20:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e23:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e2b:	39 d1                	cmp    %edx,%ecx
  801e2d:	72 07                	jb     801e36 <printnum+0x36>
  801e2f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e32:	39 d0                	cmp    %edx,%eax
  801e34:	77 69                	ja     801e9f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e36:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801e3a:	83 eb 01             	sub    $0x1,%ebx
  801e3d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e41:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e49:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801e4d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801e50:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801e53:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801e56:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e5a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e61:	00 
  801e62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e65:	89 04 24             	mov    %eax,(%esp)
  801e68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e6f:	e8 bc 23 00 00       	call   804230 <__udivdi3>
  801e74:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801e77:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801e7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e7e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e82:	89 04 24             	mov    %eax,(%esp)
  801e85:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e89:	89 f2                	mov    %esi,%edx
  801e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e8e:	e8 6d ff ff ff       	call   801e00 <printnum>
  801e93:	eb 11                	jmp    801ea6 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e95:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e99:	89 3c 24             	mov    %edi,(%esp)
  801e9c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e9f:	83 eb 01             	sub    $0x1,%ebx
  801ea2:	85 db                	test   %ebx,%ebx
  801ea4:	7f ef                	jg     801e95 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eaa:	8b 74 24 04          	mov    0x4(%esp),%esi
  801eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ebc:	00 
  801ebd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ec0:	89 14 24             	mov    %edx,(%esp)
  801ec3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801ec6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eca:	e8 91 24 00 00       	call   804360 <__umoddi3>
  801ecf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ed3:	0f be 80 87 4a 80 00 	movsbl 0x804a87(%eax),%eax
  801eda:	89 04 24             	mov    %eax,(%esp)
  801edd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801ee0:	83 c4 4c             	add    $0x4c,%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801eeb:	83 fa 01             	cmp    $0x1,%edx
  801eee:	7e 0e                	jle    801efe <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801ef0:	8b 10                	mov    (%eax),%edx
  801ef2:	8d 4a 08             	lea    0x8(%edx),%ecx
  801ef5:	89 08                	mov    %ecx,(%eax)
  801ef7:	8b 02                	mov    (%edx),%eax
  801ef9:	8b 52 04             	mov    0x4(%edx),%edx
  801efc:	eb 22                	jmp    801f20 <getuint+0x38>
	else if (lflag)
  801efe:	85 d2                	test   %edx,%edx
  801f00:	74 10                	je     801f12 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801f02:	8b 10                	mov    (%eax),%edx
  801f04:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f07:	89 08                	mov    %ecx,(%eax)
  801f09:	8b 02                	mov    (%edx),%eax
  801f0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f10:	eb 0e                	jmp    801f20 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801f12:	8b 10                	mov    (%eax),%edx
  801f14:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f17:	89 08                	mov    %ecx,(%eax)
  801f19:	8b 02                	mov    (%edx),%eax
  801f1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801f20:	5d                   	pop    %ebp
  801f21:	c3                   	ret    

00801f22 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801f28:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801f2c:	8b 10                	mov    (%eax),%edx
  801f2e:	3b 50 04             	cmp    0x4(%eax),%edx
  801f31:	73 0a                	jae    801f3d <sprintputch+0x1b>
		*b->buf++ = ch;
  801f33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f36:	88 0a                	mov    %cl,(%edx)
  801f38:	83 c2 01             	add    $0x1,%edx
  801f3b:	89 10                	mov    %edx,(%eax)
}
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	57                   	push   %edi
  801f43:	56                   	push   %esi
  801f44:	53                   	push   %ebx
  801f45:	83 ec 4c             	sub    $0x4c,%esp
  801f48:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801f51:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  801f58:	eb 11                	jmp    801f6b <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	0f 84 b6 03 00 00    	je     802318 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  801f62:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f66:	89 04 24             	mov    %eax,(%esp)
  801f69:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f6b:	0f b6 03             	movzbl (%ebx),%eax
  801f6e:	83 c3 01             	add    $0x1,%ebx
  801f71:	83 f8 25             	cmp    $0x25,%eax
  801f74:	75 e4                	jne    801f5a <vprintfmt+0x1b>
  801f76:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  801f7a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801f81:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  801f88:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801f8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f94:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801f97:	eb 06                	jmp    801f9f <vprintfmt+0x60>
  801f99:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  801f9d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f9f:	0f b6 0b             	movzbl (%ebx),%ecx
  801fa2:	0f b6 c1             	movzbl %cl,%eax
  801fa5:	8d 53 01             	lea    0x1(%ebx),%edx
  801fa8:	83 e9 23             	sub    $0x23,%ecx
  801fab:	80 f9 55             	cmp    $0x55,%cl
  801fae:	0f 87 47 03 00 00    	ja     8022fb <vprintfmt+0x3bc>
  801fb4:	0f b6 c9             	movzbl %cl,%ecx
  801fb7:	ff 24 8d c0 4b 80 00 	jmp    *0x804bc0(,%ecx,4)
  801fbe:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  801fc2:	eb d9                	jmp    801f9d <vprintfmt+0x5e>
  801fc4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801fcb:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801fd0:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801fd3:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801fd7:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  801fda:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801fdd:	83 fb 09             	cmp    $0x9,%ebx
  801fe0:	77 30                	ja     802012 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801fe2:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801fe5:	eb e9                	jmp    801fd0 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  801fea:	8d 48 04             	lea    0x4(%eax),%ecx
  801fed:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801ff0:	8b 00                	mov    (%eax),%eax
  801ff2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  801ff5:	eb 1e                	jmp    802015 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  801ff7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  802000:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  802004:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802007:	eb 94                	jmp    801f9d <vprintfmt+0x5e>
  802009:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  802010:	eb 8b                	jmp    801f9d <vprintfmt+0x5e>
  802012:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  802015:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802019:	79 82                	jns    801f9d <vprintfmt+0x5e>
  80201b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80201e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802021:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  802024:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  802027:	e9 71 ff ff ff       	jmp    801f9d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80202c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  802030:	e9 68 ff ff ff       	jmp    801f9d <vprintfmt+0x5e>
  802035:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802038:	8b 45 14             	mov    0x14(%ebp),%eax
  80203b:	8d 50 04             	lea    0x4(%eax),%edx
  80203e:	89 55 14             	mov    %edx,0x14(%ebp)
  802041:	89 74 24 04          	mov    %esi,0x4(%esp)
  802045:	8b 00                	mov    (%eax),%eax
  802047:	89 04 24             	mov    %eax,(%esp)
  80204a:	ff d7                	call   *%edi
  80204c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80204f:	e9 17 ff ff ff       	jmp    801f6b <vprintfmt+0x2c>
  802054:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802057:	8b 45 14             	mov    0x14(%ebp),%eax
  80205a:	8d 50 04             	lea    0x4(%eax),%edx
  80205d:	89 55 14             	mov    %edx,0x14(%ebp)
  802060:	8b 00                	mov    (%eax),%eax
  802062:	89 c2                	mov    %eax,%edx
  802064:	c1 fa 1f             	sar    $0x1f,%edx
  802067:	31 d0                	xor    %edx,%eax
  802069:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80206b:	83 f8 11             	cmp    $0x11,%eax
  80206e:	7f 0b                	jg     80207b <vprintfmt+0x13c>
  802070:	8b 14 85 20 4d 80 00 	mov    0x804d20(,%eax,4),%edx
  802077:	85 d2                	test   %edx,%edx
  802079:	75 20                	jne    80209b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80207b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207f:	c7 44 24 08 98 4a 80 	movl   $0x804a98,0x8(%esp)
  802086:	00 
  802087:	89 74 24 04          	mov    %esi,0x4(%esp)
  80208b:	89 3c 24             	mov    %edi,(%esp)
  80208e:	e8 0d 03 00 00       	call   8023a0 <printfmt>
  802093:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802096:	e9 d0 fe ff ff       	jmp    801f6b <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80209b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80209f:	c7 44 24 08 bf 44 80 	movl   $0x8044bf,0x8(%esp)
  8020a6:	00 
  8020a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ab:	89 3c 24             	mov    %edi,(%esp)
  8020ae:	e8 ed 02 00 00       	call   8023a0 <printfmt>
  8020b3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8020b6:	e9 b0 fe ff ff       	jmp    801f6b <vprintfmt+0x2c>
  8020bb:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8020be:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8020c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8020c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ca:	8d 50 04             	lea    0x4(%eax),%edx
  8020cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8020d0:	8b 18                	mov    (%eax),%ebx
  8020d2:	85 db                	test   %ebx,%ebx
  8020d4:	b8 a1 4a 80 00       	mov    $0x804aa1,%eax
  8020d9:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8020dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8020e0:	7e 76                	jle    802158 <vprintfmt+0x219>
  8020e2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8020e6:	74 7a                	je     802162 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8020e8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ec:	89 1c 24             	mov    %ebx,(%esp)
  8020ef:	e8 f4 02 00 00       	call   8023e8 <strnlen>
  8020f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8020f7:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8020f9:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8020fd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  802100:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  802103:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802105:	eb 0f                	jmp    802116 <vprintfmt+0x1d7>
					putch(padc, putdat);
  802107:	89 74 24 04          	mov    %esi,0x4(%esp)
  80210b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210e:	89 04 24             	mov    %eax,(%esp)
  802111:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802113:	83 eb 01             	sub    $0x1,%ebx
  802116:	85 db                	test   %ebx,%ebx
  802118:	7f ed                	jg     802107 <vprintfmt+0x1c8>
  80211a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80211d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802120:	89 7d e0             	mov    %edi,-0x20(%ebp)
  802123:	89 f7                	mov    %esi,%edi
  802125:	8b 75 cc             	mov    -0x34(%ebp),%esi
  802128:	eb 40                	jmp    80216a <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80212a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80212e:	74 18                	je     802148 <vprintfmt+0x209>
  802130:	8d 50 e0             	lea    -0x20(%eax),%edx
  802133:	83 fa 5e             	cmp    $0x5e,%edx
  802136:	76 10                	jbe    802148 <vprintfmt+0x209>
					putch('?', putdat);
  802138:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80213c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802143:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802146:	eb 0a                	jmp    802152 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802148:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80214c:	89 04 24             	mov    %eax,(%esp)
  80214f:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802152:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802156:	eb 12                	jmp    80216a <vprintfmt+0x22b>
  802158:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80215b:	89 f7                	mov    %esi,%edi
  80215d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  802160:	eb 08                	jmp    80216a <vprintfmt+0x22b>
  802162:	89 7d e0             	mov    %edi,-0x20(%ebp)
  802165:	89 f7                	mov    %esi,%edi
  802167:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80216a:	0f be 03             	movsbl (%ebx),%eax
  80216d:	83 c3 01             	add    $0x1,%ebx
  802170:	85 c0                	test   %eax,%eax
  802172:	74 25                	je     802199 <vprintfmt+0x25a>
  802174:	85 f6                	test   %esi,%esi
  802176:	78 b2                	js     80212a <vprintfmt+0x1eb>
  802178:	83 ee 01             	sub    $0x1,%esi
  80217b:	79 ad                	jns    80212a <vprintfmt+0x1eb>
  80217d:	89 fe                	mov    %edi,%esi
  80217f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  802182:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  802185:	eb 1a                	jmp    8021a1 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802187:	89 74 24 04          	mov    %esi,0x4(%esp)
  80218b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802192:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802194:	83 eb 01             	sub    $0x1,%ebx
  802197:	eb 08                	jmp    8021a1 <vprintfmt+0x262>
  802199:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80219c:	89 fe                	mov    %edi,%esi
  80219e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8021a1:	85 db                	test   %ebx,%ebx
  8021a3:	7f e2                	jg     802187 <vprintfmt+0x248>
  8021a5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8021a8:	e9 be fd ff ff       	jmp    801f6b <vprintfmt+0x2c>
  8021ad:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8021b0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8021b3:	83 f9 01             	cmp    $0x1,%ecx
  8021b6:	7e 16                	jle    8021ce <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8021b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021bb:	8d 50 08             	lea    0x8(%eax),%edx
  8021be:	89 55 14             	mov    %edx,0x14(%ebp)
  8021c1:	8b 10                	mov    (%eax),%edx
  8021c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8021c6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8021c9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8021cc:	eb 32                	jmp    802200 <vprintfmt+0x2c1>
	else if (lflag)
  8021ce:	85 c9                	test   %ecx,%ecx
  8021d0:	74 18                	je     8021ea <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8021d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d5:	8d 50 04             	lea    0x4(%eax),%edx
  8021d8:	89 55 14             	mov    %edx,0x14(%ebp)
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021e0:	89 c1                	mov    %eax,%ecx
  8021e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8021e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8021e8:	eb 16                	jmp    802200 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8021ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ed:	8d 50 04             	lea    0x4(%eax),%edx
  8021f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021f8:	89 c2                	mov    %eax,%edx
  8021fa:	c1 fa 1f             	sar    $0x1f,%edx
  8021fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802200:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802203:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802206:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80220b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80220f:	0f 89 a7 00 00 00    	jns    8022bc <vprintfmt+0x37d>
				putch('-', putdat);
  802215:	89 74 24 04          	mov    %esi,0x4(%esp)
  802219:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  802220:	ff d7                	call   *%edi
				num = -(long long) num;
  802222:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802225:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802228:	f7 d9                	neg    %ecx
  80222a:	83 d3 00             	adc    $0x0,%ebx
  80222d:	f7 db                	neg    %ebx
  80222f:	b8 0a 00 00 00       	mov    $0xa,%eax
  802234:	e9 83 00 00 00       	jmp    8022bc <vprintfmt+0x37d>
  802239:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80223c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80223f:	89 ca                	mov    %ecx,%edx
  802241:	8d 45 14             	lea    0x14(%ebp),%eax
  802244:	e8 9f fc ff ff       	call   801ee8 <getuint>
  802249:	89 c1                	mov    %eax,%ecx
  80224b:	89 d3                	mov    %edx,%ebx
  80224d:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  802252:	eb 68                	jmp    8022bc <vprintfmt+0x37d>
  802254:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802257:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  80225a:	89 ca                	mov    %ecx,%edx
  80225c:	8d 45 14             	lea    0x14(%ebp),%eax
  80225f:	e8 84 fc ff ff       	call   801ee8 <getuint>
  802264:	89 c1                	mov    %eax,%ecx
  802266:	89 d3                	mov    %edx,%ebx
  802268:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  80226d:	eb 4d                	jmp    8022bc <vprintfmt+0x37d>
  80226f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  802272:	89 74 24 04          	mov    %esi,0x4(%esp)
  802276:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80227d:	ff d7                	call   *%edi
			putch('x', putdat);
  80227f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802283:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80228a:	ff d7                	call   *%edi
			num = (unsigned long long)
  80228c:	8b 45 14             	mov    0x14(%ebp),%eax
  80228f:	8d 50 04             	lea    0x4(%eax),%edx
  802292:	89 55 14             	mov    %edx,0x14(%ebp)
  802295:	8b 08                	mov    (%eax),%ecx
  802297:	bb 00 00 00 00       	mov    $0x0,%ebx
  80229c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8022a1:	eb 19                	jmp    8022bc <vprintfmt+0x37d>
  8022a3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8022a6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8022a9:	89 ca                	mov    %ecx,%edx
  8022ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8022ae:	e8 35 fc ff ff       	call   801ee8 <getuint>
  8022b3:	89 c1                	mov    %eax,%ecx
  8022b5:	89 d3                	mov    %edx,%ebx
  8022b7:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8022bc:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8022c0:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022cf:	89 0c 24             	mov    %ecx,(%esp)
  8022d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022d6:	89 f2                	mov    %esi,%edx
  8022d8:	89 f8                	mov    %edi,%eax
  8022da:	e8 21 fb ff ff       	call   801e00 <printnum>
  8022df:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8022e2:	e9 84 fc ff ff       	jmp    801f6b <vprintfmt+0x2c>
  8022e7:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8022ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ee:	89 04 24             	mov    %eax,(%esp)
  8022f1:	ff d7                	call   *%edi
  8022f3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8022f6:	e9 70 fc ff ff       	jmp    801f6b <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8022fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ff:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802306:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802308:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80230b:	80 38 25             	cmpb   $0x25,(%eax)
  80230e:	0f 84 57 fc ff ff    	je     801f6b <vprintfmt+0x2c>
  802314:	89 c3                	mov    %eax,%ebx
  802316:	eb f0                	jmp    802308 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  802318:	83 c4 4c             	add    $0x4c,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5e                   	pop    %esi
  80231d:	5f                   	pop    %edi
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    

00802320 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 28             	sub    $0x28,%esp
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80232c:	85 c0                	test   %eax,%eax
  80232e:	74 04                	je     802334 <vsnprintf+0x14>
  802330:	85 d2                	test   %edx,%edx
  802332:	7f 07                	jg     80233b <vsnprintf+0x1b>
  802334:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802339:	eb 3b                	jmp    802376 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80233b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80233e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  802342:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80234c:	8b 45 14             	mov    0x14(%ebp),%eax
  80234f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802353:	8b 45 10             	mov    0x10(%ebp),%eax
  802356:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80235d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802361:	c7 04 24 22 1f 80 00 	movl   $0x801f22,(%esp)
  802368:	e8 d2 fb ff ff       	call   801f3f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80236d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802370:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80237e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  802381:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802385:	8b 45 10             	mov    0x10(%ebp),%eax
  802388:	89 44 24 08          	mov    %eax,0x8(%esp)
  80238c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 04 24             	mov    %eax,(%esp)
  802399:	e8 82 ff ff ff       	call   802320 <vsnprintf>
	va_end(ap);

	return rc;
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8023a6:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8023a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 79 fb ff ff       	call   801f3f <vprintfmt>
	va_end(ap);
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    
	...

008023d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8023db:	eb 03                	jmp    8023e0 <strlen+0x10>
		n++;
  8023dd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8023e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8023e4:	75 f7                	jne    8023dd <strlen+0xd>
		n++;
	return n;
}
  8023e6:	5d                   	pop    %ebp
  8023e7:	c3                   	ret    

008023e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	53                   	push   %ebx
  8023ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8023ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8023f7:	eb 03                	jmp    8023fc <strnlen+0x14>
		n++;
  8023f9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8023fc:	39 c1                	cmp    %eax,%ecx
  8023fe:	74 06                	je     802406 <strnlen+0x1e>
  802400:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  802404:	75 f3                	jne    8023f9 <strnlen+0x11>
		n++;
	return n;
}
  802406:	5b                   	pop    %ebx
  802407:	5d                   	pop    %ebp
  802408:	c3                   	ret    

00802409 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	53                   	push   %ebx
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802413:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802418:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80241c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80241f:	83 c2 01             	add    $0x1,%edx
  802422:	84 c9                	test   %cl,%cl
  802424:	75 f2                	jne    802418 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  802426:	5b                   	pop    %ebx
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    

00802429 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	53                   	push   %ebx
  80242d:	83 ec 08             	sub    $0x8,%esp
  802430:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802433:	89 1c 24             	mov    %ebx,(%esp)
  802436:	e8 95 ff ff ff       	call   8023d0 <strlen>
	strcpy(dst + len, src);
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802442:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  802445:	89 04 24             	mov    %eax,(%esp)
  802448:	e8 bc ff ff ff       	call   802409 <strcpy>
	return dst;
}
  80244d:	89 d8                	mov    %ebx,%eax
  80244f:	83 c4 08             	add    $0x8,%esp
  802452:	5b                   	pop    %ebx
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    

00802455 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	56                   	push   %esi
  802459:	53                   	push   %ebx
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802460:	8b 75 10             	mov    0x10(%ebp),%esi
  802463:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802468:	eb 0f                	jmp    802479 <strncpy+0x24>
		*dst++ = *src;
  80246a:	0f b6 19             	movzbl (%ecx),%ebx
  80246d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802470:	80 39 01             	cmpb   $0x1,(%ecx)
  802473:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802476:	83 c2 01             	add    $0x1,%edx
  802479:	39 f2                	cmp    %esi,%edx
  80247b:	72 ed                	jb     80246a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    

00802481 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	56                   	push   %esi
  802485:	53                   	push   %ebx
  802486:	8b 75 08             	mov    0x8(%ebp),%esi
  802489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80248c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80248f:	89 f0                	mov    %esi,%eax
  802491:	85 d2                	test   %edx,%edx
  802493:	75 0a                	jne    80249f <strlcpy+0x1e>
  802495:	eb 17                	jmp    8024ae <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802497:	88 18                	mov    %bl,(%eax)
  802499:	83 c0 01             	add    $0x1,%eax
  80249c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80249f:	83 ea 01             	sub    $0x1,%edx
  8024a2:	74 07                	je     8024ab <strlcpy+0x2a>
  8024a4:	0f b6 19             	movzbl (%ecx),%ebx
  8024a7:	84 db                	test   %bl,%bl
  8024a9:	75 ec                	jne    802497 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  8024ab:	c6 00 00             	movb   $0x0,(%eax)
  8024ae:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8024b0:	5b                   	pop    %ebx
  8024b1:	5e                   	pop    %esi
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8024bd:	eb 06                	jmp    8024c5 <strcmp+0x11>
		p++, q++;
  8024bf:	83 c1 01             	add    $0x1,%ecx
  8024c2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8024c5:	0f b6 01             	movzbl (%ecx),%eax
  8024c8:	84 c0                	test   %al,%al
  8024ca:	74 04                	je     8024d0 <strcmp+0x1c>
  8024cc:	3a 02                	cmp    (%edx),%al
  8024ce:	74 ef                	je     8024bf <strcmp+0xb>
  8024d0:	0f b6 c0             	movzbl %al,%eax
  8024d3:	0f b6 12             	movzbl (%edx),%edx
  8024d6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8024d8:	5d                   	pop    %ebp
  8024d9:	c3                   	ret    

008024da <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	53                   	push   %ebx
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8024e7:	eb 09                	jmp    8024f2 <strncmp+0x18>
		n--, p++, q++;
  8024e9:	83 ea 01             	sub    $0x1,%edx
  8024ec:	83 c0 01             	add    $0x1,%eax
  8024ef:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8024f2:	85 d2                	test   %edx,%edx
  8024f4:	75 07                	jne    8024fd <strncmp+0x23>
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	eb 13                	jmp    802510 <strncmp+0x36>
  8024fd:	0f b6 18             	movzbl (%eax),%ebx
  802500:	84 db                	test   %bl,%bl
  802502:	74 04                	je     802508 <strncmp+0x2e>
  802504:	3a 19                	cmp    (%ecx),%bl
  802506:	74 e1                	je     8024e9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802508:	0f b6 00             	movzbl (%eax),%eax
  80250b:	0f b6 11             	movzbl (%ecx),%edx
  80250e:	29 d0                	sub    %edx,%eax
}
  802510:	5b                   	pop    %ebx
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80251d:	eb 07                	jmp    802526 <strchr+0x13>
		if (*s == c)
  80251f:	38 ca                	cmp    %cl,%dl
  802521:	74 0f                	je     802532 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802523:	83 c0 01             	add    $0x1,%eax
  802526:	0f b6 10             	movzbl (%eax),%edx
  802529:	84 d2                	test   %dl,%dl
  80252b:	75 f2                	jne    80251f <strchr+0xc>
  80252d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    

00802534 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80253e:	eb 07                	jmp    802547 <strfind+0x13>
		if (*s == c)
  802540:	38 ca                	cmp    %cl,%dl
  802542:	74 0a                	je     80254e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802544:	83 c0 01             	add    $0x1,%eax
  802547:	0f b6 10             	movzbl (%eax),%edx
  80254a:	84 d2                	test   %dl,%dl
  80254c:	75 f2                	jne    802540 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    

00802550 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 0c             	sub    $0xc,%esp
  802556:	89 1c 24             	mov    %ebx,(%esp)
  802559:	89 74 24 04          	mov    %esi,0x4(%esp)
  80255d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802561:	8b 7d 08             	mov    0x8(%ebp),%edi
  802564:	8b 45 0c             	mov    0xc(%ebp),%eax
  802567:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80256a:	85 c9                	test   %ecx,%ecx
  80256c:	74 30                	je     80259e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80256e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802574:	75 25                	jne    80259b <memset+0x4b>
  802576:	f6 c1 03             	test   $0x3,%cl
  802579:	75 20                	jne    80259b <memset+0x4b>
		c &= 0xFF;
  80257b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80257e:	89 d3                	mov    %edx,%ebx
  802580:	c1 e3 08             	shl    $0x8,%ebx
  802583:	89 d6                	mov    %edx,%esi
  802585:	c1 e6 18             	shl    $0x18,%esi
  802588:	89 d0                	mov    %edx,%eax
  80258a:	c1 e0 10             	shl    $0x10,%eax
  80258d:	09 f0                	or     %esi,%eax
  80258f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  802591:	09 d8                	or     %ebx,%eax
  802593:	c1 e9 02             	shr    $0x2,%ecx
  802596:	fc                   	cld    
  802597:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802599:	eb 03                	jmp    80259e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80259b:	fc                   	cld    
  80259c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80259e:	89 f8                	mov    %edi,%eax
  8025a0:	8b 1c 24             	mov    (%esp),%ebx
  8025a3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025a7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025ab:	89 ec                	mov    %ebp,%esp
  8025ad:	5d                   	pop    %ebp
  8025ae:	c3                   	ret    

008025af <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 08             	sub    $0x8,%esp
  8025b5:	89 34 24             	mov    %esi,(%esp)
  8025b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  8025c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8025c5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8025c7:	39 c6                	cmp    %eax,%esi
  8025c9:	73 35                	jae    802600 <memmove+0x51>
  8025cb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8025ce:	39 d0                	cmp    %edx,%eax
  8025d0:	73 2e                	jae    802600 <memmove+0x51>
		s += n;
		d += n;
  8025d2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8025d4:	f6 c2 03             	test   $0x3,%dl
  8025d7:	75 1b                	jne    8025f4 <memmove+0x45>
  8025d9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8025df:	75 13                	jne    8025f4 <memmove+0x45>
  8025e1:	f6 c1 03             	test   $0x3,%cl
  8025e4:	75 0e                	jne    8025f4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8025e6:	83 ef 04             	sub    $0x4,%edi
  8025e9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8025ec:	c1 e9 02             	shr    $0x2,%ecx
  8025ef:	fd                   	std    
  8025f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8025f2:	eb 09                	jmp    8025fd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8025f4:	83 ef 01             	sub    $0x1,%edi
  8025f7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8025fa:	fd                   	std    
  8025fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8025fd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8025fe:	eb 20                	jmp    802620 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802600:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802606:	75 15                	jne    80261d <memmove+0x6e>
  802608:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80260e:	75 0d                	jne    80261d <memmove+0x6e>
  802610:	f6 c1 03             	test   $0x3,%cl
  802613:	75 08                	jne    80261d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  802615:	c1 e9 02             	shr    $0x2,%ecx
  802618:	fc                   	cld    
  802619:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80261b:	eb 03                	jmp    802620 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80261d:	fc                   	cld    
  80261e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802620:	8b 34 24             	mov    (%esp),%esi
  802623:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802627:	89 ec                	mov    %ebp,%esp
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    

0080262b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802631:	8b 45 10             	mov    0x10(%ebp),%eax
  802634:	89 44 24 08          	mov    %eax,0x8(%esp)
  802638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	89 04 24             	mov    %eax,(%esp)
  802645:	e8 65 ff ff ff       	call   8025af <memmove>
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	57                   	push   %edi
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	8b 7d 08             	mov    0x8(%ebp),%edi
  802655:	8b 75 0c             	mov    0xc(%ebp),%esi
  802658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80265b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802660:	eb 1c                	jmp    80267e <memcmp+0x32>
		if (*s1 != *s2)
  802662:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  802666:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  80266a:	83 c2 01             	add    $0x1,%edx
  80266d:	83 e9 01             	sub    $0x1,%ecx
  802670:	38 d8                	cmp    %bl,%al
  802672:	74 0a                	je     80267e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  802674:	0f b6 c0             	movzbl %al,%eax
  802677:	0f b6 db             	movzbl %bl,%ebx
  80267a:	29 d8                	sub    %ebx,%eax
  80267c:	eb 09                	jmp    802687 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80267e:	85 c9                	test   %ecx,%ecx
  802680:	75 e0                	jne    802662 <memcmp+0x16>
  802682:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  802687:	5b                   	pop    %ebx
  802688:	5e                   	pop    %esi
  802689:	5f                   	pop    %edi
  80268a:	5d                   	pop    %ebp
  80268b:	c3                   	ret    

0080268c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802695:	89 c2                	mov    %eax,%edx
  802697:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80269a:	eb 07                	jmp    8026a3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  80269c:	38 08                	cmp    %cl,(%eax)
  80269e:	74 07                	je     8026a7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8026a0:	83 c0 01             	add    $0x1,%eax
  8026a3:	39 d0                	cmp    %edx,%eax
  8026a5:	72 f5                	jb     80269c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8026a7:	5d                   	pop    %ebp
  8026a8:	c3                   	ret    

008026a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	57                   	push   %edi
  8026ad:	56                   	push   %esi
  8026ae:	53                   	push   %ebx
  8026af:	83 ec 04             	sub    $0x4,%esp
  8026b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026b8:	eb 03                	jmp    8026bd <strtol+0x14>
		s++;
  8026ba:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026bd:	0f b6 02             	movzbl (%edx),%eax
  8026c0:	3c 20                	cmp    $0x20,%al
  8026c2:	74 f6                	je     8026ba <strtol+0x11>
  8026c4:	3c 09                	cmp    $0x9,%al
  8026c6:	74 f2                	je     8026ba <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026c8:	3c 2b                	cmp    $0x2b,%al
  8026ca:	75 0c                	jne    8026d8 <strtol+0x2f>
		s++;
  8026cc:	8d 52 01             	lea    0x1(%edx),%edx
  8026cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026d6:	eb 15                	jmp    8026ed <strtol+0x44>
	else if (*s == '-')
  8026d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026df:	3c 2d                	cmp    $0x2d,%al
  8026e1:	75 0a                	jne    8026ed <strtol+0x44>
		s++, neg = 1;
  8026e3:	8d 52 01             	lea    0x1(%edx),%edx
  8026e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8026ed:	85 db                	test   %ebx,%ebx
  8026ef:	0f 94 c0             	sete   %al
  8026f2:	74 05                	je     8026f9 <strtol+0x50>
  8026f4:	83 fb 10             	cmp    $0x10,%ebx
  8026f7:	75 15                	jne    80270e <strtol+0x65>
  8026f9:	80 3a 30             	cmpb   $0x30,(%edx)
  8026fc:	75 10                	jne    80270e <strtol+0x65>
  8026fe:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802702:	75 0a                	jne    80270e <strtol+0x65>
		s += 2, base = 16;
  802704:	83 c2 02             	add    $0x2,%edx
  802707:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80270c:	eb 13                	jmp    802721 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80270e:	84 c0                	test   %al,%al
  802710:	74 0f                	je     802721 <strtol+0x78>
  802712:	bb 0a 00 00 00       	mov    $0xa,%ebx
  802717:	80 3a 30             	cmpb   $0x30,(%edx)
  80271a:	75 05                	jne    802721 <strtol+0x78>
		s++, base = 8;
  80271c:	83 c2 01             	add    $0x1,%edx
  80271f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
  802726:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802728:	0f b6 0a             	movzbl (%edx),%ecx
  80272b:	89 cf                	mov    %ecx,%edi
  80272d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  802730:	80 fb 09             	cmp    $0x9,%bl
  802733:	77 08                	ja     80273d <strtol+0x94>
			dig = *s - '0';
  802735:	0f be c9             	movsbl %cl,%ecx
  802738:	83 e9 30             	sub    $0x30,%ecx
  80273b:	eb 1e                	jmp    80275b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  80273d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  802740:	80 fb 19             	cmp    $0x19,%bl
  802743:	77 08                	ja     80274d <strtol+0xa4>
			dig = *s - 'a' + 10;
  802745:	0f be c9             	movsbl %cl,%ecx
  802748:	83 e9 57             	sub    $0x57,%ecx
  80274b:	eb 0e                	jmp    80275b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  80274d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  802750:	80 fb 19             	cmp    $0x19,%bl
  802753:	77 15                	ja     80276a <strtol+0xc1>
			dig = *s - 'A' + 10;
  802755:	0f be c9             	movsbl %cl,%ecx
  802758:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80275b:	39 f1                	cmp    %esi,%ecx
  80275d:	7d 0b                	jge    80276a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80275f:	83 c2 01             	add    $0x1,%edx
  802762:	0f af c6             	imul   %esi,%eax
  802765:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  802768:	eb be                	jmp    802728 <strtol+0x7f>
  80276a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80276c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802770:	74 05                	je     802777 <strtol+0xce>
		*endptr = (char *) s;
  802772:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802775:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  802777:	89 ca                	mov    %ecx,%edx
  802779:	f7 da                	neg    %edx
  80277b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277f:	0f 45 c2             	cmovne %edx,%eax
}
  802782:	83 c4 04             	add    $0x4,%esp
  802785:	5b                   	pop    %ebx
  802786:	5e                   	pop    %esi
  802787:	5f                   	pop    %edi
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    
	...

0080278c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	89 1c 24             	mov    %ebx,(%esp)
  802795:	89 74 24 04          	mov    %esi,0x4(%esp)
  802799:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80279d:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a7:	89 d1                	mov    %edx,%ecx
  8027a9:	89 d3                	mov    %edx,%ebx
  8027ab:	89 d7                	mov    %edx,%edi
  8027ad:	89 d6                	mov    %edx,%esi
  8027af:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8027b1:	8b 1c 24             	mov    (%esp),%ebx
  8027b4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8027b8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027bc:	89 ec                	mov    %ebp,%esp
  8027be:	5d                   	pop    %ebp
  8027bf:	c3                   	ret    

008027c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	89 1c 24             	mov    %ebx,(%esp)
  8027c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dc:	89 c3                	mov    %eax,%ebx
  8027de:	89 c7                	mov    %eax,%edi
  8027e0:	89 c6                	mov    %eax,%esi
  8027e2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8027e4:	8b 1c 24             	mov    (%esp),%ebx
  8027e7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8027eb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027ef:	89 ec                	mov    %ebp,%esp
  8027f1:	5d                   	pop    %ebp
  8027f2:	c3                   	ret    

008027f3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	89 1c 24             	mov    %ebx,(%esp)
  8027fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802800:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802804:	ba 00 00 00 00       	mov    $0x0,%edx
  802809:	b8 10 00 00 00       	mov    $0x10,%eax
  80280e:	89 d1                	mov    %edx,%ecx
  802810:	89 d3                	mov    %edx,%ebx
  802812:	89 d7                	mov    %edx,%edi
  802814:	89 d6                	mov    %edx,%esi
  802816:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802818:	8b 1c 24             	mov    (%esp),%ebx
  80281b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80281f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802823:	89 ec                	mov    %ebp,%esp
  802825:	5d                   	pop    %ebp
  802826:	c3                   	ret    

00802827 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	83 ec 38             	sub    $0x38,%esp
  80282d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802830:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802833:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802836:	bb 00 00 00 00       	mov    $0x0,%ebx
  80283b:	b8 0f 00 00 00       	mov    $0xf,%eax
  802840:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802843:	8b 55 08             	mov    0x8(%ebp),%edx
  802846:	89 df                	mov    %ebx,%edi
  802848:	89 de                	mov    %ebx,%esi
  80284a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80284c:	85 c0                	test   %eax,%eax
  80284e:	7e 28                	jle    802878 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802850:	89 44 24 10          	mov    %eax,0x10(%esp)
  802854:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80285b:	00 
  80285c:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802863:	00 
  802864:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80286b:	00 
  80286c:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802873:	e8 70 f4 ff ff       	call   801ce8 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  802878:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80287b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80287e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802881:	89 ec                	mov    %ebp,%esp
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    

00802885 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 38             	sub    $0x38,%esp
  80288b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80288e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802891:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802894:	bb 00 00 00 00       	mov    $0x0,%ebx
  802899:	b8 0e 00 00 00       	mov    $0xe,%eax
  80289e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a4:	89 df                	mov    %ebx,%edi
  8028a6:	89 de                	mov    %ebx,%esi
  8028a8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	7e 28                	jle    8028d6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028ae:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028b2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8028b9:	00 
  8028ba:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  8028c1:	00 
  8028c2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8028c9:	00 
  8028ca:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  8028d1:	e8 12 f4 ff ff       	call   801ce8 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8028d6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028d9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028dc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028df:	89 ec                	mov    %ebp,%esp
  8028e1:	5d                   	pop    %ebp
  8028e2:	c3                   	ret    

008028e3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 38             	sub    $0x38,%esp
  8028e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8028ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8028ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8028f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8028fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ff:	89 cb                	mov    %ecx,%ebx
  802901:	89 cf                	mov    %ecx,%edi
  802903:	89 ce                	mov    %ecx,%esi
  802905:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802907:	85 c0                	test   %eax,%eax
  802909:	7e 28                	jle    802933 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80290b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80290f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  802916:	00 
  802917:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  80291e:	00 
  80291f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802926:	00 
  802927:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  80292e:	e8 b5 f3 ff ff       	call   801ce8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802933:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802936:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802939:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80293c:	89 ec                	mov    %ebp,%esp
  80293e:	5d                   	pop    %ebp
  80293f:	c3                   	ret    

00802940 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	89 1c 24             	mov    %ebx,(%esp)
  802949:	89 74 24 04          	mov    %esi,0x4(%esp)
  80294d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802951:	be 00 00 00 00       	mov    $0x0,%esi
  802956:	b8 0c 00 00 00       	mov    $0xc,%eax
  80295b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80295e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802964:	8b 55 08             	mov    0x8(%ebp),%edx
  802967:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802969:	8b 1c 24             	mov    (%esp),%ebx
  80296c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802970:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802974:	89 ec                	mov    %ebp,%esp
  802976:	5d                   	pop    %ebp
  802977:	c3                   	ret    

00802978 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
  80297b:	83 ec 38             	sub    $0x38,%esp
  80297e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802981:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802984:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802987:	bb 00 00 00 00       	mov    $0x0,%ebx
  80298c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802991:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 df                	mov    %ebx,%edi
  802999:	89 de                	mov    %ebx,%esi
  80299b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80299d:	85 c0                	test   %eax,%eax
  80299f:	7e 28                	jle    8029c9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029a1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8029a5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8029ac:	00 
  8029ad:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  8029b4:	00 
  8029b5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029bc:	00 
  8029bd:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  8029c4:	e8 1f f3 ff ff       	call   801ce8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8029c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029cc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029d2:	89 ec                	mov    %ebp,%esp
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    

008029d6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 38             	sub    $0x38,%esp
  8029dc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8029df:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8029e2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029ea:	b8 09 00 00 00       	mov    $0x9,%eax
  8029ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f5:	89 df                	mov    %ebx,%edi
  8029f7:	89 de                	mov    %ebx,%esi
  8029f9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	7e 28                	jle    802a27 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a03:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  802a0a:	00 
  802a0b:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802a12:	00 
  802a13:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a1a:	00 
  802a1b:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802a22:	e8 c1 f2 ff ff       	call   801ce8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802a27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a30:	89 ec                	mov    %ebp,%esp
  802a32:	5d                   	pop    %ebp
  802a33:	c3                   	ret    

00802a34 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802a34:	55                   	push   %ebp
  802a35:	89 e5                	mov    %esp,%ebp
  802a37:	83 ec 38             	sub    $0x38,%esp
  802a3a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a3d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a40:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a43:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a48:	b8 08 00 00 00       	mov    $0x8,%eax
  802a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a50:	8b 55 08             	mov    0x8(%ebp),%edx
  802a53:	89 df                	mov    %ebx,%edi
  802a55:	89 de                	mov    %ebx,%esi
  802a57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	7e 28                	jle    802a85 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a61:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  802a68:	00 
  802a69:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802a70:	00 
  802a71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a78:	00 
  802a79:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802a80:	e8 63 f2 ff ff       	call   801ce8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802a85:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a88:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a8b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a8e:	89 ec                	mov    %ebp,%esp
  802a90:	5d                   	pop    %ebp
  802a91:	c3                   	ret    

00802a92 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
  802a95:	83 ec 38             	sub    $0x38,%esp
  802a98:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a9b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a9e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802aa6:	b8 06 00 00 00       	mov    $0x6,%eax
  802aab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aae:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab1:	89 df                	mov    %ebx,%edi
  802ab3:	89 de                	mov    %ebx,%esi
  802ab5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	7e 28                	jle    802ae3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802abb:	89 44 24 10          	mov    %eax,0x10(%esp)
  802abf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  802ac6:	00 
  802ac7:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802ace:	00 
  802acf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ad6:	00 
  802ad7:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802ade:	e8 05 f2 ff ff       	call   801ce8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802ae3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ae6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ae9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802aec:	89 ec                	mov    %ebp,%esp
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    

00802af0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	83 ec 38             	sub    $0x38,%esp
  802af6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802af9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802afc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aff:	b8 05 00 00 00       	mov    $0x5,%eax
  802b04:	8b 75 18             	mov    0x18(%ebp),%esi
  802b07:	8b 7d 14             	mov    0x14(%ebp),%edi
  802b0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b10:	8b 55 08             	mov    0x8(%ebp),%edx
  802b13:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802b15:	85 c0                	test   %eax,%eax
  802b17:	7e 28                	jle    802b41 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b19:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b1d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  802b24:	00 
  802b25:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802b2c:	00 
  802b2d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b34:	00 
  802b35:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802b3c:	e8 a7 f1 ff ff       	call   801ce8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802b41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b44:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b47:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b4a:	89 ec                	mov    %ebp,%esp
  802b4c:	5d                   	pop    %ebp
  802b4d:	c3                   	ret    

00802b4e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	83 ec 38             	sub    $0x38,%esp
  802b54:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b57:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b5d:	be 00 00 00 00       	mov    $0x0,%esi
  802b62:	b8 04 00 00 00       	mov    $0x4,%eax
  802b67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b70:	89 f7                	mov    %esi,%edi
  802b72:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802b74:	85 c0                	test   %eax,%eax
  802b76:	7e 28                	jle    802ba0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b78:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b7c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802b83:	00 
  802b84:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802b8b:	00 
  802b8c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b93:	00 
  802b94:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802b9b:	e8 48 f1 ff ff       	call   801ce8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802ba0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ba3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ba6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ba9:	89 ec                	mov    %ebp,%esp
  802bab:	5d                   	pop    %ebp
  802bac:	c3                   	ret    

00802bad <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  802bad:	55                   	push   %ebp
  802bae:	89 e5                	mov    %esp,%ebp
  802bb0:	83 ec 0c             	sub    $0xc,%esp
  802bb3:	89 1c 24             	mov    %ebx,(%esp)
  802bb6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bba:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc3:	b8 0b 00 00 00       	mov    $0xb,%eax
  802bc8:	89 d1                	mov    %edx,%ecx
  802bca:	89 d3                	mov    %edx,%ebx
  802bcc:	89 d7                	mov    %edx,%edi
  802bce:	89 d6                	mov    %edx,%esi
  802bd0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802bd2:	8b 1c 24             	mov    (%esp),%ebx
  802bd5:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bd9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bdd:	89 ec                	mov    %ebp,%esp
  802bdf:	5d                   	pop    %ebp
  802be0:	c3                   	ret    

00802be1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 0c             	sub    $0xc,%esp
  802be7:	89 1c 24             	mov    %ebx,(%esp)
  802bea:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bee:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf7:	b8 02 00 00 00       	mov    $0x2,%eax
  802bfc:	89 d1                	mov    %edx,%ecx
  802bfe:	89 d3                	mov    %edx,%ebx
  802c00:	89 d7                	mov    %edx,%edi
  802c02:	89 d6                	mov    %edx,%esi
  802c04:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802c06:	8b 1c 24             	mov    (%esp),%ebx
  802c09:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c0d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c11:	89 ec                	mov    %ebp,%esp
  802c13:	5d                   	pop    %ebp
  802c14:	c3                   	ret    

00802c15 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
  802c18:	83 ec 38             	sub    $0x38,%esp
  802c1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c24:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c29:	b8 03 00 00 00       	mov    $0x3,%eax
  802c2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c31:	89 cb                	mov    %ecx,%ebx
  802c33:	89 cf                	mov    %ecx,%edi
  802c35:	89 ce                	mov    %ecx,%esi
  802c37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	7e 28                	jle    802c65 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  802c3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c41:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  802c48:	00 
  802c49:	c7 44 24 08 87 4d 80 	movl   $0x804d87,0x8(%esp)
  802c50:	00 
  802c51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c58:	00 
  802c59:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  802c60:	e8 83 f0 ff ff       	call   801ce8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  802c65:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c68:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c6b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c6e:	89 ec                	mov    %ebp,%esp
  802c70:	5d                   	pop    %ebp
  802c71:	c3                   	ret    
	...

00802c74 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
  802c77:	53                   	push   %ebx
  802c78:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  802c7b:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  802c82:	75 5b                	jne    802cdf <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  802c84:	e8 58 ff ff ff       	call   802be1 <sys_getenvid>
  802c89:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  802c8b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c92:	00 
  802c93:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802c9a:	ee 
  802c9b:	89 04 24             	mov    %eax,(%esp)
  802c9e:	e8 ab fe ff ff       	call   802b4e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 28                	je     802ccf <set_pgfault_handler+0x5b>
  802ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  802cab:	c7 44 24 0c d9 4d 80 	movl   $0x804dd9,0xc(%esp)
  802cb2:	00 
  802cb3:	c7 44 24 08 b2 4d 80 	movl   $0x804db2,0x8(%esp)
  802cba:	00 
  802cbb:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802cc2:	00 
  802cc3:	c7 04 24 cb 4d 80 00 	movl   $0x804dcb,(%esp)
  802cca:	e8 19 f0 ff ff       	call   801ce8 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802ccf:	c7 44 24 04 f0 2c 80 	movl   $0x802cf0,0x4(%esp)
  802cd6:	00 
  802cd7:	89 1c 24             	mov    %ebx,(%esp)
  802cda:	e8 99 fc ff ff       	call   802978 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	a3 14 a0 80 00       	mov    %eax,0x80a014
	
}
  802ce7:	83 c4 24             	add    $0x24,%esp
  802cea:	5b                   	pop    %ebx
  802ceb:	5d                   	pop    %ebp
  802cec:	c3                   	ret    
  802ced:	00 00                	add    %al,(%eax)
	...

00802cf0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802cf0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802cf1:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802cf6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802cf8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  802cfb:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  802cfe:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  802d02:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  802d06:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  802d09:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  802d0c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  802d10:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  802d11:	83 c4 04             	add    $0x4,%esp
	popfl ;
  802d14:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802d15:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802d16:	c3                   	ret    
	...

00802d18 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d1e:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802d23:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d26:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802d2c:	8b 12                	mov    (%edx),%edx
  802d2e:	39 ca                	cmp    %ecx,%edx
  802d30:	75 0c                	jne    802d3e <ipc_find_env+0x26>
			return envs[i].env_id;
  802d32:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d35:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	eb 0e                	jmp    802d4c <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d3e:	83 c0 01             	add    $0x1,%eax
  802d41:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d46:	75 db                	jne    802d23 <ipc_find_env+0xb>
  802d48:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802d4c:	5d                   	pop    %ebp
  802d4d:	c3                   	ret    

00802d4e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
  802d51:	57                   	push   %edi
  802d52:	56                   	push   %esi
  802d53:	53                   	push   %ebx
  802d54:	83 ec 2c             	sub    $0x2c,%esp
  802d57:	8b 75 08             	mov    0x8(%ebp),%esi
  802d5a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802d60:	85 db                	test   %ebx,%ebx
  802d62:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d67:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  802d6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d75:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d79:	89 34 24             	mov    %esi,(%esp)
  802d7c:	e8 bf fb ff ff       	call   802940 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802d81:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d84:	74 e4                	je     802d6a <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 28                	je     802db2 <ipc_send+0x64>
  802d8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d8e:	c7 44 24 0c 0a 4e 80 	movl   $0x804e0a,0xc(%esp)
  802d95:	00 
  802d96:	c7 44 24 08 ed 4d 80 	movl   $0x804ded,0x8(%esp)
  802d9d:	00 
  802d9e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802da5:	00 
  802da6:	c7 04 24 00 4e 80 00 	movl   $0x804e00,(%esp)
  802dad:	e8 36 ef ff ff       	call   801ce8 <_panic>
	//if(!ret) sys_yield();
}
  802db2:	83 c4 2c             	add    $0x2c,%esp
  802db5:	5b                   	pop    %ebx
  802db6:	5e                   	pop    %esi
  802db7:	5f                   	pop    %edi
  802db8:	5d                   	pop    %ebp
  802db9:	c3                   	ret    

00802dba <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 28             	sub    $0x28,%esp
  802dc0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802dc3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802dc6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802dc9:	8b 75 08             	mov    0x8(%ebp),%esi
  802dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcf:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802dd9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802ddc:	89 04 24             	mov    %eax,(%esp)
  802ddf:	e8 ff fa ff ff       	call   8028e3 <sys_ipc_recv>
  802de4:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802de6:	e8 f6 fd ff ff       	call   802be1 <sys_getenvid>
  802deb:	25 ff 03 00 00       	and    $0x3ff,%eax
  802df0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802df3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802df8:	a3 10 a0 80 00       	mov    %eax,0x80a010
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802dfd:	85 f6                	test   %esi,%esi
  802dff:	74 0e                	je     802e0f <ipc_recv+0x55>
  802e01:	ba 00 00 00 00       	mov    $0x0,%edx
  802e06:	85 db                	test   %ebx,%ebx
  802e08:	75 03                	jne    802e0d <ipc_recv+0x53>
  802e0a:	8b 50 74             	mov    0x74(%eax),%edx
  802e0d:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802e0f:	85 ff                	test   %edi,%edi
  802e11:	74 13                	je     802e26 <ipc_recv+0x6c>
  802e13:	b8 00 00 00 00       	mov    $0x0,%eax
  802e18:	85 db                	test   %ebx,%ebx
  802e1a:	75 08                	jne    802e24 <ipc_recv+0x6a>
  802e1c:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802e21:	8b 40 78             	mov    0x78(%eax),%eax
  802e24:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802e26:	85 db                	test   %ebx,%ebx
  802e28:	75 08                	jne    802e32 <ipc_recv+0x78>
  802e2a:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802e2f:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802e32:	89 d8                	mov    %ebx,%eax
  802e34:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802e37:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802e3a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802e3d:	89 ec                	mov    %ebp,%esp
  802e3f:	5d                   	pop    %ebp
  802e40:	c3                   	ret    
  802e41:	00 00                	add    %al,(%eax)
	...

00802e44 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e44:	55                   	push   %ebp
  802e45:	89 e5                	mov    %esp,%ebp
  802e47:	56                   	push   %esi
  802e48:	53                   	push   %ebx
  802e49:	83 ec 10             	sub    $0x10,%esp
  802e4c:	89 c3                	mov    %eax,%ebx
  802e4e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  802e50:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802e57:	75 11                	jne    802e6a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802e60:	e8 b3 fe ff ff       	call   802d18 <ipc_find_env>
  802e65:	a3 00 a0 80 00       	mov    %eax,0x80a000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  802e6a:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802e6f:	8b 40 48             	mov    0x48(%eax),%eax
  802e72:	8b 15 00 b0 80 00    	mov    0x80b000,%edx
  802e78:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802e7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e84:	c7 04 24 13 4e 80 00 	movl   $0x804e13,(%esp)
  802e8b:	e8 11 ef ff ff       	call   801da1 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e90:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802e97:	00 
  802e98:	c7 44 24 08 00 b0 80 	movl   $0x80b000,0x8(%esp)
  802e9f:	00 
  802ea0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ea4:	a1 00 a0 80 00       	mov    0x80a000,%eax
  802ea9:	89 04 24             	mov    %eax,(%esp)
  802eac:	e8 9d fe ff ff       	call   802d4e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802eb1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802eb8:	00 
  802eb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ebd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec4:	e8 f1 fe ff ff       	call   802dba <ipc_recv>
}
  802ec9:	83 c4 10             	add    $0x10,%esp
  802ecc:	5b                   	pop    %ebx
  802ecd:	5e                   	pop    %esi
  802ece:	5d                   	pop    %ebp
  802ecf:	c3                   	ret    

00802ed0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
  802ed3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 40 0c             	mov    0xc(%eax),%eax
  802edc:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee4:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ee9:	ba 00 00 00 00       	mov    $0x0,%edx
  802eee:	b8 02 00 00 00       	mov    $0x2,%eax
  802ef3:	e8 4c ff ff ff       	call   802e44 <fsipc>
}
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
  802efd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802f0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802f10:	b8 06 00 00 00       	mov    $0x6,%eax
  802f15:	e8 2a ff ff ff       	call   802e44 <fsipc>
}
  802f1a:	c9                   	leave  
  802f1b:	c3                   	ret    

00802f1c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802f1c:	55                   	push   %ebp
  802f1d:	89 e5                	mov    %esp,%ebp
  802f1f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f22:	ba 00 00 00 00       	mov    $0x0,%edx
  802f27:	b8 08 00 00 00       	mov    $0x8,%eax
  802f2c:	e8 13 ff ff ff       	call   802e44 <fsipc>
}
  802f31:	c9                   	leave  
  802f32:	c3                   	ret    

00802f33 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f33:	55                   	push   %ebp
  802f34:	89 e5                	mov    %esp,%ebp
  802f36:	53                   	push   %ebx
  802f37:	83 ec 14             	sub    $0x14,%esp
  802f3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 40 0c             	mov    0xc(%eax),%eax
  802f43:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f48:	ba 00 00 00 00       	mov    $0x0,%edx
  802f4d:	b8 05 00 00 00       	mov    $0x5,%eax
  802f52:	e8 ed fe ff ff       	call   802e44 <fsipc>
  802f57:	85 c0                	test   %eax,%eax
  802f59:	78 2b                	js     802f86 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f5b:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  802f62:	00 
  802f63:	89 1c 24             	mov    %ebx,(%esp)
  802f66:	e8 9e f4 ff ff       	call   802409 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802f6b:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802f70:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f76:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802f7b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802f81:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  802f86:	83 c4 14             	add    $0x14,%esp
  802f89:	5b                   	pop    %ebx
  802f8a:	5d                   	pop    %ebp
  802f8b:	c3                   	ret    

00802f8c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f8c:	55                   	push   %ebp
  802f8d:	89 e5                	mov    %esp,%ebp
  802f8f:	53                   	push   %ebx
  802f90:	83 ec 14             	sub    $0x14,%esp
  802f93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9c:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  802fa1:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004

	assert(n<=PGSIZE);
  802fa7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802fad:	76 24                	jbe    802fd3 <devfile_write+0x47>
  802faf:	c7 44 24 0c 29 4e 80 	movl   $0x804e29,0xc(%esp)
  802fb6:	00 
  802fb7:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  802fbe:	00 
  802fbf:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  802fc6:	00 
  802fc7:	c7 04 24 33 4e 80 00 	movl   $0x804e33,(%esp)
  802fce:	e8 15 ed ff ff       	call   801ce8 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  802fd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fda:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fde:	c7 04 24 08 b0 80 00 	movl   $0x80b008,(%esp)
  802fe5:	e8 c5 f5 ff ff       	call   8025af <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  802fea:	ba 00 00 00 00       	mov    $0x0,%edx
  802fef:	b8 04 00 00 00       	mov    $0x4,%eax
  802ff4:	e8 4b fe ff ff       	call   802e44 <fsipc>
	if(ret<0) return ret;
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	78 53                	js     803050 <devfile_write+0xc4>
	
	assert(ret <= n);
  802ffd:	39 c3                	cmp    %eax,%ebx
  802fff:	73 24                	jae    803025 <devfile_write+0x99>
  803001:	c7 44 24 0c 3e 4e 80 	movl   $0x804e3e,0xc(%esp)
  803008:	00 
  803009:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  803010:	00 
  803011:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  803018:	00 
  803019:	c7 04 24 33 4e 80 00 	movl   $0x804e33,(%esp)
  803020:	e8 c3 ec ff ff       	call   801ce8 <_panic>
	assert(ret <= PGSIZE);
  803025:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80302a:	7e 24                	jle    803050 <devfile_write+0xc4>
  80302c:	c7 44 24 0c 47 4e 80 	movl   $0x804e47,0xc(%esp)
  803033:	00 
  803034:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80303b:	00 
  80303c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  803043:	00 
  803044:	c7 04 24 33 4e 80 00 	movl   $0x804e33,(%esp)
  80304b:	e8 98 ec ff ff       	call   801ce8 <_panic>
	return ret;
}
  803050:	83 c4 14             	add    $0x14,%esp
  803053:	5b                   	pop    %ebx
  803054:	5d                   	pop    %ebp
  803055:	c3                   	ret    

00803056 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803056:	55                   	push   %ebp
  803057:	89 e5                	mov    %esp,%ebp
  803059:	56                   	push   %esi
  80305a:	53                   	push   %ebx
  80305b:	83 ec 10             	sub    $0x10,%esp
  80305e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	8b 40 0c             	mov    0xc(%eax),%eax
  803067:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  80306c:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803072:	ba 00 00 00 00       	mov    $0x0,%edx
  803077:	b8 03 00 00 00       	mov    $0x3,%eax
  80307c:	e8 c3 fd ff ff       	call   802e44 <fsipc>
  803081:	89 c3                	mov    %eax,%ebx
  803083:	85 c0                	test   %eax,%eax
  803085:	78 6b                	js     8030f2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  803087:	39 de                	cmp    %ebx,%esi
  803089:	73 24                	jae    8030af <devfile_read+0x59>
  80308b:	c7 44 24 0c 55 4e 80 	movl   $0x804e55,0xc(%esp)
  803092:	00 
  803093:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  80309a:	00 
  80309b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8030a2:	00 
  8030a3:	c7 04 24 33 4e 80 00 	movl   $0x804e33,(%esp)
  8030aa:	e8 39 ec ff ff       	call   801ce8 <_panic>
	assert(r <= PGSIZE);
  8030af:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8030b5:	7e 24                	jle    8030db <devfile_read+0x85>
  8030b7:	c7 44 24 0c 5c 4e 80 	movl   $0x804e5c,0xc(%esp)
  8030be:	00 
  8030bf:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  8030c6:	00 
  8030c7:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8030ce:	00 
  8030cf:	c7 04 24 33 4e 80 00 	movl   $0x804e33,(%esp)
  8030d6:	e8 0d ec ff ff       	call   801ce8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8030db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030df:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8030e6:	00 
  8030e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ea:	89 04 24             	mov    %eax,(%esp)
  8030ed:	e8 bd f4 ff ff       	call   8025af <memmove>
	return r;
}
  8030f2:	89 d8                	mov    %ebx,%eax
  8030f4:	83 c4 10             	add    $0x10,%esp
  8030f7:	5b                   	pop    %ebx
  8030f8:	5e                   	pop    %esi
  8030f9:	5d                   	pop    %ebp
  8030fa:	c3                   	ret    

008030fb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
  8030fe:	83 ec 28             	sub    $0x28,%esp
  803101:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803104:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803107:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80310a:	89 34 24             	mov    %esi,(%esp)
  80310d:	e8 be f2 ff ff       	call   8023d0 <strlen>
  803112:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803117:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80311c:	7f 5e                	jg     80317c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80311e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803121:	89 04 24             	mov    %eax,(%esp)
  803124:	e8 ca 00 00 00       	call   8031f3 <fd_alloc>
  803129:	89 c3                	mov    %eax,%ebx
  80312b:	85 c0                	test   %eax,%eax
  80312d:	78 4d                	js     80317c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80312f:	89 74 24 04          	mov    %esi,0x4(%esp)
  803133:	c7 04 24 00 b0 80 00 	movl   $0x80b000,(%esp)
  80313a:	e8 ca f2 ff ff       	call   802409 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	a3 00 b4 80 00       	mov    %eax,0x80b400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314a:	b8 01 00 00 00       	mov    $0x1,%eax
  80314f:	e8 f0 fc ff ff       	call   802e44 <fsipc>
  803154:	89 c3                	mov    %eax,%ebx
  803156:	85 c0                	test   %eax,%eax
  803158:	79 15                	jns    80316f <open+0x74>
		fd_close(fd, 0);
  80315a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803161:	00 
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	89 04 24             	mov    %eax,(%esp)
  803168:	e8 0b 04 00 00       	call   803578 <fd_close>
		return r;
  80316d:	eb 0d                	jmp    80317c <open+0x81>
	}

	return fd2num(fd);
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	89 04 24             	mov    %eax,(%esp)
  803175:	e8 4e 00 00 00       	call   8031c8 <fd2num>
  80317a:	89 c3                	mov    %eax,%ebx
}
  80317c:	89 d8                	mov    %ebx,%eax
  80317e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803181:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803184:	89 ec                	mov    %ebp,%esp
  803186:	5d                   	pop    %ebp
  803187:	c3                   	ret    

00803188 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	89 c2                	mov    %eax,%edx
  803190:	c1 ea 16             	shr    $0x16,%edx
  803193:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80319a:	f6 c2 01             	test   $0x1,%dl
  80319d:	74 20                	je     8031bf <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  80319f:	c1 e8 0c             	shr    $0xc,%eax
  8031a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8031a9:	a8 01                	test   $0x1,%al
  8031ab:	74 12                	je     8031bf <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8031ad:	c1 e8 0c             	shr    $0xc,%eax
  8031b0:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8031b5:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  8031ba:	0f b7 c0             	movzwl %ax,%eax
  8031bd:	eb 05                	jmp    8031c4 <pageref+0x3c>
  8031bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c4:	5d                   	pop    %ebp
  8031c5:	c3                   	ret    
	...

008031c8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	05 00 00 00 30       	add    $0x30000000,%eax
  8031d3:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8031d6:	5d                   	pop    %ebp
  8031d7:	c3                   	ret    

008031d8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8031d8:	55                   	push   %ebp
  8031d9:	89 e5                	mov    %esp,%ebp
  8031db:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	89 04 24             	mov    %eax,(%esp)
  8031e4:	e8 df ff ff ff       	call   8031c8 <fd2num>
  8031e9:	05 20 00 0d 00       	add    $0xd0020,%eax
  8031ee:	c1 e0 0c             	shl    $0xc,%eax
}
  8031f1:	c9                   	leave  
  8031f2:	c3                   	ret    

008031f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8031f3:	55                   	push   %ebp
  8031f4:	89 e5                	mov    %esp,%ebp
  8031f6:	57                   	push   %edi
  8031f7:	56                   	push   %esi
  8031f8:	53                   	push   %ebx
  8031f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8031fc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  803201:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  803206:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80320b:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80320d:	89 c2                	mov    %eax,%edx
  80320f:	c1 ea 16             	shr    $0x16,%edx
  803212:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  803215:	f6 c2 01             	test   $0x1,%dl
  803218:	74 0d                	je     803227 <fd_alloc+0x34>
  80321a:	89 c2                	mov    %eax,%edx
  80321c:	c1 ea 0c             	shr    $0xc,%edx
  80321f:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  803222:	f6 c2 01             	test   $0x1,%dl
  803225:	75 09                	jne    803230 <fd_alloc+0x3d>
			*fd_store = fd;
  803227:	89 37                	mov    %esi,(%edi)
  803229:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80322e:	eb 17                	jmp    803247 <fd_alloc+0x54>
  803230:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803235:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80323a:	75 cf                	jne    80320b <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80323c:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  803242:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  803247:	5b                   	pop    %ebx
  803248:	5e                   	pop    %esi
  803249:	5f                   	pop    %edi
  80324a:	5d                   	pop    %ebp
  80324b:	c3                   	ret    

0080324c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80324c:	55                   	push   %ebp
  80324d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	83 f8 1f             	cmp    $0x1f,%eax
  803255:	77 36                	ja     80328d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  803257:	05 00 00 0d 00       	add    $0xd0000,%eax
  80325c:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80325f:	89 c2                	mov    %eax,%edx
  803261:	c1 ea 16             	shr    $0x16,%edx
  803264:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80326b:	f6 c2 01             	test   $0x1,%dl
  80326e:	74 1d                	je     80328d <fd_lookup+0x41>
  803270:	89 c2                	mov    %eax,%edx
  803272:	c1 ea 0c             	shr    $0xc,%edx
  803275:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80327c:	f6 c2 01             	test   $0x1,%dl
  80327f:	74 0c                	je     80328d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  803281:	8b 55 0c             	mov    0xc(%ebp),%edx
  803284:	89 02                	mov    %eax,(%edx)
  803286:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80328b:	eb 05                	jmp    803292 <fd_lookup+0x46>
  80328d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803292:	5d                   	pop    %ebp
  803293:	c3                   	ret    

00803294 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  803294:	55                   	push   %ebp
  803295:	89 e5                	mov    %esp,%ebp
  803297:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80329a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80329d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	89 04 24             	mov    %eax,(%esp)
  8032a7:	e8 a0 ff ff ff       	call   80324c <fd_lookup>
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	78 0e                	js     8032be <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8032b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b6:	89 50 04             	mov    %edx,0x4(%eax)
  8032b9:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8032be:	c9                   	leave  
  8032bf:	c3                   	ret    

008032c0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	56                   	push   %esi
  8032c4:	53                   	push   %ebx
  8032c5:	83 ec 10             	sub    $0x10,%esp
  8032c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8032ce:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8032d3:	be e8 4e 80 00       	mov    $0x804ee8,%esi
  8032d8:	eb 10                	jmp    8032ea <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8032da:	39 08                	cmp    %ecx,(%eax)
  8032dc:	75 09                	jne    8032e7 <dev_lookup+0x27>
			*dev = devtab[i];
  8032de:	89 03                	mov    %eax,(%ebx)
  8032e0:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8032e5:	eb 31                	jmp    803318 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8032e7:	83 c2 01             	add    $0x1,%edx
  8032ea:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	75 e9                	jne    8032da <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8032f1:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8032f6:	8b 40 48             	mov    0x48(%eax),%eax
  8032f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803301:	c7 04 24 68 4e 80 00 	movl   $0x804e68,(%esp)
  803308:	e8 94 ea ff ff       	call   801da1 <cprintf>
	*dev = 0;
  80330d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803313:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  803318:	83 c4 10             	add    $0x10,%esp
  80331b:	5b                   	pop    %ebx
  80331c:	5e                   	pop    %esi
  80331d:	5d                   	pop    %ebp
  80331e:	c3                   	ret    

0080331f <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
  803322:	53                   	push   %ebx
  803323:	83 ec 24             	sub    $0x24,%esp
  803326:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803329:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80332c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	89 04 24             	mov    %eax,(%esp)
  803336:	e8 11 ff ff ff       	call   80324c <fd_lookup>
  80333b:	85 c0                	test   %eax,%eax
  80333d:	78 53                	js     803392 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80333f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803342:	89 44 24 04          	mov    %eax,0x4(%esp)
  803346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	89 04 24             	mov    %eax,(%esp)
  80334e:	e8 6d ff ff ff       	call   8032c0 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803353:	85 c0                	test   %eax,%eax
  803355:	78 3b                	js     803392 <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  803357:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335f:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  803363:	74 2d                	je     803392 <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803365:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  803368:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80336f:	00 00 00 
	stat->st_isdir = 0;
  803372:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803379:	00 00 00 
	stat->st_dev = dev;
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338c:	89 14 24             	mov    %edx,(%esp)
  80338f:	ff 50 14             	call   *0x14(%eax)
}
  803392:	83 c4 24             	add    $0x24,%esp
  803395:	5b                   	pop    %ebx
  803396:	5d                   	pop    %ebp
  803397:	c3                   	ret    

00803398 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
  80339b:	53                   	push   %ebx
  80339c:	83 ec 24             	sub    $0x24,%esp
  80339f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a9:	89 1c 24             	mov    %ebx,(%esp)
  8033ac:	e8 9b fe ff ff       	call   80324c <fd_lookup>
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	78 5f                	js     803414 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	89 04 24             	mov    %eax,(%esp)
  8033c4:	e8 f7 fe ff ff       	call   8032c0 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	78 47                	js     803414 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8033cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d0:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8033d4:	75 23                	jne    8033f9 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8033d6:	a1 10 a0 80 00       	mov    0x80a010,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8033db:	8b 40 48             	mov    0x48(%eax),%eax
  8033de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033e6:	c7 04 24 88 4e 80 00 	movl   $0x804e88,(%esp)
  8033ed:	e8 af e9 ff ff       	call   801da1 <cprintf>
  8033f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8033f7:	eb 1b                	jmp    803414 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 48 18             	mov    0x18(%eax),%ecx
  8033ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803404:	85 c9                	test   %ecx,%ecx
  803406:	74 0c                	je     803414 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80340f:	89 14 24             	mov    %edx,(%esp)
  803412:	ff d1                	call   *%ecx
}
  803414:	83 c4 24             	add    $0x24,%esp
  803417:	5b                   	pop    %ebx
  803418:	5d                   	pop    %ebp
  803419:	c3                   	ret    

0080341a <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80341a:	55                   	push   %ebp
  80341b:	89 e5                	mov    %esp,%ebp
  80341d:	53                   	push   %ebx
  80341e:	83 ec 24             	sub    $0x24,%esp
  803421:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80342b:	89 1c 24             	mov    %ebx,(%esp)
  80342e:	e8 19 fe ff ff       	call   80324c <fd_lookup>
  803433:	85 c0                	test   %eax,%eax
  803435:	78 66                	js     80349d <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803437:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80343a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	89 04 24             	mov    %eax,(%esp)
  803446:	e8 75 fe ff ff       	call   8032c0 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80344b:	85 c0                	test   %eax,%eax
  80344d:	78 4e                	js     80349d <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80344f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803452:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  803456:	75 23                	jne    80347b <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803458:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80345d:	8b 40 48             	mov    0x48(%eax),%eax
  803460:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803464:	89 44 24 04          	mov    %eax,0x4(%esp)
  803468:	c7 04 24 ac 4e 80 00 	movl   $0x804eac,(%esp)
  80346f:	e8 2d e9 ff ff       	call   801da1 <cprintf>
  803474:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  803479:	eb 22                	jmp    80349d <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	8b 48 0c             	mov    0xc(%eax),%ecx
  803481:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803486:	85 c9                	test   %ecx,%ecx
  803488:	74 13                	je     80349d <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80348a:	8b 45 10             	mov    0x10(%ebp),%eax
  80348d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803491:	8b 45 0c             	mov    0xc(%ebp),%eax
  803494:	89 44 24 04          	mov    %eax,0x4(%esp)
  803498:	89 14 24             	mov    %edx,(%esp)
  80349b:	ff d1                	call   *%ecx
}
  80349d:	83 c4 24             	add    $0x24,%esp
  8034a0:	5b                   	pop    %ebx
  8034a1:	5d                   	pop    %ebp
  8034a2:	c3                   	ret    

008034a3 <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8034a3:	55                   	push   %ebp
  8034a4:	89 e5                	mov    %esp,%ebp
  8034a6:	53                   	push   %ebx
  8034a7:	83 ec 24             	sub    $0x24,%esp
  8034aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8034b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034b4:	89 1c 24             	mov    %ebx,(%esp)
  8034b7:	e8 90 fd ff ff       	call   80324c <fd_lookup>
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	78 6b                	js     80352b <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8034c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8034c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	89 04 24             	mov    %eax,(%esp)
  8034cf:	e8 ec fd ff ff       	call   8032c0 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	78 53                	js     80352b <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8034d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034db:	8b 42 08             	mov    0x8(%edx),%eax
  8034de:	83 e0 03             	and    $0x3,%eax
  8034e1:	83 f8 01             	cmp    $0x1,%eax
  8034e4:	75 23                	jne    803509 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8034e6:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8034eb:	8b 40 48             	mov    0x48(%eax),%eax
  8034ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f6:	c7 04 24 c9 4e 80 00 	movl   $0x804ec9,(%esp)
  8034fd:	e8 9f e8 ff ff       	call   801da1 <cprintf>
  803502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  803507:	eb 22                	jmp    80352b <read+0x88>
	}
	if (!dev->dev_read)
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	8b 48 08             	mov    0x8(%eax),%ecx
  80350f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803514:	85 c9                	test   %ecx,%ecx
  803516:	74 13                	je     80352b <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  803518:	8b 45 10             	mov    0x10(%ebp),%eax
  80351b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80351f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803522:	89 44 24 04          	mov    %eax,0x4(%esp)
  803526:	89 14 24             	mov    %edx,(%esp)
  803529:	ff d1                	call   *%ecx
}
  80352b:	83 c4 24             	add    $0x24,%esp
  80352e:	5b                   	pop    %ebx
  80352f:	5d                   	pop    %ebp
  803530:	c3                   	ret    

00803531 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803531:	55                   	push   %ebp
  803532:	89 e5                	mov    %esp,%ebp
  803534:	57                   	push   %edi
  803535:	56                   	push   %esi
  803536:	53                   	push   %ebx
  803537:	83 ec 1c             	sub    $0x1c,%esp
  80353a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80353d:	8b 75 10             	mov    0x10(%ebp),%esi
  803540:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803545:	eb 21                	jmp    803568 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803547:	89 f2                	mov    %esi,%edx
  803549:	29 c2                	sub    %eax,%edx
  80354b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80354f:	03 45 0c             	add    0xc(%ebp),%eax
  803552:	89 44 24 04          	mov    %eax,0x4(%esp)
  803556:	89 3c 24             	mov    %edi,(%esp)
  803559:	e8 45 ff ff ff       	call   8034a3 <read>
		if (m < 0)
  80355e:	85 c0                	test   %eax,%eax
  803560:	78 0e                	js     803570 <readn+0x3f>
			return m;
		if (m == 0)
  803562:	85 c0                	test   %eax,%eax
  803564:	74 08                	je     80356e <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803566:	01 c3                	add    %eax,%ebx
  803568:	89 d8                	mov    %ebx,%eax
  80356a:	39 f3                	cmp    %esi,%ebx
  80356c:	72 d9                	jb     803547 <readn+0x16>
  80356e:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  803570:	83 c4 1c             	add    $0x1c,%esp
  803573:	5b                   	pop    %ebx
  803574:	5e                   	pop    %esi
  803575:	5f                   	pop    %edi
  803576:	5d                   	pop    %ebp
  803577:	c3                   	ret    

00803578 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  803578:	55                   	push   %ebp
  803579:	89 e5                	mov    %esp,%ebp
  80357b:	83 ec 38             	sub    $0x38,%esp
  80357e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803581:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803584:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803587:	8b 7d 08             	mov    0x8(%ebp),%edi
  80358a:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80358e:	89 3c 24             	mov    %edi,(%esp)
  803591:	e8 32 fc ff ff       	call   8031c8 <fd2num>
  803596:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  803599:	89 54 24 04          	mov    %edx,0x4(%esp)
  80359d:	89 04 24             	mov    %eax,(%esp)
  8035a0:	e8 a7 fc ff ff       	call   80324c <fd_lookup>
  8035a5:	89 c3                	mov    %eax,%ebx
  8035a7:	85 c0                	test   %eax,%eax
  8035a9:	78 05                	js     8035b0 <fd_close+0x38>
  8035ab:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8035ae:	74 0e                	je     8035be <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8035b0:	89 f0                	mov    %esi,%eax
  8035b2:	84 c0                	test   %al,%al
  8035b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b9:	0f 44 d8             	cmove  %eax,%ebx
  8035bc:	eb 3d                	jmp    8035fb <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8035be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c5:	8b 07                	mov    (%edi),%eax
  8035c7:	89 04 24             	mov    %eax,(%esp)
  8035ca:	e8 f1 fc ff ff       	call   8032c0 <dev_lookup>
  8035cf:	89 c3                	mov    %eax,%ebx
  8035d1:	85 c0                	test   %eax,%eax
  8035d3:	78 16                	js     8035eb <fd_close+0x73>
		if (dev->dev_close)
  8035d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d8:	8b 40 10             	mov    0x10(%eax),%eax
  8035db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	74 07                	je     8035eb <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8035e4:	89 3c 24             	mov    %edi,(%esp)
  8035e7:	ff d0                	call   *%eax
  8035e9:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8035eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8035ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035f6:	e8 97 f4 ff ff       	call   802a92 <sys_page_unmap>
	return r;
}
  8035fb:	89 d8                	mov    %ebx,%eax
  8035fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803600:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803603:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803606:	89 ec                	mov    %ebp,%esp
  803608:	5d                   	pop    %ebp
  803609:	c3                   	ret    

0080360a <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80360a:	55                   	push   %ebp
  80360b:	89 e5                	mov    %esp,%ebp
  80360d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803610:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803613:	89 44 24 04          	mov    %eax,0x4(%esp)
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	89 04 24             	mov    %eax,(%esp)
  80361d:	e8 2a fc ff ff       	call   80324c <fd_lookup>
  803622:	85 c0                	test   %eax,%eax
  803624:	78 13                	js     803639 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  803626:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80362d:	00 
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	89 04 24             	mov    %eax,(%esp)
  803634:	e8 3f ff ff ff       	call   803578 <fd_close>
}
  803639:	c9                   	leave  
  80363a:	c3                   	ret    

0080363b <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80363b:	55                   	push   %ebp
  80363c:	89 e5                	mov    %esp,%ebp
  80363e:	83 ec 18             	sub    $0x18,%esp
  803641:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803644:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803647:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80364e:	00 
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	89 04 24             	mov    %eax,(%esp)
  803655:	e8 a1 fa ff ff       	call   8030fb <open>
  80365a:	89 c3                	mov    %eax,%ebx
  80365c:	85 c0                	test   %eax,%eax
  80365e:	78 1b                	js     80367b <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  803660:	8b 45 0c             	mov    0xc(%ebp),%eax
  803663:	89 44 24 04          	mov    %eax,0x4(%esp)
  803667:	89 1c 24             	mov    %ebx,(%esp)
  80366a:	e8 b0 fc ff ff       	call   80331f <fstat>
  80366f:	89 c6                	mov    %eax,%esi
	close(fd);
  803671:	89 1c 24             	mov    %ebx,(%esp)
  803674:	e8 91 ff ff ff       	call   80360a <close>
  803679:	89 f3                	mov    %esi,%ebx
	return r;
}
  80367b:	89 d8                	mov    %ebx,%eax
  80367d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803680:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803683:	89 ec                	mov    %ebp,%esp
  803685:	5d                   	pop    %ebp
  803686:	c3                   	ret    

00803687 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	53                   	push   %ebx
  80368b:	83 ec 14             	sub    $0x14,%esp
  80368e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  803693:	89 1c 24             	mov    %ebx,(%esp)
  803696:	e8 6f ff ff ff       	call   80360a <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80369b:	83 c3 01             	add    $0x1,%ebx
  80369e:	83 fb 20             	cmp    $0x20,%ebx
  8036a1:	75 f0                	jne    803693 <close_all+0xc>
		close(i);
}
  8036a3:	83 c4 14             	add    $0x14,%esp
  8036a6:	5b                   	pop    %ebx
  8036a7:	5d                   	pop    %ebp
  8036a8:	c3                   	ret    

008036a9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8036a9:	55                   	push   %ebp
  8036aa:	89 e5                	mov    %esp,%ebp
  8036ac:	83 ec 58             	sub    $0x58,%esp
  8036af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8036b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8036b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8036b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8036bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8036be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	89 04 24             	mov    %eax,(%esp)
  8036c8:	e8 7f fb ff ff       	call   80324c <fd_lookup>
  8036cd:	89 c3                	mov    %eax,%ebx
  8036cf:	85 c0                	test   %eax,%eax
  8036d1:	0f 88 e0 00 00 00    	js     8037b7 <dup+0x10e>
		return r;
	close(newfdnum);
  8036d7:	89 3c 24             	mov    %edi,(%esp)
  8036da:	e8 2b ff ff ff       	call   80360a <close>

	newfd = INDEX2FD(newfdnum);
  8036df:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8036e5:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036eb:	89 04 24             	mov    %eax,(%esp)
  8036ee:	e8 e5 fa ff ff       	call   8031d8 <fd2data>
  8036f3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8036f5:	89 34 24             	mov    %esi,(%esp)
  8036f8:	e8 db fa ff ff       	call   8031d8 <fd2data>
  8036fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803700:	89 da                	mov    %ebx,%edx
  803702:	89 d8                	mov    %ebx,%eax
  803704:	c1 e8 16             	shr    $0x16,%eax
  803707:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80370e:	a8 01                	test   $0x1,%al
  803710:	74 43                	je     803755 <dup+0xac>
  803712:	c1 ea 0c             	shr    $0xc,%edx
  803715:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80371c:	a8 01                	test   $0x1,%al
  80371e:	74 35                	je     803755 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803720:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  803727:	25 07 0e 00 00       	and    $0xe07,%eax
  80372c:	89 44 24 10          	mov    %eax,0x10(%esp)
  803730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803733:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803737:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80373e:	00 
  80373f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803743:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80374a:	e8 a1 f3 ff ff       	call   802af0 <sys_page_map>
  80374f:	89 c3                	mov    %eax,%ebx
  803751:	85 c0                	test   %eax,%eax
  803753:	78 3f                	js     803794 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803758:	89 c2                	mov    %eax,%edx
  80375a:	c1 ea 0c             	shr    $0xc,%edx
  80375d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  803764:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80376a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80376e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803772:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803779:	00 
  80377a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80377e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803785:	e8 66 f3 ff ff       	call   802af0 <sys_page_map>
  80378a:	89 c3                	mov    %eax,%ebx
  80378c:	85 c0                	test   %eax,%eax
  80378e:	78 04                	js     803794 <dup+0xeb>
  803790:	89 fb                	mov    %edi,%ebx
  803792:	eb 23                	jmp    8037b7 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803794:	89 74 24 04          	mov    %esi,0x4(%esp)
  803798:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80379f:	e8 ee f2 ff ff       	call   802a92 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8037a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037b2:	e8 db f2 ff ff       	call   802a92 <sys_page_unmap>
	return r;
}
  8037b7:	89 d8                	mov    %ebx,%eax
  8037b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8037bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8037bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8037c2:	89 ec                	mov    %ebp,%esp
  8037c4:	5d                   	pop    %ebp
  8037c5:	c3                   	ret    
	...

008037d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037d0:	55                   	push   %ebp
  8037d1:	89 e5                	mov    %esp,%ebp
  8037d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8037d6:	c7 44 24 04 fc 4e 80 	movl   $0x804efc,0x4(%esp)
  8037dd:	00 
  8037de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e1:	89 04 24             	mov    %eax,(%esp)
  8037e4:	e8 20 ec ff ff       	call   802409 <strcpy>
	return 0;
}
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ee:	c9                   	leave  
  8037ef:	c3                   	ret    

008037f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	53                   	push   %ebx
  8037f4:	83 ec 14             	sub    $0x14,%esp
  8037f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8037fa:	89 1c 24             	mov    %ebx,(%esp)
  8037fd:	e8 86 f9 ff ff       	call   803188 <pageref>
  803802:	89 c2                	mov    %eax,%edx
  803804:	b8 00 00 00 00       	mov    $0x0,%eax
  803809:	83 fa 01             	cmp    $0x1,%edx
  80380c:	75 0b                	jne    803819 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80380e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803811:	89 04 24             	mov    %eax,(%esp)
  803814:	e8 b1 02 00 00       	call   803aca <nsipc_close>
	else
		return 0;
}
  803819:	83 c4 14             	add    $0x14,%esp
  80381c:	5b                   	pop    %ebx
  80381d:	5d                   	pop    %ebp
  80381e:	c3                   	ret    

0080381f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80381f:	55                   	push   %ebp
  803820:	89 e5                	mov    %esp,%ebp
  803822:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803825:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80382c:	00 
  80382d:	8b 45 10             	mov    0x10(%ebp),%eax
  803830:	89 44 24 08          	mov    %eax,0x8(%esp)
  803834:	8b 45 0c             	mov    0xc(%ebp),%eax
  803837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80383b:	8b 45 08             	mov    0x8(%ebp),%eax
  80383e:	8b 40 0c             	mov    0xc(%eax),%eax
  803841:	89 04 24             	mov    %eax,(%esp)
  803844:	e8 bd 02 00 00       	call   803b06 <nsipc_send>
}
  803849:	c9                   	leave  
  80384a:	c3                   	ret    

0080384b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80384b:	55                   	push   %ebp
  80384c:	89 e5                	mov    %esp,%ebp
  80384e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803851:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803858:	00 
  803859:	8b 45 10             	mov    0x10(%ebp),%eax
  80385c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803860:	8b 45 0c             	mov    0xc(%ebp),%eax
  803863:	89 44 24 04          	mov    %eax,0x4(%esp)
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	8b 40 0c             	mov    0xc(%eax),%eax
  80386d:	89 04 24             	mov    %eax,(%esp)
  803870:	e8 04 03 00 00       	call   803b79 <nsipc_recv>
}
  803875:	c9                   	leave  
  803876:	c3                   	ret    

00803877 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803877:	55                   	push   %ebp
  803878:	89 e5                	mov    %esp,%ebp
  80387a:	56                   	push   %esi
  80387b:	53                   	push   %ebx
  80387c:	83 ec 20             	sub    $0x20,%esp
  80387f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803881:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803884:	89 04 24             	mov    %eax,(%esp)
  803887:	e8 67 f9 ff ff       	call   8031f3 <fd_alloc>
  80388c:	89 c3                	mov    %eax,%ebx
  80388e:	85 c0                	test   %eax,%eax
  803890:	78 21                	js     8038b3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803892:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803899:	00 
  80389a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038a8:	e8 a1 f2 ff ff       	call   802b4e <sys_page_alloc>
  8038ad:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8038af:	85 c0                	test   %eax,%eax
  8038b1:	79 0a                	jns    8038bd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8038b3:	89 34 24             	mov    %esi,(%esp)
  8038b6:	e8 0f 02 00 00       	call   803aca <nsipc_close>
		return r;
  8038bb:	eb 28                	jmp    8038e5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8038bd:	8b 15 84 90 80 00    	mov    0x809084,%edx
  8038c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8038c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038db:	89 04 24             	mov    %eax,(%esp)
  8038de:	e8 e5 f8 ff ff       	call   8031c8 <fd2num>
  8038e3:	89 c3                	mov    %eax,%ebx
}
  8038e5:	89 d8                	mov    %ebx,%eax
  8038e7:	83 c4 20             	add    $0x20,%esp
  8038ea:	5b                   	pop    %ebx
  8038eb:	5e                   	pop    %esi
  8038ec:	5d                   	pop    %ebp
  8038ed:	c3                   	ret    

008038ee <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8038ee:	55                   	push   %ebp
  8038ef:	89 e5                	mov    %esp,%ebp
  8038f1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8038f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  803902:	8b 45 08             	mov    0x8(%ebp),%eax
  803905:	89 04 24             	mov    %eax,(%esp)
  803908:	e8 71 01 00 00       	call   803a7e <nsipc_socket>
  80390d:	85 c0                	test   %eax,%eax
  80390f:	78 05                	js     803916 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  803911:	e8 61 ff ff ff       	call   803877 <alloc_sockfd>
}
  803916:	c9                   	leave  
  803917:	c3                   	ret    

00803918 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803918:	55                   	push   %ebp
  803919:	89 e5                	mov    %esp,%ebp
  80391b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80391e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803921:	89 54 24 04          	mov    %edx,0x4(%esp)
  803925:	89 04 24             	mov    %eax,(%esp)
  803928:	e8 1f f9 ff ff       	call   80324c <fd_lookup>
  80392d:	85 c0                	test   %eax,%eax
  80392f:	78 15                	js     803946 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803934:	8b 0a                	mov    (%edx),%ecx
  803936:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80393b:	3b 0d 84 90 80 00    	cmp    0x809084,%ecx
  803941:	75 03                	jne    803946 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803943:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803946:	c9                   	leave  
  803947:	c3                   	ret    

00803948 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  803948:	55                   	push   %ebp
  803949:	89 e5                	mov    %esp,%ebp
  80394b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80394e:	8b 45 08             	mov    0x8(%ebp),%eax
  803951:	e8 c2 ff ff ff       	call   803918 <fd2sockid>
  803956:	85 c0                	test   %eax,%eax
  803958:	78 0f                	js     803969 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80395a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80395d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803961:	89 04 24             	mov    %eax,(%esp)
  803964:	e8 3f 01 00 00       	call   803aa8 <nsipc_listen>
}
  803969:	c9                   	leave  
  80396a:	c3                   	ret    

0080396b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80396b:	55                   	push   %ebp
  80396c:	89 e5                	mov    %esp,%ebp
  80396e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803971:	8b 45 08             	mov    0x8(%ebp),%eax
  803974:	e8 9f ff ff ff       	call   803918 <fd2sockid>
  803979:	85 c0                	test   %eax,%eax
  80397b:	78 16                	js     803993 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80397d:	8b 55 10             	mov    0x10(%ebp),%edx
  803980:	89 54 24 08          	mov    %edx,0x8(%esp)
  803984:	8b 55 0c             	mov    0xc(%ebp),%edx
  803987:	89 54 24 04          	mov    %edx,0x4(%esp)
  80398b:	89 04 24             	mov    %eax,(%esp)
  80398e:	e8 66 02 00 00       	call   803bf9 <nsipc_connect>
}
  803993:	c9                   	leave  
  803994:	c3                   	ret    

00803995 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  803995:	55                   	push   %ebp
  803996:	89 e5                	mov    %esp,%ebp
  803998:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80399b:	8b 45 08             	mov    0x8(%ebp),%eax
  80399e:	e8 75 ff ff ff       	call   803918 <fd2sockid>
  8039a3:	85 c0                	test   %eax,%eax
  8039a5:	78 0f                	js     8039b6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8039a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039ae:	89 04 24             	mov    %eax,(%esp)
  8039b1:	e8 2e 01 00 00       	call   803ae4 <nsipc_shutdown>
}
  8039b6:	c9                   	leave  
  8039b7:	c3                   	ret    

008039b8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039b8:	55                   	push   %ebp
  8039b9:	89 e5                	mov    %esp,%ebp
  8039bb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039be:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c1:	e8 52 ff ff ff       	call   803918 <fd2sockid>
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	78 16                	js     8039e0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8039ca:	8b 55 10             	mov    0x10(%ebp),%edx
  8039cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039d8:	89 04 24             	mov    %eax,(%esp)
  8039db:	e8 58 02 00 00       	call   803c38 <nsipc_bind>
}
  8039e0:	c9                   	leave  
  8039e1:	c3                   	ret    

008039e2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039e2:	55                   	push   %ebp
  8039e3:	89 e5                	mov    %esp,%ebp
  8039e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039eb:	e8 28 ff ff ff       	call   803918 <fd2sockid>
  8039f0:	85 c0                	test   %eax,%eax
  8039f2:	78 1f                	js     803a13 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8039f4:	8b 55 10             	mov    0x10(%ebp),%edx
  8039f7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a02:	89 04 24             	mov    %eax,(%esp)
  803a05:	e8 6d 02 00 00       	call   803c77 <nsipc_accept>
  803a0a:	85 c0                	test   %eax,%eax
  803a0c:	78 05                	js     803a13 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  803a0e:	e8 64 fe ff ff       	call   803877 <alloc_sockfd>
}
  803a13:	c9                   	leave  
  803a14:	c3                   	ret    
  803a15:	00 00                	add    %al,(%eax)
	...

00803a18 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a18:	55                   	push   %ebp
  803a19:	89 e5                	mov    %esp,%ebp
  803a1b:	53                   	push   %ebx
  803a1c:	83 ec 14             	sub    $0x14,%esp
  803a1f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803a21:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  803a28:	75 11                	jne    803a3b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a2a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  803a31:	e8 e2 f2 ff ff       	call   802d18 <ipc_find_env>
  803a36:	a3 04 a0 80 00       	mov    %eax,0x80a004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a3b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803a42:	00 
  803a43:	c7 44 24 08 00 d0 80 	movl   $0x80d000,0x8(%esp)
  803a4a:	00 
  803a4b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803a4f:	a1 04 a0 80 00       	mov    0x80a004,%eax
  803a54:	89 04 24             	mov    %eax,(%esp)
  803a57:	e8 f2 f2 ff ff       	call   802d4e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803a5c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803a63:	00 
  803a64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a6b:	00 
  803a6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a73:	e8 42 f3 ff ff       	call   802dba <ipc_recv>
}
  803a78:	83 c4 14             	add    $0x14,%esp
  803a7b:	5b                   	pop    %ebx
  803a7c:	5d                   	pop    %ebp
  803a7d:	c3                   	ret    

00803a7e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  803a7e:	55                   	push   %ebp
  803a7f:	89 e5                	mov    %esp,%ebp
  803a81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a84:	8b 45 08             	mov    0x8(%ebp),%eax
  803a87:	a3 00 d0 80 00       	mov    %eax,0x80d000
	nsipcbuf.socket.req_type = type;
  803a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8f:	a3 04 d0 80 00       	mov    %eax,0x80d004
	nsipcbuf.socket.req_protocol = protocol;
  803a94:	8b 45 10             	mov    0x10(%ebp),%eax
  803a97:	a3 08 d0 80 00       	mov    %eax,0x80d008
	return nsipc(NSREQ_SOCKET);
  803a9c:	b8 09 00 00 00       	mov    $0x9,%eax
  803aa1:	e8 72 ff ff ff       	call   803a18 <nsipc>
}
  803aa6:	c9                   	leave  
  803aa7:	c3                   	ret    

00803aa8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  803aa8:	55                   	push   %ebp
  803aa9:	89 e5                	mov    %esp,%ebp
  803aab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803aae:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab1:	a3 00 d0 80 00       	mov    %eax,0x80d000
	nsipcbuf.listen.req_backlog = backlog;
  803ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab9:	a3 04 d0 80 00       	mov    %eax,0x80d004
	return nsipc(NSREQ_LISTEN);
  803abe:	b8 06 00 00 00       	mov    $0x6,%eax
  803ac3:	e8 50 ff ff ff       	call   803a18 <nsipc>
}
  803ac8:	c9                   	leave  
  803ac9:	c3                   	ret    

00803aca <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  803aca:	55                   	push   %ebp
  803acb:	89 e5                	mov    %esp,%ebp
  803acd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad3:	a3 00 d0 80 00       	mov    %eax,0x80d000
	return nsipc(NSREQ_CLOSE);
  803ad8:	b8 04 00 00 00       	mov    $0x4,%eax
  803add:	e8 36 ff ff ff       	call   803a18 <nsipc>
}
  803ae2:	c9                   	leave  
  803ae3:	c3                   	ret    

00803ae4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  803ae4:	55                   	push   %ebp
  803ae5:	89 e5                	mov    %esp,%ebp
  803ae7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803aea:	8b 45 08             	mov    0x8(%ebp),%eax
  803aed:	a3 00 d0 80 00       	mov    %eax,0x80d000
	nsipcbuf.shutdown.req_how = how;
  803af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af5:	a3 04 d0 80 00       	mov    %eax,0x80d004
	return nsipc(NSREQ_SHUTDOWN);
  803afa:	b8 03 00 00 00       	mov    $0x3,%eax
  803aff:	e8 14 ff ff ff       	call   803a18 <nsipc>
}
  803b04:	c9                   	leave  
  803b05:	c3                   	ret    

00803b06 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b06:	55                   	push   %ebp
  803b07:	89 e5                	mov    %esp,%ebp
  803b09:	53                   	push   %ebx
  803b0a:	83 ec 14             	sub    $0x14,%esp
  803b0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803b10:	8b 45 08             	mov    0x8(%ebp),%eax
  803b13:	a3 00 d0 80 00       	mov    %eax,0x80d000
	assert(size < 1600);
  803b18:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803b1e:	7e 24                	jle    803b44 <nsipc_send+0x3e>
  803b20:	c7 44 24 0c 08 4f 80 	movl   $0x804f08,0xc(%esp)
  803b27:	00 
  803b28:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  803b2f:	00 
  803b30:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  803b37:	00 
  803b38:	c7 04 24 14 4f 80 00 	movl   $0x804f14,(%esp)
  803b3f:	e8 a4 e1 ff ff       	call   801ce8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b4f:	c7 04 24 0c d0 80 00 	movl   $0x80d00c,(%esp)
  803b56:	e8 54 ea ff ff       	call   8025af <memmove>
	nsipcbuf.send.req_size = size;
  803b5b:	89 1d 04 d0 80 00    	mov    %ebx,0x80d004
	nsipcbuf.send.req_flags = flags;
  803b61:	8b 45 14             	mov    0x14(%ebp),%eax
  803b64:	a3 08 d0 80 00       	mov    %eax,0x80d008
	return nsipc(NSREQ_SEND);
  803b69:	b8 08 00 00 00       	mov    $0x8,%eax
  803b6e:	e8 a5 fe ff ff       	call   803a18 <nsipc>
}
  803b73:	83 c4 14             	add    $0x14,%esp
  803b76:	5b                   	pop    %ebx
  803b77:	5d                   	pop    %ebp
  803b78:	c3                   	ret    

00803b79 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b79:	55                   	push   %ebp
  803b7a:	89 e5                	mov    %esp,%ebp
  803b7c:	56                   	push   %esi
  803b7d:	53                   	push   %ebx
  803b7e:	83 ec 10             	sub    $0x10,%esp
  803b81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803b84:	8b 45 08             	mov    0x8(%ebp),%eax
  803b87:	a3 00 d0 80 00       	mov    %eax,0x80d000
	nsipcbuf.recv.req_len = len;
  803b8c:	89 35 04 d0 80 00    	mov    %esi,0x80d004
	nsipcbuf.recv.req_flags = flags;
  803b92:	8b 45 14             	mov    0x14(%ebp),%eax
  803b95:	a3 08 d0 80 00       	mov    %eax,0x80d008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b9a:	b8 07 00 00 00       	mov    $0x7,%eax
  803b9f:	e8 74 fe ff ff       	call   803a18 <nsipc>
  803ba4:	89 c3                	mov    %eax,%ebx
  803ba6:	85 c0                	test   %eax,%eax
  803ba8:	78 46                	js     803bf0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803baa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803baf:	7f 04                	jg     803bb5 <nsipc_recv+0x3c>
  803bb1:	39 c6                	cmp    %eax,%esi
  803bb3:	7d 24                	jge    803bd9 <nsipc_recv+0x60>
  803bb5:	c7 44 24 0c 20 4f 80 	movl   $0x804f20,0xc(%esp)
  803bbc:	00 
  803bbd:	c7 44 24 08 ad 44 80 	movl   $0x8044ad,0x8(%esp)
  803bc4:	00 
  803bc5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  803bcc:	00 
  803bcd:	c7 04 24 14 4f 80 00 	movl   $0x804f14,(%esp)
  803bd4:	e8 0f e1 ff ff       	call   801ce8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bdd:	c7 44 24 04 00 d0 80 	movl   $0x80d000,0x4(%esp)
  803be4:	00 
  803be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be8:	89 04 24             	mov    %eax,(%esp)
  803beb:	e8 bf e9 ff ff       	call   8025af <memmove>
	}

	return r;
}
  803bf0:	89 d8                	mov    %ebx,%eax
  803bf2:	83 c4 10             	add    $0x10,%esp
  803bf5:	5b                   	pop    %ebx
  803bf6:	5e                   	pop    %esi
  803bf7:	5d                   	pop    %ebp
  803bf8:	c3                   	ret    

00803bf9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bf9:	55                   	push   %ebp
  803bfa:	89 e5                	mov    %esp,%ebp
  803bfc:	53                   	push   %ebx
  803bfd:	83 ec 14             	sub    $0x14,%esp
  803c00:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803c03:	8b 45 08             	mov    0x8(%ebp),%eax
  803c06:	a3 00 d0 80 00       	mov    %eax,0x80d000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c16:	c7 04 24 04 d0 80 00 	movl   $0x80d004,(%esp)
  803c1d:	e8 8d e9 ff ff       	call   8025af <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803c22:	89 1d 14 d0 80 00    	mov    %ebx,0x80d014
	return nsipc(NSREQ_CONNECT);
  803c28:	b8 05 00 00 00       	mov    $0x5,%eax
  803c2d:	e8 e6 fd ff ff       	call   803a18 <nsipc>
}
  803c32:	83 c4 14             	add    $0x14,%esp
  803c35:	5b                   	pop    %ebx
  803c36:	5d                   	pop    %ebp
  803c37:	c3                   	ret    

00803c38 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c38:	55                   	push   %ebp
  803c39:	89 e5                	mov    %esp,%ebp
  803c3b:	53                   	push   %ebx
  803c3c:	83 ec 14             	sub    $0x14,%esp
  803c3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803c42:	8b 45 08             	mov    0x8(%ebp),%eax
  803c45:	a3 00 d0 80 00       	mov    %eax,0x80d000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c55:	c7 04 24 04 d0 80 00 	movl   $0x80d004,(%esp)
  803c5c:	e8 4e e9 ff ff       	call   8025af <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803c61:	89 1d 14 d0 80 00    	mov    %ebx,0x80d014
	return nsipc(NSREQ_BIND);
  803c67:	b8 02 00 00 00       	mov    $0x2,%eax
  803c6c:	e8 a7 fd ff ff       	call   803a18 <nsipc>
}
  803c71:	83 c4 14             	add    $0x14,%esp
  803c74:	5b                   	pop    %ebx
  803c75:	5d                   	pop    %ebp
  803c76:	c3                   	ret    

00803c77 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c77:	55                   	push   %ebp
  803c78:	89 e5                	mov    %esp,%ebp
  803c7a:	83 ec 28             	sub    $0x28,%esp
  803c7d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803c80:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803c83:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803c86:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  803c89:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8c:	a3 00 d0 80 00       	mov    %eax,0x80d000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803c91:	8b 07                	mov    (%edi),%eax
  803c93:	a3 04 d0 80 00       	mov    %eax,0x80d004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c98:	b8 01 00 00 00       	mov    $0x1,%eax
  803c9d:	e8 76 fd ff ff       	call   803a18 <nsipc>
  803ca2:	89 c6                	mov    %eax,%esi
  803ca4:	85 c0                	test   %eax,%eax
  803ca6:	78 22                	js     803cca <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803ca8:	bb 10 d0 80 00       	mov    $0x80d010,%ebx
  803cad:	8b 03                	mov    (%ebx),%eax
  803caf:	89 44 24 08          	mov    %eax,0x8(%esp)
  803cb3:	c7 44 24 04 00 d0 80 	movl   $0x80d000,0x4(%esp)
  803cba:	00 
  803cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cbe:	89 04 24             	mov    %eax,(%esp)
  803cc1:	e8 e9 e8 ff ff       	call   8025af <memmove>
		*addrlen = ret->ret_addrlen;
  803cc6:	8b 03                	mov    (%ebx),%eax
  803cc8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  803cca:	89 f0                	mov    %esi,%eax
  803ccc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803ccf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803cd2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803cd5:	89 ec                	mov    %ebp,%esp
  803cd7:	5d                   	pop    %ebp
  803cd8:	c3                   	ret    
  803cd9:	00 00                	add    %al,(%eax)
	...

00803cdc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803cdc:	55                   	push   %ebp
  803cdd:	89 e5                	mov    %esp,%ebp
  803cdf:	83 ec 18             	sub    $0x18,%esp
  803ce2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803ce5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803ce8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cee:	89 04 24             	mov    %eax,(%esp)
  803cf1:	e8 e2 f4 ff ff       	call   8031d8 <fd2data>
  803cf6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  803cf8:	c7 44 24 04 35 4f 80 	movl   $0x804f35,0x4(%esp)
  803cff:	00 
  803d00:	89 34 24             	mov    %esi,(%esp)
  803d03:	e8 01 e7 ff ff       	call   802409 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803d08:	8b 43 04             	mov    0x4(%ebx),%eax
  803d0b:	2b 03                	sub    (%ebx),%eax
  803d0d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  803d13:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  803d1a:	00 00 00 
	stat->st_dev = &devpipe;
  803d1d:	c7 86 88 00 00 00 a0 	movl   $0x8090a0,0x88(%esi)
  803d24:	90 80 00 
	return 0;
}
  803d27:	b8 00 00 00 00       	mov    $0x0,%eax
  803d2c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803d2f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803d32:	89 ec                	mov    %ebp,%esp
  803d34:	5d                   	pop    %ebp
  803d35:	c3                   	ret    

00803d36 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d36:	55                   	push   %ebp
  803d37:	89 e5                	mov    %esp,%ebp
  803d39:	53                   	push   %ebx
  803d3a:	83 ec 14             	sub    $0x14,%esp
  803d3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803d40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803d44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d4b:	e8 42 ed ff ff       	call   802a92 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803d50:	89 1c 24             	mov    %ebx,(%esp)
  803d53:	e8 80 f4 ff ff       	call   8031d8 <fd2data>
  803d58:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d63:	e8 2a ed ff ff       	call   802a92 <sys_page_unmap>
}
  803d68:	83 c4 14             	add    $0x14,%esp
  803d6b:	5b                   	pop    %ebx
  803d6c:	5d                   	pop    %ebp
  803d6d:	c3                   	ret    

00803d6e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d6e:	55                   	push   %ebp
  803d6f:	89 e5                	mov    %esp,%ebp
  803d71:	57                   	push   %edi
  803d72:	56                   	push   %esi
  803d73:	53                   	push   %ebx
  803d74:	83 ec 2c             	sub    $0x2c,%esp
  803d77:	89 c7                	mov    %eax,%edi
  803d79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d7c:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803d81:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803d84:	89 3c 24             	mov    %edi,(%esp)
  803d87:	e8 fc f3 ff ff       	call   803188 <pageref>
  803d8c:	89 c6                	mov    %eax,%esi
  803d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d91:	89 04 24             	mov    %eax,(%esp)
  803d94:	e8 ef f3 ff ff       	call   803188 <pageref>
  803d99:	39 c6                	cmp    %eax,%esi
  803d9b:	0f 94 c0             	sete   %al
  803d9e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  803da1:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  803da7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803daa:	39 cb                	cmp    %ecx,%ebx
  803dac:	75 08                	jne    803db6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803dae:	83 c4 2c             	add    $0x2c,%esp
  803db1:	5b                   	pop    %ebx
  803db2:	5e                   	pop    %esi
  803db3:	5f                   	pop    %edi
  803db4:	5d                   	pop    %ebp
  803db5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803db6:	83 f8 01             	cmp    $0x1,%eax
  803db9:	75 c1                	jne    803d7c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803dbb:	8b 52 58             	mov    0x58(%edx),%edx
  803dbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dc2:	89 54 24 08          	mov    %edx,0x8(%esp)
  803dc6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803dca:	c7 04 24 3c 4f 80 00 	movl   $0x804f3c,(%esp)
  803dd1:	e8 cb df ff ff       	call   801da1 <cprintf>
  803dd6:	eb a4                	jmp    803d7c <_pipeisclosed+0xe>

00803dd8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dd8:	55                   	push   %ebp
  803dd9:	89 e5                	mov    %esp,%ebp
  803ddb:	57                   	push   %edi
  803ddc:	56                   	push   %esi
  803ddd:	53                   	push   %ebx
  803dde:	83 ec 1c             	sub    $0x1c,%esp
  803de1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803de4:	89 34 24             	mov    %esi,(%esp)
  803de7:	e8 ec f3 ff ff       	call   8031d8 <fd2data>
  803dec:	89 c3                	mov    %eax,%ebx
  803dee:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803df3:	eb 48                	jmp    803e3d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803df5:	89 da                	mov    %ebx,%edx
  803df7:	89 f0                	mov    %esi,%eax
  803df9:	e8 70 ff ff ff       	call   803d6e <_pipeisclosed>
  803dfe:	85 c0                	test   %eax,%eax
  803e00:	74 07                	je     803e09 <devpipe_write+0x31>
  803e02:	b8 00 00 00 00       	mov    $0x0,%eax
  803e07:	eb 3b                	jmp    803e44 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e09:	e8 9f ed ff ff       	call   802bad <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e0e:	8b 43 04             	mov    0x4(%ebx),%eax
  803e11:	8b 13                	mov    (%ebx),%edx
  803e13:	83 c2 20             	add    $0x20,%edx
  803e16:	39 d0                	cmp    %edx,%eax
  803e18:	73 db                	jae    803df5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e1a:	89 c2                	mov    %eax,%edx
  803e1c:	c1 fa 1f             	sar    $0x1f,%edx
  803e1f:	c1 ea 1b             	shr    $0x1b,%edx
  803e22:	01 d0                	add    %edx,%eax
  803e24:	83 e0 1f             	and    $0x1f,%eax
  803e27:	29 d0                	sub    %edx,%eax
  803e29:	89 c2                	mov    %eax,%edx
  803e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e2e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  803e32:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803e36:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e3a:	83 c7 01             	add    $0x1,%edi
  803e3d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803e40:	72 cc                	jb     803e0e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e42:	89 f8                	mov    %edi,%eax
}
  803e44:	83 c4 1c             	add    $0x1c,%esp
  803e47:	5b                   	pop    %ebx
  803e48:	5e                   	pop    %esi
  803e49:	5f                   	pop    %edi
  803e4a:	5d                   	pop    %ebp
  803e4b:	c3                   	ret    

00803e4c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e4c:	55                   	push   %ebp
  803e4d:	89 e5                	mov    %esp,%ebp
  803e4f:	83 ec 28             	sub    $0x28,%esp
  803e52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803e55:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803e58:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803e5b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e5e:	89 3c 24             	mov    %edi,(%esp)
  803e61:	e8 72 f3 ff ff       	call   8031d8 <fd2data>
  803e66:	89 c3                	mov    %eax,%ebx
  803e68:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e6d:	eb 48                	jmp    803eb7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e6f:	85 f6                	test   %esi,%esi
  803e71:	74 04                	je     803e77 <devpipe_read+0x2b>
				return i;
  803e73:	89 f0                	mov    %esi,%eax
  803e75:	eb 47                	jmp    803ebe <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e77:	89 da                	mov    %ebx,%edx
  803e79:	89 f8                	mov    %edi,%eax
  803e7b:	e8 ee fe ff ff       	call   803d6e <_pipeisclosed>
  803e80:	85 c0                	test   %eax,%eax
  803e82:	74 07                	je     803e8b <devpipe_read+0x3f>
  803e84:	b8 00 00 00 00       	mov    $0x0,%eax
  803e89:	eb 33                	jmp    803ebe <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e8b:	e8 1d ed ff ff       	call   802bad <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e90:	8b 03                	mov    (%ebx),%eax
  803e92:	3b 43 04             	cmp    0x4(%ebx),%eax
  803e95:	74 d8                	je     803e6f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e97:	89 c2                	mov    %eax,%edx
  803e99:	c1 fa 1f             	sar    $0x1f,%edx
  803e9c:	c1 ea 1b             	shr    $0x1b,%edx
  803e9f:	01 d0                	add    %edx,%eax
  803ea1:	83 e0 1f             	and    $0x1f,%eax
  803ea4:	29 d0                	sub    %edx,%eax
  803ea6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  803eae:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803eb1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803eb4:	83 c6 01             	add    $0x1,%esi
  803eb7:	3b 75 10             	cmp    0x10(%ebp),%esi
  803eba:	72 d4                	jb     803e90 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ebc:	89 f0                	mov    %esi,%eax
}
  803ebe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803ec1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803ec4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803ec7:	89 ec                	mov    %ebp,%esp
  803ec9:	5d                   	pop    %ebp
  803eca:	c3                   	ret    

00803ecb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803ecb:	55                   	push   %ebp
  803ecc:	89 e5                	mov    %esp,%ebp
  803ece:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ed1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  803edb:	89 04 24             	mov    %eax,(%esp)
  803ede:	e8 69 f3 ff ff       	call   80324c <fd_lookup>
  803ee3:	85 c0                	test   %eax,%eax
  803ee5:	78 15                	js     803efc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eea:	89 04 24             	mov    %eax,(%esp)
  803eed:	e8 e6 f2 ff ff       	call   8031d8 <fd2data>
	return _pipeisclosed(fd, p);
  803ef2:	89 c2                	mov    %eax,%edx
  803ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef7:	e8 72 fe ff ff       	call   803d6e <_pipeisclosed>
}
  803efc:	c9                   	leave  
  803efd:	c3                   	ret    

00803efe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803efe:	55                   	push   %ebp
  803eff:	89 e5                	mov    %esp,%ebp
  803f01:	83 ec 48             	sub    $0x48,%esp
  803f04:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803f07:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803f0a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803f0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803f13:	89 04 24             	mov    %eax,(%esp)
  803f16:	e8 d8 f2 ff ff       	call   8031f3 <fd_alloc>
  803f1b:	89 c3                	mov    %eax,%ebx
  803f1d:	85 c0                	test   %eax,%eax
  803f1f:	0f 88 42 01 00 00    	js     804067 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f25:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f2c:	00 
  803f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f3b:	e8 0e ec ff ff       	call   802b4e <sys_page_alloc>
  803f40:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f42:	85 c0                	test   %eax,%eax
  803f44:	0f 88 1d 01 00 00    	js     804067 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f4a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803f4d:	89 04 24             	mov    %eax,(%esp)
  803f50:	e8 9e f2 ff ff       	call   8031f3 <fd_alloc>
  803f55:	89 c3                	mov    %eax,%ebx
  803f57:	85 c0                	test   %eax,%eax
  803f59:	0f 88 f5 00 00 00    	js     804054 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f5f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f66:	00 
  803f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f75:	e8 d4 eb ff ff       	call   802b4e <sys_page_alloc>
  803f7a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f7c:	85 c0                	test   %eax,%eax
  803f7e:	0f 88 d0 00 00 00    	js     804054 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f87:	89 04 24             	mov    %eax,(%esp)
  803f8a:	e8 49 f2 ff ff       	call   8031d8 <fd2data>
  803f8f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f91:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f98:	00 
  803f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fa4:	e8 a5 eb ff ff       	call   802b4e <sys_page_alloc>
  803fa9:	89 c3                	mov    %eax,%ebx
  803fab:	85 c0                	test   %eax,%eax
  803fad:	0f 88 8e 00 00 00    	js     804041 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fb6:	89 04 24             	mov    %eax,(%esp)
  803fb9:	e8 1a f2 ff ff       	call   8031d8 <fd2data>
  803fbe:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803fc5:	00 
  803fc6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803fd1:	00 
  803fd2:	89 74 24 04          	mov    %esi,0x4(%esp)
  803fd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fdd:	e8 0e eb ff ff       	call   802af0 <sys_page_map>
  803fe2:	89 c3                	mov    %eax,%ebx
  803fe4:	85 c0                	test   %eax,%eax
  803fe6:	78 49                	js     804031 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803fe8:	b8 a0 90 80 00       	mov    $0x8090a0,%eax
  803fed:	8b 08                	mov    (%eax),%ecx
  803fef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  803ff4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  803ffe:	8b 10                	mov    (%eax),%edx
  804000:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804003:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  804005:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804008:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80400f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804012:	89 04 24             	mov    %eax,(%esp)
  804015:	e8 ae f1 ff ff       	call   8031c8 <fd2num>
  80401a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80401c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80401f:	89 04 24             	mov    %eax,(%esp)
  804022:	e8 a1 f1 ff ff       	call   8031c8 <fd2num>
  804027:	89 47 04             	mov    %eax,0x4(%edi)
  80402a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80402f:	eb 36                	jmp    804067 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  804031:	89 74 24 04          	mov    %esi,0x4(%esp)
  804035:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80403c:	e8 51 ea ff ff       	call   802a92 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  804041:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804044:	89 44 24 04          	mov    %eax,0x4(%esp)
  804048:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80404f:	e8 3e ea ff ff       	call   802a92 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  804054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80405b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804062:	e8 2b ea ff ff       	call   802a92 <sys_page_unmap>
    err:
	return r;
}
  804067:	89 d8                	mov    %ebx,%eax
  804069:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80406c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80406f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  804072:	89 ec                	mov    %ebp,%esp
  804074:	5d                   	pop    %ebp
  804075:	c3                   	ret    
	...

00804080 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804080:	55                   	push   %ebp
  804081:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
  804088:	5d                   	pop    %ebp
  804089:	c3                   	ret    

0080408a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80408a:	55                   	push   %ebp
  80408b:	89 e5                	mov    %esp,%ebp
  80408d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804090:	c7 44 24 04 54 4f 80 	movl   $0x804f54,0x4(%esp)
  804097:	00 
  804098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80409b:	89 04 24             	mov    %eax,(%esp)
  80409e:	e8 66 e3 ff ff       	call   802409 <strcpy>
	return 0;
}
  8040a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a8:	c9                   	leave  
  8040a9:	c3                   	ret    

008040aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040aa:	55                   	push   %ebp
  8040ab:	89 e5                	mov    %esp,%ebp
  8040ad:	57                   	push   %edi
  8040ae:	56                   	push   %esi
  8040af:	53                   	push   %ebx
  8040b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8040b6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040c1:	eb 34                	jmp    8040f7 <devcons_write+0x4d>
		m = n - tot;
  8040c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8040c6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8040c8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8040ce:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8040d3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040da:	03 45 0c             	add    0xc(%ebp),%eax
  8040dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040e1:	89 3c 24             	mov    %edi,(%esp)
  8040e4:	e8 c6 e4 ff ff       	call   8025af <memmove>
		sys_cputs(buf, m);
  8040e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8040ed:	89 3c 24             	mov    %edi,(%esp)
  8040f0:	e8 cb e6 ff ff       	call   8027c0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040f5:	01 de                	add    %ebx,%esi
  8040f7:	89 f0                	mov    %esi,%eax
  8040f9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8040fc:	72 c5                	jb     8040c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8040fe:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804104:	5b                   	pop    %ebx
  804105:	5e                   	pop    %esi
  804106:	5f                   	pop    %edi
  804107:	5d                   	pop    %ebp
  804108:	c3                   	ret    

00804109 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804109:	55                   	push   %ebp
  80410a:	89 e5                	mov    %esp,%ebp
  80410c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80410f:	8b 45 08             	mov    0x8(%ebp),%eax
  804112:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804115:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80411c:	00 
  80411d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804120:	89 04 24             	mov    %eax,(%esp)
  804123:	e8 98 e6 ff ff       	call   8027c0 <sys_cputs>
}
  804128:	c9                   	leave  
  804129:	c3                   	ret    

0080412a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80412a:	55                   	push   %ebp
  80412b:	89 e5                	mov    %esp,%ebp
  80412d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  804130:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804134:	75 07                	jne    80413d <devcons_read+0x13>
  804136:	eb 28                	jmp    804160 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804138:	e8 70 ea ff ff       	call   802bad <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80413d:	8d 76 00             	lea    0x0(%esi),%esi
  804140:	e8 47 e6 ff ff       	call   80278c <sys_cgetc>
  804145:	85 c0                	test   %eax,%eax
  804147:	74 ef                	je     804138 <devcons_read+0xe>
  804149:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80414b:	85 c0                	test   %eax,%eax
  80414d:	78 16                	js     804165 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80414f:	83 f8 04             	cmp    $0x4,%eax
  804152:	74 0c                	je     804160 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  804154:	8b 45 0c             	mov    0xc(%ebp),%eax
  804157:	88 10                	mov    %dl,(%eax)
  804159:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80415e:	eb 05                	jmp    804165 <devcons_read+0x3b>
  804160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804165:	c9                   	leave  
  804166:	c3                   	ret    

00804167 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  804167:	55                   	push   %ebp
  804168:	89 e5                	mov    %esp,%ebp
  80416a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80416d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804170:	89 04 24             	mov    %eax,(%esp)
  804173:	e8 7b f0 ff ff       	call   8031f3 <fd_alloc>
  804178:	85 c0                	test   %eax,%eax
  80417a:	78 3f                	js     8041bb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80417c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804183:	00 
  804184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80418b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804192:	e8 b7 e9 ff ff       	call   802b4e <sys_page_alloc>
  804197:	85 c0                	test   %eax,%eax
  804199:	78 20                	js     8041bb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80419b:	8b 15 bc 90 80 00    	mov    0x8090bc,%edx
  8041a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8041a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8041b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b3:	89 04 24             	mov    %eax,(%esp)
  8041b6:	e8 0d f0 ff ff       	call   8031c8 <fd2num>
}
  8041bb:	c9                   	leave  
  8041bc:	c3                   	ret    

008041bd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8041bd:	55                   	push   %ebp
  8041be:	89 e5                	mov    %esp,%ebp
  8041c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8041c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8041cd:	89 04 24             	mov    %eax,(%esp)
  8041d0:	e8 77 f0 ff ff       	call   80324c <fd_lookup>
  8041d5:	85 c0                	test   %eax,%eax
  8041d7:	78 11                	js     8041ea <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8041d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041dc:	8b 00                	mov    (%eax),%eax
  8041de:	3b 05 bc 90 80 00    	cmp    0x8090bc,%eax
  8041e4:	0f 94 c0             	sete   %al
  8041e7:	0f b6 c0             	movzbl %al,%eax
}
  8041ea:	c9                   	leave  
  8041eb:	c3                   	ret    

008041ec <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8041ec:	55                   	push   %ebp
  8041ed:	89 e5                	mov    %esp,%ebp
  8041ef:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8041f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8041f9:	00 
  8041fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8041fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  804201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804208:	e8 96 f2 ff ff       	call   8034a3 <read>
	if (r < 0)
  80420d:	85 c0                	test   %eax,%eax
  80420f:	78 0f                	js     804220 <getchar+0x34>
		return r;
	if (r < 1)
  804211:	85 c0                	test   %eax,%eax
  804213:	7f 07                	jg     80421c <getchar+0x30>
  804215:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80421a:	eb 04                	jmp    804220 <getchar+0x34>
		return -E_EOF;
	return c;
  80421c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  804220:	c9                   	leave  
  804221:	c3                   	ret    
	...

00804230 <__udivdi3>:
  804230:	55                   	push   %ebp
  804231:	89 e5                	mov    %esp,%ebp
  804233:	57                   	push   %edi
  804234:	56                   	push   %esi
  804235:	83 ec 10             	sub    $0x10,%esp
  804238:	8b 45 14             	mov    0x14(%ebp),%eax
  80423b:	8b 55 08             	mov    0x8(%ebp),%edx
  80423e:	8b 75 10             	mov    0x10(%ebp),%esi
  804241:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804244:	85 c0                	test   %eax,%eax
  804246:	89 55 f0             	mov    %edx,-0x10(%ebp)
  804249:	75 35                	jne    804280 <__udivdi3+0x50>
  80424b:	39 fe                	cmp    %edi,%esi
  80424d:	77 61                	ja     8042b0 <__udivdi3+0x80>
  80424f:	85 f6                	test   %esi,%esi
  804251:	75 0b                	jne    80425e <__udivdi3+0x2e>
  804253:	b8 01 00 00 00       	mov    $0x1,%eax
  804258:	31 d2                	xor    %edx,%edx
  80425a:	f7 f6                	div    %esi
  80425c:	89 c6                	mov    %eax,%esi
  80425e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804261:	31 d2                	xor    %edx,%edx
  804263:	89 f8                	mov    %edi,%eax
  804265:	f7 f6                	div    %esi
  804267:	89 c7                	mov    %eax,%edi
  804269:	89 c8                	mov    %ecx,%eax
  80426b:	f7 f6                	div    %esi
  80426d:	89 c1                	mov    %eax,%ecx
  80426f:	89 fa                	mov    %edi,%edx
  804271:	89 c8                	mov    %ecx,%eax
  804273:	83 c4 10             	add    $0x10,%esp
  804276:	5e                   	pop    %esi
  804277:	5f                   	pop    %edi
  804278:	5d                   	pop    %ebp
  804279:	c3                   	ret    
  80427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804280:	39 f8                	cmp    %edi,%eax
  804282:	77 1c                	ja     8042a0 <__udivdi3+0x70>
  804284:	0f bd d0             	bsr    %eax,%edx
  804287:	83 f2 1f             	xor    $0x1f,%edx
  80428a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80428d:	75 39                	jne    8042c8 <__udivdi3+0x98>
  80428f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  804292:	0f 86 a0 00 00 00    	jbe    804338 <__udivdi3+0x108>
  804298:	39 f8                	cmp    %edi,%eax
  80429a:	0f 82 98 00 00 00    	jb     804338 <__udivdi3+0x108>
  8042a0:	31 ff                	xor    %edi,%edi
  8042a2:	31 c9                	xor    %ecx,%ecx
  8042a4:	89 c8                	mov    %ecx,%eax
  8042a6:	89 fa                	mov    %edi,%edx
  8042a8:	83 c4 10             	add    $0x10,%esp
  8042ab:	5e                   	pop    %esi
  8042ac:	5f                   	pop    %edi
  8042ad:	5d                   	pop    %ebp
  8042ae:	c3                   	ret    
  8042af:	90                   	nop
  8042b0:	89 d1                	mov    %edx,%ecx
  8042b2:	89 fa                	mov    %edi,%edx
  8042b4:	89 c8                	mov    %ecx,%eax
  8042b6:	31 ff                	xor    %edi,%edi
  8042b8:	f7 f6                	div    %esi
  8042ba:	89 c1                	mov    %eax,%ecx
  8042bc:	89 fa                	mov    %edi,%edx
  8042be:	89 c8                	mov    %ecx,%eax
  8042c0:	83 c4 10             	add    $0x10,%esp
  8042c3:	5e                   	pop    %esi
  8042c4:	5f                   	pop    %edi
  8042c5:	5d                   	pop    %ebp
  8042c6:	c3                   	ret    
  8042c7:	90                   	nop
  8042c8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8042cc:	89 f2                	mov    %esi,%edx
  8042ce:	d3 e0                	shl    %cl,%eax
  8042d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8042d3:	b8 20 00 00 00       	mov    $0x20,%eax
  8042d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8042db:	89 c1                	mov    %eax,%ecx
  8042dd:	d3 ea                	shr    %cl,%edx
  8042df:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8042e3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8042e6:	d3 e6                	shl    %cl,%esi
  8042e8:	89 c1                	mov    %eax,%ecx
  8042ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8042ed:	89 fe                	mov    %edi,%esi
  8042ef:	d3 ee                	shr    %cl,%esi
  8042f1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8042f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8042f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042fb:	d3 e7                	shl    %cl,%edi
  8042fd:	89 c1                	mov    %eax,%ecx
  8042ff:	d3 ea                	shr    %cl,%edx
  804301:	09 d7                	or     %edx,%edi
  804303:	89 f2                	mov    %esi,%edx
  804305:	89 f8                	mov    %edi,%eax
  804307:	f7 75 ec             	divl   -0x14(%ebp)
  80430a:	89 d6                	mov    %edx,%esi
  80430c:	89 c7                	mov    %eax,%edi
  80430e:	f7 65 e8             	mull   -0x18(%ebp)
  804311:	39 d6                	cmp    %edx,%esi
  804313:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804316:	72 30                	jb     804348 <__udivdi3+0x118>
  804318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80431b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80431f:	d3 e2                	shl    %cl,%edx
  804321:	39 c2                	cmp    %eax,%edx
  804323:	73 05                	jae    80432a <__udivdi3+0xfa>
  804325:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  804328:	74 1e                	je     804348 <__udivdi3+0x118>
  80432a:	89 f9                	mov    %edi,%ecx
  80432c:	31 ff                	xor    %edi,%edi
  80432e:	e9 71 ff ff ff       	jmp    8042a4 <__udivdi3+0x74>
  804333:	90                   	nop
  804334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804338:	31 ff                	xor    %edi,%edi
  80433a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80433f:	e9 60 ff ff ff       	jmp    8042a4 <__udivdi3+0x74>
  804344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804348:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80434b:	31 ff                	xor    %edi,%edi
  80434d:	89 c8                	mov    %ecx,%eax
  80434f:	89 fa                	mov    %edi,%edx
  804351:	83 c4 10             	add    $0x10,%esp
  804354:	5e                   	pop    %esi
  804355:	5f                   	pop    %edi
  804356:	5d                   	pop    %ebp
  804357:	c3                   	ret    
	...

00804360 <__umoddi3>:
  804360:	55                   	push   %ebp
  804361:	89 e5                	mov    %esp,%ebp
  804363:	57                   	push   %edi
  804364:	56                   	push   %esi
  804365:	83 ec 20             	sub    $0x20,%esp
  804368:	8b 55 14             	mov    0x14(%ebp),%edx
  80436b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80436e:	8b 7d 10             	mov    0x10(%ebp),%edi
  804371:	8b 75 0c             	mov    0xc(%ebp),%esi
  804374:	85 d2                	test   %edx,%edx
  804376:	89 c8                	mov    %ecx,%eax
  804378:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80437b:	75 13                	jne    804390 <__umoddi3+0x30>
  80437d:	39 f7                	cmp    %esi,%edi
  80437f:	76 3f                	jbe    8043c0 <__umoddi3+0x60>
  804381:	89 f2                	mov    %esi,%edx
  804383:	f7 f7                	div    %edi
  804385:	89 d0                	mov    %edx,%eax
  804387:	31 d2                	xor    %edx,%edx
  804389:	83 c4 20             	add    $0x20,%esp
  80438c:	5e                   	pop    %esi
  80438d:	5f                   	pop    %edi
  80438e:	5d                   	pop    %ebp
  80438f:	c3                   	ret    
  804390:	39 f2                	cmp    %esi,%edx
  804392:	77 4c                	ja     8043e0 <__umoddi3+0x80>
  804394:	0f bd ca             	bsr    %edx,%ecx
  804397:	83 f1 1f             	xor    $0x1f,%ecx
  80439a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80439d:	75 51                	jne    8043f0 <__umoddi3+0x90>
  80439f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8043a2:	0f 87 e0 00 00 00    	ja     804488 <__umoddi3+0x128>
  8043a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ab:	29 f8                	sub    %edi,%eax
  8043ad:	19 d6                	sbb    %edx,%esi
  8043af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b5:	89 f2                	mov    %esi,%edx
  8043b7:	83 c4 20             	add    $0x20,%esp
  8043ba:	5e                   	pop    %esi
  8043bb:	5f                   	pop    %edi
  8043bc:	5d                   	pop    %ebp
  8043bd:	c3                   	ret    
  8043be:	66 90                	xchg   %ax,%ax
  8043c0:	85 ff                	test   %edi,%edi
  8043c2:	75 0b                	jne    8043cf <__umoddi3+0x6f>
  8043c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8043c9:	31 d2                	xor    %edx,%edx
  8043cb:	f7 f7                	div    %edi
  8043cd:	89 c7                	mov    %eax,%edi
  8043cf:	89 f0                	mov    %esi,%eax
  8043d1:	31 d2                	xor    %edx,%edx
  8043d3:	f7 f7                	div    %edi
  8043d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d8:	f7 f7                	div    %edi
  8043da:	eb a9                	jmp    804385 <__umoddi3+0x25>
  8043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043e0:	89 c8                	mov    %ecx,%eax
  8043e2:	89 f2                	mov    %esi,%edx
  8043e4:	83 c4 20             	add    $0x20,%esp
  8043e7:	5e                   	pop    %esi
  8043e8:	5f                   	pop    %edi
  8043e9:	5d                   	pop    %ebp
  8043ea:	c3                   	ret    
  8043eb:	90                   	nop
  8043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043f4:	d3 e2                	shl    %cl,%edx
  8043f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8043f9:	ba 20 00 00 00       	mov    $0x20,%edx
  8043fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  804401:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804404:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804408:	89 fa                	mov    %edi,%edx
  80440a:	d3 ea                	shr    %cl,%edx
  80440c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804410:	0b 55 f4             	or     -0xc(%ebp),%edx
  804413:	d3 e7                	shl    %cl,%edi
  804415:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804419:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80441c:	89 f2                	mov    %esi,%edx
  80441e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  804421:	89 c7                	mov    %eax,%edi
  804423:	d3 ea                	shr    %cl,%edx
  804425:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804429:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80442c:	89 c2                	mov    %eax,%edx
  80442e:	d3 e6                	shl    %cl,%esi
  804430:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804434:	d3 ea                	shr    %cl,%edx
  804436:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80443a:	09 d6                	or     %edx,%esi
  80443c:	89 f0                	mov    %esi,%eax
  80443e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  804441:	d3 e7                	shl    %cl,%edi
  804443:	89 f2                	mov    %esi,%edx
  804445:	f7 75 f4             	divl   -0xc(%ebp)
  804448:	89 d6                	mov    %edx,%esi
  80444a:	f7 65 e8             	mull   -0x18(%ebp)
  80444d:	39 d6                	cmp    %edx,%esi
  80444f:	72 2b                	jb     80447c <__umoddi3+0x11c>
  804451:	39 c7                	cmp    %eax,%edi
  804453:	72 23                	jb     804478 <__umoddi3+0x118>
  804455:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804459:	29 c7                	sub    %eax,%edi
  80445b:	19 d6                	sbb    %edx,%esi
  80445d:	89 f0                	mov    %esi,%eax
  80445f:	89 f2                	mov    %esi,%edx
  804461:	d3 ef                	shr    %cl,%edi
  804463:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804467:	d3 e0                	shl    %cl,%eax
  804469:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80446d:	09 f8                	or     %edi,%eax
  80446f:	d3 ea                	shr    %cl,%edx
  804471:	83 c4 20             	add    $0x20,%esp
  804474:	5e                   	pop    %esi
  804475:	5f                   	pop    %edi
  804476:	5d                   	pop    %ebp
  804477:	c3                   	ret    
  804478:	39 d6                	cmp    %edx,%esi
  80447a:	75 d9                	jne    804455 <__umoddi3+0xf5>
  80447c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80447f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  804482:	eb d1                	jmp    804455 <__umoddi3+0xf5>
  804484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804488:	39 f2                	cmp    %esi,%edx
  80448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804490:	0f 82 12 ff ff ff    	jb     8043a8 <__umoddi3+0x48>
  804496:	e9 17 ff ff ff       	jmp    8043b2 <__umoddi3+0x52>
