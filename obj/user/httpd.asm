
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 0f 08 00 00       	call   800840 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 40 32 80 00 	movl   $0x803240,(%esp)
  800051:	e8 07 09 00 00       	call   80095d <cprintf>
	exit();
  800056:	e8 35 08 00 00       	call   800890 <exit>
}
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	57                   	push   %edi
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	81 ec 2c 02 00 00    	sub    $0x22c,%esp
  800069:	89 c3                	mov    %eax,%ebx
  80006b:	b8 10 40 80 00       	mov    $0x804010,%eax
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800070:	eb 07                	jmp    800079 <send_error+0x1c>
		if (e->code == code)
  800072:	39 d1                	cmp    %edx,%ecx
  800074:	74 11                	je     800087 <send_error+0x2a>
			break;
		e++;
  800076:	83 c0 08             	add    $0x8,%eax
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800079:	8b 08                	mov    (%eax),%ecx
  80007b:	85 c9                	test   %ecx,%ecx
  80007d:	74 5c                	je     8000db <send_error+0x7e>
  80007f:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  800083:	75 ed                	jne    800072 <send_error+0x15>
  800085:	eb 04                	jmp    80008b <send_error+0x2e>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  800087:	85 c9                	test   %ecx,%ecx
  800089:	74 50                	je     8000db <send_error+0x7e>
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80008b:	8b 40 04             	mov    0x4(%eax),%eax
  80008e:	89 44 24 18          	mov    %eax,0x18(%esp)
  800092:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  800096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80009e:	c7 44 24 08 e0 32 80 	movl   $0x8032e0,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  8000ad:	00 
  8000ae:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  8000b4:	89 34 24             	mov    %esi,(%esp)
  8000b7:	e8 78 0e 00 00       	call   800f34 <snprintf>
  8000bc:	89 c7                	mov    %eax,%edi
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8000be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c6:	8b 03                	mov    (%ebx),%eax
  8000c8:	89 04 24             	mov    %eax,(%esp)
  8000cb:	e8 b6 19 00 00       	call   801a86 <write>
  8000d0:	89 c2                	mov    %eax,%edx
  8000d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d7:	39 d7                	cmp    %edx,%edi
  8000d9:	74 05                	je     8000e0 <send_error+0x83>
  8000db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		return -1;

	return 0;
}
  8000e0:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	81 ec dc 06 00 00    	sub    $0x6dc,%esp
  8000f7:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000f9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800100:	00 
  800101:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800107:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010b:	89 34 24             	mov    %esi,(%esp)
  80010e:	e8 fc 19 00 00       	call   801b0f <read>
  800113:	85 c0                	test   %eax,%eax
  800115:	79 1c                	jns    800133 <handle_client+0x48>
			panic("failed to read");
  800117:	c7 44 24 08 44 32 80 	movl   $0x803244,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 53 32 80 00 	movl   $0x803253,(%esp)
  80012e:	e8 71 07 00 00       	call   8008a4 <_panic>

		memset(req, 0, sizeof(req));
  800133:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80013a:	00 
  80013b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800142:	00 
  800143:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800146:	89 04 24             	mov    %eax,(%esp)
  800149:	e8 c2 0f 00 00       	call   801110 <memset>

		req->sock = sock;
  80014e:	89 75 dc             	mov    %esi,-0x24(%ebp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  800151:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800158:	00 
  800159:	c7 44 24 04 60 32 80 	movl   $0x803260,0x4(%esp)
  800160:	00 
  800161:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800167:	89 04 24             	mov    %eax,(%esp)
  80016a:	e8 2b 0f 00 00       	call   80109a <strncmp>
  80016f:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  800175:	85 c0                	test   %eax,%eax
  800177:	74 08                	je     800181 <handle_client+0x96>
  800179:	e9 43 02 00 00       	jmp    8003c1 <handle_client+0x2d6>
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
  80017e:	83 c3 01             	add    $0x1,%ebx
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  800181:	0f b6 03             	movzbl (%ebx),%eax
  800184:	84 c0                	test   %al,%al
  800186:	74 04                	je     80018c <handle_client+0xa1>
  800188:	3c 20                	cmp    $0x20,%al
  80018a:	75 f2                	jne    80017e <handle_client+0x93>
		request++;
	url_len = request - url;
  80018c:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  800192:	89 85 34 f9 ff ff    	mov    %eax,-0x6cc(%ebp)
  800198:	89 df                	mov    %ebx,%edi
  80019a:	29 c7                	sub    %eax,%edi

	req->url = malloc(url_len + 1);
  80019c:	8d 47 01             	lea    0x1(%edi),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 b8 25 00 00       	call   80275f <malloc>
  8001a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8001aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001ae:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
  8001b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001b8:	89 04 24             	mov    %eax,(%esp)
  8001bb:	e8 af 0f 00 00       	call   80116f <memmove>
	req->url[url_len] = '\0';
  8001c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c3:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)

	// skip space
	request++;
  8001c7:	8d 7b 01             	lea    0x1(%ebx),%edi
  8001ca:	89 fb                	mov    %edi,%ebx
  8001cc:	eb 03                	jmp    8001d1 <handle_client+0xe6>

	version = request;
	while (*request && *request != '\n')
		request++;
  8001ce:	83 c3 01             	add    $0x1,%ebx

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8001d1:	0f b6 03             	movzbl (%ebx),%eax
  8001d4:	84 c0                	test   %al,%al
  8001d6:	74 04                	je     8001dc <handle_client+0xf1>
  8001d8:	3c 0a                	cmp    $0xa,%al
  8001da:	75 f2                	jne    8001ce <handle_client+0xe3>
		request++;
	version_len = request - version;
  8001dc:	29 fb                	sub    %edi,%ebx

	req->version = malloc(version_len + 1);
  8001de:	8d 43 01             	lea    0x1(%ebx),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 76 25 00 00       	call   80275f <malloc>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  8001ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 73 0f 00 00       	call   80116f <memmove>
	req->version[version_len] = '\0';
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.

	fd = open(req->url,O_RDONLY);
  800203:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80020a:	00 
  80020b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	e8 d5 1e 00 00       	call   8020eb <open>
  800216:	89 c7                	mov    %eax,%edi
	stat(req->url,&st);
  800218:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  80021e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	e8 7a 1a 00 00       	call   801ca7 <stat>
	
	if(fd<0 || st.st_isdir == 1)
  80022d:	85 ff                	test   %edi,%edi
  80022f:	78 0e                	js     80023f <handle_client+0x154>
  800231:	bb 00 40 80 00       	mov    $0x804000,%ebx
  800236:	83 bd d4 fd ff ff 01 	cmpl   $0x1,-0x22c(%ebp)
  80023d:	75 1c                	jne    80025b <handle_client+0x170>
	{
		r = send_error(req,404);
  80023f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800242:	ba 94 01 00 00       	mov    $0x194,%edx
  800247:	e8 11 fe ff ff       	call   80005d <send_error>
  80024c:	e9 47 01 00 00       	jmp    800398 <handle_client+0x2ad>
static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
		if (h->code == code)
  800251:	3d c8 00 00 00       	cmp    $0xc8,%eax
  800256:	74 13                	je     80026b <handle_client+0x180>
			break;
		h++;
  800258:	83 c3 08             	add    $0x8,%ebx

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  80025b:	8b 03                	mov    (%ebx),%eax
  80025d:	85 c0                	test   %eax,%eax
  80025f:	0f 84 2b 01 00 00    	je     800390 <handle_client+0x2a5>
  800265:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  800269:	75 e6                	jne    800251 <handle_client+0x166>
	}

	if (h->code == 0)
		return -1;

	int len = strlen(h->header);
  80026b:	8b 43 04             	mov    0x4(%ebx),%eax
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	e8 1a 0d 00 00       	call   800f90 <strlen>
  800276:	89 85 44 f9 ff ff    	mov    %eax,-0x6bc(%ebp)
	if (write(req->sock, h->header, len) != len) {
  80027c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800280:	8b 43 04             	mov    0x4(%ebx),%eax
  800283:	89 44 24 04          	mov    %eax,0x4(%esp)
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	e8 f4 17 00 00       	call   801a86 <write>
  800292:	39 85 44 f9 ff ff    	cmp    %eax,-0x6bc(%ebp)
  800298:	0f 84 32 01 00 00    	je     8003d0 <handle_client+0x2e5>
		die("Failed to send bytes to client");
  80029e:	b8 5c 33 80 00       	mov    $0x80335c,%eax
  8002a3:	e8 98 fd ff ff       	call   800040 <die>
  8002a8:	e9 23 01 00 00       	jmp    8003d0 <handle_client+0x2e5>
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
	if (r > 63)
		panic("buffer too small!");
  8002ad:	c7 44 24 08 65 32 80 	movl   $0x803265,0x8(%esp)
  8002b4:	00 
  8002b5:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8002bc:	00 
  8002bd:	c7 04 24 53 32 80 00 	movl   $0x803253,(%esp)
  8002c4:	e8 db 05 00 00       	call   8008a4 <_panic>

	if (write(req->sock, buf, r) != r)
  8002c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002cd:	8d 85 50 f9 ff ff    	lea    -0x6b0(%ebp),%eax
  8002d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002da:	89 04 24             	mov    %eax,(%esp)
  8002dd:	e8 a4 17 00 00       	call   801a86 <write>
  8002e2:	39 c3                	cmp    %eax,%ebx
  8002e4:	0f 85 a6 00 00 00    	jne    800390 <handle_client+0x2a5>
  8002ea:	e9 17 01 00 00       	jmp    800406 <handle_client+0x31b>
	if (!type)
		return -1;

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
	if (r > 127)
		panic("buffer too small!");
  8002ef:	c7 44 24 08 65 32 80 	movl   $0x803265,0x8(%esp)
  8002f6:	00 
  8002f7:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  8002fe:	00 
  8002ff:	c7 04 24 53 32 80 00 	movl   $0x803253,(%esp)
  800306:	e8 99 05 00 00       	call   8008a4 <_panic>

	if (write(req->sock, buf, r) != r)
  80030b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80030f:	8d 85 50 f9 ff ff    	lea    -0x6b0(%ebp),%eax
  800315:	89 44 24 04          	mov    %eax,0x4(%esp)
  800319:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80031c:	89 04 24             	mov    %eax,(%esp)
  80031f:	e8 62 17 00 00       	call   801a86 <write>
  800324:	39 c3                	cmp    %eax,%ebx
  800326:	75 68                	jne    800390 <handle_client+0x2a5>

static int
send_header_fin(struct http_request *req)
{
	const char *fin = "\r\n";
	int fin_len = strlen(fin);
  800328:	c7 04 24 8a 32 80 00 	movl   $0x80328a,(%esp)
  80032f:	e8 5c 0c 00 00       	call   800f90 <strlen>
  800334:	89 c3                	mov    %eax,%ebx

	if (write(req->sock, fin, fin_len) != fin_len)
  800336:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033a:	c7 44 24 04 8a 32 80 	movl   $0x80328a,0x4(%esp)
  800341:	00 
  800342:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	e8 39 17 00 00       	call   801a86 <write>
  80034d:	39 c3                	cmp    %eax,%ebx
  80034f:	75 3f                	jne    800390 <handle_client+0x2a5>
  800351:	eb 1d                	jmp    800370 <handle_client+0x285>
	char buf[1024];
	int ret;

	while((ret = read(fd,buf,1024))>0)
	{ 
		if(write(req->sock, buf, ret) != ret)
  800353:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800357:	8d 85 50 f9 ff ff    	lea    -0x6b0(%ebp),%eax
  80035d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800361:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800364:	89 04 24             	mov    %eax,(%esp)
  800367:	e8 1a 17 00 00       	call   801a86 <write>
  80036c:	39 c3                	cmp    %eax,%ebx
  80036e:	75 20                	jne    800390 <handle_client+0x2a5>
	// LAB 6: Your code here.
	//panic("send_data not implemented");
	char buf[1024];
	int ret;

	while((ret = read(fd,buf,1024))>0)
  800370:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  800377:	00 
  800378:	8d 95 50 f9 ff ff    	lea    -0x6b0(%ebp),%edx
  80037e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800382:	89 3c 24             	mov    %edi,(%esp)
  800385:	e8 85 17 00 00       	call   801b0f <read>
  80038a:	89 c3                	mov    %eax,%ebx
  80038c:	85 c0                	test   %eax,%eax
  80038e:	7f c3                	jg     800353 <handle_client+0x268>
		goto end;

	r = send_data(req, fd);

end:
	close(fd);
  800390:	89 3c 24             	mov    %edi,(%esp)
  800393:	e8 de 18 00 00       	call   801c76 <close>
}

static void
req_free(struct http_request *req)
{
	free(req->url);
  800398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039b:	89 04 24             	mov    %eax,(%esp)
  80039e:	e8 e9 22 00 00       	call   80268c <free>
	free(req->version);
  8003a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a6:	89 04 24             	mov    %eax,(%esp)
  8003a9:	e8 de 22 00 00       	call   80268c <free>

		// no keep alive
		break;
	}

	close(sock);
  8003ae:	89 34 24             	mov    %esi,(%esp)
  8003b1:	e8 c0 18 00 00       	call   801c76 <close>
}
  8003b6:	81 c4 dc 06 00 00    	add    $0x6dc,%esp
  8003bc:	5b                   	pop    %ebx
  8003bd:	5e                   	pop    %esi
  8003be:	5f                   	pop    %edi
  8003bf:	5d                   	pop    %ebp
  8003c0:	c3                   	ret    

		req->sock = sock;

		r = http_request_parse(req, buffer);
		if (r == -E_BAD_REQ)
			send_error(req, 400);
  8003c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8003c4:	ba 90 01 00 00       	mov    $0x190,%edx
  8003c9:	e8 8f fc ff ff       	call   80005d <send_error>
  8003ce:	eb c8                	jmp    800398 <handle_client+0x2ad>
send_size(struct http_request *req, off_t size)
{
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  8003d0:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  8003d7:	ff 
  8003d8:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  8003df:	00 
  8003e0:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  8003e7:	00 
  8003e8:	8d 85 50 f9 ff ff    	lea    -0x6b0(%ebp),%eax
  8003ee:	89 04 24             	mov    %eax,(%esp)
  8003f1:	e8 3e 0b 00 00       	call   800f34 <snprintf>
  8003f6:	89 c3                	mov    %eax,%ebx
	if (r > 63)
  8003f8:	83 f8 3f             	cmp    $0x3f,%eax
  8003fb:	0f 8e c8 fe ff ff    	jle    8002c9 <handle_client+0x1de>
  800401:	e9 a7 fe ff ff       	jmp    8002ad <handle_client+0x1c2>

	type = mime_type(req->url);
	if (!type)
		return -1;

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  800406:	c7 44 24 0c 8d 32 80 	movl   $0x80328d,0xc(%esp)
  80040d:	00 
  80040e:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800415:	00 
  800416:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80041d:	00 
  80041e:	8d 85 50 f9 ff ff    	lea    -0x6b0(%ebp),%eax
  800424:	89 04 24             	mov    %eax,(%esp)
  800427:	e8 08 0b 00 00       	call   800f34 <snprintf>
  80042c:	89 c3                	mov    %eax,%ebx
	if (r > 127)
  80042e:	83 f8 7f             	cmp    $0x7f,%eax
  800431:	0f 8e d4 fe ff ff    	jle    80030b <handle_client+0x220>
  800437:	e9 b3 fe ff ff       	jmp    8002ef <handle_client+0x204>

0080043c <umain>:
	close(sock);
}

void
umain(int argc, char **argv)
{
  80043c:	55                   	push   %ebp
  80043d:	89 e5                	mov    %esp,%ebp
  80043f:	57                   	push   %edi
  800440:	56                   	push   %esi
  800441:	53                   	push   %ebx
  800442:	83 ec 4c             	sub    $0x4c,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  800445:	c7 05 20 40 80 00 aa 	movl   $0x8032aa,0x804020
  80044c:	32 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  80044f:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800456:	00 
  800457:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80045e:	00 
  80045f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800466:	e8 33 1e 00 00       	call   80229e <socket>
  80046b:	89 c6                	mov    %eax,%esi
  80046d:	85 c0                	test   %eax,%eax
  80046f:	79 0a                	jns    80047b <umain+0x3f>
		die("Failed to create socket");
  800471:	b8 b1 32 80 00       	mov    $0x8032b1,%eax
  800476:	e8 c5 fb ff ff       	call   800040 <die>

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  80047b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800482:	00 
  800483:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80048a:	00 
  80048b:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80048e:	89 1c 24             	mov    %ebx,(%esp)
  800491:	e8 7a 0c 00 00       	call   801110 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  800496:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  80049a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a1:	e8 7a 01 00 00       	call   800620 <htonl>
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  8004a9:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  8004b0:	e8 4a 01 00 00       	call   8005ff <htons>
  8004b5:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  8004b9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8004c0:	00 
  8004c1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004c5:	89 34 24             	mov    %esi,(%esp)
  8004c8:	e8 9b 1e 00 00       	call   802368 <bind>
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	79 0a                	jns    8004db <umain+0x9f>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  8004d1:	b8 7c 33 80 00       	mov    $0x80337c,%eax
  8004d6:	e8 65 fb ff ff       	call   800040 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  8004db:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  8004e2:	00 
  8004e3:	89 34 24             	mov    %esi,(%esp)
  8004e6:	e8 0d 1e 00 00       	call   8022f8 <listen>
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	79 0a                	jns    8004f9 <umain+0xbd>
		die("Failed to listen on server socket");
  8004ef:	b8 a0 33 80 00       	mov    $0x8033a0,%eax
  8004f4:	e8 47 fb ff ff       	call   800040 <die>

	cprintf("Waiting for http connections...\n");
  8004f9:	c7 04 24 c4 33 80 00 	movl   $0x8033c4,(%esp)
  800500:	e8 58 04 00 00       	call   80095d <cprintf>

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800505:	8d 7d c4             	lea    -0x3c(%ebp),%edi
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
  800508:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  80050f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800513:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051a:	89 34 24             	mov    %esi,(%esp)
  80051d:	e8 70 1e 00 00       	call   802392 <accept>
  800522:	89 c3                	mov    %eax,%ebx
  800524:	85 c0                	test   %eax,%eax
  800526:	79 0a                	jns    800532 <umain+0xf6>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800528:	b8 e8 33 80 00       	mov    $0x8033e8,%eax
  80052d:	e8 0e fb ff ff       	call   800040 <die>
		}
		handle_client(clientsock);
  800532:	89 d8                	mov    %ebx,%eax
  800534:	e8 b2 fb ff ff       	call   8000eb <handle_client>
	}
  800539:	eb cd                	jmp    800508 <umain+0xcc>
  80053b:	00 00                	add    %al,(%eax)
  80053d:	00 00                	add    %al,(%eax)
	...

