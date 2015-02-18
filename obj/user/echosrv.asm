
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 df 04 00 00       	call   800510 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  80003a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003e:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  800045:	e8 8b 05 00 00       	call   8005d5 <cprintf>
	exit();
  80004a:	e8 11 05 00 00       	call   800560 <exit>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <handle_client>:

void
handle_client(int sock)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 3c             	sub    $0x3c,%esp
  80005a:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  800064:	00 
  800065:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	89 34 24             	mov    %esi,(%esp)
  80006f:	e8 0b 17 00 00       	call   80177f <read>
  800074:	89 c3                	mov    %eax,%ebx
  800076:	85 c0                	test   %eax,%eax
  800078:	79 50                	jns    8000ca <handle_client+0x79>
		die("Failed to receive initial bytes from client");
  80007a:	b8 d4 2c 80 00       	mov    $0x802cd4,%eax
  80007f:	e8 b0 ff ff ff       	call   800034 <die>
  800084:	eb 44                	jmp    8000ca <handle_client+0x79>

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  800086:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80008a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80008e:	89 34 24             	mov    %esi,(%esp)
  800091:	e8 60 16 00 00       	call   8016f6 <write>
  800096:	39 d8                	cmp    %ebx,%eax
  800098:	74 0a                	je     8000a4 <handle_client+0x53>
			die("Failed to send bytes to client");
  80009a:	b8 00 2d 80 00       	mov    $0x802d00,%eax
  80009f:	e8 90 ff ff ff       	call   800034 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000a4:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  8000ab:	00 
  8000ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000b0:	89 34 24             	mov    %esi,(%esp)
  8000b3:	e8 c7 16 00 00       	call   80177f <read>
  8000b8:	89 c3                	mov    %eax,%ebx
  8000ba:	85 c0                	test   %eax,%eax
  8000bc:	79 0f                	jns    8000cd <handle_client+0x7c>
			die("Failed to receive additional bytes from client");
  8000be:	b8 20 2d 80 00       	mov    $0x802d20,%eax
  8000c3:	e8 6c ff ff ff       	call   800034 <die>
  8000c8:	eb 03                	jmp    8000cd <handle_client+0x7c>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000ca:	8d 7d c8             	lea    -0x38(%ebp),%edi
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cd:	85 db                	test   %ebx,%ebx
  8000cf:	7f b5                	jg     800086 <handle_client+0x35>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  8000d1:	89 34 24             	mov    %esi,(%esp)
  8000d4:	e8 0d 18 00 00       	call   8018e6 <close>
}
  8000d9:	83 c4 3c             	add    $0x3c,%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5f                   	pop    %edi
  8000df:	5d                   	pop    %ebp
  8000e0:	c3                   	ret    

008000e1 <umain>:

void
umain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	57                   	push   %edi
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	83 ec 4c             	sub    $0x4c,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ea:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8000f1:	00 
  8000f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000f9:	00 
  8000fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800101:	e8 08 1e 00 00       	call   801f0e <socket>
  800106:	89 c6                	mov    %eax,%esi
  800108:	85 c0                	test   %eax,%eax
  80010a:	79 0a                	jns    800116 <umain+0x35>
		die("Failed to create socket");
  80010c:	b8 80 2c 80 00       	mov    $0x802c80,%eax
  800111:	e8 1e ff ff ff       	call   800034 <die>

	cprintf("opened socket\n");
  800116:	c7 04 24 98 2c 80 00 	movl   $0x802c98,(%esp)
  80011d:	e8 b3 04 00 00       	call   8005d5 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800122:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800129:	00 
  80012a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800131:	00 
  800132:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800135:	89 1c 24             	mov    %ebx,(%esp)
  800138:	e8 43 0c 00 00       	call   800d80 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80013d:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800148:	e8 a3 01 00 00       	call   8002f0 <htonl>
  80014d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  800150:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800157:	e8 73 01 00 00       	call   8002cf <htons>
  80015c:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  800160:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  800167:	e8 69 04 00 00       	call   8005d5 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80016c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800173:	00 
  800174:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800178:	89 34 24             	mov    %esi,(%esp)
  80017b:	e8 58 1e 00 00       	call   801fd8 <bind>
  800180:	85 c0                	test   %eax,%eax
  800182:	79 0a                	jns    80018e <umain+0xad>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800184:	b8 50 2d 80 00       	mov    $0x802d50,%eax
  800189:	e8 a6 fe ff ff       	call   800034 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80018e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800195:	00 
  800196:	89 34 24             	mov    %esi,(%esp)
  800199:	e8 ca 1d 00 00       	call   801f68 <listen>
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	79 0a                	jns    8001ac <umain+0xcb>
		die("Failed to listen on server socket");
  8001a2:	b8 74 2d 80 00       	mov    $0x802d74,%eax
  8001a7:	e8 88 fe ff ff       	call   800034 <die>

	cprintf("bound\n");
  8001ac:	c7 04 24 b7 2c 80 00 	movl   $0x802cb7,(%esp)
  8001b3:	e8 1d 04 00 00       	call   8005d5 <cprintf>
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  8001b8:	8d 7d c4             	lea    -0x3c(%ebp),%edi

	cprintf("bound\n");

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8001bb:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  8001c2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001c6:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cd:	89 34 24             	mov    %esi,(%esp)
  8001d0:	e8 2d 1e 00 00       	call   802002 <accept>
  8001d5:	89 c3                	mov    %eax,%ebx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	79 0a                	jns    8001e5 <umain+0x104>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001db:	b8 98 2d 80 00       	mov    $0x802d98,%eax
  8001e0:	e8 4f fe ff ff       	call   800034 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 20 00 00 00       	call   800210 <inet_ntoa>
  8001f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f4:	c7 04 24 be 2c 80 00 	movl   $0x802cbe,(%esp)
  8001fb:	e8 d5 03 00 00       	call   8005d5 <cprintf>
		handle_client(clientsock);
  800200:	89 1c 24             	mov    %ebx,(%esp)
  800203:	e8 49 fe ff ff       	call   800051 <handle_client>
	}
  800208:	eb b1                	jmp    8001bb <umain+0xda>
  80020a:	00 00                	add    %al,(%eax)
  80020c:	00 00                	add    %al,(%eax)
	...

00800210 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 20             	sub    $0x20,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80021f:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800222:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  800226:	c7 45 e0 00 50 80 00 	movl   $0x805000,-0x20(%ebp)
  80022d:	ba 00 00 00 00       	mov    $0x0,%edx
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
  800232:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800235:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800238:	0f b6 00             	movzbl (%eax),%eax
  80023b:	88 45 db             	mov    %al,-0x25(%ebp)
      *ap /= (u8_t)10;
  80023e:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  800243:	f6 65 db             	mulb   -0x25(%ebp)
  800246:	66 c1 e8 08          	shr    $0x8,%ax
  80024a:	c0 e8 03             	shr    $0x3,%al
  80024d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800250:	88 01                	mov    %al,(%ecx)
      inv[i++] = '0' + rem;
  800252:	0f b6 f2             	movzbl %dl,%esi
  800255:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  800258:	01 ff                	add    %edi,%edi
  80025a:	0f b6 5d db          	movzbl -0x25(%ebp),%ebx
  80025e:	89 f9                	mov    %edi,%ecx
  800260:	28 cb                	sub    %cl,%bl
  800262:	89 df                	mov    %ebx,%edi
  800264:	8d 4f 30             	lea    0x30(%edi),%ecx
  800267:	88 4c 35 ed          	mov    %cl,-0x13(%ebp,%esi,1)
  80026b:	8d 4a 01             	lea    0x1(%edx),%ecx
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80026e:	89 ca                	mov    %ecx,%edx
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
  800270:	84 c0                	test   %al,%al
  800272:	75 c1                	jne    800235 <inet_ntoa+0x25>
  800274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800277:	89 ce                	mov    %ecx,%esi
  800279:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80027c:	eb 10                	jmp    80028e <inet_ntoa+0x7e>
    while(i--)
  80027e:	83 ea 01             	sub    $0x1,%edx
      *rp++ = inv[i];
  800281:	0f b6 ca             	movzbl %dl,%ecx
  800284:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800289:	88 08                	mov    %cl,(%eax)
  80028b:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80028e:	84 d2                	test   %dl,%dl
  800290:	75 ec                	jne    80027e <inet_ntoa+0x6e>
  800292:	89 f1                	mov    %esi,%ecx
  800294:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800297:	0f b6 c9             	movzbl %cl,%ecx
  80029a:	03 4d e0             	add    -0x20(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  80029d:	c6 01 2e             	movb   $0x2e,(%ecx)
  8002a0:	83 c1 01             	add    $0x1,%ecx
  8002a3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002a6:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8002aa:	80 7d df 03          	cmpb   $0x3,-0x21(%ebp)
  8002ae:	77 0b                	ja     8002bb <inet_ntoa+0xab>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  8002b0:	83 c3 01             	add    $0x1,%ebx
  8002b3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002b6:	e9 7a ff ff ff       	jmp    800235 <inet_ntoa+0x25>
  }
  *--rp = 0;
  8002bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002be:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8002c2:	b8 00 50 80 00       	mov    $0x805000,%eax
  8002c7:	83 c4 20             	add    $0x20,%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002d6:	66 c1 c0 08          	rol    $0x8,%ax
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
}
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    

008002dc <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  8002e2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002e6:	89 04 24             	mov    %eax,(%esp)
  8002e9:	e8 e1 ff ff ff       	call   8002cf <htons>
}
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f6:	89 d1                	mov    %edx,%ecx
  8002f8:	c1 e9 18             	shr    $0x18,%ecx
  8002fb:	89 d0                	mov    %edx,%eax
  8002fd:	c1 e0 18             	shl    $0x18,%eax
  800300:	09 c8                	or     %ecx,%eax
  800302:	89 d1                	mov    %edx,%ecx
  800304:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80030a:	c1 e1 08             	shl    $0x8,%ecx
  80030d:	09 c8                	or     %ecx,%eax
  80030f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800315:	c1 ea 08             	shr    $0x8,%edx
  800318:	09 d0                	or     %edx,%eax
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	57                   	push   %edi
  800320:	56                   	push   %esi
  800321:	53                   	push   %ebx
  800322:	83 ec 28             	sub    $0x28,%esp
  800325:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800328:	0f be 10             	movsbl (%eax),%edx
  80032b:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  80032e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800331:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800334:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800337:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80033a:	80 f9 09             	cmp    $0x9,%cl
  80033d:	0f 87 87 01 00 00    	ja     8004ca <inet_aton+0x1ae>
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
  800343:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
  80034a:	83 fa 30             	cmp    $0x30,%edx
  80034d:	75 24                	jne    800373 <inet_aton+0x57>
      c = *++cp;
  80034f:	83 c0 01             	add    $0x1,%eax
  800352:	0f be 10             	movsbl (%eax),%edx
      if (c == 'x' || c == 'X') {
  800355:	83 fa 78             	cmp    $0x78,%edx
  800358:	74 0c                	je     800366 <inet_aton+0x4a>
  80035a:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800361:	83 fa 58             	cmp    $0x58,%edx
  800364:	75 0d                	jne    800373 <inet_aton+0x57>
        base = 16;
        c = *++cp;
  800366:	83 c0 01             	add    $0x1,%eax
  800369:	0f be 10             	movsbl (%eax),%edx
  80036c:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800373:	83 c0 01             	add    $0x1,%eax
  800376:	be 00 00 00 00       	mov    $0x0,%esi
  80037b:	eb 03                	jmp    800380 <inet_aton+0x64>
  80037d:	83 c0 01             	add    $0x1,%eax
  800380:	8d 78 ff             	lea    -0x1(%eax),%edi
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800383:	89 d1                	mov    %edx,%ecx
  800385:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800388:	80 fb 09             	cmp    $0x9,%bl
  80038b:	77 0d                	ja     80039a <inet_aton+0x7e>
        val = (val * base) + (int)(c - '0');
  80038d:	0f af 75 e0          	imul   -0x20(%ebp),%esi
  800391:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  800395:	0f be 10             	movsbl (%eax),%edx
  800398:	eb e3                	jmp    80037d <inet_aton+0x61>
      } else if (base == 16 && isxdigit(c)) {
  80039a:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80039e:	75 2b                	jne    8003cb <inet_aton+0xaf>
  8003a0:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8003a3:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  8003a6:	80 fb 05             	cmp    $0x5,%bl
  8003a9:	76 08                	jbe    8003b3 <inet_aton+0x97>
  8003ab:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8003ae:	80 fb 05             	cmp    $0x5,%bl
  8003b1:	77 18                	ja     8003cb <inet_aton+0xaf>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003b3:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8003b7:	19 c9                	sbb    %ecx,%ecx
  8003b9:	83 e1 20             	and    $0x20,%ecx
  8003bc:	c1 e6 04             	shl    $0x4,%esi
  8003bf:	29 ca                	sub    %ecx,%edx
  8003c1:	8d 52 c9             	lea    -0x37(%edx),%edx
  8003c4:	09 d6                	or     %edx,%esi
        c = *++cp;
  8003c6:	0f be 10             	movsbl (%eax),%edx
  8003c9:	eb b2                	jmp    80037d <inet_aton+0x61>
      } else
        break;
    }
    if (c == '.') {
  8003cb:	83 fa 2e             	cmp    $0x2e,%edx
  8003ce:	75 22                	jne    8003f2 <inet_aton+0xd6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003d3:	39 55 d8             	cmp    %edx,-0x28(%ebp)
  8003d6:	0f 83 ee 00 00 00    	jae    8004ca <inet_aton+0x1ae>
        return (0);
      *pp++ = val;
  8003dc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8003df:	89 31                	mov    %esi,(%ecx)
  8003e1:	83 c1 04             	add    $0x4,%ecx
  8003e4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      c = *++cp;
  8003e7:	8d 47 01             	lea    0x1(%edi),%eax
  8003ea:	0f be 10             	movsbl (%eax),%edx
    } else
      break;
  }
  8003ed:	e9 45 ff ff ff       	jmp    800337 <inet_aton+0x1b>
  8003f2:	89 f3                	mov    %esi,%ebx
  8003f4:	89 f0                	mov    %esi,%eax
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003f6:	85 d2                	test   %edx,%edx
  8003f8:	74 36                	je     800430 <inet_aton+0x114>
  8003fa:	80 f9 1f             	cmp    $0x1f,%cl
  8003fd:	0f 86 c7 00 00 00    	jbe    8004ca <inet_aton+0x1ae>
  800403:	84 d2                	test   %dl,%dl
  800405:	0f 88 bf 00 00 00    	js     8004ca <inet_aton+0x1ae>
  80040b:	83 fa 20             	cmp    $0x20,%edx
  80040e:	66 90                	xchg   %ax,%ax
  800410:	74 1e                	je     800430 <inet_aton+0x114>
  800412:	83 fa 0c             	cmp    $0xc,%edx
  800415:	74 19                	je     800430 <inet_aton+0x114>
  800417:	83 fa 0a             	cmp    $0xa,%edx
  80041a:	74 14                	je     800430 <inet_aton+0x114>
  80041c:	83 fa 0d             	cmp    $0xd,%edx
  80041f:	90                   	nop
  800420:	74 0e                	je     800430 <inet_aton+0x114>
  800422:	83 fa 09             	cmp    $0x9,%edx
  800425:	74 09                	je     800430 <inet_aton+0x114>
  800427:	83 fa 0b             	cmp    $0xb,%edx
  80042a:	0f 85 9a 00 00 00    	jne    8004ca <inet_aton+0x1ae>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  800430:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800433:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800436:	29 d1                	sub    %edx,%ecx
  800438:	89 ca                	mov    %ecx,%edx
  80043a:	c1 fa 02             	sar    $0x2,%edx
  80043d:	83 c2 01             	add    $0x1,%edx
  800440:	83 fa 02             	cmp    $0x2,%edx
  800443:	74 1d                	je     800462 <inet_aton+0x146>
  800445:	83 fa 02             	cmp    $0x2,%edx
  800448:	7f 08                	jg     800452 <inet_aton+0x136>
  80044a:	85 d2                	test   %edx,%edx
  80044c:	74 7c                	je     8004ca <inet_aton+0x1ae>
  80044e:	66 90                	xchg   %ax,%ax
  800450:	eb 59                	jmp    8004ab <inet_aton+0x18f>
  800452:	83 fa 03             	cmp    $0x3,%edx
  800455:	74 1c                	je     800473 <inet_aton+0x157>
  800457:	83 fa 04             	cmp    $0x4,%edx
  80045a:	75 4f                	jne    8004ab <inet_aton+0x18f>
  80045c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800460:	eb 2a                	jmp    80048c <inet_aton+0x170>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800462:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  800467:	77 61                	ja     8004ca <inet_aton+0x1ae>
      return (0);
    val |= parts[0] << 24;
  800469:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80046c:	c1 e3 18             	shl    $0x18,%ebx
  80046f:	09 c3                	or     %eax,%ebx
    break;
  800471:	eb 38                	jmp    8004ab <inet_aton+0x18f>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800473:	3d ff ff 00 00       	cmp    $0xffff,%eax
  800478:	77 50                	ja     8004ca <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80047d:	c1 e3 10             	shl    $0x10,%ebx
  800480:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800483:	c1 e2 18             	shl    $0x18,%edx
  800486:	09 d3                	or     %edx,%ebx
  800488:	09 c3                	or     %eax,%ebx
    break;
  80048a:	eb 1f                	jmp    8004ab <inet_aton+0x18f>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80048c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800491:	77 37                	ja     8004ca <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800493:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800496:	c1 e3 10             	shl    $0x10,%ebx
  800499:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80049c:	c1 e2 18             	shl    $0x18,%edx
  80049f:	09 d3                	or     %edx,%ebx
  8004a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004a4:	c1 e2 08             	shl    $0x8,%edx
  8004a7:	09 d3                	or     %edx,%ebx
  8004a9:	09 c3                	or     %eax,%ebx
    break;
  }
  if (addr)
  8004ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8004b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b4:	74 19                	je     8004cf <inet_aton+0x1b3>
    addr->s_addr = htonl(val);
  8004b6:	89 1c 24             	mov    %ebx,(%esp)
  8004b9:	e8 32 fe ff ff       	call   8002f0 <htonl>
  8004be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c1:	89 03                	mov    %eax,(%ebx)
  8004c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8004c8:	eb 05                	jmp    8004cf <inet_aton+0x1b3>
  8004ca:	b8 00 00 00 00       	mov    $0x0,%eax
  return (1);
}
  8004cf:	83 c4 28             	add    $0x28,%esp
  8004d2:	5b                   	pop    %ebx
  8004d3:	5e                   	pop    %esi
  8004d4:	5f                   	pop    %edi
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004dd:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	e8 2d fe ff ff       	call   80031c <inet_aton>
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004f6:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
    return (val.s_addr);
  }
  return (INADDR_NONE);
}
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	e8 e3 fd ff ff       	call   8002f0 <htonl>
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    
	...

