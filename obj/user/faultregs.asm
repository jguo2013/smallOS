
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 67 05 00 00       	call   800598 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 1c             	sub    $0x1c,%esp
  80003d:	89 c3                	mov    %eax,%ebx
  80003f:	89 ce                	mov    %ecx,%esi
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800041:	8b 45 08             	mov    0x8(%ebp),%eax
  800044:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800048:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004c:	c7 44 24 04 d1 18 80 	movl   $0x8018d1,0x4(%esp)
  800053:	00 
  800054:	c7 04 24 a0 18 80 00 	movl   $0x8018a0,(%esp)
  80005b:	e8 55 06 00 00       	call   8006b5 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800060:	8b 06                	mov    (%esi),%eax
  800062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800066:	8b 03                	mov    (%ebx),%eax
  800068:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006c:	c7 44 24 04 b0 18 80 	movl   $0x8018b0,0x4(%esp)
  800073:	00 
  800074:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  80007b:	e8 35 06 00 00       	call   8006b5 <cprintf>
  800080:	8b 03                	mov    (%ebx),%eax
  800082:	3b 06                	cmp    (%esi),%eax
  800084:	75 13                	jne    800099 <check_regs+0x65>
  800086:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  80008d:	e8 23 06 00 00       	call   8006b5 <cprintf>
  800092:	bf 00 00 00 00       	mov    $0x0,%edi
  800097:	eb 11                	jmp    8000aa <check_regs+0x76>
  800099:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  8000a0:	e8 10 06 00 00       	call   8006b5 <cprintf>
  8000a5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000aa:	8b 46 04             	mov    0x4(%esi),%eax
  8000ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8000b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b8:	c7 44 24 04 d2 18 80 	movl   $0x8018d2,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  8000c7:	e8 e9 05 00 00       	call   8006b5 <cprintf>
  8000cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8000cf:	3b 46 04             	cmp    0x4(%esi),%eax
  8000d2:	75 0e                	jne    8000e2 <check_regs+0xae>
  8000d4:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  8000db:	e8 d5 05 00 00       	call   8006b5 <cprintf>
  8000e0:	eb 11                	jmp    8000f3 <check_regs+0xbf>
  8000e2:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  8000e9:	e8 c7 05 00 00       	call   8006b5 <cprintf>
  8000ee:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f3:	8b 46 08             	mov    0x8(%esi),%eax
  8000f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fa:	8b 43 08             	mov    0x8(%ebx),%eax
  8000fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800101:	c7 44 24 04 d6 18 80 	movl   $0x8018d6,0x4(%esp)
  800108:	00 
  800109:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  800110:	e8 a0 05 00 00       	call   8006b5 <cprintf>
  800115:	8b 43 08             	mov    0x8(%ebx),%eax
  800118:	3b 46 08             	cmp    0x8(%esi),%eax
  80011b:	75 0e                	jne    80012b <check_regs+0xf7>
  80011d:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  800124:	e8 8c 05 00 00       	call   8006b5 <cprintf>
  800129:	eb 11                	jmp    80013c <check_regs+0x108>
  80012b:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  800132:	e8 7e 05 00 00       	call   8006b5 <cprintf>
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013c:	8b 46 10             	mov    0x10(%esi),%eax
  80013f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800143:	8b 43 10             	mov    0x10(%ebx),%eax
  800146:	89 44 24 08          	mov    %eax,0x8(%esp)
  80014a:	c7 44 24 04 da 18 80 	movl   $0x8018da,0x4(%esp)
  800151:	00 
  800152:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  800159:	e8 57 05 00 00       	call   8006b5 <cprintf>
  80015e:	8b 43 10             	mov    0x10(%ebx),%eax
  800161:	3b 46 10             	cmp    0x10(%esi),%eax
  800164:	75 0e                	jne    800174 <check_regs+0x140>
  800166:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  80016d:	e8 43 05 00 00       	call   8006b5 <cprintf>
  800172:	eb 11                	jmp    800185 <check_regs+0x151>
  800174:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  80017b:	e8 35 05 00 00       	call   8006b5 <cprintf>
  800180:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800185:	8b 46 14             	mov    0x14(%esi),%eax
  800188:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018c:	8b 43 14             	mov    0x14(%ebx),%eax
  80018f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800193:	c7 44 24 04 de 18 80 	movl   $0x8018de,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  8001a2:	e8 0e 05 00 00       	call   8006b5 <cprintf>
  8001a7:	8b 43 14             	mov    0x14(%ebx),%eax
  8001aa:	3b 46 14             	cmp    0x14(%esi),%eax
  8001ad:	75 0e                	jne    8001bd <check_regs+0x189>
  8001af:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  8001b6:	e8 fa 04 00 00       	call   8006b5 <cprintf>
  8001bb:	eb 11                	jmp    8001ce <check_regs+0x19a>
  8001bd:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  8001c4:	e8 ec 04 00 00       	call   8006b5 <cprintf>
  8001c9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001ce:	8b 46 18             	mov    0x18(%esi),%eax
  8001d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d5:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001dc:	c7 44 24 04 e2 18 80 	movl   $0x8018e2,0x4(%esp)
  8001e3:	00 
  8001e4:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  8001eb:	e8 c5 04 00 00       	call   8006b5 <cprintf>
  8001f0:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f3:	3b 46 18             	cmp    0x18(%esi),%eax
  8001f6:	75 0e                	jne    800206 <check_regs+0x1d2>
  8001f8:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  8001ff:	e8 b1 04 00 00       	call   8006b5 <cprintf>
  800204:	eb 11                	jmp    800217 <check_regs+0x1e3>
  800206:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  80020d:	e8 a3 04 00 00       	call   8006b5 <cprintf>
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800217:	8b 46 1c             	mov    0x1c(%esi),%eax
  80021a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021e:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800221:	89 44 24 08          	mov    %eax,0x8(%esp)
  800225:	c7 44 24 04 e6 18 80 	movl   $0x8018e6,0x4(%esp)
  80022c:	00 
  80022d:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  800234:	e8 7c 04 00 00       	call   8006b5 <cprintf>
  800239:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023c:	3b 46 1c             	cmp    0x1c(%esi),%eax
  80023f:	75 0e                	jne    80024f <check_regs+0x21b>
  800241:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  800248:	e8 68 04 00 00       	call   8006b5 <cprintf>
  80024d:	eb 11                	jmp    800260 <check_regs+0x22c>
  80024f:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  800256:	e8 5a 04 00 00       	call   8006b5 <cprintf>
  80025b:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  800260:	8b 46 20             	mov    0x20(%esi),%eax
  800263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800267:	8b 43 20             	mov    0x20(%ebx),%eax
  80026a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026e:	c7 44 24 04 ea 18 80 	movl   $0x8018ea,0x4(%esp)
  800275:	00 
  800276:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  80027d:	e8 33 04 00 00       	call   8006b5 <cprintf>
  800282:	8b 43 20             	mov    0x20(%ebx),%eax
  800285:	3b 46 20             	cmp    0x20(%esi),%eax
  800288:	75 0e                	jne    800298 <check_regs+0x264>
  80028a:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  800291:	e8 1f 04 00 00       	call   8006b5 <cprintf>
  800296:	eb 11                	jmp    8002a9 <check_regs+0x275>
  800298:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  80029f:	e8 11 04 00 00       	call   8006b5 <cprintf>
  8002a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a9:	8b 46 24             	mov    0x24(%esi),%eax
  8002ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b0:	8b 43 24             	mov    0x24(%ebx),%eax
  8002b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b7:	c7 44 24 04 ee 18 80 	movl   $0x8018ee,0x4(%esp)
  8002be:	00 
  8002bf:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  8002c6:	e8 ea 03 00 00       	call   8006b5 <cprintf>
  8002cb:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ce:	3b 46 24             	cmp    0x24(%esi),%eax
  8002d1:	75 0e                	jne    8002e1 <check_regs+0x2ad>
  8002d3:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  8002da:	e8 d6 03 00 00       	call   8006b5 <cprintf>
  8002df:	eb 11                	jmp    8002f2 <check_regs+0x2be>
  8002e1:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  8002e8:	e8 c8 03 00 00       	call   8006b5 <cprintf>
  8002ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f2:	8b 46 28             	mov    0x28(%esi),%eax
  8002f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f9:	8b 43 28             	mov    0x28(%ebx),%eax
  8002fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800300:	c7 44 24 04 f5 18 80 	movl   $0x8018f5,0x4(%esp)
  800307:	00 
  800308:	c7 04 24 b4 18 80 00 	movl   $0x8018b4,(%esp)
  80030f:	e8 a1 03 00 00       	call   8006b5 <cprintf>
  800314:	8b 43 28             	mov    0x28(%ebx),%eax
  800317:	3b 46 28             	cmp    0x28(%esi),%eax
  80031a:	75 25                	jne    800341 <check_regs+0x30d>
  80031c:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  800323:	e8 8d 03 00 00       	call   8006b5 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	c7 04 24 f9 18 80 00 	movl   $0x8018f9,(%esp)
  800336:	e8 7a 03 00 00       	call   8006b5 <cprintf>
	if (!mismatch)
  80033b:	85 ff                	test   %edi,%edi
  80033d:	74 23                	je     800362 <check_regs+0x32e>
  80033f:	eb 2f                	jmp    800370 <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800341:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  800348:	e8 68 03 00 00       	call   8006b5 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	89 44 24 04          	mov    %eax,0x4(%esp)
  800354:	c7 04 24 f9 18 80 00 	movl   $0x8018f9,(%esp)
  80035b:	e8 55 03 00 00       	call   8006b5 <cprintf>
  800360:	eb 0e                	jmp    800370 <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800362:	c7 04 24 c4 18 80 00 	movl   $0x8018c4,(%esp)
  800369:	e8 47 03 00 00       	call   8006b5 <cprintf>
  80036e:	eb 0c                	jmp    80037c <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  800370:	c7 04 24 c8 18 80 00 	movl   $0x8018c8,(%esp)
  800377:	e8 39 03 00 00       	call   8006b5 <cprintf>
}
  80037c:	83 c4 1c             	add    $0x1c,%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <umain>:
		panic("sys_page_alloc: %e", r);
}

