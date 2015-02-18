
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 0b 00 00 00       	call   80003c <libmain>
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
	asm volatile("int $3");
  800037:	cc                   	int3   
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    
	...

0080003c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003c:	55                   	push   %ebp
  80003d:	89 e5                	mov    %esp,%ebp
  80003f:	83 ec 18             	sub    $0x18,%esp
  800042:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800045:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800048:	8b 75 08             	mov    0x8(%ebp),%esi
  80004b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80004e:	e8 a2 04 00 00       	call   8004f5 <sys_getenvid>
  800053:	25 ff 03 00 00       	and    $0x3ff,%eax
  800058:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800060:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800065:	85 f6                	test   %esi,%esi
  800067:	7e 07                	jle    800070 <libmain+0x34>
		binaryname = argv[0];
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800070:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800074:	89 34 24             	mov    %esi,(%esp)
  800077:	e8 b8 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80007c:	e8 0b 00 00 00       	call   80008c <exit>
}
  800081:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800084:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800087:	89 ec                	mov    %ebp,%esp
  800089:	5d                   	pop    %ebp
  80008a:	c3                   	ret    
	...

0080008c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800099:	e8 8b 04 00 00       	call   800529 <sys_env_destroy>
}
  80009e:	c9                   	leave  
  80009f:	c3                   	ret    

008000a0 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	89 1c 24             	mov    %ebx,(%esp)
  8000a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000ad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bb:	89 d1                	mov    %edx,%ecx
  8000bd:	89 d3                	mov    %edx,%ebx
  8000bf:	89 d7                	mov    %edx,%edi
  8000c1:	89 d6                	mov    %edx,%esi
  8000c3:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c5:	8b 1c 24             	mov    (%esp),%ebx
  8000c8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000cc:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000d0:	89 ec                	mov    %ebp,%esp
  8000d2:	5d                   	pop    %ebp
  8000d3:	c3                   	ret    

008000d4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	89 1c 24             	mov    %ebx,(%esp)
  8000dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000e1:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	89 c3                	mov    %eax,%ebx
  8000f2:	89 c7                	mov    %eax,%edi
  8000f4:	89 c6                	mov    %eax,%esi
  8000f6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f8:	8b 1c 24             	mov    (%esp),%ebx
  8000fb:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000ff:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800103:	89 ec                	mov    %ebp,%esp
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	89 1c 24             	mov    %ebx,(%esp)
  800110:	89 74 24 04          	mov    %esi,0x4(%esp)
  800114:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800118:	ba 00 00 00 00       	mov    $0x0,%edx
  80011d:	b8 10 00 00 00       	mov    $0x10,%eax
  800122:	89 d1                	mov    %edx,%ecx
  800124:	89 d3                	mov    %edx,%ebx
  800126:	89 d7                	mov    %edx,%edi
  800128:	89 d6                	mov    %edx,%esi
  80012a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80012c:	8b 1c 24             	mov    (%esp),%ebx
  80012f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800133:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800137:	89 ec                	mov    %ebp,%esp
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 38             	sub    $0x38,%esp
  800141:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800144:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800147:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80014f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800154:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800157:	8b 55 08             	mov    0x8(%ebp),%edx
  80015a:	89 df                	mov    %ebx,%edi
  80015c:	89 de                	mov    %ebx,%esi
  80015e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800160:	85 c0                	test   %eax,%eax
  800162:	7e 28                	jle    80018c <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800164:	89 44 24 10          	mov    %eax,0x10(%esp)
  800168:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80016f:	00 
  800170:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800177:	00 
  800178:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80017f:	00 
  800180:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800187:	e8 fc 03 00 00       	call   800588 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  80018c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80018f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800192:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800195:	89 ec                	mov    %ebp,%esp
  800197:	5d                   	pop    %ebp
  800198:	c3                   	ret    