00800540 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	57                   	push   %edi
  800544:	56                   	push   %esi
  800545:	53                   	push   %ebx
  800546:	83 ec 20             	sub    $0x20,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80054f:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800552:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  800556:	c7 45 e0 00 50 80 00 	movl   $0x805000,-0x20(%ebp)
  80055d:	ba 00 00 00 00       	mov    $0x0,%edx
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
  800562:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800568:	0f b6 00             	movzbl (%eax),%eax
  80056b:	88 45 db             	mov    %al,-0x25(%ebp)
      *ap /= (u8_t)10;
  80056e:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  800573:	f6 65 db             	mulb   -0x25(%ebp)
  800576:	66 c1 e8 08          	shr    $0x8,%ax
  80057a:	c0 e8 03             	shr    $0x3,%al
  80057d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800580:	88 01                	mov    %al,(%ecx)
      inv[i++] = '0' + rem;
  800582:	0f b6 f2             	movzbl %dl,%esi
  800585:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  800588:	01 ff                	add    %edi,%edi
  80058a:	0f b6 5d db          	movzbl -0x25(%ebp),%ebx
  80058e:	89 f9                	mov    %edi,%ecx
  800590:	28 cb                	sub    %cl,%bl
  800592:	89 df                	mov    %ebx,%edi
  800594:	8d 4f 30             	lea    0x30(%edi),%ecx
  800597:	88 4c 35 ed          	mov    %cl,-0x13(%ebp,%esi,1)
  80059b:	8d 4a 01             	lea    0x1(%edx),%ecx
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80059e:	89 ca                	mov    %ecx,%edx
    i = 0;
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
  8005a0:	84 c0                	test   %al,%al
  8005a2:	75 c1                	jne    800565 <inet_ntoa+0x25>
  8005a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a7:	89 ce                	mov    %ecx,%esi
  8005a9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005ac:	eb 10                	jmp    8005be <inet_ntoa+0x7e>
    while(i--)
  8005ae:	83 ea 01             	sub    $0x1,%edx
      *rp++ = inv[i];
  8005b1:	0f b6 ca             	movzbl %dl,%ecx
  8005b4:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8005b9:	88 08                	mov    %cl,(%eax)
  8005bb:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8005be:	84 d2                	test   %dl,%dl
  8005c0:	75 ec                	jne    8005ae <inet_ntoa+0x6e>
  8005c2:	89 f1                	mov    %esi,%ecx
  8005c4:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005c7:	0f b6 c9             	movzbl %cl,%ecx
  8005ca:	03 4d e0             	add    -0x20(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  8005cd:	c6 01 2e             	movb   $0x2e,(%ecx)
  8005d0:	83 c1 01             	add    $0x1,%ecx
  8005d3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8005d6:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8005da:	80 7d df 03          	cmpb   $0x3,-0x21(%ebp)
  8005de:	77 0b                	ja     8005eb <inet_ntoa+0xab>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  8005e0:	83 c3 01             	add    $0x1,%ebx
  8005e3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005e6:	e9 7a ff ff ff       	jmp    800565 <inet_ntoa+0x25>
  }
  *--rp = 0;
  8005eb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ee:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8005f2:	b8 00 50 80 00       	mov    $0x805000,%eax
  8005f7:	83 c4 20             	add    $0x20,%esp
  8005fa:	5b                   	pop    %ebx
  8005fb:	5e                   	pop    %esi
  8005fc:	5f                   	pop    %edi
  8005fd:	5d                   	pop    %ebp
  8005fe:	c3                   	ret    

008005ff <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800606:	66 c1 c0 08          	rol    $0x8,%ax
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  800612:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800616:	89 04 24             	mov    %eax,(%esp)
  800619:	e8 e1 ff ff ff       	call   8005ff <htons>
}
  80061e:	c9                   	leave  
  80061f:	c3                   	ret    

00800620 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	8b 55 08             	mov    0x8(%ebp),%edx
  800626:	89 d1                	mov    %edx,%ecx
  800628:	c1 e9 18             	shr    $0x18,%ecx
  80062b:	89 d0                	mov    %edx,%eax
  80062d:	c1 e0 18             	shl    $0x18,%eax
  800630:	09 c8                	or     %ecx,%eax
  800632:	89 d1                	mov    %edx,%ecx
  800634:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80063a:	c1 e1 08             	shl    $0x8,%ecx
  80063d:	09 c8                	or     %ecx,%eax
  80063f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800645:	c1 ea 08             	shr    $0x8,%edx
  800648:	09 d0                	or     %edx,%eax
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80064a:	5d                   	pop    %ebp
  80064b:	c3                   	ret    

0080064c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	57                   	push   %edi
  800650:	56                   	push   %esi
  800651:	53                   	push   %ebx
  800652:	83 ec 28             	sub    $0x28,%esp
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800658:	0f be 10             	movsbl (%eax),%edx
  80065b:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  80065e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800661:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800664:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800667:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80066a:	80 f9 09             	cmp    $0x9,%cl
  80066d:	0f 87 87 01 00 00    	ja     8007fa <inet_aton+0x1ae>
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
  800673:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
  80067a:	83 fa 30             	cmp    $0x30,%edx
  80067d:	75 24                	jne    8006a3 <inet_aton+0x57>
      c = *++cp;
  80067f:	83 c0 01             	add    $0x1,%eax
  800682:	0f be 10             	movsbl (%eax),%edx
      if (c == 'x' || c == 'X') {
  800685:	83 fa 78             	cmp    $0x78,%edx
  800688:	74 0c                	je     800696 <inet_aton+0x4a>
  80068a:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800691:	83 fa 58             	cmp    $0x58,%edx
  800694:	75 0d                	jne    8006a3 <inet_aton+0x57>
        base = 16;
        c = *++cp;
  800696:	83 c0 01             	add    $0x1,%eax
  800699:	0f be 10             	movsbl (%eax),%edx
  80069c:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  8006a3:	83 c0 01             	add    $0x1,%eax
  8006a6:	be 00 00 00 00       	mov    $0x0,%esi
  8006ab:	eb 03                	jmp    8006b0 <inet_aton+0x64>
  8006ad:	83 c0 01             	add    $0x1,%eax
  8006b0:	8d 78 ff             	lea    -0x1(%eax),%edi
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8006b3:	89 d1                	mov    %edx,%ecx
  8006b5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8006b8:	80 fb 09             	cmp    $0x9,%bl
  8006bb:	77 0d                	ja     8006ca <inet_aton+0x7e>
        val = (val * base) + (int)(c - '0');
  8006bd:	0f af 75 e0          	imul   -0x20(%ebp),%esi
  8006c1:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  8006c5:	0f be 10             	movsbl (%eax),%edx
  8006c8:	eb e3                	jmp    8006ad <inet_aton+0x61>
      } else if (base == 16 && isxdigit(c)) {
  8006ca:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8006ce:	75 2b                	jne    8006fb <inet_aton+0xaf>
  8006d0:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8006d3:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  8006d6:	80 fb 05             	cmp    $0x5,%bl
  8006d9:	76 08                	jbe    8006e3 <inet_aton+0x97>
  8006db:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8006de:	80 fb 05             	cmp    $0x5,%bl
  8006e1:	77 18                	ja     8006fb <inet_aton+0xaf>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8006e3:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8006e7:	19 c9                	sbb    %ecx,%ecx
  8006e9:	83 e1 20             	and    $0x20,%ecx
  8006ec:	c1 e6 04             	shl    $0x4,%esi
  8006ef:	29 ca                	sub    %ecx,%edx
  8006f1:	8d 52 c9             	lea    -0x37(%edx),%edx
  8006f4:	09 d6                	or     %edx,%esi
        c = *++cp;
  8006f6:	0f be 10             	movsbl (%eax),%edx
  8006f9:	eb b2                	jmp    8006ad <inet_aton+0x61>
      } else
        break;
    }
    if (c == '.') {
  8006fb:	83 fa 2e             	cmp    $0x2e,%edx
  8006fe:	75 22                	jne    800722 <inet_aton+0xd6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800703:	39 55 d8             	cmp    %edx,-0x28(%ebp)
  800706:	0f 83 ee 00 00 00    	jae    8007fa <inet_aton+0x1ae>
        return (0);
      *pp++ = val;
  80070c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80070f:	89 31                	mov    %esi,(%ecx)
  800711:	83 c1 04             	add    $0x4,%ecx
  800714:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      c = *++cp;
  800717:	8d 47 01             	lea    0x1(%edi),%eax
  80071a:	0f be 10             	movsbl (%eax),%edx
    } else
      break;
  }
  80071d:	e9 45 ff ff ff       	jmp    800667 <inet_aton+0x1b>
  800722:	89 f3                	mov    %esi,%ebx
  800724:	89 f0                	mov    %esi,%eax
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800726:	85 d2                	test   %edx,%edx
  800728:	74 36                	je     800760 <inet_aton+0x114>
  80072a:	80 f9 1f             	cmp    $0x1f,%cl
  80072d:	0f 86 c7 00 00 00    	jbe    8007fa <inet_aton+0x1ae>
  800733:	84 d2                	test   %dl,%dl
  800735:	0f 88 bf 00 00 00    	js     8007fa <inet_aton+0x1ae>
  80073b:	83 fa 20             	cmp    $0x20,%edx
  80073e:	66 90                	xchg   %ax,%ax
  800740:	74 1e                	je     800760 <inet_aton+0x114>
  800742:	83 fa 0c             	cmp    $0xc,%edx
  800745:	74 19                	je     800760 <inet_aton+0x114>
  800747:	83 fa 0a             	cmp    $0xa,%edx
  80074a:	74 14                	je     800760 <inet_aton+0x114>
  80074c:	83 fa 0d             	cmp    $0xd,%edx
  80074f:	90                   	nop
  800750:	74 0e                	je     800760 <inet_aton+0x114>
  800752:	83 fa 09             	cmp    $0x9,%edx
  800755:	74 09                	je     800760 <inet_aton+0x114>
  800757:	83 fa 0b             	cmp    $0xb,%edx
  80075a:	0f 85 9a 00 00 00    	jne    8007fa <inet_aton+0x1ae>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  800760:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800763:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800766:	29 d1                	sub    %edx,%ecx
  800768:	89 ca                	mov    %ecx,%edx
  80076a:	c1 fa 02             	sar    $0x2,%edx
  80076d:	83 c2 01             	add    $0x1,%edx
  800770:	83 fa 02             	cmp    $0x2,%edx
  800773:	74 1d                	je     800792 <inet_aton+0x146>
  800775:	83 fa 02             	cmp    $0x2,%edx
  800778:	7f 08                	jg     800782 <inet_aton+0x136>
  80077a:	85 d2                	test   %edx,%edx
  80077c:	74 7c                	je     8007fa <inet_aton+0x1ae>
  80077e:	66 90                	xchg   %ax,%ax
  800780:	eb 59                	jmp    8007db <inet_aton+0x18f>
  800782:	83 fa 03             	cmp    $0x3,%edx
  800785:	74 1c                	je     8007a3 <inet_aton+0x157>
  800787:	83 fa 04             	cmp    $0x4,%edx
  80078a:	75 4f                	jne    8007db <inet_aton+0x18f>
  80078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800790:	eb 2a                	jmp    8007bc <inet_aton+0x170>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800792:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  800797:	77 61                	ja     8007fa <inet_aton+0x1ae>
      return (0);
    val |= parts[0] << 24;
  800799:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80079c:	c1 e3 18             	shl    $0x18,%ebx
  80079f:	09 c3                	or     %eax,%ebx
    break;
  8007a1:	eb 38                	jmp    8007db <inet_aton+0x18f>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8007a3:	3d ff ff 00 00       	cmp    $0xffff,%eax
  8007a8:	77 50                	ja     8007fa <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007aa:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8007ad:	c1 e3 10             	shl    $0x10,%ebx
  8007b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b3:	c1 e2 18             	shl    $0x18,%edx
  8007b6:	09 d3                	or     %edx,%ebx
  8007b8:	09 c3                	or     %eax,%ebx
    break;
  8007ba:	eb 1f                	jmp    8007db <inet_aton+0x18f>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8007bc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007c1:	77 37                	ja     8007fa <inet_aton+0x1ae>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8007c3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8007c6:	c1 e3 10             	shl    $0x10,%ebx
  8007c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007cc:	c1 e2 18             	shl    $0x18,%edx
  8007cf:	09 d3                	or     %edx,%ebx
  8007d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007d4:	c1 e2 08             	shl    $0x8,%edx
  8007d7:	09 d3                	or     %edx,%ebx
  8007d9:	09 c3                	or     %eax,%ebx
    break;
  }
  if (addr)
  8007db:	b8 01 00 00 00       	mov    $0x1,%eax
  8007e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e4:	74 19                	je     8007ff <inet_aton+0x1b3>
    addr->s_addr = htonl(val);
  8007e6:	89 1c 24             	mov    %ebx,(%esp)
  8007e9:	e8 32 fe ff ff       	call   800620 <htonl>
  8007ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007f1:	89 03                	mov    %eax,(%ebx)
  8007f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8007f8:	eb 05                	jmp    8007ff <inet_aton+0x1b3>
  8007fa:	b8 00 00 00 00       	mov    $0x0,%eax
  return (1);
}
  8007ff:	83 c4 28             	add    $0x28,%esp
  800802:	5b                   	pop    %ebx
  800803:	5e                   	pop    %esi
  800804:	5f                   	pop    %edi
  800805:	5d                   	pop    %ebp
  800806:	c3                   	ret    

00800807 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80080d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800810:	89 44 24 04          	mov    %eax,0x4(%esp)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	89 04 24             	mov    %eax,(%esp)
  80081a:	e8 2d fe ff ff       	call   80064c <inet_aton>
  80081f:	85 c0                	test   %eax,%eax
  800821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800826:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
    return (val.s_addr);
  }
  return (INADDR_NONE);
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	e8 e3 fd ff ff       	call   800620 <htonl>
}
  80083d:	c9                   	leave  
  80083e:	c3                   	ret    
	...

00800840 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 18             	sub    $0x18,%esp
  800846:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800849:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80084c:	8b 75 08             	mov    0x8(%ebp),%esi
  80084f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800852:	e8 4a 0f 00 00       	call   8017a1 <sys_getenvid>
  800857:	25 ff 03 00 00       	and    $0x3ff,%eax
  80085c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80085f:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800864:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800869:	85 f6                	test   %esi,%esi
  80086b:	7e 07                	jle    800874 <libmain+0x34>
		binaryname = argv[0];
  80086d:	8b 03                	mov    (%ebx),%eax
  80086f:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  800874:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800878:	89 34 24             	mov    %esi,(%esp)
  80087b:	e8 bc fb ff ff       	call   80043c <umain>

	// exit gracefully
	exit();
  800880:	e8 0b 00 00 00       	call   800890 <exit>
}
  800885:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800888:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80088b:	89 ec                	mov    %ebp,%esp
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    
	...

00800890 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  800896:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80089d:	e8 33 0f 00 00       	call   8017d5 <sys_env_destroy>
}
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	56                   	push   %esi
  8008a8:	53                   	push   %ebx
  8008a9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  8008ac:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8008af:	8b 1d 20 40 80 00    	mov    0x804020,%ebx
  8008b5:	e8 e7 0e 00 00       	call   8017a1 <sys_getenvid>
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bd:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d0:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8008d7:	e8 81 00 00 00       	call   80095d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8008dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e3:	89 04 24             	mov    %eax,(%esp)
  8008e6:	e8 11 00 00 00       	call   8008fc <vcprintf>
	cprintf("\n");
  8008eb:	c7 04 24 8b 32 80 00 	movl   $0x80328b,(%esp)
  8008f2:	e8 66 00 00 00       	call   80095d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8008f7:	cc                   	int3   
  8008f8:	eb fd                	jmp    8008f7 <_panic+0x53>
	...

008008fc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	89 44 24 08          	mov    %eax,0x8(%esp)
  800927:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80092d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800931:	c7 04 24 77 09 80 00 	movl   $0x800977,(%esp)
  800938:	e8 be 01 00 00       	call   800afb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80093d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800943:	89 44 24 04          	mov    %eax,0x4(%esp)
  800947:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80094d:	89 04 24             	mov    %eax,(%esp)
  800950:	e8 2b 0a 00 00       	call   801380 <sys_cputs>

	return b.cnt;
}
  800955:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    

0080095d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800963:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800966:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	89 04 24             	mov    %eax,(%esp)
  800970:	e8 87 ff ff ff       	call   8008fc <vcprintf>
	va_end(ap);

	return cnt;
}
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 14             	sub    $0x14,%esp
  80097e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800981:	8b 03                	mov    (%ebx),%eax
  800983:	8b 55 08             	mov    0x8(%ebp),%edx
  800986:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80098f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800994:	75 19                	jne    8009af <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800996:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80099d:	00 
  80099e:	8d 43 08             	lea    0x8(%ebx),%eax
  8009a1:	89 04 24             	mov    %eax,(%esp)
  8009a4:	e8 d7 09 00 00       	call   801380 <sys_cputs>
		b->idx = 0;
  8009a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8009af:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009b3:	83 c4 14             	add    $0x14,%esp
  8009b6:	5b                   	pop    %ebx
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
  8009b9:	00 00                	add    %al,(%eax)
	...

