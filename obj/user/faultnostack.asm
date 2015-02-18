
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 2b 00 00 00       	call   80005c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003a:	c7 44 24 04 a8 05 80 	movl   $0x8005a8,0x4(%esp)
  800041:	00 
  800042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800049:	e8 5e 02 00 00       	call   8002ac <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80004e:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800055:	00 00 00 
}
  800058:	c9                   	leave  
  800059:	c3                   	ret    
	...

0080005c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	83 ec 18             	sub    $0x18,%esp
  800062:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800065:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800068:	8b 75 08             	mov    0x8(%ebp),%esi
  80006b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80006e:	e8 a2 04 00 00       	call   800515 <sys_getenvid>
  800073:	25 ff 03 00 00       	and    $0x3ff,%eax
  800078:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007b:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800080:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800085:	85 f6                	test   %esi,%esi
  800087:	7e 07                	jle    800090 <libmain+0x34>
		binaryname = argv[0];
  800089:	8b 03                	mov    (%ebx),%eax
  80008b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800090:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800094:	89 34 24             	mov    %esi,(%esp)
  800097:	e8 98 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0b 00 00 00       	call   8000ac <exit>
}
  8000a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000a7:	89 ec                	mov    %ebp,%esp
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    
	...

008000ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b9:	e8 8b 04 00 00       	call   800549 <sys_env_destroy>
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	89 d3                	mov    %edx,%ebx
  8000df:	89 d7                	mov    %edx,%edi
  8000e1:	89 d6                	mov    %edx,%esi
  8000e3:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e5:	8b 1c 24             	mov    (%esp),%ebx
  8000e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000ec:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000f0:	89 ec                	mov    %ebp,%esp
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	89 1c 24             	mov    %ebx,(%esp)
  8000fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800101:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80010d:	8b 55 08             	mov    0x8(%ebp),%edx
  800110:	89 c3                	mov    %eax,%ebx
  800112:	89 c7                	mov    %eax,%edi
  800114:	89 c6                	mov    %eax,%esi
  800116:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800118:	8b 1c 24             	mov    (%esp),%ebx
  80011b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80011f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800123:	89 ec                	mov    %ebp,%esp
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    

00800127 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	89 1c 24             	mov    %ebx,(%esp)
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 10 00 00 00       	mov    $0x10,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80014c:	8b 1c 24             	mov    (%esp),%ebx
  80014f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800153:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800157:	89 ec                	mov    %ebp,%esp
  800159:	5d                   	pop    %ebp
  80015a:	c3                   	ret    

0080015b <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 38             	sub    $0x38,%esp
  800161:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800164:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800167:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80016a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80016f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800177:	8b 55 08             	mov    0x8(%ebp),%edx
  80017a:	89 df                	mov    %ebx,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800180:	85 c0                	test   %eax,%eax
  800182:	7e 28                	jle    8001ac <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800184:	89 44 24 10          	mov    %eax,0x10(%esp)
  800188:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80018f:	00 
  800190:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  800197:	00 
  800198:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80019f:	00 
  8001a0:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  8001a7:	e8 24 04 00 00       	call   8005d0 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  8001ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001b5:	89 ec                	mov    %ebp,%esp
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    

008001b9 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	83 ec 38             	sub    $0x38,%esp
  8001bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cd:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d8:	89 df                	mov    %ebx,%edi
  8001da:	89 de                	mov    %ebx,%esi
  8001dc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001de:	85 c0                	test   %eax,%eax
  8001e0:	7e 28                	jle    80020a <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001e6:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  800205:	e8 c6 03 00 00       	call   8005d0 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  80020a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80020d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800210:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800213:	89 ec                	mov    %ebp,%esp
  800215:	5d                   	pop    %ebp
  800216:	c3                   	ret    

00800217 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 38             	sub    $0x38,%esp
  80021d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800220:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800223:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800226:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	89 cb                	mov    %ecx,%ebx
  800235:	89 cf                	mov    %ecx,%edi
  800237:	89 ce                	mov    %ecx,%esi
  800239:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80023b:	85 c0                	test   %eax,%eax
  80023d:	7e 28                	jle    800267 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80023f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800243:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80024a:	00 
  80024b:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  800252:	00 
  800253:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80025a:	00 
  80025b:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  800262:	e8 69 03 00 00       	call   8005d0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800267:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80026a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80026d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800270:	89 ec                	mov    %ebp,%esp
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    

00800274 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	89 1c 24             	mov    %ebx,(%esp)
  80027d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800281:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800285:	be 00 00 00 00       	mov    $0x0,%esi
  80028a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80028f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800292:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80029d:	8b 1c 24             	mov    (%esp),%ebx
  8002a0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8002a8:	89 ec                	mov    %ebp,%esp
  8002aa:	5d                   	pop    %ebp
  8002ab:	c3                   	ret    

008002ac <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 38             	sub    $0x38,%esp
  8002b2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002b5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002b8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cb:	89 df                	mov    %ebx,%edi
  8002cd:	89 de                	mov    %ebx,%esi
  8002cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	7e 28                	jle    8002fd <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002d9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002e0:	00 
  8002e1:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  8002e8:	00 
  8002e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002f0:	00 
  8002f1:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  8002f8:	e8 d3 02 00 00       	call   8005d0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800300:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800303:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800306:	89 ec                	mov    %ebp,%esp
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 38             	sub    $0x38,%esp
  800310:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800313:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800316:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800319:	bb 00 00 00 00       	mov    $0x0,%ebx
  80031e:	b8 09 00 00 00       	mov    $0x9,%eax
  800323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800326:	8b 55 08             	mov    0x8(%ebp),%edx
  800329:	89 df                	mov    %ebx,%edi
  80032b:	89 de                	mov    %ebx,%esi
  80032d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80032f:	85 c0                	test   %eax,%eax
  800331:	7e 28                	jle    80035b <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800333:	89 44 24 10          	mov    %eax,0x10(%esp)
  800337:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80033e:	00 
  80033f:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  800346:	00 
  800347:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80034e:	00 
  80034f:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  800356:	e8 75 02 00 00       	call   8005d0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80035b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80035e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800361:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800364:	89 ec                	mov    %ebp,%esp
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 38             	sub    $0x38,%esp
  80036e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800371:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800374:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800377:	bb 00 00 00 00       	mov    $0x0,%ebx
  80037c:	b8 08 00 00 00       	mov    $0x8,%eax
  800381:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800384:	8b 55 08             	mov    0x8(%ebp),%edx
  800387:	89 df                	mov    %ebx,%edi
  800389:	89 de                	mov    %ebx,%esi
  80038b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80038d:	85 c0                	test   %eax,%eax
  80038f:	7e 28                	jle    8003b9 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800391:	89 44 24 10          	mov    %eax,0x10(%esp)
  800395:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80039c:	00 
  80039d:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  8003a4:	00 
  8003a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003ac:	00 
  8003ad:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  8003b4:	e8 17 02 00 00       	call   8005d0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8003b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003c2:	89 ec                	mov    %ebp,%esp
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	83 ec 38             	sub    $0x38,%esp
  8003cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003da:	b8 06 00 00 00       	mov    $0x6,%eax
  8003df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e5:	89 df                	mov    %ebx,%edi
  8003e7:	89 de                	mov    %ebx,%esi
  8003e9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	7e 28                	jle    800417 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003f3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003fa:	00 
  8003fb:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  800402:	00 
  800403:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80040a:	00 
  80040b:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  800412:	e8 b9 01 00 00       	call   8005d0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800417:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80041a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80041d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800420:	89 ec                	mov    %ebp,%esp
  800422:	5d                   	pop    %ebp
  800423:	c3                   	ret    