00800199 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	83 ec 38             	sub    $0x38,%esp
  80019f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001a2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001a5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ad:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b8:	89 df                	mov    %ebx,%edi
  8001ba:	89 de                	mov    %ebx,%esi
  8001bc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	7e 28                	jle    8001ea <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c6:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8001cd:	00 
  8001ce:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8001d5:	00 
  8001d6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001dd:	00 
  8001de:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8001e5:	e8 9e 03 00 00       	call   800588 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8001ea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001ed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001f0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001f3:	89 ec                	mov    %ebp,%esp
  8001f5:	5d                   	pop    %ebp
  8001f6:	c3                   	ret    

008001f7 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 38             	sub    $0x38,%esp
  8001fd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800200:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800203:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800206:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800210:	8b 55 08             	mov    0x8(%ebp),%edx
  800213:	89 cb                	mov    %ecx,%ebx
  800215:	89 cf                	mov    %ecx,%edi
  800217:	89 ce                	mov    %ecx,%esi
  800219:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80021b:	85 c0                	test   %eax,%eax
  80021d:	7e 28                	jle    800247 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80021f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800223:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80022a:	00 
  80022b:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800232:	00 
  800233:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80023a:	00 
  80023b:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800242:	e8 41 03 00 00       	call   800588 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800247:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80024a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80024d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800250:	89 ec                	mov    %ebp,%esp
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    

00800254 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	89 1c 24             	mov    %ebx,(%esp)
  80025d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800261:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800265:	be 00 00 00 00       	mov    $0x0,%esi
  80026a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80026f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800272:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800278:	8b 55 08             	mov    0x8(%ebp),%edx
  80027b:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80027d:	8b 1c 24             	mov    (%esp),%ebx
  800280:	8b 74 24 04          	mov    0x4(%esp),%esi
  800284:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800288:	89 ec                	mov    %ebp,%esp
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    

0080028c <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 38             	sub    $0x38,%esp
  800292:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800295:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800298:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80029b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ab:	89 df                	mov    %ebx,%edi
  8002ad:	89 de                	mov    %ebx,%esi
  8002af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002b1:	85 c0                	test   %eax,%eax
  8002b3:	7e 28                	jle    8002dd <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002b9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002c0:	00 
  8002c1:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002d0:	00 
  8002d1:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8002d8:	e8 ab 02 00 00       	call   800588 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002e6:	89 ec                	mov    %ebp,%esp
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    

008002ea <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 38             	sub    $0x38,%esp
  8002f0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002f3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002f6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fe:	b8 09 00 00 00       	mov    $0x9,%eax
  800303:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800306:	8b 55 08             	mov    0x8(%ebp),%edx
  800309:	89 df                	mov    %ebx,%edi
  80030b:	89 de                	mov    %ebx,%esi
  80030d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80030f:	85 c0                	test   %eax,%eax
  800311:	7e 28                	jle    80033b <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800313:	89 44 24 10          	mov    %eax,0x10(%esp)
  800317:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80031e:	00 
  80031f:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800326:	00 
  800327:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80032e:	00 
  80032f:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800336:	e8 4d 02 00 00       	call   800588 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80033b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80033e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800341:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800344:	89 ec                	mov    %ebp,%esp
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 38             	sub    $0x38,%esp
  80034e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800351:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800354:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800357:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035c:	b8 08 00 00 00       	mov    $0x8,%eax
  800361:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800364:	8b 55 08             	mov    0x8(%ebp),%edx
  800367:	89 df                	mov    %ebx,%edi
  800369:	89 de                	mov    %ebx,%esi
  80036b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80036d:	85 c0                	test   %eax,%eax
  80036f:	7e 28                	jle    800399 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800371:	89 44 24 10          	mov    %eax,0x10(%esp)
  800375:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80037c:	00 
  80037d:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800384:	00 
  800385:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80038c:	00 
  80038d:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800394:	e8 ef 01 00 00       	call   800588 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800399:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80039c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80039f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003a2:	89 ec                	mov    %ebp,%esp
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 38             	sub    $0x38,%esp
  8003ac:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003af:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003b2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ba:	b8 06 00 00 00       	mov    $0x6,%eax
  8003bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c5:	89 df                	mov    %ebx,%edi
  8003c7:	89 de                	mov    %ebx,%esi
  8003c9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003cb:	85 c0                	test   %eax,%eax
  8003cd:	7e 28                	jle    8003f7 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003d3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003da:	00 
  8003db:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8003e2:	00 
  8003e3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003ea:	00 
  8003eb:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8003f2:	e8 91 01 00 00       	call   800588 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8003f7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003fa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003fd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800400:	89 ec                	mov    %ebp,%esp
  800402:	5d                   	pop    %ebp
  800403:	c3                   	ret    

