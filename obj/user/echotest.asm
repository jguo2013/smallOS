
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 bf 04 00 00       	call   8004f0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  80003a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003e:	c7 04 24 60 2c 80 00 	movl   $0x802c60,(%esp)
  800045:	e8 6b 05 00 00       	call   8005b5 <cprintf>
	exit();
  80004a:	e8 f1 04 00 00       	call   800540 <exit>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <umain>:

void umain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 5c             	sub    $0x5c,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  80005a:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800061:	e8 4f 05 00 00       	call   8005b5 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800066:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  80006d:	e8 45 04 00 00       	call   8004b7 <inet_addr>
  800072:	89 44 24 08          	mov    %eax,0x8(%esp)
  800076:	c7 44 24 04 74 2c 80 	movl   $0x802c74,0x4(%esp)
  80007d:	00 
  80007e:	c7 04 24 7e 2c 80 00 	movl   $0x802c7e,(%esp)
  800085:	e8 2b 05 00 00       	call   8005b5 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  80008a:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800099:	00 
  80009a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8000a1:	e8 48 1e 00 00       	call   801eee <socket>
  8000a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000a9:	85 c0                	test   %eax,%eax
  8000ab:	79 0a                	jns    8000b7 <umain+0x66>
		die("Failed to create socket");
  8000ad:	b8 93 2c 80 00       	mov    $0x802c93,%eax
  8000b2:	e8 7d ff ff ff       	call   800034 <die>

	cprintf("opened socket\n");
  8000b7:	c7 04 24 ab 2c 80 00 	movl   $0x802cab,(%esp)
  8000be:	e8 f2 04 00 00       	call   8005b5 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8000ca:	00 
  8000cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000d2:	00 
  8000d3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000d6:	89 1c 24             	mov    %ebx,(%esp)
  8000d9:	e8 82 0c 00 00       	call   800d60 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000de:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000e2:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  8000e9:	e8 c9 03 00 00       	call   8004b7 <inet_addr>
  8000ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000f1:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000f8:	e8 b2 01 00 00       	call   8002af <htons>
  8000fd:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  800101:	c7 04 24 ba 2c 80 00 	movl   $0x802cba,(%esp)
  800108:	e8 a8 04 00 00       	call   8005b5 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  80010d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800114:	00 
  800115:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800119:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 47 1e 00 00       	call   801f6b <connect>
  800124:	85 c0                	test   %eax,%eax
  800126:	79 0a                	jns    800132 <umain+0xe1>
		die("Failed to connect with server");
  800128:	b8 d7 2c 80 00       	mov    $0x802cd7,%eax
  80012d:	e8 02 ff ff ff       	call   800034 <die>

	cprintf("connected to server\n");
  800132:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  800139:	e8 77 04 00 00       	call   8005b5 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80013e:	a1 00 40 80 00       	mov    0x804000,%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 95 0a 00 00       	call   800be0 <strlen>
  80014b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80014e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800152:	a1 00 40 80 00       	mov    0x804000,%eax
  800157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80015e:	89 04 24             	mov    %eax,(%esp)
  800161:	e8 70 15 00 00       	call   8016d6 <write>
  800166:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  800169:	74 0a                	je     800175 <umain+0x124>
		die("Mismatch in number of sent bytes");
  80016b:	b8 24 2d 80 00       	mov    $0x802d24,%eax
  800170:	e8 bf fe ff ff       	call   800034 <die>

	// Receive the word back from the server
	cprintf("Received: \n");
  800175:	c7 04 24 0a 2d 80 00 	movl   $0x802d0a,(%esp)
  80017c:	e8 34 04 00 00       	call   8005b5 <cprintf>
  800181:	be 00 00 00 00       	mov    $0x0,%esi
	while (received < echolen) {
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800186:	8d 7d b8             	lea    -0x48(%ebp),%edi
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  800189:	eb 36                	jmp    8001c1 <umain+0x170>
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018b:	c7 44 24 08 1f 00 00 	movl   $0x1f,0x8(%esp)
  800192:	00 
  800193:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800197:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80019a:	89 04 24             	mov    %eax,(%esp)
  80019d:	e8 bd 15 00 00       	call   80175f <read>
  8001a2:	89 c3                	mov    %eax,%ebx
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	7f 0a                	jg     8001b2 <umain+0x161>
			die("Failed to receive bytes from server");
  8001a8:	b8 48 2d 80 00       	mov    $0x802d48,%eax
  8001ad:	e8 82 fe ff ff       	call   800034 <die>
		}
		received += bytes;
  8001b2:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  8001b4:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  8001b9:	89 3c 24             	mov    %edi,(%esp)
  8001bc:	e8 f4 03 00 00       	call   8005b5 <cprintf>
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8001c1:	39 75 b0             	cmp    %esi,-0x50(%ebp)
  8001c4:	77 c5                	ja     80018b <umain+0x13a>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8001c6:	c7 04 24 14 2d 80 00 	movl   $0x802d14,(%esp)
  8001cd:	e8 e3 03 00 00       	call   8005b5 <cprintf>

	close(sock);
  8001d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 e9 16 00 00       	call   8018c6 <close>
}
  8001dd:	83 c4 5c             	add    $0x5c,%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5e                   	pop    %esi
  8001e2:	5f                   	pop    %edi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    
	...

008001f0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 20             	sub    $0x20,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  8001ff:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800202:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  800206:	c7 45 e0 00 50 80 00 	movl   $0x805000,-0x20(%ebp)
  80020d:	ba 00 00 00 00       	mov    $0x0,%edx
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
  800212:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800215:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800218:	0f b6 00             	movzbl (%eax),%eax
  80021b:	88 45 db             	mov    %al,-0x25(%ebp)
      *ap /= (u8_t)10;
  80021e:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  800223:	f6 65 db             	mulb   -0x25(%ebp)
  800226:	66 c1 e8 08          	shr    $0x8,%ax
  80022a:	c0 e8 03             	shr    $0x3,%al
  80022d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800230:	88 01                	mov    %al,(%ecx)
      inv[i++] = '0' + rem;
  800232:	0f b6 f2             	movzbl %dl,%esi
  800235:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  800238:	01 ff                	add    %edi,%edi
  80023a:	0f b6 5d db          	movzbl -0x25(%ebp),%ebx
  80023e:	89 f9                	mov    %edi,%ecx
  800240:	28 cb                	sub    %cl,%bl
  800242:	89 df                	mov    %ebx,%edi
  800244:	8d 4f 30             	lea    0x30(%edi),%ecx
  800247:	88 4c 35 ed          	mov    %cl,-0x13(%ebp,%esi,1)
  80024b:	8d 4a 01             	lea    0x1(%edx),%ecx
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80024e:	89 ca                	mov    %ecx,%edx
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
  800250:	84 c0                	test   %al,%al
  800252:	75 c1                	jne    800215 <inet_ntoa+0x25>
  800254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800257:	89 ce                	mov    %ecx,%esi
  800259:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80025c:	eb 10                	jmp    80026e <inet_ntoa+0x7e>
    while(i--)
  80025e:	83 ea 01             	sub    $0x1,%edx
      *rp++ = inv[i];
  800261:	0f b6 ca             	movzbl %dl,%ecx
  800264:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800269:	88 08                	mov    %cl,(%eax)
  80026b:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80026e:	84 d2                	test   %dl,%dl
  800270:	75 ec                	jne    80025e <inet_ntoa+0x6e>
  800272:	89 f1                	mov    %esi,%ecx
  800274:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800277:	0f b6 c9             	movzbl %cl,%ecx
  80027a:	03 4d e0             	add    -0x20(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  80027d:	c6 01 2e             	movb   $0x2e,(%ecx)
  800280:	83 c1 01             	add    $0x1,%ecx
  800283:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800286:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80028a:	80 7d df 03          	cmpb   $0x3,-0x21(%ebp)
  80028e:	77 0b                	ja     80029b <inet_ntoa+0xab>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  800290:	83 c3 01             	add    $0x1,%ebx
  800293:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800296:	e9 7a ff ff ff       	jmp    800215 <inet_ntoa+0x25>
  }
  *--rp = 0;
  80029b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80029e:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8002a2:	b8 00 50 80 00       	mov    $0x805000,%eax
  8002a7:	83 c4 20             	add    $0x20,%esp
  8002aa:	5b                   	pop    %ebx
  8002ab:	5e                   	pop    %esi
  8002ac:	5f                   	pop    %edi
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002b6:	66 c1 c0 08          	rol    $0x8,%ax
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
}
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  8002c2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002c6:	89 04 24             	mov    %eax,(%esp)
  8002c9:	e8 e1 ff ff ff       	call   8002af <htons>
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d6:	89 d1                	mov    %edx,%ecx
  8002d8:	c1 e9 18             	shr    $0x18,%ecx
  8002db:	89 d0                	mov    %edx,%eax
  8002dd:	c1 e0 18             	shl    $0x18,%eax
  8002e0:	09 c8                	or     %ecx,%eax
  8002e2:	89 d1                	mov    %edx,%ecx
  8002e4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002ea:	c1 e1 08             	shl    $0x8,%ecx
  8002ed:	09 c8                	or     %ecx,%eax
  8002ef:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8002f5:	c1 ea 08             	shr    $0x8,%edx
  8002f8:	09 d0                	or     %edx,%eax
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	57                   	push   %edi
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
  800302:	83 ec 28             	sub    $0x28,%esp
  800305:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800308:	0f be 10             	movsbl (%eax),%edx
  80030b:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  80030e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800311:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800314:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800317:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80031a:	80 f9 09             	cmp    $0x9,%cl
  80031d:	0f 87 87 01 00 00    	ja     8004aa <inet_aton+0x1ae>
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
  800323:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
  80032a:	83 fa 30             	cmp    $0x30,%edx
  80032d:	75 24                	jne    800353 <inet_aton+0x57>
      c = *++cp;
  80032f:	83 c0 01             	add    $0x1,%eax
  800332:	0f be 10             	movsbl (%eax),%edx
      if (c == 'x' || c == 'X') {
  800335:	83 fa 78             	cmp    $0x78,%edx
  800338:	74 0c                	je     800346 <inet_aton+0x4a>
  80033a:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800341:	83 fa 58             	cmp    $0x58,%edx
  800344:	75 0d                	jne    800353 <inet_aton+0x57>
        base = 16;
        c = *++cp;
  800346:	83 c0 01             	add    $0x1,%eax
  800349:	0f be 10             	movsbl (%eax),%edx
  80034c:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800353:	83 c0 01             	add    $0x1,%eax
  800356:	be 00 00 00 00       	mov    $0x0,%esi
  80035b:	eb 03                	jmp    800360 <inet_aton+0x64>
  80035d:	83 c0 01             	add    $0x1,%eax
  800360:	8d 78 ff             	lea    -0x1(%eax),%edi
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800363:	89 d1                	mov    %edx,%ecx
  800365:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800368:	80 fb 09             	cmp    $0x9,%bl
  80036b:	77 0d                	ja     80037a <inet_aton+0x7e>
        val = (val * base) + (int)(c - '0');
  80036d:	0f af 75 e0          	imul   -0x20(%ebp),%esi
  800371:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  800375:	0f be 10             	movsbl (%eax),%edx
  800378:	eb e3                	jmp    80035d <inet_aton+0x61>
      } else if (base == 16 && isxdigit(c)) {
  80037a:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80037e:	75 2b                	jne    8003ab <inet_aton+0xaf>
  800380:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800383:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  800386:	80 fb 05             	cmp    $0x5,%bl
  800389:	76 08                	jbe    800393 <inet_aton+0x97>
  80038b:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  80038e:	80 fb 05             	cmp    $0x5,%bl
  800391:	77 18                	ja     8003ab <inet_aton+0xaf>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800393:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800397:	19 c9                	sbb    %ecx,%ecx
  800399:	83 e1 20             	and    $0x20,%ecx
  80039c:	c1 e6 04             	shl    $0x4,%esi
  80039f:	29 ca                	sub    %ecx,%edx
  8003a1:	8d 52 c9             	lea    -0x37(%edx),%edx
  8003a4:	09 d6                	or     %edx,%esi
        c = *++cp;
  8003a6:	0f be 10             	movsbl (%eax),%edx
  8003a9:	eb b2                	jmp    80035d <inet_aton+0x61>
      } else
        break;
    }
    if (c == '.') {
  8003ab:	83 fa 2e             	cmp    $0x2e,%edx
  8003ae:	75 22                	jne    8003d2 <inet_aton+0xd6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003b3:	39 55 d8             	cmp    %edx,-0x28(%ebp)
  8003b6:	0f 83 ee 00 00 00    	jae    8004aa <inet_aton+0x1ae>
        return (0);
      *pp++ = val;
  8003bc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8003bf:	89 31                	mov    %esi,(%ecx)
  8003c1:	83 c1 04             	add    $0x4,%ecx
  8003c4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      c = *++cp;
  8003c7:	8d 47 01             	lea    0x1(%edi),%eax
  8003ca:	0f be 10             	movsbl (%eax),%edx
    } else
      break;
  }
  8003cd:	e9 45 ff ff ff       	jmp    800317 <inet_aton+0x1b>
  8003d2:	89 f3                	mov    %esi,%ebx
  8003d4:	89 f0                	mov    %esi,%eax
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003d6:	85 d2                	test   %edx,%edx
  8003d8:	74 36                	je     800410 <inet_aton+0x114>
  8003da:	80 f9 1f             	cmp    $0x1f,%cl
  8003dd:	0f 86 c7 00 00 00    	jbe    8004aa <inet_aton+0x1ae>
  8003e3:	84 d2                	test   %dl,%dl
  8003e5:	0f 88 bf 00 00 00    	js     8004aa <inet_aton+0x1ae>
  8003eb:	83 fa 20             	cmp    $0x20,%edx
  8003ee:	66 90                	xchg   %ax,%ax
  8003f0:	74 1e                	je     800410 <inet_aton+0x114>
  8003f2:	83 fa 0c             	cmp    $0xc,%edx
  8003f5:	74 19                	je     800410 <inet_aton+0x114>
  8003f7:	83 fa 0a             	cmp    $0xa,%edx
  8003fa:	74 14                	je     800410 <inet_aton+0x114>
  8003fc:	83 fa 0d             	cmp    $0xd,%edx
  8003ff:	90                   	nop
  800400:	74 0e                	je     800410 <inet_aton+0x114>
  800402:	83 fa 09             	cmp    $0x9,%edx
  800405:	74 09                	je     800410 <inet_aton+0x114>
  800407:	83 fa 0b             	cmp    $0xb,%edx
  80040a:	0f 85 9a 00 00 00    	jne    8004aa <inet_aton+0x1ae>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  800410:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800413:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800416:	29 d1                	sub    %edx,%ecx
  800418:	89 ca                	mov    %ecx,%edx
  80041a:	c1 fa 02             	sar    $0x2,%edx
  80041d:	83 c2 01             	add    $0x1,%edx
  800420:	83 fa 02             	cmp    $0x2,%edx
  800423:	74 1d                	je     800442 <inet_aton+0x146>
  800425:	83 fa 02             	cmp    $0x2,%edx
  800428:	7f 08                	jg     800432 <inet_aton+0x136>
  80042a:	85 d2                	test   %edx,%edx
  80042c:	74 7c                	je     8004aa <inet_aton+0x1ae>
  80042e:	66 90                	xchg   %ax,%ax
  800430:	eb 59                	jmp    80048b <inet_aton+0x18f>
  800432:	83 fa 03             	cmp    $0x3,%edx
  800435:	74 1c                	je     800453 <inet_aton+0x157>
  800437:	83 fa 04             	cmp    $0x4,%edx
  80043a:	75 4f                	jne    80048b <inet_aton+0x18f>
  80043c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800440:	eb 2a                	jmp    80046c <inet_aton+0x170>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800442:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  800447:	77 61                	ja     8004aa <inet_aton+0x1ae>
      return (0);
    val |= parts[0] << 24;
  800449:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80044c:	c1 e3 18             	shl    $0x18,%ebx
  80044f:	09 c3                	or     %eax,%ebx
    break;
  800451:	eb 38                	jmp    80048b <inet_aton+0x18f>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800453:	3d ff ff 00 00       	cmp    $0xffff,%eax
  800458:	77 50                	ja     8004aa <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80045d:	c1 e3 10             	shl    $0x10,%ebx
  800460:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800463:	c1 e2 18             	shl    $0x18,%edx
  800466:	09 d3                	or     %edx,%ebx
  800468:	09 c3                	or     %eax,%ebx
    break;
  80046a:	eb 1f                	jmp    80048b <inet_aton+0x18f>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80046c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800471:	77 37                	ja     8004aa <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800473:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800476:	c1 e3 10             	shl    $0x10,%ebx
  800479:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80047c:	c1 e2 18             	shl    $0x18,%edx
  80047f:	09 d3                	or     %edx,%ebx
  800481:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800484:	c1 e2 08             	shl    $0x8,%edx
  800487:	09 d3                	or     %edx,%ebx
  800489:	09 c3                	or     %eax,%ebx
    break;
  }
  if (addr)
  80048b:	b8 01 00 00 00       	mov    $0x1,%eax
  800490:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800494:	74 19                	je     8004af <inet_aton+0x1b3>
    addr->s_addr = htonl(val);
  800496:	89 1c 24             	mov    %ebx,(%esp)
  800499:	e8 32 fe ff ff       	call   8002d0 <htonl>
  80049e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a1:	89 03                	mov    %eax,(%ebx)
  8004a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8004a8:	eb 05                	jmp    8004af <inet_aton+0x1b3>
  8004aa:	b8 00 00 00 00       	mov    $0x0,%eax
  return (1);
}
  8004af:	83 c4 28             	add    $0x28,%esp
  8004b2:	5b                   	pop    %ebx
  8004b3:	5e                   	pop    %esi
  8004b4:	5f                   	pop    %edi
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004bd:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	89 04 24             	mov    %eax,(%esp)
  8004ca:	e8 2d fe ff ff       	call   8002fc <inet_aton>
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004d6:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
    return (val.s_addr);
  }
  return (INADDR_NONE);
}
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	89 04 24             	mov    %eax,(%esp)
  8004e8:	e8 e3 fd ff ff       	call   8002d0 <htonl>
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    
	...

