
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 ef 09 00 00       	call   800a20 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec ac 00 00 00    	sub    $0xac,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 30 19 00 00       	call   801981 <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800053:	c7 05 00 30 80 00 e0 	movl   $0x8024e0,0x803000
  80005a:	24 80 00 

	output_envid = fork();
  80005d:	e8 d4 19 00 00       	call   801a36 <fork>
  800062:	a3 00 40 80 00       	mov    %eax,0x804000
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 ea 24 80 	movl   $0x8024ea,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 f8 24 80 00 	movl   $0x8024f8,(%esp)
  800082:	e8 fd 09 00 00       	call   800a84 <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 a5 05 00 00       	call   800638 <output>
		return;
  800093:	e9 c4 03 00 00       	jmp    80045c <umain+0x41c>
	}

	input_envid = fork();
  800098:	e8 99 19 00 00       	call   801a36 <fork>
  80009d:	a3 04 40 80 00       	mov    %eax,0x804004
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 ea 24 80 	movl   $0x8024ea,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 f8 24 80 00 	movl   $0x8024f8,(%esp)
  8000bd:	e8 c2 09 00 00       	call   800a84 <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 72 04 00 00       	call   800540 <input>
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 87 03 00 00       	jmp    80045c <umain+0x41c>
		return;
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 08 25 80 00 	movl   $0x802508,(%esp)
  8000dc:	e8 5c 0a 00 00       	call   800b3d <cprintf>
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000e1:	c6 45 90 52          	movb   $0x52,-0x70(%ebp)
  8000e5:	c6 45 91 54          	movb   $0x54,-0x6f(%ebp)
  8000e9:	c6 45 92 00          	movb   $0x0,-0x6e(%ebp)
  8000ed:	c6 45 93 12          	movb   $0x12,-0x6d(%ebp)
  8000f1:	c6 45 94 34          	movb   $0x34,-0x6c(%ebp)
  8000f5:	c6 45 95 56          	movb   $0x56,-0x6b(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 25 25 80 00 	movl   $0x802525,(%esp)
  800100:	e8 e2 08 00 00       	call   8009e7 <inet_addr>
  800105:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 2f 25 80 00 	movl   $0x80252f,(%esp)
  80010f:	e8 d3 08 00 00       	call   8009e7 <inet_addr>
  800114:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 bb 17 00 00       	call   8018ee <sys_page_alloc>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 38 25 80 	movl   $0x802538,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 f8 24 80 00 	movl   $0x8024f8,(%esp)
  800152:	e8 2d 09 00 00       	call   800a84 <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  800157:	bb 04 b0 fe 0f       	mov    $0xffeb004,%ebx
	pkt->jp_len = sizeof(*arp);
  80015c:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  800163:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800166:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80016d:	00 
  80016e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800175:	00 
  800176:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  80017d:	e8 6e 11 00 00       	call   8012f0 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800182:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800189:	00 
  80018a:	8d 75 90             	lea    -0x70(%ebp),%esi
  80018d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800191:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800198:	e8 2e 12 00 00       	call   8013cb <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80019d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  8001a4:	e8 36 06 00 00       	call   8007df <htons>
  8001a9:	66 89 43 0c          	mov    %ax,0xc(%ebx)
	arp->hwtype = htons(1); // Ethernet
  8001ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b4:	e8 26 06 00 00       	call   8007df <htons>
  8001b9:	66 89 43 0e          	mov    %ax,0xe(%ebx)
	arp->proto = htons(ETHTYPE_IP);
  8001bd:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c4:	e8 16 06 00 00       	call   8007df <htons>
  8001c9:	66 89 43 10          	mov    %ax,0x10(%ebx)
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001cd:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d4:	e8 06 06 00 00       	call   8007df <htons>
  8001d9:	66 89 43 12          	mov    %ax,0x12(%ebx)
	arp->opcode = htons(ARP_REQUEST);
  8001dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e4:	e8 f6 05 00 00       	call   8007df <htons>
  8001e9:	66 89 43 14          	mov    %ax,0x14(%ebx)
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001ed:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f4:	00 
  8001f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f9:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800200:	e8 c6 11 00 00       	call   8013cb <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800205:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80020c:	00 
  80020d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  80021b:	e8 ab 11 00 00       	call   8013cb <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800220:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800227:	00 
  800228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80022f:	00 
  800230:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  800237:	e8 b4 10 00 00       	call   8012f0 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  80023c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800243:	00 
  800244:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800252:	e8 74 11 00 00       	call   8013cb <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800257:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80025e:	00 
  80025f:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800266:	0f 
  800267:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  80026e:	00 
  80026f:	a1 00 40 80 00       	mov    0x804000,%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 86 1b 00 00       	call   801e02 <ipc_send>
	sys_page_unmap(0, pkt);
  80027c:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800283:	0f 
  800284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80028b:	e8 a2 15 00 00       	call   801832 <sys_page_unmap>
  800290:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  800297:	00 00 00 

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80029d:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
  8002a3:	89 b5 70 ff ff ff    	mov    %esi,-0x90(%ebp)
  8002a9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8002af:	29 f0                	sub    %esi,%eax
  8002b1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8002b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002be:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002c5:	0f 
  8002c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002c9:	89 04 24             	mov    %eax,(%esp)
  8002cc:	e8 9d 1b 00 00       	call   801e6e <ipc_recv>

		if (req < 0)
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	79 20                	jns    8002f5 <umain+0x2b5>
			panic("ipc_recv: %e", req);
  8002d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d9:	c7 44 24 08 49 25 80 	movl   $0x802549,0x8(%esp)
  8002e0:	00 
  8002e1:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
  8002e8:	00 
  8002e9:	c7 04 24 f8 24 80 00 	movl   $0x8024f8,(%esp)
  8002f0:	e8 8f 07 00 00       	call   800a84 <_panic>
		if (whom != input_envid)
  8002f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f8:	3b 15 04 40 80 00    	cmp    0x804004,%edx
  8002fe:	74 20                	je     800320 <umain+0x2e0>
			panic("IPC from unexpected environment %08x", whom);
  800300:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800304:	c7 44 24 08 a0 25 80 	movl   $0x8025a0,0x8(%esp)
  80030b:	00 
  80030c:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  800313:	00 
  800314:	c7 04 24 f8 24 80 00 	movl   $0x8024f8,(%esp)
  80031b:	e8 64 07 00 00       	call   800a84 <_panic>
		if (req != NSREQ_INPUT)
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 20                	je     800345 <umain+0x305>
			panic("Unexpected IPC %d", req);
  800325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800329:	c7 44 24 08 56 25 80 	movl   $0x802556,0x8(%esp)
  800330:	00 
  800331:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  800338:	00 
  800339:	c7 04 24 f8 24 80 00 	movl   $0x8024f8,(%esp)
  800340:	e8 3f 07 00 00       	call   800a84 <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800345:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  80034a:	89 45 84             	mov    %eax,-0x7c(%ebp)
static void
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
  80034d:	be 00 00 00 00       	mov    $0x0,%esi
  800352:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  800357:	83 e8 01             	sub    $0x1,%eax
  80035a:	89 45 80             	mov    %eax,-0x80(%ebp)
  80035d:	e9 bd 00 00 00       	jmp    80041f <umain+0x3df>
static void
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
  800362:	89 df                	mov    %ebx,%edi
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
  800364:	f6 c3 0f             	test   $0xf,%bl
  800367:	75 2e                	jne    800397 <umain+0x357>
			out = buf + snprintf(buf, end - buf,
  800369:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80036d:	c7 44 24 0c 68 25 80 	movl   $0x802568,0xc(%esp)
  800374:	00 
  800375:	c7 44 24 08 70 25 80 	movl   $0x802570,0x8(%esp)
  80037c:	00 
  80037d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800383:	89 44 24 04          	mov    %eax,0x4(%esp)
  800387:	8d 45 90             	lea    -0x70(%ebp),%eax
  80038a:	89 04 24             	mov    %eax,(%esp)
  80038d:	e8 82 0d 00 00       	call   801114 <snprintf>
  800392:	8d 75 90             	lea    -0x70(%ebp),%esi
  800395:	01 c6                	add    %eax,%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800397:	0f b6 87 04 b0 fe 0f 	movzbl 0xffeb004(%edi),%eax
  80039e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a2:	c7 44 24 08 7a 25 80 	movl   $0x80257a,0x8(%esp)
  8003a9:	00 
  8003aa:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8003b0:	29 f0                	sub    %esi,%eax
  8003b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b6:	89 34 24             	mov    %esi,(%esp)
  8003b9:	e8 56 0d 00 00       	call   801114 <snprintf>
  8003be:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003c0:	89 d8                	mov    %ebx,%eax
  8003c2:	c1 f8 1f             	sar    $0x1f,%eax
  8003c5:	c1 e8 1c             	shr    $0x1c,%eax
  8003c8:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003cb:	83 e7 0f             	and    $0xf,%edi
  8003ce:	29 c7                	sub    %eax,%edi
  8003d0:	83 ff 0f             	cmp    $0xf,%edi
  8003d3:	74 05                	je     8003da <umain+0x39a>
  8003d5:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003d8:	75 1f                	jne    8003f9 <umain+0x3b9>
			cprintf("%.*s\n", out - buf, buf);
  8003da:	8d 45 90             	lea    -0x70(%ebp),%eax
  8003dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e1:	89 f0                	mov    %esi,%eax
  8003e3:	2b 85 70 ff ff ff    	sub    -0x90(%ebp),%eax
  8003e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ed:	c7 04 24 7f 25 80 00 	movl   $0x80257f,(%esp)
  8003f4:	e8 44 07 00 00       	call   800b3d <cprintf>
		if (i % 2 == 1)
  8003f9:	89 d8                	mov    %ebx,%eax
  8003fb:	c1 e8 1f             	shr    $0x1f,%eax
  8003fe:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800401:	83 e2 01             	and    $0x1,%edx
  800404:	29 c2                	sub    %eax,%edx
  800406:	83 fa 01             	cmp    $0x1,%edx
  800409:	75 06                	jne    800411 <umain+0x3d1>
			*(out++) = ' ';
  80040b:	c6 06 20             	movb   $0x20,(%esi)
  80040e:	83 c6 01             	add    $0x1,%esi
		if (i % 16 == 7)
  800411:	83 ff 07             	cmp    $0x7,%edi
  800414:	75 06                	jne    80041c <umain+0x3dc>
			*(out++) = ' ';
  800416:	c6 06 20             	movb   $0x20,(%esi)
  800419:	83 c6 01             	add    $0x1,%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  80041c:	83 c3 01             	add    $0x1,%ebx
  80041f:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  800422:	0f 8f 3a ff ff ff    	jg     800362 <umain+0x322>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  800428:	c7 04 24 9b 25 80 00 	movl   $0x80259b,(%esp)
  80042f:	e8 09 07 00 00       	call   800b3d <cprintf>

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  800434:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  80043b:	0f 84 76 fe ff ff    	je     8002b7 <umain+0x277>
			cprintf("Waiting for packets...\n");
  800441:	c7 04 24 85 25 80 00 	movl   $0x802585,(%esp)
  800448:	e8 f0 06 00 00       	call   800b3d <cprintf>
  80044d:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  800454:	00 00 00 
  800457:	e9 5b fe ff ff       	jmp    8002b7 <umain+0x277>
		first = 0;
	}
}
  80045c:	81 c4 ac 00 00 00    	add    $0xac,%esp
  800462:	5b                   	pop    %ebx
  800463:	5e                   	pop    %esi
  800464:	5f                   	pop    %edi
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    
	...

00800470 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	57                   	push   %edi
  800474:	56                   	push   %esi
  800475:	53                   	push   %ebx
  800476:	83 ec 2c             	sub    $0x2c,%esp
  800479:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80047c:	e8 12 11 00 00       	call   801593 <sys_time_msec>
  800481:	89 c3                	mov    %eax,%ebx
  800483:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800486:	c7 05 00 30 80 00 c5 	movl   $0x8025c5,0x803000
  80048d:	25 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800490:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800493:	eb 05                	jmp    80049a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800495:	e8 b3 14 00 00       	call   80194d <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80049a:	e8 f4 10 00 00       	call   801593 <sys_time_msec>
  80049f:	39 c3                	cmp    %eax,%ebx
  8004a1:	76 06                	jbe    8004a9 <timer+0x39>
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	79 ee                	jns    800495 <timer+0x25>
  8004a7:	eb 09                	jmp    8004b2 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	90                   	nop
  8004ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8004b0:	79 20                	jns    8004d2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  8004b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004b6:	c7 44 24 08 ce 25 80 	movl   $0x8025ce,0x8(%esp)
  8004bd:	00 
  8004be:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8004c5:	00 
  8004c6:	c7 04 24 e0 25 80 00 	movl   $0x8025e0,(%esp)
  8004cd:	e8 b2 05 00 00       	call   800a84 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8004d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004d9:	00 
  8004da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004e1:	00 
  8004e2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8004e9:	00 
  8004ea:	89 34 24             	mov    %esi,(%esp)
  8004ed:	e8 10 19 00 00       	call   801e02 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004f2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004f9:	00 
  8004fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800501:	00 
  800502:	89 3c 24             	mov    %edi,(%esp)
  800505:	e8 64 19 00 00       	call   801e6e <ipc_recv>
  80050a:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  80050c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80050f:	39 c6                	cmp    %eax,%esi
  800511:	74 12                	je     800525 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800513:	89 44 24 04          	mov    %eax,0x4(%esp)
  800517:	c7 04 24 ec 25 80 00 	movl   $0x8025ec,(%esp)
  80051e:	e8 1a 06 00 00       	call   800b3d <cprintf>
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  800523:	eb cd                	jmp    8004f2 <timer+0x82>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800525:	e8 69 10 00 00       	call   801593 <sys_time_msec>
  80052a:	01 c3                	add    %eax,%ebx
  80052c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800530:	e9 65 ff ff ff       	jmp    80049a <timer+0x2a>
	...

00800540 <input>:

