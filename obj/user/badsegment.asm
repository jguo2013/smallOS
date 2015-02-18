
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0f 00 00 00       	call   800040 <libmain>
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
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800037:	66 b8 28 00          	mov    $0x28,%ax
  80003b:	8e d8                	mov    %eax,%ds
}
  80003d:	5d                   	pop    %ebp
  80003e:	c3                   	ret    
	...

00800040 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800049:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80004c:	8b 75 08             	mov    0x8(%ebp),%esi
  80004f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800052:	e8 a2 04 00 00       	call   8004f9 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800064:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 f6                	test   %esi,%esi
  80006b:	7e 07                	jle    800074 <libmain+0x34>
		binaryname = argv[0];
  80006d:	8b 03                	mov    (%ebx),%eax
  80006f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800074:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800078:	89 34 24             	mov    %esi,(%esp)
  80007b:	e8 b4 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800080:	e8 0b 00 00 00       	call   800090 <exit>
}
  800085:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800088:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80008b:	89 ec                	mov    %ebp,%esp
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
	...

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800096:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80009d:	e8 8b 04 00 00       	call   80052d <sys_env_destroy>
}
  8000a2:	c9                   	leave  
  8000a3:	c3                   	ret    

008000a4 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000b1:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bf:	89 d1                	mov    %edx,%ecx
  8000c1:	89 d3                	mov    %edx,%ebx
  8000c3:	89 d7                	mov    %edx,%edi
  8000c5:	89 d6                	mov    %edx,%esi
  8000c7:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c9:	8b 1c 24             	mov    (%esp),%ebx
  8000cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000d0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000d4:	89 ec                	mov    %ebp,%esp
  8000d6:	5d                   	pop    %ebp
  8000d7:	c3                   	ret    

008000d8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	89 1c 24             	mov    %ebx,(%esp)
  8000e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000e5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f4:	89 c3                	mov    %eax,%ebx
  8000f6:	89 c7                	mov    %eax,%edi
  8000f8:	89 c6                	mov    %eax,%esi
  8000fa:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000fc:	8b 1c 24             	mov    (%esp),%ebx
  8000ff:	8b 74 24 04          	mov    0x4(%esp),%esi
  800103:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800107:	89 ec                	mov    %ebp,%esp
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	89 1c 24             	mov    %ebx,(%esp)
  800114:	89 74 24 04          	mov    %esi,0x4(%esp)
  800118:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011c:	ba 00 00 00 00       	mov    $0x0,%edx
  800121:	b8 10 00 00 00       	mov    $0x10,%eax
  800126:	89 d1                	mov    %edx,%ecx
  800128:	89 d3                	mov    %edx,%ebx
  80012a:	89 d7                	mov    %edx,%edi
  80012c:	89 d6                	mov    %edx,%esi
  80012e:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800130:	8b 1c 24             	mov    (%esp),%ebx
  800133:	8b 74 24 04          	mov    0x4(%esp),%esi
  800137:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80013b:	89 ec                	mov    %ebp,%esp
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	83 ec 38             	sub    $0x38,%esp
  800145:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800148:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80014b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800153:	b8 0f 00 00 00       	mov    $0xf,%eax
  800158:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015b:	8b 55 08             	mov    0x8(%ebp),%edx
  80015e:	89 df                	mov    %ebx,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800164:	85 c0                	test   %eax,%eax
  800166:	7e 28                	jle    800190 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800168:	89 44 24 10          	mov    %eax,0x10(%esp)
  80016c:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800173:	00 
  800174:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80017b:	00 
  80017c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800183:	00 
  800184:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80018b:	e8 fc 03 00 00       	call   80058c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800190:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800193:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800196:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800199:	89 ec                	mov    %ebp,%esp
  80019b:	5d                   	pop    %ebp
  80019c:	c3                   	ret    

