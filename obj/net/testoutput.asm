
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 df 03 00 00       	call   800410 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 30 13 00 00       	call   801371 <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800043:	c7 05 00 30 80 00 c0 	movl   $0x801ec0,0x803000
  80004a:	1e 80 00 

	output_envid = fork();
  80004d:	e8 d4 13 00 00       	call   801426 <fork>
  800052:	a3 00 40 80 00       	mov    %eax,0x804000
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	79 1c                	jns    800077 <umain+0x43>
		panic("error forking");
  80005b:	c7 44 24 08 cb 1e 80 	movl   $0x801ecb,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 d9 1e 80 00 	movl   $0x801ed9,(%esp)
  800072:	e8 fd 03 00 00       	call   800474 <_panic>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
  800077:	bb 00 00 00 00       	mov    $0x0,%ebx
	binaryname = "testoutput";

	output_envid = fork();
	if (output_envid < 0)
		panic("error forking");
	else if (output_envid == 0) {
  80007c:	85 c0                	test   %eax,%eax
  80007e:	75 0d                	jne    80008d <umain+0x59>
		output(ns_envid);
  800080:	89 34 24             	mov    %esi,(%esp)
  800083:	e8 a0 02 00 00       	call   800328 <output>
		return;
  800088:	e9 c9 00 00 00       	jmp    800156 <umain+0x122>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80008d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800094:	00 
  800095:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80009c:	0f 
  80009d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a4:	e8 35 12 00 00       	call   8012de <sys_page_alloc>
  8000a9:	85 c0                	test   %eax,%eax
  8000ab:	79 20                	jns    8000cd <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b1:	c7 44 24 08 ea 1e 80 	movl   $0x801eea,0x8(%esp)
  8000b8:	00 
  8000b9:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000c0:	00 
  8000c1:	c7 04 24 d9 1e 80 00 	movl   $0x801ed9,(%esp)
  8000c8:	e8 a7 03 00 00       	call   800474 <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000cd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d1:	c7 44 24 08 fd 1e 80 	movl   $0x801efd,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000e8:	e8 17 0a 00 00       	call   800b04 <snprintf>
  8000ed:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f6:	c7 04 24 09 1f 80 00 	movl   $0x801f09,(%esp)
  8000fd:	e8 2b 04 00 00       	call   80052d <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800102:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800109:	00 
  80010a:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800111:	0f 
  800112:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800119:	00 
  80011a:	a1 00 40 80 00       	mov    0x804000,%eax
  80011f:	89 04 24             	mov    %eax,(%esp)
  800122:	e8 cb 16 00 00       	call   8017f2 <ipc_send>
		sys_page_unmap(0, pkt);
  800127:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80012e:	0f 
  80012f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800136:	e8 e7 10 00 00       	call   801222 <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80013b:	83 c3 01             	add    $0x1,%ebx
  80013e:	83 fb 0a             	cmp    $0xa,%ebx
  800141:	0f 85 46 ff ff ff    	jne    80008d <umain+0x59>
  800147:	b3 00                	mov    $0x0,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800149:	e8 ef 11 00 00       	call   80133d <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80014e:	83 c3 01             	add    $0x1,%ebx
  800151:	83 fb 14             	cmp    $0x14,%ebx
  800154:	75 f3                	jne    800149 <umain+0x115>
		sys_yield();
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    
  80015d:	00 00                	add    %al,(%eax)
	...

00800160 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 2c             	sub    $0x2c,%esp
  800169:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80016c:	e8 12 0e 00 00       	call   800f83 <sys_time_msec>
  800171:	89 c3                	mov    %eax,%ebx
  800173:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800176:	c7 05 00 30 80 00 21 	movl   $0x801f21,0x803000
  80017d:	1f 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800180:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800183:	eb 05                	jmp    80018a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800185:	e8 b3 11 00 00       	call   80133d <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80018a:	e8 f4 0d 00 00       	call   800f83 <sys_time_msec>
  80018f:	39 c3                	cmp    %eax,%ebx
  800191:	76 06                	jbe    800199 <timer+0x39>
  800193:	85 c0                	test   %eax,%eax
  800195:	79 ee                	jns    800185 <timer+0x25>
  800197:	eb 09                	jmp    8001a2 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	90                   	nop
  80019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8001a0:	79 20                	jns    8001c2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  8001a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a6:	c7 44 24 08 2a 1f 80 	movl   $0x801f2a,0x8(%esp)
  8001ad:	00 
  8001ae:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8001b5:	00 
  8001b6:	c7 04 24 3c 1f 80 00 	movl   $0x801f3c,(%esp)
  8001bd:	e8 b2 02 00 00       	call   800474 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c9:	00 
  8001ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001d1:	00 
  8001d2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001d9:	00 
  8001da:	89 34 24             	mov    %esi,(%esp)
  8001dd:	e8 10 16 00 00       	call   8017f2 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001e9:	00 
  8001ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001f1:	00 
  8001f2:	89 3c 24             	mov    %edi,(%esp)
  8001f5:	e8 64 16 00 00       	call   80185e <ipc_recv>
  8001fa:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	39 c6                	cmp    %eax,%esi
  800201:	74 12                	je     800215 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 48 1f 80 00 	movl   $0x801f48,(%esp)
  80020e:	e8 1a 03 00 00       	call   80052d <cprintf>
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  800213:	eb cd                	jmp    8001e2 <timer+0x82>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800215:	e8 69 0d 00 00       	call   800f83 <sys_time_msec>
  80021a:	01 c3                	add    %eax,%ebx
  80021c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800220:	e9 65 ff ff ff       	jmp    80018a <timer+0x2a>
	...

00800230 <input>:

void
input(envid_t ns_envid)
//void
//umain(int argc, char **argv)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 2c             	sub    $0x2c,%esp
	uint32_t req, whom, size;
	int perm, ret, even_odd = 0;
	envid_t to_env;

	binaryname = "ns_input";
  800239:	c7 05 00 30 80 00 83 	movl   $0x801f83,0x803000
  800240:	1f 80 00 
  800243:	bb 00 00 00 00       	mov    $0x0,%ebx
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	while (1) 
	{
		ret = sys_net_receive((void *)INPUT_PKTMAP,&size);
  800248:	8d 75 e4             	lea    -0x1c(%ebp),%esi
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_P|PTE_W|PTE_U);

		}
		else
		{
			nsipcbuf_1.pkt.jp_len = size;
  80024b:	bf 00 50 80 00       	mov    $0x805000,%edi
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	while (1) 
	{
		ret = sys_net_receive((void *)INPUT_PKTMAP,&size);
  800250:	89 74 24 04          	mov    %esi,0x4(%esp)
  800254:	c7 04 24 00 00 00 10 	movl   $0x10000000,(%esp)
  80025b:	e8 57 0d 00 00       	call   800fb7 <sys_net_receive>
		if( ret == -E_NO_RDESC ) 
  800260:	83 f8 ef             	cmp    $0xffffffef,%eax
  800263:	75 07                	jne    80026c <input+0x3c>
		  {sys_yield(); continue;}
  800265:	e8 d3 10 00 00       	call   80133d <sys_yield>
  80026a:	eb e4                	jmp    800250 <input+0x20>
		cprintf("%s get an input packet size %u\n",__func__,size);
  80026c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800273:	c7 44 24 04 ac 1f 80 	movl   $0x801fac,0x4(%esp)
  80027a:	00 
  80027b:	c7 04 24 8c 1f 80 00 	movl   $0x801f8c,(%esp)
  800282:	e8 a6 02 00 00       	call   80052d <cprintf>

		if(even_odd)
  800287:	85 db                	test   %ebx,%ebx
  800289:	74 45                	je     8002d0 <input+0xa0>
		{
			nsipcbuf.pkt.jp_len = size;
  80028b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028e:	a3 00 60 80 00       	mov    %eax,0x806000
			memmove(nsipcbuf.pkt.jp_data,(void *)INPUT_PKTMAP,nsipcbuf.pkt.jp_len);
  800293:	89 44 24 08          	mov    %eax,0x8(%esp)
  800297:	c7 44 24 04 00 00 00 	movl   $0x10000000,0x4(%esp)
  80029e:	10 
  80029f:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8002a6:	e8 94 0a 00 00       	call   800d3f <memmove>
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_P|PTE_W|PTE_U);
  8002ab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002b2:	00 
  8002b3:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8002ba:	00 
  8002bb:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8002c2:	00 
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	89 04 24             	mov    %eax,(%esp)
  8002c9:	e8 24 15 00 00       	call   8017f2 <ipc_send>
  8002ce:	eb 3c                	jmp    80030c <input+0xdc>

		}
		else
		{
			nsipcbuf_1.pkt.jp_len = size;
  8002d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d3:	89 07                	mov    %eax,(%edi)
			memmove(nsipcbuf_1.pkt.jp_data,(void *)INPUT_PKTMAP,nsipcbuf_1.pkt.jp_len);
  8002d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d9:	c7 44 24 04 00 00 00 	movl   $0x10000000,0x4(%esp)
  8002e0:	10 
  8002e1:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8002e8:	e8 52 0a 00 00       	call   800d3f <memmove>
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf_1,PTE_P|PTE_W|PTE_U);
  8002ed:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002f4:	00 
  8002f5:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8002f9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800300:	00 
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	89 04 24             	mov    %eax,(%esp)
  800307:	e8 e6 14 00 00       	call   8017f2 <ipc_send>
		}
		even_odd = (even_odd+1)%2;
  80030c:	83 c3 01             	add    $0x1,%ebx
  80030f:	89 d8                	mov    %ebx,%eax
  800311:	c1 e8 1f             	shr    $0x1f,%eax
  800314:	01 c3                	add    %eax,%ebx
  800316:	83 e3 01             	and    $0x1,%ebx
  800319:	29 c3                	sub    %eax,%ebx
		sys_yield();
  80031b:	e8 1d 10 00 00       	call   80133d <sys_yield>
  800320:	e9 2b ff ff ff       	jmp    800250 <input+0x20>
  800325:	00 00                	add    %al,(%eax)
	...

00800328 <output>:

void
output(envid_t ns_envid)
//void
//umain(int argc, char **argv)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 3c             	sub    $0x3c,%esp
	//	- send the packet to the device driver
	uint32_t req, whom;
	int perm, ret;
	void *pg;

	binaryname = "ns_output";
  800331:	c7 05 00 30 80 00 b2 	movl   $0x801fb2,0x803000
  800338:	1f 80 00 
	//cprintf("output is running\n");

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, &nsipcbuf, &perm);
  80033b:	8d 75 e0             	lea    -0x20(%ebp),%esi
  80033e:	8d 7d e4             	lea    -0x1c(%ebp),%edi

	binaryname = "ns_output";
	//cprintf("output is running\n");

	while (1) {
		perm = 0;
  800341:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv((int32_t *) &whom, &nsipcbuf, &perm);
  800348:	89 74 24 08          	mov    %esi,0x8(%esp)
  80034c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  800353:	00 
  800354:	89 3c 24             	mov    %edi,(%esp)
  800357:	e8 02 15 00 00       	call   80185e <ipc_recv>

		cprintf("%s req %d from %08x size %u\n", __func__, req, whom, nsipcbuf.pkt.jp_len);
  80035c:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800362:	89 54 24 10          	mov    %edx,0x10(%esp)
  800366:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800369:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80036d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800371:	c7 44 24 04 4f 20 80 	movl   $0x80204f,0x4(%esp)
  800378:	00 
  800379:	c7 04 24 bc 1f 80 00 	movl   $0x801fbc,(%esp)
  800380:	e8 a8 01 00 00       	call   80052d <cprintf>

		// All requests must contain an argument page
		if (!(perm & PTE_P)) 
  800385:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  800389:	75 15                	jne    8003a0 <output+0x78>
		{
			cprintf("Invalid request from %08x: no argument page\n",whom);
  80038b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800392:	c7 04 24 f8 1f 80 00 	movl   $0x801ff8,(%esp)
  800399:	e8 8f 01 00 00       	call   80052d <cprintf>
			continue;
  80039e:	eb a1                	jmp    800341 <output+0x19>
		}

		if(whom != ns_envid)
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a6:	74 24                	je     8003cc <output+0xa4>
			panic("%s get message from wrong environments",__func__);
  8003a8:	c7 44 24 0c 4f 20 80 	movl   $0x80204f,0xc(%esp)
  8003af:	00 
  8003b0:	c7 44 24 08 28 20 80 	movl   $0x802028,0x8(%esp)
  8003b7:	00 
  8003b8:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8003bf:	00 
  8003c0:	c7 04 24 d9 1f 80 00 	movl   $0x801fd9,(%esp)
  8003c7:	e8 a8 00 00 00       	call   800474 <_panic>

		do 
		{ret = sys_net_send(nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len);}
  8003cc:	bb 00 60 80 00       	mov    $0x806000,%ebx
  8003d1:	8b 03                	mov    (%ebx),%eax
  8003d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8003de:	e8 32 0c 00 00       	call   801015 <sys_net_send>
		while(ret == -E_NO_TXDESC);
  8003e3:	83 f8 f0             	cmp    $0xfffffff0,%eax
  8003e6:	74 e9                	je     8003d1 <output+0xa9>

		if(ret)panic("output error %e\n",ret);
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	0f 84 51 ff ff ff    	je     800341 <output+0x19>
  8003f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f4:	c7 44 24 08 e6 1f 80 	movl   $0x801fe6,0x8(%esp)
  8003fb:	00 
  8003fc:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  800403:	00 
  800404:	c7 04 24 d9 1f 80 00 	movl   $0x801fd9,(%esp)
  80040b:	e8 64 00 00 00       	call   800474 <_panic>

00800410 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 18             	sub    $0x18,%esp
  800416:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800419:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80041c:	8b 75 08             	mov    0x8(%ebp),%esi
  80041f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800422:	e8 4a 0f 00 00       	call   801371 <sys_getenvid>
  800427:	25 ff 03 00 00       	and    $0x3ff,%eax
  80042c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80042f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800434:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800439:	85 f6                	test   %esi,%esi
  80043b:	7e 07                	jle    800444 <libmain+0x34>
		binaryname = argv[0];
  80043d:	8b 03                	mov    (%ebx),%eax
  80043f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800444:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800448:	89 34 24             	mov    %esi,(%esp)
  80044b:	e8 e4 fb ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800450:	e8 0b 00 00 00       	call   800460 <exit>
}
  800455:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800458:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80045b:	89 ec                	mov    %ebp,%esp
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    
	...

00800460 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80046d:	e8 33 0f 00 00       	call   8013a5 <sys_env_destroy>
}
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	56                   	push   %esi
  800478:	53                   	push   %ebx
  800479:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80047c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80047f:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800485:	e8 e7 0e 00 00       	call   801371 <sys_getenvid>
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800491:	8b 55 08             	mov    0x8(%ebp),%edx
  800494:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800498:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a0:	c7 04 24 60 20 80 00 	movl   $0x802060,(%esp)
  8004a7:	e8 81 00 00 00       	call   80052d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b3:	89 04 24             	mov    %eax,(%esp)
  8004b6:	e8 11 00 00 00       	call   8004cc <vcprintf>
	cprintf("\n");
  8004bb:	c7 04 24 7d 24 80 00 	movl   $0x80247d,(%esp)
  8004c2:	e8 66 00 00 00       	call   80052d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004c7:	cc                   	int3   
  8004c8:	eb fd                	jmp    8004c7 <_panic+0x53>
	...

008004cc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8004d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004dc:	00 00 00 
	b.cnt = 0;
  8004df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800501:	c7 04 24 47 05 80 00 	movl   $0x800547,(%esp)
  800508:	e8 be 01 00 00       	call   8006cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80050d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800513:	89 44 24 04          	mov    %eax,0x4(%esp)
  800517:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 2b 0a 00 00       	call   800f50 <sys_cputs>

	return b.cnt;
}
  800525:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800533:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	89 04 24             	mov    %eax,(%esp)
  800540:	e8 87 ff ff ff       	call   8004cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	53                   	push   %ebx
  80054b:	83 ec 14             	sub    $0x14,%esp
  80054e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800551:	8b 03                	mov    (%ebx),%eax
  800553:	8b 55 08             	mov    0x8(%ebp),%edx
  800556:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80055a:	83 c0 01             	add    $0x1,%eax
  80055d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80055f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800564:	75 19                	jne    80057f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800566:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80056d:	00 
  80056e:	8d 43 08             	lea    0x8(%ebx),%eax
  800571:	89 04 24             	mov    %eax,(%esp)
  800574:	e8 d7 09 00 00       	call   800f50 <sys_cputs>
		b->idx = 0;
  800579:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80057f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800583:	83 c4 14             	add    $0x14,%esp
  800586:	5b                   	pop    %ebx
  800587:	5d                   	pop    %ebp
  800588:	c3                   	ret    
  800589:	00 00                	add    %al,(%eax)
	...

0080058c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	57                   	push   %edi
  800590:	56                   	push   %esi
  800591:	53                   	push   %ebx
  800592:	83 ec 4c             	sub    $0x4c,%esp
  800595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800598:	89 d6                	mov    %edx,%esi
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005ac:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b7:	39 d1                	cmp    %edx,%ecx
  8005b9:	72 07                	jb     8005c2 <printnum+0x36>
  8005bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005be:	39 d0                	cmp    %edx,%eax
  8005c0:	77 69                	ja     80062b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005c6:	83 eb 01             	sub    $0x1,%ebx
  8005c9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005d1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8005d5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8005d9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005dc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005df:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005e6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005ed:	00 
  8005ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005f1:	89 04 24             	mov    %eax,(%esp)
  8005f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005fb:	e8 50 16 00 00       	call   801c50 <__udivdi3>
  800600:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800603:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800606:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80060a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80060e:	89 04 24             	mov    %eax,(%esp)
  800611:	89 54 24 04          	mov    %edx,0x4(%esp)
  800615:	89 f2                	mov    %esi,%edx
  800617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80061a:	e8 6d ff ff ff       	call   80058c <printnum>
  80061f:	eb 11                	jmp    800632 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800621:	89 74 24 04          	mov    %esi,0x4(%esp)
  800625:	89 3c 24             	mov    %edi,(%esp)
  800628:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80062b:	83 eb 01             	sub    $0x1,%ebx
  80062e:	85 db                	test   %ebx,%ebx
  800630:	7f ef                	jg     800621 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800632:	89 74 24 04          	mov    %esi,0x4(%esp)
  800636:	8b 74 24 04          	mov    0x4(%esp),%esi
  80063a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800641:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800648:	00 
  800649:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064c:	89 14 24             	mov    %edx,(%esp)
  80064f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800652:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800656:	e8 25 17 00 00       	call   801d80 <__umoddi3>
  80065b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065f:	0f be 80 83 20 80 00 	movsbl 0x802083(%eax),%eax
  800666:	89 04 24             	mov    %eax,(%esp)
  800669:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80066c:	83 c4 4c             	add    $0x4c,%esp
  80066f:	5b                   	pop    %ebx
  800670:	5e                   	pop    %esi
  800671:	5f                   	pop    %edi
  800672:	5d                   	pop    %ebp
  800673:	c3                   	ret    

00800674 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800674:	55                   	push   %ebp
  800675:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800677:	83 fa 01             	cmp    $0x1,%edx
  80067a:	7e 0e                	jle    80068a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80067c:	8b 10                	mov    (%eax),%edx
  80067e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800681:	89 08                	mov    %ecx,(%eax)
  800683:	8b 02                	mov    (%edx),%eax
  800685:	8b 52 04             	mov    0x4(%edx),%edx
  800688:	eb 22                	jmp    8006ac <getuint+0x38>
	else if (lflag)
  80068a:	85 d2                	test   %edx,%edx
  80068c:	74 10                	je     80069e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8d 4a 04             	lea    0x4(%edx),%ecx
  800693:	89 08                	mov    %ecx,(%eax)
  800695:	8b 02                	mov    (%edx),%eax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
  80069c:	eb 0e                	jmp    8006ac <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80069e:	8b 10                	mov    (%eax),%edx
  8006a0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006a3:	89 08                	mov    %ecx,(%eax)
  8006a5:	8b 02                	mov    (%edx),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006b4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	3b 50 04             	cmp    0x4(%eax),%edx
  8006bd:	73 0a                	jae    8006c9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006c2:	88 0a                	mov    %cl,(%edx)
  8006c4:	83 c2 01             	add    $0x1,%edx
  8006c7:	89 10                	mov    %edx,(%eax)
}
  8006c9:	5d                   	pop    %ebp
  8006ca:	c3                   	ret    