void
input(envid_t ns_envid)
//void
//umain(int argc, char **argv)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	57                   	push   %edi
  800544:	56                   	push   %esi
  800545:	53                   	push   %ebx
  800546:	83 ec 2c             	sub    $0x2c,%esp
	uint32_t req, whom, size;
	int perm, ret, even_odd = 0;
	envid_t to_env;

	binaryname = "ns_input";
  800549:	c7 05 00 30 80 00 27 	movl   $0x802627,0x803000
  800550:	26 80 00 
  800553:	bb 00 00 00 00       	mov    $0x0,%ebx
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	while (1) 
	{
		ret = sys_net_receive((void *)INPUT_PKTMAP,&size);
  800558:	8d 75 e4             	lea    -0x1c(%ebp),%esi
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_P|PTE_W|PTE_U);

		}
		else
		{
			nsipcbuf_1.pkt.jp_len = size;
  80055b:	bf 00 50 80 00       	mov    $0x805000,%edi
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	while (1) 
	{
		ret = sys_net_receive((void *)INPUT_PKTMAP,&size);
  800560:	89 74 24 04          	mov    %esi,0x4(%esp)
  800564:	c7 04 24 00 00 00 10 	movl   $0x10000000,(%esp)
  80056b:	e8 57 10 00 00       	call   8015c7 <sys_net_receive>
		if( ret == -E_NO_RDESC ) 
  800570:	83 f8 ef             	cmp    $0xffffffef,%eax
  800573:	75 07                	jne    80057c <input+0x3c>
		  {sys_yield(); continue;}
  800575:	e8 d3 13 00 00       	call   80194d <sys_yield>
  80057a:	eb e4                	jmp    800560 <input+0x20>
		cprintf("%s get an input packet size %u\n",__func__,size);
  80057c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80057f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800583:	c7 44 24 04 50 26 80 	movl   $0x802650,0x4(%esp)
  80058a:	00 
  80058b:	c7 04 24 30 26 80 00 	movl   $0x802630,(%esp)
  800592:	e8 a6 05 00 00       	call   800b3d <cprintf>

		if(even_odd)
  800597:	85 db                	test   %ebx,%ebx
  800599:	74 45                	je     8005e0 <input+0xa0>
		{
			nsipcbuf.pkt.jp_len = size;
  80059b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80059e:	a3 00 60 80 00       	mov    %eax,0x806000
			memmove(nsipcbuf.pkt.jp_data,(void *)INPUT_PKTMAP,nsipcbuf.pkt.jp_len);
  8005a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a7:	c7 44 24 04 00 00 00 	movl   $0x10000000,0x4(%esp)
  8005ae:	10 
  8005af:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8005b6:	e8 94 0d 00 00       	call   80134f <memmove>
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_P|PTE_W|PTE_U);
  8005bb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8005c2:	00 
  8005c3:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8005ca:	00 
  8005cb:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8005d2:	00 
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	89 04 24             	mov    %eax,(%esp)
  8005d9:	e8 24 18 00 00       	call   801e02 <ipc_send>
  8005de:	eb 3c                	jmp    80061c <input+0xdc>

		}
		else
		{
			nsipcbuf_1.pkt.jp_len = size;
  8005e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e3:	89 07                	mov    %eax,(%edi)
			memmove(nsipcbuf_1.pkt.jp_data,(void *)INPUT_PKTMAP,nsipcbuf_1.pkt.jp_len);
  8005e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e9:	c7 44 24 04 00 00 00 	movl   $0x10000000,0x4(%esp)
  8005f0:	10 
  8005f1:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8005f8:	e8 52 0d 00 00       	call   80134f <memmove>
			ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf_1,PTE_P|PTE_W|PTE_U);
  8005fd:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800604:	00 
  800605:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800609:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800610:	00 
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 04 24             	mov    %eax,(%esp)
  800617:	e8 e6 17 00 00       	call   801e02 <ipc_send>
		}
		even_odd = (even_odd+1)%2;
  80061c:	83 c3 01             	add    $0x1,%ebx
  80061f:	89 d8                	mov    %ebx,%eax
  800621:	c1 e8 1f             	shr    $0x1f,%eax
  800624:	01 c3                	add    %eax,%ebx
  800626:	83 e3 01             	and    $0x1,%ebx
  800629:	29 c3                	sub    %eax,%ebx
		sys_yield();
  80062b:	e8 1d 13 00 00       	call   80194d <sys_yield>
  800630:	e9 2b ff ff ff       	jmp    800560 <input+0x20>
  800635:	00 00                	add    %al,(%eax)
	...

00800638 <output>:

void
output(envid_t ns_envid)
//void
//umain(int argc, char **argv)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	57                   	push   %edi
  80063c:	56                   	push   %esi
  80063d:	53                   	push   %ebx
  80063e:	83 ec 3c             	sub    $0x3c,%esp
	//	- send the packet to the device driver
	uint32_t req, whom;
	int perm, ret;
	void *pg;

	binaryname = "ns_output";
  800641:	c7 05 00 30 80 00 56 	movl   $0x802656,0x803000
  800648:	26 80 00 
	//cprintf("output is running\n");

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, &nsipcbuf, &perm);
  80064b:	8d 75 e0             	lea    -0x20(%ebp),%esi
  80064e:	8d 7d e4             	lea    -0x1c(%ebp),%edi

	binaryname = "ns_output";
	//cprintf("output is running\n");

	while (1) {
		perm = 0;
  800651:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv((int32_t *) &whom, &nsipcbuf, &perm);
  800658:	89 74 24 08          	mov    %esi,0x8(%esp)
  80065c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  800663:	00 
  800664:	89 3c 24             	mov    %edi,(%esp)
  800667:	e8 02 18 00 00       	call   801e6e <ipc_recv>

		cprintf("%s req %d from %08x size %u\n", __func__, req, whom, nsipcbuf.pkt.jp_len);
  80066c:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800672:	89 54 24 10          	mov    %edx,0x10(%esp)
  800676:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800679:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80067d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800681:	c7 44 24 04 f3 26 80 	movl   $0x8026f3,0x4(%esp)
  800688:	00 
  800689:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  800690:	e8 a8 04 00 00       	call   800b3d <cprintf>

		// All requests must contain an argument page
		if (!(perm & PTE_P)) 
  800695:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  800699:	75 15                	jne    8006b0 <output+0x78>
		{
			cprintf("Invalid request from %08x: no argument page\n",whom);
  80069b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a2:	c7 04 24 9c 26 80 00 	movl   $0x80269c,(%esp)
  8006a9:	e8 8f 04 00 00       	call   800b3d <cprintf>
			continue;
  8006ae:	eb a1                	jmp    800651 <output+0x19>
		}

		if(whom != ns_envid)
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b6:	74 24                	je     8006dc <output+0xa4>
			panic("%s get message from wrong environments",__func__);
  8006b8:	c7 44 24 0c f3 26 80 	movl   $0x8026f3,0xc(%esp)
  8006bf:	00 
  8006c0:	c7 44 24 08 cc 26 80 	movl   $0x8026cc,0x8(%esp)
  8006c7:	00 
  8006c8:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8006cf:	00 
  8006d0:	c7 04 24 7d 26 80 00 	movl   $0x80267d,(%esp)
  8006d7:	e8 a8 03 00 00       	call   800a84 <_panic>

		do 
		{ret = sys_net_send(nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len);}
  8006dc:	bb 00 60 80 00       	mov    $0x806000,%ebx
  8006e1:	8b 03                	mov    (%ebx),%eax
  8006e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8006ee:	e8 32 0f 00 00       	call   801625 <sys_net_send>
		while(ret == -E_NO_TXDESC);
  8006f3:	83 f8 f0             	cmp    $0xfffffff0,%eax
  8006f6:	74 e9                	je     8006e1 <output+0xa9>

		if(ret)panic("output error %e\n",ret);
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	0f 84 51 ff ff ff    	je     800651 <output+0x19>
  800700:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800704:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  80070b:	00 
  80070c:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  800713:	00 
  800714:	c7 04 24 7d 26 80 00 	movl   $0x80267d,(%esp)
  80071b:	e8 64 03 00 00       	call   800a84 <_panic>

00800720 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	57                   	push   %edi
  800724:	56                   	push   %esi
  800725:	53                   	push   %ebx
  800726:	83 ec 20             	sub    $0x20,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80072f:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800732:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  800736:	c7 45 e0 08 40 80 00 	movl   $0x804008,-0x20(%ebp)
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
  800742:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800748:	0f b6 00             	movzbl (%eax),%eax
  80074b:	88 45 db             	mov    %al,-0x25(%ebp)
      *ap /= (u8_t)10;
  80074e:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  800753:	f6 65 db             	mulb   -0x25(%ebp)
  800756:	66 c1 e8 08          	shr    $0x8,%ax
  80075a:	c0 e8 03             	shr    $0x3,%al
  80075d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800760:	88 01                	mov    %al,(%ecx)
      inv[i++] = '0' + rem;
  800762:	0f b6 f2             	movzbl %dl,%esi
  800765:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  800768:	01 ff                	add    %edi,%edi
  80076a:	0f b6 5d db          	movzbl -0x25(%ebp),%ebx
  80076e:	89 f9                	mov    %edi,%ecx
  800770:	28 cb                	sub    %cl,%bl
  800772:	89 df                	mov    %ebx,%edi
  800774:	8d 4f 30             	lea    0x30(%edi),%ecx
  800777:	88 4c 35 ed          	mov    %cl,-0x13(%ebp,%esi,1)
  80077b:	8d 4a 01             	lea    0x1(%edx),%ecx
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80077e:	89 ca                	mov    %ecx,%edx
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
  800780:	84 c0                	test   %al,%al
  800782:	75 c1                	jne    800745 <inet_ntoa+0x25>
  800784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800787:	89 ce                	mov    %ecx,%esi
  800789:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80078c:	eb 10                	jmp    80079e <inet_ntoa+0x7e>
    while(i--)
  80078e:	83 ea 01             	sub    $0x1,%edx
      *rp++ = inv[i];
  800791:	0f b6 ca             	movzbl %dl,%ecx
  800794:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800799:	88 08                	mov    %cl,(%eax)
  80079b:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80079e:	84 d2                	test   %dl,%dl
  8007a0:	75 ec                	jne    80078e <inet_ntoa+0x6e>
  8007a2:	89 f1                	mov    %esi,%ecx
  8007a4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8007a7:	0f b6 c9             	movzbl %cl,%ecx
  8007aa:	03 4d e0             	add    -0x20(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  8007ad:	c6 01 2e             	movb   $0x2e,(%ecx)
  8007b0:	83 c1 01             	add    $0x1,%ecx
  8007b3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8007b6:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8007ba:	80 7d df 03          	cmpb   $0x3,-0x21(%ebp)
  8007be:	77 0b                	ja     8007cb <inet_ntoa+0xab>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  8007c0:	83 c3 01             	add    $0x1,%ebx
  8007c3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8007c6:	e9 7a ff ff ff       	jmp    800745 <inet_ntoa+0x25>
  }
  *--rp = 0;
  8007cb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007ce:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8007d2:	b8 08 40 80 00       	mov    $0x804008,%eax
  8007d7:	83 c4 20             	add    $0x20,%esp
  8007da:	5b                   	pop    %ebx
  8007db:	5e                   	pop    %esi
  8007dc:	5f                   	pop    %edi
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8007e6:	66 c1 c0 08          	rol    $0x8,%ax
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
}
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  8007f2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8007f6:	89 04 24             	mov    %eax,(%esp)
  8007f9:	e8 e1 ff ff ff       	call   8007df <htons>
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 55 08             	mov    0x8(%ebp),%edx
  800806:	89 d1                	mov    %edx,%ecx
  800808:	c1 e9 18             	shr    $0x18,%ecx
  80080b:	89 d0                	mov    %edx,%eax
  80080d:	c1 e0 18             	shl    $0x18,%eax
  800810:	09 c8                	or     %ecx,%eax
  800812:	89 d1                	mov    %edx,%ecx
  800814:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80081a:	c1 e1 08             	shl    $0x8,%ecx
  80081d:	09 c8                	or     %ecx,%eax
  80081f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800825:	c1 ea 08             	shr    $0x8,%edx
  800828:	09 d0                	or     %edx,%eax
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80082a:	5d                   	pop    %ebp
  80082b:	c3                   	ret    