008009bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	57                   	push   %edi
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	83 ec 4c             	sub    $0x4c,%esp
  8009c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009c8:	89 d6                	mov    %edx,%esi
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8009d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8009dc:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e7:	39 d1                	cmp    %edx,%ecx
  8009e9:	72 07                	jb     8009f2 <printnum+0x36>
  8009eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009ee:	39 d0                	cmp    %edx,%eax
  8009f0:	77 69                	ja     800a5b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009f2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8009f6:	83 eb 01             	sub    $0x1,%ebx
  8009f9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8009fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a01:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800a05:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800a09:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800a0c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800a0f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a12:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800a1d:	00 
  800a1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a21:	89 04 24             	mov    %eax,(%esp)
  800a24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a27:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a2b:	e8 a0 25 00 00       	call   802fd0 <__udivdi3>
  800a30:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800a33:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a3a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800a3e:	89 04 24             	mov    %eax,(%esp)
  800a41:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a45:	89 f2                	mov    %esi,%edx
  800a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a4a:	e8 6d ff ff ff       	call   8009bc <printnum>
  800a4f:	eb 11                	jmp    800a62 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a51:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a55:	89 3c 24             	mov    %edi,(%esp)
  800a58:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a5b:	83 eb 01             	sub    $0x1,%ebx
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	7f ef                	jg     800a51 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a62:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a66:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800a78:	00 
  800a79:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a7c:	89 14 24             	mov    %edx,(%esp)
  800a7f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a86:	e8 75 26 00 00       	call   803100 <__umoddi3>
  800a8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a8f:	0f be 80 5f 34 80 00 	movsbl 0x80345f(%eax),%eax
  800a96:	89 04 24             	mov    %eax,(%esp)
  800a99:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800a9c:	83 c4 4c             	add    $0x4c,%esp
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5f                   	pop    %edi
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aa7:	83 fa 01             	cmp    $0x1,%edx
  800aaa:	7e 0e                	jle    800aba <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800aac:	8b 10                	mov    (%eax),%edx
  800aae:	8d 4a 08             	lea    0x8(%edx),%ecx
  800ab1:	89 08                	mov    %ecx,(%eax)
  800ab3:	8b 02                	mov    (%edx),%eax
  800ab5:	8b 52 04             	mov    0x4(%edx),%edx
  800ab8:	eb 22                	jmp    800adc <getuint+0x38>
	else if (lflag)
  800aba:	85 d2                	test   %edx,%edx
  800abc:	74 10                	je     800ace <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800abe:	8b 10                	mov    (%eax),%edx
  800ac0:	8d 4a 04             	lea    0x4(%edx),%ecx
  800ac3:	89 08                	mov    %ecx,(%eax)
  800ac5:	8b 02                	mov    (%edx),%eax
  800ac7:	ba 00 00 00 00       	mov    $0x0,%edx
  800acc:	eb 0e                	jmp    800adc <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800ace:	8b 10                	mov    (%eax),%edx
  800ad0:	8d 4a 04             	lea    0x4(%edx),%ecx
  800ad3:	89 08                	mov    %ecx,(%eax)
  800ad5:	8b 02                	mov    (%edx),%eax
  800ad7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800ae4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800ae8:	8b 10                	mov    (%eax),%edx
  800aea:	3b 50 04             	cmp    0x4(%eax),%edx
  800aed:	73 0a                	jae    800af9 <sprintputch+0x1b>
		*b->buf++ = ch;
  800aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af2:	88 0a                	mov    %cl,(%edx)
  800af4:	83 c2 01             	add    $0x1,%edx
  800af7:	89 10                	mov    %edx,(%eax)
}
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	57                   	push   %edi
  800aff:	56                   	push   %esi
  800b00:	53                   	push   %ebx
  800b01:	83 ec 4c             	sub    $0x4c,%esp
  800b04:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b07:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b0d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800b14:	eb 11                	jmp    800b27 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800b16:	85 c0                	test   %eax,%eax
  800b18:	0f 84 b6 03 00 00    	je     800ed4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  800b1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b27:	0f b6 03             	movzbl (%ebx),%eax
  800b2a:	83 c3 01             	add    $0x1,%ebx
  800b2d:	83 f8 25             	cmp    $0x25,%eax
  800b30:	75 e4                	jne    800b16 <vprintfmt+0x1b>
  800b32:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800b36:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800b3d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800b44:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800b4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b50:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b53:	eb 06                	jmp    800b5b <vprintfmt+0x60>
  800b55:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800b59:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b5b:	0f b6 0b             	movzbl (%ebx),%ecx
  800b5e:	0f b6 c1             	movzbl %cl,%eax
  800b61:	8d 53 01             	lea    0x1(%ebx),%edx
  800b64:	83 e9 23             	sub    $0x23,%ecx
  800b67:	80 f9 55             	cmp    $0x55,%cl
  800b6a:	0f 87 47 03 00 00    	ja     800eb7 <vprintfmt+0x3bc>
  800b70:	0f b6 c9             	movzbl %cl,%ecx
  800b73:	ff 24 8d a0 35 80 00 	jmp    *0x8035a0(,%ecx,4)
  800b7a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800b7e:	eb d9                	jmp    800b59 <vprintfmt+0x5e>
  800b80:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800b87:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800b8c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800b8f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800b93:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800b96:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800b99:	83 fb 09             	cmp    $0x9,%ebx
  800b9c:	77 30                	ja     800bce <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b9e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ba1:	eb e9                	jmp    800b8c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba6:	8d 48 04             	lea    0x4(%eax),%ecx
  800ba9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  800bb1:	eb 1e                	jmp    800bd1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  800bb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbc:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  800bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bc3:	eb 94                	jmp    800b59 <vprintfmt+0x5e>
  800bc5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800bcc:	eb 8b                	jmp    800b59 <vprintfmt+0x5e>
  800bce:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  800bd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd5:	79 82                	jns    800b59 <vprintfmt+0x5e>
  800bd7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bdd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800be0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800be3:	e9 71 ff ff ff       	jmp    800b59 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800be8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800bec:	e9 68 ff ff ff       	jmp    800b59 <vprintfmt+0x5e>
  800bf1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf7:	8d 50 04             	lea    0x4(%eax),%edx
  800bfa:	89 55 14             	mov    %edx,0x14(%ebp)
  800bfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	89 04 24             	mov    %eax,(%esp)
  800c06:	ff d7                	call   *%edi
  800c08:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800c0b:	e9 17 ff ff ff       	jmp    800b27 <vprintfmt+0x2c>
  800c10:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c13:	8b 45 14             	mov    0x14(%ebp),%eax
  800c16:	8d 50 04             	lea    0x4(%eax),%edx
  800c19:	89 55 14             	mov    %edx,0x14(%ebp)
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	89 c2                	mov    %eax,%edx
  800c20:	c1 fa 1f             	sar    $0x1f,%edx
  800c23:	31 d0                	xor    %edx,%eax
  800c25:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c27:	83 f8 11             	cmp    $0x11,%eax
  800c2a:	7f 0b                	jg     800c37 <vprintfmt+0x13c>
  800c2c:	8b 14 85 00 37 80 00 	mov    0x803700(,%eax,4),%edx
  800c33:	85 d2                	test   %edx,%edx
  800c35:	75 20                	jne    800c57 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  800c37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c3b:	c7 44 24 08 70 34 80 	movl   $0x803470,0x8(%esp)
  800c42:	00 
  800c43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c47:	89 3c 24             	mov    %edi,(%esp)
  800c4a:	e8 0d 03 00 00       	call   800f5c <printfmt>
  800c4f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c52:	e9 d0 fe ff ff       	jmp    800b27 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c57:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c5b:	c7 44 24 08 56 38 80 	movl   $0x803856,0x8(%esp)
  800c62:	00 
  800c63:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c67:	89 3c 24             	mov    %edi,(%esp)
  800c6a:	e8 ed 02 00 00       	call   800f5c <printfmt>
  800c6f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800c72:	e9 b0 fe ff ff       	jmp    800b27 <vprintfmt+0x2c>
  800c77:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800c7a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c83:	8b 45 14             	mov    0x14(%ebp),%eax
  800c86:	8d 50 04             	lea    0x4(%eax),%edx
  800c89:	89 55 14             	mov    %edx,0x14(%ebp)
  800c8c:	8b 18                	mov    (%eax),%ebx
  800c8e:	85 db                	test   %ebx,%ebx
  800c90:	b8 79 34 80 00       	mov    $0x803479,%eax
  800c95:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  800c98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800c9c:	7e 76                	jle    800d14 <vprintfmt+0x219>
  800c9e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800ca2:	74 7a                	je     800d1e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ca8:	89 1c 24             	mov    %ebx,(%esp)
  800cab:	e8 f8 02 00 00       	call   800fa8 <strnlen>
  800cb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cb3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  800cb5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  800cb9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800cbc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800cbf:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc1:	eb 0f                	jmp    800cd2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  800cc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cca:	89 04 24             	mov    %eax,(%esp)
  800ccd:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ccf:	83 eb 01             	sub    $0x1,%ebx
  800cd2:	85 db                	test   %ebx,%ebx
  800cd4:	7f ed                	jg     800cc3 <vprintfmt+0x1c8>
  800cd6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800cd9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800cdc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800cdf:	89 f7                	mov    %esi,%edi
  800ce1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800ce4:	eb 40                	jmp    800d26 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ce6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800cea:	74 18                	je     800d04 <vprintfmt+0x209>
  800cec:	8d 50 e0             	lea    -0x20(%eax),%edx
  800cef:	83 fa 5e             	cmp    $0x5e,%edx
  800cf2:	76 10                	jbe    800d04 <vprintfmt+0x209>
					putch('?', putdat);
  800cf4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cf8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800cff:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800d02:	eb 0a                	jmp    800d0e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800d04:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d08:	89 04 24             	mov    %eax,(%esp)
  800d0b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800d12:	eb 12                	jmp    800d26 <vprintfmt+0x22b>
  800d14:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800d17:	89 f7                	mov    %esi,%edi
  800d19:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800d1c:	eb 08                	jmp    800d26 <vprintfmt+0x22b>
  800d1e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800d21:	89 f7                	mov    %esi,%edi
  800d23:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800d26:	0f be 03             	movsbl (%ebx),%eax
  800d29:	83 c3 01             	add    $0x1,%ebx
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	74 25                	je     800d55 <vprintfmt+0x25a>
  800d30:	85 f6                	test   %esi,%esi
  800d32:	78 b2                	js     800ce6 <vprintfmt+0x1eb>
  800d34:	83 ee 01             	sub    $0x1,%esi
  800d37:	79 ad                	jns    800ce6 <vprintfmt+0x1eb>
  800d39:	89 fe                	mov    %edi,%esi
  800d3b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800d3e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800d41:	eb 1a                	jmp    800d5d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800d43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d47:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800d4e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d50:	83 eb 01             	sub    $0x1,%ebx
  800d53:	eb 08                	jmp    800d5d <vprintfmt+0x262>
  800d55:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800d58:	89 fe                	mov    %edi,%esi
  800d5a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800d5d:	85 db                	test   %ebx,%ebx
  800d5f:	7f e2                	jg     800d43 <vprintfmt+0x248>
  800d61:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800d64:	e9 be fd ff ff       	jmp    800b27 <vprintfmt+0x2c>
  800d69:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800d6c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d6f:	83 f9 01             	cmp    $0x1,%ecx
  800d72:	7e 16                	jle    800d8a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800d74:	8b 45 14             	mov    0x14(%ebp),%eax
  800d77:	8d 50 08             	lea    0x8(%eax),%edx
  800d7a:	89 55 14             	mov    %edx,0x14(%ebp)
  800d7d:	8b 10                	mov    (%eax),%edx
  800d7f:	8b 48 04             	mov    0x4(%eax),%ecx
  800d82:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800d85:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800d88:	eb 32                	jmp    800dbc <vprintfmt+0x2c1>
	else if (lflag)
  800d8a:	85 c9                	test   %ecx,%ecx
  800d8c:	74 18                	je     800da6 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  800d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d91:	8d 50 04             	lea    0x4(%eax),%edx
  800d94:	89 55 14             	mov    %edx,0x14(%ebp)
  800d97:	8b 00                	mov    (%eax),%eax
  800d99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d9c:	89 c1                	mov    %eax,%ecx
  800d9e:	c1 f9 1f             	sar    $0x1f,%ecx
  800da1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800da4:	eb 16                	jmp    800dbc <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  800da6:	8b 45 14             	mov    0x14(%ebp),%eax
  800da9:	8d 50 04             	lea    0x4(%eax),%edx
  800dac:	89 55 14             	mov    %edx,0x14(%ebp)
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800db4:	89 c2                	mov    %eax,%edx
  800db6:	c1 fa 1f             	sar    $0x1f,%edx
  800db9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dbc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800dbf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800dc2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800dc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dcb:	0f 89 a7 00 00 00    	jns    800e78 <vprintfmt+0x37d>
				putch('-', putdat);
  800dd1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dd5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ddc:	ff d7                	call   *%edi
				num = -(long long) num;
  800dde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800de1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800de4:	f7 d9                	neg    %ecx
  800de6:	83 d3 00             	adc    $0x0,%ebx
  800de9:	f7 db                	neg    %ebx
  800deb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df0:	e9 83 00 00 00       	jmp    800e78 <vprintfmt+0x37d>
  800df5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800df8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dfb:	89 ca                	mov    %ecx,%edx
  800dfd:	8d 45 14             	lea    0x14(%ebp),%eax
  800e00:	e8 9f fc ff ff       	call   800aa4 <getuint>
  800e05:	89 c1                	mov    %eax,%ecx
  800e07:	89 d3                	mov    %edx,%ebx
  800e09:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800e0e:	eb 68                	jmp    800e78 <vprintfmt+0x37d>
  800e10:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800e13:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800e16:	89 ca                	mov    %ecx,%edx
  800e18:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1b:	e8 84 fc ff ff       	call   800aa4 <getuint>
  800e20:	89 c1                	mov    %eax,%ecx
  800e22:	89 d3                	mov    %edx,%ebx
  800e24:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800e29:	eb 4d                	jmp    800e78 <vprintfmt+0x37d>
  800e2b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800e2e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e32:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800e39:	ff d7                	call   *%edi
			putch('x', putdat);
  800e3b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e3f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800e46:	ff d7                	call   *%edi
			num = (unsigned long long)
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	8d 50 04             	lea    0x4(%eax),%edx
  800e4e:	89 55 14             	mov    %edx,0x14(%ebp)
  800e51:	8b 08                	mov    (%eax),%ecx
  800e53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e58:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800e5d:	eb 19                	jmp    800e78 <vprintfmt+0x37d>
  800e5f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800e62:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e65:	89 ca                	mov    %ecx,%edx
  800e67:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6a:	e8 35 fc ff ff       	call   800aa4 <getuint>
  800e6f:	89 c1                	mov    %eax,%ecx
  800e71:	89 d3                	mov    %edx,%ebx
  800e73:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e78:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800e7c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800e80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e83:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e87:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e8b:	89 0c 24             	mov    %ecx,(%esp)
  800e8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e92:	89 f2                	mov    %esi,%edx
  800e94:	89 f8                	mov    %edi,%eax
  800e96:	e8 21 fb ff ff       	call   8009bc <printnum>
  800e9b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800e9e:	e9 84 fc ff ff       	jmp    800b27 <vprintfmt+0x2c>
  800ea3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eaa:	89 04 24             	mov    %eax,(%esp)
  800ead:	ff d7                	call   *%edi
  800eaf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  800eb2:	e9 70 fc ff ff       	jmp    800b27 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ebb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ec2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800ec7:	80 38 25             	cmpb   $0x25,(%eax)
  800eca:	0f 84 57 fc ff ff    	je     800b27 <vprintfmt+0x2c>
  800ed0:	89 c3                	mov    %eax,%ebx
  800ed2:	eb f0                	jmp    800ec4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  800ed4:	83 c4 4c             	add    $0x4c,%esp
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 28             	sub    $0x28,%esp
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	74 04                	je     800ef0 <vsnprintf+0x14>
  800eec:	85 d2                	test   %edx,%edx
  800eee:	7f 07                	jg     800ef7 <vsnprintf+0x1b>
  800ef0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef5:	eb 3b                	jmp    800f32 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ef7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800efa:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f08:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f19:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1d:	c7 04 24 de 0a 80 00 	movl   $0x800ade,(%esp)
  800f24:	e8 d2 fb ff ff       	call   800afb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f2c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800f3a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800f3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	89 04 24             	mov    %eax,(%esp)
  800f55:	e8 82 ff ff ff       	call   800edc <vsnprintf>
	va_end(ap);

	return rc;
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800f62:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800f65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	89 04 24             	mov    %eax,(%esp)
  800f7d:	e8 79 fb ff ff       	call   800afb <vprintfmt>
	va_end(ap);
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    
	...

00800f90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800f9b:	eb 03                	jmp    800fa0 <strlen+0x10>
		n++;
  800f9d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fa0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800fa4:	75 f7                	jne    800f9d <strlen+0xd>
		n++;
	return n;
}
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	53                   	push   %ebx
  800fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fb7:	eb 03                	jmp    800fbc <strnlen+0x14>
		n++;
  800fb9:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fbc:	39 c1                	cmp    %eax,%ecx
  800fbe:	74 06                	je     800fc6 <strnlen+0x1e>
  800fc0:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800fc4:	75 f3                	jne    800fb9 <strnlen+0x11>
		n++;
	return n;
}
  800fc6:	5b                   	pop    %ebx
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	53                   	push   %ebx
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800fd3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800fd8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800fdc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800fdf:	83 c2 01             	add    $0x1,%edx
  800fe2:	84 c9                	test   %cl,%cl
  800fe4:	75 f2                	jne    800fd8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800fe6:	5b                   	pop    %ebx
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	53                   	push   %ebx
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ff3:	89 1c 24             	mov    %ebx,(%esp)
  800ff6:	e8 95 ff ff ff       	call   800f90 <strlen>
	strcpy(dst + len, src);
  800ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffe:	89 54 24 04          	mov    %edx,0x4(%esp)
  801002:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  801005:	89 04 24             	mov    %eax,(%esp)
  801008:	e8 bc ff ff ff       	call   800fc9 <strcpy>
	return dst;
}
  80100d:	89 d8                	mov    %ebx,%eax
  80100f:	83 c4 08             	add    $0x8,%esp
  801012:	5b                   	pop    %ebx
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	56                   	push   %esi
  801019:	53                   	push   %ebx
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	8b 75 10             	mov    0x10(%ebp),%esi
  801023:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801028:	eb 0f                	jmp    801039 <strncpy+0x24>
		*dst++ = *src;
  80102a:	0f b6 19             	movzbl (%ecx),%ebx
  80102d:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801030:	80 39 01             	cmpb   $0x1,(%ecx)
  801033:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801036:	83 c2 01             	add    $0x1,%edx
  801039:	39 f2                	cmp    %esi,%edx
  80103b:	72 ed                	jb     80102a <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80103d:	5b                   	pop    %ebx
  80103e:	5e                   	pop    %esi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	56                   	push   %esi
  801045:	53                   	push   %ebx
  801046:	8b 75 08             	mov    0x8(%ebp),%esi
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80104f:	89 f0                	mov    %esi,%eax
  801051:	85 d2                	test   %edx,%edx
  801053:	75 0a                	jne    80105f <strlcpy+0x1e>
  801055:	eb 17                	jmp    80106e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801057:	88 18                	mov    %bl,(%eax)
  801059:	83 c0 01             	add    $0x1,%eax
  80105c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80105f:	83 ea 01             	sub    $0x1,%edx
  801062:	74 07                	je     80106b <strlcpy+0x2a>
  801064:	0f b6 19             	movzbl (%ecx),%ebx
  801067:	84 db                	test   %bl,%bl
  801069:	75 ec                	jne    801057 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80106b:	c6 00 00             	movb   $0x0,(%eax)
  80106e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  801070:	5b                   	pop    %ebx
  801071:	5e                   	pop    %esi
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80107d:	eb 06                	jmp    801085 <strcmp+0x11>
		p++, q++;
  80107f:	83 c1 01             	add    $0x1,%ecx
  801082:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801085:	0f b6 01             	movzbl (%ecx),%eax
  801088:	84 c0                	test   %al,%al
  80108a:	74 04                	je     801090 <strcmp+0x1c>
  80108c:	3a 02                	cmp    (%edx),%al
  80108e:	74 ef                	je     80107f <strcmp+0xb>
  801090:	0f b6 c0             	movzbl %al,%eax
  801093:	0f b6 12             	movzbl (%edx),%edx
  801096:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	53                   	push   %ebx
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8010a7:	eb 09                	jmp    8010b2 <strncmp+0x18>
		n--, p++, q++;
  8010a9:	83 ea 01             	sub    $0x1,%edx
  8010ac:	83 c0 01             	add    $0x1,%eax
  8010af:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010b2:	85 d2                	test   %edx,%edx
  8010b4:	75 07                	jne    8010bd <strncmp+0x23>
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bb:	eb 13                	jmp    8010d0 <strncmp+0x36>
  8010bd:	0f b6 18             	movzbl (%eax),%ebx
  8010c0:	84 db                	test   %bl,%bl
  8010c2:	74 04                	je     8010c8 <strncmp+0x2e>
  8010c4:	3a 19                	cmp    (%ecx),%bl
  8010c6:	74 e1                	je     8010a9 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010c8:	0f b6 00             	movzbl (%eax),%eax
  8010cb:	0f b6 11             	movzbl (%ecx),%edx
  8010ce:	29 d0                	sub    %edx,%eax
}
  8010d0:	5b                   	pop    %ebx
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010dd:	eb 07                	jmp    8010e6 <strchr+0x13>
		if (*s == c)
  8010df:	38 ca                	cmp    %cl,%dl
  8010e1:	74 0f                	je     8010f2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010e3:	83 c0 01             	add    $0x1,%eax
  8010e6:	0f b6 10             	movzbl (%eax),%edx
  8010e9:	84 d2                	test   %dl,%dl
  8010eb:	75 f2                	jne    8010df <strchr+0xc>
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010fe:	eb 07                	jmp    801107 <strfind+0x13>
		if (*s == c)
  801100:	38 ca                	cmp    %cl,%dl
  801102:	74 0a                	je     80110e <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801104:	83 c0 01             	add    $0x1,%eax
  801107:	0f b6 10             	movzbl (%eax),%edx
  80110a:	84 d2                	test   %dl,%dl
  80110c:	75 f2                	jne    801100 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 0c             	sub    $0xc,%esp
  801116:	89 1c 24             	mov    %ebx,(%esp)
  801119:	89 74 24 04          	mov    %esi,0x4(%esp)
  80111d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801121:	8b 7d 08             	mov    0x8(%ebp),%edi
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80112a:	85 c9                	test   %ecx,%ecx
  80112c:	74 30                	je     80115e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80112e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801134:	75 25                	jne    80115b <memset+0x4b>
  801136:	f6 c1 03             	test   $0x3,%cl
  801139:	75 20                	jne    80115b <memset+0x4b>
		c &= 0xFF;
  80113b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80113e:	89 d3                	mov    %edx,%ebx
  801140:	c1 e3 08             	shl    $0x8,%ebx
  801143:	89 d6                	mov    %edx,%esi
  801145:	c1 e6 18             	shl    $0x18,%esi
  801148:	89 d0                	mov    %edx,%eax
  80114a:	c1 e0 10             	shl    $0x10,%eax
  80114d:	09 f0                	or     %esi,%eax
  80114f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  801151:	09 d8                	or     %ebx,%eax
  801153:	c1 e9 02             	shr    $0x2,%ecx
  801156:	fc                   	cld    
  801157:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801159:	eb 03                	jmp    80115e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80115b:	fc                   	cld    
  80115c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80115e:	89 f8                	mov    %edi,%eax
  801160:	8b 1c 24             	mov    (%esp),%ebx
  801163:	8b 74 24 04          	mov    0x4(%esp),%esi
  801167:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80116b:	89 ec                	mov    %ebp,%esp
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	89 34 24             	mov    %esi,(%esp)
  801178:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  801182:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  801185:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  801187:	39 c6                	cmp    %eax,%esi
  801189:	73 35                	jae    8011c0 <memmove+0x51>
  80118b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80118e:	39 d0                	cmp    %edx,%eax
  801190:	73 2e                	jae    8011c0 <memmove+0x51>
		s += n;
		d += n;
  801192:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801194:	f6 c2 03             	test   $0x3,%dl
  801197:	75 1b                	jne    8011b4 <memmove+0x45>
  801199:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80119f:	75 13                	jne    8011b4 <memmove+0x45>
  8011a1:	f6 c1 03             	test   $0x3,%cl
  8011a4:	75 0e                	jne    8011b4 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8011a6:	83 ef 04             	sub    $0x4,%edi
  8011a9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8011ac:	c1 e9 02             	shr    $0x2,%ecx
  8011af:	fd                   	std    
  8011b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011b2:	eb 09                	jmp    8011bd <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011b4:	83 ef 01             	sub    $0x1,%edi
  8011b7:	8d 72 ff             	lea    -0x1(%edx),%esi
  8011ba:	fd                   	std    
  8011bb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011bd:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011be:	eb 20                	jmp    8011e0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011c0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8011c6:	75 15                	jne    8011dd <memmove+0x6e>
  8011c8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8011ce:	75 0d                	jne    8011dd <memmove+0x6e>
  8011d0:	f6 c1 03             	test   $0x3,%cl
  8011d3:	75 08                	jne    8011dd <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8011d5:	c1 e9 02             	shr    $0x2,%ecx
  8011d8:	fc                   	cld    
  8011d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011db:	eb 03                	jmp    8011e0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8011dd:	fc                   	cld    
  8011de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8011e0:	8b 34 24             	mov    (%esp),%esi
  8011e3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8011e7:	89 ec                	mov    %ebp,%esp
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    

