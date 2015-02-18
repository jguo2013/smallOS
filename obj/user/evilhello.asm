
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
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
  800037:	83 ec 18             	sub    $0x18,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  80003a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  800041:	00 
  800042:	c7 04 24 0c 00 10 f0 	movl   $0xf010000c,(%esp)
  800049:	e8 9a 00 00 00       	call   8000e8 <sys_cputs>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	83 ec 18             	sub    $0x18,%esp
  800056:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800059:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80005c:	8b 75 08             	mov    0x8(%ebp),%esi
  80005f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800062:	e8 a2 04 00 00       	call   800509 <sys_getenvid>
  800067:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800074:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800079:	85 f6                	test   %esi,%esi
  80007b:	7e 07                	jle    800084 <libmain+0x34>
		binaryname = argv[0];
  80007d:	8b 03                	mov    (%ebx),%eax
  80007f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	89 34 24             	mov    %esi,(%esp)
  80008b:	e8 a4 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800090:	e8 0b 00 00 00       	call   8000a0 <exit>
}
  800095:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800098:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009b:	89 ec                	mov    %ebp,%esp
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
	...

008000a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ad:	e8 8b 04 00 00       	call   80053d <sys_env_destroy>
}
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	89 1c 24             	mov    %ebx,(%esp)
  8000bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cf:	89 d1                	mov    %edx,%ecx
  8000d1:	89 d3                	mov    %edx,%ebx
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	89 d6                	mov    %edx,%esi
  8000d7:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d9:	8b 1c 24             	mov    (%esp),%ebx
  8000dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000e0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000e4:	89 ec                	mov    %ebp,%esp
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    

008000e8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	89 1c 24             	mov    %ebx,(%esp)
  8000f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800101:	8b 55 08             	mov    0x8(%ebp),%edx
  800104:	89 c3                	mov    %eax,%ebx
  800106:	89 c7                	mov    %eax,%edi
  800108:	89 c6                	mov    %eax,%esi
  80010a:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80010c:	8b 1c 24             	mov    (%esp),%ebx
  80010f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800113:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800117:	89 ec                	mov    %ebp,%esp
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    

0080011b <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	89 1c 24             	mov    %ebx,(%esp)
  800124:	89 74 24 04          	mov    %esi,0x4(%esp)
  800128:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012c:	ba 00 00 00 00       	mov    $0x0,%edx
  800131:	b8 10 00 00 00       	mov    $0x10,%eax
  800136:	89 d1                	mov    %edx,%ecx
  800138:	89 d3                	mov    %edx,%ebx
  80013a:	89 d7                	mov    %edx,%edi
  80013c:	89 d6                	mov    %edx,%esi
  80013e:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800140:	8b 1c 24             	mov    (%esp),%ebx
  800143:	8b 74 24 04          	mov    0x4(%esp),%esi
  800147:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80014b:	89 ec                	mov    %ebp,%esp
  80014d:	5d                   	pop    %ebp
  80014e:	c3                   	ret    

0080014f <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	83 ec 38             	sub    $0x38,%esp
  800155:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800158:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80015b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80015e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800163:	b8 0f 00 00 00       	mov    $0xf,%eax
  800168:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016b:	8b 55 08             	mov    0x8(%ebp),%edx
  80016e:	89 df                	mov    %ebx,%edi
  800170:	89 de                	mov    %ebx,%esi
  800172:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800174:	85 c0                	test   %eax,%eax
  800176:	7e 28                	jle    8001a0 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800178:	89 44 24 10          	mov    %eax,0x10(%esp)
  80017c:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800183:	00 
  800184:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  80018b:	00 
  80018c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800193:	00 
  800194:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  80019b:	e8 fc 03 00 00       	call   80059c <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  8001a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001a9:	89 ec                	mov    %ebp,%esp
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    