008006cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	57                   	push   %edi
  8006cf:	56                   	push   %esi
  8006d0:	53                   	push   %ebx
  8006d1:	83 ec 4c             	sub    $0x4c,%esp
  8006d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006da:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006dd:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8006e4:	eb 11                	jmp    8006f7 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	0f 84 b6 03 00 00    	je     800aa4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  8006ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f2:	89 04 24             	mov    %eax,(%esp)
  8006f5:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f7:	0f b6 03             	movzbl (%ebx),%eax
  8006fa:	83 c3 01             	add    $0x1,%ebx
  8006fd:	83 f8 25             	cmp    $0x25,%eax
  800700:	75 e4                	jne    8006e6 <vprintfmt+0x1b>
  800702:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800706:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80070d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800714:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80071b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800720:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800723:	eb 06                	jmp    80072b <vprintfmt+0x60>
  800725:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800729:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072b:	0f b6 0b             	movzbl (%ebx),%ecx
  80072e:	0f b6 c1             	movzbl %cl,%eax
  800731:	8d 53 01             	lea    0x1(%ebx),%edx
  800734:	83 e9 23             	sub    $0x23,%ecx
  800737:	80 f9 55             	cmp    $0x55,%cl
  80073a:	0f 87 47 03 00 00    	ja     800a87 <vprintfmt+0x3bc>
  800740:	0f b6 c9             	movzbl %cl,%ecx
  800743:	ff 24 8d c0 21 80 00 	jmp    *0x8021c0(,%ecx,4)
  80074a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80074e:	eb d9                	jmp    800729 <vprintfmt+0x5e>
  800750:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80075c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80075f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800763:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800766:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800769:	83 fb 09             	cmp    $0x9,%ebx
  80076c:	77 30                	ja     80079e <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800771:	eb e9                	jmp    80075c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 48 04             	lea    0x4(%eax),%ecx
  800779:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800781:	eb 1e                	jmp    8007a1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800787:	b8 00 00 00 00       	mov    $0x0,%eax
  80078c:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800793:	eb 94                	jmp    800729 <vprintfmt+0x5e>
  800795:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80079c:	eb 8b                	jmp    800729 <vprintfmt+0x5e>
  80079e:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	79 82                	jns    800729 <vprintfmt+0x5e>
  8007a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ad:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007b0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8007b3:	e9 71 ff ff ff       	jmp    800729 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007b8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007bc:	e9 68 ff ff ff       	jmp    800729 <vprintfmt+0x5e>
  8007c1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8007cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 04 24             	mov    %eax,(%esp)
  8007d6:	ff d7                	call   *%edi
  8007d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8007db:	e9 17 ff ff ff       	jmp    8006f7 <vprintfmt+0x2c>
  8007e0:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 50 04             	lea    0x4(%eax),%edx
  8007e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	89 c2                	mov    %eax,%edx
  8007f0:	c1 fa 1f             	sar    $0x1f,%edx
  8007f3:	31 d0                	xor    %edx,%eax
  8007f5:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007f7:	83 f8 11             	cmp    $0x11,%eax
  8007fa:	7f 0b                	jg     800807 <vprintfmt+0x13c>
  8007fc:	8b 14 85 20 23 80 00 	mov    0x802320(,%eax,4),%edx
  800803:	85 d2                	test   %edx,%edx
  800805:	75 20                	jne    800827 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800807:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080b:	c7 44 24 08 94 20 80 	movl   $0x802094,0x8(%esp)
  800812:	00 
  800813:	89 74 24 04          	mov    %esi,0x4(%esp)
  800817:	89 3c 24             	mov    %edi,(%esp)
  80081a:	e8 0d 03 00 00       	call   800b2c <printfmt>
  80081f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800822:	e9 d0 fe ff ff       	jmp    8006f7 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800827:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80082b:	c7 44 24 08 b0 24 80 	movl   $0x8024b0,0x8(%esp)
  800832:	00 
  800833:	89 74 24 04          	mov    %esi,0x4(%esp)
  800837:	89 3c 24             	mov    %edi,(%esp)
  80083a:	e8 ed 02 00 00       	call   800b2c <printfmt>
  80083f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800842:	e9 b0 fe ff ff       	jmp    8006f7 <vprintfmt+0x2c>
  800847:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80084a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80084d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800850:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8d 50 04             	lea    0x4(%eax),%edx
  800859:	89 55 14             	mov    %edx,0x14(%ebp)
  80085c:	8b 18                	mov    (%eax),%ebx
  80085e:	85 db                	test   %ebx,%ebx
  800860:	b8 9d 20 80 00       	mov    $0x80209d,%eax
  800865:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800868:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80086c:	7e 76                	jle    8008e4 <vprintfmt+0x219>
  80086e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800872:	74 7a                	je     8008ee <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800874:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800878:	89 1c 24             	mov    %ebx,(%esp)
  80087b:	e8 f8 02 00 00       	call   800b78 <strnlen>
  800880:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800883:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800885:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800889:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80088c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  80088f:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800891:	eb 0f                	jmp    8008a2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800893:	89 74 24 04          	mov    %esi,0x4(%esp)
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 04 24             	mov    %eax,(%esp)
  80089d:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80089f:	83 eb 01             	sub    $0x1,%ebx
  8008a2:	85 db                	test   %ebx,%ebx
  8008a4:	7f ed                	jg     800893 <vprintfmt+0x1c8>
  8008a6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8008a9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008ac:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008af:	89 f7                	mov    %esi,%edi
  8008b1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008b4:	eb 40                	jmp    8008f6 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008ba:	74 18                	je     8008d4 <vprintfmt+0x209>
  8008bc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008bf:	83 fa 5e             	cmp    $0x5e,%edx
  8008c2:	76 10                	jbe    8008d4 <vprintfmt+0x209>
					putch('?', putdat);
  8008c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008c8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008cf:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008d2:	eb 0a                	jmp    8008de <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8008d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d8:	89 04 24             	mov    %eax,(%esp)
  8008db:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008de:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008e2:	eb 12                	jmp    8008f6 <vprintfmt+0x22b>
  8008e4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008e7:	89 f7                	mov    %esi,%edi
  8008e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008ec:	eb 08                	jmp    8008f6 <vprintfmt+0x22b>
  8008ee:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008f1:	89 f7                	mov    %esi,%edi
  8008f3:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008f6:	0f be 03             	movsbl (%ebx),%eax
  8008f9:	83 c3 01             	add    $0x1,%ebx
  8008fc:	85 c0                	test   %eax,%eax
  8008fe:	74 25                	je     800925 <vprintfmt+0x25a>
  800900:	85 f6                	test   %esi,%esi
  800902:	78 b2                	js     8008b6 <vprintfmt+0x1eb>
  800904:	83 ee 01             	sub    $0x1,%esi
  800907:	79 ad                	jns    8008b6 <vprintfmt+0x1eb>
  800909:	89 fe                	mov    %edi,%esi
  80090b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80090e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800911:	eb 1a                	jmp    80092d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800913:	89 74 24 04          	mov    %esi,0x4(%esp)
  800917:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80091e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800920:	83 eb 01             	sub    $0x1,%ebx
  800923:	eb 08                	jmp    80092d <vprintfmt+0x262>
  800925:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800928:	89 fe                	mov    %edi,%esi
  80092a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80092d:	85 db                	test   %ebx,%ebx
  80092f:	7f e2                	jg     800913 <vprintfmt+0x248>
  800931:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800934:	e9 be fd ff ff       	jmp    8006f7 <vprintfmt+0x2c>
  800939:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80093c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80093f:	83 f9 01             	cmp    $0x1,%ecx
  800942:	7e 16                	jle    80095a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8d 50 08             	lea    0x8(%eax),%edx
  80094a:	89 55 14             	mov    %edx,0x14(%ebp)
  80094d:	8b 10                	mov    (%eax),%edx
  80094f:	8b 48 04             	mov    0x4(%eax),%ecx
  800952:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800955:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800958:	eb 32                	jmp    80098c <vprintfmt+0x2c1>
	else if (lflag)
  80095a:	85 c9                	test   %ecx,%ecx
  80095c:	74 18                	je     800976 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	89 55 14             	mov    %edx,0x14(%ebp)
  800967:	8b 00                	mov    (%eax),%eax
  800969:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096c:	89 c1                	mov    %eax,%ecx
  80096e:	c1 f9 1f             	sar    $0x1f,%ecx
  800971:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800974:	eb 16                	jmp    80098c <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	8d 50 04             	lea    0x4(%eax),%edx
  80097c:	89 55 14             	mov    %edx,0x14(%ebp)
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800984:	89 c2                	mov    %eax,%edx
  800986:	c1 fa 1f             	sar    $0x1f,%edx
  800989:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80098c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80098f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800992:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800997:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099b:	0f 89 a7 00 00 00    	jns    800a48 <vprintfmt+0x37d>
				putch('-', putdat);
  8009a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009a5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009ac:	ff d7                	call   *%edi
				num = -(long long) num;
  8009ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009b1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009b4:	f7 d9                	neg    %ecx
  8009b6:	83 d3 00             	adc    $0x0,%ebx
  8009b9:	f7 db                	neg    %ebx
  8009bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009c0:	e9 83 00 00 00       	jmp    800a48 <vprintfmt+0x37d>
  8009c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009cb:	89 ca                	mov    %ecx,%edx
  8009cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d0:	e8 9f fc ff ff       	call   800674 <getuint>
  8009d5:	89 c1                	mov    %eax,%ecx
  8009d7:	89 d3                	mov    %edx,%ebx
  8009d9:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8009de:	eb 68                	jmp    800a48 <vprintfmt+0x37d>
  8009e0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009e3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8009e6:	89 ca                	mov    %ecx,%edx
  8009e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009eb:	e8 84 fc ff ff       	call   800674 <getuint>
  8009f0:	89 c1                	mov    %eax,%ecx
  8009f2:	89 d3                	mov    %edx,%ebx
  8009f4:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8009f9:	eb 4d                	jmp    800a48 <vprintfmt+0x37d>
  8009fb:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8009fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a02:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a09:	ff d7                	call   *%edi
			putch('x', putdat);
  800a0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a0f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a16:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	8d 50 04             	lea    0x4(%eax),%edx
  800a1e:	89 55 14             	mov    %edx,0x14(%ebp)
  800a21:	8b 08                	mov    (%eax),%ecx
  800a23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a28:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a2d:	eb 19                	jmp    800a48 <vprintfmt+0x37d>
  800a2f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a32:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a35:	89 ca                	mov    %ecx,%edx
  800a37:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3a:	e8 35 fc ff ff       	call   800674 <getuint>
  800a3f:	89 c1                	mov    %eax,%ecx
  800a41:	89 d3                	mov    %edx,%ebx
  800a43:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a48:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800a4c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a53:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a57:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5b:	89 0c 24             	mov    %ecx,(%esp)
  800a5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a62:	89 f2                	mov    %esi,%edx
  800a64:	89 f8                	mov    %edi,%eax
  800a66:	e8 21 fb ff ff       	call   80058c <printnum>
  800a6b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800a6e:	e9 84 fc ff ff       	jmp    8006f7 <vprintfmt+0x2c>
  800a73:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a76:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7a:	89 04 24             	mov    %eax,(%esp)
  800a7d:	ff d7                	call   *%edi
  800a7f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800a82:	e9 70 fc ff ff       	jmp    8006f7 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a87:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a8b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a92:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800a97:	80 38 25             	cmpb   $0x25,(%eax)
  800a9a:	0f 84 57 fc ff ff    	je     8006f7 <vprintfmt+0x2c>
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	eb f0                	jmp    800a94 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800aa4:	83 c4 4c             	add    $0x4c,%esp
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5f                   	pop    %edi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 28             	sub    $0x28,%esp
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800ab8:	85 c0                	test   %eax,%eax
  800aba:	74 04                	je     800ac0 <vsnprintf+0x14>
  800abc:	85 d2                	test   %edx,%edx
  800abe:	7f 07                	jg     800ac7 <vsnprintf+0x1b>
  800ac0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ac5:	eb 3b                	jmp    800b02 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aca:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800adf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aed:	c7 04 24 ae 06 80 00 	movl   $0x8006ae,(%esp)
  800af4:	e8 d2 fb ff ff       	call   8006cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800afc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b11:	8b 45 10             	mov    0x10(%ebp),%eax
  800b14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	e8 82 ff ff ff       	call   800aac <vsnprintf>
	va_end(ap);

	return rc;
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b32:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b39:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 04 24             	mov    %eax,(%esp)
  800b4d:	e8 79 fb ff ff       	call   8006cb <vprintfmt>
	va_end(ap);
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    
	...

