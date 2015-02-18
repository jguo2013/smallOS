
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
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
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
  80003d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800040:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800043:	83 ff 01             	cmp    $0x1,%edi
  800046:	7e 25                	jle    80006d <umain+0x39>
  800048:	8d 73 04             	lea    0x4(%ebx),%esi
  80004b:	c7 44 24 04 60 28 80 	movl   $0x802860,0x4(%esp)
  800052:	00 
  800053:	8b 06                	mov    (%esi),%eax
  800055:	89 04 24             	mov    %eax,(%esp)
  800058:	e8 e7 01 00 00       	call   800244 <strcmp>
  80005d:	85 c0                	test   %eax,%eax
  80005f:	75 0c                	jne    80006d <umain+0x39>
		nflag = 1;
		argc--;
  800061:	83 ef 01             	sub    $0x1,%edi
  800064:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  80006b:	eb 09                	jmp    800076 <umain+0x42>
  80006d:	89 de                	mov    %ebx,%esi
  80006f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800076:	bb 01 00 00 00       	mov    $0x1,%ebx
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80007b:	eb 46                	jmp    8000c3 <umain+0x8f>
		if (i > 1)
  80007d:	83 fb 01             	cmp    $0x1,%ebx
  800080:	7e 1c                	jle    80009e <umain+0x6a>
			write(1, " ", 1);
  800082:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800089:	00 
  80008a:	c7 44 24 04 63 28 80 	movl   $0x802863,0x4(%esp)
  800091:	00 
  800092:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800099:	e8 b8 0b 00 00       	call   800c56 <write>
		write(1, argv[i], strlen(argv[i]));
  80009e:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000a1:	89 04 24             	mov    %eax,(%esp)
  8000a4:	e8 b7 00 00 00       	call   800160 <strlen>
  8000a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ad:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000bb:	e8 96 0b 00 00       	call   800c56 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000c0:	83 c3 01             	add    $0x1,%ebx
  8000c3:	39 df                	cmp    %ebx,%edi
  8000c5:	7f b6                	jg     80007d <umain+0x49>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000cb:	75 1c                	jne    8000e9 <umain+0xb5>
		write(1, "\n", 1);
  8000cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d4:	00 
  8000d5:	c7 44 24 04 39 2d 80 	movl   $0x802d39,0x4(%esp)
  8000dc:	00 
  8000dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000e4:	e8 6d 0b 00 00       	call   800c56 <write>
}
  8000e9:	83 c4 2c             	add    $0x2c,%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    
  8000f1:	00 00                	add    %al,(%eax)
	...

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	83 ec 18             	sub    $0x18,%esp
  8000fa:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000fd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800100:	8b 75 08             	mov    0x8(%ebp),%esi
  800103:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env *)UENVS + ENVX(sys_getenvid());
  800106:	e8 66 08 00 00       	call   800971 <sys_getenvid>
  80010b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800110:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800113:	2d 00 00 40 11       	sub    $0x11400000,%eax
  800118:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011d:	85 f6                	test   %esi,%esi
  80011f:	7e 07                	jle    800128 <libmain+0x34>
		binaryname = argv[0];
  800121:	8b 03                	mov    (%ebx),%eax
  800123:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800128:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80012c:	89 34 24             	mov    %esi,(%esp)
  80012f:	e8 00 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800134:	e8 0b 00 00 00       	call   800144 <exit>
}
  800139:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80013c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80013f:	89 ec                	mov    %ebp,%esp
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    
	...

00800144 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	83 ec 18             	sub    $0x18,%esp
	//close_all();
	sys_env_destroy(0);
  80014a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800151:	e8 4f 08 00 00       	call   8009a5 <sys_env_destroy>
}
  800156:	c9                   	leave  
  800157:	c3                   	ret    
	...

00800160 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  80016b:	eb 03                	jmp    800170 <strlen+0x10>
		n++;
  80016d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800170:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800174:	75 f7                	jne    80016d <strlen+0xd>
		n++;
	return n;
}
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	53                   	push   %ebx
  80017c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80017f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800182:	b8 00 00 00 00       	mov    $0x0,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800187:	eb 03                	jmp    80018c <strnlen+0x14>
		n++;
  800189:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80018c:	39 c1                	cmp    %eax,%ecx
  80018e:	74 06                	je     800196 <strnlen+0x1e>
  800190:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800194:	75 f3                	jne    800189 <strnlen+0x11>
		n++;
	return n;
}
  800196:	5b                   	pop    %ebx
  800197:	5d                   	pop    %ebp
  800198:	c3                   	ret    

00800199 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	53                   	push   %ebx
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001a3:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8001ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8001af:	83 c2 01             	add    $0x1,%edx
  8001b2:	84 c9                	test   %cl,%cl
  8001b4:	75 f2                	jne    8001a8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8001b6:	5b                   	pop    %ebx
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    

008001b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001c3:	89 1c 24             	mov    %ebx,(%esp)
  8001c6:	e8 95 ff ff ff       	call   800160 <strlen>
	strcpy(dst + len, src);
  8001cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001d2:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 bc ff ff ff       	call   800199 <strcpy>
	return dst;
}
  8001dd:	89 d8                	mov    %ebx,%eax
  8001df:	83 c4 08             	add    $0x8,%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	56                   	push   %esi
  8001e9:	53                   	push   %ebx
  8001ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f0:	8b 75 10             	mov    0x10(%ebp),%esi
  8001f3:	ba 00 00 00 00       	mov    $0x0,%edx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f8:	eb 0f                	jmp    800209 <strncpy+0x24>
		*dst++ = *src;
  8001fa:	0f b6 19             	movzbl (%ecx),%ebx
  8001fd:	88 1c 10             	mov    %bl,(%eax,%edx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800200:	80 39 01             	cmpb   $0x1,(%ecx)
  800203:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800206:	83 c2 01             	add    $0x1,%edx
  800209:	39 f2                	cmp    %esi,%edx
  80020b:	72 ed                	jb     8001fa <strncpy+0x15>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80020d:	5b                   	pop    %ebx
  80020e:	5e                   	pop    %esi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    

00800211 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	8b 75 08             	mov    0x8(%ebp),%esi
  800219:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021c:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80021f:	89 f0                	mov    %esi,%eax
  800221:	85 d2                	test   %edx,%edx
  800223:	75 0a                	jne    80022f <strlcpy+0x1e>
  800225:	eb 17                	jmp    80023e <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800227:	88 18                	mov    %bl,(%eax)
  800229:	83 c0 01             	add    $0x1,%eax
  80022c:	83 c1 01             	add    $0x1,%ecx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80022f:	83 ea 01             	sub    $0x1,%edx
  800232:	74 07                	je     80023b <strlcpy+0x2a>
  800234:	0f b6 19             	movzbl (%ecx),%ebx
  800237:	84 db                	test   %bl,%bl
  800239:	75 ec                	jne    800227 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
  80023b:	c6 00 00             	movb   $0x0,(%eax)
  80023e:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800240:	5b                   	pop    %ebx
  800241:	5e                   	pop    %esi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80024a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80024d:	eb 06                	jmp    800255 <strcmp+0x11>
		p++, q++;
  80024f:	83 c1 01             	add    $0x1,%ecx
  800252:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800255:	0f b6 01             	movzbl (%ecx),%eax
  800258:	84 c0                	test   %al,%al
  80025a:	74 04                	je     800260 <strcmp+0x1c>
  80025c:	3a 02                	cmp    (%edx),%al
  80025e:	74 ef                	je     80024f <strcmp+0xb>
  800260:	0f b6 c0             	movzbl %al,%eax
  800263:	0f b6 12             	movzbl (%edx),%edx
  800266:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	53                   	push   %ebx
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800274:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800277:	eb 09                	jmp    800282 <strncmp+0x18>
		n--, p++, q++;
  800279:	83 ea 01             	sub    $0x1,%edx
  80027c:	83 c0 01             	add    $0x1,%eax
  80027f:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800282:	85 d2                	test   %edx,%edx
  800284:	75 07                	jne    80028d <strncmp+0x23>
  800286:	b8 00 00 00 00       	mov    $0x0,%eax
  80028b:	eb 13                	jmp    8002a0 <strncmp+0x36>
  80028d:	0f b6 18             	movzbl (%eax),%ebx
  800290:	84 db                	test   %bl,%bl
  800292:	74 04                	je     800298 <strncmp+0x2e>
  800294:	3a 19                	cmp    (%ecx),%bl
  800296:	74 e1                	je     800279 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800298:	0f b6 00             	movzbl (%eax),%eax
  80029b:	0f b6 11             	movzbl (%ecx),%edx
  80029e:	29 d0                	sub    %edx,%eax
}
  8002a0:	5b                   	pop    %ebx
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ad:	eb 07                	jmp    8002b6 <strchr+0x13>
		if (*s == c)
  8002af:	38 ca                	cmp    %cl,%dl
  8002b1:	74 0f                	je     8002c2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8002b3:	83 c0 01             	add    $0x1,%eax
  8002b6:	0f b6 10             	movzbl (%eax),%edx
  8002b9:	84 d2                	test   %dl,%dl
  8002bb:	75 f2                	jne    8002af <strchr+0xc>
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ce:	eb 07                	jmp    8002d7 <strfind+0x13>
		if (*s == c)
  8002d0:	38 ca                	cmp    %cl,%dl
  8002d2:	74 0a                	je     8002de <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8002d4:	83 c0 01             	add    $0x1,%eax
  8002d7:	0f b6 10             	movzbl (%eax),%edx
  8002da:	84 d2                	test   %dl,%dl
  8002dc:	75 f2                	jne    8002d0 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	89 1c 24             	mov    %ebx,(%esp)
  8002e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ed:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8002f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002fa:	85 c9                	test   %ecx,%ecx
  8002fc:	74 30                	je     80032e <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002fe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800304:	75 25                	jne    80032b <memset+0x4b>
  800306:	f6 c1 03             	test   $0x3,%cl
  800309:	75 20                	jne    80032b <memset+0x4b>
		c &= 0xFF;
  80030b:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80030e:	89 d3                	mov    %edx,%ebx
  800310:	c1 e3 08             	shl    $0x8,%ebx
  800313:	89 d6                	mov    %edx,%esi
  800315:	c1 e6 18             	shl    $0x18,%esi
  800318:	89 d0                	mov    %edx,%eax
  80031a:	c1 e0 10             	shl    $0x10,%eax
  80031d:	09 f0                	or     %esi,%eax
  80031f:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800321:	09 d8                	or     %ebx,%eax
  800323:	c1 e9 02             	shr    $0x2,%ecx
  800326:	fc                   	cld    
  800327:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800329:	eb 03                	jmp    80032e <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80032b:	fc                   	cld    
  80032c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80032e:	89 f8                	mov    %edi,%eax
  800330:	8b 1c 24             	mov    (%esp),%ebx
  800333:	8b 74 24 04          	mov    0x4(%esp),%esi
  800337:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80033b:	89 ec                	mov    %ebp,%esp
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    

0080033f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	89 34 24             	mov    %esi,(%esp)
  800348:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
  800352:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800355:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800357:	39 c6                	cmp    %eax,%esi
  800359:	73 35                	jae    800390 <memmove+0x51>
  80035b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80035e:	39 d0                	cmp    %edx,%eax
  800360:	73 2e                	jae    800390 <memmove+0x51>
		s += n;
		d += n;
  800362:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800364:	f6 c2 03             	test   $0x3,%dl
  800367:	75 1b                	jne    800384 <memmove+0x45>
  800369:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80036f:	75 13                	jne    800384 <memmove+0x45>
  800371:	f6 c1 03             	test   $0x3,%cl
  800374:	75 0e                	jne    800384 <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800376:	83 ef 04             	sub    $0x4,%edi
  800379:	8d 72 fc             	lea    -0x4(%edx),%esi
  80037c:	c1 e9 02             	shr    $0x2,%ecx
  80037f:	fd                   	std    
  800380:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800382:	eb 09                	jmp    80038d <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800384:	83 ef 01             	sub    $0x1,%edi
  800387:	8d 72 ff             	lea    -0x1(%edx),%esi
  80038a:	fd                   	std    
  80038b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80038d:	fc                   	cld    
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80038e:	eb 20                	jmp    8003b0 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800390:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800396:	75 15                	jne    8003ad <memmove+0x6e>
  800398:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80039e:	75 0d                	jne    8003ad <memmove+0x6e>
  8003a0:	f6 c1 03             	test   $0x3,%cl
  8003a3:	75 08                	jne    8003ad <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8003a5:	c1 e9 02             	shr    $0x2,%ecx
  8003a8:	fc                   	cld    
  8003a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003ab:	eb 03                	jmp    8003b0 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8003ad:	fc                   	cld    
  8003ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003b0:	8b 34 24             	mov    (%esp),%esi
  8003b3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003b7:	89 ec                	mov    %ebp,%esp
  8003b9:	5d                   	pop    %ebp
  8003ba:	c3                   	ret    