008004f0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 18             	sub    $0x18,%esp
  8004f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8004f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800502:	e8 ea 0e 00 00       	call   8013f1 <sys_getenvid>
  800507:	25 ff 03 00 00       	and    $0x3ff,%eax
  80050c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80050f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800514:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800519:	85 f6                	test   %esi,%esi
  80051b:	7e 07                	jle    800524 <libmain+0x34>
		binaryname = argv[0];
  80051d:	8b 03                	mov    (%ebx),%eax
  80051f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800524:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800528:	89 34 24             	mov    %esi,(%esp)
  80052b:	e8 21 fb ff ff       	call   800051 <umain>

	// exit gracefully
	exit();
  800530:	e8 0b 00 00 00       	call   800540 <exit>
}
  800535:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800538:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80053b:	89 ec                	mov    %ebp,%esp
  80053d:	5d                   	pop    %ebp
  80053e:	c3                   	ret    
	...

00800540 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800546:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80054d:	e8 d3 0e 00 00       	call   801425 <sys_env_destroy>
}
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80055d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800564:	00 00 00 
	b.cnt = 0;
  800567:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80057f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800585:	89 44 24 04          	mov    %eax,0x4(%esp)
  800589:	c7 04 24 cf 05 80 00 	movl   $0x8005cf,(%esp)
  800590:	e8 be 01 00 00       	call   800753 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800595:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80059b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005a5:	89 04 24             	mov    %eax,(%esp)
  8005a8:	e8 23 0a 00 00       	call   800fd0 <sys_cputs>

	return b.cnt;
}
  8005ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8005bb:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8005be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	89 04 24             	mov    %eax,(%esp)
  8005c8:	e8 87 ff ff ff       	call   800554 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

008005cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	53                   	push   %ebx
  8005d3:	83 ec 14             	sub    $0x14,%esp
  8005d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005d9:	8b 03                	mov    (%ebx),%eax
  8005db:	8b 55 08             	mov    0x8(%ebp),%edx
  8005de:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8005e2:	83 c0 01             	add    $0x1,%eax
  8005e5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8005e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ec:	75 19                	jne    800607 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8005ee:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8005f5:	00 
  8005f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8005f9:	89 04 24             	mov    %eax,(%esp)
  8005fc:	e8 cf 09 00 00       	call   800fd0 <sys_cputs>
		b->idx = 0;
  800601:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800607:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80060b:	83 c4 14             	add    $0x14,%esp
  80060e:	5b                   	pop    %ebx
  80060f:	5d                   	pop    %ebp
  800610:	c3                   	ret    
  800611:	00 00                	add    %al,(%eax)
	...

00800614 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	57                   	push   %edi
  800618:	56                   	push   %esi
  800619:	53                   	push   %ebx
  80061a:	83 ec 4c             	sub    $0x4c,%esp
  80061d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800620:	89 d6                	mov    %edx,%esi
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80062e:	8b 45 10             	mov    0x10(%ebp),%eax
  800631:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800634:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800637:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063f:	39 d1                	cmp    %edx,%ecx
  800641:	72 07                	jb     80064a <printnum+0x36>
  800643:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800646:	39 d0                	cmp    %edx,%eax
  800648:	77 69                	ja     8006b3 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80064e:	83 eb 01             	sub    $0x1,%ebx
  800651:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800655:	89 44 24 08          	mov    %eax,0x8(%esp)
  800659:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80065d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800661:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800664:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800667:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80066a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80066e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800675:	00 
  800676:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800679:	89 04 24             	mov    %eax,(%esp)
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800683:	e8 68 23 00 00       	call   8029f0 <__udivdi3>
  800688:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80068b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80068e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800692:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800696:	89 04 24             	mov    %eax,(%esp)
  800699:	89 54 24 04          	mov    %edx,0x4(%esp)
  80069d:	89 f2                	mov    %esi,%edx
  80069f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a2:	e8 6d ff ff ff       	call   800614 <printnum>
  8006a7:	eb 11                	jmp    8006ba <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ad:	89 3c 24             	mov    %edi,(%esp)
  8006b0:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b3:	83 eb 01             	sub    $0x1,%ebx
  8006b6:	85 db                	test   %ebx,%ebx
  8006b8:	7f ef                	jg     8006a9 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006be:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006c9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8006d0:	00 
  8006d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006d4:	89 14 24             	mov    %edx,(%esp)
  8006d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006de:	e8 3d 24 00 00       	call   802b20 <__umoddi3>
  8006e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e7:	0f be 80 76 2d 80 00 	movsbl 0x802d76(%eax),%eax
  8006ee:	89 04 24             	mov    %eax,(%esp)
  8006f1:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8006f4:	83 c4 4c             	add    $0x4c,%esp
  8006f7:	5b                   	pop    %ebx
  8006f8:	5e                   	pop    %esi
  8006f9:	5f                   	pop    %edi
  8006fa:	5d                   	pop    %ebp
  8006fb:	c3                   	ret    

008006fc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ff:	83 fa 01             	cmp    $0x1,%edx
  800702:	7e 0e                	jle    800712 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800704:	8b 10                	mov    (%eax),%edx
  800706:	8d 4a 08             	lea    0x8(%edx),%ecx
  800709:	89 08                	mov    %ecx,(%eax)
  80070b:	8b 02                	mov    (%edx),%eax
  80070d:	8b 52 04             	mov    0x4(%edx),%edx
  800710:	eb 22                	jmp    800734 <getuint+0x38>
	else if (lflag)
  800712:	85 d2                	test   %edx,%edx
  800714:	74 10                	je     800726 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800716:	8b 10                	mov    (%eax),%edx
  800718:	8d 4a 04             	lea    0x4(%edx),%ecx
  80071b:	89 08                	mov    %ecx,(%eax)
  80071d:	8b 02                	mov    (%edx),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 0e                	jmp    800734 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 10                	mov    (%eax),%edx
  800728:	8d 4a 04             	lea    0x4(%edx),%ecx
  80072b:	89 08                	mov    %ecx,(%eax)
  80072d:	8b 02                	mov    (%edx),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800734:	5d                   	pop    %ebp
  800735:	c3                   	ret    

00800736 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80073c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800740:	8b 10                	mov    (%eax),%edx
  800742:	3b 50 04             	cmp    0x4(%eax),%edx
  800745:	73 0a                	jae    800751 <sprintputch+0x1b>
		*b->buf++ = ch;
  800747:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80074a:	88 0a                	mov    %cl,(%edx)
  80074c:	83 c2 01             	add    $0x1,%edx
  80074f:	89 10                	mov    %edx,(%eax)
}
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	57                   	push   %edi
  800757:	56                   	push   %esi
  800758:	53                   	push   %ebx
  800759:	83 ec 4c             	sub    $0x4c,%esp
  80075c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80075f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800762:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800765:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80076c:	eb 11                	jmp    80077f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80076e:	85 c0                	test   %eax,%eax
  800770:	0f 84 b6 03 00 00    	je     800b2c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800776:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077a:	89 04 24             	mov    %eax,(%esp)
  80077d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	0f b6 03             	movzbl (%ebx),%eax
  800782:	83 c3 01             	add    $0x1,%ebx
  800785:	83 f8 25             	cmp    $0x25,%eax
  800788:	75 e4                	jne    80076e <vprintfmt+0x1b>
  80078a:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  80078e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800795:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  80079c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8007a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007ab:	eb 06                	jmp    8007b3 <vprintfmt+0x60>
  8007ad:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8007b1:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	0f b6 0b             	movzbl (%ebx),%ecx
  8007b6:	0f b6 c1             	movzbl %cl,%eax
  8007b9:	8d 53 01             	lea    0x1(%ebx),%edx
  8007bc:	83 e9 23             	sub    $0x23,%ecx
  8007bf:	80 f9 55             	cmp    $0x55,%cl
  8007c2:	0f 87 47 03 00 00    	ja     800b0f <vprintfmt+0x3bc>
  8007c8:	0f b6 c9             	movzbl %cl,%ecx
  8007cb:	ff 24 8d c0 2e 80 00 	jmp    *0x802ec0(,%ecx,4)
  8007d2:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8007d6:	eb d9                	jmp    8007b1 <vprintfmt+0x5e>
  8007d8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8007df:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8007e4:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8007e7:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8007eb:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8007ee:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8007f1:	83 fb 09             	cmp    $0x9,%ebx
  8007f4:	77 30                	ja     800826 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f6:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f9:	eb e9                	jmp    8007e4 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 48 04             	lea    0x4(%eax),%ecx
  800801:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800809:	eb 1e                	jmp    800829 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	b8 00 00 00 00       	mov    $0x0,%eax
  800814:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80081b:	eb 94                	jmp    8007b1 <vprintfmt+0x5e>
  80081d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800824:	eb 8b                	jmp    8007b1 <vprintfmt+0x5e>
  800826:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800829:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082d:	79 82                	jns    8007b1 <vprintfmt+0x5e>
  80082f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800835:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800838:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80083b:	e9 71 ff ff ff       	jmp    8007b1 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800840:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800844:	e9 68 ff ff ff       	jmp    8007b1 <vprintfmt+0x5e>
  800849:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8d 50 04             	lea    0x4(%eax),%edx
  800852:	89 55 14             	mov    %edx,0x14(%ebp)
  800855:	89 74 24 04          	mov    %esi,0x4(%esp)
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 04 24             	mov    %eax,(%esp)
  80085e:	ff d7                	call   *%edi
  800860:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800863:	e9 17 ff ff ff       	jmp    80077f <vprintfmt+0x2c>
  800868:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 50 04             	lea    0x4(%eax),%edx
  800871:	89 55 14             	mov    %edx,0x14(%ebp)
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 c2                	mov    %eax,%edx
  800878:	c1 fa 1f             	sar    $0x1f,%edx
  80087b:	31 d0                	xor    %edx,%eax
  80087d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80087f:	83 f8 11             	cmp    $0x11,%eax
  800882:	7f 0b                	jg     80088f <vprintfmt+0x13c>
  800884:	8b 14 85 20 30 80 00 	mov    0x803020(,%eax,4),%edx
  80088b:	85 d2                	test   %edx,%edx
  80088d:	75 20                	jne    8008af <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  80088f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800893:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  80089a:	00 
  80089b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80089f:	89 3c 24             	mov    %edi,(%esp)
  8008a2:	e8 0d 03 00 00       	call   800bb4 <printfmt>
  8008a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008aa:	e9 d0 fe ff ff       	jmp    80077f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008b3:	c7 44 24 08 76 31 80 	movl   $0x803176,0x8(%esp)
  8008ba:	00 
  8008bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008bf:	89 3c 24             	mov    %edi,(%esp)
  8008c2:	e8 ed 02 00 00       	call   800bb4 <printfmt>
  8008c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8008ca:	e9 b0 fe ff ff       	jmp    80077f <vprintfmt+0x2c>
  8008cf:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008d2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8008d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8d 50 04             	lea    0x4(%eax),%edx
  8008e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e4:	8b 18                	mov    (%eax),%ebx
  8008e6:	85 db                	test   %ebx,%ebx
  8008e8:	b8 90 2d 80 00       	mov    $0x802d90,%eax
  8008ed:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  8008f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008f4:	7e 76                	jle    80096c <vprintfmt+0x219>
  8008f6:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8008fa:	74 7a                	je     800976 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800900:	89 1c 24             	mov    %ebx,(%esp)
  800903:	e8 f0 02 00 00       	call   800bf8 <strnlen>
  800908:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80090b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80090d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800911:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800914:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800917:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x1d7>
					putch(padc, putdat);
  80091b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800927:	83 eb 01             	sub    $0x1,%ebx
  80092a:	85 db                	test   %ebx,%ebx
  80092c:	7f ed                	jg     80091b <vprintfmt+0x1c8>
  80092e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800931:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800934:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800937:	89 f7                	mov    %esi,%edi
  800939:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80093c:	eb 40                	jmp    80097e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80093e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800942:	74 18                	je     80095c <vprintfmt+0x209>
  800944:	8d 50 e0             	lea    -0x20(%eax),%edx
  800947:	83 fa 5e             	cmp    $0x5e,%edx
  80094a:	76 10                	jbe    80095c <vprintfmt+0x209>
					putch('?', putdat);
  80094c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800950:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800957:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80095a:	eb 0a                	jmp    800966 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  80095c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800960:	89 04 24             	mov    %eax,(%esp)
  800963:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800966:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80096a:	eb 12                	jmp    80097e <vprintfmt+0x22b>
  80096c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80096f:	89 f7                	mov    %esi,%edi
  800971:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800974:	eb 08                	jmp    80097e <vprintfmt+0x22b>
  800976:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800979:	89 f7                	mov    %esi,%edi
  80097b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80097e:	0f be 03             	movsbl (%ebx),%eax
  800981:	83 c3 01             	add    $0x1,%ebx
  800984:	85 c0                	test   %eax,%eax
  800986:	74 25                	je     8009ad <vprintfmt+0x25a>
  800988:	85 f6                	test   %esi,%esi
  80098a:	78 b2                	js     80093e <vprintfmt+0x1eb>
  80098c:	83 ee 01             	sub    $0x1,%esi
  80098f:	79 ad                	jns    80093e <vprintfmt+0x1eb>
  800991:	89 fe                	mov    %edi,%esi
  800993:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800996:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800999:	eb 1a                	jmp    8009b5 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80099b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009a6:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a8:	83 eb 01             	sub    $0x1,%ebx
  8009ab:	eb 08                	jmp    8009b5 <vprintfmt+0x262>
  8009ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8009b0:	89 fe                	mov    %edi,%esi
  8009b2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8009b5:	85 db                	test   %ebx,%ebx
  8009b7:	7f e2                	jg     80099b <vprintfmt+0x248>
  8009b9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8009bc:	e9 be fd ff ff       	jmp    80077f <vprintfmt+0x2c>
  8009c1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009c4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009c7:	83 f9 01             	cmp    $0x1,%ecx
  8009ca:	7e 16                	jle    8009e2 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	8d 50 08             	lea    0x8(%eax),%edx
  8009d2:	89 55 14             	mov    %edx,0x14(%ebp)
  8009d5:	8b 10                	mov    (%eax),%edx
  8009d7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009da:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8009dd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009e0:	eb 32                	jmp    800a14 <vprintfmt+0x2c1>
	else if (lflag)
  8009e2:	85 c9                	test   %ecx,%ecx
  8009e4:	74 18                	je     8009fe <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ec:	89 55 14             	mov    %edx,0x14(%ebp)
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f4:	89 c1                	mov    %eax,%ecx
  8009f6:	c1 f9 1f             	sar    $0x1f,%ecx
  8009f9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009fc:	eb 16                	jmp    800a14 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	8d 50 04             	lea    0x4(%eax),%edx
  800a04:	89 55 14             	mov    %edx,0x14(%ebp)
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0c:	89 c2                	mov    %eax,%edx
  800a0e:	c1 fa 1f             	sar    $0x1f,%edx
  800a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a14:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800a17:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a1a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a23:	0f 89 a7 00 00 00    	jns    800ad0 <vprintfmt+0x37d>
				putch('-', putdat);
  800a29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a34:	ff d7                	call   *%edi
				num = -(long long) num;
  800a36:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800a39:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a3c:	f7 d9                	neg    %ecx
  800a3e:	83 d3 00             	adc    $0x0,%ebx
  800a41:	f7 db                	neg    %ebx
  800a43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a48:	e9 83 00 00 00       	jmp    800ad0 <vprintfmt+0x37d>
  800a4d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a50:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a53:	89 ca                	mov    %ecx,%edx
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
  800a58:	e8 9f fc ff ff       	call   8006fc <getuint>
  800a5d:	89 c1                	mov    %eax,%ecx
  800a5f:	89 d3                	mov    %edx,%ebx
  800a61:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800a66:	eb 68                	jmp    800ad0 <vprintfmt+0x37d>
  800a68:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800a6e:	89 ca                	mov    %ecx,%edx
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	e8 84 fc ff ff       	call   8006fc <getuint>
  800a78:	89 c1                	mov    %eax,%ecx
  800a7a:	89 d3                	mov    %edx,%ebx
  800a7c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800a81:	eb 4d                	jmp    800ad0 <vprintfmt+0x37d>
  800a83:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800a86:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a8a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a91:	ff d7                	call   *%edi
			putch('x', putdat);
  800a93:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a97:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a9e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	8d 50 04             	lea    0x4(%eax),%edx
  800aa6:	89 55 14             	mov    %edx,0x14(%ebp)
  800aa9:	8b 08                	mov    (%eax),%ecx
  800aab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800ab5:	eb 19                	jmp    800ad0 <vprintfmt+0x37d>
  800ab7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800aba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abd:	89 ca                	mov    %ecx,%edx
  800abf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac2:	e8 35 fc ff ff       	call   8006fc <getuint>
  800ac7:	89 c1                	mov    %eax,%ecx
  800ac9:	89 d3                	mov    %edx,%ebx
  800acb:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad0:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800ad4:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ad8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800adb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800adf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae3:	89 0c 24             	mov    %ecx,(%esp)
  800ae6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aea:	89 f2                	mov    %esi,%edx
  800aec:	89 f8                	mov    %edi,%eax
  800aee:	e8 21 fb ff ff       	call   800614 <printnum>
  800af3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800af6:	e9 84 fc ff ff       	jmp    80077f <vprintfmt+0x2c>
  800afb:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800afe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b02:	89 04 24             	mov    %eax,(%esp)
  800b05:	ff d7                	call   *%edi
  800b07:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b0a:	e9 70 fc ff ff       	jmp    80077f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b13:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b1a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800b1f:	80 38 25             	cmpb   $0x25,(%eax)
  800b22:	0f 84 57 fc ff ff    	je     80077f <vprintfmt+0x2c>
  800b28:	89 c3                	mov    %eax,%ebx
  800b2a:	eb f0                	jmp    800b1c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800b2c:	83 c4 4c             	add    $0x4c,%esp
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 28             	sub    $0x28,%esp
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800b40:	85 c0                	test   %eax,%eax
  800b42:	74 04                	je     800b48 <vsnprintf+0x14>
  800b44:	85 d2                	test   %edx,%edx
  800b46:	7f 07                	jg     800b4f <vsnprintf+0x1b>
  800b48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b4d:	eb 3b                	jmp    800b8a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b52:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b60:	8b 45 14             	mov    0x14(%ebp),%eax
  800b63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b67:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b75:	c7 04 24 36 07 80 00 	movl   $0x800736,(%esp)
  800b7c:	e8 d2 fb ff ff       	call   800753 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b92:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	89 04 24             	mov    %eax,(%esp)
  800bad:	e8 82 ff ff ff       	call   800b34 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800bba:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800bbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 04 24             	mov    %eax,(%esp)
  800bd5:	e8 79 fb ff ff       	call   800753 <vprintfmt>
	va_end(ap);
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    
  800bdc:	00 00                	add    %al,(%eax)
	...

