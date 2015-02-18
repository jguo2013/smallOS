
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 47 00 00 00       	call   800078 <libmain>
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
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80003a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800041:	00 
  800042:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800049:	ee 
  80004a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800051:	e8 48 04 00 00       	call   80049e <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800056:	c7 44 24 04 20 00 10 	movl   $0xf0100020,0x4(%esp)
  80005d:	f0 
  80005e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800065:	e8 5e 02 00 00       	call   8002c8 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80006a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800071:	00 00 00 
}
  800074:	c9                   	leave  
  800075:	c3                   	ret    
	...

00800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	83 ec 18             	sub    $0x18,%esp
  80007e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800081:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800084:	8b 75 08             	mov    0x8(%ebp),%esi
  800087:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  80008a:	e8 a2 04 00 00       	call   800531 <sys_getenvid>
  80008f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800094:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800097:	2d 00 00 40 11       	sub    $0x11400000,%eax
  80009c:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	85 f6                	test   %esi,%esi
  8000a3:	7e 07                	jle    8000ac <libmain+0x34>
		binaryname = argv[0];
  8000a5:	8b 03                	mov    (%ebx),%eax
  8000a7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000b0:	89 34 24             	mov    %esi,(%esp)
  8000b3:	e8 7c ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000b8:	e8 0b 00 00 00       	call   8000c8 <exit>
}
  8000bd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000c0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000c3:	89 ec                	mov    %ebp,%esp
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    
	...

008000c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8000ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000d5:	e8 8b 04 00 00       	call   800565 <sys_env_destroy>
}
  8000da:	c9                   	leave  
  8000db:	c3                   	ret    

008000dc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
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
  8000ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f7:	89 d1                	mov    %edx,%ecx
  8000f9:	89 d3                	mov    %edx,%ebx
  8000fb:	89 d7                	mov    %edx,%edi
  8000fd:	89 d6                	mov    %edx,%esi
  8000ff:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800101:	8b 1c 24             	mov    (%esp),%ebx
  800104:	8b 74 24 04          	mov    0x4(%esp),%esi
  800108:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80010c:	89 ec                	mov    %ebp,%esp
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	89 1c 24             	mov    %ebx,(%esp)
  800119:	89 74 24 04          	mov    %esi,0x4(%esp)
  80011d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800121:	b8 00 00 00 00       	mov    $0x0,%eax
  800126:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800129:	8b 55 08             	mov    0x8(%ebp),%edx
  80012c:	89 c3                	mov    %eax,%ebx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 c6                	mov    %eax,%esi
  800132:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800134:	8b 1c 24             	mov    (%esp),%ebx
  800137:	8b 74 24 04          	mov    0x4(%esp),%esi
  80013b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80013f:	89 ec                	mov    %ebp,%esp
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	89 1c 24             	mov    %ebx,(%esp)
  80014c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800150:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800154:	ba 00 00 00 00       	mov    $0x0,%edx
  800159:	b8 10 00 00 00       	mov    $0x10,%eax
  80015e:	89 d1                	mov    %edx,%ecx
  800160:	89 d3                	mov    %edx,%ebx
  800162:	89 d7                	mov    %edx,%edi
  800164:	89 d6                	mov    %edx,%esi
  800166:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800168:	8b 1c 24             	mov    (%esp),%ebx
  80016b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80016f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800173:	89 ec                	mov    %ebp,%esp
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 38             	sub    $0x38,%esp
  80017d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800180:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800183:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800186:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800193:	8b 55 08             	mov    0x8(%ebp),%edx
  800196:	89 df                	mov    %ebx,%edi
  800198:	89 de                	mov    %ebx,%esi
  80019a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80019c:	85 c0                	test   %eax,%eax
  80019e:	7e 28                	jle    8001c8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001a4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8001ab:	00 
  8001ac:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  8001b3:	00 
  8001b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001bb:	00 
  8001bc:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  8001c3:	e8 fc 03 00 00       	call   8005c4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  8001c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001d1:	89 ec                	mov    %ebp,%esp
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	83 ec 38             	sub    $0x38,%esp
  8001db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	89 df                	mov    %ebx,%edi
  8001f6:	89 de                	mov    %ebx,%esi
  8001f8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7e 28                	jle    800226 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800202:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800209:	00 
  80020a:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  800211:	00 
  800212:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800219:	00 
  80021a:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  800221:	e8 9e 03 00 00       	call   8005c4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800226:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800229:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80022c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80022f:	89 ec                	mov    %ebp,%esp
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 38             	sub    $0x38,%esp
  800239:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80023c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80023f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	b8 0d 00 00 00       	mov    $0xd,%eax
  80024c:	8b 55 08             	mov    0x8(%ebp),%edx
  80024f:	89 cb                	mov    %ecx,%ebx
  800251:	89 cf                	mov    %ecx,%edi
  800253:	89 ce                	mov    %ecx,%esi
  800255:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800257:	85 c0                	test   %eax,%eax
  800259:	7e 28                	jle    800283 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80025b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80025f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800266:	00 
  800267:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  80026e:	00 
  80026f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800276:	00 
  800277:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  80027e:	e8 41 03 00 00       	call   8005c4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800283:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800286:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800289:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80028c:	89 ec                	mov    %ebp,%esp
  80028e:	5d                   	pop    %ebp
  80028f:	c3                   	ret    