008003bb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	89 04 24             	mov    %eax,(%esp)
  8003d5:	e8 65 ff ff ff       	call   80033f <memmove>
}
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	57                   	push   %edi
  8003e0:	56                   	push   %esi
  8003e1:	53                   	push   %ebx
  8003e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003eb:	ba 00 00 00 00       	mov    $0x0,%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003f0:	eb 1c                	jmp    80040e <memcmp+0x32>
		if (*s1 != *s2)
  8003f2:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
  8003f6:	0f b6 1c 16          	movzbl (%esi,%edx,1),%ebx
  8003fa:	83 c2 01             	add    $0x1,%edx
  8003fd:	83 e9 01             	sub    $0x1,%ecx
  800400:	38 d8                	cmp    %bl,%al
  800402:	74 0a                	je     80040e <memcmp+0x32>
			return (int) *s1 - (int) *s2;
  800404:	0f b6 c0             	movzbl %al,%eax
  800407:	0f b6 db             	movzbl %bl,%ebx
  80040a:	29 d8                	sub    %ebx,%eax
  80040c:	eb 09                	jmp    800417 <memcmp+0x3b>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80040e:	85 c9                	test   %ecx,%ecx
  800410:	75 e0                	jne    8003f2 <memcmp+0x16>
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800417:	5b                   	pop    %ebx
  800418:	5e                   	pop    %esi
  800419:	5f                   	pop    %edi
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800425:	89 c2                	mov    %eax,%edx
  800427:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80042a:	eb 07                	jmp    800433 <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  80042c:	38 08                	cmp    %cl,(%eax)
  80042e:	74 07                	je     800437 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800430:	83 c0 01             	add    $0x1,%eax
  800433:	39 d0                	cmp    %edx,%eax
  800435:	72 f5                	jb     80042c <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	57                   	push   %edi
  80043d:	56                   	push   %esi
  80043e:	53                   	push   %ebx
  80043f:	83 ec 04             	sub    $0x4,%esp
  800442:	8b 55 08             	mov    0x8(%ebp),%edx
  800445:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800448:	eb 03                	jmp    80044d <strtol+0x14>
		s++;
  80044a:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80044d:	0f b6 02             	movzbl (%edx),%eax
  800450:	3c 20                	cmp    $0x20,%al
  800452:	74 f6                	je     80044a <strtol+0x11>
  800454:	3c 09                	cmp    $0x9,%al
  800456:	74 f2                	je     80044a <strtol+0x11>
		s++;

	// plus/minus sign
	if (*s == '+')
  800458:	3c 2b                	cmp    $0x2b,%al
  80045a:	75 0c                	jne    800468 <strtol+0x2f>
		s++;
  80045c:	8d 52 01             	lea    0x1(%edx),%edx
  80045f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800466:	eb 15                	jmp    80047d <strtol+0x44>
	else if (*s == '-')
  800468:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046f:	3c 2d                	cmp    $0x2d,%al
  800471:	75 0a                	jne    80047d <strtol+0x44>
		s++, neg = 1;
  800473:	8d 52 01             	lea    0x1(%edx),%edx
  800476:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80047d:	85 db                	test   %ebx,%ebx
  80047f:	0f 94 c0             	sete   %al
  800482:	74 05                	je     800489 <strtol+0x50>
  800484:	83 fb 10             	cmp    $0x10,%ebx
  800487:	75 15                	jne    80049e <strtol+0x65>
  800489:	80 3a 30             	cmpb   $0x30,(%edx)
  80048c:	75 10                	jne    80049e <strtol+0x65>
  80048e:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800492:	75 0a                	jne    80049e <strtol+0x65>
		s += 2, base = 16;
  800494:	83 c2 02             	add    $0x2,%edx
  800497:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80049c:	eb 13                	jmp    8004b1 <strtol+0x78>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80049e:	84 c0                	test   %al,%al
  8004a0:	74 0f                	je     8004b1 <strtol+0x78>
  8004a2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8004a7:	80 3a 30             	cmpb   $0x30,(%edx)
  8004aa:	75 05                	jne    8004b1 <strtol+0x78>
		s++, base = 8;
  8004ac:	83 c2 01             	add    $0x1,%edx
  8004af:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8004b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8004b8:	0f b6 0a             	movzbl (%edx),%ecx
  8004bb:	89 cf                	mov    %ecx,%edi
  8004bd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8004c0:	80 fb 09             	cmp    $0x9,%bl
  8004c3:	77 08                	ja     8004cd <strtol+0x94>
			dig = *s - '0';
  8004c5:	0f be c9             	movsbl %cl,%ecx
  8004c8:	83 e9 30             	sub    $0x30,%ecx
  8004cb:	eb 1e                	jmp    8004eb <strtol+0xb2>
		else if (*s >= 'a' && *s <= 'z')
  8004cd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8004d0:	80 fb 19             	cmp    $0x19,%bl
  8004d3:	77 08                	ja     8004dd <strtol+0xa4>
			dig = *s - 'a' + 10;
  8004d5:	0f be c9             	movsbl %cl,%ecx
  8004d8:	83 e9 57             	sub    $0x57,%ecx
  8004db:	eb 0e                	jmp    8004eb <strtol+0xb2>
		else if (*s >= 'A' && *s <= 'Z')
  8004dd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  8004e0:	80 fb 19             	cmp    $0x19,%bl
  8004e3:	77 15                	ja     8004fa <strtol+0xc1>
			dig = *s - 'A' + 10;
  8004e5:	0f be c9             	movsbl %cl,%ecx
  8004e8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8004eb:	39 f1                	cmp    %esi,%ecx
  8004ed:	7d 0b                	jge    8004fa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8004ef:	83 c2 01             	add    $0x1,%edx
  8004f2:	0f af c6             	imul   %esi,%eax
  8004f5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  8004f8:	eb be                	jmp    8004b8 <strtol+0x7f>
  8004fa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  8004fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800500:	74 05                	je     800507 <strtol+0xce>
		*endptr = (char *) s;
  800502:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800505:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800507:	89 ca                	mov    %ecx,%edx
  800509:	f7 da                	neg    %edx
  80050b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80050f:	0f 45 c2             	cmovne %edx,%eax
}
  800512:	83 c4 04             	add    $0x4,%esp
  800515:	5b                   	pop    %ebx
  800516:	5e                   	pop    %esi
  800517:	5f                   	pop    %edi
  800518:	5d                   	pop    %ebp
  800519:	c3                   	ret    
	...

0080051c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	89 1c 24             	mov    %ebx,(%esp)
  800525:	89 74 24 04          	mov    %esi,0x4(%esp)
  800529:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80052d:	ba 00 00 00 00       	mov    $0x0,%edx
  800532:	b8 01 00 00 00       	mov    $0x1,%eax
  800537:	89 d1                	mov    %edx,%ecx
  800539:	89 d3                	mov    %edx,%ebx
  80053b:	89 d7                	mov    %edx,%edi
  80053d:	89 d6                	mov    %edx,%esi
  80053f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800541:	8b 1c 24             	mov    (%esp),%ebx
  800544:	8b 74 24 04          	mov    0x4(%esp),%esi
  800548:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80054c:	89 ec                	mov    %ebp,%esp
  80054e:	5d                   	pop    %ebp
  80054f:	c3                   	ret    

00800550 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	89 1c 24             	mov    %ebx,(%esp)
  800559:	89 74 24 04          	mov    %esi,0x4(%esp)
  80055d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800561:	b8 00 00 00 00       	mov    $0x0,%eax
  800566:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800569:	8b 55 08             	mov    0x8(%ebp),%edx
  80056c:	89 c3                	mov    %eax,%ebx
  80056e:	89 c7                	mov    %eax,%edi
  800570:	89 c6                	mov    %eax,%esi
  800572:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800574:	8b 1c 24             	mov    (%esp),%ebx
  800577:	8b 74 24 04          	mov    0x4(%esp),%esi
  80057b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80057f:	89 ec                	mov    %ebp,%esp
  800581:	5d                   	pop    %ebp
  800582:	c3                   	ret    

00800583 <sys_time_msec>:
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800583:	55                   	push   %ebp
  800584:	89 e5                	mov    %esp,%ebp
  800586:	83 ec 0c             	sub    $0xc,%esp
  800589:	89 1c 24             	mov    %ebx,(%esp)
  80058c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800590:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800594:	ba 00 00 00 00       	mov    $0x0,%edx
  800599:	b8 10 00 00 00       	mov    $0x10,%eax
  80059e:	89 d1                	mov    %edx,%ecx
  8005a0:	89 d3                	mov    %edx,%ebx
  8005a2:	89 d7                	mov    %edx,%edi
  8005a4:	89 d6                	mov    %edx,%esi
  8005a6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8005a8:	8b 1c 24             	mov    (%esp),%ebx
  8005ab:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005af:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005b3:	89 ec                	mov    %ebp,%esp
  8005b5:	5d                   	pop    %ebp
  8005b6:	c3                   	ret    

008005b7 <sys_net_receive>:
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	83 ec 38             	sub    $0x38,%esp
  8005bd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005c0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005c3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005cb:	b8 0f 00 00 00       	mov    $0xf,%eax
  8005d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005d6:	89 df                	mov    %ebx,%edi
  8005d8:	89 de                	mov    %ebx,%esi
  8005da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	7e 28                	jle    800608 <sys_net_receive+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8005e4:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8005eb:	00 
  8005ec:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  8005f3:	00 
  8005f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005fb:	00 
  8005fc:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  800603:	e8 9c 17 00 00       	call   801da4 <_panic>

int
sys_net_receive(uint32_t * buf, uint32_t *size)
{
	return syscall(SYS_net_recv, 1, (uint32_t)buf, (uint32_t)size, 0, 0, 0);
}
  800608:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80060b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80060e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800611:	89 ec                	mov    %ebp,%esp
  800613:	5d                   	pop    %ebp
  800614:	c3                   	ret    

00800615 <sys_net_send>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

int
sys_net_send(void *buf, uint32_t size)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	83 ec 38             	sub    $0x38,%esp
  80061b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80061e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800621:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800624:	bb 00 00 00 00       	mov    $0x0,%ebx
  800629:	b8 0e 00 00 00       	mov    $0xe,%eax
  80062e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800631:	8b 55 08             	mov    0x8(%ebp),%edx
  800634:	89 df                	mov    %ebx,%edi
  800636:	89 de                	mov    %ebx,%esi
  800638:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80063a:	85 c0                	test   %eax,%eax
  80063c:	7e 28                	jle    800666 <sys_net_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80063e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800642:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800649:	00 
  80064a:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  800651:	00 
  800652:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800659:	00 
  80065a:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  800661:	e8 3e 17 00 00       	call   801da4 <_panic>

int
sys_net_send(void *buf, uint32_t size)
{
	return syscall(SYS_net_send, 1, (uint32_t)buf, size, 0, 0, 0);
}
  800666:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800669:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80066c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80066f:	89 ec                	mov    %ebp,%esp
  800671:	5d                   	pop    %ebp
  800672:	c3                   	ret    

00800673 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
  800676:	83 ec 38             	sub    $0x38,%esp
  800679:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80067c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80067f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800682:	b9 00 00 00 00       	mov    $0x0,%ecx
  800687:	b8 0d 00 00 00       	mov    $0xd,%eax
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	89 cb                	mov    %ecx,%ebx
  800691:	89 cf                	mov    %ecx,%edi
  800693:	89 ce                	mov    %ecx,%esi
  800695:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800697:	85 c0                	test   %eax,%eax
  800699:	7e 28                	jle    8006c3 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80069b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80069f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8006a6:	00 
  8006a7:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  8006ae:	00 
  8006af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8006b6:	00 
  8006b7:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  8006be:	e8 e1 16 00 00       	call   801da4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8006c3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8006c6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8006c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8006cc:	89 ec                	mov    %ebp,%esp
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	83 ec 0c             	sub    $0xc,%esp
  8006d6:	89 1c 24             	mov    %ebx,(%esp)
  8006d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006e1:	be 00 00 00 00       	mov    $0x0,%esi
  8006e6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8006eb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8006ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8006f9:	8b 1c 24             	mov    (%esp),%ebx
  8006fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  800700:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800704:	89 ec                	mov    %ebp,%esp
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    

00800708 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	83 ec 38             	sub    $0x38,%esp
  80070e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800711:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800714:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800717:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800721:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800724:	8b 55 08             	mov    0x8(%ebp),%edx
  800727:	89 df                	mov    %ebx,%edi
  800729:	89 de                	mov    %ebx,%esi
  80072b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80072d:	85 c0                	test   %eax,%eax
  80072f:	7e 28                	jle    800759 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800731:	89 44 24 10          	mov    %eax,0x10(%esp)
  800735:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80073c:	00 
  80073d:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  800744:	00 
  800745:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80074c:	00 
  80074d:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  800754:	e8 4b 16 00 00       	call   801da4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800759:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80075c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80075f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800762:	89 ec                	mov    %ebp,%esp
  800764:	5d                   	pop    %ebp
  800765:	c3                   	ret    

00800766 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	83 ec 38             	sub    $0x38,%esp
  80076c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80076f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800772:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800775:	bb 00 00 00 00       	mov    $0x0,%ebx
  80077a:	b8 09 00 00 00       	mov    $0x9,%eax
  80077f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800782:	8b 55 08             	mov    0x8(%ebp),%edx
  800785:	89 df                	mov    %ebx,%edi
  800787:	89 de                	mov    %ebx,%esi
  800789:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80078b:	85 c0                	test   %eax,%eax
  80078d:	7e 28                	jle    8007b7 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80078f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800793:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80079a:	00 
  80079b:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  8007a2:	00 
  8007a3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8007aa:	00 
  8007ab:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  8007b2:	e8 ed 15 00 00       	call   801da4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8007b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8007bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8007c0:	89 ec                	mov    %ebp,%esp
  8007c2:	5d                   	pop    %ebp
  8007c3:	c3                   	ret    

008007c4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	83 ec 38             	sub    $0x38,%esp
  8007ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8007cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8007d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8007dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8007e3:	89 df                	mov    %ebx,%edi
  8007e5:	89 de                	mov    %ebx,%esi
  8007e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	7e 28                	jle    800815 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007f1:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8007f8:	00 
  8007f9:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  800800:	00 
  800801:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800808:	00 
  800809:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  800810:	e8 8f 15 00 00       	call   801da4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800815:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800818:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80081b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80081e:	89 ec                	mov    %ebp,%esp
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 38             	sub    $0x38,%esp
  800828:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80082b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80082e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800831:	bb 00 00 00 00       	mov    $0x0,%ebx
  800836:	b8 06 00 00 00       	mov    $0x6,%eax
  80083b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083e:	8b 55 08             	mov    0x8(%ebp),%edx
  800841:	89 df                	mov    %ebx,%edi
  800843:	89 de                	mov    %ebx,%esi
  800845:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800847:	85 c0                	test   %eax,%eax
  800849:	7e 28                	jle    800873 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80084b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80084f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800856:	00 
  800857:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  80085e:	00 
  80085f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800866:	00 
  800867:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  80086e:	e8 31 15 00 00       	call   801da4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800873:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800876:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800879:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80087c:	89 ec                	mov    %ebp,%esp
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 38             	sub    $0x38,%esp
  800886:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800889:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80088c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80088f:	b8 05 00 00 00       	mov    $0x5,%eax
  800894:	8b 75 18             	mov    0x18(%ebp),%esi
  800897:	8b 7d 14             	mov    0x14(%ebp),%edi
  80089a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80089d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	7e 28                	jle    8008d1 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008ad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8008b4:	00 
  8008b5:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  8008bc:	00 
  8008bd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008c4:	00 
  8008c5:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  8008cc:	e8 d3 14 00 00       	call   801da4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8008d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8008d4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8008d7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8008da:	89 ec                	mov    %ebp,%esp
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	83 ec 38             	sub    $0x38,%esp
  8008e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008ed:	be 00 00 00 00       	mov    $0x0,%esi
  8008f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8008f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800900:	89 f7                	mov    %esi,%edi
  800902:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800904:	85 c0                	test   %eax,%eax
  800906:	7e 28                	jle    800930 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800908:	89 44 24 10          	mov    %eax,0x10(%esp)
  80090c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800913:	00 
  800914:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  80091b:	00 
  80091c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800923:	00 
  800924:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  80092b:	e8 74 14 00 00       	call   801da4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800930:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800933:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800936:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800939:	89 ec                	mov    %ebp,%esp
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 0c             	sub    $0xc,%esp
  800943:	89 1c 24             	mov    %ebx,(%esp)
  800946:	89 74 24 04          	mov    %esi,0x4(%esp)
  80094a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80094e:	ba 00 00 00 00       	mov    $0x0,%edx
  800953:	b8 0b 00 00 00       	mov    $0xb,%eax
  800958:	89 d1                	mov    %edx,%ecx
  80095a:	89 d3                	mov    %edx,%ebx
  80095c:	89 d7                	mov    %edx,%edi
  80095e:	89 d6                	mov    %edx,%esi
  800960:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800962:	8b 1c 24             	mov    (%esp),%ebx
  800965:	8b 74 24 04          	mov    0x4(%esp),%esi
  800969:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80096d:	89 ec                	mov    %ebp,%esp
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	89 1c 24             	mov    %ebx,(%esp)
  80097a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80097e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800982:	ba 00 00 00 00       	mov    $0x0,%edx
  800987:	b8 02 00 00 00       	mov    $0x2,%eax
  80098c:	89 d1                	mov    %edx,%ecx
  80098e:	89 d3                	mov    %edx,%ebx
  800990:	89 d7                	mov    %edx,%edi
  800992:	89 d6                	mov    %edx,%esi
  800994:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800996:	8b 1c 24             	mov    (%esp),%ebx
  800999:	8b 74 24 04          	mov    0x4(%esp),%esi
  80099d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009a1:	89 ec                	mov    %ebp,%esp
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 38             	sub    $0x38,%esp
  8009ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009be:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c1:	89 cb                	mov    %ecx,%ebx
  8009c3:	89 cf                	mov    %ecx,%edi
  8009c5:	89 ce                	mov    %ecx,%esi
  8009c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	7e 28                	jle    8009f5 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009d1:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8009d8:	00 
  8009d9:	c7 44 24 08 6f 28 80 	movl   $0x80286f,0x8(%esp)
  8009e0:	00 
  8009e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8009e8:	00 
  8009e9:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  8009f0:	e8 af 13 00 00       	call   801da4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8009f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009fe:	89 ec                	mov    %ebp,%esp
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    
	...