void
umain(int argc, char **argv)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  80038a:	c7 04 24 95 04 80 00 	movl   $0x800495,(%esp)
  800391:	e8 ee 11 00 00       	call   801584 <set_pgfault_handler>

	__asm __volatile(
  800396:	50                   	push   %eax
  800397:	9c                   	pushf  
  800398:	58                   	pop    %eax
  800399:	0d d5 08 00 00       	or     $0x8d5,%eax
  80039e:	50                   	push   %eax
  80039f:	9d                   	popf   
  8003a0:	a3 44 20 80 00       	mov    %eax,0x802044
  8003a5:	8d 05 e0 03 80 00    	lea    0x8003e0,%eax
  8003ab:	a3 40 20 80 00       	mov    %eax,0x802040
  8003b0:	58                   	pop    %eax
  8003b1:	89 3d 20 20 80 00    	mov    %edi,0x802020
  8003b7:	89 35 24 20 80 00    	mov    %esi,0x802024
  8003bd:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  8003c3:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  8003c9:	89 15 34 20 80 00    	mov    %edx,0x802034
  8003cf:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  8003d5:	a3 3c 20 80 00       	mov    %eax,0x80203c
  8003da:	89 25 48 20 80 00    	mov    %esp,0x802048
  8003e0:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8003e7:	00 00 00 
  8003ea:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8003f0:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8003f6:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  8003fc:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  800402:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  800408:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  80040e:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  800413:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  800419:	8b 3d 20 20 80 00    	mov    0x802020,%edi
  80041f:	8b 35 24 20 80 00    	mov    0x802024,%esi
  800425:	8b 2d 28 20 80 00    	mov    0x802028,%ebp
  80042b:	8b 1d 30 20 80 00    	mov    0x802030,%ebx
  800431:	8b 15 34 20 80 00    	mov    0x802034,%edx
  800437:	8b 0d 38 20 80 00    	mov    0x802038,%ecx
  80043d:	a1 3c 20 80 00       	mov    0x80203c,%eax
  800442:	8b 25 48 20 80 00    	mov    0x802048,%esp
  800448:	50                   	push   %eax
  800449:	9c                   	pushf  
  80044a:	58                   	pop    %eax
  80044b:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  800450:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800451:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800458:	74 0c                	je     800466 <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  80045a:	c7 04 24 60 19 80 00 	movl   $0x801960,(%esp)
  800461:	e8 4f 02 00 00       	call   8006b5 <cprintf>
	after.eip = before.eip;
  800466:	a1 40 20 80 00       	mov    0x802040,%eax
  80046b:	a3 c0 20 80 00       	mov    %eax,0x8020c0

	check_regs(&before, "before", &after, "after", "after page-fault");
  800470:	c7 44 24 04 0e 19 80 	movl   $0x80190e,0x4(%esp)
  800477:	00 
  800478:	c7 04 24 1f 19 80 00 	movl   $0x80191f,(%esp)
  80047f:	b9 a0 20 80 00       	mov    $0x8020a0,%ecx
  800484:	ba 07 19 80 00       	mov    $0x801907,%edx
  800489:	b8 20 20 80 00       	mov    $0x802020,%eax
  80048e:	e8 a1 fb ff ff       	call   800034 <check_regs>
}
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <pgfault>:
		cprintf("MISMATCH\n");
}

static void
pgfault(struct UTrapframe *utf)
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 28             	sub    $0x28,%esp
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80049e:	8b 10                	mov    (%eax),%edx
  8004a0:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8004a6:	74 27                	je     8004cf <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8004a8:	8b 40 28             	mov    0x28(%eax),%eax
  8004ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004b3:	c7 44 24 08 80 19 80 	movl   $0x801980,0x8(%esp)
  8004ba:	00 
  8004bb:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8004c2:	00 
  8004c3:	c7 04 24 25 19 80 00 	movl   $0x801925,(%esp)
  8004ca:	e8 2d 01 00 00       	call   8005fc <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8004cf:	8b 50 08             	mov    0x8(%eax),%edx
  8004d2:	89 15 60 20 80 00    	mov    %edx,0x802060
  8004d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8004db:	89 15 64 20 80 00    	mov    %edx,0x802064
  8004e1:	8b 50 10             	mov    0x10(%eax),%edx
  8004e4:	89 15 68 20 80 00    	mov    %edx,0x802068
  8004ea:	8b 50 14             	mov    0x14(%eax),%edx
  8004ed:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  8004f3:	8b 50 18             	mov    0x18(%eax),%edx
  8004f6:	89 15 70 20 80 00    	mov    %edx,0x802070
  8004fc:	8b 50 1c             	mov    0x1c(%eax),%edx
  8004ff:	89 15 74 20 80 00    	mov    %edx,0x802074
  800505:	8b 50 20             	mov    0x20(%eax),%edx
  800508:	89 15 78 20 80 00    	mov    %edx,0x802078
  80050e:	8b 50 24             	mov    0x24(%eax),%edx
  800511:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800517:	8b 50 28             	mov    0x28(%eax),%edx
  80051a:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags;
  800520:	8b 50 2c             	mov    0x2c(%eax),%edx
  800523:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  800529:	8b 40 30             	mov    0x30(%eax),%eax
  80052c:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800531:	c7 44 24 04 36 19 80 	movl   $0x801936,0x4(%esp)
  800538:	00 
  800539:	c7 04 24 44 19 80 00 	movl   $0x801944,(%esp)
  800540:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800545:	ba 07 19 80 00       	mov    $0x801907,%edx
  80054a:	b8 20 20 80 00       	mov    $0x802020,%eax
  80054f:	e8 e0 fa ff ff       	call   800034 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(sys_getenvid(), UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800554:	e8 98 0f 00 00       	call   8014f1 <sys_getenvid>
  800559:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800560:	00 
  800561:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800568:	00 
  800569:	89 04 24             	mov    %eax,(%esp)
  80056c:	e8 ed 0e 00 00       	call   80145e <sys_page_alloc>
  800571:	85 c0                	test   %eax,%eax
  800573:	79 20                	jns    800595 <pgfault+0x100>
		panic("sys_page_alloc: %e", r);
  800575:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800579:	c7 44 24 08 4b 19 80 	movl   $0x80194b,0x8(%esp)
  800580:	00 
  800581:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800588:	00 
  800589:	c7 04 24 25 19 80 00 	movl   $0x801925,(%esp)
  800590:	e8 67 00 00 00       	call   8005fc <_panic>
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    
	...

00800598 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 18             	sub    $0x18,%esp
  80059e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8005a1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8005a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  8005aa:	e8 42 0f 00 00       	call   8014f1 <sys_getenvid>
  8005af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005b7:	2d 00 00 40 11       	sub    $0x11400000,%eax
  8005bc:	a3 cc 20 80 00       	mov    %eax,0x8020cc

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c1:	85 f6                	test   %esi,%esi
  8005c3:	7e 07                	jle    8005cc <libmain+0x34>
		binaryname = argv[0];
  8005c5:	8b 03                	mov    (%ebx),%eax
  8005c7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8005cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d0:	89 34 24             	mov    %esi,(%esp)
  8005d3:	e8 ac fd ff ff       	call   800384 <umain>

	// exit gracefully
	exit();
  8005d8:	e8 0b 00 00 00       	call   8005e8 <exit>
}
  8005dd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8005e0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8005e3:	89 ec                	mov    %ebp,%esp
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    
	...

008005e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  8005ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f5:	e8 2b 0f 00 00       	call   801525 <sys_env_destroy>
}
  8005fa:	c9                   	leave  
  8005fb:	c3                   	ret    

008005fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	56                   	push   %esi
  800600:	53                   	push   %ebx
  800601:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800604:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800607:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  80060d:	e8 df 0e 00 00       	call   8014f1 <sys_getenvid>
  800612:	8b 55 0c             	mov    0xc(%ebp),%edx
  800615:	89 54 24 10          	mov    %edx,0x10(%esp)
  800619:	8b 55 08             	mov    0x8(%ebp),%edx
  80061c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800620:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	c7 04 24 bc 19 80 00 	movl   $0x8019bc,(%esp)
  80062f:	e8 81 00 00 00       	call   8006b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800634:	89 74 24 04          	mov    %esi,0x4(%esp)
  800638:	8b 45 10             	mov    0x10(%ebp),%eax
  80063b:	89 04 24             	mov    %eax,(%esp)
  80063e:	e8 11 00 00 00       	call   800654 <vcprintf>
	cprintf("\n");
  800643:	c7 04 24 d0 18 80 00 	movl   $0x8018d0,(%esp)
  80064a:	e8 66 00 00 00       	call   8006b5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80064f:	cc                   	int3   
  800650:	eb fd                	jmp    80064f <_panic+0x53>
	...