008011eb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	89 04 24             	mov    %eax,(%esp)
  801205:	e8 65 ff ff ff       	call   80116f <memmove>
}
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
  801212:	8b 7d 08             	mov    0x8(%ebp),%edi
  801215:	8b 75 0c             	mov    0xc(%ebp),%esi
  801218:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801220:	eb 1c                	jmp    80123e <memcmp+0x32>
		if (*s1 != *s2)
  801222:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  801226:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  80122a:	83 c2 01             	add    $0x1,%edx
  80122d:	83 e9 01             	sub    $0x1,%ecx
  801230:	38 d8                	cmp    %bl,%al
  801232:	74 0a                	je     80123e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  801234:	0f b6 c0             	movzbl %al,%eax
  801237:	0f b6 db             	movzbl %bl,%ebx
  80123a:	29 d8                	sub    %ebx,%eax
  80123c:	eb 09                	jmp    801247 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80123e:	85 c9                	test   %ecx,%ecx
  801240:	75 e0                	jne    801222 <memcmp+0x16>
  801242:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801255:	89 c2                	mov    %eax,%edx
  801257:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80125a:	eb 07                	jmp    801263 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  80125c:	38 08                	cmp    %cl,(%eax)
  80125e:	74 07                	je     801267 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801260:	83 c0 01             	add    $0x1,%eax
  801263:	39 d0                	cmp    %edx,%eax
  801265:	72 f5                	jb     80125c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    

00801269 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	57                   	push   %edi
  80126d:	56                   	push   %esi
  80126e:	53                   	push   %ebx
  80126f:	83 ec 04             	sub    $0x4,%esp
  801272:	8b 55 08             	mov    0x8(%ebp),%edx
  801275:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801278:	eb 03                	jmp    80127d <strtol+0x14>
		s++;
  80127a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80127d:	0f b6 02             	movzbl (%edx),%eax
  801280:	3c 20                	cmp    $0x20,%al
  801282:	74 f6                	je     80127a <strtol+0x11>
  801284:	3c 09                	cmp    $0x9,%al
  801286:	74 f2                	je     80127a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  801288:	3c 2b                	cmp    $0x2b,%al
  80128a:	75 0c                	jne    801298 <strtol+0x2f>
		s++;
  80128c:	8d 52 01             	lea    0x1(%edx),%edx
  80128f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801296:	eb 15                	jmp    8012ad <strtol+0x44>
	else if (*s == '-')
  801298:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80129f:	3c 2d                	cmp    $0x2d,%al
  8012a1:	75 0a                	jne    8012ad <strtol+0x44>
		s++, neg = 1;
  8012a3:	8d 52 01             	lea    0x1(%edx),%edx
  8012a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012ad:	85 db                	test   %ebx,%ebx
  8012af:	0f 94 c0             	sete   %al
  8012b2:	74 05                	je     8012b9 <strtol+0x50>
  8012b4:	83 fb 10             	cmp    $0x10,%ebx
  8012b7:	75 15                	jne    8012ce <strtol+0x65>
  8012b9:	80 3a 30             	cmpb   $0x30,(%edx)
  8012bc:	75 10                	jne    8012ce <strtol+0x65>
  8012be:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8012c2:	75 0a                	jne    8012ce <strtol+0x65>
		s += 2, base = 16;
  8012c4:	83 c2 02             	add    $0x2,%edx
  8012c7:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012cc:	eb 13                	jmp    8012e1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8012ce:	84 c0                	test   %al,%al
  8012d0:	74 0f                	je     8012e1 <strtol+0x78>
  8012d2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8012d7:	80 3a 30             	cmpb   $0x30,(%edx)
  8012da:	75 05                	jne    8012e1 <strtol+0x78>
		s++, base = 8;
  8012dc:	83 c2 01             	add    $0x1,%edx
  8012df:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e8:	0f b6 0a             	movzbl (%edx),%ecx
  8012eb:	89 cf                	mov    %ecx,%edi
  8012ed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8012f0:	80 fb 09             	cmp    $0x9,%bl
  8012f3:	77 08                	ja     8012fd <strtol+0x94>
			dig = *s - '0';
  8012f5:	0f be c9             	movsbl %cl,%ecx
  8012f8:	83 e9 30             	sub    $0x30,%ecx
  8012fb:	eb 1e                	jmp    80131b <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  8012fd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801300:	80 fb 19             	cmp    $0x19,%bl
  801303:	77 08                	ja     80130d <strtol+0xa4>
			dig = *s - 'a' + 10;
  801305:	0f be c9             	movsbl %cl,%ecx
  801308:	83 e9 57             	sub    $0x57,%ecx
  80130b:	eb 0e                	jmp    80131b <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  80130d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801310:	80 fb 19             	cmp    $0x19,%bl
  801313:	77 15                	ja     80132a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801315:	0f be c9             	movsbl %cl,%ecx
  801318:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80131b:	39 f1                	cmp    %esi,%ecx
  80131d:	7d 0b                	jge    80132a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80131f:	83 c2 01             	add    $0x1,%edx
  801322:	0f af c6             	imul   %esi,%eax
  801325:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801328:	eb be                	jmp    8012e8 <strtol+0x7f>
  80132a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80132c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801330:	74 05                	je     801337 <strtol+0xce>
		*endptr = (char *) s;
  801332:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801335:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801337:	89 ca                	mov    %ecx,%edx
  801339:	f7 da                	neg    %edx
  80133b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133f:	0f 45 c2             	cmovne %edx,%eax
}
  801342:	83 c4 04             	add    $0x4,%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    
	...

0080134c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 0c             	sub    $0xc,%esp
  801352:	89 1c 24             	mov    %ebx,(%esp)
  801355:	89 74 24 04          	mov    %esi,0x4(%esp)
  801359:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80135d:	ba 00 00 00 00       	mov    $0x0,%edx
  801362:	b8 01 00 00 00       	mov    $0x1,%eax
  801367:	89 d1                	mov    %edx,%ecx
  801369:	89 d3                	mov    %edx,%ebx
  80136b:	89 d7                	mov    %edx,%edi
  80136d:	89 d6                	mov    %edx,%esi
  80136f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801371:	8b 1c 24             	mov    (%esp),%ebx
  801374:	8b 74 24 04          	mov    0x4(%esp),%esi
  801378:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80137c:	89 ec                	mov    %ebp,%esp
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 0c             	sub    $0xc,%esp
  801386:	89 1c 24             	mov    %ebx,(%esp)
  801389:	89 74 24 04          	mov    %esi,0x4(%esp)
  80138d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801391:	b8 00 00 00 00       	mov    $0x0,%eax
  801396:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
  80139c:	89 c3                	mov    %eax,%ebx
  80139e:	89 c7                	mov    %eax,%edi
  8013a0:	89 c6                	mov    %eax,%esi
  8013a2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8013a4:	8b 1c 24             	mov    (%esp),%ebx
  8013a7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013ab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013af:	89 ec                	mov    %ebp,%esp
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	89 1c 24             	mov    %ebx,(%esp)
  8013bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c9:	b8 10 00 00 00       	mov    $0x10,%eax
  8013ce:	89 d1                	mov    %edx,%ecx
  8013d0:	89 d3                	mov    %edx,%ebx
  8013d2:	89 d7                	mov    %edx,%edi
  8013d4:	89 d6                	mov    %edx,%esi
  8013d6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013d8:	8b 1c 24             	mov    (%esp),%ebx
  8013db:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013df:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013e3:	89 ec                	mov    %ebp,%esp
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 38             	sub    $0x38,%esp
  8013ed:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013f0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013f3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fb:	b8 0f 00 00 00       	mov    $0xf,%eax
  801400:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801403:	8b 55 08             	mov    0x8(%ebp),%edx
  801406:	89 df                	mov    %ebx,%edi
  801408:	89 de                	mov    %ebx,%esi
  80140a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80140c:	85 c0                	test   %eax,%eax
  80140e:	7e 28                	jle    801438 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801410:	89 44 24 10          	mov    %eax,0x10(%esp)
  801414:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80141b:	00 
  80141c:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  801423:	00 
  801424:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80142b:	00 
  80142c:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  801433:	e8 6c f4 ff ff       	call   8008a4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  801438:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80143b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80143e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801441:	89 ec                	mov    %ebp,%esp
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
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
  801454:	bb 00 00 00 00       	mov    $0x0,%ebx
  801459:	b8 0e 00 00 00       	mov    $0xe,%eax
  80145e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801461:	8b 55 08             	mov    0x8(%ebp),%edx
  801464:	89 df                	mov    %ebx,%edi
  801466:	89 de                	mov    %ebx,%esi
  801468:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80146a:	85 c0                	test   %eax,%eax
  80146c:	7e 28                	jle    801496 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80146e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801472:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801479:	00 
  80147a:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  801481:	00 
  801482:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801489:	00 
  80148a:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  801491:	e8 0e f4 ff ff       	call   8008a4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  801496:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801499:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80149c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80149f:	89 ec                	mov    %ebp,%esp
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 38             	sub    $0x38,%esp
  8014a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014af:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014b7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bf:	89 cb                	mov    %ecx,%ebx
  8014c1:	89 cf                	mov    %ecx,%edi
  8014c3:	89 ce                	mov    %ecx,%esi
  8014c5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	7e 28                	jle    8014f3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014cf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8014d6:	00 
  8014d7:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  8014de:	00 
  8014df:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014e6:	00 
  8014e7:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  8014ee:	e8 b1 f3 ff ff       	call   8008a4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014f3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014f6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014f9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014fc:	89 ec                	mov    %ebp,%esp
  8014fe:	5d                   	pop    %ebp
  8014ff:	c3                   	ret    

00801500 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 0c             	sub    $0xc,%esp
  801506:	89 1c 24             	mov    %ebx,(%esp)
  801509:	89 74 24 04          	mov    %esi,0x4(%esp)
  80150d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801511:	be 00 00 00 00       	mov    $0x0,%esi
  801516:	b8 0c 00 00 00       	mov    $0xc,%eax
  80151b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80151e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801524:	8b 55 08             	mov    0x8(%ebp),%edx
  801527:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801529:	8b 1c 24             	mov    (%esp),%ebx
  80152c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801530:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801534:	89 ec                	mov    %ebp,%esp
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 38             	sub    $0x38,%esp
  80153e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801541:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801544:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801547:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801551:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801554:	8b 55 08             	mov    0x8(%ebp),%edx
  801557:	89 df                	mov    %ebx,%edi
  801559:	89 de                	mov    %ebx,%esi
  80155b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80155d:	85 c0                	test   %eax,%eax
  80155f:	7e 28                	jle    801589 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801561:	89 44 24 10          	mov    %eax,0x10(%esp)
  801565:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80156c:	00 
  80156d:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  801574:	00 
  801575:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80157c:	00 
  80157d:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  801584:	e8 1b f3 ff ff       	call   8008a4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801589:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80158c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80158f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801592:	89 ec                	mov    %ebp,%esp
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 38             	sub    $0x38,%esp
  80159c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80159f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015aa:	b8 09 00 00 00       	mov    $0x9,%eax
  8015af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b5:	89 df                	mov    %ebx,%edi
  8015b7:	89 de                	mov    %ebx,%esi
  8015b9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	7e 28                	jle    8015e7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015c3:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8015ca:	00 
  8015cb:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  8015d2:	00 
  8015d3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015da:	00 
  8015db:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  8015e2:	e8 bd f2 ff ff       	call   8008a4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8015e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015ea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015ed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015f0:	89 ec                	mov    %ebp,%esp
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    

008015f4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 38             	sub    $0x38,%esp
  8015fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801600:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801603:	bb 00 00 00 00       	mov    $0x0,%ebx
  801608:	b8 08 00 00 00       	mov    $0x8,%eax
  80160d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801610:	8b 55 08             	mov    0x8(%ebp),%edx
  801613:	89 df                	mov    %ebx,%edi
  801615:	89 de                	mov    %ebx,%esi
  801617:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801619:	85 c0                	test   %eax,%eax
  80161b:	7e 28                	jle    801645 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80161d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801621:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801628:	00 
  801629:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  801630:	00 
  801631:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801638:	00 
  801639:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  801640:	e8 5f f2 ff ff       	call   8008a4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801645:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801648:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80164b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80164e:	89 ec                	mov    %ebp,%esp
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 38             	sub    $0x38,%esp
  801658:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80165b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80165e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801661:	bb 00 00 00 00       	mov    $0x0,%ebx
  801666:	b8 06 00 00 00       	mov    $0x6,%eax
  80166b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166e:	8b 55 08             	mov    0x8(%ebp),%edx
  801671:	89 df                	mov    %ebx,%edi
  801673:	89 de                	mov    %ebx,%esi
  801675:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801677:	85 c0                	test   %eax,%eax
  801679:	7e 28                	jle    8016a3 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80167b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80167f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801686:	00 
  801687:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  80168e:	00 
  80168f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801696:	00 
  801697:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  80169e:	e8 01 f2 ff ff       	call   8008a4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016a3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016a6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016a9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016ac:	89 ec                	mov    %ebp,%esp
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 38             	sub    $0x38,%esp
  8016b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8016c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	7e 28                	jle    801701 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016dd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8016e4:	00 
  8016e5:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  8016ec:	00 
  8016ed:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016f4:	00 
  8016f5:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  8016fc:	e8 a3 f1 ff ff       	call   8008a4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801701:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801704:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801707:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80170a:	89 ec                	mov    %ebp,%esp
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 38             	sub    $0x38,%esp
  801714:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801717:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80171a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171d:	be 00 00 00 00       	mov    $0x0,%esi
  801722:	b8 04 00 00 00       	mov    $0x4,%eax
  801727:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80172a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172d:	8b 55 08             	mov    0x8(%ebp),%edx
  801730:	89 f7                	mov    %esi,%edi
  801732:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801734:	85 c0                	test   %eax,%eax
  801736:	7e 28                	jle    801760 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801738:	89 44 24 10          	mov    %eax,0x10(%esp)
  80173c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801743:	00 
  801744:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  80174b:	00 
  80174c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801753:	00 
  801754:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  80175b:	e8 44 f1 ff ff       	call   8008a4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801760:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801763:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801766:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801769:	89 ec                	mov    %ebp,%esp
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	89 1c 24             	mov    %ebx,(%esp)
  801776:	89 74 24 04          	mov    %esi,0x4(%esp)
  80177a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177e:	ba 00 00 00 00       	mov    $0x0,%edx
  801783:	b8 0b 00 00 00       	mov    $0xb,%eax
  801788:	89 d1                	mov    %edx,%ecx
  80178a:	89 d3                	mov    %edx,%ebx
  80178c:	89 d7                	mov    %edx,%edi
  80178e:	89 d6                	mov    %edx,%esi
  801790:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801792:	8b 1c 24             	mov    (%esp),%ebx
  801795:	8b 74 24 04          	mov    0x4(%esp),%esi
  801799:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80179d:	89 ec                	mov    %ebp,%esp
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    

008017a1 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	89 1c 24             	mov    %ebx,(%esp)
  8017aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017bc:	89 d1                	mov    %edx,%ecx
  8017be:	89 d3                	mov    %edx,%ebx
  8017c0:	89 d7                	mov    %edx,%edi
  8017c2:	89 d6                	mov    %edx,%esi
  8017c4:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8017c6:	8b 1c 24             	mov    (%esp),%ebx
  8017c9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8017cd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8017d1:	89 ec                	mov    %ebp,%esp
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    