00800a04 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	05 00 00 00 30       	add    $0x30000000,%eax
  800a0f:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	89 04 24             	mov    %eax,(%esp)
  800a20:	e8 df ff ff ff       	call   800a04 <fd2num>
  800a25:	05 20 00 0d 00       	add    $0xd0020,%eax
  800a2a:	c1 e0 0c             	shl    $0xc,%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a38:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800a3d:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800a42:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800a47:	89 c6                	mov    %eax,%esi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800a49:	89 c2                	mov    %eax,%edx
  800a4b:	c1 ea 16             	shr    $0x16,%edx
  800a4e:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  800a51:	f6 c2 01             	test   $0x1,%dl
  800a54:	74 0d                	je     800a63 <fd_alloc+0x34>
  800a56:	89 c2                	mov    %eax,%edx
  800a58:	c1 ea 0c             	shr    $0xc,%edx
  800a5b:	8b 14 93             	mov    (%ebx,%edx,4),%edx
  800a5e:	f6 c2 01             	test   $0x1,%dl
  800a61:	75 09                	jne    800a6c <fd_alloc+0x3d>
			*fd_store = fd;
  800a63:	89 37                	mov    %esi,(%edi)
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800a6a:	eb 17                	jmp    800a83 <fd_alloc+0x54>
  800a6c:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800a71:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800a76:	75 cf                	jne    800a47 <fd_alloc+0x18>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800a78:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800a7e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	83 f8 1f             	cmp    $0x1f,%eax
  800a91:	77 36                	ja     800ac9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800a93:	05 00 00 0d 00       	add    $0xd0000,%eax
  800a98:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800a9b:	89 c2                	mov    %eax,%edx
  800a9d:	c1 ea 16             	shr    $0x16,%edx
  800aa0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800aa7:	f6 c2 01             	test   $0x1,%dl
  800aaa:	74 1d                	je     800ac9 <fd_lookup+0x41>
  800aac:	89 c2                	mov    %eax,%edx
  800aae:	c1 ea 0c             	shr    $0xc,%edx
  800ab1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ab8:	f6 c2 01             	test   $0x1,%dl
  800abb:	74 0c                	je     800ac9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac0:	89 02                	mov    %eax,(%edx)
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  800ac7:	eb 05                	jmp    800ace <fd_lookup+0x46>
  800ac9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ad6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	89 04 24             	mov    %eax,(%esp)
  800ae3:	e8 a0 ff ff ff       	call   800a88 <fd_lookup>
  800ae8:	85 c0                	test   %eax,%eax
  800aea:	78 0e                	js     800afa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 50 04             	mov    %edx,0x4(%eax)
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	56                   	push   %esi
  800b00:	53                   	push   %ebx
  800b01:	83 ec 10             	sub    $0x10,%esp
  800b04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800b0f:	be 18 29 80 00       	mov    $0x802918,%esi
  800b14:	eb 10                	jmp    800b26 <dev_lookup+0x2a>
		if (devtab[i]->dev_id == dev_id) {
  800b16:	39 08                	cmp    %ecx,(%eax)
  800b18:	75 09                	jne    800b23 <dev_lookup+0x27>
			*dev = devtab[i];
  800b1a:	89 03                	mov    %eax,(%ebx)
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800b21:	eb 31                	jmp    800b54 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800b29:	85 c0                	test   %eax,%eax
  800b2b:	75 e9                	jne    800b16 <dev_lookup+0x1a>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800b2d:	a1 08 40 80 00       	mov    0x804008,%eax
  800b32:	8b 40 48             	mov    0x48(%eax),%eax
  800b35:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b3d:	c7 04 24 9c 28 80 00 	movl   $0x80289c,(%esp)
  800b44:	e8 14 13 00 00       	call   801e5d <cprintf>
	*dev = 0;
  800b49:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800b54:	83 c4 10             	add    $0x10,%esp
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	53                   	push   %ebx
  800b5f:	83 ec 24             	sub    $0x24,%esp
  800b62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b65:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 04 24             	mov    %eax,(%esp)
  800b72:	e8 11 ff ff ff       	call   800a88 <fd_lookup>
  800b77:	85 c0                	test   %eax,%eax
  800b79:	78 53                	js     800bce <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	89 04 24             	mov    %eax,(%esp)
  800b8a:	e8 6d ff ff ff       	call   800afc <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	78 3b                	js     800bce <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800b93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  800b9f:	74 2d                	je     800bce <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800ba1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800ba4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800bab:	00 00 00 
	stat->st_isdir = 0;
  800bae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bb5:	00 00 00 
	stat->st_dev = dev;
  800bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bbb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800bc1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800bc8:	89 14 24             	mov    %edx,(%esp)
  800bcb:	ff 50 14             	call   *0x14(%eax)
}
  800bce:	83 c4 24             	add    $0x24,%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	53                   	push   %ebx
  800bd8:	83 ec 24             	sub    $0x24,%esp
  800bdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bde:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be5:	89 1c 24             	mov    %ebx,(%esp)
  800be8:	e8 9b fe ff ff       	call   800a88 <fd_lookup>
  800bed:	85 c0                	test   %eax,%eax
  800bef:	78 5f                	js     800c50 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bf1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	89 04 24             	mov    %eax,(%esp)
  800c00:	e8 f7 fe ff ff       	call   800afc <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c05:	85 c0                	test   %eax,%eax
  800c07:	78 47                	js     800c50 <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c0c:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800c10:	75 23                	jne    800c35 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800c12:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c17:	8b 40 48             	mov    0x48(%eax),%eax
  800c1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c22:	c7 04 24 bc 28 80 00 	movl   $0x8028bc,(%esp)
  800c29:	e8 2f 12 00 00       	call   801e5d <cprintf>
  800c2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800c33:	eb 1b                	jmp    800c50 <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c38:	8b 48 18             	mov    0x18(%eax),%ecx
  800c3b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c40:	85 c9                	test   %ecx,%ecx
  800c42:	74 0c                	je     800c50 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4b:	89 14 24             	mov    %edx,(%esp)
  800c4e:	ff d1                	call   *%ecx
}
  800c50:	83 c4 24             	add    $0x24,%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 24             	sub    $0x24,%esp
  800c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c67:	89 1c 24             	mov    %ebx,(%esp)
  800c6a:	e8 19 fe ff ff       	call   800a88 <fd_lookup>
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	78 66                	js     800cd9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	89 04 24             	mov    %eax,(%esp)
  800c82:	e8 75 fe ff ff       	call   800afc <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c87:	85 c0                	test   %eax,%eax
  800c89:	78 4e                	js     800cd9 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c8e:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800c92:	75 23                	jne    800cb7 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c94:	a1 08 40 80 00       	mov    0x804008,%eax
  800c99:	8b 40 48             	mov    0x48(%eax),%eax
  800c9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ca4:	c7 04 24 dd 28 80 00 	movl   $0x8028dd,(%esp)
  800cab:	e8 ad 11 00 00       	call   801e5d <cprintf>
  800cb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800cb5:	eb 22                	jmp    800cd9 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cba:	8b 48 0c             	mov    0xc(%eax),%ecx
  800cbd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cc2:	85 c9                	test   %ecx,%ecx
  800cc4:	74 13                	je     800cd9 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd4:	89 14 24             	mov    %edx,(%esp)
  800cd7:	ff d1                	call   *%ecx
}
  800cd9:	83 c4 24             	add    $0x24,%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 24             	sub    $0x24,%esp
  800ce6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ce9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf0:	89 1c 24             	mov    %ebx,(%esp)
  800cf3:	e8 90 fd ff ff       	call   800a88 <fd_lookup>
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	78 6b                	js     800d67 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d06:	8b 00                	mov    (%eax),%eax
  800d08:	89 04 24             	mov    %eax,(%esp)
  800d0b:	e8 ec fd ff ff       	call   800afc <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d10:	85 c0                	test   %eax,%eax
  800d12:	78 53                	js     800d67 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800d14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d17:	8b 42 08             	mov    0x8(%edx),%eax
  800d1a:	83 e0 03             	and    $0x3,%eax
  800d1d:	83 f8 01             	cmp    $0x1,%eax
  800d20:	75 23                	jne    800d45 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800d22:	a1 08 40 80 00       	mov    0x804008,%eax
  800d27:	8b 40 48             	mov    0x48(%eax),%eax
  800d2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d32:	c7 04 24 fa 28 80 00 	movl   $0x8028fa,(%esp)
  800d39:	e8 1f 11 00 00       	call   801e5d <cprintf>
  800d3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800d43:	eb 22                	jmp    800d67 <read+0x88>
	}
	if (!dev->dev_read)
  800d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d48:	8b 48 08             	mov    0x8(%eax),%ecx
  800d4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d50:	85 c9                	test   %ecx,%ecx
  800d52:	74 13                	je     800d67 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d62:	89 14 24             	mov    %edx,(%esp)
  800d65:	ff d1                	call   *%ecx
}
  800d67:	83 c4 24             	add    $0x24,%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 1c             	sub    $0x1c,%esp
  800d76:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d79:	8b 75 10             	mov    0x10(%ebp),%esi
  800d7c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d81:	eb 21                	jmp    800da4 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d83:	89 f2                	mov    %esi,%edx
  800d85:	29 c2                	sub    %eax,%edx
  800d87:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d8b:	03 45 0c             	add    0xc(%ebp),%eax
  800d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d92:	89 3c 24             	mov    %edi,(%esp)
  800d95:	e8 45 ff ff ff       	call   800cdf <read>
		if (m < 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	78 0e                	js     800dac <readn+0x3f>
			return m;
		if (m == 0)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	74 08                	je     800daa <readn+0x3d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800da2:	01 c3                	add    %eax,%ebx
  800da4:	89 d8                	mov    %ebx,%eax
  800da6:	39 f3                	cmp    %esi,%ebx
  800da8:	72 d9                	jb     800d83 <readn+0x16>
  800daa:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800dac:	83 c4 1c             	add    $0x1c,%esp
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 38             	sub    $0x38,%esp
  800dba:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800dc3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dc6:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800dca:	89 3c 24             	mov    %edi,(%esp)
  800dcd:	e8 32 fc ff ff       	call   800a04 <fd2num>
  800dd2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800dd5:	89 54 24 04          	mov    %edx,0x4(%esp)
  800dd9:	89 04 24             	mov    %eax,(%esp)
  800ddc:	e8 a7 fc ff ff       	call   800a88 <fd_lookup>
  800de1:	89 c3                	mov    %eax,%ebx
  800de3:	85 c0                	test   %eax,%eax
  800de5:	78 05                	js     800dec <fd_close+0x38>
  800de7:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  800dea:	74 0e                	je     800dfa <fd_close+0x46>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800dec:	89 f0                	mov    %esi,%eax
  800dee:	84 c0                	test   %al,%al
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	0f 44 d8             	cmove  %eax,%ebx
  800df8:	eb 3d                	jmp    800e37 <fd_close+0x83>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800dfa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e01:	8b 07                	mov    (%edi),%eax
  800e03:	89 04 24             	mov    %eax,(%esp)
  800e06:	e8 f1 fc ff ff       	call   800afc <dev_lookup>
  800e0b:	89 c3                	mov    %eax,%ebx
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	78 16                	js     800e27 <fd_close+0x73>
		if (dev->dev_close)
  800e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e14:	8b 40 10             	mov    0x10(%eax),%eax
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	74 07                	je     800e27 <fd_close+0x73>
			r = (*dev->dev_close)(fd);
  800e20:	89 3c 24             	mov    %edi,(%esp)
  800e23:	ff d0                	call   *%eax
  800e25:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800e27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e32:	e8 eb f9 ff ff       	call   800822 <sys_page_unmap>
	return r;
}
  800e37:	89 d8                	mov    %ebx,%eax
  800e39:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e42:	89 ec                	mov    %ebp,%esp
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	89 04 24             	mov    %eax,(%esp)
  800e59:	e8 2a fc ff ff       	call   800a88 <fd_lookup>
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	78 13                	js     800e75 <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800e62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800e69:	00 
  800e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6d:	89 04 24             	mov    %eax,(%esp)
  800e70:	e8 3f ff ff ff       	call   800db4 <fd_close>
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 18             	sub    $0x18,%esp
  800e7d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800e80:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e83:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800e8a:	00 
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 04 24             	mov    %eax,(%esp)
  800e91:	e8 25 04 00 00       	call   8012bb <open>
  800e96:	89 c3                	mov    %eax,%ebx
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	78 1b                	js     800eb7 <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea3:	89 1c 24             	mov    %ebx,(%esp)
  800ea6:	e8 b0 fc ff ff       	call   800b5b <fstat>
  800eab:	89 c6                	mov    %eax,%esi
	close(fd);
  800ead:	89 1c 24             	mov    %ebx,(%esp)
  800eb0:	e8 91 ff ff ff       	call   800e46 <close>
  800eb5:	89 f3                	mov    %esi,%ebx
	return r;
}
  800eb7:	89 d8                	mov    %ebx,%eax
  800eb9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ebc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ebf:	89 ec                	mov    %ebp,%esp
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	53                   	push   %ebx
  800ec7:	83 ec 14             	sub    $0x14,%esp
  800eca:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  800ecf:	89 1c 24             	mov    %ebx,(%esp)
  800ed2:	e8 6f ff ff ff       	call   800e46 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800ed7:	83 c3 01             	add    $0x1,%ebx
  800eda:	83 fb 20             	cmp    $0x20,%ebx
  800edd:	75 f0                	jne    800ecf <close_all+0xc>
		close(i);
}
  800edf:	83 c4 14             	add    $0x14,%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 58             	sub    $0x58,%esp
  800eeb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800ef4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ef7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800efa:	89 44 24 04          	mov    %eax,0x4(%esp)
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 04 24             	mov    %eax,(%esp)
  800f04:	e8 7f fb ff ff       	call   800a88 <fd_lookup>
  800f09:	89 c3                	mov    %eax,%ebx
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	0f 88 e0 00 00 00    	js     800ff3 <dup+0x10e>
		return r;
	close(newfdnum);
  800f13:	89 3c 24             	mov    %edi,(%esp)
  800f16:	e8 2b ff ff ff       	call   800e46 <close>

	newfd = INDEX2FD(newfdnum);
  800f1b:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  800f21:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  800f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f27:	89 04 24             	mov    %eax,(%esp)
  800f2a:	e8 e5 fa ff ff       	call   800a14 <fd2data>
  800f2f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f31:	89 34 24             	mov    %esi,(%esp)
  800f34:	e8 db fa ff ff       	call   800a14 <fd2data>
  800f39:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f3c:	89 da                	mov    %ebx,%edx
  800f3e:	89 d8                	mov    %ebx,%eax
  800f40:	c1 e8 16             	shr    $0x16,%eax
  800f43:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f4a:	a8 01                	test   $0x1,%al
  800f4c:	74 43                	je     800f91 <dup+0xac>
  800f4e:	c1 ea 0c             	shr    $0xc,%edx
  800f51:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800f58:	a8 01                	test   $0x1,%al
  800f5a:	74 35                	je     800f91 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800f5c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800f63:	25 07 0e 00 00       	and    $0xe07,%eax
  800f68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f73:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f7a:	00 
  800f7b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f86:	e8 f5 f8 ff ff       	call   800880 <sys_page_map>
  800f8b:	89 c3                	mov    %eax,%ebx
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	78 3f                	js     800fd0 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f94:	89 c2                	mov    %eax,%edx
  800f96:	c1 ea 0c             	shr    $0xc,%edx
  800f99:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fa0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fa6:	89 54 24 10          	mov    %edx,0x10(%esp)
  800faa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800fae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800fb5:	00 
  800fb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fc1:	e8 ba f8 ff ff       	call   800880 <sys_page_map>
  800fc6:	89 c3                	mov    %eax,%ebx
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	78 04                	js     800fd0 <dup+0xeb>
  800fcc:	89 fb                	mov    %edi,%ebx
  800fce:	eb 23                	jmp    800ff3 <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800fd0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fdb:	e8 42 f8 ff ff       	call   800822 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fe0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fee:	e8 2f f8 ff ff       	call   800822 <sys_page_unmap>
	return r;
}
  800ff3:	89 d8                	mov    %ebx,%eax
  800ff5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ffb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ffe:	89 ec                	mov    %ebp,%esp
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    
	...