00800654 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80065d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800664:	00 00 00 
	b.cnt = 0;
  800667:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80066e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800671:	8b 45 0c             	mov    0xc(%ebp),%eax
  800674:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80067f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800685:	89 44 24 04          	mov    %eax,0x4(%esp)
  800689:	c7 04 24 cf 06 80 00 	movl   $0x8006cf,(%esp)
  800690:	e8 be 01 00 00       	call   800853 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800695:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80069b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006a5:	89 04 24             	mov    %eax,(%esp)
  8006a8:	e8 23 0a 00 00       	call   8010d0 <sys_cputs>

	return b.cnt;
}
  8006ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006b3:	c9                   	leave  
  8006b4:	c3                   	ret    

008006b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
  8006b8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8006be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 04 24             	mov    %eax,(%esp)
  8006c8:	e8 87 ff ff ff       	call   800654 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	53                   	push   %ebx
  8006d3:	83 ec 14             	sub    $0x14,%esp
  8006d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006d9:	8b 03                	mov    (%ebx),%eax
  8006db:	8b 55 08             	mov    0x8(%ebp),%edx
  8006de:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006e2:	83 c0 01             	add    $0x1,%eax
  8006e5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ec:	75 19                	jne    800707 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8006ee:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006f5:	00 
  8006f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8006f9:	89 04 24             	mov    %eax,(%esp)
  8006fc:	e8 cf 09 00 00       	call   8010d0 <sys_cputs>
		b->idx = 0;
  800701:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800707:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80070b:	83 c4 14             	add    $0x14,%esp
  80070e:	5b                   	pop    %ebx
  80070f:	5d                   	pop    %ebp
  800710:	c3                   	ret    
  800711:	00 00                	add    %al,(%eax)
	...