00800404 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	83 ec 38             	sub    $0x38,%esp
  80040a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80040d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800410:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800413:	b8 05 00 00 00       	mov    $0x5,%eax
  800418:	8b 75 18             	mov    0x18(%ebp),%esi
  80041b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80041e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800421:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800424:	8b 55 08             	mov    0x8(%ebp),%edx
  800427:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800429:	85 c0                	test   %eax,%eax
  80042b:	7e 28                	jle    800455 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80042d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800431:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800438:	00 
  800439:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800440:	00 
  800441:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800448:	00 
  800449:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800450:	e8 33 01 00 00       	call   800588 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800455:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800458:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80045b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80045e:	89 ec                	mov    %ebp,%esp
  800460:	5d                   	pop    %ebp
  800461:	c3                   	ret    

00800462 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 38             	sub    $0x38,%esp
  800468:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80046b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80046e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800471:	be 00 00 00 00       	mov    $0x0,%esi
  800476:	b8 04 00 00 00       	mov    $0x4,%eax
  80047b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	8b 55 08             	mov    0x8(%ebp),%edx
  800484:	89 f7                	mov    %esi,%edi
  800486:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800488:	85 c0                	test   %eax,%eax
  80048a:	7e 28                	jle    8004b4 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80048c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800490:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800497:	00 
  800498:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80049f:	00 
  8004a0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004a7:	00 
  8004a8:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8004af:	e8 d4 00 00 00       	call   800588 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004b4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004b7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004ba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004bd:	89 ec                	mov    %ebp,%esp
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    

008004c1 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	89 1c 24             	mov    %ebx,(%esp)
  8004ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004dc:	89 d1                	mov    %edx,%ecx
  8004de:	89 d3                	mov    %edx,%ebx
  8004e0:	89 d7                	mov    %edx,%edi
  8004e2:	89 d6                	mov    %edx,%esi
  8004e4:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8004e6:	8b 1c 24             	mov    (%esp),%ebx
  8004e9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004ed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8004f1:	89 ec                	mov    %ebp,%esp
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 0c             	sub    $0xc,%esp
  8004fb:	89 1c 24             	mov    %ebx,(%esp)
  8004fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800502:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800506:	ba 00 00 00 00       	mov    $0x0,%edx
  80050b:	b8 02 00 00 00       	mov    $0x2,%eax
  800510:	89 d1                	mov    %edx,%ecx
  800512:	89 d3                	mov    %edx,%ebx
  800514:	89 d7                	mov    %edx,%edi
  800516:	89 d6                	mov    %edx,%esi
  800518:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80051a:	8b 1c 24             	mov    (%esp),%ebx
  80051d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800521:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800525:	89 ec                	mov    %ebp,%esp
  800527:	5d                   	pop    %ebp
  800528:	c3                   	ret    

00800529 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	83 ec 38             	sub    $0x38,%esp
  80052f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800532:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800535:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800538:	b9 00 00 00 00       	mov    $0x0,%ecx
  80053d:	b8 03 00 00 00       	mov    $0x3,%eax
  800542:	8b 55 08             	mov    0x8(%ebp),%edx
  800545:	89 cb                	mov    %ecx,%ebx
  800547:	89 cf                	mov    %ecx,%edi
  800549:	89 ce                	mov    %ecx,%esi
  80054b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80054d:	85 c0                	test   %eax,%eax
  80054f:	7e 28                	jle    800579 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800551:	89 44 24 10          	mov    %eax,0x10(%esp)
  800555:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80055c:	00 
  80055d:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800564:	00 
  800565:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80056c:	00 
  80056d:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800574:	e8 0f 00 00 00       	call   800588 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800579:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80057c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80057f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800582:	89 ec                	mov    %ebp,%esp
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    
	...