00800510 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	83 ec 18             	sub    $0x18,%esp
  800516:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800519:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80051c:	8b 75 08             	mov    0x8(%ebp),%esi
  80051f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800522:	e8 ea 0e 00 00       	call   801411 <sys_getenvid>
  800527:	25 ff 03 00 00       	and    $0x3ff,%eax
  80052c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80052f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800534:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800539:	85 f6                	test   %esi,%esi
  80053b:	7e 07                	jle    800544 <libmain+0x34>
		binaryname = argv[0];
  80053d:	8b 03                	mov    (%ebx),%eax
  80053f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800544:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800548:	89 34 24             	mov    %esi,(%esp)
  80054b:	e8 91 fb ff ff       	call   8000e1 <umain>

	// exit gracefully
	exit();
  800550:	e8 0b 00 00 00       	call   800560 <exit>
}
  800555:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800558:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80055b:	89 ec                	mov    %ebp,%esp
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    
	...

00800560 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800566:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80056d:	e8 d3 0e 00 00       	call   801445 <sys_env_destroy>
}
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80057d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800584:	00 00 00 
	b.cnt = 0;
  800587:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800591:	8b 45 0c             	mov    0xc(%ebp),%eax
  800594:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80059f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a9:	c7 04 24 ef 05 80 00 	movl   $0x8005ef,(%esp)
  8005b0:	e8 be 01 00 00       	call   800773 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005b5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8005bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005bf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005c5:	89 04 24             	mov    %eax,(%esp)
  8005c8:	e8 23 0a 00 00       	call   800ff0 <sys_cputs>

	return b.cnt;
}
  8005cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005d3:	c9                   	leave  
  8005d4:	c3                   	ret    

008005d5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8005db:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8005de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	89 04 24             	mov    %eax,(%esp)
  8005e8:	e8 87 ff ff ff       	call   800574 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	53                   	push   %ebx
  8005f3:	83 ec 14             	sub    $0x14,%esp
  8005f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005f9:	8b 03                	mov    (%ebx),%eax
  8005fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8005fe:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800602:	83 c0 01             	add    $0x1,%eax
  800605:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800607:	3d ff 00 00 00       	cmp    $0xff,%eax
  80060c:	75 19                	jne    800627 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80060e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800615:	00 
  800616:	8d 43 08             	lea    0x8(%ebx),%eax
  800619:	89 04 24             	mov    %eax,(%esp)
  80061c:	e8 cf 09 00 00       	call   800ff0 <sys_cputs>
		b->idx = 0;
  800621:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800627:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80062b:	83 c4 14             	add    $0x14,%esp
  80062e:	5b                   	pop    %ebx
  80062f:	5d                   	pop    %ebp
  800630:	c3                   	ret    
  800631:	00 00                	add    %al,(%eax)
	...

00800634 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	57                   	push   %edi
  800638:	56                   	push   %esi
  800639:	53                   	push   %ebx
  80063a:	83 ec 4c             	sub    $0x4c,%esp
  80063d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800640:	89 d6                	mov    %edx,%esi
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80064e:	8b 45 10             	mov    0x10(%ebp),%eax
  800651:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800654:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800657:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80065a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065f:	39 d1                	cmp    %edx,%ecx
  800661:	72 07                	jb     80066a <printnum+0x36>
  800663:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800666:	39 d0                	cmp    %edx,%eax
  800668:	77 69                	ja     8006d3 <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80066a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80066e:	83 eb 01             	sub    $0x1,%ebx
  800671:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800675:	89 44 24 08          	mov    %eax,0x8(%esp)
  800679:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  80067d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800681:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800684:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800687:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80068a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80068e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800695:	00 
  800696:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800699:	89 04 24             	mov    %eax,(%esp)
  80069c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80069f:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006a3:	e8 68 23 00 00       	call   802a10 <__udivdi3>
  8006a8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8006ab:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006b6:	89 04 24             	mov    %eax,(%esp)
  8006b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bd:	89 f2                	mov    %esi,%edx
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	e8 6d ff ff ff       	call   800634 <printnum>
  8006c7:	eb 11                	jmp    8006da <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006cd:	89 3c 24             	mov    %edi,(%esp)
  8006d0:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d3:	83 eb 01             	sub    $0x1,%ebx
  8006d6:	85 db                	test   %ebx,%ebx
  8006d8:	7f ef                	jg     8006c9 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006de:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8006f0:	00 
  8006f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f4:	89 14 24             	mov    %edx,(%esp)
  8006f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006fe:	e8 3d 24 00 00       	call   802b40 <__umoddi3>
  800703:	89 74 24 04          	mov    %esi,0x4(%esp)
  800707:	0f be 80 c5 2d 80 00 	movsbl 0x802dc5(%eax),%eax
  80070e:	89 04 24             	mov    %eax,(%esp)
  800711:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800714:	83 c4 4c             	add    $0x4c,%esp
  800717:	5b                   	pop    %ebx
  800718:	5e                   	pop    %esi
  800719:	5f                   	pop    %edi
  80071a:	5d                   	pop    %ebp
  80071b:	c3                   	ret    

0080071c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071f:	83 fa 01             	cmp    $0x1,%edx
  800722:	7e 0e                	jle    800732 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800724:	8b 10                	mov    (%eax),%edx
  800726:	8d 4a 08             	lea    0x8(%edx),%ecx
  800729:	89 08                	mov    %ecx,(%eax)
  80072b:	8b 02                	mov    (%edx),%eax
  80072d:	8b 52 04             	mov    0x4(%edx),%edx
  800730:	eb 22                	jmp    800754 <getuint+0x38>
	else if (lflag)
  800732:	85 d2                	test   %edx,%edx
  800734:	74 10                	je     800746 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800736:	8b 10                	mov    (%eax),%edx
  800738:	8d 4a 04             	lea    0x4(%edx),%ecx
  80073b:	89 08                	mov    %ecx,(%eax)
  80073d:	8b 02                	mov    (%edx),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 0e                	jmp    800754 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 10                	mov    (%eax),%edx
  800748:	8d 4a 04             	lea    0x4(%edx),%ecx
  80074b:	89 08                	mov    %ecx,(%eax)
  80074d:	8b 02                	mov    (%edx),%eax
  80074f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800754:	5d                   	pop    %ebp
  800755:	c3                   	ret    

