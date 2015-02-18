
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	sys_cputs(hello, 1024*1024);
  80003a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  800041:	00 
  800042:	a1 00 20 80 00       	mov    0x802000,%eax
  800047:	89 04 24             	mov    %eax,(%esp)
  80004a:	e8 9d 00 00 00       	call   8000ec <sys_cputs>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    
  800051:	00 00                	add    %al,(%eax)
	...

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
  80005a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80005d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800060:	8b 75 08             	mov    0x8(%ebp),%esi
  800063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800066:	e8 a2 04 00 00       	call   80050d <sys_getenvid>
  80006b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800073:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800078:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007d:	85 f6                	test   %esi,%esi
  80007f:	7e 07                	jle    800088 <libmain+0x34>
		binaryname = argv[0];
  800081:	8b 03                	mov    (%ebx),%eax
  800083:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  800088:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 a0 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800094:	e8 0b 00 00 00       	call   8000a4 <exit>
}
  800099:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80009c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009f:	89 ec                	mov    %ebp,%esp
  8000a1:	5d                   	pop    %ebp
  8000a2:	c3                   	ret    
	...

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 8b 04 00 00       	call   800541 <sys_env_destroy>
}
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	89 1c 24             	mov    %ebx,(%esp)
  8000c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d3:	89 d1                	mov    %edx,%ecx
  8000d5:	89 d3                	mov    %edx,%ebx
  8000d7:	89 d7                	mov    %edx,%edi
  8000d9:	89 d6                	mov    %edx,%esi
  8000db:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000dd:	8b 1c 24             	mov    (%esp),%ebx
  8000e0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000e8:	89 ec                	mov    %ebp,%esp
  8000ea:	5d                   	pop    %ebp
  8000eb:	c3                   	ret    

008000ec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	89 1c 24             	mov    %ebx,(%esp)
  8000f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800105:	8b 55 08             	mov    0x8(%ebp),%edx
  800108:	89 c3                	mov    %eax,%ebx
  80010a:	89 c7                	mov    %eax,%edi
  80010c:	89 c6                	mov    %eax,%esi
  80010e:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800110:	8b 1c 24             	mov    (%esp),%ebx
  800113:	8b 74 24 04          	mov    0x4(%esp),%esi
  800117:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80011b:	89 ec                	mov    %ebp,%esp
  80011d:	5d                   	pop    %ebp
  80011e:	c3                   	ret    

0080011f <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	89 1c 24             	mov    %ebx,(%esp)
  800128:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012c:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 10 00 00 00       	mov    $0x10,%eax
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	89 d3                	mov    %edx,%ebx
  80013e:	89 d7                	mov    %edx,%edi
  800140:	89 d6                	mov    %edx,%esi
  800142:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800144:	8b 1c 24             	mov    (%esp),%ebx
  800147:	8b 74 24 04          	mov    0x4(%esp),%esi
  80014b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80014f:	89 ec                	mov    %ebp,%esp
  800151:	5d                   	pop    %ebp
  800152:	c3                   	ret    

00800153 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 38             	sub    $0x38,%esp
  800159:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80015c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80015f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800162:	bb 00 00 00 00       	mov    $0x0,%ebx
  800167:	b8 0f 00 00 00       	mov    $0xf,%eax
  80016c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016f:	8b 55 08             	mov    0x8(%ebp),%edx
  800172:	89 df                	mov    %ebx,%edi
  800174:	89 de                	mov    %ebx,%esi
  800176:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800178:	85 c0                	test   %eax,%eax
  80017a:	7e 28                	jle    8001a4 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80017c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800180:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800187:	00 
  800188:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  80018f:	00 
  800190:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800197:	00 
  800198:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  80019f:	e8 fc 03 00 00       	call   8005a0 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  8001a4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001a7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001aa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001ad:	89 ec                	mov    %ebp,%esp
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    

008001b1 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 38             	sub    $0x38,%esp
  8001b7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001ba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001bd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d0:	89 df                	mov    %ebx,%edi
  8001d2:	89 de                	mov    %ebx,%esi
  8001d4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	7e 28                	jle    800202 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001de:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8001e5:	00 
  8001e6:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001f5:	00 
  8001f6:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  8001fd:	e8 9e 03 00 00       	call   8005a0 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800202:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800205:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800208:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80020b:	89 ec                	mov    %ebp,%esp
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 38             	sub    $0x38,%esp
  800215:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800218:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80021b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80021e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800223:	b8 0d 00 00 00       	mov    $0xd,%eax
  800228:	8b 55 08             	mov    0x8(%ebp),%edx
  80022b:	89 cb                	mov    %ecx,%ebx
  80022d:	89 cf                	mov    %ecx,%edi
  80022f:	89 ce                	mov    %ecx,%esi
  800231:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800233:	85 c0                	test   %eax,%eax
  800235:	7e 28                	jle    80025f <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800237:	89 44 24 10          	mov    %eax,0x10(%esp)
  80023b:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800242:	00 
  800243:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  80024a:	00 
  80024b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800252:	00 
  800253:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  80025a:	e8 41 03 00 00       	call   8005a0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80025f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800262:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800265:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800268:	89 ec                	mov    %ebp,%esp
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	89 1c 24             	mov    %ebx,(%esp)
  800275:	89 74 24 04          	mov    %esi,0x4(%esp)
  800279:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80027d:	be 00 00 00 00       	mov    $0x0,%esi
  800282:	b8 0c 00 00 00       	mov    $0xc,%eax
  800287:	8b 7d 14             	mov    0x14(%ebp),%edi
  80028a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80028d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800295:	8b 1c 24             	mov    (%esp),%ebx
  800298:	8b 74 24 04          	mov    0x4(%esp),%esi
  80029c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8002a0:	89 ec                	mov    %ebp,%esp
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    