00800714 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	57                   	push   %edi
  800718:	56                   	push   %esi
  800719:	53                   	push   %ebx
  80071a:	83 ec 4c             	sub    $0x4c,%esp
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800720:	89 d6                	mov    %edx,%esi
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800734:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800737:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80073a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073f:	39 d1                	cmp    %edx,%ecx
  800741:	72 07                	jb     80074a <printnum+0x36>
  800743:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800746:	39 d0                	cmp    %edx,%eax
  800748:	77 69                	ja     8007b3 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80074a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80074e:	83 eb 01             	sub    $0x1,%ebx
  800751:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800755:	89 44 24 08          	mov    %eax,0x8(%esp)
  800759:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80075d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800761:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800764:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800767:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80076a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80076e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800775:	00 
  800776:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800779:	89 04 24             	mov    %eax,(%esp)
  80077c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80077f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800783:	e8 a8 0e 00 00       	call   801630 <__udivdi3>
  800788:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80078b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80078e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800792:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800796:	89 04 24             	mov    %eax,(%esp)
  800799:	89 54 24 04          	mov    %edx,0x4(%esp)
  80079d:	89 f2                	mov    %esi,%edx
  80079f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a2:	e8 6d ff ff ff       	call   800714 <printnum>
  8007a7:	eb 11                	jmp    8007ba <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ad:	89 3c 24             	mov    %edi,(%esp)
  8007b0:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b3:	83 eb 01             	sub    $0x1,%ebx
  8007b6:	85 db                	test   %ebx,%ebx
  8007b8:	7f ef                	jg     8007a9 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007be:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007d0:	00 
  8007d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007d4:	89 14 24             	mov    %edx,(%esp)
  8007d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007de:	e8 7d 0f 00 00       	call   801760 <__umoddi3>
  8007e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e7:	0f be 80 df 19 80 00 	movsbl 0x8019df(%eax),%eax
  8007ee:	89 04 24             	mov    %eax,(%esp)
  8007f1:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8007f4:	83 c4 4c             	add    $0x4c,%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5f                   	pop    %edi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ff:	83 fa 01             	cmp    $0x1,%edx
  800802:	7e 0e                	jle    800812 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800804:	8b 10                	mov    (%eax),%edx
  800806:	8d 4a 08             	lea    0x8(%edx),%ecx
  800809:	89 08                	mov    %ecx,(%eax)
  80080b:	8b 02                	mov    (%edx),%eax
  80080d:	8b 52 04             	mov    0x4(%edx),%edx
  800810:	eb 22                	jmp    800834 <getuint+0x38>
	else if (lflag)
  800812:	85 d2                	test   %edx,%edx
  800814:	74 10                	je     800826 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800816:	8b 10                	mov    (%eax),%edx
  800818:	8d 4a 04             	lea    0x4(%edx),%ecx
  80081b:	89 08                	mov    %ecx,(%eax)
  80081d:	8b 02                	mov    (%edx),%eax
  80081f:	ba 00 00 00 00       	mov    $0x0,%edx
  800824:	eb 0e                	jmp    800834 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800826:	8b 10                	mov    (%eax),%edx
  800828:	8d 4a 04             	lea    0x4(%edx),%ecx
  80082b:	89 08                	mov    %ecx,(%eax)
  80082d:	8b 02                	mov    (%edx),%eax
  80082f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80083c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800840:	8b 10                	mov    (%eax),%edx
  800842:	3b 50 04             	cmp    0x4(%eax),%edx
  800845:	73 0a                	jae    800851 <sprintputch+0x1b>
		*b->buf++ = ch;
  800847:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084a:	88 0a                	mov    %cl,(%edx)
  80084c:	83 c2 01             	add    $0x1,%edx
  80084f:	89 10                	mov    %edx,(%eax)
}
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	57                   	push   %edi
  800857:	56                   	push   %esi
  800858:	53                   	push   %ebx
  800859:	83 ec 4c             	sub    $0x4c,%esp
  80085c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80085f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800862:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800865:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80086c:	eb 11                	jmp    80087f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80086e:	85 c0                	test   %eax,%eax
  800870:	0f 84 b6 03 00 00    	je     800c2c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800876:	89 74 24 04          	mov    %esi,0x4(%esp)
  80087a:	89 04 24             	mov    %eax,(%esp)
  80087d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087f:	0f b6 03             	movzbl (%ebx),%eax
  800882:	83 c3 01             	add    $0x1,%ebx
  800885:	83 f8 25             	cmp    $0x25,%eax
  800888:	75 e4                	jne    80086e <vprintfmt+0x1b>
  80088a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80088e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800895:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80089c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8008a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008ab:	eb 06                	jmp    8008b3 <vprintfmt+0x60>
  8008ad:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8008b1:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b3:	0f b6 0b             	movzbl (%ebx),%ecx
  8008b6:	0f b6 c1             	movzbl %cl,%eax
  8008b9:	8d 53 01             	lea    0x1(%ebx),%edx
  8008bc:	83 e9 23             	sub    $0x23,%ecx
  8008bf:	80 f9 55             	cmp    $0x55,%cl
  8008c2:	0f 87 47 03 00 00    	ja     800c0f <vprintfmt+0x3bc>
  8008c8:	0f b6 c9             	movzbl %cl,%ecx
  8008cb:	ff 24 8d 20 1b 80 00 	jmp    *0x801b20(,%ecx,4)
  8008d2:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8008d6:	eb d9                	jmp    8008b1 <vprintfmt+0x5e>
  8008d8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8008df:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008e4:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008e7:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008eb:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8008ee:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008f1:	83 fb 09             	cmp    $0x9,%ebx
  8008f4:	77 30                	ja     800926 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f6:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008f9:	eb e9                	jmp    8008e4 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8d 48 04             	lea    0x4(%eax),%ecx
  800901:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800904:	8b 00                	mov    (%eax),%eax
  800906:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800909:	eb 1e                	jmp    800929 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80090b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091b:	eb 94                	jmp    8008b1 <vprintfmt+0x5e>
  80091d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800924:	eb 8b                	jmp    8008b1 <vprintfmt+0x5e>
  800926:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092d:	79 82                	jns    8008b1 <vprintfmt+0x5e>
  80092f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800935:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800938:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80093b:	e9 71 ff ff ff       	jmp    8008b1 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800940:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800944:	e9 68 ff ff ff       	jmp    8008b1 <vprintfmt+0x5e>
  800949:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	89 55 14             	mov    %edx,0x14(%ebp)
  800955:	89 74 24 04          	mov    %esi,0x4(%esp)
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	89 04 24             	mov    %eax,(%esp)
  80095e:	ff d7                	call   *%edi
  800960:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800963:	e9 17 ff ff ff       	jmp    80087f <vprintfmt+0x2c>
  800968:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8d 50 04             	lea    0x4(%eax),%edx
  800971:	89 55 14             	mov    %edx,0x14(%ebp)
  800974:	8b 00                	mov    (%eax),%eax
  800976:	89 c2                	mov    %eax,%edx
  800978:	c1 fa 1f             	sar    $0x1f,%edx
  80097b:	31 d0                	xor    %edx,%eax
  80097d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80097f:	83 f8 11             	cmp    $0x11,%eax
  800982:	7f 0b                	jg     80098f <vprintfmt+0x13c>
  800984:	8b 14 85 80 1c 80 00 	mov    0x801c80(,%eax,4),%edx
  80098b:	85 d2                	test   %edx,%edx
  80098d:	75 20                	jne    8009af <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80098f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800993:	c7 44 24 08 f0 19 80 	movl   $0x8019f0,0x8(%esp)
  80099a:	00 
  80099b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099f:	89 3c 24             	mov    %edi,(%esp)
  8009a2:	e8 0d 03 00 00       	call   800cb4 <printfmt>
  8009a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009aa:	e9 d0 fe ff ff       	jmp    80087f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b3:	c7 44 24 08 f9 19 80 	movl   $0x8019f9,0x8(%esp)
  8009ba:	00 
  8009bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009bf:	89 3c 24             	mov    %edi,(%esp)
  8009c2:	e8 ed 02 00 00       	call   800cb4 <printfmt>
  8009c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8009ca:	e9 b0 fe ff ff       	jmp    80087f <vprintfmt+0x2c>
  8009cf:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009d2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8009d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009db:	8b 45 14             	mov    0x14(%ebp),%eax
  8009de:	8d 50 04             	lea    0x4(%eax),%edx
  8009e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8009e4:	8b 18                	mov    (%eax),%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	b8 fc 19 80 00       	mov    $0x8019fc,%eax
  8009ed:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8009f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009f4:	7e 76                	jle    800a6c <vprintfmt+0x219>
  8009f6:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8009fa:	74 7a                	je     800a76 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a00:	89 1c 24             	mov    %ebx,(%esp)
  800a03:	e8 f0 02 00 00       	call   800cf8 <strnlen>
  800a08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800a0b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800a0d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800a11:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a14:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800a17:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a19:	eb 0f                	jmp    800a2a <vprintfmt+0x1d7>
					putch(padc, putdat);
  800a1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a22:	89 04 24             	mov    %eax,(%esp)
  800a25:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a27:	83 eb 01             	sub    $0x1,%ebx
  800a2a:	85 db                	test   %ebx,%ebx
  800a2c:	7f ed                	jg     800a1b <vprintfmt+0x1c8>
  800a2e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800a31:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a34:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a37:	89 f7                	mov    %esi,%edi
  800a39:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a3c:	eb 40                	jmp    800a7e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a3e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a42:	74 18                	je     800a5c <vprintfmt+0x209>
  800a44:	8d 50 e0             	lea    -0x20(%eax),%edx
  800a47:	83 fa 5e             	cmp    $0x5e,%edx
  800a4a:	76 10                	jbe    800a5c <vprintfmt+0x209>
					putch('?', putdat);
  800a4c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a50:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a57:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a5a:	eb 0a                	jmp    800a66 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800a5c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a60:	89 04 24             	mov    %eax,(%esp)
  800a63:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a66:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a6a:	eb 12                	jmp    800a7e <vprintfmt+0x22b>
  800a6c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a6f:	89 f7                	mov    %esi,%edi
  800a71:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a74:	eb 08                	jmp    800a7e <vprintfmt+0x22b>
  800a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800a79:	89 f7                	mov    %esi,%edi
  800a7b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800a7e:	0f be 03             	movsbl (%ebx),%eax
  800a81:	83 c3 01             	add    $0x1,%ebx
  800a84:	85 c0                	test   %eax,%eax
  800a86:	74 25                	je     800aad <vprintfmt+0x25a>
  800a88:	85 f6                	test   %esi,%esi
  800a8a:	78 b2                	js     800a3e <vprintfmt+0x1eb>
  800a8c:	83 ee 01             	sub    $0x1,%esi
  800a8f:	79 ad                	jns    800a3e <vprintfmt+0x1eb>
  800a91:	89 fe                	mov    %edi,%esi
  800a93:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a96:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a99:	eb 1a                	jmp    800ab5 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a9f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800aa6:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa8:	83 eb 01             	sub    $0x1,%ebx
  800aab:	eb 08                	jmp    800ab5 <vprintfmt+0x262>
  800aad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800ab0:	89 fe                	mov    %edi,%esi
  800ab2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ab5:	85 db                	test   %ebx,%ebx
  800ab7:	7f e2                	jg     800a9b <vprintfmt+0x248>
  800ab9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800abc:	e9 be fd ff ff       	jmp    80087f <vprintfmt+0x2c>
  800ac1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800ac4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ac7:	83 f9 01             	cmp    $0x1,%ecx
  800aca:	7e 16                	jle    800ae2 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8d 50 08             	lea    0x8(%eax),%edx
  800ad2:	89 55 14             	mov    %edx,0x14(%ebp)
  800ad5:	8b 10                	mov    (%eax),%edx
  800ad7:	8b 48 04             	mov    0x4(%eax),%ecx
  800ada:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800add:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ae0:	eb 32                	jmp    800b14 <vprintfmt+0x2c1>
	else if (lflag)
  800ae2:	85 c9                	test   %ecx,%ecx
  800ae4:	74 18                	je     800afe <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	8d 50 04             	lea    0x4(%eax),%edx
  800aec:	89 55 14             	mov    %edx,0x14(%ebp)
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af4:	89 c1                	mov    %eax,%ecx
  800af6:	c1 f9 1f             	sar    $0x1f,%ecx
  800af9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800afc:	eb 16                	jmp    800b14 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	8d 50 04             	lea    0x4(%eax),%edx
  800b04:	89 55 14             	mov    %edx,0x14(%ebp)
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b0c:	89 c2                	mov    %eax,%edx
  800b0e:	c1 fa 1f             	sar    $0x1f,%edx
  800b11:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b14:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800b17:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b1a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800b1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b23:	0f 89 a7 00 00 00    	jns    800bd0 <vprintfmt+0x37d>
				putch('-', putdat);
  800b29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b2d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b34:	ff d7                	call   *%edi
				num = -(long long) num;
  800b36:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800b39:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b3c:	f7 d9                	neg    %ecx
  800b3e:	83 d3 00             	adc    $0x0,%ebx
  800b41:	f7 db                	neg    %ebx
  800b43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b48:	e9 83 00 00 00       	jmp    800bd0 <vprintfmt+0x37d>
  800b4d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b50:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b53:	89 ca                	mov    %ecx,%edx
  800b55:	8d 45 14             	lea    0x14(%ebp),%eax
  800b58:	e8 9f fc ff ff       	call   8007fc <getuint>
  800b5d:	89 c1                	mov    %eax,%ecx
  800b5f:	89 d3                	mov    %edx,%ebx
  800b61:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800b66:	eb 68                	jmp    800bd0 <vprintfmt+0x37d>
  800b68:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800b6e:	89 ca                	mov    %ecx,%edx
  800b70:	8d 45 14             	lea    0x14(%ebp),%eax
  800b73:	e8 84 fc ff ff       	call   8007fc <getuint>
  800b78:	89 c1                	mov    %eax,%ecx
  800b7a:	89 d3                	mov    %edx,%ebx
  800b7c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800b81:	eb 4d                	jmp    800bd0 <vprintfmt+0x37d>
  800b83:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800b86:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b8a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b91:	ff d7                	call   *%edi
			putch('x', putdat);
  800b93:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b97:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b9e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	8d 50 04             	lea    0x4(%eax),%edx
  800ba6:	89 55 14             	mov    %edx,0x14(%ebp)
  800ba9:	8b 08                	mov    (%eax),%ecx
  800bab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800bb5:	eb 19                	jmp    800bd0 <vprintfmt+0x37d>
  800bb7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800bba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bbd:	89 ca                	mov    %ecx,%edx
  800bbf:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc2:	e8 35 fc ff ff       	call   8007fc <getuint>
  800bc7:	89 c1                	mov    %eax,%ecx
  800bc9:	89 d3                	mov    %edx,%ebx
  800bcb:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd0:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800bd4:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800bdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be3:	89 0c 24             	mov    %ecx,(%esp)
  800be6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bea:	89 f2                	mov    %esi,%edx
  800bec:	89 f8                	mov    %edi,%eax
  800bee:	e8 21 fb ff ff       	call   800714 <printnum>
  800bf3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800bf6:	e9 84 fc ff ff       	jmp    80087f <vprintfmt+0x2c>
  800bfb:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bfe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c02:	89 04 24             	mov    %eax,(%esp)
  800c05:	ff d7                	call   *%edi
  800c07:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800c0a:	e9 70 fc ff ff       	jmp    80087f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c13:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c1a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c1f:	80 38 25             	cmpb   $0x25,(%eax)
  800c22:	0f 84 57 fc ff ff    	je     80087f <vprintfmt+0x2c>
  800c28:	89 c3                	mov    %eax,%ebx
  800c2a:	eb f0                	jmp    800c1c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800c2c:	83 c4 4c             	add    $0x4c,%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 28             	sub    $0x28,%esp
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800c40:	85 c0                	test   %eax,%eax
  800c42:	74 04                	je     800c48 <vsnprintf+0x14>
  800c44:	85 d2                	test   %edx,%edx
  800c46:	7f 07                	jg     800c4f <vsnprintf+0x1b>
  800c48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c4d:	eb 3b                	jmp    800c8a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c52:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c60:	8b 45 14             	mov    0x14(%ebp),%eax
  800c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c75:	c7 04 24 36 08 80 00 	movl   $0x800836,(%esp)
  800c7c:	e8 d2 fb ff ff       	call   800853 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800c92:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800c95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c99:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	89 04 24             	mov    %eax,(%esp)
  800cad:	e8 82 ff ff ff       	call   800c34 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800cba:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800cbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 04 24             	mov    %eax,(%esp)
  800cd5:	e8 79 fb ff ff       	call   800853 <vprintfmt>
	va_end(ap);
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    
  800cdc:	00 00                	add    %al,(%eax)
	...