00800756 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80075c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800760:	8b 10                	mov    (%eax),%edx
  800762:	3b 50 04             	cmp    0x4(%eax),%edx
  800765:	73 0a                	jae    800771 <sprintputch+0x1b>
		*b->buf++ = ch;
  800767:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076a:	88 0a                	mov    %cl,(%edx)
  80076c:	83 c2 01             	add    $0x1,%edx
  80076f:	89 10                	mov    %edx,(%eax)
}
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	57                   	push   %edi
  800777:	56                   	push   %esi
  800778:	53                   	push   %ebx
  800779:	83 ec 4c             	sub    $0x4c,%esp
  80077c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80077f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800782:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800785:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  80078c:	eb 11                	jmp    80079f <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80078e:	85 c0                	test   %eax,%eax
  800790:	0f 84 b6 03 00 00    	je     800b4c <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800796:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079a:	89 04 24             	mov    %eax,(%esp)
  80079d:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079f:	0f b6 03             	movzbl (%ebx),%eax
  8007a2:	83 c3 01             	add    $0x1,%ebx
  8007a5:	83 f8 25             	cmp    $0x25,%eax
  8007a8:	75 e4                	jne    80078e <vprintfmt+0x1b>
  8007aa:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8007ae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8007b5:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8007bc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8007c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007c8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007cb:	eb 06                	jmp    8007d3 <vprintfmt+0x60>
  8007cd:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8007d1:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d3:	0f b6 0b             	movzbl (%ebx),%ecx
  8007d6:	0f b6 c1             	movzbl %cl,%eax
  8007d9:	8d 53 01             	lea    0x1(%ebx),%edx
  8007dc:	83 e9 23             	sub    $0x23,%ecx
  8007df:	80 f9 55             	cmp    $0x55,%cl
  8007e2:	0f 87 47 03 00 00    	ja     800b2f <vprintfmt+0x3bc>
  8007e8:	0f b6 c9             	movzbl %cl,%ecx
  8007eb:	ff 24 8d 00 2f 80 00 	jmp    *0x802f00(,%ecx,4)
  8007f2:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8007f6:	eb d9                	jmp    8007d1 <vprintfmt+0x5e>
  8007f8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8007ff:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800804:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800807:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  80080b:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  80080e:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800811:	83 fb 09             	cmp    $0x9,%ebx
  800814:	77 30                	ja     800846 <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800816:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800819:	eb e9                	jmp    800804 <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8d 48 04             	lea    0x4(%eax),%ecx
  800821:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800824:	8b 00                	mov    (%eax),%eax
  800826:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800829:	eb 1e                	jmp    800849 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  80082b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
  800834:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083b:	eb 94                	jmp    8007d1 <vprintfmt+0x5e>
  80083d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800844:	eb 8b                	jmp    8007d1 <vprintfmt+0x5e>
  800846:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	79 82                	jns    8007d1 <vprintfmt+0x5e>
  80084f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800852:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800855:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800858:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80085b:	e9 71 ff ff ff       	jmp    8007d1 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800860:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800864:	e9 68 ff ff ff       	jmp    8007d1 <vprintfmt+0x5e>
  800869:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 50 04             	lea    0x4(%eax),%edx
  800872:	89 55 14             	mov    %edx,0x14(%ebp)
  800875:	89 74 24 04          	mov    %esi,0x4(%esp)
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	89 04 24             	mov    %eax,(%esp)
  80087e:	ff d7                	call   *%edi
  800880:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800883:	e9 17 ff ff ff       	jmp    80079f <vprintfmt+0x2c>
  800888:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	8d 50 04             	lea    0x4(%eax),%edx
  800891:	89 55 14             	mov    %edx,0x14(%ebp)
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 c2                	mov    %eax,%edx
  800898:	c1 fa 1f             	sar    $0x1f,%edx
  80089b:	31 d0                	xor    %edx,%eax
  80089d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80089f:	83 f8 11             	cmp    $0x11,%eax
  8008a2:	7f 0b                	jg     8008af <vprintfmt+0x13c>
  8008a4:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	75 20                	jne    8008cf <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  8008af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008b3:	c7 44 24 08 d6 2d 80 	movl   $0x802dd6,0x8(%esp)
  8008ba:	00 
  8008bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008bf:	89 3c 24             	mov    %edi,(%esp)
  8008c2:	e8 0d 03 00 00       	call   800bd4 <printfmt>
  8008c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ca:	e9 d0 fe ff ff       	jmp    80079f <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008d3:	c7 44 24 08 b6 31 80 	movl   $0x8031b6,0x8(%esp)
  8008da:	00 
  8008db:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008df:	89 3c 24             	mov    %edi,(%esp)
  8008e2:	e8 ed 02 00 00       	call   800bd4 <printfmt>
  8008e7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8008ea:	e9 b0 fe ff ff       	jmp    80079f <vprintfmt+0x2c>
  8008ef:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008f2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8008f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	89 55 14             	mov    %edx,0x14(%ebp)
  800904:	8b 18                	mov    (%eax),%ebx
  800906:	85 db                	test   %ebx,%ebx
  800908:	b8 df 2d 80 00       	mov    $0x802ddf,%eax
  80090d:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800910:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800914:	7e 76                	jle    80098c <vprintfmt+0x219>
  800916:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  80091a:	74 7a                	je     800996 <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800920:	89 1c 24             	mov    %ebx,(%esp)
  800923:	e8 f0 02 00 00       	call   800c18 <strnlen>
  800928:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80092b:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  80092d:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800931:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800934:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800937:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	eb 0f                	jmp    80094a <vprintfmt+0x1d7>
					putch(padc, putdat);
  80093b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80093f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800942:	89 04 24             	mov    %eax,(%esp)
  800945:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800947:	83 eb 01             	sub    $0x1,%ebx
  80094a:	85 db                	test   %ebx,%ebx
  80094c:	7f ed                	jg     80093b <vprintfmt+0x1c8>
  80094e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800951:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800954:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800957:	89 f7                	mov    %esi,%edi
  800959:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80095c:	eb 40                	jmp    80099e <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80095e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800962:	74 18                	je     80097c <vprintfmt+0x209>
  800964:	8d 50 e0             	lea    -0x20(%eax),%edx
  800967:	83 fa 5e             	cmp    $0x5e,%edx
  80096a:	76 10                	jbe    80097c <vprintfmt+0x209>
					putch('?', putdat);
  80096c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800970:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800977:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80097a:	eb 0a                	jmp    800986 <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  80097c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800980:	89 04 24             	mov    %eax,(%esp)
  800983:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80098a:	eb 12                	jmp    80099e <vprintfmt+0x22b>
  80098c:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80098f:	89 f7                	mov    %esi,%edi
  800991:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800994:	eb 08                	jmp    80099e <vprintfmt+0x22b>
  800996:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800999:	89 f7                	mov    %esi,%edi
  80099b:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80099e:	0f be 03             	movsbl (%ebx),%eax
  8009a1:	83 c3 01             	add    $0x1,%ebx
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	74 25                	je     8009cd <vprintfmt+0x25a>
  8009a8:	85 f6                	test   %esi,%esi
  8009aa:	78 b2                	js     80095e <vprintfmt+0x1eb>
  8009ac:	83 ee 01             	sub    $0x1,%esi
  8009af:	79 ad                	jns    80095e <vprintfmt+0x1eb>
  8009b1:	89 fe                	mov    %edi,%esi
  8009b3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8009b6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8009b9:	eb 1a                	jmp    8009d5 <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8009bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009bf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009c6:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c8:	83 eb 01             	sub    $0x1,%ebx
  8009cb:	eb 08                	jmp    8009d5 <vprintfmt+0x262>
  8009cd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8009d0:	89 fe                	mov    %edi,%esi
  8009d2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8009d5:	85 db                	test   %ebx,%ebx
  8009d7:	7f e2                	jg     8009bb <vprintfmt+0x248>
  8009d9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8009dc:	e9 be fd ff ff       	jmp    80079f <vprintfmt+0x2c>
  8009e1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009e7:	83 f9 01             	cmp    $0x1,%ecx
  8009ea:	7e 16                	jle    800a02 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	8d 50 08             	lea    0x8(%eax),%edx
  8009f2:	89 55 14             	mov    %edx,0x14(%ebp)
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009fa:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8009fd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a00:	eb 32                	jmp    800a34 <vprintfmt+0x2c1>
	else if (lflag)
  800a02:	85 c9                	test   %ecx,%ecx
  800a04:	74 18                	je     800a1e <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	8d 50 04             	lea    0x4(%eax),%edx
  800a0c:	89 55 14             	mov    %edx,0x14(%ebp)
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a14:	89 c1                	mov    %eax,%ecx
  800a16:	c1 f9 1f             	sar    $0x1f,%ecx
  800a19:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a1c:	eb 16                	jmp    800a34 <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8d 50 04             	lea    0x4(%eax),%edx
  800a24:	89 55 14             	mov    %edx,0x14(%ebp)
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	c1 fa 1f             	sar    $0x1f,%edx
  800a31:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a34:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800a37:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a3a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800a3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a43:	0f 89 a7 00 00 00    	jns    800af0 <vprintfmt+0x37d>
				putch('-', putdat);
  800a49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a4d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a54:	ff d7                	call   *%edi
				num = -(long long) num;
  800a56:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800a59:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a5c:	f7 d9                	neg    %ecx
  800a5e:	83 d3 00             	adc    $0x0,%ebx
  800a61:	f7 db                	neg    %ebx
  800a63:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a68:	e9 83 00 00 00       	jmp    800af0 <vprintfmt+0x37d>
  800a6d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a70:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a73:	89 ca                	mov    %ecx,%edx
  800a75:	8d 45 14             	lea    0x14(%ebp),%eax
  800a78:	e8 9f fc ff ff       	call   80071c <getuint>
  800a7d:	89 c1                	mov    %eax,%ecx
  800a7f:	89 d3                	mov    %edx,%ebx
  800a81:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800a86:	eb 68                	jmp    800af0 <vprintfmt+0x37d>
  800a88:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a8b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800a8e:	89 ca                	mov    %ecx,%edx
  800a90:	8d 45 14             	lea    0x14(%ebp),%eax
  800a93:	e8 84 fc ff ff       	call   80071c <getuint>
  800a98:	89 c1                	mov    %eax,%ecx
  800a9a:	89 d3                	mov    %edx,%ebx
  800a9c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800aa1:	eb 4d                	jmp    800af0 <vprintfmt+0x37d>
  800aa3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800aa6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aaa:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800ab1:	ff d7                	call   *%edi
			putch('x', putdat);
  800ab3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800abe:	ff d7                	call   *%edi
			num = (unsigned long long)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	8d 50 04             	lea    0x4(%eax),%edx
  800ac6:	89 55 14             	mov    %edx,0x14(%ebp)
  800ac9:	8b 08                	mov    (%eax),%ecx
  800acb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ad0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800ad5:	eb 19                	jmp    800af0 <vprintfmt+0x37d>
  800ad7:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800ada:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800add:	89 ca                	mov    %ecx,%edx
  800adf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae2:	e8 35 fc ff ff       	call   80071c <getuint>
  800ae7:	89 c1                	mov    %eax,%ecx
  800ae9:	89 d3                	mov    %edx,%ebx
  800aeb:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af0:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800af4:	89 54 24 10          	mov    %edx,0x10(%esp)
  800af8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800afb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800aff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b03:	89 0c 24             	mov    %ecx,(%esp)
  800b06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b0a:	89 f2                	mov    %esi,%edx
  800b0c:	89 f8                	mov    %edi,%eax
  800b0e:	e8 21 fb ff ff       	call   800634 <printnum>
  800b13:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b16:	e9 84 fc ff ff       	jmp    80079f <vprintfmt+0x2c>
  800b1b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	ff d7                	call   *%edi
  800b27:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800b2a:	e9 70 fc ff ff       	jmp    80079f <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b33:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b3a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800b3f:	80 38 25             	cmpb   $0x25,(%eax)
  800b42:	0f 84 57 fc ff ff    	je     80079f <vprintfmt+0x2c>
  800b48:	89 c3                	mov    %eax,%ebx
  800b4a:	eb f0                	jmp    800b3c <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800b4c:	83 c4 4c             	add    $0x4c,%esp
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 28             	sub    $0x28,%esp
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800b60:	85 c0                	test   %eax,%eax
  800b62:	74 04                	je     800b68 <vsnprintf+0x14>
  800b64:	85 d2                	test   %edx,%edx
  800b66:	7f 07                	jg     800b6f <vsnprintf+0x1b>
  800b68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b6d:	eb 3b                	jmp    800baa <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b87:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b95:	c7 04 24 56 07 80 00 	movl   $0x800756,(%esp)
  800b9c:	e8 d2 fb ff ff       	call   800773 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800bb2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800bb5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	89 04 24             	mov    %eax,(%esp)
  800bcd:	e8 82 ff ff ff       	call   800b54 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800bda:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800bdd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800be1:	8b 45 10             	mov    0x10(%ebp),%eax
  800be4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 04 24             	mov    %eax,(%esp)
  800bf5:	e8 79 fb ff ff       	call   800773 <vprintfmt>
	va_end(ap);
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    
  800bfc:	00 00                	add    %al,(%eax)
	...

00800c00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	8b 55 08             	mov    0x8(%ebp),%edx
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0b:	eb 03                	jmp    800c10 <strlen+0x10>
		n++;
  800c0d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c10:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c14:	75 f7                	jne    800c0d <strlen+0xd>
		n++;
	return n;
}
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	53                   	push   %ebx
  800c1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c27:	eb 03                	jmp    800c2c <strnlen+0x14>
		n++;
  800c29:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2c:	39 c1                	cmp    %eax,%ecx
  800c2e:	74 06                	je     800c36 <strnlen+0x1e>
  800c30:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800c34:	75 f3                	jne    800c29 <strnlen+0x11>
		n++;
	return n;
}
  800c36:	5b                   	pop    %ebx
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	53                   	push   %ebx
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c48:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c4c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c4f:	83 c2 01             	add    $0x1,%edx
  800c52:	84 c9                	test   %cl,%cl
  800c54:	75 f2                	jne    800c48 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c56:	5b                   	pop    %ebx
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	53                   	push   %ebx
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c63:	89 1c 24             	mov    %ebx,(%esp)
  800c66:	e8 95 ff ff ff       	call   800c00 <strlen>
	strcpy(dst + len, src);
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c72:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  800c75:	89 04 24             	mov    %eax,(%esp)
  800c78:	e8 bc ff ff ff       	call   800c39 <strcpy>
	return dst;
}
  800c7d:	89 d8                	mov    %ebx,%eax
  800c7f:	83 c4 08             	add    $0x8,%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c90:	8b 75 10             	mov    0x10(%ebp),%esi
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c98:	eb 0f                	jmp    800ca9 <strncpy+0x24>
		*dst++ = *src;
  800c9a:	0f b6 19             	movzbl (%ecx),%ebx
  800c9d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ca0:	80 39 01             	cmpb   $0x1,(%ecx)
  800ca3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca6:	83 c2 01             	add    $0x1,%edx
  800ca9:	39 f2                	cmp    %esi,%edx
  800cab:	72 ed                	jb     800c9a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	8b 75 08             	mov    0x8(%ebp),%esi
  800cb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbc:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cbf:	89 f0                	mov    %esi,%eax
  800cc1:	85 d2                	test   %edx,%edx
  800cc3:	75 0a                	jne    800ccf <strlcpy+0x1e>
  800cc5:	eb 17                	jmp    800cde <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cc7:	88 18                	mov    %bl,(%eax)
  800cc9:	83 c0 01             	add    $0x1,%eax
  800ccc:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ccf:	83 ea 01             	sub    $0x1,%edx
  800cd2:	74 07                	je     800cdb <strlcpy+0x2a>
  800cd4:	0f b6 19             	movzbl (%ecx),%ebx
  800cd7:	84 db                	test   %bl,%bl
  800cd9:	75 ec                	jne    800cc7 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  800cdb:	c6 00 00             	movb   $0x0,(%eax)
  800cde:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ced:	eb 06                	jmp    800cf5 <strcmp+0x11>
		p++, q++;
  800cef:	83 c1 01             	add    $0x1,%ecx
  800cf2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cf5:	0f b6 01             	movzbl (%ecx),%eax
  800cf8:	84 c0                	test   %al,%al
  800cfa:	74 04                	je     800d00 <strcmp+0x1c>
  800cfc:	3a 02                	cmp    (%edx),%al
  800cfe:	74 ef                	je     800cef <strcmp+0xb>
  800d00:	0f b6 c0             	movzbl %al,%eax
  800d03:	0f b6 12             	movzbl (%edx),%edx
  800d06:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	53                   	push   %ebx
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d14:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800d17:	eb 09                	jmp    800d22 <strncmp+0x18>
		n--, p++, q++;
  800d19:	83 ea 01             	sub    $0x1,%edx
  800d1c:	83 c0 01             	add    $0x1,%eax
  800d1f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d22:	85 d2                	test   %edx,%edx
  800d24:	75 07                	jne    800d2d <strncmp+0x23>
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	eb 13                	jmp    800d40 <strncmp+0x36>
  800d2d:	0f b6 18             	movzbl (%eax),%ebx
  800d30:	84 db                	test   %bl,%bl
  800d32:	74 04                	je     800d38 <strncmp+0x2e>
  800d34:	3a 19                	cmp    (%ecx),%bl
  800d36:	74 e1                	je     800d19 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d38:	0f b6 00             	movzbl (%eax),%eax
  800d3b:	0f b6 11             	movzbl (%ecx),%edx
  800d3e:	29 d0                	sub    %edx,%eax
}
  800d40:	5b                   	pop    %ebx
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d4d:	eb 07                	jmp    800d56 <strchr+0x13>
		if (*s == c)
  800d4f:	38 ca                	cmp    %cl,%dl
  800d51:	74 0f                	je     800d62 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d53:	83 c0 01             	add    $0x1,%eax
  800d56:	0f b6 10             	movzbl (%eax),%edx
  800d59:	84 d2                	test   %dl,%dl
  800d5b:	75 f2                	jne    800d4f <strchr+0xc>
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d6e:	eb 07                	jmp    800d77 <strfind+0x13>
		if (*s == c)
  800d70:	38 ca                	cmp    %cl,%dl
  800d72:	74 0a                	je     800d7e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d74:	83 c0 01             	add    $0x1,%eax
  800d77:	0f b6 10             	movzbl (%eax),%edx
  800d7a:	84 d2                	test   %dl,%dl
  800d7c:	75 f2                	jne    800d70 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	89 1c 24             	mov    %ebx,(%esp)
  800d89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d91:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d9a:	85 c9                	test   %ecx,%ecx
  800d9c:	74 30                	je     800dce <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800da4:	75 25                	jne    800dcb <memset+0x4b>
  800da6:	f6 c1 03             	test   $0x3,%cl
  800da9:	75 20                	jne    800dcb <memset+0x4b>
		c &= 0xFF;
  800dab:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dae:	89 d3                	mov    %edx,%ebx
  800db0:	c1 e3 08             	shl    $0x8,%ebx
  800db3:	89 d6                	mov    %edx,%esi
  800db5:	c1 e6 18             	shl    $0x18,%esi
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 10             	shl    $0x10,%eax
  800dbd:	09 f0                	or     %esi,%eax
  800dbf:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800dc1:	09 d8                	or     %ebx,%eax
  800dc3:	c1 e9 02             	shr    $0x2,%ecx
  800dc6:	fc                   	cld    
  800dc7:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800dc9:	eb 03                	jmp    800dce <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dcb:	fc                   	cld    
  800dcc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dce:	89 f8                	mov    %edi,%eax
  800dd0:	8b 1c 24             	mov    (%esp),%ebx
  800dd3:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dd7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ddb:	89 ec                	mov    %ebp,%esp
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 08             	sub    $0x8,%esp
  800de5:	89 34 24             	mov    %esi,(%esp)
  800de8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800df2:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800df5:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800df7:	39 c6                	cmp    %eax,%esi
  800df9:	73 35                	jae    800e30 <memmove+0x51>
  800dfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dfe:	39 d0                	cmp    %edx,%eax
  800e00:	73 2e                	jae    800e30 <memmove+0x51>
		s += n;
		d += n;
  800e02:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e04:	f6 c2 03             	test   $0x3,%dl
  800e07:	75 1b                	jne    800e24 <memmove+0x45>
  800e09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e0f:	75 13                	jne    800e24 <memmove+0x45>
  800e11:	f6 c1 03             	test   $0x3,%cl
  800e14:	75 0e                	jne    800e24 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800e16:	83 ef 04             	sub    $0x4,%edi
  800e19:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e1c:	c1 e9 02             	shr    $0x2,%ecx
  800e1f:	fd                   	std    
  800e20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e22:	eb 09                	jmp    800e2d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e24:	83 ef 01             	sub    $0x1,%edi
  800e27:	8d 72 ff             	lea    -0x1(%edx),%esi
  800e2a:	fd                   	std    
  800e2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e2d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2e:	eb 20                	jmp    800e50 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e36:	75 15                	jne    800e4d <memmove+0x6e>
  800e38:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e3e:	75 0d                	jne    800e4d <memmove+0x6e>
  800e40:	f6 c1 03             	test   $0x3,%cl
  800e43:	75 08                	jne    800e4d <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800e45:	c1 e9 02             	shr    $0x2,%ecx
  800e48:	fc                   	cld    
  800e49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e4b:	eb 03                	jmp    800e50 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e4d:	fc                   	cld    
  800e4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e50:	8b 34 24             	mov    (%esp),%esi
  800e53:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e57:	89 ec                	mov    %ebp,%esp
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e61:	8b 45 10             	mov    0x10(%ebp),%eax
  800e64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 04 24             	mov    %eax,(%esp)
  800e75:	e8 65 ff ff ff       	call   800ddf <memmove>
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e8b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e90:	eb 1c                	jmp    800eae <memcmp+0x32>
		if (*s1 != *s2)
  800e92:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  800e96:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  800e9a:	83 c2 01             	add    $0x1,%edx
  800e9d:	83 e9 01             	sub    $0x1,%ecx
  800ea0:	38 d8                	cmp    %bl,%al
  800ea2:	74 0a                	je     800eae <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800ea4:	0f b6 c0             	movzbl %al,%eax
  800ea7:	0f b6 db             	movzbl %bl,%ebx
  800eaa:	29 d8                	sub    %ebx,%eax
  800eac:	eb 09                	jmp    800eb7 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800eae:	85 c9                	test   %ecx,%ecx
  800eb0:	75 e0                	jne    800e92 <memcmp+0x16>
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800eca:	eb 07                	jmp    800ed3 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	38 08                	cmp    %cl,(%eax)
  800ece:	74 07                	je     800ed7 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed0:	83 c0 01             	add    $0x1,%eax
  800ed3:	39 d0                	cmp    %edx,%eax
  800ed5:	72 f5                	jb     800ecc <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 04             	sub    $0x4,%esp
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee8:	eb 03                	jmp    800eed <strtol+0x14>
		s++;
  800eea:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eed:	0f b6 02             	movzbl (%edx),%eax
  800ef0:	3c 20                	cmp    $0x20,%al
  800ef2:	74 f6                	je     800eea <strtol+0x11>
  800ef4:	3c 09                	cmp    $0x9,%al
  800ef6:	74 f2                	je     800eea <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef8:	3c 2b                	cmp    $0x2b,%al
  800efa:	75 0c                	jne    800f08 <strtol+0x2f>
		s++;
  800efc:	8d 52 01             	lea    0x1(%edx),%edx
  800eff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f06:	eb 15                	jmp    800f1d <strtol+0x44>
	else if (*s == '-')
  800f08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f0f:	3c 2d                	cmp    $0x2d,%al
  800f11:	75 0a                	jne    800f1d <strtol+0x44>
		s++, neg = 1;
  800f13:	8d 52 01             	lea    0x1(%edx),%edx
  800f16:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f1d:	85 db                	test   %ebx,%ebx
  800f1f:	0f 94 c0             	sete   %al
  800f22:	74 05                	je     800f29 <strtol+0x50>
  800f24:	83 fb 10             	cmp    $0x10,%ebx
  800f27:	75 15                	jne    800f3e <strtol+0x65>
  800f29:	80 3a 30             	cmpb   $0x30,(%edx)
  800f2c:	75 10                	jne    800f3e <strtol+0x65>
  800f2e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f32:	75 0a                	jne    800f3e <strtol+0x65>
		s += 2, base = 16;
  800f34:	83 c2 02             	add    $0x2,%edx
  800f37:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3c:	eb 13                	jmp    800f51 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f3e:	84 c0                	test   %al,%al
  800f40:	74 0f                	je     800f51 <strtol+0x78>
  800f42:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f47:	80 3a 30             	cmpb   $0x30,(%edx)
  800f4a:	75 05                	jne    800f51 <strtol+0x78>
		s++, base = 8;
  800f4c:	83 c2 01             	add    $0x1,%edx
  800f4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
  800f56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f58:	0f b6 0a             	movzbl (%edx),%ecx
  800f5b:	89 cf                	mov    %ecx,%edi
  800f5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f60:	80 fb 09             	cmp    $0x9,%bl
  800f63:	77 08                	ja     800f6d <strtol+0x94>
			dig = *s - '0';
  800f65:	0f be c9             	movsbl %cl,%ecx
  800f68:	83 e9 30             	sub    $0x30,%ecx
  800f6b:	eb 1e                	jmp    800f8b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  800f6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f70:	80 fb 19             	cmp    $0x19,%bl
  800f73:	77 08                	ja     800f7d <strtol+0xa4>
			dig = *s - 'a' + 10;
  800f75:	0f be c9             	movsbl %cl,%ecx
  800f78:	83 e9 57             	sub    $0x57,%ecx
  800f7b:	eb 0e                	jmp    800f8b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  800f7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f80:	80 fb 19             	cmp    $0x19,%bl
  800f83:	77 15                	ja     800f9a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f85:	0f be c9             	movsbl %cl,%ecx
  800f88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f8b:	39 f1                	cmp    %esi,%ecx
  800f8d:	7d 0b                	jge    800f9a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f8f:	83 c2 01             	add    $0x1,%edx
  800f92:	0f af c6             	imul   %esi,%eax
  800f95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f98:	eb be                	jmp    800f58 <strtol+0x7f>
  800f9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa0:	74 05                	je     800fa7 <strtol+0xce>
		*endptr = (char *) s;
  800fa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800fa5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800fa7:	89 ca                	mov    %ecx,%edx
  800fa9:	f7 da                	neg    %edx
  800fab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800faf:	0f 45 c2             	cmovne %edx,%eax
}
  800fb2:	83 c4 04             	add    $0x4,%esp
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    
	...