00800be0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800beb:	eb 03                	jmp    800bf0 <strlen+0x10>
		n++;
  800bed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bf4:	75 f7                	jne    800bed <strlen+0xd>
		n++;
	return n;
}
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	53                   	push   %ebx
  800bfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c07:	eb 03                	jmp    800c0c <strnlen+0x14>
		n++;
  800c09:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	39 c1                	cmp    %eax,%ecx
  800c0e:	74 06                	je     800c16 <strnlen+0x1e>
  800c10:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800c14:	75 f3                	jne    800c09 <strnlen+0x11>
		n++;
	return n;
}
  800c16:	5b                   	pop    %ebx
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	53                   	push   %ebx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c23:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c28:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c2c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c2f:	83 c2 01             	add    $0x1,%edx
  800c32:	84 c9                	test   %cl,%cl
  800c34:	75 f2                	jne    800c28 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c36:	5b                   	pop    %ebx
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c43:	89 1c 24             	mov    %ebx,(%esp)
  800c46:	e8 95 ff ff ff       	call   800be0 <strlen>
	strcpy(dst + len, src);
  800c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c52:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800c55:	89 04 24             	mov    %eax,(%esp)
  800c58:	e8 bc ff ff ff       	call   800c19 <strcpy>
	return dst;
}
  800c5d:	89 d8                	mov    %ebx,%eax
  800c5f:	83 c4 08             	add    $0x8,%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	8b 75 10             	mov    0x10(%ebp),%esi
  800c73:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c78:	eb 0f                	jmp    800c89 <strncpy+0x24>
		*dst++ = *src;
  800c7a:	0f b6 19             	movzbl (%ecx),%ebx
  800c7d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c80:	80 39 01             	cmpb   $0x1,(%ecx)
  800c83:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c86:	83 c2 01             	add    $0x1,%edx
  800c89:	39 f2                	cmp    %esi,%edx
  800c8b:	72 ed                	jb     800c7a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
  800c96:	8b 75 08             	mov    0x8(%ebp),%esi
  800c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c9f:	89 f0                	mov    %esi,%eax
  800ca1:	85 d2                	test   %edx,%edx
  800ca3:	75 0a                	jne    800caf <strlcpy+0x1e>
  800ca5:	eb 17                	jmp    800cbe <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ca7:	88 18                	mov    %bl,(%eax)
  800ca9:	83 c0 01             	add    $0x1,%eax
  800cac:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800caf:	83 ea 01             	sub    $0x1,%edx
  800cb2:	74 07                	je     800cbb <strlcpy+0x2a>
  800cb4:	0f b6 19             	movzbl (%ecx),%ebx
  800cb7:	84 db                	test   %bl,%bl
  800cb9:	75 ec                	jne    800ca7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800cbb:	c6 00 00             	movb   $0x0,(%eax)
  800cbe:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ccd:	eb 06                	jmp    800cd5 <strcmp+0x11>
		p++, q++;
  800ccf:	83 c1 01             	add    $0x1,%ecx
  800cd2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd5:	0f b6 01             	movzbl (%ecx),%eax
  800cd8:	84 c0                	test   %al,%al
  800cda:	74 04                	je     800ce0 <strcmp+0x1c>
  800cdc:	3a 02                	cmp    (%edx),%al
  800cde:	74 ef                	je     800ccf <strcmp+0xb>
  800ce0:	0f b6 c0             	movzbl %al,%eax
  800ce3:	0f b6 12             	movzbl (%edx),%edx
  800ce6:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	53                   	push   %ebx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800cf7:	eb 09                	jmp    800d02 <strncmp+0x18>
		n--, p++, q++;
  800cf9:	83 ea 01             	sub    $0x1,%edx
  800cfc:	83 c0 01             	add    $0x1,%eax
  800cff:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d02:	85 d2                	test   %edx,%edx
  800d04:	75 07                	jne    800d0d <strncmp+0x23>
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 13                	jmp    800d20 <strncmp+0x36>
  800d0d:	0f b6 18             	movzbl (%eax),%ebx
  800d10:	84 db                	test   %bl,%bl
  800d12:	74 04                	je     800d18 <strncmp+0x2e>
  800d14:	3a 19                	cmp    (%ecx),%bl
  800d16:	74 e1                	je     800cf9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d18:	0f b6 00             	movzbl (%eax),%eax
  800d1b:	0f b6 11             	movzbl (%ecx),%edx
  800d1e:	29 d0                	sub    %edx,%eax
}
  800d20:	5b                   	pop    %ebx
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d2d:	eb 07                	jmp    800d36 <strchr+0x13>
		if (*s == c)
  800d2f:	38 ca                	cmp    %cl,%dl
  800d31:	74 0f                	je     800d42 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d33:	83 c0 01             	add    $0x1,%eax
  800d36:	0f b6 10             	movzbl (%eax),%edx
  800d39:	84 d2                	test   %dl,%dl
  800d3b:	75 f2                	jne    800d2f <strchr+0xc>
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d4e:	eb 07                	jmp    800d57 <strfind+0x13>
		if (*s == c)
  800d50:	38 ca                	cmp    %cl,%dl
  800d52:	74 0a                	je     800d5e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d54:	83 c0 01             	add    $0x1,%eax
  800d57:	0f b6 10             	movzbl (%eax),%edx
  800d5a:	84 d2                	test   %dl,%dl
  800d5c:	75 f2                	jne    800d50 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	89 1c 24             	mov    %ebx,(%esp)
  800d69:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d71:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d7a:	85 c9                	test   %ecx,%ecx
  800d7c:	74 30                	je     800dae <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d84:	75 25                	jne    800dab <memset+0x4b>
  800d86:	f6 c1 03             	test   $0x3,%cl
  800d89:	75 20                	jne    800dab <memset+0x4b>
		c &= 0xFF;
  800d8b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d8e:	89 d3                	mov    %edx,%ebx
  800d90:	c1 e3 08             	shl    $0x8,%ebx
  800d93:	89 d6                	mov    %edx,%esi
  800d95:	c1 e6 18             	shl    $0x18,%esi
  800d98:	89 d0                	mov    %edx,%eax
  800d9a:	c1 e0 10             	shl    $0x10,%eax
  800d9d:	09 f0                	or     %esi,%eax
  800d9f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800da1:	09 d8                	or     %ebx,%eax
  800da3:	c1 e9 02             	shr    $0x2,%ecx
  800da6:	fc                   	cld    
  800da7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800da9:	eb 03                	jmp    800dae <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dab:	fc                   	cld    
  800dac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dae:	89 f8                	mov    %edi,%eax
  800db0:	8b 1c 24             	mov    (%esp),%ebx
  800db3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800db7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dbb:	89 ec                	mov    %ebp,%esp
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 08             	sub    $0x8,%esp
  800dc5:	89 34 24             	mov    %esi,(%esp)
  800dc8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800dd2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800dd5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800dd7:	39 c6                	cmp    %eax,%esi
  800dd9:	73 35                	jae    800e10 <memmove+0x51>
  800ddb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dde:	39 d0                	cmp    %edx,%eax
  800de0:	73 2e                	jae    800e10 <memmove+0x51>
		s += n;
		d += n;
  800de2:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de4:	f6 c2 03             	test   $0x3,%dl
  800de7:	75 1b                	jne    800e04 <memmove+0x45>
  800de9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800def:	75 13                	jne    800e04 <memmove+0x45>
  800df1:	f6 c1 03             	test   $0x3,%cl
  800df4:	75 0e                	jne    800e04 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800df6:	83 ef 04             	sub    $0x4,%edi
  800df9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dfc:	c1 e9 02             	shr    $0x2,%ecx
  800dff:	fd                   	std    
  800e00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e02:	eb 09                	jmp    800e0d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e04:	83 ef 01             	sub    $0x1,%edi
  800e07:	8d 72 ff             	lea    -0x1(%edx),%esi
  800e0a:	fd                   	std    
  800e0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e0d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e0e:	eb 20                	jmp    800e30 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e10:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e16:	75 15                	jne    800e2d <memmove+0x6e>
  800e18:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e1e:	75 0d                	jne    800e2d <memmove+0x6e>
  800e20:	f6 c1 03             	test   $0x3,%cl
  800e23:	75 08                	jne    800e2d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800e25:	c1 e9 02             	shr    $0x2,%ecx
  800e28:	fc                   	cld    
  800e29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e2b:	eb 03                	jmp    800e30 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e2d:	fc                   	cld    
  800e2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e30:	8b 34 24             	mov    (%esp),%esi
  800e33:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e37:	89 ec                	mov    %ebp,%esp
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 04 24             	mov    %eax,(%esp)
  800e55:	e8 65 ff ff ff       	call   800dbf <memmove>
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e6b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e70:	eb 1c                	jmp    800e8e <memcmp+0x32>
		if (*s1 != *s2)
  800e72:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800e76:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800e7a:	83 c2 01             	add    $0x1,%edx
  800e7d:	83 e9 01             	sub    $0x1,%ecx
  800e80:	38 d8                	cmp    %bl,%al
  800e82:	74 0a                	je     800e8e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800e84:	0f b6 c0             	movzbl %al,%eax
  800e87:	0f b6 db             	movzbl %bl,%ebx
  800e8a:	29 d8                	sub    %ebx,%eax
  800e8c:	eb 09                	jmp    800e97 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e8e:	85 c9                	test   %ecx,%ecx
  800e90:	75 e0                	jne    800e72 <memcmp+0x16>
  800e92:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ea5:	89 c2                	mov    %eax,%edx
  800ea7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eaa:	eb 07                	jmp    800eb3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eac:	38 08                	cmp    %cl,(%eax)
  800eae:	74 07                	je     800eb7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb0:	83 c0 01             	add    $0x1,%eax
  800eb3:	39 d0                	cmp    %edx,%eax
  800eb5:	72 f5                	jb     800eac <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec8:	eb 03                	jmp    800ecd <strtol+0x14>
		s++;
  800eca:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ecd:	0f b6 02             	movzbl (%edx),%eax
  800ed0:	3c 20                	cmp    $0x20,%al
  800ed2:	74 f6                	je     800eca <strtol+0x11>
  800ed4:	3c 09                	cmp    $0x9,%al
  800ed6:	74 f2                	je     800eca <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ed8:	3c 2b                	cmp    $0x2b,%al
  800eda:	75 0c                	jne    800ee8 <strtol+0x2f>
		s++;
  800edc:	8d 52 01             	lea    0x1(%edx),%edx
  800edf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ee6:	eb 15                	jmp    800efd <strtol+0x44>
	else if (*s == '-')
  800ee8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eef:	3c 2d                	cmp    $0x2d,%al
  800ef1:	75 0a                	jne    800efd <strtol+0x44>
		s++, neg = 1;
  800ef3:	8d 52 01             	lea    0x1(%edx),%edx
  800ef6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efd:	85 db                	test   %ebx,%ebx
  800eff:	0f 94 c0             	sete   %al
  800f02:	74 05                	je     800f09 <strtol+0x50>
  800f04:	83 fb 10             	cmp    $0x10,%ebx
  800f07:	75 15                	jne    800f1e <strtol+0x65>
  800f09:	80 3a 30             	cmpb   $0x30,(%edx)
  800f0c:	75 10                	jne    800f1e <strtol+0x65>
  800f0e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f12:	75 0a                	jne    800f1e <strtol+0x65>
		s += 2, base = 16;
  800f14:	83 c2 02             	add    $0x2,%edx
  800f17:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f1c:	eb 13                	jmp    800f31 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f1e:	84 c0                	test   %al,%al
  800f20:	74 0f                	je     800f31 <strtol+0x78>
  800f22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f27:	80 3a 30             	cmpb   $0x30,(%edx)
  800f2a:	75 05                	jne    800f31 <strtol+0x78>
		s++, base = 8;
  800f2c:	83 c2 01             	add    $0x1,%edx
  800f2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f38:	0f b6 0a             	movzbl (%edx),%ecx
  800f3b:	89 cf                	mov    %ecx,%edi
  800f3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f40:	80 fb 09             	cmp    $0x9,%bl
  800f43:	77 08                	ja     800f4d <strtol+0x94>
			dig = *s - '0';
  800f45:	0f be c9             	movsbl %cl,%ecx
  800f48:	83 e9 30             	sub    $0x30,%ecx
  800f4b:	eb 1e                	jmp    800f6b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800f4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f50:	80 fb 19             	cmp    $0x19,%bl
  800f53:	77 08                	ja     800f5d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800f55:	0f be c9             	movsbl %cl,%ecx
  800f58:	83 e9 57             	sub    $0x57,%ecx
  800f5b:	eb 0e                	jmp    800f6b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800f5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f60:	80 fb 19             	cmp    $0x19,%bl
  800f63:	77 15                	ja     800f7a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f65:	0f be c9             	movsbl %cl,%ecx
  800f68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f6b:	39 f1                	cmp    %esi,%ecx
  800f6d:	7d 0b                	jge    800f7a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f6f:	83 c2 01             	add    $0x1,%edx
  800f72:	0f af c6             	imul   %esi,%eax
  800f75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f78:	eb be                	jmp    800f38 <strtol+0x7f>
  800f7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f80:	74 05                	je     800f87 <strtol+0xce>
		*endptr = (char *) s;
  800f82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f87:	89 ca                	mov    %ecx,%edx
  800f89:	f7 da                	neg    %edx
  800f8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f8f:	0f 45 c2             	cmovne %edx,%eax
}
  800f92:	83 c4 04             	add    $0x4,%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
	...