00800588 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	56                   	push   %esi
  80058c:	53                   	push   %ebx
  80058d:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800590:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800593:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  800599:	e8 57 ff ff ff       	call   8004f5 <sys_getenvid>
  80059e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b4:	c7 04 24 d8 12 80 00 	movl   $0x8012d8,(%esp)
  8005bb:	e8 81 00 00 00       	call   800641 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	e8 11 00 00 00       	call   8005e0 <vcprintf>
	cprintf("\n");
  8005cf:	c7 04 24 fb 12 80 00 	movl   $0x8012fb,(%esp)
  8005d6:	e8 66 00 00 00       	call   800641 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005db:	cc                   	int3   
  8005dc:	eb fd                	jmp    8005db <_panic+0x53>
	...

008005e0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f0:	00 00 00 
	b.cnt = 0;
  8005f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005fa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	89 44 24 08          	mov    %eax,0x8(%esp)
  80060b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800611:	89 44 24 04          	mov    %eax,0x4(%esp)
  800615:	c7 04 24 5b 06 80 00 	movl   $0x80065b,(%esp)
  80061c:	e8 be 01 00 00       	call   8007df <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800621:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800631:	89 04 24             	mov    %eax,(%esp)
  800634:	e8 9b fa ff ff       	call   8000d4 <sys_cputs>

	return b.cnt;
}
  800639:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
  800644:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800647:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80064a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	89 04 24             	mov    %eax,(%esp)
  800654:	e8 87 ff ff ff       	call   8005e0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	53                   	push   %ebx
  80065f:	83 ec 14             	sub    $0x14,%esp
  800662:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800665:	8b 03                	mov    (%ebx),%eax
  800667:	8b 55 08             	mov    0x8(%ebp),%edx
  80066a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80066e:	83 c0 01             	add    $0x1,%eax
  800671:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800673:	3d ff 00 00 00       	cmp    $0xff,%eax
  800678:	75 19                	jne    800693 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80067a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800681:	00 
  800682:	8d 43 08             	lea    0x8(%ebx),%eax
  800685:	89 04 24             	mov    %eax,(%esp)
  800688:	e8 47 fa ff ff       	call   8000d4 <sys_cputs>
		b->idx = 0;
  80068d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800693:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800697:	83 c4 14             	add    $0x14,%esp
  80069a:	5b                   	pop    %ebx
  80069b:	5d                   	pop    %ebp
  80069c:	c3                   	ret    
  80069d:	00 00                	add    %al,(%eax)
	...