00800424 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 38             	sub    $0x38,%esp
  80042a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80042d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800430:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800433:	b8 05 00 00 00       	mov    $0x5,%eax
  800438:	8b 75 18             	mov    0x18(%ebp),%esi
  80043b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80043e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800441:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800444:	8b 55 08             	mov    0x8(%ebp),%edx
  800447:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800449:	85 c0                	test   %eax,%eax
  80044b:	7e 28                	jle    800475 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80044d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800451:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800458:	00 
  800459:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  800460:	00 
  800461:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800468:	00 
  800469:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  800470:	e8 5b 01 00 00       	call   8005d0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800475:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800478:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80047b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80047e:	89 ec                	mov    %ebp,%esp
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 38             	sub    $0x38,%esp
  800488:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80048b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80048e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800491:	be 00 00 00 00       	mov    $0x0,%esi
  800496:	b8 04 00 00 00       	mov    $0x4,%eax
  80049b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80049e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a4:	89 f7                	mov    %esi,%edi
  8004a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004a8:	85 c0                	test   %eax,%eax
  8004aa:	7e 28                	jle    8004d4 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004b0:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8004b7:	00 
  8004b8:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  8004bf:	00 
  8004c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004c7:	00 
  8004c8:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  8004cf:	e8 fc 00 00 00       	call   8005d0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004dd:	89 ec                	mov    %ebp,%esp
  8004df:	5d                   	pop    %ebp
  8004e0:	c3                   	ret    

008004e1 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	83 ec 0c             	sub    $0xc,%esp
  8004e7:	89 1c 24             	mov    %ebx,(%esp)
  8004ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f7:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004fc:	89 d1                	mov    %edx,%ecx
  8004fe:	89 d3                	mov    %edx,%ebx
  800500:	89 d7                	mov    %edx,%edi
  800502:	89 d6                	mov    %edx,%esi
  800504:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800506:	8b 1c 24             	mov    (%esp),%ebx
  800509:	8b 74 24 04          	mov    0x4(%esp),%esi
  80050d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800511:	89 ec                	mov    %ebp,%esp
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    

00800515 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	89 1c 24             	mov    %ebx,(%esp)
  80051e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800522:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800526:	ba 00 00 00 00       	mov    $0x0,%edx
  80052b:	b8 02 00 00 00       	mov    $0x2,%eax
  800530:	89 d1                	mov    %edx,%ecx
  800532:	89 d3                	mov    %edx,%ebx
  800534:	89 d7                	mov    %edx,%edi
  800536:	89 d6                	mov    %edx,%esi
  800538:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80053a:	8b 1c 24             	mov    (%esp),%ebx
  80053d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800541:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800545:	89 ec                	mov    %ebp,%esp
  800547:	5d                   	pop    %ebp
  800548:	c3                   	ret    

00800549 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	83 ec 38             	sub    $0x38,%esp
  80054f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800552:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800555:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800558:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055d:	b8 03 00 00 00       	mov    $0x3,%eax
  800562:	8b 55 08             	mov    0x8(%ebp),%edx
  800565:	89 cb                	mov    %ecx,%ebx
  800567:	89 cf                	mov    %ecx,%edi
  800569:	89 ce                	mov    %ecx,%esi
  80056b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80056d:	85 c0                	test   %eax,%eax
  80056f:	7e 28                	jle    800599 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800571:	89 44 24 10          	mov    %eax,0x10(%esp)
  800575:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80057c:	00 
  80057d:	c7 44 24 08 6a 13 80 	movl   $0x80136a,0x8(%esp)
  800584:	00 
  800585:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80058c:	00 
  80058d:	c7 04 24 87 13 80 00 	movl   $0x801387,(%esp)
  800594:	e8 37 00 00 00       	call   8005d0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800599:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80059c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80059f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a2:	89 ec                	mov    %ebp,%esp
  8005a4:	5d                   	pop    %ebp
  8005a5:	c3                   	ret    
	...

008005a8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8005a8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8005a9:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8005ae:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8005b0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  8005b3:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  8005b6:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  8005ba:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  8005be:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  8005c1:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  8005c4:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  8005c8:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  8005c9:	83 c4 04             	add    $0x4,%esp
	popfl ;
  8005cc:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8005cd:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8005ce:	c3                   	ret    
	...

008005d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	56                   	push   %esi
  8005d4:	53                   	push   %ebx
  8005d5:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8005d8:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005db:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8005e1:	e8 2f ff ff ff       	call   800515 <sys_getenvid>
  8005e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fc:	c7 04 24 98 13 80 00 	movl   $0x801398,(%esp)
  800603:	e8 81 00 00 00       	call   800689 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800608:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	89 04 24             	mov    %eax,(%esp)
  800612:	e8 11 00 00 00       	call   800628 <vcprintf>
	cprintf("\n");
  800617:	c7 04 24 bb 13 80 00 	movl   $0x8013bb,(%esp)
  80061e:	e8 66 00 00 00       	call   800689 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800623:	cc                   	int3   
  800624:	eb fd                	jmp    800623 <_panic+0x53>
	...

00800628 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800631:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800638:	00 00 00 
	b.cnt = 0;
  80063b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800642:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800653:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065d:	c7 04 24 a3 06 80 00 	movl   $0x8006a3,(%esp)
  800664:	e8 be 01 00 00       	call   800827 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800669:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80066f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800673:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800679:	89 04 24             	mov    %eax,(%esp)
  80067c:	e8 73 fa ff ff       	call   8000f4 <sys_cputs>

	return b.cnt;
}
  800681:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80068f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800692:	89 44 24 04          	mov    %eax,0x4(%esp)
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 04 24             	mov    %eax,(%esp)
  80069c:	e8 87 ff ff ff       	call   800628 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006a1:	c9                   	leave  
  8006a2:	c3                   	ret    

008006a3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	53                   	push   %ebx
  8006a7:	83 ec 14             	sub    $0x14,%esp
  8006aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006ad:	8b 03                	mov    (%ebx),%eax
  8006af:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006b6:	83 c0 01             	add    $0x1,%eax
  8006b9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c0:	75 19                	jne    8006db <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8006c2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006c9:	00 
  8006ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8006cd:	89 04 24             	mov    %eax,(%esp)
  8006d0:	e8 1f fa ff ff       	call   8000f4 <sys_cputs>
		b->idx = 0;
  8006d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006db:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006df:	83 c4 14             	add    $0x14,%esp
  8006e2:	5b                   	pop    %ebx
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    
  8006e5:	00 00                	add    %al,(%eax)
	...