00800f9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	89 1c 24             	mov    %ebx,(%esp)
  800fa5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fa9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fad:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb7:	89 d1                	mov    %edx,%ecx
  800fb9:	89 d3                	mov    %edx,%ebx
  800fbb:	89 d7                	mov    %edx,%edi
  800fbd:	89 d6                	mov    %edx,%esi
  800fbf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fc1:	8b 1c 24             	mov    (%esp),%ebx
  800fc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fcc:	89 ec                	mov    %ebp,%esp
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	89 1c 24             	mov    %ebx,(%esp)
  800fd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	89 c3                	mov    %eax,%ebx
  800fee:	89 c7                	mov    %eax,%edi
  800ff0:	89 c6                	mov    %eax,%esi
  800ff2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ff4:	8b 1c 24             	mov    (%esp),%ebx
  800ff7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ffb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fff:	89 ec                	mov    %ebp,%esp
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	89 1c 24             	mov    %ebx,(%esp)
  80100c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801010:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801014:	ba 00 00 00 00       	mov    $0x0,%edx
  801019:	b8 10 00 00 00       	mov    $0x10,%eax
  80101e:	89 d1                	mov    %edx,%ecx
  801020:	89 d3                	mov    %edx,%ebx
  801022:	89 d7                	mov    %edx,%edi
  801024:	89 d6                	mov    %edx,%esi
  801026:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801028:	8b 1c 24             	mov    (%esp),%ebx
  80102b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80102f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801033:	89 ec                	mov    %ebp,%esp
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    

00801037 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 38             	sub    $0x38,%esp
  80103d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801040:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801043:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7e 28                	jle    801088 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801060:	89 44 24 10          	mov    %eax,0x10(%esp)
  801064:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80106b:	00 
  80106c:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801073:	00 
  801074:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80107b:	00 
  80107c:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801083:	e8 9c 17 00 00       	call   802824 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801088:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80108b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80108e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801091:	89 ec                	mov    %ebp,%esp
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 38             	sub    $0x38,%esp
  80109b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80109e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	89 df                	mov    %ebx,%edi
  8010b6:	89 de                	mov    %ebx,%esi
  8010b8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	7e 28                	jle    8010e6 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010c9:	00 
  8010ca:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  8010d1:	00 
  8010d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d9:	00 
  8010da:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8010e1:	e8 3e 17 00 00       	call   802824 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  8010e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ef:	89 ec                	mov    %ebp,%esp
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 38             	sub    $0x38,%esp
  8010f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801102:	b9 00 00 00 00       	mov    $0x0,%ecx
  801107:	b8 0d 00 00 00       	mov    $0xd,%eax
  80110c:	8b 55 08             	mov    0x8(%ebp),%edx
  80110f:	89 cb                	mov    %ecx,%ebx
  801111:	89 cf                	mov    %ecx,%edi
  801113:	89 ce                	mov    %ecx,%esi
  801115:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801117:	85 c0                	test   %eax,%eax
  801119:	7e 28                	jle    801143 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80111b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801126:	00 
  801127:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  80112e:	00 
  80112f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801136:	00 
  801137:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  80113e:	e8 e1 16 00 00       	call   802824 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801143:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801146:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801149:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80114c:	89 ec                	mov    %ebp,%esp
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	89 1c 24             	mov    %ebx,(%esp)
  801159:	89 74 24 04          	mov    %esi,0x4(%esp)
  80115d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801161:	be 00 00 00 00       	mov    $0x0,%esi
  801166:	b8 0c 00 00 00       	mov    $0xc,%eax
  80116b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80116e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801171:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801179:	8b 1c 24             	mov    (%esp),%ebx
  80117c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801180:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801184:	89 ec                	mov    %ebp,%esp
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 38             	sub    $0x38,%esp
  80118e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801191:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801194:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801197:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a7:	89 df                	mov    %ebx,%edi
  8011a9:	89 de                	mov    %ebx,%esi
  8011ab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	7e 28                	jle    8011d9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011bc:	00 
  8011bd:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  8011c4:	00 
  8011c5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011cc:	00 
  8011cd:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8011d4:	e8 4b 16 00 00       	call   802824 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e2:	89 ec                	mov    %ebp,%esp
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 38             	sub    $0x38,%esp
  8011ec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ef:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011fa:	b8 09 00 00 00       	mov    $0x9,%eax
  8011ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801202:	8b 55 08             	mov    0x8(%ebp),%edx
  801205:	89 df                	mov    %ebx,%edi
  801207:	89 de                	mov    %ebx,%esi
  801209:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80120b:	85 c0                	test   %eax,%eax
  80120d:	7e 28                	jle    801237 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80120f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801213:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80121a:	00 
  80121b:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801222:	00 
  801223:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80122a:	00 
  80122b:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801232:	e8 ed 15 00 00       	call   802824 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801237:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80123a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80123d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801240:	89 ec                	mov    %ebp,%esp
  801242:	5d                   	pop    %ebp
  801243:	c3                   	ret    

00801244 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	83 ec 38             	sub    $0x38,%esp
  80124a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80124d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801250:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801253:	bb 00 00 00 00       	mov    $0x0,%ebx
  801258:	b8 08 00 00 00       	mov    $0x8,%eax
  80125d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801260:	8b 55 08             	mov    0x8(%ebp),%edx
  801263:	89 df                	mov    %ebx,%edi
  801265:	89 de                	mov    %ebx,%esi
  801267:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801269:	85 c0                	test   %eax,%eax
  80126b:	7e 28                	jle    801295 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80126d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801271:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801278:	00 
  801279:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801280:	00 
  801281:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801288:	00 
  801289:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801290:	e8 8f 15 00 00       	call   802824 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801295:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801298:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80129b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80129e:	89 ec                	mov    %ebp,%esp
  8012a0:	5d                   	pop    %ebp
  8012a1:	c3                   	ret    

008012a2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 38             	sub    $0x38,%esp
  8012a8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012ab:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ae:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8012bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012be:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c1:	89 df                	mov    %ebx,%edi
  8012c3:	89 de                	mov    %ebx,%esi
  8012c5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	7e 28                	jle    8012f3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012cf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012d6:	00 
  8012d7:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  8012de:	00 
  8012df:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e6:	00 
  8012e7:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8012ee:	e8 31 15 00 00       	call   802824 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012f3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012f6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012fc:	89 ec                	mov    %ebp,%esp
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 38             	sub    $0x38,%esp
  801306:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801309:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80130c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130f:	b8 05 00 00 00       	mov    $0x5,%eax
  801314:	8b 75 18             	mov    0x18(%ebp),%esi
  801317:	8b 7d 14             	mov    0x14(%ebp),%edi
  80131a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80131d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801320:	8b 55 08             	mov    0x8(%ebp),%edx
  801323:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801325:	85 c0                	test   %eax,%eax
  801327:	7e 28                	jle    801351 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801329:	89 44 24 10          	mov    %eax,0x10(%esp)
  80132d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801334:	00 
  801335:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  80133c:	00 
  80133d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801344:	00 
  801345:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  80134c:	e8 d3 14 00 00       	call   802824 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801351:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801354:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801357:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80135a:	89 ec                	mov    %ebp,%esp
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 38             	sub    $0x38,%esp
  801364:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801367:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80136a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80136d:	be 00 00 00 00       	mov    $0x0,%esi
  801372:	b8 04 00 00 00       	mov    $0x4,%eax
  801377:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80137a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137d:	8b 55 08             	mov    0x8(%ebp),%edx
  801380:	89 f7                	mov    %esi,%edi
  801382:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801384:	85 c0                	test   %eax,%eax
  801386:	7e 28                	jle    8013b0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801388:	89 44 24 10          	mov    %eax,0x10(%esp)
  80138c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801393:	00 
  801394:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  80139b:	00 
  80139c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013a3:	00 
  8013a4:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8013ab:	e8 74 14 00 00       	call   802824 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013b9:	89 ec                	mov    %ebp,%esp
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	89 1c 24             	mov    %ebx,(%esp)
  8013c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ca:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013d8:	89 d1                	mov    %edx,%ecx
  8013da:	89 d3                	mov    %edx,%ebx
  8013dc:	89 d7                	mov    %edx,%edi
  8013de:	89 d6                	mov    %edx,%esi
  8013e0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013e2:	8b 1c 24             	mov    (%esp),%ebx
  8013e5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013e9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ed:	89 ec                	mov    %ebp,%esp
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 0c             	sub    $0xc,%esp
  8013f7:	89 1c 24             	mov    %ebx,(%esp)
  8013fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801402:	ba 00 00 00 00       	mov    $0x0,%edx
  801407:	b8 02 00 00 00       	mov    $0x2,%eax
  80140c:	89 d1                	mov    %edx,%ecx
  80140e:	89 d3                	mov    %edx,%ebx
  801410:	89 d7                	mov    %edx,%edi
  801412:	89 d6                	mov    %edx,%esi
  801414:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801416:	8b 1c 24             	mov    (%esp),%ebx
  801419:	8b 74 24 04          	mov    0x4(%esp),%esi
  80141d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801421:	89 ec                	mov    %ebp,%esp
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 38             	sub    $0x38,%esp
  80142b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80142e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801431:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801434:	b9 00 00 00 00       	mov    $0x0,%ecx
  801439:	b8 03 00 00 00       	mov    $0x3,%eax
  80143e:	8b 55 08             	mov    0x8(%ebp),%edx
  801441:	89 cb                	mov    %ecx,%ebx
  801443:	89 cf                	mov    %ecx,%edi
  801445:	89 ce                	mov    %ecx,%esi
  801447:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801449:	85 c0                	test   %eax,%eax
  80144b:	7e 28                	jle    801475 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80144d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801451:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801458:	00 
  801459:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801460:	00 
  801461:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801468:	00 
  801469:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801470:	e8 af 13 00 00       	call   802824 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801475:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801478:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80147b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80147e:	89 ec                	mov    %ebp,%esp
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    
	...

00801484 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	05 00 00 00 30       	add    $0x30000000,%eax
  80148f:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    

00801494 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	89 04 24             	mov    %eax,(%esp)
  8014a0:	e8 df ff ff ff       	call   801484 <fd2num>
  8014a5:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014aa:	c1 e0 0c             	shl    $0xc,%eax
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	57                   	push   %edi
  8014b3:	56                   	push   %esi
  8014b4:	53                   	push   %ebx
  8014b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014bd:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8014c2:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014c7:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	c1 ea 16             	shr    $0x16,%edx
  8014ce:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8014d1:	f6 c2 01             	test   $0x1,%dl
  8014d4:	74 0d                	je     8014e3 <fd_alloc+0x34>
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	c1 ea 0c             	shr    $0xc,%edx
  8014db:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8014de:	f6 c2 01             	test   $0x1,%dl
  8014e1:	75 09                	jne    8014ec <fd_alloc+0x3d>
			*fd_store = fd;
  8014e3:	89 37                	mov    %esi,(%edi)
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8014ea:	eb 17                	jmp    801503 <fd_alloc+0x54>
  8014ec:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014f1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014f6:	75 cf                	jne    8014c7 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014f8:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8014fe:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801503:	5b                   	pop    %ebx
  801504:	5e                   	pop    %esi
  801505:	5f                   	pop    %edi
  801506:	5d                   	pop    %ebp
  801507:	c3                   	ret    

00801508 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	83 f8 1f             	cmp    $0x1f,%eax
  801511:	77 36                	ja     801549 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801513:	05 00 00 0d 00       	add    $0xd0000,%eax
  801518:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80151b:	89 c2                	mov    %eax,%edx
  80151d:	c1 ea 16             	shr    $0x16,%edx
  801520:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801527:	f6 c2 01             	test   $0x1,%dl
  80152a:	74 1d                	je     801549 <fd_lookup+0x41>
  80152c:	89 c2                	mov    %eax,%edx
  80152e:	c1 ea 0c             	shr    $0xc,%edx
  801531:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801538:	f6 c2 01             	test   $0x1,%dl
  80153b:	74 0c                	je     801549 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80153d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801540:	89 02                	mov    %eax,(%edx)
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801547:	eb 05                	jmp    80154e <fd_lookup+0x46>
  801549:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    