0080082c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	57                   	push   %edi
  800830:	56                   	push   %esi
  800831:	53                   	push   %ebx
  800832:	83 ec 28             	sub    $0x28,%esp
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800838:	0f be 10             	movsbl (%eax),%edx
  80083b:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  80083e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800841:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800844:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800847:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80084a:	80 f9 09             	cmp    $0x9,%cl
  80084d:	0f 87 87 01 00 00    	ja     8009da <inet_aton+0x1ae>
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
  800853:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
  80085a:	83 fa 30             	cmp    $0x30,%edx
  80085d:	75 24                	jne    800883 <inet_aton+0x57>
      c = *++cp;
  80085f:	83 c0 01             	add    $0x1,%eax
  800862:	0f be 10             	movsbl (%eax),%edx
      if (c == 'x' || c == 'X') {
  800865:	83 fa 78             	cmp    $0x78,%edx
  800868:	74 0c                	je     800876 <inet_aton+0x4a>
  80086a:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800871:	83 fa 58             	cmp    $0x58,%edx
  800874:	75 0d                	jne    800883 <inet_aton+0x57>
        base = 16;
        c = *++cp;
  800876:	83 c0 01             	add    $0x1,%eax
  800879:	0f be 10             	movsbl (%eax),%edx
  80087c:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	be 00 00 00 00       	mov    $0x0,%esi
  80088b:	eb 03                	jmp    800890 <inet_aton+0x64>
  80088d:	83 c0 01             	add    $0x1,%eax
  800890:	8d 78 ff             	lea    -0x1(%eax),%edi
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800893:	89 d1                	mov    %edx,%ecx
  800895:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800898:	80 fb 09             	cmp    $0x9,%bl
  80089b:	77 0d                	ja     8008aa <inet_aton+0x7e>
        val = (val * base) + (int)(c - '0');
  80089d:	0f af 75 e0          	imul   -0x20(%ebp),%esi
  8008a1:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  8008a5:	0f be 10             	movsbl (%eax),%edx
  8008a8:	eb e3                	jmp    80088d <inet_aton+0x61>
      } else if (base == 16 && isxdigit(c)) {
  8008aa:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8008ae:	75 2b                	jne    8008db <inet_aton+0xaf>
  8008b0:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8008b3:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  8008b6:	80 fb 05             	cmp    $0x5,%bl
  8008b9:	76 08                	jbe    8008c3 <inet_aton+0x97>
  8008bb:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8008be:	80 fb 05             	cmp    $0x5,%bl
  8008c1:	77 18                	ja     8008db <inet_aton+0xaf>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8008c3:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8008c7:	19 c9                	sbb    %ecx,%ecx
  8008c9:	83 e1 20             	and    $0x20,%ecx
  8008cc:	c1 e6 04             	shl    $0x4,%esi
  8008cf:	29 ca                	sub    %ecx,%edx
  8008d1:	8d 52 c9             	lea    -0x37(%edx),%edx
  8008d4:	09 d6                	or     %edx,%esi
        c = *++cp;
  8008d6:	0f be 10             	movsbl (%eax),%edx
  8008d9:	eb b2                	jmp    80088d <inet_aton+0x61>
      } else
        break;
    }
    if (c == '.') {
  8008db:	83 fa 2e             	cmp    $0x2e,%edx
  8008de:	75 22                	jne    800902 <inet_aton+0xd6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8008e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008e3:	39 55 d8             	cmp    %edx,-0x28(%ebp)
  8008e6:	0f 83 ee 00 00 00    	jae    8009da <inet_aton+0x1ae>
        return (0);
      *pp++ = val;
  8008ec:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008ef:	89 31                	mov    %esi,(%ecx)
  8008f1:	83 c1 04             	add    $0x4,%ecx
  8008f4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      c = *++cp;
  8008f7:	8d 47 01             	lea    0x1(%edi),%eax
  8008fa:	0f be 10             	movsbl (%eax),%edx
    } else
      break;
  }
  8008fd:	e9 45 ff ff ff       	jmp    800847 <inet_aton+0x1b>
  800902:	89 f3                	mov    %esi,%ebx
  800904:	89 f0                	mov    %esi,%eax
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800906:	85 d2                	test   %edx,%edx
  800908:	74 36                	je     800940 <inet_aton+0x114>
  80090a:	80 f9 1f             	cmp    $0x1f,%cl
  80090d:	0f 86 c7 00 00 00    	jbe    8009da <inet_aton+0x1ae>
  800913:	84 d2                	test   %dl,%dl
  800915:	0f 88 bf 00 00 00    	js     8009da <inet_aton+0x1ae>
  80091b:	83 fa 20             	cmp    $0x20,%edx
  80091e:	66 90                	xchg   %ax,%ax
  800920:	74 1e                	je     800940 <inet_aton+0x114>
  800922:	83 fa 0c             	cmp    $0xc,%edx
  800925:	74 19                	je     800940 <inet_aton+0x114>
  800927:	83 fa 0a             	cmp    $0xa,%edx
  80092a:	74 14                	je     800940 <inet_aton+0x114>
  80092c:	83 fa 0d             	cmp    $0xd,%edx
  80092f:	90                   	nop
  800930:	74 0e                	je     800940 <inet_aton+0x114>
  800932:	83 fa 09             	cmp    $0x9,%edx
  800935:	74 09                	je     800940 <inet_aton+0x114>
  800937:	83 fa 0b             	cmp    $0xb,%edx
  80093a:	0f 85 9a 00 00 00    	jne    8009da <inet_aton+0x1ae>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  800940:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800943:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800946:	29 d1                	sub    %edx,%ecx
  800948:	89 ca                	mov    %ecx,%edx
  80094a:	c1 fa 02             	sar    $0x2,%edx
  80094d:	83 c2 01             	add    $0x1,%edx
  800950:	83 fa 02             	cmp    $0x2,%edx
  800953:	74 1d                	je     800972 <inet_aton+0x146>
  800955:	83 fa 02             	cmp    $0x2,%edx
  800958:	7f 08                	jg     800962 <inet_aton+0x136>
  80095a:	85 d2                	test   %edx,%edx
  80095c:	74 7c                	je     8009da <inet_aton+0x1ae>
  80095e:	66 90                	xchg   %ax,%ax
  800960:	eb 59                	jmp    8009bb <inet_aton+0x18f>
  800962:	83 fa 03             	cmp    $0x3,%edx
  800965:	74 1c                	je     800983 <inet_aton+0x157>
  800967:	83 fa 04             	cmp    $0x4,%edx
  80096a:	75 4f                	jne    8009bb <inet_aton+0x18f>
  80096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800970:	eb 2a                	jmp    80099c <inet_aton+0x170>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800972:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  800977:	77 61                	ja     8009da <inet_aton+0x1ae>
      return (0);
    val |= parts[0] << 24;
  800979:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80097c:	c1 e3 18             	shl    $0x18,%ebx
  80097f:	09 c3                	or     %eax,%ebx
    break;
  800981:	eb 38                	jmp    8009bb <inet_aton+0x18f>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800983:	3d ff ff 00 00       	cmp    $0xffff,%eax
  800988:	77 50                	ja     8009da <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80098a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80098d:	c1 e3 10             	shl    $0x10,%ebx
  800990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800993:	c1 e2 18             	shl    $0x18,%edx
  800996:	09 d3                	or     %edx,%ebx
  800998:	09 c3                	or     %eax,%ebx
    break;
  80099a:	eb 1f                	jmp    8009bb <inet_aton+0x18f>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80099c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a1:	77 37                	ja     8009da <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8009a3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8009a6:	c1 e3 10             	shl    $0x10,%ebx
  8009a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ac:	c1 e2 18             	shl    $0x18,%edx
  8009af:	09 d3                	or     %edx,%ebx
  8009b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009b4:	c1 e2 08             	shl    $0x8,%edx
  8009b7:	09 d3                	or     %edx,%ebx
  8009b9:	09 c3                	or     %eax,%ebx
    break;
  }
  if (addr)
  8009bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8009c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c4:	74 19                	je     8009df <inet_aton+0x1b3>
    addr->s_addr = htonl(val);
  8009c6:	89 1c 24             	mov    %ebx,(%esp)
  8009c9:	e8 32 fe ff ff       	call   800800 <htonl>
  8009ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d1:	89 03                	mov    %eax,(%ebx)
  8009d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8009d8:	eb 05                	jmp    8009df <inet_aton+0x1b3>
  8009da:	b8 00 00 00 00       	mov    $0x0,%eax
  return (1);
}
  8009df:	83 c4 28             	add    $0x28,%esp
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5f                   	pop    %edi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8009ed:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	89 04 24             	mov    %eax,(%esp)
  8009fa:	e8 2d fe ff ff       	call   80082c <inet_aton>
  8009ff:	85 c0                	test   %eax,%eax
  800a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800a06:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
    return (val.s_addr);
  }
  return (INADDR_NONE);
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	89 04 24             	mov    %eax,(%esp)
  800a18:	e8 e3 fd ff ff       	call   800800 <htonl>
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    
	...

00800a20 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
  800a26:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a29:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800a2c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800a32:	e8 4a 0f 00 00       	call   801981 <sys_getenvid>
  800a37:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a3c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a3f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800a44:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a49:	85 f6                	test   %esi,%esi
  800a4b:	7e 07                	jle    800a54 <libmain+0x34>
		binaryname = argv[0];
  800a4d:	8b 03                	mov    (%ebx),%eax
  800a4f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800a54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a58:	89 34 24             	mov    %esi,(%esp)
  800a5b:	e8 e0 f5 ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800a60:	e8 0b 00 00 00       	call   800a70 <exit>
}
  800a65:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800a68:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800a6b:	89 ec                	mov    %ebp,%esp
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    
	...

00800a70 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800a76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a7d:	e8 33 0f 00 00       	call   8019b5 <sys_env_destroy>
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  800a8c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a8f:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800a95:	e8 e7 0e 00 00       	call   801981 <sys_getenvid>
  800a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800aa8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800ab7:	e8 81 00 00 00       	call   800b3d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800abc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac3:	89 04 24             	mov    %eax,(%esp)
  800ac6:	e8 11 00 00 00       	call   800adc <vcprintf>
	cprintf("\n");
  800acb:	c7 04 24 9b 25 80 00 	movl   $0x80259b,(%esp)
  800ad2:	e8 66 00 00 00       	call   800b3d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ad7:	cc                   	int3   
  800ad8:	eb fd                	jmp    800ad7 <_panic+0x53>
	...

00800adc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800ae5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aec:	00 00 00 
	b.cnt = 0;
  800aef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800af6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b11:	c7 04 24 57 0b 80 00 	movl   $0x800b57,(%esp)
  800b18:	e8 be 01 00 00       	call   800cdb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b1d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b27:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b2d:	89 04 24             	mov    %eax,(%esp)
  800b30:	e8 2b 0a 00 00       	call   801560 <sys_cputs>

	return b.cnt;
}
  800b35:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800b43:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 04 24             	mov    %eax,(%esp)
  800b50:	e8 87 ff ff ff       	call   800adc <vcprintf>
	va_end(ap);

	return cnt;
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	53                   	push   %ebx
  800b5b:	83 ec 14             	sub    $0x14,%esp
  800b5e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b61:	8b 03                	mov    (%ebx),%eax
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
  800b66:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800b6f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b74:	75 19                	jne    800b8f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800b76:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800b7d:	00 
  800b7e:	8d 43 08             	lea    0x8(%ebx),%eax
  800b81:	89 04 24             	mov    %eax,(%esp)
  800b84:	e8 d7 09 00 00       	call   801560 <sys_cputs>
		b->idx = 0;
  800b89:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800b8f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b93:	83 c4 14             	add    $0x14,%esp
  800b96:	5b                   	pop    %ebx
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
  800b99:	00 00                	add    %al,(%eax)
	...