008002a4 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 38             	sub    $0x38,%esp
  8002aa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002ad:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c3:	89 df                	mov    %ebx,%edi
  8002c5:	89 de                	mov    %ebx,%esi
  8002c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	7e 28                	jle    8002f5 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002d1:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002d8:	00 
  8002d9:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  8002e0:	00 
  8002e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002e8:	00 
  8002e9:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  8002f0:	e8 ab 02 00 00       	call   8005a0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002fe:	89 ec                	mov    %ebp,%esp
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 38             	sub    $0x38,%esp
  800308:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80030b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80030e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800311:	bb 00 00 00 00       	mov    $0x0,%ebx
  800316:	b8 09 00 00 00       	mov    $0x9,%eax
  80031b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031e:	8b 55 08             	mov    0x8(%ebp),%edx
  800321:	89 df                	mov    %ebx,%edi
  800323:	89 de                	mov    %ebx,%esi
  800325:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800327:	85 c0                	test   %eax,%eax
  800329:	7e 28                	jle    800353 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80032b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80032f:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800336:	00 
  800337:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  80033e:	00 
  80033f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800346:	00 
  800347:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  80034e:	e8 4d 02 00 00       	call   8005a0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800353:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800356:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800359:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80035c:	89 ec                	mov    %ebp,%esp
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 38             	sub    $0x38,%esp
  800366:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800369:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80036c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80036f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800374:	b8 08 00 00 00       	mov    $0x8,%eax
  800379:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037c:	8b 55 08             	mov    0x8(%ebp),%edx
  80037f:	89 df                	mov    %ebx,%edi
  800381:	89 de                	mov    %ebx,%esi
  800383:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800385:	85 c0                	test   %eax,%eax
  800387:	7e 28                	jle    8003b1 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800389:	89 44 24 10          	mov    %eax,0x10(%esp)
  80038d:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800394:	00 
  800395:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  80039c:	00 
  80039d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003a4:	00 
  8003a5:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  8003ac:	e8 ef 01 00 00       	call   8005a0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8003b1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003b4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003ba:	89 ec                	mov    %ebp,%esp
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	83 ec 38             	sub    $0x38,%esp
  8003c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d2:	b8 06 00 00 00       	mov    $0x6,%eax
  8003d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003da:	8b 55 08             	mov    0x8(%ebp),%edx
  8003dd:	89 df                	mov    %ebx,%edi
  8003df:	89 de                	mov    %ebx,%esi
  8003e1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003e3:	85 c0                	test   %eax,%eax
  8003e5:	7e 28                	jle    80040f <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003eb:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003f2:	00 
  8003f3:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  8003fa:	00 
  8003fb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800402:	00 
  800403:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  80040a:	e8 91 01 00 00       	call   8005a0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80040f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800412:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800415:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800418:	89 ec                	mov    %ebp,%esp
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 38             	sub    $0x38,%esp
  800422:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800425:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800428:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80042b:	b8 05 00 00 00       	mov    $0x5,%eax
  800430:	8b 75 18             	mov    0x18(%ebp),%esi
  800433:	8b 7d 14             	mov    0x14(%ebp),%edi
  800436:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043c:	8b 55 08             	mov    0x8(%ebp),%edx
  80043f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800441:	85 c0                	test   %eax,%eax
  800443:	7e 28                	jle    80046d <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800445:	89 44 24 10          	mov    %eax,0x10(%esp)
  800449:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800450:	00 
  800451:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  800458:	00 
  800459:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800460:	00 
  800461:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  800468:	e8 33 01 00 00       	call   8005a0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80046d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800470:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800473:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800476:	89 ec                	mov    %ebp,%esp
  800478:	5d                   	pop    %ebp
  800479:	c3                   	ret    

0080047a <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 38             	sub    $0x38,%esp
  800480:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800483:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800486:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800489:	be 00 00 00 00       	mov    $0x0,%esi
  80048e:	b8 04 00 00 00       	mov    $0x4,%eax
  800493:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800496:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800499:	8b 55 08             	mov    0x8(%ebp),%edx
  80049c:	89 f7                	mov    %esi,%edi
  80049e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004a0:	85 c0                	test   %eax,%eax
  8004a2:	7e 28                	jle    8004cc <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004a8:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8004af:	00 
  8004b0:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  8004b7:	00 
  8004b8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004bf:	00 
  8004c0:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  8004c7:	e8 d4 00 00 00       	call   8005a0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004d5:	89 ec                	mov    %ebp,%esp
  8004d7:	5d                   	pop    %ebp
  8004d8:	c3                   	ret    

008004d9 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 0c             	sub    $0xc,%esp
  8004df:	89 1c 24             	mov    %ebx,(%esp)
  8004e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004f4:	89 d1                	mov    %edx,%ecx
  8004f6:	89 d3                	mov    %edx,%ebx
  8004f8:	89 d7                	mov    %edx,%edi
  8004fa:	89 d6                	mov    %edx,%esi
  8004fc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8004fe:	8b 1c 24             	mov    (%esp),%ebx
  800501:	8b 74 24 04          	mov    0x4(%esp),%esi
  800505:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800509:	89 ec                	mov    %ebp,%esp
  80050b:	5d                   	pop    %ebp
  80050c:	c3                   	ret    

0080050d <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 0c             	sub    $0xc,%esp
  800513:	89 1c 24             	mov    %ebx,(%esp)
  800516:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80051e:	ba 00 00 00 00       	mov    $0x0,%edx
  800523:	b8 02 00 00 00       	mov    $0x2,%eax
  800528:	89 d1                	mov    %edx,%ecx
  80052a:	89 d3                	mov    %edx,%ebx
  80052c:	89 d7                	mov    %edx,%edi
  80052e:	89 d6                	mov    %edx,%esi
  800530:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800532:	8b 1c 24             	mov    (%esp),%ebx
  800535:	8b 74 24 04          	mov    0x4(%esp),%esi
  800539:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80053d:	89 ec                	mov    %ebp,%esp
  80053f:	5d                   	pop    %ebp
  800540:	c3                   	ret    

00800541 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800541:	55                   	push   %ebp
  800542:	89 e5                	mov    %esp,%ebp
  800544:	83 ec 38             	sub    $0x38,%esp
  800547:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80054a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80054d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800550:	b9 00 00 00 00       	mov    $0x0,%ecx
  800555:	b8 03 00 00 00       	mov    $0x3,%eax
  80055a:	8b 55 08             	mov    0x8(%ebp),%edx
  80055d:	89 cb                	mov    %ecx,%ebx
  80055f:	89 cf                	mov    %ecx,%edi
  800561:	89 ce                	mov    %ecx,%esi
  800563:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800565:	85 c0                	test   %eax,%eax
  800567:	7e 28                	jle    800591 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800569:	89 44 24 10          	mov    %eax,0x10(%esp)
  80056d:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800574:	00 
  800575:	c7 44 24 08 d8 12 80 	movl   $0x8012d8,0x8(%esp)
  80057c:	00 
  80057d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800584:	00 
  800585:	c7 04 24 f5 12 80 00 	movl   $0x8012f5,(%esp)
  80058c:	e8 0f 00 00 00       	call   8005a0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800591:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800594:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800597:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80059a:	89 ec                	mov    %ebp,%esp
  80059c:	5d                   	pop    %ebp
  80059d:	c3                   	ret    
	...

008005a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	56                   	push   %esi
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8005a8:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005ab:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8005b1:	e8 57 ff ff ff       	call   80050d <sys_getenvid>
  8005b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005cc:	c7 04 24 04 13 80 00 	movl   $0x801304,(%esp)
  8005d3:	e8 81 00 00 00       	call   800659 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005df:	89 04 24             	mov    %eax,(%esp)
  8005e2:	e8 11 00 00 00       	call   8005f8 <vcprintf>
	cprintf("\n");
  8005e7:	c7 04 24 cc 12 80 00 	movl   $0x8012cc,(%esp)
  8005ee:	e8 66 00 00 00       	call   800659 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005f3:	cc                   	int3   
  8005f4:	eb fd                	jmp    8005f3 <_panic+0x53>
	...