00800fbc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	89 1c 24             	mov    %ebx,(%esp)
  800fc5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fc9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd7:	89 d1                	mov    %edx,%ecx
  800fd9:	89 d3                	mov    %edx,%ebx
  800fdb:	89 d7                	mov    %edx,%edi
  800fdd:	89 d6                	mov    %edx,%esi
  800fdf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fe1:	8b 1c 24             	mov    (%esp),%ebx
  800fe4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fe8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fec:	89 ec                	mov    %ebp,%esp
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	89 1c 24             	mov    %ebx,(%esp)
  800ff9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801001:	b8 00 00 00 00       	mov    $0x0,%eax
  801006:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801009:	8b 55 08             	mov    0x8(%ebp),%edx
  80100c:	89 c3                	mov    %eax,%ebx
  80100e:	89 c7                	mov    %eax,%edi
  801010:	89 c6                	mov    %eax,%esi
  801012:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801014:	8b 1c 24             	mov    (%esp),%ebx
  801017:	8b 74 24 04          	mov    0x4(%esp),%esi
  80101b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80101f:	89 ec                	mov    %ebp,%esp
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 0c             	sub    $0xc,%esp
  801029:	89 1c 24             	mov    %ebx,(%esp)
  80102c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801030:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	ba 00 00 00 00       	mov    $0x0,%edx
  801039:	b8 10 00 00 00       	mov    $0x10,%eax
  80103e:	89 d1                	mov    %edx,%ecx
  801040:	89 d3                	mov    %edx,%ebx
  801042:	89 d7                	mov    %edx,%edi
  801044:	89 d6                	mov    %edx,%esi
  801046:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801048:	8b 1c 24             	mov    (%esp),%ebx
  80104b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80104f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801053:	89 ec                	mov    %ebp,%esp
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 38             	sub    $0x38,%esp
  80105d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801060:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801063:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801066:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801070:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801073:	8b 55 08             	mov    0x8(%ebp),%edx
  801076:	89 df                	mov    %ebx,%edi
  801078:	89 de                	mov    %ebx,%esi
  80107a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	7e 28                	jle    8010a8 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801080:	89 44 24 10          	mov    %eax,0x10(%esp)
  801084:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80108b:	00 
  80108c:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  801093:	00 
  801094:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109b:	00 
  80109c:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  8010a3:	e8 9c 17 00 00       	call   802844 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  8010a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b1:	89 ec                	mov    %ebp,%esp
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 38             	sub    $0x38,%esp
  8010bb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010be:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	89 df                	mov    %ebx,%edi
  8010d6:	89 de                	mov    %ebx,%esi
  8010d8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	7e 28                	jle    801106 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010de:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e2:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010e9:	00 
  8010ea:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  8010f1:	00 
  8010f2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f9:	00 
  8010fa:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  801101:	e8 3e 17 00 00       	call   802844 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801106:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801109:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110f:	89 ec                	mov    %ebp,%esp
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 38             	sub    $0x38,%esp
  801119:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801122:	b9 00 00 00 00       	mov    $0x0,%ecx
  801127:	b8 0d 00 00 00       	mov    $0xd,%eax
  80112c:	8b 55 08             	mov    0x8(%ebp),%edx
  80112f:	89 cb                	mov    %ecx,%ebx
  801131:	89 cf                	mov    %ecx,%edi
  801133:	89 ce                	mov    %ecx,%esi
  801135:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801137:	85 c0                	test   %eax,%eax
  801139:	7e 28                	jle    801163 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801146:	00 
  801147:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  80114e:	00 
  80114f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801156:	00 
  801157:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  80115e:	e8 e1 16 00 00       	call   802844 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801163:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801166:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801169:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116c:	89 ec                	mov    %ebp,%esp
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	89 1c 24             	mov    %ebx,(%esp)
  801179:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801181:	be 00 00 00 00       	mov    $0x0,%esi
  801186:	b8 0c 00 00 00       	mov    $0xc,%eax
  80118b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80118e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801191:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801199:	8b 1c 24             	mov    (%esp),%ebx
  80119c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011a0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a4:	89 ec                	mov    %ebp,%esp
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    

008011a8 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 38             	sub    $0x38,%esp
  8011ae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c7:	89 df                	mov    %ebx,%edi
  8011c9:	89 de                	mov    %ebx,%esi
  8011cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	7e 28                	jle    8011f9 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d5:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  8011e4:	00 
  8011e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ec:	00 
  8011ed:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  8011f4:	e8 4b 16 00 00       	call   802844 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801202:	89 ec                	mov    %ebp,%esp
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    

00801206 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 38             	sub    $0x38,%esp
  80120c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80120f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801212:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801215:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121a:	b8 09 00 00 00       	mov    $0x9,%eax
  80121f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801222:	8b 55 08             	mov    0x8(%ebp),%edx
  801225:	89 df                	mov    %ebx,%edi
  801227:	89 de                	mov    %ebx,%esi
  801229:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80122b:	85 c0                	test   %eax,%eax
  80122d:	7e 28                	jle    801257 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80122f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801233:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80123a:	00 
  80123b:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  801242:	00 
  801243:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80124a:	00 
  80124b:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  801252:	e8 ed 15 00 00       	call   802844 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801257:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80125a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80125d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801260:	89 ec                	mov    %ebp,%esp
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    

00801264 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 38             	sub    $0x38,%esp
  80126a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80126d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801270:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801273:	bb 00 00 00 00       	mov    $0x0,%ebx
  801278:	b8 08 00 00 00       	mov    $0x8,%eax
  80127d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 df                	mov    %ebx,%edi
  801285:	89 de                	mov    %ebx,%esi
  801287:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801289:	85 c0                	test   %eax,%eax
  80128b:	7e 28                	jle    8012b5 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80128d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801291:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801298:	00 
  801299:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  8012a0:	00 
  8012a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a8:	00 
  8012a9:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  8012b0:	e8 8f 15 00 00       	call   802844 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012b5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012b8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012bb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012be:	89 ec                	mov    %ebp,%esp
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 38             	sub    $0x38,%esp
  8012c8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012cb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ce:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8012db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012de:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e1:	89 df                	mov    %ebx,%edi
  8012e3:	89 de                	mov    %ebx,%esi
  8012e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	7e 28                	jle    801313 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ef:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012f6:	00 
  8012f7:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  80130e:	e8 31 15 00 00       	call   802844 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801313:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801316:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801319:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80131c:	89 ec                	mov    %ebp,%esp
  80131e:	5d                   	pop    %ebp
  80131f:	c3                   	ret    

00801320 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 38             	sub    $0x38,%esp
  801326:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801329:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80132c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132f:	b8 05 00 00 00       	mov    $0x5,%eax
  801334:	8b 75 18             	mov    0x18(%ebp),%esi
  801337:	8b 7d 14             	mov    0x14(%ebp),%edi
  80133a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801340:	8b 55 08             	mov    0x8(%ebp),%edx
  801343:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801345:	85 c0                	test   %eax,%eax
  801347:	7e 28                	jle    801371 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801349:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801354:	00 
  801355:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  80135c:	00 
  80135d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801364:	00 
  801365:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  80136c:	e8 d3 14 00 00       	call   802844 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801371:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801374:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801377:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80137a:	89 ec                	mov    %ebp,%esp
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    

0080137e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 38             	sub    $0x38,%esp
  801384:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801387:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80138a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80138d:	be 00 00 00 00       	mov    $0x0,%esi
  801392:	b8 04 00 00 00       	mov    $0x4,%eax
  801397:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80139a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139d:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a0:	89 f7                	mov    %esi,%edi
  8013a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	7e 28                	jle    8013d0 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ac:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8013b3:	00 
  8013b4:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013c3:	00 
  8013c4:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  8013cb:	e8 74 14 00 00       	call   802844 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013d9:	89 ec                	mov    %ebp,%esp
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 0c             	sub    $0xc,%esp
  8013e3:	89 1c 24             	mov    %ebx,(%esp)
  8013e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013f8:	89 d1                	mov    %edx,%ecx
  8013fa:	89 d3                	mov    %edx,%ebx
  8013fc:	89 d7                	mov    %edx,%edi
  8013fe:	89 d6                	mov    %edx,%esi
  801400:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801402:	8b 1c 24             	mov    (%esp),%ebx
  801405:	8b 74 24 04          	mov    0x4(%esp),%esi
  801409:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80140d:	89 ec                	mov    %ebp,%esp
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	89 1c 24             	mov    %ebx,(%esp)
  80141a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80141e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801422:	ba 00 00 00 00       	mov    $0x0,%edx
  801427:	b8 02 00 00 00       	mov    $0x2,%eax
  80142c:	89 d1                	mov    %edx,%ecx
  80142e:	89 d3                	mov    %edx,%ebx
  801430:	89 d7                	mov    %edx,%edi
  801432:	89 d6                	mov    %edx,%esi
  801434:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801436:	8b 1c 24             	mov    (%esp),%ebx
  801439:	8b 74 24 04          	mov    0x4(%esp),%esi
  80143d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801441:	89 ec                	mov    %ebp,%esp
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 38             	sub    $0x38,%esp
  80144b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80144e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801451:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801454:	b9 00 00 00 00       	mov    $0x0,%ecx
  801459:	b8 03 00 00 00       	mov    $0x3,%eax
  80145e:	8b 55 08             	mov    0x8(%ebp),%edx
  801461:	89 cb                	mov    %ecx,%ebx
  801463:	89 cf                	mov    %ecx,%edi
  801465:	89 ce                	mov    %ecx,%esi
  801467:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801469:	85 c0                	test   %eax,%eax
  80146b:	7e 28                	jle    801495 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80146d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801471:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801478:	00 
  801479:	c7 44 24 08 c7 30 80 	movl   $0x8030c7,0x8(%esp)
  801480:	00 
  801481:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801488:	00 
  801489:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  801490:	e8 af 13 00 00       	call   802844 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801495:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801498:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80149b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80149e:	89 ec                	mov    %ebp,%esp
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    
	...

