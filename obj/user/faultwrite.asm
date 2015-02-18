
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 13 00 00 00       	call   800044 <libmain>
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
	*(unsigned*)0 = 0;
  800037:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003e:	00 00 00 
}
  800041:	5d                   	pop    %ebp
  800042:	c3                   	ret    
	...

00800044 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800044:	55                   	push   %ebp
  800045:	89 e5                	mov    %esp,%ebp
  800047:	83 ec 18             	sub    $0x18,%esp
  80004a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80004d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800050:	8b 75 08             	mov    0x8(%ebp),%esi
  800053:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800056:	e8 a2 04 00 00       	call   8004fd <sys_getenvid>
  80005b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800060:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800063:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800068:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006d:	85 f6                	test   %esi,%esi
  80006f:	7e 07                	jle    800078 <libmain+0x34>
		binaryname = argv[0];
  800071:	8b 03                	mov    (%ebx),%eax
  800073:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800078:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80007c:	89 34 24             	mov    %esi,(%esp)
  80007f:	e8 b0 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800084:	e8 0b 00 00 00       	call   800094 <exit>
}
  800089:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80008c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80008f:	89 ec                	mov    %ebp,%esp
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    
	...

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80009a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a1:	e8 8b 04 00 00       	call   800531 <sys_env_destroy>
}
  8000a6:	c9                   	leave  
  8000a7:	c3                   	ret    

008000a8 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	89 1c 24             	mov    %ebx,(%esp)
  8000b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000b5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c3:	89 d1                	mov    %edx,%ecx
  8000c5:	89 d3                	mov    %edx,%ebx
  8000c7:	89 d7                	mov    %edx,%edi
  8000c9:	89 d6                	mov    %edx,%esi
  8000cb:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000cd:	8b 1c 24             	mov    (%esp),%ebx
  8000d0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000d8:	89 ec                	mov    %ebp,%esp
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	89 1c 24             	mov    %ebx,(%esp)
  8000e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000e9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f8:	89 c3                	mov    %eax,%ebx
  8000fa:	89 c7                	mov    %eax,%edi
  8000fc:	89 c6                	mov    %eax,%esi
  8000fe:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800100:	8b 1c 24             	mov    (%esp),%ebx
  800103:	8b 74 24 04          	mov    0x4(%esp),%esi
  800107:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80010b:	89 ec                	mov    %ebp,%esp
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    

0080010f <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	89 1c 24             	mov    %ebx,(%esp)
  800118:	89 74 24 04          	mov    %esi,0x4(%esp)
  80011c:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	b8 10 00 00 00       	mov    $0x10,%eax
  80012a:	89 d1                	mov    %edx,%ecx
  80012c:	89 d3                	mov    %edx,%ebx
  80012e:	89 d7                	mov    %edx,%edi
  800130:	89 d6                	mov    %edx,%esi
  800132:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800134:	8b 1c 24             	mov    (%esp),%ebx
  800137:	8b 74 24 04          	mov    0x4(%esp),%esi
  80013b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80013f:	89 ec                	mov    %ebp,%esp
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 38             	sub    $0x38,%esp
  800149:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80014c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80014f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800152:	bb 00 00 00 00       	mov    $0x0,%ebx
  800157:	b8 0f 00 00 00       	mov    $0xf,%eax
  80015c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015f:	8b 55 08             	mov    0x8(%ebp),%edx
  800162:	89 df                	mov    %ebx,%edi
  800164:	89 de                	mov    %ebx,%esi
  800166:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800168:	85 c0                	test   %eax,%eax
  80016a:	7e 28                	jle    800194 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800170:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800177:	00 
  800178:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80017f:	00 
  800180:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800187:	00 
  800188:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80018f:	e8 fc 03 00 00       	call   800590 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800194:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800197:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80019a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80019d:	89 ec                	mov    %ebp,%esp
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    

008001a1 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	83 ec 38             	sub    $0x38,%esp
  8001a7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001aa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001ad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001b5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c0:	89 df                	mov    %ebx,%edi
  8001c2:	89 de                	mov    %ebx,%esi
  8001c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	7e 28                	jle    8001f2 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001ce:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8001d5:	00 
  8001d6:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8001dd:	00 
  8001de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001e5:	00 
  8001e6:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8001ed:	e8 9e 03 00 00       	call   800590 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8001f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001fb:	89 ec                	mov    %ebp,%esp
  8001fd:	5d                   	pop    %ebp
  8001fe:	c3                   	ret    

008001ff <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	83 ec 38             	sub    $0x38,%esp
  800205:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800208:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80020b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80020e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800213:	b8 0d 00 00 00       	mov    $0xd,%eax
  800218:	8b 55 08             	mov    0x8(%ebp),%edx
  80021b:	89 cb                	mov    %ecx,%ebx
  80021d:	89 cf                	mov    %ecx,%edi
  80021f:	89 ce                	mov    %ecx,%esi
  800221:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800223:	85 c0                	test   %eax,%eax
  800225:	7e 28                	jle    80024f <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800227:	89 44 24 10          	mov    %eax,0x10(%esp)
  80022b:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800232:	00 
  800233:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80023a:	00 
  80023b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800242:	00 
  800243:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80024a:	e8 41 03 00 00       	call   800590 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80024f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800252:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800255:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800258:	89 ec                	mov    %ebp,%esp
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    

0080025c <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	89 1c 24             	mov    %ebx,(%esp)
  800265:	89 74 24 04          	mov    %esi,0x4(%esp)
  800269:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80026d:	be 00 00 00 00       	mov    $0x0,%esi
  800272:	b8 0c 00 00 00       	mov    $0xc,%eax
  800277:	8b 7d 14             	mov    0x14(%ebp),%edi
  80027a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80027d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800280:	8b 55 08             	mov    0x8(%ebp),%edx
  800283:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800285:	8b 1c 24             	mov    (%esp),%ebx
  800288:	8b 74 24 04          	mov    0x4(%esp),%esi
  80028c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800290:	89 ec                	mov    %ebp,%esp
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    

00800294 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 38             	sub    $0x38,%esp
  80029a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80029d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002a0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b3:	89 df                	mov    %ebx,%edi
  8002b5:	89 de                	mov    %ebx,%esi
  8002b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	7e 28                	jle    8002e5 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002c1:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8002d0:	00 
  8002d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002d8:	00 
  8002d9:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8002e0:	e8 ab 02 00 00       	call   800590 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002e8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002ee:	89 ec                	mov    %ebp,%esp
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 38             	sub    $0x38,%esp
  8002f8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002fb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002fe:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800301:	bb 00 00 00 00       	mov    $0x0,%ebx
  800306:	b8 09 00 00 00       	mov    $0x9,%eax
  80030b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030e:	8b 55 08             	mov    0x8(%ebp),%edx
  800311:	89 df                	mov    %ebx,%edi
  800313:	89 de                	mov    %ebx,%esi
  800315:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800317:	85 c0                	test   %eax,%eax
  800319:	7e 28                	jle    800343 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80031b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80031f:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800326:	00 
  800327:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80032e:	00 
  80032f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800336:	00 
  800337:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80033e:	e8 4d 02 00 00       	call   800590 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800343:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800346:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800349:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80034c:	89 ec                	mov    %ebp,%esp
  80034e:	5d                   	pop    %ebp
  80034f:	c3                   	ret    