008001ad <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 38             	sub    $0x38,%esp
  8001b3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001b6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001b9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c1:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cc:	89 df                	mov    %ebx,%edi
  8001ce:	89 de                	mov    %ebx,%esi
  8001d0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	7e 28                	jle    8001fe <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001da:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8001e1:	00 
  8001e2:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  8001e9:	00 
  8001ea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001f1:	00 
  8001f2:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  8001f9:	e8 9e 03 00 00       	call   80059c <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8001fe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800201:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800204:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800207:	89 ec                	mov    %ebp,%esp
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    

0080020b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 38             	sub    $0x38,%esp
  800211:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800214:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800217:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80021a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800224:	8b 55 08             	mov    0x8(%ebp),%edx
  800227:	89 cb                	mov    %ecx,%ebx
  800229:	89 cf                	mov    %ecx,%edi
  80022b:	89 ce                	mov    %ecx,%esi
  80022d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80022f:	85 c0                	test   %eax,%eax
  800231:	7e 28                	jle    80025b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800233:	89 44 24 10          	mov    %eax,0x10(%esp)
  800237:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80023e:	00 
  80023f:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  800246:	00 
  800247:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80024e:	00 
  80024f:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  800256:	e8 41 03 00 00       	call   80059c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80025b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80025e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800261:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800264:	89 ec                	mov    %ebp,%esp
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    

00800268 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	89 1c 24             	mov    %ebx,(%esp)
  800271:	89 74 24 04          	mov    %esi,0x4(%esp)
  800275:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800279:	be 00 00 00 00       	mov    $0x0,%esi
  80027e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800283:	8b 7d 14             	mov    0x14(%ebp),%edi
  800286:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028c:	8b 55 08             	mov    0x8(%ebp),%edx
  80028f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800291:	8b 1c 24             	mov    (%esp),%ebx
  800294:	8b 74 24 04          	mov    0x4(%esp),%esi
  800298:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80029c:	89 ec                	mov    %ebp,%esp
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 38             	sub    $0x38,%esp
  8002a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	89 df                	mov    %ebx,%edi
  8002c1:	89 de                	mov    %ebx,%esi
  8002c3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	7e 28                	jle    8002f1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002cd:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002d4:	00 
  8002d5:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  8002dc:	00 
  8002dd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002e4:	00 
  8002e5:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  8002ec:	e8 ab 02 00 00       	call   80059c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002fa:	89 ec                	mov    %ebp,%esp
  8002fc:	5d                   	pop    %ebp
  8002fd:	c3                   	ret    

008002fe <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 38             	sub    $0x38,%esp
  800304:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800307:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80030a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80030d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800312:	b8 09 00 00 00       	mov    $0x9,%eax
  800317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031a:	8b 55 08             	mov    0x8(%ebp),%edx
  80031d:	89 df                	mov    %ebx,%edi
  80031f:	89 de                	mov    %ebx,%esi
  800321:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7e 28                	jle    80034f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800327:	89 44 24 10          	mov    %eax,0x10(%esp)
  80032b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800332:	00 
  800333:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  80033a:	00 
  80033b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800342:	00 
  800343:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  80034a:	e8 4d 02 00 00       	call   80059c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80034f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800352:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800355:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800358:	89 ec                	mov    %ebp,%esp
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 38             	sub    $0x38,%esp
  800362:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800365:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800368:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80036b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800370:	b8 08 00 00 00       	mov    $0x8,%eax
  800375:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800378:	8b 55 08             	mov    0x8(%ebp),%edx
  80037b:	89 df                	mov    %ebx,%edi
  80037d:	89 de                	mov    %ebx,%esi
  80037f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800381:	85 c0                	test   %eax,%eax
  800383:	7e 28                	jle    8003ad <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800385:	89 44 24 10          	mov    %eax,0x10(%esp)
  800389:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800390:	00 
  800391:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  800398:	00 
  800399:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003a0:	00 
  8003a1:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  8003a8:	e8 ef 01 00 00       	call   80059c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8003ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003b0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b6:	89 ec                	mov    %ebp,%esp
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	83 ec 38             	sub    $0x38,%esp
  8003c0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003c3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003c6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8003d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d9:	89 df                	mov    %ebx,%edi
  8003db:	89 de                	mov    %ebx,%esi
  8003dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	7e 28                	jle    80040b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003e7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003ee:	00 
  8003ef:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  8003f6:	00 
  8003f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003fe:	00 
  8003ff:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  800406:	e8 91 01 00 00       	call   80059c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80040b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80040e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800411:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800414:	89 ec                	mov    %ebp,%esp
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 38             	sub    $0x38,%esp
  80041e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800421:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800424:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800427:	b8 05 00 00 00       	mov    $0x5,%eax
  80042c:	8b 75 18             	mov    0x18(%ebp),%esi
  80042f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800432:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800435:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800438:	8b 55 08             	mov    0x8(%ebp),%edx
  80043b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80043d:	85 c0                	test   %eax,%eax
  80043f:	7e 28                	jle    800469 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800441:	89 44 24 10          	mov    %eax,0x10(%esp)
  800445:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80044c:	00 
  80044d:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  800454:	00 
  800455:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80045c:	00 
  80045d:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  800464:	e8 33 01 00 00       	call   80059c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800469:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80046c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80046f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800472:	89 ec                	mov    %ebp,%esp
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    