008006e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	57                   	push   %edi
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 4c             	sub    $0x4c,%esp
  8006f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f4:	89 d6                	mov    %edx,%esi
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ff:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800708:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80070e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800713:	39 d1                	cmp    %edx,%ecx
  800715:	72 07                	jb     80071e <printnum+0x36>
  800717:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80071a:	39 d0                	cmp    %edx,%eax
  80071c:	77 69                	ja     800787 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800722:	83 eb 01             	sub    $0x1,%ebx
  800725:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800729:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800731:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800735:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800738:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80073b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80073e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800742:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800749:	00 
  80074a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80074d:	89 04 24             	mov    %eax,(%esp)
  800750:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800753:	89 54 24 04          	mov    %edx,0x4(%esp)
  800757:	e8 94 09 00 00       	call   8010f0 <__udivdi3>
  80075c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80075f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800762:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800766:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80076a:	89 04 24             	mov    %eax,(%esp)
  80076d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800771:	89 f2                	mov    %esi,%edx
  800773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800776:	e8 6d ff ff ff       	call   8006e8 <printnum>
  80077b:	eb 11                	jmp    80078e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800781:	89 3c 24             	mov    %edi,(%esp)
  800784:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800787:	83 eb 01             	sub    $0x1,%ebx
  80078a:	85 db                	test   %ebx,%ebx
  80078c:	7f ef                	jg     80077d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800792:	8b 74 24 04          	mov    0x4(%esp),%esi
  800796:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800799:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007a4:	00 
  8007a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a8:	89 14 24             	mov    %edx,(%esp)
  8007ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007b2:	e8 69 0a 00 00       	call   801220 <__umoddi3>
  8007b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007bb:	0f be 80 bd 13 80 00 	movsbl 0x8013bd(%eax),%eax
  8007c2:	89 04 24             	mov    %eax,(%esp)
  8007c5:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8007c8:	83 c4 4c             	add    $0x4c,%esp
  8007cb:	5b                   	pop    %ebx
  8007cc:	5e                   	pop    %esi
  8007cd:	5f                   	pop    %edi
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d3:	83 fa 01             	cmp    $0x1,%edx
  8007d6:	7e 0e                	jle    8007e6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007d8:	8b 10                	mov    (%eax),%edx
  8007da:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007dd:	89 08                	mov    %ecx,(%eax)
  8007df:	8b 02                	mov    (%edx),%eax
  8007e1:	8b 52 04             	mov    0x4(%edx),%edx
  8007e4:	eb 22                	jmp    800808 <getuint+0x38>
	else if (lflag)
  8007e6:	85 d2                	test   %edx,%edx
  8007e8:	74 10                	je     8007fa <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007ea:	8b 10                	mov    (%eax),%edx
  8007ec:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ef:	89 08                	mov    %ecx,(%eax)
  8007f1:	8b 02                	mov    (%edx),%eax
  8007f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f8:	eb 0e                	jmp    800808 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ff:	89 08                	mov    %ecx,(%eax)
  800801:	8b 02                	mov    (%edx),%eax
  800803:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800810:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800814:	8b 10                	mov    (%eax),%edx
  800816:	3b 50 04             	cmp    0x4(%eax),%edx
  800819:	73 0a                	jae    800825 <sprintputch+0x1b>
		*b->buf++ = ch;
  80081b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081e:	88 0a                	mov    %cl,(%edx)
  800820:	83 c2 01             	add    $0x1,%edx
  800823:	89 10                	mov    %edx,(%eax)
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	57                   	push   %edi
  80082b:	56                   	push   %esi
  80082c:	53                   	push   %ebx
  80082d:	83 ec 4c             	sub    $0x4c,%esp
  800830:	8b 7d 08             	mov    0x8(%ebp),%edi
  800833:	8b 75 0c             	mov    0xc(%ebp),%esi
  800836:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800839:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800840:	eb 11                	jmp    800853 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800842:	85 c0                	test   %eax,%eax
  800844:	0f 84 b6 03 00 00    	je     800c00 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80084a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80084e:	89 04 24             	mov    %eax,(%esp)
  800851:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800853:	0f b6 03             	movzbl (%ebx),%eax
  800856:	83 c3 01             	add    $0x1,%ebx
  800859:	83 f8 25             	cmp    $0x25,%eax
  80085c:	75 e4                	jne    800842 <vprintfmt+0x1b>
  80085e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800862:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800869:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800870:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800877:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80087f:	eb 06                	jmp    800887 <vprintfmt+0x60>
  800881:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800885:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800887:	0f b6 0b             	movzbl (%ebx),%ecx
  80088a:	0f b6 c1             	movzbl %cl,%eax
  80088d:	8d 53 01             	lea    0x1(%ebx),%edx
  800890:	83 e9 23             	sub    $0x23,%ecx
  800893:	80 f9 55             	cmp    $0x55,%cl
  800896:	0f 87 47 03 00 00    	ja     800be3 <vprintfmt+0x3bc>
  80089c:	0f b6 c9             	movzbl %cl,%ecx
  80089f:	ff 24 8d 00 15 80 00 	jmp    *0x801500(,%ecx,4)
  8008a6:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8008aa:	eb d9                	jmp    800885 <vprintfmt+0x5e>
  8008ac:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8008b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008b8:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008bb:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008bf:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8008c2:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008c5:	83 fb 09             	cmp    $0x9,%ebx
  8008c8:	77 30                	ja     8008fa <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ca:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008cd:	eb e9                	jmp    8008b8 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 48 04             	lea    0x4(%eax),%ecx
  8008d5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8008dd:	eb 1e                	jmp    8008fd <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8008df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ef:	eb 94                	jmp    800885 <vprintfmt+0x5e>
  8008f1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008f8:	eb 8b                	jmp    800885 <vprintfmt+0x5e>
  8008fa:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800901:	79 82                	jns    800885 <vprintfmt+0x5e>
  800903:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800909:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80090c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80090f:	e9 71 ff ff ff       	jmp    800885 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800914:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800918:	e9 68 ff ff ff       	jmp    800885 <vprintfmt+0x5e>
  80091d:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8d 50 04             	lea    0x4(%eax),%edx
  800926:	89 55 14             	mov    %edx,0x14(%ebp)
  800929:	89 74 24 04          	mov    %esi,0x4(%esp)
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	89 04 24             	mov    %eax,(%esp)
  800932:	ff d7                	call   *%edi
  800934:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800937:	e9 17 ff ff ff       	jmp    800853 <vprintfmt+0x2c>
  80093c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	89 55 14             	mov    %edx,0x14(%ebp)
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 c2                	mov    %eax,%edx
  80094c:	c1 fa 1f             	sar    $0x1f,%edx
  80094f:	31 d0                	xor    %edx,%eax
  800951:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800953:	83 f8 11             	cmp    $0x11,%eax
  800956:	7f 0b                	jg     800963 <vprintfmt+0x13c>
  800958:	8b 14 85 60 16 80 00 	mov    0x801660(,%eax,4),%edx
  80095f:	85 d2                	test   %edx,%edx
  800961:	75 20                	jne    800983 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800963:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800967:	c7 44 24 08 ce 13 80 	movl   $0x8013ce,0x8(%esp)
  80096e:	00 
  80096f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800973:	89 3c 24             	mov    %edi,(%esp)
  800976:	e8 0d 03 00 00       	call   800c88 <printfmt>
  80097b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80097e:	e9 d0 fe ff ff       	jmp    800853 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800983:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800987:	c7 44 24 08 d7 13 80 	movl   $0x8013d7,0x8(%esp)
  80098e:	00 
  80098f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800993:	89 3c 24             	mov    %edi,(%esp)
  800996:	e8 ed 02 00 00       	call   800c88 <printfmt>
  80099b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80099e:	e9 b0 fe ff ff       	jmp    800853 <vprintfmt+0x2c>
  8009a3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009a6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8009a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 50 04             	lea    0x4(%eax),%edx
  8009b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b8:	8b 18                	mov    (%eax),%ebx
  8009ba:	85 db                	test   %ebx,%ebx
  8009bc:	b8 da 13 80 00       	mov    $0x8013da,%eax
  8009c1:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8009c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009c8:	7e 76                	jle    800a40 <vprintfmt+0x219>
  8009ca:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8009ce:	74 7a                	je     800a4a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009d4:	89 1c 24             	mov    %ebx,(%esp)
  8009d7:	e8 ec 02 00 00       	call   800cc8 <strnlen>
  8009dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009df:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8009e1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009eb:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ed:	eb 0f                	jmp    8009fe <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f6:	89 04 24             	mov    %eax,(%esp)
  8009f9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fb:	83 eb 01             	sub    $0x1,%ebx
  8009fe:	85 db                	test   %ebx,%ebx
  800a00:	7f ed                	jg     8009ef <vprintfmt+0x1c8>
  800a02:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800a05:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a08:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a0b:	89 f7                	mov    %esi,%edi
  800a0d:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a10:	eb 40                	jmp    800a52 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a12:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a16:	74 18                	je     800a30 <vprintfmt+0x209>
  800a18:	8d 50 e0             	lea    -0x20(%eax),%edx
  800a1b:	83 fa 5e             	cmp    $0x5e,%edx
  800a1e:	76 10                	jbe    800a30 <vprintfmt+0x209>
					putch('?', putdat);
  800a20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a24:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a2b:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	eb 0a                	jmp    800a3a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800a30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a34:	89 04 24             	mov    %eax,(%esp)
  800a37:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a3e:	eb 12                	jmp    800a52 <vprintfmt+0x22b>
  800a40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a43:	89 f7                	mov    %esi,%edi
  800a45:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a48:	eb 08                	jmp    800a52 <vprintfmt+0x22b>
  800a4a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a4d:	89 f7                	mov    %esi,%edi
  800a4f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a52:	0f be 03             	movsbl (%ebx),%eax
  800a55:	83 c3 01             	add    $0x1,%ebx
  800a58:	85 c0                	test   %eax,%eax
  800a5a:	74 25                	je     800a81 <vprintfmt+0x25a>
  800a5c:	85 f6                	test   %esi,%esi
  800a5e:	78 b2                	js     800a12 <vprintfmt+0x1eb>
  800a60:	83 ee 01             	sub    $0x1,%esi
  800a63:	79 ad                	jns    800a12 <vprintfmt+0x1eb>
  800a65:	89 fe                	mov    %edi,%esi
  800a67:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a6d:	eb 1a                	jmp    800a89 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a73:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a7a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7c:	83 eb 01             	sub    $0x1,%ebx
  800a7f:	eb 08                	jmp    800a89 <vprintfmt+0x262>
  800a81:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a84:	89 fe                	mov    %edi,%esi
  800a86:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a89:	85 db                	test   %ebx,%ebx
  800a8b:	7f e2                	jg     800a6f <vprintfmt+0x248>
  800a8d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a90:	e9 be fd ff ff       	jmp    800853 <vprintfmt+0x2c>
  800a95:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a98:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a9b:	83 f9 01             	cmp    $0x1,%ecx
  800a9e:	7e 16                	jle    800ab6 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	8d 50 08             	lea    0x8(%eax),%edx
  800aa6:	89 55 14             	mov    %edx,0x14(%ebp)
  800aa9:	8b 10                	mov    (%eax),%edx
  800aab:	8b 48 04             	mov    0x4(%eax),%ecx
  800aae:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800ab1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ab4:	eb 32                	jmp    800ae8 <vprintfmt+0x2c1>
	else if (lflag)
  800ab6:	85 c9                	test   %ecx,%ecx
  800ab8:	74 18                	je     800ad2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	8d 50 04             	lea    0x4(%eax),%edx
  800ac0:	89 55 14             	mov    %edx,0x14(%ebp)
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac8:	89 c1                	mov    %eax,%ecx
  800aca:	c1 f9 1f             	sar    $0x1f,%ecx
  800acd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ad0:	eb 16                	jmp    800ae8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad5:	8d 50 04             	lea    0x4(%eax),%edx
  800ad8:	89 55 14             	mov    %edx,0x14(%ebp)
  800adb:	8b 00                	mov    (%eax),%eax
  800add:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	c1 fa 1f             	sar    $0x1f,%edx
  800ae5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800aeb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800aee:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af7:	0f 89 a7 00 00 00    	jns    800ba4 <vprintfmt+0x37d>
				putch('-', putdat);
  800afd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b01:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b08:	ff d7                	call   *%edi
				num = -(long long) num;
  800b0a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800b0d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b10:	f7 d9                	neg    %ecx
  800b12:	83 d3 00             	adc    $0x0,%ebx
  800b15:	f7 db                	neg    %ebx
  800b17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b1c:	e9 83 00 00 00       	jmp    800ba4 <vprintfmt+0x37d>
  800b21:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b24:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b27:	89 ca                	mov    %ecx,%edx
  800b29:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2c:	e8 9f fc ff ff       	call   8007d0 <getuint>
  800b31:	89 c1                	mov    %eax,%ecx
  800b33:	89 d3                	mov    %edx,%ebx
  800b35:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800b3a:	eb 68                	jmp    800ba4 <vprintfmt+0x37d>
  800b3c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b3f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b42:	89 ca                	mov    %ecx,%edx
  800b44:	8d 45 14             	lea    0x14(%ebp),%eax
  800b47:	e8 84 fc ff ff       	call   8007d0 <getuint>
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	89 d3                	mov    %edx,%ebx
  800b50:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b55:	eb 4d                	jmp    800ba4 <vprintfmt+0x37d>
  800b57:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b5e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b65:	ff d7                	call   *%edi
			putch('x', putdat);
  800b67:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b6b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b72:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b74:	8b 45 14             	mov    0x14(%ebp),%eax
  800b77:	8d 50 04             	lea    0x4(%eax),%edx
  800b7a:	89 55 14             	mov    %edx,0x14(%ebp)
  800b7d:	8b 08                	mov    (%eax),%ecx
  800b7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b84:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b89:	eb 19                	jmp    800ba4 <vprintfmt+0x37d>
  800b8b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b8e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b91:	89 ca                	mov    %ecx,%edx
  800b93:	8d 45 14             	lea    0x14(%ebp),%eax
  800b96:	e8 35 fc ff ff       	call   8007d0 <getuint>
  800b9b:	89 c1                	mov    %eax,%ecx
  800b9d:	89 d3                	mov    %edx,%ebx
  800b9f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ba4:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800ba8:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800baf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb7:	89 0c 24             	mov    %ecx,(%esp)
  800bba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bbe:	89 f2                	mov    %esi,%edx
  800bc0:	89 f8                	mov    %edi,%eax
  800bc2:	e8 21 fb ff ff       	call   8006e8 <printnum>
  800bc7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bca:	e9 84 fc ff ff       	jmp    800853 <vprintfmt+0x2c>
  800bcf:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bd2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bd6:	89 04 24             	mov    %eax,(%esp)
  800bd9:	ff d7                	call   *%edi
  800bdb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bde:	e9 70 fc ff ff       	jmp    800853 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800be3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800be7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bee:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800bf3:	80 38 25             	cmpb   $0x25,(%eax)
  800bf6:	0f 84 57 fc ff ff    	je     800853 <vprintfmt+0x2c>
  800bfc:	89 c3                	mov    %eax,%ebx
  800bfe:	eb f0                	jmp    800bf0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800c00:	83 c4 4c             	add    $0x4c,%esp
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 28             	sub    $0x28,%esp
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800c14:	85 c0                	test   %eax,%eax
  800c16:	74 04                	je     800c1c <vsnprintf+0x14>
  800c18:	85 d2                	test   %edx,%edx
  800c1a:	7f 07                	jg     800c23 <vsnprintf+0x1b>
  800c1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c21:	eb 3b                	jmp    800c5e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c26:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c34:	8b 45 14             	mov    0x14(%ebp),%eax
  800c37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c42:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c49:	c7 04 24 0a 08 80 00 	movl   $0x80080a,(%esp)
  800c50:	e8 d2 fb ff ff       	call   800827 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c58:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c66:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 04 24             	mov    %eax,(%esp)
  800c81:	e8 82 ff ff ff       	call   800c08 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c8e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c91:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c95:	8b 45 10             	mov    0x10(%ebp),%eax
  800c98:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	89 04 24             	mov    %eax,(%esp)
  800ca9:	e8 79 fb ff ff       	call   800827 <vprintfmt>
	va_end(ap);
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbb:	eb 03                	jmp    800cc0 <strlen+0x10>
		n++;
  800cbd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cc4:	75 f7                	jne    800cbd <strlen+0xd>
		n++;
	return n;
}
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	53                   	push   %ebx
  800ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd7:	eb 03                	jmp    800cdc <strnlen+0x14>
		n++;
  800cd9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdc:	39 c1                	cmp    %eax,%ecx
  800cde:	74 06                	je     800ce6 <strnlen+0x1e>
  800ce0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800ce4:	75 f3                	jne    800cd9 <strnlen+0x11>
		n++;
	return n;
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	53                   	push   %ebx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cf3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cf8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cfc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800cff:	83 c2 01             	add    $0x1,%edx
  800d02:	84 c9                	test   %cl,%cl
  800d04:	75 f2                	jne    800cf8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d06:	5b                   	pop    %ebx
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d13:	89 1c 24             	mov    %ebx,(%esp)
  800d16:	e8 95 ff ff ff       	call   800cb0 <strlen>
	strcpy(dst + len, src);
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d22:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800d25:	89 04 24             	mov    %eax,(%esp)
  800d28:	e8 bc ff ff ff       	call   800ce9 <strcpy>
	return dst;
}
  800d2d:	89 d8                	mov    %ebx,%eax
  800d2f:	83 c4 08             	add    $0x8,%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	8b 75 10             	mov    0x10(%ebp),%esi
  800d43:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d48:	eb 0f                	jmp    800d59 <strncpy+0x24>
		*dst++ = *src;
  800d4a:	0f b6 19             	movzbl (%ecx),%ebx
  800d4d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d50:	80 39 01             	cmpb   $0x1,(%ecx)
  800d53:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d56:	83 c2 01             	add    $0x1,%edx
  800d59:	39 f2                	cmp    %esi,%edx
  800d5b:	72 ed                	jb     800d4a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	8b 75 08             	mov    0x8(%ebp),%esi
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d6f:	89 f0                	mov    %esi,%eax
  800d71:	85 d2                	test   %edx,%edx
  800d73:	75 0a                	jne    800d7f <strlcpy+0x1e>
  800d75:	eb 17                	jmp    800d8e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d77:	88 18                	mov    %bl,(%eax)
  800d79:	83 c0 01             	add    $0x1,%eax
  800d7c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d7f:	83 ea 01             	sub    $0x1,%edx
  800d82:	74 07                	je     800d8b <strlcpy+0x2a>
  800d84:	0f b6 19             	movzbl (%ecx),%ebx
  800d87:	84 db                	test   %bl,%bl
  800d89:	75 ec                	jne    800d77 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800d8b:	c6 00 00             	movb   $0x0,(%eax)
  800d8e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d9d:	eb 06                	jmp    800da5 <strcmp+0x11>
		p++, q++;
  800d9f:	83 c1 01             	add    $0x1,%ecx
  800da2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da5:	0f b6 01             	movzbl (%ecx),%eax
  800da8:	84 c0                	test   %al,%al
  800daa:	74 04                	je     800db0 <strcmp+0x1c>
  800dac:	3a 02                	cmp    (%edx),%al
  800dae:	74 ef                	je     800d9f <strcmp+0xb>
  800db0:	0f b6 c0             	movzbl %al,%eax
  800db3:	0f b6 12             	movzbl (%edx),%edx
  800db6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	53                   	push   %ebx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800dc7:	eb 09                	jmp    800dd2 <strncmp+0x18>
		n--, p++, q++;
  800dc9:	83 ea 01             	sub    $0x1,%edx
  800dcc:	83 c0 01             	add    $0x1,%eax
  800dcf:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800dd2:	85 d2                	test   %edx,%edx
  800dd4:	75 07                	jne    800ddd <strncmp+0x23>
  800dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddb:	eb 13                	jmp    800df0 <strncmp+0x36>
  800ddd:	0f b6 18             	movzbl (%eax),%ebx
  800de0:	84 db                	test   %bl,%bl
  800de2:	74 04                	je     800de8 <strncmp+0x2e>
  800de4:	3a 19                	cmp    (%ecx),%bl
  800de6:	74 e1                	je     800dc9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de8:	0f b6 00             	movzbl (%eax),%eax
  800deb:	0f b6 11             	movzbl (%ecx),%edx
  800dee:	29 d0                	sub    %edx,%eax
}
  800df0:	5b                   	pop    %ebx
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dfd:	eb 07                	jmp    800e06 <strchr+0x13>
		if (*s == c)
  800dff:	38 ca                	cmp    %cl,%dl
  800e01:	74 0f                	je     800e12 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e03:	83 c0 01             	add    $0x1,%eax
  800e06:	0f b6 10             	movzbl (%eax),%edx
  800e09:	84 d2                	test   %dl,%dl
  800e0b:	75 f2                	jne    800dff <strchr+0xc>
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e1e:	eb 07                	jmp    800e27 <strfind+0x13>
		if (*s == c)
  800e20:	38 ca                	cmp    %cl,%dl
  800e22:	74 0a                	je     800e2e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e24:	83 c0 01             	add    $0x1,%eax
  800e27:	0f b6 10             	movzbl (%eax),%edx
  800e2a:	84 d2                	test   %dl,%dl
  800e2c:	75 f2                	jne    800e20 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	89 1c 24             	mov    %ebx,(%esp)
  800e39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e41:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e4a:	85 c9                	test   %ecx,%ecx
  800e4c:	74 30                	je     800e7e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e4e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e54:	75 25                	jne    800e7b <memset+0x4b>
  800e56:	f6 c1 03             	test   $0x3,%cl
  800e59:	75 20                	jne    800e7b <memset+0x4b>
		c &= 0xFF;
  800e5b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e5e:	89 d3                	mov    %edx,%ebx
  800e60:	c1 e3 08             	shl    $0x8,%ebx
  800e63:	89 d6                	mov    %edx,%esi
  800e65:	c1 e6 18             	shl    $0x18,%esi
  800e68:	89 d0                	mov    %edx,%eax
  800e6a:	c1 e0 10             	shl    $0x10,%eax
  800e6d:	09 f0                	or     %esi,%eax
  800e6f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800e71:	09 d8                	or     %ebx,%eax
  800e73:	c1 e9 02             	shr    $0x2,%ecx
  800e76:	fc                   	cld    
  800e77:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e79:	eb 03                	jmp    800e7e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e7b:	fc                   	cld    
  800e7c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e7e:	89 f8                	mov    %edi,%eax
  800e80:	8b 1c 24             	mov    (%esp),%ebx
  800e83:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e87:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e8b:	89 ec                	mov    %ebp,%esp
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    