00800290 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	89 1c 24             	mov    %ebx,(%esp)
  800299:	89 74 24 04          	mov    %esi,0x4(%esp)
  80029d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002a1:	be 00 00 00 00       	mov    $0x0,%esi
  8002a6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002b9:	8b 1c 24             	mov    (%esp),%ebx
  8002bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002c0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8002c4:	89 ec                	mov    %ebp,%esp
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 38             	sub    $0x38,%esp
  8002ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002d4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e7:	89 df                	mov    %ebx,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002ed:	85 c0                	test   %eax,%eax
  8002ef:	7e 28                	jle    800319 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002f5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002fc:	00 
  8002fd:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  800304:	00 
  800305:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80030c:	00 
  80030d:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  800314:	e8 ab 02 00 00       	call   8005c4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800319:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80031c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80031f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800322:	89 ec                	mov    %ebp,%esp
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 38             	sub    $0x38,%esp
  80032c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80032f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800332:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800335:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033a:	b8 09 00 00 00       	mov    $0x9,%eax
  80033f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800342:	8b 55 08             	mov    0x8(%ebp),%edx
  800345:	89 df                	mov    %ebx,%edi
  800347:	89 de                	mov    %ebx,%esi
  800349:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80034b:	85 c0                	test   %eax,%eax
  80034d:	7e 28                	jle    800377 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80034f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800353:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80035a:	00 
  80035b:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  800362:	00 
  800363:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80036a:	00 
  80036b:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  800372:	e8 4d 02 00 00       	call   8005c4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800377:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80037a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80037d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800380:	89 ec                	mov    %ebp,%esp
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 38             	sub    $0x38,%esp
  80038a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80038d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800390:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800393:	bb 00 00 00 00       	mov    $0x0,%ebx
  800398:	b8 08 00 00 00       	mov    $0x8,%eax
  80039d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a3:	89 df                	mov    %ebx,%edi
  8003a5:	89 de                	mov    %ebx,%esi
  8003a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	7e 28                	jle    8003d5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003b1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8003b8:	00 
  8003b9:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  8003c0:	00 
  8003c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003c8:	00 
  8003c9:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  8003d0:	e8 ef 01 00 00       	call   8005c4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8003d5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003d8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003db:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003de:	89 ec                	mov    %ebp,%esp
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 38             	sub    $0x38,%esp
  8003e8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003eb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003ee:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8003fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800401:	89 df                	mov    %ebx,%edi
  800403:	89 de                	mov    %ebx,%esi
  800405:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800407:	85 c0                	test   %eax,%eax
  800409:	7e 28                	jle    800433 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80040b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80040f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800416:	00 
  800417:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  80041e:	00 
  80041f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800426:	00 
  800427:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  80042e:	e8 91 01 00 00       	call   8005c4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800433:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800436:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800439:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80043c:	89 ec                	mov    %ebp,%esp
  80043e:	5d                   	pop    %ebp
  80043f:	c3                   	ret    

00800440 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	83 ec 38             	sub    $0x38,%esp
  800446:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800449:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80044c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80044f:	b8 05 00 00 00       	mov    $0x5,%eax
  800454:	8b 75 18             	mov    0x18(%ebp),%esi
  800457:	8b 7d 14             	mov    0x14(%ebp),%edi
  80045a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80045d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800460:	8b 55 08             	mov    0x8(%ebp),%edx
  800463:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800465:	85 c0                	test   %eax,%eax
  800467:	7e 28                	jle    800491 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800469:	89 44 24 10          	mov    %eax,0x10(%esp)
  80046d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800474:	00 
  800475:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  80047c:	00 
  80047d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800484:	00 
  800485:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  80048c:	e8 33 01 00 00       	call   8005c4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800491:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800494:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800497:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80049a:	89 ec                	mov    %ebp,%esp
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 38             	sub    $0x38,%esp
  8004a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8004a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8004aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004ad:	be 00 00 00 00       	mov    $0x0,%esi
  8004b2:	b8 04 00 00 00       	mov    $0x4,%eax
  8004b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c0:	89 f7                	mov    %esi,%edi
  8004c2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004c4:	85 c0                	test   %eax,%eax
  8004c6:	7e 28                	jle    8004f0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004cc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8004d3:	00 
  8004d4:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  8004db:	00 
  8004dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004e3:	00 
  8004e4:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  8004eb:	e8 d4 00 00 00       	call   8005c4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004f9:	89 ec                	mov    %ebp,%esp
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
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
  800513:	b8 0b 00 00 00       	mov    $0xb,%eax
  800518:	89 d1                	mov    %edx,%ecx
  80051a:	89 d3                	mov    %edx,%ebx
  80051c:	89 d7                	mov    %edx,%edi
  80051e:	89 d6                	mov    %edx,%esi
  800520:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800522:	8b 1c 24             	mov    (%esp),%ebx
  800525:	8b 74 24 04          	mov    0x4(%esp),%esi
  800529:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80052d:	89 ec                	mov    %ebp,%esp
  80052f:	5d                   	pop    %ebp
  800530:	c3                   	ret    