00801004 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 10             	sub    $0x10,%esp
  80100c:	89 c3                	mov    %eax,%ebx
  80100e:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801010:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801017:	75 11                	jne    80102a <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801019:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801020:	e8 5f 14 00 00       	call   802484 <ipc_find_env>
  801025:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	//if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  80102a:	a1 08 40 80 00       	mov    0x804008,%eax
  80102f:	8b 40 48             	mov    0x48(%eax),%eax
  801032:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801038:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80103c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801040:	89 44 24 04          	mov    %eax,0x4(%esp)
  801044:	c7 04 24 2c 29 80 00 	movl   $0x80292c,(%esp)
  80104b:	e8 0d 0e 00 00       	call   801e5d <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801050:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801057:	00 
  801058:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80105f:	00 
  801060:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801064:	a1 00 40 80 00       	mov    0x804000,%eax
  801069:	89 04 24             	mov    %eax,(%esp)
  80106c:	e8 49 14 00 00       	call   8024ba <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801071:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801078:	00 
  801079:	89 74 24 04          	mov    %esi,0x4(%esp)
  80107d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801084:	e8 9d 14 00 00       	call   802526 <ipc_recv>
}
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8b 40 0c             	mov    0xc(%eax),%eax
  80109c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8010a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b3:	e8 4c ff ff ff       	call   801004 <fsipc>
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8010c6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8010cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8010d5:	e8 2a ff ff ff       	call   801004 <fsipc>
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8010e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ec:	e8 13 ff ff ff       	call   801004 <fsipc>
}
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <devfile_stat>:
	return ret;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	53                   	push   %ebx
  8010f7:	83 ec 14             	sub    $0x14,%esp
  8010fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8b 40 0c             	mov    0xc(%eax),%eax
  801103:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801108:	ba 00 00 00 00       	mov    $0x0,%edx
  80110d:	b8 05 00 00 00       	mov    $0x5,%eax
  801112:	e8 ed fe ff ff       	call   801004 <fsipc>
  801117:	85 c0                	test   %eax,%eax
  801119:	78 2b                	js     801146 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80111b:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801122:	00 
  801123:	89 1c 24             	mov    %ebx,(%esp)
  801126:	e8 6e f0 ff ff       	call   800199 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80112b:	a1 80 50 80 00       	mov    0x805080,%eax
  801130:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801136:	a1 84 50 80 00       	mov    0x805084,%eax
  80113b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801146:	83 c4 14             	add    $0x14,%esp
  801149:	5b                   	pop    %ebx
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	53                   	push   %ebx
  801150:	83 ec 14             	sub    $0x14,%esp
  801153:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	int ret;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8b 40 0c             	mov    0xc(%eax),%eax
  80115c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801161:	89 1d 04 50 80 00    	mov    %ebx,0x805004

	assert(n<=PGSIZE);
  801167:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80116d:	76 24                	jbe    801193 <devfile_write+0x47>
  80116f:	c7 44 24 0c 42 29 80 	movl   $0x802942,0xc(%esp)
  801176:	00 
  801177:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  80117e:	00 
  80117f:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  801186:	00 
  801187:	c7 04 24 61 29 80 00 	movl   $0x802961,(%esp)
  80118e:	e8 11 0c 00 00       	call   801da4 <_panic>
	memmove(fsipcbuf.write.req_buf,buf,n);
  801193:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80119e:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8011a5:	e8 95 f1 ff ff       	call   80033f <memmove>

	ret = fsipc(FSREQ_WRITE, NULL);
  8011aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8011af:	b8 04 00 00 00       	mov    $0x4,%eax
  8011b4:	e8 4b fe ff ff       	call   801004 <fsipc>
	if(ret<0) return ret;
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 53                	js     801210 <devfile_write+0xc4>
	
	assert(ret <= n);
  8011bd:	39 c3                	cmp    %eax,%ebx
  8011bf:	73 24                	jae    8011e5 <devfile_write+0x99>
  8011c1:	c7 44 24 0c 6c 29 80 	movl   $0x80296c,0xc(%esp)
  8011c8:	00 
  8011c9:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  8011d0:	00 
  8011d1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8011d8:	00 
  8011d9:	c7 04 24 61 29 80 00 	movl   $0x802961,(%esp)
  8011e0:	e8 bf 0b 00 00       	call   801da4 <_panic>
	assert(ret <= PGSIZE);
  8011e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8011ea:	7e 24                	jle    801210 <devfile_write+0xc4>
  8011ec:	c7 44 24 0c 75 29 80 	movl   $0x802975,0xc(%esp)
  8011f3:	00 
  8011f4:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  8011fb:	00 
  8011fc:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801203:	00 
  801204:	c7 04 24 61 29 80 00 	movl   $0x802961,(%esp)
  80120b:	e8 94 0b 00 00       	call   801da4 <_panic>
	return ret;
}
  801210:	83 c4 14             	add    $0x14,%esp
  801213:	5b                   	pop    %ebx
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    

00801216 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 10             	sub    $0x10,%esp
  80121e:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8b 40 0c             	mov    0xc(%eax),%eax
  801227:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80122c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801232:	ba 00 00 00 00       	mov    $0x0,%edx
  801237:	b8 03 00 00 00       	mov    $0x3,%eax
  80123c:	e8 c3 fd ff ff       	call   801004 <fsipc>
  801241:	89 c3                	mov    %eax,%ebx
  801243:	85 c0                	test   %eax,%eax
  801245:	78 6b                	js     8012b2 <devfile_read+0x9c>
		return r;
	assert(r <= n);
  801247:	39 de                	cmp    %ebx,%esi
  801249:	73 24                	jae    80126f <devfile_read+0x59>
  80124b:	c7 44 24 0c 83 29 80 	movl   $0x802983,0xc(%esp)
  801252:	00 
  801253:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  80125a:	00 
  80125b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801262:	00 
  801263:	c7 04 24 61 29 80 00 	movl   $0x802961,(%esp)
  80126a:	e8 35 0b 00 00       	call   801da4 <_panic>
	assert(r <= PGSIZE);
  80126f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801275:	7e 24                	jle    80129b <devfile_read+0x85>
  801277:	c7 44 24 0c 8a 29 80 	movl   $0x80298a,0xc(%esp)
  80127e:	00 
  80127f:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  801286:	00 
  801287:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  80128e:	00 
  80128f:	c7 04 24 61 29 80 00 	movl   $0x802961,(%esp)
  801296:	e8 09 0b 00 00       	call   801da4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80129b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8012a6:	00 
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	89 04 24             	mov    %eax,(%esp)
  8012ad:	e8 8d f0 ff ff       	call   80033f <memmove>
	return r;
}
  8012b2:	89 d8                	mov    %ebx,%eax
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 28             	sub    $0x28,%esp
  8012c1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8012c4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8012c7:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8012ca:	89 34 24             	mov    %esi,(%esp)
  8012cd:	e8 8e ee ff ff       	call   800160 <strlen>
  8012d2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8012d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8012dc:	7f 5e                	jg     80133c <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8012de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e1:	89 04 24             	mov    %eax,(%esp)
  8012e4:	e8 46 f7 ff ff       	call   800a2f <fd_alloc>
  8012e9:	89 c3                	mov    %eax,%ebx
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 4d                	js     80133c <open+0x81>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8012ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f3:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8012fa:	e8 9a ee ff ff       	call   800199 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801302:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130a:	b8 01 00 00 00       	mov    $0x1,%eax
  80130f:	e8 f0 fc ff ff       	call   801004 <fsipc>
  801314:	89 c3                	mov    %eax,%ebx
  801316:	85 c0                	test   %eax,%eax
  801318:	79 15                	jns    80132f <open+0x74>
		fd_close(fd, 0);
  80131a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801321:	00 
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	89 04 24             	mov    %eax,(%esp)
  801328:	e8 87 fa ff ff       	call   800db4 <fd_close>
		return r;
  80132d:	eb 0d                	jmp    80133c <open+0x81>
	}

	return fd2num(fd);
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	89 04 24             	mov    %eax,(%esp)
  801335:	e8 ca f6 ff ff       	call   800a04 <fd2num>
  80133a:	89 c3                	mov    %eax,%ebx
}
  80133c:	89 d8                	mov    %ebx,%eax
  80133e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801341:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801344:	89 ec                	mov    %ebp,%esp
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    
	...

00801350 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801356:	c7 44 24 04 96 29 80 	movl   $0x802996,0x4(%esp)
  80135d:	00 
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	89 04 24             	mov    %eax,(%esp)
  801364:	e8 30 ee ff ff       	call   800199 <strcpy>
	return 0;
}
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	53                   	push   %ebx
  801374:	83 ec 14             	sub    $0x14,%esp
  801377:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80137a:	89 1c 24             	mov    %ebx,(%esp)
  80137d:	e8 2e 12 00 00       	call   8025b0 <pageref>
  801382:	89 c2                	mov    %eax,%edx
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	83 fa 01             	cmp    $0x1,%edx
  80138c:	75 0b                	jne    801399 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80138e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801391:	89 04 24             	mov    %eax,(%esp)
  801394:	e8 b1 02 00 00       	call   80164a <nsipc_close>
	else
		return 0;
}
  801399:	83 c4 14             	add    $0x14,%esp
  80139c:	5b                   	pop    %ebx
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    

0080139f <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8013a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013ac:	00 
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c1:	89 04 24             	mov    %eax,(%esp)
  8013c4:	e8 bd 02 00 00       	call   801686 <nsipc_send>
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8013d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013d8:	00 
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ed:	89 04 24             	mov    %eax,(%esp)
  8013f0:	e8 04 03 00 00       	call   8016f9 <nsipc_recv>
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	56                   	push   %esi
  8013fb:	53                   	push   %ebx
  8013fc:	83 ec 20             	sub    $0x20,%esp
  8013ff:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801401:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801404:	89 04 24             	mov    %eax,(%esp)
  801407:	e8 23 f6 ff ff       	call   800a2f <fd_alloc>
  80140c:	89 c3                	mov    %eax,%ebx
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 21                	js     801433 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801412:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801419:	00 
  80141a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801421:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801428:	e8 b1 f4 ff ff       	call   8008de <sys_page_alloc>
  80142d:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80142f:	85 c0                	test   %eax,%eax
  801431:	79 0a                	jns    80143d <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  801433:	89 34 24             	mov    %esi,(%esp)
  801436:	e8 0f 02 00 00       	call   80164a <nsipc_close>
		return r;
  80143b:	eb 28                	jmp    801465 <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80143d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801446:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145b:	89 04 24             	mov    %eax,(%esp)
  80145e:	e8 a1 f5 ff ff       	call   800a04 <fd2num>
  801463:	89 c3                	mov    %eax,%ebx
}
  801465:	89 d8                	mov    %ebx,%eax
  801467:	83 c4 20             	add    $0x20,%esp
  80146a:	5b                   	pop    %ebx
  80146b:	5e                   	pop    %esi
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	89 04 24             	mov    %eax,(%esp)
  801488:	e8 71 01 00 00       	call   8015fe <nsipc_socket>
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 05                	js     801496 <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801491:	e8 61 ff ff ff       	call   8013f7 <alloc_sockfd>
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80149e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014a5:	89 04 24             	mov    %eax,(%esp)
  8014a8:	e8 db f5 ff ff       	call   800a88 <fd_lookup>
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 15                	js     8014c6 <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8014b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b4:	8b 0a                	mov    (%edx),%ecx
  8014b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014bb:	3b 0d 20 30 80 00    	cmp    0x803020,%ecx
  8014c1:	75 03                	jne    8014c6 <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8014c3:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	e8 c2 ff ff ff       	call   801498 <fd2sockid>
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 0f                	js     8014e9 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8014da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014e1:	89 04 24             	mov    %eax,(%esp)
  8014e4:	e8 3f 01 00 00       	call   801628 <nsipc_listen>
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	e8 9f ff ff ff       	call   801498 <fd2sockid>
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 16                	js     801513 <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8014fd:	8b 55 10             	mov    0x10(%ebp),%edx
  801500:	89 54 24 08          	mov    %edx,0x8(%esp)
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	89 54 24 04          	mov    %edx,0x4(%esp)
  80150b:	89 04 24             	mov    %eax,(%esp)
  80150e:	e8 66 02 00 00       	call   801779 <nsipc_connect>
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	e8 75 ff ff ff       	call   801498 <fd2sockid>
  801523:	85 c0                	test   %eax,%eax
  801525:	78 0f                	js     801536 <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80152e:	89 04 24             	mov    %eax,(%esp)
  801531:	e8 2e 01 00 00       	call   801664 <nsipc_shutdown>
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	e8 52 ff ff ff       	call   801498 <fd2sockid>
  801546:	85 c0                	test   %eax,%eax
  801548:	78 16                	js     801560 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80154a:	8b 55 10             	mov    0x10(%ebp),%edx
  80154d:	89 54 24 08          	mov    %edx,0x8(%esp)
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 54 24 04          	mov    %edx,0x4(%esp)
  801558:	89 04 24             	mov    %eax,(%esp)
  80155b:	e8 58 02 00 00       	call   8017b8 <nsipc_bind>
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	e8 28 ff ff ff       	call   801498 <fd2sockid>
  801570:	85 c0                	test   %eax,%eax
  801572:	78 1f                	js     801593 <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801574:	8b 55 10             	mov    0x10(%ebp),%edx
  801577:	89 54 24 08          	mov    %edx,0x8(%esp)
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801582:	89 04 24             	mov    %eax,(%esp)
  801585:	e8 6d 02 00 00       	call   8017f7 <nsipc_accept>
  80158a:	85 c0                	test   %eax,%eax
  80158c:	78 05                	js     801593 <accept+0x31>
		return r;
	return alloc_sockfd(r);
  80158e:	e8 64 fe ff ff       	call   8013f7 <alloc_sockfd>
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    
  801595:	00 00                	add    %al,(%eax)
	...