008017d5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 38             	sub    $0x38,%esp
  8017db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f1:	89 cb                	mov    %ecx,%ebx
  8017f3:	89 cf                	mov    %ecx,%edi
  8017f5:	89 ce                	mov    %ecx,%esi
  8017f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	7e 28                	jle    801825 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801801:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801808:	00 
  801809:	c7 44 24 08 67 37 80 	movl   $0x803767,0x8(%esp)
  801810:	00 
  801811:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801818:	00 
  801819:	c7 04 24 84 37 80 00 	movl   $0x803784,(%esp)
  801820:	e8 7f f0 ff ff       	call   8008a4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801825:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801828:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80182b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80182e:	89 ec                	mov    %ebp,%esp
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    
	...

00801834 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	05 00 00 00 30       	add    $0x30000000,%eax
  80183f:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	89 04 24             	mov    %eax,(%esp)
  801850:	e8 df ff ff ff       	call   801834 <fd2num>
  801855:	05 20 00 0d 00       	add    $0xd0020,%eax
  80185a:	c1 e0 0c             	shl    $0xc,%eax
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	57                   	push   %edi
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	8b 7d 08             	mov    0x8(%ebp),%edi
  801868:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80186d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801872:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801877:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801879:	89 c2                	mov    %eax,%edx
  80187b:	c1 ea 16             	shr    $0x16,%edx
  80187e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801881:	f6 c2 01             	test   $0x1,%dl
  801884:	74 0d                	je     801893 <fd_alloc+0x34>
  801886:	89 c2                	mov    %eax,%edx
  801888:	c1 ea 0c             	shr    $0xc,%edx
  80188b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  80188e:	f6 c2 01             	test   $0x1,%dl
  801891:	75 09                	jne    80189c <fd_alloc+0x3d>
			*fd_store = fd;
  801893:	89 37                	mov    %esi,(%edi)
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80189a:	eb 17                	jmp    8018b3 <fd_alloc+0x54>
  80189c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8018a1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018a6:	75 cf                	jne    801877 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018a8:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8018ae:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5f                   	pop    %edi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    

008018b8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	83 f8 1f             	cmp    $0x1f,%eax
  8018c1:	77 36                	ja     8018f9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018c3:	05 00 00 0d 00       	add    $0xd0000,%eax
  8018c8:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018cb:	89 c2                	mov    %eax,%edx
  8018cd:	c1 ea 16             	shr    $0x16,%edx
  8018d0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018d7:	f6 c2 01             	test   $0x1,%dl
  8018da:	74 1d                	je     8018f9 <fd_lookup+0x41>
  8018dc:	89 c2                	mov    %eax,%edx
  8018de:	c1 ea 0c             	shr    $0xc,%edx
  8018e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018e8:	f6 c2 01             	test   $0x1,%dl
  8018eb:	74 0c                	je     8018f9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	89 02                	mov    %eax,(%edx)
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8018f7:	eb 05                	jmp    8018fe <fd_lookup+0x46>
  8018f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801906:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	89 04 24             	mov    %eax,(%esp)
  801913:	e8 a0 ff ff ff       	call   8018b8 <fd_lookup>
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 0e                	js     80192a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	89 50 04             	mov    %edx,0x4(%eax)
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	83 ec 10             	sub    $0x10,%esp
  801934:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801937:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80193a:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80193f:	be 10 38 80 00       	mov    $0x803810,%esi
  801944:	eb 10                	jmp    801956 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  801946:	39 08                	cmp    %ecx,(%eax)
  801948:	75 09                	jne    801953 <dev_lookup+0x27>
			*dev = devtab[i];
  80194a:	89 03                	mov    %eax,(%ebx)
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801951:	eb 31                	jmp    801984 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801953:	83 c2 01             	add    $0x1,%edx
  801956:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801959:	85 c0                	test   %eax,%eax
  80195b:	75 e9                	jne    801946 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80195d:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801962:	8b 40 48             	mov    0x48(%eax),%eax
  801965:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196d:	c7 04 24 94 37 80 00 	movl   $0x803794,(%esp)
  801974:	e8 e4 ef ff ff       	call   80095d <cprintf>
	*dev = 0;
  801979:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80197f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	83 ec 24             	sub    $0x24,%esp
  801992:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801995:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 11 ff ff ff       	call   8018b8 <fd_lookup>
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	78 53                	js     8019fe <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	89 04 24             	mov    %eax,(%esp)
  8019ba:	e8 6d ff ff ff       	call   80192c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 3b                	js     8019fe <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8019c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cb:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8019cf:	74 2d                	je     8019fe <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019d1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019d4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019db:	00 00 00 
	stat->st_isdir = 0;
  8019de:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e5:	00 00 00 
	stat->st_dev = dev;
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f8:	89 14 24             	mov    %edx,(%esp)
  8019fb:	ff 50 14             	call   *0x14(%eax)
}
  8019fe:	83 c4 24             	add    $0x24,%esp
  801a01:	5b                   	pop    %ebx
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    

00801a04 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	53                   	push   %ebx
  801a08:	83 ec 24             	sub    $0x24,%esp
  801a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a15:	89 1c 24             	mov    %ebx,(%esp)
  801a18:	e8 9b fe ff ff       	call   8018b8 <fd_lookup>
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 5f                	js     801a80 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	89 04 24             	mov    %eax,(%esp)
  801a30:	e8 f7 fe ff ff       	call   80192c <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 47                	js     801a80 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3c:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a40:	75 23                	jne    801a65 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a42:	a1 1c 50 80 00       	mov    0x80501c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a47:	8b 40 48             	mov    0x48(%eax),%eax
  801a4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a52:	c7 04 24 b4 37 80 00 	movl   $0x8037b4,(%esp)
  801a59:	e8 ff ee ff ff       	call   80095d <cprintf>
  801a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a63:	eb 1b                	jmp    801a80 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a68:	8b 48 18             	mov    0x18(%eax),%ecx
  801a6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a70:	85 c9                	test   %ecx,%ecx
  801a72:	74 0c                	je     801a80 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7b:	89 14 24             	mov    %edx,(%esp)
  801a7e:	ff d1                	call   *%ecx
}
  801a80:	83 c4 24             	add    $0x24,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    

00801a86 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 24             	sub    $0x24,%esp
  801a8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a90:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a97:	89 1c 24             	mov    %ebx,(%esp)
  801a9a:	e8 19 fe ff ff       	call   8018b8 <fd_lookup>
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 66                	js     801b09 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aad:	8b 00                	mov    (%eax),%eax
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 75 fe ff ff       	call   80192c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 4e                	js     801b09 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abe:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801ac2:	75 23                	jne    801ae7 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ac4:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801ac9:	8b 40 48             	mov    0x48(%eax),%eax
  801acc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad4:	c7 04 24 d5 37 80 00 	movl   $0x8037d5,(%esp)
  801adb:	e8 7d ee ff ff       	call   80095d <cprintf>
  801ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801ae5:	eb 22                	jmp    801b09 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aea:	8b 48 0c             	mov    0xc(%eax),%ecx
  801aed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af2:	85 c9                	test   %ecx,%ecx
  801af4:	74 13                	je     801b09 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801af6:	8b 45 10             	mov    0x10(%ebp),%eax
  801af9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b04:	89 14 24             	mov    %edx,(%esp)
  801b07:	ff d1                	call   *%ecx
}
  801b09:	83 c4 24             	add    $0x24,%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    

00801b0f <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	53                   	push   %ebx
  801b13:	83 ec 24             	sub    $0x24,%esp
  801b16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b19:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b20:	89 1c 24             	mov    %ebx,(%esp)
  801b23:	e8 90 fd ff ff       	call   8018b8 <fd_lookup>
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 6b                	js     801b97 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b36:	8b 00                	mov    (%eax),%eax
  801b38:	89 04 24             	mov    %eax,(%esp)
  801b3b:	e8 ec fd ff ff       	call   80192c <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b40:	85 c0                	test   %eax,%eax
  801b42:	78 53                	js     801b97 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b47:	8b 42 08             	mov    0x8(%edx),%eax
  801b4a:	83 e0 03             	and    $0x3,%eax
  801b4d:	83 f8 01             	cmp    $0x1,%eax
  801b50:	75 23                	jne    801b75 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b52:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801b57:	8b 40 48             	mov    0x48(%eax),%eax
  801b5a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b62:	c7 04 24 f2 37 80 00 	movl   $0x8037f2,(%esp)
  801b69:	e8 ef ed ff ff       	call   80095d <cprintf>
  801b6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b73:	eb 22                	jmp    801b97 <read+0x88>
	}
	if (!dev->dev_read)
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	8b 48 08             	mov    0x8(%eax),%ecx
  801b7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b80:	85 c9                	test   %ecx,%ecx
  801b82:	74 13                	je     801b97 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b92:	89 14 24             	mov    %edx,(%esp)
  801b95:	ff d1                	call   *%ecx
}
  801b97:	83 c4 24             	add    $0x24,%esp
  801b9a:	5b                   	pop    %ebx
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    

00801b9d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	57                   	push   %edi
  801ba1:	56                   	push   %esi
  801ba2:	53                   	push   %ebx
  801ba3:	83 ec 1c             	sub    $0x1c,%esp
  801ba6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ba9:	8b 75 10             	mov    0x10(%ebp),%esi
  801bac:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bb1:	eb 21                	jmp    801bd4 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bb3:	89 f2                	mov    %esi,%edx
  801bb5:	29 c2                	sub    %eax,%edx
  801bb7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bbb:	03 45 0c             	add    0xc(%ebp),%eax
  801bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc2:	89 3c 24             	mov    %edi,(%esp)
  801bc5:	e8 45 ff ff ff       	call   801b0f <read>
		if (m < 0)
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 0e                	js     801bdc <readn+0x3f>
			return m;
		if (m == 0)
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	74 08                	je     801bda <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bd2:	01 c3                	add    %eax,%ebx
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	39 f3                	cmp    %esi,%ebx
  801bd8:	72 d9                	jb     801bb3 <readn+0x16>
  801bda:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    

00801be4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 38             	sub    $0x38,%esp
  801bea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bf0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bf3:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bf6:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bfa:	89 3c 24             	mov    %edi,(%esp)
  801bfd:	e8 32 fc ff ff       	call   801834 <fd2num>
  801c02:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801c05:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c09:	89 04 24             	mov    %eax,(%esp)
  801c0c:	e8 a7 fc ff ff       	call   8018b8 <fd_lookup>
  801c11:	89 c3                	mov    %eax,%ebx
  801c13:	85 c0                	test   %eax,%eax
  801c15:	78 05                	js     801c1c <fd_close+0x38>
  801c17:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  801c1a:	74 0e                	je     801c2a <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801c1c:	89 f0                	mov    %esi,%eax
  801c1e:	84 c0                	test   %al,%al
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
  801c25:	0f 44 d8             	cmove  %eax,%ebx
  801c28:	eb 3d                	jmp    801c67 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c2a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c31:	8b 07                	mov    (%edi),%eax
  801c33:	89 04 24             	mov    %eax,(%esp)
  801c36:	e8 f1 fc ff ff       	call   80192c <dev_lookup>
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 16                	js     801c57 <fd_close+0x73>
		if (dev->dev_close)
  801c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c44:	8b 40 10             	mov    0x10(%eax),%eax
  801c47:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	74 07                	je     801c57 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  801c50:	89 3c 24             	mov    %edi,(%esp)
  801c53:	ff d0                	call   *%eax
  801c55:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c57:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c62:	e8 eb f9 ff ff       	call   801652 <sys_page_unmap>
	return r;
}
  801c67:	89 d8                	mov    %ebx,%eax
  801c69:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c6c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c6f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c72:	89 ec                	mov    %ebp,%esp
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	89 04 24             	mov    %eax,(%esp)
  801c89:	e8 2a fc ff ff       	call   8018b8 <fd_lookup>
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 13                	js     801ca5 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801c92:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c99:	00 
  801c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9d:	89 04 24             	mov    %eax,(%esp)
  801ca0:	e8 3f ff ff ff       	call   801be4 <fd_close>
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 18             	sub    $0x18,%esp
  801cad:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cb0:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cba:	00 
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	89 04 24             	mov    %eax,(%esp)
  801cc1:	e8 25 04 00 00       	call   8020eb <open>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 1b                	js     801ce7 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd3:	89 1c 24             	mov    %ebx,(%esp)
  801cd6:	e8 b0 fc ff ff       	call   80198b <fstat>
  801cdb:	89 c6                	mov    %eax,%esi
	close(fd);
  801cdd:	89 1c 24             	mov    %ebx,(%esp)
  801ce0:	e8 91 ff ff ff       	call   801c76 <close>
  801ce5:	89 f3                	mov    %esi,%ebx
	return r;
}
  801ce7:	89 d8                	mov    %ebx,%eax
  801ce9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cec:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801cef:	89 ec                	mov    %ebp,%esp
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 14             	sub    $0x14,%esp
  801cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801cff:	89 1c 24             	mov    %ebx,(%esp)
  801d02:	e8 6f ff ff ff       	call   801c76 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d07:	83 c3 01             	add    $0x1,%ebx
  801d0a:	83 fb 20             	cmp    $0x20,%ebx
  801d0d:	75 f0                	jne    801cff <close_all+0xc>
		close(i);
}
  801d0f:	83 c4 14             	add    $0x14,%esp
  801d12:	5b                   	pop    %ebx
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    

00801d15 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 58             	sub    $0x58,%esp
  801d1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d21:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d24:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d27:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	89 04 24             	mov    %eax,(%esp)
  801d34:	e8 7f fb ff ff       	call   8018b8 <fd_lookup>
  801d39:	89 c3                	mov    %eax,%ebx
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	0f 88 e0 00 00 00    	js     801e23 <dup+0x10e>
		return r;
	close(newfdnum);
  801d43:	89 3c 24             	mov    %edi,(%esp)
  801d46:	e8 2b ff ff ff       	call   801c76 <close>

	newfd = INDEX2FD(newfdnum);
  801d4b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801d51:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d57:	89 04 24             	mov    %eax,(%esp)
  801d5a:	e8 e5 fa ff ff       	call   801844 <fd2data>
  801d5f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801d61:	89 34 24             	mov    %esi,(%esp)
  801d64:	e8 db fa ff ff       	call   801844 <fd2data>
  801d69:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801d6c:	89 da                	mov    %ebx,%edx
  801d6e:	89 d8                	mov    %ebx,%eax
  801d70:	c1 e8 16             	shr    $0x16,%eax
  801d73:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d7a:	a8 01                	test   $0x1,%al
  801d7c:	74 43                	je     801dc1 <dup+0xac>
  801d7e:	c1 ea 0c             	shr    $0xc,%edx
  801d81:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d88:	a8 01                	test   $0x1,%al
  801d8a:	74 35                	je     801dc1 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801d8c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d93:	25 07 0e 00 00       	and    $0xe07,%eax
  801d98:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801da3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801daa:	00 
  801dab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801daf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db6:	e8 f5 f8 ff ff       	call   8016b0 <sys_page_map>
  801dbb:	89 c3                	mov    %eax,%ebx
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 3f                	js     801e00 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dc4:	89 c2                	mov    %eax,%edx
  801dc6:	c1 ea 0c             	shr    $0xc,%edx
  801dc9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801dd0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801dd6:	89 54 24 10          	mov    %edx,0x10(%esp)
  801dda:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dde:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801de5:	00 
  801de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df1:	e8 ba f8 ff ff       	call   8016b0 <sys_page_map>
  801df6:	89 c3                	mov    %eax,%ebx
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 04                	js     801e00 <dup+0xeb>
  801dfc:	89 fb                	mov    %edi,%ebx
  801dfe:	eb 23                	jmp    801e23 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801e00:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e0b:	e8 42 f8 ff ff       	call   801652 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801e10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e1e:	e8 2f f8 ff ff       	call   801652 <sys_page_unmap>
	return r;
}
  801e23:	89 d8                	mov    %ebx,%eax
  801e25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e28:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e2b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e2e:	89 ec                	mov    %ebp,%esp
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    
	...

00801e34 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
  801e39:	83 ec 10             	sub    $0x10,%esp
  801e3c:	89 c3                	mov    %eax,%ebx
  801e3e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801e40:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801e47:	75 11                	jne    801e5a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e50:	e8 0f 10 00 00       	call   802e64 <ipc_find_env>
  801e55:	a3 10 50 80 00       	mov    %eax,0x805010

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801e5a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801e5f:	8b 40 48             	mov    0x48(%eax),%eax
  801e62:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801e68:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e74:	c7 04 24 24 38 80 00 	movl   $0x803824,(%esp)
  801e7b:	e8 dd ea ff ff       	call   80095d <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e80:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e87:	00 
  801e88:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e8f:	00 
  801e90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e94:	a1 10 50 80 00       	mov    0x805010,%eax
  801e99:	89 04 24             	mov    %eax,(%esp)
  801e9c:	e8 f9 0f 00 00       	call   802e9a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ea1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ea8:	00 
  801ea9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ead:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb4:	e8 4d 10 00 00       	call   802f06 <ipc_recv>
}
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ed9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ede:	b8 02 00 00 00       	mov    $0x2,%eax
  801ee3:	e8 4c ff ff ff       	call   801e34 <fsipc>
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801efb:	ba 00 00 00 00       	mov    $0x0,%edx
  801f00:	b8 06 00 00 00       	mov    $0x6,%eax
  801f05:	e8 2a ff ff ff       	call   801e34 <fsipc>
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
  801f17:	b8 08 00 00 00       	mov    $0x8,%eax
  801f1c:	e8 13 ff ff ff       	call   801e34 <fsipc>
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	53                   	push   %ebx
  801f27:	83 ec 14             	sub    $0x14,%esp
  801f2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	8b 40 0c             	mov    0xc(%eax),%eax
  801f33:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f38:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3d:	b8 05 00 00 00       	mov    $0x5,%eax
  801f42:	e8 ed fe ff ff       	call   801e34 <fsipc>
  801f47:	85 c0                	test   %eax,%eax
  801f49:	78 2b                	js     801f76 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f4b:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f52:	00 
  801f53:	89 1c 24             	mov    %ebx,(%esp)
  801f56:	e8 6e f0 ff ff       	call   800fc9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f5b:	a1 80 60 80 00       	mov    0x806080,%eax
  801f60:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f66:	a1 84 60 80 00       	mov    0x806084,%eax
  801f6b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801f76:	83 c4 14             	add    $0x14,%esp
  801f79:	5b                   	pop    %ebx
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    