008005f8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800601:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800608:	00 00 00 
	b.cnt = 0;
  80060b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800612:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
  800618:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062d:	c7 04 24 73 06 80 00 	movl   $0x800673,(%esp)
  800634:	e8 be 01 00 00       	call   8007f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800639:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80063f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800643:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800649:	89 04 24             	mov    %eax,(%esp)
  80064c:	e8 9b fa ff ff       	call   8000ec <sys_cputs>

	return b.cnt;
}
  800651:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80065f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800662:	89 44 24 04          	mov    %eax,0x4(%esp)
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	89 04 24             	mov    %eax,(%esp)
  80066c:	e8 87 ff ff ff       	call   8005f8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800671:	c9                   	leave  
  800672:	c3                   	ret    

00800673 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
  800676:	53                   	push   %ebx
  800677:	83 ec 14             	sub    $0x14,%esp
  80067a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80067d:	8b 03                	mov    (%ebx),%eax
  80067f:	8b 55 08             	mov    0x8(%ebp),%edx
  800682:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800686:	83 c0 01             	add    $0x1,%eax
  800689:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80068b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800690:	75 19                	jne    8006ab <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800692:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800699:	00 
  80069a:	8d 43 08             	lea    0x8(%ebx),%eax
  80069d:	89 04 24             	mov    %eax,(%esp)
  8006a0:	e8 47 fa ff ff       	call   8000ec <sys_cputs>
		b->idx = 0;
  8006a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006af:	83 c4 14             	add    $0x14,%esp
  8006b2:	5b                   	pop    %ebx
  8006b3:	5d                   	pop    %ebp
  8006b4:	c3                   	ret    
  8006b5:	00 00                	add    %al,(%eax)
	...