00800b60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800b6b:	eb 03                	jmp    800b70 <strlen+0x10>
		n++;
  800b6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b74:	75 f7                	jne    800b6d <strlen+0xd>
		n++;
	return n;
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	53                   	push   %ebx
  800b7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b82:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b87:	eb 03                	jmp    800b8c <strnlen+0x14>
		n++;
  800b89:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8c:	39 c1                	cmp    %eax,%ecx
  800b8e:	74 06                	je     800b96 <strnlen+0x1e>
  800b90:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b94:	75 f3                	jne    800b89 <strnlen+0x11>
		n++;
	return n;
}
  800b96:	5b                   	pop    %ebx
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	53                   	push   %ebx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ba3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ba8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800baf:	83 c2 01             	add    $0x1,%edx
  800bb2:	84 c9                	test   %cl,%cl
  800bb4:	75 f2                	jne    800ba8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bc3:	89 1c 24             	mov    %ebx,(%esp)
  800bc6:	e8 95 ff ff ff       	call   800b60 <strlen>
	strcpy(dst + len, src);
  800bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bce:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bd2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800bd5:	89 04 24             	mov    %eax,(%esp)
  800bd8:	e8 bc ff ff ff       	call   800b99 <strcpy>
	return dst;
}
  800bdd:	89 d8                	mov    %ebx,%eax
  800bdf:	83 c4 08             	add    $0x8,%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf0:	8b 75 10             	mov    0x10(%ebp),%esi
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf8:	eb 0f                	jmp    800c09 <strncpy+0x24>
		*dst++ = *src;
  800bfa:	0f b6 19             	movzbl (%ecx),%ebx
  800bfd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c00:	80 39 01             	cmpb   $0x1,(%ecx)
  800c03:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c06:	83 c2 01             	add    $0x1,%edx
  800c09:	39 f2                	cmp    %esi,%edx
  800c0b:	72 ed                	jb     800bfa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    

00800c11 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	8b 75 08             	mov    0x8(%ebp),%esi
  800c19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c1f:	89 f0                	mov    %esi,%eax
  800c21:	85 d2                	test   %edx,%edx
  800c23:	75 0a                	jne    800c2f <strlcpy+0x1e>
  800c25:	eb 17                	jmp    800c3e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c27:	88 18                	mov    %bl,(%eax)
  800c29:	83 c0 01             	add    $0x1,%eax
  800c2c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c2f:	83 ea 01             	sub    $0x1,%edx
  800c32:	74 07                	je     800c3b <strlcpy+0x2a>
  800c34:	0f b6 19             	movzbl (%ecx),%ebx
  800c37:	84 db                	test   %bl,%bl
  800c39:	75 ec                	jne    800c27 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800c3b:	c6 00 00             	movb   $0x0,(%eax)
  800c3e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c4d:	eb 06                	jmp    800c55 <strcmp+0x11>
		p++, q++;
  800c4f:	83 c1 01             	add    $0x1,%ecx
  800c52:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c55:	0f b6 01             	movzbl (%ecx),%eax
  800c58:	84 c0                	test   %al,%al
  800c5a:	74 04                	je     800c60 <strcmp+0x1c>
  800c5c:	3a 02                	cmp    (%edx),%al
  800c5e:	74 ef                	je     800c4f <strcmp+0xb>
  800c60:	0f b6 c0             	movzbl %al,%eax
  800c63:	0f b6 12             	movzbl (%edx),%edx
  800c66:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	53                   	push   %ebx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800c77:	eb 09                	jmp    800c82 <strncmp+0x18>
		n--, p++, q++;
  800c79:	83 ea 01             	sub    $0x1,%edx
  800c7c:	83 c0 01             	add    $0x1,%eax
  800c7f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c82:	85 d2                	test   %edx,%edx
  800c84:	75 07                	jne    800c8d <strncmp+0x23>
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8b:	eb 13                	jmp    800ca0 <strncmp+0x36>
  800c8d:	0f b6 18             	movzbl (%eax),%ebx
  800c90:	84 db                	test   %bl,%bl
  800c92:	74 04                	je     800c98 <strncmp+0x2e>
  800c94:	3a 19                	cmp    (%ecx),%bl
  800c96:	74 e1                	je     800c79 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c98:	0f b6 00             	movzbl (%eax),%eax
  800c9b:	0f b6 11             	movzbl (%ecx),%edx
  800c9e:	29 d0                	sub    %edx,%eax
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cad:	eb 07                	jmp    800cb6 <strchr+0x13>
		if (*s == c)
  800caf:	38 ca                	cmp    %cl,%dl
  800cb1:	74 0f                	je     800cc2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb3:	83 c0 01             	add    $0x1,%eax
  800cb6:	0f b6 10             	movzbl (%eax),%edx
  800cb9:	84 d2                	test   %dl,%dl
  800cbb:	75 f2                	jne    800caf <strchr+0xc>
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cce:	eb 07                	jmp    800cd7 <strfind+0x13>
		if (*s == c)
  800cd0:	38 ca                	cmp    %cl,%dl
  800cd2:	74 0a                	je     800cde <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd4:	83 c0 01             	add    $0x1,%eax
  800cd7:	0f b6 10             	movzbl (%eax),%edx
  800cda:	84 d2                	test   %dl,%dl
  800cdc:	75 f2                	jne    800cd0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	89 1c 24             	mov    %ebx,(%esp)
  800ce9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ced:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cfa:	85 c9                	test   %ecx,%ecx
  800cfc:	74 30                	je     800d2e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cfe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d04:	75 25                	jne    800d2b <memset+0x4b>
  800d06:	f6 c1 03             	test   $0x3,%cl
  800d09:	75 20                	jne    800d2b <memset+0x4b>
		c &= 0xFF;
  800d0b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0e:	89 d3                	mov    %edx,%ebx
  800d10:	c1 e3 08             	shl    $0x8,%ebx
  800d13:	89 d6                	mov    %edx,%esi
  800d15:	c1 e6 18             	shl    $0x18,%esi
  800d18:	89 d0                	mov    %edx,%eax
  800d1a:	c1 e0 10             	shl    $0x10,%eax
  800d1d:	09 f0                	or     %esi,%eax
  800d1f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d21:	09 d8                	or     %ebx,%eax
  800d23:	c1 e9 02             	shr    $0x2,%ecx
  800d26:	fc                   	cld    
  800d27:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d29:	eb 03                	jmp    800d2e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d2b:	fc                   	cld    
  800d2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2e:	89 f8                	mov    %edi,%eax
  800d30:	8b 1c 24             	mov    (%esp),%ebx
  800d33:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d37:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d3b:	89 ec                	mov    %ebp,%esp
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 08             	sub    $0x8,%esp
  800d45:	89 34 24             	mov    %esi,(%esp)
  800d48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800d52:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d55:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d57:	39 c6                	cmp    %eax,%esi
  800d59:	73 35                	jae    800d90 <memmove+0x51>
  800d5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d5e:	39 d0                	cmp    %edx,%eax
  800d60:	73 2e                	jae    800d90 <memmove+0x51>
		s += n;
		d += n;
  800d62:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d64:	f6 c2 03             	test   $0x3,%dl
  800d67:	75 1b                	jne    800d84 <memmove+0x45>
  800d69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d6f:	75 13                	jne    800d84 <memmove+0x45>
  800d71:	f6 c1 03             	test   $0x3,%cl
  800d74:	75 0e                	jne    800d84 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d76:	83 ef 04             	sub    $0x4,%edi
  800d79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d7c:	c1 e9 02             	shr    $0x2,%ecx
  800d7f:	fd                   	std    
  800d80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d82:	eb 09                	jmp    800d8d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d84:	83 ef 01             	sub    $0x1,%edi
  800d87:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d8a:	fd                   	std    
  800d8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d8d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d8e:	eb 20                	jmp    800db0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d90:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d96:	75 15                	jne    800dad <memmove+0x6e>
  800d98:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d9e:	75 0d                	jne    800dad <memmove+0x6e>
  800da0:	f6 c1 03             	test   $0x3,%cl
  800da3:	75 08                	jne    800dad <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800da5:	c1 e9 02             	shr    $0x2,%ecx
  800da8:	fc                   	cld    
  800da9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dab:	eb 03                	jmp    800db0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dad:	fc                   	cld    
  800dae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800db0:	8b 34 24             	mov    (%esp),%esi
  800db3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800db7:	89 ec                	mov    %ebp,%esp
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 04 24             	mov    %eax,(%esp)
  800dd5:	e8 65 ff ff ff       	call   800d3f <memmove>
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800de5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800deb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800df0:	eb 1c                	jmp    800e0e <memcmp+0x32>
		if (*s1 != *s2)
  800df2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800df6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800dfa:	83 c2 01             	add    $0x1,%edx
  800dfd:	83 e9 01             	sub    $0x1,%ecx
  800e00:	38 d8                	cmp    %bl,%al
  800e02:	74 0a                	je     800e0e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	0f b6 db             	movzbl %bl,%ebx
  800e0a:	29 d8                	sub    %ebx,%eax
  800e0c:	eb 09                	jmp    800e17 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e0e:	85 c9                	test   %ecx,%ecx
  800e10:	75 e0                	jne    800df2 <memcmp+0x16>
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e25:	89 c2                	mov    %eax,%edx
  800e27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e2a:	eb 07                	jmp    800e33 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2c:	38 08                	cmp    %cl,(%eax)
  800e2e:	74 07                	je     800e37 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e30:	83 c0 01             	add    $0x1,%eax
  800e33:	39 d0                	cmp    %edx,%eax
  800e35:	72 f5                	jb     800e2c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	83 ec 04             	sub    $0x4,%esp
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e48:	eb 03                	jmp    800e4d <strtol+0x14>
		s++;
  800e4a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4d:	0f b6 02             	movzbl (%edx),%eax
  800e50:	3c 20                	cmp    $0x20,%al
  800e52:	74 f6                	je     800e4a <strtol+0x11>
  800e54:	3c 09                	cmp    $0x9,%al
  800e56:	74 f2                	je     800e4a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e58:	3c 2b                	cmp    $0x2b,%al
  800e5a:	75 0c                	jne    800e68 <strtol+0x2f>
		s++;
  800e5c:	8d 52 01             	lea    0x1(%edx),%edx
  800e5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e66:	eb 15                	jmp    800e7d <strtol+0x44>
	else if (*s == '-')
  800e68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e6f:	3c 2d                	cmp    $0x2d,%al
  800e71:	75 0a                	jne    800e7d <strtol+0x44>
		s++, neg = 1;
  800e73:	8d 52 01             	lea    0x1(%edx),%edx
  800e76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7d:	85 db                	test   %ebx,%ebx
  800e7f:	0f 94 c0             	sete   %al
  800e82:	74 05                	je     800e89 <strtol+0x50>
  800e84:	83 fb 10             	cmp    $0x10,%ebx
  800e87:	75 15                	jne    800e9e <strtol+0x65>
  800e89:	80 3a 30             	cmpb   $0x30,(%edx)
  800e8c:	75 10                	jne    800e9e <strtol+0x65>
  800e8e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e92:	75 0a                	jne    800e9e <strtol+0x65>
		s += 2, base = 16;
  800e94:	83 c2 02             	add    $0x2,%edx
  800e97:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9c:	eb 13                	jmp    800eb1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e9e:	84 c0                	test   %al,%al
  800ea0:	74 0f                	je     800eb1 <strtol+0x78>
  800ea2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ea7:	80 3a 30             	cmpb   $0x30,(%edx)
  800eaa:	75 05                	jne    800eb1 <strtol+0x78>
		s++, base = 8;
  800eac:	83 c2 01             	add    $0x1,%edx
  800eaf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eb8:	0f b6 0a             	movzbl (%edx),%ecx
  800ebb:	89 cf                	mov    %ecx,%edi
  800ebd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ec0:	80 fb 09             	cmp    $0x9,%bl
  800ec3:	77 08                	ja     800ecd <strtol+0x94>
			dig = *s - '0';
  800ec5:	0f be c9             	movsbl %cl,%ecx
  800ec8:	83 e9 30             	sub    $0x30,%ecx
  800ecb:	eb 1e                	jmp    800eeb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800ecd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ed0:	80 fb 19             	cmp    $0x19,%bl
  800ed3:	77 08                	ja     800edd <strtol+0xa4>
			dig = *s - 'a' + 10;
  800ed5:	0f be c9             	movsbl %cl,%ecx
  800ed8:	83 e9 57             	sub    $0x57,%ecx
  800edb:	eb 0e                	jmp    800eeb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800edd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ee0:	80 fb 19             	cmp    $0x19,%bl
  800ee3:	77 15                	ja     800efa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ee5:	0f be c9             	movsbl %cl,%ecx
  800ee8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800eeb:	39 f1                	cmp    %esi,%ecx
  800eed:	7d 0b                	jge    800efa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800eef:	83 c2 01             	add    $0x1,%edx
  800ef2:	0f af c6             	imul   %esi,%eax
  800ef5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ef8:	eb be                	jmp    800eb8 <strtol+0x7f>
  800efa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800efc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f00:	74 05                	je     800f07 <strtol+0xce>
		*endptr = (char *) s;
  800f02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f07:	89 ca                	mov    %ecx,%edx
  800f09:	f7 da                	neg    %edx
  800f0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f0f:	0f 45 c2             	cmovne %edx,%eax
}
  800f12:	83 c4 04             	add    $0x4,%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
	...