00801598 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	53                   	push   %ebx
  80159c:	83 ec 14             	sub    $0x14,%esp
  80159f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8015a1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8015a8:	75 11                	jne    8015bb <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8015aa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8015b1:	e8 ce 0e 00 00       	call   802484 <ipc_find_env>
  8015b6:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8015bb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015c2:	00 
  8015c3:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8015ca:	00 
  8015cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015cf:	a1 04 40 80 00       	mov    0x804004,%eax
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	e8 de 0e 00 00       	call   8024ba <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8015dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015e3:	00 
  8015e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015eb:	00 
  8015ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f3:	e8 2e 0f 00 00       	call   802526 <ipc_recv>
}
  8015f8:	83 c4 14             	add    $0x14,%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801614:	8b 45 10             	mov    0x10(%ebp),%eax
  801617:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80161c:	b8 09 00 00 00       	mov    $0x9,%eax
  801621:	e8 72 ff ff ff       	call   801598 <nsipc>
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801636:	8b 45 0c             	mov    0xc(%ebp),%eax
  801639:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80163e:	b8 06 00 00 00       	mov    $0x6,%eax
  801643:	e8 50 ff ff ff       	call   801598 <nsipc>
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801658:	b8 04 00 00 00       	mov    $0x4,%eax
  80165d:	e8 36 ff ff ff       	call   801598 <nsipc>
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801672:	8b 45 0c             	mov    0xc(%ebp),%eax
  801675:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80167a:	b8 03 00 00 00       	mov    $0x3,%eax
  80167f:	e8 14 ff ff ff       	call   801598 <nsipc>
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 14             	sub    $0x14,%esp
  80168d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801698:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80169e:	7e 24                	jle    8016c4 <nsipc_send+0x3e>
  8016a0:	c7 44 24 0c a2 29 80 	movl   $0x8029a2,0xc(%esp)
  8016a7:	00 
  8016a8:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  8016af:	00 
  8016b0:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8016b7:	00 
  8016b8:	c7 04 24 ae 29 80 00 	movl   $0x8029ae,(%esp)
  8016bf:	e8 e0 06 00 00       	call   801da4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8016c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8016d6:	e8 64 ec ff ff       	call   80033f <memmove>
	nsipcbuf.send.req_size = size;
  8016db:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8016e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8016e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8016ee:	e8 a5 fe ff ff       	call   801598 <nsipc>
}
  8016f3:	83 c4 14             	add    $0x14,%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    

008016f9 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	56                   	push   %esi
  8016fd:	53                   	push   %ebx
  8016fe:	83 ec 10             	sub    $0x10,%esp
  801701:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80170c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801712:	8b 45 14             	mov    0x14(%ebp),%eax
  801715:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80171a:	b8 07 00 00 00       	mov    $0x7,%eax
  80171f:	e8 74 fe ff ff       	call   801598 <nsipc>
  801724:	89 c3                	mov    %eax,%ebx
  801726:	85 c0                	test   %eax,%eax
  801728:	78 46                	js     801770 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80172a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80172f:	7f 04                	jg     801735 <nsipc_recv+0x3c>
  801731:	39 c6                	cmp    %eax,%esi
  801733:	7d 24                	jge    801759 <nsipc_recv+0x60>
  801735:	c7 44 24 0c ba 29 80 	movl   $0x8029ba,0xc(%esp)
  80173c:	00 
  80173d:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  801744:	00 
  801745:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  80174c:	00 
  80174d:	c7 04 24 ae 29 80 00 	movl   $0x8029ae,(%esp)
  801754:	e8 4b 06 00 00       	call   801da4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801759:	89 44 24 08          	mov    %eax,0x8(%esp)
  80175d:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801764:	00 
  801765:	8b 45 0c             	mov    0xc(%ebp),%eax
  801768:	89 04 24             	mov    %eax,(%esp)
  80176b:	e8 cf eb ff ff       	call   80033f <memmove>
	}

	return r;
}
  801770:	89 d8                	mov    %ebx,%eax
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	53                   	push   %ebx
  80177d:	83 ec 14             	sub    $0x14,%esp
  801780:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80178b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80178f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801792:	89 44 24 04          	mov    %eax,0x4(%esp)
  801796:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80179d:	e8 9d eb ff ff       	call   80033f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8017a2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8017a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ad:	e8 e6 fd ff ff       	call   801598 <nsipc>
}
  8017b2:	83 c4 14             	add    $0x14,%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 14             	sub    $0x14,%esp
  8017bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8017ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d5:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8017dc:	e8 5e eb ff ff       	call   80033f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8017e1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8017e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ec:	e8 a7 fd ff ff       	call   801598 <nsipc>
}
  8017f1:	83 c4 14             	add    $0x14,%esp
  8017f4:	5b                   	pop    %ebx
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 28             	sub    $0x28,%esp
  8017fd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801800:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801803:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801806:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	nsipcbuf.accept.req_s = s;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801811:	8b 07                	mov    (%edi),%eax
  801813:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801818:	b8 01 00 00 00       	mov    $0x1,%eax
  80181d:	e8 76 fd ff ff       	call   801598 <nsipc>
  801822:	89 c6                	mov    %eax,%esi
  801824:	85 c0                	test   %eax,%eax
  801826:	78 22                	js     80184a <nsipc_accept+0x53>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801828:	bb 10 70 80 00       	mov    $0x807010,%ebx
  80182d:	8b 03                	mov    (%ebx),%eax
  80182f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801833:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80183a:	00 
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	89 04 24             	mov    %eax,(%esp)
  801841:	e8 f9 ea ff ff       	call   80033f <memmove>
		*addrlen = ret->ret_addrlen;
  801846:	8b 03                	mov    (%ebx),%eax
  801848:	89 07                	mov    %eax,(%edi)
	}
	return r;
}
  80184a:	89 f0                	mov    %esi,%eax
  80184c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80184f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801852:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801855:	89 ec                	mov    %ebp,%esp
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    
  801859:	00 00                	add    %al,(%eax)
	...

0080185c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 18             	sub    $0x18,%esp
  801862:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801865:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801868:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 9e f1 ff ff       	call   800a14 <fd2data>
  801876:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801878:	c7 44 24 04 cf 29 80 	movl   $0x8029cf,0x4(%esp)
  80187f:	00 
  801880:	89 34 24             	mov    %esi,(%esp)
  801883:	e8 11 e9 ff ff       	call   800199 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801888:	8b 43 04             	mov    0x4(%ebx),%eax
  80188b:	2b 03                	sub    (%ebx),%eax
  80188d:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801893:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80189a:	00 00 00 
	stat->st_dev = &devpipe;
  80189d:	c7 86 88 00 00 00 3c 	movl   $0x80303c,0x88(%esi)
  8018a4:	30 80 00 
	return 0;
}
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018af:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018b2:	89 ec                	mov    %ebp,%esp
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 14             	sub    $0x14,%esp
  8018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018cb:	e8 52 ef ff ff       	call   800822 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018d0:	89 1c 24             	mov    %ebx,(%esp)
  8018d3:	e8 3c f1 ff ff       	call   800a14 <fd2data>
  8018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e3:	e8 3a ef ff ff       	call   800822 <sys_page_unmap>
}
  8018e8:	83 c4 14             	add    $0x14,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	57                   	push   %edi
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 2c             	sub    $0x2c,%esp
  8018f7:	89 c7                	mov    %eax,%edi
  8018f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8018fc:	a1 08 40 80 00       	mov    0x804008,%eax
  801901:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801904:	89 3c 24             	mov    %edi,(%esp)
  801907:	e8 a4 0c 00 00       	call   8025b0 <pageref>
  80190c:	89 c6                	mov    %eax,%esi
  80190e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801911:	89 04 24             	mov    %eax,(%esp)
  801914:	e8 97 0c 00 00       	call   8025b0 <pageref>
  801919:	39 c6                	cmp    %eax,%esi
  80191b:	0f 94 c0             	sete   %al
  80191e:	0f b6 c0             	movzbl %al,%eax
		nn = thisenv->env_runs;
  801921:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801927:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80192a:	39 cb                	cmp    %ecx,%ebx
  80192c:	75 08                	jne    801936 <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80192e:	83 c4 2c             	add    $0x2c,%esp
  801931:	5b                   	pop    %ebx
  801932:	5e                   	pop    %esi
  801933:	5f                   	pop    %edi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801936:	83 f8 01             	cmp    $0x1,%eax
  801939:	75 c1                	jne    8018fc <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80193b:	8b 52 58             	mov    0x58(%edx),%edx
  80193e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801942:	89 54 24 08          	mov    %edx,0x8(%esp)
  801946:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80194a:	c7 04 24 d6 29 80 00 	movl   $0x8029d6,(%esp)
  801951:	e8 07 05 00 00       	call   801e5d <cprintf>
  801956:	eb a4                	jmp    8018fc <_pipeisclosed+0xe>

00801958 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	57                   	push   %edi
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
  80195e:	83 ec 1c             	sub    $0x1c,%esp
  801961:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801964:	89 34 24             	mov    %esi,(%esp)
  801967:	e8 a8 f0 ff ff       	call   800a14 <fd2data>
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	bf 00 00 00 00       	mov    $0x0,%edi
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801973:	eb 48                	jmp    8019bd <devpipe_write+0x65>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801975:	89 da                	mov    %ebx,%edx
  801977:	89 f0                	mov    %esi,%eax
  801979:	e8 70 ff ff ff       	call   8018ee <_pipeisclosed>
  80197e:	85 c0                	test   %eax,%eax
  801980:	74 07                	je     801989 <devpipe_write+0x31>
  801982:	b8 00 00 00 00       	mov    $0x0,%eax
  801987:	eb 3b                	jmp    8019c4 <devpipe_write+0x6c>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801989:	e8 af ef ff ff       	call   80093d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80198e:	8b 43 04             	mov    0x4(%ebx),%eax
  801991:	8b 13                	mov    (%ebx),%edx
  801993:	83 c2 20             	add    $0x20,%edx
  801996:	39 d0                	cmp    %edx,%eax
  801998:	73 db                	jae    801975 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80199a:	89 c2                	mov    %eax,%edx
  80199c:	c1 fa 1f             	sar    $0x1f,%edx
  80199f:	c1 ea 1b             	shr    $0x1b,%edx
  8019a2:	01 d0                	add    %edx,%eax
  8019a4:	83 e0 1f             	and    $0x1f,%eax
  8019a7:	29 d0                	sub    %edx,%eax
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ae:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8019b2:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019b6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019ba:	83 c7 01             	add    $0x1,%edi
  8019bd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019c0:	72 cc                	jb     80198e <devpipe_write+0x36>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8019c2:	89 f8                	mov    %edi,%eax
}
  8019c4:	83 c4 1c             	add    $0x1c,%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5f                   	pop    %edi
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    

008019cc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 28             	sub    $0x28,%esp
  8019d2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019d5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019d8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019db:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8019de:	89 3c 24             	mov    %edi,(%esp)
  8019e1:	e8 2e f0 ff ff       	call   800a14 <fd2data>
  8019e6:	89 c3                	mov    %eax,%ebx
  8019e8:	be 00 00 00 00       	mov    $0x0,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019ed:	eb 48                	jmp    801a37 <devpipe_read+0x6b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8019ef:	85 f6                	test   %esi,%esi
  8019f1:	74 04                	je     8019f7 <devpipe_read+0x2b>
				return i;
  8019f3:	89 f0                	mov    %esi,%eax
  8019f5:	eb 47                	jmp    801a3e <devpipe_read+0x72>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8019f7:	89 da                	mov    %ebx,%edx
  8019f9:	89 f8                	mov    %edi,%eax
  8019fb:	e8 ee fe ff ff       	call   8018ee <_pipeisclosed>
  801a00:	85 c0                	test   %eax,%eax
  801a02:	74 07                	je     801a0b <devpipe_read+0x3f>
  801a04:	b8 00 00 00 00       	mov    $0x0,%eax
  801a09:	eb 33                	jmp    801a3e <devpipe_read+0x72>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a0b:	e8 2d ef ff ff       	call   80093d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a10:	8b 03                	mov    (%ebx),%eax
  801a12:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a15:	74 d8                	je     8019ef <devpipe_read+0x23>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a17:	89 c2                	mov    %eax,%edx
  801a19:	c1 fa 1f             	sar    $0x1f,%edx
  801a1c:	c1 ea 1b             	shr    $0x1b,%edx
  801a1f:	01 d0                	add    %edx,%eax
  801a21:	83 e0 1f             	and    $0x1f,%eax
  801a24:	29 d0                	sub    %edx,%eax
  801a26:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801a31:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a34:	83 c6 01             	add    $0x1,%esi
  801a37:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a3a:	72 d4                	jb     801a10 <devpipe_read+0x44>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a3c:	89 f0                	mov    %esi,%eax
}
  801a3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a41:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a44:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a47:	89 ec                	mov    %ebp,%esp
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    