00801f7c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	53                   	push   %ebx
  801f80:	83 ec 14             	sub    $0x14,%esp
  801f83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801f91:	89 1d 04 60 80 00    	mov    %ebx,0x806004

	assert(n<=PGSIZE);
  801f97:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801f9d:	76 24                	jbe    801fc3 <devfile_write+0x47>
  801f9f:	c7 44 24 0c 3a 38 80 	movl   $0x80383a,0xc(%esp)
  801fa6:	00 
  801fa7:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  801fae:	00 
  801faf:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801fb6:	00 
  801fb7:	c7 04 24 59 38 80 00 	movl   $0x803859,(%esp)
  801fbe:	e8 e1 e8 ff ff       	call   8008a4 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801fc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fce:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801fd5:	e8 95 f1 ff ff       	call   80116f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  801fda:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdf:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe4:	e8 4b fe ff ff       	call   801e34 <fsipc>
	if(ret<0) return ret;
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 53                	js     802040 <devfile_write+0xc4>
	
	assert(ret <= n);
  801fed:	39 c3                	cmp    %eax,%ebx
  801fef:	73 24                	jae    802015 <devfile_write+0x99>
  801ff1:	c7 44 24 0c 64 38 80 	movl   $0x803864,0xc(%esp)
  801ff8:	00 
  801ff9:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  802000:	00 
  802001:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  802008:	00 
  802009:	c7 04 24 59 38 80 00 	movl   $0x803859,(%esp)
  802010:	e8 8f e8 ff ff       	call   8008a4 <_panic>
	assert(ret <= PGSIZE);
  802015:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80201a:	7e 24                	jle    802040 <devfile_write+0xc4>
  80201c:	c7 44 24 0c 6d 38 80 	movl   $0x80386d,0xc(%esp)
  802023:	00 
  802024:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  80202b:	00 
  80202c:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  802033:	00 
  802034:	c7 04 24 59 38 80 00 	movl   $0x803859,(%esp)
  80203b:	e8 64 e8 ff ff       	call   8008a4 <_panic>
	return ret;
}
  802040:	83 c4 14             	add    $0x14,%esp
  802043:	5b                   	pop    %ebx
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    

00802046 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	56                   	push   %esi
  80204a:	53                   	push   %ebx
  80204b:	83 ec 10             	sub    $0x10,%esp
  80204e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	8b 40 0c             	mov    0xc(%eax),%eax
  802057:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80205c:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802062:	ba 00 00 00 00       	mov    $0x0,%edx
  802067:	b8 03 00 00 00       	mov    $0x3,%eax
  80206c:	e8 c3 fd ff ff       	call   801e34 <fsipc>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	85 c0                	test   %eax,%eax
  802075:	78 6b                	js     8020e2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  802077:	39 de                	cmp    %ebx,%esi
  802079:	73 24                	jae    80209f <devfile_read+0x59>
  80207b:	c7 44 24 0c 7b 38 80 	movl   $0x80387b,0xc(%esp)
  802082:	00 
  802083:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  80208a:	00 
  80208b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  802092:	00 
  802093:	c7 04 24 59 38 80 00 	movl   $0x803859,(%esp)
  80209a:	e8 05 e8 ff ff       	call   8008a4 <_panic>
	assert(r <= PGSIZE);
  80209f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8020a5:	7e 24                	jle    8020cb <devfile_read+0x85>
  8020a7:	c7 44 24 0c 82 38 80 	movl   $0x803882,0xc(%esp)
  8020ae:	00 
  8020af:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  8020b6:	00 
  8020b7:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8020be:	00 
  8020bf:	c7 04 24 59 38 80 00 	movl   $0x803859,(%esp)
  8020c6:	e8 d9 e7 ff ff       	call   8008a4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020cf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8020d6:	00 
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	89 04 24             	mov    %eax,(%esp)
  8020dd:	e8 8d f0 ff ff       	call   80116f <memmove>
	return r;
}
  8020e2:	89 d8                	mov    %ebx,%eax
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    

008020eb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 28             	sub    $0x28,%esp
  8020f1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020f4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8020f7:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8020fa:	89 34 24             	mov    %esi,(%esp)
  8020fd:	e8 8e ee ff ff       	call   800f90 <strlen>
  802102:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802107:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80210c:	7f 5e                	jg     80216c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80210e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802111:	89 04 24             	mov    %eax,(%esp)
  802114:	e8 46 f7 ff ff       	call   80185f <fd_alloc>
  802119:	89 c3                	mov    %eax,%ebx
  80211b:	85 c0                	test   %eax,%eax
  80211d:	78 4d                	js     80216c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80211f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802123:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80212a:	e8 9a ee ff ff       	call   800fc9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80212f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802132:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213a:	b8 01 00 00 00       	mov    $0x1,%eax
  80213f:	e8 f0 fc ff ff       	call   801e34 <fsipc>
  802144:	89 c3                	mov    %eax,%ebx
  802146:	85 c0                	test   %eax,%eax
  802148:	79 15                	jns    80215f <open+0x74>
		fd_close(fd, 0);
  80214a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802151:	00 
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	89 04 24             	mov    %eax,(%esp)
  802158:	e8 87 fa ff ff       	call   801be4 <fd_close>
		return r;
  80215d:	eb 0d                	jmp    80216c <open+0x81>
	}

	return fd2num(fd);
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	89 04 24             	mov    %eax,(%esp)
  802165:	e8 ca f6 ff ff       	call   801834 <fd2num>
  80216a:	89 c3                	mov    %eax,%ebx
}
  80216c:	89 d8                	mov    %ebx,%eax
  80216e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802171:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802174:	89 ec                	mov    %ebp,%esp
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    
	...

00802180 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802186:	c7 44 24 04 8e 38 80 	movl   $0x80388e,0x4(%esp)
  80218d:	00 
  80218e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 30 ee ff ff       	call   800fc9 <strcpy>
	return 0;
}
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 14             	sub    $0x14,%esp
  8021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8021aa:	89 1c 24             	mov    %ebx,(%esp)
  8021ad:	e8 de 0d 00 00       	call   802f90 <pageref>
  8021b2:	89 c2                	mov    %eax,%edx
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	83 fa 01             	cmp    $0x1,%edx
  8021bc:	75 0b                	jne    8021c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8021be:	8b 43 0c             	mov    0xc(%ebx),%eax
  8021c1:	89 04 24             	mov    %eax,(%esp)
  8021c4:	e8 b1 02 00 00       	call   80247a <nsipc_close>
	else
		return 0;
}
  8021c9:	83 c4 14             	add    $0x14,%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    

008021cf <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021dc:	00 
  8021dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 bd 02 00 00       	call   8024b6 <nsipc_send>
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802201:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802208:	00 
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 40 0c             	mov    0xc(%eax),%eax
  80221d:	89 04 24             	mov    %eax,(%esp)
  802220:	e8 04 03 00 00       	call   802529 <nsipc_recv>
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 20             	sub    $0x20,%esp
  80222f:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802231:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802234:	89 04 24             	mov    %eax,(%esp)
  802237:	e8 23 f6 ff ff       	call   80185f <fd_alloc>
  80223c:	89 c3                	mov    %eax,%ebx
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 21                	js     802263 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802242:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802249:	00 
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 b1 f4 ff ff       	call   80170e <sys_page_alloc>
  80225d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80225f:	85 c0                	test   %eax,%eax
  802261:	79 0a                	jns    80226d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  802263:	89 34 24             	mov    %esi,(%esp)
  802266:	e8 0f 02 00 00       	call   80247a <nsipc_close>
		return r;
  80226b:	eb 28                	jmp    802295 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80226d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	89 04 24             	mov    %eax,(%esp)
  80228e:	e8 a1 f5 ff ff       	call   801834 <fd2num>
  802293:	89 c3                	mov    %eax,%ebx
}
  802295:	89 d8                	mov    %ebx,%eax
  802297:	83 c4 20             	add    $0x20,%esp
  80229a:	5b                   	pop    %ebx
  80229b:	5e                   	pop    %esi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    

0080229e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	89 04 24             	mov    %eax,(%esp)
  8022b8:	e8 71 01 00 00       	call   80242e <nsipc_socket>
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	78 05                	js     8022c6 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8022c1:	e8 61 ff ff ff       	call   802227 <alloc_sockfd>
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8022ce:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8022d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022d5:	89 04 24             	mov    %eax,(%esp)
  8022d8:	e8 db f5 ff ff       	call   8018b8 <fd_lookup>
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	78 15                	js     8022f6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	8b 0a                	mov    (%edx),%ecx
  8022e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022eb:	3b 0d 40 40 80 00    	cmp    0x804040,%ecx
  8022f1:	75 03                	jne    8022f6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8022f3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	e8 c2 ff ff ff       	call   8022c8 <fd2sockid>
  802306:	85 c0                	test   %eax,%eax
  802308:	78 0f                	js     802319 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802311:	89 04 24             	mov    %eax,(%esp)
  802314:	e8 3f 01 00 00       	call   802458 <nsipc_listen>
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	e8 9f ff ff ff       	call   8022c8 <fd2sockid>
  802329:	85 c0                	test   %eax,%eax
  80232b:	78 16                	js     802343 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  80232d:	8b 55 10             	mov    0x10(%ebp),%edx
  802330:	89 54 24 08          	mov    %edx,0x8(%esp)
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	89 54 24 04          	mov    %edx,0x4(%esp)
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 66 02 00 00       	call   8025a9 <nsipc_connect>
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	e8 75 ff ff ff       	call   8022c8 <fd2sockid>
  802353:	85 c0                	test   %eax,%eax
  802355:	78 0f                	js     802366 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80235e:	89 04 24             	mov    %eax,(%esp)
  802361:	e8 2e 01 00 00       	call   802494 <nsipc_shutdown>
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	e8 52 ff ff ff       	call   8022c8 <fd2sockid>
  802376:	85 c0                	test   %eax,%eax
  802378:	78 16                	js     802390 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80237a:	8b 55 10             	mov    0x10(%ebp),%edx
  80237d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	89 54 24 04          	mov    %edx,0x4(%esp)
  802388:	89 04 24             	mov    %eax,(%esp)
  80238b:	e8 58 02 00 00       	call   8025e8 <nsipc_bind>
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	e8 28 ff ff ff       	call   8022c8 <fd2sockid>
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	78 1f                	js     8023c3 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023a4:	8b 55 10             	mov    0x10(%ebp),%edx
  8023a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023b2:	89 04 24             	mov    %eax,(%esp)
  8023b5:	e8 6d 02 00 00       	call   802627 <nsipc_accept>
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	78 05                	js     8023c3 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8023be:	e8 64 fe ff ff       	call   802227 <alloc_sockfd>
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    
  8023c5:	00 00                	add    %al,(%eax)
	...

008023c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	53                   	push   %ebx
  8023cc:	83 ec 14             	sub    $0x14,%esp
  8023cf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8023d1:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  8023d8:	75 11                	jne    8023eb <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8023da:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8023e1:	e8 7e 0a 00 00       	call   802e64 <ipc_find_env>
  8023e6:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023eb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023f2:	00 
  8023f3:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8023fa:	00 
  8023fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023ff:	a1 14 50 80 00       	mov    0x805014,%eax
  802404:	89 04 24             	mov    %eax,(%esp)
  802407:	e8 8e 0a 00 00       	call   802e9a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80240c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802413:	00 
  802414:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80241b:	00 
  80241c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802423:	e8 de 0a 00 00       	call   802f06 <ipc_recv>
}
  802428:	83 c4 14             	add    $0x14,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802444:	8b 45 10             	mov    0x10(%ebp),%eax
  802447:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80244c:	b8 09 00 00 00       	mov    $0x9,%eax
  802451:	e8 72 ff ff ff       	call   8023c8 <nsipc>
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802466:	8b 45 0c             	mov    0xc(%ebp),%eax
  802469:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80246e:	b8 06 00 00 00       	mov    $0x6,%eax
  802473:	e8 50 ff ff ff       	call   8023c8 <nsipc>
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802488:	b8 04 00 00 00       	mov    $0x4,%eax
  80248d:	e8 36 ff ff ff       	call   8023c8 <nsipc>
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8024a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a5:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8024aa:	b8 03 00 00 00       	mov    $0x3,%eax
  8024af:	e8 14 ff ff ff       	call   8023c8 <nsipc>
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	53                   	push   %ebx
  8024ba:	83 ec 14             	sub    $0x14,%esp
  8024bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8024c8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024ce:	7e 24                	jle    8024f4 <nsipc_send+0x3e>
  8024d0:	c7 44 24 0c 9a 38 80 	movl   $0x80389a,0xc(%esp)
  8024d7:	00 
  8024d8:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  8024df:	00 
  8024e0:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8024e7:	00 
  8024e8:	c7 04 24 a6 38 80 00 	movl   $0x8038a6,(%esp)
  8024ef:	e8 b0 e3 ff ff       	call   8008a4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ff:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802506:	e8 64 ec ff ff       	call   80116f <memmove>
	nsipcbuf.send.req_size = size;
  80250b:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802511:	8b 45 14             	mov    0x14(%ebp),%eax
  802514:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802519:	b8 08 00 00 00       	mov    $0x8,%eax
  80251e:	e8 a5 fe ff ff       	call   8023c8 <nsipc>
}
  802523:	83 c4 14             	add    $0x14,%esp
  802526:	5b                   	pop    %ebx
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    

00802529 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	56                   	push   %esi
  80252d:	53                   	push   %ebx
  80252e:	83 ec 10             	sub    $0x10,%esp
  802531:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80253c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802542:	8b 45 14             	mov    0x14(%ebp),%eax
  802545:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80254a:	b8 07 00 00 00       	mov    $0x7,%eax
  80254f:	e8 74 fe ff ff       	call   8023c8 <nsipc>
  802554:	89 c3                	mov    %eax,%ebx
  802556:	85 c0                	test   %eax,%eax
  802558:	78 46                	js     8025a0 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80255a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80255f:	7f 04                	jg     802565 <nsipc_recv+0x3c>
  802561:	39 c6                	cmp    %eax,%esi
  802563:	7d 24                	jge    802589 <nsipc_recv+0x60>
  802565:	c7 44 24 0c b2 38 80 	movl   $0x8038b2,0xc(%esp)
  80256c:	00 
  80256d:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  802574:	00 
  802575:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80257c:	00 
  80257d:	c7 04 24 a6 38 80 00 	movl   $0x8038a6,(%esp)
  802584:	e8 1b e3 ff ff       	call   8008a4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802589:	89 44 24 08          	mov    %eax,0x8(%esp)
  80258d:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802594:	00 
  802595:	8b 45 0c             	mov    0xc(%ebp),%eax
  802598:	89 04 24             	mov    %eax,(%esp)
  80259b:	e8 cf eb ff ff       	call   80116f <memmove>
	}

	return r;
}
  8025a0:	89 d8                	mov    %ebx,%eax
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5e                   	pop    %esi
  8025a7:	5d                   	pop    %ebp
  8025a8:	c3                   	ret    

008025a9 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	53                   	push   %ebx
  8025ad:	83 ec 14             	sub    $0x14,%esp
  8025b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8025bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c6:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8025cd:	e8 9d eb ff ff       	call   80116f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8025d2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8025d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8025dd:	e8 e6 fd ff ff       	call   8023c8 <nsipc>
}
  8025e2:	83 c4 14             	add    $0x14,%esp
  8025e5:	5b                   	pop    %ebx
  8025e6:	5d                   	pop    %ebp
  8025e7:	c3                   	ret    

008025e8 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	53                   	push   %ebx
  8025ec:	83 ec 14             	sub    $0x14,%esp
  8025ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802601:	89 44 24 04          	mov    %eax,0x4(%esp)
  802605:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80260c:	e8 5e eb ff ff       	call   80116f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802611:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802617:	b8 02 00 00 00       	mov    $0x2,%eax
  80261c:	e8 a7 fd ff ff       	call   8023c8 <nsipc>
}
  802621:	83 c4 14             	add    $0x14,%esp
  802624:	5b                   	pop    %ebx
  802625:	5d                   	pop    %ebp
  802626:	c3                   	ret    

00802627 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
  80262a:	83 ec 28             	sub    $0x28,%esp
  80262d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802630:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802633:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802636:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802641:	8b 07                	mov    (%edi),%eax
  802643:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802648:	b8 01 00 00 00       	mov    $0x1,%eax
  80264d:	e8 76 fd ff ff       	call   8023c8 <nsipc>
  802652:	89 c6                	mov    %eax,%esi
  802654:	85 c0                	test   %eax,%eax
  802656:	78 22                	js     80267a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802658:	bb 10 80 80 00       	mov    $0x808010,%ebx
  80265d:	8b 03                	mov    (%ebx),%eax
  80265f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802663:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80266a:	00 
  80266b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266e:	89 04 24             	mov    %eax,(%esp)
  802671:	e8 f9 ea ff ff       	call   80116f <memmove>
		*addrlen = ret->ret_addrlen;
  802676:	8b 03                	mov    (%ebx),%eax
  802678:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80267a:	89 f0                	mov    %esi,%eax
  80267c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80267f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802682:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802685:	89 ec                	mov    %ebp,%esp
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    
  802689:	00 00                	add    %al,(%eax)
	...

0080268c <free>:
	return v;
}

void
free(void *v)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	56                   	push   %esi
  802690:	53                   	push   %ebx
  802691:	83 ec 10             	sub    $0x10,%esp
  802694:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  802697:	85 db                	test   %ebx,%ebx
  802699:	0f 84 b9 00 00 00    	je     802758 <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80269f:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  8026a5:	76 08                	jbe    8026af <free+0x23>
  8026a7:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  8026ad:	76 24                	jbe    8026d3 <free+0x47>
  8026af:	c7 44 24 0c c8 38 80 	movl   $0x8038c8,0xc(%esp)
  8026b6:	00 
  8026b7:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  8026be:	00 
  8026bf:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8026c6:	00 
  8026c7:	c7 04 24 f8 38 80 00 	movl   $0x8038f8,(%esp)
  8026ce:	e8 d1 e1 ff ff       	call   8008a4 <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  8026d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8026d9:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8026de:	eb 4a                	jmp    80272a <free+0x9e>
		sys_page_unmap(0, c);
  8026e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026eb:	e8 62 ef ff ff       	call   801652 <sys_page_unmap>
		c += PGSIZE;
  8026f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  8026f6:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  8026fc:	76 08                	jbe    802706 <free+0x7a>
  8026fe:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  802704:	76 24                	jbe    80272a <free+0x9e>
  802706:	c7 44 24 0c 05 39 80 	movl   $0x803905,0xc(%esp)
  80270d:	00 
  80270e:	c7 44 24 08 44 38 80 	movl   $0x803844,0x8(%esp)
  802715:	00 
  802716:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  80271d:	00 
  80271e:	c7 04 24 f8 38 80 00 	movl   $0x8038f8,(%esp)
  802725:	e8 7a e1 ff ff       	call   8008a4 <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80272a:	89 d8                	mov    %ebx,%eax
  80272c:	c1 e8 0c             	shr    $0xc,%eax
  80272f:	8b 04 86             	mov    (%esi,%eax,4),%eax
  802732:	f6 c4 02             	test   $0x2,%ah
  802735:	75 a9                	jne    8026e0 <free+0x54>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  802737:	8d 93 fc 0f 00 00    	lea    0xffc(%ebx),%edx
	if (--(*ref) == 0)
  80273d:	8b 02                	mov    (%edx),%eax
  80273f:	83 e8 01             	sub    $0x1,%eax
  802742:	89 02                	mov    %eax,(%edx)
  802744:	85 c0                	test   %eax,%eax
  802746:	75 10                	jne    802758 <free+0xcc>
		sys_page_unmap(0, c);
  802748:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80274c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802753:	e8 fa ee ff ff       	call   801652 <sys_page_unmap>
}
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	5b                   	pop    %ebx
  80275c:	5e                   	pop    %esi
  80275d:	5d                   	pop    %ebp
  80275e:	c3                   	ret    