008014a4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8014af:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	89 04 24             	mov    %eax,(%esp)
  8014c0:	e8 df ff ff ff       	call   8014a4 <fd2num>
  8014c5:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014ca:	c1 e0 0c             	shl    $0xc,%eax
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	57                   	push   %edi
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014dd:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8014e2:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014e7:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	c1 ea 16             	shr    $0x16,%edx
  8014ee:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8014f1:	f6 c2 01             	test   $0x1,%dl
  8014f4:	74 0d                	je     801503 <fd_alloc+0x34>
  8014f6:	89 c2                	mov    %eax,%edx
  8014f8:	c1 ea 0c             	shr    $0xc,%edx
  8014fb:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  8014fe:	f6 c2 01             	test   $0x1,%dl
  801501:	75 09                	jne    80150c <fd_alloc+0x3d>
			*fd_store = fd;
  801503:	89 37                	mov    %esi,(%edi)
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80150a:	eb 17                	jmp    801523 <fd_alloc+0x54>
  80150c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801511:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801516:	75 cf                	jne    8014e7 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801518:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  80151e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801523:	5b                   	pop    %ebx
  801524:	5e                   	pop    %esi
  801525:	5f                   	pop    %edi
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	83 f8 1f             	cmp    $0x1f,%eax
  801531:	77 36                	ja     801569 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801533:	05 00 00 0d 00       	add    $0xd0000,%eax
  801538:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80153b:	89 c2                	mov    %eax,%edx
  80153d:	c1 ea 16             	shr    $0x16,%edx
  801540:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801547:	f6 c2 01             	test   $0x1,%dl
  80154a:	74 1d                	je     801569 <fd_lookup+0x41>
  80154c:	89 c2                	mov    %eax,%edx
  80154e:	c1 ea 0c             	shr    $0xc,%edx
  801551:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801558:	f6 c2 01             	test   $0x1,%dl
  80155b:	74 0c                	je     801569 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80155d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801560:	89 02                	mov    %eax,(%edx)
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801567:	eb 05                	jmp    80156e <fd_lookup+0x46>
  801569:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801576:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	89 04 24             	mov    %eax,(%esp)
  801583:	e8 a0 ff ff ff       	call   801528 <fd_lookup>
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 0e                	js     80159a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80158c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	89 50 04             	mov    %edx,0x4(%eax)
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 10             	sub    $0x10,%esp
  8015a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8015af:	be 70 31 80 00       	mov    $0x803170,%esi
  8015b4:	eb 10                	jmp    8015c6 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  8015b6:	39 08                	cmp    %ecx,(%eax)
  8015b8:	75 09                	jne    8015c3 <dev_lookup+0x27>
			*dev = devtab[i];
  8015ba:	89 03                	mov    %eax,(%ebx)
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8015c1:	eb 31                	jmp    8015f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015c3:	83 c2 01             	add    $0x1,%edx
  8015c6:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	75 e9                	jne    8015b6 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015cd:	a1 18 50 80 00       	mov    0x805018,%eax
  8015d2:	8b 40 48             	mov    0x48(%eax),%eax
  8015d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015dd:	c7 04 24 f4 30 80 00 	movl   $0x8030f4,(%esp)
  8015e4:	e8 ec ef ff ff       	call   8005d5 <cprintf>
	*dev = 0;
  8015e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	5b                   	pop    %ebx
  8015f8:	5e                   	pop    %esi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    

008015fb <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 24             	sub    $0x24,%esp
  801602:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801605:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	89 04 24             	mov    %eax,(%esp)
  801612:	e8 11 ff ff ff       	call   801528 <fd_lookup>
  801617:	85 c0                	test   %eax,%eax
  801619:	78 53                	js     80166e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	8b 00                	mov    (%eax),%eax
  801627:	89 04 24             	mov    %eax,(%esp)
  80162a:	e8 6d ff ff ff       	call   80159c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162f:	85 c0                	test   %eax,%eax
  801631:	78 3b                	js     80166e <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801633:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80163f:	74 2d                	je     80166e <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801641:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801644:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80164b:	00 00 00 
	stat->st_isdir = 0;
  80164e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801655:	00 00 00 
	stat->st_dev = dev;
  801658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801668:	89 14 24             	mov    %edx,(%esp)
  80166b:	ff 50 14             	call   *0x14(%eax)
}
  80166e:	83 c4 24             	add    $0x24,%esp
  801671:	5b                   	pop    %ebx
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	53                   	push   %ebx
  801678:	83 ec 24             	sub    $0x24,%esp
  80167b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801681:	89 44 24 04          	mov    %eax,0x4(%esp)
  801685:	89 1c 24             	mov    %ebx,(%esp)
  801688:	e8 9b fe ff ff       	call   801528 <fd_lookup>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 5f                	js     8016f0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801691:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801694:	89 44 24 04          	mov    %eax,0x4(%esp)
  801698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169b:	8b 00                	mov    (%eax),%eax
  80169d:	89 04 24             	mov    %eax,(%esp)
  8016a0:	e8 f7 fe ff ff       	call   80159c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 47                	js     8016f0 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ac:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8016b0:	75 23                	jne    8016d5 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016b2:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b7:	8b 40 48             	mov    0x48(%eax),%eax
  8016ba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c2:	c7 04 24 14 31 80 00 	movl   $0x803114,(%esp)
  8016c9:	e8 07 ef ff ff       	call   8005d5 <cprintf>
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016d3:	eb 1b                	jmp    8016f0 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8016d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d8:	8b 48 18             	mov    0x18(%eax),%ecx
  8016db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e0:	85 c9                	test   %ecx,%ecx
  8016e2:	74 0c                	je     8016f0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	89 14 24             	mov    %edx,(%esp)
  8016ee:	ff d1                	call   *%ecx
}
  8016f0:	83 c4 24             	add    $0x24,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	53                   	push   %ebx
  8016fa:	83 ec 24             	sub    $0x24,%esp
  8016fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801700:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801703:	89 44 24 04          	mov    %eax,0x4(%esp)
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 19 fe ff ff       	call   801528 <fd_lookup>
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 66                	js     801779 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801713:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	8b 00                	mov    (%eax),%eax
  80171f:	89 04 24             	mov    %eax,(%esp)
  801722:	e8 75 fe ff ff       	call   80159c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801727:	85 c0                	test   %eax,%eax
  801729:	78 4e                	js     801779 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80172e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801732:	75 23                	jne    801757 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801734:	a1 18 50 80 00       	mov    0x805018,%eax
  801739:	8b 40 48             	mov    0x48(%eax),%eax
  80173c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801740:	89 44 24 04          	mov    %eax,0x4(%esp)
  801744:	c7 04 24 35 31 80 00 	movl   $0x803135,(%esp)
  80174b:	e8 85 ee ff ff       	call   8005d5 <cprintf>
  801750:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801755:	eb 22                	jmp    801779 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80175d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801762:	85 c9                	test   %ecx,%ecx
  801764:	74 13                	je     801779 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801766:	8b 45 10             	mov    0x10(%ebp),%eax
  801769:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	89 44 24 04          	mov    %eax,0x4(%esp)
  801774:	89 14 24             	mov    %edx,(%esp)
  801777:	ff d1                	call   *%ecx
}
  801779:	83 c4 24             	add    $0x24,%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	53                   	push   %ebx
  801783:	83 ec 24             	sub    $0x24,%esp
  801786:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801789:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801790:	89 1c 24             	mov    %ebx,(%esp)
  801793:	e8 90 fd ff ff       	call   801528 <fd_lookup>
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 6b                	js     801807 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	8b 00                	mov    (%eax),%eax
  8017a8:	89 04 24             	mov    %eax,(%esp)
  8017ab:	e8 ec fd ff ff       	call   80159c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 53                	js     801807 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017b7:	8b 42 08             	mov    0x8(%edx),%eax
  8017ba:	83 e0 03             	and    $0x3,%eax
  8017bd:	83 f8 01             	cmp    $0x1,%eax
  8017c0:	75 23                	jne    8017e5 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017c2:	a1 18 50 80 00       	mov    0x805018,%eax
  8017c7:	8b 40 48             	mov    0x48(%eax),%eax
  8017ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d2:	c7 04 24 52 31 80 00 	movl   $0x803152,(%esp)
  8017d9:	e8 f7 ed ff ff       	call   8005d5 <cprintf>
  8017de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017e3:	eb 22                	jmp    801807 <read+0x88>
	}
	if (!dev->dev_read)
  8017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8017eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f0:	85 c9                	test   %ecx,%ecx
  8017f2:	74 13                	je     801807 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	89 14 24             	mov    %edx,(%esp)
  801805:	ff d1                	call   *%ecx
}
  801807:	83 c4 24             	add    $0x24,%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    

0080180d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	57                   	push   %edi
  801811:	56                   	push   %esi
  801812:	53                   	push   %ebx
  801813:	83 ec 1c             	sub    $0x1c,%esp
  801816:	8b 7d 08             	mov    0x8(%ebp),%edi
  801819:	8b 75 10             	mov    0x10(%ebp),%esi
  80181c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801821:	eb 21                	jmp    801844 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801823:	89 f2                	mov    %esi,%edx
  801825:	29 c2                	sub    %eax,%edx
  801827:	89 54 24 08          	mov    %edx,0x8(%esp)
  80182b:	03 45 0c             	add    0xc(%ebp),%eax
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	89 3c 24             	mov    %edi,(%esp)
  801835:	e8 45 ff ff ff       	call   80177f <read>
		if (m < 0)
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 0e                	js     80184c <readn+0x3f>
			return m;
		if (m == 0)
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 08                	je     80184a <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801842:	01 c3                	add    %eax,%ebx
  801844:	89 d8                	mov    %ebx,%eax
  801846:	39 f3                	cmp    %esi,%ebx
  801848:	72 d9                	jb     801823 <readn+0x16>
  80184a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80184c:	83 c4 1c             	add    $0x1c,%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5f                   	pop    %edi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 38             	sub    $0x38,%esp
  80185a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80185d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801860:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801863:	8b 7d 08             	mov    0x8(%ebp),%edi
  801866:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80186a:	89 3c 24             	mov    %edi,(%esp)
  80186d:	e8 32 fc ff ff       	call   8014a4 <fd2num>
  801872:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801875:	89 54 24 04          	mov    %edx,0x4(%esp)
  801879:	89 04 24             	mov    %eax,(%esp)
  80187c:	e8 a7 fc ff ff       	call   801528 <fd_lookup>
  801881:	89 c3                	mov    %eax,%ebx
  801883:	85 c0                	test   %eax,%eax
  801885:	78 05                	js     80188c <fd_close+0x38>
  801887:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  80188a:	74 0e                	je     80189a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80188c:	89 f0                	mov    %esi,%eax
  80188e:	84 c0                	test   %al,%al
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
  801895:	0f 44 d8             	cmove  %eax,%ebx
  801898:	eb 3d                	jmp    8018d7 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80189a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80189d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a1:	8b 07                	mov    (%edi),%eax
  8018a3:	89 04 24             	mov    %eax,(%esp)
  8018a6:	e8 f1 fc ff ff       	call   80159c <dev_lookup>
  8018ab:	89 c3                	mov    %eax,%ebx
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 16                	js     8018c7 <fd_close+0x73>
		if (dev->dev_close)
  8018b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b4:	8b 40 10             	mov    0x10(%eax),%eax
  8018b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	74 07                	je     8018c7 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  8018c0:	89 3c 24             	mov    %edi,(%esp)
  8018c3:	ff d0                	call   *%eax
  8018c5:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d2:	e8 eb f9 ff ff       	call   8012c2 <sys_page_unmap>
	return r;
}
  8018d7:	89 d8                	mov    %ebx,%eax
  8018d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018e2:	89 ec                	mov    %ebp,%esp
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 04 24             	mov    %eax,(%esp)
  8018f9:	e8 2a fc ff ff       	call   801528 <fd_lookup>
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 13                	js     801915 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801902:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801909:	00 
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	89 04 24             	mov    %eax,(%esp)
  801910:	e8 3f ff ff ff       	call   801854 <fd_close>
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 18             	sub    $0x18,%esp
  80191d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801920:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801923:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80192a:	00 
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	89 04 24             	mov    %eax,(%esp)
  801931:	e8 25 04 00 00       	call   801d5b <open>
  801936:	89 c3                	mov    %eax,%ebx
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 1b                	js     801957 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801943:	89 1c 24             	mov    %ebx,(%esp)
  801946:	e8 b0 fc ff ff       	call   8015fb <fstat>
  80194b:	89 c6                	mov    %eax,%esi
	close(fd);
  80194d:	89 1c 24             	mov    %ebx,(%esp)
  801950:	e8 91 ff ff ff       	call   8018e6 <close>
  801955:	89 f3                	mov    %esi,%ebx
	return r;
}
  801957:	89 d8                	mov    %ebx,%eax
  801959:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80195c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80195f:	89 ec                	mov    %ebp,%esp
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    

00801963 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	53                   	push   %ebx
  801967:	83 ec 14             	sub    $0x14,%esp
  80196a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  80196f:	89 1c 24             	mov    %ebx,(%esp)
  801972:	e8 6f ff ff ff       	call   8018e6 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801977:	83 c3 01             	add    $0x1,%ebx
  80197a:	83 fb 20             	cmp    $0x20,%ebx
  80197d:	75 f0                	jne    80196f <close_all+0xc>
		close(i);
}
  80197f:	83 c4 14             	add    $0x14,%esp
  801982:	5b                   	pop    %ebx
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 58             	sub    $0x58,%esp
  80198b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80198e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801991:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801994:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801997:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80199a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	89 04 24             	mov    %eax,(%esp)
  8019a4:	e8 7f fb ff ff       	call   801528 <fd_lookup>
  8019a9:	89 c3                	mov    %eax,%ebx
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	0f 88 e0 00 00 00    	js     801a93 <dup+0x10e>
		return r;
	close(newfdnum);
  8019b3:	89 3c 24             	mov    %edi,(%esp)
  8019b6:	e8 2b ff ff ff       	call   8018e6 <close>

	newfd = INDEX2FD(newfdnum);
  8019bb:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8019c1:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8019c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019c7:	89 04 24             	mov    %eax,(%esp)
  8019ca:	e8 e5 fa ff ff       	call   8014b4 <fd2data>
  8019cf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019d1:	89 34 24             	mov    %esi,(%esp)
  8019d4:	e8 db fa ff ff       	call   8014b4 <fd2data>
  8019d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019dc:	89 da                	mov    %ebx,%edx
  8019de:	89 d8                	mov    %ebx,%eax
  8019e0:	c1 e8 16             	shr    $0x16,%eax
  8019e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ea:	a8 01                	test   $0x1,%al
  8019ec:	74 43                	je     801a31 <dup+0xac>
  8019ee:	c1 ea 0c             	shr    $0xc,%edx
  8019f1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019f8:	a8 01                	test   $0x1,%al
  8019fa:	74 35                	je     801a31 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019fc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a03:	25 07 0e 00 00       	and    $0xe07,%eax
  801a08:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a1a:	00 
  801a1b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a26:	e8 f5 f8 ff ff       	call   801320 <sys_page_map>
  801a2b:	89 c3                	mov    %eax,%ebx
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	78 3f                	js     801a70 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a34:	89 c2                	mov    %eax,%edx
  801a36:	c1 ea 0c             	shr    $0xc,%edx
  801a39:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a40:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a46:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a4a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a4e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a55:	00 
  801a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a61:	e8 ba f8 ff ff       	call   801320 <sys_page_map>
  801a66:	89 c3                	mov    %eax,%ebx
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 04                	js     801a70 <dup+0xeb>
  801a6c:	89 fb                	mov    %edi,%ebx
  801a6e:	eb 23                	jmp    801a93 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a70:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7b:	e8 42 f8 ff ff       	call   8012c2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8e:	e8 2f f8 ff ff       	call   8012c2 <sys_page_unmap>
	return r;
}
  801a93:	89 d8                	mov    %ebx,%eax
  801a95:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a98:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a9b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a9e:	89 ec                	mov    %ebp,%esp
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    
	...