00801a4b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	89 04 24             	mov    %eax,(%esp)
  801a5e:	e8 25 f0 ff ff       	call   800a88 <fd_lookup>
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 15                	js     801a7c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	89 04 24             	mov    %eax,(%esp)
  801a6d:	e8 a2 ef ff ff       	call   800a14 <fd2data>
	return _pipeisclosed(fd, p);
  801a72:	89 c2                	mov    %eax,%edx
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	e8 72 fe ff ff       	call   8018ee <_pipeisclosed>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 48             	sub    $0x48,%esp
  801a84:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a87:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a8a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a90:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a93:	89 04 24             	mov    %eax,(%esp)
  801a96:	e8 94 ef ff ff       	call   800a2f <fd_alloc>
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	0f 88 42 01 00 00    	js     801be7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aa5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801aac:	00 
  801aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abb:	e8 1e ee ff ff       	call   8008de <sys_page_alloc>
  801ac0:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	0f 88 1d 01 00 00    	js     801be7 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801aca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801acd:	89 04 24             	mov    %eax,(%esp)
  801ad0:	e8 5a ef ff ff       	call   800a2f <fd_alloc>
  801ad5:	89 c3                	mov    %eax,%ebx
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	0f 88 f5 00 00 00    	js     801bd4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801adf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ae6:	00 
  801ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801af5:	e8 e4 ed ff ff       	call   8008de <sys_page_alloc>
  801afa:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801afc:	85 c0                	test   %eax,%eax
  801afe:	0f 88 d0 00 00 00    	js     801bd4 <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b07:	89 04 24             	mov    %eax,(%esp)
  801b0a:	e8 05 ef ff ff       	call   800a14 <fd2data>
  801b0f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b11:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b18:	00 
  801b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b24:	e8 b5 ed ff ff       	call   8008de <sys_page_alloc>
  801b29:	89 c3                	mov    %eax,%ebx
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	0f 88 8e 00 00 00    	js     801bc1 <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b36:	89 04 24             	mov    %eax,(%esp)
  801b39:	e8 d6 ee ff ff       	call   800a14 <fd2data>
  801b3e:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b45:	00 
  801b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b51:	00 
  801b52:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5d:	e8 1e ed ff ff       	call   800880 <sys_page_map>
  801b62:	89 c3                	mov    %eax,%ebx
  801b64:	85 c0                	test   %eax,%eax
  801b66:	78 49                	js     801bb1 <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b68:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801b6d:	8b 08                	mov    (%eax),%ecx
  801b6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b72:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b77:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  801b7e:	8b 10                	mov    (%eax),%edx
  801b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b83:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b88:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b92:	89 04 24             	mov    %eax,(%esp)
  801b95:	e8 6a ee ff ff       	call   800a04 <fd2num>
  801b9a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9f:	89 04 24             	mov    %eax,(%esp)
  801ba2:	e8 5d ee ff ff       	call   800a04 <fd2num>
  801ba7:	89 47 04             	mov    %eax,0x4(%edi)
  801baa:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  801baf:	eb 36                	jmp    801be7 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  801bb1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bbc:	e8 61 ec ff ff       	call   800822 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bcf:	e8 4e ec ff ff       	call   800822 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be2:	e8 3b ec ff ff       	call   800822 <sys_page_unmap>
    err:
	return r;
}
  801be7:	89 d8                	mov    %ebx,%eax
  801be9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bec:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bef:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bf2:	89 ec                	mov    %ebp,%esp
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
	...

00801c00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c03:	b8 00 00 00 00       	mov    $0x0,%eax
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    

00801c0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c10:	c7 44 24 04 ee 29 80 	movl   $0x8029ee,0x4(%esp)
  801c17:	00 
  801c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 76 e5 ff ff       	call   800199 <strcpy>
	return 0;
}
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	57                   	push   %edi
  801c2e:	56                   	push   %esi
  801c2f:	53                   	push   %ebx
  801c30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  801c36:	be 00 00 00 00       	mov    $0x0,%esi
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c3b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c41:	eb 34                	jmp    801c77 <devcons_write+0x4d>
		m = n - tot;
  801c43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c46:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
  801c48:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  801c4e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801c53:	0f 43 da             	cmovae %edx,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c56:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c5a:	03 45 0c             	add    0xc(%ebp),%eax
  801c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c61:	89 3c 24             	mov    %edi,(%esp)
  801c64:	e8 d6 e6 ff ff       	call   80033f <memmove>
		sys_cputs(buf, m);
  801c69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6d:	89 3c 24             	mov    %edi,(%esp)
  801c70:	e8 db e8 ff ff       	call   800550 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c75:	01 de                	add    %ebx,%esi
  801c77:	89 f0                	mov    %esi,%eax
  801c79:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c7c:	72 c5                	jb     801c43 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801c7e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    

00801c89 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c95:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c9c:	00 
  801c9d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ca0:	89 04 24             	mov    %eax,(%esp)
  801ca3:	e8 a8 e8 ff ff       	call   800550 <sys_cputs>
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  801cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cb4:	75 07                	jne    801cbd <devcons_read+0x13>
  801cb6:	eb 28                	jmp    801ce0 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801cb8:	e8 80 ec ff ff       	call   80093d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cbd:	8d 76 00             	lea    0x0(%esi),%esi
  801cc0:	e8 57 e8 ff ff       	call   80051c <sys_cgetc>
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	74 ef                	je     801cb8 <devcons_read+0xe>
  801cc9:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	78 16                	js     801ce5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ccf:	83 f8 04             	cmp    $0x4,%eax
  801cd2:	74 0c                	je     801ce0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd7:	88 10                	mov    %dl,(%eax)
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  801cde:	eb 05                	jmp    801ce5 <devcons_read+0x3b>
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ced:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf0:	89 04 24             	mov    %eax,(%esp)
  801cf3:	e8 37 ed ff ff       	call   800a2f <fd_alloc>
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 3f                	js     801d3b <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cfc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d03:	00 
  801d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d12:	e8 c7 eb ff ff       	call   8008de <sys_page_alloc>
  801d17:	85 c0                	test   %eax,%eax
  801d19:	78 20                	js     801d3b <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d1b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d29:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d33:	89 04 24             	mov    %eax,(%esp)
  801d36:	e8 c9 ec ff ff       	call   800a04 <fd2num>
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	89 04 24             	mov    %eax,(%esp)
  801d50:	e8 33 ed ff ff       	call   800a88 <fd_lookup>
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 11                	js     801d6a <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	8b 00                	mov    (%eax),%eax
  801d5e:	3b 05 58 30 80 00    	cmp    0x803058,%eax
  801d64:	0f 94 c0             	sete   %al
  801d67:	0f b6 c0             	movzbl %al,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d72:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d79:	00 
  801d7a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d88:	e8 52 ef ff ff       	call   800cdf <read>
	if (r < 0)
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	78 0f                	js     801da0 <getchar+0x34>
		return r;
	if (r < 1)
  801d91:	85 c0                	test   %eax,%eax
  801d93:	7f 07                	jg     801d9c <getchar+0x30>
  801d95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d9a:	eb 04                	jmp    801da0 <getchar+0x34>
		return -E_EOF;
	return c;
  801d9c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    
	...

00801da4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	83 ec 20             	sub    $0x20,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
  801dac:	8d 75 14             	lea    0x14(%ebp),%esi
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801daf:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801db5:	e8 b7 eb ff ff       	call   800971 <sys_getenvid>
  801dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbd:	89 54 24 10          	mov    %edx,0x10(%esp)
  801dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dc8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd0:	c7 04 24 fc 29 80 00 	movl   $0x8029fc,(%esp)
  801dd7:	e8 81 00 00 00       	call   801e5d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ddc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801de0:	8b 45 10             	mov    0x10(%ebp),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 11 00 00 00       	call   801dfc <vcprintf>
	cprintf("\n");
  801deb:	c7 04 24 39 2d 80 00 	movl   $0x802d39,(%esp)
  801df2:	e8 66 00 00 00       	call   801e5d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801df7:	cc                   	int3   
  801df8:	eb fd                	jmp    801df7 <_panic+0x53>
	...

00801dfc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801e05:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e0c:	00 00 00 
	b.cnt = 0;
  801e0f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e16:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e27:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e31:	c7 04 24 77 1e 80 00 	movl   $0x801e77,(%esp)
  801e38:	e8 be 01 00 00       	call   801ffb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801e3d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e47:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801e4d:	89 04 24             	mov    %eax,(%esp)
  801e50:	e8 fb e6 ff ff       	call   800550 <sys_cputs>

	return b.cnt;
}
  801e55:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  801e63:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  801e66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	89 04 24             	mov    %eax,(%esp)
  801e70:	e8 87 ff ff ff       	call   801dfc <vcprintf>
	va_end(ap);

	return cnt;
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	53                   	push   %ebx
  801e7b:	83 ec 14             	sub    $0x14,%esp
  801e7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e81:	8b 03                	mov    (%ebx),%eax
  801e83:	8b 55 08             	mov    0x8(%ebp),%edx
  801e86:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  801e8a:	83 c0 01             	add    $0x1,%eax
  801e8d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801e8f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801e94:	75 19                	jne    801eaf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801e96:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801e9d:	00 
  801e9e:	8d 43 08             	lea    0x8(%ebx),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 a7 e6 ff ff       	call   800550 <sys_cputs>
		b->idx = 0;
  801ea9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801eaf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801eb3:	83 c4 14             	add    $0x14,%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5d                   	pop    %ebp
  801eb8:	c3                   	ret    
  801eb9:	00 00                	add    %al,(%eax)
	...

00801ebc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	57                   	push   %edi
  801ec0:	56                   	push   %esi
  801ec1:	53                   	push   %ebx
  801ec2:	83 ec 4c             	sub    $0x4c,%esp
  801ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ec8:	89 d6                	mov    %edx,%esi
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801edc:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801edf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ee2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ee7:	39 d1                	cmp    %edx,%ecx
  801ee9:	72 07                	jb     801ef2 <printnum+0x36>
  801eeb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801eee:	39 d0                	cmp    %edx,%eax
  801ef0:	77 69                	ja     801f5b <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801ef2:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801ef6:	83 eb 01             	sub    $0x1,%ebx
  801ef9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801efd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f01:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f05:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801f09:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801f0c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801f0f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801f12:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1d:	00 
  801f1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f21:	89 04 24             	mov    %eax,(%esp)
  801f24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f27:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f2b:	e8 c0 06 00 00       	call   8025f0 <__udivdi3>
  801f30:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801f33:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801f36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f3a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f3e:	89 04 24             	mov    %eax,(%esp)
  801f41:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f45:	89 f2                	mov    %esi,%edx
  801f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f4a:	e8 6d ff ff ff       	call   801ebc <printnum>
  801f4f:	eb 11                	jmp    801f62 <printnum+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801f51:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f55:	89 3c 24             	mov    %edi,(%esp)
  801f58:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f5b:	83 eb 01             	sub    $0x1,%ebx
  801f5e:	85 db                	test   %ebx,%ebx
  801f60:	7f ef                	jg     801f51 <printnum+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801f62:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f66:	8b 74 24 04          	mov    0x4(%esp),%esi
  801f6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f78:	00 
  801f79:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f7c:	89 14 24             	mov    %edx,(%esp)
  801f7f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f86:	e8 95 07 00 00       	call   802720 <__umoddi3>
  801f8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f8f:	0f be 80 1f 2a 80 00 	movsbl 0x802a1f(%eax),%eax
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801f9c:	83 c4 4c             	add    $0x4c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    

00801fa4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801fa7:	83 fa 01             	cmp    $0x1,%edx
  801faa:	7e 0e                	jle    801fba <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801fac:	8b 10                	mov    (%eax),%edx
  801fae:	8d 4a 08             	lea    0x8(%edx),%ecx
  801fb1:	89 08                	mov    %ecx,(%eax)
  801fb3:	8b 02                	mov    (%edx),%eax
  801fb5:	8b 52 04             	mov    0x4(%edx),%edx
  801fb8:	eb 22                	jmp    801fdc <getuint+0x38>
	else if (lflag)
  801fba:	85 d2                	test   %edx,%edx
  801fbc:	74 10                	je     801fce <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801fbe:	8b 10                	mov    (%eax),%edx
  801fc0:	8d 4a 04             	lea    0x4(%edx),%ecx
  801fc3:	89 08                	mov    %ecx,(%eax)
  801fc5:	8b 02                	mov    (%edx),%eax
  801fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcc:	eb 0e                	jmp    801fdc <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801fce:	8b 10                	mov    (%eax),%edx
  801fd0:	8d 4a 04             	lea    0x4(%edx),%ecx
  801fd3:	89 08                	mov    %ecx,(%eax)
  801fd5:	8b 02                	mov    (%edx),%eax
  801fd7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    

00801fde <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801fe4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801fe8:	8b 10                	mov    (%eax),%edx
  801fea:	3b 50 04             	cmp    0x4(%eax),%edx
  801fed:	73 0a                	jae    801ff9 <sprintputch+0x1b>
		*b->buf++ = ch;
  801fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff2:	88 0a                	mov    %cl,(%edx)
  801ff4:	83 c2 01             	add    $0x1,%edx
  801ff7:	89 10                	mov    %edx,(%eax)
}
  801ff9:	5d                   	pop    %ebp
  801ffa:	c3                   	ret    