00801550 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801556:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	e8 a0 ff ff ff       	call   801508 <fd_lookup>
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 0e                	js     80157a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80156c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801572:	89 50 04             	mov    %edx,0x4(%eax)
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	83 ec 10             	sub    $0x10,%esp
  801584:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801587:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80158f:	be 30 31 80 00       	mov    $0x803130,%esi
  801594:	eb 10                	jmp    8015a6 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801596:	39 08                	cmp    %ecx,(%eax)
  801598:	75 09                	jne    8015a3 <dev_lookup+0x27>
			*dev = devtab[i];
  80159a:	89 03                	mov    %eax,(%ebx)
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8015a1:	eb 31                	jmp    8015d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015a3:	83 c2 01             	add    $0x1,%edx
  8015a6:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	75 e9                	jne    801596 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015ad:	a1 18 50 80 00       	mov    0x805018,%eax
  8015b2:	8b 40 48             	mov    0x48(%eax),%eax
  8015b5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bd:	c7 04 24 b4 30 80 00 	movl   $0x8030b4,(%esp)
  8015c4:	e8 ec ef ff ff       	call   8005b5 <cprintf>
	*dev = 0;
  8015c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	5b                   	pop    %ebx
  8015d8:	5e                   	pop    %esi
  8015d9:	5d                   	pop    %ebp
  8015da:	c3                   	ret    

008015db <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	53                   	push   %ebx
  8015df:	83 ec 24             	sub    $0x24,%esp
  8015e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	89 04 24             	mov    %eax,(%esp)
  8015f2:	e8 11 ff ff ff       	call   801508 <fd_lookup>
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	78 53                	js     80164e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	8b 00                	mov    (%eax),%eax
  801607:	89 04 24             	mov    %eax,(%esp)
  80160a:	e8 6d ff ff ff       	call   80157c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 3b                	js     80164e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801613:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80161f:	74 2d                	je     80164e <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801621:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801624:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80162b:	00 00 00 
	stat->st_isdir = 0;
  80162e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801635:	00 00 00 
	stat->st_dev = dev;
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801641:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801648:	89 14 24             	mov    %edx,(%esp)
  80164b:	ff 50 14             	call   *0x14(%eax)
}
  80164e:	83 c4 24             	add    $0x24,%esp
  801651:	5b                   	pop    %ebx
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    

00801654 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	53                   	push   %ebx
  801658:	83 ec 24             	sub    $0x24,%esp
  80165b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801661:	89 44 24 04          	mov    %eax,0x4(%esp)
  801665:	89 1c 24             	mov    %ebx,(%esp)
  801668:	e8 9b fe ff ff       	call   801508 <fd_lookup>
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 5f                	js     8016d0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801671:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	89 04 24             	mov    %eax,(%esp)
  801680:	e8 f7 fe ff ff       	call   80157c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801685:	85 c0                	test   %eax,%eax
  801687:	78 47                	js     8016d0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801689:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168c:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801690:	75 23                	jne    8016b5 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801692:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801697:	8b 40 48             	mov    0x48(%eax),%eax
  80169a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80169e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a2:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8016a9:	e8 07 ef ff ff       	call   8005b5 <cprintf>
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016b3:	eb 1b                	jmp    8016d0 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	8b 48 18             	mov    0x18(%eax),%ecx
  8016bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c0:	85 c9                	test   %ecx,%ecx
  8016c2:	74 0c                	je     8016d0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	89 14 24             	mov    %edx,(%esp)
  8016ce:	ff d1                	call   *%ecx
}
  8016d0:	83 c4 24             	add    $0x24,%esp
  8016d3:	5b                   	pop    %ebx
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	53                   	push   %ebx
  8016da:	83 ec 24             	sub    $0x24,%esp
  8016dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e7:	89 1c 24             	mov    %ebx,(%esp)
  8016ea:	e8 19 fe ff ff       	call   801508 <fd_lookup>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 66                	js     801759 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fd:	8b 00                	mov    (%eax),%eax
  8016ff:	89 04 24             	mov    %eax,(%esp)
  801702:	e8 75 fe ff ff       	call   80157c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801707:	85 c0                	test   %eax,%eax
  801709:	78 4e                	js     801759 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80170e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801712:	75 23                	jne    801737 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801714:	a1 18 50 80 00       	mov    0x805018,%eax
  801719:	8b 40 48             	mov    0x48(%eax),%eax
  80171c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801720:	89 44 24 04          	mov    %eax,0x4(%esp)
  801724:	c7 04 24 f5 30 80 00 	movl   $0x8030f5,(%esp)
  80172b:	e8 85 ee ff ff       	call   8005b5 <cprintf>
  801730:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801735:	eb 22                	jmp    801759 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80173d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801742:	85 c9                	test   %ecx,%ecx
  801744:	74 13                	je     801759 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	89 44 24 04          	mov    %eax,0x4(%esp)
  801754:	89 14 24             	mov    %edx,(%esp)
  801757:	ff d1                	call   *%ecx
}
  801759:	83 c4 24             	add    $0x24,%esp
  80175c:	5b                   	pop    %ebx
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    

0080175f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	53                   	push   %ebx
  801763:	83 ec 24             	sub    $0x24,%esp
  801766:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801769:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801770:	89 1c 24             	mov    %ebx,(%esp)
  801773:	e8 90 fd ff ff       	call   801508 <fd_lookup>
  801778:	85 c0                	test   %eax,%eax
  80177a:	78 6b                	js     8017e7 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801786:	8b 00                	mov    (%eax),%eax
  801788:	89 04 24             	mov    %eax,(%esp)
  80178b:	e8 ec fd ff ff       	call   80157c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801790:	85 c0                	test   %eax,%eax
  801792:	78 53                	js     8017e7 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801794:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801797:	8b 42 08             	mov    0x8(%edx),%eax
  80179a:	83 e0 03             	and    $0x3,%eax
  80179d:	83 f8 01             	cmp    $0x1,%eax
  8017a0:	75 23                	jne    8017c5 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a2:	a1 18 50 80 00       	mov    0x805018,%eax
  8017a7:	8b 40 48             	mov    0x48(%eax),%eax
  8017aa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b2:	c7 04 24 12 31 80 00 	movl   $0x803112,(%esp)
  8017b9:	e8 f7 ed ff ff       	call   8005b5 <cprintf>
  8017be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017c3:	eb 22                	jmp    8017e7 <read+0x88>
	}
	if (!dev->dev_read)
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 48 08             	mov    0x8(%eax),%ecx
  8017cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d0:	85 c9                	test   %ecx,%ecx
  8017d2:	74 13                	je     8017e7 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	89 14 24             	mov    %edx,(%esp)
  8017e5:	ff d1                	call   *%ecx
}
  8017e7:	83 c4 24             	add    $0x24,%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    

008017ed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	57                   	push   %edi
  8017f1:	56                   	push   %esi
  8017f2:	53                   	push   %ebx
  8017f3:	83 ec 1c             	sub    $0x1c,%esp
  8017f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017f9:	8b 75 10             	mov    0x10(%ebp),%esi
  8017fc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801801:	eb 21                	jmp    801824 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801803:	89 f2                	mov    %esi,%edx
  801805:	29 c2                	sub    %eax,%edx
  801807:	89 54 24 08          	mov    %edx,0x8(%esp)
  80180b:	03 45 0c             	add    0xc(%ebp),%eax
  80180e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801812:	89 3c 24             	mov    %edi,(%esp)
  801815:	e8 45 ff ff ff       	call   80175f <read>
		if (m < 0)
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 0e                	js     80182c <readn+0x3f>
			return m;
		if (m == 0)
  80181e:	85 c0                	test   %eax,%eax
  801820:	74 08                	je     80182a <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801822:	01 c3                	add    %eax,%ebx
  801824:	89 d8                	mov    %ebx,%eax
  801826:	39 f3                	cmp    %esi,%ebx
  801828:	72 d9                	jb     801803 <readn+0x16>
  80182a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80182c:	83 c4 1c             	add    $0x1c,%esp
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5f                   	pop    %edi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 38             	sub    $0x38,%esp
  80183a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80183d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801840:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801843:	8b 7d 08             	mov    0x8(%ebp),%edi
  801846:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80184a:	89 3c 24             	mov    %edi,(%esp)
  80184d:	e8 32 fc ff ff       	call   801484 <fd2num>
  801852:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801855:	89 54 24 04          	mov    %edx,0x4(%esp)
  801859:	89 04 24             	mov    %eax,(%esp)
  80185c:	e8 a7 fc ff ff       	call   801508 <fd_lookup>
  801861:	89 c3                	mov    %eax,%ebx
  801863:	85 c0                	test   %eax,%eax
  801865:	78 05                	js     80186c <fd_close+0x38>
  801867:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  80186a:	74 0e                	je     80187a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80186c:	89 f0                	mov    %esi,%eax
  80186e:	84 c0                	test   %al,%al
  801870:	b8 00 00 00 00       	mov    $0x0,%eax
  801875:	0f 44 d8             	cmove  %eax,%ebx
  801878:	eb 3d                	jmp    8018b7 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80187a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	8b 07                	mov    (%edi),%eax
  801883:	89 04 24             	mov    %eax,(%esp)
  801886:	e8 f1 fc ff ff       	call   80157c <dev_lookup>
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 16                	js     8018a7 <fd_close+0x73>
		if (dev->dev_close)
  801891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801894:	8b 40 10             	mov    0x10(%eax),%eax
  801897:	bb 00 00 00 00       	mov    $0x0,%ebx
  80189c:	85 c0                	test   %eax,%eax
  80189e:	74 07                	je     8018a7 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8018a0:	89 3c 24             	mov    %edi,(%esp)
  8018a3:	ff d0                	call   *%eax
  8018a5:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b2:	e8 eb f9 ff ff       	call   8012a2 <sys_page_unmap>
	return r;
}
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018c2:	89 ec                	mov    %ebp,%esp
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    

008018c6 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	89 04 24             	mov    %eax,(%esp)
  8018d9:	e8 2a fc ff ff       	call   801508 <fd_lookup>
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 13                	js     8018f5 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8018e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018e9:	00 
  8018ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ed:	89 04 24             	mov    %eax,(%esp)
  8018f0:	e8 3f ff ff ff       	call   801834 <fd_close>
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 18             	sub    $0x18,%esp
  8018fd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801900:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801903:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80190a:	00 
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	89 04 24             	mov    %eax,(%esp)
  801911:	e8 25 04 00 00       	call   801d3b <open>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 1b                	js     801937 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80191c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	89 1c 24             	mov    %ebx,(%esp)
  801926:	e8 b0 fc ff ff       	call   8015db <fstat>
  80192b:	89 c6                	mov    %eax,%esi
	close(fd);
  80192d:	89 1c 24             	mov    %ebx,(%esp)
  801930:	e8 91 ff ff ff       	call   8018c6 <close>
  801935:	89 f3                	mov    %esi,%ebx
	return r;
}
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80193c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80193f:	89 ec                	mov    %ebp,%esp
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	53                   	push   %ebx
  801947:	83 ec 14             	sub    $0x14,%esp
  80194a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  80194f:	89 1c 24             	mov    %ebx,(%esp)
  801952:	e8 6f ff ff ff       	call   8018c6 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801957:	83 c3 01             	add    $0x1,%ebx
  80195a:	83 fb 20             	cmp    $0x20,%ebx
  80195d:	75 f0                	jne    80194f <close_all+0xc>
		close(i);
}
  80195f:	83 c4 14             	add    $0x14,%esp
  801962:	5b                   	pop    %ebx
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 58             	sub    $0x58,%esp
  80196b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80196e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801971:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801974:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801977:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80197a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 04 24             	mov    %eax,(%esp)
  801984:	e8 7f fb ff ff       	call   801508 <fd_lookup>
  801989:	89 c3                	mov    %eax,%ebx
  80198b:	85 c0                	test   %eax,%eax
  80198d:	0f 88 e0 00 00 00    	js     801a73 <dup+0x10e>
		return r;
	close(newfdnum);
  801993:	89 3c 24             	mov    %edi,(%esp)
  801996:	e8 2b ff ff ff       	call   8018c6 <close>

	newfd = INDEX2FD(newfdnum);
  80199b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8019a1:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8019a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a7:	89 04 24             	mov    %eax,(%esp)
  8019aa:	e8 e5 fa ff ff       	call   801494 <fd2data>
  8019af:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019b1:	89 34 24             	mov    %esi,(%esp)
  8019b4:	e8 db fa ff ff       	call   801494 <fd2data>
  8019b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019bc:	89 da                	mov    %ebx,%edx
  8019be:	89 d8                	mov    %ebx,%eax
  8019c0:	c1 e8 16             	shr    $0x16,%eax
  8019c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ca:	a8 01                	test   $0x1,%al
  8019cc:	74 43                	je     801a11 <dup+0xac>
  8019ce:	c1 ea 0c             	shr    $0xc,%edx
  8019d1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019d8:	a8 01                	test   $0x1,%al
  8019da:	74 35                	je     801a11 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019dc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8019e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019fa:	00 
  8019fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a06:	e8 f5 f8 ff ff       	call   801300 <sys_page_map>
  801a0b:	89 c3                	mov    %eax,%ebx
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 3f                	js     801a50 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a14:	89 c2                	mov    %eax,%edx
  801a16:	c1 ea 0c             	shr    $0xc,%edx
  801a19:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a20:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a26:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a2a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a2e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a35:	00 
  801a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a41:	e8 ba f8 ff ff       	call   801300 <sys_page_map>
  801a46:	89 c3                	mov    %eax,%ebx
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 04                	js     801a50 <dup+0xeb>
  801a4c:	89 fb                	mov    %edi,%ebx
  801a4e:	eb 23                	jmp    801a73 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a50:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5b:	e8 42 f8 ff ff       	call   8012a2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6e:	e8 2f f8 ff ff       	call   8012a2 <sys_page_unmap>
	return r;
}
  801a73:	89 d8                	mov    %ebx,%eax
  801a75:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a78:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a7b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a7e:	89 ec                	mov    %ebp,%esp
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    
	...

00801a84 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	56                   	push   %esi
  801a88:	53                   	push   %ebx
  801a89:	83 ec 10             	sub    $0x10,%esp
  801a8c:	89 c3                	mov    %eax,%ebx
  801a8e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a90:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a97:	75 11                	jne    801aaa <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801aa0:	e8 d7 0d 00 00       	call   80287c <ipc_find_env>
  801aa5:	a3 10 50 80 00       	mov    %eax,0x805010

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801aaa:	a1 18 50 80 00       	mov    0x805018,%eax
  801aaf:	8b 40 48             	mov    0x48(%eax),%eax
  801ab2:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801ab8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801abc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac4:	c7 04 24 44 31 80 00 	movl   $0x803144,(%esp)
  801acb:	e8 e5 ea ff ff       	call   8005b5 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ad0:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ad7:	00 
  801ad8:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801adf:	00 
  801ae0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae4:	a1 10 50 80 00       	mov    0x805010,%eax
  801ae9:	89 04 24             	mov    %eax,(%esp)
  801aec:	e8 c1 0d 00 00       	call   8028b2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801af1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801af8:	00 
  801af9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801afd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b04:	e8 15 0e 00 00       	call   80291e <ipc_recv>
}
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b29:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b33:	e8 4c ff ff ff       	call   801a84 <fsipc>
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	8b 40 0c             	mov    0xc(%eax),%eax
  801b46:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b50:	b8 06 00 00 00       	mov    $0x6,%eax
  801b55:	e8 2a ff ff ff       	call   801a84 <fsipc>
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
  801b67:	b8 08 00 00 00       	mov    $0x8,%eax
  801b6c:	e8 13 ff ff ff       	call   801a84 <fsipc>
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	53                   	push   %ebx
  801b77:	83 ec 14             	sub    $0x14,%esp
  801b7a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	8b 40 0c             	mov    0xc(%eax),%eax
  801b83:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b88:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8d:	b8 05 00 00 00       	mov    $0x5,%eax
  801b92:	e8 ed fe ff ff       	call   801a84 <fsipc>
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 2b                	js     801bc6 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b9b:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ba2:	00 
  801ba3:	89 1c 24             	mov    %ebx,(%esp)
  801ba6:	e8 6e f0 ff ff       	call   800c19 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bab:	a1 80 60 80 00       	mov    0x806080,%eax
  801bb0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bb6:	a1 84 60 80 00       	mov    0x806084,%eax
  801bbb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801bc6:	83 c4 14             	add    $0x14,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 14             	sub    $0x14,%esp
  801bd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801be1:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801be7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801bed:	76 24                	jbe    801c13 <devfile_write+0x47>
  801bef:	c7 44 24 0c 5a 31 80 	movl   $0x80315a,0xc(%esp)
  801bf6:	00 
  801bf7:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  801bfe:	00 
  801bff:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801c06:	00 
  801c07:	c7 04 24 79 31 80 00 	movl   $0x803179,(%esp)
  801c0e:	e8 11 0c 00 00       	call   802824 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801c13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1e:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c25:	e8 95 f1 ff ff       	call   800dbf <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2f:	b8 04 00 00 00       	mov    $0x4,%eax
  801c34:	e8 4b fe ff ff       	call   801a84 <fsipc>
	if(ret<0) return ret;
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	78 53                	js     801c90 <devfile_write+0xc4>
	
	assert(ret <= n);
  801c3d:	39 c3                	cmp    %eax,%ebx
  801c3f:	73 24                	jae    801c65 <devfile_write+0x99>
  801c41:	c7 44 24 0c 84 31 80 	movl   $0x803184,0xc(%esp)
  801c48:	00 
  801c49:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  801c50:	00 
  801c51:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c58:	00 
  801c59:	c7 04 24 79 31 80 00 	movl   $0x803179,(%esp)
  801c60:	e8 bf 0b 00 00       	call   802824 <_panic>
	assert(ret <= PGSIZE);
  801c65:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c6a:	7e 24                	jle    801c90 <devfile_write+0xc4>
  801c6c:	c7 44 24 0c 8d 31 80 	movl   $0x80318d,0xc(%esp)
  801c73:	00 
  801c74:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  801c7b:	00 
  801c7c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801c83:	00 
  801c84:	c7 04 24 79 31 80 00 	movl   $0x803179,(%esp)
  801c8b:	e8 94 0b 00 00       	call   802824 <_panic>
	return ret;
}
  801c90:	83 c4 14             	add    $0x14,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    