00800476 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 38             	sub    $0x38,%esp
  80047c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80047f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800482:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800485:	be 00 00 00 00       	mov    $0x0,%esi
  80048a:	b8 04 00 00 00       	mov    $0x4,%eax
  80048f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800495:	8b 55 08             	mov    0x8(%ebp),%edx
  800498:	89 f7                	mov    %esi,%edi
  80049a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80049c:	85 c0                	test   %eax,%eax
  80049e:	7e 28                	jle    8004c8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004a4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8004ab:	00 
  8004ac:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  8004b3:	00 
  8004b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004bb:	00 
  8004bc:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  8004c3:	e8 d4 00 00 00       	call   80059c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004d1:	89 ec                	mov    %ebp,%esp
  8004d3:	5d                   	pop    %ebp
  8004d4:	c3                   	ret    

008004d5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 0c             	sub    $0xc,%esp
  8004db:	89 1c 24             	mov    %ebx,(%esp)
  8004de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004e2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004eb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004f0:	89 d1                	mov    %edx,%ecx
  8004f2:	89 d3                	mov    %edx,%ebx
  8004f4:	89 d7                	mov    %edx,%edi
  8004f6:	89 d6                	mov    %edx,%esi
  8004f8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8004fa:	8b 1c 24             	mov    (%esp),%ebx
  8004fd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800501:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800505:	89 ec                	mov    %ebp,%esp
  800507:	5d                   	pop    %ebp
  800508:	c3                   	ret    

00800509 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	83 ec 0c             	sub    $0xc,%esp
  80050f:	89 1c 24             	mov    %ebx,(%esp)
  800512:	89 74 24 04          	mov    %esi,0x4(%esp)
  800516:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80051a:	ba 00 00 00 00       	mov    $0x0,%edx
  80051f:	b8 02 00 00 00       	mov    $0x2,%eax
  800524:	89 d1                	mov    %edx,%ecx
  800526:	89 d3                	mov    %edx,%ebx
  800528:	89 d7                	mov    %edx,%edi
  80052a:	89 d6                	mov    %edx,%esi
  80052c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80052e:	8b 1c 24             	mov    (%esp),%ebx
  800531:	8b 74 24 04          	mov    0x4(%esp),%esi
  800535:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800539:	89 ec                	mov    %ebp,%esp
  80053b:	5d                   	pop    %ebp
  80053c:	c3                   	ret    