00800ce0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800ceb:	eb 03                	jmp    800cf0 <strlen+0x10>
		n++;
  800ced:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cf4:	75 f7                	jne    800ced <strlen+0xd>
		n++;
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	53                   	push   %ebx
  800cfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d07:	eb 03                	jmp    800d0c <strnlen+0x14>
		n++;
  800d09:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0c:	39 c1                	cmp    %eax,%ecx
  800d0e:	74 06                	je     800d16 <strnlen+0x1e>
  800d10:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800d14:	75 f3                	jne    800d09 <strnlen+0x11>
		n++;
	return n;
}
  800d16:	5b                   	pop    %ebx
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	53                   	push   %ebx
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d23:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d28:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d2c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d2f:	83 c2 01             	add    $0x1,%edx
  800d32:	84 c9                	test   %cl,%cl
  800d34:	75 f2                	jne    800d28 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800d36:	5b                   	pop    %ebx
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d43:	89 1c 24             	mov    %ebx,(%esp)
  800d46:	e8 95 ff ff ff       	call   800ce0 <strlen>
	strcpy(dst + len, src);
  800d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d52:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800d55:	89 04 24             	mov    %eax,(%esp)
  800d58:	e8 bc ff ff ff       	call   800d19 <strcpy>
	return dst;
}
  800d5d:	89 d8                	mov    %ebx,%eax
  800d5f:	83 c4 08             	add    $0x8,%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	8b 75 10             	mov    0x10(%ebp),%esi
  800d73:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d78:	eb 0f                	jmp    800d89 <strncpy+0x24>
		*dst++ = *src;
  800d7a:	0f b6 19             	movzbl (%ecx),%ebx
  800d7d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d80:	80 39 01             	cmpb   $0x1,(%ecx)
  800d83:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d86:	83 c2 01             	add    $0x1,%edx
  800d89:	39 f2                	cmp    %esi,%edx
  800d8b:	72 ed                	jb     800d7a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d8d:	5b                   	pop    %ebx
  800d8e:	5e                   	pop    %esi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	8b 75 08             	mov    0x8(%ebp),%esi
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d9f:	89 f0                	mov    %esi,%eax
  800da1:	85 d2                	test   %edx,%edx
  800da3:	75 0a                	jne    800daf <strlcpy+0x1e>
  800da5:	eb 17                	jmp    800dbe <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800da7:	88 18                	mov    %bl,(%eax)
  800da9:	83 c0 01             	add    $0x1,%eax
  800dac:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800daf:	83 ea 01             	sub    $0x1,%edx
  800db2:	74 07                	je     800dbb <strlcpy+0x2a>
  800db4:	0f b6 19             	movzbl (%ecx),%ebx
  800db7:	84 db                	test   %bl,%bl
  800db9:	75 ec                	jne    800da7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800dbb:	c6 00 00             	movb   $0x0,(%eax)
  800dbe:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dcd:	eb 06                	jmp    800dd5 <strcmp+0x11>
		p++, q++;
  800dcf:	83 c1 01             	add    $0x1,%ecx
  800dd2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dd5:	0f b6 01             	movzbl (%ecx),%eax
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 04                	je     800de0 <strcmp+0x1c>
  800ddc:	3a 02                	cmp    (%edx),%al
  800dde:	74 ef                	je     800dcf <strcmp+0xb>
  800de0:	0f b6 c0             	movzbl %al,%eax
  800de3:	0f b6 12             	movzbl (%edx),%edx
  800de6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	53                   	push   %ebx
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800df7:	eb 09                	jmp    800e02 <strncmp+0x18>
		n--, p++, q++;
  800df9:	83 ea 01             	sub    $0x1,%edx
  800dfc:	83 c0 01             	add    $0x1,%eax
  800dff:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e02:	85 d2                	test   %edx,%edx
  800e04:	75 07                	jne    800e0d <strncmp+0x23>
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0b:	eb 13                	jmp    800e20 <strncmp+0x36>
  800e0d:	0f b6 18             	movzbl (%eax),%ebx
  800e10:	84 db                	test   %bl,%bl
  800e12:	74 04                	je     800e18 <strncmp+0x2e>
  800e14:	3a 19                	cmp    (%ecx),%bl
  800e16:	74 e1                	je     800df9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	0f b6 00             	movzbl (%eax),%eax
  800e1b:	0f b6 11             	movzbl (%ecx),%edx
  800e1e:	29 d0                	sub    %edx,%eax
}
  800e20:	5b                   	pop    %ebx
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e2d:	eb 07                	jmp    800e36 <strchr+0x13>
		if (*s == c)
  800e2f:	38 ca                	cmp    %cl,%dl
  800e31:	74 0f                	je     800e42 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e33:	83 c0 01             	add    $0x1,%eax
  800e36:	0f b6 10             	movzbl (%eax),%edx
  800e39:	84 d2                	test   %dl,%dl
  800e3b:	75 f2                	jne    800e2f <strchr+0xc>
  800e3d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e4e:	eb 07                	jmp    800e57 <strfind+0x13>
		if (*s == c)
  800e50:	38 ca                	cmp    %cl,%dl
  800e52:	74 0a                	je     800e5e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e54:	83 c0 01             	add    $0x1,%eax
  800e57:	0f b6 10             	movzbl (%eax),%edx
  800e5a:	84 d2                	test   %dl,%dl
  800e5c:	75 f2                	jne    800e50 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	89 1c 24             	mov    %ebx,(%esp)
  800e69:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800e71:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e7a:	85 c9                	test   %ecx,%ecx
  800e7c:	74 30                	je     800eae <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e84:	75 25                	jne    800eab <memset+0x4b>
  800e86:	f6 c1 03             	test   $0x3,%cl
  800e89:	75 20                	jne    800eab <memset+0x4b>
		c &= 0xFF;
  800e8b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e8e:	89 d3                	mov    %edx,%ebx
  800e90:	c1 e3 08             	shl    $0x8,%ebx
  800e93:	89 d6                	mov    %edx,%esi
  800e95:	c1 e6 18             	shl    $0x18,%esi
  800e98:	89 d0                	mov    %edx,%eax
  800e9a:	c1 e0 10             	shl    $0x10,%eax
  800e9d:	09 f0                	or     %esi,%eax
  800e9f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ea1:	09 d8                	or     %ebx,%eax
  800ea3:	c1 e9 02             	shr    $0x2,%ecx
  800ea6:	fc                   	cld    
  800ea7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ea9:	eb 03                	jmp    800eae <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eab:	fc                   	cld    
  800eac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800eae:	89 f8                	mov    %edi,%eax
  800eb0:	8b 1c 24             	mov    (%esp),%ebx
  800eb3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800eb7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ebb:	89 ec                	mov    %ebp,%esp
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	89 34 24             	mov    %esi,(%esp)
  800ec8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800ed2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800ed5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800ed7:	39 c6                	cmp    %eax,%esi
  800ed9:	73 35                	jae    800f10 <memmove+0x51>
  800edb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ede:	39 d0                	cmp    %edx,%eax
  800ee0:	73 2e                	jae    800f10 <memmove+0x51>
		s += n;
		d += n;
  800ee2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ee4:	f6 c2 03             	test   $0x3,%dl
  800ee7:	75 1b                	jne    800f04 <memmove+0x45>
  800ee9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800eef:	75 13                	jne    800f04 <memmove+0x45>
  800ef1:	f6 c1 03             	test   $0x3,%cl
  800ef4:	75 0e                	jne    800f04 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ef6:	83 ef 04             	sub    $0x4,%edi
  800ef9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800efc:	c1 e9 02             	shr    $0x2,%ecx
  800eff:	fd                   	std    
  800f00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f02:	eb 09                	jmp    800f0d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f04:	83 ef 01             	sub    $0x1,%edi
  800f07:	8d 72 ff             	lea    -0x1(%edx),%esi
  800f0a:	fd                   	std    
  800f0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f0d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0e:	eb 20                	jmp    800f30 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f10:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f16:	75 15                	jne    800f2d <memmove+0x6e>
  800f18:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f1e:	75 0d                	jne    800f2d <memmove+0x6e>
  800f20:	f6 c1 03             	test   $0x3,%cl
  800f23:	75 08                	jne    800f2d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800f25:	c1 e9 02             	shr    $0x2,%ecx
  800f28:	fc                   	cld    
  800f29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f2b:	eb 03                	jmp    800f30 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f2d:	fc                   	cld    
  800f2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f30:	8b 34 24             	mov    (%esp),%esi
  800f33:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800f37:	89 ec                	mov    %ebp,%esp
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	89 04 24             	mov    %eax,(%esp)
  800f55:	e8 65 ff ff ff       	call   800ebf <memmove>
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f70:	eb 1c                	jmp    800f8e <memcmp+0x32>
		if (*s1 != *s2)
  800f72:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800f76:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800f7a:	83 c2 01             	add    $0x1,%edx
  800f7d:	83 e9 01             	sub    $0x1,%ecx
  800f80:	38 d8                	cmp    %bl,%al
  800f82:	74 0a                	je     800f8e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800f84:	0f b6 c0             	movzbl %al,%eax
  800f87:	0f b6 db             	movzbl %bl,%ebx
  800f8a:	29 d8                	sub    %ebx,%eax
  800f8c:	eb 09                	jmp    800f97 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f8e:	85 c9                	test   %ecx,%ecx
  800f90:	75 e0                	jne    800f72 <memcmp+0x16>
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800f97:	5b                   	pop    %ebx
  800f98:	5e                   	pop    %esi
  800f99:	5f                   	pop    %edi
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800faa:	eb 07                	jmp    800fb3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fac:	38 08                	cmp    %cl,(%eax)
  800fae:	74 07                	je     800fb7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb0:	83 c0 01             	add    $0x1,%eax
  800fb3:	39 d0                	cmp    %edx,%eax
  800fb5:	72 f5                	jb     800fac <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 04             	sub    $0x4,%esp
  800fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc8:	eb 03                	jmp    800fcd <strtol+0x14>
		s++;
  800fca:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcd:	0f b6 02             	movzbl (%edx),%eax
  800fd0:	3c 20                	cmp    $0x20,%al
  800fd2:	74 f6                	je     800fca <strtol+0x11>
  800fd4:	3c 09                	cmp    $0x9,%al
  800fd6:	74 f2                	je     800fca <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd8:	3c 2b                	cmp    $0x2b,%al
  800fda:	75 0c                	jne    800fe8 <strtol+0x2f>
		s++;
  800fdc:	8d 52 01             	lea    0x1(%edx),%edx
  800fdf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fe6:	eb 15                	jmp    800ffd <strtol+0x44>
	else if (*s == '-')
  800fe8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fef:	3c 2d                	cmp    $0x2d,%al
  800ff1:	75 0a                	jne    800ffd <strtol+0x44>
		s++, neg = 1;
  800ff3:	8d 52 01             	lea    0x1(%edx),%edx
  800ff6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffd:	85 db                	test   %ebx,%ebx
  800fff:	0f 94 c0             	sete   %al
  801002:	74 05                	je     801009 <strtol+0x50>
  801004:	83 fb 10             	cmp    $0x10,%ebx
  801007:	75 15                	jne    80101e <strtol+0x65>
  801009:	80 3a 30             	cmpb   $0x30,(%edx)
  80100c:	75 10                	jne    80101e <strtol+0x65>
  80100e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801012:	75 0a                	jne    80101e <strtol+0x65>
		s += 2, base = 16;
  801014:	83 c2 02             	add    $0x2,%edx
  801017:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80101c:	eb 13                	jmp    801031 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80101e:	84 c0                	test   %al,%al
  801020:	74 0f                	je     801031 <strtol+0x78>
  801022:	bb 0a 00 00 00       	mov    $0xa,%ebx
  801027:	80 3a 30             	cmpb   $0x30,(%edx)
  80102a:	75 05                	jne    801031 <strtol+0x78>
		s++, base = 8;
  80102c:	83 c2 01             	add    $0x1,%edx
  80102f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
  801036:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801038:	0f b6 0a             	movzbl (%edx),%ecx
  80103b:	89 cf                	mov    %ecx,%edi
  80103d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801040:	80 fb 09             	cmp    $0x9,%bl
  801043:	77 08                	ja     80104d <strtol+0x94>
			dig = *s - '0';
  801045:	0f be c9             	movsbl %cl,%ecx
  801048:	83 e9 30             	sub    $0x30,%ecx
  80104b:	eb 1e                	jmp    80106b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  80104d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801050:	80 fb 19             	cmp    $0x19,%bl
  801053:	77 08                	ja     80105d <strtol+0xa4>
			dig = *s - 'a' + 10;
  801055:	0f be c9             	movsbl %cl,%ecx
  801058:	83 e9 57             	sub    $0x57,%ecx
  80105b:	eb 0e                	jmp    80106b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  80105d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801060:	80 fb 19             	cmp    $0x19,%bl
  801063:	77 15                	ja     80107a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801065:	0f be c9             	movsbl %cl,%ecx
  801068:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80106b:	39 f1                	cmp    %esi,%ecx
  80106d:	7d 0b                	jge    80107a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80106f:	83 c2 01             	add    $0x1,%edx
  801072:	0f af c6             	imul   %esi,%eax
  801075:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801078:	eb be                	jmp    801038 <strtol+0x7f>
  80107a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80107c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801080:	74 05                	je     801087 <strtol+0xce>
		*endptr = (char *) s;
  801082:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801085:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801087:	89 ca                	mov    %ecx,%edx
  801089:	f7 da                	neg    %edx
  80108b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80108f:	0f 45 c2             	cmovne %edx,%eax
}
  801092:	83 c4 04             	add    $0x4,%esp
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    
	...