00800b9c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	57                   	push   %edi
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	83 ec 4c             	sub    $0x4c,%esp
  800ba5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ba8:	89 d6                	mov    %edx,%esi
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800bbc:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc7:	39 d1                	cmp    %edx,%ecx
  800bc9:	72 07                	jb     800bd2 <printnum+0x36>
  800bcb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bce:	39 d0                	cmp    %edx,%eax
  800bd0:	77 69                	ja     800c3b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800bd6:	83 eb 01             	sub    $0x1,%ebx
  800bd9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800be5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800be9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800bec:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800bef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800bf2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800bf6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800bfd:	00 
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	89 04 24             	mov    %eax,(%esp)
  800c04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c07:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c0b:	e8 50 16 00 00       	call   802260 <__udivdi3>
  800c10:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800c13:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800c16:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c1a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800c1e:	89 04 24             	mov    %eax,(%esp)
  800c21:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c25:	89 f2                	mov    %esi,%edx
  800c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c2a:	e8 6d ff ff ff       	call   800b9c <printnum>
  800c2f:	eb 11                	jmp    800c42 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c31:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c35:	89 3c 24             	mov    %edi,(%esp)
  800c38:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c3b:	83 eb 01             	sub    $0x1,%ebx
  800c3e:	85 db                	test   %ebx,%ebx
  800c40:	7f ef                	jg     800c31 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c42:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c46:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c51:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800c58:	00 
  800c59:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c5c:	89 14 24             	mov    %edx,(%esp)
  800c5f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c66:	e8 25 17 00 00       	call   802390 <__umoddi3>
  800c6b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c6f:	0f be 80 27 27 80 00 	movsbl 0x802727(%eax),%eax
  800c76:	89 04 24             	mov    %eax,(%esp)
  800c79:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800c7c:	83 c4 4c             	add    $0x4c,%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c87:	83 fa 01             	cmp    $0x1,%edx
  800c8a:	7e 0e                	jle    800c9a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c8c:	8b 10                	mov    (%eax),%edx
  800c8e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c91:	89 08                	mov    %ecx,(%eax)
  800c93:	8b 02                	mov    (%edx),%eax
  800c95:	8b 52 04             	mov    0x4(%edx),%edx
  800c98:	eb 22                	jmp    800cbc <getuint+0x38>
	else if (lflag)
  800c9a:	85 d2                	test   %edx,%edx
  800c9c:	74 10                	je     800cae <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c9e:	8b 10                	mov    (%eax),%edx
  800ca0:	8d 4a 04             	lea    0x4(%edx),%ecx
  800ca3:	89 08                	mov    %ecx,(%eax)
  800ca5:	8b 02                	mov    (%edx),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 0e                	jmp    800cbc <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 10                	mov    (%eax),%edx
  800cb0:	8d 4a 04             	lea    0x4(%edx),%ecx
  800cb3:	89 08                	mov    %ecx,(%eax)
  800cb5:	8b 02                	mov    (%edx),%eax
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800cc4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800cc8:	8b 10                	mov    (%eax),%edx
  800cca:	3b 50 04             	cmp    0x4(%eax),%edx
  800ccd:	73 0a                	jae    800cd9 <sprintputch+0x1b>
		*b->buf++ = ch;
  800ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd2:	88 0a                	mov    %cl,(%edx)
  800cd4:	83 c2 01             	add    $0x1,%edx
  800cd7:	89 10                	mov    %edx,(%eax)
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 4c             	sub    $0x4c,%esp
  800ce4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cea:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ced:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800cf4:	eb 11                	jmp    800d07 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	0f 84 b6 03 00 00    	je     8010b4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800cfe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d02:	89 04 24             	mov    %eax,(%esp)
  800d05:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d07:	0f b6 03             	movzbl (%ebx),%eax
  800d0a:	83 c3 01             	add    $0x1,%ebx
  800d0d:	83 f8 25             	cmp    $0x25,%eax
  800d10:	75 e4                	jne    800cf6 <vprintfmt+0x1b>
  800d12:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800d16:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800d1d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800d24:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800d2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d30:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800d33:	eb 06                	jmp    800d3b <vprintfmt+0x60>
  800d35:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800d39:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d3b:	0f b6 0b             	movzbl (%ebx),%ecx
  800d3e:	0f b6 c1             	movzbl %cl,%eax
  800d41:	8d 53 01             	lea    0x1(%ebx),%edx
  800d44:	83 e9 23             	sub    $0x23,%ecx
  800d47:	80 f9 55             	cmp    $0x55,%cl
  800d4a:	0f 87 47 03 00 00    	ja     801097 <vprintfmt+0x3bc>
  800d50:	0f b6 c9             	movzbl %cl,%ecx
  800d53:	ff 24 8d 60 28 80 00 	jmp    *0x802860(,%ecx,4)
  800d5a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800d5e:	eb d9                	jmp    800d39 <vprintfmt+0x5e>
  800d60:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800d67:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d6c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800d6f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800d73:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800d76:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800d79:	83 fb 09             	cmp    $0x9,%ebx
  800d7c:	77 30                	ja     800dae <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d7e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d81:	eb e9                	jmp    800d6c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d83:	8b 45 14             	mov    0x14(%ebp),%eax
  800d86:	8d 48 04             	lea    0x4(%eax),%ecx
  800d89:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800d91:	eb 1e                	jmp    800db1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d97:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9c:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800da0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800da3:	eb 94                	jmp    800d39 <vprintfmt+0x5e>
  800da5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800dac:	eb 8b                	jmp    800d39 <vprintfmt+0x5e>
  800dae:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800db1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db5:	79 82                	jns    800d39 <vprintfmt+0x5e>
  800db7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800dba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dbd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800dc0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800dc3:	e9 71 ff ff ff       	jmp    800d39 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dc8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800dcc:	e9 68 ff ff ff       	jmp    800d39 <vprintfmt+0x5e>
  800dd1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd7:	8d 50 04             	lea    0x4(%eax),%edx
  800dda:	89 55 14             	mov    %edx,0x14(%ebp)
  800ddd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800de1:	8b 00                	mov    (%eax),%eax
  800de3:	89 04 24             	mov    %eax,(%esp)
  800de6:	ff d7                	call   *%edi
  800de8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800deb:	e9 17 ff ff ff       	jmp    800d07 <vprintfmt+0x2c>
  800df0:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800df3:	8b 45 14             	mov    0x14(%ebp),%eax
  800df6:	8d 50 04             	lea    0x4(%eax),%edx
  800df9:	89 55 14             	mov    %edx,0x14(%ebp)
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	89 c2                	mov    %eax,%edx
  800e00:	c1 fa 1f             	sar    $0x1f,%edx
  800e03:	31 d0                	xor    %edx,%eax
  800e05:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e07:	83 f8 11             	cmp    $0x11,%eax
  800e0a:	7f 0b                	jg     800e17 <vprintfmt+0x13c>
  800e0c:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800e13:	85 d2                	test   %edx,%edx
  800e15:	75 20                	jne    800e37 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e1b:	c7 44 24 08 38 27 80 	movl   $0x802738,0x8(%esp)
  800e22:	00 
  800e23:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e27:	89 3c 24             	mov    %edi,(%esp)
  800e2a:	e8 0d 03 00 00       	call   80113c <printfmt>
  800e2f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e32:	e9 d0 fe ff ff       	jmp    800d07 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e37:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e3b:	c7 44 24 08 50 2b 80 	movl   $0x802b50,0x8(%esp)
  800e42:	00 
  800e43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e47:	89 3c 24             	mov    %edi,(%esp)
  800e4a:	e8 ed 02 00 00       	call   80113c <printfmt>
  800e4f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800e52:	e9 b0 fe ff ff       	jmp    800d07 <vprintfmt+0x2c>
  800e57:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800e5a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e63:	8b 45 14             	mov    0x14(%ebp),%eax
  800e66:	8d 50 04             	lea    0x4(%eax),%edx
  800e69:	89 55 14             	mov    %edx,0x14(%ebp)
  800e6c:	8b 18                	mov    (%eax),%ebx
  800e6e:	85 db                	test   %ebx,%ebx
  800e70:	b8 41 27 80 00       	mov    $0x802741,%eax
  800e75:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800e78:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e7c:	7e 76                	jle    800ef4 <vprintfmt+0x219>
  800e7e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800e82:	74 7a                	je     800efe <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e88:	89 1c 24             	mov    %ebx,(%esp)
  800e8b:	e8 f8 02 00 00       	call   801188 <strnlen>
  800e90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e93:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800e95:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e9c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800e9f:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea1:	eb 0f                	jmp    800eb2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800ea3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eaa:	89 04 24             	mov    %eax,(%esp)
  800ead:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eaf:	83 eb 01             	sub    $0x1,%ebx
  800eb2:	85 db                	test   %ebx,%ebx
  800eb4:	7f ed                	jg     800ea3 <vprintfmt+0x1c8>
  800eb6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800eb9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ebc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800ebf:	89 f7                	mov    %esi,%edi
  800ec1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800ec4:	eb 40                	jmp    800f06 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ec6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800eca:	74 18                	je     800ee4 <vprintfmt+0x209>
  800ecc:	8d 50 e0             	lea    -0x20(%eax),%edx
  800ecf:	83 fa 5e             	cmp    $0x5e,%edx
  800ed2:	76 10                	jbe    800ee4 <vprintfmt+0x209>
					putch('?', putdat);
  800ed4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ed8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800edf:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ee2:	eb 0a                	jmp    800eee <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800ee4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ee8:	89 04 24             	mov    %eax,(%esp)
  800eeb:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800ef2:	eb 12                	jmp    800f06 <vprintfmt+0x22b>
  800ef4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800ef7:	89 f7                	mov    %esi,%edi
  800ef9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800efc:	eb 08                	jmp    800f06 <vprintfmt+0x22b>
  800efe:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800f01:	89 f7                	mov    %esi,%edi
  800f03:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800f06:	0f be 03             	movsbl (%ebx),%eax
  800f09:	83 c3 01             	add    $0x1,%ebx
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	74 25                	je     800f35 <vprintfmt+0x25a>
  800f10:	85 f6                	test   %esi,%esi
  800f12:	78 b2                	js     800ec6 <vprintfmt+0x1eb>
  800f14:	83 ee 01             	sub    $0x1,%esi
  800f17:	79 ad                	jns    800ec6 <vprintfmt+0x1eb>
  800f19:	89 fe                	mov    %edi,%esi
  800f1b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800f1e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800f21:	eb 1a                	jmp    800f3d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f23:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f27:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f2e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f30:	83 eb 01             	sub    $0x1,%ebx
  800f33:	eb 08                	jmp    800f3d <vprintfmt+0x262>
  800f35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800f38:	89 fe                	mov    %edi,%esi
  800f3a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800f3d:	85 db                	test   %ebx,%ebx
  800f3f:	7f e2                	jg     800f23 <vprintfmt+0x248>
  800f41:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800f44:	e9 be fd ff ff       	jmp    800d07 <vprintfmt+0x2c>
  800f49:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800f4c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f4f:	83 f9 01             	cmp    $0x1,%ecx
  800f52:	7e 16                	jle    800f6a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800f54:	8b 45 14             	mov    0x14(%ebp),%eax
  800f57:	8d 50 08             	lea    0x8(%eax),%edx
  800f5a:	89 55 14             	mov    %edx,0x14(%ebp)
  800f5d:	8b 10                	mov    (%eax),%edx
  800f5f:	8b 48 04             	mov    0x4(%eax),%ecx
  800f62:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800f65:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f68:	eb 32                	jmp    800f9c <vprintfmt+0x2c1>
	else if (lflag)
  800f6a:	85 c9                	test   %ecx,%ecx
  800f6c:	74 18                	je     800f86 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f71:	8d 50 04             	lea    0x4(%eax),%edx
  800f74:	89 55 14             	mov    %edx,0x14(%ebp)
  800f77:	8b 00                	mov    (%eax),%eax
  800f79:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f7c:	89 c1                	mov    %eax,%ecx
  800f7e:	c1 f9 1f             	sar    $0x1f,%ecx
  800f81:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f84:	eb 16                	jmp    800f9c <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800f86:	8b 45 14             	mov    0x14(%ebp),%eax
  800f89:	8d 50 04             	lea    0x4(%eax),%edx
  800f8c:	89 55 14             	mov    %edx,0x14(%ebp)
  800f8f:	8b 00                	mov    (%eax),%eax
  800f91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f94:	89 c2                	mov    %eax,%edx
  800f96:	c1 fa 1f             	sar    $0x1f,%edx
  800f99:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f9c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800f9f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fa2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800fa7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fab:	0f 89 a7 00 00 00    	jns    801058 <vprintfmt+0x37d>
				putch('-', putdat);
  800fb1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fb5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800fbc:	ff d7                	call   *%edi
				num = -(long long) num;
  800fbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800fc1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fc4:	f7 d9                	neg    %ecx
  800fc6:	83 d3 00             	adc    $0x0,%ebx
  800fc9:	f7 db                	neg    %ebx
  800fcb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fd0:	e9 83 00 00 00       	jmp    801058 <vprintfmt+0x37d>
  800fd5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800fd8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fdb:	89 ca                	mov    %ecx,%edx
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	e8 9f fc ff ff       	call   800c84 <getuint>
  800fe5:	89 c1                	mov    %eax,%ecx
  800fe7:	89 d3                	mov    %edx,%ebx
  800fe9:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800fee:	eb 68                	jmp    801058 <vprintfmt+0x37d>
  800ff0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800ff3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800ff6:	89 ca                	mov    %ecx,%edx
  800ff8:	8d 45 14             	lea    0x14(%ebp),%eax
  800ffb:	e8 84 fc ff ff       	call   800c84 <getuint>
  801000:	89 c1                	mov    %eax,%ecx
  801002:	89 d3                	mov    %edx,%ebx
  801004:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  801009:	eb 4d                	jmp    801058 <vprintfmt+0x37d>
  80100b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80100e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801012:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801019:	ff d7                	call   *%edi
			putch('x', putdat);
  80101b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80101f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801026:	ff d7                	call   *%edi
			num = (unsigned long long)
  801028:	8b 45 14             	mov    0x14(%ebp),%eax
  80102b:	8d 50 04             	lea    0x4(%eax),%edx
  80102e:	89 55 14             	mov    %edx,0x14(%ebp)
  801031:	8b 08                	mov    (%eax),%ecx
  801033:	bb 00 00 00 00       	mov    $0x0,%ebx
  801038:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80103d:	eb 19                	jmp    801058 <vprintfmt+0x37d>
  80103f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801042:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801045:	89 ca                	mov    %ecx,%edx
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	e8 35 fc ff ff       	call   800c84 <getuint>
  80104f:	89 c1                	mov    %eax,%ecx
  801051:	89 d3                	mov    %edx,%ebx
  801053:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  801058:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  80105c:	89 54 24 10          	mov    %edx,0x10(%esp)
  801060:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801063:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80106b:	89 0c 24             	mov    %ecx,(%esp)
  80106e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801072:	89 f2                	mov    %esi,%edx
  801074:	89 f8                	mov    %edi,%eax
  801076:	e8 21 fb ff ff       	call   800b9c <printnum>
  80107b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80107e:	e9 84 fc ff ff       	jmp    800d07 <vprintfmt+0x2c>
  801083:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801086:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108a:	89 04 24             	mov    %eax,(%esp)
  80108d:	ff d7                	call   *%edi
  80108f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  801092:	e9 70 fc ff ff       	jmp    800d07 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801097:	89 74 24 04          	mov    %esi,0x4(%esp)
  80109b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8010a2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010a7:	80 38 25             	cmpb   $0x25,(%eax)
  8010aa:	0f 84 57 fc ff ff    	je     800d07 <vprintfmt+0x2c>
  8010b0:	89 c3                	mov    %eax,%ebx
  8010b2:	eb f0                	jmp    8010a4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8010b4:	83 c4 4c             	add    $0x4c,%esp
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 28             	sub    $0x28,%esp
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	74 04                	je     8010d0 <vsnprintf+0x14>
  8010cc:	85 d2                	test   %edx,%edx
  8010ce:	7f 07                	jg     8010d7 <vsnprintf+0x1b>
  8010d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d5:	eb 3b                	jmp    801112 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010da:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8010de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fd:	c7 04 24 be 0c 80 00 	movl   $0x800cbe,(%esp)
  801104:	e8 d2 fb ff ff       	call   800cdb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80110c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80111a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80111d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	89 44 24 08          	mov    %eax,0x8(%esp)
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	89 04 24             	mov    %eax,(%esp)
  801135:	e8 82 ff ff ff       	call   8010bc <vsnprintf>
	va_end(ap);

	return rc;
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  801142:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  801145:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	89 44 24 04          	mov    %eax,0x4(%esp)
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 04 24             	mov    %eax,(%esp)
  80115d:	e8 79 fb ff ff       	call   800cdb <vprintfmt>
	va_end(ap);
}
  801162:	c9                   	leave  
  801163:	c3                   	ret    
	...

00801170 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80117b:	eb 03                	jmp    801180 <strlen+0x10>
		n++;
  80117d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801180:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801184:	75 f7                	jne    80117d <strlen+0xd>
		n++;
	return n;
}
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	53                   	push   %ebx
  80118c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80118f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801197:	eb 03                	jmp    80119c <strnlen+0x14>
		n++;
  801199:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80119c:	39 c1                	cmp    %eax,%ecx
  80119e:	74 06                	je     8011a6 <strnlen+0x1e>
  8011a0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8011a4:	75 f3                	jne    801199 <strnlen+0x11>
		n++;
	return n;
}
  8011a6:	5b                   	pop    %ebx
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	53                   	push   %ebx
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011b3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8011b8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8011bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8011bf:	83 c2 01             	add    $0x1,%edx
  8011c2:	84 c9                	test   %cl,%cl
  8011c4:	75 f2                	jne    8011b8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8011c6:	5b                   	pop    %ebx
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	53                   	push   %ebx
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8011d3:	89 1c 24             	mov    %ebx,(%esp)
  8011d6:	e8 95 ff ff ff       	call   801170 <strlen>
	strcpy(dst + len, src);
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011e2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8011e5:	89 04 24             	mov    %eax,(%esp)
  8011e8:	e8 bc ff ff ff       	call   8011a9 <strcpy>
	return dst;
}
  8011ed:	89 d8                	mov    %ebx,%eax
  8011ef:	83 c4 08             	add    $0x8,%esp
  8011f2:	5b                   	pop    %ebx
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	56                   	push   %esi
  8011f9:	53                   	push   %ebx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801200:	8b 75 10             	mov    0x10(%ebp),%esi
  801203:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801208:	eb 0f                	jmp    801219 <strncpy+0x24>
		*dst++ = *src;
  80120a:	0f b6 19             	movzbl (%ecx),%ebx
  80120d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801210:	80 39 01             	cmpb   $0x1,(%ecx)
  801213:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801216:	83 c2 01             	add    $0x1,%edx
  801219:	39 f2                	cmp    %esi,%edx
  80121b:	72 ed                	jb     80120a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	8b 75 08             	mov    0x8(%ebp),%esi
  801229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80122f:	89 f0                	mov    %esi,%eax
  801231:	85 d2                	test   %edx,%edx
  801233:	75 0a                	jne    80123f <strlcpy+0x1e>
  801235:	eb 17                	jmp    80124e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801237:	88 18                	mov    %bl,(%eax)
  801239:	83 c0 01             	add    $0x1,%eax
  80123c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80123f:	83 ea 01             	sub    $0x1,%edx
  801242:	74 07                	je     80124b <strlcpy+0x2a>
  801244:	0f b6 19             	movzbl (%ecx),%ebx
  801247:	84 db                	test   %bl,%bl
  801249:	75 ec                	jne    801237 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80124b:	c6 00 00             	movb   $0x0,(%eax)
  80124e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  801250:	5b                   	pop    %ebx
  801251:	5e                   	pop    %esi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    

00801254 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80125d:	eb 06                	jmp    801265 <strcmp+0x11>
		p++, q++;
  80125f:	83 c1 01             	add    $0x1,%ecx
  801262:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801265:	0f b6 01             	movzbl (%ecx),%eax
  801268:	84 c0                	test   %al,%al
  80126a:	74 04                	je     801270 <strcmp+0x1c>
  80126c:	3a 02                	cmp    (%edx),%al
  80126e:	74 ef                	je     80125f <strcmp+0xb>
  801270:	0f b6 c0             	movzbl %al,%eax
  801273:	0f b6 12             	movzbl (%edx),%edx
  801276:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    