00801ffb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	57                   	push   %edi
  801fff:	56                   	push   %esi
  802000:	53                   	push   %ebx
  802001:	83 ec 4c             	sub    $0x4c,%esp
  802004:	8b 7d 08             	mov    0x8(%ebp),%edi
  802007:	8b 75 0c             	mov    0xc(%ebp),%esi
  80200a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80200d:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  802014:	eb 11                	jmp    802027 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  802016:	85 c0                	test   %eax,%eax
  802018:	0f 84 b6 03 00 00    	je     8023d4 <vprintfmt+0x3d9>
				return;
			putch(ch, putdat);
  80201e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802022:	89 04 24             	mov    %eax,(%esp)
  802025:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802027:	0f b6 03             	movzbl (%ebx),%eax
  80202a:	83 c3 01             	add    $0x1,%ebx
  80202d:	83 f8 25             	cmp    $0x25,%eax
  802030:	75 e4                	jne    802016 <vprintfmt+0x1b>
  802032:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  802036:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80203d:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  802044:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80204b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802050:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802053:	eb 06                	jmp    80205b <vprintfmt+0x60>
  802055:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  802059:	89 d3                	mov    %edx,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80205b:	0f b6 0b             	movzbl (%ebx),%ecx
  80205e:	0f b6 c1             	movzbl %cl,%eax
  802061:	8d 53 01             	lea    0x1(%ebx),%edx
  802064:	83 e9 23             	sub    $0x23,%ecx
  802067:	80 f9 55             	cmp    $0x55,%cl
  80206a:	0f 87 47 03 00 00    	ja     8023b7 <vprintfmt+0x3bc>
  802070:	0f b6 c9             	movzbl %cl,%ecx
  802073:	ff 24 8d 60 2b 80 00 	jmp    *0x802b60(,%ecx,4)
  80207a:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80207e:	eb d9                	jmp    802059 <vprintfmt+0x5e>
  802080:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802087:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80208c:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  80208f:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  802093:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  802096:	8d 58 d0             	lea    -0x30(%eax),%ebx
  802099:	83 fb 09             	cmp    $0x9,%ebx
  80209c:	77 30                	ja     8020ce <vprintfmt+0xd3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80209e:	83 c2 01             	add    $0x1,%edx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8020a1:	eb e9                	jmp    80208c <vprintfmt+0x91>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8020a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a6:	8d 48 04             	lea    0x4(%eax),%ecx
  8020a9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			goto process_precision;
  8020b1:	eb 1e                	jmp    8020d1 <vprintfmt+0xd6>

		case '.':
			if (width < 0)
  8020b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
  8020c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020c3:	eb 94                	jmp    802059 <vprintfmt+0x5e>
  8020c5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8020cc:	eb 8b                	jmp    802059 <vprintfmt+0x5e>
  8020ce:	89 4d cc             	mov    %ecx,-0x34(%ebp)

		process_precision:
			if (width < 0)
  8020d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020d5:	79 82                	jns    802059 <vprintfmt+0x5e>
  8020d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020dd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8020e0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8020e3:	e9 71 ff ff ff       	jmp    802059 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8020e8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8020ec:	e9 68 ff ff ff       	jmp    802059 <vprintfmt+0x5e>
  8020f1:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8020f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f7:	8d 50 04             	lea    0x4(%eax),%edx
  8020fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8020fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802101:	8b 00                	mov    (%eax),%eax
  802103:	89 04 24             	mov    %eax,(%esp)
  802106:	ff d7                	call   *%edi
  802108:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80210b:	e9 17 ff ff ff       	jmp    802027 <vprintfmt+0x2c>
  802110:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802113:	8b 45 14             	mov    0x14(%ebp),%eax
  802116:	8d 50 04             	lea    0x4(%eax),%edx
  802119:	89 55 14             	mov    %edx,0x14(%ebp)
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	89 c2                	mov    %eax,%edx
  802120:	c1 fa 1f             	sar    $0x1f,%edx
  802123:	31 d0                	xor    %edx,%eax
  802125:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802127:	83 f8 11             	cmp    $0x11,%eax
  80212a:	7f 0b                	jg     802137 <vprintfmt+0x13c>
  80212c:	8b 14 85 c0 2c 80 00 	mov    0x802cc0(,%eax,4),%edx
  802133:	85 d2                	test   %edx,%edx
  802135:	75 20                	jne    802157 <vprintfmt+0x15c>
				printfmt(putch, putdat, "error %d", err);
  802137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80213b:	c7 44 24 08 30 2a 80 	movl   $0x802a30,0x8(%esp)
  802142:	00 
  802143:	89 74 24 04          	mov    %esi,0x4(%esp)
  802147:	89 3c 24             	mov    %edi,(%esp)
  80214a:	e8 0d 03 00 00       	call   80245c <printfmt>
  80214f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802152:	e9 d0 fe ff ff       	jmp    802027 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802157:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80215b:	c7 44 24 08 5e 29 80 	movl   $0x80295e,0x8(%esp)
  802162:	00 
  802163:	89 74 24 04          	mov    %esi,0x4(%esp)
  802167:	89 3c 24             	mov    %edi,(%esp)
  80216a:	e8 ed 02 00 00       	call   80245c <printfmt>
  80216f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  802172:	e9 b0 fe ff ff       	jmp    802027 <vprintfmt+0x2c>
  802177:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80217a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80217d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802180:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802183:	8b 45 14             	mov    0x14(%ebp),%eax
  802186:	8d 50 04             	lea    0x4(%eax),%edx
  802189:	89 55 14             	mov    %edx,0x14(%ebp)
  80218c:	8b 18                	mov    (%eax),%ebx
  80218e:	85 db                	test   %ebx,%ebx
  802190:	b8 39 2a 80 00       	mov    $0x802a39,%eax
  802195:	0f 44 d8             	cmove  %eax,%ebx
				p = "(null)";
			if (width > 0 && padc != '-')
  802198:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80219c:	7e 76                	jle    802214 <vprintfmt+0x219>
  80219e:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8021a2:	74 7a                	je     80221e <vprintfmt+0x223>
				for (width -= strnlen(p, precision); width > 0; width--)
  8021a4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021a8:	89 1c 24             	mov    %ebx,(%esp)
  8021ab:	e8 c8 df ff ff       	call   800178 <strnlen>
  8021b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021b3:	29 c2                	sub    %eax,%edx
					putch(padc, putdat);
  8021b5:	0f be 4d e0          	movsbl -0x20(%ebp),%ecx
  8021b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8021bc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8021bf:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8021c1:	eb 0f                	jmp    8021d2 <vprintfmt+0x1d7>
					putch(padc, putdat);
  8021c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ca:	89 04 24             	mov    %eax,(%esp)
  8021cd:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8021cf:	83 eb 01             	sub    $0x1,%ebx
  8021d2:	85 db                	test   %ebx,%ebx
  8021d4:	7f ed                	jg     8021c3 <vprintfmt+0x1c8>
  8021d6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8021d9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8021dc:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8021df:	89 f7                	mov    %esi,%edi
  8021e1:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8021e4:	eb 40                	jmp    802226 <vprintfmt+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8021e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8021ea:	74 18                	je     802204 <vprintfmt+0x209>
  8021ec:	8d 50 e0             	lea    -0x20(%eax),%edx
  8021ef:	83 fa 5e             	cmp    $0x5e,%edx
  8021f2:	76 10                	jbe    802204 <vprintfmt+0x209>
					putch('?', putdat);
  8021f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021f8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8021ff:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802202:	eb 0a                	jmp    80220e <vprintfmt+0x213>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802204:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802208:	89 04 24             	mov    %eax,(%esp)
  80220b:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80220e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802212:	eb 12                	jmp    802226 <vprintfmt+0x22b>
  802214:	89 7d e0             	mov    %edi,-0x20(%ebp)
  802217:	89 f7                	mov    %esi,%edi
  802219:	8b 75 cc             	mov    -0x34(%ebp),%esi
  80221c:	eb 08                	jmp    802226 <vprintfmt+0x22b>
  80221e:	89 7d e0             	mov    %edi,-0x20(%ebp)
  802221:	89 f7                	mov    %esi,%edi
  802223:	8b 75 cc             	mov    -0x34(%ebp),%esi
  802226:	0f be 03             	movsbl (%ebx),%eax
  802229:	83 c3 01             	add    $0x1,%ebx
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 25                	je     802255 <vprintfmt+0x25a>
  802230:	85 f6                	test   %esi,%esi
  802232:	78 b2                	js     8021e6 <vprintfmt+0x1eb>
  802234:	83 ee 01             	sub    $0x1,%esi
  802237:	79 ad                	jns    8021e6 <vprintfmt+0x1eb>
  802239:	89 fe                	mov    %edi,%esi
  80223b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80223e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  802241:	eb 1a                	jmp    80225d <vprintfmt+0x262>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802243:	89 74 24 04          	mov    %esi,0x4(%esp)
  802247:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80224e:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802250:	83 eb 01             	sub    $0x1,%ebx
  802253:	eb 08                	jmp    80225d <vprintfmt+0x262>
  802255:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  802258:	89 fe                	mov    %edi,%esi
  80225a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80225d:	85 db                	test   %ebx,%ebx
  80225f:	7f e2                	jg     802243 <vprintfmt+0x248>
  802261:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  802264:	e9 be fd ff ff       	jmp    802027 <vprintfmt+0x2c>
  802269:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80226c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80226f:	83 f9 01             	cmp    $0x1,%ecx
  802272:	7e 16                	jle    80228a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  802274:	8b 45 14             	mov    0x14(%ebp),%eax
  802277:	8d 50 08             	lea    0x8(%eax),%edx
  80227a:	89 55 14             	mov    %edx,0x14(%ebp)
  80227d:	8b 10                	mov    (%eax),%edx
  80227f:	8b 48 04             	mov    0x4(%eax),%ecx
  802282:	89 55 d8             	mov    %edx,-0x28(%ebp)
  802285:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802288:	eb 32                	jmp    8022bc <vprintfmt+0x2c1>
	else if (lflag)
  80228a:	85 c9                	test   %ecx,%ecx
  80228c:	74 18                	je     8022a6 <vprintfmt+0x2ab>
		return va_arg(*ap, long);
  80228e:	8b 45 14             	mov    0x14(%ebp),%eax
  802291:	8d 50 04             	lea    0x4(%eax),%edx
  802294:	89 55 14             	mov    %edx,0x14(%ebp)
  802297:	8b 00                	mov    (%eax),%eax
  802299:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80229c:	89 c1                	mov    %eax,%ecx
  80229e:	c1 f9 1f             	sar    $0x1f,%ecx
  8022a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8022a4:	eb 16                	jmp    8022bc <vprintfmt+0x2c1>
	else
		return va_arg(*ap, int);
  8022a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a9:	8d 50 04             	lea    0x4(%eax),%edx
  8022ac:	89 55 14             	mov    %edx,0x14(%ebp)
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022b4:	89 c2                	mov    %eax,%edx
  8022b6:	c1 fa 1f             	sar    $0x1f,%edx
  8022b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8022bc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8022bf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8022c2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8022c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8022cb:	0f 89 a7 00 00 00    	jns    802378 <vprintfmt+0x37d>
				putch('-', putdat);
  8022d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022d5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8022dc:	ff d7                	call   *%edi
				num = -(long long) num;
  8022de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8022e1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8022e4:	f7 d9                	neg    %ecx
  8022e6:	83 d3 00             	adc    $0x0,%ebx
  8022e9:	f7 db                	neg    %ebx
  8022eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8022f0:	e9 83 00 00 00       	jmp    802378 <vprintfmt+0x37d>
  8022f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8022f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8022fb:	89 ca                	mov    %ecx,%edx
  8022fd:	8d 45 14             	lea    0x14(%ebp),%eax
  802300:	e8 9f fc ff ff       	call   801fa4 <getuint>
  802305:	89 c1                	mov    %eax,%ecx
  802307:	89 d3                	mov    %edx,%ebx
  802309:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80230e:	eb 68                	jmp    802378 <vprintfmt+0x37d>
  802310:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802313:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  802316:	89 ca                	mov    %ecx,%edx
  802318:	8d 45 14             	lea    0x14(%ebp),%eax
  80231b:	e8 84 fc ff ff       	call   801fa4 <getuint>
  802320:	89 c1                	mov    %eax,%ecx
  802322:	89 d3                	mov    %edx,%ebx
  802324:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  802329:	eb 4d                	jmp    802378 <vprintfmt+0x37d>
  80232b:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  80232e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802332:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  802339:	ff d7                	call   *%edi
			putch('x', putdat);
  80233b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80233f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  802346:	ff d7                	call   *%edi
			num = (unsigned long long)
  802348:	8b 45 14             	mov    0x14(%ebp),%eax
  80234b:	8d 50 04             	lea    0x4(%eax),%edx
  80234e:	89 55 14             	mov    %edx,0x14(%ebp)
  802351:	8b 08                	mov    (%eax),%ecx
  802353:	bb 00 00 00 00       	mov    $0x0,%ebx
  802358:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80235d:	eb 19                	jmp    802378 <vprintfmt+0x37d>
  80235f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802362:	8b 4d d4             	mov    -0x2c(%ebp),%ecx

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802365:	89 ca                	mov    %ecx,%edx
  802367:	8d 45 14             	lea    0x14(%ebp),%eax
  80236a:	e8 35 fc ff ff       	call   801fa4 <getuint>
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 d3                	mov    %edx,%ebx
  802373:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  802378:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  80237c:	89 54 24 10          	mov    %edx,0x10(%esp)
  802380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802383:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802387:	89 44 24 08          	mov    %eax,0x8(%esp)
  80238b:	89 0c 24             	mov    %ecx,(%esp)
  80238e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802392:	89 f2                	mov    %esi,%edx
  802394:	89 f8                	mov    %edi,%eax
  802396:	e8 21 fb ff ff       	call   801ebc <printnum>
  80239b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  80239e:	e9 84 fc ff ff       	jmp    802027 <vprintfmt+0x2c>
  8023a3:	89 55 d0             	mov    %edx,-0x30(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8023a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023aa:	89 04 24             	mov    %eax,(%esp)
  8023ad:	ff d7                	call   *%edi
  8023af:	8b 5d d0             	mov    -0x30(%ebp),%ebx
			break;
  8023b2:	e9 70 fc ff ff       	jmp    802027 <vprintfmt+0x2c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8023b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023bb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8023c2:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8023c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c7:	80 38 25             	cmpb   $0x25,(%eax)
  8023ca:	0f 84 57 fc ff ff    	je     802027 <vprintfmt+0x2c>
  8023d0:	89 c3                	mov    %eax,%ebx
  8023d2:	eb f0                	jmp    8023c4 <vprintfmt+0x3c9>
				/* do nothing */;
			break;
		}
	}
}
  8023d4:	83 c4 4c             	add    $0x4c,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5f                   	pop    %edi
  8023da:	5d                   	pop    %ebp
  8023db:	c3                   	ret    

008023dc <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 28             	sub    $0x28,%esp
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 04                	je     8023f0 <vsnprintf+0x14>
  8023ec:	85 d2                	test   %edx,%edx
  8023ee:	7f 07                	jg     8023f7 <vsnprintf+0x1b>
  8023f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023f5:	eb 3b                	jmp    802432 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8023f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023fa:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8023fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802408:	8b 45 14             	mov    0x14(%ebp),%eax
  80240b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80240f:	8b 45 10             	mov    0x10(%ebp),%eax
  802412:	89 44 24 08          	mov    %eax,0x8(%esp)
  802416:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802419:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241d:	c7 04 24 de 1f 80 00 	movl   $0x801fde,(%esp)
  802424:	e8 d2 fb ff ff       	call   801ffb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80243a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  80243d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802441:	8b 45 10             	mov    0x10(%ebp),%eax
  802444:	89 44 24 08          	mov    %eax,0x8(%esp)
  802448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	89 04 24             	mov    %eax,(%esp)
  802455:	e8 82 ff ff ff       	call   8023dc <vsnprintf>
	va_end(ap);

	return rc;
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  802462:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  802465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802469:	8b 45 10             	mov    0x10(%ebp),%eax
  80246c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802470:	8b 45 0c             	mov    0xc(%ebp),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	89 04 24             	mov    %eax,(%esp)
  80247d:	e8 79 fb ff ff       	call   801ffb <vprintfmt>
	va_end(ap);
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80248f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802492:	81 c2 50 00 c0 ee    	add    $0xeec00050,%edx
  802498:	8b 12                	mov    (%edx),%edx
  80249a:	39 ca                	cmp    %ecx,%edx
  80249c:	75 0c                	jne    8024aa <ipc_find_env+0x26>
			return envs[i].env_id;
  80249e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024a1:	05 48 00 c0 ee       	add    $0xeec00048,%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	eb 0e                	jmp    8024b8 <ipc_find_env+0x34>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024aa:	83 c0 01             	add    $0x1,%eax
  8024ad:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024b2:	75 db                	jne    80248f <ipc_find_env+0xb>
  8024b4:	66 b8 00 00          	mov    $0x0,%ax
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
  8024b8:	5d                   	pop    %ebp
  8024b9:	c3                   	ret    

008024ba <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	57                   	push   %edi
  8024be:	56                   	push   %esi
  8024bf:	53                   	push   %ebx
  8024c0:	83 ec 2c             	sub    $0x2c,%esp
  8024c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8024c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	int ret;	
	if(!pg) pg = (void *)UTOP;
  8024cc:	85 db                	test   %ebx,%ebx
  8024ce:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024d3:	0f 44 d8             	cmove  %eax,%ebx
	do
	{ret = sys_ipc_try_send(to_env,val,pg,perm);}
  8024d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024e5:	89 34 24             	mov    %esi,(%esp)
  8024e8:	e8 e3 e1 ff ff       	call   8006d0 <sys_ipc_try_send>
	while(ret == -E_IPC_NOT_RECV);
  8024ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024f0:	74 e4                	je     8024d6 <ipc_send+0x1c>

	if(ret)	panic("ipc_send fails %d\n",__func__,ret);
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 28                	je     80251e <ipc_send+0x64>
  8024f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8024fa:	c7 44 24 0c 45 2d 80 	movl   $0x802d45,0xc(%esp)
  802501:	00 
  802502:	c7 44 24 08 28 2d 80 	movl   $0x802d28,0x8(%esp)
  802509:	00 
  80250a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802511:	00 
  802512:	c7 04 24 3b 2d 80 00 	movl   $0x802d3b,(%esp)
  802519:	e8 86 f8 ff ff       	call   801da4 <_panic>
	//if(!ret) sys_yield();
}
  80251e:	83 c4 2c             	add    $0x2c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    