0080053d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	83 ec 38             	sub    $0x38,%esp
  800543:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800546:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800549:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80054c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800551:	b8 03 00 00 00       	mov    $0x3,%eax
  800556:	8b 55 08             	mov    0x8(%ebp),%edx
  800559:	89 cb                	mov    %ecx,%ebx
  80055b:	89 cf                	mov    %ecx,%edi
  80055d:	89 ce                	mov    %ecx,%esi
  80055f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800561:	85 c0                	test   %eax,%eax
  800563:	7e 28                	jle    80058d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800565:	89 44 24 10          	mov    %eax,0x10(%esp)
  800569:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800570:	00 
  800571:	c7 44 24 08 ca 12 80 	movl   $0x8012ca,0x8(%esp)
  800578:	00 
  800579:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800580:	00 
  800581:	c7 04 24 e7 12 80 00 	movl   $0x8012e7,(%esp)
  800588:	e8 0f 00 00 00       	call   80059c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80058d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800590:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800593:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800596:	89 ec                	mov    %ebp,%esp
  800598:	5d                   	pop    %ebp
  800599:	c3                   	ret    
	...

0080059c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	56                   	push   %esi
  8005a0:	53                   	push   %ebx
  8005a1:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8005a4:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a7:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8005ad:	e8 57 ff ff ff       	call   800509 <sys_getenvid>
  8005b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005c0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c8:	c7 04 24 f8 12 80 00 	movl   $0x8012f8,(%esp)
  8005cf:	e8 81 00 00 00       	call   800655 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	e8 11 00 00 00       	call   8005f4 <vcprintf>
	cprintf("\n");
  8005e3:	c7 04 24 1b 13 80 00 	movl   $0x80131b,(%esp)
  8005ea:	e8 66 00 00 00       	call   800655 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005ef:	cc                   	int3   
  8005f0:	eb fd                	jmp    8005ef <_panic+0x53>
	...

008005f4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800604:	00 00 00 
	b.cnt = 0;
  800607:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80060e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800611:	8b 45 0c             	mov    0xc(%ebp),%eax
  800614:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80061f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800625:	89 44 24 04          	mov    %eax,0x4(%esp)
  800629:	c7 04 24 6f 06 80 00 	movl   $0x80066f,(%esp)
  800630:	e8 be 01 00 00       	call   8007f3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800635:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80063b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800645:	89 04 24             	mov    %eax,(%esp)
  800648:	e8 9b fa ff ff       	call   8000e8 <sys_cputs>

	return b.cnt;
}
  80064d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800653:	c9                   	leave  
  800654:	c3                   	ret    

00800655 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80065b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80065e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	89 04 24             	mov    %eax,(%esp)
  800668:	e8 87 ff ff ff       	call   8005f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	53                   	push   %ebx
  800673:	83 ec 14             	sub    $0x14,%esp
  800676:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800679:	8b 03                	mov    (%ebx),%eax
  80067b:	8b 55 08             	mov    0x8(%ebp),%edx
  80067e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800682:	83 c0 01             	add    $0x1,%eax
  800685:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800687:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068c:	75 19                	jne    8006a7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80068e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800695:	00 
  800696:	8d 43 08             	lea    0x8(%ebx),%eax
  800699:	89 04 24             	mov    %eax,(%esp)
  80069c:	e8 47 fa ff ff       	call   8000e8 <sys_cputs>
		b->idx = 0;
  8006a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006a7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006ab:	83 c4 14             	add    $0x14,%esp
  8006ae:	5b                   	pop    %ebx
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    
  8006b1:	00 00                	add    %al,(%eax)
	...