00800350 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 38             	sub    $0x38,%esp
  800356:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800359:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80035c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80035f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800364:	b8 08 00 00 00       	mov    $0x8,%eax
  800369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036c:	8b 55 08             	mov    0x8(%ebp),%edx
  80036f:	89 df                	mov    %ebx,%edi
  800371:	89 de                	mov    %ebx,%esi
  800373:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800375:	85 c0                	test   %eax,%eax
  800377:	7e 28                	jle    8003a1 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800379:	89 44 24 10          	mov    %eax,0x10(%esp)
  80037d:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800384:	00 
  800385:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80038c:	00 
  80038d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800394:	00 
  800395:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80039c:	e8 ef 01 00 00       	call   800590 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8003a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003aa:	89 ec                	mov    %ebp,%esp
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	83 ec 38             	sub    $0x38,%esp
  8003b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c2:	b8 06 00 00 00       	mov    $0x6,%eax
  8003c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cd:	89 df                	mov    %ebx,%edi
  8003cf:	89 de                	mov    %ebx,%esi
  8003d1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003d3:	85 c0                	test   %eax,%eax
  8003d5:	7e 28                	jle    8003ff <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003db:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003e2:	00 
  8003e3:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8003ea:	00 
  8003eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003f2:	00 
  8003f3:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8003fa:	e8 91 01 00 00       	call   800590 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8003ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800402:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800405:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800408:	89 ec                	mov    %ebp,%esp
  80040a:	5d                   	pop    %ebp
  80040b:	c3                   	ret    

0080040c <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	83 ec 38             	sub    $0x38,%esp
  800412:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800415:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800418:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80041b:	b8 05 00 00 00       	mov    $0x5,%eax
  800420:	8b 75 18             	mov    0x18(%ebp),%esi
  800423:	8b 7d 14             	mov    0x14(%ebp),%edi
  800426:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800429:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80042c:	8b 55 08             	mov    0x8(%ebp),%edx
  80042f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800431:	85 c0                	test   %eax,%eax
  800433:	7e 28                	jle    80045d <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800435:	89 44 24 10          	mov    %eax,0x10(%esp)
  800439:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800440:	00 
  800441:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800448:	00 
  800449:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800450:	00 
  800451:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800458:	e8 33 01 00 00       	call   800590 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80045d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800460:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800463:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800466:	89 ec                	mov    %ebp,%esp
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    

0080046a <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	83 ec 38             	sub    $0x38,%esp
  800470:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800473:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800476:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800479:	be 00 00 00 00       	mov    $0x0,%esi
  80047e:	b8 04 00 00 00       	mov    $0x4,%eax
  800483:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800489:	8b 55 08             	mov    0x8(%ebp),%edx
  80048c:	89 f7                	mov    %esi,%edi
  80048e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800490:	85 c0                	test   %eax,%eax
  800492:	7e 28                	jle    8004bc <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800494:	89 44 24 10          	mov    %eax,0x10(%esp)
  800498:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80049f:	00 
  8004a0:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8004a7:	00 
  8004a8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004af:	00 
  8004b0:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8004b7:	e8 d4 00 00 00       	call   800590 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004bc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004bf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004c5:	89 ec                	mov    %ebp,%esp
  8004c7:	5d                   	pop    %ebp
  8004c8:	c3                   	ret    

008004c9 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 0c             	sub    $0xc,%esp
  8004cf:	89 1c 24             	mov    %ebx,(%esp)
  8004d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004da:	ba 00 00 00 00       	mov    $0x0,%edx
  8004df:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004e4:	89 d1                	mov    %edx,%ecx
  8004e6:	89 d3                	mov    %edx,%ebx
  8004e8:	89 d7                	mov    %edx,%edi
  8004ea:	89 d6                	mov    %edx,%esi
  8004ec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8004ee:	8b 1c 24             	mov    (%esp),%ebx
  8004f1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004f5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8004f9:	89 ec                	mov    %ebp,%esp
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	89 1c 24             	mov    %ebx,(%esp)
  800506:	89 74 24 04          	mov    %esi,0x4(%esp)
  80050a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80050e:	ba 00 00 00 00       	mov    $0x0,%edx
  800513:	b8 02 00 00 00       	mov    $0x2,%eax
  800518:	89 d1                	mov    %edx,%ecx
  80051a:	89 d3                	mov    %edx,%ebx
  80051c:	89 d7                	mov    %edx,%edi
  80051e:	89 d6                	mov    %edx,%esi
  800520:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800522:	8b 1c 24             	mov    (%esp),%ebx
  800525:	8b 74 24 04          	mov    0x4(%esp),%esi
  800529:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80052d:	89 ec                	mov    %ebp,%esp
  80052f:	5d                   	pop    %ebp
  800530:	c3                   	ret    

00800531 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 38             	sub    $0x38,%esp
  800537:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80053a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80053d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
  800545:	b8 03 00 00 00       	mov    $0x3,%eax
  80054a:	8b 55 08             	mov    0x8(%ebp),%edx
  80054d:	89 cb                	mov    %ecx,%ebx
  80054f:	89 cf                	mov    %ecx,%edi
  800551:	89 ce                	mov    %ecx,%esi
  800553:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800555:	85 c0                	test   %eax,%eax
  800557:	7e 28                	jle    800581 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800559:	89 44 24 10          	mov    %eax,0x10(%esp)
  80055d:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800564:	00 
  800565:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80056c:	00 
  80056d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800574:	00 
  800575:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80057c:	e8 0f 00 00 00       	call   800590 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800581:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800584:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800587:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80058a:	89 ec                	mov    %ebp,%esp
  80058c:	5d                   	pop    %ebp
  80058d:	c3                   	ret    
	...

00800590 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	56                   	push   %esi
  800594:	53                   	push   %ebx
  800595:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800598:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80059b:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8005a1:	e8 57 ff ff ff       	call   8004fd <sys_getenvid>
  8005a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005bc:	c7 04 24 d8 12 80 00 	movl   $0x8012d8,(%esp)
  8005c3:	e8 81 00 00 00       	call   800649 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 04 24             	mov    %eax,(%esp)
  8005d2:	e8 11 00 00 00       	call   8005e8 <vcprintf>
	cprintf("\n");
  8005d7:	c7 04 24 fb 12 80 00 	movl   $0x8012fb,(%esp)
  8005de:	e8 66 00 00 00       	call   800649 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005e3:	cc                   	int3   
  8005e4:	eb fd                	jmp    8005e3 <_panic+0x53>
	...