00801c96 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	56                   	push   %esi
  801c9a:	53                   	push   %ebx
  801c9b:	83 ec 10             	sub    $0x10,%esp
  801c9e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cac:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb7:	b8 03 00 00 00       	mov    $0x3,%eax
  801cbc:	e8 c3 fd ff ff       	call   801a84 <fsipc>
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 6b                	js     801d32 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801cc7:	39 de                	cmp    %ebx,%esi
  801cc9:	73 24                	jae    801cef <devfile_read+0x59>
  801ccb:	c7 44 24 0c 9b 31 80 	movl   $0x80319b,0xc(%esp)
  801cd2:	00 
  801cd3:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  801cda:	00 
  801cdb:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801ce2:	00 
  801ce3:	c7 04 24 79 31 80 00 	movl   $0x803179,(%esp)
  801cea:	e8 35 0b 00 00       	call   802824 <_panic>
	assert(r <= PGSIZE);
  801cef:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801cf5:	7e 24                	jle    801d1b <devfile_read+0x85>
  801cf7:	c7 44 24 0c a2 31 80 	movl   $0x8031a2,0xc(%esp)
  801cfe:	00 
  801cff:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  801d06:	00 
  801d07:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d0e:	00 
  801d0f:	c7 04 24 79 31 80 00 	movl   $0x803179,(%esp)
  801d16:	e8 09 0b 00 00       	call   802824 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d26:	00 
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	89 04 24             	mov    %eax,(%esp)
  801d2d:	e8 8d f0 ff ff       	call   800dbf <memmove>
	return r;
}
  801d32:	89 d8                	mov    %ebx,%eax
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 28             	sub    $0x28,%esp
  801d41:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d44:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d47:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d4a:	89 34 24             	mov    %esi,(%esp)
  801d4d:	e8 8e ee ff ff       	call   800be0 <strlen>
  801d52:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d57:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d5c:	7f 5e                	jg     801dbc <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d61:	89 04 24             	mov    %eax,(%esp)
  801d64:	e8 46 f7 ff ff       	call   8014af <fd_alloc>
  801d69:	89 c3                	mov    %eax,%ebx
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 4d                	js     801dbc <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d73:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d7a:	e8 9a ee ff ff       	call   800c19 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d82:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	e8 f0 fc ff ff       	call   801a84 <fsipc>
  801d94:	89 c3                	mov    %eax,%ebx
  801d96:	85 c0                	test   %eax,%eax
  801d98:	79 15                	jns    801daf <open+0x74>
		fd_close(fd, 0);
  801d9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801da1:	00 
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	89 04 24             	mov    %eax,(%esp)
  801da8:	e8 87 fa ff ff       	call   801834 <fd_close>
		return r;
  801dad:	eb 0d                	jmp    801dbc <open+0x81>
	}

	return fd2num(fd);
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 ca f6 ff ff       	call   801484 <fd2num>
  801dba:	89 c3                	mov    %eax,%ebx
}
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dc1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dc4:	89 ec                	mov    %ebp,%esp
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    
	...

00801dd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801dd6:	c7 44 24 04 ae 31 80 	movl   $0x8031ae,0x4(%esp)
  801ddd:	00 
  801dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de1:	89 04 24             	mov    %eax,(%esp)
  801de4:	e8 30 ee ff ff       	call   800c19 <strcpy>
	return 0;
}
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
  801df4:	83 ec 14             	sub    $0x14,%esp
  801df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dfa:	89 1c 24             	mov    %ebx,(%esp)
  801dfd:	e8 a6 0b 00 00       	call   8029a8 <pageref>
  801e02:	89 c2                	mov    %eax,%edx
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
  801e09:	83 fa 01             	cmp    $0x1,%edx
  801e0c:	75 0b                	jne    801e19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e0e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e11:	89 04 24             	mov    %eax,(%esp)
  801e14:	e8 b1 02 00 00       	call   8020ca <nsipc_close>
	else
		return 0;
}
  801e19:	83 c4 14             	add    $0x14,%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e25:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e2c:	00 
  801e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e41:	89 04 24             	mov    %eax,(%esp)
  801e44:	e8 bd 02 00 00       	call   802106 <nsipc_send>
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e51:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e58:	00 
  801e59:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6d:	89 04 24             	mov    %eax,(%esp)
  801e70:	e8 04 03 00 00       	call   802179 <nsipc_recv>
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	56                   	push   %esi
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 20             	sub    $0x20,%esp
  801e7f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e84:	89 04 24             	mov    %eax,(%esp)
  801e87:	e8 23 f6 ff ff       	call   8014af <fd_alloc>
  801e8c:	89 c3                	mov    %eax,%ebx
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 21                	js     801eb3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e99:	00 
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea8:	e8 b1 f4 ff ff       	call   80135e <sys_page_alloc>
  801ead:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	79 0a                	jns    801ebd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801eb3:	89 34 24             	mov    %esi,(%esp)
  801eb6:	e8 0f 02 00 00       	call   8020ca <nsipc_close>
		return r;
  801ebb:	eb 28                	jmp    801ee5 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ebd:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	89 04 24             	mov    %eax,(%esp)
  801ede:	e8 a1 f5 ff ff       	call   801484 <fd2num>
  801ee3:	89 c3                	mov    %eax,%ebx
}
  801ee5:	89 d8                	mov    %ebx,%eax
  801ee7:	83 c4 20             	add    $0x20,%esp
  801eea:	5b                   	pop    %ebx
  801eeb:	5e                   	pop    %esi
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    

00801eee <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	89 04 24             	mov    %eax,(%esp)
  801f08:	e8 71 01 00 00       	call   80207e <nsipc_socket>
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	78 05                	js     801f16 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801f11:	e8 61 ff ff ff       	call   801e77 <alloc_sockfd>
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f1e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f21:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f25:	89 04 24             	mov    %eax,(%esp)
  801f28:	e8 db f5 ff ff       	call   801508 <fd_lookup>
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 15                	js     801f46 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f34:	8b 0a                	mov    (%edx),%ecx
  801f36:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f3b:	3b 0d 24 40 80 00    	cmp    0x804024,%ecx
  801f41:	75 03                	jne    801f46 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f43:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	e8 c2 ff ff ff       	call   801f18 <fd2sockid>
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 0f                	js     801f69 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f61:	89 04 24             	mov    %eax,(%esp)
  801f64:	e8 3f 01 00 00       	call   8020a8 <nsipc_listen>
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	e8 9f ff ff ff       	call   801f18 <fd2sockid>
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 16                	js     801f93 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801f7d:	8b 55 10             	mov    0x10(%ebp),%edx
  801f80:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f87:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f8b:	89 04 24             	mov    %eax,(%esp)
  801f8e:	e8 66 02 00 00       	call   8021f9 <nsipc_connect>
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	e8 75 ff ff ff       	call   801f18 <fd2sockid>
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 0f                	js     801fb6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fae:	89 04 24             	mov    %eax,(%esp)
  801fb1:	e8 2e 01 00 00       	call   8020e4 <nsipc_shutdown>
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	e8 52 ff ff ff       	call   801f18 <fd2sockid>
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	78 16                	js     801fe0 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801fca:	8b 55 10             	mov    0x10(%ebp),%edx
  801fcd:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fd8:	89 04 24             	mov    %eax,(%esp)
  801fdb:	e8 58 02 00 00       	call   802238 <nsipc_bind>
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	e8 28 ff ff ff       	call   801f18 <fd2sockid>
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 1f                	js     802013 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff4:	8b 55 10             	mov    0x10(%ebp),%edx
  801ff7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffe:	89 54 24 04          	mov    %edx,0x4(%esp)
  802002:	89 04 24             	mov    %eax,(%esp)
  802005:	e8 6d 02 00 00       	call   802277 <nsipc_accept>
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 05                	js     802013 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80200e:	e8 64 fe ff ff       	call   801e77 <alloc_sockfd>
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    
  802015:	00 00                	add    %al,(%eax)
	...

00802018 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	53                   	push   %ebx
  80201c:	83 ec 14             	sub    $0x14,%esp
  80201f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802021:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802028:	75 11                	jne    80203b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80202a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802031:	e8 46 08 00 00       	call   80287c <ipc_find_env>
  802036:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80203b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802042:	00 
  802043:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80204a:	00 
  80204b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80204f:	a1 14 50 80 00       	mov    0x805014,%eax
  802054:	89 04 24             	mov    %eax,(%esp)
  802057:	e8 56 08 00 00       	call   8028b2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80205c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802063:	00 
  802064:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80206b:	00 
  80206c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802073:	e8 a6 08 00 00       	call   80291e <ipc_recv>
}
  802078:	83 c4 14             	add    $0x14,%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802094:	8b 45 10             	mov    0x10(%ebp),%eax
  802097:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80209c:	b8 09 00 00 00       	mov    $0x9,%eax
  8020a1:	e8 72 ff ff ff       	call   802018 <nsipc>
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8020b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8020be:	b8 06 00 00 00       	mov    $0x6,%eax
  8020c3:	e8 50 ff ff ff       	call   802018 <nsipc>
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8020d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8020dd:	e8 36 ff ff ff       	call   802018 <nsipc>
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8020f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f5:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8020fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8020ff:	e8 14 ff ff ff       	call   802018 <nsipc>
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	53                   	push   %ebx
  80210a:	83 ec 14             	sub    $0x14,%esp
  80210d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802118:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80211e:	7e 24                	jle    802144 <nsipc_send+0x3e>
  802120:	c7 44 24 0c ba 31 80 	movl   $0x8031ba,0xc(%esp)
  802127:	00 
  802128:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  80212f:	00 
  802130:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802137:	00 
  802138:	c7 04 24 c6 31 80 00 	movl   $0x8031c6,(%esp)
  80213f:	e8 e0 06 00 00       	call   802824 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802144:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802156:	e8 64 ec ff ff       	call   800dbf <memmove>
	nsipcbuf.send.req_size = size;
  80215b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802161:	8b 45 14             	mov    0x14(%ebp),%eax
  802164:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802169:	b8 08 00 00 00       	mov    $0x8,%eax
  80216e:	e8 a5 fe ff ff       	call   802018 <nsipc>
}
  802173:	83 c4 14             	add    $0x14,%esp
  802176:	5b                   	pop    %ebx
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    

00802179 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	56                   	push   %esi
  80217d:	53                   	push   %ebx
  80217e:	83 ec 10             	sub    $0x10,%esp
  802181:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80218c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802192:	8b 45 14             	mov    0x14(%ebp),%eax
  802195:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80219a:	b8 07 00 00 00       	mov    $0x7,%eax
  80219f:	e8 74 fe ff ff       	call   802018 <nsipc>
  8021a4:	89 c3                	mov    %eax,%ebx
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 46                	js     8021f0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021aa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021af:	7f 04                	jg     8021b5 <nsipc_recv+0x3c>
  8021b1:	39 c6                	cmp    %eax,%esi
  8021b3:	7d 24                	jge    8021d9 <nsipc_recv+0x60>
  8021b5:	c7 44 24 0c d2 31 80 	movl   $0x8031d2,0xc(%esp)
  8021bc:	00 
  8021bd:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  8021c4:	00 
  8021c5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8021cc:	00 
  8021cd:	c7 04 24 c6 31 80 00 	movl   $0x8031c6,(%esp)
  8021d4:	e8 4b 06 00 00       	call   802824 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021dd:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8021e4:	00 
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	89 04 24             	mov    %eax,(%esp)
  8021eb:	e8 cf eb ff ff       	call   800dbf <memmove>
	}

	return r;
}
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    

008021f9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 14             	sub    $0x14,%esp
  802200:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80220b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80220f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802212:	89 44 24 04          	mov    %eax,0x4(%esp)
  802216:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80221d:	e8 9d eb ff ff       	call   800dbf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802222:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802228:	b8 05 00 00 00       	mov    $0x5,%eax
  80222d:	e8 e6 fd ff ff       	call   802018 <nsipc>
}
  802232:	83 c4 14             	add    $0x14,%esp
  802235:	5b                   	pop    %ebx
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    

00802238 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	53                   	push   %ebx
  80223c:	83 ec 14             	sub    $0x14,%esp
  80223f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80224a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80224e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802251:	89 44 24 04          	mov    %eax,0x4(%esp)
  802255:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80225c:	e8 5e eb ff ff       	call   800dbf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802261:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802267:	b8 02 00 00 00       	mov    $0x2,%eax
  80226c:	e8 a7 fd ff ff       	call   802018 <nsipc>
}
  802271:	83 c4 14             	add    $0x14,%esp
  802274:	5b                   	pop    %ebx
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    

00802277 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 28             	sub    $0x28,%esp
  80227d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802280:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802283:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802286:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802291:	8b 07                	mov    (%edi),%eax
  802293:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802298:	b8 01 00 00 00       	mov    $0x1,%eax
  80229d:	e8 76 fd ff ff       	call   802018 <nsipc>
  8022a2:	89 c6                	mov    %eax,%esi
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 22                	js     8022ca <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022a8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8022ad:	8b 03                	mov    (%ebx),%eax
  8022af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8022ba:	00 
  8022bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022be:	89 04 24             	mov    %eax,(%esp)
  8022c1:	e8 f9 ea ff ff       	call   800dbf <memmove>
		*addrlen = ret->ret_addrlen;
  8022c6:	8b 03                	mov    (%ebx),%eax
  8022c8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8022ca:	89 f0                	mov    %esi,%eax
  8022cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022d5:	89 ec                	mov    %ebp,%esp
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    
  8022d9:	00 00                	add    %al,(%eax)
	...