008006b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	57                   	push   %edi
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 4c             	sub    $0x4c,%esp
  8006bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c0:	89 d6                	mov    %edx,%esi
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006d4:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006df:	39 d1                	cmp    %edx,%ecx
  8006e1:	72 07                	jb     8006ea <printnum+0x36>
  8006e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006e6:	39 d0                	cmp    %edx,%eax
  8006e8:	77 69                	ja     800753 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006ea:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8006ee:	83 eb 01             	sub    $0x1,%ebx
  8006f1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006f9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8006fd:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800701:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800704:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800707:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80070a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80070e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800715:	00 
  800716:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800719:	89 04 24             	mov    %eax,(%esp)
  80071c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80071f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800723:	e8 18 09 00 00       	call   801040 <__udivdi3>
  800728:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80072b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80072e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800732:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800736:	89 04 24             	mov    %eax,(%esp)
  800739:	89 54 24 04          	mov    %edx,0x4(%esp)
  80073d:	89 f2                	mov    %esi,%edx
  80073f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800742:	e8 6d ff ff ff       	call   8006b4 <printnum>
  800747:	eb 11                	jmp    80075a <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800749:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074d:	89 3c 24             	mov    %edi,(%esp)
  800750:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800753:	83 eb 01             	sub    $0x1,%ebx
  800756:	85 db                	test   %ebx,%ebx
  800758:	7f ef                	jg     800749 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800762:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800765:	89 44 24 08          	mov    %eax,0x8(%esp)
  800769:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800770:	00 
  800771:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800774:	89 14 24             	mov    %edx,(%esp)
  800777:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80077a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80077e:	e8 ed 09 00 00       	call   801170 <__umoddi3>
  800783:	89 74 24 04          	mov    %esi,0x4(%esp)
  800787:	0f be 80 1d 13 80 00 	movsbl 0x80131d(%eax),%eax
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800794:	83 c4 4c             	add    $0x4c,%esp
  800797:	5b                   	pop    %ebx
  800798:	5e                   	pop    %esi
  800799:	5f                   	pop    %edi
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079f:	83 fa 01             	cmp    $0x1,%edx
  8007a2:	7e 0e                	jle    8007b2 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007a4:	8b 10                	mov    (%eax),%edx
  8007a6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007a9:	89 08                	mov    %ecx,(%eax)
  8007ab:	8b 02                	mov    (%edx),%eax
  8007ad:	8b 52 04             	mov    0x4(%edx),%edx
  8007b0:	eb 22                	jmp    8007d4 <getuint+0x38>
	else if (lflag)
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	74 10                	je     8007c6 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007b6:	8b 10                	mov    (%eax),%edx
  8007b8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007bb:	89 08                	mov    %ecx,(%eax)
  8007bd:	8b 02                	mov    (%edx),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	eb 0e                	jmp    8007d4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007cb:	89 08                	mov    %ecx,(%eax)
  8007cd:	8b 02                	mov    (%edx),%eax
  8007cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007dc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e0:	8b 10                	mov    (%eax),%edx
  8007e2:	3b 50 04             	cmp    0x4(%eax),%edx
  8007e5:	73 0a                	jae    8007f1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ea:	88 0a                	mov    %cl,(%edx)
  8007ec:	83 c2 01             	add    $0x1,%edx
  8007ef:	89 10                	mov    %edx,(%eax)
}
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	57                   	push   %edi
  8007f7:	56                   	push   %esi
  8007f8:	53                   	push   %ebx
  8007f9:	83 ec 4c             	sub    $0x4c,%esp
  8007fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800802:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800805:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80080c:	eb 11                	jmp    80081f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80080e:	85 c0                	test   %eax,%eax
  800810:	0f 84 b6 03 00 00    	je     800bcc <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800816:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081a:	89 04 24             	mov    %eax,(%esp)
  80081d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081f:	0f b6 03             	movzbl (%ebx),%eax
  800822:	83 c3 01             	add    $0x1,%ebx
  800825:	83 f8 25             	cmp    $0x25,%eax
  800828:	75 e4                	jne    80080e <vprintfmt+0x1b>
  80082a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80082e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800835:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80083c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800843:	b9 00 00 00 00       	mov    $0x0,%ecx
  800848:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80084b:	eb 06                	jmp    800853 <vprintfmt+0x60>
  80084d:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800851:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800853:	0f b6 0b             	movzbl (%ebx),%ecx
  800856:	0f b6 c1             	movzbl %cl,%eax
  800859:	8d 53 01             	lea    0x1(%ebx),%edx
  80085c:	83 e9 23             	sub    $0x23,%ecx
  80085f:	80 f9 55             	cmp    $0x55,%cl
  800862:	0f 87 47 03 00 00    	ja     800baf <vprintfmt+0x3bc>
  800868:	0f b6 c9             	movzbl %cl,%ecx
  80086b:	ff 24 8d 60 14 80 00 	jmp    *0x801460(,%ecx,4)
  800872:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800876:	eb d9                	jmp    800851 <vprintfmt+0x5e>
  800878:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80087f:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800884:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800887:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80088b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80088e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800891:	83 fb 09             	cmp    $0x9,%ebx
  800894:	77 30                	ja     8008c6 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800896:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800899:	eb e9                	jmp    800884 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8d 48 04             	lea    0x4(%eax),%ecx
  8008a1:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8008a9:	eb 1e                	jmp    8008c9 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b4:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bb:	eb 94                	jmp    800851 <vprintfmt+0x5e>
  8008bd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008c4:	eb 8b                	jmp    800851 <vprintfmt+0x5e>
  8008c6:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cd:	79 82                	jns    800851 <vprintfmt+0x5e>
  8008cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008d8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8008db:	e9 71 ff ff ff       	jmp    800851 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008e4:	e9 68 ff ff ff       	jmp    800851 <vprintfmt+0x5e>
  8008e9:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8d 50 04             	lea    0x4(%eax),%edx
  8008f2:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	89 04 24             	mov    %eax,(%esp)
  8008fe:	ff d7                	call   *%edi
  800900:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800903:	e9 17 ff ff ff       	jmp    80081f <vprintfmt+0x2c>
  800908:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8d 50 04             	lea    0x4(%eax),%edx
  800911:	89 55 14             	mov    %edx,0x14(%ebp)
  800914:	8b 00                	mov    (%eax),%eax
  800916:	89 c2                	mov    %eax,%edx
  800918:	c1 fa 1f             	sar    $0x1f,%edx
  80091b:	31 d0                	xor    %edx,%eax
  80091d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80091f:	83 f8 11             	cmp    $0x11,%eax
  800922:	7f 0b                	jg     80092f <vprintfmt+0x13c>
  800924:	8b 14 85 c0 15 80 00 	mov    0x8015c0(,%eax,4),%edx
  80092b:	85 d2                	test   %edx,%edx
  80092d:	75 20                	jne    80094f <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80092f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800933:	c7 44 24 08 2e 13 80 	movl   $0x80132e,0x8(%esp)
  80093a:	00 
  80093b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80093f:	89 3c 24             	mov    %edi,(%esp)
  800942:	e8 0d 03 00 00       	call   800c54 <printfmt>
  800947:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80094a:	e9 d0 fe ff ff       	jmp    80081f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80094f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800953:	c7 44 24 08 37 13 80 	movl   $0x801337,0x8(%esp)
  80095a:	00 
  80095b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80095f:	89 3c 24             	mov    %edi,(%esp)
  800962:	e8 ed 02 00 00       	call   800c54 <printfmt>
  800967:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80096a:	e9 b0 fe ff ff       	jmp    80081f <vprintfmt+0x2c>
  80096f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800972:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800978:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8d 50 04             	lea    0x4(%eax),%edx
  800981:	89 55 14             	mov    %edx,0x14(%ebp)
  800984:	8b 18                	mov    (%eax),%ebx
  800986:	85 db                	test   %ebx,%ebx
  800988:	b8 3a 13 80 00       	mov    $0x80133a,%eax
  80098d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800990:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800994:	7e 76                	jle    800a0c <vprintfmt+0x219>
  800996:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80099a:	74 7a                	je     800a16 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009a0:	89 1c 24             	mov    %ebx,(%esp)
  8009a3:	e8 f0 02 00 00       	call   800c98 <strnlen>
  8009a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ab:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8009ad:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009b4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009b7:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c2:	89 04 24             	mov    %eax,(%esp)
  8009c5:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c7:	83 eb 01             	sub    $0x1,%ebx
  8009ca:	85 db                	test   %ebx,%ebx
  8009cc:	7f ed                	jg     8009bb <vprintfmt+0x1c8>
  8009ce:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8009d1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009d4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009d7:	89 f7                	mov    %esi,%edi
  8009d9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8009dc:	eb 40                	jmp    800a1e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009de:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009e2:	74 18                	je     8009fc <vprintfmt+0x209>
  8009e4:	8d 50 e0             	lea    -0x20(%eax),%edx
  8009e7:	83 fa 5e             	cmp    $0x5e,%edx
  8009ea:	76 10                	jbe    8009fc <vprintfmt+0x209>
					putch('?', putdat);
  8009ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009f7:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009fa:	eb 0a                	jmp    800a06 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8009fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a00:	89 04 24             	mov    %eax,(%esp)
  800a03:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a06:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a0a:	eb 12                	jmp    800a1e <vprintfmt+0x22b>
  800a0c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a0f:	89 f7                	mov    %esi,%edi
  800a11:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a14:	eb 08                	jmp    800a1e <vprintfmt+0x22b>
  800a16:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a19:	89 f7                	mov    %esi,%edi
  800a1b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a1e:	0f be 03             	movsbl (%ebx),%eax
  800a21:	83 c3 01             	add    $0x1,%ebx
  800a24:	85 c0                	test   %eax,%eax
  800a26:	74 25                	je     800a4d <vprintfmt+0x25a>
  800a28:	85 f6                	test   %esi,%esi
  800a2a:	78 b2                	js     8009de <vprintfmt+0x1eb>
  800a2c:	83 ee 01             	sub    $0x1,%esi
  800a2f:	79 ad                	jns    8009de <vprintfmt+0x1eb>
  800a31:	89 fe                	mov    %edi,%esi
  800a33:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a36:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a39:	eb 1a                	jmp    800a55 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a3b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a3f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a46:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a48:	83 eb 01             	sub    $0x1,%ebx
  800a4b:	eb 08                	jmp    800a55 <vprintfmt+0x262>
  800a4d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a50:	89 fe                	mov    %edi,%esi
  800a52:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a55:	85 db                	test   %ebx,%ebx
  800a57:	7f e2                	jg     800a3b <vprintfmt+0x248>
  800a59:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a5c:	e9 be fd ff ff       	jmp    80081f <vprintfmt+0x2c>
  800a61:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a64:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a67:	83 f9 01             	cmp    $0x1,%ecx
  800a6a:	7e 16                	jle    800a82 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	8d 50 08             	lea    0x8(%eax),%edx
  800a72:	89 55 14             	mov    %edx,0x14(%ebp)
  800a75:	8b 10                	mov    (%eax),%edx
  800a77:	8b 48 04             	mov    0x4(%eax),%ecx
  800a7a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800a7d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a80:	eb 32                	jmp    800ab4 <vprintfmt+0x2c1>
	else if (lflag)
  800a82:	85 c9                	test   %ecx,%ecx
  800a84:	74 18                	je     800a9e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	8d 50 04             	lea    0x4(%eax),%edx
  800a8c:	89 55 14             	mov    %edx,0x14(%ebp)
  800a8f:	8b 00                	mov    (%eax),%eax
  800a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a94:	89 c1                	mov    %eax,%ecx
  800a96:	c1 f9 1f             	sar    $0x1f,%ecx
  800a99:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a9c:	eb 16                	jmp    800ab4 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	8d 50 04             	lea    0x4(%eax),%edx
  800aa4:	89 55 14             	mov    %edx,0x14(%ebp)
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aac:	89 c2                	mov    %eax,%edx
  800aae:	c1 fa 1f             	sar    $0x1f,%edx
  800ab1:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800ab7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800aba:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800abf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ac3:	0f 89 a7 00 00 00    	jns    800b70 <vprintfmt+0x37d>
				putch('-', putdat);
  800ac9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800acd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ad4:	ff d7                	call   *%edi
				num = -(long long) num;
  800ad6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800ad9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800adc:	f7 d9                	neg    %ecx
  800ade:	83 d3 00             	adc    $0x0,%ebx
  800ae1:	f7 db                	neg    %ebx
  800ae3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae8:	e9 83 00 00 00       	jmp    800b70 <vprintfmt+0x37d>
  800aed:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800af0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af3:	89 ca                	mov    %ecx,%edx
  800af5:	8d 45 14             	lea    0x14(%ebp),%eax
  800af8:	e8 9f fc ff ff       	call   80079c <getuint>
  800afd:	89 c1                	mov    %eax,%ecx
  800aff:	89 d3                	mov    %edx,%ebx
  800b01:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800b06:	eb 68                	jmp    800b70 <vprintfmt+0x37d>
  800b08:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b0b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b0e:	89 ca                	mov    %ecx,%edx
  800b10:	8d 45 14             	lea    0x14(%ebp),%eax
  800b13:	e8 84 fc ff ff       	call   80079c <getuint>
  800b18:	89 c1                	mov    %eax,%ecx
  800b1a:	89 d3                	mov    %edx,%ebx
  800b1c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b21:	eb 4d                	jmp    800b70 <vprintfmt+0x37d>
  800b23:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b26:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b2a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b31:	ff d7                	call   *%edi
			putch('x', putdat);
  800b33:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b37:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b3e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b40:	8b 45 14             	mov    0x14(%ebp),%eax
  800b43:	8d 50 04             	lea    0x4(%eax),%edx
  800b46:	89 55 14             	mov    %edx,0x14(%ebp)
  800b49:	8b 08                	mov    (%eax),%ecx
  800b4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b50:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b55:	eb 19                	jmp    800b70 <vprintfmt+0x37d>
  800b57:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b5a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b5d:	89 ca                	mov    %ecx,%edx
  800b5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b62:	e8 35 fc ff ff       	call   80079c <getuint>
  800b67:	89 c1                	mov    %eax,%ecx
  800b69:	89 d3                	mov    %edx,%ebx
  800b6b:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b70:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800b74:	89 54 24 10          	mov    %edx,0x10(%esp)
  800b78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b7b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b83:	89 0c 24             	mov    %ecx,(%esp)
  800b86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b8a:	89 f2                	mov    %esi,%edx
  800b8c:	89 f8                	mov    %edi,%eax
  800b8e:	e8 21 fb ff ff       	call   8006b4 <printnum>
  800b93:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b96:	e9 84 fc ff ff       	jmp    80081f <vprintfmt+0x2c>
  800b9b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba2:	89 04 24             	mov    %eax,(%esp)
  800ba5:	ff d7                	call   *%edi
  800ba7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800baa:	e9 70 fc ff ff       	jmp    80081f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800baf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bb3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bba:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800bbf:	80 38 25             	cmpb   $0x25,(%eax)
  800bc2:	0f 84 57 fc ff ff    	je     80081f <vprintfmt+0x2c>
  800bc8:	89 c3                	mov    %eax,%ebx
  800bca:	eb f0                	jmp    800bbc <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800bcc:	83 c4 4c             	add    $0x4c,%esp
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 28             	sub    $0x28,%esp
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800be0:	85 c0                	test   %eax,%eax
  800be2:	74 04                	je     800be8 <vsnprintf+0x14>
  800be4:	85 d2                	test   %edx,%edx
  800be6:	7f 07                	jg     800bef <vsnprintf+0x1b>
  800be8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bed:	eb 3b                	jmp    800c2a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c00:	8b 45 14             	mov    0x14(%ebp),%eax
  800c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c15:	c7 04 24 d6 07 80 00 	movl   $0x8007d6,(%esp)
  800c1c:	e8 d2 fb ff ff       	call   8007f3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c24:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c32:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c39:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	89 04 24             	mov    %eax,(%esp)
  800c4d:	e8 82 ff ff ff       	call   800bd4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c5a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c61:	8b 45 10             	mov    0x10(%ebp),%eax
  800c64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 04 24             	mov    %eax,(%esp)
  800c75:	e8 79 fb ff ff       	call   8007f3 <vprintfmt>
	va_end(ap);
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    
  800c7c:	00 00                	add    %al,(%eax)
	...

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