008005e8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f8:	00 00 00 
	b.cnt = 0;
  8005fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800602:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800613:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061d:	c7 04 24 63 06 80 00 	movl   $0x800663,(%esp)
  800624:	e8 be 01 00 00       	call   8007e7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800629:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80062f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800633:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800639:	89 04 24             	mov    %eax,(%esp)
  80063c:	e8 9b fa ff ff       	call   8000dc <sys_cputs>

	return b.cnt;
}
  800641:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800647:	c9                   	leave  
  800648:	c3                   	ret    

00800649 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80064f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800652:	89 44 24 04          	mov    %eax,0x4(%esp)
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 04 24             	mov    %eax,(%esp)
  80065c:	e8 87 ff ff ff       	call   8005e8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800661:	c9                   	leave  
  800662:	c3                   	ret    

00800663 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800663:	55                   	push   %ebp
  800664:	89 e5                	mov    %esp,%ebp
  800666:	53                   	push   %ebx
  800667:	83 ec 14             	sub    $0x14,%esp
  80066a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80066d:	8b 03                	mov    (%ebx),%eax
  80066f:	8b 55 08             	mov    0x8(%ebp),%edx
  800672:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800676:	83 c0 01             	add    $0x1,%eax
  800679:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80067b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800680:	75 19                	jne    80069b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800682:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800689:	00 
  80068a:	8d 43 08             	lea    0x8(%ebx),%eax
  80068d:	89 04 24             	mov    %eax,(%esp)
  800690:	e8 47 fa ff ff       	call   8000dc <sys_cputs>
		b->idx = 0;
  800695:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80069b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80069f:	83 c4 14             	add    $0x14,%esp
  8006a2:	5b                   	pop    %ebx
  8006a3:	5d                   	pop    %ebp
  8006a4:	c3                   	ret    
  8006a5:	00 00                	add    %al,(%eax)
	...

008006a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	57                   	push   %edi
  8006ac:	56                   	push   %esi
  8006ad:	53                   	push   %ebx
  8006ae:	83 ec 4c             	sub    $0x4c,%esp
  8006b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b4:	89 d6                	mov    %edx,%esi
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006c8:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d3:	39 d1                	cmp    %edx,%ecx
  8006d5:	72 07                	jb     8006de <printnum+0x36>
  8006d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006da:	39 d0                	cmp    %edx,%eax
  8006dc:	77 69                	ja     800747 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006de:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8006e2:	83 eb 01             	sub    $0x1,%ebx
  8006e5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8006f1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8006f5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8006f8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8006fb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800702:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800709:	00 
  80070a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80070d:	89 04 24             	mov    %eax,(%esp)
  800710:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800713:	89 54 24 04          	mov    %edx,0x4(%esp)
  800717:	e8 14 09 00 00       	call   801030 <__udivdi3>
  80071c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80071f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800722:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800726:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80072a:	89 04 24             	mov    %eax,(%esp)
  80072d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800731:	89 f2                	mov    %esi,%edx
  800733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800736:	e8 6d ff ff ff       	call   8006a8 <printnum>
  80073b:	eb 11                	jmp    80074e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80073d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800741:	89 3c 24             	mov    %edi,(%esp)
  800744:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800747:	83 eb 01             	sub    $0x1,%ebx
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	7f ef                	jg     80073d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80074e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800752:	8b 74 24 04          	mov    0x4(%esp),%esi
  800756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800759:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800764:	00 
  800765:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800768:	89 14 24             	mov    %edx,(%esp)
  80076b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80076e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800772:	e8 e9 09 00 00       	call   801160 <__umoddi3>
  800777:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077b:	0f be 80 fd 12 80 00 	movsbl 0x8012fd(%eax),%eax
  800782:	89 04 24             	mov    %eax,(%esp)
  800785:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800788:	83 c4 4c             	add    $0x4c,%esp
  80078b:	5b                   	pop    %ebx
  80078c:	5e                   	pop    %esi
  80078d:	5f                   	pop    %edi
  80078e:	5d                   	pop    %ebp
  80078f:	c3                   	ret    