008006a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	57                   	push   %edi
  8006a4:	56                   	push   %esi
  8006a5:	53                   	push   %ebx
  8006a6:	83 ec 4c             	sub    $0x4c,%esp
  8006a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ac:	89 d6                	mov    %edx,%esi
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006c0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cb:	39 d1                	cmp    %edx,%ecx
  8006cd:	72 07                	jb     8006d6 <printnum+0x36>
  8006cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006d2:	39 d0                	cmp    %edx,%eax
  8006d4:	77 69                	ja     80073f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8006da:	83 eb 01             	sub    $0x1,%ebx
  8006dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8006e9:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8006ed:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8006f0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8006f3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006f6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8006fa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800701:	00 
  800702:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80070b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80070f:	e8 1c 09 00 00       	call   801030 <__udivdi3>
  800714:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800717:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80071a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80071e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800722:	89 04 24             	mov    %eax,(%esp)
  800725:	89 54 24 04          	mov    %edx,0x4(%esp)
  800729:	89 f2                	mov    %esi,%edx
  80072b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80072e:	e8 6d ff ff ff       	call   8006a0 <printnum>
  800733:	eb 11                	jmp    800746 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800735:	89 74 24 04          	mov    %esi,0x4(%esp)
  800739:	89 3c 24             	mov    %edi,(%esp)
  80073c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80073f:	83 eb 01             	sub    $0x1,%ebx
  800742:	85 db                	test   %ebx,%ebx
  800744:	7f ef                	jg     800735 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800746:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80074e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800751:	89 44 24 08          	mov    %eax,0x8(%esp)
  800755:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80075c:	00 
  80075d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800760:	89 14 24             	mov    %edx,(%esp)
  800763:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800766:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80076a:	e8 f1 09 00 00       	call   801160 <__umoddi3>
  80076f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800773:	0f be 80 fd 12 80 00 	movsbl 0x8012fd(%eax),%eax
  80077a:	89 04 24             	mov    %eax,(%esp)
  80077d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800780:	83 c4 4c             	add    $0x4c,%esp
  800783:	5b                   	pop    %ebx
  800784:	5e                   	pop    %esi
  800785:	5f                   	pop    %edi
  800786:	5d                   	pop    %ebp
  800787:	c3                   	ret    