0080127a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801284:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  801287:	eb 09                	jmp    801292 <strncmp+0x18>
		n--, p++, q++;
  801289:	83 ea 01             	sub    $0x1,%edx
  80128c:	83 c0 01             	add    $0x1,%eax
  80128f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801292:	85 d2                	test   %edx,%edx
  801294:	75 07                	jne    80129d <strncmp+0x23>
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
  80129b:	eb 13                	jmp    8012b0 <strncmp+0x36>
  80129d:	0f b6 18             	movzbl (%eax),%ebx
  8012a0:	84 db                	test   %bl,%bl
  8012a2:	74 04                	je     8012a8 <strncmp+0x2e>
  8012a4:	3a 19                	cmp    (%ecx),%bl
  8012a6:	74 e1                	je     801289 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a8:	0f b6 00             	movzbl (%eax),%eax
  8012ab:	0f b6 11             	movzbl (%ecx),%edx
  8012ae:	29 d0                	sub    %edx,%eax
}
  8012b0:	5b                   	pop    %ebx
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012bd:	eb 07                	jmp    8012c6 <strchr+0x13>
		if (*s == c)
  8012bf:	38 ca                	cmp    %cl,%dl
  8012c1:	74 0f                	je     8012d2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c3:	83 c0 01             	add    $0x1,%eax
  8012c6:	0f b6 10             	movzbl (%eax),%edx
  8012c9:	84 d2                	test   %dl,%dl
  8012cb:	75 f2                	jne    8012bf <strchr+0xc>
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    

008012d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012de:	eb 07                	jmp    8012e7 <strfind+0x13>
		if (*s == c)
  8012e0:	38 ca                	cmp    %cl,%dl
  8012e2:	74 0a                	je     8012ee <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e4:	83 c0 01             	add    $0x1,%eax
  8012e7:	0f b6 10             	movzbl (%eax),%edx
  8012ea:	84 d2                	test   %dl,%dl
  8012ec:	75 f2                	jne    8012e0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 0c             	sub    $0xc,%esp
  8012f6:	89 1c 24             	mov    %ebx,(%esp)
  8012f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801301:	8b 7d 08             	mov    0x8(%ebp),%edi
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80130a:	85 c9                	test   %ecx,%ecx
  80130c:	74 30                	je     80133e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80130e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801314:	75 25                	jne    80133b <memset+0x4b>
  801316:	f6 c1 03             	test   $0x3,%cl
  801319:	75 20                	jne    80133b <memset+0x4b>
		c &= 0xFF;
  80131b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80131e:	89 d3                	mov    %edx,%ebx
  801320:	c1 e3 08             	shl    $0x8,%ebx
  801323:	89 d6                	mov    %edx,%esi
  801325:	c1 e6 18             	shl    $0x18,%esi
  801328:	89 d0                	mov    %edx,%eax
  80132a:	c1 e0 10             	shl    $0x10,%eax
  80132d:	09 f0                	or     %esi,%eax
  80132f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  801331:	09 d8                	or     %ebx,%eax
  801333:	c1 e9 02             	shr    $0x2,%ecx
  801336:	fc                   	cld    
  801337:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801339:	eb 03                	jmp    80133e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80133b:	fc                   	cld    
  80133c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80133e:	89 f8                	mov    %edi,%eax
  801340:	8b 1c 24             	mov    (%esp),%ebx
  801343:	8b 74 24 04          	mov    0x4(%esp),%esi
  801347:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80134b:	89 ec                	mov    %ebp,%esp
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    

0080134f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 08             	sub    $0x8,%esp
  801355:	89 34 24             	mov    %esi,(%esp)
  801358:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  801362:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  801365:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  801367:	39 c6                	cmp    %eax,%esi
  801369:	73 35                	jae    8013a0 <memmove+0x51>
  80136b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80136e:	39 d0                	cmp    %edx,%eax
  801370:	73 2e                	jae    8013a0 <memmove+0x51>
		s += n;
		d += n;
  801372:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801374:	f6 c2 03             	test   $0x3,%dl
  801377:	75 1b                	jne    801394 <memmove+0x45>
  801379:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80137f:	75 13                	jne    801394 <memmove+0x45>
  801381:	f6 c1 03             	test   $0x3,%cl
  801384:	75 0e                	jne    801394 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  801386:	83 ef 04             	sub    $0x4,%edi
  801389:	8d 72 fc             	lea    -0x4(%edx),%esi
  80138c:	c1 e9 02             	shr    $0x2,%ecx
  80138f:	fd                   	std    
  801390:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801392:	eb 09                	jmp    80139d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801394:	83 ef 01             	sub    $0x1,%edi
  801397:	8d 72 ff             	lea    -0x1(%edx),%esi
  80139a:	fd                   	std    
  80139b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80139d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 20                	jmp    8013c0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013a0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8013a6:	75 15                	jne    8013bd <memmove+0x6e>
  8013a8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013ae:	75 0d                	jne    8013bd <memmove+0x6e>
  8013b0:	f6 c1 03             	test   $0x3,%cl
  8013b3:	75 08                	jne    8013bd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8013b5:	c1 e9 02             	shr    $0x2,%ecx
  8013b8:	fc                   	cld    
  8013b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013bb:	eb 03                	jmp    8013c0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013bd:	fc                   	cld    
  8013be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8013c0:	8b 34 24             	mov    (%esp),%esi
  8013c3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8013c7:	89 ec                	mov    %ebp,%esp
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8013d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	89 04 24             	mov    %eax,(%esp)
  8013e5:	e8 65 ff ff ff       	call   80134f <memmove>
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
  8013f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013fb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801400:	eb 1c                	jmp    80141e <memcmp+0x32>
		if (*s1 != *s2)
  801402:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  801406:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  80140a:	83 c2 01             	add    $0x1,%edx
  80140d:	83 e9 01             	sub    $0x1,%ecx
  801410:	38 d8                	cmp    %bl,%al
  801412:	74 0a                	je     80141e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  801414:	0f b6 c0             	movzbl %al,%eax
  801417:	0f b6 db             	movzbl %bl,%ebx
  80141a:	29 d8                	sub    %ebx,%eax
  80141c:	eb 09                	jmp    801427 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80141e:	85 c9                	test   %ecx,%ecx
  801420:	75 e0                	jne    801402 <memcmp+0x16>
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801427:	5b                   	pop    %ebx
  801428:	5e                   	pop    %esi
  801429:	5f                   	pop    %edi
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801435:	89 c2                	mov    %eax,%edx
  801437:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80143a:	eb 07                	jmp    801443 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  80143c:	38 08                	cmp    %cl,(%eax)
  80143e:	74 07                	je     801447 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801440:	83 c0 01             	add    $0x1,%eax
  801443:	39 d0                	cmp    %edx,%eax
  801445:	72 f5                	jb     80143c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    

00801449 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	8b 55 08             	mov    0x8(%ebp),%edx
  801455:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801458:	eb 03                	jmp    80145d <strtol+0x14>
		s++;
  80145a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80145d:	0f b6 02             	movzbl (%edx),%eax
  801460:	3c 20                	cmp    $0x20,%al
  801462:	74 f6                	je     80145a <strtol+0x11>
  801464:	3c 09                	cmp    $0x9,%al
  801466:	74 f2                	je     80145a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  801468:	3c 2b                	cmp    $0x2b,%al
  80146a:	75 0c                	jne    801478 <strtol+0x2f>
		s++;
  80146c:	8d 52 01             	lea    0x1(%edx),%edx
  80146f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801476:	eb 15                	jmp    80148d <strtol+0x44>
	else if (*s == '-')
  801478:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80147f:	3c 2d                	cmp    $0x2d,%al
  801481:	75 0a                	jne    80148d <strtol+0x44>
		s++, neg = 1;
  801483:	8d 52 01             	lea    0x1(%edx),%edx
  801486:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80148d:	85 db                	test   %ebx,%ebx
  80148f:	0f 94 c0             	sete   %al
  801492:	74 05                	je     801499 <strtol+0x50>
  801494:	83 fb 10             	cmp    $0x10,%ebx
  801497:	75 15                	jne    8014ae <strtol+0x65>
  801499:	80 3a 30             	cmpb   $0x30,(%edx)
  80149c:	75 10                	jne    8014ae <strtol+0x65>
  80149e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8014a2:	75 0a                	jne    8014ae <strtol+0x65>
		s += 2, base = 16;
  8014a4:	83 c2 02             	add    $0x2,%edx
  8014a7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ac:	eb 13                	jmp    8014c1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8014ae:	84 c0                	test   %al,%al
  8014b0:	74 0f                	je     8014c1 <strtol+0x78>
  8014b2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8014b7:	80 3a 30             	cmpb   $0x30,(%edx)
  8014ba:	75 05                	jne    8014c1 <strtol+0x78>
		s++, base = 8;
  8014bc:	83 c2 01             	add    $0x1,%edx
  8014bf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c8:	0f b6 0a             	movzbl (%edx),%ecx
  8014cb:	89 cf                	mov    %ecx,%edi
  8014cd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8014d0:	80 fb 09             	cmp    $0x9,%bl
  8014d3:	77 08                	ja     8014dd <strtol+0x94>
			dig = *s - '0';
  8014d5:	0f be c9             	movsbl %cl,%ecx
  8014d8:	83 e9 30             	sub    $0x30,%ecx
  8014db:	eb 1e                	jmp    8014fb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  8014dd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8014e0:	80 fb 19             	cmp    $0x19,%bl
  8014e3:	77 08                	ja     8014ed <strtol+0xa4>
			dig = *s - 'a' + 10;
  8014e5:	0f be c9             	movsbl %cl,%ecx
  8014e8:	83 e9 57             	sub    $0x57,%ecx
  8014eb:	eb 0e                	jmp    8014fb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  8014ed:	8d 5f bf             	lea    -0x41(%edi),%ebx
  8014f0:	80 fb 19             	cmp    $0x19,%bl
  8014f3:	77 15                	ja     80150a <strtol+0xc1>
			dig = *s - 'A' + 10;
  8014f5:	0f be c9             	movsbl %cl,%ecx
  8014f8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8014fb:	39 f1                	cmp    %esi,%ecx
  8014fd:	7d 0b                	jge    80150a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8014ff:	83 c2 01             	add    $0x1,%edx
  801502:	0f af c6             	imul   %esi,%eax
  801505:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801508:	eb be                	jmp    8014c8 <strtol+0x7f>
  80150a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80150c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801510:	74 05                	je     801517 <strtol+0xce>
		*endptr = (char *) s;
  801512:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801515:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801517:	89 ca                	mov    %ecx,%edx
  801519:	f7 da                	neg    %edx
  80151b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151f:	0f 45 c2             	cmovne %edx,%eax
}
  801522:	83 c4 04             	add    $0x4,%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    
	...

0080152c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 0c             	sub    $0xc,%esp
  801532:	89 1c 24             	mov    %ebx,(%esp)
  801535:	89 74 24 04          	mov    %esi,0x4(%esp)
  801539:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153d:	ba 00 00 00 00       	mov    $0x0,%edx
  801542:	b8 01 00 00 00       	mov    $0x1,%eax
  801547:	89 d1                	mov    %edx,%ecx
  801549:	89 d3                	mov    %edx,%ebx
  80154b:	89 d7                	mov    %edx,%edi
  80154d:	89 d6                	mov    %edx,%esi
  80154f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801551:	8b 1c 24             	mov    (%esp),%ebx
  801554:	8b 74 24 04          	mov    0x4(%esp),%esi
  801558:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80155c:	89 ec                	mov    %ebp,%esp
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 0c             	sub    $0xc,%esp
  801566:	89 1c 24             	mov    %ebx,(%esp)
  801569:	89 74 24 04          	mov    %esi,0x4(%esp)
  80156d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
  801576:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801579:	8b 55 08             	mov    0x8(%ebp),%edx
  80157c:	89 c3                	mov    %eax,%ebx
  80157e:	89 c7                	mov    %eax,%edi
  801580:	89 c6                	mov    %eax,%esi
  801582:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801584:	8b 1c 24             	mov    (%esp),%ebx
  801587:	8b 74 24 04          	mov    0x4(%esp),%esi
  80158b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80158f:	89 ec                	mov    %ebp,%esp
  801591:	5d                   	pop    %ebp
  801592:	c3                   	ret    

00801593 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	89 1c 24             	mov    %ebx,(%esp)
  80159c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015a0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	b8 10 00 00 00       	mov    $0x10,%eax
  8015ae:	89 d1                	mov    %edx,%ecx
  8015b0:	89 d3                	mov    %edx,%ebx
  8015b2:	89 d7                	mov    %edx,%edi
  8015b4:	89 d6                	mov    %edx,%esi
  8015b6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015b8:	8b 1c 24             	mov    (%esp),%ebx
  8015bb:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015bf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015c3:	89 ec                	mov    %ebp,%esp
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 38             	sub    $0x38,%esp
  8015cd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015d0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015d3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015db:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e6:	89 df                	mov    %ebx,%edi
  8015e8:	89 de                	mov    %ebx,%esi
  8015ea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	7e 28                	jle    801618 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015f4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8015fb:	00 
  8015fc:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  801603:	00 
  801604:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80160b:	00 
  80160c:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  801613:	e8 6c f4 ff ff       	call   800a84 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801618:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80161b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80161e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801621:	89 ec                	mov    %ebp,%esp
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 38             	sub    $0x38,%esp
  80162b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80162e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801631:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801634:	bb 00 00 00 00       	mov    $0x0,%ebx
  801639:	b8 0e 00 00 00       	mov    $0xe,%eax
  80163e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801641:	8b 55 08             	mov    0x8(%ebp),%edx
  801644:	89 df                	mov    %ebx,%edi
  801646:	89 de                	mov    %ebx,%esi
  801648:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80164a:	85 c0                	test   %eax,%eax
  80164c:	7e 28                	jle    801676 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80164e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801652:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801659:	00 
  80165a:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  801661:	00 
  801662:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801669:	00 
  80166a:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  801671:	e8 0e f4 ff ff       	call   800a84 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801676:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801679:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80167c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80167f:	89 ec                	mov    %ebp,%esp
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 38             	sub    $0x38,%esp
  801689:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80168c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80168f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801692:	b9 00 00 00 00       	mov    $0x0,%ecx
  801697:	b8 0d 00 00 00       	mov    $0xd,%eax
  80169c:	8b 55 08             	mov    0x8(%ebp),%edx
  80169f:	89 cb                	mov    %ecx,%ebx
  8016a1:	89 cf                	mov    %ecx,%edi
  8016a3:	89 ce                	mov    %ecx,%esi
  8016a5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	7e 28                	jle    8016d3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016af:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8016b6:	00 
  8016b7:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  8016be:	00 
  8016bf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016c6:	00 
  8016c7:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  8016ce:	e8 b1 f3 ff ff       	call   800a84 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016d6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016d9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016dc:	89 ec                	mov    %ebp,%esp
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	89 1c 24             	mov    %ebx,(%esp)
  8016e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ed:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f1:	be 00 00 00 00       	mov    $0x0,%esi
  8016f6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8016fb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801701:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801704:	8b 55 08             	mov    0x8(%ebp),%edx
  801707:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801709:	8b 1c 24             	mov    (%esp),%ebx
  80170c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801710:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801714:	89 ec                	mov    %ebp,%esp
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    