00800531 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	89 1c 24             	mov    %ebx,(%esp)
  80053a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80053e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800542:	ba 00 00 00 00       	mov    $0x0,%edx
  800547:	b8 02 00 00 00       	mov    $0x2,%eax
  80054c:	89 d1                	mov    %edx,%ecx
  80054e:	89 d3                	mov    %edx,%ebx
  800550:	89 d7                	mov    %edx,%edi
  800552:	89 d6                	mov    %edx,%esi
  800554:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800556:	8b 1c 24             	mov    (%esp),%ebx
  800559:	8b 74 24 04          	mov    0x4(%esp),%esi
  80055d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800561:	89 ec                	mov    %ebp,%esp
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    

00800565 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	83 ec 38             	sub    $0x38,%esp
  80056b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80056e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800571:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800574:	b9 00 00 00 00       	mov    $0x0,%ecx
  800579:	b8 03 00 00 00       	mov    $0x3,%eax
  80057e:	8b 55 08             	mov    0x8(%ebp),%edx
  800581:	89 cb                	mov    %ecx,%ebx
  800583:	89 cf                	mov    %ecx,%edi
  800585:	89 ce                	mov    %ecx,%esi
  800587:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800589:	85 c0                	test   %eax,%eax
  80058b:	7e 28                	jle    8005b5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80058d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800591:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800598:	00 
  800599:	c7 44 24 08 ea 12 80 	movl   $0x8012ea,0x8(%esp)
  8005a0:	00 
  8005a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005a8:	00 
  8005a9:	c7 04 24 07 13 80 00 	movl   $0x801307,(%esp)
  8005b0:	e8 0f 00 00 00       	call   8005c4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8005b5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8005b8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8005bb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005be:	89 ec                	mov    %ebp,%esp
  8005c0:	5d                   	pop    %ebp
  8005c1:	c3                   	ret    
	...

008005c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	56                   	push   %esi
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8005cc:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005cf:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  8005d5:	e8 57 ff ff ff       	call   800531 <sys_getenvid>
  8005da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005dd:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f0:	c7 04 24 18 13 80 00 	movl   $0x801318,(%esp)
  8005f7:	e8 81 00 00 00       	call   80067d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	89 04 24             	mov    %eax,(%esp)
  800606:	e8 11 00 00 00       	call   80061c <vcprintf>
	cprintf("\n");
  80060b:	c7 04 24 3b 13 80 00 	movl   $0x80133b,(%esp)
  800612:	e8 66 00 00 00       	call   80067d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800617:	cc                   	int3   
  800618:	eb fd                	jmp    800617 <_panic+0x53>
	...

0080061c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80061c:	55                   	push   %ebp
  80061d:	89 e5                	mov    %esp,%ebp
  80061f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800625:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80062c:	00 00 00 
	b.cnt = 0;
  80062f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800636:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	89 44 24 08          	mov    %eax,0x8(%esp)
  800647:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80064d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800651:	c7 04 24 97 06 80 00 	movl   $0x800697,(%esp)
  800658:	e8 be 01 00 00       	call   80081b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80065d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800663:	89 44 24 04          	mov    %eax,0x4(%esp)
  800667:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80066d:	89 04 24             	mov    %eax,(%esp)
  800670:	e8 9b fa ff ff       	call   800110 <sys_cputs>

	return b.cnt;
}
  800675:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800683:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 04 24             	mov    %eax,(%esp)
  800690:	e8 87 ff ff ff       	call   80061c <vcprintf>
	va_end(ap);

	return cnt;
}
  800695:	c9                   	leave  
  800696:	c3                   	ret    

00800697 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	53                   	push   %ebx
  80069b:	83 ec 14             	sub    $0x14,%esp
  80069e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006a1:	8b 03                	mov    (%ebx),%eax
  8006a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006aa:	83 c0 01             	add    $0x1,%eax
  8006ad:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b4:	75 19                	jne    8006cf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8006b6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006bd:	00 
  8006be:	8d 43 08             	lea    0x8(%ebx),%eax
  8006c1:	89 04 24             	mov    %eax,(%esp)
  8006c4:	e8 47 fa ff ff       	call   800110 <sys_cputs>
		b->idx = 0;
  8006c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006d3:	83 c4 14             	add    $0x14,%esp
  8006d6:	5b                   	pop    %ebx
  8006d7:	5d                   	pop    %ebp
  8006d8:	c3                   	ret    
  8006d9:	00 00                	add    %al,(%eax)
	...