0080109c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	89 1c 24             	mov    %ebx,(%esp)
  8010a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8010b7:	89 d1                	mov    %edx,%ecx
  8010b9:	89 d3                	mov    %edx,%ebx
  8010bb:	89 d7                	mov    %edx,%edi
  8010bd:	89 d6                	mov    %edx,%esi
  8010bf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010c1:	8b 1c 24             	mov    (%esp),%ebx
  8010c4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010c8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010cc:	89 ec                	mov    %ebp,%esp
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 0c             	sub    $0xc,%esp
  8010d6:	89 1c 24             	mov    %ebx,(%esp)
  8010d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	89 c3                	mov    %eax,%ebx
  8010ee:	89 c7                	mov    %eax,%edi
  8010f0:	89 c6                	mov    %eax,%esi
  8010f2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010f4:	8b 1c 24             	mov    (%esp),%ebx
  8010f7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010fb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ff:	89 ec                	mov    %ebp,%esp
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	89 1c 24             	mov    %ebx,(%esp)
  80110c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801110:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801114:	ba 00 00 00 00       	mov    $0x0,%edx
  801119:	b8 10 00 00 00       	mov    $0x10,%eax
  80111e:	89 d1                	mov    %edx,%ecx
  801120:	89 d3                	mov    %edx,%ebx
  801122:	89 d7                	mov    %edx,%edi
  801124:	89 d6                	mov    %edx,%esi
  801126:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801128:	8b 1c 24             	mov    (%esp),%ebx
  80112b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80112f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801133:	89 ec                	mov    %ebp,%esp
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 38             	sub    $0x38,%esp
  80113d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801140:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801143:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	89 df                	mov    %ebx,%edi
  801158:	89 de                	mov    %ebx,%esi
  80115a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	7e 28                	jle    801188 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801160:	89 44 24 10          	mov    %eax,0x10(%esp)
  801164:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80116b:	00 
  80116c:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  801173:	00 
  801174:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117b:	00 
  80117c:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  801183:	e8 74 f4 ff ff       	call   8005fc <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801188:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80118b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80118e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801191:	89 ec                	mov    %ebp,%esp
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 38             	sub    $0x38,%esp
  80119b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80119e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	89 df                	mov    %ebx,%edi
  8011b6:	89 de                	mov    %ebx,%esi
  8011b8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	7e 28                	jle    8011e6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8011c9:	00 
  8011ca:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  8011d1:	00 
  8011d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d9:	00 
  8011da:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  8011e1:	e8 16 f4 ff ff       	call   8005fc <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8011e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ef:	89 ec                	mov    %ebp,%esp
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 38             	sub    $0x38,%esp
  8011f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801202:	b9 00 00 00 00       	mov    $0x0,%ecx
  801207:	b8 0d 00 00 00       	mov    $0xd,%eax
  80120c:	8b 55 08             	mov    0x8(%ebp),%edx
  80120f:	89 cb                	mov    %ecx,%ebx
  801211:	89 cf                	mov    %ecx,%edi
  801213:	89 ce                	mov    %ecx,%esi
  801215:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801217:	85 c0                	test   %eax,%eax
  801219:	7e 28                	jle    801243 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80121b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80121f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801226:	00 
  801227:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  80122e:	00 
  80122f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801236:	00 
  801237:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  80123e:	e8 b9 f3 ff ff       	call   8005fc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801243:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801246:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801249:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80124c:	89 ec                	mov    %ebp,%esp
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	89 1c 24             	mov    %ebx,(%esp)
  801259:	89 74 24 04          	mov    %esi,0x4(%esp)
  80125d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801261:	be 00 00 00 00       	mov    $0x0,%esi
  801266:	b8 0c 00 00 00       	mov    $0xc,%eax
  80126b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80126e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801274:	8b 55 08             	mov    0x8(%ebp),%edx
  801277:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801279:	8b 1c 24             	mov    (%esp),%ebx
  80127c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801280:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801284:	89 ec                	mov    %ebp,%esp
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    

00801288 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	83 ec 38             	sub    $0x38,%esp
  80128e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801291:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801294:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801297:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a7:	89 df                	mov    %ebx,%edi
  8012a9:	89 de                	mov    %ebx,%esi
  8012ab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	7e 28                	jle    8012d9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8012bc:	00 
  8012bd:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012cc:	00 
  8012cd:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  8012d4:	e8 23 f3 ff ff       	call   8005fc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012e2:	89 ec                	mov    %ebp,%esp
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    