0080019d <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	83 ec 38             	sub    $0x38,%esp
  8001a3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001a9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001b1:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bc:	89 df                	mov    %ebx,%edi
  8001be:	89 de                	mov    %ebx,%esi
  8001c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	7e 28                	jle    8001ee <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001ca:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8001d1:	00 
  8001d2:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8001d9:	00 
  8001da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001e1:	00 
  8001e2:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8001e9:	e8 9e 03 00 00       	call   80058c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8001ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001f7:	89 ec                	mov    %ebp,%esp
  8001f9:	5d                   	pop    %ebp
  8001fa:	c3                   	ret    

008001fb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	83 ec 38             	sub    $0x38,%esp
  800201:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800204:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800207:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80020a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800214:	8b 55 08             	mov    0x8(%ebp),%edx
  800217:	89 cb                	mov    %ecx,%ebx
  800219:	89 cf                	mov    %ecx,%edi
  80021b:	89 ce                	mov    %ecx,%esi
  80021d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80021f:	85 c0                	test   %eax,%eax
  800221:	7e 28                	jle    80024b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800223:	89 44 24 10          	mov    %eax,0x10(%esp)
  800227:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80022e:	00 
  80022f:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800236:	00 
  800237:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80023e:	00 
  80023f:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800246:	e8 41 03 00 00       	call   80058c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80024b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80024e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800251:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800254:	89 ec                	mov    %ebp,%esp
  800256:	5d                   	pop    %ebp
  800257:	c3                   	ret    

00800258 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	89 1c 24             	mov    %ebx,(%esp)
  800261:	89 74 24 04          	mov    %esi,0x4(%esp)
  800265:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800269:	be 00 00 00 00       	mov    $0x0,%esi
  80026e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800273:	8b 7d 14             	mov    0x14(%ebp),%edi
  800276:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027c:	8b 55 08             	mov    0x8(%ebp),%edx
  80027f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800281:	8b 1c 24             	mov    (%esp),%ebx
  800284:	8b 74 24 04          	mov    0x4(%esp),%esi
  800288:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80028c:	89 ec                	mov    %ebp,%esp
  80028e:	5d                   	pop    %ebp
  80028f:	c3                   	ret    

00800290 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 38             	sub    $0x38,%esp
  800296:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800299:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80029c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8002af:	89 df                	mov    %ebx,%edi
  8002b1:	89 de                	mov    %ebx,%esi
  8002b3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	7e 28                	jle    8002e1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002bd:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002c4:	00 
  8002c5:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8002cc:	00 
  8002cd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002d4:	00 
  8002d5:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8002dc:	e8 ab 02 00 00       	call   80058c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002ea:	89 ec                	mov    %ebp,%esp
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 38             	sub    $0x38,%esp
  8002f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800302:	b8 09 00 00 00       	mov    $0x9,%eax
  800307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030a:	8b 55 08             	mov    0x8(%ebp),%edx
  80030d:	89 df                	mov    %ebx,%edi
  80030f:	89 de                	mov    %ebx,%esi
  800311:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800313:	85 c0                	test   %eax,%eax
  800315:	7e 28                	jle    80033f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800317:	89 44 24 10          	mov    %eax,0x10(%esp)
  80031b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800322:	00 
  800323:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  80032a:	00 
  80032b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800332:	00 
  800333:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  80033a:	e8 4d 02 00 00       	call   80058c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80033f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800342:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800345:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800348:	89 ec                	mov    %ebp,%esp
  80034a:	5d                   	pop    %ebp
  80034b:	c3                   	ret    