00800e8f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	89 34 24             	mov    %esi,(%esp)
  800e98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800ea2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800ea5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800ea7:	39 c6                	cmp    %eax,%esi
  800ea9:	73 35                	jae    800ee0 <memmove+0x51>
  800eab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800eae:	39 d0                	cmp    %edx,%eax
  800eb0:	73 2e                	jae    800ee0 <memmove+0x51>
		s += n;
		d += n;
  800eb2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eb4:	f6 c2 03             	test   $0x3,%dl
  800eb7:	75 1b                	jne    800ed4 <memmove+0x45>
  800eb9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ebf:	75 13                	jne    800ed4 <memmove+0x45>
  800ec1:	f6 c1 03             	test   $0x3,%cl
  800ec4:	75 0e                	jne    800ed4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ec6:	83 ef 04             	sub    $0x4,%edi
  800ec9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ecc:	c1 e9 02             	shr    $0x2,%ecx
  800ecf:	fd                   	std    
  800ed0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed2:	eb 09                	jmp    800edd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ed4:	83 ef 01             	sub    $0x1,%edi
  800ed7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800eda:	fd                   	std    
  800edb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800edd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ede:	eb 20                	jmp    800f00 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ee0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ee6:	75 15                	jne    800efd <memmove+0x6e>
  800ee8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800eee:	75 0d                	jne    800efd <memmove+0x6e>
  800ef0:	f6 c1 03             	test   $0x3,%cl
  800ef3:	75 08                	jne    800efd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ef5:	c1 e9 02             	shr    $0x2,%ecx
  800ef8:	fc                   	cld    
  800ef9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800efb:	eb 03                	jmp    800f00 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800efd:	fc                   	cld    
  800efe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f00:	8b 34 24             	mov    (%esp),%esi
  800f03:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800f07:	89 ec                	mov    %ebp,%esp
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f11:	8b 45 10             	mov    0x10(%ebp),%eax
  800f14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	89 04 24             	mov    %eax,(%esp)
  800f25:	e8 65 ff ff ff       	call   800e8f <memmove>
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
  800f32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f3b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f40:	eb 1c                	jmp    800f5e <memcmp+0x32>
		if (*s1 != *s2)
  800f42:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800f46:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800f4a:	83 c2 01             	add    $0x1,%edx
  800f4d:	83 e9 01             	sub    $0x1,%ecx
  800f50:	38 d8                	cmp    %bl,%al
  800f52:	74 0a                	je     800f5e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800f54:	0f b6 c0             	movzbl %al,%eax
  800f57:	0f b6 db             	movzbl %bl,%ebx
  800f5a:	29 d8                	sub    %ebx,%eax
  800f5c:	eb 09                	jmp    800f67 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f5e:	85 c9                	test   %ecx,%ecx
  800f60:	75 e0                	jne    800f42 <memcmp+0x16>
  800f62:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f75:	89 c2                	mov    %eax,%edx
  800f77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f7a:	eb 07                	jmp    800f83 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f7c:	38 08                	cmp    %cl,(%eax)
  800f7e:	74 07                	je     800f87 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f80:	83 c0 01             	add    $0x1,%eax
  800f83:	39 d0                	cmp    %edx,%eax
  800f85:	72 f5                	jb     800f7c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	eb 03                	jmp    800f9d <strtol+0x14>
		s++;
  800f9a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9d:	0f b6 02             	movzbl (%edx),%eax
  800fa0:	3c 20                	cmp    $0x20,%al
  800fa2:	74 f6                	je     800f9a <strtol+0x11>
  800fa4:	3c 09                	cmp    $0x9,%al
  800fa6:	74 f2                	je     800f9a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fa8:	3c 2b                	cmp    $0x2b,%al
  800faa:	75 0c                	jne    800fb8 <strtol+0x2f>
		s++;
  800fac:	8d 52 01             	lea    0x1(%edx),%edx
  800faf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fb6:	eb 15                	jmp    800fcd <strtol+0x44>
	else if (*s == '-')
  800fb8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbf:	3c 2d                	cmp    $0x2d,%al
  800fc1:	75 0a                	jne    800fcd <strtol+0x44>
		s++, neg = 1;
  800fc3:	8d 52 01             	lea    0x1(%edx),%edx
  800fc6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcd:	85 db                	test   %ebx,%ebx
  800fcf:	0f 94 c0             	sete   %al
  800fd2:	74 05                	je     800fd9 <strtol+0x50>
  800fd4:	83 fb 10             	cmp    $0x10,%ebx
  800fd7:	75 15                	jne    800fee <strtol+0x65>
  800fd9:	80 3a 30             	cmpb   $0x30,(%edx)
  800fdc:	75 10                	jne    800fee <strtol+0x65>
  800fde:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fe2:	75 0a                	jne    800fee <strtol+0x65>
		s += 2, base = 16;
  800fe4:	83 c2 02             	add    $0x2,%edx
  800fe7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fec:	eb 13                	jmp    801001 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fee:	84 c0                	test   %al,%al
  800ff0:	74 0f                	je     801001 <strtol+0x78>
  800ff2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ff7:	80 3a 30             	cmpb   $0x30,(%edx)
  800ffa:	75 05                	jne    801001 <strtol+0x78>
		s++, base = 8;
  800ffc:	83 c2 01             	add    $0x1,%edx
  800fff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801001:	b8 00 00 00 00       	mov    $0x0,%eax
  801006:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801008:	0f b6 0a             	movzbl (%edx),%ecx
  80100b:	89 cf                	mov    %ecx,%edi
  80100d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801010:	80 fb 09             	cmp    $0x9,%bl
  801013:	77 08                	ja     80101d <strtol+0x94>
			dig = *s - '0';
  801015:	0f be c9             	movsbl %cl,%ecx
  801018:	83 e9 30             	sub    $0x30,%ecx
  80101b:	eb 1e                	jmp    80103b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  80101d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801020:	80 fb 19             	cmp    $0x19,%bl
  801023:	77 08                	ja     80102d <strtol+0xa4>
			dig = *s - 'a' + 10;
  801025:	0f be c9             	movsbl %cl,%ecx
  801028:	83 e9 57             	sub    $0x57,%ecx
  80102b:	eb 0e                	jmp    80103b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  80102d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801030:	80 fb 19             	cmp    $0x19,%bl
  801033:	77 15                	ja     80104a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801035:	0f be c9             	movsbl %cl,%ecx
  801038:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80103b:	39 f1                	cmp    %esi,%ecx
  80103d:	7d 0b                	jge    80104a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80103f:	83 c2 01             	add    $0x1,%edx
  801042:	0f af c6             	imul   %esi,%eax
  801045:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801048:	eb be                	jmp    801008 <strtol+0x7f>
  80104a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 05                	je     801057 <strtol+0xce>
		*endptr = (char *) s;
  801052:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801055:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801057:	89 ca                	mov    %ecx,%edx
  801059:	f7 da                	neg    %edx
  80105b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80105f:	0f 45 c2             	cmovne %edx,%eax
}
  801062:	83 c4 04             	add    $0x4,%esp
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    
	...