008006b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	57                   	push   %edi
  8006bc:	56                   	push   %esi
  8006bd:	53                   	push   %ebx
  8006be:	83 ec 4c             	sub    $0x4c,%esp
  8006c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c4:	89 d6                	mov    %edx,%esi
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cf:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006d8:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e3:	39 d1                	cmp    %edx,%ecx
  8006e5:	72 07                	jb     8006ee <printnum+0x36>
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	39 d0                	cmp    %edx,%eax
  8006ec:	77 69                	ja     800757 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006ee:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8006f2:	83 eb 01             	sub    $0x1,%ebx
  8006f5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800701:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800705:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800708:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80070b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80070e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800712:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800719:	00 
  80071a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800723:	89 54 24 04          	mov    %edx,0x4(%esp)
  800727:	e8 14 09 00 00       	call   801040 <__udivdi3>
  80072c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80072f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800732:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800736:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80073a:	89 04 24             	mov    %eax,(%esp)
  80073d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800741:	89 f2                	mov    %esi,%edx
  800743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800746:	e8 6d ff ff ff       	call   8006b8 <printnum>
  80074b:	eb 11                	jmp    80075e <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80074d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800751:	89 3c 24             	mov    %edi,(%esp)
  800754:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800757:	83 eb 01             	sub    $0x1,%ebx
  80075a:	85 db                	test   %ebx,%ebx
  80075c:	7f ef                	jg     80074d <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800762:	8b 74 24 04          	mov    0x4(%esp),%esi
  800766:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800769:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800774:	00 
  800775:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800778:	89 14 24             	mov    %edx,(%esp)
  80077b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80077e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800782:	e8 e9 09 00 00       	call   801170 <__umoddi3>
  800787:	89 74 24 04          	mov    %esi,0x4(%esp)
  80078b:	0f be 80 27 13 80 00 	movsbl 0x801327(%eax),%eax
  800792:	89 04 24             	mov    %eax,(%esp)
  800795:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800798:	83 c4 4c             	add    $0x4c,%esp
  80079b:	5b                   	pop    %ebx
  80079c:	5e                   	pop    %esi
  80079d:	5f                   	pop    %edi
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a3:	83 fa 01             	cmp    $0x1,%edx
  8007a6:	7e 0e                	jle    8007b6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007a8:	8b 10                	mov    (%eax),%edx
  8007aa:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007ad:	89 08                	mov    %ecx,(%eax)
  8007af:	8b 02                	mov    (%edx),%eax
  8007b1:	8b 52 04             	mov    0x4(%edx),%edx
  8007b4:	eb 22                	jmp    8007d8 <getuint+0x38>
	else if (lflag)
  8007b6:	85 d2                	test   %edx,%edx
  8007b8:	74 10                	je     8007ca <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007ba:	8b 10                	mov    (%eax),%edx
  8007bc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007bf:	89 08                	mov    %ecx,(%eax)
  8007c1:	8b 02                	mov    (%edx),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	eb 0e                	jmp    8007d8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007ca:	8b 10                	mov    (%eax),%edx
  8007cc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007cf:	89 08                	mov    %ecx,(%eax)
  8007d1:	8b 02                	mov    (%edx),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007e0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e4:	8b 10                	mov    (%eax),%edx
  8007e6:	3b 50 04             	cmp    0x4(%eax),%edx
  8007e9:	73 0a                	jae    8007f5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ee:	88 0a                	mov    %cl,(%edx)
  8007f0:	83 c2 01             	add    $0x1,%edx
  8007f3:	89 10                	mov    %edx,(%eax)
}
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	57                   	push   %edi
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 4c             	sub    $0x4c,%esp
  800800:	8b 7d 08             	mov    0x8(%ebp),%edi
  800803:	8b 75 0c             	mov    0xc(%ebp),%esi
  800806:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800809:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800810:	eb 11                	jmp    800823 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800812:	85 c0                	test   %eax,%eax
  800814:	0f 84 b6 03 00 00    	je     800bd0 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80081a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081e:	89 04 24             	mov    %eax,(%esp)
  800821:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800823:	0f b6 03             	movzbl (%ebx),%eax
  800826:	83 c3 01             	add    $0x1,%ebx
  800829:	83 f8 25             	cmp    $0x25,%eax
  80082c:	75 e4                	jne    800812 <vprintfmt+0x1b>
  80082e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800832:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800839:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800840:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800847:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80084f:	eb 06                	jmp    800857 <vprintfmt+0x60>
  800851:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800855:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800857:	0f b6 0b             	movzbl (%ebx),%ecx
  80085a:	0f b6 c1             	movzbl %cl,%eax
  80085d:	8d 53 01             	lea    0x1(%ebx),%edx
  800860:	83 e9 23             	sub    $0x23,%ecx
  800863:	80 f9 55             	cmp    $0x55,%cl
  800866:	0f 87 47 03 00 00    	ja     800bb3 <vprintfmt+0x3bc>
  80086c:	0f b6 c9             	movzbl %cl,%ecx
  80086f:	ff 24 8d 60 14 80 00 	jmp    *0x801460(,%ecx,4)
  800876:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80087a:	eb d9                	jmp    800855 <vprintfmt+0x5e>
  80087c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800883:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800888:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80088b:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80088f:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800892:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800895:	83 fb 09             	cmp    $0x9,%ebx
  800898:	77 30                	ja     8008ca <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089a:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80089d:	eb e9                	jmp    800888 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8d 48 04             	lea    0x4(%eax),%ecx
  8008a5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8008ad:	eb 1e                	jmp    8008cd <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8008af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bf:	eb 94                	jmp    800855 <vprintfmt+0x5e>
  8008c1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008c8:	eb 8b                	jmp    800855 <vprintfmt+0x5e>
  8008ca:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d1:	79 82                	jns    800855 <vprintfmt+0x5e>
  8008d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8008df:	e9 71 ff ff ff       	jmp    800855 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e4:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008e8:	e9 68 ff ff ff       	jmp    800855 <vprintfmt+0x5e>
  8008ed:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8d 50 04             	lea    0x4(%eax),%edx
  8008f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	89 04 24             	mov    %eax,(%esp)
  800902:	ff d7                	call   *%edi
  800904:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800907:	e9 17 ff ff ff       	jmp    800823 <vprintfmt+0x2c>
  80090c:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	89 55 14             	mov    %edx,0x14(%ebp)
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	c1 fa 1f             	sar    $0x1f,%edx
  80091f:	31 d0                	xor    %edx,%eax
  800921:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800923:	83 f8 11             	cmp    $0x11,%eax
  800926:	7f 0b                	jg     800933 <vprintfmt+0x13c>
  800928:	8b 14 85 c0 15 80 00 	mov    0x8015c0(,%eax,4),%edx
  80092f:	85 d2                	test   %edx,%edx
  800931:	75 20                	jne    800953 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800933:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800937:	c7 44 24 08 38 13 80 	movl   $0x801338,0x8(%esp)
  80093e:	00 
  80093f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800943:	89 3c 24             	mov    %edi,(%esp)
  800946:	e8 0d 03 00 00       	call   800c58 <printfmt>
  80094b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80094e:	e9 d0 fe ff ff       	jmp    800823 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800953:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800957:	c7 44 24 08 41 13 80 	movl   $0x801341,0x8(%esp)
  80095e:	00 
  80095f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800963:	89 3c 24             	mov    %edi,(%esp)
  800966:	e8 ed 02 00 00       	call   800c58 <printfmt>
  80096b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80096e:	e9 b0 fe ff ff       	jmp    800823 <vprintfmt+0x2c>
  800973:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800976:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80097c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	8d 50 04             	lea    0x4(%eax),%edx
  800985:	89 55 14             	mov    %edx,0x14(%ebp)
  800988:	8b 18                	mov    (%eax),%ebx
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	b8 44 13 80 00       	mov    $0x801344,%eax
  800991:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800994:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800998:	7e 76                	jle    800a10 <vprintfmt+0x219>
  80099a:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80099e:	74 7a                	je     800a1a <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009a4:	89 1c 24             	mov    %ebx,(%esp)
  8009a7:	e8 ec 02 00 00       	call   800c98 <strnlen>
  8009ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009af:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8009b1:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009b5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009bb:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bd:	eb 0f                	jmp    8009ce <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c6:	89 04 24             	mov    %eax,(%esp)
  8009c9:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cb:	83 eb 01             	sub    $0x1,%ebx
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	7f ed                	jg     8009bf <vprintfmt+0x1c8>
  8009d2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8009d5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009db:	89 f7                	mov    %esi,%edi
  8009dd:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8009e0:	eb 40                	jmp    800a22 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009e6:	74 18                	je     800a00 <vprintfmt+0x209>
  8009e8:	8d 50 e0             	lea    -0x20(%eax),%edx
  8009eb:	83 fa 5e             	cmp    $0x5e,%edx
  8009ee:	76 10                	jbe    800a00 <vprintfmt+0x209>
					putch('?', putdat);
  8009f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009fb:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009fe:	eb 0a                	jmp    800a0a <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800a00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a04:	89 04 24             	mov    %eax,(%esp)
  800a07:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a0e:	eb 12                	jmp    800a22 <vprintfmt+0x22b>
  800a10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a13:	89 f7                	mov    %esi,%edi
  800a15:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a18:	eb 08                	jmp    800a22 <vprintfmt+0x22b>
  800a1a:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a1d:	89 f7                	mov    %esi,%edi
  800a1f:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a22:	0f be 03             	movsbl (%ebx),%eax
  800a25:	83 c3 01             	add    $0x1,%ebx
  800a28:	85 c0                	test   %eax,%eax
  800a2a:	74 25                	je     800a51 <vprintfmt+0x25a>
  800a2c:	85 f6                	test   %esi,%esi
  800a2e:	78 b2                	js     8009e2 <vprintfmt+0x1eb>
  800a30:	83 ee 01             	sub    $0x1,%esi
  800a33:	79 ad                	jns    8009e2 <vprintfmt+0x1eb>
  800a35:	89 fe                	mov    %edi,%esi
  800a37:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a3d:	eb 1a                	jmp    800a59 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a3f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a43:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a4a:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4c:	83 eb 01             	sub    $0x1,%ebx
  800a4f:	eb 08                	jmp    800a59 <vprintfmt+0x262>
  800a51:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a54:	89 fe                	mov    %edi,%esi
  800a56:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a59:	85 db                	test   %ebx,%ebx
  800a5b:	7f e2                	jg     800a3f <vprintfmt+0x248>
  800a5d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a60:	e9 be fd ff ff       	jmp    800823 <vprintfmt+0x2c>
  800a65:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a68:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a6b:	83 f9 01             	cmp    $0x1,%ecx
  800a6e:	7e 16                	jle    800a86 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	8d 50 08             	lea    0x8(%eax),%edx
  800a76:	89 55 14             	mov    %edx,0x14(%ebp)
  800a79:	8b 10                	mov    (%eax),%edx
  800a7b:	8b 48 04             	mov    0x4(%eax),%ecx
  800a7e:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800a81:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a84:	eb 32                	jmp    800ab8 <vprintfmt+0x2c1>
	else if (lflag)
  800a86:	85 c9                	test   %ecx,%ecx
  800a88:	74 18                	je     800aa2 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	8d 50 04             	lea    0x4(%eax),%edx
  800a90:	89 55 14             	mov    %edx,0x14(%ebp)
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a98:	89 c1                	mov    %eax,%ecx
  800a9a:	c1 f9 1f             	sar    $0x1f,%ecx
  800a9d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800aa0:	eb 16                	jmp    800ab8 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	8d 50 04             	lea    0x4(%eax),%edx
  800aa8:	89 55 14             	mov    %edx,0x14(%ebp)
  800aab:	8b 00                	mov    (%eax),%eax
  800aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	c1 fa 1f             	sar    $0x1f,%edx
  800ab5:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800abb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800abe:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ac3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ac7:	0f 89 a7 00 00 00    	jns    800b74 <vprintfmt+0x37d>
				putch('-', putdat);
  800acd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ad8:	ff d7                	call   *%edi
				num = -(long long) num;
  800ada:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800add:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ae0:	f7 d9                	neg    %ecx
  800ae2:	83 d3 00             	adc    $0x0,%ebx
  800ae5:	f7 db                	neg    %ebx
  800ae7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aec:	e9 83 00 00 00       	jmp    800b74 <vprintfmt+0x37d>
  800af1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800af4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af7:	89 ca                	mov    %ecx,%edx
  800af9:	8d 45 14             	lea    0x14(%ebp),%eax
  800afc:	e8 9f fc ff ff       	call   8007a0 <getuint>
  800b01:	89 c1                	mov    %eax,%ecx
  800b03:	89 d3                	mov    %edx,%ebx
  800b05:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800b0a:	eb 68                	jmp    800b74 <vprintfmt+0x37d>
  800b0c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b0f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b12:	89 ca                	mov    %ecx,%edx
  800b14:	8d 45 14             	lea    0x14(%ebp),%eax
  800b17:	e8 84 fc ff ff       	call   8007a0 <getuint>
  800b1c:	89 c1                	mov    %eax,%ecx
  800b1e:	89 d3                	mov    %edx,%ebx
  800b20:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b25:	eb 4d                	jmp    800b74 <vprintfmt+0x37d>
  800b27:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b2a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b2e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b35:	ff d7                	call   *%edi
			putch('x', putdat);
  800b37:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b3b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b42:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	8d 50 04             	lea    0x4(%eax),%edx
  800b4a:	89 55 14             	mov    %edx,0x14(%ebp)
  800b4d:	8b 08                	mov    (%eax),%ecx
  800b4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b54:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b59:	eb 19                	jmp    800b74 <vprintfmt+0x37d>
  800b5b:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b5e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b61:	89 ca                	mov    %ecx,%edx
  800b63:	8d 45 14             	lea    0x14(%ebp),%eax
  800b66:	e8 35 fc ff ff       	call   8007a0 <getuint>
  800b6b:	89 c1                	mov    %eax,%ecx
  800b6d:	89 d3                	mov    %edx,%ebx
  800b6f:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b74:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800b78:	89 54 24 10          	mov    %edx,0x10(%esp)
  800b7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b7f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b83:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b87:	89 0c 24             	mov    %ecx,(%esp)
  800b8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b8e:	89 f2                	mov    %esi,%edx
  800b90:	89 f8                	mov    %edi,%eax
  800b92:	e8 21 fb ff ff       	call   8006b8 <printnum>
  800b97:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b9a:	e9 84 fc ff ff       	jmp    800823 <vprintfmt+0x2c>
  800b9f:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba6:	89 04 24             	mov    %eax,(%esp)
  800ba9:	ff d7                	call   *%edi
  800bab:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bae:	e9 70 fc ff ff       	jmp    800823 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bb7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bbe:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800bc3:	80 38 25             	cmpb   $0x25,(%eax)
  800bc6:	0f 84 57 fc ff ff    	je     800823 <vprintfmt+0x2c>
  800bcc:	89 c3                	mov    %eax,%ebx
  800bce:	eb f0                	jmp    800bc0 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800bd0:	83 c4 4c             	add    $0x4c,%esp
  800bd3:	5b                   	pop    %ebx
  800bd4:	5e                   	pop    %esi
  800bd5:	5f                   	pop    %edi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 28             	sub    $0x28,%esp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800be4:	85 c0                	test   %eax,%eax
  800be6:	74 04                	je     800bec <vsnprintf+0x14>
  800be8:	85 d2                	test   %edx,%edx
  800bea:	7f 07                	jg     800bf3 <vsnprintf+0x1b>
  800bec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bf1:	eb 3b                	jmp    800c2e <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c04:	8b 45 14             	mov    0x14(%ebp),%eax
  800c07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c12:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c19:	c7 04 24 da 07 80 00 	movl   $0x8007da,(%esp)
  800c20:	e8 d2 fb ff ff       	call   8007f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c36:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c40:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 04 24             	mov    %eax,(%esp)
  800c51:	e8 82 ff ff ff       	call   800bd8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c5e:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c61:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c65:	8b 45 10             	mov    0x10(%ebp),%eax
  800c68:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	89 04 24             	mov    %eax,(%esp)
  800c79:	e8 79 fb ff ff       	call   8007f7 <vprintfmt>
	va_end(ap);
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8b:	eb 03                	jmp    800c90 <strlen+0x10>
		n++;
  800c8d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c94:	75 f7                	jne    800c8d <strlen+0xd>
		n++;
	return n;
}
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	53                   	push   %ebx
  800c9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca7:	eb 03                	jmp    800cac <strnlen+0x14>
		n++;
  800ca9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cac:	39 c1                	cmp    %eax,%ecx
  800cae:	74 06                	je     800cb6 <strnlen+0x1e>
  800cb0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800cb4:	75 f3                	jne    800ca9 <strnlen+0x11>
		n++;
	return n;
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	53                   	push   %ebx
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cc3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cc8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ccc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ccf:	83 c2 01             	add    $0x1,%edx
  800cd2:	84 c9                	test   %cl,%cl
  800cd4:	75 f2                	jne    800cc8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800cd6:	5b                   	pop    %ebx
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ce3:	89 1c 24             	mov    %ebx,(%esp)
  800ce6:	e8 95 ff ff ff       	call   800c80 <strlen>
	strcpy(dst + len, src);
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	89 54 24 04          	mov    %edx,0x4(%esp)
  800cf2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800cf5:	89 04 24             	mov    %eax,(%esp)
  800cf8:	e8 bc ff ff ff       	call   800cb9 <strcpy>
	return dst;
}
  800cfd:	89 d8                	mov    %ebx,%eax
  800cff:	83 c4 08             	add    $0x8,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	8b 75 10             	mov    0x10(%ebp),%esi
  800d13:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d18:	eb 0f                	jmp    800d29 <strncpy+0x24>
		*dst++ = *src;
  800d1a:	0f b6 19             	movzbl (%ecx),%ebx
  800d1d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d20:	80 39 01             	cmpb   $0x1,(%ecx)
  800d23:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	39 f2                	cmp    %esi,%edx
  800d2b:	72 ed                	jb     800d1a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	8b 75 08             	mov    0x8(%ebp),%esi
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d3f:	89 f0                	mov    %esi,%eax
  800d41:	85 d2                	test   %edx,%edx
  800d43:	75 0a                	jne    800d4f <strlcpy+0x1e>
  800d45:	eb 17                	jmp    800d5e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d47:	88 18                	mov    %bl,(%eax)
  800d49:	83 c0 01             	add    $0x1,%eax
  800d4c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d4f:	83 ea 01             	sub    $0x1,%edx
  800d52:	74 07                	je     800d5b <strlcpy+0x2a>
  800d54:	0f b6 19             	movzbl (%ecx),%ebx
  800d57:	84 db                	test   %bl,%bl
  800d59:	75 ec                	jne    800d47 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800d5b:	c6 00 00             	movb   $0x0,(%eax)
  800d5e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d6d:	eb 06                	jmp    800d75 <strcmp+0x11>
		p++, q++;
  800d6f:	83 c1 01             	add    $0x1,%ecx
  800d72:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d75:	0f b6 01             	movzbl (%ecx),%eax
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 04                	je     800d80 <strcmp+0x1c>
  800d7c:	3a 02                	cmp    (%edx),%al
  800d7e:	74 ef                	je     800d6f <strcmp+0xb>
  800d80:	0f b6 c0             	movzbl %al,%eax
  800d83:	0f b6 12             	movzbl (%edx),%edx
  800d86:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	53                   	push   %ebx
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800d97:	eb 09                	jmp    800da2 <strncmp+0x18>
		n--, p++, q++;
  800d99:	83 ea 01             	sub    $0x1,%edx
  800d9c:	83 c0 01             	add    $0x1,%eax
  800d9f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800da2:	85 d2                	test   %edx,%edx
  800da4:	75 07                	jne    800dad <strncmp+0x23>
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dab:	eb 13                	jmp    800dc0 <strncmp+0x36>
  800dad:	0f b6 18             	movzbl (%eax),%ebx
  800db0:	84 db                	test   %bl,%bl
  800db2:	74 04                	je     800db8 <strncmp+0x2e>
  800db4:	3a 19                	cmp    (%ecx),%bl
  800db6:	74 e1                	je     800d99 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db8:	0f b6 00             	movzbl (%eax),%eax
  800dbb:	0f b6 11             	movzbl (%ecx),%edx
  800dbe:	29 d0                	sub    %edx,%eax
}
  800dc0:	5b                   	pop    %ebx
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dcd:	eb 07                	jmp    800dd6 <strchr+0x13>
		if (*s == c)
  800dcf:	38 ca                	cmp    %cl,%dl
  800dd1:	74 0f                	je     800de2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dd3:	83 c0 01             	add    $0x1,%eax
  800dd6:	0f b6 10             	movzbl (%eax),%edx
  800dd9:	84 d2                	test   %dl,%dl
  800ddb:	75 f2                	jne    800dcf <strchr+0xc>
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dee:	eb 07                	jmp    800df7 <strfind+0x13>
		if (*s == c)
  800df0:	38 ca                	cmp    %cl,%dl
  800df2:	74 0a                	je     800dfe <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df4:	83 c0 01             	add    $0x1,%eax
  800df7:	0f b6 10             	movzbl (%eax),%edx
  800dfa:	84 d2                	test   %dl,%dl
  800dfc:	75 f2                	jne    800df0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	89 1c 24             	mov    %ebx,(%esp)
  800e09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e11:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e1a:	85 c9                	test   %ecx,%ecx
  800e1c:	74 30                	je     800e4e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e1e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e24:	75 25                	jne    800e4b <memset+0x4b>
  800e26:	f6 c1 03             	test   $0x3,%cl
  800e29:	75 20                	jne    800e4b <memset+0x4b>
		c &= 0xFF;
  800e2b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e2e:	89 d3                	mov    %edx,%ebx
  800e30:	c1 e3 08             	shl    $0x8,%ebx
  800e33:	89 d6                	mov    %edx,%esi
  800e35:	c1 e6 18             	shl    $0x18,%esi
  800e38:	89 d0                	mov    %edx,%eax
  800e3a:	c1 e0 10             	shl    $0x10,%eax
  800e3d:	09 f0                	or     %esi,%eax
  800e3f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800e41:	09 d8                	or     %ebx,%eax
  800e43:	c1 e9 02             	shr    $0x2,%ecx
  800e46:	fc                   	cld    
  800e47:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e49:	eb 03                	jmp    800e4e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e4b:	fc                   	cld    
  800e4c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e4e:	89 f8                	mov    %edi,%eax
  800e50:	8b 1c 24             	mov    (%esp),%ebx
  800e53:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e57:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e5b:	89 ec                	mov    %ebp,%esp
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 08             	sub    $0x8,%esp
  800e65:	89 34 24             	mov    %esi,(%esp)
  800e68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800e72:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800e75:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800e77:	39 c6                	cmp    %eax,%esi
  800e79:	73 35                	jae    800eb0 <memmove+0x51>
  800e7b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e7e:	39 d0                	cmp    %edx,%eax
  800e80:	73 2e                	jae    800eb0 <memmove+0x51>
		s += n;
		d += n;
  800e82:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e84:	f6 c2 03             	test   $0x3,%dl
  800e87:	75 1b                	jne    800ea4 <memmove+0x45>
  800e89:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e8f:	75 13                	jne    800ea4 <memmove+0x45>
  800e91:	f6 c1 03             	test   $0x3,%cl
  800e94:	75 0e                	jne    800ea4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800e96:	83 ef 04             	sub    $0x4,%edi
  800e99:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e9c:	c1 e9 02             	shr    $0x2,%ecx
  800e9f:	fd                   	std    
  800ea0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ea2:	eb 09                	jmp    800ead <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ea4:	83 ef 01             	sub    $0x1,%edi
  800ea7:	8d 72 ff             	lea    -0x1(%edx),%esi
  800eaa:	fd                   	std    
  800eab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ead:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eae:	eb 20                	jmp    800ed0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eb0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eb6:	75 15                	jne    800ecd <memmove+0x6e>
  800eb8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ebe:	75 0d                	jne    800ecd <memmove+0x6e>
  800ec0:	f6 c1 03             	test   $0x3,%cl
  800ec3:	75 08                	jne    800ecd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800ec5:	c1 e9 02             	shr    $0x2,%ecx
  800ec8:	fc                   	cld    
  800ec9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ecb:	eb 03                	jmp    800ed0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ecd:	fc                   	cld    
  800ece:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ed0:	8b 34 24             	mov    (%esp),%esi
  800ed3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ed7:	89 ec                	mov    %ebp,%esp
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	89 04 24             	mov    %eax,(%esp)
  800ef5:	e8 65 ff ff ff       	call   800e5f <memmove>
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
  800f02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f0b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f10:	eb 1c                	jmp    800f2e <memcmp+0x32>
		if (*s1 != *s2)
  800f12:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800f16:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800f1a:	83 c2 01             	add    $0x1,%edx
  800f1d:	83 e9 01             	sub    $0x1,%ecx
  800f20:	38 d8                	cmp    %bl,%al
  800f22:	74 0a                	je     800f2e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	0f b6 db             	movzbl %bl,%ebx
  800f2a:	29 d8                	sub    %ebx,%eax
  800f2c:	eb 09                	jmp    800f37 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f2e:	85 c9                	test   %ecx,%ecx
  800f30:	75 e0                	jne    800f12 <memcmp+0x16>
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f45:	89 c2                	mov    %eax,%edx
  800f47:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f4a:	eb 07                	jmp    800f53 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f4c:	38 08                	cmp    %cl,(%eax)
  800f4e:	74 07                	je     800f57 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f50:	83 c0 01             	add    $0x1,%eax
  800f53:	39 d0                	cmp    %edx,%eax
  800f55:	72 f5                	jb     800f4c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f68:	eb 03                	jmp    800f6d <strtol+0x14>
		s++;
  800f6a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6d:	0f b6 02             	movzbl (%edx),%eax
  800f70:	3c 20                	cmp    $0x20,%al
  800f72:	74 f6                	je     800f6a <strtol+0x11>
  800f74:	3c 09                	cmp    $0x9,%al
  800f76:	74 f2                	je     800f6a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 0c                	jne    800f88 <strtol+0x2f>
		s++;
  800f7c:	8d 52 01             	lea    0x1(%edx),%edx
  800f7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f86:	eb 15                	jmp    800f9d <strtol+0x44>
	else if (*s == '-')
  800f88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f8f:	3c 2d                	cmp    $0x2d,%al
  800f91:	75 0a                	jne    800f9d <strtol+0x44>
		s++, neg = 1;
  800f93:	8d 52 01             	lea    0x1(%edx),%edx
  800f96:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9d:	85 db                	test   %ebx,%ebx
  800f9f:	0f 94 c0             	sete   %al
  800fa2:	74 05                	je     800fa9 <strtol+0x50>
  800fa4:	83 fb 10             	cmp    $0x10,%ebx
  800fa7:	75 15                	jne    800fbe <strtol+0x65>
  800fa9:	80 3a 30             	cmpb   $0x30,(%edx)
  800fac:	75 10                	jne    800fbe <strtol+0x65>
  800fae:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fb2:	75 0a                	jne    800fbe <strtol+0x65>
		s += 2, base = 16;
  800fb4:	83 c2 02             	add    $0x2,%edx
  800fb7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fbc:	eb 13                	jmp    800fd1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 0f                	je     800fd1 <strtol+0x78>
  800fc2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800fc7:	80 3a 30             	cmpb   $0x30,(%edx)
  800fca:	75 05                	jne    800fd1 <strtol+0x78>
		s++, base = 8;
  800fcc:	83 c2 01             	add    $0x1,%edx
  800fcf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd8:	0f b6 0a             	movzbl (%edx),%ecx
  800fdb:	89 cf                	mov    %ecx,%edi
  800fdd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800fe0:	80 fb 09             	cmp    $0x9,%bl
  800fe3:	77 08                	ja     800fed <strtol+0x94>
			dig = *s - '0';
  800fe5:	0f be c9             	movsbl %cl,%ecx
  800fe8:	83 e9 30             	sub    $0x30,%ecx
  800feb:	eb 1e                	jmp    80100b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800fed:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ff0:	80 fb 19             	cmp    $0x19,%bl
  800ff3:	77 08                	ja     800ffd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ff5:	0f be c9             	movsbl %cl,%ecx
  800ff8:	83 e9 57             	sub    $0x57,%ecx
  800ffb:	eb 0e                	jmp    80100b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800ffd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801000:	80 fb 19             	cmp    $0x19,%bl
  801003:	77 15                	ja     80101a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801005:	0f be c9             	movsbl %cl,%ecx
  801008:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80100b:	39 f1                	cmp    %esi,%ecx
  80100d:	7d 0b                	jge    80101a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80100f:	83 c2 01             	add    $0x1,%edx
  801012:	0f af c6             	imul   %esi,%eax
  801015:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801018:	eb be                	jmp    800fd8 <strtol+0x7f>
  80101a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80101c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801020:	74 05                	je     801027 <strtol+0xce>
		*endptr = (char *) s;
  801022:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801025:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801027:	89 ca                	mov    %ecx,%edx
  801029:	f7 da                	neg    %edx
  80102b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80102f:	0f 45 c2             	cmovne %edx,%eax
}
  801032:	83 c4 04             	add    $0x4,%esp
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    
  80103a:	00 00                	add    %al,(%eax)
  80103c:	00 00                	add    %al,(%eax)
	...