00801aa4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	83 ec 10             	sub    $0x10,%esp
  801aac:	89 c3                	mov    %eax,%ebx
  801aae:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801ab0:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801ab7:	75 11                	jne    801aca <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ab9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801ac0:	e8 d7 0d 00 00       	call   80289c <ipc_find_env>
  801ac5:	a3 10 50 80 00       	mov    %eax,0x805010

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801aca:	a1 18 50 80 00       	mov    0x805018,%eax
  801acf:	8b 40 48             	mov    0x48(%eax),%eax
  801ad2:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801ad8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801adc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae4:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  801aeb:	e8 e5 ea ff ff       	call   8005d5 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801af0:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801af7:	00 
  801af8:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801aff:	00 
  801b00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b04:	a1 10 50 80 00       	mov    0x805010,%eax
  801b09:	89 04 24             	mov    %eax,(%esp)
  801b0c:	e8 c1 0d 00 00       	call   8028d2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b18:	00 
  801b19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b24:	e8 15 0e 00 00       	call   80293e <ipc_recv>
}
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b49:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b53:	e8 4c ff ff ff       	call   801aa4 <fsipc>
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	8b 40 0c             	mov    0xc(%eax),%eax
  801b66:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b70:	b8 06 00 00 00       	mov    $0x6,%eax
  801b75:	e8 2a ff ff ff       	call   801aa4 <fsipc>
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b82:	ba 00 00 00 00       	mov    $0x0,%edx
  801b87:	b8 08 00 00 00       	mov    $0x8,%eax
  801b8c:	e8 13 ff ff ff       	call   801aa4 <fsipc>
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	53                   	push   %ebx
  801b97:	83 ec 14             	sub    $0x14,%esp
  801b9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ba8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bad:	b8 05 00 00 00       	mov    $0x5,%eax
  801bb2:	e8 ed fe ff ff       	call   801aa4 <fsipc>
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 2b                	js     801be6 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bbb:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bc2:	00 
  801bc3:	89 1c 24             	mov    %ebx,(%esp)
  801bc6:	e8 6e f0 ff ff       	call   800c39 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bcb:	a1 80 60 80 00       	mov    0x806080,%eax
  801bd0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bd6:	a1 84 60 80 00       	mov    0x806084,%eax
  801bdb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801be6:	83 c4 14             	add    $0x14,%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 14             	sub    $0x14,%esp
  801bf3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c01:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801c07:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801c0d:	76 24                	jbe    801c33 <devfile_write+0x47>
  801c0f:	c7 44 24 0c 9a 31 80 	movl   $0x80319a,0xc(%esp)
  801c16:	00 
  801c17:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  801c1e:	00 
  801c1f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801c26:	00 
  801c27:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  801c2e:	e8 11 0c 00 00       	call   802844 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801c33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3e:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c45:	e8 95 f1 ff ff       	call   800ddf <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4f:	b8 04 00 00 00       	mov    $0x4,%eax
  801c54:	e8 4b fe ff ff       	call   801aa4 <fsipc>
	if(ret<0) return ret;
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	78 53                	js     801cb0 <devfile_write+0xc4>
	
	assert(ret <= n);
  801c5d:	39 c3                	cmp    %eax,%ebx
  801c5f:	73 24                	jae    801c85 <devfile_write+0x99>
  801c61:	c7 44 24 0c c4 31 80 	movl   $0x8031c4,0xc(%esp)
  801c68:	00 
  801c69:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  801c70:	00 
  801c71:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c78:	00 
  801c79:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  801c80:	e8 bf 0b 00 00       	call   802844 <_panic>
	assert(ret <= PGSIZE);
  801c85:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c8a:	7e 24                	jle    801cb0 <devfile_write+0xc4>
  801c8c:	c7 44 24 0c cd 31 80 	movl   $0x8031cd,0xc(%esp)
  801c93:	00 
  801c94:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  801c9b:	00 
  801c9c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801ca3:	00 
  801ca4:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  801cab:	e8 94 0b 00 00       	call   802844 <_panic>
	return ret;
}
  801cb0:	83 c4 14             	add    $0x14,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 10             	sub    $0x10,%esp
  801cbe:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ccc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd7:	b8 03 00 00 00       	mov    $0x3,%eax
  801cdc:	e8 c3 fd ff ff       	call   801aa4 <fsipc>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	78 6b                	js     801d52 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801ce7:	39 de                	cmp    %ebx,%esi
  801ce9:	73 24                	jae    801d0f <devfile_read+0x59>
  801ceb:	c7 44 24 0c db 31 80 	movl   $0x8031db,0xc(%esp)
  801cf2:	00 
  801cf3:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  801cfa:	00 
  801cfb:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d02:	00 
  801d03:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  801d0a:	e8 35 0b 00 00       	call   802844 <_panic>
	assert(r <= PGSIZE);
  801d0f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801d15:	7e 24                	jle    801d3b <devfile_read+0x85>
  801d17:	c7 44 24 0c e2 31 80 	movl   $0x8031e2,0xc(%esp)
  801d1e:	00 
  801d1f:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  801d26:	00 
  801d27:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d2e:	00 
  801d2f:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  801d36:	e8 09 0b 00 00       	call   802844 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d46:	00 
  801d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4a:	89 04 24             	mov    %eax,(%esp)
  801d4d:	e8 8d f0 ff ff       	call   800ddf <memmove>
	return r;
}
  801d52:	89 d8                	mov    %ebx,%eax
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 28             	sub    $0x28,%esp
  801d61:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d64:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d67:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d6a:	89 34 24             	mov    %esi,(%esp)
  801d6d:	e8 8e ee ff ff       	call   800c00 <strlen>
  801d72:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d77:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d7c:	7f 5e                	jg     801ddc <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d81:	89 04 24             	mov    %eax,(%esp)
  801d84:	e8 46 f7 ff ff       	call   8014cf <fd_alloc>
  801d89:	89 c3                	mov    %eax,%ebx
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 4d                	js     801ddc <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d93:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d9a:	e8 9a ee ff ff       	call   800c39 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da2:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801da7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	e8 f0 fc ff ff       	call   801aa4 <fsipc>
  801db4:	89 c3                	mov    %eax,%ebx
  801db6:	85 c0                	test   %eax,%eax
  801db8:	79 15                	jns    801dcf <open+0x74>
		fd_close(fd, 0);
  801dba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dc1:	00 
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	89 04 24             	mov    %eax,(%esp)
  801dc8:	e8 87 fa ff ff       	call   801854 <fd_close>
		return r;
  801dcd:	eb 0d                	jmp    801ddc <open+0x81>
	}

	return fd2num(fd);
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	89 04 24             	mov    %eax,(%esp)
  801dd5:	e8 ca f6 ff ff       	call   8014a4 <fd2num>
  801dda:	89 c3                	mov    %eax,%ebx
}
  801ddc:	89 d8                	mov    %ebx,%eax
  801dde:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801de1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801de4:	89 ec                	mov    %ebp,%esp
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
	...

00801df0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801df6:	c7 44 24 04 ee 31 80 	movl   $0x8031ee,0x4(%esp)
  801dfd:	00 
  801dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e01:	89 04 24             	mov    %eax,(%esp)
  801e04:	e8 30 ee ff ff       	call   800c39 <strcpy>
	return 0;
}
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
  801e14:	83 ec 14             	sub    $0x14,%esp
  801e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e1a:	89 1c 24             	mov    %ebx,(%esp)
  801e1d:	e8 a6 0b 00 00       	call   8029c8 <pageref>
  801e22:	89 c2                	mov    %eax,%edx
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	83 fa 01             	cmp    $0x1,%edx
  801e2c:	75 0b                	jne    801e39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e2e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e31:	89 04 24             	mov    %eax,(%esp)
  801e34:	e8 b1 02 00 00       	call   8020ea <nsipc_close>
	else
		return 0;
}
  801e39:	83 c4 14             	add    $0x14,%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e45:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e4c:	00 
  801e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e61:	89 04 24             	mov    %eax,(%esp)
  801e64:	e8 bd 02 00 00       	call   802126 <nsipc_send>
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e78:	00 
  801e79:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8d:	89 04 24             	mov    %eax,(%esp)
  801e90:	e8 04 03 00 00       	call   802199 <nsipc_recv>
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	56                   	push   %esi
  801e9b:	53                   	push   %ebx
  801e9c:	83 ec 20             	sub    $0x20,%esp
  801e9f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ea1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea4:	89 04 24             	mov    %eax,(%esp)
  801ea7:	e8 23 f6 ff ff       	call   8014cf <fd_alloc>
  801eac:	89 c3                	mov    %eax,%ebx
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 21                	js     801ed3 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801eb2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801eb9:	00 
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec8:	e8 b1 f4 ff ff       	call   80137e <sys_page_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	79 0a                	jns    801edd <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801ed3:	89 34 24             	mov    %esi,(%esp)
  801ed6:	e8 0f 02 00 00       	call   8020ea <nsipc_close>
		return r;
  801edb:	eb 28                	jmp    801f05 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801edd:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	89 04 24             	mov    %eax,(%esp)
  801efe:	e8 a1 f5 ff ff       	call   8014a4 <fd2num>
  801f03:	89 c3                	mov    %eax,%ebx
}
  801f05:	89 d8                	mov    %ebx,%eax
  801f07:	83 c4 20             	add    $0x20,%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5e                   	pop    %esi
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    

00801f0e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f14:	8b 45 10             	mov    0x10(%ebp),%eax
  801f17:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	89 04 24             	mov    %eax,(%esp)
  801f28:	e8 71 01 00 00       	call   80209e <nsipc_socket>
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 05                	js     801f36 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801f31:	e8 61 ff ff ff       	call   801e97 <alloc_sockfd>
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f3e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f41:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f45:	89 04 24             	mov    %eax,(%esp)
  801f48:	e8 db f5 ff ff       	call   801528 <fd_lookup>
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 15                	js     801f66 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f54:	8b 0a                	mov    (%edx),%ecx
  801f56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f5b:	3b 0d 20 40 80 00    	cmp    0x804020,%ecx
  801f61:	75 03                	jne    801f66 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f63:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	e8 c2 ff ff ff       	call   801f38 <fd2sockid>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 0f                	js     801f89 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f81:	89 04 24             	mov    %eax,(%esp)
  801f84:	e8 3f 01 00 00       	call   8020c8 <nsipc_listen>
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	e8 9f ff ff ff       	call   801f38 <fd2sockid>
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 16                	js     801fb3 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801f9d:	8b 55 10             	mov    0x10(%ebp),%edx
  801fa0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fab:	89 04 24             	mov    %eax,(%esp)
  801fae:	e8 66 02 00 00       	call   802219 <nsipc_connect>
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	e8 75 ff ff ff       	call   801f38 <fd2sockid>
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	78 0f                	js     801fd6 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fca:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 2e 01 00 00       	call   802104 <nsipc_shutdown>
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	e8 52 ff ff ff       	call   801f38 <fd2sockid>
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 16                	js     802000 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801fea:	8b 55 10             	mov    0x10(%ebp),%edx
  801fed:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ff8:	89 04 24             	mov    %eax,(%esp)
  801ffb:	e8 58 02 00 00       	call   802258 <nsipc_bind>
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	e8 28 ff ff ff       	call   801f38 <fd2sockid>
  802010:	85 c0                	test   %eax,%eax
  802012:	78 1f                	js     802033 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802014:	8b 55 10             	mov    0x10(%ebp),%edx
  802017:	89 54 24 08          	mov    %edx,0x8(%esp)
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802022:	89 04 24             	mov    %eax,(%esp)
  802025:	e8 6d 02 00 00       	call   802297 <nsipc_accept>
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 05                	js     802033 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80202e:	e8 64 fe ff ff       	call   801e97 <alloc_sockfd>
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    
  802035:	00 00                	add    %al,(%eax)
	...

00802038 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	53                   	push   %ebx
  80203c:	83 ec 14             	sub    $0x14,%esp
  80203f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802041:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802048:	75 11                	jne    80205b <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80204a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802051:	e8 46 08 00 00       	call   80289c <ipc_find_env>
  802056:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80205b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802062:	00 
  802063:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  80206a:	00 
  80206b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80206f:	a1 14 50 80 00       	mov    0x805014,%eax
  802074:	89 04 24             	mov    %eax,(%esp)
  802077:	e8 56 08 00 00       	call   8028d2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80207c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802083:	00 
  802084:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80208b:	00 
  80208c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802093:	e8 a6 08 00 00       	call   80293e <ipc_recv>
}
  802098:	83 c4 14             	add    $0x14,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    

0080209e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8020bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8020c1:	e8 72 ff ff ff       	call   802038 <nsipc>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8020de:	b8 06 00 00 00       	mov    $0x6,%eax
  8020e3:	e8 50 ff ff ff       	call   802038 <nsipc>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8020f8:	b8 04 00 00 00       	mov    $0x4,%eax
  8020fd:	e8 36 ff ff ff       	call   802038 <nsipc>
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80211a:	b8 03 00 00 00       	mov    $0x3,%eax
  80211f:	e8 14 ff ff ff       	call   802038 <nsipc>
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	53                   	push   %ebx
  80212a:	83 ec 14             	sub    $0x14,%esp
  80212d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802138:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80213e:	7e 24                	jle    802164 <nsipc_send+0x3e>
  802140:	c7 44 24 0c fa 31 80 	movl   $0x8031fa,0xc(%esp)
  802147:	00 
  802148:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  80214f:	00 
  802150:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  802157:	00 
  802158:	c7 04 24 06 32 80 00 	movl   $0x803206,(%esp)
  80215f:	e8 e0 06 00 00       	call   802844 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802164:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216f:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802176:	e8 64 ec ff ff       	call   800ddf <memmove>
	nsipcbuf.send.req_size = size;
  80217b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802181:	8b 45 14             	mov    0x14(%ebp),%eax
  802184:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802189:	b8 08 00 00 00       	mov    $0x8,%eax
  80218e:	e8 a5 fe ff ff       	call   802038 <nsipc>
}
  802193:	83 c4 14             	add    $0x14,%esp
  802196:	5b                   	pop    %ebx
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	56                   	push   %esi
  80219d:	53                   	push   %ebx
  80219e:	83 ec 10             	sub    $0x10,%esp
  8021a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8021ac:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8021b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b5:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021ba:	b8 07 00 00 00       	mov    $0x7,%eax
  8021bf:	e8 74 fe ff ff       	call   802038 <nsipc>
  8021c4:	89 c3                	mov    %eax,%ebx
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	78 46                	js     802210 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021ca:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021cf:	7f 04                	jg     8021d5 <nsipc_recv+0x3c>
  8021d1:	39 c6                	cmp    %eax,%esi
  8021d3:	7d 24                	jge    8021f9 <nsipc_recv+0x60>
  8021d5:	c7 44 24 0c 12 32 80 	movl   $0x803212,0xc(%esp)
  8021dc:	00 
  8021dd:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  8021e4:	00 
  8021e5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8021ec:	00 
  8021ed:	c7 04 24 06 32 80 00 	movl   $0x803206,(%esp)
  8021f4:	e8 4b 06 00 00       	call   802844 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021fd:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802204:	00 
  802205:	8b 45 0c             	mov    0xc(%ebp),%eax
  802208:	89 04 24             	mov    %eax,(%esp)
  80220b:	e8 cf eb ff ff       	call   800ddf <memmove>
	}

	return r;
}
  802210:	89 d8                	mov    %ebx,%eax
  802212:	83 c4 10             	add    $0x10,%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    

00802219 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	53                   	push   %ebx
  80221d:	83 ec 14             	sub    $0x14,%esp
  802220:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80222b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80222f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802232:	89 44 24 04          	mov    %eax,0x4(%esp)
  802236:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80223d:	e8 9d eb ff ff       	call   800ddf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802242:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802248:	b8 05 00 00 00       	mov    $0x5,%eax
  80224d:	e8 e6 fd ff ff       	call   802038 <nsipc>
}
  802252:	83 c4 14             	add    $0x14,%esp
  802255:	5b                   	pop    %ebx
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    

00802258 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	53                   	push   %ebx
  80225c:	83 ec 14             	sub    $0x14,%esp
  80225f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80226a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80226e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802271:	89 44 24 04          	mov    %eax,0x4(%esp)
  802275:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80227c:	e8 5e eb ff ff       	call   800ddf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802281:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802287:	b8 02 00 00 00       	mov    $0x2,%eax
  80228c:	e8 a7 fd ff ff       	call   802038 <nsipc>
}
  802291:	83 c4 14             	add    $0x14,%esp
  802294:	5b                   	pop    %ebx
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    

00802297 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 28             	sub    $0x28,%esp
  80229d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022a0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022a3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022a6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022b1:	8b 07                	mov    (%edi),%eax
  8022b3:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bd:	e8 76 fd ff ff       	call   802038 <nsipc>
  8022c2:	89 c6                	mov    %eax,%esi
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	78 22                	js     8022ea <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022c8:	bb 10 80 80 00       	mov    $0x808010,%ebx
  8022cd:	8b 03                	mov    (%ebx),%eax
  8022cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022d3:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8022da:	00 
  8022db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022de:	89 04 24             	mov    %eax,(%esp)
  8022e1:	e8 f9 ea ff ff       	call   800ddf <memmove>
		*addrlen = ret->ret_addrlen;
  8022e6:	8b 03                	mov    (%ebx),%eax
  8022e8:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  8022ea:	89 f0                	mov    %esi,%eax
  8022ec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022ef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022f5:	89 ec                	mov    %ebp,%esp
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    
  8022f9:	00 00                	add    %al,(%eax)
	...