00800790 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800793:	83 fa 01             	cmp    $0x1,%edx
  800796:	7e 0e                	jle    8007a6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800798:	8b 10                	mov    (%eax),%edx
  80079a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80079d:	89 08                	mov    %ecx,(%eax)
  80079f:	8b 02                	mov    (%edx),%eax
  8007a1:	8b 52 04             	mov    0x4(%edx),%edx
  8007a4:	eb 22                	jmp    8007c8 <getuint+0x38>
	else if (lflag)
  8007a6:	85 d2                	test   %edx,%edx
  8007a8:	74 10                	je     8007ba <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007aa:	8b 10                	mov    (%eax),%edx
  8007ac:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007af:	89 08                	mov    %ecx,(%eax)
  8007b1:	8b 02                	mov    (%edx),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b8:	eb 0e                	jmp    8007c8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007ba:	8b 10                	mov    (%eax),%edx
  8007bc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007bf:	89 08                	mov    %ecx,(%eax)
  8007c1:	8b 02                	mov    (%edx),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007d4:	8b 10                	mov    (%eax),%edx
  8007d6:	3b 50 04             	cmp    0x4(%eax),%edx
  8007d9:	73 0a                	jae    8007e5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	88 0a                	mov    %cl,(%edx)
  8007e0:	83 c2 01             	add    $0x1,%edx
  8007e3:	89 10                	mov    %edx,(%eax)
}
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	57                   	push   %edi
  8007eb:	56                   	push   %esi
  8007ec:	53                   	push   %ebx
  8007ed:	83 ec 4c             	sub    $0x4c,%esp
  8007f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8007f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f9:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800800:	eb 11                	jmp    800813 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800802:	85 c0                	test   %eax,%eax
  800804:	0f 84 b6 03 00 00    	je     800bc0 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80080a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080e:	89 04 24             	mov    %eax,(%esp)
  800811:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800813:	0f b6 03             	movzbl (%ebx),%eax
  800816:	83 c3 01             	add    $0x1,%ebx
  800819:	83 f8 25             	cmp    $0x25,%eax
  80081c:	75 e4                	jne    800802 <vprintfmt+0x1b>
  80081e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800822:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800829:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800837:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80083f:	eb 06                	jmp    800847 <vprintfmt+0x60>
  800841:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800845:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800847:	0f b6 0b             	movzbl (%ebx),%ecx
  80084a:	0f b6 c1             	movzbl %cl,%eax
  80084d:	8d 53 01             	lea    0x1(%ebx),%edx
  800850:	83 e9 23             	sub    $0x23,%ecx
  800853:	80 f9 55             	cmp    $0x55,%cl
  800856:	0f 87 47 03 00 00    	ja     800ba3 <vprintfmt+0x3bc>
  80085c:	0f b6 c9             	movzbl %cl,%ecx
  80085f:	ff 24 8d 40 14 80 00 	jmp    *0x801440(,%ecx,4)
  800866:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80086a:	eb d9                	jmp    800845 <vprintfmt+0x5e>
  80086c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800873:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800878:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80087b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80087f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800882:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800885:	83 fb 09             	cmp    $0x9,%ebx
  800888:	77 30                	ja     8008ba <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80088d:	eb e9                	jmp    800878 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 48 04             	lea    0x4(%eax),%ecx
  800895:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  80089d:	eb 1e                	jmp    8008bd <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80089f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008af:	eb 94                	jmp    800845 <vprintfmt+0x5e>
  8008b1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008b8:	eb 8b                	jmp    800845 <vprintfmt+0x5e>
  8008ba:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c1:	79 82                	jns    800845 <vprintfmt+0x5e>
  8008c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008cc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8008cf:	e9 71 ff ff ff       	jmp    800845 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008d8:	e9 68 ff ff ff       	jmp    800845 <vprintfmt+0x5e>
  8008dd:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 50 04             	lea    0x4(%eax),%edx
  8008e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	89 04 24             	mov    %eax,(%esp)
  8008f2:	ff d7                	call   *%edi
  8008f4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8008f7:	e9 17 ff ff ff       	jmp    800813 <vprintfmt+0x2c>
  8008fc:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	89 55 14             	mov    %edx,0x14(%ebp)
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	89 c2                	mov    %eax,%edx
  80090c:	c1 fa 1f             	sar    $0x1f,%edx
  80090f:	31 d0                	xor    %edx,%eax
  800911:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800913:	83 f8 11             	cmp    $0x11,%eax
  800916:	7f 0b                	jg     800923 <vprintfmt+0x13c>
  800918:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  80091f:	85 d2                	test   %edx,%edx
  800921:	75 20                	jne    800943 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800923:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800927:	c7 44 24 08 0e 13 80 	movl   $0x80130e,0x8(%esp)
  80092e:	00 
  80092f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800933:	89 3c 24             	mov    %edi,(%esp)
  800936:	e8 0d 03 00 00       	call   800c48 <printfmt>
  80093b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80093e:	e9 d0 fe ff ff       	jmp    800813 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800943:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800947:	c7 44 24 08 17 13 80 	movl   $0x801317,0x8(%esp)
  80094e:	00 
  80094f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800953:	89 3c 24             	mov    %edi,(%esp)
  800956:	e8 ed 02 00 00       	call   800c48 <printfmt>
  80095b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80095e:	e9 b0 fe ff ff       	jmp    800813 <vprintfmt+0x2c>
  800963:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800966:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80096c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8d 50 04             	lea    0x4(%eax),%edx
  800975:	89 55 14             	mov    %edx,0x14(%ebp)
  800978:	8b 18                	mov    (%eax),%ebx
  80097a:	85 db                	test   %ebx,%ebx
  80097c:	b8 1a 13 80 00       	mov    $0x80131a,%eax
  800981:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800984:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800988:	7e 76                	jle    800a00 <vprintfmt+0x219>
  80098a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80098e:	74 7a                	je     800a0a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800990:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800994:	89 1c 24             	mov    %ebx,(%esp)
  800997:	e8 ec 02 00 00       	call   800c88 <strnlen>
  80099c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80099f:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8009a1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009a8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009ab:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ad:	eb 0f                	jmp    8009be <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b6:	89 04 24             	mov    %eax,(%esp)
  8009b9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bb:	83 eb 01             	sub    $0x1,%ebx
  8009be:	85 db                	test   %ebx,%ebx
  8009c0:	7f ed                	jg     8009af <vprintfmt+0x1c8>
  8009c2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8009c5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009cb:	89 f7                	mov    %esi,%edi
  8009cd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8009d0:	eb 40                	jmp    800a12 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009d6:	74 18                	je     8009f0 <vprintfmt+0x209>
  8009d8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8009db:	83 fa 5e             	cmp    $0x5e,%edx
  8009de:	76 10                	jbe    8009f0 <vprintfmt+0x209>
					putch('?', putdat);
  8009e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009eb:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009ee:	eb 0a                	jmp    8009fa <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8009f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f4:	89 04 24             	mov    %eax,(%esp)
  8009f7:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fa:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8009fe:	eb 12                	jmp    800a12 <vprintfmt+0x22b>
  800a00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a03:	89 f7                	mov    %esi,%edi
  800a05:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a08:	eb 08                	jmp    800a12 <vprintfmt+0x22b>
  800a0a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a0d:	89 f7                	mov    %esi,%edi
  800a0f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a12:	0f be 03             	movsbl (%ebx),%eax
  800a15:	83 c3 01             	add    $0x1,%ebx
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	74 25                	je     800a41 <vprintfmt+0x25a>
  800a1c:	85 f6                	test   %esi,%esi
  800a1e:	78 b2                	js     8009d2 <vprintfmt+0x1eb>
  800a20:	83 ee 01             	sub    $0x1,%esi
  800a23:	79 ad                	jns    8009d2 <vprintfmt+0x1eb>
  800a25:	89 fe                	mov    %edi,%esi
  800a27:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a2d:	eb 1a                	jmp    800a49 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a33:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a3a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3c:	83 eb 01             	sub    $0x1,%ebx
  800a3f:	eb 08                	jmp    800a49 <vprintfmt+0x262>
  800a41:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a44:	89 fe                	mov    %edi,%esi
  800a46:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a49:	85 db                	test   %ebx,%ebx
  800a4b:	7f e2                	jg     800a2f <vprintfmt+0x248>
  800a4d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a50:	e9 be fd ff ff       	jmp    800813 <vprintfmt+0x2c>
  800a55:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a58:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a5b:	83 f9 01             	cmp    $0x1,%ecx
  800a5e:	7e 16                	jle    800a76 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	8d 50 08             	lea    0x8(%eax),%edx
  800a66:	89 55 14             	mov    %edx,0x14(%ebp)
  800a69:	8b 10                	mov    (%eax),%edx
  800a6b:	8b 48 04             	mov    0x4(%eax),%ecx
  800a6e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800a71:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a74:	eb 32                	jmp    800aa8 <vprintfmt+0x2c1>
	else if (lflag)
  800a76:	85 c9                	test   %ecx,%ecx
  800a78:	74 18                	je     800a92 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	8d 50 04             	lea    0x4(%eax),%edx
  800a80:	89 55 14             	mov    %edx,0x14(%ebp)
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a88:	89 c1                	mov    %eax,%ecx
  800a8a:	c1 f9 1f             	sar    $0x1f,%ecx
  800a8d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a90:	eb 16                	jmp    800aa8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	8d 50 04             	lea    0x4(%eax),%edx
  800a98:	89 55 14             	mov    %edx,0x14(%ebp)
  800a9b:	8b 00                	mov    (%eax),%eax
  800a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa0:	89 c2                	mov    %eax,%edx
  800aa2:	c1 fa 1f             	sar    $0x1f,%edx
  800aa5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aa8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800aab:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800aae:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ab3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ab7:	0f 89 a7 00 00 00    	jns    800b64 <vprintfmt+0x37d>
				putch('-', putdat);
  800abd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ac1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ac8:	ff d7                	call   *%edi
				num = -(long long) num;
  800aca:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800acd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ad0:	f7 d9                	neg    %ecx
  800ad2:	83 d3 00             	adc    $0x0,%ebx
  800ad5:	f7 db                	neg    %ebx
  800ad7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800adc:	e9 83 00 00 00       	jmp    800b64 <vprintfmt+0x37d>
  800ae1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800ae4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ae7:	89 ca                	mov    %ecx,%edx
  800ae9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aec:	e8 9f fc ff ff       	call   800790 <getuint>
  800af1:	89 c1                	mov    %eax,%ecx
  800af3:	89 d3                	mov    %edx,%ebx
  800af5:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800afa:	eb 68                	jmp    800b64 <vprintfmt+0x37d>
  800afc:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800aff:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b02:	89 ca                	mov    %ecx,%edx
  800b04:	8d 45 14             	lea    0x14(%ebp),%eax
  800b07:	e8 84 fc ff ff       	call   800790 <getuint>
  800b0c:	89 c1                	mov    %eax,%ecx
  800b0e:	89 d3                	mov    %edx,%ebx
  800b10:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b15:	eb 4d                	jmp    800b64 <vprintfmt+0x37d>
  800b17:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b1a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b1e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b25:	ff d7                	call   *%edi
			putch('x', putdat);
  800b27:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b2b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b32:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	8d 50 04             	lea    0x4(%eax),%edx
  800b3a:	89 55 14             	mov    %edx,0x14(%ebp)
  800b3d:	8b 08                	mov    (%eax),%ecx
  800b3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b44:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b49:	eb 19                	jmp    800b64 <vprintfmt+0x37d>
  800b4b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b4e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b51:	89 ca                	mov    %ecx,%edx
  800b53:	8d 45 14             	lea    0x14(%ebp),%eax
  800b56:	e8 35 fc ff ff       	call   800790 <getuint>
  800b5b:	89 c1                	mov    %eax,%ecx
  800b5d:	89 d3                	mov    %edx,%ebx
  800b5f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b64:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800b68:	89 54 24 10          	mov    %edx,0x10(%esp)
  800b6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b6f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b77:	89 0c 24             	mov    %ecx,(%esp)
  800b7a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b7e:	89 f2                	mov    %esi,%edx
  800b80:	89 f8                	mov    %edi,%eax
  800b82:	e8 21 fb ff ff       	call   8006a8 <printnum>
  800b87:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b8a:	e9 84 fc ff ff       	jmp    800813 <vprintfmt+0x2c>
  800b8f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b92:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b96:	89 04 24             	mov    %eax,(%esp)
  800b99:	ff d7                	call   *%edi
  800b9b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b9e:	e9 70 fc ff ff       	jmp    800813 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bae:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800bb3:	80 38 25             	cmpb   $0x25,(%eax)
  800bb6:	0f 84 57 fc ff ff    	je     800813 <vprintfmt+0x2c>
  800bbc:	89 c3                	mov    %eax,%ebx
  800bbe:	eb f0                	jmp    800bb0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800bc0:	83 c4 4c             	add    $0x4c,%esp
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 28             	sub    $0x28,%esp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800bd4:	85 c0                	test   %eax,%eax
  800bd6:	74 04                	je     800bdc <vsnprintf+0x14>
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	7f 07                	jg     800be3 <vsnprintf+0x1b>
  800bdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800be1:	eb 3b                	jmp    800c1e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c02:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c09:	c7 04 24 ca 07 80 00 	movl   $0x8007ca,(%esp)
  800c10:	e8 d2 fb ff ff       	call   8007e7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c18:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c26:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c30:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 04 24             	mov    %eax,(%esp)
  800c41:	e8 82 ff ff ff       	call   800bc8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c4e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c55:	8b 45 10             	mov    0x10(%ebp),%eax
  800c58:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 04 24             	mov    %eax,(%esp)
  800c69:	e8 79 fb ff ff       	call   8007e7 <vprintfmt>
	va_end(ap);
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	8b 55 08             	mov    0x8(%ebp),%edx
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7b:	eb 03                	jmp    800c80 <strlen+0x10>
		n++;
  800c7d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c84:	75 f7                	jne    800c7d <strlen+0xd>
		n++;
	return n;
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	53                   	push   %ebx
  800c8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c97:	eb 03                	jmp    800c9c <strnlen+0x14>
		n++;
  800c99:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9c:	39 c1                	cmp    %eax,%ecx
  800c9e:	74 06                	je     800ca6 <strnlen+0x1e>
  800ca0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800ca4:	75 f3                	jne    800c99 <strnlen+0x11>
		n++;
	return n;
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	53                   	push   %ebx
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cb3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cbc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cbf:	83 c2 01             	add    $0x1,%edx
  800cc2:	84 c9                	test   %cl,%cl
  800cc4:	75 f2                	jne    800cb8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cd3:	89 1c 24             	mov    %ebx,(%esp)
  800cd6:	e8 95 ff ff ff       	call   800c70 <strlen>
	strcpy(dst + len, src);
  800cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cde:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ce2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800ce5:	89 04 24             	mov    %eax,(%esp)
  800ce8:	e8 bc ff ff ff       	call   800ca9 <strcpy>
	return dst;
}
  800ced:	89 d8                	mov    %ebx,%eax
  800cef:	83 c4 08             	add    $0x8,%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	8b 75 10             	mov    0x10(%ebp),%esi
  800d03:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d08:	eb 0f                	jmp    800d19 <strncpy+0x24>
		*dst++ = *src;
  800d0a:	0f b6 19             	movzbl (%ecx),%ebx
  800d0d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d10:	80 39 01             	cmpb   $0x1,(%ecx)
  800d13:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d16:	83 c2 01             	add    $0x1,%edx
  800d19:	39 f2                	cmp    %esi,%edx
  800d1b:	72 ed                	jb     800d0a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
  800d26:	8b 75 08             	mov    0x8(%ebp),%esi
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d2f:	89 f0                	mov    %esi,%eax
  800d31:	85 d2                	test   %edx,%edx
  800d33:	75 0a                	jne    800d3f <strlcpy+0x1e>
  800d35:	eb 17                	jmp    800d4e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d37:	88 18                	mov    %bl,(%eax)
  800d39:	83 c0 01             	add    $0x1,%eax
  800d3c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3f:	83 ea 01             	sub    $0x1,%edx
  800d42:	74 07                	je     800d4b <strlcpy+0x2a>
  800d44:	0f b6 19             	movzbl (%ecx),%ebx
  800d47:	84 db                	test   %bl,%bl
  800d49:	75 ec                	jne    800d37 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800d4b:	c6 00 00             	movb   $0x0,(%eax)
  800d4e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d5d:	eb 06                	jmp    800d65 <strcmp+0x11>
		p++, q++;
  800d5f:	83 c1 01             	add    $0x1,%ecx
  800d62:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d65:	0f b6 01             	movzbl (%ecx),%eax
  800d68:	84 c0                	test   %al,%al
  800d6a:	74 04                	je     800d70 <strcmp+0x1c>
  800d6c:	3a 02                	cmp    (%edx),%al
  800d6e:	74 ef                	je     800d5f <strcmp+0xb>
  800d70:	0f b6 c0             	movzbl %al,%eax
  800d73:	0f b6 12             	movzbl (%edx),%edx
  800d76:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800d87:	eb 09                	jmp    800d92 <strncmp+0x18>
		n--, p++, q++;
  800d89:	83 ea 01             	sub    $0x1,%edx
  800d8c:	83 c0 01             	add    $0x1,%eax
  800d8f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d92:	85 d2                	test   %edx,%edx
  800d94:	75 07                	jne    800d9d <strncmp+0x23>
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9b:	eb 13                	jmp    800db0 <strncmp+0x36>
  800d9d:	0f b6 18             	movzbl (%eax),%ebx
  800da0:	84 db                	test   %bl,%bl
  800da2:	74 04                	je     800da8 <strncmp+0x2e>
  800da4:	3a 19                	cmp    (%ecx),%bl
  800da6:	74 e1                	je     800d89 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da8:	0f b6 00             	movzbl (%eax),%eax
  800dab:	0f b6 11             	movzbl (%ecx),%edx
  800dae:	29 d0                	sub    %edx,%eax
}
  800db0:	5b                   	pop    %ebx
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dbd:	eb 07                	jmp    800dc6 <strchr+0x13>
		if (*s == c)
  800dbf:	38 ca                	cmp    %cl,%dl
  800dc1:	74 0f                	je     800dd2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dc3:	83 c0 01             	add    $0x1,%eax
  800dc6:	0f b6 10             	movzbl (%eax),%edx
  800dc9:	84 d2                	test   %dl,%dl
  800dcb:	75 f2                	jne    800dbf <strchr+0xc>
  800dcd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dde:	eb 07                	jmp    800de7 <strfind+0x13>
		if (*s == c)
  800de0:	38 ca                	cmp    %cl,%dl
  800de2:	74 0a                	je     800dee <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de4:	83 c0 01             	add    $0x1,%eax
  800de7:	0f b6 10             	movzbl (%eax),%edx
  800dea:	84 d2                	test   %dl,%dl
  800dec:	75 f2                	jne    800de0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	89 1c 24             	mov    %ebx,(%esp)
  800df9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dfd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e01:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e0a:	85 c9                	test   %ecx,%ecx
  800e0c:	74 30                	je     800e3e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e0e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e14:	75 25                	jne    800e3b <memset+0x4b>
  800e16:	f6 c1 03             	test   $0x3,%cl
  800e19:	75 20                	jne    800e3b <memset+0x4b>
		c &= 0xFF;
  800e1b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e1e:	89 d3                	mov    %edx,%ebx
  800e20:	c1 e3 08             	shl    $0x8,%ebx
  800e23:	89 d6                	mov    %edx,%esi
  800e25:	c1 e6 18             	shl    $0x18,%esi
  800e28:	89 d0                	mov    %edx,%eax
  800e2a:	c1 e0 10             	shl    $0x10,%eax
  800e2d:	09 f0                	or     %esi,%eax
  800e2f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800e31:	09 d8                	or     %ebx,%eax
  800e33:	c1 e9 02             	shr    $0x2,%ecx
  800e36:	fc                   	cld    
  800e37:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e39:	eb 03                	jmp    800e3e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e3b:	fc                   	cld    
  800e3c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e3e:	89 f8                	mov    %edi,%eax
  800e40:	8b 1c 24             	mov    (%esp),%ebx
  800e43:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e47:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e4b:	89 ec                	mov    %ebp,%esp
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	89 34 24             	mov    %esi,(%esp)
  800e58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800e62:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800e65:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800e67:	39 c6                	cmp    %eax,%esi
  800e69:	73 35                	jae    800ea0 <memmove+0x51>
  800e6b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e6e:	39 d0                	cmp    %edx,%eax
  800e70:	73 2e                	jae    800ea0 <memmove+0x51>
		s += n;
		d += n;
  800e72:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e74:	f6 c2 03             	test   $0x3,%dl
  800e77:	75 1b                	jne    800e94 <memmove+0x45>
  800e79:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e7f:	75 13                	jne    800e94 <memmove+0x45>
  800e81:	f6 c1 03             	test   $0x3,%cl
  800e84:	75 0e                	jne    800e94 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800e86:	83 ef 04             	sub    $0x4,%edi
  800e89:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e8c:	c1 e9 02             	shr    $0x2,%ecx
  800e8f:	fd                   	std    
  800e90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e92:	eb 09                	jmp    800e9d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e94:	83 ef 01             	sub    $0x1,%edi
  800e97:	8d 72 ff             	lea    -0x1(%edx),%esi
  800e9a:	fd                   	std    
  800e9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e9d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9e:	eb 20                	jmp    800ec0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ea0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ea6:	75 15                	jne    800ebd <memmove+0x6e>
  800ea8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800eae:	75 0d                	jne    800ebd <memmove+0x6e>
  800eb0:	f6 c1 03             	test   $0x3,%cl
  800eb3:	75 08                	jne    800ebd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800eb5:	c1 e9 02             	shr    $0x2,%ecx
  800eb8:	fc                   	cld    
  800eb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ebb:	eb 03                	jmp    800ec0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ebd:	fc                   	cld    
  800ebe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ec0:	8b 34 24             	mov    (%esp),%esi
  800ec3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ec7:	89 ec                	mov    %ebp,%esp
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	89 04 24             	mov    %eax,(%esp)
  800ee5:	e8 65 ff ff ff       	call   800e4f <memmove>
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
  800ef2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ef5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ef8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800efb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f00:	eb 1c                	jmp    800f1e <memcmp+0x32>
		if (*s1 != *s2)
  800f02:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800f06:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800f0a:	83 c2 01             	add    $0x1,%edx
  800f0d:	83 e9 01             	sub    $0x1,%ecx
  800f10:	38 d8                	cmp    %bl,%al
  800f12:	74 0a                	je     800f1e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800f14:	0f b6 c0             	movzbl %al,%eax
  800f17:	0f b6 db             	movzbl %bl,%ebx
  800f1a:	29 d8                	sub    %ebx,%eax
  800f1c:	eb 09                	jmp    800f27 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f1e:	85 c9                	test   %ecx,%ecx
  800f20:	75 e0                	jne    800f02 <memcmp+0x16>
  800f22:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f35:	89 c2                	mov    %eax,%edx
  800f37:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f3a:	eb 07                	jmp    800f43 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3c:	38 08                	cmp    %cl,(%eax)
  800f3e:	74 07                	je     800f47 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	83 c0 01             	add    $0x1,%eax
  800f43:	39 d0                	cmp    %edx,%eax
  800f45:	72 f5                	jb     800f3c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 04             	sub    $0x4,%esp
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f58:	eb 03                	jmp    800f5d <strtol+0x14>
		s++;
  800f5a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5d:	0f b6 02             	movzbl (%edx),%eax
  800f60:	3c 20                	cmp    $0x20,%al
  800f62:	74 f6                	je     800f5a <strtol+0x11>
  800f64:	3c 09                	cmp    $0x9,%al
  800f66:	74 f2                	je     800f5a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f68:	3c 2b                	cmp    $0x2b,%al
  800f6a:	75 0c                	jne    800f78 <strtol+0x2f>
		s++;
  800f6c:	8d 52 01             	lea    0x1(%edx),%edx
  800f6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f76:	eb 15                	jmp    800f8d <strtol+0x44>
	else if (*s == '-')
  800f78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f7f:	3c 2d                	cmp    $0x2d,%al
  800f81:	75 0a                	jne    800f8d <strtol+0x44>
		s++, neg = 1;
  800f83:	8d 52 01             	lea    0x1(%edx),%edx
  800f86:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f8d:	85 db                	test   %ebx,%ebx
  800f8f:	0f 94 c0             	sete   %al
  800f92:	74 05                	je     800f99 <strtol+0x50>
  800f94:	83 fb 10             	cmp    $0x10,%ebx
  800f97:	75 15                	jne    800fae <strtol+0x65>
  800f99:	80 3a 30             	cmpb   $0x30,(%edx)
  800f9c:	75 10                	jne    800fae <strtol+0x65>
  800f9e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fa2:	75 0a                	jne    800fae <strtol+0x65>
		s += 2, base = 16;
  800fa4:	83 c2 02             	add    $0x2,%edx
  800fa7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fac:	eb 13                	jmp    800fc1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fae:	84 c0                	test   %al,%al
  800fb0:	74 0f                	je     800fc1 <strtol+0x78>
  800fb2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800fb7:	80 3a 30             	cmpb   $0x30,(%edx)
  800fba:	75 05                	jne    800fc1 <strtol+0x78>
		s++, base = 8;
  800fbc:	83 c2 01             	add    $0x1,%edx
  800fbf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc8:	0f b6 0a             	movzbl (%edx),%ecx
  800fcb:	89 cf                	mov    %ecx,%edi
  800fcd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800fd0:	80 fb 09             	cmp    $0x9,%bl
  800fd3:	77 08                	ja     800fdd <strtol+0x94>
			dig = *s - '0';
  800fd5:	0f be c9             	movsbl %cl,%ecx
  800fd8:	83 e9 30             	sub    $0x30,%ecx
  800fdb:	eb 1e                	jmp    800ffb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800fdd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800fe0:	80 fb 19             	cmp    $0x19,%bl
  800fe3:	77 08                	ja     800fed <strtol+0xa4>
			dig = *s - 'a' + 10;
  800fe5:	0f be c9             	movsbl %cl,%ecx
  800fe8:	83 e9 57             	sub    $0x57,%ecx
  800feb:	eb 0e                	jmp    800ffb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800fed:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ff0:	80 fb 19             	cmp    $0x19,%bl
  800ff3:	77 15                	ja     80100a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ff5:	0f be c9             	movsbl %cl,%ecx
  800ff8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ffb:	39 f1                	cmp    %esi,%ecx
  800ffd:	7d 0b                	jge    80100a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800fff:	83 c2 01             	add    $0x1,%edx
  801002:	0f af c6             	imul   %esi,%eax
  801005:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801008:	eb be                	jmp    800fc8 <strtol+0x7f>
  80100a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80100c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801010:	74 05                	je     801017 <strtol+0xce>
		*endptr = (char *) s;
  801012:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801015:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801017:	89 ca                	mov    %ecx,%edx
  801019:	f7 da                	neg    %edx
  80101b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80101f:	0f 45 c2             	cmovne %edx,%eax
}
  801022:	83 c4 04             	add    $0x4,%esp
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    
  80102a:	00 00                	add    %al,(%eax)
  80102c:	00 00                	add    %al,(%eax)
	...