0080275f <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	57                   	push   %edi
  802763:	56                   	push   %esi
  802764:	53                   	push   %ebx
  802765:	83 ec 3c             	sub    $0x3c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  802768:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  80276f:	75 0a                	jne    80277b <malloc+0x1c>
		mptr = mbegin;
  802771:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802778:	00 00 08 

	n = ROUNDUP(n, 4);
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	83 c0 03             	add    $0x3,%eax
  802781:	83 e0 fc             	and    $0xfffffffc,%eax
  802784:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (n >= MAXMALLOC)
  802787:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  80278c:	0f 87 7e 01 00 00    	ja     802910 <malloc+0x1b1>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  802792:	a1 18 50 80 00       	mov    0x805018,%eax
  802797:	89 c2                	mov    %eax,%edx
  802799:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80279e:	74 4d                	je     8027ed <malloc+0x8e>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8027a0:	89 c3                	mov    %eax,%ebx
  8027a2:	c1 eb 0c             	shr    $0xc,%ebx
  8027a5:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  8027a8:	8d 4c 30 03          	lea    0x3(%eax,%esi,1),%ecx
  8027ac:	c1 e9 0c             	shr    $0xc,%ecx
  8027af:	39 cb                	cmp    %ecx,%ebx
  8027b1:	75 1e                	jne    8027d1 <malloc+0x72>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8027b3:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8027b9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  8027bf:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  8027c3:	8d 14 30             	lea    (%eax,%esi,1),%edx
  8027c6:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  8027cc:	e9 44 01 00 00       	jmp    802915 <malloc+0x1b6>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  8027d1:	89 04 24             	mov    %eax,(%esp)
  8027d4:	e8 b3 fe ff ff       	call   80268c <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8027d9:	a1 18 50 80 00       	mov    0x805018,%eax
  8027de:	05 00 10 00 00       	add    $0x1000,%eax
  8027e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027e8:	a3 18 50 80 00       	mov    %eax,0x805018
  8027ed:	8b 3d 18 50 80 00    	mov    0x805018,%edi
  8027f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			return 0;
	return 1;
}

void*
malloc(size_t n)
  8027fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fd:	83 c0 04             	add    $0x4,%eax
  802800:	89 45 d8             	mov    %eax,-0x28(%ebp)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802803:	bb 00 d0 7b ef       	mov    $0xef7bd000,%ebx
  802808:	be 00 00 40 ef       	mov    $0xef400000,%esi
			return 0;
	return 1;
}

void*
malloc(size_t n)
  80280d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802810:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802813:	89 c1                	mov    %eax,%ecx
  802815:	01 f9                	add    %edi,%ecx
  802817:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80281a:	89 f8                	mov    %edi,%eax
  80281c:	eb 26                	jmp    802844 <malloc+0xe5>
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  80281e:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  802823:	77 28                	ja     80284d <malloc+0xee>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802825:	89 c2                	mov    %eax,%edx
  802827:	c1 ea 16             	shr    $0x16,%edx
  80282a:	8b 14 93             	mov    (%ebx,%edx,4),%edx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  80282d:	f6 c2 01             	test   $0x1,%dl
  802830:	74 0d                	je     80283f <malloc+0xe0>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802832:	89 c2                	mov    %eax,%edx
  802834:	c1 ea 0c             	shr    $0xc,%edx
  802837:	8b 14 96             	mov    (%esi,%edx,4),%edx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  80283a:	f6 c2 01             	test   $0x1,%dl
  80283d:	75 0e                	jne    80284d <malloc+0xee>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80283f:	05 00 10 00 00       	add    $0x1000,%eax
  802844:	39 c1                	cmp    %eax,%ecx
  802846:	77 d6                	ja     80281e <malloc+0xbf>
  802848:	e9 91 00 00 00       	jmp    8028de <malloc+0x17f>
  80284d:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802853:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  802859:	81 ff 00 00 00 10    	cmp    $0x10000000,%edi
  80285f:	75 b6                	jne    802817 <malloc+0xb8>
			mptr = mbegin;
			if (++nwrap == 2)
  802861:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  802865:	83 7d dc 02          	cmpl   $0x2,-0x24(%ebp)
  802869:	74 07                	je     802872 <malloc+0x113>
  80286b:	bf 00 00 00 08       	mov    $0x8000000,%edi
  802870:	eb 9b                	jmp    80280d <malloc+0xae>
  802872:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802879:	00 00 08 
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	e9 8f 00 00 00       	jmp    802915 <malloc+0x1b6>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802886:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  80288c:	39 fe                	cmp    %edi,%esi
  80288e:	19 c0                	sbb    %eax,%eax
  802890:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802895:	83 c8 07             	or     $0x7,%eax
  802898:	89 44 24 08          	mov    %eax,0x8(%esp)
  80289c:	03 15 18 50 80 00    	add    0x805018,%edx
  8028a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ad:	e8 5c ee ff ff       	call   80170e <sys_page_alloc>
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	78 22                	js     8028d8 <malloc+0x179>
  8028b6:	89 f3                	mov    %esi,%ebx
  8028b8:	eb 35                	jmp    8028ef <malloc+0x190>
			for (; i >= 0; i -= PGSIZE)
				sys_page_unmap(0, mptr + i);
  8028ba:	89 d8                	mov    %ebx,%eax
  8028bc:	03 05 18 50 80 00    	add    0x805018,%eax
  8028c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028cd:	e8 80 ed ff ff       	call   801652 <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  8028d2:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  8028d8:	85 db                	test   %ebx,%ebx
  8028da:	79 de                	jns    8028ba <malloc+0x15b>
  8028dc:	eb 32                	jmp    802910 <malloc+0x1b1>
  8028de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8028e1:	89 35 18 50 80 00    	mov    %esi,0x805018
  8028e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8028ef:	89 da                	mov    %ebx,%edx
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  8028f1:	39 df                	cmp    %ebx,%edi
  8028f3:	77 91                	ja     802886 <malloc+0x127>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  8028f5:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8028fa:	c7 44 18 fc 02 00 00 	movl   $0x2,-0x4(%eax,%ebx,1)
  802901:	00 
	v = mptr;
	mptr += n;
  802902:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802905:	8d 14 10             	lea    (%eax,%edx,1),%edx
  802908:	89 15 18 50 80 00    	mov    %edx,0x805018
	return v;
  80290e:	eb 05                	jmp    802915 <malloc+0x1b6>
  802910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802915:	83 c4 3c             	add    $0x3c,%esp
  802918:	5b                   	pop    %ebx
  802919:	5e                   	pop    %esi
  80291a:	5f                   	pop    %edi
  80291b:	5d                   	pop    %ebp
  80291c:	c3                   	ret    
  80291d:	00 00                	add    %al,(%eax)
	...

00802920 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 18             	sub    $0x18,%esp
  802926:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802929:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80292c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	89 04 24             	mov    %eax,(%esp)
  802935:	e8 0a ef ff ff       	call   801844 <fd2data>
  80293a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80293c:	c7 44 24 04 1d 39 80 	movl   $0x80391d,0x4(%esp)
  802943:	00 
  802944:	89 34 24             	mov    %esi,(%esp)
  802947:	e8 7d e6 ff ff       	call   800fc9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80294c:	8b 43 04             	mov    0x4(%ebx),%eax
  80294f:	2b 03                	sub    (%ebx),%eax
  802951:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802957:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80295e:	00 00 00 
	stat->st_dev = &devpipe;
  802961:	c7 86 88 00 00 00 5c 	movl   $0x80405c,0x88(%esi)
  802968:	40 80 00 
	return 0;
}
  80296b:	b8 00 00 00 00       	mov    $0x0,%eax
  802970:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802973:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802976:	89 ec                	mov    %ebp,%esp
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    

0080297a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	53                   	push   %ebx
  80297e:	83 ec 14             	sub    $0x14,%esp
  802981:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802984:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802988:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80298f:	e8 be ec ff ff       	call   801652 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802994:	89 1c 24             	mov    %ebx,(%esp)
  802997:	e8 a8 ee ff ff       	call   801844 <fd2data>
  80299c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a7:	e8 a6 ec ff ff       	call   801652 <sys_page_unmap>
}
  8029ac:	83 c4 14             	add    $0x14,%esp
  8029af:	5b                   	pop    %ebx
  8029b0:	5d                   	pop    %ebp
  8029b1:	c3                   	ret    

008029b2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	57                   	push   %edi
  8029b6:	56                   	push   %esi
  8029b7:	53                   	push   %ebx
  8029b8:	83 ec 2c             	sub    $0x2c,%esp
  8029bb:	89 c7                	mov    %eax,%edi
  8029bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8029c0:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8029c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8029c8:	89 3c 24             	mov    %edi,(%esp)
  8029cb:	e8 c0 05 00 00       	call   802f90 <pageref>
  8029d0:	89 c6                	mov    %eax,%esi
  8029d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d5:	89 04 24             	mov    %eax,(%esp)
  8029d8:	e8 b3 05 00 00       	call   802f90 <pageref>
  8029dd:	39 c6                	cmp    %eax,%esi
  8029df:	0f 94 c0             	sete   %al
  8029e2:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  8029e5:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8029eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029ee:	39 cb                	cmp    %ecx,%ebx
  8029f0:	75 08                	jne    8029fa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8029f2:	83 c4 2c             	add    $0x2c,%esp
  8029f5:	5b                   	pop    %ebx
  8029f6:	5e                   	pop    %esi
  8029f7:	5f                   	pop    %edi
  8029f8:	5d                   	pop    %ebp
  8029f9:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8029fa:	83 f8 01             	cmp    $0x1,%eax
  8029fd:	75 c1                	jne    8029c0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029ff:	8b 52 58             	mov    0x58(%edx),%edx
  802a02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a06:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a0e:	c7 04 24 24 39 80 00 	movl   $0x803924,(%esp)
  802a15:	e8 43 df ff ff       	call   80095d <cprintf>
  802a1a:	eb a4                	jmp    8029c0 <_pipeisclosed+0xe>

00802a1c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	57                   	push   %edi
  802a20:	56                   	push   %esi
  802a21:	53                   	push   %ebx
  802a22:	83 ec 1c             	sub    $0x1c,%esp
  802a25:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802a28:	89 34 24             	mov    %esi,(%esp)
  802a2b:	e8 14 ee ff ff       	call   801844 <fd2data>
  802a30:	89 c3                	mov    %eax,%ebx
  802a32:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a37:	eb 48                	jmp    802a81 <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802a39:	89 da                	mov    %ebx,%edx
  802a3b:	89 f0                	mov    %esi,%eax
  802a3d:	e8 70 ff ff ff       	call   8029b2 <_pipeisclosed>
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 07                	je     802a4d <devpipe_write+0x31>
  802a46:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4b:	eb 3b                	jmp    802a88 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802a4d:	e8 1b ed ff ff       	call   80176d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a52:	8b 43 04             	mov    0x4(%ebx),%eax
  802a55:	8b 13                	mov    (%ebx),%edx
  802a57:	83 c2 20             	add    $0x20,%edx
  802a5a:	39 d0                	cmp    %edx,%eax
  802a5c:	73 db                	jae    802a39 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a5e:	89 c2                	mov    %eax,%edx
  802a60:	c1 fa 1f             	sar    $0x1f,%edx
  802a63:	c1 ea 1b             	shr    $0x1b,%edx
  802a66:	01 d0                	add    %edx,%eax
  802a68:	83 e0 1f             	and    $0x1f,%eax
  802a6b:	29 d0                	sub    %edx,%eax
  802a6d:	89 c2                	mov    %eax,%edx
  802a6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a72:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802a76:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a7a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a7e:	83 c7 01             	add    $0x1,%edi
  802a81:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a84:	72 cc                	jb     802a52 <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802a86:	89 f8                	mov    %edi,%eax
}
  802a88:	83 c4 1c             	add    $0x1c,%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    

00802a90 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	83 ec 28             	sub    $0x28,%esp
  802a96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a9f:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802aa2:	89 3c 24             	mov    %edi,(%esp)
  802aa5:	e8 9a ed ff ff       	call   801844 <fd2data>
  802aaa:	89 c3                	mov    %eax,%ebx
  802aac:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ab1:	eb 48                	jmp    802afb <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802ab3:	85 f6                	test   %esi,%esi
  802ab5:	74 04                	je     802abb <devpipe_read+0x2b>
				return i;
  802ab7:	89 f0                	mov    %esi,%eax
  802ab9:	eb 47                	jmp    802b02 <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802abb:	89 da                	mov    %ebx,%edx
  802abd:	89 f8                	mov    %edi,%eax
  802abf:	e8 ee fe ff ff       	call   8029b2 <_pipeisclosed>
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 07                	je     802acf <devpipe_read+0x3f>
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	eb 33                	jmp    802b02 <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802acf:	e8 99 ec ff ff       	call   80176d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ad4:	8b 03                	mov    (%ebx),%eax
  802ad6:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ad9:	74 d8                	je     802ab3 <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802adb:	89 c2                	mov    %eax,%edx
  802add:	c1 fa 1f             	sar    $0x1f,%edx
  802ae0:	c1 ea 1b             	shr    $0x1b,%edx
  802ae3:	01 d0                	add    %edx,%eax
  802ae5:	83 e0 1f             	and    $0x1f,%eax
  802ae8:	29 d0                	sub    %edx,%eax
  802aea:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af2:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802af5:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802af8:	83 c6 01             	add    $0x1,%esi
  802afb:	3b 75 10             	cmp    0x10(%ebp),%esi
  802afe:	72 d4                	jb     802ad4 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802b00:	89 f0                	mov    %esi,%eax
}
  802b02:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b05:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b08:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b0b:	89 ec                	mov    %ebp,%esp
  802b0d:	5d                   	pop    %ebp
  802b0e:	c3                   	ret    

00802b0f <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	89 04 24             	mov    %eax,(%esp)
  802b22:	e8 91 ed ff ff       	call   8018b8 <fd_lookup>
  802b27:	85 c0                	test   %eax,%eax
  802b29:	78 15                	js     802b40 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	89 04 24             	mov    %eax,(%esp)
  802b31:	e8 0e ed ff ff       	call   801844 <fd2data>
	return _pipeisclosed(fd, p);
  802b36:	89 c2                	mov    %eax,%edx
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	e8 72 fe ff ff       	call   8029b2 <_pipeisclosed>
}
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
  802b45:	83 ec 48             	sub    $0x48,%esp
  802b48:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b4b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b4e:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b51:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b57:	89 04 24             	mov    %eax,(%esp)
  802b5a:	e8 00 ed ff ff       	call   80185f <fd_alloc>
  802b5f:	89 c3                	mov    %eax,%ebx
  802b61:	85 c0                	test   %eax,%eax
  802b63:	0f 88 42 01 00 00    	js     802cab <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b69:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b70:	00 
  802b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b7f:	e8 8a eb ff ff       	call   80170e <sys_page_alloc>
  802b84:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b86:	85 c0                	test   %eax,%eax
  802b88:	0f 88 1d 01 00 00    	js     802cab <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b8e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802b91:	89 04 24             	mov    %eax,(%esp)
  802b94:	e8 c6 ec ff ff       	call   80185f <fd_alloc>
  802b99:	89 c3                	mov    %eax,%ebx
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	0f 88 f5 00 00 00    	js     802c98 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ba3:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802baa:	00 
  802bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bb9:	e8 50 eb ff ff       	call   80170e <sys_page_alloc>
  802bbe:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	0f 88 d0 00 00 00    	js     802c98 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcb:	89 04 24             	mov    %eax,(%esp)
  802bce:	e8 71 ec ff ff       	call   801844 <fd2data>
  802bd3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bd5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802bdc:	00 
  802bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802be8:	e8 21 eb ff ff       	call   80170e <sys_page_alloc>
  802bed:	89 c3                	mov    %eax,%ebx
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	0f 88 8e 00 00 00    	js     802c85 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfa:	89 04 24             	mov    %eax,(%esp)
  802bfd:	e8 42 ec ff ff       	call   801844 <fd2data>
  802c02:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802c09:	00 
  802c0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c0e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c15:	00 
  802c16:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c21:	e8 8a ea ff ff       	call   8016b0 <sys_page_map>
  802c26:	89 c3                	mov    %eax,%ebx
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	78 49                	js     802c75 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802c2c:	b8 5c 40 80 00       	mov    $0x80405c,%eax
  802c31:	8b 08                	mov    (%eax),%ecx
  802c33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c36:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c3b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802c42:	8b 10                	mov    (%eax),%edx
  802c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c47:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c56:	89 04 24             	mov    %eax,(%esp)
  802c59:	e8 d6 eb ff ff       	call   801834 <fd2num>
  802c5e:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c63:	89 04 24             	mov    %eax,(%esp)
  802c66:	e8 c9 eb ff ff       	call   801834 <fd2num>
  802c6b:	89 47 04             	mov    %eax,0x4(%edi)
  802c6e:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802c73:	eb 36                	jmp    802cab <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802c75:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c80:	e8 cd e9 ff ff       	call   801652 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c93:	e8 ba e9 ff ff       	call   801652 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ca6:	e8 a7 e9 ff ff       	call   801652 <sys_page_unmap>
    err:
	return r;
}
  802cab:	89 d8                	mov    %ebx,%eax
  802cad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802cb0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802cb3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802cb6:	89 ec                	mov    %ebp,%esp
  802cb8:	5d                   	pop    %ebp
  802cb9:	c3                   	ret    
  802cba:	00 00                	add    %al,(%eax)
  802cbc:	00 00                	add    %al,(%eax)
	...

00802cc0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	5d                   	pop    %ebp
  802cc9:	c3                   	ret    

00802cca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802cd0:	c7 44 24 04 3c 39 80 	movl   $0x80393c,0x4(%esp)
  802cd7:	00 
  802cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdb:	89 04 24             	mov    %eax,(%esp)
  802cde:	e8 e6 e2 ff ff       	call   800fc9 <strcpy>
	return 0;
}
  802ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	57                   	push   %edi
  802cee:	56                   	push   %esi
  802cef:	53                   	push   %ebx
  802cf0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  802cf6:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802cfb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d01:	eb 34                	jmp    802d37 <devcons_write+0x4d>
		m = n - tot;
  802d03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d06:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  802d08:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  802d0e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802d13:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d16:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d1a:	03 45 0c             	add    0xc(%ebp),%eax
  802d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d21:	89 3c 24             	mov    %edi,(%esp)
  802d24:	e8 46 e4 ff ff       	call   80116f <memmove>
		sys_cputs(buf, m);
  802d29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d2d:	89 3c 24             	mov    %edi,(%esp)
  802d30:	e8 4b e6 ff ff       	call   801380 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d35:	01 de                	add    %ebx,%esi
  802d37:	89 f0                	mov    %esi,%eax
  802d39:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d3c:	72 c5                	jb     802d03 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802d3e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802d44:	5b                   	pop    %ebx
  802d45:	5e                   	pop    %esi
  802d46:	5f                   	pop    %edi
  802d47:	5d                   	pop    %ebp
  802d48:	c3                   	ret    

00802d49 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802d55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802d5c:	00 
  802d5d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d60:	89 04 24             	mov    %eax,(%esp)
  802d63:	e8 18 e6 ff ff       	call   801380 <sys_cputs>
}
  802d68:	c9                   	leave  
  802d69:	c3                   	ret    