008006dc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	57                   	push   %edi
  8006e0:	56                   	push   %esi
  8006e1:	53                   	push   %ebx
  8006e2:	83 ec 4c             	sub    $0x4c,%esp
  8006e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e8:	89 d6                	mov    %edx,%esi
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006fc:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	39 d1                	cmp    %edx,%ecx
  800709:	72 07                	jb     800712 <printnum+0x36>
  80070b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80070e:	39 d0                	cmp    %edx,%eax
  800710:	77 69                	ja     80077b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800712:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800716:	83 eb 01             	sub    $0x1,%ebx
  800719:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80071d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800721:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800725:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800729:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80072c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80072f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800732:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800736:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80073d:	00 
  80073e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800741:	89 04 24             	mov    %eax,(%esp)
  800744:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800747:	89 54 24 04          	mov    %edx,0x4(%esp)
  80074b:	e8 20 09 00 00       	call   801070 <__udivdi3>
  800750:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800753:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800756:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80075a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	89 54 24 04          	mov    %edx,0x4(%esp)
  800765:	89 f2                	mov    %esi,%edx
  800767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80076a:	e8 6d ff ff ff       	call   8006dc <printnum>
  80076f:	eb 11                	jmp    800782 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	89 74 24 04          	mov    %esi,0x4(%esp)
  800775:	89 3c 24             	mov    %edi,(%esp)
  800778:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077b:	83 eb 01             	sub    $0x1,%ebx
  80077e:	85 db                	test   %ebx,%ebx
  800780:	7f ef                	jg     800771 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800782:	89 74 24 04          	mov    %esi,0x4(%esp)
  800786:	8b 74 24 04          	mov    0x4(%esp),%esi
  80078a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80078d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800791:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800798:	00 
  800799:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80079c:	89 14 24             	mov    %edx,(%esp)
  80079f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007a6:	e8 f5 09 00 00       	call   8011a0 <__umoddi3>
  8007ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007af:	0f be 80 3d 13 80 00 	movsbl 0x80133d(%eax),%eax
  8007b6:	89 04 24             	mov    %eax,(%esp)
  8007b9:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8007bc:	83 c4 4c             	add    $0x4c,%esp
  8007bf:	5b                   	pop    %ebx
  8007c0:	5e                   	pop    %esi
  8007c1:	5f                   	pop    %edi
  8007c2:	5d                   	pop    %ebp
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 fa 01             	cmp    $0x1,%edx
  8007ca:	7e 0e                	jle    8007da <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007cc:	8b 10                	mov    (%eax),%edx
  8007ce:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007d1:	89 08                	mov    %ecx,(%eax)
  8007d3:	8b 02                	mov    (%edx),%eax
  8007d5:	8b 52 04             	mov    0x4(%edx),%edx
  8007d8:	eb 22                	jmp    8007fc <getuint+0x38>
	else if (lflag)
  8007da:	85 d2                	test   %edx,%edx
  8007dc:	74 10                	je     8007ee <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007e3:	89 08                	mov    %ecx,(%eax)
  8007e5:	8b 02                	mov    (%edx),%eax
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ec:	eb 0e                	jmp    8007fc <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007ee:	8b 10                	mov    (%eax),%edx
  8007f0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007f3:	89 08                	mov    %ecx,(%eax)
  8007f5:	8b 02                	mov    (%edx),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800804:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800808:	8b 10                	mov    (%eax),%edx
  80080a:	3b 50 04             	cmp    0x4(%eax),%edx
  80080d:	73 0a                	jae    800819 <sprintputch+0x1b>
		*b->buf++ = ch;
  80080f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800812:	88 0a                	mov    %cl,(%edx)
  800814:	83 c2 01             	add    $0x1,%edx
  800817:	89 10                	mov    %edx,(%eax)
}
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	57                   	push   %edi
  80081f:	56                   	push   %esi
  800820:	53                   	push   %ebx
  800821:	83 ec 4c             	sub    $0x4c,%esp
  800824:	8b 7d 08             	mov    0x8(%ebp),%edi
  800827:	8b 75 0c             	mov    0xc(%ebp),%esi
  80082a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800834:	eb 11                	jmp    800847 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800836:	85 c0                	test   %eax,%eax
  800838:	0f 84 b6 03 00 00    	je     800bf4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80083e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800842:	89 04 24             	mov    %eax,(%esp)
  800845:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800847:	0f b6 03             	movzbl (%ebx),%eax
  80084a:	83 c3 01             	add    $0x1,%ebx
  80084d:	83 f8 25             	cmp    $0x25,%eax
  800850:	75 e4                	jne    800836 <vprintfmt+0x1b>
  800852:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800856:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80085d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800864:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80086b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800870:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800873:	eb 06                	jmp    80087b <vprintfmt+0x60>
  800875:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800879:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087b:	0f b6 0b             	movzbl (%ebx),%ecx
  80087e:	0f b6 c1             	movzbl %cl,%eax
  800881:	8d 53 01             	lea    0x1(%ebx),%edx
  800884:	83 e9 23             	sub    $0x23,%ecx
  800887:	80 f9 55             	cmp    $0x55,%cl
  80088a:	0f 87 47 03 00 00    	ja     800bd7 <vprintfmt+0x3bc>
  800890:	0f b6 c9             	movzbl %cl,%ecx
  800893:	ff 24 8d 80 14 80 00 	jmp    *0x801480(,%ecx,4)
  80089a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80089e:	eb d9                	jmp    800879 <vprintfmt+0x5e>
  8008a0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8008a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008ac:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008af:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008b3:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8008b6:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008b9:	83 fb 09             	cmp    $0x9,%ebx
  8008bc:	77 30                	ja     8008ee <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008be:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008c1:	eb e9                	jmp    8008ac <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 48 04             	lea    0x4(%eax),%ecx
  8008c9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8008d1:	eb 1e                	jmp    8008f1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8008d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8008e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e3:	eb 94                	jmp    800879 <vprintfmt+0x5e>
  8008e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8008ec:	eb 8b                	jmp    800879 <vprintfmt+0x5e>
  8008ee:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	79 82                	jns    800879 <vprintfmt+0x5e>
  8008f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008fd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800900:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800903:	e9 71 ff ff ff       	jmp    800879 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800908:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80090c:	e9 68 ff ff ff       	jmp    800879 <vprintfmt+0x5e>
  800911:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8d 50 04             	lea    0x4(%eax),%edx
  80091a:	89 55 14             	mov    %edx,0x14(%ebp)
  80091d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 04 24             	mov    %eax,(%esp)
  800926:	ff d7                	call   *%edi
  800928:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80092b:	e9 17 ff ff ff       	jmp    800847 <vprintfmt+0x2c>
  800930:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8d 50 04             	lea    0x4(%eax),%edx
  800939:	89 55 14             	mov    %edx,0x14(%ebp)
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	89 c2                	mov    %eax,%edx
  800940:	c1 fa 1f             	sar    $0x1f,%edx
  800943:	31 d0                	xor    %edx,%eax
  800945:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800947:	83 f8 11             	cmp    $0x11,%eax
  80094a:	7f 0b                	jg     800957 <vprintfmt+0x13c>
  80094c:	8b 14 85 e0 15 80 00 	mov    0x8015e0(,%eax,4),%edx
  800953:	85 d2                	test   %edx,%edx
  800955:	75 20                	jne    800977 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800957:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80095b:	c7 44 24 08 4e 13 80 	movl   $0x80134e,0x8(%esp)
  800962:	00 
  800963:	89 74 24 04          	mov    %esi,0x4(%esp)
  800967:	89 3c 24             	mov    %edi,(%esp)
  80096a:	e8 0d 03 00 00       	call   800c7c <printfmt>
  80096f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800972:	e9 d0 fe ff ff       	jmp    800847 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800977:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80097b:	c7 44 24 08 57 13 80 	movl   $0x801357,0x8(%esp)
  800982:	00 
  800983:	89 74 24 04          	mov    %esi,0x4(%esp)
  800987:	89 3c 24             	mov    %edi,(%esp)
  80098a:	e8 ed 02 00 00       	call   800c7c <printfmt>
  80098f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800992:	e9 b0 fe ff ff       	jmp    800847 <vprintfmt+0x2c>
  800997:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80099a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80099d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	8d 50 04             	lea    0x4(%eax),%edx
  8009a9:	89 55 14             	mov    %edx,0x14(%ebp)
  8009ac:	8b 18                	mov    (%eax),%ebx
  8009ae:	85 db                	test   %ebx,%ebx
  8009b0:	b8 5a 13 80 00       	mov    $0x80135a,%eax
  8009b5:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8009b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009bc:	7e 76                	jle    800a34 <vprintfmt+0x219>
  8009be:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8009c2:	74 7a                	je     800a3e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009c8:	89 1c 24             	mov    %ebx,(%esp)
  8009cb:	e8 f8 02 00 00       	call   800cc8 <strnlen>
  8009d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009d3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8009d5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8009d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009dc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8009df:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e1:	eb 0f                	jmp    8009f2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8009e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ea:	89 04 24             	mov    %eax,(%esp)
  8009ed:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ef:	83 eb 01             	sub    $0x1,%ebx
  8009f2:	85 db                	test   %ebx,%ebx
  8009f4:	7f ed                	jg     8009e3 <vprintfmt+0x1c8>
  8009f6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8009f9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009fc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8009ff:	89 f7                	mov    %esi,%edi
  800a01:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a04:	eb 40                	jmp    800a46 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a06:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a0a:	74 18                	je     800a24 <vprintfmt+0x209>
  800a0c:	8d 50 e0             	lea    -0x20(%eax),%edx
  800a0f:	83 fa 5e             	cmp    $0x5e,%edx
  800a12:	76 10                	jbe    800a24 <vprintfmt+0x209>
					putch('?', putdat);
  800a14:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a18:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a1f:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a22:	eb 0a                	jmp    800a2e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800a24:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a28:	89 04 24             	mov    %eax,(%esp)
  800a2b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a32:	eb 12                	jmp    800a46 <vprintfmt+0x22b>
  800a34:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a37:	89 f7                	mov    %esi,%edi
  800a39:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a3c:	eb 08                	jmp    800a46 <vprintfmt+0x22b>
  800a3e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a41:	89 f7                	mov    %esi,%edi
  800a43:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a46:	0f be 03             	movsbl (%ebx),%eax
  800a49:	83 c3 01             	add    $0x1,%ebx
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	74 25                	je     800a75 <vprintfmt+0x25a>
  800a50:	85 f6                	test   %esi,%esi
  800a52:	78 b2                	js     800a06 <vprintfmt+0x1eb>
  800a54:	83 ee 01             	sub    $0x1,%esi
  800a57:	79 ad                	jns    800a06 <vprintfmt+0x1eb>
  800a59:	89 fe                	mov    %edi,%esi
  800a5b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a5e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a61:	eb 1a                	jmp    800a7d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a63:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a67:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a6e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a70:	83 eb 01             	sub    $0x1,%ebx
  800a73:	eb 08                	jmp    800a7d <vprintfmt+0x262>
  800a75:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a78:	89 fe                	mov    %edi,%esi
  800a7a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	7f e2                	jg     800a63 <vprintfmt+0x248>
  800a81:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800a84:	e9 be fd ff ff       	jmp    800847 <vprintfmt+0x2c>
  800a89:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a8c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a8f:	83 f9 01             	cmp    $0x1,%ecx
  800a92:	7e 16                	jle    800aaa <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	8d 50 08             	lea    0x8(%eax),%edx
  800a9a:	89 55 14             	mov    %edx,0x14(%ebp)
  800a9d:	8b 10                	mov    (%eax),%edx
  800a9f:	8b 48 04             	mov    0x4(%eax),%ecx
  800aa2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800aa5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800aa8:	eb 32                	jmp    800adc <vprintfmt+0x2c1>
	else if (lflag)
  800aaa:	85 c9                	test   %ecx,%ecx
  800aac:	74 18                	je     800ac6 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	8d 50 04             	lea    0x4(%eax),%edx
  800ab4:	89 55 14             	mov    %edx,0x14(%ebp)
  800ab7:	8b 00                	mov    (%eax),%eax
  800ab9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800abc:	89 c1                	mov    %eax,%ecx
  800abe:	c1 f9 1f             	sar    $0x1f,%ecx
  800ac1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ac4:	eb 16                	jmp    800adc <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	89 55 14             	mov    %edx,0x14(%ebp)
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ad4:	89 c2                	mov    %eax,%edx
  800ad6:	c1 fa 1f             	sar    $0x1f,%edx
  800ad9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800adc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800adf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ae2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ae7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aeb:	0f 89 a7 00 00 00    	jns    800b98 <vprintfmt+0x37d>
				putch('-', putdat);
  800af1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800af5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800afc:	ff d7                	call   *%edi
				num = -(long long) num;
  800afe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800b01:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b04:	f7 d9                	neg    %ecx
  800b06:	83 d3 00             	adc    $0x0,%ebx
  800b09:	f7 db                	neg    %ebx
  800b0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b10:	e9 83 00 00 00       	jmp    800b98 <vprintfmt+0x37d>
  800b15:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b18:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b1b:	89 ca                	mov    %ecx,%edx
  800b1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b20:	e8 9f fc ff ff       	call   8007c4 <getuint>
  800b25:	89 c1                	mov    %eax,%ecx
  800b27:	89 d3                	mov    %edx,%ebx
  800b29:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800b2e:	eb 68                	jmp    800b98 <vprintfmt+0x37d>
  800b30:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b33:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b36:	89 ca                	mov    %ecx,%edx
  800b38:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	89 c1                	mov    %eax,%ecx
  800b42:	89 d3                	mov    %edx,%ebx
  800b44:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b49:	eb 4d                	jmp    800b98 <vprintfmt+0x37d>
  800b4b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b52:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b59:	ff d7                	call   *%edi
			putch('x', putdat);
  800b5b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b5f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b66:	ff d7                	call   *%edi
			num = (unsigned long long)
  800b68:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6b:	8d 50 04             	lea    0x4(%eax),%edx
  800b6e:	89 55 14             	mov    %edx,0x14(%ebp)
  800b71:	8b 08                	mov    (%eax),%ecx
  800b73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b78:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b7d:	eb 19                	jmp    800b98 <vprintfmt+0x37d>
  800b7f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b82:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b85:	89 ca                	mov    %ecx,%edx
  800b87:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8a:	e8 35 fc ff ff       	call   8007c4 <getuint>
  800b8f:	89 c1                	mov    %eax,%ecx
  800b91:	89 d3                	mov    %edx,%ebx
  800b93:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b98:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800b9c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ba3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bab:	89 0c 24             	mov    %ecx,(%esp)
  800bae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bb2:	89 f2                	mov    %esi,%edx
  800bb4:	89 f8                	mov    %edi,%eax
  800bb6:	e8 21 fb ff ff       	call   8006dc <printnum>
  800bbb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bbe:	e9 84 fc ff ff       	jmp    800847 <vprintfmt+0x2c>
  800bc3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bca:	89 04 24             	mov    %eax,(%esp)
  800bcd:	ff d7                	call   *%edi
  800bcf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bd2:	e9 70 fc ff ff       	jmp    800847 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bdb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800be2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800be7:	80 38 25             	cmpb   $0x25,(%eax)
  800bea:	0f 84 57 fc ff ff    	je     800847 <vprintfmt+0x2c>
  800bf0:	89 c3                	mov    %eax,%ebx
  800bf2:	eb f0                	jmp    800be4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800bf4:	83 c4 4c             	add    $0x4c,%esp
  800bf7:	5b                   	pop    %ebx
  800bf8:	5e                   	pop    %esi
  800bf9:	5f                   	pop    %edi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    