0080034c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	83 ec 38             	sub    $0x38,%esp
  800352:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800355:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800358:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80035b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800360:	b8 08 00 00 00       	mov    $0x8,%eax
  800365:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800368:	8b 55 08             	mov    0x8(%ebp),%edx
  80036b:	89 df                	mov    %ebx,%edi
  80036d:	89 de                	mov    %ebx,%esi
  80036f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800371:	85 c0                	test   %eax,%eax
  800373:	7e 28                	jle    80039d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800375:	89 44 24 10          	mov    %eax,0x10(%esp)
  800379:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800380:	00 
  800381:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800388:	00 
  800389:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800390:	00 
  800391:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800398:	e8 ef 01 00 00       	call   80058c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80039d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003a6:	89 ec                	mov    %ebp,%esp
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 38             	sub    $0x38,%esp
  8003b0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003b3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003b6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003be:	b8 06 00 00 00       	mov    $0x6,%eax
  8003c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c9:	89 df                	mov    %ebx,%edi
  8003cb:	89 de                	mov    %ebx,%esi
  8003cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	7e 28                	jle    8003fb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003d7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003de:	00 
  8003df:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8003e6:	00 
  8003e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003ee:	00 
  8003ef:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8003f6:	e8 91 01 00 00       	call   80058c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8003fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800401:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800404:	89 ec                	mov    %ebp,%esp
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 38             	sub    $0x38,%esp
  80040e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800411:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800414:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800417:	b8 05 00 00 00       	mov    $0x5,%eax
  80041c:	8b 75 18             	mov    0x18(%ebp),%esi
  80041f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800422:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800425:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800428:	8b 55 08             	mov    0x8(%ebp),%edx
  80042b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80042d:	85 c0                	test   %eax,%eax
  80042f:	7e 28                	jle    800459 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800431:	89 44 24 10          	mov    %eax,0x10(%esp)
  800435:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80043c:	00 
  80043d:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800444:	00 
  800445:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80044c:	00 
  80044d:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800454:	e8 33 01 00 00       	call   80058c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800459:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80045c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80045f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800462:	89 ec                	mov    %ebp,%esp
  800464:	5d                   	pop    %ebp
  800465:	c3                   	ret    

00800466 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 38             	sub    $0x38,%esp
  80046c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80046f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800472:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800475:	be 00 00 00 00       	mov    $0x0,%esi
  80047a:	b8 04 00 00 00       	mov    $0x4,%eax
  80047f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800482:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800485:	8b 55 08             	mov    0x8(%ebp),%edx
  800488:	89 f7                	mov    %esi,%edi
  80048a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80048c:	85 c0                	test   %eax,%eax
  80048e:	7e 28                	jle    8004b8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800490:	89 44 24 10          	mov    %eax,0x10(%esp)
  800494:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80049b:	00 
  80049c:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  8004a3:	00 
  8004a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004ab:	00 
  8004ac:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  8004b3:	e8 d4 00 00 00       	call   80058c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004c1:	89 ec                	mov    %ebp,%esp
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	89 1c 24             	mov    %ebx,(%esp)
  8004ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004db:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004e0:	89 d1                	mov    %edx,%ecx
  8004e2:	89 d3                	mov    %edx,%ebx
  8004e4:	89 d7                	mov    %edx,%edi
  8004e6:	89 d6                	mov    %edx,%esi
  8004e8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8004ea:	8b 1c 24             	mov    (%esp),%ebx
  8004ed:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004f1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8004f5:	89 ec                	mov    %ebp,%esp
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    

008004f9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	89 1c 24             	mov    %ebx,(%esp)
  800502:	89 74 24 04          	mov    %esi,0x4(%esp)
  800506:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80050a:	ba 00 00 00 00       	mov    $0x0,%edx
  80050f:	b8 02 00 00 00       	mov    $0x2,%eax
  800514:	89 d1                	mov    %edx,%ecx
  800516:	89 d3                	mov    %edx,%ebx
  800518:	89 d7                	mov    %edx,%edi
  80051a:	89 d6                	mov    %edx,%esi
  80051c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80051e:	8b 1c 24             	mov    (%esp),%ebx
  800521:	8b 74 24 04          	mov    0x4(%esp),%esi
  800525:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800529:	89 ec                	mov    %ebp,%esp
  80052b:	5d                   	pop    %ebp
  80052c:	c3                   	ret    