00800f1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	89 1c 24             	mov    %ebx,(%esp)
  800f25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f32:	b8 01 00 00 00       	mov    $0x1,%eax
  800f37:	89 d1                	mov    %edx,%ecx
  800f39:	89 d3                	mov    %edx,%ebx
  800f3b:	89 d7                	mov    %edx,%edi
  800f3d:	89 d6                	mov    %edx,%esi
  800f3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f41:	8b 1c 24             	mov    (%esp),%ebx
  800f44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f4c:	89 ec                	mov    %ebp,%esp
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 0c             	sub    $0xc,%esp
  800f56:	89 1c 24             	mov    %ebx,(%esp)
  800f59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f61:	b8 00 00 00 00       	mov    $0x0,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	89 c3                	mov    %eax,%ebx
  800f6e:	89 c7                	mov    %eax,%edi
  800f70:	89 c6                	mov    %eax,%esi
  800f72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f74:	8b 1c 24             	mov    (%esp),%ebx
  800f77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f7f:	89 ec                	mov    %ebp,%esp
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 0c             	sub    $0xc,%esp
  800f89:	89 1c 24             	mov    %ebx,(%esp)
  800f8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	ba 00 00 00 00       	mov    $0x0,%edx
  800f99:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9e:	89 d1                	mov    %edx,%ecx
  800fa0:	89 d3                	mov    %edx,%ebx
  800fa2:	89 d7                	mov    %edx,%edi
  800fa4:	89 d6                	mov    %edx,%esi
  800fa6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa8:	8b 1c 24             	mov    (%esp),%ebx
  800fab:	8b 74 24 04          	mov    0x4(%esp),%esi
  800faf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fb3:	89 ec                	mov    %ebp,%esp
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 38             	sub    $0x38,%esp
  800fbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7e 28                	jle    801008 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800feb:	00 
  800fec:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffb:	00 
  800ffc:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  801003:	e8 6c f4 ff ff       	call   800474 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801008:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80100b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801011:	89 ec                	mov    %ebp,%esp
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 38             	sub    $0x38,%esp
  80101b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801021:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	b8 0e 00 00 00       	mov    $0xe,%eax
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7e 28                	jle    801066 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801042:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801049:	00 
  80104a:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  801061:	e8 0e f4 ff ff       	call   800474 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801066:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801069:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106f:	89 ec                	mov    %ebp,%esp
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 38             	sub    $0x38,%esp
  801079:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80107c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80107f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	b9 00 00 00 00       	mov    $0x0,%ecx
  801087:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	89 cb                	mov    %ecx,%ebx
  801091:	89 cf                	mov    %ecx,%edi
  801093:	89 ce                	mov    %ecx,%esi
  801095:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7e 28                	jle    8010c3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  8010be:	e8 b1 f3 ff ff       	call   800474 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010c3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010cc:	89 ec                	mov    %ebp,%esp
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
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
  8010e1:	be 00 00 00 00       	mov    $0x0,%esi
  8010e6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010eb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010f9:	8b 1c 24             	mov    (%esp),%ebx
  8010fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801100:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801104:	89 ec                	mov    %ebp,%esp
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    

00801108 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 38             	sub    $0x38,%esp
  80110e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801111:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801114:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801117:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801121:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801124:	8b 55 08             	mov    0x8(%ebp),%edx
  801127:	89 df                	mov    %ebx,%edi
  801129:	89 de                	mov    %ebx,%esi
  80112b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80112d:	85 c0                	test   %eax,%eax
  80112f:	7e 28                	jle    801159 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801131:	89 44 24 10          	mov    %eax,0x10(%esp)
  801135:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80113c:	00 
  80113d:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  801144:	00 
  801145:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80114c:	00 
  80114d:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  801154:	e8 1b f3 ff ff       	call   800474 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801159:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80115c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80115f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801162:	89 ec                	mov    %ebp,%esp
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 38             	sub    $0x38,%esp
  80116c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80116f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801172:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801175:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117a:	b8 09 00 00 00       	mov    $0x9,%eax
  80117f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	89 df                	mov    %ebx,%edi
  801187:	89 de                	mov    %ebx,%esi
  801189:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80118b:	85 c0                	test   %eax,%eax
  80118d:	7e 28                	jle    8011b7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801193:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80119a:	00 
  80119b:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  8011a2:	00 
  8011a3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011aa:	00 
  8011ab:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  8011b2:	e8 bd f2 ff ff       	call   800474 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c0:	89 ec                	mov    %ebp,%esp
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 38             	sub    $0x38,%esp
  8011ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8011dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e3:	89 df                	mov    %ebx,%edi
  8011e5:	89 de                	mov    %ebx,%esi
  8011e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	7e 28                	jle    801215 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011f8:	00 
  8011f9:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  801200:	00 
  801201:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801208:	00 
  801209:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  801210:	e8 5f f2 ff ff       	call   800474 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801215:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801218:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80121b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80121e:	89 ec                	mov    %ebp,%esp
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 38             	sub    $0x38,%esp
  801228:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80122b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80122e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801231:	bb 00 00 00 00       	mov    $0x0,%ebx
  801236:	b8 06 00 00 00       	mov    $0x6,%eax
  80123b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	89 df                	mov    %ebx,%edi
  801243:	89 de                	mov    %ebx,%esi
  801245:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801247:	85 c0                	test   %eax,%eax
  801249:	7e 28                	jle    801273 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80124f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801256:	00 
  801257:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  80125e:	00 
  80125f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801266:	00 
  801267:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  80126e:	e8 01 f2 ff ff       	call   800474 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801273:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801276:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801279:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127c:	89 ec                	mov    %ebp,%esp
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 38             	sub    $0x38,%esp
  801286:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801289:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80128c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128f:	b8 05 00 00 00       	mov    $0x5,%eax
  801294:	8b 75 18             	mov    0x18(%ebp),%esi
  801297:	8b 7d 14             	mov    0x14(%ebp),%edi
  80129a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80129d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	7e 28                	jle    8012d1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  8012bc:	00 
  8012bd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c4:	00 
  8012c5:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  8012cc:	e8 a3 f1 ff ff       	call   800474 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012d4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012da:	89 ec                	mov    %ebp,%esp
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 38             	sub    $0x38,%esp
  8012e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ed:	be 00 00 00 00       	mov    $0x0,%esi
  8012f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8012f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801300:	89 f7                	mov    %esi,%edi
  801302:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801304:	85 c0                	test   %eax,%eax
  801306:	7e 28                	jle    801330 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801308:	89 44 24 10          	mov    %eax,0x10(%esp)
  80130c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801313:	00 
  801314:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  80131b:	00 
  80131c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801323:	00 
  801324:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  80132b:	e8 44 f1 ff ff       	call   800474 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801330:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801333:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801336:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801339:	89 ec                	mov    %ebp,%esp
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    

0080133d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	89 1c 24             	mov    %ebx,(%esp)
  801346:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134e:	ba 00 00 00 00       	mov    $0x0,%edx
  801353:	b8 0b 00 00 00       	mov    $0xb,%eax
  801358:	89 d1                	mov    %edx,%ecx
  80135a:	89 d3                	mov    %edx,%ebx
  80135c:	89 d7                	mov    %edx,%edi
  80135e:	89 d6                	mov    %edx,%esi
  801360:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801362:	8b 1c 24             	mov    (%esp),%ebx
  801365:	8b 74 24 04          	mov    0x4(%esp),%esi
  801369:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80136d:	89 ec                	mov    %ebp,%esp
  80136f:	5d                   	pop    %ebp
  801370:	c3                   	ret    