00800788 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80078b:	83 fa 01             	cmp    $0x1,%edx
  80078e:	7e 0e                	jle    80079e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800790:	8b 10                	mov    (%eax),%edx
  800792:	8d 4a 08             	lea    0x8(%edx),%ecx
  800795:	89 08                	mov    %ecx,(%eax)
  800797:	8b 02                	mov    (%edx),%eax
  800799:	8b 52 04             	mov    0x4(%edx),%edx
  80079c:	eb 22                	jmp    8007c0 <getuint+0x38>
	else if (lflag)
  80079e:	85 d2                	test   %edx,%edx
  8007a0:	74 10                	je     8007b2 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007a7:	89 08                	mov    %ecx,(%eax)
  8007a9:	8b 02                	mov    (%edx),%eax
  8007ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b0:	eb 0e                	jmp    8007c0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007b2:	8b 10                	mov    (%eax),%edx
  8007b4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007b7:	89 08                	mov    %ecx,(%eax)
  8007b9:	8b 02                	mov    (%edx),%eax
  8007bb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007cc:	8b 10                	mov    (%eax),%edx
  8007ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8007d1:	73 0a                	jae    8007dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8007d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d6:	88 0a                	mov    %cl,(%edx)
  8007d8:	83 c2 01             	add    $0x1,%edx
  8007db:	89 10                	mov    %edx,(%eax)
}
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	57                   	push   %edi
  8007e3:	56                   	push   %esi
  8007e4:	53                   	push   %ebx
  8007e5:	83 ec 4c             	sub    $0x4c,%esp
  8007e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8007ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f1:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8007f8:	eb 11                	jmp    80080b <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	0f 84 b6 03 00 00    	je     800bb8 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800802:	89 74 24 04          	mov    %esi,0x4(%esp)
  800806:	89 04 24             	mov    %eax,(%esp)
  800809:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080b:	0f b6 03             	movzbl (%ebx),%eax
  80080e:	83 c3 01             	add    $0x1,%ebx
  800811:	83 f8 25             	cmp    $0x25,%eax
  800814:	75 e4                	jne    8007fa <vprintfmt+0x1b>
  800816:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80081a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800821:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800828:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80082f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800834:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800837:	eb 06                	jmp    80083f <vprintfmt+0x60>
  800839:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  80083d:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80083f:	0f b6 0b             	movzbl (%ebx),%ecx
  800842:	0f b6 c1             	movzbl %cl,%eax
  800845:	8d 53 01             	lea    0x1(%ebx),%edx
  800848:	83 e9 23             	sub    $0x23,%ecx
  80084b:	80 f9 55             	cmp    $0x55,%cl
  80084e:	0f 87 47 03 00 00    	ja     800b9b <vprintfmt+0x3bc>
  800854:	0f b6 c9             	movzbl %cl,%ecx
  800857:	ff 24 8d 40 14 80 00 	jmp    *0x801440(,%ecx,4)
  80085e:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800862:	eb d9                	jmp    80083d <vprintfmt+0x5e>
  800864:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80086b:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800870:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800873:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800877:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80087a:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80087d:	83 fb 09             	cmp    $0x9,%ebx
  800880:	77 30                	ja     8008b2 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800882:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800885:	eb e9                	jmp    800870 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 48 04             	lea    0x4(%eax),%ecx
  80088d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800890:	8b 00                	mov    (%eax),%eax
  800892:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800895:	eb 1e                	jmp    8008b5 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a0:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a7:	eb 94                	jmp    80083d <vprintfmt+0x5e>
  8008a9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008b0:	eb 8b                	jmp    80083d <vprintfmt+0x5e>
  8008b2:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b9:	79 82                	jns    80083d <vprintfmt+0x5e>
  8008bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008c4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8008c7:	e9 71 ff ff ff       	jmp    80083d <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008cc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008d0:	e9 68 ff ff ff       	jmp    80083d <vprintfmt+0x5e>
  8008d5:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 50 04             	lea    0x4(%eax),%edx
  8008de:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	89 04 24             	mov    %eax,(%esp)
  8008ea:	ff d7                	call   *%edi
  8008ec:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8008ef:	e9 17 ff ff ff       	jmp    80080b <vprintfmt+0x2c>
  8008f4:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8d 50 04             	lea    0x4(%eax),%edx
  8008fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800900:	8b 00                	mov    (%eax),%eax
  800902:	89 c2                	mov    %eax,%edx
  800904:	c1 fa 1f             	sar    $0x1f,%edx
  800907:	31 d0                	xor    %edx,%eax
  800909:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80090b:	83 f8 11             	cmp    $0x11,%eax
  80090e:	7f 0b                	jg     80091b <vprintfmt+0x13c>
  800910:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  800917:	85 d2                	test   %edx,%edx
  800919:	75 20                	jne    80093b <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80091b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091f:	c7 44 24 08 0e 13 80 	movl   $0x80130e,0x8(%esp)
  800926:	00 
  800927:	89 74 24 04          	mov    %esi,0x4(%esp)
  80092b:	89 3c 24             	mov    %edi,(%esp)
  80092e:	e8 0d 03 00 00       	call   800c40 <printfmt>
  800933:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800936:	e9 d0 fe ff ff       	jmp    80080b <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80093f:	c7 44 24 08 17 13 80 	movl   $0x801317,0x8(%esp)
  800946:	00 
  800947:	89 74 24 04          	mov    %esi,0x4(%esp)
  80094b:	89 3c 24             	mov    %edi,(%esp)
  80094e:	e8 ed 02 00 00       	call   800c40 <printfmt>
  800953:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800956:	e9 b0 fe ff ff       	jmp    80080b <vprintfmt+0x2c>
  80095b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80095e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800964:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8d 50 04             	lea    0x4(%eax),%edx
  80096d:	89 55 14             	mov    %edx,0x14(%ebp)
  800970:	8b 18                	mov    (%eax),%ebx
  800972:	85 db                	test   %ebx,%ebx
  800974:	b8 1a 13 80 00       	mov    $0x80131a,%eax
  800979:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  80097c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800980:	7e 76                	jle    8009f8 <vprintfmt+0x219>
  800982:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800986:	74 7a                	je     800a02 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800988:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80098c:	89 1c 24             	mov    %ebx,(%esp)
  80098f:	e8 f4 02 00 00       	call   800c88 <strnlen>
  800994:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800997:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800999:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  80099d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009a0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009a3:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a5:	eb 0f                	jmp    8009b6 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ae:	89 04 24             	mov    %eax,(%esp)
  8009b1:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b3:	83 eb 01             	sub    $0x1,%ebx
  8009b6:	85 db                	test   %ebx,%ebx
  8009b8:	7f ed                	jg     8009a7 <vprintfmt+0x1c8>
  8009ba:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8009bd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009c0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009c3:	89 f7                	mov    %esi,%edi
  8009c5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8009c8:	eb 40                	jmp    800a0a <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009ce:	74 18                	je     8009e8 <vprintfmt+0x209>
  8009d0:	8d 50 e0             	lea    -0x20(%eax),%edx
  8009d3:	83 fa 5e             	cmp    $0x5e,%edx
  8009d6:	76 10                	jbe    8009e8 <vprintfmt+0x209>
					putch('?', putdat);
  8009d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009e3:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009e6:	eb 0a                	jmp    8009f2 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8009e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ec:	89 04 24             	mov    %eax,(%esp)
  8009ef:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8009f6:	eb 12                	jmp    800a0a <vprintfmt+0x22b>
  8009f8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009fb:	89 f7                	mov    %esi,%edi
  8009fd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a00:	eb 08                	jmp    800a0a <vprintfmt+0x22b>
  800a02:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a05:	89 f7                	mov    %esi,%edi
  800a07:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a0a:	0f be 03             	movsbl (%ebx),%eax
  800a0d:	83 c3 01             	add    $0x1,%ebx
  800a10:	85 c0                	test   %eax,%eax
  800a12:	74 25                	je     800a39 <vprintfmt+0x25a>
  800a14:	85 f6                	test   %esi,%esi
  800a16:	78 b2                	js     8009ca <vprintfmt+0x1eb>
  800a18:	83 ee 01             	sub    $0x1,%esi
  800a1b:	79 ad                	jns    8009ca <vprintfmt+0x1eb>
  800a1d:	89 fe                	mov    %edi,%esi
  800a1f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a22:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a25:	eb 1a                	jmp    800a41 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a27:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a32:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a34:	83 eb 01             	sub    $0x1,%ebx
  800a37:	eb 08                	jmp    800a41 <vprintfmt+0x262>
  800a39:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a3c:	89 fe                	mov    %edi,%esi
  800a3e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	7f e2                	jg     800a27 <vprintfmt+0x248>
  800a45:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a48:	e9 be fd ff ff       	jmp    80080b <vprintfmt+0x2c>
  800a4d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a50:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a53:	83 f9 01             	cmp    $0x1,%ecx
  800a56:	7e 16                	jle    800a6e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	8d 50 08             	lea    0x8(%eax),%edx
  800a5e:	89 55 14             	mov    %edx,0x14(%ebp)
  800a61:	8b 10                	mov    (%eax),%edx
  800a63:	8b 48 04             	mov    0x4(%eax),%ecx
  800a66:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800a69:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a6c:	eb 32                	jmp    800aa0 <vprintfmt+0x2c1>
	else if (lflag)
  800a6e:	85 c9                	test   %ecx,%ecx
  800a70:	74 18                	je     800a8a <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	8d 50 04             	lea    0x4(%eax),%edx
  800a78:	89 55 14             	mov    %edx,0x14(%ebp)
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a80:	89 c1                	mov    %eax,%ecx
  800a82:	c1 f9 1f             	sar    $0x1f,%ecx
  800a85:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a88:	eb 16                	jmp    800aa0 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	8d 50 04             	lea    0x4(%eax),%edx
  800a90:	89 55 14             	mov    %edx,0x14(%ebp)
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a98:	89 c2                	mov    %eax,%edx
  800a9a:	c1 fa 1f             	sar    $0x1f,%edx
  800a9d:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aa0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800aa3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800aa6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800aab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aaf:	0f 89 a7 00 00 00    	jns    800b5c <vprintfmt+0x37d>
				putch('-', putdat);
  800ab5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ac0:	ff d7                	call   *%edi
				num = -(long long) num;
  800ac2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800ac5:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ac8:	f7 d9                	neg    %ecx
  800aca:	83 d3 00             	adc    $0x0,%ebx
  800acd:	f7 db                	neg    %ebx
  800acf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad4:	e9 83 00 00 00       	jmp    800b5c <vprintfmt+0x37d>
  800ad9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800adc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800adf:	89 ca                	mov    %ecx,%edx
  800ae1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae4:	e8 9f fc ff ff       	call   800788 <getuint>
  800ae9:	89 c1                	mov    %eax,%ecx
  800aeb:	89 d3                	mov    %edx,%ebx
  800aed:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800af2:	eb 68                	jmp    800b5c <vprintfmt+0x37d>
  800af4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800af7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800afa:	89 ca                	mov    %ecx,%edx
  800afc:	8d 45 14             	lea    0x14(%ebp),%eax
  800aff:	e8 84 fc ff ff       	call   800788 <getuint>
  800b04:	89 c1                	mov    %eax,%ecx
  800b06:	89 d3                	mov    %edx,%ebx
  800b08:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b0d:	eb 4d                	jmp    800b5c <vprintfmt+0x37d>
  800b0f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b12:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b16:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b1d:	ff d7                	call   *%edi
			putch('x', putdat);
  800b1f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b23:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b2a:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	8d 50 04             	lea    0x4(%eax),%edx
  800b32:	89 55 14             	mov    %edx,0x14(%ebp)
  800b35:	8b 08                	mov    (%eax),%ecx
  800b37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b3c:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b41:	eb 19                	jmp    800b5c <vprintfmt+0x37d>
  800b43:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b46:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b49:	89 ca                	mov    %ecx,%edx
  800b4b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b4e:	e8 35 fc ff ff       	call   800788 <getuint>
  800b53:	89 c1                	mov    %eax,%ecx
  800b55:	89 d3                	mov    %edx,%ebx
  800b57:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5c:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800b60:	89 54 24 10          	mov    %edx,0x10(%esp)
  800b64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b67:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b6f:	89 0c 24             	mov    %ecx,(%esp)
  800b72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b76:	89 f2                	mov    %esi,%edx
  800b78:	89 f8                	mov    %edi,%eax
  800b7a:	e8 21 fb ff ff       	call   8006a0 <printnum>
  800b7f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b82:	e9 84 fc ff ff       	jmp    80080b <vprintfmt+0x2c>
  800b87:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b8a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b8e:	89 04 24             	mov    %eax,(%esp)
  800b91:	ff d7                	call   *%edi
  800b93:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b96:	e9 70 fc ff ff       	jmp    80080b <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b9f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ba6:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800bab:	80 38 25             	cmpb   $0x25,(%eax)
  800bae:	0f 84 57 fc ff ff    	je     80080b <vprintfmt+0x2c>
  800bb4:	89 c3                	mov    %eax,%ebx
  800bb6:	eb f0                	jmp    800ba8 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800bb8:	83 c4 4c             	add    $0x4c,%esp
  800bbb:	5b                   	pop    %ebx
  800bbc:	5e                   	pop    %esi
  800bbd:	5f                   	pop    %edi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 28             	sub    $0x28,%esp
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800bcc:	85 c0                	test   %eax,%eax
  800bce:	74 04                	je     800bd4 <vsnprintf+0x14>
  800bd0:	85 d2                	test   %edx,%edx
  800bd2:	7f 07                	jg     800bdb <vsnprintf+0x1b>
  800bd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd9:	eb 3b                	jmp    800c16 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bde:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bec:	8b 45 14             	mov    0x14(%ebp),%eax
  800bef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c01:	c7 04 24 c2 07 80 00 	movl   $0x8007c2,(%esp)
  800c08:	e8 d2 fb ff ff       	call   8007df <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c1e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c25:	8b 45 10             	mov    0x10(%ebp),%eax
  800c28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 04 24             	mov    %eax,(%esp)
  800c39:	e8 82 ff ff ff       	call   800bc0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c46:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c50:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 04 24             	mov    %eax,(%esp)
  800c61:	e8 79 fb ff ff       	call   8007df <vprintfmt>
	va_end(ap);
}
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    
	...

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