0080106c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	53                   	push   %ebx
  801070:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  801073:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  80107a:	75 5b                	jne    8010d7 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  80107c:	e8 94 f4 ff ff       	call   800515 <sys_getenvid>
  801081:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  801083:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80108a:	00 
  80108b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801092:	ee 
  801093:	89 04 24             	mov    %eax,(%esp)
  801096:	e8 e7 f3 ff ff       	call   800482 <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  80109b:	85 c0                	test   %eax,%eax
  80109d:	74 28                	je     8010c7 <set_pgfault_handler+0x5b>
  80109f:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a3:	c7 44 24 0c ef 16 80 	movl   $0x8016ef,0xc(%esp)
  8010aa:	00 
  8010ab:	c7 44 24 08 c8 16 80 	movl   $0x8016c8,0x8(%esp)
  8010b2:	00 
  8010b3:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010ba:	00 
  8010bb:	c7 04 24 e1 16 80 00 	movl   $0x8016e1,(%esp)
  8010c2:	e8 09 f5 ff ff       	call   8005d0 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8010c7:	c7 44 24 04 a8 05 80 	movl   $0x8005a8,0x4(%esp)
  8010ce:	00 
  8010cf:	89 1c 24             	mov    %ebx,(%esp)
  8010d2:	e8 d5 f1 ff ff       	call   8002ac <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	a3 08 20 80 00       	mov    %eax,0x802008
	
}
  8010df:	83 c4 24             	add    $0x24,%esp
  8010e2:	5b                   	pop    %ebx
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    
	...