008022dc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 18             	sub    $0x18,%esp
  8022e2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8022e5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8022e8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	89 04 24             	mov    %eax,(%esp)
  8022f1:	e8 9e f1 ff ff       	call   801494 <fd2data>
  8022f6:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8022f8:	c7 44 24 04 e7 31 80 	movl   $0x8031e7,0x4(%esp)
  8022ff:	00 
  802300:	89 34 24             	mov    %esi,(%esp)
  802303:	e8 11 e9 ff ff       	call   800c19 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802308:	8b 43 04             	mov    0x4(%ebx),%eax
  80230b:	2b 03                	sub    (%ebx),%eax
  80230d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802313:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80231a:	00 00 00 
	stat->st_dev = &devpipe;
  80231d:	c7 86 88 00 00 00 40 	movl   $0x804040,0x88(%esi)
  802324:	40 80 00 
	return 0;
}
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80232f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802332:	89 ec                	mov    %ebp,%esp
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	53                   	push   %ebx
  80233a:	83 ec 14             	sub    $0x14,%esp
  80233d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802340:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80234b:	e8 52 ef ff ff       	call   8012a2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802350:	89 1c 24             	mov    %ebx,(%esp)
  802353:	e8 3c f1 ff ff       	call   801494 <fd2data>
  802358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802363:	e8 3a ef ff ff       	call   8012a2 <sys_page_unmap>
}
  802368:	83 c4 14             	add    $0x14,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 2c             	sub    $0x2c,%esp
  802377:	89 c7                	mov    %eax,%edi
  802379:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80237c:	a1 18 50 80 00       	mov    0x805018,%eax
  802381:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802384:	89 3c 24             	mov    %edi,(%esp)
  802387:	e8 1c 06 00 00       	call   8029a8 <pageref>
  80238c:	89 c6                	mov    %eax,%esi
  80238e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802391:	89 04 24             	mov    %eax,(%esp)
  802394:	e8 0f 06 00 00       	call   8029a8 <pageref>
  802399:	39 c6                	cmp    %eax,%esi
  80239b:	0f 94 c0             	sete   %al
  80239e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8023a1:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8023a7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023aa:	39 cb                	cmp    %ecx,%ebx
  8023ac:	75 08                	jne    8023b6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8023ae:	83 c4 2c             	add    $0x2c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8023b6:	83 f8 01             	cmp    $0x1,%eax
  8023b9:	75 c1                	jne    80237c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023bb:	8b 52 58             	mov    0x58(%edx),%edx
  8023be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023c2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023ca:	c7 04 24 ee 31 80 00 	movl   $0x8031ee,(%esp)
  8023d1:	e8 df e1 ff ff       	call   8005b5 <cprintf>
  8023d6:	eb a4                	jmp    80237c <_pipeisclosed+0xe>

008023d8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	57                   	push   %edi
  8023dc:	56                   	push   %esi
  8023dd:	53                   	push   %ebx
  8023de:	83 ec 1c             	sub    $0x1c,%esp
  8023e1:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023e4:	89 34 24             	mov    %esi,(%esp)
  8023e7:	e8 a8 f0 ff ff       	call   801494 <fd2data>
  8023ec:	89 c3                	mov    %eax,%ebx
  8023ee:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023f3:	eb 48                	jmp    80243d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8023f5:	89 da                	mov    %ebx,%edx
  8023f7:	89 f0                	mov    %esi,%eax
  8023f9:	e8 70 ff ff ff       	call   80236e <_pipeisclosed>
  8023fe:	85 c0                	test   %eax,%eax
  802400:	74 07                	je     802409 <devpipe_write+0x31>
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	eb 3b                	jmp    802444 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802409:	e8 af ef ff ff       	call   8013bd <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80240e:	8b 43 04             	mov    0x4(%ebx),%eax
  802411:	8b 13                	mov    (%ebx),%edx
  802413:	83 c2 20             	add    $0x20,%edx
  802416:	39 d0                	cmp    %edx,%eax
  802418:	73 db                	jae    8023f5 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80241a:	89 c2                	mov    %eax,%edx
  80241c:	c1 fa 1f             	sar    $0x1f,%edx
  80241f:	c1 ea 1b             	shr    $0x1b,%edx
  802422:	01 d0                	add    %edx,%eax
  802424:	83 e0 1f             	and    $0x1f,%eax
  802427:	29 d0                	sub    %edx,%eax
  802429:	89 c2                	mov    %eax,%edx
  80242b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80242e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802432:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802436:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80243a:	83 c7 01             	add    $0x1,%edi
  80243d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802440:	72 cc                	jb     80240e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802442:	89 f8                	mov    %edi,%eax
}
  802444:	83 c4 1c             	add    $0x1c,%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5f                   	pop    %edi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    

0080244c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 28             	sub    $0x28,%esp
  802452:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802455:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802458:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80245b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80245e:	89 3c 24             	mov    %edi,(%esp)
  802461:	e8 2e f0 ff ff       	call   801494 <fd2data>
  802466:	89 c3                	mov    %eax,%ebx
  802468:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80246d:	eb 48                	jmp    8024b7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80246f:	85 f6                	test   %esi,%esi
  802471:	74 04                	je     802477 <devpipe_read+0x2b>
				return i;
  802473:	89 f0                	mov    %esi,%eax
  802475:	eb 47                	jmp    8024be <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802477:	89 da                	mov    %ebx,%edx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	e8 ee fe ff ff       	call   80236e <_pipeisclosed>
  802480:	85 c0                	test   %eax,%eax
  802482:	74 07                	je     80248b <devpipe_read+0x3f>
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	eb 33                	jmp    8024be <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80248b:	e8 2d ef ff ff       	call   8013bd <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802490:	8b 03                	mov    (%ebx),%eax
  802492:	3b 43 04             	cmp    0x4(%ebx),%eax
  802495:	74 d8                	je     80246f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802497:	89 c2                	mov    %eax,%edx
  802499:	c1 fa 1f             	sar    $0x1f,%edx
  80249c:	c1 ea 1b             	shr    $0x1b,%edx
  80249f:	01 d0                	add    %edx,%eax
  8024a1:	83 e0 1f             	and    $0x1f,%eax
  8024a4:	29 d0                	sub    %edx,%eax
  8024a6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ae:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8024b1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b4:	83 c6 01             	add    $0x1,%esi
  8024b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024ba:	72 d4                	jb     802490 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024bc:	89 f0                	mov    %esi,%eax
}
  8024be:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8024c1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8024c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8024c7:	89 ec                	mov    %ebp,%esp
  8024c9:	5d                   	pop    %ebp
  8024ca:	c3                   	ret    

008024cb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	89 04 24             	mov    %eax,(%esp)
  8024de:	e8 25 f0 ff ff       	call   801508 <fd_lookup>
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	78 15                	js     8024fc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	89 04 24             	mov    %eax,(%esp)
  8024ed:	e8 a2 ef ff ff       	call   801494 <fd2data>
	return _pipeisclosed(fd, p);
  8024f2:	89 c2                	mov    %eax,%edx
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	e8 72 fe ff ff       	call   80236e <_pipeisclosed>
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 48             	sub    $0x48,%esp
  802504:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802507:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80250a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802510:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802513:	89 04 24             	mov    %eax,(%esp)
  802516:	e8 94 ef ff ff       	call   8014af <fd_alloc>
  80251b:	89 c3                	mov    %eax,%ebx
  80251d:	85 c0                	test   %eax,%eax
  80251f:	0f 88 42 01 00 00    	js     802667 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802525:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80252c:	00 
  80252d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802530:	89 44 24 04          	mov    %eax,0x4(%esp)
  802534:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80253b:	e8 1e ee ff ff       	call   80135e <sys_page_alloc>
  802540:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802542:	85 c0                	test   %eax,%eax
  802544:	0f 88 1d 01 00 00    	js     802667 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80254a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80254d:	89 04 24             	mov    %eax,(%esp)
  802550:	e8 5a ef ff ff       	call   8014af <fd_alloc>
  802555:	89 c3                	mov    %eax,%ebx
  802557:	85 c0                	test   %eax,%eax
  802559:	0f 88 f5 00 00 00    	js     802654 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802566:	00 
  802567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802575:	e8 e4 ed ff ff       	call   80135e <sys_page_alloc>
  80257a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80257c:	85 c0                	test   %eax,%eax
  80257e:	0f 88 d0 00 00 00    	js     802654 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802587:	89 04 24             	mov    %eax,(%esp)
  80258a:	e8 05 ef ff ff       	call   801494 <fd2data>
  80258f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802591:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802598:	00 
  802599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a4:	e8 b5 ed ff ff       	call   80135e <sys_page_alloc>
  8025a9:	89 c3                	mov    %eax,%ebx
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 88 8e 00 00 00    	js     802641 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b6:	89 04 24             	mov    %eax,(%esp)
  8025b9:	e8 d6 ee ff ff       	call   801494 <fd2data>
  8025be:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025c5:	00 
  8025c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025d1:	00 
  8025d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025dd:	e8 1e ed ff ff       	call   801300 <sys_page_map>
  8025e2:	89 c3                	mov    %eax,%ebx
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	78 49                	js     802631 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025e8:	b8 40 40 80 00       	mov    $0x804040,%eax
  8025ed:	8b 08                	mov    (%eax),%ecx
  8025ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f2:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8025fe:	8b 10                	mov    (%eax),%edx
  802600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802603:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802608:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80260f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802612:	89 04 24             	mov    %eax,(%esp)
  802615:	e8 6a ee ff ff       	call   801484 <fd2num>
  80261a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80261c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261f:	89 04 24             	mov    %eax,(%esp)
  802622:	e8 5d ee ff ff       	call   801484 <fd2num>
  802627:	89 47 04             	mov    %eax,0x4(%edi)
  80262a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80262f:	eb 36                	jmp    802667 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802631:	89 74 24 04          	mov    %esi,0x4(%esp)
  802635:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80263c:	e8 61 ec ff ff       	call   8012a2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80264f:	e8 4e ec ff ff       	call   8012a2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80265b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802662:	e8 3b ec ff ff       	call   8012a2 <sys_page_unmap>
    err:
	return r;
}
  802667:	89 d8                	mov    %ebx,%eax
  802669:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80266c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80266f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802672:	89 ec                	mov    %ebp,%esp
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
	...

00802680 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    

0080268a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802690:	c7 44 24 04 06 32 80 	movl   $0x803206,0x4(%esp)
  802697:	00 
  802698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269b:	89 04 24             	mov    %eax,(%esp)
  80269e:	e8 76 e5 ff ff       	call   800c19 <strcpy>
	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	57                   	push   %edi
  8026ae:	56                   	push   %esi
  8026af:	53                   	push   %ebx
  8026b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8026b6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026c1:	eb 34                	jmp    8026f7 <devcons_write+0x4d>
		m = n - tot;
  8026c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026c6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8026c8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8026ce:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026d3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026da:	03 45 0c             	add    0xc(%ebp),%eax
  8026dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e1:	89 3c 24             	mov    %edi,(%esp)
  8026e4:	e8 d6 e6 ff ff       	call   800dbf <memmove>
		sys_cputs(buf, m);
  8026e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026ed:	89 3c 24             	mov    %edi,(%esp)
  8026f0:	e8 db e8 ff ff       	call   800fd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026f5:	01 de                	add    %ebx,%esi
  8026f7:	89 f0                	mov    %esi,%eax
  8026f9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026fc:	72 c5                	jb     8026c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8026fe:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802704:	5b                   	pop    %ebx
  802705:	5e                   	pop    %esi
  802706:	5f                   	pop    %edi
  802707:	5d                   	pop    %ebp
  802708:	c3                   	ret    

00802709 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802715:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80271c:	00 
  80271d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802720:	89 04 24             	mov    %eax,(%esp)
  802723:	e8 a8 e8 ff ff       	call   800fd0 <sys_cputs>
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802730:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802734:	75 07                	jne    80273d <devcons_read+0x13>
  802736:	eb 28                	jmp    802760 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802738:	e8 80 ec ff ff       	call   8013bd <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	e8 57 e8 ff ff       	call   800f9c <sys_cgetc>
  802745:	85 c0                	test   %eax,%eax
  802747:	74 ef                	je     802738 <devcons_read+0xe>
  802749:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80274b:	85 c0                	test   %eax,%eax
  80274d:	78 16                	js     802765 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80274f:	83 f8 04             	cmp    $0x4,%eax
  802752:	74 0c                	je     802760 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802754:	8b 45 0c             	mov    0xc(%ebp),%eax
  802757:	88 10                	mov    %dl,(%eax)
  802759:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80275e:	eb 05                	jmp    802765 <devcons_read+0x3b>
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80276d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802770:	89 04 24             	mov    %eax,(%esp)
  802773:	e8 37 ed ff ff       	call   8014af <fd_alloc>
  802778:	85 c0                	test   %eax,%eax
  80277a:	78 3f                	js     8027bb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80277c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802783:	00 
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802792:	e8 c7 eb ff ff       	call   80135e <sys_page_alloc>
  802797:	85 c0                	test   %eax,%eax
  802799:	78 20                	js     8027bb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80279b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	89 04 24             	mov    %eax,(%esp)
  8027b6:	e8 c9 ec ff ff       	call   801484 <fd2num>
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	89 04 24             	mov    %eax,(%esp)
  8027d0:	e8 33 ed ff ff       	call   801508 <fd_lookup>
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	78 11                	js     8027ea <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	3b 05 5c 40 80 00    	cmp    0x80405c,%eax
  8027e4:	0f 94 c0             	sete   %al
  8027e7:	0f b6 c0             	movzbl %al,%eax
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027f9:	00 
  8027fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802801:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802808:	e8 52 ef ff ff       	call   80175f <read>
	if (r < 0)
  80280d:	85 c0                	test   %eax,%eax
  80280f:	78 0f                	js     802820 <getchar+0x34>
		return r;
	if (r < 1)
  802811:	85 c0                	test   %eax,%eax
  802813:	7f 07                	jg     80281c <getchar+0x30>
  802815:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80281a:	eb 04                	jmp    802820 <getchar+0x34>
		return -E_EOF;
	return c;
  80281c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    
	...

00802824 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802824:	55                   	push   %ebp
  802825:	89 e5                	mov    %esp,%ebp
  802827:	56                   	push   %esi
  802828:	53                   	push   %ebx
  802829:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80282c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80282f:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  802835:	e8 b7 eb ff ff       	call   8013f1 <sys_getenvid>
  80283a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283d:	89 54 24 10          	mov    %edx,0x10(%esp)
  802841:	8b 55 08             	mov    0x8(%ebp),%edx
  802844:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802848:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80284c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802850:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  802857:	e8 59 dd ff ff       	call   8005b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80285c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802860:	8b 45 10             	mov    0x10(%ebp),%eax
  802863:	89 04 24             	mov    %eax,(%esp)
  802866:	e8 e9 dc ff ff       	call   800554 <vcprintf>
	cprintf("\n");
  80286b:	c7 04 24 14 2d 80 00 	movl   $0x802d14,(%esp)
  802872:	e8 3e dd ff ff       	call   8005b5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802877:	cc                   	int3   
  802878:	eb fd                	jmp    802877 <_panic+0x53>
	...

0080287c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802882:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802887:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80288a:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802890:	8b 12                	mov    (%edx),%edx
  802892:	39 ca                	cmp    %ecx,%edx
  802894:	75 0c                	jne    8028a2 <ipc_find_env+0x26>
			return envs[i].env_id;
  802896:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802899:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	eb 0e                	jmp    8028b0 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028a2:	83 c0 01             	add    $0x1,%eax
  8028a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028aa:	75 db                	jne    802887 <ipc_find_env+0xb>
  8028ac:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8028b0:	5d                   	pop    %ebp
  8028b1:	c3                   	ret    