0080052d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 38             	sub    $0x38,%esp
  800533:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800536:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800539:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80053c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800541:	b8 03 00 00 00       	mov    $0x3,%eax
  800546:	8b 55 08             	mov    0x8(%ebp),%edx
  800549:	89 cb                	mov    %ecx,%ebx
  80054b:	89 cf                	mov    %ecx,%edi
  80054d:	89 ce                	mov    %ecx,%esi
  80054f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800551:	85 c0                	test   %eax,%eax
  800553:	7e 28                	jle    80057d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800555:	89 44 24 10          	mov    %eax,0x10(%esp)
  800559:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800560:	00 
  800561:	c7 44 24 08 aa 12 80 	movl   $0x8012aa,0x8(%esp)
  800568:	00 
  800569:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800570:	00 
  800571:	c7 04 24 c7 12 80 00 	movl   $0x8012c7,(%esp)
  800578:	e8 0f 00 00 00       	call   80058c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80057d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800580:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800583:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800586:	89 ec                	mov    %ebp,%esp
  800588:	5d                   	pop    %ebp
  800589:	c3                   	ret    
	...

0080058c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	56                   	push   %esi
  800590:	53                   	push   %ebx
  800591:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800594:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800597:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  80059d:	e8 57 ff ff ff       	call   8004f9 <sys_getenvid>
  8005a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b8:	c7 04 24 d8 12 80 00 	movl   $0x8012d8,(%esp)
  8005bf:	e8 81 00 00 00       	call   800645 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cb:	89 04 24             	mov    %eax,(%esp)
  8005ce:	e8 11 00 00 00       	call   8005e4 <vcprintf>
	cprintf("\n");
  8005d3:	c7 04 24 fb 12 80 00 	movl   $0x8012fb,(%esp)
  8005da:	e8 66 00 00 00       	call   800645 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005df:	cc                   	int3   
  8005e0:	eb fd                	jmp    8005df <_panic+0x53>
	...

008005e4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f4:	00 00 00 
	b.cnt = 0;
  8005f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005fe:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800601:	8b 45 0c             	mov    0xc(%ebp),%eax
  800604:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80060f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800615:	89 44 24 04          	mov    %eax,0x4(%esp)
  800619:	c7 04 24 5f 06 80 00 	movl   $0x80065f,(%esp)
  800620:	e8 be 01 00 00       	call   8007e3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800625:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80062b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800635:	89 04 24             	mov    %eax,(%esp)
  800638:	e8 9b fa ff ff       	call   8000d8 <sys_cputs>

	return b.cnt;
}
  80063d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80064b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80064e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	89 04 24             	mov    %eax,(%esp)
  800658:	e8 87 ff ff ff       	call   8005e4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	53                   	push   %ebx
  800663:	83 ec 14             	sub    $0x14,%esp
  800666:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800669:	8b 03                	mov    (%ebx),%eax
  80066b:	8b 55 08             	mov    0x8(%ebp),%edx
  80066e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800672:	83 c0 01             	add    $0x1,%eax
  800675:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800677:	3d ff 00 00 00       	cmp    $0xff,%eax
  80067c:	75 19                	jne    800697 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80067e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800685:	00 
  800686:	8d 43 08             	lea    0x8(%ebx),%eax
  800689:	89 04 24             	mov    %eax,(%esp)
  80068c:	e8 47 fa ff ff       	call   8000d8 <sys_cputs>
		b->idx = 0;
  800691:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800697:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80069b:	83 c4 14             	add    $0x14,%esp
  80069e:	5b                   	pop    %ebx
  80069f:	5d                   	pop    %ebp
  8006a0:	c3                   	ret    
  8006a1:	00 00                	add    %al,(%eax)
	...