008010f0 <__udivdi3>:
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	83 ec 10             	sub    $0x10,%esp
  8010f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	8b 75 10             	mov    0x10(%ebp),%esi
  801101:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801104:	85 c0                	test   %eax,%eax
  801106:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801109:	75 35                	jne    801140 <__udivdi3+0x50>
  80110b:	39 fe                	cmp    %edi,%esi
  80110d:	77 61                	ja     801170 <__udivdi3+0x80>
  80110f:	85 f6                	test   %esi,%esi
  801111:	75 0b                	jne    80111e <__udivdi3+0x2e>
  801113:	b8 01 00 00 00       	mov    $0x1,%eax
  801118:	31 d2                	xor    %edx,%edx
  80111a:	f7 f6                	div    %esi
  80111c:	89 c6                	mov    %eax,%esi
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	31 d2                	xor    %edx,%edx
  801123:	89 f8                	mov    %edi,%eax
  801125:	f7 f6                	div    %esi
  801127:	89 c7                	mov    %eax,%edi
  801129:	89 c8                	mov    %ecx,%eax
  80112b:	f7 f6                	div    %esi
  80112d:	89 c1                	mov    %eax,%ecx
  80112f:	89 fa                	mov    %edi,%edx
  801131:	89 c8                	mov    %ecx,%eax
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    
  80113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801140:	39 f8                	cmp    %edi,%eax
  801142:	77 1c                	ja     801160 <__udivdi3+0x70>
  801144:	0f bd d0             	bsr    %eax,%edx
  801147:	83 f2 1f             	xor    $0x1f,%edx
  80114a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80114d:	75 39                	jne    801188 <__udivdi3+0x98>
  80114f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801152:	0f 86 a0 00 00 00    	jbe    8011f8 <__udivdi3+0x108>
  801158:	39 f8                	cmp    %edi,%eax
  80115a:	0f 82 98 00 00 00    	jb     8011f8 <__udivdi3+0x108>
  801160:	31 ff                	xor    %edi,%edi
  801162:	31 c9                	xor    %ecx,%ecx
  801164:	89 c8                	mov    %ecx,%eax
  801166:	89 fa                	mov    %edi,%edx
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	5e                   	pop    %esi
  80116c:	5f                   	pop    %edi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    
  80116f:	90                   	nop
  801170:	89 d1                	mov    %edx,%ecx
  801172:	89 fa                	mov    %edi,%edx
  801174:	89 c8                	mov    %ecx,%eax
  801176:	31 ff                	xor    %edi,%edi
  801178:	f7 f6                	div    %esi
  80117a:	89 c1                	mov    %eax,%ecx
  80117c:	89 fa                	mov    %edi,%edx
  80117e:	89 c8                	mov    %ecx,%eax
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    
  801187:	90                   	nop
  801188:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80118c:	89 f2                	mov    %esi,%edx
  80118e:	d3 e0                	shl    %cl,%eax
  801190:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801193:	b8 20 00 00 00       	mov    $0x20,%eax
  801198:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80119b:	89 c1                	mov    %eax,%ecx
  80119d:	d3 ea                	shr    %cl,%edx
  80119f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8011a6:	d3 e6                	shl    %cl,%esi
  8011a8:	89 c1                	mov    %eax,%ecx
  8011aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8011ad:	89 fe                	mov    %edi,%esi
  8011af:	d3 ee                	shr    %cl,%esi
  8011b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011bb:	d3 e7                	shl    %cl,%edi
  8011bd:	89 c1                	mov    %eax,%ecx
  8011bf:	d3 ea                	shr    %cl,%edx
  8011c1:	09 d7                	or     %edx,%edi
  8011c3:	89 f2                	mov    %esi,%edx
  8011c5:	89 f8                	mov    %edi,%eax
  8011c7:	f7 75 ec             	divl   -0x14(%ebp)
  8011ca:	89 d6                	mov    %edx,%esi
  8011cc:	89 c7                	mov    %eax,%edi
  8011ce:	f7 65 e8             	mull   -0x18(%ebp)
  8011d1:	39 d6                	cmp    %edx,%esi
  8011d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8011d6:	72 30                	jb     801208 <__udivdi3+0x118>
  8011d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8011df:	d3 e2                	shl    %cl,%edx
  8011e1:	39 c2                	cmp    %eax,%edx
  8011e3:	73 05                	jae    8011ea <__udivdi3+0xfa>
  8011e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8011e8:	74 1e                	je     801208 <__udivdi3+0x118>
  8011ea:	89 f9                	mov    %edi,%ecx
  8011ec:	31 ff                	xor    %edi,%edi
  8011ee:	e9 71 ff ff ff       	jmp    801164 <__udivdi3+0x74>
  8011f3:	90                   	nop
  8011f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011f8:	31 ff                	xor    %edi,%edi
  8011fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8011ff:	e9 60 ff ff ff       	jmp    801164 <__udivdi3+0x74>
  801204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801208:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80120b:	31 ff                	xor    %edi,%edi
  80120d:	89 c8                	mov    %ecx,%eax
  80120f:	89 fa                	mov    %edi,%edx
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	5e                   	pop    %esi
  801215:	5f                   	pop    %edi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    
	...