008022fc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 18             	sub    $0x18,%esp
  802302:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802305:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802308:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	89 04 24             	mov    %eax,(%esp)
  802311:	e8 9e f1 ff ff       	call   8014b4 <fd2data>
  802316:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802318:	c7 44 24 04 27 32 80 	movl   $0x803227,0x4(%esp)
  80231f:	00 
  802320:	89 34 24             	mov    %esi,(%esp)
  802323:	e8 11 e9 ff ff       	call   800c39 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802328:	8b 43 04             	mov    0x4(%ebx),%eax
  80232b:	2b 03                	sub    (%ebx),%eax
  80232d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802333:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80233a:	00 00 00 
	stat->st_dev = &devpipe;
  80233d:	c7 86 88 00 00 00 3c 	movl   $0x80403c,0x88(%esi)
  802344:	40 80 00 
	return 0;
}
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
  80234c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80234f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802352:	89 ec                	mov    %ebp,%esp
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    

00802356 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	53                   	push   %ebx
  80235a:	83 ec 14             	sub    $0x14,%esp
  80235d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802360:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802364:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80236b:	e8 52 ef ff ff       	call   8012c2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802370:	89 1c 24             	mov    %ebx,(%esp)
  802373:	e8 3c f1 ff ff       	call   8014b4 <fd2data>
  802378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802383:	e8 3a ef ff ff       	call   8012c2 <sys_page_unmap>
}
  802388:	83 c4 14             	add    $0x14,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    

0080238e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 2c             	sub    $0x2c,%esp
  802397:	89 c7                	mov    %eax,%edi
  802399:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80239c:	a1 18 50 80 00       	mov    0x805018,%eax
  8023a1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023a4:	89 3c 24             	mov    %edi,(%esp)
  8023a7:	e8 1c 06 00 00       	call   8029c8 <pageref>
  8023ac:	89 c6                	mov    %eax,%esi
  8023ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b1:	89 04 24             	mov    %eax,(%esp)
  8023b4:	e8 0f 06 00 00       	call   8029c8 <pageref>
  8023b9:	39 c6                	cmp    %eax,%esi
  8023bb:	0f 94 c0             	sete   %al
  8023be:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8023c1:	8b 15 18 50 80 00    	mov    0x805018,%edx
  8023c7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023ca:	39 cb                	cmp    %ecx,%ebx
  8023cc:	75 08                	jne    8023d6 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8023ce:	83 c4 2c             	add    $0x2c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8023d6:	83 f8 01             	cmp    $0x1,%eax
  8023d9:	75 c1                	jne    80239c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023db:	8b 52 58             	mov    0x58(%edx),%edx
  8023de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023ea:	c7 04 24 2e 32 80 00 	movl   $0x80322e,(%esp)
  8023f1:	e8 df e1 ff ff       	call   8005d5 <cprintf>
  8023f6:	eb a4                	jmp    80239c <_pipeisclosed+0xe>

008023f8 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	57                   	push   %edi
  8023fc:	56                   	push   %esi
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 1c             	sub    $0x1c,%esp
  802401:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802404:	89 34 24             	mov    %esi,(%esp)
  802407:	e8 a8 f0 ff ff       	call   8014b4 <fd2data>
  80240c:	89 c3                	mov    %eax,%ebx
  80240e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802413:	eb 48                	jmp    80245d <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802415:	89 da                	mov    %ebx,%edx
  802417:	89 f0                	mov    %esi,%eax
  802419:	e8 70 ff ff ff       	call   80238e <_pipeisclosed>
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 07                	je     802429 <devpipe_write+0x31>
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
  802427:	eb 3b                	jmp    802464 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802429:	e8 af ef ff ff       	call   8013dd <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80242e:	8b 43 04             	mov    0x4(%ebx),%eax
  802431:	8b 13                	mov    (%ebx),%edx
  802433:	83 c2 20             	add    $0x20,%edx
  802436:	39 d0                	cmp    %edx,%eax
  802438:	73 db                	jae    802415 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80243a:	89 c2                	mov    %eax,%edx
  80243c:	c1 fa 1f             	sar    $0x1f,%edx
  80243f:	c1 ea 1b             	shr    $0x1b,%edx
  802442:	01 d0                	add    %edx,%eax
  802444:	83 e0 1f             	and    $0x1f,%eax
  802447:	29 d0                	sub    %edx,%eax
  802449:	89 c2                	mov    %eax,%edx
  80244b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244e:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802452:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802456:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80245a:	83 c7 01             	add    $0x1,%edi
  80245d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802460:	72 cc                	jb     80242e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802462:	89 f8                	mov    %edi,%eax
}
  802464:	83 c4 1c             	add    $0x1c,%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5f                   	pop    %edi
  80246a:	5d                   	pop    %ebp
  80246b:	c3                   	ret    

0080246c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 28             	sub    $0x28,%esp
  802472:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802475:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802478:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80247b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80247e:	89 3c 24             	mov    %edi,(%esp)
  802481:	e8 2e f0 ff ff       	call   8014b4 <fd2data>
  802486:	89 c3                	mov    %eax,%ebx
  802488:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80248d:	eb 48                	jmp    8024d7 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80248f:	85 f6                	test   %esi,%esi
  802491:	74 04                	je     802497 <devpipe_read+0x2b>
				return i;
  802493:	89 f0                	mov    %esi,%eax
  802495:	eb 47                	jmp    8024de <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802497:	89 da                	mov    %ebx,%edx
  802499:	89 f8                	mov    %edi,%eax
  80249b:	e8 ee fe ff ff       	call   80238e <_pipeisclosed>
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	74 07                	je     8024ab <devpipe_read+0x3f>
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	eb 33                	jmp    8024de <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024ab:	e8 2d ef ff ff       	call   8013dd <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024b0:	8b 03                	mov    (%ebx),%eax
  8024b2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024b5:	74 d8                	je     80248f <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024b7:	89 c2                	mov    %eax,%edx
  8024b9:	c1 fa 1f             	sar    $0x1f,%edx
  8024bc:	c1 ea 1b             	shr    $0x1b,%edx
  8024bf:	01 d0                	add    %edx,%eax
  8024c1:	83 e0 1f             	and    $0x1f,%eax
  8024c4:	29 d0                	sub    %edx,%eax
  8024c6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ce:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8024d1:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024d4:	83 c6 01             	add    $0x1,%esi
  8024d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024da:	72 d4                	jb     8024b0 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024dc:	89 f0                	mov    %esi,%eax
}
  8024de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8024e1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8024e4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8024e7:	89 ec                	mov    %ebp,%esp
  8024e9:	5d                   	pop    %ebp
  8024ea:	c3                   	ret    

008024eb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	89 04 24             	mov    %eax,(%esp)
  8024fe:	e8 25 f0 ff ff       	call   801528 <fd_lookup>
  802503:	85 c0                	test   %eax,%eax
  802505:	78 15                	js     80251c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	89 04 24             	mov    %eax,(%esp)
  80250d:	e8 a2 ef ff ff       	call   8014b4 <fd2data>
	return _pipeisclosed(fd, p);
  802512:	89 c2                	mov    %eax,%edx
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	e8 72 fe ff ff       	call   80238e <_pipeisclosed>
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 48             	sub    $0x48,%esp
  802524:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802527:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80252a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80252d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802530:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802533:	89 04 24             	mov    %eax,(%esp)
  802536:	e8 94 ef ff ff       	call   8014cf <fd_alloc>
  80253b:	89 c3                	mov    %eax,%ebx
  80253d:	85 c0                	test   %eax,%eax
  80253f:	0f 88 42 01 00 00    	js     802687 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802545:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80254c:	00 
  80254d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802550:	89 44 24 04          	mov    %eax,0x4(%esp)
  802554:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80255b:	e8 1e ee ff ff       	call   80137e <sys_page_alloc>
  802560:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802562:	85 c0                	test   %eax,%eax
  802564:	0f 88 1d 01 00 00    	js     802687 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80256a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80256d:	89 04 24             	mov    %eax,(%esp)
  802570:	e8 5a ef ff ff       	call   8014cf <fd_alloc>
  802575:	89 c3                	mov    %eax,%ebx
  802577:	85 c0                	test   %eax,%eax
  802579:	0f 88 f5 00 00 00    	js     802674 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802586:	00 
  802587:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80258a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802595:	e8 e4 ed ff ff       	call   80137e <sys_page_alloc>
  80259a:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80259c:	85 c0                	test   %eax,%eax
  80259e:	0f 88 d0 00 00 00    	js     802674 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a7:	89 04 24             	mov    %eax,(%esp)
  8025aa:	e8 05 ef ff ff       	call   8014b4 <fd2data>
  8025af:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b8:	00 
  8025b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c4:	e8 b5 ed ff ff       	call   80137e <sys_page_alloc>
  8025c9:	89 c3                	mov    %eax,%ebx
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	0f 88 8e 00 00 00    	js     802661 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 d6 ee ff ff       	call   8014b4 <fd2data>
  8025de:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025e5:	00 
  8025e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025f1:	00 
  8025f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025fd:	e8 1e ed ff ff       	call   801320 <sys_page_map>
  802602:	89 c3                	mov    %eax,%ebx
  802604:	85 c0                	test   %eax,%eax
  802606:	78 49                	js     802651 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802608:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  80260d:	8b 08                	mov    (%eax),%ecx
  80260f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802612:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802614:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802617:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  80261e:	8b 10                	mov    (%eax),%edx
  802620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802623:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802625:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802628:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	89 04 24             	mov    %eax,(%esp)
  802635:	e8 6a ee ff ff       	call   8014a4 <fd2num>
  80263a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80263c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263f:	89 04 24             	mov    %eax,(%esp)
  802642:	e8 5d ee ff ff       	call   8014a4 <fd2num>
  802647:	89 47 04             	mov    %eax,0x4(%edi)
  80264a:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80264f:	eb 36                	jmp    802687 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802651:	89 74 24 04          	mov    %esi,0x4(%esp)
  802655:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80265c:	e8 61 ec ff ff       	call   8012c2 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266f:	e8 4e ec ff ff       	call   8012c2 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80267b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802682:	e8 3b ec ff ff       	call   8012c2 <sys_page_unmap>
    err:
	return r;
}
  802687:	89 d8                	mov    %ebx,%eax
  802689:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80268c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80268f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802692:	89 ec                	mov    %ebp,%esp
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    
	...

008026a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	5d                   	pop    %ebp
  8026a9:	c3                   	ret    

008026aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026b0:	c7 44 24 04 46 32 80 	movl   $0x803246,0x4(%esp)
  8026b7:	00 
  8026b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bb:	89 04 24             	mov    %eax,(%esp)
  8026be:	e8 76 e5 ff ff       	call   800c39 <strcpy>
	return 0;
}
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	57                   	push   %edi
  8026ce:	56                   	push   %esi
  8026cf:	53                   	push   %ebx
  8026d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8026d6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e1:	eb 34                	jmp    802717 <devcons_write+0x4d>
		m = n - tot;
  8026e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026e6:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  8026e8:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  8026ee:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026f3:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026f6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026fa:	03 45 0c             	add    0xc(%ebp),%eax
  8026fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802701:	89 3c 24             	mov    %edi,(%esp)
  802704:	e8 d6 e6 ff ff       	call   800ddf <memmove>
		sys_cputs(buf, m);
  802709:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80270d:	89 3c 24             	mov    %edi,(%esp)
  802710:	e8 db e8 ff ff       	call   800ff0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802715:	01 de                	add    %ebx,%esi
  802717:	89 f0                	mov    %esi,%eax
  802719:	3b 75 10             	cmp    0x10(%ebp),%esi
  80271c:	72 c5                	jb     8026e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80271e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802724:	5b                   	pop    %ebx
  802725:	5e                   	pop    %esi
  802726:	5f                   	pop    %edi
  802727:	5d                   	pop    %ebp
  802728:	c3                   	ret    

00802729 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802735:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80273c:	00 
  80273d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802740:	89 04 24             	mov    %eax,(%esp)
  802743:	e8 a8 e8 ff ff       	call   800ff0 <sys_cputs>
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802754:	75 07                	jne    80275d <devcons_read+0x13>
  802756:	eb 28                	jmp    802780 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802758:	e8 80 ec ff ff       	call   8013dd <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80275d:	8d 76 00             	lea    0x0(%esi),%esi
  802760:	e8 57 e8 ff ff       	call   800fbc <sys_cgetc>
  802765:	85 c0                	test   %eax,%eax
  802767:	74 ef                	je     802758 <devcons_read+0xe>
  802769:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80276b:	85 c0                	test   %eax,%eax
  80276d:	78 16                	js     802785 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80276f:	83 f8 04             	cmp    $0x4,%eax
  802772:	74 0c                	je     802780 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802774:	8b 45 0c             	mov    0xc(%ebp),%eax
  802777:	88 10                	mov    %dl,(%eax)
  802779:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  80277e:	eb 05                	jmp    802785 <devcons_read+0x3b>
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80278d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802790:	89 04 24             	mov    %eax,(%esp)
  802793:	e8 37 ed ff ff       	call   8014cf <fd_alloc>
  802798:	85 c0                	test   %eax,%eax
  80279a:	78 3f                	js     8027db <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80279c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027a3:	00 
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b2:	e8 c7 eb ff ff       	call   80137e <sys_page_alloc>
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	78 20                	js     8027db <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8027bb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	89 04 24             	mov    %eax,(%esp)
  8027d6:	e8 c9 ec ff ff       	call   8014a4 <fd2num>
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	89 04 24             	mov    %eax,(%esp)
  8027f0:	e8 33 ed ff ff       	call   801528 <fd_lookup>
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	78 11                	js     80280a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	3b 05 58 40 80 00    	cmp    0x804058,%eax
  802804:	0f 94 c0             	sete   %al
  802807:	0f b6 c0             	movzbl %al,%eax
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802812:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802819:	00 
  80281a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80281d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802821:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802828:	e8 52 ef ff ff       	call   80177f <read>
	if (r < 0)
  80282d:	85 c0                	test   %eax,%eax
  80282f:	78 0f                	js     802840 <getchar+0x34>
		return r;
	if (r < 1)
  802831:	85 c0                	test   %eax,%eax
  802833:	7f 07                	jg     80283c <getchar+0x30>
  802835:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80283a:	eb 04                	jmp    802840 <getchar+0x34>
		return -E_EOF;
	return c;
  80283c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    
	...

00802844 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
  802847:	56                   	push   %esi
  802848:	53                   	push   %ebx
  802849:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  80284c:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80284f:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  802855:	e8 b7 eb ff ff       	call   801411 <sys_getenvid>
  80285a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285d:	89 54 24 10          	mov    %edx,0x10(%esp)
  802861:	8b 55 08             	mov    0x8(%ebp),%edx
  802864:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802868:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80286c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802870:	c7 04 24 54 32 80 00 	movl   $0x803254,(%esp)
  802877:	e8 59 dd ff ff       	call   8005d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80287c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802880:	8b 45 10             	mov    0x10(%ebp),%eax
  802883:	89 04 24             	mov    %eax,(%esp)
  802886:	e8 e9 dc ff ff       	call   800574 <vcprintf>
	cprintf("\n");
  80288b:	c7 04 24 89 32 80 00 	movl   $0x803289,(%esp)
  802892:	e8 3e dd ff ff       	call   8005d5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802897:	cc                   	int3   
  802898:	eb fd                	jmp    802897 <_panic+0x53>
	...