00802526 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 28             	sub    $0x28,%esp
  80252c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80252f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802532:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802535:	8b 75 08             	mov    0x8(%ebp),%esi
  802538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253b:	8b 7d 10             	mov    0x10(%ebp),%edi
	// LAB 4: Your code here.
	int32_t ret;
	envid_t curr_id;

	if(!pg) pg = (void *)UTOP;
  80253e:	85 c0                	test   %eax,%eax
  802540:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802545:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802548:	89 04 24             	mov    %eax,(%esp)
  80254b:	e8 23 e1 ff ff       	call   800673 <sys_ipc_recv>
  802550:	89 c3                	mov    %eax,%ebx
	thisenv = &envs[ENVX(sys_getenvid())];	
  802552:	e8 1a e4 ff ff       	call   800971 <sys_getenvid>
  802557:	25 ff 03 00 00       	and    $0x3ff,%eax
  80255c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80255f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802564:	a3 08 40 80 00       	mov    %eax,0x804008
	//cprintf("thisenv->env_ipc_perm = %d ret = %d\n",thisenv->env_ipc_perm,ret);
	
	if(from_env_store) *from_env_store = ret ? 0 : thisenv->env_ipc_from;
  802569:	85 f6                	test   %esi,%esi
  80256b:	74 0e                	je     80257b <ipc_recv+0x55>
  80256d:	ba 00 00 00 00       	mov    $0x0,%edx
  802572:	85 db                	test   %ebx,%ebx
  802574:	75 03                	jne    802579 <ipc_recv+0x53>
  802576:	8b 50 74             	mov    0x74(%eax),%edx
  802579:	89 16                	mov    %edx,(%esi)
	if(perm_store) *perm_store = ret ? 0 : thisenv->env_ipc_perm;
  80257b:	85 ff                	test   %edi,%edi
  80257d:	74 13                	je     802592 <ipc_recv+0x6c>
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	85 db                	test   %ebx,%ebx
  802586:	75 08                	jne    802590 <ipc_recv+0x6a>
  802588:	a1 08 40 80 00       	mov    0x804008,%eax
  80258d:	8b 40 78             	mov    0x78(%eax),%eax
  802590:	89 07                	mov    %eax,(%edi)
	return ret ? ret : thisenv->env_ipc_value;
  802592:	85 db                	test   %ebx,%ebx
  802594:	75 08                	jne    80259e <ipc_recv+0x78>
  802596:	a1 08 40 80 00       	mov    0x804008,%eax
  80259b:	8b 58 70             	mov    0x70(%eax),%ebx
}
  80259e:	89 d8                	mov    %ebx,%eax
  8025a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025a9:	89 ec                	mov    %ebp,%esp
  8025ab:	5d                   	pop    %ebp
  8025ac:	c3                   	ret    
  8025ad:	00 00                	add    %al,(%eax)
	...

008025b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	89 c2                	mov    %eax,%edx
  8025b8:	c1 ea 16             	shr    $0x16,%edx
  8025bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8025c2:	f6 c2 01             	test   $0x1,%dl
  8025c5:	74 20                	je     8025e7 <pageref+0x37>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025c7:	c1 e8 0c             	shr    $0xc,%eax
  8025ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025d1:	a8 01                	test   $0x1,%al
  8025d3:	74 12                	je     8025e7 <pageref+0x37>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025d5:	c1 e8 0c             	shr    $0xc,%eax
  8025d8:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8025dd:	0f b7 44 c2 04       	movzwl 0x4(%edx,%eax,8),%eax
  8025e2:	0f b7 c0             	movzwl %ax,%eax
  8025e5:	eb 05                	jmp    8025ec <pageref+0x3c>
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    
	...

008025f0 <__udivdi3>:
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	57                   	push   %edi
  8025f4:	56                   	push   %esi
  8025f5:	83 ec 10             	sub    $0x10,%esp
  8025f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8025fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fe:	8b 75 10             	mov    0x10(%ebp),%esi
  802601:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802604:	85 c0                	test   %eax,%eax
  802606:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802609:	75 35                	jne    802640 <__udivdi3+0x50>
  80260b:	39 fe                	cmp    %edi,%esi
  80260d:	77 61                	ja     802670 <__udivdi3+0x80>
  80260f:	85 f6                	test   %esi,%esi
  802611:	75 0b                	jne    80261e <__udivdi3+0x2e>
  802613:	b8 01 00 00 00       	mov    $0x1,%eax
  802618:	31 d2                	xor    %edx,%edx
  80261a:	f7 f6                	div    %esi
  80261c:	89 c6                	mov    %eax,%esi
  80261e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802621:	31 d2                	xor    %edx,%edx
  802623:	89 f8                	mov    %edi,%eax
  802625:	f7 f6                	div    %esi
  802627:	89 c7                	mov    %eax,%edi
  802629:	89 c8                	mov    %ecx,%eax
  80262b:	f7 f6                	div    %esi
  80262d:	89 c1                	mov    %eax,%ecx
  80262f:	89 fa                	mov    %edi,%edx
  802631:	89 c8                	mov    %ecx,%eax
  802633:	83 c4 10             	add    $0x10,%esp
  802636:	5e                   	pop    %esi
  802637:	5f                   	pop    %edi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
  80263a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802640:	39 f8                	cmp    %edi,%eax
  802642:	77 1c                	ja     802660 <__udivdi3+0x70>
  802644:	0f bd d0             	bsr    %eax,%edx
  802647:	83 f2 1f             	xor    $0x1f,%edx
  80264a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80264d:	75 39                	jne    802688 <__udivdi3+0x98>
  80264f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802652:	0f 86 a0 00 00 00    	jbe    8026f8 <__udivdi3+0x108>
  802658:	39 f8                	cmp    %edi,%eax
  80265a:	0f 82 98 00 00 00    	jb     8026f8 <__udivdi3+0x108>
  802660:	31 ff                	xor    %edi,%edi
  802662:	31 c9                	xor    %ecx,%ecx
  802664:	89 c8                	mov    %ecx,%eax
  802666:	89 fa                	mov    %edi,%edx
  802668:	83 c4 10             	add    $0x10,%esp
  80266b:	5e                   	pop    %esi
  80266c:	5f                   	pop    %edi
  80266d:	5d                   	pop    %ebp
  80266e:	c3                   	ret    
  80266f:	90                   	nop
  802670:	89 d1                	mov    %edx,%ecx
  802672:	89 fa                	mov    %edi,%edx
  802674:	89 c8                	mov    %ecx,%eax
  802676:	31 ff                	xor    %edi,%edi
  802678:	f7 f6                	div    %esi
  80267a:	89 c1                	mov    %eax,%ecx
  80267c:	89 fa                	mov    %edi,%edx
  80267e:	89 c8                	mov    %ecx,%eax
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	5e                   	pop    %esi
  802684:	5f                   	pop    %edi
  802685:	5d                   	pop    %ebp
  802686:	c3                   	ret    
  802687:	90                   	nop
  802688:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80268c:	89 f2                	mov    %esi,%edx
  80268e:	d3 e0                	shl    %cl,%eax
  802690:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802693:	b8 20 00 00 00       	mov    $0x20,%eax
  802698:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80269b:	89 c1                	mov    %eax,%ecx
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8026a6:	d3 e6                	shl    %cl,%esi
  8026a8:	89 c1                	mov    %eax,%ecx
  8026aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8026ad:	89 fe                	mov    %edi,%esi
  8026af:	d3 ee                	shr    %cl,%esi
  8026b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026bb:	d3 e7                	shl    %cl,%edi
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	d3 ea                	shr    %cl,%edx
  8026c1:	09 d7                	or     %edx,%edi
  8026c3:	89 f2                	mov    %esi,%edx
  8026c5:	89 f8                	mov    %edi,%eax
  8026c7:	f7 75 ec             	divl   -0x14(%ebp)
  8026ca:	89 d6                	mov    %edx,%esi
  8026cc:	89 c7                	mov    %eax,%edi
  8026ce:	f7 65 e8             	mull   -0x18(%ebp)
  8026d1:	39 d6                	cmp    %edx,%esi
  8026d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026d6:	72 30                	jb     802708 <__udivdi3+0x118>
  8026d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026df:	d3 e2                	shl    %cl,%edx
  8026e1:	39 c2                	cmp    %eax,%edx
  8026e3:	73 05                	jae    8026ea <__udivdi3+0xfa>
  8026e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8026e8:	74 1e                	je     802708 <__udivdi3+0x118>
  8026ea:	89 f9                	mov    %edi,%ecx
  8026ec:	31 ff                	xor    %edi,%edi
  8026ee:	e9 71 ff ff ff       	jmp    802664 <__udivdi3+0x74>
  8026f3:	90                   	nop
  8026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	31 ff                	xor    %edi,%edi
  8026fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8026ff:	e9 60 ff ff ff       	jmp    802664 <__udivdi3+0x74>
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80270b:	31 ff                	xor    %edi,%edi
  80270d:	89 c8                	mov    %ecx,%eax
  80270f:	89 fa                	mov    %edi,%edx
  802711:	83 c4 10             	add    $0x10,%esp
  802714:	5e                   	pop    %esi
  802715:	5f                   	pop    %edi
  802716:	5d                   	pop    %ebp
  802717:	c3                   	ret    
	...

00802720 <__umoddi3>:
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	57                   	push   %edi
  802724:	56                   	push   %esi
  802725:	83 ec 20             	sub    $0x20,%esp
  802728:	8b 55 14             	mov    0x14(%ebp),%edx
  80272b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80272e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802731:	8b 75 0c             	mov    0xc(%ebp),%esi
  802734:	85 d2                	test   %edx,%edx
  802736:	89 c8                	mov    %ecx,%eax
  802738:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80273b:	75 13                	jne    802750 <__umoddi3+0x30>
  80273d:	39 f7                	cmp    %esi,%edi
  80273f:	76 3f                	jbe    802780 <__umoddi3+0x60>
  802741:	89 f2                	mov    %esi,%edx
  802743:	f7 f7                	div    %edi
  802745:	89 d0                	mov    %edx,%eax
  802747:	31 d2                	xor    %edx,%edx
  802749:	83 c4 20             	add    $0x20,%esp
  80274c:	5e                   	pop    %esi
  80274d:	5f                   	pop    %edi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    
  802750:	39 f2                	cmp    %esi,%edx
  802752:	77 4c                	ja     8027a0 <__umoddi3+0x80>
  802754:	0f bd ca             	bsr    %edx,%ecx
  802757:	83 f1 1f             	xor    $0x1f,%ecx
  80275a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80275d:	75 51                	jne    8027b0 <__umoddi3+0x90>
  80275f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802762:	0f 87 e0 00 00 00    	ja     802848 <__umoddi3+0x128>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	29 f8                	sub    %edi,%eax
  80276d:	19 d6                	sbb    %edx,%esi
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 f2                	mov    %esi,%edx
  802777:	83 c4 20             	add    $0x20,%esp
  80277a:	5e                   	pop    %esi
  80277b:	5f                   	pop    %edi
  80277c:	5d                   	pop    %ebp
  80277d:	c3                   	ret    
  80277e:	66 90                	xchg   %ax,%ax
  802780:	85 ff                	test   %edi,%edi
  802782:	75 0b                	jne    80278f <__umoddi3+0x6f>
  802784:	b8 01 00 00 00       	mov    $0x1,%eax
  802789:	31 d2                	xor    %edx,%edx
  80278b:	f7 f7                	div    %edi
  80278d:	89 c7                	mov    %eax,%edi
  80278f:	89 f0                	mov    %esi,%eax
  802791:	31 d2                	xor    %edx,%edx
  802793:	f7 f7                	div    %edi
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	f7 f7                	div    %edi
  80279a:	eb a9                	jmp    802745 <__umoddi3+0x25>
  80279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027a0:	89 c8                	mov    %ecx,%eax
  8027a2:	89 f2                	mov    %esi,%edx
  8027a4:	83 c4 20             	add    $0x20,%esp
  8027a7:	5e                   	pop    %esi
  8027a8:	5f                   	pop    %edi
  8027a9:	5d                   	pop    %ebp
  8027aa:	c3                   	ret    
  8027ab:	90                   	nop
  8027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027b4:	d3 e2                	shl    %cl,%edx
  8027b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8027be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8027c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8027c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027c8:	89 fa                	mov    %edi,%edx
  8027ca:	d3 ea                	shr    %cl,%edx
  8027cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8027d3:	d3 e7                	shl    %cl,%edi
  8027d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027dc:	89 f2                	mov    %esi,%edx
  8027de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8027e1:	89 c7                	mov    %eax,%edi
  8027e3:	d3 ea                	shr    %cl,%edx
  8027e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8027ec:	89 c2                	mov    %eax,%edx
  8027ee:	d3 e6                	shl    %cl,%esi
  8027f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027f4:	d3 ea                	shr    %cl,%edx
  8027f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027fa:	09 d6                	or     %edx,%esi
  8027fc:	89 f0                	mov    %esi,%eax
  8027fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802801:	d3 e7                	shl    %cl,%edi
  802803:	89 f2                	mov    %esi,%edx
  802805:	f7 75 f4             	divl   -0xc(%ebp)
  802808:	89 d6                	mov    %edx,%esi
  80280a:	f7 65 e8             	mull   -0x18(%ebp)
  80280d:	39 d6                	cmp    %edx,%esi
  80280f:	72 2b                	jb     80283c <__umoddi3+0x11c>
  802811:	39 c7                	cmp    %eax,%edi
  802813:	72 23                	jb     802838 <__umoddi3+0x118>
  802815:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802819:	29 c7                	sub    %eax,%edi
  80281b:	19 d6                	sbb    %edx,%esi
  80281d:	89 f0                	mov    %esi,%eax
  80281f:	89 f2                	mov    %esi,%edx
  802821:	d3 ef                	shr    %cl,%edi
  802823:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802827:	d3 e0                	shl    %cl,%eax
  802829:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80282d:	09 f8                	or     %edi,%eax
  80282f:	d3 ea                	shr    %cl,%edx
  802831:	83 c4 20             	add    $0x20,%esp
  802834:	5e                   	pop    %esi
  802835:	5f                   	pop    %edi
  802836:	5d                   	pop    %ebp
  802837:	c3                   	ret    
  802838:	39 d6                	cmp    %edx,%esi
  80283a:	75 d9                	jne    802815 <__umoddi3+0xf5>
  80283c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80283f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802842:	eb d1                	jmp    802815 <__umoddi3+0xf5>
  802844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802848:	39 f2                	cmp    %esi,%edx
  80284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802850:	0f 82 12 ff ff ff    	jb     802768 <__umoddi3+0x48>
  802856:	e9 17 ff ff ff       	jmp    802772 <__umoddi3+0x52>