008006a4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	57                   	push   %edi
  8006a8:	56                   	push   %esi
  8006a9:	53                   	push   %ebx
  8006aa:	83 ec 4c             	sub    $0x4c,%esp
  8006ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b0:	89 d6                	mov    %edx,%esi
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006be:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006c4:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cf:	39 d1                	cmp    %edx,%ecx
  8006d1:	72 07                	jb     8006da <printnum+0x36>
  8006d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006d6:	39 d0                	cmp    %edx,%eax
  8006d8:	77 69                	ja     800743 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006da:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8006de:	83 eb 01             	sub    $0x1,%ebx
  8006e1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8006ed:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8006f1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8006f4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8006f7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8006fe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800705:	00 
  800706:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800709:	89 04 24             	mov    %eax,(%esp)
  80070c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80070f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800713:	e8 18 09 00 00       	call   801030 <__udivdi3>
  800718:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80071b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80071e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800722:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072d:	89 f2                	mov    %esi,%edx
  80072f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800732:	e8 6d ff ff ff       	call   8006a4 <printnum>
  800737:	eb 11                	jmp    80074a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800739:	89 74 24 04          	mov    %esi,0x4(%esp)
  80073d:	89 3c 24             	mov    %edi,(%esp)
  800740:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800743:	83 eb 01             	sub    $0x1,%ebx
  800746:	85 db                	test   %ebx,%ebx
  800748:	7f ef                	jg     800739 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80074a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800752:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800755:	89 44 24 08          	mov    %eax,0x8(%esp)
  800759:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800760:	00 
  800761:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800764:	89 14 24             	mov    %edx,(%esp)
  800767:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80076a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80076e:	e8 ed 09 00 00       	call   801160 <__umoddi3>
  800773:	89 74 24 04          	mov    %esi,0x4(%esp)
  800777:	0f be 80 fd 12 80 00 	movsbl 0x8012fd(%eax),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800784:	83 c4 4c             	add    $0x4c,%esp
  800787:	5b                   	pop    %ebx
  800788:	5e                   	pop    %esi
  800789:	5f                   	pop    %edi
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80078f:	83 fa 01             	cmp    $0x1,%edx
  800792:	7e 0e                	jle    8007a2 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800794:	8b 10                	mov    (%eax),%edx
  800796:	8d 4a 08             	lea    0x8(%edx),%ecx
  800799:	89 08                	mov    %ecx,(%eax)
  80079b:	8b 02                	mov    (%edx),%eax
  80079d:	8b 52 04             	mov    0x4(%edx),%edx
  8007a0:	eb 22                	jmp    8007c4 <getuint+0x38>
	else if (lflag)
  8007a2:	85 d2                	test   %edx,%edx
  8007a4:	74 10                	je     8007b6 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007a6:	8b 10                	mov    (%eax),%edx
  8007a8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ab:	89 08                	mov    %ecx,(%eax)
  8007ad:	8b 02                	mov    (%edx),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	eb 0e                	jmp    8007c4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007b6:	8b 10                	mov    (%eax),%edx
  8007b8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007bb:	89 08                	mov    %ecx,(%eax)
  8007bd:	8b 02                	mov    (%edx),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007c4:	5d                   	pop    %ebp
  8007c5:	c3                   	ret    

008007c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007d0:	8b 10                	mov    (%eax),%edx
  8007d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8007d5:	73 0a                	jae    8007e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007da:	88 0a                	mov    %cl,(%edx)
  8007dc:	83 c2 01             	add    $0x1,%edx
  8007df:	89 10                	mov    %edx,(%eax)
}
  8007e1:	5d                   	pop    %ebp
  8007e2:	c3                   	ret    