00802d6a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d6a:	55                   	push   %ebp
  802d6b:	89 e5                	mov    %esp,%ebp
  802d6d:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d74:	75 07                	jne    802d7d <devcons_read+0x13>
  802d76:	eb 28                	jmp    802da0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802d78:	e8 f0 e9 ff ff       	call   80176d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802d7d:	8d 76 00             	lea    0x0(%esi),%esi
  802d80:	e8 c7 e5 ff ff       	call   80134c <sys_cgetc>
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 ef                	je     802d78 <devcons_read+0xe>
  802d89:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	78 16                	js     802da5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802d8f:	83 f8 04             	cmp    $0x4,%eax
  802d92:	74 0c                	je     802da0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d97:	88 10                	mov    %dl,(%eax)
  802d99:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802d9e:	eb 05                	jmp    802da5 <devcons_read+0x3b>
  802da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da5:	c9                   	leave  
  802da6:	c3                   	ret    

00802da7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
  802daa:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802dad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db0:	89 04 24             	mov    %eax,(%esp)
  802db3:	e8 a7 ea ff ff       	call   80185f <fd_alloc>
  802db8:	85 c0                	test   %eax,%eax
  802dba:	78 3f                	js     802dfb <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dbc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802dc3:	00 
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dd2:	e8 37 e9 ff ff       	call   80170e <sys_page_alloc>
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	78 20                	js     802dfb <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ddb:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	89 04 24             	mov    %eax,(%esp)
  802df6:	e8 39 ea ff ff       	call   801834 <fd2num>
}
  802dfb:	c9                   	leave  
  802dfc:	c3                   	ret    

00802dfd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802dfd:	55                   	push   %ebp
  802dfe:	89 e5                	mov    %esp,%ebp
  802e00:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e06:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	89 04 24             	mov    %eax,(%esp)
  802e10:	e8 a3 ea ff ff       	call   8018b8 <fd_lookup>
  802e15:	85 c0                	test   %eax,%eax
  802e17:	78 11                	js     802e2a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	3b 05 78 40 80 00    	cmp    0x804078,%eax
  802e24:	0f 94 c0             	sete   %al
  802e27:	0f b6 c0             	movzbl %al,%eax
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
  802e2f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802e32:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802e39:	00 
  802e3a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e48:	e8 c2 ec ff ff       	call   801b0f <read>
	if (r < 0)
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	78 0f                	js     802e60 <getchar+0x34>
		return r;
	if (r < 1)
  802e51:	85 c0                	test   %eax,%eax
  802e53:	7f 07                	jg     802e5c <getchar+0x30>
  802e55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802e5a:	eb 04                	jmp    802e60 <getchar+0x34>
		return -E_EOF;
	return c;
  802e5c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802e60:	c9                   	leave  
  802e61:	c3                   	ret    
	...

00802e64 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e6a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802e6f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802e72:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802e78:	8b 12                	mov    (%edx),%edx
  802e7a:	39 ca                	cmp    %ecx,%edx
  802e7c:	75 0c                	jne    802e8a <ipc_find_env+0x26>
			return envs[i].env_id;
  802e7e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802e81:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	eb 0e                	jmp    802e98 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802e8a:	83 c0 01             	add    $0x1,%eax
  802e8d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e92:	75 db                	jne    802e6f <ipc_find_env+0xb>
  802e94:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  802e98:	5d                   	pop    %ebp
  802e99:	c3                   	ret    

00802e9a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
  802e9d:	57                   	push   %edi
  802e9e:	56                   	push   %esi
  802e9f:	53                   	push   %ebx
  802ea0:	83 ec 2c             	sub    $0x2c,%esp
  802ea3:	8b 75 08             	mov    0x8(%ebp),%esi
  802ea6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ea9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  802eac:	85 db                	test   %ebx,%ebx
  802eae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802eb3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  802eb6:	8b 45 14             	mov    0x14(%ebp),%eax
  802eb9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ebd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ec1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802ec5:	89 34 24             	mov    %esi,(%esp)
  802ec8:	e8 33 e6 ff ff       	call   801500 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  802ecd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802ed0:	74 e4                	je     802eb6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	74 28                	je     802efe <ipc_send+0x64>
  802ed6:	89 44 24 10          	mov    %eax,0x10(%esp)
  802eda:	c7 44 24 0c 65 39 80 	movl   $0x803965,0xc(%esp)
  802ee1:	00 
  802ee2:	c7 44 24 08 48 39 80 	movl   $0x803948,0x8(%esp)
  802ee9:	00 
  802eea:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802ef1:	00 
  802ef2:	c7 04 24 5b 39 80 00 	movl   $0x80395b,(%esp)
  802ef9:	e8 a6 d9 ff ff       	call   8008a4 <_panic>
	//if(!ret) sys_yield();
}
  802efe:	83 c4 2c             	add    $0x2c,%esp
  802f01:	5b                   	pop    %ebx
  802f02:	5e                   	pop    %esi
  802f03:	5f                   	pop    %edi
  802f04:	5d                   	pop    %ebp
  802f05:	c3                   	ret    

00802f06 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802f06:	55                   	push   %ebp
  802f07:	89 e5                	mov    %esp,%ebp
  802f09:	83 ec 28             	sub    $0x28,%esp
  802f0c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802f0f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802f12:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802f15:	8b 75 08             	mov    0x8(%ebp),%esi
  802f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802f25:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802f28:	89 04 24             	mov    %eax,(%esp)
  802f2b:	e8 73 e5 ff ff       	call   8014a3 <sys_ipc_recv>
  802f30:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802f32:	e8 6a e8 ff ff       	call   8017a1 <sys_getenvid>
  802f37:	25 ff 03 00 00       	and    $0x3ff,%eax
  802f3c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802f3f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802f44:	a3 1c 50 80 00       	mov    %eax,0x80501c
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802f49:	85 f6                	test   %esi,%esi
  802f4b:	74 0e                	je     802f5b <ipc_recv+0x55>
  802f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f52:	85 db                	test   %ebx,%ebx
  802f54:	75 03                	jne    802f59 <ipc_recv+0x53>
  802f56:	8b 50 74             	mov    0x74(%eax),%edx
  802f59:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  802f5b:	85 ff                	test   %edi,%edi
  802f5d:	74 13                	je     802f72 <ipc_recv+0x6c>
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f64:	85 db                	test   %ebx,%ebx
  802f66:	75 08                	jne    802f70 <ipc_recv+0x6a>
  802f68:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802f6d:	8b 40 78             	mov    0x78(%eax),%eax
  802f70:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802f72:	85 db                	test   %ebx,%ebx
  802f74:	75 08                	jne    802f7e <ipc_recv+0x78>
  802f76:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802f7b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  802f7e:	89 d8                	mov    %ebx,%eax
  802f80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802f86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802f89:	89 ec                	mov    %ebp,%esp
  802f8b:	5d                   	pop    %ebp
  802f8c:	c3                   	ret    
  802f8d:	00 00                	add    %al,(%eax)
	...

00802f90 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	89 c2                	mov    %eax,%edx
  802f98:	c1 ea 16             	shr    $0x16,%edx
  802f9b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802fa2:	f6 c2 01             	test   $0x1,%dl
  802fa5:	74 20                	je     802fc7 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  802fa7:	c1 e8 0c             	shr    $0xc,%eax
  802faa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802fb1:	a8 01                	test   $0x1,%al
  802fb3:	74 12                	je     802fc7 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802fb5:	c1 e8 0c             	shr    $0xc,%eax
  802fb8:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  802fbd:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  802fc2:	0f b7 c0             	movzwl %ax,%eax
  802fc5:	eb 05                	jmp    802fcc <pageref+0x3c>
  802fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcc:	5d                   	pop    %ebp
  802fcd:	c3                   	ret    
	...

00802fd0 <__udivdi3>:
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
  802fd3:	57                   	push   %edi
  802fd4:	56                   	push   %esi
  802fd5:	83 ec 10             	sub    $0x10,%esp
  802fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  802fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fde:	8b 75 10             	mov    0x10(%ebp),%esi
  802fe1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802fe9:	75 35                	jne    803020 <__udivdi3+0x50>
  802feb:	39 fe                	cmp    %edi,%esi
  802fed:	77 61                	ja     803050 <__udivdi3+0x80>
  802fef:	85 f6                	test   %esi,%esi
  802ff1:	75 0b                	jne    802ffe <__udivdi3+0x2e>
  802ff3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ff8:	31 d2                	xor    %edx,%edx
  802ffa:	f7 f6                	div    %esi
  802ffc:	89 c6                	mov    %eax,%esi
  802ffe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803001:	31 d2                	xor    %edx,%edx
  803003:	89 f8                	mov    %edi,%eax
  803005:	f7 f6                	div    %esi
  803007:	89 c7                	mov    %eax,%edi
  803009:	89 c8                	mov    %ecx,%eax
  80300b:	f7 f6                	div    %esi
  80300d:	89 c1                	mov    %eax,%ecx
  80300f:	89 fa                	mov    %edi,%edx
  803011:	89 c8                	mov    %ecx,%eax
  803013:	83 c4 10             	add    $0x10,%esp
  803016:	5e                   	pop    %esi
  803017:	5f                   	pop    %edi
  803018:	5d                   	pop    %ebp
  803019:	c3                   	ret    
  80301a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803020:	39 f8                	cmp    %edi,%eax
  803022:	77 1c                	ja     803040 <__udivdi3+0x70>
  803024:	0f bd d0             	bsr    %eax,%edx
  803027:	83 f2 1f             	xor    $0x1f,%edx
  80302a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80302d:	75 39                	jne    803068 <__udivdi3+0x98>
  80302f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803032:	0f 86 a0 00 00 00    	jbe    8030d8 <__udivdi3+0x108>
  803038:	39 f8                	cmp    %edi,%eax
  80303a:	0f 82 98 00 00 00    	jb     8030d8 <__udivdi3+0x108>
  803040:	31 ff                	xor    %edi,%edi
  803042:	31 c9                	xor    %ecx,%ecx
  803044:	89 c8                	mov    %ecx,%eax
  803046:	89 fa                	mov    %edi,%edx
  803048:	83 c4 10             	add    $0x10,%esp
  80304b:	5e                   	pop    %esi
  80304c:	5f                   	pop    %edi
  80304d:	5d                   	pop    %ebp
  80304e:	c3                   	ret    
  80304f:	90                   	nop
  803050:	89 d1                	mov    %edx,%ecx
  803052:	89 fa                	mov    %edi,%edx
  803054:	89 c8                	mov    %ecx,%eax
  803056:	31 ff                	xor    %edi,%edi
  803058:	f7 f6                	div    %esi
  80305a:	89 c1                	mov    %eax,%ecx
  80305c:	89 fa                	mov    %edi,%edx
  80305e:	89 c8                	mov    %ecx,%eax
  803060:	83 c4 10             	add    $0x10,%esp
  803063:	5e                   	pop    %esi
  803064:	5f                   	pop    %edi
  803065:	5d                   	pop    %ebp
  803066:	c3                   	ret    
  803067:	90                   	nop
  803068:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80306c:	89 f2                	mov    %esi,%edx
  80306e:	d3 e0                	shl    %cl,%eax
  803070:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803073:	b8 20 00 00 00       	mov    $0x20,%eax
  803078:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80307b:	89 c1                	mov    %eax,%ecx
  80307d:	d3 ea                	shr    %cl,%edx
  80307f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803083:	0b 55 ec             	or     -0x14(%ebp),%edx
  803086:	d3 e6                	shl    %cl,%esi
  803088:	89 c1                	mov    %eax,%ecx
  80308a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80308d:	89 fe                	mov    %edi,%esi
  80308f:	d3 ee                	shr    %cl,%esi
  803091:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803095:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803098:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309b:	d3 e7                	shl    %cl,%edi
  80309d:	89 c1                	mov    %eax,%ecx
  80309f:	d3 ea                	shr    %cl,%edx
  8030a1:	09 d7                	or     %edx,%edi
  8030a3:	89 f2                	mov    %esi,%edx
  8030a5:	89 f8                	mov    %edi,%eax
  8030a7:	f7 75 ec             	divl   -0x14(%ebp)
  8030aa:	89 d6                	mov    %edx,%esi
  8030ac:	89 c7                	mov    %eax,%edi
  8030ae:	f7 65 e8             	mull   -0x18(%ebp)
  8030b1:	39 d6                	cmp    %edx,%esi
  8030b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8030b6:	72 30                	jb     8030e8 <__udivdi3+0x118>
  8030b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030bb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8030bf:	d3 e2                	shl    %cl,%edx
  8030c1:	39 c2                	cmp    %eax,%edx
  8030c3:	73 05                	jae    8030ca <__udivdi3+0xfa>
  8030c5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8030c8:	74 1e                	je     8030e8 <__udivdi3+0x118>
  8030ca:	89 f9                	mov    %edi,%ecx
  8030cc:	31 ff                	xor    %edi,%edi
  8030ce:	e9 71 ff ff ff       	jmp    803044 <__udivdi3+0x74>
  8030d3:	90                   	nop
  8030d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030d8:	31 ff                	xor    %edi,%edi
  8030da:	b9 01 00 00 00       	mov    $0x1,%ecx
  8030df:	e9 60 ff ff ff       	jmp    803044 <__udivdi3+0x74>
  8030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030e8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8030eb:	31 ff                	xor    %edi,%edi
  8030ed:	89 c8                	mov    %ecx,%eax
  8030ef:	89 fa                	mov    %edi,%edx
  8030f1:	83 c4 10             	add    $0x10,%esp
  8030f4:	5e                   	pop    %esi
  8030f5:	5f                   	pop    %edi
  8030f6:	5d                   	pop    %ebp
  8030f7:	c3                   	ret    
	...

00803100 <__umoddi3>:
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	57                   	push   %edi
  803104:	56                   	push   %esi
  803105:	83 ec 20             	sub    $0x20,%esp
  803108:	8b 55 14             	mov    0x14(%ebp),%edx
  80310b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80310e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803111:	8b 75 0c             	mov    0xc(%ebp),%esi
  803114:	85 d2                	test   %edx,%edx
  803116:	89 c8                	mov    %ecx,%eax
  803118:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80311b:	75 13                	jne    803130 <__umoddi3+0x30>
  80311d:	39 f7                	cmp    %esi,%edi
  80311f:	76 3f                	jbe    803160 <__umoddi3+0x60>
  803121:	89 f2                	mov    %esi,%edx
  803123:	f7 f7                	div    %edi
  803125:	89 d0                	mov    %edx,%eax
  803127:	31 d2                	xor    %edx,%edx
  803129:	83 c4 20             	add    $0x20,%esp
  80312c:	5e                   	pop    %esi
  80312d:	5f                   	pop    %edi
  80312e:	5d                   	pop    %ebp
  80312f:	c3                   	ret    
  803130:	39 f2                	cmp    %esi,%edx
  803132:	77 4c                	ja     803180 <__umoddi3+0x80>
  803134:	0f bd ca             	bsr    %edx,%ecx
  803137:	83 f1 1f             	xor    $0x1f,%ecx
  80313a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80313d:	75 51                	jne    803190 <__umoddi3+0x90>
  80313f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803142:	0f 87 e0 00 00 00    	ja     803228 <__umoddi3+0x128>
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	29 f8                	sub    %edi,%eax
  80314d:	19 d6                	sbb    %edx,%esi
  80314f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	89 f2                	mov    %esi,%edx
  803157:	83 c4 20             	add    $0x20,%esp
  80315a:	5e                   	pop    %esi
  80315b:	5f                   	pop    %edi
  80315c:	5d                   	pop    %ebp
  80315d:	c3                   	ret    
  80315e:	66 90                	xchg   %ax,%ax
  803160:	85 ff                	test   %edi,%edi
  803162:	75 0b                	jne    80316f <__umoddi3+0x6f>
  803164:	b8 01 00 00 00       	mov    $0x1,%eax
  803169:	31 d2                	xor    %edx,%edx
  80316b:	f7 f7                	div    %edi
  80316d:	89 c7                	mov    %eax,%edi
  80316f:	89 f0                	mov    %esi,%eax
  803171:	31 d2                	xor    %edx,%edx
  803173:	f7 f7                	div    %edi
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	f7 f7                	div    %edi
  80317a:	eb a9                	jmp    803125 <__umoddi3+0x25>
  80317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803180:	89 c8                	mov    %ecx,%eax
  803182:	89 f2                	mov    %esi,%edx
  803184:	83 c4 20             	add    $0x20,%esp
  803187:	5e                   	pop    %esi
  803188:	5f                   	pop    %edi
  803189:	5d                   	pop    %ebp
  80318a:	c3                   	ret    
  80318b:	90                   	nop
  80318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803190:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803194:	d3 e2                	shl    %cl,%edx
  803196:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803199:	ba 20 00 00 00       	mov    $0x20,%edx
  80319e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8031a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8031a4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8031a8:	89 fa                	mov    %edi,%edx
  8031aa:	d3 ea                	shr    %cl,%edx
  8031ac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8031b0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8031b3:	d3 e7                	shl    %cl,%edi
  8031b5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8031b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8031bc:	89 f2                	mov    %esi,%edx
  8031be:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	d3 ea                	shr    %cl,%edx
  8031c5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8031c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8031cc:	89 c2                	mov    %eax,%edx
  8031ce:	d3 e6                	shl    %cl,%esi
  8031d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8031d4:	d3 ea                	shr    %cl,%edx
  8031d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8031da:	09 d6                	or     %edx,%esi
  8031dc:	89 f0                	mov    %esi,%eax
  8031de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8031e1:	d3 e7                	shl    %cl,%edi
  8031e3:	89 f2                	mov    %esi,%edx
  8031e5:	f7 75 f4             	divl   -0xc(%ebp)
  8031e8:	89 d6                	mov    %edx,%esi
  8031ea:	f7 65 e8             	mull   -0x18(%ebp)
  8031ed:	39 d6                	cmp    %edx,%esi
  8031ef:	72 2b                	jb     80321c <__umoddi3+0x11c>
  8031f1:	39 c7                	cmp    %eax,%edi
  8031f3:	72 23                	jb     803218 <__umoddi3+0x118>
  8031f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8031f9:	29 c7                	sub    %eax,%edi
  8031fb:	19 d6                	sbb    %edx,%esi
  8031fd:	89 f0                	mov    %esi,%eax
  8031ff:	89 f2                	mov    %esi,%edx
  803201:	d3 ef                	shr    %cl,%edi
  803203:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803207:	d3 e0                	shl    %cl,%eax
  803209:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80320d:	09 f8                	or     %edi,%eax
  80320f:	d3 ea                	shr    %cl,%edx
  803211:	83 c4 20             	add    $0x20,%esp
  803214:	5e                   	pop    %esi
  803215:	5f                   	pop    %edi
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    
  803218:	39 d6                	cmp    %edx,%esi
  80321a:	75 d9                	jne    8031f5 <__umoddi3+0xf5>
  80321c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80321f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803222:	eb d1                	jmp    8031f5 <__umoddi3+0xf5>
  803224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803228:	39 f2                	cmp    %esi,%edx
  80322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803230:	0f 82 12 ff ff ff    	jb     803148 <__umoddi3+0x48>
  803236:	e9 17 ff ff ff       	jmp    803152 <__umoddi3+0x52>