00801220 <__umoddi3>:
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	83 ec 20             	sub    $0x20,%esp
  801228:	8b 55 14             	mov    0x14(%ebp),%edx
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801231:	8b 75 0c             	mov    0xc(%ebp),%esi
  801234:	85 d2                	test   %edx,%edx
  801236:	89 c8                	mov    %ecx,%eax
  801238:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80123b:	75 13                	jne    801250 <__umoddi3+0x30>
  80123d:	39 f7                	cmp    %esi,%edi
  80123f:	76 3f                	jbe    801280 <__umoddi3+0x60>
  801241:	89 f2                	mov    %esi,%edx
  801243:	f7 f7                	div    %edi
  801245:	89 d0                	mov    %edx,%eax
  801247:	31 d2                	xor    %edx,%edx
  801249:	83 c4 20             	add    $0x20,%esp
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
  801250:	39 f2                	cmp    %esi,%edx
  801252:	77 4c                	ja     8012a0 <__umoddi3+0x80>
  801254:	0f bd ca             	bsr    %edx,%ecx
  801257:	83 f1 1f             	xor    $0x1f,%ecx
  80125a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80125d:	75 51                	jne    8012b0 <__umoddi3+0x90>
  80125f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801262:	0f 87 e0 00 00 00    	ja     801348 <__umoddi3+0x128>
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	29 f8                	sub    %edi,%eax
  80126d:	19 d6                	sbb    %edx,%esi
  80126f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801275:	89 f2                	mov    %esi,%edx
  801277:	83 c4 20             	add    $0x20,%esp
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
  80127e:	66 90                	xchg   %ax,%ax
  801280:	85 ff                	test   %edi,%edi
  801282:	75 0b                	jne    80128f <__umoddi3+0x6f>
  801284:	b8 01 00 00 00       	mov    $0x1,%eax
  801289:	31 d2                	xor    %edx,%edx
  80128b:	f7 f7                	div    %edi
  80128d:	89 c7                	mov    %eax,%edi
  80128f:	89 f0                	mov    %esi,%eax
  801291:	31 d2                	xor    %edx,%edx
  801293:	f7 f7                	div    %edi
  801295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801298:	f7 f7                	div    %edi
  80129a:	eb a9                	jmp    801245 <__umoddi3+0x25>
  80129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012a0:	89 c8                	mov    %ecx,%eax
  8012a2:	89 f2                	mov    %esi,%edx
  8012a4:	83 c4 20             	add    $0x20,%esp
  8012a7:	5e                   	pop    %esi
  8012a8:	5f                   	pop    %edi
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    
  8012ab:	90                   	nop
  8012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012b4:	d3 e2                	shl    %cl,%edx
  8012b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8012be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8012c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8012c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012c8:	89 fa                	mov    %edi,%edx
  8012ca:	d3 ea                	shr    %cl,%edx
  8012cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8012d3:	d3 e7                	shl    %cl,%edi
  8012d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012dc:	89 f2                	mov    %esi,%edx
  8012de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8012e1:	89 c7                	mov    %eax,%edi
  8012e3:	d3 ea                	shr    %cl,%edx
  8012e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	d3 e6                	shl    %cl,%esi
  8012f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012f4:	d3 ea                	shr    %cl,%edx
  8012f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012fa:	09 d6                	or     %edx,%esi
  8012fc:	89 f0                	mov    %esi,%eax
  8012fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801301:	d3 e7                	shl    %cl,%edi
  801303:	89 f2                	mov    %esi,%edx
  801305:	f7 75 f4             	divl   -0xc(%ebp)
  801308:	89 d6                	mov    %edx,%esi
  80130a:	f7 65 e8             	mull   -0x18(%ebp)
  80130d:	39 d6                	cmp    %edx,%esi
  80130f:	72 2b                	jb     80133c <__umoddi3+0x11c>
  801311:	39 c7                	cmp    %eax,%edi
  801313:	72 23                	jb     801338 <__umoddi3+0x118>
  801315:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801319:	29 c7                	sub    %eax,%edi
  80131b:	19 d6                	sbb    %edx,%esi
  80131d:	89 f0                	mov    %esi,%eax
  80131f:	89 f2                	mov    %esi,%edx
  801321:	d3 ef                	shr    %cl,%edi
  801323:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801327:	d3 e0                	shl    %cl,%eax
  801329:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80132d:	09 f8                	or     %edi,%eax
  80132f:	d3 ea                	shr    %cl,%edx
  801331:	83 c4 20             	add    $0x20,%esp
  801334:	5e                   	pop    %esi
  801335:	5f                   	pop    %edi
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    
  801338:	39 d6                	cmp    %edx,%esi
  80133a:	75 d9                	jne    801315 <__umoddi3+0xf5>
  80133c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80133f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801342:	eb d1                	jmp    801315 <__umoddi3+0xf5>
  801344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801348:	39 f2                	cmp    %esi,%edx
  80134a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801350:	0f 82 12 ff ff ff    	jb     801268 <__umoddi3+0x48>
  801356:	e9 17 ff ff ff       	jmp    801272 <__umoddi3+0x52>