00801040 <__udivdi3>:
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	83 ec 10             	sub    $0x10,%esp
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 75 10             	mov    0x10(%ebp),%esi
  801051:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801054:	85 c0                	test   %eax,%eax
  801056:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801059:	75 35                	jne    801090 <__udivdi3+0x50>
  80105b:	39 fe                	cmp    %edi,%esi
  80105d:	77 61                	ja     8010c0 <__udivdi3+0x80>
  80105f:	85 f6                	test   %esi,%esi
  801061:	75 0b                	jne    80106e <__udivdi3+0x2e>
  801063:	b8 01 00 00 00       	mov    $0x1,%eax
  801068:	31 d2                	xor    %edx,%edx
  80106a:	f7 f6                	div    %esi
  80106c:	89 c6                	mov    %eax,%esi
  80106e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801071:	31 d2                	xor    %edx,%edx
  801073:	89 f8                	mov    %edi,%eax
  801075:	f7 f6                	div    %esi
  801077:	89 c7                	mov    %eax,%edi
  801079:	89 c8                	mov    %ecx,%eax
  80107b:	f7 f6                	div    %esi
  80107d:	89 c1                	mov    %eax,%ecx
  80107f:	89 fa                	mov    %edi,%edx
  801081:	89 c8                	mov    %ecx,%eax
  801083:	83 c4 10             	add    $0x10,%esp
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
  80108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801090:	39 f8                	cmp    %edi,%eax
  801092:	77 1c                	ja     8010b0 <__udivdi3+0x70>
  801094:	0f bd d0             	bsr    %eax,%edx
  801097:	83 f2 1f             	xor    $0x1f,%edx
  80109a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80109d:	75 39                	jne    8010d8 <__udivdi3+0x98>
  80109f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8010a2:	0f 86 a0 00 00 00    	jbe    801148 <__udivdi3+0x108>
  8010a8:	39 f8                	cmp    %edi,%eax
  8010aa:	0f 82 98 00 00 00    	jb     801148 <__udivdi3+0x108>
  8010b0:	31 ff                	xor    %edi,%edi
  8010b2:	31 c9                	xor    %ecx,%ecx
  8010b4:	89 c8                	mov    %ecx,%eax
  8010b6:	89 fa                	mov    %edi,%edx
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    
  8010bf:	90                   	nop
  8010c0:	89 d1                	mov    %edx,%ecx
  8010c2:	89 fa                	mov    %edi,%edx
  8010c4:	89 c8                	mov    %ecx,%eax
  8010c6:	31 ff                	xor    %edi,%edi
  8010c8:	f7 f6                	div    %esi
  8010ca:	89 c1                	mov    %eax,%ecx
  8010cc:	89 fa                	mov    %edi,%edx
  8010ce:	89 c8                	mov    %ecx,%eax
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    
  8010d7:	90                   	nop
  8010d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010dc:	89 f2                	mov    %esi,%edx
  8010de:	d3 e0                	shl    %cl,%eax
  8010e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8010e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8010eb:	89 c1                	mov    %eax,%ecx
  8010ed:	d3 ea                	shr    %cl,%edx
  8010ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8010f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8010f6:	d3 e6                	shl    %cl,%esi
  8010f8:	89 c1                	mov    %eax,%ecx
  8010fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8010fd:	89 fe                	mov    %edi,%esi
  8010ff:	d3 ee                	shr    %cl,%esi
  801101:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801105:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801108:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80110b:	d3 e7                	shl    %cl,%edi
  80110d:	89 c1                	mov    %eax,%ecx
  80110f:	d3 ea                	shr    %cl,%edx
  801111:	09 d7                	or     %edx,%edi
  801113:	89 f2                	mov    %esi,%edx
  801115:	89 f8                	mov    %edi,%eax
  801117:	f7 75 ec             	divl   -0x14(%ebp)
  80111a:	89 d6                	mov    %edx,%esi
  80111c:	89 c7                	mov    %eax,%edi
  80111e:	f7 65 e8             	mull   -0x18(%ebp)
  801121:	39 d6                	cmp    %edx,%esi
  801123:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801126:	72 30                	jb     801158 <__udivdi3+0x118>
  801128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80112f:	d3 e2                	shl    %cl,%edx
  801131:	39 c2                	cmp    %eax,%edx
  801133:	73 05                	jae    80113a <__udivdi3+0xfa>
  801135:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801138:	74 1e                	je     801158 <__udivdi3+0x118>
  80113a:	89 f9                	mov    %edi,%ecx
  80113c:	31 ff                	xor    %edi,%edi
  80113e:	e9 71 ff ff ff       	jmp    8010b4 <__udivdi3+0x74>
  801143:	90                   	nop
  801144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801148:	31 ff                	xor    %edi,%edi
  80114a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80114f:	e9 60 ff ff ff       	jmp    8010b4 <__udivdi3+0x74>
  801154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801158:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80115b:	31 ff                	xor    %edi,%edi
  80115d:	89 c8                	mov    %ecx,%eax
  80115f:	89 fa                	mov    %edi,%edx
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
	...