00801371 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 0c             	sub    $0xc,%esp
  801377:	89 1c 24             	mov    %ebx,(%esp)
  80137a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80137e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801382:	ba 00 00 00 00       	mov    $0x0,%edx
  801387:	b8 02 00 00 00       	mov    $0x2,%eax
  80138c:	89 d1                	mov    %edx,%ecx
  80138e:	89 d3                	mov    %edx,%ebx
  801390:	89 d7                	mov    %edx,%edi
  801392:	89 d6                	mov    %edx,%esi
  801394:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801396:	8b 1c 24             	mov    (%esp),%ebx
  801399:	8b 74 24 04          	mov    0x4(%esp),%esi
  80139d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013a1:	89 ec                	mov    %ebp,%esp
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 38             	sub    $0x38,%esp
  8013ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8013be:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c1:	89 cb                	mov    %ecx,%ebx
  8013c3:	89 cf                	mov    %ecx,%edi
  8013c5:	89 ce                	mov    %ecx,%esi
  8013c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	7e 28                	jle    8013f5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013d1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013d8:	00 
  8013d9:	c7 44 24 08 87 23 80 	movl   $0x802387,0x8(%esp)
  8013e0:	00 
  8013e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013e8:	00 
  8013e9:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  8013f0:	e8 7f f0 ff ff       	call   800474 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013fe:	89 ec                	mov    %ebp,%esp
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    
	...

00801404 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80140a:	c7 44 24 08 b2 23 80 	movl   $0x8023b2,0x8(%esp)
  801411:	00 
  801412:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801419:	00 
  80141a:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  801421:	e8 4e f0 ff ff       	call   800474 <_panic>

00801426 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	57                   	push   %edi
  80142a:	56                   	push   %esi
  80142b:	53                   	push   %ebx
  80142c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  80142f:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  801436:	e8 71 07 00 00       	call   801bac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80143b:	ba 07 00 00 00       	mov    $0x7,%edx
  801440:	89 d0                	mov    %edx,%eax
  801442:	cd 30                	int    $0x30
  801444:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801447:	85 c0                	test   %eax,%eax
  801449:	79 20                	jns    80146b <fork+0x45>
		panic("sys_exofork: %e", envid);
  80144b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144f:	c7 44 24 08 d3 23 80 	movl   $0x8023d3,0x8(%esp)
  801456:	00 
  801457:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80145e:	00 
  80145f:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  801466:	e8 09 f0 ff ff       	call   800474 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  80146b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801472:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801477:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80147b:	75 21                	jne    80149e <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  80147d:	e8 ef fe ff ff       	call   801371 <sys_getenvid>
  801482:	25 ff 03 00 00       	and    $0x3ff,%eax
  801487:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80148a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80148f:	a3 08 40 80 00       	mov    %eax,0x804008
  801494:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801499:	e9 e5 01 00 00       	jmp    801683 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  80149e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014a1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8014a8:	a8 01                	test   $0x1,%al
  8014aa:	0f 84 4c 01 00 00    	je     8015fc <fork+0x1d6>
  8014b0:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  8014b6:	0f 84 cf 01 00 00    	je     80168b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  8014bc:	c1 e2 16             	shl    $0x16,%edx
  8014bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  8014c2:	89 d3                	mov    %edx,%ebx
  8014c4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014cb:	00 
  8014cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014d3:	89 04 24             	mov    %eax,(%esp)
  8014d6:	e8 03 fe ff ff       	call   8012de <sys_page_alloc>
			if(ret < 0) return ret;
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	0f 88 a0 01 00 00    	js     801683 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  8014e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8014ea:	89 14 24             	mov    %edx,(%esp)
  8014ed:	e8 30 fd ff ff       	call   801222 <sys_page_unmap>
			if(ret < 0) return ret;
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 88 89 01 00 00    	js     801683 <fork+0x25d>
  8014fa:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  8014ff:	89 de                	mov    %ebx,%esi
  801501:	c1 e6 0c             	shl    $0xc,%esi
  801504:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801507:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  80150d:	0f 84 da 00 00 00    	je     8015ed <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801513:	c1 ee 0c             	shr    $0xc,%esi
  801516:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801519:	a8 01                	test   $0x1,%al
  80151b:	0f 84 cc 00 00 00    	je     8015ed <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801521:	89 f0                	mov    %esi,%eax
  801523:	c1 e0 0c             	shl    $0xc,%eax
  801526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801529:	e8 43 fe ff ff       	call   801371 <sys_getenvid>
  80152e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801531:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801534:	89 c6                	mov    %eax,%esi
  801536:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  80153c:	25 01 04 00 00       	and    $0x401,%eax
  801541:	3d 01 04 00 00       	cmp    $0x401,%eax
  801546:	75 3a                	jne    801582 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801548:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80154f:	00 
  801550:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801553:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80155a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80155e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801562:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801565:	89 14 24             	mov    %edx,(%esp)
  801568:	e8 13 fd ff ff       	call   801280 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  80156d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801570:	89 44 24 04          	mov    %eax,0x4(%esp)
  801574:	c7 04 24 e3 23 80 00 	movl   $0x8023e3,(%esp)
  80157b:	e8 ad ef ff ff       	call   80052d <cprintf>
  801580:	eb 6b                	jmp    8015ed <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801582:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801588:	74 14                	je     80159e <fork+0x178>
  80158a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801590:	74 0c                	je     80159e <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801592:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801598:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  80159e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015a1:	89 74 24 10          	mov    %esi,0x10(%esp)
  8015a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015b7:	89 14 24             	mov    %edx,(%esp)
  8015ba:	e8 c1 fc ff ff       	call   801280 <sys_page_map>
	if(ret<0) return ret;
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	0f 88 bc 00 00 00    	js     801683 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  8015c7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8015cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015d5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015dd:	89 14 24             	mov    %edx,(%esp)
  8015e0:	e8 9b fc ff ff       	call   801280 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	0f 88 96 00 00 00    	js     801683 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  8015ed:	83 c3 01             	add    $0x1,%ebx
  8015f0:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8015f6:	0f 85 03 ff ff ff    	jne    8014ff <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  8015fc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801600:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801607:	0f 85 91 fe ff ff    	jne    80149e <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  80160d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801614:	00 
  801615:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80161c:	ee 
  80161d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801620:	89 04 24             	mov    %eax,(%esp)
  801623:	e8 b6 fc ff ff       	call   8012de <sys_page_alloc>
	if(ret < 0) return ret;
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 57                	js     801683 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  80162c:	a1 08 40 80 00       	mov    0x804008,%eax
  801631:	8b 40 64             	mov    0x64(%eax),%eax
  801634:	89 44 24 04          	mov    %eax,0x4(%esp)
  801638:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80163b:	89 14 24             	mov    %edx,(%esp)
  80163e:	e8 c5 fa ff ff       	call   801108 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801643:	85 c0                	test   %eax,%eax
  801645:	78 3c                	js     801683 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801647:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80164e:	00 
  80164f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801652:	89 04 24             	mov    %eax,(%esp)
  801655:	e8 6a fb ff ff       	call   8011c4 <sys_env_set_status>
  80165a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  80165c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80165f:	85 d2                	test   %edx,%edx
  801661:	79 20                	jns    801683 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801663:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801667:	c7 44 24 08 fa 23 80 	movl   $0x8023fa,0x8(%esp)
  80166e:	00 
  80166f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801676:	00 
  801677:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  80167e:	e8 f1 ed ff ff       	call   800474 <_panic>

	return envid;
}
  801683:	83 c4 4c             	add    $0x4c,%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5f                   	pop    %edi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  80168b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  80168f:	e9 0a fe ff ff       	jmp    80149e <fork+0x78>

00801694 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
  801699:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  80169c:	e8 d0 fc ff ff       	call   801371 <sys_getenvid>
  8016a1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8b 00                	mov    (%eax),%eax
  8016a8:	89 c6                	mov    %eax,%esi
  8016aa:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  8016ad:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8016b4:	f6 c2 02             	test   $0x2,%dl
  8016b7:	75 2c                	jne    8016e5 <pgfault+0x51>
  8016b9:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  8016c0:	f6 c6 08             	test   $0x8,%dh
  8016c3:	75 20                	jne    8016e5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  8016c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016c9:	c7 44 24 08 48 24 80 	movl   $0x802448,0x8(%esp)
  8016d0:	00 
  8016d1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8016d8:	00 
  8016d9:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  8016e0:	e8 8f ed ff ff       	call   800474 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8016e5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016ec:	00 
  8016ed:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8016f4:	00 
  8016f5:	89 1c 24             	mov    %ebx,(%esp)
  8016f8:	e8 e1 fb ff ff       	call   8012de <sys_page_alloc>
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	79 20                	jns    801721 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801701:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801705:	c7 44 24 08 11 24 80 	movl   $0x802411,0x8(%esp)
  80170c:	00 
  80170d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801714:	00 
  801715:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  80171c:	e8 53 ed ff ff       	call   800474 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801721:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801724:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80172b:	00 
  80172c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801730:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801737:	e8 03 f6 ff ff       	call   800d3f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80173c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801743:	00 
  801744:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801748:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80174c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801753:	00 
  801754:	89 1c 24             	mov    %ebx,(%esp)
  801757:	e8 24 fb ff ff       	call   801280 <sys_page_map>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	79 20                	jns    801780 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801760:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801764:	c7 44 24 08 23 24 80 	movl   $0x802423,0x8(%esp)
  80176b:	00 
  80176c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801773:	00 
  801774:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  80177b:	e8 f4 ec ff ff       	call   800474 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801780:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801787:	00 
  801788:	89 1c 24             	mov    %ebx,(%esp)
  80178b:	e8 92 fa ff ff       	call   801222 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801790:	85 c0                	test   %eax,%eax
  801792:	74 20                	je     8017b4 <pgfault+0x120>
  801794:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801798:	c7 44 24 08 33 24 80 	movl   $0x802433,0x8(%esp)
  80179f:	00 
  8017a0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8017a7:	00 
  8017a8:	c7 04 24 c8 23 80 00 	movl   $0x8023c8,(%esp)
  8017af:	e8 c0 ec ff ff       	call   800474 <_panic>

}
  8017b4:	83 c4 20             	add    $0x20,%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5d                   	pop    %ebp
  8017ba:	c3                   	ret    
	...

008017bc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8017c7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8017ca:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8017d0:	8b 12                	mov    (%edx),%edx
  8017d2:	39 ca                	cmp    %ecx,%edx
  8017d4:	75 0c                	jne    8017e2 <ipc_find_env+0x26>
			return envs[i].env_id;
  8017d6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8017d9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8017de:	8b 00                	mov    (%eax),%eax
  8017e0:	eb 0e                	jmp    8017f0 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8017e2:	83 c0 01             	add    $0x1,%eax
  8017e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017ea:	75 db                	jne    8017c7 <ipc_find_env+0xb>
  8017ec:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    