00801718 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 38             	sub    $0x38,%esp
  80171e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801721:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801724:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801727:	bb 00 00 00 00       	mov    $0x0,%ebx
  80172c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801731:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801734:	8b 55 08             	mov    0x8(%ebp),%edx
  801737:	89 df                	mov    %ebx,%edi
  801739:	89 de                	mov    %ebx,%esi
  80173b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80173d:	85 c0                	test   %eax,%eax
  80173f:	7e 28                	jle    801769 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801741:	89 44 24 10          	mov    %eax,0x10(%esp)
  801745:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80174c:	00 
  80174d:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  801754:	00 
  801755:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80175c:	00 
  80175d:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  801764:	e8 1b f3 ff ff       	call   800a84 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801769:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80176c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80176f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801772:	89 ec                	mov    %ebp,%esp
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 38             	sub    $0x38,%esp
  80177c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80177f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801782:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801785:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178a:	b8 09 00 00 00       	mov    $0x9,%eax
  80178f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801792:	8b 55 08             	mov    0x8(%ebp),%edx
  801795:	89 df                	mov    %ebx,%edi
  801797:	89 de                	mov    %ebx,%esi
  801799:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	7e 28                	jle    8017c7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80179f:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017a3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8017aa:	00 
  8017ab:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  8017b2:	00 
  8017b3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017ba:	00 
  8017bb:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  8017c2:	e8 bd f2 ff ff       	call   800a84 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8017c7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017ca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017cd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017d0:	89 ec                	mov    %ebp,%esp
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 38             	sub    $0x38,%esp
  8017da:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017dd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017e0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8017ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f3:	89 df                	mov    %ebx,%edi
  8017f5:	89 de                	mov    %ebx,%esi
  8017f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	7e 28                	jle    801825 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801801:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801808:	00 
  801809:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  801810:	00 
  801811:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801818:	00 
  801819:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  801820:	e8 5f f2 ff ff       	call   800a84 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801825:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801828:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80182b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80182e:	89 ec                	mov    %ebp,%esp
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 38             	sub    $0x38,%esp
  801838:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80183b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80183e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801841:	bb 00 00 00 00       	mov    $0x0,%ebx
  801846:	b8 06 00 00 00       	mov    $0x6,%eax
  80184b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184e:	8b 55 08             	mov    0x8(%ebp),%edx
  801851:	89 df                	mov    %ebx,%edi
  801853:	89 de                	mov    %ebx,%esi
  801855:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801857:	85 c0                	test   %eax,%eax
  801859:	7e 28                	jle    801883 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80185b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80185f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801866:	00 
  801867:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  80186e:	00 
  80186f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801876:	00 
  801877:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  80187e:	e8 01 f2 ff ff       	call   800a84 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801883:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801886:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801889:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80188c:	89 ec                	mov    %ebp,%esp
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 38             	sub    $0x38,%esp
  801896:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801899:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80189c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189f:	b8 05 00 00 00       	mov    $0x5,%eax
  8018a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	7e 28                	jle    8018e1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018bd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8018c4:	00 
  8018c5:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  8018cc:	00 
  8018cd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018d4:	00 
  8018d5:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  8018dc:	e8 a3 f1 ff ff       	call   800a84 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8018e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018ea:	89 ec                	mov    %ebp,%esp
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 38             	sub    $0x38,%esp
  8018f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018fd:	be 00 00 00 00       	mov    $0x0,%esi
  801902:	b8 04 00 00 00       	mov    $0x4,%eax
  801907:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80190a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190d:	8b 55 08             	mov    0x8(%ebp),%edx
  801910:	89 f7                	mov    %esi,%edi
  801912:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801914:	85 c0                	test   %eax,%eax
  801916:	7e 28                	jle    801940 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801918:	89 44 24 10          	mov    %eax,0x10(%esp)
  80191c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801923:	00 
  801924:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  80192b:	00 
  80192c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801933:	00 
  801934:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  80193b:	e8 44 f1 ff ff       	call   800a84 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801940:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801943:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801946:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801949:	89 ec                	mov    %ebp,%esp
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	89 1c 24             	mov    %ebx,(%esp)
  801956:	89 74 24 04          	mov    %esi,0x4(%esp)
  80195a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80195e:	ba 00 00 00 00       	mov    $0x0,%edx
  801963:	b8 0b 00 00 00       	mov    $0xb,%eax
  801968:	89 d1                	mov    %edx,%ecx
  80196a:	89 d3                	mov    %edx,%ebx
  80196c:	89 d7                	mov    %edx,%edi
  80196e:	89 d6                	mov    %edx,%esi
  801970:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801972:	8b 1c 24             	mov    (%esp),%ebx
  801975:	8b 74 24 04          	mov    0x4(%esp),%esi
  801979:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80197d:	89 ec                	mov    %ebp,%esp
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    

00801981 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 0c             	sub    $0xc,%esp
  801987:	89 1c 24             	mov    %ebx,(%esp)
  80198a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80198e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
  801997:	b8 02 00 00 00       	mov    $0x2,%eax
  80199c:	89 d1                	mov    %edx,%ecx
  80199e:	89 d3                	mov    %edx,%ebx
  8019a0:	89 d7                	mov    %edx,%edi
  8019a2:	89 d6                	mov    %edx,%esi
  8019a4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8019a6:	8b 1c 24             	mov    (%esp),%ebx
  8019a9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8019ad:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8019b1:	89 ec                	mov    %ebp,%esp
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 38             	sub    $0x38,%esp
  8019bb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019be:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019c1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d1:	89 cb                	mov    %ecx,%ebx
  8019d3:	89 cf                	mov    %ecx,%edi
  8019d5:	89 ce                	mov    %ecx,%esi
  8019d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	7e 28                	jle    801a05 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019e1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8019e8:	00 
  8019e9:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  8019f0:	00 
  8019f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019f8:	00 
  8019f9:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  801a00:	e8 7f f0 ff ff       	call   800a84 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801a05:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a08:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a0b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a0e:	89 ec                	mov    %ebp,%esp
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    
	...

00801a14 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801a1a:	c7 44 24 08 52 2a 80 	movl   $0x802a52,0x8(%esp)
  801a21:	00 
  801a22:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801a29:	00 
  801a2a:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801a31:	e8 4e f0 ff ff       	call   800a84 <_panic>