008007e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	57                   	push   %edi
  8007e7:	56                   	push   %esi
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 4c             	sub    $0x4c,%esp
  8007ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8007f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f5:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8007fc:	eb 11                	jmp    80080f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007fe:	85 c0                	test   %eax,%eax
  800800:	0f 84 b6 03 00 00    	je     800bbc <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800806:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080a:	89 04 24             	mov    %eax,(%esp)
  80080d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080f:	0f b6 03             	movzbl (%ebx),%eax
  800812:	83 c3 01             	add    $0x1,%ebx
  800815:	83 f8 25             	cmp    $0x25,%eax
  800818:	75 e4                	jne    8007fe <vprintfmt+0x1b>
  80081a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80081e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800825:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80082c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800833:	b9 00 00 00 00       	mov    $0x0,%ecx
  800838:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80083b:	eb 06                	jmp    800843 <vprintfmt+0x60>
  80083d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800841:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800843:	0f b6 0b             	movzbl (%ebx),%ecx
  800846:	0f b6 c1             	movzbl %cl,%eax
  800849:	8d 53 01             	lea    0x1(%ebx),%edx
  80084c:	83 e9 23             	sub    $0x23,%ecx
  80084f:	80 f9 55             	cmp    $0x55,%cl
  800852:	0f 87 47 03 00 00    	ja     800b9f <vprintfmt+0x3bc>
  800858:	0f b6 c9             	movzbl %cl,%ecx
  80085b:	ff 24 8d 40 14 80 00 	jmp    *0x801440(,%ecx,4)
  800862:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800866:	eb d9                	jmp    800841 <vprintfmt+0x5e>
  800868:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80086f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800874:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800877:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80087b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80087e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800881:	83 fb 09             	cmp    $0x9,%ebx
  800884:	77 30                	ja     8008b6 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800886:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800889:	eb e9                	jmp    800874 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	8d 48 04             	lea    0x4(%eax),%ecx
  800891:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800899:	eb 1e                	jmp    8008b9 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80089b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ab:	eb 94                	jmp    800841 <vprintfmt+0x5e>
  8008ad:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008b4:	eb 8b                	jmp    800841 <vprintfmt+0x5e>
  8008b6:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bd:	79 82                	jns    800841 <vprintfmt+0x5e>
  8008bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008c8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8008cb:	e9 71 ff ff ff       	jmp    800841 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008d4:	e9 68 ff ff ff       	jmp    800841 <vprintfmt+0x5e>
  8008d9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 50 04             	lea    0x4(%eax),%edx
  8008e2:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	89 04 24             	mov    %eax,(%esp)
  8008ee:	ff d7                	call   *%edi
  8008f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8008f3:	e9 17 ff ff ff       	jmp    80080f <vprintfmt+0x2c>
  8008f8:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	89 55 14             	mov    %edx,0x14(%ebp)
  800904:	8b 00                	mov    (%eax),%eax
  800906:	89 c2                	mov    %eax,%edx
  800908:	c1 fa 1f             	sar    $0x1f,%edx
  80090b:	31 d0                	xor    %edx,%eax
  80090d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80090f:	83 f8 11             	cmp    $0x11,%eax
  800912:	7f 0b                	jg     80091f <vprintfmt+0x13c>
  800914:	8b 14 85 a0 15 80 00 	mov    0x8015a0(,%eax,4),%edx
  80091b:	85 d2                	test   %edx,%edx
  80091d:	75 20                	jne    80093f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80091f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800923:	c7 44 24 08 0e 13 80 	movl   $0x80130e,0x8(%esp)
  80092a:	00 
  80092b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80092f:	89 3c 24             	mov    %edi,(%esp)
  800932:	e8 0d 03 00 00       	call   800c44 <printfmt>
  800937:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80093a:	e9 d0 fe ff ff       	jmp    80080f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800943:	c7 44 24 08 17 13 80 	movl   $0x801317,0x8(%esp)
  80094a:	00 
  80094b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80094f:	89 3c 24             	mov    %edi,(%esp)
  800952:	e8 ed 02 00 00       	call   800c44 <printfmt>
  800957:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80095a:	e9 b0 fe ff ff       	jmp    80080f <vprintfmt+0x2c>
  80095f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800962:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800968:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8d 50 04             	lea    0x4(%eax),%edx
  800971:	89 55 14             	mov    %edx,0x14(%ebp)
  800974:	8b 18                	mov    (%eax),%ebx
  800976:	85 db                	test   %ebx,%ebx
  800978:	b8 1a 13 80 00       	mov    $0x80131a,%eax
  80097d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800980:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800984:	7e 76                	jle    8009fc <vprintfmt+0x219>
  800986:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80098a:	74 7a                	je     800a06 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80098c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800990:	89 1c 24             	mov    %ebx,(%esp)
  800993:	e8 f0 02 00 00       	call   800c88 <strnlen>
  800998:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80099b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80099d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009a1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009a4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009a7:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a9:	eb 0f                	jmp    8009ba <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b7:	83 eb 01             	sub    $0x1,%ebx
  8009ba:	85 db                	test   %ebx,%ebx
  8009bc:	7f ed                	jg     8009ab <vprintfmt+0x1c8>
  8009be:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8009c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009c4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009c7:	89 f7                	mov    %esi,%edi
  8009c9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8009cc:	eb 40                	jmp    800a0e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009d2:	74 18                	je     8009ec <vprintfmt+0x209>
  8009d4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8009d7:	83 fa 5e             	cmp    $0x5e,%edx
  8009da:	76 10                	jbe    8009ec <vprintfmt+0x209>
					putch('?', putdat);
  8009dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009e7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009ea:	eb 0a                	jmp    8009f6 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8009ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f0:	89 04 24             	mov    %eax,(%esp)
  8009f3:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8009fa:	eb 12                	jmp    800a0e <vprintfmt+0x22b>
  8009fc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009ff:	89 f7                	mov    %esi,%edi
  800a01:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a04:	eb 08                	jmp    800a0e <vprintfmt+0x22b>
  800a06:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a09:	89 f7                	mov    %esi,%edi
  800a0b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a0e:	0f be 03             	movsbl (%ebx),%eax
  800a11:	83 c3 01             	add    $0x1,%ebx
  800a14:	85 c0                	test   %eax,%eax
  800a16:	74 25                	je     800a3d <vprintfmt+0x25a>
  800a18:	85 f6                	test   %esi,%esi
  800a1a:	78 b2                	js     8009ce <vprintfmt+0x1eb>
  800a1c:	83 ee 01             	sub    $0x1,%esi
  800a1f:	79 ad                	jns    8009ce <vprintfmt+0x1eb>
  800a21:	89 fe                	mov    %edi,%esi
  800a23:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a26:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a29:	eb 1a                	jmp    800a45 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a36:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a38:	83 eb 01             	sub    $0x1,%ebx
  800a3b:	eb 08                	jmp    800a45 <vprintfmt+0x262>
  800a3d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a40:	89 fe                	mov    %edi,%esi
  800a42:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a45:	85 db                	test   %ebx,%ebx
  800a47:	7f e2                	jg     800a2b <vprintfmt+0x248>
  800a49:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a4c:	e9 be fd ff ff       	jmp    80080f <vprintfmt+0x2c>
  800a51:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a54:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a57:	83 f9 01             	cmp    $0x1,%ecx
  800a5a:	7e 16                	jle    800a72 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	8d 50 08             	lea    0x8(%eax),%edx
  800a62:	89 55 14             	mov    %edx,0x14(%ebp)
  800a65:	8b 10                	mov    (%eax),%edx
  800a67:	8b 48 04             	mov    0x4(%eax),%ecx
  800a6a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800a6d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a70:	eb 32                	jmp    800aa4 <vprintfmt+0x2c1>
	else if (lflag)
  800a72:	85 c9                	test   %ecx,%ecx
  800a74:	74 18                	je     800a8e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8d 50 04             	lea    0x4(%eax),%edx
  800a7c:	89 55 14             	mov    %edx,0x14(%ebp)
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a84:	89 c1                	mov    %eax,%ecx
  800a86:	c1 f9 1f             	sar    $0x1f,%ecx
  800a89:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a8c:	eb 16                	jmp    800aa4 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	8d 50 04             	lea    0x4(%eax),%edx
  800a94:	89 55 14             	mov    %edx,0x14(%ebp)
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9c:	89 c2                	mov    %eax,%edx
  800a9e:	c1 fa 1f             	sar    $0x1f,%edx
  800aa1:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aa4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800aa7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800aaa:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800aaf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ab3:	0f 89 a7 00 00 00    	jns    800b60 <vprintfmt+0x37d>
				putch('-', putdat);
  800ab9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800abd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ac4:	ff d7                	call   *%edi
				num = -(long long) num;
  800ac6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800ac9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800acc:	f7 d9                	neg    %ecx
  800ace:	83 d3 00             	adc    $0x0,%ebx
  800ad1:	f7 db                	neg    %ebx
  800ad3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad8:	e9 83 00 00 00       	jmp    800b60 <vprintfmt+0x37d>
  800add:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800ae0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ae3:	89 ca                	mov    %ecx,%edx
  800ae5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae8:	e8 9f fc ff ff       	call   80078c <getuint>
  800aed:	89 c1                	mov    %eax,%ecx
  800aef:	89 d3                	mov    %edx,%ebx
  800af1:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800af6:	eb 68                	jmp    800b60 <vprintfmt+0x37d>
  800af8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800afb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800afe:	89 ca                	mov    %ecx,%edx
  800b00:	8d 45 14             	lea    0x14(%ebp),%eax
  800b03:	e8 84 fc ff ff       	call   80078c <getuint>
  800b08:	89 c1                	mov    %eax,%ecx
  800b0a:	89 d3                	mov    %edx,%ebx
  800b0c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b11:	eb 4d                	jmp    800b60 <vprintfmt+0x37d>
  800b13:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b16:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b1a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b21:	ff d7                	call   *%edi
			putch('x', putdat);
  800b23:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b27:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b2e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	8d 50 04             	lea    0x4(%eax),%edx
  800b36:	89 55 14             	mov    %edx,0x14(%ebp)
  800b39:	8b 08                	mov    (%eax),%ecx
  800b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b40:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b45:	eb 19                	jmp    800b60 <vprintfmt+0x37d>
  800b47:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b4a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b4d:	89 ca                	mov    %ecx,%edx
  800b4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b52:	e8 35 fc ff ff       	call   80078c <getuint>
  800b57:	89 c1                	mov    %eax,%ecx
  800b59:	89 d3                	mov    %edx,%ebx
  800b5b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b60:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800b64:	89 54 24 10          	mov    %edx,0x10(%esp)
  800b68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b73:	89 0c 24             	mov    %ecx,(%esp)
  800b76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b7a:	89 f2                	mov    %esi,%edx
  800b7c:	89 f8                	mov    %edi,%eax
  800b7e:	e8 21 fb ff ff       	call   8006a4 <printnum>
  800b83:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b86:	e9 84 fc ff ff       	jmp    80080f <vprintfmt+0x2c>
  800b8b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b8e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b92:	89 04 24             	mov    %eax,(%esp)
  800b95:	ff d7                	call   *%edi
  800b97:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b9a:	e9 70 fc ff ff       	jmp    80080f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800baa:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800baf:	80 38 25             	cmpb   $0x25,(%eax)
  800bb2:	0f 84 57 fc ff ff    	je     80080f <vprintfmt+0x2c>
  800bb8:	89 c3                	mov    %eax,%ebx
  800bba:	eb f0                	jmp    800bac <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800bbc:	83 c4 4c             	add    $0x4c,%esp
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 28             	sub    $0x28,%esp
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800bd0:	85 c0                	test   %eax,%eax
  800bd2:	74 04                	je     800bd8 <vsnprintf+0x14>
  800bd4:	85 d2                	test   %edx,%edx
  800bd6:	7f 07                	jg     800bdf <vsnprintf+0x1b>
  800bd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bdd:	eb 3b                	jmp    800c1a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c05:	c7 04 24 c6 07 80 00 	movl   $0x8007c6,(%esp)
  800c0c:	e8 d2 fb ff ff       	call   8007e3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c22:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c29:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	89 04 24             	mov    %eax,(%esp)
  800c3d:	e8 82 ff ff ff       	call   800bc4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c4a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	89 04 24             	mov    %eax,(%esp)
  800c65:	e8 79 fb ff ff       	call   8007e3 <vprintfmt>
	va_end(ap);
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    
  800c6c:	00 00                	add    %al,(%eax)
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