008017f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	57                   	push   %edi
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 2c             	sub    $0x2c,%esp
  8017fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8017fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801801:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  801804:	85 db                	test   %ebx,%ebx
  801806:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80180b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  80180e:	8b 45 14             	mov    0x14(%ebp),%eax
  801811:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801815:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801819:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80181d:	89 34 24             	mov    %esi,(%esp)
  801820:	e8 ab f8 ff ff       	call   8010d0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  801825:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801828:	74 e4                	je     80180e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80182a:	85 c0                	test   %eax,%eax
  80182c:	74 28                	je     801856 <ipc_send+0x64>
  80182e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801832:	c7 44 24 0c 89 24 80 	movl   $0x802489,0xc(%esp)
  801839:	00 
  80183a:	c7 44 24 08 6c 24 80 	movl   $0x80246c,0x8(%esp)
  801841:	00 
  801842:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801849:	00 
  80184a:	c7 04 24 7f 24 80 00 	movl   $0x80247f,(%esp)
  801851:	e8 1e ec ff ff       	call   800474 <_panic>
	//if(!ret) sys_yield();
}
  801856:	83 c4 2c             	add    $0x2c,%esp
  801859:	5b                   	pop    %ebx
  80185a:	5e                   	pop    %esi
  80185b:	5f                   	pop    %edi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 28             	sub    $0x28,%esp
  801864:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801867:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80186a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80186d:	8b 75 08             	mov    0x8(%ebp),%esi
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  801876:	85 c0                	test   %eax,%eax
  801878:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80187d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801880:	89 04 24             	mov    %eax,(%esp)
  801883:	e8 eb f7 ff ff       	call   801073 <sys_ipc_recv>
  801888:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80188a:	e8 e2 fa ff ff       	call   801371 <sys_getenvid>
  80188f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801894:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801897:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80189c:	a3 08 40 80 00       	mov    %eax,0x804008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  8018a1:	85 f6                	test   %esi,%esi
  8018a3:	74 0e                	je     8018b3 <ipc_recv+0x55>
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	85 db                	test   %ebx,%ebx
  8018ac:	75 03                	jne    8018b1 <ipc_recv+0x53>
  8018ae:	8b 50 74             	mov    0x74(%eax),%edx
  8018b1:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  8018b3:	85 ff                	test   %edi,%edi
  8018b5:	74 13                	je     8018ca <ipc_recv+0x6c>
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	85 db                	test   %ebx,%ebx
  8018be:	75 08                	jne    8018c8 <ipc_recv+0x6a>
  8018c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8018c5:	8b 40 78             	mov    0x78(%eax),%eax
  8018c8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8018ca:	85 db                	test   %ebx,%ebx
  8018cc:	75 08                	jne    8018d6 <ipc_recv+0x78>
  8018ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8018d3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8018d6:	89 d8                	mov    %ebx,%eax
  8018d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018db:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018de:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018e1:	89 ec                	mov    %ebp,%esp
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    
  8018e5:	00 00                	add    %al,(%eax)
	...

008018e8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 14             	sub    $0x14,%esp
  8018ef:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018f1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8018f8:	75 11                	jne    80190b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801901:	e8 b6 fe ff ff       	call   8017bc <ipc_find_env>
  801906:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80190b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801912:	00 
  801913:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80191a:	00 
  80191b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80191f:	a1 04 40 80 00       	mov    0x804004,%eax
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 c6 fe ff ff       	call   8017f2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80192c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801933:	00 
  801934:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80193b:	00 
  80193c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801943:	e8 16 ff ff ff       	call   80185e <ipc_recv>
}
  801948:	83 c4 14             	add    $0x14,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80195c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80196c:	b8 09 00 00 00       	mov    $0x9,%eax
  801971:	e8 72 ff ff ff       	call   8018e8 <nsipc>
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801986:	8b 45 0c             	mov    0xc(%ebp),%eax
  801989:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80198e:	b8 06 00 00 00       	mov    $0x6,%eax
  801993:	e8 50 ff ff ff       	call   8018e8 <nsipc>
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8019a8:	b8 04 00 00 00       	mov    $0x4,%eax
  8019ad:	e8 36 ff ff ff       	call   8018e8 <nsipc>
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8019c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8019ca:	b8 03 00 00 00       	mov    $0x3,%eax
  8019cf:	e8 14 ff ff ff       	call   8018e8 <nsipc>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 14             	sub    $0x14,%esp
  8019dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8019e8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8019ee:	7e 24                	jle    801a14 <nsipc_send+0x3e>
  8019f0:	c7 44 24 0c 92 24 80 	movl   $0x802492,0xc(%esp)
  8019f7:	00 
  8019f8:	c7 44 24 08 9e 24 80 	movl   $0x80249e,0x8(%esp)
  8019ff:	00 
  801a00:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  801a07:	00 
  801a08:	c7 04 24 b3 24 80 00 	movl   $0x8024b3,(%esp)
  801a0f:	e8 60 ea ff ff       	call   800474 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a14:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1f:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801a26:	e8 14 f3 ff ff       	call   800d3f <memmove>
	nsipcbuf.send.req_size = size;
  801a2b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801a31:	8b 45 14             	mov    0x14(%ebp),%eax
  801a34:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801a39:	b8 08 00 00 00       	mov    $0x8,%eax
  801a3e:	e8 a5 fe ff ff       	call   8018e8 <nsipc>
}
  801a43:	83 c4 14             	add    $0x14,%esp
  801a46:	5b                   	pop    %ebx
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
  801a4e:	83 ec 10             	sub    $0x10,%esp
  801a51:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a5c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a62:	8b 45 14             	mov    0x14(%ebp),%eax
  801a65:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a6a:	b8 07 00 00 00       	mov    $0x7,%eax
  801a6f:	e8 74 fe ff ff       	call   8018e8 <nsipc>
  801a74:	89 c3                	mov    %eax,%ebx
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 46                	js     801ac0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801a7a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801a7f:	7f 04                	jg     801a85 <nsipc_recv+0x3c>
  801a81:	39 c6                	cmp    %eax,%esi
  801a83:	7d 24                	jge    801aa9 <nsipc_recv+0x60>
  801a85:	c7 44 24 0c bf 24 80 	movl   $0x8024bf,0xc(%esp)
  801a8c:	00 
  801a8d:	c7 44 24 08 9e 24 80 	movl   $0x80249e,0x8(%esp)
  801a94:	00 
  801a95:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  801a9c:	00 
  801a9d:	c7 04 24 b3 24 80 00 	movl   $0x8024b3,(%esp)
  801aa4:	e8 cb e9 ff ff       	call   800474 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801aa9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aad:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ab4:	00 
  801ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab8:	89 04 24             	mov    %eax,(%esp)
  801abb:	e8 7f f2 ff ff       	call   800d3f <memmove>
	}

	return r;
}
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	53                   	push   %ebx
  801acd:	83 ec 14             	sub    $0x14,%esp
  801ad0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801adb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae6:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801aed:	e8 4d f2 ff ff       	call   800d3f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801af2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801af8:	b8 05 00 00 00       	mov    $0x5,%eax
  801afd:	e8 e6 fd ff ff       	call   8018e8 <nsipc>
}
  801b02:	83 c4 14             	add    $0x14,%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    

00801b08 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 14             	sub    $0x14,%esp
  801b0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b25:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b2c:	e8 0e f2 ff ff       	call   800d3f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b31:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b37:	b8 02 00 00 00       	mov    $0x2,%eax
  801b3c:	e8 a7 fd ff ff       	call   8018e8 <nsipc>
}
  801b41:	83 c4 14             	add    $0x14,%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    

00801b47 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 28             	sub    $0x28,%esp
  801b4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b53:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b56:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b61:	8b 07                	mov    (%edi),%eax
  801b63:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b68:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6d:	e8 76 fd ff ff       	call   8018e8 <nsipc>
  801b72:	89 c6                	mov    %eax,%esi
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 22                	js     801b9a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b78:	bb 10 60 80 00       	mov    $0x806010,%ebx
  801b7d:	8b 03                	mov    (%ebx),%eax
  801b7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b83:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b8a:	00 
  801b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 a9 f1 ff ff       	call   800d3f <memmove>
		*addrlen = ret->ret_addrlen;
  801b96:	8b 03                	mov    (%ebx),%eax
  801b98:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  801b9a:	89 f0                	mov    %esi,%eax
  801b9c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b9f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ba2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ba5:	89 ec                	mov    %ebp,%esp
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    
  801ba9:	00 00                	add    %al,(%eax)
	...

00801bac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  801bb3:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  801bba:	75 5b                	jne    801c17 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  801bbc:	e8 b0 f7 ff ff       	call   801371 <sys_getenvid>
  801bc1:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  801bc3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bca:	00 
  801bcb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801bd2:	ee 
  801bd3:	89 04 24             	mov    %eax,(%esp)
  801bd6:	e8 03 f7 ff ff       	call   8012de <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	74 28                	je     801c07 <set_pgfault_handler+0x5b>
  801bdf:	89 44 24 10          	mov    %eax,0x10(%esp)
  801be3:	c7 44 24 0c fb 24 80 	movl   $0x8024fb,0xc(%esp)
  801bea:	00 
  801beb:	c7 44 24 08 d4 24 80 	movl   $0x8024d4,0x8(%esp)
  801bf2:	00 
  801bf3:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801bfa:	00 
  801bfb:	c7 04 24 ed 24 80 00 	movl   $0x8024ed,(%esp)
  801c02:	e8 6d e8 ff ff       	call   800474 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  801c07:	c7 44 24 04 28 1c 80 	movl   $0x801c28,0x4(%esp)
  801c0e:	00 
  801c0f:	89 1c 24             	mov    %ebx,(%esp)
  801c12:	e8 f1 f4 ff ff       	call   801108 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	a3 00 70 80 00       	mov    %eax,0x807000
	
}
  801c1f:	83 c4 24             	add    $0x24,%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
  801c25:	00 00                	add    %al,(%eax)
	...

00801c28 <_pgfault_upcall>:
  801c28:	54                   	push   %esp
  801c29:	a1 00 70 80 00       	mov    0x807000,%eax
  801c2e:	ff d0                	call   *%eax
  801c30:	83 c4 04             	add    $0x4,%esp
  801c33:	83 c4 08             	add    $0x8,%esp
  801c36:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  801c3a:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801c3e:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  801c41:	83 e9 04             	sub    $0x4,%ecx
  801c44:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  801c48:	61                   	popa   
  801c49:	83 c4 04             	add    $0x4,%esp
  801c4c:	9d                   	popf   
  801c4d:	5c                   	pop    %esp
  801c4e:	c3                   	ret    
	...