008012e6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 38             	sub    $0x38,%esp
  8012ec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012ef:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fa:	b8 09 00 00 00       	mov    $0x9,%eax
  8012ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801302:	8b 55 08             	mov    0x8(%ebp),%edx
  801305:	89 df                	mov    %ebx,%edi
  801307:	89 de                	mov    %ebx,%esi
  801309:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80130b:	85 c0                	test   %eax,%eax
  80130d:	7e 28                	jle    801337 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80130f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801313:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80131a:	00 
  80131b:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  801322:	00 
  801323:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80132a:	00 
  80132b:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  801332:	e8 c5 f2 ff ff       	call   8005fc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801337:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80133a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80133d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801340:	89 ec                	mov    %ebp,%esp
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 38             	sub    $0x38,%esp
  80134a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80134d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801350:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801353:	bb 00 00 00 00       	mov    $0x0,%ebx
  801358:	b8 08 00 00 00       	mov    $0x8,%eax
  80135d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801360:	8b 55 08             	mov    0x8(%ebp),%edx
  801363:	89 df                	mov    %ebx,%edi
  801365:	89 de                	mov    %ebx,%esi
  801367:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801369:	85 c0                	test   %eax,%eax
  80136b:	7e 28                	jle    801395 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80136d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801371:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801378:	00 
  801379:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  801380:	00 
  801381:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801388:	00 
  801389:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  801390:	e8 67 f2 ff ff       	call   8005fc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801395:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801398:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80139b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80139e:	89 ec                	mov    %ebp,%esp
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    

008013a2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 38             	sub    $0x38,%esp
  8013a8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013ab:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013ae:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8013bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013be:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c1:	89 df                	mov    %ebx,%edi
  8013c3:	89 de                	mov    %ebx,%esi
  8013c5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	7e 28                	jle    8013f3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013cf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8013d6:	00 
  8013d7:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  8013de:	00 
  8013df:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013e6:	00 
  8013e7:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  8013ee:	e8 09 f2 ff ff       	call   8005fc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013f3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013f6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013f9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013fc:	89 ec                	mov    %ebp,%esp
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 38             	sub    $0x38,%esp
  801406:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801409:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80140c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140f:	b8 05 00 00 00       	mov    $0x5,%eax
  801414:	8b 75 18             	mov    0x18(%ebp),%esi
  801417:	8b 7d 14             	mov    0x14(%ebp),%edi
  80141a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80141d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801425:	85 c0                	test   %eax,%eax
  801427:	7e 28                	jle    801451 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801429:	89 44 24 10          	mov    %eax,0x10(%esp)
  80142d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801434:	00 
  801435:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  80143c:	00 
  80143d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801444:	00 
  801445:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  80144c:	e8 ab f1 ff ff       	call   8005fc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801451:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801454:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801457:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80145a:	89 ec                	mov    %ebp,%esp
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    

0080145e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 38             	sub    $0x38,%esp
  801464:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801467:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80146a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146d:	be 00 00 00 00       	mov    $0x0,%esi
  801472:	b8 04 00 00 00       	mov    $0x4,%eax
  801477:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80147a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147d:	8b 55 08             	mov    0x8(%ebp),%edx
  801480:	89 f7                	mov    %esi,%edi
  801482:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801484:	85 c0                	test   %eax,%eax
  801486:	7e 28                	jle    8014b0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801488:	89 44 24 10          	mov    %eax,0x10(%esp)
  80148c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801493:	00 
  801494:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  80149b:	00 
  80149c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a3:	00 
  8014a4:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  8014ab:	e8 4c f1 ff ff       	call   8005fc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8014b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014b9:	89 ec                	mov    %ebp,%esp
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	89 1c 24             	mov    %ebx,(%esp)
  8014c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014ca:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8014d8:	89 d1                	mov    %edx,%ecx
  8014da:	89 d3                	mov    %edx,%ebx
  8014dc:	89 d7                	mov    %edx,%edi
  8014de:	89 d6                	mov    %edx,%esi
  8014e0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8014e2:	8b 1c 24             	mov    (%esp),%ebx
  8014e5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014e9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8014ed:	89 ec                	mov    %ebp,%esp
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    

008014f1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	89 1c 24             	mov    %ebx,(%esp)
  8014fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801502:	ba 00 00 00 00       	mov    $0x0,%edx
  801507:	b8 02 00 00 00       	mov    $0x2,%eax
  80150c:	89 d1                	mov    %edx,%ecx
  80150e:	89 d3                	mov    %edx,%ebx
  801510:	89 d7                	mov    %edx,%edi
  801512:	89 d6                	mov    %edx,%esi
  801514:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801516:	8b 1c 24             	mov    (%esp),%ebx
  801519:	8b 74 24 04          	mov    0x4(%esp),%esi
  80151d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801521:	89 ec                	mov    %ebp,%esp
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 38             	sub    $0x38,%esp
  80152b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80152e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801531:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801534:	b9 00 00 00 00       	mov    $0x0,%ecx
  801539:	b8 03 00 00 00       	mov    $0x3,%eax
  80153e:	8b 55 08             	mov    0x8(%ebp),%edx
  801541:	89 cb                	mov    %ecx,%ebx
  801543:	89 cf                	mov    %ecx,%edi
  801545:	89 ce                	mov    %ecx,%esi
  801547:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801549:	85 c0                	test   %eax,%eax
  80154b:	7e 28                	jle    801575 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80154d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801551:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801558:	00 
  801559:	c7 44 24 08 e8 1c 80 	movl   $0x801ce8,0x8(%esp)
  801560:	00 
  801561:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801568:	00 
  801569:	c7 04 24 05 1d 80 00 	movl   $0x801d05,(%esp)
  801570:	e8 87 f0 ff ff       	call   8005fc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801575:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801578:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80157b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80157e:	89 ec                	mov    %ebp,%esp
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    
	...

00801584 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	53                   	push   %ebx
  801588:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  80158b:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  801592:	75 5b                	jne    8015ef <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801594:	e8 58 ff ff ff       	call   8014f1 <sys_getenvid>
  801599:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80159b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015a2:	00 
  8015a3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015aa:	ee 
  8015ab:	89 04 24             	mov    %eax,(%esp)
  8015ae:	e8 ab fe ff ff       	call   80145e <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	74 28                	je     8015df <set_pgfault_handler+0x5b>
  8015b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015bb:	c7 44 24 0c 3a 1d 80 	movl   $0x801d3a,0xc(%esp)
  8015c2:	00 
  8015c3:	c7 44 24 08 13 1d 80 	movl   $0x801d13,0x8(%esp)
  8015ca:	00 
  8015cb:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8015d2:	00 
  8015d3:	c7 04 24 2c 1d 80 00 	movl   $0x801d2c,(%esp)
  8015da:	e8 1d f0 ff ff       	call   8005fc <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8015df:	c7 44 24 04 00 16 80 	movl   $0x801600,0x4(%esp)
  8015e6:	00 
  8015e7:	89 1c 24             	mov    %ebx,(%esp)
  8015ea:	e8 99 fc ff ff       	call   801288 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	a3 d0 20 80 00       	mov    %eax,0x8020d0
	
}
  8015f7:	83 c4 24             	add    $0x24,%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    
  8015fd:	00 00                	add    %al,(%eax)
	...

00801600 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801600:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801601:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  801606:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801608:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl  $8,   %esp		//pop fault va and err
  80160b:	83 c4 08             	add    $0x8,%esp
	movl  32(%esp), %ebx	//eip 
  80160e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	movl	40(%esp), %ecx	//esp
  801612:	8b 4c 24 28          	mov    0x28(%esp),%ecx
	
	movl	%ebx, -4(%ecx)	//put eip on top of stack
  801616:	89 59 fc             	mov    %ebx,-0x4(%ecx)
	subl  $4, %ecx  	
  801619:	83 e9 04             	sub    $0x4,%ecx
	movl	%ecx, 40(%esp)	//adjust esp 	
  80161c:	89 4c 24 28          	mov    %ecx,0x28(%esp)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal;
  801620:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl 	$4, %esp;		
  801621:	83 c4 04             	add    $0x4,%esp
	popfl ;
  801624:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801625:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801626:	c3                   	ret    
	...