0080289c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80289c:	55                   	push   %ebp
  80289d:	89 e5                	mov    %esp,%ebp
  80289f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8028a7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8028aa:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  8028b0:	8b 12                	mov    (%edx),%edx
  8028b2:	39 ca                	cmp    %ecx,%edx
  8028b4:	75 0c                	jne    8028c2 <ipc_find_env+0x26>
			return envs[i].env_id;
  8028b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8028b9:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	eb 0e                	jmp    8028d0 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028c2:	83 c0 01             	add    $0x1,%eax
  8028c5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028ca:	75 db                	jne    8028a7 <ipc_find_env+0xb>
  8028cc:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8028d0:	5d                   	pop    %ebp
  8028d1:	c3                   	ret    

008028d2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
  8028d5:	57                   	push   %edi
  8028d6:	56                   	push   %esi
  8028d7:	53                   	push   %ebx
  8028d8:	83 ec 2c             	sub    $0x2c,%esp
  8028db:	8b 75 08             	mov    0x8(%ebp),%esi
  8028de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8028e4:	85 db                	test   %ebx,%ebx
  8028e6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028eb:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8028ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028fd:	89 34 24             	mov    %esi,(%esp)
  802900:	e8 6b e8 ff ff       	call   801170 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802905:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802908:	74 e4                	je     8028ee <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 28                	je     802936 <ipc_send+0x64>
  80290e:	89 44 24 10          	mov    %eax,0x10(%esp)
  802912:	c7 44 24 0c 95 32 80 	movl   $0x803295,0xc(%esp)
  802919:	00 
  80291a:	c7 44 24 08 78 32 80 	movl   $0x803278,0x8(%esp)
  802921:	00 
  802922:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802929:	00 
  80292a:	c7 04 24 8b 32 80 00 	movl   $0x80328b,(%esp)
  802931:	e8 0e ff ff ff       	call   802844 <_panic>
	//if(!ret) sys_yield();
}
  802936:	83 c4 2c             	add    $0x2c,%esp
  802939:	5b                   	pop    %ebx
  80293a:	5e                   	pop    %esi
  80293b:	5f                   	pop    %edi
  80293c:	5d                   	pop    %ebp
  80293d:	c3                   	ret    

0080293e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	83 ec 28             	sub    $0x28,%esp
  802944:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802947:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80294a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80294d:	8b 75 08             	mov    0x8(%ebp),%esi
  802950:	8b 45 0c             	mov    0xc(%ebp),%eax
  802953:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802956:	85 c0                	test   %eax,%eax
  802958:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80295d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802960:	89 04 24             	mov    %eax,(%esp)
  802963:	e8 ab e7 ff ff       	call   801113 <sys_ipc_recv>
  802968:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  80296a:	e8 a2 ea ff ff       	call   801411 <sys_getenvid>
  80296f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802974:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802977:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80297c:	a3 18 50 80 00       	mov    %eax,0x805018
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802981:	85 f6                	test   %esi,%esi
  802983:	74 0e                	je     802993 <ipc_recv+0x55>
  802985:	ba 00 00 00 00       	mov    $0x0,%edx
  80298a:	85 db                	test   %ebx,%ebx
  80298c:	75 03                	jne    802991 <ipc_recv+0x53>
  80298e:	8b 50 74             	mov    0x74(%eax),%edx
  802991:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802993:	85 ff                	test   %edi,%edi
  802995:	74 13                	je     8029aa <ipc_recv+0x6c>
  802997:	b8 00 00 00 00       	mov    $0x0,%eax
  80299c:	85 db                	test   %ebx,%ebx
  80299e:	75 08                	jne    8029a8 <ipc_recv+0x6a>
  8029a0:	a1 18 50 80 00       	mov    0x805018,%eax
  8029a5:	8b 40 78             	mov    0x78(%eax),%eax
  8029a8:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  8029aa:	85 db                	test   %ebx,%ebx
  8029ac:	75 08                	jne    8029b6 <ipc_recv+0x78>
  8029ae:	a1 18 50 80 00       	mov    0x805018,%eax
  8029b3:	8b 58 70             	mov    0x70(%eax),%ebx
}
  8029b6:	89 d8                	mov    %ebx,%eax
  8029b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029c1:	89 ec                	mov    %ebp,%esp
  8029c3:	5d                   	pop    %ebp
  8029c4:	c3                   	ret    
  8029c5:	00 00                	add    %al,(%eax)
	...

008029c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	89 c2                	mov    %eax,%edx
  8029d0:	c1 ea 16             	shr    $0x16,%edx
  8029d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029da:	f6 c2 01             	test   $0x1,%dl
  8029dd:	74 20                	je     8029ff <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  8029df:	c1 e8 0c             	shr    $0xc,%eax
  8029e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029e9:	a8 01                	test   $0x1,%al
  8029eb:	74 12                	je     8029ff <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029ed:	c1 e8 0c             	shr    $0xc,%eax
  8029f0:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8029f5:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  8029fa:	0f b7 c0             	movzwl %ax,%eax
  8029fd:	eb 05                	jmp    802a04 <pageref+0x3c>
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
	...

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	57                   	push   %edi
  802a14:	56                   	push   %esi
  802a15:	83 ec 10             	sub    $0x10,%esp
  802a18:	8b 45 14             	mov    0x14(%ebp),%eax
  802a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1e:	8b 75 10             	mov    0x10(%ebp),%esi
  802a21:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a24:	85 c0                	test   %eax,%eax
  802a26:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802a29:	75 35                	jne    802a60 <__udivdi3+0x50>
  802a2b:	39 fe                	cmp    %edi,%esi
  802a2d:	77 61                	ja     802a90 <__udivdi3+0x80>
  802a2f:	85 f6                	test   %esi,%esi
  802a31:	75 0b                	jne    802a3e <__udivdi3+0x2e>
  802a33:	b8 01 00 00 00       	mov    $0x1,%eax
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	f7 f6                	div    %esi
  802a3c:	89 c6                	mov    %eax,%esi
  802a3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a41:	31 d2                	xor    %edx,%edx
  802a43:	89 f8                	mov    %edi,%eax
  802a45:	f7 f6                	div    %esi
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	89 c8                	mov    %ecx,%eax
  802a4b:	f7 f6                	div    %esi
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	89 fa                	mov    %edi,%edx
  802a51:	89 c8                	mov    %ecx,%eax
  802a53:	83 c4 10             	add    $0x10,%esp
  802a56:	5e                   	pop    %esi
  802a57:	5f                   	pop    %edi
  802a58:	5d                   	pop    %ebp
  802a59:	c3                   	ret    
  802a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a60:	39 f8                	cmp    %edi,%eax
  802a62:	77 1c                	ja     802a80 <__udivdi3+0x70>
  802a64:	0f bd d0             	bsr    %eax,%edx
  802a67:	83 f2 1f             	xor    $0x1f,%edx
  802a6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a6d:	75 39                	jne    802aa8 <__udivdi3+0x98>
  802a6f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802a72:	0f 86 a0 00 00 00    	jbe    802b18 <__udivdi3+0x108>
  802a78:	39 f8                	cmp    %edi,%eax
  802a7a:	0f 82 98 00 00 00    	jb     802b18 <__udivdi3+0x108>
  802a80:	31 ff                	xor    %edi,%edi
  802a82:	31 c9                	xor    %ecx,%ecx
  802a84:	89 c8                	mov    %ecx,%eax
  802a86:	89 fa                	mov    %edi,%edx
  802a88:	83 c4 10             	add    $0x10,%esp
  802a8b:	5e                   	pop    %esi
  802a8c:	5f                   	pop    %edi
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    
  802a8f:	90                   	nop
  802a90:	89 d1                	mov    %edx,%ecx
  802a92:	89 fa                	mov    %edi,%edx
  802a94:	89 c8                	mov    %ecx,%eax
  802a96:	31 ff                	xor    %edi,%edi
  802a98:	f7 f6                	div    %esi
  802a9a:	89 c1                	mov    %eax,%ecx
  802a9c:	89 fa                	mov    %edi,%edx
  802a9e:	89 c8                	mov    %ecx,%eax
  802aa0:	83 c4 10             	add    $0x10,%esp
  802aa3:	5e                   	pop    %esi
  802aa4:	5f                   	pop    %edi
  802aa5:	5d                   	pop    %ebp
  802aa6:	c3                   	ret    
  802aa7:	90                   	nop
  802aa8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aac:	89 f2                	mov    %esi,%edx
  802aae:	d3 e0                	shl    %cl,%eax
  802ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ab3:	b8 20 00 00 00       	mov    $0x20,%eax
  802ab8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802abb:	89 c1                	mov    %eax,%ecx
  802abd:	d3 ea                	shr    %cl,%edx
  802abf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ac3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802ac6:	d3 e6                	shl    %cl,%esi
  802ac8:	89 c1                	mov    %eax,%ecx
  802aca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802acd:	89 fe                	mov    %edi,%esi
  802acf:	d3 ee                	shr    %cl,%esi
  802ad1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ad5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	d3 e7                	shl    %cl,%edi
  802add:	89 c1                	mov    %eax,%ecx
  802adf:	d3 ea                	shr    %cl,%edx
  802ae1:	09 d7                	or     %edx,%edi
  802ae3:	89 f2                	mov    %esi,%edx
  802ae5:	89 f8                	mov    %edi,%eax
  802ae7:	f7 75 ec             	divl   -0x14(%ebp)
  802aea:	89 d6                	mov    %edx,%esi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	f7 65 e8             	mull   -0x18(%ebp)
  802af1:	39 d6                	cmp    %edx,%esi
  802af3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802af6:	72 30                	jb     802b28 <__udivdi3+0x118>
  802af8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aff:	d3 e2                	shl    %cl,%edx
  802b01:	39 c2                	cmp    %eax,%edx
  802b03:	73 05                	jae    802b0a <__udivdi3+0xfa>
  802b05:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802b08:	74 1e                	je     802b28 <__udivdi3+0x118>
  802b0a:	89 f9                	mov    %edi,%ecx
  802b0c:	31 ff                	xor    %edi,%edi
  802b0e:	e9 71 ff ff ff       	jmp    802a84 <__udivdi3+0x74>
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	31 ff                	xor    %edi,%edi
  802b1a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802b1f:	e9 60 ff ff ff       	jmp    802a84 <__udivdi3+0x74>
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802b2b:	31 ff                	xor    %edi,%edi
  802b2d:	89 c8                	mov    %ecx,%eax
  802b2f:	89 fa                	mov    %edi,%edx
  802b31:	83 c4 10             	add    $0x10,%esp
  802b34:	5e                   	pop    %esi
  802b35:	5f                   	pop    %edi
  802b36:	5d                   	pop    %ebp
  802b37:	c3                   	ret    
	...

00802b40 <__umoddi3>:
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
  802b43:	57                   	push   %edi
  802b44:	56                   	push   %esi
  802b45:	83 ec 20             	sub    $0x20,%esp
  802b48:	8b 55 14             	mov    0x14(%ebp),%edx
  802b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b4e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802b51:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b54:	85 d2                	test   %edx,%edx
  802b56:	89 c8                	mov    %ecx,%eax
  802b58:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802b5b:	75 13                	jne    802b70 <__umoddi3+0x30>
  802b5d:	39 f7                	cmp    %esi,%edi
  802b5f:	76 3f                	jbe    802ba0 <__umoddi3+0x60>
  802b61:	89 f2                	mov    %esi,%edx
  802b63:	f7 f7                	div    %edi
  802b65:	89 d0                	mov    %edx,%eax
  802b67:	31 d2                	xor    %edx,%edx
  802b69:	83 c4 20             	add    $0x20,%esp
  802b6c:	5e                   	pop    %esi
  802b6d:	5f                   	pop    %edi
  802b6e:	5d                   	pop    %ebp
  802b6f:	c3                   	ret    
  802b70:	39 f2                	cmp    %esi,%edx
  802b72:	77 4c                	ja     802bc0 <__umoddi3+0x80>
  802b74:	0f bd ca             	bsr    %edx,%ecx
  802b77:	83 f1 1f             	xor    $0x1f,%ecx
  802b7a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802b7d:	75 51                	jne    802bd0 <__umoddi3+0x90>
  802b7f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802b82:	0f 87 e0 00 00 00    	ja     802c68 <__umoddi3+0x128>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	29 f8                	sub    %edi,%eax
  802b8d:	19 d6                	sbb    %edx,%esi
  802b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	89 f2                	mov    %esi,%edx
  802b97:	83 c4 20             	add    $0x20,%esp
  802b9a:	5e                   	pop    %esi
  802b9b:	5f                   	pop    %edi
  802b9c:	5d                   	pop    %ebp
  802b9d:	c3                   	ret    
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	85 ff                	test   %edi,%edi
  802ba2:	75 0b                	jne    802baf <__umoddi3+0x6f>
  802ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba9:	31 d2                	xor    %edx,%edx
  802bab:	f7 f7                	div    %edi
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	89 f0                	mov    %esi,%eax
  802bb1:	31 d2                	xor    %edx,%edx
  802bb3:	f7 f7                	div    %edi
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	f7 f7                	div    %edi
  802bba:	eb a9                	jmp    802b65 <__umoddi3+0x25>
  802bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc0:	89 c8                	mov    %ecx,%eax
  802bc2:	89 f2                	mov    %esi,%edx
  802bc4:	83 c4 20             	add    $0x20,%esp
  802bc7:	5e                   	pop    %esi
  802bc8:	5f                   	pop    %edi
  802bc9:	5d                   	pop    %ebp
  802bca:	c3                   	ret    
  802bcb:	90                   	nop
  802bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bd4:	d3 e2                	shl    %cl,%edx
  802bd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bd9:	ba 20 00 00 00       	mov    $0x20,%edx
  802bde:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802be1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802be4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802be8:	89 fa                	mov    %edi,%edx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bf0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802bf3:	d3 e7                	shl    %cl,%edi
  802bf5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bfc:	89 f2                	mov    %esi,%edx
  802bfe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	d3 ea                	shr    %cl,%edx
  802c05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	d3 e6                	shl    %cl,%esi
  802c10:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c14:	d3 ea                	shr    %cl,%edx
  802c16:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c1a:	09 d6                	or     %edx,%esi
  802c1c:	89 f0                	mov    %esi,%eax
  802c1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802c21:	d3 e7                	shl    %cl,%edi
  802c23:	89 f2                	mov    %esi,%edx
  802c25:	f7 75 f4             	divl   -0xc(%ebp)
  802c28:	89 d6                	mov    %edx,%esi
  802c2a:	f7 65 e8             	mull   -0x18(%ebp)
  802c2d:	39 d6                	cmp    %edx,%esi
  802c2f:	72 2b                	jb     802c5c <__umoddi3+0x11c>
  802c31:	39 c7                	cmp    %eax,%edi
  802c33:	72 23                	jb     802c58 <__umoddi3+0x118>
  802c35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c39:	29 c7                	sub    %eax,%edi
  802c3b:	19 d6                	sbb    %edx,%esi
  802c3d:	89 f0                	mov    %esi,%eax
  802c3f:	89 f2                	mov    %esi,%edx
  802c41:	d3 ef                	shr    %cl,%edi
  802c43:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c47:	d3 e0                	shl    %cl,%eax
  802c49:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c4d:	09 f8                	or     %edi,%eax
  802c4f:	d3 ea                	shr    %cl,%edx
  802c51:	83 c4 20             	add    $0x20,%esp
  802c54:	5e                   	pop    %esi
  802c55:	5f                   	pop    %edi
  802c56:	5d                   	pop    %ebp
  802c57:	c3                   	ret    
  802c58:	39 d6                	cmp    %edx,%esi
  802c5a:	75 d9                	jne    802c35 <__umoddi3+0xf5>
  802c5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c5f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802c62:	eb d1                	jmp    802c35 <__umoddi3+0xf5>
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	39 f2                	cmp    %esi,%edx
  802c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c70:	0f 82 12 ff ff ff    	jb     802b88 <__umoddi3+0x48>
  802c76:	e9 17 ff ff ff       	jmp    802b92 <__umoddi3+0x52>