008028b2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
  8028b5:	57                   	push   %edi
  8028b6:	56                   	push   %esi
  8028b7:	53                   	push   %ebx
  8028b8:	83 ec 2c             	sub    $0x2c,%esp
  8028bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8028be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8028c4:	85 db                	test   %ebx,%ebx
  8028c6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028cb:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8028ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028d5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028dd:	89 34 24             	mov    %esi,(%esp)
  8028e0:	e8 6b e8 ff ff       	call   801150 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8028e5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028e8:	74 e4                	je     8028ce <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 28                	je     802916 <ipc_send+0x64>
  8028ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028f2:	c7 44 24 0c 55 32 80 	movl   $0x803255,0xc(%esp)
  8028f9:	00 
  8028fa:	c7 44 24 08 38 32 80 	movl   $0x803238,0x8(%esp)
  802901:	00 
  802902:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802909:	00 
  80290a:	c7 04 24 4b 32 80 00 	movl   $0x80324b,(%esp)
  802911:	e8 0e ff ff ff       	call   802824 <_panic>
	//if(!ret) sys_yield();
}
  802916:	83 c4 2c             	add    $0x2c,%esp
  802919:	5b                   	pop    %ebx
  80291a:	5e                   	pop    %esi
  80291b:	5f                   	pop    %edi
  80291c:	5d                   	pop    %ebp
  80291d:	c3                   	ret    

0080291e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
  802921:	83 ec 28             	sub    $0x28,%esp
  802924:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802927:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80292a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80292d:	8b 75 08             	mov    0x8(%ebp),%esi
  802930:	8b 45 0c             	mov    0xc(%ebp),%eax
  802933:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802936:	85 c0                	test   %eax,%eax
  802938:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80293d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802940:	89 04 24             	mov    %eax,(%esp)
  802943:	e8 ab e7 ff ff       	call   8010f3 <sys_ipc_recv>
  802948:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80294a:	e8 a2 ea ff ff       	call   8013f1 <sys_getenvid>
  80294f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802954:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802957:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80295c:	a3 18 50 80 00       	mov    %eax,0x805018
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802961:	85 f6                	test   %esi,%esi
  802963:	74 0e                	je     802973 <ipc_recv+0x55>
  802965:	ba 00 00 00 00       	mov    $0x0,%edx
  80296a:	85 db                	test   %ebx,%ebx
  80296c:	75 03                	jne    802971 <ipc_recv+0x53>
  80296e:	8b 50 74             	mov    0x74(%eax),%edx
  802971:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802973:	85 ff                	test   %edi,%edi
  802975:	74 13                	je     80298a <ipc_recv+0x6c>
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	85 db                	test   %ebx,%ebx
  80297e:	75 08                	jne    802988 <ipc_recv+0x6a>
  802980:	a1 18 50 80 00       	mov    0x805018,%eax
  802985:	8b 40 78             	mov    0x78(%eax),%eax
  802988:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  80298a:	85 db                	test   %ebx,%ebx
  80298c:	75 08                	jne    802996 <ipc_recv+0x78>
  80298e:	a1 18 50 80 00       	mov    0x805018,%eax
  802993:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802996:	89 d8                	mov    %ebx,%eax
  802998:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80299b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80299e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029a1:	89 ec                	mov    %ebp,%esp
  8029a3:	5d                   	pop    %ebp
  8029a4:	c3                   	ret    
  8029a5:	00 00                	add    %al,(%eax)
	...

008029a8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	89 c2                	mov    %eax,%edx
  8029b0:	c1 ea 16             	shr    $0x16,%edx
  8029b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029ba:	f6 c2 01             	test   $0x1,%dl
  8029bd:	74 20                	je     8029df <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  8029bf:	c1 e8 0c             	shr    $0xc,%eax
  8029c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029c9:	a8 01                	test   $0x1,%al
  8029cb:	74 12                	je     8029df <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029cd:	c1 e8 0c             	shr    $0xc,%eax
  8029d0:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8029d5:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  8029da:	0f b7 c0             	movzwl %ax,%eax
  8029dd:	eb 05                	jmp    8029e4 <pageref+0x3c>
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    
	...

008029f0 <__udivdi3>:
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
  8029f3:	57                   	push   %edi
  8029f4:	56                   	push   %esi
  8029f5:	83 ec 10             	sub    $0x10,%esp
  8029f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8029fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fe:	8b 75 10             	mov    0x10(%ebp),%esi
  802a01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a04:	85 c0                	test   %eax,%eax
  802a06:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802a09:	75 35                	jne    802a40 <__udivdi3+0x50>
  802a0b:	39 fe                	cmp    %edi,%esi
  802a0d:	77 61                	ja     802a70 <__udivdi3+0x80>
  802a0f:	85 f6                	test   %esi,%esi
  802a11:	75 0b                	jne    802a1e <__udivdi3+0x2e>
  802a13:	b8 01 00 00 00       	mov    $0x1,%eax
  802a18:	31 d2                	xor    %edx,%edx
  802a1a:	f7 f6                	div    %esi
  802a1c:	89 c6                	mov    %eax,%esi
  802a1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a21:	31 d2                	xor    %edx,%edx
  802a23:	89 f8                	mov    %edi,%eax
  802a25:	f7 f6                	div    %esi
  802a27:	89 c7                	mov    %eax,%edi
  802a29:	89 c8                	mov    %ecx,%eax
  802a2b:	f7 f6                	div    %esi
  802a2d:	89 c1                	mov    %eax,%ecx
  802a2f:	89 fa                	mov    %edi,%edx
  802a31:	89 c8                	mov    %ecx,%eax
  802a33:	83 c4 10             	add    $0x10,%esp
  802a36:	5e                   	pop    %esi
  802a37:	5f                   	pop    %edi
  802a38:	5d                   	pop    %ebp
  802a39:	c3                   	ret    
  802a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a40:	39 f8                	cmp    %edi,%eax
  802a42:	77 1c                	ja     802a60 <__udivdi3+0x70>
  802a44:	0f bd d0             	bsr    %eax,%edx
  802a47:	83 f2 1f             	xor    $0x1f,%edx
  802a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a4d:	75 39                	jne    802a88 <__udivdi3+0x98>
  802a4f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802a52:	0f 86 a0 00 00 00    	jbe    802af8 <__udivdi3+0x108>
  802a58:	39 f8                	cmp    %edi,%eax
  802a5a:	0f 82 98 00 00 00    	jb     802af8 <__udivdi3+0x108>
  802a60:	31 ff                	xor    %edi,%edi
  802a62:	31 c9                	xor    %ecx,%ecx
  802a64:	89 c8                	mov    %ecx,%eax
  802a66:	89 fa                	mov    %edi,%edx
  802a68:	83 c4 10             	add    $0x10,%esp
  802a6b:	5e                   	pop    %esi
  802a6c:	5f                   	pop    %edi
  802a6d:	5d                   	pop    %ebp
  802a6e:	c3                   	ret    
  802a6f:	90                   	nop
  802a70:	89 d1                	mov    %edx,%ecx
  802a72:	89 fa                	mov    %edi,%edx
  802a74:	89 c8                	mov    %ecx,%eax
  802a76:	31 ff                	xor    %edi,%edi
  802a78:	f7 f6                	div    %esi
  802a7a:	89 c1                	mov    %eax,%ecx
  802a7c:	89 fa                	mov    %edi,%edx
  802a7e:	89 c8                	mov    %ecx,%eax
  802a80:	83 c4 10             	add    $0x10,%esp
  802a83:	5e                   	pop    %esi
  802a84:	5f                   	pop    %edi
  802a85:	5d                   	pop    %ebp
  802a86:	c3                   	ret    
  802a87:	90                   	nop
  802a88:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802a8c:	89 f2                	mov    %esi,%edx
  802a8e:	d3 e0                	shl    %cl,%eax
  802a90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a93:	b8 20 00 00 00       	mov    $0x20,%eax
  802a98:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a9b:	89 c1                	mov    %eax,%ecx
  802a9d:	d3 ea                	shr    %cl,%edx
  802a9f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aa3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802aa6:	d3 e6                	shl    %cl,%esi
  802aa8:	89 c1                	mov    %eax,%ecx
  802aaa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802aad:	89 fe                	mov    %edi,%esi
  802aaf:	d3 ee                	shr    %cl,%esi
  802ab1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ab5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abb:	d3 e7                	shl    %cl,%edi
  802abd:	89 c1                	mov    %eax,%ecx
  802abf:	d3 ea                	shr    %cl,%edx
  802ac1:	09 d7                	or     %edx,%edi
  802ac3:	89 f2                	mov    %esi,%edx
  802ac5:	89 f8                	mov    %edi,%eax
  802ac7:	f7 75 ec             	divl   -0x14(%ebp)
  802aca:	89 d6                	mov    %edx,%esi
  802acc:	89 c7                	mov    %eax,%edi
  802ace:	f7 65 e8             	mull   -0x18(%ebp)
  802ad1:	39 d6                	cmp    %edx,%esi
  802ad3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ad6:	72 30                	jb     802b08 <__udivdi3+0x118>
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802adf:	d3 e2                	shl    %cl,%edx
  802ae1:	39 c2                	cmp    %eax,%edx
  802ae3:	73 05                	jae    802aea <__udivdi3+0xfa>
  802ae5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802ae8:	74 1e                	je     802b08 <__udivdi3+0x118>
  802aea:	89 f9                	mov    %edi,%ecx
  802aec:	31 ff                	xor    %edi,%edi
  802aee:	e9 71 ff ff ff       	jmp    802a64 <__udivdi3+0x74>
  802af3:	90                   	nop
  802af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802af8:	31 ff                	xor    %edi,%edi
  802afa:	b9 01 00 00 00       	mov    $0x1,%ecx
  802aff:	e9 60 ff ff ff       	jmp    802a64 <__udivdi3+0x74>
  802b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b08:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802b0b:	31 ff                	xor    %edi,%edi
  802b0d:	89 c8                	mov    %ecx,%eax
  802b0f:	89 fa                	mov    %edi,%edx
  802b11:	83 c4 10             	add    $0x10,%esp
  802b14:	5e                   	pop    %esi
  802b15:	5f                   	pop    %edi
  802b16:	5d                   	pop    %ebp
  802b17:	c3                   	ret    
	...

00802b20 <__umoddi3>:
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
  802b23:	57                   	push   %edi
  802b24:	56                   	push   %esi
  802b25:	83 ec 20             	sub    $0x20,%esp
  802b28:	8b 55 14             	mov    0x14(%ebp),%edx
  802b2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b2e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802b31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b34:	85 d2                	test   %edx,%edx
  802b36:	89 c8                	mov    %ecx,%eax
  802b38:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802b3b:	75 13                	jne    802b50 <__umoddi3+0x30>
  802b3d:	39 f7                	cmp    %esi,%edi
  802b3f:	76 3f                	jbe    802b80 <__umoddi3+0x60>
  802b41:	89 f2                	mov    %esi,%edx
  802b43:	f7 f7                	div    %edi
  802b45:	89 d0                	mov    %edx,%eax
  802b47:	31 d2                	xor    %edx,%edx
  802b49:	83 c4 20             	add    $0x20,%esp
  802b4c:	5e                   	pop    %esi
  802b4d:	5f                   	pop    %edi
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    
  802b50:	39 f2                	cmp    %esi,%edx
  802b52:	77 4c                	ja     802ba0 <__umoddi3+0x80>
  802b54:	0f bd ca             	bsr    %edx,%ecx
  802b57:	83 f1 1f             	xor    $0x1f,%ecx
  802b5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802b5d:	75 51                	jne    802bb0 <__umoddi3+0x90>
  802b5f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802b62:	0f 87 e0 00 00 00    	ja     802c48 <__umoddi3+0x128>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	29 f8                	sub    %edi,%eax
  802b6d:	19 d6                	sbb    %edx,%esi
  802b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	89 f2                	mov    %esi,%edx
  802b77:	83 c4 20             	add    $0x20,%esp
  802b7a:	5e                   	pop    %esi
  802b7b:	5f                   	pop    %edi
  802b7c:	5d                   	pop    %ebp
  802b7d:	c3                   	ret    
  802b7e:	66 90                	xchg   %ax,%ax
  802b80:	85 ff                	test   %edi,%edi
  802b82:	75 0b                	jne    802b8f <__umoddi3+0x6f>
  802b84:	b8 01 00 00 00       	mov    $0x1,%eax
  802b89:	31 d2                	xor    %edx,%edx
  802b8b:	f7 f7                	div    %edi
  802b8d:	89 c7                	mov    %eax,%edi
  802b8f:	89 f0                	mov    %esi,%eax
  802b91:	31 d2                	xor    %edx,%edx
  802b93:	f7 f7                	div    %edi
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	f7 f7                	div    %edi
  802b9a:	eb a9                	jmp    802b45 <__umoddi3+0x25>
  802b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ba0:	89 c8                	mov    %ecx,%eax
  802ba2:	89 f2                	mov    %esi,%edx
  802ba4:	83 c4 20             	add    $0x20,%esp
  802ba7:	5e                   	pop    %esi
  802ba8:	5f                   	pop    %edi
  802ba9:	5d                   	pop    %ebp
  802baa:	c3                   	ret    
  802bab:	90                   	nop
  802bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bb4:	d3 e2                	shl    %cl,%edx
  802bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bb9:	ba 20 00 00 00       	mov    $0x20,%edx
  802bbe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802bc1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802bc4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bc8:	89 fa                	mov    %edi,%edx
  802bca:	d3 ea                	shr    %cl,%edx
  802bcc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bd0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802bd3:	d3 e7                	shl    %cl,%edi
  802bd5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bdc:	89 f2                	mov    %esi,%edx
  802bde:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802be1:	89 c7                	mov    %eax,%edi
  802be3:	d3 ea                	shr    %cl,%edx
  802be5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802be9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802bec:	89 c2                	mov    %eax,%edx
  802bee:	d3 e6                	shl    %cl,%esi
  802bf0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bf4:	d3 ea                	shr    %cl,%edx
  802bf6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bfa:	09 d6                	or     %edx,%esi
  802bfc:	89 f0                	mov    %esi,%eax
  802bfe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802c01:	d3 e7                	shl    %cl,%edi
  802c03:	89 f2                	mov    %esi,%edx
  802c05:	f7 75 f4             	divl   -0xc(%ebp)
  802c08:	89 d6                	mov    %edx,%esi
  802c0a:	f7 65 e8             	mull   -0x18(%ebp)
  802c0d:	39 d6                	cmp    %edx,%esi
  802c0f:	72 2b                	jb     802c3c <__umoddi3+0x11c>
  802c11:	39 c7                	cmp    %eax,%edi
  802c13:	72 23                	jb     802c38 <__umoddi3+0x118>
  802c15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c19:	29 c7                	sub    %eax,%edi
  802c1b:	19 d6                	sbb    %edx,%esi
  802c1d:	89 f0                	mov    %esi,%eax
  802c1f:	89 f2                	mov    %esi,%edx
  802c21:	d3 ef                	shr    %cl,%edi
  802c23:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c27:	d3 e0                	shl    %cl,%eax
  802c29:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c2d:	09 f8                	or     %edi,%eax
  802c2f:	d3 ea                	shr    %cl,%edx
  802c31:	83 c4 20             	add    $0x20,%esp
  802c34:	5e                   	pop    %esi
  802c35:	5f                   	pop    %edi
  802c36:	5d                   	pop    %ebp
  802c37:	c3                   	ret    
  802c38:	39 d6                	cmp    %edx,%esi
  802c3a:	75 d9                	jne    802c15 <__umoddi3+0xf5>
  802c3c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c3f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802c42:	eb d1                	jmp    802c15 <__umoddi3+0xf5>
  802c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c48:	39 f2                	cmp    %esi,%edx
  802c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c50:	0f 82 12 ff ff ff    	jb     802b68 <__umoddi3+0x48>
  802c56:	e9 17 ff ff ff       	jmp    802b72 <__umoddi3+0x52>