00800bfc <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 28             	sub    $0x28,%esp
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	74 04                	je     800c10 <vsnprintf+0x14>
  800c0c:	85 d2                	test   %edx,%edx
  800c0e:	7f 07                	jg     800c17 <vsnprintf+0x1b>
  800c10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c15:	eb 3b                	jmp    800c52 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c1a:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c28:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c36:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3d:	c7 04 24 fe 07 80 00 	movl   $0x8007fe,(%esp)
  800c44:	e8 d2 fb ff ff       	call   80081b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c5a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c61:	8b 45 10             	mov    0x10(%ebp),%eax
  800c64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 04 24             	mov    %eax,(%esp)
  800c75:	e8 82 ff ff ff       	call   800bfc <vsnprintf>
	va_end(ap);

	return rc;
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800c82:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800c85:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c89:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	89 04 24             	mov    %eax,(%esp)
  800c9d:	e8 79 fb ff ff       	call   80081b <vprintfmt>
	va_end(ap);
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    
	...

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
  80106a:	00 00                	add    %al,(%eax)
  80106c:	00 00                	add    %al,(%eax)
	...

00801070 <__udivdi3>:
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	83 ec 10             	sub    $0x10,%esp
  801078:	8b 45 14             	mov    0x14(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	8b 75 10             	mov    0x10(%ebp),%esi
  801081:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801084:	85 c0                	test   %eax,%eax
  801086:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801089:	75 35                	jne    8010c0 <__udivdi3+0x50>
  80108b:	39 fe                	cmp    %edi,%esi
  80108d:	77 61                	ja     8010f0 <__udivdi3+0x80>
  80108f:	85 f6                	test   %esi,%esi
  801091:	75 0b                	jne    80109e <__udivdi3+0x2e>
  801093:	b8 01 00 00 00       	mov    $0x1,%eax
  801098:	31 d2                	xor    %edx,%edx
  80109a:	f7 f6                	div    %esi
  80109c:	89 c6                	mov    %eax,%esi
  80109e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010a1:	31 d2                	xor    %edx,%edx
  8010a3:	89 f8                	mov    %edi,%eax
  8010a5:	f7 f6                	div    %esi
  8010a7:	89 c7                	mov    %eax,%edi
  8010a9:	89 c8                	mov    %ecx,%eax
  8010ab:	f7 f6                	div    %esi
  8010ad:	89 c1                	mov    %eax,%ecx
  8010af:	89 fa                	mov    %edi,%edx
  8010b1:	89 c8                	mov    %ecx,%eax
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	5e                   	pop    %esi
  8010b7:	5f                   	pop    %edi
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    
  8010ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010c0:	39 f8                	cmp    %edi,%eax
  8010c2:	77 1c                	ja     8010e0 <__udivdi3+0x70>
  8010c4:	0f bd d0             	bsr    %eax,%edx
  8010c7:	83 f2 1f             	xor    $0x1f,%edx
  8010ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010cd:	75 39                	jne    801108 <__udivdi3+0x98>
  8010cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8010d2:	0f 86 a0 00 00 00    	jbe    801178 <__udivdi3+0x108>
  8010d8:	39 f8                	cmp    %edi,%eax
  8010da:	0f 82 98 00 00 00    	jb     801178 <__udivdi3+0x108>
  8010e0:	31 ff                	xor    %edi,%edi
  8010e2:	31 c9                	xor    %ecx,%ecx
  8010e4:	89 c8                	mov    %ecx,%eax
  8010e6:	89 fa                	mov    %edi,%edx
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	5e                   	pop    %esi
  8010ec:	5f                   	pop    %edi
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    
  8010ef:	90                   	nop
  8010f0:	89 d1                	mov    %edx,%ecx
  8010f2:	89 fa                	mov    %edi,%edx
  8010f4:	89 c8                	mov    %ecx,%eax
  8010f6:	31 ff                	xor    %edi,%edi
  8010f8:	f7 f6                	div    %esi
  8010fa:	89 c1                	mov    %eax,%ecx
  8010fc:	89 fa                	mov    %edi,%edx
  8010fe:	89 c8                	mov    %ecx,%eax
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
  801107:	90                   	nop
  801108:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80110c:	89 f2                	mov    %esi,%edx
  80110e:	d3 e0                	shl    %cl,%eax
  801110:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801113:	b8 20 00 00 00       	mov    $0x20,%eax
  801118:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80111b:	89 c1                	mov    %eax,%ecx
  80111d:	d3 ea                	shr    %cl,%edx
  80111f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801123:	0b 55 ec             	or     -0x14(%ebp),%edx
  801126:	d3 e6                	shl    %cl,%esi
  801128:	89 c1                	mov    %eax,%ecx
  80112a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80112d:	89 fe                	mov    %edi,%esi
  80112f:	d3 ee                	shr    %cl,%esi
  801131:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801135:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801138:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113b:	d3 e7                	shl    %cl,%edi
  80113d:	89 c1                	mov    %eax,%ecx
  80113f:	d3 ea                	shr    %cl,%edx
  801141:	09 d7                	or     %edx,%edi
  801143:	89 f2                	mov    %esi,%edx
  801145:	89 f8                	mov    %edi,%eax
  801147:	f7 75 ec             	divl   -0x14(%ebp)
  80114a:	89 d6                	mov    %edx,%esi
  80114c:	89 c7                	mov    %eax,%edi
  80114e:	f7 65 e8             	mull   -0x18(%ebp)
  801151:	39 d6                	cmp    %edx,%esi
  801153:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801156:	72 30                	jb     801188 <__udivdi3+0x118>
  801158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80115b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80115f:	d3 e2                	shl    %cl,%edx
  801161:	39 c2                	cmp    %eax,%edx
  801163:	73 05                	jae    80116a <__udivdi3+0xfa>
  801165:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801168:	74 1e                	je     801188 <__udivdi3+0x118>
  80116a:	89 f9                	mov    %edi,%ecx
  80116c:	31 ff                	xor    %edi,%edi
  80116e:	e9 71 ff ff ff       	jmp    8010e4 <__udivdi3+0x74>
  801173:	90                   	nop
  801174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801178:	31 ff                	xor    %edi,%edi
  80117a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80117f:	e9 60 ff ff ff       	jmp    8010e4 <__udivdi3+0x74>
  801184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801188:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80118b:	31 ff                	xor    %edi,%edi
  80118d:	89 c8                	mov    %ecx,%eax
  80118f:	89 fa                	mov    %edi,%edx
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	5e                   	pop    %esi
  801195:	5f                   	pop    %edi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    
	...

008011a0 <__umoddi3>:
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	83 ec 20             	sub    $0x20,%esp
  8011a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8011ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8011b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011b4:	85 d2                	test   %edx,%edx
  8011b6:	89 c8                	mov    %ecx,%eax
  8011b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011bb:	75 13                	jne    8011d0 <__umoddi3+0x30>
  8011bd:	39 f7                	cmp    %esi,%edi
  8011bf:	76 3f                	jbe    801200 <__umoddi3+0x60>
  8011c1:	89 f2                	mov    %esi,%edx
  8011c3:	f7 f7                	div    %edi
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	31 d2                	xor    %edx,%edx
  8011c9:	83 c4 20             	add    $0x20,%esp
  8011cc:	5e                   	pop    %esi
  8011cd:	5f                   	pop    %edi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    
  8011d0:	39 f2                	cmp    %esi,%edx
  8011d2:	77 4c                	ja     801220 <__umoddi3+0x80>
  8011d4:	0f bd ca             	bsr    %edx,%ecx
  8011d7:	83 f1 1f             	xor    $0x1f,%ecx
  8011da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011dd:	75 51                	jne    801230 <__umoddi3+0x90>
  8011df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8011e2:	0f 87 e0 00 00 00    	ja     8012c8 <__umoddi3+0x128>
  8011e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011eb:	29 f8                	sub    %edi,%eax
  8011ed:	19 d6                	sbb    %edx,%esi
  8011ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f5:	89 f2                	mov    %esi,%edx
  8011f7:	83 c4 20             	add    $0x20,%esp
  8011fa:	5e                   	pop    %esi
  8011fb:	5f                   	pop    %edi
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    
  8011fe:	66 90                	xchg   %ax,%ax
  801200:	85 ff                	test   %edi,%edi
  801202:	75 0b                	jne    80120f <__umoddi3+0x6f>
  801204:	b8 01 00 00 00       	mov    $0x1,%eax
  801209:	31 d2                	xor    %edx,%edx
  80120b:	f7 f7                	div    %edi
  80120d:	89 c7                	mov    %eax,%edi
  80120f:	89 f0                	mov    %esi,%eax
  801211:	31 d2                	xor    %edx,%edx
  801213:	f7 f7                	div    %edi
  801215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801218:	f7 f7                	div    %edi
  80121a:	eb a9                	jmp    8011c5 <__umoddi3+0x25>
  80121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801220:	89 c8                	mov    %ecx,%eax
  801222:	89 f2                	mov    %esi,%edx
  801224:	83 c4 20             	add    $0x20,%esp
  801227:	5e                   	pop    %esi
  801228:	5f                   	pop    %edi
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    
  80122b:	90                   	nop
  80122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801230:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801234:	d3 e2                	shl    %cl,%edx
  801236:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801239:	ba 20 00 00 00       	mov    $0x20,%edx
  80123e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801241:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801244:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801248:	89 fa                	mov    %edi,%edx
  80124a:	d3 ea                	shr    %cl,%edx
  80124c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801250:	0b 55 f4             	or     -0xc(%ebp),%edx
  801253:	d3 e7                	shl    %cl,%edi
  801255:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801259:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125c:	89 f2                	mov    %esi,%edx
  80125e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801261:	89 c7                	mov    %eax,%edi
  801263:	d3 ea                	shr    %cl,%edx
  801265:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801269:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80126c:	89 c2                	mov    %eax,%edx
  80126e:	d3 e6                	shl    %cl,%esi
  801270:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801274:	d3 ea                	shr    %cl,%edx
  801276:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80127a:	09 d6                	or     %edx,%esi
  80127c:	89 f0                	mov    %esi,%eax
  80127e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801281:	d3 e7                	shl    %cl,%edi
  801283:	89 f2                	mov    %esi,%edx
  801285:	f7 75 f4             	divl   -0xc(%ebp)
  801288:	89 d6                	mov    %edx,%esi
  80128a:	f7 65 e8             	mull   -0x18(%ebp)
  80128d:	39 d6                	cmp    %edx,%esi
  80128f:	72 2b                	jb     8012bc <__umoddi3+0x11c>
  801291:	39 c7                	cmp    %eax,%edi
  801293:	72 23                	jb     8012b8 <__umoddi3+0x118>
  801295:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801299:	29 c7                	sub    %eax,%edi
  80129b:	19 d6                	sbb    %edx,%esi
  80129d:	89 f0                	mov    %esi,%eax
  80129f:	89 f2                	mov    %esi,%edx
  8012a1:	d3 ef                	shr    %cl,%edi
  8012a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8012a7:	d3 e0                	shl    %cl,%eax
  8012a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8012ad:	09 f8                	or     %edi,%eax
  8012af:	d3 ea                	shr    %cl,%edx
  8012b1:	83 c4 20             	add    $0x20,%esp
  8012b4:	5e                   	pop    %esi
  8012b5:	5f                   	pop    %edi
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    
  8012b8:	39 d6                	cmp    %edx,%esi
  8012ba:	75 d9                	jne    801295 <__umoddi3+0xf5>
  8012bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8012bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8012c2:	eb d1                	jmp    801295 <__umoddi3+0xf5>
  8012c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012c8:	39 f2                	cmp    %esi,%edx
  8012ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012d0:	0f 82 12 ff ff ff    	jb     8011e8 <__umoddi3+0x48>
  8012d6:	e9 17 ff ff ff       	jmp    8011f2 <__umoddi3+0x52>