00801c50 <__udivdi3>:
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	57                   	push   %edi
  801c54:	56                   	push   %esi
  801c55:	83 ec 10             	sub    $0x10,%esp
  801c58:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c5e:	8b 75 10             	mov    0x10(%ebp),%esi
  801c61:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c64:	85 c0                	test   %eax,%eax
  801c66:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801c69:	75 35                	jne    801ca0 <__udivdi3+0x50>
  801c6b:	39 fe                	cmp    %edi,%esi
  801c6d:	77 61                	ja     801cd0 <__udivdi3+0x80>
  801c6f:	85 f6                	test   %esi,%esi
  801c71:	75 0b                	jne    801c7e <__udivdi3+0x2e>
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
  801c78:	31 d2                	xor    %edx,%edx
  801c7a:	f7 f6                	div    %esi
  801c7c:	89 c6                	mov    %eax,%esi
  801c7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c81:	31 d2                	xor    %edx,%edx
  801c83:	89 f8                	mov    %edi,%eax
  801c85:	f7 f6                	div    %esi
  801c87:	89 c7                	mov    %eax,%edi
  801c89:	89 c8                	mov    %ecx,%eax
  801c8b:	f7 f6                	div    %esi
  801c8d:	89 c1                	mov    %eax,%ecx
  801c8f:	89 fa                	mov    %edi,%edx
  801c91:	89 c8                	mov    %ecx,%eax
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
  801c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ca0:	39 f8                	cmp    %edi,%eax
  801ca2:	77 1c                	ja     801cc0 <__udivdi3+0x70>
  801ca4:	0f bd d0             	bsr    %eax,%edx
  801ca7:	83 f2 1f             	xor    $0x1f,%edx
  801caa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801cad:	75 39                	jne    801ce8 <__udivdi3+0x98>
  801caf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  801cb2:	0f 86 a0 00 00 00    	jbe    801d58 <__udivdi3+0x108>
  801cb8:	39 f8                	cmp    %edi,%eax
  801cba:	0f 82 98 00 00 00    	jb     801d58 <__udivdi3+0x108>
  801cc0:	31 ff                	xor    %edi,%edi
  801cc2:	31 c9                	xor    %ecx,%ecx
  801cc4:	89 c8                	mov    %ecx,%eax
  801cc6:	89 fa                	mov    %edi,%edx
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	5e                   	pop    %esi
  801ccc:	5f                   	pop    %edi
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    
  801ccf:	90                   	nop
  801cd0:	89 d1                	mov    %edx,%ecx
  801cd2:	89 fa                	mov    %edi,%edx
  801cd4:	89 c8                	mov    %ecx,%eax
  801cd6:	31 ff                	xor    %edi,%edi
  801cd8:	f7 f6                	div    %esi
  801cda:	89 c1                	mov    %eax,%ecx
  801cdc:	89 fa                	mov    %edi,%edx
  801cde:	89 c8                	mov    %ecx,%eax
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	5e                   	pop    %esi
  801ce4:	5f                   	pop    %edi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    
  801ce7:	90                   	nop
  801ce8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801cec:	89 f2                	mov    %esi,%edx
  801cee:	d3 e0                	shl    %cl,%eax
  801cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cf3:	b8 20 00 00 00       	mov    $0x20,%eax
  801cf8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801cfb:	89 c1                	mov    %eax,%ecx
  801cfd:	d3 ea                	shr    %cl,%edx
  801cff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801d03:	0b 55 ec             	or     -0x14(%ebp),%edx
  801d06:	d3 e6                	shl    %cl,%esi
  801d08:	89 c1                	mov    %eax,%ecx
  801d0a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  801d0d:	89 fe                	mov    %edi,%esi
  801d0f:	d3 ee                	shr    %cl,%esi
  801d11:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801d15:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1b:	d3 e7                	shl    %cl,%edi
  801d1d:	89 c1                	mov    %eax,%ecx
  801d1f:	d3 ea                	shr    %cl,%edx
  801d21:	09 d7                	or     %edx,%edi
  801d23:	89 f2                	mov    %esi,%edx
  801d25:	89 f8                	mov    %edi,%eax
  801d27:	f7 75 ec             	divl   -0x14(%ebp)
  801d2a:	89 d6                	mov    %edx,%esi
  801d2c:	89 c7                	mov    %eax,%edi
  801d2e:	f7 65 e8             	mull   -0x18(%ebp)
  801d31:	39 d6                	cmp    %edx,%esi
  801d33:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801d36:	72 30                	jb     801d68 <__udivdi3+0x118>
  801d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d3b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  801d3f:	d3 e2                	shl    %cl,%edx
  801d41:	39 c2                	cmp    %eax,%edx
  801d43:	73 05                	jae    801d4a <__udivdi3+0xfa>
  801d45:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  801d48:	74 1e                	je     801d68 <__udivdi3+0x118>
  801d4a:	89 f9                	mov    %edi,%ecx
  801d4c:	31 ff                	xor    %edi,%edi
  801d4e:	e9 71 ff ff ff       	jmp    801cc4 <__udivdi3+0x74>
  801d53:	90                   	nop
  801d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d58:	31 ff                	xor    %edi,%edi
  801d5a:	b9 01 00 00 00       	mov    $0x1,%ecx
  801d5f:	e9 60 ff ff ff       	jmp    801cc4 <__udivdi3+0x74>
  801d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d68:	8d 4f ff             	lea    -0x1(%edi),%ecx
  801d6b:	31 ff                	xor    %edi,%edi
  801d6d:	89 c8                	mov    %ecx,%eax
  801d6f:	89 fa                	mov    %edi,%edx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	5e                   	pop    %esi
  801d75:	5f                   	pop    %edi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
	...

00801d80 <__umoddi3>:
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	57                   	push   %edi
  801d84:	56                   	push   %esi
  801d85:	83 ec 20             	sub    $0x20,%esp
  801d88:	8b 55 14             	mov    0x14(%ebp),%edx
  801d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d91:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d94:	85 d2                	test   %edx,%edx
  801d96:	89 c8                	mov    %ecx,%eax
  801d98:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801d9b:	75 13                	jne    801db0 <__umoddi3+0x30>
  801d9d:	39 f7                	cmp    %esi,%edi
  801d9f:	76 3f                	jbe    801de0 <__umoddi3+0x60>
  801da1:	89 f2                	mov    %esi,%edx
  801da3:	f7 f7                	div    %edi
  801da5:	89 d0                	mov    %edx,%eax
  801da7:	31 d2                	xor    %edx,%edx
  801da9:	83 c4 20             	add    $0x20,%esp
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    
  801db0:	39 f2                	cmp    %esi,%edx
  801db2:	77 4c                	ja     801e00 <__umoddi3+0x80>
  801db4:	0f bd ca             	bsr    %edx,%ecx
  801db7:	83 f1 1f             	xor    $0x1f,%ecx
  801dba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801dbd:	75 51                	jne    801e10 <__umoddi3+0x90>
  801dbf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  801dc2:	0f 87 e0 00 00 00    	ja     801ea8 <__umoddi3+0x128>
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	29 f8                	sub    %edi,%eax
  801dcd:	19 d6                	sbb    %edx,%esi
  801dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	89 f2                	mov    %esi,%edx
  801dd7:	83 c4 20             	add    $0x20,%esp
  801dda:	5e                   	pop    %esi
  801ddb:	5f                   	pop    %edi
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    
  801dde:	66 90                	xchg   %ax,%ax
  801de0:	85 ff                	test   %edi,%edi
  801de2:	75 0b                	jne    801def <__umoddi3+0x6f>
  801de4:	b8 01 00 00 00       	mov    $0x1,%eax
  801de9:	31 d2                	xor    %edx,%edx
  801deb:	f7 f7                	div    %edi
  801ded:	89 c7                	mov    %eax,%edi
  801def:	89 f0                	mov    %esi,%eax
  801df1:	31 d2                	xor    %edx,%edx
  801df3:	f7 f7                	div    %edi
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	f7 f7                	div    %edi
  801dfa:	eb a9                	jmp    801da5 <__umoddi3+0x25>
  801dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e00:	89 c8                	mov    %ecx,%eax
  801e02:	89 f2                	mov    %esi,%edx
  801e04:	83 c4 20             	add    $0x20,%esp
  801e07:	5e                   	pop    %esi
  801e08:	5f                   	pop    %edi
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    
  801e0b:	90                   	nop
  801e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e10:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801e14:	d3 e2                	shl    %cl,%edx
  801e16:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801e19:	ba 20 00 00 00       	mov    $0x20,%edx
  801e1e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  801e21:	89 55 ec             	mov    %edx,-0x14(%ebp)
  801e24:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801e28:	89 fa                	mov    %edi,%edx
  801e2a:	d3 ea                	shr    %cl,%edx
  801e2c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801e30:	0b 55 f4             	or     -0xc(%ebp),%edx
  801e33:	d3 e7                	shl    %cl,%edi
  801e35:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801e3c:	89 f2                	mov    %esi,%edx
  801e3e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  801e41:	89 c7                	mov    %eax,%edi
  801e43:	d3 ea                	shr    %cl,%edx
  801e45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801e49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801e4c:	89 c2                	mov    %eax,%edx
  801e4e:	d3 e6                	shl    %cl,%esi
  801e50:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801e54:	d3 ea                	shr    %cl,%edx
  801e56:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801e5a:	09 d6                	or     %edx,%esi
  801e5c:	89 f0                	mov    %esi,%eax
  801e5e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801e61:	d3 e7                	shl    %cl,%edi
  801e63:	89 f2                	mov    %esi,%edx
  801e65:	f7 75 f4             	divl   -0xc(%ebp)
  801e68:	89 d6                	mov    %edx,%esi
  801e6a:	f7 65 e8             	mull   -0x18(%ebp)
  801e6d:	39 d6                	cmp    %edx,%esi
  801e6f:	72 2b                	jb     801e9c <__umoddi3+0x11c>
  801e71:	39 c7                	cmp    %eax,%edi
  801e73:	72 23                	jb     801e98 <__umoddi3+0x118>
  801e75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801e79:	29 c7                	sub    %eax,%edi
  801e7b:	19 d6                	sbb    %edx,%esi
  801e7d:	89 f0                	mov    %esi,%eax
  801e7f:	89 f2                	mov    %esi,%edx
  801e81:	d3 ef                	shr    %cl,%edi
  801e83:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  801e87:	d3 e0                	shl    %cl,%eax
  801e89:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  801e8d:	09 f8                	or     %edi,%eax
  801e8f:	d3 ea                	shr    %cl,%edx
  801e91:	83 c4 20             	add    $0x20,%esp
  801e94:	5e                   	pop    %esi
  801e95:	5f                   	pop    %edi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    
  801e98:	39 d6                	cmp    %edx,%esi
  801e9a:	75 d9                	jne    801e75 <__umoddi3+0xf5>
  801e9c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  801e9f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  801ea2:	eb d1                	jmp    801e75 <__umoddi3+0xf5>
  801ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ea8:	39 f2                	cmp    %esi,%edx
  801eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801eb0:	0f 82 12 ff ff ff    	jb     801dc8 <__umoddi3+0x48>
  801eb6:	e9 17 ff ff ff       	jmp    801dd2 <__umoddi3+0x52>