00801170 <__umoddi3>:
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	83 ec 20             	sub    $0x20,%esp
  801178:	8b 55 14             	mov    0x14(%ebp),%edx
  80117b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801181:	8b 75 0c             	mov    0xc(%ebp),%esi
  801184:	85 d2                	test   %edx,%edx
  801186:	89 c8                	mov    %ecx,%eax
  801188:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80118b:	75 13                	jne    8011a0 <__umoddi3+0x30>
  80118d:	39 f7                	cmp    %esi,%edi
  80118f:	76 3f                	jbe    8011d0 <__umoddi3+0x60>
  801191:	89 f2                	mov    %esi,%edx
  801193:	f7 f7                	div    %edi
  801195:	89 d0                	mov    %edx,%eax
  801197:	31 d2                	xor    %edx,%edx
  801199:	83 c4 20             	add    $0x20,%esp
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
  8011a0:	39 f2                	cmp    %esi,%edx
  8011a2:	77 4c                	ja     8011f0 <__umoddi3+0x80>
  8011a4:	0f bd ca             	bsr    %edx,%ecx
  8011a7:	83 f1 1f             	xor    $0x1f,%ecx
  8011aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011ad:	75 51                	jne    801200 <__umoddi3+0x90>
  8011af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8011b2:	0f 87 e0 00 00 00    	ja     801298 <__umoddi3+0x128>
  8011b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bb:	29 f8                	sub    %edi,%eax
  8011bd:	19 d6                	sbb    %edx,%esi
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c5:	89 f2                	mov    %esi,%edx
  8011c7:	83 c4 20             	add    $0x20,%esp
  8011ca:	5e                   	pop    %esi
  8011cb:	5f                   	pop    %edi
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    
  8011ce:	66 90                	xchg   %ax,%ax
  8011d0:	85 ff                	test   %edi,%edi
  8011d2:	75 0b                	jne    8011df <__umoddi3+0x6f>
  8011d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8011d9:	31 d2                	xor    %edx,%edx
  8011db:	f7 f7                	div    %edi
  8011dd:	89 c7                	mov    %eax,%edi
  8011df:	89 f0                	mov    %esi,%eax
  8011e1:	31 d2                	xor    %edx,%edx
  8011e3:	f7 f7                	div    %edi
  8011e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e8:	f7 f7                	div    %edi
  8011ea:	eb a9                	jmp    801195 <__umoddi3+0x25>
  8011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011f0:	89 c8                	mov    %ecx,%eax
  8011f2:	89 f2                	mov    %esi,%edx
  8011f4:	83 c4 20             	add    $0x20,%esp
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    
  8011fb:	90                   	nop
  8011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801200:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801204:	d3 e2                	shl    %cl,%edx
  801206:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801209:	ba 20 00 00 00       	mov    $0x20,%edx
  80120e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801211:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801214:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801218:	89 fa                	mov    %edi,%edx
  80121a:	d3 ea                	shr    %cl,%edx
  80121c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801220:	0b 55 f4             	or     -0xc(%ebp),%edx
  801223:	d3 e7                	shl    %cl,%edi
  801225:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801229:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80122c:	89 f2                	mov    %esi,%edx
  80122e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801231:	89 c7                	mov    %eax,%edi
  801233:	d3 ea                	shr    %cl,%edx
  801235:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80123c:	89 c2                	mov    %eax,%edx
  80123e:	d3 e6                	shl    %cl,%esi
  801240:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801244:	d3 ea                	shr    %cl,%edx
  801246:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80124a:	09 d6                	or     %edx,%esi
  80124c:	89 f0                	mov    %esi,%eax
  80124e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801251:	d3 e7                	shl    %cl,%edi
  801253:	89 f2                	mov    %esi,%edx
  801255:	f7 75 f4             	divl   -0xc(%ebp)
  801258:	89 d6                	mov    %edx,%esi
  80125a:	f7 65 e8             	mull   -0x18(%ebp)
  80125d:	39 d6                	cmp    %edx,%esi
  80125f:	72 2b                	jb     80128c <__umoddi3+0x11c>
  801261:	39 c7                	cmp    %eax,%edi
  801263:	72 23                	jb     801288 <__umoddi3+0x118>
  801265:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801269:	29 c7                	sub    %eax,%edi
  80126b:	19 d6                	sbb    %edx,%esi
  80126d:	89 f0                	mov    %esi,%eax
  80126f:	89 f2                	mov    %esi,%edx
  801271:	d3 ef                	shr    %cl,%edi
  801273:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801277:	d3 e0                	shl    %cl,%eax
  801279:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80127d:	09 f8                	or     %edi,%eax
  80127f:	d3 ea                	shr    %cl,%edx
  801281:	83 c4 20             	add    $0x20,%esp
  801284:	5e                   	pop    %esi
  801285:	5f                   	pop    %edi
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    
  801288:	39 d6                	cmp    %edx,%esi
  80128a:	75 d9                	jne    801265 <__umoddi3+0xf5>
  80128c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80128f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801292:	eb d1                	jmp    801265 <__umoddi3+0xf5>
  801294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801298:	39 f2                	cmp    %esi,%edx
  80129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012a0:	0f 82 12 ff ff ff    	jb     8011b8 <__umoddi3+0x48>
  8012a6:	e9 17 ff ff ff       	jmp    8011c2 <__umoddi3+0x52>