00801030 <__udivdi3>:
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	83 ec 10             	sub    $0x10,%esp
  801038:	8b 45 14             	mov    0x14(%ebp),%eax
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	8b 75 10             	mov    0x10(%ebp),%esi
  801041:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801044:	85 c0                	test   %eax,%eax
  801046:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801049:	75 35                	jne    801080 <__udivdi3+0x50>
  80104b:	39 fe                	cmp    %edi,%esi
  80104d:	77 61                	ja     8010b0 <__udivdi3+0x80>
  80104f:	85 f6                	test   %esi,%esi
  801051:	75 0b                	jne    80105e <__udivdi3+0x2e>
  801053:	b8 01 00 00 00       	mov    $0x1,%eax
  801058:	31 d2                	xor    %edx,%edx
  80105a:	f7 f6                	div    %esi
  80105c:	89 c6                	mov    %eax,%esi
  80105e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801061:	31 d2                	xor    %edx,%edx
  801063:	89 f8                	mov    %edi,%eax
  801065:	f7 f6                	div    %esi
  801067:	89 c7                	mov    %eax,%edi
  801069:	89 c8                	mov    %ecx,%eax
  80106b:	f7 f6                	div    %esi
  80106d:	89 c1                	mov    %eax,%ecx
  80106f:	89 fa                	mov    %edi,%edx
  801071:	89 c8                	mov    %ecx,%eax
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    
  80107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801080:	39 f8                	cmp    %edi,%eax
  801082:	77 1c                	ja     8010a0 <__udivdi3+0x70>
  801084:	0f bd d0             	bsr    %eax,%edx
  801087:	83 f2 1f             	xor    $0x1f,%edx
  80108a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80108d:	75 39                	jne    8010c8 <__udivdi3+0x98>
  80108f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801092:	0f 86 a0 00 00 00    	jbe    801138 <__udivdi3+0x108>
  801098:	39 f8                	cmp    %edi,%eax
  80109a:	0f 82 98 00 00 00    	jb     801138 <__udivdi3+0x108>
  8010a0:	31 ff                	xor    %edi,%edi
  8010a2:	31 c9                	xor    %ecx,%ecx
  8010a4:	89 c8                	mov    %ecx,%eax
  8010a6:	89 fa                	mov    %edi,%edx
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    
  8010af:	90                   	nop
  8010b0:	89 d1                	mov    %edx,%ecx
  8010b2:	89 fa                	mov    %edi,%edx
  8010b4:	89 c8                	mov    %ecx,%eax
  8010b6:	31 ff                	xor    %edi,%edi
  8010b8:	f7 f6                	div    %esi
  8010ba:	89 c1                	mov    %eax,%ecx
  8010bc:	89 fa                	mov    %edi,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	5e                   	pop    %esi
  8010c4:	5f                   	pop    %edi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    
  8010c7:	90                   	nop
  8010c8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010cc:	89 f2                	mov    %esi,%edx
  8010ce:	d3 e0                	shl    %cl,%eax
  8010d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010d3:	b8 20 00 00 00       	mov    $0x20,%eax
  8010d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8010db:	89 c1                	mov    %eax,%ecx
  8010dd:	d3 ea                	shr    %cl,%edx
  8010df:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010e3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8010e6:	d3 e6                	shl    %cl,%esi
  8010e8:	89 c1                	mov    %eax,%ecx
  8010ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8010ed:	89 fe                	mov    %edi,%esi
  8010ef:	d3 ee                	shr    %cl,%esi
  8010f1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8010f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fb:	d3 e7                	shl    %cl,%edi
  8010fd:	89 c1                	mov    %eax,%ecx
  8010ff:	d3 ea                	shr    %cl,%edx
  801101:	09 d7                	or     %edx,%edi
  801103:	89 f2                	mov    %esi,%edx
  801105:	89 f8                	mov    %edi,%eax
  801107:	f7 75 ec             	divl   -0x14(%ebp)
  80110a:	89 d6                	mov    %edx,%esi
  80110c:	89 c7                	mov    %eax,%edi
  80110e:	f7 65 e8             	mull   -0x18(%ebp)
  801111:	39 d6                	cmp    %edx,%esi
  801113:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801116:	72 30                	jb     801148 <__udivdi3+0x118>
  801118:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80111f:	d3 e2                	shl    %cl,%edx
  801121:	39 c2                	cmp    %eax,%edx
  801123:	73 05                	jae    80112a <__udivdi3+0xfa>
  801125:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801128:	74 1e                	je     801148 <__udivdi3+0x118>
  80112a:	89 f9                	mov    %edi,%ecx
  80112c:	31 ff                	xor    %edi,%edi
  80112e:	e9 71 ff ff ff       	jmp    8010a4 <__udivdi3+0x74>
  801133:	90                   	nop
  801134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801138:	31 ff                	xor    %edi,%edi
  80113a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80113f:	e9 60 ff ff ff       	jmp    8010a4 <__udivdi3+0x74>
  801144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801148:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80114b:	31 ff                	xor    %edi,%edi
  80114d:	89 c8                	mov    %ecx,%eax
  80114f:	89 fa                	mov    %edi,%edx
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    
	...