00801a36 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	57                   	push   %edi
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 4c             	sub    $0x4c,%esp
	// LAB 4: Your code here.	
	uintptr_t addr;
	int ret;
	size_t i,j;
	
	set_pgfault_handler(pgfault);
  801a3f:	c7 04 24 a4 1c 80 00 	movl   $0x801ca4,(%esp)
  801a46:	e8 71 07 00 00       	call   8021bc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801a4b:	ba 07 00 00 00       	mov    $0x7,%edx
  801a50:	89 d0                	mov    %edx,%eax
  801a52:	cd 30                	int    $0x30
  801a54:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	envid_t envid = sys_exofork();
	if (envid < 0)
  801a57:	85 c0                	test   %eax,%eax
  801a59:	79 20                	jns    801a7b <fork+0x45>
		panic("sys_exofork: %e", envid);
  801a5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5f:	c7 44 24 08 73 2a 80 	movl   $0x802a73,0x8(%esp)
  801a66:	00 
  801a67:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801a6e:	00 
  801a6f:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801a76:	e8 09 f0 ff ff       	call   800a84 <_panic>
	if (envid == 0) 
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
  801a7b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
				if(addr == UXSTACKTOP-PGSIZE) continue;
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801a82:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	if (envid < 0)
		panic("sys_exofork: %e", envid);
	if (envid == 0) 
  801a87:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a8b:	75 21                	jne    801aae <fork+0x78>
	{
		// We're the child.
		thisenv = &envs[ENVX(sys_getenvid())];
  801a8d:	e8 ef fe ff ff       	call   801981 <sys_getenvid>
  801a92:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a97:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a9a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a9f:	a3 1c 40 80 00       	mov    %eax,0x80401c
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  801aa9:	e9 e5 01 00 00       	jmp    801c93 <fork+0x25d>
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
	{
		if(uvpd[i] & PTE_P && i != PDX(UVPT))
  801aae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ab1:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801ab8:	a8 01                	test   $0x1,%al
  801aba:	0f 84 4c 01 00 00    	je     801c0c <fork+0x1d6>
  801ac0:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
  801ac6:	0f 84 cf 01 00 00    	je     801c9b <fork+0x265>
		{
			addr = i << PDXSHIFT;
  801acc:	c1 e2 16             	shl    $0x16,%edx
  801acf:	89 55 e0             	mov    %edx,-0x20(%ebp)
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
  801ad2:	89 d3                	mov    %edx,%ebx
  801ad4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801adb:	00 
  801adc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ae0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ae3:	89 04 24             	mov    %eax,(%esp)
  801ae6:	e8 03 fe ff ff       	call   8018ee <sys_page_alloc>
			if(ret < 0) return ret;
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	0f 88 a0 01 00 00    	js     801c93 <fork+0x25d>
			ret = sys_page_unmap(envid,(void *)addr);
  801af3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801af7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801afa:	89 14 24             	mov    %edx,(%esp)
  801afd:	e8 30 fd ff ff       	call   801832 <sys_page_unmap>
			if(ret < 0) return ret;
  801b02:	85 c0                	test   %eax,%eax
  801b04:	0f 88 89 01 00 00    	js     801c93 <fork+0x25d>
  801b0a:	bb 00 00 00 00       	mov    $0x0,%ebx

			for(j=0;j<NPTENTRIES;j++)
			{
				addr = (i<<PDXSHIFT)+(j<<PGSHIFT);
  801b0f:	89 de                	mov    %ebx,%esi
  801b11:	c1 e6 0c             	shl    $0xc,%esi
  801b14:	03 75 e0             	add    -0x20(%ebp),%esi
				if(addr == UXSTACKTOP-PGSIZE) continue;
  801b17:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  801b1d:	0f 84 da 00 00 00    	je     801bfd <fork+0x1c7>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
  801b23:	c1 ee 0c             	shr    $0xc,%esi
  801b26:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801b29:	a8 01                	test   $0x1,%al
  801b2b:	0f 84 cc 00 00 00    	je     801bfd <fork+0x1c7>
static int
duppage(envid_t envid, unsigned pn)
{
	int ret;
	int perm;
	uint32_t va = pn << PGSHIFT;
  801b31:	89 f0                	mov    %esi,%eax
  801b33:	c1 e0 0c             	shl    $0xc,%eax
  801b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t curr_envid = sys_getenvid();
  801b39:	e8 43 fe ff ff       	call   801981 <sys_getenvid>
  801b3e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	// LAB 4: Your code here.
	perm = uvpt[pn] & 0xFFF;
  801b41:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801b44:	89 c6                	mov    %eax,%esi
  801b46:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	
	if((perm & PTE_P) && ( perm & PTE_SHARE))
  801b4c:	25 01 04 00 00       	and    $0x401,%eax
  801b51:	3d 01 04 00 00       	cmp    $0x401,%eax
  801b56:	75 3a                	jne    801b92 <fork+0x15c>
	{
		perm = sys_page_map(curr_envid, (void *)va, envid, (void *)va, PTE_AVAIL|PTE_P|PTE_U|PTE_W);
  801b58:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  801b5f:	00 
  801b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b72:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b75:	89 14 24             	mov    %edx,(%esp)
  801b78:	e8 13 fd ff ff       	call   801890 <sys_page_map>
		if(ret)	panic("sys_page_map: %e", ret);
		cprintf("copy shared page : %x\n",va);
  801b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b84:	c7 04 24 83 2a 80 00 	movl   $0x802a83,(%esp)
  801b8b:	e8 ad ef ff ff       	call   800b3d <cprintf>
  801b90:	eb 6b                	jmp    801bfd <fork+0x1c7>
		return ret;
	}	
	if((perm & PTE_P) && (( perm & PTE_W) || (perm & PTE_COW)))
  801b92:	f7 c6 01 00 00 00    	test   $0x1,%esi
  801b98:	74 14                	je     801bae <fork+0x178>
  801b9a:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801ba0:	74 0c                	je     801bae <fork+0x178>
	{
		perm = (perm & (~PTE_W)) | PTE_COW;
  801ba2:	81 e6 fd f7 ff ff    	and    $0xfffff7fd,%esi
  801ba8:	81 ce 00 08 00 00    	or     $0x800,%esi
		//cprintf("copy cow page : %x\n",va);
	}
	ret = sys_page_map(curr_envid, (void *)va, envid, (void *)va, perm);
  801bae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb1:	89 74 24 10          	mov    %esi,0x10(%esp)
  801bb5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801bc7:	89 14 24             	mov    %edx,(%esp)
  801bca:	e8 c1 fc ff ff       	call   801890 <sys_page_map>
	if(ret<0) return ret;
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	0f 88 bc 00 00 00    	js     801c93 <fork+0x25d>

	ret = sys_page_map(curr_envid, (void *)va, curr_envid, (void *)va, perm);
  801bd7:	89 74 24 10          	mov    %esi,0x10(%esp)
  801bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bde:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801be5:	89 54 24 08          	mov    %edx,0x8(%esp)
  801be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bed:	89 14 24             	mov    %edx,(%esp)
  801bf0:	e8 9b fc ff ff       	call   801890 <sys_page_map>
				
				if(uvpt[addr>>PGSHIFT] & PTE_P)
				{
					//cprintf("we are trying to alloc %x\n",addr);		
					ret = duppage(envid,addr>>PGSHIFT);
					if(ret < 0) return ret;
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	0f 88 96 00 00 00    	js     801c93 <fork+0x25d>
			ret = sys_page_alloc(envid,(void *)addr,PTE_P|PTE_U|PTE_W);
			if(ret < 0) return ret;
			ret = sys_page_unmap(envid,(void *)addr);
			if(ret < 0) return ret;

			for(j=0;j<NPTENTRIES;j++)
  801bfd:	83 c3 01             	add    $0x1,%ebx
  801c00:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801c06:	0f 85 03 ff ff ff    	jne    801b0f <fork+0xd9>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  801c0c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801c10:	81 7d d8 bb 03 00 00 	cmpl   $0x3bb,-0x28(%ebp)
  801c17:	0f 85 91 fe ff ff    	jne    801aae <fork+0x78>
			}
		}
	}

	// Allocate a new user exception stack.
	ret = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W);
  801c1d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c24:	00 
  801c25:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801c2c:	ee 
  801c2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c30:	89 04 24             	mov    %eax,(%esp)
  801c33:	e8 b6 fc ff ff       	call   8018ee <sys_page_alloc>
	if(ret < 0) return ret;
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	78 57                	js     801c93 <fork+0x25d>

	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
  801c3c:	a1 1c 40 80 00       	mov    0x80401c,%eax
  801c41:	8b 40 64             	mov    0x64(%eax),%eax
  801c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c48:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801c4b:	89 14 24             	mov    %edx,(%esp)
  801c4e:	e8 c5 fa ff ff       	call   801718 <sys_env_set_pgfault_upcall>
	if(ret < 0) return ret;
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 3c                	js     801c93 <fork+0x25d>
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801c57:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801c5e:	00 
  801c5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c62:	89 04 24             	mov    %eax,(%esp)
  801c65:	e8 6a fb ff ff       	call   8017d4 <sys_env_set_status>
  801c6a:	89 c2                	mov    %eax,%edx
		panic("sys_env_set_status: %e", ret);
  801c6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	//copy page fault handler
	ret = sys_env_set_pgfault_upcall(envid,thisenv->env_pgfault_upcall);
	if(ret < 0) return ret;
	
	// Start the child environment running
	if ((ret = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801c6f:	85 d2                	test   %edx,%edx
  801c71:	79 20                	jns    801c93 <fork+0x25d>
		panic("sys_env_set_status: %e", ret);
  801c73:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c77:	c7 44 24 08 9a 2a 80 	movl   $0x802a9a,0x8(%esp)
  801c7e:	00 
  801c7f:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801c86:	00 
  801c87:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801c8e:	e8 f1 ed ff ff       	call   800a84 <_panic>

	return envid;
}
  801c93:	83 c4 4c             	add    $0x4c,%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5f                   	pop    %edi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// We're the parent.
	for(i=0;i<PDX(UTOP);i++)
  801c9b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  801c9f:	e9 0a fe ff ff       	jmp    801aae <fork+0x78>

00801ca4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	56                   	push   %esi
  801ca8:	53                   	push   %ebx
  801ca9:	83 ec 20             	sub    $0x20,%esp
	void *addr;
	uint32_t err = utf->utf_err;
	int ret;
	envid_t envid = sys_getenvid();
  801cac:	e8 d0 fc ff ff       	call   801981 <sys_getenvid>
  801cb1:	89 c3                	mov    %eax,%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	8b 00                	mov    (%eax),%eax
  801cb8:	89 c6                	mov    %eax,%esi
  801cba:	c1 ee 0c             	shr    $0xc,%esi
	addr = (void *) (vp << PGSHIFT);
	
	if(!(uvpt[vp] & PTE_W) && !(uvpt[vp] & PTE_COW))
  801cbd:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801cc4:	f6 c2 02             	test   $0x2,%dl
  801cc7:	75 2c                	jne    801cf5 <pgfault+0x51>
  801cc9:	8b 14 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%edx
  801cd0:	f6 c6 08             	test   $0x8,%dh
  801cd3:	75 20                	jne    801cf5 <pgfault+0x51>
		panic("page %x is not set cow or write\n",utf->utf_fault_va);
  801cd5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cd9:	c7 44 24 08 e8 2a 80 	movl   $0x802ae8,0x8(%esp)
  801ce0:	00 
  801ce1:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801ce8:	00 
  801ce9:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801cf0:	e8 8f ed ff ff       	call   800a84 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cf5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801cfc:	00 
  801cfd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d04:	00 
  801d05:	89 1c 24             	mov    %ebx,(%esp)
  801d08:	e8 e1 fb ff ff       	call   8018ee <sys_page_alloc>
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	79 20                	jns    801d31 <pgfault+0x8d>
		panic("pgfault alloc: %e", ret);
  801d11:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d15:	c7 44 24 08 b1 2a 80 	movl   $0x802ab1,0x8(%esp)
  801d1c:	00 
  801d1d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801d24:	00 
  801d25:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801d2c:	e8 53 ed ff ff       	call   800a84 <_panic>
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.

	uint32_t vp = utf->utf_fault_va >> PGSHIFT;
	addr = (void *) (vp << PGSHIFT);
  801d31:	c1 e6 0c             	shl    $0xc,%esi
	// LAB 4: Your code here.
	
	if ((ret = sys_page_alloc(envid, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("pgfault alloc: %e", ret);

	memmove((void *)UTEMP, addr, PGSIZE);
  801d34:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d3b:	00 
  801d3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d40:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801d47:	e8 03 f6 ff ff       	call   80134f <memmove>
	if ((ret = sys_page_map(envid, UTEMP, envid, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801d4c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d53:	00 
  801d54:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d58:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d5c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d63:	00 
  801d64:	89 1c 24             	mov    %ebx,(%esp)
  801d67:	e8 24 fb ff ff       	call   801890 <sys_page_map>
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	79 20                	jns    801d90 <pgfault+0xec>
		panic("pgfault map: %e", ret);	
  801d70:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d74:	c7 44 24 08 c3 2a 80 	movl   $0x802ac3,0x8(%esp)
  801d7b:	00 
  801d7c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801d83:	00 
  801d84:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801d8b:	e8 f4 ec ff ff       	call   800a84 <_panic>

	ret = sys_page_unmap(envid,(void *)UTEMP);
  801d90:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d97:	00 
  801d98:	89 1c 24             	mov    %ebx,(%esp)
  801d9b:	e8 92 fa ff ff       	call   801832 <sys_page_unmap>
	if(ret) panic("pgfault unmap: %e", ret);
  801da0:	85 c0                	test   %eax,%eax
  801da2:	74 20                	je     801dc4 <pgfault+0x120>
  801da4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801da8:	c7 44 24 08 d3 2a 80 	movl   $0x802ad3,0x8(%esp)
  801daf:	00 
  801db0:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801db7:	00 
  801db8:	c7 04 24 68 2a 80 00 	movl   $0x802a68,(%esp)
  801dbf:	e8 c0 ec ff ff       	call   800a84 <_panic>

}
  801dc4:	83 c4 20             	add    $0x20,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    
	...

00801dcc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801dd7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dda:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  801de0:	8b 12                	mov    (%edx),%edx
  801de2:	39 ca                	cmp    %ecx,%edx
  801de4:	75 0c                	jne    801df2 <ipc_find_env+0x26>
			return envs[i].env_id;
  801de6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801de9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  801dee:	8b 00                	mov    (%eax),%eax
  801df0:	eb 0e                	jmp    801e00 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801df2:	83 c0 01             	add    $0x1,%eax
  801df5:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dfa:	75 db                	jne    801dd7 <ipc_find_env+0xb>
  801dfc:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 2c             	sub    $0x2c,%esp
  801e0b:	8b 75 08             	mov    0x8(%ebp),%esi
  801e0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  801e14:	85 db                	test   %ebx,%ebx
  801e16:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e1b:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  801e1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e29:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e2d:	89 34 24             	mov    %esi,(%esp)
  801e30:	e8 ab f8 ff ff       	call   8016e0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  801e35:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e38:	74 e4                	je     801e1e <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	74 28                	je     801e66 <ipc_send+0x64>
  801e3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e42:	c7 44 24 0c 29 2b 80 	movl   $0x802b29,0xc(%esp)
  801e49:	00 
  801e4a:	c7 44 24 08 0c 2b 80 	movl   $0x802b0c,0x8(%esp)
  801e51:	00 
  801e52:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801e59:	00 
  801e5a:	c7 04 24 1f 2b 80 00 	movl   $0x802b1f,(%esp)
  801e61:	e8 1e ec ff ff       	call   800a84 <_panic>
	//if(!ret) sys_yield();
}
  801e66:	83 c4 2c             	add    $0x2c,%esp
  801e69:	5b                   	pop    %ebx
  801e6a:	5e                   	pop    %esi
  801e6b:	5f                   	pop    %edi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 28             	sub    $0x28,%esp
  801e74:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801e77:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801e7a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801e7d:	8b 75 08             	mov    0x8(%ebp),%esi
  801e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e83:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  801e86:	85 c0                	test   %eax,%eax
  801e88:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e8d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801e90:	89 04 24             	mov    %eax,(%esp)
  801e93:	e8 eb f7 ff ff       	call   801683 <sys_ipc_recv>
  801e98:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  801e9a:	e8 e2 fa ff ff       	call   801981 <sys_getenvid>
  801e9f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ea4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ea7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801eac:	a3 1c 40 80 00       	mov    %eax,0x80401c
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  801eb1:	85 f6                	test   %esi,%esi
  801eb3:	74 0e                	je     801ec3 <ipc_recv+0x55>
  801eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eba:	85 db                	test   %ebx,%ebx
  801ebc:	75 03                	jne    801ec1 <ipc_recv+0x53>
  801ebe:	8b 50 74             	mov    0x74(%eax),%edx
  801ec1:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  801ec3:	85 ff                	test   %edi,%edi
  801ec5:	74 13                	je     801eda <ipc_recv+0x6c>
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	85 db                	test   %ebx,%ebx
  801ece:	75 08                	jne    801ed8 <ipc_recv+0x6a>
  801ed0:	a1 1c 40 80 00       	mov    0x80401c,%eax
  801ed5:	8b 40 78             	mov    0x78(%eax),%eax
  801ed8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  801eda:	85 db                	test   %ebx,%ebx
  801edc:	75 08                	jne    801ee6 <ipc_recv+0x78>
  801ede:	a1 1c 40 80 00       	mov    0x80401c,%eax
  801ee3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  801ee6:	89 d8                	mov    %ebx,%eax
  801ee8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801eeb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801eee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ef1:	89 ec                	mov    %ebp,%esp
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
  801ef5:	00 00                	add    %al,(%eax)
	...

00801ef8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	53                   	push   %ebx
  801efc:	83 ec 14             	sub    $0x14,%esp
  801eff:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f01:	83 3d 18 40 80 00 00 	cmpl   $0x0,0x804018
  801f08:	75 11                	jne    801f1b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f0a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f11:	e8 b6 fe ff ff       	call   801dcc <ipc_find_env>
  801f16:	a3 18 40 80 00       	mov    %eax,0x804018
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f1b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f22:	00 
  801f23:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801f2a:	00 
  801f2b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f2f:	a1 18 40 80 00       	mov    0x804018,%eax
  801f34:	89 04 24             	mov    %eax,(%esp)
  801f37:	e8 c6 fe ff ff       	call   801e02 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f3c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f43:	00 
  801f44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f4b:	00 
  801f4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f53:	e8 16 ff ff ff       	call   801e6e <ipc_recv>
}
  801f58:	83 c4 14             	add    $0x14,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    

00801f5e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f74:	8b 45 10             	mov    0x10(%ebp),%eax
  801f77:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f7c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f81:	e8 72 ff ff ff       	call   801ef8 <nsipc>
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f9e:	b8 06 00 00 00       	mov    $0x6,%eax
  801fa3:	e8 50 ff ff ff       	call   801ef8 <nsipc>
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fb8:	b8 04 00 00 00       	mov    $0x4,%eax
  801fbd:	e8 36 ff ff ff       	call   801ef8 <nsipc>
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fda:	b8 03 00 00 00       	mov    $0x3,%eax
  801fdf:	e8 14 ff ff ff       	call   801ef8 <nsipc>
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	53                   	push   %ebx
  801fea:	83 ec 14             	sub    $0x14,%esp
  801fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ff8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ffe:	7e 24                	jle    802024 <nsipc_send+0x3e>
  802000:	c7 44 24 0c 32 2b 80 	movl   $0x802b32,0xc(%esp)
  802007:	00 
  802008:	c7 44 24 08 3e 2b 80 	movl   $0x802b3e,0x8(%esp)
  80200f:	00 
  802010:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802017:	00 
  802018:	c7 04 24 53 2b 80 00 	movl   $0x802b53,(%esp)
  80201f:	e8 60 ea ff ff       	call   800a84 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802024:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202f:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  802036:	e8 14 f3 ff ff       	call   80134f <memmove>
	nsipcbuf.send.req_size = size;
  80203b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802041:	8b 45 14             	mov    0x14(%ebp),%eax
  802044:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802049:	b8 08 00 00 00       	mov    $0x8,%eax
  80204e:	e8 a5 fe ff ff       	call   801ef8 <nsipc>
}
  802053:	83 c4 14             	add    $0x14,%esp
  802056:	5b                   	pop    %ebx
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    

00802059 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	56                   	push   %esi
  80205d:	53                   	push   %ebx
  80205e:	83 ec 10             	sub    $0x10,%esp
  802061:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80206c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802072:	8b 45 14             	mov    0x14(%ebp),%eax
  802075:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80207a:	b8 07 00 00 00       	mov    $0x7,%eax
  80207f:	e8 74 fe ff ff       	call   801ef8 <nsipc>
  802084:	89 c3                	mov    %eax,%ebx
  802086:	85 c0                	test   %eax,%eax
  802088:	78 46                	js     8020d0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80208a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80208f:	7f 04                	jg     802095 <nsipc_recv+0x3c>
  802091:	39 c6                	cmp    %eax,%esi
  802093:	7d 24                	jge    8020b9 <nsipc_recv+0x60>
  802095:	c7 44 24 0c 5f 2b 80 	movl   $0x802b5f,0xc(%esp)
  80209c:	00 
  80209d:	c7 44 24 08 3e 2b 80 	movl   $0x802b3e,0x8(%esp)
  8020a4:	00 
  8020a5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8020ac:	00 
  8020ad:	c7 04 24 53 2b 80 00 	movl   $0x802b53,(%esp)
  8020b4:	e8 cb e9 ff ff       	call   800a84 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020bd:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8020c4:	00 
  8020c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c8:	89 04 24             	mov    %eax,(%esp)
  8020cb:	e8 7f f2 ff ff       	call   80134f <memmove>
	}

	return r;
}
  8020d0:	89 d8                	mov    %ebx,%eax
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	5b                   	pop    %ebx
  8020d6:	5e                   	pop    %esi
  8020d7:	5d                   	pop    %ebp
  8020d8:	c3                   	ret    

008020d9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	53                   	push   %ebx
  8020dd:	83 ec 14             	sub    $0x14,%esp
  8020e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f6:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8020fd:	e8 4d f2 ff ff       	call   80134f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802102:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802108:	b8 05 00 00 00       	mov    $0x5,%eax
  80210d:	e8 e6 fd ff ff       	call   801ef8 <nsipc>
}
  802112:	83 c4 14             	add    $0x14,%esp
  802115:	5b                   	pop    %ebx
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    

00802118 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	53                   	push   %ebx
  80211c:	83 ec 14             	sub    $0x14,%esp
  80211f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80212a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	89 44 24 04          	mov    %eax,0x4(%esp)
  802135:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80213c:	e8 0e f2 ff ff       	call   80134f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802141:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802147:	b8 02 00 00 00       	mov    $0x2,%eax
  80214c:	e8 a7 fd ff ff       	call   801ef8 <nsipc>
}
  802151:	83 c4 14             	add    $0x14,%esp
  802154:	5b                   	pop    %ebx
  802155:	5d                   	pop    %ebp
  802156:	c3                   	ret    

00802157 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 28             	sub    $0x28,%esp
  80215d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802160:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802163:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802166:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802171:	8b 07                	mov    (%edi),%eax
  802173:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802178:	b8 01 00 00 00       	mov    $0x1,%eax
  80217d:	e8 76 fd ff ff       	call   801ef8 <nsipc>
  802182:	89 c6                	mov    %eax,%esi
  802184:	85 c0                	test   %eax,%eax
  802186:	78 22                	js     8021aa <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802188:	bb 10 60 80 00       	mov    $0x806010,%ebx
  80218d:	8b 03                	mov    (%ebx),%eax
  80218f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802193:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80219a:	00 
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 a9 f1 ff ff       	call   80134f <memmove>
		*addrlen = ret->ret_addrlen;
  8021a6:	8b 03                	mov    (%ebx),%eax
  8021a8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8021aa:	89 f0                	mov    %esi,%eax
  8021ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8021af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8021b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8021b5:	89 ec                	mov    %ebp,%esp
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    
  8021b9:	00 00                	add    %al,(%eax)
	...

008021bc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	53                   	push   %ebx
  8021c0:	83 ec 24             	sub    $0x24,%esp
	int ret;

	if (_pgfault_handler == 0) {
  8021c3:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8021ca:	75 5b                	jne    802227 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
		envid_t envid = sys_getenvid();
  8021cc:	e8 b0 f7 ff ff       	call   801981 <sys_getenvid>
  8021d1:	89 c3                	mov    %eax,%ebx
		ret = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  8021d3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021da:	00 
  8021db:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8021e2:	ee 
  8021e3:	89 04 24             	mov    %eax,(%esp)
  8021e6:	e8 03 f7 ff ff       	call   8018ee <sys_page_alloc>
		if(ret) panic("%s sys_page_alloc err %e",__func__,ret);
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	74 28                	je     802217 <set_pgfault_handler+0x5b>
  8021ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021f3:	c7 44 24 0c 9b 2b 80 	movl   $0x802b9b,0xc(%esp)
  8021fa:	00 
  8021fb:	c7 44 24 08 74 2b 80 	movl   $0x802b74,0x8(%esp)
  802202:	00 
  802203:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80220a:	00 
  80220b:	c7 04 24 8d 2b 80 00 	movl   $0x802b8d,(%esp)
  802212:	e8 6d e8 ff ff       	call   800a84 <_panic>
		
		sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802217:	c7 44 24 04 38 22 80 	movl   $0x802238,0x4(%esp)
  80221e:	00 
  80221f:	89 1c 24             	mov    %ebx,(%esp)
  802222:	e8 f1 f4 ff ff       	call   801718 <sys_env_set_pgfault_upcall>
		if(ret) panic("%s sys_env_set_pgfault_upcall err %e",__func__,ret);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	a3 00 70 80 00       	mov    %eax,0x807000
	
}
  80222f:	83 c4 24             	add    $0x24,%esp
  802232:	5b                   	pop    %ebx
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	00 00                	add    %al,(%eax)
	...

00802238 <_pgfault_upcall>:
  802238:	54                   	push   %esp
  802239:	a1 00 70 80 00       	mov    0x807000,%eax
  80223e:	ff d0                	call   *%eax
  802240:	83 c4 04             	add    $0x4,%esp
  802243:	83 c4 08             	add    $0x8,%esp
  802246:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  80224a:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  80224e:	89 59 fc             	mov    %ebx,-0x4(%ecx)
  802251:	83 e9 04             	sub    $0x4,%ecx
  802254:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  802258:	61                   	popa   
  802259:	83 c4 04             	add    $0x4,%esp
  80225c:	9d                   	popf   
  80225d:	5c                   	pop    %esp
  80225e:	c3                   	ret    
	...

00802260 <__udivdi3>:
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	57                   	push   %edi
  802264:	56                   	push   %esi
  802265:	83 ec 10             	sub    $0x10,%esp
  802268:	8b 45 14             	mov    0x14(%ebp),%eax
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	8b 75 10             	mov    0x10(%ebp),%esi
  802271:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802274:	85 c0                	test   %eax,%eax
  802276:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802279:	75 35                	jne    8022b0 <__udivdi3+0x50>
  80227b:	39 fe                	cmp    %edi,%esi
  80227d:	77 61                	ja     8022e0 <__udivdi3+0x80>
  80227f:	85 f6                	test   %esi,%esi
  802281:	75 0b                	jne    80228e <__udivdi3+0x2e>
  802283:	b8 01 00 00 00       	mov    $0x1,%eax
  802288:	31 d2                	xor    %edx,%edx
  80228a:	f7 f6                	div    %esi
  80228c:	89 c6                	mov    %eax,%esi
  80228e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802291:	31 d2                	xor    %edx,%edx
  802293:	89 f8                	mov    %edi,%eax
  802295:	f7 f6                	div    %esi
  802297:	89 c7                	mov    %eax,%edi
  802299:	89 c8                	mov    %ecx,%eax
  80229b:	f7 f6                	div    %esi
  80229d:	89 c1                	mov    %eax,%ecx
  80229f:	89 fa                	mov    %edi,%edx
  8022a1:	89 c8                	mov    %ecx,%eax
  8022a3:	83 c4 10             	add    $0x10,%esp
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    
  8022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b0:	39 f8                	cmp    %edi,%eax
  8022b2:	77 1c                	ja     8022d0 <__udivdi3+0x70>
  8022b4:	0f bd d0             	bsr    %eax,%edx
  8022b7:	83 f2 1f             	xor    $0x1f,%edx
  8022ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8022bd:	75 39                	jne    8022f8 <__udivdi3+0x98>
  8022bf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8022c2:	0f 86 a0 00 00 00    	jbe    802368 <__udivdi3+0x108>
  8022c8:	39 f8                	cmp    %edi,%eax
  8022ca:	0f 82 98 00 00 00    	jb     802368 <__udivdi3+0x108>
  8022d0:	31 ff                	xor    %edi,%edi
  8022d2:	31 c9                	xor    %ecx,%ecx
  8022d4:	89 c8                	mov    %ecx,%eax
  8022d6:	89 fa                	mov    %edi,%edx
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	5e                   	pop    %esi
  8022dc:	5f                   	pop    %edi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    
  8022df:	90                   	nop
  8022e0:	89 d1                	mov    %edx,%ecx
  8022e2:	89 fa                	mov    %edi,%edx
  8022e4:	89 c8                	mov    %ecx,%eax
  8022e6:	31 ff                	xor    %edi,%edi
  8022e8:	f7 f6                	div    %esi
  8022ea:	89 c1                	mov    %eax,%ecx
  8022ec:	89 fa                	mov    %edi,%edx
  8022ee:	89 c8                	mov    %ecx,%eax
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	5e                   	pop    %esi
  8022f4:	5f                   	pop    %edi
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    
  8022f7:	90                   	nop
  8022f8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8022fc:	89 f2                	mov    %esi,%edx
  8022fe:	d3 e0                	shl    %cl,%eax
  802300:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802303:	b8 20 00 00 00       	mov    $0x20,%eax
  802308:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80230b:	89 c1                	mov    %eax,%ecx
  80230d:	d3 ea                	shr    %cl,%edx
  80230f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802313:	0b 55 ec             	or     -0x14(%ebp),%edx
  802316:	d3 e6                	shl    %cl,%esi
  802318:	89 c1                	mov    %eax,%ecx
  80231a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80231d:	89 fe                	mov    %edi,%esi
  80231f:	d3 ee                	shr    %cl,%esi
  802321:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802325:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232b:	d3 e7                	shl    %cl,%edi
  80232d:	89 c1                	mov    %eax,%ecx
  80232f:	d3 ea                	shr    %cl,%edx
  802331:	09 d7                	or     %edx,%edi
  802333:	89 f2                	mov    %esi,%edx
  802335:	89 f8                	mov    %edi,%eax
  802337:	f7 75 ec             	divl   -0x14(%ebp)
  80233a:	89 d6                	mov    %edx,%esi
  80233c:	89 c7                	mov    %eax,%edi
  80233e:	f7 65 e8             	mull   -0x18(%ebp)
  802341:	39 d6                	cmp    %edx,%esi
  802343:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802346:	72 30                	jb     802378 <__udivdi3+0x118>
  802348:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80234f:	d3 e2                	shl    %cl,%edx
  802351:	39 c2                	cmp    %eax,%edx
  802353:	73 05                	jae    80235a <__udivdi3+0xfa>
  802355:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802358:	74 1e                	je     802378 <__udivdi3+0x118>
  80235a:	89 f9                	mov    %edi,%ecx
  80235c:	31 ff                	xor    %edi,%edi
  80235e:	e9 71 ff ff ff       	jmp    8022d4 <__udivdi3+0x74>
  802363:	90                   	nop
  802364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802368:	31 ff                	xor    %edi,%edi
  80236a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80236f:	e9 60 ff ff ff       	jmp    8022d4 <__udivdi3+0x74>
  802374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802378:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80237b:	31 ff                	xor    %edi,%edi
  80237d:	89 c8                	mov    %ecx,%eax
  80237f:	89 fa                	mov    %edi,%edx
  802381:	83 c4 10             	add    $0x10,%esp
  802384:	5e                   	pop    %esi
  802385:	5f                   	pop    %edi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    
	...

00802390 <__umoddi3>:
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	57                   	push   %edi
  802394:	56                   	push   %esi
  802395:	83 ec 20             	sub    $0x20,%esp
  802398:	8b 55 14             	mov    0x14(%ebp),%edx
  80239b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80239e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8023a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023a4:	85 d2                	test   %edx,%edx
  8023a6:	89 c8                	mov    %ecx,%eax
  8023a8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8023ab:	75 13                	jne    8023c0 <__umoddi3+0x30>
  8023ad:	39 f7                	cmp    %esi,%edi
  8023af:	76 3f                	jbe    8023f0 <__umoddi3+0x60>
  8023b1:	89 f2                	mov    %esi,%edx
  8023b3:	f7 f7                	div    %edi
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	31 d2                	xor    %edx,%edx
  8023b9:	83 c4 20             	add    $0x20,%esp
  8023bc:	5e                   	pop    %esi
  8023bd:	5f                   	pop    %edi
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    
  8023c0:	39 f2                	cmp    %esi,%edx
  8023c2:	77 4c                	ja     802410 <__umoddi3+0x80>
  8023c4:	0f bd ca             	bsr    %edx,%ecx
  8023c7:	83 f1 1f             	xor    $0x1f,%ecx
  8023ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8023cd:	75 51                	jne    802420 <__umoddi3+0x90>
  8023cf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8023d2:	0f 87 e0 00 00 00    	ja     8024b8 <__umoddi3+0x128>
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	29 f8                	sub    %edi,%eax
  8023dd:	19 d6                	sbb    %edx,%esi
  8023df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	89 f2                	mov    %esi,%edx
  8023e7:	83 c4 20             	add    $0x20,%esp
  8023ea:	5e                   	pop    %esi
  8023eb:	5f                   	pop    %edi
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    
  8023ee:	66 90                	xchg   %ax,%ax
  8023f0:	85 ff                	test   %edi,%edi
  8023f2:	75 0b                	jne    8023ff <__umoddi3+0x6f>
  8023f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f9:	31 d2                	xor    %edx,%edx
  8023fb:	f7 f7                	div    %edi
  8023fd:	89 c7                	mov    %eax,%edi
  8023ff:	89 f0                	mov    %esi,%eax
  802401:	31 d2                	xor    %edx,%edx
  802403:	f7 f7                	div    %edi
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	f7 f7                	div    %edi
  80240a:	eb a9                	jmp    8023b5 <__umoddi3+0x25>
  80240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802410:	89 c8                	mov    %ecx,%eax
  802412:	89 f2                	mov    %esi,%edx
  802414:	83 c4 20             	add    $0x20,%esp
  802417:	5e                   	pop    %esi
  802418:	5f                   	pop    %edi
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    
  80241b:	90                   	nop
  80241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802420:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802424:	d3 e2                	shl    %cl,%edx
  802426:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802429:	ba 20 00 00 00       	mov    $0x20,%edx
  80242e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802431:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802434:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802438:	89 fa                	mov    %edi,%edx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802440:	0b 55 f4             	or     -0xc(%ebp),%edx
  802443:	d3 e7                	shl    %cl,%edi
  802445:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802449:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80244c:	89 f2                	mov    %esi,%edx
  80244e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802451:	89 c7                	mov    %eax,%edi
  802453:	d3 ea                	shr    %cl,%edx
  802455:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802459:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80245c:	89 c2                	mov    %eax,%edx
  80245e:	d3 e6                	shl    %cl,%esi
  802460:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802464:	d3 ea                	shr    %cl,%edx
  802466:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80246a:	09 d6                	or     %edx,%esi
  80246c:	89 f0                	mov    %esi,%eax
  80246e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802471:	d3 e7                	shl    %cl,%edi
  802473:	89 f2                	mov    %esi,%edx
  802475:	f7 75 f4             	divl   -0xc(%ebp)
  802478:	89 d6                	mov    %edx,%esi
  80247a:	f7 65 e8             	mull   -0x18(%ebp)
  80247d:	39 d6                	cmp    %edx,%esi
  80247f:	72 2b                	jb     8024ac <__umoddi3+0x11c>
  802481:	39 c7                	cmp    %eax,%edi
  802483:	72 23                	jb     8024a8 <__umoddi3+0x118>
  802485:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802489:	29 c7                	sub    %eax,%edi
  80248b:	19 d6                	sbb    %edx,%esi
  80248d:	89 f0                	mov    %esi,%eax
  80248f:	89 f2                	mov    %esi,%edx
  802491:	d3 ef                	shr    %cl,%edi
  802493:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802497:	d3 e0                	shl    %cl,%eax
  802499:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80249d:	09 f8                	or     %edi,%eax
  80249f:	d3 ea                	shr    %cl,%edx
  8024a1:	83 c4 20             	add    $0x20,%esp
  8024a4:	5e                   	pop    %esi
  8024a5:	5f                   	pop    %edi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    
  8024a8:	39 d6                	cmp    %edx,%esi
  8024aa:	75 d9                	jne    802485 <__umoddi3+0xf5>
  8024ac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8024af:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8024b2:	eb d1                	jmp    802485 <__umoddi3+0xf5>
  8024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	39 f2                	cmp    %esi,%edx
  8024ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c0:	0f 82 12 ff ff ff    	jb     8023d8 <__umoddi3+0x48>
  8024c6:	e9 17 ff ff ff       	jmp    8023e2 <__umoddi3+0x52>