00801630 <__udivdi3>:
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	57                   	push   %edi
  801634:	56                   	push   %esi
  801635:	83 ec 10             	sub    $0x10,%esp
  801638:	8b 45 14             	mov    0x14(%ebp),%eax
  80163b:	8b 55 08             	mov    0x8(%ebp),%edx
  80163e:	8b 75 10             	mov    0x10(%ebp),%esi
  801641:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801644:	85 c0                	test   %eax,%eax
  801646:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801649:	75 35                	jne    801680 <__udivdi3+0x50>
  80164b:	39 fe                	cmp    %edi,%esi
  80164d:	77 61                	ja     8016b0 <__udivdi3+0x80>
  80164f:	85 f6                	test   %esi,%esi
  801651:	75 0b                	jne    80165e <__udivdi3+0x2e>
  801653:	b8 01 00 00 00       	mov    $0x1,%eax
  801658:	31 d2                	xor    %edx,%edx
  80165a:	f7 f6                	div    %esi
  80165c:	89 c6                	mov    %eax,%esi
  80165e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801661:	31 d2                	xor    %edx,%edx
  801663:	89 f8                	mov    %edi,%eax
  801665:	f7 f6                	div    %esi
  801667:	89 c7                	mov    %eax,%edi
  801669:	89 c8                	mov    %ecx,%eax
  80166b:	f7 f6                	div    %esi
  80166d:	89 c1                	mov    %eax,%ecx
  80166f:	89 fa                	mov    %edi,%edx
  801671:	89 c8                	mov    %ecx,%eax
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
  80167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801680:	39 f8                	cmp    %edi,%eax
  801682:	77 1c                	ja     8016a0 <__udivdi3+0x70>
  801684:	0f bd d0             	bsr    %eax,%edx
  801687:	83 f2 1f             	xor    $0x1f,%edx
  80168a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80168d:	75 39                	jne    8016c8 <__udivdi3+0x98>
  80168f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801692:	0f 86 a0 00 00 00    	jbe    801738 <__udivdi3+0x108>
  801698:	39 f8                	cmp    %edi,%eax
  80169a:	0f 82 98 00 00 00    	jb     801738 <__udivdi3+0x108>
  8016a0:	31 ff                	xor    %edi,%edi
  8016a2:	31 c9                	xor    %ecx,%ecx
  8016a4:	89 c8                	mov    %ecx,%eax
  8016a6:	89 fa                	mov    %edi,%edx
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	5e                   	pop    %esi
  8016ac:	5f                   	pop    %edi
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    
  8016af:	90                   	nop
  8016b0:	89 d1                	mov    %edx,%ecx
  8016b2:	89 fa                	mov    %edi,%edx
  8016b4:	89 c8                	mov    %ecx,%eax
  8016b6:	31 ff                	xor    %edi,%edi
  8016b8:	f7 f6                	div    %esi
  8016ba:	89 c1                	mov    %eax,%ecx
  8016bc:	89 fa                	mov    %edi,%edx
  8016be:	89 c8                	mov    %ecx,%eax
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	5e                   	pop    %esi
  8016c4:	5f                   	pop    %edi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    
  8016c7:	90                   	nop
  8016c8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8016cc:	89 f2                	mov    %esi,%edx
  8016ce:	d3 e0                	shl    %cl,%eax
  8016d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d3:	b8 20 00 00 00       	mov    $0x20,%eax
  8016d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8016db:	89 c1                	mov    %eax,%ecx
  8016dd:	d3 ea                	shr    %cl,%edx
  8016df:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8016e3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8016e6:	d3 e6                	shl    %cl,%esi
  8016e8:	89 c1                	mov    %eax,%ecx
  8016ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8016ed:	89 fe                	mov    %edi,%esi
  8016ef:	d3 ee                	shr    %cl,%esi
  8016f1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8016f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8016f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fb:	d3 e7                	shl    %cl,%edi
  8016fd:	89 c1                	mov    %eax,%ecx
  8016ff:	d3 ea                	shr    %cl,%edx
  801701:	09 d7                	or     %edx,%edi
  801703:	89 f2                	mov    %esi,%edx
  801705:	89 f8                	mov    %edi,%eax
  801707:	f7 75 ec             	divl   -0x14(%ebp)
  80170a:	89 d6                	mov    %edx,%esi
  80170c:	89 c7                	mov    %eax,%edi
  80170e:	f7 65 e8             	mull   -0x18(%ebp)
  801711:	39 d6                	cmp    %edx,%esi
  801713:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801716:	72 30                	jb     801748 <__udivdi3+0x118>
  801718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80171f:	d3 e2                	shl    %cl,%edx
  801721:	39 c2                	cmp    %eax,%edx
  801723:	73 05                	jae    80172a <__udivdi3+0xfa>
  801725:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801728:	74 1e                	je     801748 <__udivdi3+0x118>
  80172a:	89 f9                	mov    %edi,%ecx
  80172c:	31 ff                	xor    %edi,%edi
  80172e:	e9 71 ff ff ff       	jmp    8016a4 <__udivdi3+0x74>
  801733:	90                   	nop
  801734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801738:	31 ff                	xor    %edi,%edi
  80173a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80173f:	e9 60 ff ff ff       	jmp    8016a4 <__udivdi3+0x74>
  801744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801748:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80174b:	31 ff                	xor    %edi,%edi
  80174d:	89 c8                	mov    %ecx,%eax
  80174f:	89 fa                	mov    %edi,%edx
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	5e                   	pop    %esi
  801755:	5f                   	pop    %edi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    
	...

00801760 <__umoddi3>:
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	57                   	push   %edi
  801764:	56                   	push   %esi
  801765:	83 ec 20             	sub    $0x20,%esp
  801768:	8b 55 14             	mov    0x14(%ebp),%edx
  80176b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801771:	8b 75 0c             	mov    0xc(%ebp),%esi
  801774:	85 d2                	test   %edx,%edx
  801776:	89 c8                	mov    %ecx,%eax
  801778:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80177b:	75 13                	jne    801790 <__umoddi3+0x30>
  80177d:	39 f7                	cmp    %esi,%edi
  80177f:	76 3f                	jbe    8017c0 <__umoddi3+0x60>
  801781:	89 f2                	mov    %esi,%edx
  801783:	f7 f7                	div    %edi
  801785:	89 d0                	mov    %edx,%eax
  801787:	31 d2                	xor    %edx,%edx
  801789:	83 c4 20             	add    $0x20,%esp
  80178c:	5e                   	pop    %esi
  80178d:	5f                   	pop    %edi
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    
  801790:	39 f2                	cmp    %esi,%edx
  801792:	77 4c                	ja     8017e0 <__umoddi3+0x80>
  801794:	0f bd ca             	bsr    %edx,%ecx
  801797:	83 f1 1f             	xor    $0x1f,%ecx
  80179a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80179d:	75 51                	jne    8017f0 <__umoddi3+0x90>
  80179f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8017a2:	0f 87 e0 00 00 00    	ja     801888 <__umoddi3+0x128>
  8017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ab:	29 f8                	sub    %edi,%eax
  8017ad:	19 d6                	sbb    %edx,%esi
  8017af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b5:	89 f2                	mov    %esi,%edx
  8017b7:	83 c4 20             	add    $0x20,%esp
  8017ba:	5e                   	pop    %esi
  8017bb:	5f                   	pop    %edi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    
  8017be:	66 90                	xchg   %ax,%ax
  8017c0:	85 ff                	test   %edi,%edi
  8017c2:	75 0b                	jne    8017cf <__umoddi3+0x6f>
  8017c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c9:	31 d2                	xor    %edx,%edx
  8017cb:	f7 f7                	div    %edi
  8017cd:	89 c7                	mov    %eax,%edi
  8017cf:	89 f0                	mov    %esi,%eax
  8017d1:	31 d2                	xor    %edx,%edx
  8017d3:	f7 f7                	div    %edi
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	f7 f7                	div    %edi
  8017da:	eb a9                	jmp    801785 <__umoddi3+0x25>
  8017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017e0:	89 c8                	mov    %ecx,%eax
  8017e2:	89 f2                	mov    %esi,%edx
  8017e4:	83 c4 20             	add    $0x20,%esp
  8017e7:	5e                   	pop    %esi
  8017e8:	5f                   	pop    %edi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    
  8017eb:	90                   	nop
  8017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8017f4:	d3 e2                	shl    %cl,%edx
  8017f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8017f9:	ba 20 00 00 00       	mov    $0x20,%edx
  8017fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801801:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801804:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801808:	89 fa                	mov    %edi,%edx
  80180a:	d3 ea                	shr    %cl,%edx
  80180c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801810:	0b 55 f4             	or     -0xc(%ebp),%edx
  801813:	d3 e7                	shl    %cl,%edi
  801815:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801819:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80181c:	89 f2                	mov    %esi,%edx
  80181e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801821:	89 c7                	mov    %eax,%edi
  801823:	d3 ea                	shr    %cl,%edx
  801825:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801829:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	d3 e6                	shl    %cl,%esi
  801830:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801834:	d3 ea                	shr    %cl,%edx
  801836:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80183a:	09 d6                	or     %edx,%esi
  80183c:	89 f0                	mov    %esi,%eax
  80183e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801841:	d3 e7                	shl    %cl,%edi
  801843:	89 f2                	mov    %esi,%edx
  801845:	f7 75 f4             	divl   -0xc(%ebp)
  801848:	89 d6                	mov    %edx,%esi
  80184a:	f7 65 e8             	mull   -0x18(%ebp)
  80184d:	39 d6                	cmp    %edx,%esi
  80184f:	72 2b                	jb     80187c <__umoddi3+0x11c>
  801851:	39 c7                	cmp    %eax,%edi
  801853:	72 23                	jb     801878 <__umoddi3+0x118>
  801855:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801859:	29 c7                	sub    %eax,%edi
  80185b:	19 d6                	sbb    %edx,%esi
  80185d:	89 f0                	mov    %esi,%eax
  80185f:	89 f2                	mov    %esi,%edx
  801861:	d3 ef                	shr    %cl,%edi
  801863:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801867:	d3 e0                	shl    %cl,%eax
  801869:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80186d:	09 f8                	or     %edi,%eax
  80186f:	d3 ea                	shr    %cl,%edx
  801871:	83 c4 20             	add    $0x20,%esp
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
  801878:	39 d6                	cmp    %edx,%esi
  80187a:	75 d9                	jne    801855 <__umoddi3+0xf5>
  80187c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80187f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801882:	eb d1                	jmp    801855 <__umoddi3+0xf5>
  801884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801888:	39 f2                	cmp    %esi,%edx
  80188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801890:	0f 82 12 ff ff ff    	jb     8017a8 <__umoddi3+0x48>
  801896:	e9 17 ff ff ff       	jmp    8017b2 <__umoddi3+0x52>