00801160 <__umoddi3>:
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	83 ec 20             	sub    $0x20,%esp
  801168:	8b 55 14             	mov    0x14(%ebp),%edx
  80116b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801171:	8b 75 0c             	mov    0xc(%ebp),%esi
  801174:	85 d2                	test   %edx,%edx
  801176:	89 c8                	mov    %ecx,%eax
  801178:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80117b:	75 13                	jne    801190 <__umoddi3+0x30>
  80117d:	39 f7                	cmp    %esi,%edi
  80117f:	76 3f                	jbe    8011c0 <__umoddi3+0x60>
  801181:	89 f2                	mov    %esi,%edx
  801183:	f7 f7                	div    %edi
  801185:	89 d0                	mov    %edx,%eax
  801187:	31 d2                	xor    %edx,%edx
  801189:	83 c4 20             	add    $0x20,%esp
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    
  801190:	39 f2                	cmp    %esi,%edx
  801192:	77 4c                	ja     8011e0 <__umoddi3+0x80>
  801194:	0f bd ca             	bsr    %edx,%ecx
  801197:	83 f1 1f             	xor    $0x1f,%ecx
  80119a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80119d:	75 51                	jne    8011f0 <__umoddi3+0x90>
  80119f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8011a2:	0f 87 e0 00 00 00    	ja     801288 <__umoddi3+0x128>
  8011a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ab:	29 f8                	sub    %edi,%eax
  8011ad:	19 d6                	sbb    %edx,%esi
  8011af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b5:	89 f2                	mov    %esi,%edx
  8011b7:	83 c4 20             	add    $0x20,%esp
  8011ba:	5e                   	pop    %esi
  8011bb:	5f                   	pop    %edi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    
  8011be:	66 90                	xchg   %ax,%ax
  8011c0:	85 ff                	test   %edi,%edi
  8011c2:	75 0b                	jne    8011cf <__umoddi3+0x6f>
  8011c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c9:	31 d2                	xor    %edx,%edx
  8011cb:	f7 f7                	div    %edi
  8011cd:	89 c7                	mov    %eax,%edi
  8011cf:	89 f0                	mov    %esi,%eax
  8011d1:	31 d2                	xor    %edx,%edx
  8011d3:	f7 f7                	div    %edi
  8011d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d8:	f7 f7                	div    %edi
  8011da:	eb a9                	jmp    801185 <__umoddi3+0x25>
  8011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011e0:	89 c8                	mov    %ecx,%eax
  8011e2:	89 f2                	mov    %esi,%edx
  8011e4:	83 c4 20             	add    $0x20,%esp
  8011e7:	5e                   	pop    %esi
  8011e8:	5f                   	pop    %edi
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    
  8011eb:	90                   	nop
  8011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8011f4:	d3 e2                	shl    %cl,%edx
  8011f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f9:	ba 20 00 00 00       	mov    $0x20,%edx
  8011fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801201:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801204:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801208:	89 fa                	mov    %edi,%edx
  80120a:	d3 ea                	shr    %cl,%edx
  80120c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801210:	0b 55 f4             	or     -0xc(%ebp),%edx
  801213:	d3 e7                	shl    %cl,%edi
  801215:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801219:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80121c:	89 f2                	mov    %esi,%edx
  80121e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801221:	89 c7                	mov    %eax,%edi
  801223:	d3 ea                	shr    %cl,%edx
  801225:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	d3 e6                	shl    %cl,%esi
  801230:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801234:	d3 ea                	shr    %cl,%edx
  801236:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80123a:	09 d6                	or     %edx,%esi
  80123c:	89 f0                	mov    %esi,%eax
  80123e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801241:	d3 e7                	shl    %cl,%edi
  801243:	89 f2                	mov    %esi,%edx
  801245:	f7 75 f4             	divl   -0xc(%ebp)
  801248:	89 d6                	mov    %edx,%esi
  80124a:	f7 65 e8             	mull   -0x18(%ebp)
  80124d:	39 d6                	cmp    %edx,%esi
  80124f:	72 2b                	jb     80127c <__umoddi3+0x11c>
  801251:	39 c7                	cmp    %eax,%edi
  801253:	72 23                	jb     801278 <__umoddi3+0x118>
  801255:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801259:	29 c7                	sub    %eax,%edi
  80125b:	19 d6                	sbb    %edx,%esi
  80125d:	89 f0                	mov    %esi,%eax
  80125f:	89 f2                	mov    %esi,%edx
  801261:	d3 ef                	shr    %cl,%edi
  801263:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801267:	d3 e0                	shl    %cl,%eax
  801269:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80126d:	09 f8                	or     %edi,%eax
  80126f:	d3 ea                	shr    %cl,%edx
  801271:	83 c4 20             	add    $0x20,%esp
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    
  801278:	39 d6                	cmp    %edx,%esi
  80127a:	75 d9                	jne    801255 <__umoddi3+0xf5>
  80127c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80127f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801282:	eb d1                	jmp    801255 <__umoddi3+0xf5>
  801284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801288:	39 f2                	cmp    %esi,%edx
  80128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801290:	0f 82 12 ff ff ff    	jb     8011a8 <__umoddi3+0x48>
  801296:	e9 17 ff ff ff       	jmp    8011b2 <__umoddi3+0x52>
