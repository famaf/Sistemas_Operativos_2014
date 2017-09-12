
_usertests:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 fc 62 00 00       	mov    0x62fc,%eax
       b:	c7 44 24 04 5a 44 00 	movl   $0x445a,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 5b 40 00 00       	call   4076 <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 65 44 00 00 	movl   $0x4465,(%esp)
      22:	e8 2f 3f 00 00       	call   3f56 <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 fc 62 00 00       	mov    0x62fc,%eax
      30:	c7 44 24 04 6d 44 00 	movl   $0x446d,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 36 40 00 00       	call   4076 <printf>
    exit();
      40:	e8 a9 3e 00 00       	call   3eee <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 65 44 00 00 	movl   $0x4465,(%esp)
      4c:	e8 0d 3f 00 00       	call   3f5e <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 fc 62 00 00       	mov    0x62fc,%eax
      5a:	c7 44 24 04 7b 44 00 	movl   $0x447b,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 0c 40 00 00       	call   4076 <printf>
    exit();
      6a:	e8 7f 3e 00 00       	call   3eee <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 91 44 00 00 	movl   $0x4491,(%esp)
      76:	e8 c3 3e 00 00       	call   3f3e <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 fc 62 00 00       	mov    0x62fc,%eax
      84:	c7 44 24 04 9c 44 00 	movl   $0x449c,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 e2 3f 00 00       	call   4076 <printf>
    exit();
      94:	e8 55 3e 00 00       	call   3eee <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 b6 44 00 00 	movl   $0x44b6,(%esp)
      a0:	e8 b9 3e 00 00       	call   3f5e <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 fc 62 00 00       	mov    0x62fc,%eax
      ae:	c7 44 24 04 b8 44 00 	movl   $0x44b8,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 b8 3f 00 00       	call   4076 <printf>
    exit();
      be:	e8 2b 3e 00 00       	call   3eee <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 fc 62 00 00       	mov    0x62fc,%eax
      c8:	c7 44 24 04 c8 44 00 	movl   $0x44c8,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 9e 3f 00 00       	call   4076 <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 fc 62 00 00       	mov    0x62fc,%eax
      e5:	c7 44 24 04 d6 44 00 	movl   $0x44d6,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 81 3f 00 00       	call   4076 <printf>

  pid = fork();
      f5:	e8 ec 3d 00 00       	call   3ee6 <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 fc 62 00 00       	mov    0x62fc,%eax
     108:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 5e 3f 00 00       	call   4076 <printf>
    exit();
     118:	e8 d1 3d 00 00       	call   3eee <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 65 44 00 00 	movl   $0x4465,(%esp)
     12e:	e8 23 3e 00 00       	call   3f56 <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 fc 62 00 00       	mov    0x62fc,%eax
     13c:	c7 44 24 04 6d 44 00 	movl   $0x446d,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 2a 3f 00 00       	call   4076 <printf>
      exit();
     14c:	e8 9d 3d 00 00       	call   3eee <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 65 44 00 00 	movl   $0x4465,(%esp)
     158:	e8 01 3e 00 00       	call   3f5e <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 fc 62 00 00       	mov    0x62fc,%eax
     166:	c7 44 24 04 f2 44 00 	movl   $0x44f2,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 00 3f 00 00       	call   4076 <printf>
      exit();
     176:	e8 73 3d 00 00       	call   3eee <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 91 44 00 00 	movl   $0x4491,(%esp)
     182:	e8 b7 3d 00 00       	call   3f3e <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 fc 62 00 00       	mov    0x62fc,%eax
     190:	c7 44 24 04 9c 44 00 	movl   $0x449c,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 d6 3e 00 00       	call   4076 <printf>
      exit();
     1a0:	e8 49 3d 00 00       	call   3eee <exit>
    }
    exit();
     1a5:	e8 44 3d 00 00       	call   3eee <exit>
  }
  wait();
     1aa:	e8 47 3d 00 00       	call   3ef6 <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 fc 62 00 00       	mov    0x62fc,%eax
     1b4:	c7 44 24 04 06 45 00 	movl   $0x4506,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 b2 3e 00 00       	call   4076 <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 fc 62 00 00       	mov    0x62fc,%eax
     1d1:	c7 44 24 04 18 45 00 	movl   $0x4518,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 95 3e 00 00       	call   4076 <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 27 45 00 00 	movl   $0x4527,(%esp)
     1e8:	e8 69 3d 00 00       	call   3f56 <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 fc 62 00 00       	mov    0x62fc,%eax
     1f6:	c7 44 24 04 2d 45 00 	movl   $0x452d,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 70 3e 00 00       	call   4076 <printf>
    exit();
     206:	e8 e3 3c 00 00       	call   3eee <exit>
  }
  pid = fork();
     20b:	e8 d6 3c 00 00       	call   3ee6 <fork>
     210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 fc 62 00 00       	mov    0x62fc,%eax
     21e:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 48 3e 00 00       	call   4076 <printf>
    exit();
     22e:	e8 bb 3c 00 00       	call   3eee <exit>
  }
  if(pid == 0){
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 27 45 00 00 	movl   $0x4527,(%esp)
     248:	e8 e1 3c 00 00       	call   3f2e <open>
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 fc 62 00 00       	mov    0x62fc,%eax
     25b:	c7 44 24 04 44 45 00 	movl   $0x4544,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 0b 3e 00 00       	call   4076 <printf>
      exit();
     26b:	e8 7e 3c 00 00       	call   3eee <exit>
    }
    exit();
     270:	e8 79 3c 00 00       	call   3eee <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 fd 3c 00 00       	call   3f7e <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 27 45 00 00 	movl   $0x4527,(%esp)
     288:	e8 b1 3c 00 00       	call   3f3e <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 fc 62 00 00       	mov    0x62fc,%eax
     296:	c7 44 24 04 68 45 00 	movl   $0x4568,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 d0 3d 00 00       	call   4076 <printf>
    exit();
     2a6:	e8 43 3c 00 00       	call   3eee <exit>
  }
  wait();
     2ab:	e8 46 3c 00 00       	call   3ef6 <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 fc 62 00 00       	mov    0x62fc,%eax
     2b5:	c7 44 24 04 77 45 00 	movl   $0x4577,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 b1 3d 00 00       	call   4076 <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 fc 62 00 00       	mov    0x62fc,%eax
     2d2:	c7 44 24 04 89 45 00 	movl   $0x4589,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 94 3d 00 00       	call   4076 <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 44 44 00 00 	movl   $0x4444,(%esp)
     2f1:	e8 38 3c 00 00       	call   3f2e <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 fc 62 00 00       	mov    0x62fc,%eax
     304:	c7 44 24 04 94 45 00 	movl   $0x4594,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 62 3d 00 00       	call   4076 <printf>
    exit();
     314:	e8 d5 3b 00 00       	call   3eee <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 f2 3b 00 00       	call   3f16 <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 a7 45 00 00 	movl   $0x45a7,(%esp)
     333:	e8 f6 3b 00 00       	call   3f2e <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 fc 62 00 00       	mov    0x62fc,%eax
     346:	c7 44 24 04 b4 45 00 	movl   $0x45b4,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 20 3d 00 00       	call   4076 <printf>
    exit();
     356:	e8 93 3b 00 00       	call   3eee <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 fc 62 00 00       	mov    0x62fc,%eax
     360:	c7 44 24 04 d2 45 00 	movl   $0x45d2,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 06 3d 00 00       	call   4076 <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 fc 62 00 00       	mov    0x62fc,%eax
     37d:	c7 44 24 04 e0 45 00 	movl   $0x45e0,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 e9 3c 00 00       	call   4076 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 f1 45 00 00 	movl   $0x45f1,(%esp)
     39c:	e8 8d 3b 00 00       	call   3f2e <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 fc 62 00 00       	mov    0x62fc,%eax
     3af:	c7 44 24 04 f7 45 00 	movl   $0x45f7,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 b7 3c 00 00       	call   4076 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 a0 00 00 00       	jmp    46b <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 fc 62 00 00       	mov    0x62fc,%eax
     3d0:	c7 44 24 04 12 46 00 	movl   $0x4612,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 96 3c 00 00       	call   4076 <printf>
    exit();
     3e0:	e8 09 3b 00 00       	call   3eee <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 2e 46 00 	movl   $0x462e,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 0e 3b 00 00       	call   3f0e <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 fc 62 00 00       	mov    0x62fc,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 3c 46 00 	movl   $0x463c,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 55 3c 00 00       	call   4076 <printf>
      exit();
     421:	e8 c8 3a 00 00       	call   3eee <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 60 46 00 	movl   $0x4660,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 cd 3a 00 00       	call   3f0e <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 fc 62 00 00       	mov    0x62fc,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 6c 46 00 	movl   $0x466c,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 14 3c 00 00       	call   4076 <printf>
      exit();
     462:	e8 87 3a 00 00       	call   3eee <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     46b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46f:	0f 8e 70 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     475:	a1 fc 62 00 00       	mov    0x62fc,%eax
     47a:	c7 44 24 04 90 46 00 	movl   $0x4690,0x4(%esp)
     481:	00 
     482:	89 04 24             	mov    %eax,(%esp)
     485:	e8 ec 3b 00 00       	call   4076 <printf>
  close(fd);
     48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 81 3a 00 00       	call   3f16 <close>
  fd = open("small", O_RDONLY);
     495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49c:	00 
     49d:	c7 04 24 f1 45 00 00 	movl   $0x45f1,(%esp)
     4a4:	e8 85 3a 00 00       	call   3f2e <open>
     4a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4b0:	78 3e                	js     4f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     4b2:	a1 fc 62 00 00       	mov    0x62fc,%eax
     4b7:	c7 44 24 04 9b 46 00 	movl   $0x469b,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 af 3b 00 00       	call   4076 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4ce:	00 
     4cf:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
     4d6:	00 
     4d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4da:	89 04 24             	mov    %eax,(%esp)
     4dd:	e8 24 3a 00 00       	call   3f06 <read>
     4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4ec:	75 4e                	jne    53c <writetest+0x1ca>
     4ee:	eb 1a                	jmp    50a <writetest+0x198>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4f0:	a1 fc 62 00 00       	mov    0x62fc,%eax
     4f5:	c7 44 24 04 b4 46 00 	movl   $0x46b4,0x4(%esp)
     4fc:	00 
     4fd:	89 04 24             	mov    %eax,(%esp)
     500:	e8 71 3b 00 00       	call   4076 <printf>
    exit();
     505:	e8 e4 39 00 00       	call   3eee <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     50a:	a1 fc 62 00 00       	mov    0x62fc,%eax
     50f:	c7 44 24 04 cf 46 00 	movl   $0x46cf,0x4(%esp)
     516:	00 
     517:	89 04 24             	mov    %eax,(%esp)
     51a:	e8 57 3b 00 00       	call   4076 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     522:	89 04 24             	mov    %eax,(%esp)
     525:	e8 ec 39 00 00       	call   3f16 <close>

  if(unlink("small") < 0){
     52a:	c7 04 24 f1 45 00 00 	movl   $0x45f1,(%esp)
     531:	e8 08 3a 00 00       	call   3f3e <unlink>
     536:	85 c0                	test   %eax,%eax
     538:	79 36                	jns    570 <writetest+0x1fe>
     53a:	eb 1a                	jmp    556 <writetest+0x1e4>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53c:	a1 fc 62 00 00       	mov    0x62fc,%eax
     541:	c7 44 24 04 e2 46 00 	movl   $0x46e2,0x4(%esp)
     548:	00 
     549:	89 04 24             	mov    %eax,(%esp)
     54c:	e8 25 3b 00 00       	call   4076 <printf>
    exit();
     551:	e8 98 39 00 00       	call   3eee <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     556:	a1 fc 62 00 00       	mov    0x62fc,%eax
     55b:	c7 44 24 04 ef 46 00 	movl   $0x46ef,0x4(%esp)
     562:	00 
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 0b 3b 00 00       	call   4076 <printf>
    exit();
     56b:	e8 7e 39 00 00       	call   3eee <exit>
  }
  printf(stdout, "small file test ok\n");
     570:	a1 fc 62 00 00       	mov    0x62fc,%eax
     575:	c7 44 24 04 04 47 00 	movl   $0x4704,0x4(%esp)
     57c:	00 
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 f1 3a 00 00       	call   4076 <printf>
}
     585:	c9                   	leave  
     586:	c3                   	ret    

00000587 <writetest1>:

void
writetest1(void)
{
     587:	55                   	push   %ebp
     588:	89 e5                	mov    %esp,%ebp
     58a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58d:	a1 fc 62 00 00       	mov    0x62fc,%eax
     592:	c7 44 24 04 18 47 00 	movl   $0x4718,0x4(%esp)
     599:	00 
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 d4 3a 00 00       	call   4076 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 28 47 00 00 	movl   $0x4728,(%esp)
     5b1:	e8 78 39 00 00       	call   3f2e <open>
     5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5bd:	79 1a                	jns    5d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5bf:	a1 fc 62 00 00       	mov    0x62fc,%eax
     5c4:	c7 44 24 04 2c 47 00 	movl   $0x472c,0x4(%esp)
     5cb:	00 
     5cc:	89 04 24             	mov    %eax,(%esp)
     5cf:	e8 a2 3a 00 00       	call   4076 <printf>
    exit();
     5d4:	e8 15 39 00 00       	call   3eee <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5e0:	eb 51                	jmp    633 <writetest1+0xac>
    ((int*)buf)[0] = i;
     5e2:	b8 e0 8a 00 00       	mov    $0x8ae0,%eax
     5e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f3:	00 
     5f4:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
     5fb:	00 
     5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 07 39 00 00       	call   3f0e <write>
     607:	3d 00 02 00 00       	cmp    $0x200,%eax
     60c:	74 21                	je     62f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60e:	a1 fc 62 00 00       	mov    0x62fc,%eax
     613:	8b 55 f4             	mov    -0xc(%ebp),%edx
     616:	89 54 24 08          	mov    %edx,0x8(%esp)
     61a:	c7 44 24 04 46 47 00 	movl   $0x4746,0x4(%esp)
     621:	00 
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 4c 3a 00 00       	call   4076 <printf>
      exit();
     62a:	e8 bf 38 00 00       	call   3eee <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     63b:	76 a5                	jbe    5e2 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 ce 38 00 00       	call   3f16 <close>

  fd = open("big", O_RDONLY);
     648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64f:	00 
     650:	c7 04 24 28 47 00 00 	movl   $0x4728,(%esp)
     657:	e8 d2 38 00 00       	call   3f2e <open>
     65c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     663:	79 1a                	jns    67f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     665:	a1 fc 62 00 00       	mov    0x62fc,%eax
     66a:	c7 44 24 04 64 47 00 	movl   $0x4764,0x4(%esp)
     671:	00 
     672:	89 04 24             	mov    %eax,(%esp)
     675:	e8 fc 39 00 00       	call   4076 <printf>
    exit();
     67a:	e8 6f 38 00 00       	call   3eee <exit>
  }

  n = 0;
     67f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68d:	00 
     68e:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
     695:	00 
     696:	8b 45 ec             	mov    -0x14(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 65 38 00 00       	call   3f06 <read>
     6a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a8:	75 4c                	jne    6f6 <writetest1+0x16f>
      if(n == MAXFILE - 1){
     6aa:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6b1:	75 21                	jne    6d4 <writetest1+0x14d>
        printf(stdout, "read only %d blocks from big", n);
     6b3:	a1 fc 62 00 00       	mov    0x62fc,%eax
     6b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     6bb:	89 54 24 08          	mov    %edx,0x8(%esp)
     6bf:	c7 44 24 04 7d 47 00 	movl   $0x477d,0x4(%esp)
     6c6:	00 
     6c7:	89 04 24             	mov    %eax,(%esp)
     6ca:	e8 a7 39 00 00       	call   4076 <printf>
        exit();
     6cf:	e8 1a 38 00 00       	call   3eee <exit>
      }
      break;
     6d4:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     6d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 36 38 00 00       	call   3f16 <close>
  if(unlink("big") < 0){
     6e0:	c7 04 24 28 47 00 00 	movl   $0x4728,(%esp)
     6e7:	e8 52 38 00 00       	call   3f3e <unlink>
     6ec:	85 c0                	test   %eax,%eax
     6ee:	0f 89 87 00 00 00    	jns    77b <writetest1+0x1f4>
     6f4:	eb 6b                	jmp    761 <writetest1+0x1da>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     6f6:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     6fd:	74 21                	je     720 <writetest1+0x199>
      printf(stdout, "read failed %d\n", i);
     6ff:	a1 fc 62 00 00       	mov    0x62fc,%eax
     704:	8b 55 f4             	mov    -0xc(%ebp),%edx
     707:	89 54 24 08          	mov    %edx,0x8(%esp)
     70b:	c7 44 24 04 9a 47 00 	movl   $0x479a,0x4(%esp)
     712:	00 
     713:	89 04 24             	mov    %eax,(%esp)
     716:	e8 5b 39 00 00       	call   4076 <printf>
      exit();
     71b:	e8 ce 37 00 00       	call   3eee <exit>
    }
    if(((int*)buf)[0] != n){
     720:	b8 e0 8a 00 00       	mov    $0x8ae0,%eax
     725:	8b 00                	mov    (%eax),%eax
     727:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     72a:	74 2c                	je     758 <writetest1+0x1d1>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     72c:	b8 e0 8a 00 00       	mov    $0x8ae0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     731:	8b 10                	mov    (%eax),%edx
     733:	a1 fc 62 00 00       	mov    0x62fc,%eax
     738:	89 54 24 0c          	mov    %edx,0xc(%esp)
     73c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     73f:	89 54 24 08          	mov    %edx,0x8(%esp)
     743:	c7 44 24 04 ac 47 00 	movl   $0x47ac,0x4(%esp)
     74a:	00 
     74b:	89 04 24             	mov    %eax,(%esp)
     74e:	e8 23 39 00 00       	call   4076 <printf>
             n, ((int*)buf)[0]);
      exit();
     753:	e8 96 37 00 00       	call   3eee <exit>
    }
    n++;
     758:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     75c:	e9 25 ff ff ff       	jmp    686 <writetest1+0xff>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     761:	a1 fc 62 00 00       	mov    0x62fc,%eax
     766:	c7 44 24 04 cc 47 00 	movl   $0x47cc,0x4(%esp)
     76d:	00 
     76e:	89 04 24             	mov    %eax,(%esp)
     771:	e8 00 39 00 00       	call   4076 <printf>
    exit();
     776:	e8 73 37 00 00       	call   3eee <exit>
  }
  printf(stdout, "big files ok\n");
     77b:	a1 fc 62 00 00       	mov    0x62fc,%eax
     780:	c7 44 24 04 df 47 00 	movl   $0x47df,0x4(%esp)
     787:	00 
     788:	89 04 24             	mov    %eax,(%esp)
     78b:	e8 e6 38 00 00       	call   4076 <printf>
}
     790:	c9                   	leave  
     791:	c3                   	ret    

00000792 <createtest>:

void
createtest(void)
{
     792:	55                   	push   %ebp
     793:	89 e5                	mov    %esp,%ebp
     795:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     798:	a1 fc 62 00 00       	mov    0x62fc,%eax
     79d:	c7 44 24 04 f0 47 00 	movl   $0x47f0,0x4(%esp)
     7a4:	00 
     7a5:	89 04 24             	mov    %eax,(%esp)
     7a8:	e8 c9 38 00 00       	call   4076 <printf>

  name[0] = 'a';
     7ad:	c6 05 e0 aa 00 00 61 	movb   $0x61,0xaae0
  name[2] = '\0';
     7b4:	c6 05 e2 aa 00 00 00 	movb   $0x0,0xaae2
  for(i = 0; i < 52; i++){
     7bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7c2:	eb 31                	jmp    7f5 <createtest+0x63>
    name[1] = '0' + i;
     7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c7:	83 c0 30             	add    $0x30,%eax
     7ca:	a2 e1 aa 00 00       	mov    %al,0xaae1
    fd = open(name, O_CREATE|O_RDWR);
     7cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d6:	00 
     7d7:	c7 04 24 e0 aa 00 00 	movl   $0xaae0,(%esp)
     7de:	e8 4b 37 00 00       	call   3f2e <open>
     7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e9:	89 04 24             	mov    %eax,(%esp)
     7ec:	e8 25 37 00 00       	call   3f16 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7f5:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     7f9:	7e c9                	jle    7c4 <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7fb:	c6 05 e0 aa 00 00 61 	movb   $0x61,0xaae0
  name[2] = '\0';
     802:	c6 05 e2 aa 00 00 00 	movb   $0x0,0xaae2
  for(i = 0; i < 52; i++){
     809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     810:	eb 1b                	jmp    82d <createtest+0x9b>
    name[1] = '0' + i;
     812:	8b 45 f4             	mov    -0xc(%ebp),%eax
     815:	83 c0 30             	add    $0x30,%eax
     818:	a2 e1 aa 00 00       	mov    %al,0xaae1
    unlink(name);
     81d:	c7 04 24 e0 aa 00 00 	movl   $0xaae0,(%esp)
     824:	e8 15 37 00 00       	call   3f3e <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     829:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     82d:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     831:	7e df                	jle    812 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     833:	a1 fc 62 00 00       	mov    0x62fc,%eax
     838:	c7 44 24 04 18 48 00 	movl   $0x4818,0x4(%esp)
     83f:	00 
     840:	89 04 24             	mov    %eax,(%esp)
     843:	e8 2e 38 00 00       	call   4076 <printf>
}
     848:	c9                   	leave  
     849:	c3                   	ret    

0000084a <dirtest>:

void dirtest(void)
{
     84a:	55                   	push   %ebp
     84b:	89 e5                	mov    %esp,%ebp
     84d:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     850:	a1 fc 62 00 00       	mov    0x62fc,%eax
     855:	c7 44 24 04 3e 48 00 	movl   $0x483e,0x4(%esp)
     85c:	00 
     85d:	89 04 24             	mov    %eax,(%esp)
     860:	e8 11 38 00 00       	call   4076 <printf>

  if(mkdir("dir0") < 0){
     865:	c7 04 24 4a 48 00 00 	movl   $0x484a,(%esp)
     86c:	e8 e5 36 00 00       	call   3f56 <mkdir>
     871:	85 c0                	test   %eax,%eax
     873:	79 1a                	jns    88f <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     875:	a1 fc 62 00 00       	mov    0x62fc,%eax
     87a:	c7 44 24 04 6d 44 00 	movl   $0x446d,0x4(%esp)
     881:	00 
     882:	89 04 24             	mov    %eax,(%esp)
     885:	e8 ec 37 00 00       	call   4076 <printf>
    exit();
     88a:	e8 5f 36 00 00       	call   3eee <exit>
  }

  if(chdir("dir0") < 0){
     88f:	c7 04 24 4a 48 00 00 	movl   $0x484a,(%esp)
     896:	e8 c3 36 00 00       	call   3f5e <chdir>
     89b:	85 c0                	test   %eax,%eax
     89d:	79 1a                	jns    8b9 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     89f:	a1 fc 62 00 00       	mov    0x62fc,%eax
     8a4:	c7 44 24 04 4f 48 00 	movl   $0x484f,0x4(%esp)
     8ab:	00 
     8ac:	89 04 24             	mov    %eax,(%esp)
     8af:	e8 c2 37 00 00       	call   4076 <printf>
    exit();
     8b4:	e8 35 36 00 00       	call   3eee <exit>
  }

  if(chdir("..") < 0){
     8b9:	c7 04 24 62 48 00 00 	movl   $0x4862,(%esp)
     8c0:	e8 99 36 00 00       	call   3f5e <chdir>
     8c5:	85 c0                	test   %eax,%eax
     8c7:	79 1a                	jns    8e3 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c9:	a1 fc 62 00 00       	mov    0x62fc,%eax
     8ce:	c7 44 24 04 65 48 00 	movl   $0x4865,0x4(%esp)
     8d5:	00 
     8d6:	89 04 24             	mov    %eax,(%esp)
     8d9:	e8 98 37 00 00       	call   4076 <printf>
    exit();
     8de:	e8 0b 36 00 00       	call   3eee <exit>
  }

  if(unlink("dir0") < 0){
     8e3:	c7 04 24 4a 48 00 00 	movl   $0x484a,(%esp)
     8ea:	e8 4f 36 00 00       	call   3f3e <unlink>
     8ef:	85 c0                	test   %eax,%eax
     8f1:	79 1a                	jns    90d <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8f3:	a1 fc 62 00 00       	mov    0x62fc,%eax
     8f8:	c7 44 24 04 76 48 00 	movl   $0x4876,0x4(%esp)
     8ff:	00 
     900:	89 04 24             	mov    %eax,(%esp)
     903:	e8 6e 37 00 00       	call   4076 <printf>
    exit();
     908:	e8 e1 35 00 00       	call   3eee <exit>
  }
  printf(stdout, "mkdir test ok\n");
     90d:	a1 fc 62 00 00       	mov    0x62fc,%eax
     912:	c7 44 24 04 8a 48 00 	movl   $0x488a,0x4(%esp)
     919:	00 
     91a:	89 04 24             	mov    %eax,(%esp)
     91d:	e8 54 37 00 00       	call   4076 <printf>
}
     922:	c9                   	leave  
     923:	c3                   	ret    

00000924 <exectest>:

void
exectest(void)
{
     924:	55                   	push   %ebp
     925:	89 e5                	mov    %esp,%ebp
     927:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     92a:	a1 fc 62 00 00       	mov    0x62fc,%eax
     92f:	c7 44 24 04 99 48 00 	movl   $0x4899,0x4(%esp)
     936:	00 
     937:	89 04 24             	mov    %eax,(%esp)
     93a:	e8 37 37 00 00       	call   4076 <printf>
  if(exec("echo", echoargv) < 0){
     93f:	c7 44 24 04 e8 62 00 	movl   $0x62e8,0x4(%esp)
     946:	00 
     947:	c7 04 24 44 44 00 00 	movl   $0x4444,(%esp)
     94e:	e8 d3 35 00 00       	call   3f26 <exec>
     953:	85 c0                	test   %eax,%eax
     955:	79 1a                	jns    971 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     957:	a1 fc 62 00 00       	mov    0x62fc,%eax
     95c:	c7 44 24 04 a4 48 00 	movl   $0x48a4,0x4(%esp)
     963:	00 
     964:	89 04 24             	mov    %eax,(%esp)
     967:	e8 0a 37 00 00       	call   4076 <printf>
    exit();
     96c:	e8 7d 35 00 00       	call   3eee <exit>
  }
}
     971:	c9                   	leave  
     972:	c3                   	ret    

00000973 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     973:	55                   	push   %ebp
     974:	89 e5                	mov    %esp,%ebp
     976:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     979:	8d 45 d8             	lea    -0x28(%ebp),%eax
     97c:	89 04 24             	mov    %eax,(%esp)
     97f:	e8 7a 35 00 00       	call   3efe <pipe>
     984:	85 c0                	test   %eax,%eax
     986:	74 19                	je     9a1 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     988:	c7 44 24 04 b6 48 00 	movl   $0x48b6,0x4(%esp)
     98f:	00 
     990:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     997:	e8 da 36 00 00       	call   4076 <printf>
    exit();
     99c:	e8 4d 35 00 00       	call   3eee <exit>
  }
  pid = fork();
     9a1:	e8 40 35 00 00       	call   3ee6 <fork>
     9a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9b4:	0f 85 88 00 00 00    	jne    a42 <pipe1+0xcf>
    close(fds[0]);
     9ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9bd:	89 04 24             	mov    %eax,(%esp)
     9c0:	e8 51 35 00 00       	call   3f16 <close>
    for(n = 0; n < 5; n++){
     9c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9cc:	eb 69                	jmp    a37 <pipe1+0xc4>
      for(i = 0; i < 1033; i++)
     9ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9d5:	eb 18                	jmp    9ef <pipe1+0x7c>
        buf[i] = seq++;
     9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9da:	8d 50 01             	lea    0x1(%eax),%edx
     9dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9e3:	81 c2 e0 8a 00 00    	add    $0x8ae0,%edx
     9e9:	88 02                	mov    %al,(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9eb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9ef:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     9f6:	7e df                	jle    9d7 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9fb:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     a02:	00 
     a03:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
     a0a:	00 
     a0b:	89 04 24             	mov    %eax,(%esp)
     a0e:	e8 fb 34 00 00       	call   3f0e <write>
     a13:	3d 09 04 00 00       	cmp    $0x409,%eax
     a18:	74 19                	je     a33 <pipe1+0xc0>
        printf(1, "pipe1 oops 1\n");
     a1a:	c7 44 24 04 c5 48 00 	movl   $0x48c5,0x4(%esp)
     a21:	00 
     a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a29:	e8 48 36 00 00       	call   4076 <printf>
        exit();
     a2e:	e8 bb 34 00 00       	call   3eee <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a37:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a3b:	7e 91                	jle    9ce <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a3d:	e8 ac 34 00 00       	call   3eee <exit>
  } else if(pid > 0){
     a42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a46:	0f 8e f9 00 00 00    	jle    b45 <pipe1+0x1d2>
    close(fds[1]);
     a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a4f:	89 04 24             	mov    %eax,(%esp)
     a52:	e8 bf 34 00 00       	call   3f16 <close>
    total = 0;
     a57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     a5e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a65:	eb 68                	jmp    acf <pipe1+0x15c>
      for(i = 0; i < n; i++){
     a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a6e:	eb 3d                	jmp    aad <pipe1+0x13a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a73:	05 e0 8a 00 00       	add    $0x8ae0,%eax
     a78:	0f b6 00             	movzbl (%eax),%eax
     a7b:	0f be c8             	movsbl %al,%ecx
     a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a81:	8d 50 01             	lea    0x1(%eax),%edx
     a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a87:	31 c8                	xor    %ecx,%eax
     a89:	0f b6 c0             	movzbl %al,%eax
     a8c:	85 c0                	test   %eax,%eax
     a8e:	74 19                	je     aa9 <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
     a90:	c7 44 24 04 d3 48 00 	movl   $0x48d3,0x4(%esp)
     a97:	00 
     a98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9f:	e8 d2 35 00 00       	call   4076 <printf>
     aa4:	e9 b5 00 00 00       	jmp    b5e <pipe1+0x1eb>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aa9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ab3:	7c bb                	jl     a70 <pipe1+0xfd>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab8:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     abb:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ac1:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac6:	76 07                	jbe    acf <pipe1+0x15c>
        cc = sizeof(buf);
     ac8:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
     ad5:	89 54 24 08          	mov    %edx,0x8(%esp)
     ad9:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
     ae0:	00 
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 1d 34 00 00       	call   3f06 <read>
     ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     af0:	0f 8f 71 ff ff ff    	jg     a67 <pipe1+0xf4>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     af6:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     afd:	74 20                	je     b1f <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
     aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b02:	89 44 24 08          	mov    %eax,0x8(%esp)
     b06:	c7 44 24 04 e1 48 00 	movl   $0x48e1,0x4(%esp)
     b0d:	00 
     b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b15:	e8 5c 35 00 00       	call   4076 <printf>
      exit();
     b1a:	e8 cf 33 00 00       	call   3eee <exit>
    }
    close(fds[0]);
     b1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b22:	89 04 24             	mov    %eax,(%esp)
     b25:	e8 ec 33 00 00       	call   3f16 <close>
    wait();
     b2a:	e8 c7 33 00 00       	call   3ef6 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b2f:	c7 44 24 04 07 49 00 	movl   $0x4907,0x4(%esp)
     b36:	00 
     b37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b3e:	e8 33 35 00 00       	call   4076 <printf>
     b43:	eb 19                	jmp    b5e <pipe1+0x1eb>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b45:	c7 44 24 04 f8 48 00 	movl   $0x48f8,0x4(%esp)
     b4c:	00 
     b4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b54:	e8 1d 35 00 00       	call   4076 <printf>
    exit();
     b59:	e8 90 33 00 00       	call   3eee <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b5e:	c9                   	leave  
     b5f:	c3                   	ret    

00000b60 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b66:	c7 44 24 04 11 49 00 	movl   $0x4911,0x4(%esp)
     b6d:	00 
     b6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b75:	e8 fc 34 00 00       	call   4076 <printf>
  pid1 = fork();
     b7a:	e8 67 33 00 00       	call   3ee6 <fork>
     b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b86:	75 02                	jne    b8a <preempt+0x2a>
    for(;;)
      ;
     b88:	eb fe                	jmp    b88 <preempt+0x28>

  pid2 = fork();
     b8a:	e8 57 33 00 00       	call   3ee6 <fork>
     b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b96:	75 02                	jne    b9a <preempt+0x3a>
    for(;;)
      ;
     b98:	eb fe                	jmp    b98 <preempt+0x38>

  pipe(pfds);
     b9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b9d:	89 04 24             	mov    %eax,(%esp)
     ba0:	e8 59 33 00 00       	call   3efe <pipe>
  pid3 = fork();
     ba5:	e8 3c 33 00 00       	call   3ee6 <fork>
     baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bb1:	75 4c                	jne    bff <preempt+0x9f>
    close(pfds[0]);
     bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bb6:	89 04 24             	mov    %eax,(%esp)
     bb9:	e8 58 33 00 00       	call   3f16 <close>
    if(write(pfds[1], "x", 1) != 1)
     bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bc8:	00 
     bc9:	c7 44 24 04 1b 49 00 	movl   $0x491b,0x4(%esp)
     bd0:	00 
     bd1:	89 04 24             	mov    %eax,(%esp)
     bd4:	e8 35 33 00 00       	call   3f0e <write>
     bd9:	83 f8 01             	cmp    $0x1,%eax
     bdc:	74 14                	je     bf2 <preempt+0x92>
      printf(1, "preempt write error");
     bde:	c7 44 24 04 1d 49 00 	movl   $0x491d,0x4(%esp)
     be5:	00 
     be6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bed:	e8 84 34 00 00       	call   4076 <printf>
    close(pfds[1]);
     bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf5:	89 04 24             	mov    %eax,(%esp)
     bf8:	e8 19 33 00 00       	call   3f16 <close>
    for(;;)
      ;
     bfd:	eb fe                	jmp    bfd <preempt+0x9d>
  }

  close(pfds[1]);
     bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c02:	89 04 24             	mov    %eax,(%esp)
     c05:	e8 0c 33 00 00       	call   3f16 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c0d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c14:	00 
     c15:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
     c1c:	00 
     c1d:	89 04 24             	mov    %eax,(%esp)
     c20:	e8 e1 32 00 00       	call   3f06 <read>
     c25:	83 f8 01             	cmp    $0x1,%eax
     c28:	74 16                	je     c40 <preempt+0xe0>
    printf(1, "preempt read error");
     c2a:	c7 44 24 04 31 49 00 	movl   $0x4931,0x4(%esp)
     c31:	00 
     c32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c39:	e8 38 34 00 00       	call   4076 <printf>
     c3e:	eb 77                	jmp    cb7 <preempt+0x157>
    return;
  }
  close(pfds[0]);
     c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c43:	89 04 24             	mov    %eax,(%esp)
     c46:	e8 cb 32 00 00       	call   3f16 <close>
  printf(1, "kill... ");
     c4b:	c7 44 24 04 44 49 00 	movl   $0x4944,0x4(%esp)
     c52:	00 
     c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c5a:	e8 17 34 00 00       	call   4076 <printf>
  kill(pid1);
     c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c62:	89 04 24             	mov    %eax,(%esp)
     c65:	e8 b4 32 00 00       	call   3f1e <kill>
  kill(pid2);
     c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6d:	89 04 24             	mov    %eax,(%esp)
     c70:	e8 a9 32 00 00       	call   3f1e <kill>
  kill(pid3);
     c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c78:	89 04 24             	mov    %eax,(%esp)
     c7b:	e8 9e 32 00 00       	call   3f1e <kill>
  printf(1, "wait... ");
     c80:	c7 44 24 04 4d 49 00 	movl   $0x494d,0x4(%esp)
     c87:	00 
     c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8f:	e8 e2 33 00 00       	call   4076 <printf>
  wait();
     c94:	e8 5d 32 00 00       	call   3ef6 <wait>
  wait();
     c99:	e8 58 32 00 00       	call   3ef6 <wait>
  wait();
     c9e:	e8 53 32 00 00       	call   3ef6 <wait>
  printf(1, "preempt ok\n");
     ca3:	c7 44 24 04 56 49 00 	movl   $0x4956,0x4(%esp)
     caa:	00 
     cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb2:	e8 bf 33 00 00       	call   4076 <printf>
}
     cb7:	c9                   	leave  
     cb8:	c3                   	ret    

00000cb9 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cb9:	55                   	push   %ebp
     cba:	89 e5                	mov    %esp,%ebp
     cbc:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cc6:	eb 53                	jmp    d1b <exitwait+0x62>
    pid = fork();
     cc8:	e8 19 32 00 00       	call   3ee6 <fork>
     ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cd4:	79 16                	jns    cec <exitwait+0x33>
      printf(1, "fork failed\n");
     cd6:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
     cdd:	00 
     cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce5:	e8 8c 33 00 00       	call   4076 <printf>
      return;
     cea:	eb 49                	jmp    d35 <exitwait+0x7c>
    }
    if(pid){
     cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cf0:	74 20                	je     d12 <exitwait+0x59>
      if(wait() != pid){
     cf2:	e8 ff 31 00 00       	call   3ef6 <wait>
     cf7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     cfa:	74 1b                	je     d17 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cfc:	c7 44 24 04 62 49 00 	movl   $0x4962,0x4(%esp)
     d03:	00 
     d04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d0b:	e8 66 33 00 00       	call   4076 <printf>
        return;
     d10:	eb 23                	jmp    d35 <exitwait+0x7c>
      }
    } else {
      exit();
     d12:	e8 d7 31 00 00       	call   3eee <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d1b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d1f:	7e a7                	jle    cc8 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d21:	c7 44 24 04 72 49 00 	movl   $0x4972,0x4(%esp)
     d28:	00 
     d29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d30:	e8 41 33 00 00       	call   4076 <printf>
}
     d35:	c9                   	leave  
     d36:	c3                   	ret    

00000d37 <mem>:

void
mem(void)
{
     d37:	55                   	push   %ebp
     d38:	89 e5                	mov    %esp,%ebp
     d3a:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d3d:	c7 44 24 04 7f 49 00 	movl   $0x497f,0x4(%esp)
     d44:	00 
     d45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d4c:	e8 25 33 00 00       	call   4076 <printf>
  ppid = getpid();
     d51:	e8 18 32 00 00       	call   3f6e <getpid>
     d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d59:	e8 88 31 00 00       	call   3ee6 <fork>
     d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d65:	0f 85 aa 00 00 00    	jne    e15 <mem+0xde>
    m1 = 0;
     d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     d72:	eb 0e                	jmp    d82 <mem+0x4b>
      *(char**)m2 = m1;
     d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d7a:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     d82:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     d89:	e8 d4 35 00 00       	call   4362 <malloc>
     d8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d95:	75 dd                	jne    d74 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d97:	eb 19                	jmp    db2 <mem+0x7b>
      m2 = *(char**)m1;
     d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9c:	8b 00                	mov    (%eax),%eax
     d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da4:	89 04 24             	mov    %eax,(%esp)
     da7:	e8 7d 34 00 00       	call   4229 <free>
      m1 = m2;
     dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
     daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     db6:	75 e1                	jne    d99 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     db8:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     dbf:	e8 9e 35 00 00       	call   4362 <malloc>
     dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dcb:	75 24                	jne    df1 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dcd:	c7 44 24 04 89 49 00 	movl   $0x4989,0x4(%esp)
     dd4:	00 
     dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ddc:	e8 95 32 00 00       	call   4076 <printf>
      kill(ppid);
     de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     de4:	89 04 24             	mov    %eax,(%esp)
     de7:	e8 32 31 00 00       	call   3f1e <kill>
      exit();
     dec:	e8 fd 30 00 00       	call   3eee <exit>
    }
    free(m1);
     df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df4:	89 04 24             	mov    %eax,(%esp)
     df7:	e8 2d 34 00 00       	call   4229 <free>
    printf(1, "mem ok\n");
     dfc:	c7 44 24 04 a3 49 00 	movl   $0x49a3,0x4(%esp)
     e03:	00 
     e04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e0b:	e8 66 32 00 00       	call   4076 <printf>
    exit();
     e10:	e8 d9 30 00 00       	call   3eee <exit>
  } else {
    wait();
     e15:	e8 dc 30 00 00       	call   3ef6 <wait>
  }
}
     e1a:	c9                   	leave  
     e1b:	c3                   	ret    

00000e1c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e1c:	55                   	push   %ebp
     e1d:	89 e5                	mov    %esp,%ebp
     e1f:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e22:	c7 44 24 04 ab 49 00 	movl   $0x49ab,0x4(%esp)
     e29:	00 
     e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e31:	e8 40 32 00 00       	call   4076 <printf>

  unlink("sharedfd");
     e36:	c7 04 24 ba 49 00 00 	movl   $0x49ba,(%esp)
     e3d:	e8 fc 30 00 00       	call   3f3e <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e42:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e49:	00 
     e4a:	c7 04 24 ba 49 00 00 	movl   $0x49ba,(%esp)
     e51:	e8 d8 30 00 00       	call   3f2e <open>
     e56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     e59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e5d:	79 19                	jns    e78 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e5f:	c7 44 24 04 c4 49 00 	movl   $0x49c4,0x4(%esp)
     e66:	00 
     e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e6e:	e8 03 32 00 00       	call   4076 <printf>
    return;
     e73:	e9 a0 01 00 00       	jmp    1018 <sharedfd+0x1fc>
  }
  pid = fork();
     e78:	e8 69 30 00 00       	call   3ee6 <fork>
     e7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e84:	75 07                	jne    e8d <sharedfd+0x71>
     e86:	b8 63 00 00 00       	mov    $0x63,%eax
     e8b:	eb 05                	jmp    e92 <sharedfd+0x76>
     e8d:	b8 70 00 00 00       	mov    $0x70,%eax
     e92:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e99:	00 
     e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ea1:	89 04 24             	mov    %eax,(%esp)
     ea4:	e8 98 2e 00 00       	call   3d41 <memset>
  for(i = 0; i < 1000; i++){
     ea9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb0:	eb 39                	jmp    eeb <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eb2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eb9:	00 
     eba:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ec4:	89 04 24             	mov    %eax,(%esp)
     ec7:	e8 42 30 00 00       	call   3f0e <write>
     ecc:	83 f8 0a             	cmp    $0xa,%eax
     ecf:	74 16                	je     ee7 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ed1:	c7 44 24 04 f0 49 00 	movl   $0x49f0,0x4(%esp)
     ed8:	00 
     ed9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ee0:	e8 91 31 00 00       	call   4076 <printf>
      break;
     ee5:	eb 0d                	jmp    ef4 <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     ee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eeb:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     ef2:	7e be                	jle    eb2 <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ef8:	75 05                	jne    eff <sharedfd+0xe3>
    exit();
     efa:	e8 ef 2f 00 00       	call   3eee <exit>
  else
    wait();
     eff:	e8 f2 2f 00 00       	call   3ef6 <wait>
  close(fd);
     f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f07:	89 04 24             	mov    %eax,(%esp)
     f0a:	e8 07 30 00 00       	call   3f16 <close>
  fd = open("sharedfd", 0);
     f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f16:	00 
     f17:	c7 04 24 ba 49 00 00 	movl   $0x49ba,(%esp)
     f1e:	e8 0b 30 00 00       	call   3f2e <open>
     f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f2a:	79 19                	jns    f45 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f2c:	c7 44 24 04 10 4a 00 	movl   $0x4a10,0x4(%esp)
     f33:	00 
     f34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f3b:	e8 36 31 00 00       	call   4076 <printf>
    return;
     f40:	e9 d3 00 00 00       	jmp    1018 <sharedfd+0x1fc>
  }
  nc = np = 0;
     f45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f52:	eb 3b                	jmp    f8f <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
     f54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f5b:	eb 2a                	jmp    f87 <sharedfd+0x16b>
      if(buf[i] == 'c')
     f5d:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f63:	01 d0                	add    %edx,%eax
     f65:	0f b6 00             	movzbl (%eax),%eax
     f68:	3c 63                	cmp    $0x63,%al
     f6a:	75 04                	jne    f70 <sharedfd+0x154>
        nc++;
     f6c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     f70:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f76:	01 d0                	add    %edx,%eax
     f78:	0f b6 00             	movzbl (%eax),%eax
     f7b:	3c 70                	cmp    $0x70,%al
     f7d:	75 04                	jne    f83 <sharedfd+0x167>
        np++;
     f7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f8a:	83 f8 09             	cmp    $0x9,%eax
     f8d:	76 ce                	jbe    f5d <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f8f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f96:	00 
     f97:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa1:	89 04 24             	mov    %eax,(%esp)
     fa4:	e8 5d 2f 00 00       	call   3f06 <read>
     fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
     fac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fb0:	7f a2                	jg     f54 <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb5:	89 04 24             	mov    %eax,(%esp)
     fb8:	e8 59 2f 00 00       	call   3f16 <close>
  unlink("sharedfd");
     fbd:	c7 04 24 ba 49 00 00 	movl   $0x49ba,(%esp)
     fc4:	e8 75 2f 00 00       	call   3f3e <unlink>
  if(nc == 10000 && np == 10000){
     fc9:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fd0:	75 1f                	jne    ff1 <sharedfd+0x1d5>
     fd2:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     fd9:	75 16                	jne    ff1 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
     fdb:	c7 44 24 04 3b 4a 00 	movl   $0x4a3b,0x4(%esp)
     fe2:	00 
     fe3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fea:	e8 87 30 00 00       	call   4076 <printf>
     fef:	eb 27                	jmp    1018 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
     fff:	c7 44 24 04 48 4a 00 	movl   $0x4a48,0x4(%esp)
    1006:	00 
    1007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    100e:	e8 63 30 00 00       	call   4076 <printf>
    exit();
    1013:	e8 d6 2e 00 00       	call   3eee <exit>
  }
}
    1018:	c9                   	leave  
    1019:	c3                   	ret    

0000101a <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
    101a:	55                   	push   %ebp
    101b:	89 e5                	mov    %esp,%ebp
    101d:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
    1020:	c7 44 24 04 5d 4a 00 	movl   $0x4a5d,0x4(%esp)
    1027:	00 
    1028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    102f:	e8 42 30 00 00       	call   4076 <printf>

  unlink("f1");
    1034:	c7 04 24 6c 4a 00 00 	movl   $0x4a6c,(%esp)
    103b:	e8 fe 2e 00 00       	call   3f3e <unlink>
  unlink("f2");
    1040:	c7 04 24 6f 4a 00 00 	movl   $0x4a6f,(%esp)
    1047:	e8 f2 2e 00 00       	call   3f3e <unlink>

  pid = fork();
    104c:	e8 95 2e 00 00       	call   3ee6 <fork>
    1051:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    1054:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1058:	79 19                	jns    1073 <twofiles+0x59>
    printf(1, "fork failed\n");
    105a:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
    1061:	00 
    1062:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1069:	e8 08 30 00 00       	call   4076 <printf>
    exit();
    106e:	e8 7b 2e 00 00       	call   3eee <exit>
  }

  fname = pid ? "f1" : "f2";
    1073:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1077:	74 07                	je     1080 <twofiles+0x66>
    1079:	b8 6c 4a 00 00       	mov    $0x4a6c,%eax
    107e:	eb 05                	jmp    1085 <twofiles+0x6b>
    1080:	b8 6f 4a 00 00       	mov    $0x4a6f,%eax
    1085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
    1088:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    108f:	00 
    1090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1093:	89 04 24             	mov    %eax,(%esp)
    1096:	e8 93 2e 00 00       	call   3f2e <open>
    109b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
    109e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10a2:	79 19                	jns    10bd <twofiles+0xa3>
    printf(1, "create failed\n");
    10a4:	c7 44 24 04 72 4a 00 	movl   $0x4a72,0x4(%esp)
    10ab:	00 
    10ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b3:	e8 be 2f 00 00       	call   4076 <printf>
    exit();
    10b8:	e8 31 2e 00 00       	call   3eee <exit>
  }

  memset(buf, pid?'p':'c', 512);
    10bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    10c1:	74 07                	je     10ca <twofiles+0xb0>
    10c3:	b8 70 00 00 00       	mov    $0x70,%eax
    10c8:	eb 05                	jmp    10cf <twofiles+0xb5>
    10ca:	b8 63 00 00 00       	mov    $0x63,%eax
    10cf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10d6:	00 
    10d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    10db:	c7 04 24 e0 8a 00 00 	movl   $0x8ae0,(%esp)
    10e2:	e8 5a 2c 00 00       	call   3d41 <memset>
  for(i = 0; i < 12; i++){
    10e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10ee:	eb 4b                	jmp    113b <twofiles+0x121>
    if((n = write(fd, buf, 500)) != 500){
    10f0:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    10f7:	00 
    10f8:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    10ff:	00 
    1100:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1103:	89 04 24             	mov    %eax,(%esp)
    1106:	e8 03 2e 00 00       	call   3f0e <write>
    110b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    110e:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
    1115:	74 20                	je     1137 <twofiles+0x11d>
      printf(1, "write failed %d\n", n);
    1117:	8b 45 dc             	mov    -0x24(%ebp),%eax
    111a:	89 44 24 08          	mov    %eax,0x8(%esp)
    111e:	c7 44 24 04 81 4a 00 	movl   $0x4a81,0x4(%esp)
    1125:	00 
    1126:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    112d:	e8 44 2f 00 00       	call   4076 <printf>
      exit();
    1132:	e8 b7 2d 00 00       	call   3eee <exit>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    1137:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    113b:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    113f:	7e af                	jle    10f0 <twofiles+0xd6>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
    1141:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1144:	89 04 24             	mov    %eax,(%esp)
    1147:	e8 ca 2d 00 00       	call   3f16 <close>
  if(pid)
    114c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1150:	74 11                	je     1163 <twofiles+0x149>
    wait();
    1152:	e8 9f 2d 00 00       	call   3ef6 <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
    1157:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    115e:	e9 e7 00 00 00       	jmp    124a <twofiles+0x230>
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
    1163:	e8 86 2d 00 00       	call   3eee <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    1168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    116c:	74 07                	je     1175 <twofiles+0x15b>
    116e:	b8 6c 4a 00 00       	mov    $0x4a6c,%eax
    1173:	eb 05                	jmp    117a <twofiles+0x160>
    1175:	b8 6f 4a 00 00       	mov    $0x4a6f,%eax
    117a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1181:	00 
    1182:	89 04 24             	mov    %eax,(%esp)
    1185:	e8 a4 2d 00 00       	call   3f2e <open>
    118a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
    118d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1194:	eb 58                	jmp    11ee <twofiles+0x1d4>
      for(j = 0; j < n; j++){
    1196:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    119d:	eb 41                	jmp    11e0 <twofiles+0x1c6>
        if(buf[j] != (i?'p':'c')){
    119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11a2:	05 e0 8a 00 00       	add    $0x8ae0,%eax
    11a7:	0f b6 00             	movzbl (%eax),%eax
    11aa:	0f be d0             	movsbl %al,%edx
    11ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11b1:	74 07                	je     11ba <twofiles+0x1a0>
    11b3:	b8 70 00 00 00       	mov    $0x70,%eax
    11b8:	eb 05                	jmp    11bf <twofiles+0x1a5>
    11ba:	b8 63 00 00 00       	mov    $0x63,%eax
    11bf:	39 c2                	cmp    %eax,%edx
    11c1:	74 19                	je     11dc <twofiles+0x1c2>
          printf(1, "wrong char\n");
    11c3:	c7 44 24 04 92 4a 00 	movl   $0x4a92,0x4(%esp)
    11ca:	00 
    11cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11d2:	e8 9f 2e 00 00       	call   4076 <printf>
          exit();
    11d7:	e8 12 2d 00 00       	call   3eee <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11dc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    11e6:	7c b7                	jl     119f <twofiles+0x185>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11eb:	01 45 ec             	add    %eax,-0x14(%ebp)
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11ee:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    11f5:	00 
    11f6:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    11fd:	00 
    11fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1201:	89 04 24             	mov    %eax,(%esp)
    1204:	e8 fd 2c 00 00       	call   3f06 <read>
    1209:	89 45 dc             	mov    %eax,-0x24(%ebp)
    120c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1210:	7f 84                	jg     1196 <twofiles+0x17c>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1212:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1215:	89 04 24             	mov    %eax,(%esp)
    1218:	e8 f9 2c 00 00       	call   3f16 <close>
    if(total != 12*500){
    121d:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1224:	74 20                	je     1246 <twofiles+0x22c>
      printf(1, "wrong length %d\n", total);
    1226:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1229:	89 44 24 08          	mov    %eax,0x8(%esp)
    122d:	c7 44 24 04 9e 4a 00 	movl   $0x4a9e,0x4(%esp)
    1234:	00 
    1235:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    123c:	e8 35 2e 00 00       	call   4076 <printf>
      exit();
    1241:	e8 a8 2c 00 00       	call   3eee <exit>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    1246:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    124a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    124e:	0f 8e 14 ff ff ff    	jle    1168 <twofiles+0x14e>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
    1254:	c7 04 24 6c 4a 00 00 	movl   $0x4a6c,(%esp)
    125b:	e8 de 2c 00 00       	call   3f3e <unlink>
  unlink("f2");
    1260:	c7 04 24 6f 4a 00 00 	movl   $0x4a6f,(%esp)
    1267:	e8 d2 2c 00 00       	call   3f3e <unlink>

  printf(1, "twofiles ok\n");
    126c:	c7 44 24 04 af 4a 00 	movl   $0x4aaf,0x4(%esp)
    1273:	00 
    1274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    127b:	e8 f6 2d 00 00       	call   4076 <printf>
}
    1280:	c9                   	leave  
    1281:	c3                   	ret    

00001282 <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
    1282:	55                   	push   %ebp
    1283:	89 e5                	mov    %esp,%ebp
    1285:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
    1288:	c7 44 24 04 bc 4a 00 	movl   $0x4abc,0x4(%esp)
    128f:	00 
    1290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1297:	e8 da 2d 00 00       	call   4076 <printf>
  pid = fork();
    129c:	e8 45 2c 00 00       	call   3ee6 <fork>
    12a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
    12a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12a8:	79 19                	jns    12c3 <createdelete+0x41>
    printf(1, "fork failed\n");
    12aa:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
    12b1:	00 
    12b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b9:	e8 b8 2d 00 00       	call   4076 <printf>
    exit();
    12be:	e8 2b 2c 00 00       	call   3eee <exit>
  }

  name[0] = pid ? 'p' : 'c';
    12c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12c7:	74 07                	je     12d0 <createdelete+0x4e>
    12c9:	b8 70 00 00 00       	mov    $0x70,%eax
    12ce:	eb 05                	jmp    12d5 <createdelete+0x53>
    12d0:	b8 63 00 00 00       	mov    $0x63,%eax
    12d5:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
    12d8:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
    12dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12e3:	e9 97 00 00 00       	jmp    137f <createdelete+0xfd>
    name[1] = '0' + i;
    12e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12eb:	83 c0 30             	add    $0x30,%eax
    12ee:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
    12f1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    12f8:	00 
    12f9:	8d 45 cc             	lea    -0x34(%ebp),%eax
    12fc:	89 04 24             	mov    %eax,(%esp)
    12ff:	e8 2a 2c 00 00       	call   3f2e <open>
    1304:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    1307:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    130b:	79 19                	jns    1326 <createdelete+0xa4>
      printf(1, "create failed\n");
    130d:	c7 44 24 04 72 4a 00 	movl   $0x4a72,0x4(%esp)
    1314:	00 
    1315:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    131c:	e8 55 2d 00 00       	call   4076 <printf>
      exit();
    1321:	e8 c8 2b 00 00       	call   3eee <exit>
    }
    close(fd);
    1326:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1329:	89 04 24             	mov    %eax,(%esp)
    132c:	e8 e5 2b 00 00       	call   3f16 <close>
    if(i > 0 && (i % 2 ) == 0){
    1331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1335:	7e 44                	jle    137b <createdelete+0xf9>
    1337:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133a:	83 e0 01             	and    $0x1,%eax
    133d:	85 c0                	test   %eax,%eax
    133f:	75 3a                	jne    137b <createdelete+0xf9>
      name[1] = '0' + (i / 2);
    1341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1344:	89 c2                	mov    %eax,%edx
    1346:	c1 ea 1f             	shr    $0x1f,%edx
    1349:	01 d0                	add    %edx,%eax
    134b:	d1 f8                	sar    %eax
    134d:	83 c0 30             	add    $0x30,%eax
    1350:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    1353:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1356:	89 04 24             	mov    %eax,(%esp)
    1359:	e8 e0 2b 00 00       	call   3f3e <unlink>
    135e:	85 c0                	test   %eax,%eax
    1360:	79 19                	jns    137b <createdelete+0xf9>
        printf(1, "unlink failed\n");
    1362:	c7 44 24 04 68 45 00 	movl   $0x4568,0x4(%esp)
    1369:	00 
    136a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1371:	e8 00 2d 00 00       	call   4076 <printf>
        exit();
    1376:	e8 73 2b 00 00       	call   3eee <exit>
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
  for(i = 0; i < N; i++){
    137b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    137f:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1383:	0f 8e 5f ff ff ff    	jle    12e8 <createdelete+0x66>
        exit();
      }
    }
  }

  if(pid==0)
    1389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    138d:	75 05                	jne    1394 <createdelete+0x112>
    exit();
    138f:	e8 5a 2b 00 00       	call   3eee <exit>
  else
    wait();
    1394:	e8 5d 2b 00 00       	call   3ef6 <wait>

  for(i = 0; i < N; i++){
    1399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13a0:	e9 34 01 00 00       	jmp    14d9 <createdelete+0x257>
    name[0] = 'p';
    13a5:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    13a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ac:	83 c0 30             	add    $0x30,%eax
    13af:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    13b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13b9:	00 
    13ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
    13bd:	89 04 24             	mov    %eax,(%esp)
    13c0:	e8 69 2b 00 00       	call   3f2e <open>
    13c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    13c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13cc:	74 06                	je     13d4 <createdelete+0x152>
    13ce:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    13d2:	7e 26                	jle    13fa <createdelete+0x178>
    13d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13d8:	79 20                	jns    13fa <createdelete+0x178>
      printf(1, "oops createdelete %s didn't exist\n", name);
    13da:	8d 45 cc             	lea    -0x34(%ebp),%eax
    13dd:	89 44 24 08          	mov    %eax,0x8(%esp)
    13e1:	c7 44 24 04 d0 4a 00 	movl   $0x4ad0,0x4(%esp)
    13e8:	00 
    13e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f0:	e8 81 2c 00 00       	call   4076 <printf>
      exit();
    13f5:	e8 f4 2a 00 00       	call   3eee <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    13fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13fe:	7e 2c                	jle    142c <createdelete+0x1aa>
    1400:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1404:	7f 26                	jg     142c <createdelete+0x1aa>
    1406:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    140a:	78 20                	js     142c <createdelete+0x1aa>
      printf(1, "oops createdelete %s did exist\n", name);
    140c:	8d 45 cc             	lea    -0x34(%ebp),%eax
    140f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1413:	c7 44 24 04 f4 4a 00 	movl   $0x4af4,0x4(%esp)
    141a:	00 
    141b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1422:	e8 4f 2c 00 00       	call   4076 <printf>
      exit();
    1427:	e8 c2 2a 00 00       	call   3eee <exit>
    }
    if(fd >= 0)
    142c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1430:	78 0b                	js     143d <createdelete+0x1bb>
      close(fd);
    1432:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1435:	89 04 24             	mov    %eax,(%esp)
    1438:	e8 d9 2a 00 00       	call   3f16 <close>

    name[0] = 'c';
    143d:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    1441:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1444:	83 c0 30             	add    $0x30,%eax
    1447:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    144a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1451:	00 
    1452:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1455:	89 04 24             	mov    %eax,(%esp)
    1458:	e8 d1 2a 00 00       	call   3f2e <open>
    145d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    1460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1464:	74 06                	je     146c <createdelete+0x1ea>
    1466:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    146a:	7e 26                	jle    1492 <createdelete+0x210>
    146c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1470:	79 20                	jns    1492 <createdelete+0x210>
      printf(1, "oops createdelete %s didn't exist\n", name);
    1472:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1475:	89 44 24 08          	mov    %eax,0x8(%esp)
    1479:	c7 44 24 04 d0 4a 00 	movl   $0x4ad0,0x4(%esp)
    1480:	00 
    1481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1488:	e8 e9 2b 00 00       	call   4076 <printf>
      exit();
    148d:	e8 5c 2a 00 00       	call   3eee <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    1492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1496:	7e 2c                	jle    14c4 <createdelete+0x242>
    1498:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    149c:	7f 26                	jg     14c4 <createdelete+0x242>
    149e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14a2:	78 20                	js     14c4 <createdelete+0x242>
      printf(1, "oops createdelete %s did exist\n", name);
    14a4:	8d 45 cc             	lea    -0x34(%ebp),%eax
    14a7:	89 44 24 08          	mov    %eax,0x8(%esp)
    14ab:	c7 44 24 04 f4 4a 00 	movl   $0x4af4,0x4(%esp)
    14b2:	00 
    14b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ba:	e8 b7 2b 00 00       	call   4076 <printf>
      exit();
    14bf:	e8 2a 2a 00 00       	call   3eee <exit>
    }
    if(fd >= 0)
    14c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14c8:	78 0b                	js     14d5 <createdelete+0x253>
      close(fd);
    14ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14cd:	89 04 24             	mov    %eax,(%esp)
    14d0:	e8 41 2a 00 00       	call   3f16 <close>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    14d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14d9:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14dd:	0f 8e c2 fe ff ff    	jle    13a5 <createdelete+0x123>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    14e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14ea:	eb 2b                	jmp    1517 <createdelete+0x295>
    name[0] = 'p';
    14ec:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    14f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f3:	83 c0 30             	add    $0x30,%eax
    14f6:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    14f9:	8d 45 cc             	lea    -0x34(%ebp),%eax
    14fc:	89 04 24             	mov    %eax,(%esp)
    14ff:	e8 3a 2a 00 00       	call   3f3e <unlink>
    name[0] = 'c';
    1504:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    1508:	8d 45 cc             	lea    -0x34(%ebp),%eax
    150b:	89 04 24             	mov    %eax,(%esp)
    150e:	e8 2b 2a 00 00       	call   3f3e <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    1513:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1517:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    151b:	7e cf                	jle    14ec <createdelete+0x26a>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
    151d:	c7 44 24 04 14 4b 00 	movl   $0x4b14,0x4(%esp)
    1524:	00 
    1525:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    152c:	e8 45 2b 00 00       	call   4076 <printf>
}
    1531:	c9                   	leave  
    1532:	c3                   	ret    

00001533 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1533:	55                   	push   %ebp
    1534:	89 e5                	mov    %esp,%ebp
    1536:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1539:	c7 44 24 04 25 4b 00 	movl   $0x4b25,0x4(%esp)
    1540:	00 
    1541:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1548:	e8 29 2b 00 00       	call   4076 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    154d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1554:	00 
    1555:	c7 04 24 36 4b 00 00 	movl   $0x4b36,(%esp)
    155c:	e8 cd 29 00 00       	call   3f2e <open>
    1561:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1568:	79 19                	jns    1583 <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    156a:	c7 44 24 04 41 4b 00 	movl   $0x4b41,0x4(%esp)
    1571:	00 
    1572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1579:	e8 f8 2a 00 00       	call   4076 <printf>
    exit();
    157e:	e8 6b 29 00 00       	call   3eee <exit>
  }
  write(fd, "hello", 5);
    1583:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    158a:	00 
    158b:	c7 44 24 04 5b 4b 00 	movl   $0x4b5b,0x4(%esp)
    1592:	00 
    1593:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1596:	89 04 24             	mov    %eax,(%esp)
    1599:	e8 70 29 00 00       	call   3f0e <write>
  close(fd);
    159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a1:	89 04 24             	mov    %eax,(%esp)
    15a4:	e8 6d 29 00 00       	call   3f16 <close>

  fd = open("unlinkread", O_RDWR);
    15a9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    15b0:	00 
    15b1:	c7 04 24 36 4b 00 00 	movl   $0x4b36,(%esp)
    15b8:	e8 71 29 00 00       	call   3f2e <open>
    15bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c4:	79 19                	jns    15df <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    15c6:	c7 44 24 04 61 4b 00 	movl   $0x4b61,0x4(%esp)
    15cd:	00 
    15ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15d5:	e8 9c 2a 00 00       	call   4076 <printf>
    exit();
    15da:	e8 0f 29 00 00       	call   3eee <exit>
  }
  if(unlink("unlinkread") != 0){
    15df:	c7 04 24 36 4b 00 00 	movl   $0x4b36,(%esp)
    15e6:	e8 53 29 00 00       	call   3f3e <unlink>
    15eb:	85 c0                	test   %eax,%eax
    15ed:	74 19                	je     1608 <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    15ef:	c7 44 24 04 79 4b 00 	movl   $0x4b79,0x4(%esp)
    15f6:	00 
    15f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15fe:	e8 73 2a 00 00       	call   4076 <printf>
    exit();
    1603:	e8 e6 28 00 00       	call   3eee <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1608:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    160f:	00 
    1610:	c7 04 24 36 4b 00 00 	movl   $0x4b36,(%esp)
    1617:	e8 12 29 00 00       	call   3f2e <open>
    161c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    161f:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    1626:	00 
    1627:	c7 44 24 04 93 4b 00 	movl   $0x4b93,0x4(%esp)
    162e:	00 
    162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1632:	89 04 24             	mov    %eax,(%esp)
    1635:	e8 d4 28 00 00       	call   3f0e <write>
  close(fd1);
    163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    163d:	89 04 24             	mov    %eax,(%esp)
    1640:	e8 d1 28 00 00       	call   3f16 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1645:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    164c:	00 
    164d:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    1654:	00 
    1655:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1658:	89 04 24             	mov    %eax,(%esp)
    165b:	e8 a6 28 00 00       	call   3f06 <read>
    1660:	83 f8 05             	cmp    $0x5,%eax
    1663:	74 19                	je     167e <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    1665:	c7 44 24 04 97 4b 00 	movl   $0x4b97,0x4(%esp)
    166c:	00 
    166d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1674:	e8 fd 29 00 00       	call   4076 <printf>
    exit();
    1679:	e8 70 28 00 00       	call   3eee <exit>
  }
  if(buf[0] != 'h'){
    167e:	0f b6 05 e0 8a 00 00 	movzbl 0x8ae0,%eax
    1685:	3c 68                	cmp    $0x68,%al
    1687:	74 19                	je     16a2 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    1689:	c7 44 24 04 ae 4b 00 	movl   $0x4bae,0x4(%esp)
    1690:	00 
    1691:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1698:	e8 d9 29 00 00       	call   4076 <printf>
    exit();
    169d:	e8 4c 28 00 00       	call   3eee <exit>
  }
  if(write(fd, buf, 10) != 10){
    16a2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    16a9:	00 
    16aa:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    16b1:	00 
    16b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16b5:	89 04 24             	mov    %eax,(%esp)
    16b8:	e8 51 28 00 00       	call   3f0e <write>
    16bd:	83 f8 0a             	cmp    $0xa,%eax
    16c0:	74 19                	je     16db <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    16c2:	c7 44 24 04 c5 4b 00 	movl   $0x4bc5,0x4(%esp)
    16c9:	00 
    16ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16d1:	e8 a0 29 00 00       	call   4076 <printf>
    exit();
    16d6:	e8 13 28 00 00       	call   3eee <exit>
  }
  close(fd);
    16db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16de:	89 04 24             	mov    %eax,(%esp)
    16e1:	e8 30 28 00 00       	call   3f16 <close>
  unlink("unlinkread");
    16e6:	c7 04 24 36 4b 00 00 	movl   $0x4b36,(%esp)
    16ed:	e8 4c 28 00 00       	call   3f3e <unlink>
  printf(1, "unlinkread ok\n");
    16f2:	c7 44 24 04 de 4b 00 	movl   $0x4bde,0x4(%esp)
    16f9:	00 
    16fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1701:	e8 70 29 00 00       	call   4076 <printf>
}
    1706:	c9                   	leave  
    1707:	c3                   	ret    

00001708 <linktest>:

void
linktest(void)
{
    1708:	55                   	push   %ebp
    1709:	89 e5                	mov    %esp,%ebp
    170b:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    170e:	c7 44 24 04 ed 4b 00 	movl   $0x4bed,0x4(%esp)
    1715:	00 
    1716:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    171d:	e8 54 29 00 00       	call   4076 <printf>

  unlink("lf1");
    1722:	c7 04 24 f7 4b 00 00 	movl   $0x4bf7,(%esp)
    1729:	e8 10 28 00 00       	call   3f3e <unlink>
  unlink("lf2");
    172e:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    1735:	e8 04 28 00 00       	call   3f3e <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    173a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1741:	00 
    1742:	c7 04 24 f7 4b 00 00 	movl   $0x4bf7,(%esp)
    1749:	e8 e0 27 00 00       	call   3f2e <open>
    174e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1755:	79 19                	jns    1770 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    1757:	c7 44 24 04 ff 4b 00 	movl   $0x4bff,0x4(%esp)
    175e:	00 
    175f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1766:	e8 0b 29 00 00       	call   4076 <printf>
    exit();
    176b:	e8 7e 27 00 00       	call   3eee <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1770:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1777:	00 
    1778:	c7 44 24 04 5b 4b 00 	movl   $0x4b5b,0x4(%esp)
    177f:	00 
    1780:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1783:	89 04 24             	mov    %eax,(%esp)
    1786:	e8 83 27 00 00       	call   3f0e <write>
    178b:	83 f8 05             	cmp    $0x5,%eax
    178e:	74 19                	je     17a9 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    1790:	c7 44 24 04 12 4c 00 	movl   $0x4c12,0x4(%esp)
    1797:	00 
    1798:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    179f:	e8 d2 28 00 00       	call   4076 <printf>
    exit();
    17a4:	e8 45 27 00 00       	call   3eee <exit>
  }
  close(fd);
    17a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ac:	89 04 24             	mov    %eax,(%esp)
    17af:	e8 62 27 00 00       	call   3f16 <close>

  if(link("lf1", "lf2") < 0){
    17b4:	c7 44 24 04 fb 4b 00 	movl   $0x4bfb,0x4(%esp)
    17bb:	00 
    17bc:	c7 04 24 f7 4b 00 00 	movl   $0x4bf7,(%esp)
    17c3:	e8 86 27 00 00       	call   3f4e <link>
    17c8:	85 c0                	test   %eax,%eax
    17ca:	79 19                	jns    17e5 <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    17cc:	c7 44 24 04 24 4c 00 	movl   $0x4c24,0x4(%esp)
    17d3:	00 
    17d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17db:	e8 96 28 00 00       	call   4076 <printf>
    exit();
    17e0:	e8 09 27 00 00       	call   3eee <exit>
  }
  unlink("lf1");
    17e5:	c7 04 24 f7 4b 00 00 	movl   $0x4bf7,(%esp)
    17ec:	e8 4d 27 00 00       	call   3f3e <unlink>

  if(open("lf1", 0) >= 0){
    17f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17f8:	00 
    17f9:	c7 04 24 f7 4b 00 00 	movl   $0x4bf7,(%esp)
    1800:	e8 29 27 00 00       	call   3f2e <open>
    1805:	85 c0                	test   %eax,%eax
    1807:	78 19                	js     1822 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    1809:	c7 44 24 04 3c 4c 00 	movl   $0x4c3c,0x4(%esp)
    1810:	00 
    1811:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1818:	e8 59 28 00 00       	call   4076 <printf>
    exit();
    181d:	e8 cc 26 00 00       	call   3eee <exit>
  }

  fd = open("lf2", 0);
    1822:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1829:	00 
    182a:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    1831:	e8 f8 26 00 00       	call   3f2e <open>
    1836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    183d:	79 19                	jns    1858 <linktest+0x150>
    printf(1, "open lf2 failed\n");
    183f:	c7 44 24 04 61 4c 00 	movl   $0x4c61,0x4(%esp)
    1846:	00 
    1847:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184e:	e8 23 28 00 00       	call   4076 <printf>
    exit();
    1853:	e8 96 26 00 00       	call   3eee <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1858:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    185f:	00 
    1860:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    1867:	00 
    1868:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186b:	89 04 24             	mov    %eax,(%esp)
    186e:	e8 93 26 00 00       	call   3f06 <read>
    1873:	83 f8 05             	cmp    $0x5,%eax
    1876:	74 19                	je     1891 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    1878:	c7 44 24 04 72 4c 00 	movl   $0x4c72,0x4(%esp)
    187f:	00 
    1880:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1887:	e8 ea 27 00 00       	call   4076 <printf>
    exit();
    188c:	e8 5d 26 00 00       	call   3eee <exit>
  }
  close(fd);
    1891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1894:	89 04 24             	mov    %eax,(%esp)
    1897:	e8 7a 26 00 00       	call   3f16 <close>

  if(link("lf2", "lf2") >= 0){
    189c:	c7 44 24 04 fb 4b 00 	movl   $0x4bfb,0x4(%esp)
    18a3:	00 
    18a4:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    18ab:	e8 9e 26 00 00       	call   3f4e <link>
    18b0:	85 c0                	test   %eax,%eax
    18b2:	78 19                	js     18cd <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    18b4:	c7 44 24 04 83 4c 00 	movl   $0x4c83,0x4(%esp)
    18bb:	00 
    18bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c3:	e8 ae 27 00 00       	call   4076 <printf>
    exit();
    18c8:	e8 21 26 00 00       	call   3eee <exit>
  }

  unlink("lf2");
    18cd:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    18d4:	e8 65 26 00 00       	call   3f3e <unlink>
  if(link("lf2", "lf1") >= 0){
    18d9:	c7 44 24 04 f7 4b 00 	movl   $0x4bf7,0x4(%esp)
    18e0:	00 
    18e1:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    18e8:	e8 61 26 00 00       	call   3f4e <link>
    18ed:	85 c0                	test   %eax,%eax
    18ef:	78 19                	js     190a <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    18f1:	c7 44 24 04 a4 4c 00 	movl   $0x4ca4,0x4(%esp)
    18f8:	00 
    18f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1900:	e8 71 27 00 00       	call   4076 <printf>
    exit();
    1905:	e8 e4 25 00 00       	call   3eee <exit>
  }

  if(link(".", "lf1") >= 0){
    190a:	c7 44 24 04 f7 4b 00 	movl   $0x4bf7,0x4(%esp)
    1911:	00 
    1912:	c7 04 24 c7 4c 00 00 	movl   $0x4cc7,(%esp)
    1919:	e8 30 26 00 00       	call   3f4e <link>
    191e:	85 c0                	test   %eax,%eax
    1920:	78 19                	js     193b <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    1922:	c7 44 24 04 c9 4c 00 	movl   $0x4cc9,0x4(%esp)
    1929:	00 
    192a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1931:	e8 40 27 00 00       	call   4076 <printf>
    exit();
    1936:	e8 b3 25 00 00       	call   3eee <exit>
  }

  printf(1, "linktest ok\n");
    193b:	c7 44 24 04 e5 4c 00 	movl   $0x4ce5,0x4(%esp)
    1942:	00 
    1943:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    194a:	e8 27 27 00 00       	call   4076 <printf>
}
    194f:	c9                   	leave  
    1950:	c3                   	ret    

00001951 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1951:	55                   	push   %ebp
    1952:	89 e5                	mov    %esp,%ebp
    1954:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1957:	c7 44 24 04 f2 4c 00 	movl   $0x4cf2,0x4(%esp)
    195e:	00 
    195f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1966:	e8 0b 27 00 00       	call   4076 <printf>
  file[0] = 'C';
    196b:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    196f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    197a:	e9 f7 00 00 00       	jmp    1a76 <concreate+0x125>
    file[1] = '0' + i;
    197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1982:	83 c0 30             	add    $0x30,%eax
    1985:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1988:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198b:	89 04 24             	mov    %eax,(%esp)
    198e:	e8 ab 25 00 00       	call   3f3e <unlink>
    pid = fork();
    1993:	e8 4e 25 00 00       	call   3ee6 <fork>
    1998:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    199b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    199f:	74 3a                	je     19db <concreate+0x8a>
    19a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19a4:	ba 56 55 55 55       	mov    $0x55555556,%edx
    19a9:	89 c8                	mov    %ecx,%eax
    19ab:	f7 ea                	imul   %edx
    19ad:	89 c8                	mov    %ecx,%eax
    19af:	c1 f8 1f             	sar    $0x1f,%eax
    19b2:	29 c2                	sub    %eax,%edx
    19b4:	89 d0                	mov    %edx,%eax
    19b6:	01 c0                	add    %eax,%eax
    19b8:	01 d0                	add    %edx,%eax
    19ba:	29 c1                	sub    %eax,%ecx
    19bc:	89 ca                	mov    %ecx,%edx
    19be:	83 fa 01             	cmp    $0x1,%edx
    19c1:	75 18                	jne    19db <concreate+0x8a>
      link("C0", file);
    19c3:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    19ca:	c7 04 24 02 4d 00 00 	movl   $0x4d02,(%esp)
    19d1:	e8 78 25 00 00       	call   3f4e <link>
    19d6:	e9 87 00 00 00       	jmp    1a62 <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    19db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19df:	75 3a                	jne    1a1b <concreate+0xca>
    19e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19e4:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19e9:	89 c8                	mov    %ecx,%eax
    19eb:	f7 ea                	imul   %edx
    19ed:	d1 fa                	sar    %edx
    19ef:	89 c8                	mov    %ecx,%eax
    19f1:	c1 f8 1f             	sar    $0x1f,%eax
    19f4:	29 c2                	sub    %eax,%edx
    19f6:	89 d0                	mov    %edx,%eax
    19f8:	c1 e0 02             	shl    $0x2,%eax
    19fb:	01 d0                	add    %edx,%eax
    19fd:	29 c1                	sub    %eax,%ecx
    19ff:	89 ca                	mov    %ecx,%edx
    1a01:	83 fa 01             	cmp    $0x1,%edx
    1a04:	75 15                	jne    1a1b <concreate+0xca>
      link("C0", file);
    1a06:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a09:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a0d:	c7 04 24 02 4d 00 00 	movl   $0x4d02,(%esp)
    1a14:	e8 35 25 00 00       	call   3f4e <link>
    1a19:	eb 47                	jmp    1a62 <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1a1b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1a22:	00 
    1a23:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a26:	89 04 24             	mov    %eax,(%esp)
    1a29:	e8 00 25 00 00       	call   3f2e <open>
    1a2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    1a31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a35:	79 20                	jns    1a57 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    1a37:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a3e:	c7 44 24 04 05 4d 00 	movl   $0x4d05,0x4(%esp)
    1a45:	00 
    1a46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a4d:	e8 24 26 00 00       	call   4076 <printf>
        exit();
    1a52:	e8 97 24 00 00       	call   3eee <exit>
      }
      close(fd);
    1a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a5a:	89 04 24             	mov    %eax,(%esp)
    1a5d:	e8 b4 24 00 00       	call   3f16 <close>
    }
    if(pid == 0)
    1a62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a66:	75 05                	jne    1a6d <concreate+0x11c>
      exit();
    1a68:	e8 81 24 00 00       	call   3eee <exit>
    else
      wait();
    1a6d:	e8 84 24 00 00       	call   3ef6 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a76:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a7a:	0f 8e ff fe ff ff    	jle    197f <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a80:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a87:	00 
    1a88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a8f:	00 
    1a90:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a93:	89 04 24             	mov    %eax,(%esp)
    1a96:	e8 a6 22 00 00       	call   3d41 <memset>
  fd = open(".", 0);
    1a9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1aa2:	00 
    1aa3:	c7 04 24 c7 4c 00 00 	movl   $0x4cc7,(%esp)
    1aaa:	e8 7f 24 00 00       	call   3f2e <open>
    1aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1ab2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1ab9:	e9 a1 00 00 00       	jmp    1b5f <concreate+0x20e>
    if(de.inum == 0)
    1abe:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1ac2:	66 85 c0             	test   %ax,%ax
    1ac5:	75 05                	jne    1acc <concreate+0x17b>
      continue;
    1ac7:	e9 93 00 00 00       	jmp    1b5f <concreate+0x20e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1acc:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1ad0:	3c 43                	cmp    $0x43,%al
    1ad2:	0f 85 87 00 00 00    	jne    1b5f <concreate+0x20e>
    1ad8:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1adc:	84 c0                	test   %al,%al
    1ade:	75 7f                	jne    1b5f <concreate+0x20e>
      i = de.name[1] - '0';
    1ae0:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1ae4:	0f be c0             	movsbl %al,%eax
    1ae7:	83 e8 30             	sub    $0x30,%eax
    1aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1af1:	78 08                	js     1afb <concreate+0x1aa>
    1af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1af6:	83 f8 27             	cmp    $0x27,%eax
    1af9:	76 23                	jbe    1b1e <concreate+0x1cd>
        printf(1, "concreate weird file %s\n", de.name);
    1afb:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1afe:	83 c0 02             	add    $0x2,%eax
    1b01:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b05:	c7 44 24 04 21 4d 00 	movl   $0x4d21,0x4(%esp)
    1b0c:	00 
    1b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b14:	e8 5d 25 00 00       	call   4076 <printf>
        exit();
    1b19:	e8 d0 23 00 00       	call   3eee <exit>
      }
      if(fa[i]){
    1b1e:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b24:	01 d0                	add    %edx,%eax
    1b26:	0f b6 00             	movzbl (%eax),%eax
    1b29:	84 c0                	test   %al,%al
    1b2b:	74 23                	je     1b50 <concreate+0x1ff>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b2d:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b30:	83 c0 02             	add    $0x2,%eax
    1b33:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b37:	c7 44 24 04 3a 4d 00 	movl   $0x4d3a,0x4(%esp)
    1b3e:	00 
    1b3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b46:	e8 2b 25 00 00       	call   4076 <printf>
        exit();
    1b4b:	e8 9e 23 00 00       	call   3eee <exit>
      }
      fa[i] = 1;
    1b50:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b56:	01 d0                	add    %edx,%eax
    1b58:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b5b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b5f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1b66:	00 
    1b67:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b71:	89 04 24             	mov    %eax,(%esp)
    1b74:	e8 8d 23 00 00       	call   3f06 <read>
    1b79:	85 c0                	test   %eax,%eax
    1b7b:	0f 8f 3d ff ff ff    	jg     1abe <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b81:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b84:	89 04 24             	mov    %eax,(%esp)
    1b87:	e8 8a 23 00 00       	call   3f16 <close>

  if(n != 40){
    1b8c:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b90:	74 19                	je     1bab <concreate+0x25a>
    printf(1, "concreate not enough files in directory listing\n");
    1b92:	c7 44 24 04 58 4d 00 	movl   $0x4d58,0x4(%esp)
    1b99:	00 
    1b9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ba1:	e8 d0 24 00 00       	call   4076 <printf>
    exit();
    1ba6:	e8 43 23 00 00       	call   3eee <exit>
  }

  for(i = 0; i < 40; i++){
    1bab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bb2:	e9 2d 01 00 00       	jmp    1ce4 <concreate+0x393>
    file[1] = '0' + i;
    1bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bba:	83 c0 30             	add    $0x30,%eax
    1bbd:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1bc0:	e8 21 23 00 00       	call   3ee6 <fork>
    1bc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1bc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bcc:	79 19                	jns    1be7 <concreate+0x296>
      printf(1, "fork failed\n");
    1bce:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
    1bd5:	00 
    1bd6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bdd:	e8 94 24 00 00       	call   4076 <printf>
      exit();
    1be2:	e8 07 23 00 00       	call   3eee <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1be7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bea:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bef:	89 c8                	mov    %ecx,%eax
    1bf1:	f7 ea                	imul   %edx
    1bf3:	89 c8                	mov    %ecx,%eax
    1bf5:	c1 f8 1f             	sar    $0x1f,%eax
    1bf8:	29 c2                	sub    %eax,%edx
    1bfa:	89 d0                	mov    %edx,%eax
    1bfc:	01 c0                	add    %eax,%eax
    1bfe:	01 d0                	add    %edx,%eax
    1c00:	29 c1                	sub    %eax,%ecx
    1c02:	89 ca                	mov    %ecx,%edx
    1c04:	85 d2                	test   %edx,%edx
    1c06:	75 06                	jne    1c0e <concreate+0x2bd>
    1c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c0c:	74 28                	je     1c36 <concreate+0x2e5>
       ((i % 3) == 1 && pid != 0)){
    1c0e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1c11:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1c16:	89 c8                	mov    %ecx,%eax
    1c18:	f7 ea                	imul   %edx
    1c1a:	89 c8                	mov    %ecx,%eax
    1c1c:	c1 f8 1f             	sar    $0x1f,%eax
    1c1f:	29 c2                	sub    %eax,%edx
    1c21:	89 d0                	mov    %edx,%eax
    1c23:	01 c0                	add    %eax,%eax
    1c25:	01 d0                	add    %edx,%eax
    1c27:	29 c1                	sub    %eax,%ecx
    1c29:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1c2b:	83 fa 01             	cmp    $0x1,%edx
    1c2e:	75 74                	jne    1ca4 <concreate+0x353>
       ((i % 3) == 1 && pid != 0)){
    1c30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c34:	74 6e                	je     1ca4 <concreate+0x353>
      close(open(file, 0));
    1c36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c3d:	00 
    1c3e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c41:	89 04 24             	mov    %eax,(%esp)
    1c44:	e8 e5 22 00 00       	call   3f2e <open>
    1c49:	89 04 24             	mov    %eax,(%esp)
    1c4c:	e8 c5 22 00 00       	call   3f16 <close>
      close(open(file, 0));
    1c51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c58:	00 
    1c59:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c5c:	89 04 24             	mov    %eax,(%esp)
    1c5f:	e8 ca 22 00 00       	call   3f2e <open>
    1c64:	89 04 24             	mov    %eax,(%esp)
    1c67:	e8 aa 22 00 00       	call   3f16 <close>
      close(open(file, 0));
    1c6c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c73:	00 
    1c74:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c77:	89 04 24             	mov    %eax,(%esp)
    1c7a:	e8 af 22 00 00       	call   3f2e <open>
    1c7f:	89 04 24             	mov    %eax,(%esp)
    1c82:	e8 8f 22 00 00       	call   3f16 <close>
      close(open(file, 0));
    1c87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c8e:	00 
    1c8f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c92:	89 04 24             	mov    %eax,(%esp)
    1c95:	e8 94 22 00 00       	call   3f2e <open>
    1c9a:	89 04 24             	mov    %eax,(%esp)
    1c9d:	e8 74 22 00 00       	call   3f16 <close>
    1ca2:	eb 2c                	jmp    1cd0 <concreate+0x37f>
    } else {
      unlink(file);
    1ca4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1ca7:	89 04 24             	mov    %eax,(%esp)
    1caa:	e8 8f 22 00 00       	call   3f3e <unlink>
      unlink(file);
    1caf:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cb2:	89 04 24             	mov    %eax,(%esp)
    1cb5:	e8 84 22 00 00       	call   3f3e <unlink>
      unlink(file);
    1cba:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cbd:	89 04 24             	mov    %eax,(%esp)
    1cc0:	e8 79 22 00 00       	call   3f3e <unlink>
      unlink(file);
    1cc5:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cc8:	89 04 24             	mov    %eax,(%esp)
    1ccb:	e8 6e 22 00 00       	call   3f3e <unlink>
    }
    if(pid == 0)
    1cd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cd4:	75 05                	jne    1cdb <concreate+0x38a>
      exit();
    1cd6:	e8 13 22 00 00       	call   3eee <exit>
    else
      wait();
    1cdb:	e8 16 22 00 00       	call   3ef6 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1ce0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ce4:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1ce8:	0f 8e c9 fe ff ff    	jle    1bb7 <concreate+0x266>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1cee:	c7 44 24 04 89 4d 00 	movl   $0x4d89,0x4(%esp)
    1cf5:	00 
    1cf6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cfd:	e8 74 23 00 00       	call   4076 <printf>
}
    1d02:	c9                   	leave  
    1d03:	c3                   	ret    

00001d04 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1d04:	55                   	push   %ebp
    1d05:	89 e5                	mov    %esp,%ebp
    1d07:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1d0a:	c7 44 24 04 97 4d 00 	movl   $0x4d97,0x4(%esp)
    1d11:	00 
    1d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d19:	e8 58 23 00 00       	call   4076 <printf>

  unlink("x");
    1d1e:	c7 04 24 1b 49 00 00 	movl   $0x491b,(%esp)
    1d25:	e8 14 22 00 00       	call   3f3e <unlink>
  pid = fork();
    1d2a:	e8 b7 21 00 00       	call   3ee6 <fork>
    1d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d36:	79 19                	jns    1d51 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d38:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
    1d3f:	00 
    1d40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d47:	e8 2a 23 00 00       	call   4076 <printf>
    exit();
    1d4c:	e8 9d 21 00 00       	call   3eee <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d55:	74 07                	je     1d5e <linkunlink+0x5a>
    1d57:	b8 01 00 00 00       	mov    $0x1,%eax
    1d5c:	eb 05                	jmp    1d63 <linkunlink+0x5f>
    1d5e:	b8 61 00 00 00       	mov    $0x61,%eax
    1d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d6d:	e9 8e 00 00 00       	jmp    1e00 <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d75:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d7b:	05 39 30 00 00       	add    $0x3039,%eax
    1d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d86:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d8b:	89 c8                	mov    %ecx,%eax
    1d8d:	f7 e2                	mul    %edx
    1d8f:	d1 ea                	shr    %edx
    1d91:	89 d0                	mov    %edx,%eax
    1d93:	01 c0                	add    %eax,%eax
    1d95:	01 d0                	add    %edx,%eax
    1d97:	29 c1                	sub    %eax,%ecx
    1d99:	89 ca                	mov    %ecx,%edx
    1d9b:	85 d2                	test   %edx,%edx
    1d9d:	75 1e                	jne    1dbd <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1d9f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1da6:	00 
    1da7:	c7 04 24 1b 49 00 00 	movl   $0x491b,(%esp)
    1dae:	e8 7b 21 00 00       	call   3f2e <open>
    1db3:	89 04 24             	mov    %eax,(%esp)
    1db6:	e8 5b 21 00 00       	call   3f16 <close>
    1dbb:	eb 3f                	jmp    1dfc <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1dbd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1dc0:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1dc5:	89 c8                	mov    %ecx,%eax
    1dc7:	f7 e2                	mul    %edx
    1dc9:	d1 ea                	shr    %edx
    1dcb:	89 d0                	mov    %edx,%eax
    1dcd:	01 c0                	add    %eax,%eax
    1dcf:	01 d0                	add    %edx,%eax
    1dd1:	29 c1                	sub    %eax,%ecx
    1dd3:	89 ca                	mov    %ecx,%edx
    1dd5:	83 fa 01             	cmp    $0x1,%edx
    1dd8:	75 16                	jne    1df0 <linkunlink+0xec>
      link("cat", "x");
    1dda:	c7 44 24 04 1b 49 00 	movl   $0x491b,0x4(%esp)
    1de1:	00 
    1de2:	c7 04 24 a8 4d 00 00 	movl   $0x4da8,(%esp)
    1de9:	e8 60 21 00 00       	call   3f4e <link>
    1dee:	eb 0c                	jmp    1dfc <linkunlink+0xf8>
    } else {
      unlink("x");
    1df0:	c7 04 24 1b 49 00 00 	movl   $0x491b,(%esp)
    1df7:	e8 42 21 00 00       	call   3f3e <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1dfc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1e00:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1e04:	0f 8e 68 ff ff ff    	jle    1d72 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1e0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1e0e:	74 07                	je     1e17 <linkunlink+0x113>
    wait();
    1e10:	e8 e1 20 00 00       	call   3ef6 <wait>
    1e15:	eb 05                	jmp    1e1c <linkunlink+0x118>
  else 
    exit();
    1e17:	e8 d2 20 00 00       	call   3eee <exit>

  printf(1, "linkunlink ok\n");
    1e1c:	c7 44 24 04 ac 4d 00 	movl   $0x4dac,0x4(%esp)
    1e23:	00 
    1e24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e2b:	e8 46 22 00 00       	call   4076 <printf>
}
    1e30:	c9                   	leave  
    1e31:	c3                   	ret    

00001e32 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e32:	55                   	push   %ebp
    1e33:	89 e5                	mov    %esp,%ebp
    1e35:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e38:	c7 44 24 04 bb 4d 00 	movl   $0x4dbb,0x4(%esp)
    1e3f:	00 
    1e40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e47:	e8 2a 22 00 00       	call   4076 <printf>
  unlink("bd");
    1e4c:	c7 04 24 c8 4d 00 00 	movl   $0x4dc8,(%esp)
    1e53:	e8 e6 20 00 00       	call   3f3e <unlink>

  fd = open("bd", O_CREATE);
    1e58:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e5f:	00 
    1e60:	c7 04 24 c8 4d 00 00 	movl   $0x4dc8,(%esp)
    1e67:	e8 c2 20 00 00       	call   3f2e <open>
    1e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e73:	79 19                	jns    1e8e <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1e75:	c7 44 24 04 cb 4d 00 	movl   $0x4dcb,0x4(%esp)
    1e7c:	00 
    1e7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e84:	e8 ed 21 00 00       	call   4076 <printf>
    exit();
    1e89:	e8 60 20 00 00       	call   3eee <exit>
  }
  close(fd);
    1e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e91:	89 04 24             	mov    %eax,(%esp)
    1e94:	e8 7d 20 00 00       	call   3f16 <close>

  for(i = 0; i < 500; i++){
    1e99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ea0:	eb 64                	jmp    1f06 <bigdir+0xd4>
    name[0] = 'x';
    1ea2:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ea9:	8d 50 3f             	lea    0x3f(%eax),%edx
    1eac:	85 c0                	test   %eax,%eax
    1eae:	0f 48 c2             	cmovs  %edx,%eax
    1eb1:	c1 f8 06             	sar    $0x6,%eax
    1eb4:	83 c0 30             	add    $0x30,%eax
    1eb7:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ebd:	99                   	cltd   
    1ebe:	c1 ea 1a             	shr    $0x1a,%edx
    1ec1:	01 d0                	add    %edx,%eax
    1ec3:	83 e0 3f             	and    $0x3f,%eax
    1ec6:	29 d0                	sub    %edx,%eax
    1ec8:	83 c0 30             	add    $0x30,%eax
    1ecb:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1ece:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1ed2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ed9:	c7 04 24 c8 4d 00 00 	movl   $0x4dc8,(%esp)
    1ee0:	e8 69 20 00 00       	call   3f4e <link>
    1ee5:	85 c0                	test   %eax,%eax
    1ee7:	74 19                	je     1f02 <bigdir+0xd0>
      printf(1, "bigdir link failed\n");
    1ee9:	c7 44 24 04 e1 4d 00 	movl   $0x4de1,0x4(%esp)
    1ef0:	00 
    1ef1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ef8:	e8 79 21 00 00       	call   4076 <printf>
      exit();
    1efd:	e8 ec 1f 00 00       	call   3eee <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1f02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f06:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f0d:	7e 93                	jle    1ea2 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1f0f:	c7 04 24 c8 4d 00 00 	movl   $0x4dc8,(%esp)
    1f16:	e8 23 20 00 00       	call   3f3e <unlink>
  for(i = 0; i < 500; i++){
    1f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f22:	eb 5c                	jmp    1f80 <bigdir+0x14e>
    name[0] = 'x';
    1f24:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f2b:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f2e:	85 c0                	test   %eax,%eax
    1f30:	0f 48 c2             	cmovs  %edx,%eax
    1f33:	c1 f8 06             	sar    $0x6,%eax
    1f36:	83 c0 30             	add    $0x30,%eax
    1f39:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f3f:	99                   	cltd   
    1f40:	c1 ea 1a             	shr    $0x1a,%edx
    1f43:	01 d0                	add    %edx,%eax
    1f45:	83 e0 3f             	and    $0x3f,%eax
    1f48:	29 d0                	sub    %edx,%eax
    1f4a:	83 c0 30             	add    $0x30,%eax
    1f4d:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f50:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f54:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f57:	89 04 24             	mov    %eax,(%esp)
    1f5a:	e8 df 1f 00 00       	call   3f3e <unlink>
    1f5f:	85 c0                	test   %eax,%eax
    1f61:	74 19                	je     1f7c <bigdir+0x14a>
      printf(1, "bigdir unlink failed");
    1f63:	c7 44 24 04 f5 4d 00 	movl   $0x4df5,0x4(%esp)
    1f6a:	00 
    1f6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f72:	e8 ff 20 00 00       	call   4076 <printf>
      exit();
    1f77:	e8 72 1f 00 00       	call   3eee <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f7c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f80:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f87:	7e 9b                	jle    1f24 <bigdir+0xf2>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f89:	c7 44 24 04 0a 4e 00 	movl   $0x4e0a,0x4(%esp)
    1f90:	00 
    1f91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f98:	e8 d9 20 00 00       	call   4076 <printf>
}
    1f9d:	c9                   	leave  
    1f9e:	c3                   	ret    

00001f9f <subdir>:

void
subdir(void)
{
    1f9f:	55                   	push   %ebp
    1fa0:	89 e5                	mov    %esp,%ebp
    1fa2:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1fa5:	c7 44 24 04 15 4e 00 	movl   $0x4e15,0x4(%esp)
    1fac:	00 
    1fad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fb4:	e8 bd 20 00 00       	call   4076 <printf>

  unlink("ff");
    1fb9:	c7 04 24 22 4e 00 00 	movl   $0x4e22,(%esp)
    1fc0:	e8 79 1f 00 00       	call   3f3e <unlink>
  if(mkdir("dd") != 0){
    1fc5:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    1fcc:	e8 85 1f 00 00       	call   3f56 <mkdir>
    1fd1:	85 c0                	test   %eax,%eax
    1fd3:	74 19                	je     1fee <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1fd5:	c7 44 24 04 28 4e 00 	movl   $0x4e28,0x4(%esp)
    1fdc:	00 
    1fdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fe4:	e8 8d 20 00 00       	call   4076 <printf>
    exit();
    1fe9:	e8 00 1f 00 00       	call   3eee <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fee:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ff5:	00 
    1ff6:	c7 04 24 40 4e 00 00 	movl   $0x4e40,(%esp)
    1ffd:	e8 2c 1f 00 00       	call   3f2e <open>
    2002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2009:	79 19                	jns    2024 <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    200b:	c7 44 24 04 46 4e 00 	movl   $0x4e46,0x4(%esp)
    2012:	00 
    2013:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    201a:	e8 57 20 00 00       	call   4076 <printf>
    exit();
    201f:	e8 ca 1e 00 00       	call   3eee <exit>
  }
  write(fd, "ff", 2);
    2024:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    202b:	00 
    202c:	c7 44 24 04 22 4e 00 	movl   $0x4e22,0x4(%esp)
    2033:	00 
    2034:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2037:	89 04 24             	mov    %eax,(%esp)
    203a:	e8 cf 1e 00 00       	call   3f0e <write>
  close(fd);
    203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2042:	89 04 24             	mov    %eax,(%esp)
    2045:	e8 cc 1e 00 00       	call   3f16 <close>
  
  if(unlink("dd") >= 0){
    204a:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    2051:	e8 e8 1e 00 00       	call   3f3e <unlink>
    2056:	85 c0                	test   %eax,%eax
    2058:	78 19                	js     2073 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    205a:	c7 44 24 04 5c 4e 00 	movl   $0x4e5c,0x4(%esp)
    2061:	00 
    2062:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2069:	e8 08 20 00 00       	call   4076 <printf>
    exit();
    206e:	e8 7b 1e 00 00       	call   3eee <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2073:	c7 04 24 82 4e 00 00 	movl   $0x4e82,(%esp)
    207a:	e8 d7 1e 00 00       	call   3f56 <mkdir>
    207f:	85 c0                	test   %eax,%eax
    2081:	74 19                	je     209c <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    2083:	c7 44 24 04 89 4e 00 	movl   $0x4e89,0x4(%esp)
    208a:	00 
    208b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2092:	e8 df 1f 00 00       	call   4076 <printf>
    exit();
    2097:	e8 52 1e 00 00       	call   3eee <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    209c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20a3:	00 
    20a4:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    20ab:	e8 7e 1e 00 00       	call   3f2e <open>
    20b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20b7:	79 19                	jns    20d2 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    20b9:	c7 44 24 04 ad 4e 00 	movl   $0x4ead,0x4(%esp)
    20c0:	00 
    20c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20c8:	e8 a9 1f 00 00       	call   4076 <printf>
    exit();
    20cd:	e8 1c 1e 00 00       	call   3eee <exit>
  }
  write(fd, "FF", 2);
    20d2:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    20d9:	00 
    20da:	c7 44 24 04 c5 4e 00 	movl   $0x4ec5,0x4(%esp)
    20e1:	00 
    20e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20e5:	89 04 24             	mov    %eax,(%esp)
    20e8:	e8 21 1e 00 00       	call   3f0e <write>
  close(fd);
    20ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20f0:	89 04 24             	mov    %eax,(%esp)
    20f3:	e8 1e 1e 00 00       	call   3f16 <close>

  fd = open("dd/dd/../ff", 0);
    20f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20ff:	00 
    2100:	c7 04 24 c8 4e 00 00 	movl   $0x4ec8,(%esp)
    2107:	e8 22 1e 00 00       	call   3f2e <open>
    210c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    210f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2113:	79 19                	jns    212e <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    2115:	c7 44 24 04 d4 4e 00 	movl   $0x4ed4,0x4(%esp)
    211c:	00 
    211d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2124:	e8 4d 1f 00 00       	call   4076 <printf>
    exit();
    2129:	e8 c0 1d 00 00       	call   3eee <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    212e:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2135:	00 
    2136:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    213d:	00 
    213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2141:	89 04 24             	mov    %eax,(%esp)
    2144:	e8 bd 1d 00 00       	call   3f06 <read>
    2149:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    214c:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2150:	75 0b                	jne    215d <subdir+0x1be>
    2152:	0f b6 05 e0 8a 00 00 	movzbl 0x8ae0,%eax
    2159:	3c 66                	cmp    $0x66,%al
    215b:	74 19                	je     2176 <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    215d:	c7 44 24 04 ed 4e 00 	movl   $0x4eed,0x4(%esp)
    2164:	00 
    2165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    216c:	e8 05 1f 00 00       	call   4076 <printf>
    exit();
    2171:	e8 78 1d 00 00       	call   3eee <exit>
  }
  close(fd);
    2176:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2179:	89 04 24             	mov    %eax,(%esp)
    217c:	e8 95 1d 00 00       	call   3f16 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2181:	c7 44 24 04 08 4f 00 	movl   $0x4f08,0x4(%esp)
    2188:	00 
    2189:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    2190:	e8 b9 1d 00 00       	call   3f4e <link>
    2195:	85 c0                	test   %eax,%eax
    2197:	74 19                	je     21b2 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2199:	c7 44 24 04 14 4f 00 	movl   $0x4f14,0x4(%esp)
    21a0:	00 
    21a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21a8:	e8 c9 1e 00 00       	call   4076 <printf>
    exit();
    21ad:	e8 3c 1d 00 00       	call   3eee <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    21b2:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    21b9:	e8 80 1d 00 00       	call   3f3e <unlink>
    21be:	85 c0                	test   %eax,%eax
    21c0:	74 19                	je     21db <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    21c2:	c7 44 24 04 35 4f 00 	movl   $0x4f35,0x4(%esp)
    21c9:	00 
    21ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21d1:	e8 a0 1e 00 00       	call   4076 <printf>
    exit();
    21d6:	e8 13 1d 00 00       	call   3eee <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21e2:	00 
    21e3:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    21ea:	e8 3f 1d 00 00       	call   3f2e <open>
    21ef:	85 c0                	test   %eax,%eax
    21f1:	78 19                	js     220c <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21f3:	c7 44 24 04 50 4f 00 	movl   $0x4f50,0x4(%esp)
    21fa:	00 
    21fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2202:	e8 6f 1e 00 00       	call   4076 <printf>
    exit();
    2207:	e8 e2 1c 00 00       	call   3eee <exit>
  }

  if(chdir("dd") != 0){
    220c:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    2213:	e8 46 1d 00 00       	call   3f5e <chdir>
    2218:	85 c0                	test   %eax,%eax
    221a:	74 19                	je     2235 <subdir+0x296>
    printf(1, "chdir dd failed\n");
    221c:	c7 44 24 04 74 4f 00 	movl   $0x4f74,0x4(%esp)
    2223:	00 
    2224:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    222b:	e8 46 1e 00 00       	call   4076 <printf>
    exit();
    2230:	e8 b9 1c 00 00       	call   3eee <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2235:	c7 04 24 85 4f 00 00 	movl   $0x4f85,(%esp)
    223c:	e8 1d 1d 00 00       	call   3f5e <chdir>
    2241:	85 c0                	test   %eax,%eax
    2243:	74 19                	je     225e <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    2245:	c7 44 24 04 91 4f 00 	movl   $0x4f91,0x4(%esp)
    224c:	00 
    224d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2254:	e8 1d 1e 00 00       	call   4076 <printf>
    exit();
    2259:	e8 90 1c 00 00       	call   3eee <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    225e:	c7 04 24 ab 4f 00 00 	movl   $0x4fab,(%esp)
    2265:	e8 f4 1c 00 00       	call   3f5e <chdir>
    226a:	85 c0                	test   %eax,%eax
    226c:	74 19                	je     2287 <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    226e:	c7 44 24 04 91 4f 00 	movl   $0x4f91,0x4(%esp)
    2275:	00 
    2276:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    227d:	e8 f4 1d 00 00       	call   4076 <printf>
    exit();
    2282:	e8 67 1c 00 00       	call   3eee <exit>
  }
  if(chdir("./..") != 0){
    2287:	c7 04 24 ba 4f 00 00 	movl   $0x4fba,(%esp)
    228e:	e8 cb 1c 00 00       	call   3f5e <chdir>
    2293:	85 c0                	test   %eax,%eax
    2295:	74 19                	je     22b0 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    2297:	c7 44 24 04 bf 4f 00 	movl   $0x4fbf,0x4(%esp)
    229e:	00 
    229f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22a6:	e8 cb 1d 00 00       	call   4076 <printf>
    exit();
    22ab:	e8 3e 1c 00 00       	call   3eee <exit>
  }

  fd = open("dd/dd/ffff", 0);
    22b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    22b7:	00 
    22b8:	c7 04 24 08 4f 00 00 	movl   $0x4f08,(%esp)
    22bf:	e8 6a 1c 00 00       	call   3f2e <open>
    22c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22cb:	79 19                	jns    22e6 <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    22cd:	c7 44 24 04 d2 4f 00 	movl   $0x4fd2,0x4(%esp)
    22d4:	00 
    22d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22dc:	e8 95 1d 00 00       	call   4076 <printf>
    exit();
    22e1:	e8 08 1c 00 00       	call   3eee <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22e6:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    22ed:	00 
    22ee:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    22f5:	00 
    22f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22f9:	89 04 24             	mov    %eax,(%esp)
    22fc:	e8 05 1c 00 00       	call   3f06 <read>
    2301:	83 f8 02             	cmp    $0x2,%eax
    2304:	74 19                	je     231f <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    2306:	c7 44 24 04 ea 4f 00 	movl   $0x4fea,0x4(%esp)
    230d:	00 
    230e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2315:	e8 5c 1d 00 00       	call   4076 <printf>
    exit();
    231a:	e8 cf 1b 00 00       	call   3eee <exit>
  }
  close(fd);
    231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2322:	89 04 24             	mov    %eax,(%esp)
    2325:	e8 ec 1b 00 00       	call   3f16 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    232a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2331:	00 
    2332:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    2339:	e8 f0 1b 00 00       	call   3f2e <open>
    233e:	85 c0                	test   %eax,%eax
    2340:	78 19                	js     235b <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2342:	c7 44 24 04 08 50 00 	movl   $0x5008,0x4(%esp)
    2349:	00 
    234a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2351:	e8 20 1d 00 00       	call   4076 <printf>
    exit();
    2356:	e8 93 1b 00 00       	call   3eee <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    235b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2362:	00 
    2363:	c7 04 24 2d 50 00 00 	movl   $0x502d,(%esp)
    236a:	e8 bf 1b 00 00       	call   3f2e <open>
    236f:	85 c0                	test   %eax,%eax
    2371:	78 19                	js     238c <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    2373:	c7 44 24 04 36 50 00 	movl   $0x5036,0x4(%esp)
    237a:	00 
    237b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2382:	e8 ef 1c 00 00       	call   4076 <printf>
    exit();
    2387:	e8 62 1b 00 00       	call   3eee <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    238c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2393:	00 
    2394:	c7 04 24 52 50 00 00 	movl   $0x5052,(%esp)
    239b:	e8 8e 1b 00 00       	call   3f2e <open>
    23a0:	85 c0                	test   %eax,%eax
    23a2:	78 19                	js     23bd <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    23a4:	c7 44 24 04 5b 50 00 	movl   $0x505b,0x4(%esp)
    23ab:	00 
    23ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23b3:	e8 be 1c 00 00       	call   4076 <printf>
    exit();
    23b8:	e8 31 1b 00 00       	call   3eee <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    23bd:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    23c4:	00 
    23c5:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    23cc:	e8 5d 1b 00 00       	call   3f2e <open>
    23d1:	85 c0                	test   %eax,%eax
    23d3:	78 19                	js     23ee <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    23d5:	c7 44 24 04 77 50 00 	movl   $0x5077,0x4(%esp)
    23dc:	00 
    23dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23e4:	e8 8d 1c 00 00       	call   4076 <printf>
    exit();
    23e9:	e8 00 1b 00 00       	call   3eee <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23ee:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    23f5:	00 
    23f6:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    23fd:	e8 2c 1b 00 00       	call   3f2e <open>
    2402:	85 c0                	test   %eax,%eax
    2404:	78 19                	js     241f <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    2406:	c7 44 24 04 8d 50 00 	movl   $0x508d,0x4(%esp)
    240d:	00 
    240e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2415:	e8 5c 1c 00 00       	call   4076 <printf>
    exit();
    241a:	e8 cf 1a 00 00       	call   3eee <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    241f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2426:	00 
    2427:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    242e:	e8 fb 1a 00 00       	call   3f2e <open>
    2433:	85 c0                	test   %eax,%eax
    2435:	78 19                	js     2450 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    2437:	c7 44 24 04 a6 50 00 	movl   $0x50a6,0x4(%esp)
    243e:	00 
    243f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2446:	e8 2b 1c 00 00       	call   4076 <printf>
    exit();
    244b:	e8 9e 1a 00 00       	call   3eee <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2450:	c7 44 24 04 c1 50 00 	movl   $0x50c1,0x4(%esp)
    2457:	00 
    2458:	c7 04 24 2d 50 00 00 	movl   $0x502d,(%esp)
    245f:	e8 ea 1a 00 00       	call   3f4e <link>
    2464:	85 c0                	test   %eax,%eax
    2466:	75 19                	jne    2481 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2468:	c7 44 24 04 cc 50 00 	movl   $0x50cc,0x4(%esp)
    246f:	00 
    2470:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2477:	e8 fa 1b 00 00       	call   4076 <printf>
    exit();
    247c:	e8 6d 1a 00 00       	call   3eee <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2481:	c7 44 24 04 c1 50 00 	movl   $0x50c1,0x4(%esp)
    2488:	00 
    2489:	c7 04 24 52 50 00 00 	movl   $0x5052,(%esp)
    2490:	e8 b9 1a 00 00       	call   3f4e <link>
    2495:	85 c0                	test   %eax,%eax
    2497:	75 19                	jne    24b2 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2499:	c7 44 24 04 f0 50 00 	movl   $0x50f0,0x4(%esp)
    24a0:	00 
    24a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24a8:	e8 c9 1b 00 00       	call   4076 <printf>
    exit();
    24ad:	e8 3c 1a 00 00       	call   3eee <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    24b2:	c7 44 24 04 08 4f 00 	movl   $0x4f08,0x4(%esp)
    24b9:	00 
    24ba:	c7 04 24 40 4e 00 00 	movl   $0x4e40,(%esp)
    24c1:	e8 88 1a 00 00       	call   3f4e <link>
    24c6:	85 c0                	test   %eax,%eax
    24c8:	75 19                	jne    24e3 <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    24ca:	c7 44 24 04 14 51 00 	movl   $0x5114,0x4(%esp)
    24d1:	00 
    24d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24d9:	e8 98 1b 00 00       	call   4076 <printf>
    exit();
    24de:	e8 0b 1a 00 00       	call   3eee <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24e3:	c7 04 24 2d 50 00 00 	movl   $0x502d,(%esp)
    24ea:	e8 67 1a 00 00       	call   3f56 <mkdir>
    24ef:	85 c0                	test   %eax,%eax
    24f1:	75 19                	jne    250c <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24f3:	c7 44 24 04 36 51 00 	movl   $0x5136,0x4(%esp)
    24fa:	00 
    24fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2502:	e8 6f 1b 00 00       	call   4076 <printf>
    exit();
    2507:	e8 e2 19 00 00       	call   3eee <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    250c:	c7 04 24 52 50 00 00 	movl   $0x5052,(%esp)
    2513:	e8 3e 1a 00 00       	call   3f56 <mkdir>
    2518:	85 c0                	test   %eax,%eax
    251a:	75 19                	jne    2535 <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    251c:	c7 44 24 04 51 51 00 	movl   $0x5151,0x4(%esp)
    2523:	00 
    2524:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    252b:	e8 46 1b 00 00       	call   4076 <printf>
    exit();
    2530:	e8 b9 19 00 00       	call   3eee <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2535:	c7 04 24 08 4f 00 00 	movl   $0x4f08,(%esp)
    253c:	e8 15 1a 00 00       	call   3f56 <mkdir>
    2541:	85 c0                	test   %eax,%eax
    2543:	75 19                	jne    255e <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2545:	c7 44 24 04 6c 51 00 	movl   $0x516c,0x4(%esp)
    254c:	00 
    254d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2554:	e8 1d 1b 00 00       	call   4076 <printf>
    exit();
    2559:	e8 90 19 00 00       	call   3eee <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    255e:	c7 04 24 52 50 00 00 	movl   $0x5052,(%esp)
    2565:	e8 d4 19 00 00       	call   3f3e <unlink>
    256a:	85 c0                	test   %eax,%eax
    256c:	75 19                	jne    2587 <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    256e:	c7 44 24 04 89 51 00 	movl   $0x5189,0x4(%esp)
    2575:	00 
    2576:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    257d:	e8 f4 1a 00 00       	call   4076 <printf>
    exit();
    2582:	e8 67 19 00 00       	call   3eee <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2587:	c7 04 24 2d 50 00 00 	movl   $0x502d,(%esp)
    258e:	e8 ab 19 00 00       	call   3f3e <unlink>
    2593:	85 c0                	test   %eax,%eax
    2595:	75 19                	jne    25b0 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2597:	c7 44 24 04 a5 51 00 	movl   $0x51a5,0x4(%esp)
    259e:	00 
    259f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25a6:	e8 cb 1a 00 00       	call   4076 <printf>
    exit();
    25ab:	e8 3e 19 00 00       	call   3eee <exit>
  }
  if(chdir("dd/ff") == 0){
    25b0:	c7 04 24 40 4e 00 00 	movl   $0x4e40,(%esp)
    25b7:	e8 a2 19 00 00       	call   3f5e <chdir>
    25bc:	85 c0                	test   %eax,%eax
    25be:	75 19                	jne    25d9 <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    25c0:	c7 44 24 04 c1 51 00 	movl   $0x51c1,0x4(%esp)
    25c7:	00 
    25c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25cf:	e8 a2 1a 00 00       	call   4076 <printf>
    exit();
    25d4:	e8 15 19 00 00       	call   3eee <exit>
  }
  if(chdir("dd/xx") == 0){
    25d9:	c7 04 24 d9 51 00 00 	movl   $0x51d9,(%esp)
    25e0:	e8 79 19 00 00       	call   3f5e <chdir>
    25e5:	85 c0                	test   %eax,%eax
    25e7:	75 19                	jne    2602 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    25e9:	c7 44 24 04 df 51 00 	movl   $0x51df,0x4(%esp)
    25f0:	00 
    25f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25f8:	e8 79 1a 00 00       	call   4076 <printf>
    exit();
    25fd:	e8 ec 18 00 00       	call   3eee <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2602:	c7 04 24 08 4f 00 00 	movl   $0x4f08,(%esp)
    2609:	e8 30 19 00 00       	call   3f3e <unlink>
    260e:	85 c0                	test   %eax,%eax
    2610:	74 19                	je     262b <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    2612:	c7 44 24 04 35 4f 00 	movl   $0x4f35,0x4(%esp)
    2619:	00 
    261a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2621:	e8 50 1a 00 00       	call   4076 <printf>
    exit();
    2626:	e8 c3 18 00 00       	call   3eee <exit>
  }
  if(unlink("dd/ff") != 0){
    262b:	c7 04 24 40 4e 00 00 	movl   $0x4e40,(%esp)
    2632:	e8 07 19 00 00       	call   3f3e <unlink>
    2637:	85 c0                	test   %eax,%eax
    2639:	74 19                	je     2654 <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    263b:	c7 44 24 04 f7 51 00 	movl   $0x51f7,0x4(%esp)
    2642:	00 
    2643:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    264a:	e8 27 1a 00 00       	call   4076 <printf>
    exit();
    264f:	e8 9a 18 00 00       	call   3eee <exit>
  }
  if(unlink("dd") == 0){
    2654:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    265b:	e8 de 18 00 00       	call   3f3e <unlink>
    2660:	85 c0                	test   %eax,%eax
    2662:	75 19                	jne    267d <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    2664:	c7 44 24 04 0c 52 00 	movl   $0x520c,0x4(%esp)
    266b:	00 
    266c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2673:	e8 fe 19 00 00       	call   4076 <printf>
    exit();
    2678:	e8 71 18 00 00       	call   3eee <exit>
  }
  if(unlink("dd/dd") < 0){
    267d:	c7 04 24 2c 52 00 00 	movl   $0x522c,(%esp)
    2684:	e8 b5 18 00 00       	call   3f3e <unlink>
    2689:	85 c0                	test   %eax,%eax
    268b:	79 19                	jns    26a6 <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    268d:	c7 44 24 04 32 52 00 	movl   $0x5232,0x4(%esp)
    2694:	00 
    2695:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    269c:	e8 d5 19 00 00       	call   4076 <printf>
    exit();
    26a1:	e8 48 18 00 00       	call   3eee <exit>
  }
  if(unlink("dd") < 0){
    26a6:	c7 04 24 25 4e 00 00 	movl   $0x4e25,(%esp)
    26ad:	e8 8c 18 00 00       	call   3f3e <unlink>
    26b2:	85 c0                	test   %eax,%eax
    26b4:	79 19                	jns    26cf <subdir+0x730>
    printf(1, "unlink dd failed\n");
    26b6:	c7 44 24 04 47 52 00 	movl   $0x5247,0x4(%esp)
    26bd:	00 
    26be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26c5:	e8 ac 19 00 00       	call   4076 <printf>
    exit();
    26ca:	e8 1f 18 00 00       	call   3eee <exit>
  }

  printf(1, "subdir ok\n");
    26cf:	c7 44 24 04 59 52 00 	movl   $0x5259,0x4(%esp)
    26d6:	00 
    26d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26de:	e8 93 19 00 00       	call   4076 <printf>
}
    26e3:	c9                   	leave  
    26e4:	c3                   	ret    

000026e5 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26e5:	55                   	push   %ebp
    26e6:	89 e5                	mov    %esp,%ebp
    26e8:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26eb:	c7 44 24 04 64 52 00 	movl   $0x5264,0x4(%esp)
    26f2:	00 
    26f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26fa:	e8 77 19 00 00       	call   4076 <printf>

  unlink("bigwrite");
    26ff:	c7 04 24 73 52 00 00 	movl   $0x5273,(%esp)
    2706:	e8 33 18 00 00       	call   3f3e <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    270b:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    2712:	e9 b3 00 00 00       	jmp    27ca <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2717:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    271e:	00 
    271f:	c7 04 24 73 52 00 00 	movl   $0x5273,(%esp)
    2726:	e8 03 18 00 00       	call   3f2e <open>
    272b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    272e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2732:	79 19                	jns    274d <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    2734:	c7 44 24 04 7c 52 00 	movl   $0x527c,0x4(%esp)
    273b:	00 
    273c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2743:	e8 2e 19 00 00       	call   4076 <printf>
      exit();
    2748:	e8 a1 17 00 00       	call   3eee <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    274d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2754:	eb 50                	jmp    27a6 <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    2756:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2759:	89 44 24 08          	mov    %eax,0x8(%esp)
    275d:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    2764:	00 
    2765:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2768:	89 04 24             	mov    %eax,(%esp)
    276b:	e8 9e 17 00 00       	call   3f0e <write>
    2770:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2773:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2776:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2779:	74 27                	je     27a2 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    277b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    277e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2782:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2785:	89 44 24 08          	mov    %eax,0x8(%esp)
    2789:	c7 44 24 04 94 52 00 	movl   $0x5294,0x4(%esp)
    2790:	00 
    2791:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2798:	e8 d9 18 00 00       	call   4076 <printf>
        exit();
    279d:	e8 4c 17 00 00       	call   3eee <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    27a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    27a6:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    27aa:	7e aa                	jle    2756 <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    27ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
    27af:	89 04 24             	mov    %eax,(%esp)
    27b2:	e8 5f 17 00 00       	call   3f16 <close>
    unlink("bigwrite");
    27b7:	c7 04 24 73 52 00 00 	movl   $0x5273,(%esp)
    27be:	e8 7b 17 00 00       	call   3f3e <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    27c3:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    27ca:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27d1:	0f 8e 40 ff ff ff    	jle    2717 <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    27d7:	c7 44 24 04 a6 52 00 	movl   $0x52a6,0x4(%esp)
    27de:	00 
    27df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27e6:	e8 8b 18 00 00       	call   4076 <printf>
}
    27eb:	c9                   	leave  
    27ec:	c3                   	ret    

000027ed <bigfile>:

void
bigfile(void)
{
    27ed:	55                   	push   %ebp
    27ee:	89 e5                	mov    %esp,%ebp
    27f0:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27f3:	c7 44 24 04 b3 52 00 	movl   $0x52b3,0x4(%esp)
    27fa:	00 
    27fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2802:	e8 6f 18 00 00       	call   4076 <printf>

  unlink("bigfile");
    2807:	c7 04 24 c1 52 00 00 	movl   $0x52c1,(%esp)
    280e:	e8 2b 17 00 00       	call   3f3e <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2813:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    281a:	00 
    281b:	c7 04 24 c1 52 00 00 	movl   $0x52c1,(%esp)
    2822:	e8 07 17 00 00       	call   3f2e <open>
    2827:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    282a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    282e:	79 19                	jns    2849 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    2830:	c7 44 24 04 c9 52 00 	movl   $0x52c9,0x4(%esp)
    2837:	00 
    2838:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    283f:	e8 32 18 00 00       	call   4076 <printf>
    exit();
    2844:	e8 a5 16 00 00       	call   3eee <exit>
  }
  for(i = 0; i < 20; i++){
    2849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2850:	eb 5a                	jmp    28ac <bigfile+0xbf>
    memset(buf, i, 600);
    2852:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2859:	00 
    285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    285d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2861:	c7 04 24 e0 8a 00 00 	movl   $0x8ae0,(%esp)
    2868:	e8 d4 14 00 00       	call   3d41 <memset>
    if(write(fd, buf, 600) != 600){
    286d:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2874:	00 
    2875:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    287c:	00 
    287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2880:	89 04 24             	mov    %eax,(%esp)
    2883:	e8 86 16 00 00       	call   3f0e <write>
    2888:	3d 58 02 00 00       	cmp    $0x258,%eax
    288d:	74 19                	je     28a8 <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    288f:	c7 44 24 04 df 52 00 	movl   $0x52df,0x4(%esp)
    2896:	00 
    2897:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    289e:	e8 d3 17 00 00       	call   4076 <printf>
      exit();
    28a3:	e8 46 16 00 00       	call   3eee <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    28a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    28ac:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    28b0:	7e a0                	jle    2852 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    28b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    28b5:	89 04 24             	mov    %eax,(%esp)
    28b8:	e8 59 16 00 00       	call   3f16 <close>

  fd = open("bigfile", 0);
    28bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    28c4:	00 
    28c5:	c7 04 24 c1 52 00 00 	movl   $0x52c1,(%esp)
    28cc:	e8 5d 16 00 00       	call   3f2e <open>
    28d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28d8:	79 19                	jns    28f3 <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    28da:	c7 44 24 04 f5 52 00 	movl   $0x52f5,0x4(%esp)
    28e1:	00 
    28e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28e9:	e8 88 17 00 00       	call   4076 <printf>
    exit();
    28ee:	e8 fb 15 00 00       	call   3eee <exit>
  }
  total = 0;
    28f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2901:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    2908:	00 
    2909:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    2910:	00 
    2911:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2914:	89 04 24             	mov    %eax,(%esp)
    2917:	e8 ea 15 00 00       	call   3f06 <read>
    291c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    291f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2923:	79 19                	jns    293e <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    2925:	c7 44 24 04 0a 53 00 	movl   $0x530a,0x4(%esp)
    292c:	00 
    292d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2934:	e8 3d 17 00 00       	call   4076 <printf>
      exit();
    2939:	e8 b0 15 00 00       	call   3eee <exit>
    }
    if(cc == 0)
    293e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2942:	75 1b                	jne    295f <bigfile+0x172>
      break;
    2944:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2945:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2948:	89 04 24             	mov    %eax,(%esp)
    294b:	e8 c6 15 00 00       	call   3f16 <close>
  if(total != 20*600){
    2950:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    2957:	0f 84 99 00 00 00    	je     29f6 <bigfile+0x209>
    295d:	eb 7e                	jmp    29dd <bigfile+0x1f0>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    295f:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2966:	74 19                	je     2981 <bigfile+0x194>
      printf(1, "short read bigfile\n");
    2968:	c7 44 24 04 1f 53 00 	movl   $0x531f,0x4(%esp)
    296f:	00 
    2970:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2977:	e8 fa 16 00 00       	call   4076 <printf>
      exit();
    297c:	e8 6d 15 00 00       	call   3eee <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2981:	0f b6 05 e0 8a 00 00 	movzbl 0x8ae0,%eax
    2988:	0f be d0             	movsbl %al,%edx
    298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    298e:	89 c1                	mov    %eax,%ecx
    2990:	c1 e9 1f             	shr    $0x1f,%ecx
    2993:	01 c8                	add    %ecx,%eax
    2995:	d1 f8                	sar    %eax
    2997:	39 c2                	cmp    %eax,%edx
    2999:	75 1a                	jne    29b5 <bigfile+0x1c8>
    299b:	0f b6 05 0b 8c 00 00 	movzbl 0x8c0b,%eax
    29a2:	0f be d0             	movsbl %al,%edx
    29a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29a8:	89 c1                	mov    %eax,%ecx
    29aa:	c1 e9 1f             	shr    $0x1f,%ecx
    29ad:	01 c8                	add    %ecx,%eax
    29af:	d1 f8                	sar    %eax
    29b1:	39 c2                	cmp    %eax,%edx
    29b3:	74 19                	je     29ce <bigfile+0x1e1>
      printf(1, "read bigfile wrong data\n");
    29b5:	c7 44 24 04 33 53 00 	movl   $0x5333,0x4(%esp)
    29bc:	00 
    29bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29c4:	e8 ad 16 00 00       	call   4076 <printf>
      exit();
    29c9:	e8 20 15 00 00       	call   3eee <exit>
    }
    total += cc;
    29ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
    29d1:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    29d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    29d8:	e9 24 ff ff ff       	jmp    2901 <bigfile+0x114>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    29dd:	c7 44 24 04 4c 53 00 	movl   $0x534c,0x4(%esp)
    29e4:	00 
    29e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ec:	e8 85 16 00 00       	call   4076 <printf>
    exit();
    29f1:	e8 f8 14 00 00       	call   3eee <exit>
  }
  unlink("bigfile");
    29f6:	c7 04 24 c1 52 00 00 	movl   $0x52c1,(%esp)
    29fd:	e8 3c 15 00 00       	call   3f3e <unlink>

  printf(1, "bigfile test ok\n");
    2a02:	c7 44 24 04 66 53 00 	movl   $0x5366,0x4(%esp)
    2a09:	00 
    2a0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a11:	e8 60 16 00 00       	call   4076 <printf>
}
    2a16:	c9                   	leave  
    2a17:	c3                   	ret    

00002a18 <fourteen>:

void
fourteen(void)
{
    2a18:	55                   	push   %ebp
    2a19:	89 e5                	mov    %esp,%ebp
    2a1b:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2a1e:	c7 44 24 04 77 53 00 	movl   $0x5377,0x4(%esp)
    2a25:	00 
    2a26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a2d:	e8 44 16 00 00       	call   4076 <printf>

  if(mkdir("12345678901234") != 0){
    2a32:	c7 04 24 86 53 00 00 	movl   $0x5386,(%esp)
    2a39:	e8 18 15 00 00       	call   3f56 <mkdir>
    2a3e:	85 c0                	test   %eax,%eax
    2a40:	74 19                	je     2a5b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a42:	c7 44 24 04 95 53 00 	movl   $0x5395,0x4(%esp)
    2a49:	00 
    2a4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a51:	e8 20 16 00 00       	call   4076 <printf>
    exit();
    2a56:	e8 93 14 00 00       	call   3eee <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a5b:	c7 04 24 b4 53 00 00 	movl   $0x53b4,(%esp)
    2a62:	e8 ef 14 00 00       	call   3f56 <mkdir>
    2a67:	85 c0                	test   %eax,%eax
    2a69:	74 19                	je     2a84 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a6b:	c7 44 24 04 d4 53 00 	movl   $0x53d4,0x4(%esp)
    2a72:	00 
    2a73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a7a:	e8 f7 15 00 00       	call   4076 <printf>
    exit();
    2a7f:	e8 6a 14 00 00       	call   3eee <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a84:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a8b:	00 
    2a8c:	c7 04 24 04 54 00 00 	movl   $0x5404,(%esp)
    2a93:	e8 96 14 00 00       	call   3f2e <open>
    2a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a9f:	79 19                	jns    2aba <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2aa1:	c7 44 24 04 34 54 00 	movl   $0x5434,0x4(%esp)
    2aa8:	00 
    2aa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ab0:	e8 c1 15 00 00       	call   4076 <printf>
    exit();
    2ab5:	e8 34 14 00 00       	call   3eee <exit>
  }
  close(fd);
    2aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2abd:	89 04 24             	mov    %eax,(%esp)
    2ac0:	e8 51 14 00 00       	call   3f16 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2ac5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2acc:	00 
    2acd:	c7 04 24 74 54 00 00 	movl   $0x5474,(%esp)
    2ad4:	e8 55 14 00 00       	call   3f2e <open>
    2ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ae0:	79 19                	jns    2afb <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2ae2:	c7 44 24 04 a4 54 00 	movl   $0x54a4,0x4(%esp)
    2ae9:	00 
    2aea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af1:	e8 80 15 00 00       	call   4076 <printf>
    exit();
    2af6:	e8 f3 13 00 00       	call   3eee <exit>
  }
  close(fd);
    2afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2afe:	89 04 24             	mov    %eax,(%esp)
    2b01:	e8 10 14 00 00       	call   3f16 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2b06:	c7 04 24 de 54 00 00 	movl   $0x54de,(%esp)
    2b0d:	e8 44 14 00 00       	call   3f56 <mkdir>
    2b12:	85 c0                	test   %eax,%eax
    2b14:	75 19                	jne    2b2f <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2b16:	c7 44 24 04 fc 54 00 	movl   $0x54fc,0x4(%esp)
    2b1d:	00 
    2b1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b25:	e8 4c 15 00 00       	call   4076 <printf>
    exit();
    2b2a:	e8 bf 13 00 00       	call   3eee <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2b2f:	c7 04 24 2c 55 00 00 	movl   $0x552c,(%esp)
    2b36:	e8 1b 14 00 00       	call   3f56 <mkdir>
    2b3b:	85 c0                	test   %eax,%eax
    2b3d:	75 19                	jne    2b58 <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b3f:	c7 44 24 04 4c 55 00 	movl   $0x554c,0x4(%esp)
    2b46:	00 
    2b47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b4e:	e8 23 15 00 00       	call   4076 <printf>
    exit();
    2b53:	e8 96 13 00 00       	call   3eee <exit>
  }

  printf(1, "fourteen ok\n");
    2b58:	c7 44 24 04 7d 55 00 	movl   $0x557d,0x4(%esp)
    2b5f:	00 
    2b60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b67:	e8 0a 15 00 00       	call   4076 <printf>
}
    2b6c:	c9                   	leave  
    2b6d:	c3                   	ret    

00002b6e <rmdot>:

void
rmdot(void)
{
    2b6e:	55                   	push   %ebp
    2b6f:	89 e5                	mov    %esp,%ebp
    2b71:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2b74:	c7 44 24 04 8a 55 00 	movl   $0x558a,0x4(%esp)
    2b7b:	00 
    2b7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b83:	e8 ee 14 00 00       	call   4076 <printf>
  if(mkdir("dots") != 0){
    2b88:	c7 04 24 96 55 00 00 	movl   $0x5596,(%esp)
    2b8f:	e8 c2 13 00 00       	call   3f56 <mkdir>
    2b94:	85 c0                	test   %eax,%eax
    2b96:	74 19                	je     2bb1 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b98:	c7 44 24 04 9b 55 00 	movl   $0x559b,0x4(%esp)
    2b9f:	00 
    2ba0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ba7:	e8 ca 14 00 00       	call   4076 <printf>
    exit();
    2bac:	e8 3d 13 00 00       	call   3eee <exit>
  }
  if(chdir("dots") != 0){
    2bb1:	c7 04 24 96 55 00 00 	movl   $0x5596,(%esp)
    2bb8:	e8 a1 13 00 00       	call   3f5e <chdir>
    2bbd:	85 c0                	test   %eax,%eax
    2bbf:	74 19                	je     2bda <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2bc1:	c7 44 24 04 ae 55 00 	movl   $0x55ae,0x4(%esp)
    2bc8:	00 
    2bc9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bd0:	e8 a1 14 00 00       	call   4076 <printf>
    exit();
    2bd5:	e8 14 13 00 00       	call   3eee <exit>
  }
  if(unlink(".") == 0){
    2bda:	c7 04 24 c7 4c 00 00 	movl   $0x4cc7,(%esp)
    2be1:	e8 58 13 00 00       	call   3f3e <unlink>
    2be6:	85 c0                	test   %eax,%eax
    2be8:	75 19                	jne    2c03 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2bea:	c7 44 24 04 c1 55 00 	movl   $0x55c1,0x4(%esp)
    2bf1:	00 
    2bf2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bf9:	e8 78 14 00 00       	call   4076 <printf>
    exit();
    2bfe:	e8 eb 12 00 00       	call   3eee <exit>
  }
  if(unlink("..") == 0){
    2c03:	c7 04 24 62 48 00 00 	movl   $0x4862,(%esp)
    2c0a:	e8 2f 13 00 00       	call   3f3e <unlink>
    2c0f:	85 c0                	test   %eax,%eax
    2c11:	75 19                	jne    2c2c <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2c13:	c7 44 24 04 cf 55 00 	movl   $0x55cf,0x4(%esp)
    2c1a:	00 
    2c1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c22:	e8 4f 14 00 00       	call   4076 <printf>
    exit();
    2c27:	e8 c2 12 00 00       	call   3eee <exit>
  }
  if(chdir("/") != 0){
    2c2c:	c7 04 24 b6 44 00 00 	movl   $0x44b6,(%esp)
    2c33:	e8 26 13 00 00       	call   3f5e <chdir>
    2c38:	85 c0                	test   %eax,%eax
    2c3a:	74 19                	je     2c55 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2c3c:	c7 44 24 04 b8 44 00 	movl   $0x44b8,0x4(%esp)
    2c43:	00 
    2c44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c4b:	e8 26 14 00 00       	call   4076 <printf>
    exit();
    2c50:	e8 99 12 00 00       	call   3eee <exit>
  }
  if(unlink("dots/.") == 0){
    2c55:	c7 04 24 de 55 00 00 	movl   $0x55de,(%esp)
    2c5c:	e8 dd 12 00 00       	call   3f3e <unlink>
    2c61:	85 c0                	test   %eax,%eax
    2c63:	75 19                	jne    2c7e <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2c65:	c7 44 24 04 e5 55 00 	movl   $0x55e5,0x4(%esp)
    2c6c:	00 
    2c6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c74:	e8 fd 13 00 00       	call   4076 <printf>
    exit();
    2c79:	e8 70 12 00 00       	call   3eee <exit>
  }
  if(unlink("dots/..") == 0){
    2c7e:	c7 04 24 fc 55 00 00 	movl   $0x55fc,(%esp)
    2c85:	e8 b4 12 00 00       	call   3f3e <unlink>
    2c8a:	85 c0                	test   %eax,%eax
    2c8c:	75 19                	jne    2ca7 <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2c8e:	c7 44 24 04 04 56 00 	movl   $0x5604,0x4(%esp)
    2c95:	00 
    2c96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c9d:	e8 d4 13 00 00       	call   4076 <printf>
    exit();
    2ca2:	e8 47 12 00 00       	call   3eee <exit>
  }
  if(unlink("dots") != 0){
    2ca7:	c7 04 24 96 55 00 00 	movl   $0x5596,(%esp)
    2cae:	e8 8b 12 00 00       	call   3f3e <unlink>
    2cb3:	85 c0                	test   %eax,%eax
    2cb5:	74 19                	je     2cd0 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2cb7:	c7 44 24 04 1c 56 00 	movl   $0x561c,0x4(%esp)
    2cbe:	00 
    2cbf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc6:	e8 ab 13 00 00       	call   4076 <printf>
    exit();
    2ccb:	e8 1e 12 00 00       	call   3eee <exit>
  }
  printf(1, "rmdot ok\n");
    2cd0:	c7 44 24 04 31 56 00 	movl   $0x5631,0x4(%esp)
    2cd7:	00 
    2cd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cdf:	e8 92 13 00 00       	call   4076 <printf>
}
    2ce4:	c9                   	leave  
    2ce5:	c3                   	ret    

00002ce6 <dirfile>:

void
dirfile(void)
{
    2ce6:	55                   	push   %ebp
    2ce7:	89 e5                	mov    %esp,%ebp
    2ce9:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cec:	c7 44 24 04 3b 56 00 	movl   $0x563b,0x4(%esp)
    2cf3:	00 
    2cf4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cfb:	e8 76 13 00 00       	call   4076 <printf>

  fd = open("dirfile", O_CREATE);
    2d00:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d07:	00 
    2d08:	c7 04 24 48 56 00 00 	movl   $0x5648,(%esp)
    2d0f:	e8 1a 12 00 00       	call   3f2e <open>
    2d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d1b:	79 19                	jns    2d36 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2d1d:	c7 44 24 04 50 56 00 	movl   $0x5650,0x4(%esp)
    2d24:	00 
    2d25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d2c:	e8 45 13 00 00       	call   4076 <printf>
    exit();
    2d31:	e8 b8 11 00 00       	call   3eee <exit>
  }
  close(fd);
    2d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d39:	89 04 24             	mov    %eax,(%esp)
    2d3c:	e8 d5 11 00 00       	call   3f16 <close>
  if(chdir("dirfile") == 0){
    2d41:	c7 04 24 48 56 00 00 	movl   $0x5648,(%esp)
    2d48:	e8 11 12 00 00       	call   3f5e <chdir>
    2d4d:	85 c0                	test   %eax,%eax
    2d4f:	75 19                	jne    2d6a <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2d51:	c7 44 24 04 67 56 00 	movl   $0x5667,0x4(%esp)
    2d58:	00 
    2d59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d60:	e8 11 13 00 00       	call   4076 <printf>
    exit();
    2d65:	e8 84 11 00 00       	call   3eee <exit>
  }
  fd = open("dirfile/xx", 0);
    2d6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d71:	00 
    2d72:	c7 04 24 81 56 00 00 	movl   $0x5681,(%esp)
    2d79:	e8 b0 11 00 00       	call   3f2e <open>
    2d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d85:	78 19                	js     2da0 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2d87:	c7 44 24 04 8c 56 00 	movl   $0x568c,0x4(%esp)
    2d8e:	00 
    2d8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d96:	e8 db 12 00 00       	call   4076 <printf>
    exit();
    2d9b:	e8 4e 11 00 00       	call   3eee <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2da0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2da7:	00 
    2da8:	c7 04 24 81 56 00 00 	movl   $0x5681,(%esp)
    2daf:	e8 7a 11 00 00       	call   3f2e <open>
    2db4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2db7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2dbb:	78 19                	js     2dd6 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2dbd:	c7 44 24 04 8c 56 00 	movl   $0x568c,0x4(%esp)
    2dc4:	00 
    2dc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dcc:	e8 a5 12 00 00       	call   4076 <printf>
    exit();
    2dd1:	e8 18 11 00 00       	call   3eee <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2dd6:	c7 04 24 81 56 00 00 	movl   $0x5681,(%esp)
    2ddd:	e8 74 11 00 00       	call   3f56 <mkdir>
    2de2:	85 c0                	test   %eax,%eax
    2de4:	75 19                	jne    2dff <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2de6:	c7 44 24 04 aa 56 00 	movl   $0x56aa,0x4(%esp)
    2ded:	00 
    2dee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2df5:	e8 7c 12 00 00       	call   4076 <printf>
    exit();
    2dfa:	e8 ef 10 00 00       	call   3eee <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dff:	c7 04 24 81 56 00 00 	movl   $0x5681,(%esp)
    2e06:	e8 33 11 00 00       	call   3f3e <unlink>
    2e0b:	85 c0                	test   %eax,%eax
    2e0d:	75 19                	jne    2e28 <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2e0f:	c7 44 24 04 c7 56 00 	movl   $0x56c7,0x4(%esp)
    2e16:	00 
    2e17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e1e:	e8 53 12 00 00       	call   4076 <printf>
    exit();
    2e23:	e8 c6 10 00 00       	call   3eee <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2e28:	c7 44 24 04 81 56 00 	movl   $0x5681,0x4(%esp)
    2e2f:	00 
    2e30:	c7 04 24 e5 56 00 00 	movl   $0x56e5,(%esp)
    2e37:	e8 12 11 00 00       	call   3f4e <link>
    2e3c:	85 c0                	test   %eax,%eax
    2e3e:	75 19                	jne    2e59 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e40:	c7 44 24 04 ec 56 00 	movl   $0x56ec,0x4(%esp)
    2e47:	00 
    2e48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e4f:	e8 22 12 00 00       	call   4076 <printf>
    exit();
    2e54:	e8 95 10 00 00       	call   3eee <exit>
  }
  if(unlink("dirfile") != 0){
    2e59:	c7 04 24 48 56 00 00 	movl   $0x5648,(%esp)
    2e60:	e8 d9 10 00 00       	call   3f3e <unlink>
    2e65:	85 c0                	test   %eax,%eax
    2e67:	74 19                	je     2e82 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2e69:	c7 44 24 04 0b 57 00 	movl   $0x570b,0x4(%esp)
    2e70:	00 
    2e71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e78:	e8 f9 11 00 00       	call   4076 <printf>
    exit();
    2e7d:	e8 6c 10 00 00       	call   3eee <exit>
  }

  fd = open(".", O_RDWR);
    2e82:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2e89:	00 
    2e8a:	c7 04 24 c7 4c 00 00 	movl   $0x4cc7,(%esp)
    2e91:	e8 98 10 00 00       	call   3f2e <open>
    2e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e9d:	78 19                	js     2eb8 <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2e9f:	c7 44 24 04 24 57 00 	movl   $0x5724,0x4(%esp)
    2ea6:	00 
    2ea7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2eae:	e8 c3 11 00 00       	call   4076 <printf>
    exit();
    2eb3:	e8 36 10 00 00       	call   3eee <exit>
  }
  fd = open(".", 0);
    2eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2ebf:	00 
    2ec0:	c7 04 24 c7 4c 00 00 	movl   $0x4cc7,(%esp)
    2ec7:	e8 62 10 00 00       	call   3f2e <open>
    2ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2ecf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2ed6:	00 
    2ed7:	c7 44 24 04 1b 49 00 	movl   $0x491b,0x4(%esp)
    2ede:	00 
    2edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ee2:	89 04 24             	mov    %eax,(%esp)
    2ee5:	e8 24 10 00 00       	call   3f0e <write>
    2eea:	85 c0                	test   %eax,%eax
    2eec:	7e 19                	jle    2f07 <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2eee:	c7 44 24 04 43 57 00 	movl   $0x5743,0x4(%esp)
    2ef5:	00 
    2ef6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2efd:	e8 74 11 00 00       	call   4076 <printf>
    exit();
    2f02:	e8 e7 0f 00 00       	call   3eee <exit>
  }
  close(fd);
    2f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f0a:	89 04 24             	mov    %eax,(%esp)
    2f0d:	e8 04 10 00 00       	call   3f16 <close>

  printf(1, "dir vs file OK\n");
    2f12:	c7 44 24 04 57 57 00 	movl   $0x5757,0x4(%esp)
    2f19:	00 
    2f1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f21:	e8 50 11 00 00       	call   4076 <printf>
}
    2f26:	c9                   	leave  
    2f27:	c3                   	ret    

00002f28 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f28:	55                   	push   %ebp
    2f29:	89 e5                	mov    %esp,%ebp
    2f2b:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2f2e:	c7 44 24 04 67 57 00 	movl   $0x5767,0x4(%esp)
    2f35:	00 
    2f36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f3d:	e8 34 11 00 00       	call   4076 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f49:	e9 d2 00 00 00       	jmp    3020 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2f4e:	c7 04 24 78 57 00 00 	movl   $0x5778,(%esp)
    2f55:	e8 fc 0f 00 00       	call   3f56 <mkdir>
    2f5a:	85 c0                	test   %eax,%eax
    2f5c:	74 19                	je     2f77 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f5e:	c7 44 24 04 7e 57 00 	movl   $0x577e,0x4(%esp)
    2f65:	00 
    2f66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f6d:	e8 04 11 00 00       	call   4076 <printf>
      exit();
    2f72:	e8 77 0f 00 00       	call   3eee <exit>
    }
    if(chdir("irefd") != 0){
    2f77:	c7 04 24 78 57 00 00 	movl   $0x5778,(%esp)
    2f7e:	e8 db 0f 00 00       	call   3f5e <chdir>
    2f83:	85 c0                	test   %eax,%eax
    2f85:	74 19                	je     2fa0 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2f87:	c7 44 24 04 92 57 00 	movl   $0x5792,0x4(%esp)
    2f8e:	00 
    2f8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f96:	e8 db 10 00 00       	call   4076 <printf>
      exit();
    2f9b:	e8 4e 0f 00 00       	call   3eee <exit>
    }

    mkdir("");
    2fa0:	c7 04 24 a6 57 00 00 	movl   $0x57a6,(%esp)
    2fa7:	e8 aa 0f 00 00       	call   3f56 <mkdir>
    link("README", "");
    2fac:	c7 44 24 04 a6 57 00 	movl   $0x57a6,0x4(%esp)
    2fb3:	00 
    2fb4:	c7 04 24 e5 56 00 00 	movl   $0x56e5,(%esp)
    2fbb:	e8 8e 0f 00 00       	call   3f4e <link>
    fd = open("", O_CREATE);
    2fc0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2fc7:	00 
    2fc8:	c7 04 24 a6 57 00 00 	movl   $0x57a6,(%esp)
    2fcf:	e8 5a 0f 00 00       	call   3f2e <open>
    2fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fdb:	78 0b                	js     2fe8 <iref+0xc0>
      close(fd);
    2fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fe0:	89 04 24             	mov    %eax,(%esp)
    2fe3:	e8 2e 0f 00 00       	call   3f16 <close>
    fd = open("xx", O_CREATE);
    2fe8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2fef:	00 
    2ff0:	c7 04 24 a7 57 00 00 	movl   $0x57a7,(%esp)
    2ff7:	e8 32 0f 00 00       	call   3f2e <open>
    2ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3003:	78 0b                	js     3010 <iref+0xe8>
      close(fd);
    3005:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3008:	89 04 24             	mov    %eax,(%esp)
    300b:	e8 06 0f 00 00       	call   3f16 <close>
    unlink("xx");
    3010:	c7 04 24 a7 57 00 00 	movl   $0x57a7,(%esp)
    3017:	e8 22 0f 00 00       	call   3f3e <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    301c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3020:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3024:	0f 8e 24 ff ff ff    	jle    2f4e <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    302a:	c7 04 24 b6 44 00 00 	movl   $0x44b6,(%esp)
    3031:	e8 28 0f 00 00       	call   3f5e <chdir>
  printf(1, "empty file name OK\n");
    3036:	c7 44 24 04 aa 57 00 	movl   $0x57aa,0x4(%esp)
    303d:	00 
    303e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3045:	e8 2c 10 00 00       	call   4076 <printf>
}
    304a:	c9                   	leave  
    304b:	c3                   	ret    

0000304c <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    304c:	55                   	push   %ebp
    304d:	89 e5                	mov    %esp,%ebp
    304f:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3052:	c7 44 24 04 be 57 00 	movl   $0x57be,0x4(%esp)
    3059:	00 
    305a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3061:	e8 10 10 00 00       	call   4076 <printf>

  for(n=0; n<1000; n++){
    3066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    306d:	eb 1f                	jmp    308e <forktest+0x42>
    pid = fork();
    306f:	e8 72 0e 00 00       	call   3ee6 <fork>
    3074:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3077:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    307b:	79 02                	jns    307f <forktest+0x33>
      break;
    307d:	eb 18                	jmp    3097 <forktest+0x4b>
    if(pid == 0)
    307f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3083:	75 05                	jne    308a <forktest+0x3e>
      exit();
    3085:	e8 64 0e 00 00       	call   3eee <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    308a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    308e:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3095:	7e d8                	jle    306f <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3097:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    309e:	75 19                	jne    30b9 <forktest+0x6d>
    printf(1, "fork claimed to work 1000 times!\n");
    30a0:	c7 44 24 04 cc 57 00 	movl   $0x57cc,0x4(%esp)
    30a7:	00 
    30a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30af:	e8 c2 0f 00 00       	call   4076 <printf>
    exit();
    30b4:	e8 35 0e 00 00       	call   3eee <exit>
  }
  
  for(; n > 0; n--){
    30b9:	eb 26                	jmp    30e1 <forktest+0x95>
    if(wait() < 0){
    30bb:	e8 36 0e 00 00       	call   3ef6 <wait>
    30c0:	85 c0                	test   %eax,%eax
    30c2:	79 19                	jns    30dd <forktest+0x91>
      printf(1, "wait stopped early\n");
    30c4:	c7 44 24 04 ee 57 00 	movl   $0x57ee,0x4(%esp)
    30cb:	00 
    30cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30d3:	e8 9e 0f 00 00       	call   4076 <printf>
      exit();
    30d8:	e8 11 0e 00 00       	call   3eee <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    30dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30e5:	7f d4                	jg     30bb <forktest+0x6f>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30e7:	e8 0a 0e 00 00       	call   3ef6 <wait>
    30ec:	83 f8 ff             	cmp    $0xffffffff,%eax
    30ef:	74 19                	je     310a <forktest+0xbe>
    printf(1, "wait got too many\n");
    30f1:	c7 44 24 04 02 58 00 	movl   $0x5802,0x4(%esp)
    30f8:	00 
    30f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3100:	e8 71 0f 00 00       	call   4076 <printf>
    exit();
    3105:	e8 e4 0d 00 00       	call   3eee <exit>
  }
  
  printf(1, "fork test OK\n");
    310a:	c7 44 24 04 15 58 00 	movl   $0x5815,0x4(%esp)
    3111:	00 
    3112:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3119:	e8 58 0f 00 00       	call   4076 <printf>
}
    311e:	c9                   	leave  
    311f:	c3                   	ret    

00003120 <sbrktest>:

void
sbrktest(void)
{
    3120:	55                   	push   %ebp
    3121:	89 e5                	mov    %esp,%ebp
    3123:	53                   	push   %ebx
    3124:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    312a:	a1 fc 62 00 00       	mov    0x62fc,%eax
    312f:	c7 44 24 04 23 58 00 	movl   $0x5823,0x4(%esp)
    3136:	00 
    3137:	89 04 24             	mov    %eax,(%esp)
    313a:	e8 37 0f 00 00       	call   4076 <printf>
  oldbrk = sbrk(0);
    313f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3146:	e8 2b 0e 00 00       	call   3f76 <sbrk>
    314b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    314e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3155:	e8 1c 0e 00 00       	call   3f76 <sbrk>
    315a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    315d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3164:	eb 59                	jmp    31bf <sbrktest+0x9f>
    b = sbrk(1);
    3166:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    316d:	e8 04 0e 00 00       	call   3f76 <sbrk>
    3172:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3175:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3178:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    317b:	74 2f                	je     31ac <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    317d:	a1 fc 62 00 00       	mov    0x62fc,%eax
    3182:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3185:	89 54 24 10          	mov    %edx,0x10(%esp)
    3189:	8b 55 f4             	mov    -0xc(%ebp),%edx
    318c:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3190:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3193:	89 54 24 08          	mov    %edx,0x8(%esp)
    3197:	c7 44 24 04 2e 58 00 	movl   $0x582e,0x4(%esp)
    319e:	00 
    319f:	89 04 24             	mov    %eax,(%esp)
    31a2:	e8 cf 0e 00 00       	call   4076 <printf>
      exit();
    31a7:	e8 42 0d 00 00       	call   3eee <exit>
    }
    *b = 1;
    31ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31af:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    31b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31b5:	83 c0 01             	add    $0x1,%eax
    31b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    31bb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    31bf:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    31c6:	7e 9e                	jle    3166 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    31c8:	e8 19 0d 00 00       	call   3ee6 <fork>
    31cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    31d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31d4:	79 1a                	jns    31f0 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    31d6:	a1 fc 62 00 00       	mov    0x62fc,%eax
    31db:	c7 44 24 04 49 58 00 	movl   $0x5849,0x4(%esp)
    31e2:	00 
    31e3:	89 04 24             	mov    %eax,(%esp)
    31e6:	e8 8b 0e 00 00       	call   4076 <printf>
    exit();
    31eb:	e8 fe 0c 00 00       	call   3eee <exit>
  }
  c = sbrk(1);
    31f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31f7:	e8 7a 0d 00 00       	call   3f76 <sbrk>
    31fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3206:	e8 6b 0d 00 00       	call   3f76 <sbrk>
    320b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3211:	83 c0 01             	add    $0x1,%eax
    3214:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3217:	74 1a                	je     3233 <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    3219:	a1 fc 62 00 00       	mov    0x62fc,%eax
    321e:	c7 44 24 04 60 58 00 	movl   $0x5860,0x4(%esp)
    3225:	00 
    3226:	89 04 24             	mov    %eax,(%esp)
    3229:	e8 48 0e 00 00       	call   4076 <printf>
    exit();
    322e:	e8 bb 0c 00 00       	call   3eee <exit>
  }
  if(pid == 0)
    3233:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3237:	75 05                	jne    323e <sbrktest+0x11e>
    exit();
    3239:	e8 b0 0c 00 00       	call   3eee <exit>
  wait();
    323e:	e8 b3 0c 00 00       	call   3ef6 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    324a:	e8 27 0d 00 00       	call   3f76 <sbrk>
    324f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3252:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3255:	ba 00 00 40 06       	mov    $0x6400000,%edx
    325a:	29 c2                	sub    %eax,%edx
    325c:	89 d0                	mov    %edx,%eax
    325e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3261:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3264:	89 04 24             	mov    %eax,(%esp)
    3267:	e8 0a 0d 00 00       	call   3f76 <sbrk>
    326c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    326f:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3272:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3275:	74 1a                	je     3291 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3277:	a1 fc 62 00 00       	mov    0x62fc,%eax
    327c:	c7 44 24 04 7c 58 00 	movl   $0x587c,0x4(%esp)
    3283:	00 
    3284:	89 04 24             	mov    %eax,(%esp)
    3287:	e8 ea 0d 00 00       	call   4076 <printf>
    exit();
    328c:	e8 5d 0c 00 00       	call   3eee <exit>
  }
  lastaddr = (char*) (BIG-1);
    3291:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    3298:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    329b:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    329e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32a5:	e8 cc 0c 00 00       	call   3f76 <sbrk>
    32aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    32ad:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    32b4:	e8 bd 0c 00 00       	call   3f76 <sbrk>
    32b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    32bc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32c0:	75 1a                	jne    32dc <sbrktest+0x1bc>
    printf(stdout, "sbrk could not deallocate\n");
    32c2:	a1 fc 62 00 00       	mov    0x62fc,%eax
    32c7:	c7 44 24 04 ba 58 00 	movl   $0x58ba,0x4(%esp)
    32ce:	00 
    32cf:	89 04 24             	mov    %eax,(%esp)
    32d2:	e8 9f 0d 00 00       	call   4076 <printf>
    exit();
    32d7:	e8 12 0c 00 00       	call   3eee <exit>
  }
  c = sbrk(0);
    32dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32e3:	e8 8e 0c 00 00       	call   3f76 <sbrk>
    32e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32ee:	2d 00 10 00 00       	sub    $0x1000,%eax
    32f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32f6:	74 28                	je     3320 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32f8:	a1 fc 62 00 00       	mov    0x62fc,%eax
    32fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3300:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3304:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3307:	89 54 24 08          	mov    %edx,0x8(%esp)
    330b:	c7 44 24 04 d8 58 00 	movl   $0x58d8,0x4(%esp)
    3312:	00 
    3313:	89 04 24             	mov    %eax,(%esp)
    3316:	e8 5b 0d 00 00       	call   4076 <printf>
    exit();
    331b:	e8 ce 0b 00 00       	call   3eee <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3327:	e8 4a 0c 00 00       	call   3f76 <sbrk>
    332c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    332f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3336:	e8 3b 0c 00 00       	call   3f76 <sbrk>
    333b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    333e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3341:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3344:	75 19                	jne    335f <sbrktest+0x23f>
    3346:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    334d:	e8 24 0c 00 00       	call   3f76 <sbrk>
    3352:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3355:	81 c2 00 10 00 00    	add    $0x1000,%edx
    335b:	39 d0                	cmp    %edx,%eax
    335d:	74 28                	je     3387 <sbrktest+0x267>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    335f:	a1 fc 62 00 00       	mov    0x62fc,%eax
    3364:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3367:	89 54 24 0c          	mov    %edx,0xc(%esp)
    336b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    336e:	89 54 24 08          	mov    %edx,0x8(%esp)
    3372:	c7 44 24 04 10 59 00 	movl   $0x5910,0x4(%esp)
    3379:	00 
    337a:	89 04 24             	mov    %eax,(%esp)
    337d:	e8 f4 0c 00 00       	call   4076 <printf>
    exit();
    3382:	e8 67 0b 00 00       	call   3eee <exit>
  }
  if(*lastaddr == 99){
    3387:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    338a:	0f b6 00             	movzbl (%eax),%eax
    338d:	3c 63                	cmp    $0x63,%al
    338f:	75 1a                	jne    33ab <sbrktest+0x28b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3391:	a1 fc 62 00 00       	mov    0x62fc,%eax
    3396:	c7 44 24 04 38 59 00 	movl   $0x5938,0x4(%esp)
    339d:	00 
    339e:	89 04 24             	mov    %eax,(%esp)
    33a1:	e8 d0 0c 00 00       	call   4076 <printf>
    exit();
    33a6:	e8 43 0b 00 00       	call   3eee <exit>
  }

  a = sbrk(0);
    33ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33b2:	e8 bf 0b 00 00       	call   3f76 <sbrk>
    33b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    33ba:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    33bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33c4:	e8 ad 0b 00 00       	call   3f76 <sbrk>
    33c9:	29 c3                	sub    %eax,%ebx
    33cb:	89 d8                	mov    %ebx,%eax
    33cd:	89 04 24             	mov    %eax,(%esp)
    33d0:	e8 a1 0b 00 00       	call   3f76 <sbrk>
    33d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    33d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33de:	74 28                	je     3408 <sbrktest+0x2e8>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33e0:	a1 fc 62 00 00       	mov    0x62fc,%eax
    33e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
    33e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33ef:	89 54 24 08          	mov    %edx,0x8(%esp)
    33f3:	c7 44 24 04 68 59 00 	movl   $0x5968,0x4(%esp)
    33fa:	00 
    33fb:	89 04 24             	mov    %eax,(%esp)
    33fe:	e8 73 0c 00 00       	call   4076 <printf>
    exit();
    3403:	e8 e6 0a 00 00       	call   3eee <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3408:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    340f:	eb 7b                	jmp    348c <sbrktest+0x36c>
    ppid = getpid();
    3411:	e8 58 0b 00 00       	call   3f6e <getpid>
    3416:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    3419:	e8 c8 0a 00 00       	call   3ee6 <fork>
    341e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    3421:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3425:	79 1a                	jns    3441 <sbrktest+0x321>
      printf(stdout, "fork failed\n");
    3427:	a1 fc 62 00 00       	mov    0x62fc,%eax
    342c:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
    3433:	00 
    3434:	89 04 24             	mov    %eax,(%esp)
    3437:	e8 3a 0c 00 00       	call   4076 <printf>
      exit();
    343c:	e8 ad 0a 00 00       	call   3eee <exit>
    }
    if(pid == 0){
    3441:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3445:	75 39                	jne    3480 <sbrktest+0x360>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3447:	8b 45 f4             	mov    -0xc(%ebp),%eax
    344a:	0f b6 00             	movzbl (%eax),%eax
    344d:	0f be d0             	movsbl %al,%edx
    3450:	a1 fc 62 00 00       	mov    0x62fc,%eax
    3455:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3459:	8b 55 f4             	mov    -0xc(%ebp),%edx
    345c:	89 54 24 08          	mov    %edx,0x8(%esp)
    3460:	c7 44 24 04 89 59 00 	movl   $0x5989,0x4(%esp)
    3467:	00 
    3468:	89 04 24             	mov    %eax,(%esp)
    346b:	e8 06 0c 00 00       	call   4076 <printf>
      kill(ppid);
    3470:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3473:	89 04 24             	mov    %eax,(%esp)
    3476:	e8 a3 0a 00 00       	call   3f1e <kill>
      exit();
    347b:	e8 6e 0a 00 00       	call   3eee <exit>
    }
    wait();
    3480:	e8 71 0a 00 00       	call   3ef6 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3485:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    348c:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3493:	0f 86 78 ff ff ff    	jbe    3411 <sbrktest+0x2f1>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3499:	8d 45 c8             	lea    -0x38(%ebp),%eax
    349c:	89 04 24             	mov    %eax,(%esp)
    349f:	e8 5a 0a 00 00       	call   3efe <pipe>
    34a4:	85 c0                	test   %eax,%eax
    34a6:	74 19                	je     34c1 <sbrktest+0x3a1>
    printf(1, "pipe() failed\n");
    34a8:	c7 44 24 04 b6 48 00 	movl   $0x48b6,0x4(%esp)
    34af:	00 
    34b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34b7:	e8 ba 0b 00 00       	call   4076 <printf>
    exit();
    34bc:	e8 2d 0a 00 00       	call   3eee <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    34c8:	e9 87 00 00 00       	jmp    3554 <sbrktest+0x434>
    if((pids[i] = fork()) == 0){
    34cd:	e8 14 0a 00 00       	call   3ee6 <fork>
    34d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    34d5:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    34d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34dc:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34e0:	85 c0                	test   %eax,%eax
    34e2:	75 46                	jne    352a <sbrktest+0x40a>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34eb:	e8 86 0a 00 00       	call   3f76 <sbrk>
    34f0:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34f5:	29 c2                	sub    %eax,%edx
    34f7:	89 d0                	mov    %edx,%eax
    34f9:	89 04 24             	mov    %eax,(%esp)
    34fc:	e8 75 0a 00 00       	call   3f76 <sbrk>
      write(fds[1], "x", 1);
    3501:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3504:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    350b:	00 
    350c:	c7 44 24 04 1b 49 00 	movl   $0x491b,0x4(%esp)
    3513:	00 
    3514:	89 04 24             	mov    %eax,(%esp)
    3517:	e8 f2 09 00 00       	call   3f0e <write>
      // sit around until killed
      for(;;) sleep(1000);
    351c:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    3523:	e8 56 0a 00 00       	call   3f7e <sleep>
    3528:	eb f2                	jmp    351c <sbrktest+0x3fc>
    }
    if(pids[i] != -1)
    352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    352d:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3531:	83 f8 ff             	cmp    $0xffffffff,%eax
    3534:	74 1a                	je     3550 <sbrktest+0x430>
      read(fds[0], &scratch, 1);
    3536:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3539:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3540:	00 
    3541:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3544:	89 54 24 04          	mov    %edx,0x4(%esp)
    3548:	89 04 24             	mov    %eax,(%esp)
    354b:	e8 b6 09 00 00       	call   3f06 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3550:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3554:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3557:	83 f8 09             	cmp    $0x9,%eax
    355a:	0f 86 6d ff ff ff    	jbe    34cd <sbrktest+0x3ad>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3560:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3567:	e8 0a 0a 00 00       	call   3f76 <sbrk>
    356c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    356f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3576:	eb 26                	jmp    359e <sbrktest+0x47e>
    if(pids[i] == -1)
    3578:	8b 45 f0             	mov    -0x10(%ebp),%eax
    357b:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    357f:	83 f8 ff             	cmp    $0xffffffff,%eax
    3582:	75 02                	jne    3586 <sbrktest+0x466>
      continue;
    3584:	eb 14                	jmp    359a <sbrktest+0x47a>
    kill(pids[i]);
    3586:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3589:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    358d:	89 04 24             	mov    %eax,(%esp)
    3590:	e8 89 09 00 00       	call   3f1e <kill>
    wait();
    3595:	e8 5c 09 00 00       	call   3ef6 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    359a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    359e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35a1:	83 f8 09             	cmp    $0x9,%eax
    35a4:	76 d2                	jbe    3578 <sbrktest+0x458>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    35a6:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    35aa:	75 1a                	jne    35c6 <sbrktest+0x4a6>
    printf(stdout, "failed sbrk leaked memory\n");
    35ac:	a1 fc 62 00 00       	mov    0x62fc,%eax
    35b1:	c7 44 24 04 a2 59 00 	movl   $0x59a2,0x4(%esp)
    35b8:	00 
    35b9:	89 04 24             	mov    %eax,(%esp)
    35bc:	e8 b5 0a 00 00       	call   4076 <printf>
    exit();
    35c1:	e8 28 09 00 00       	call   3eee <exit>
  }

  if(sbrk(0) > oldbrk)
    35c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35cd:	e8 a4 09 00 00       	call   3f76 <sbrk>
    35d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    35d5:	76 1b                	jbe    35f2 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    35d7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35e1:	e8 90 09 00 00       	call   3f76 <sbrk>
    35e6:	29 c3                	sub    %eax,%ebx
    35e8:	89 d8                	mov    %ebx,%eax
    35ea:	89 04 24             	mov    %eax,(%esp)
    35ed:	e8 84 09 00 00       	call   3f76 <sbrk>

  printf(stdout, "sbrk test OK\n");
    35f2:	a1 fc 62 00 00       	mov    0x62fc,%eax
    35f7:	c7 44 24 04 bd 59 00 	movl   $0x59bd,0x4(%esp)
    35fe:	00 
    35ff:	89 04 24             	mov    %eax,(%esp)
    3602:	e8 6f 0a 00 00       	call   4076 <printf>
}
    3607:	81 c4 84 00 00 00    	add    $0x84,%esp
    360d:	5b                   	pop    %ebx
    360e:	5d                   	pop    %ebp
    360f:	c3                   	ret    

00003610 <validateint>:

void
validateint(int *p)
{
    3610:	55                   	push   %ebp
    3611:	89 e5                	mov    %esp,%ebp
    3613:	53                   	push   %ebx
    3614:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3617:	b8 0d 00 00 00       	mov    $0xd,%eax
    361c:	8b 55 08             	mov    0x8(%ebp),%edx
    361f:	89 d1                	mov    %edx,%ecx
    3621:	89 e3                	mov    %esp,%ebx
    3623:	89 cc                	mov    %ecx,%esp
    3625:	cd 40                	int    $0x40
    3627:	89 dc                	mov    %ebx,%esp
    3629:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    362c:	83 c4 10             	add    $0x10,%esp
    362f:	5b                   	pop    %ebx
    3630:	5d                   	pop    %ebp
    3631:	c3                   	ret    

00003632 <validatetest>:

void
validatetest(void)
{
    3632:	55                   	push   %ebp
    3633:	89 e5                	mov    %esp,%ebp
    3635:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3638:	a1 fc 62 00 00       	mov    0x62fc,%eax
    363d:	c7 44 24 04 cb 59 00 	movl   $0x59cb,0x4(%esp)
    3644:	00 
    3645:	89 04 24             	mov    %eax,(%esp)
    3648:	e8 29 0a 00 00       	call   4076 <printf>
  hi = 1100*1024;
    364d:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3654:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    365b:	eb 7f                	jmp    36dc <validatetest+0xaa>
    if((pid = fork()) == 0){
    365d:	e8 84 08 00 00       	call   3ee6 <fork>
    3662:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3669:	75 10                	jne    367b <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    366e:	89 04 24             	mov    %eax,(%esp)
    3671:	e8 9a ff ff ff       	call   3610 <validateint>
      exit();
    3676:	e8 73 08 00 00       	call   3eee <exit>
    }
    sleep(0);
    367b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3682:	e8 f7 08 00 00       	call   3f7e <sleep>
    sleep(0);
    3687:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    368e:	e8 eb 08 00 00       	call   3f7e <sleep>
    kill(pid);
    3693:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3696:	89 04 24             	mov    %eax,(%esp)
    3699:	e8 80 08 00 00       	call   3f1e <kill>
    wait();
    369e:	e8 53 08 00 00       	call   3ef6 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    36a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    36aa:	c7 04 24 da 59 00 00 	movl   $0x59da,(%esp)
    36b1:	e8 98 08 00 00       	call   3f4e <link>
    36b6:	83 f8 ff             	cmp    $0xffffffff,%eax
    36b9:	74 1a                	je     36d5 <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    36bb:	a1 fc 62 00 00       	mov    0x62fc,%eax
    36c0:	c7 44 24 04 e5 59 00 	movl   $0x59e5,0x4(%esp)
    36c7:	00 
    36c8:	89 04 24             	mov    %eax,(%esp)
    36cb:	e8 a6 09 00 00       	call   4076 <printf>
      exit();
    36d0:	e8 19 08 00 00       	call   3eee <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    36d5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36e2:	0f 83 75 ff ff ff    	jae    365d <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36e8:	a1 fc 62 00 00       	mov    0x62fc,%eax
    36ed:	c7 44 24 04 fe 59 00 	movl   $0x59fe,0x4(%esp)
    36f4:	00 
    36f5:	89 04 24             	mov    %eax,(%esp)
    36f8:	e8 79 09 00 00       	call   4076 <printf>
}
    36fd:	c9                   	leave  
    36fe:	c3                   	ret    

000036ff <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36ff:	55                   	push   %ebp
    3700:	89 e5                	mov    %esp,%ebp
    3702:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    3705:	a1 fc 62 00 00       	mov    0x62fc,%eax
    370a:	c7 44 24 04 0b 5a 00 	movl   $0x5a0b,0x4(%esp)
    3711:	00 
    3712:	89 04 24             	mov    %eax,(%esp)
    3715:	e8 5c 09 00 00       	call   4076 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    371a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3721:	eb 2d                	jmp    3750 <bsstest+0x51>
    if(uninit[i] != '\0'){
    3723:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3726:	05 c0 63 00 00       	add    $0x63c0,%eax
    372b:	0f b6 00             	movzbl (%eax),%eax
    372e:	84 c0                	test   %al,%al
    3730:	74 1a                	je     374c <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    3732:	a1 fc 62 00 00       	mov    0x62fc,%eax
    3737:	c7 44 24 04 15 5a 00 	movl   $0x5a15,0x4(%esp)
    373e:	00 
    373f:	89 04 24             	mov    %eax,(%esp)
    3742:	e8 2f 09 00 00       	call   4076 <printf>
      exit();
    3747:	e8 a2 07 00 00       	call   3eee <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    374c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3750:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3753:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3758:	76 c9                	jbe    3723 <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    375a:	a1 fc 62 00 00       	mov    0x62fc,%eax
    375f:	c7 44 24 04 26 5a 00 	movl   $0x5a26,0x4(%esp)
    3766:	00 
    3767:	89 04 24             	mov    %eax,(%esp)
    376a:	e8 07 09 00 00       	call   4076 <printf>
}
    376f:	c9                   	leave  
    3770:	c3                   	ret    

00003771 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3771:	55                   	push   %ebp
    3772:	89 e5                	mov    %esp,%ebp
    3774:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3777:	c7 04 24 33 5a 00 00 	movl   $0x5a33,(%esp)
    377e:	e8 bb 07 00 00       	call   3f3e <unlink>
  pid = fork();
    3783:	e8 5e 07 00 00       	call   3ee6 <fork>
    3788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    378b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    378f:	0f 85 90 00 00 00    	jne    3825 <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3795:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    379c:	eb 12                	jmp    37b0 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37a1:	c7 04 85 20 63 00 00 	movl   $0x5a40,0x6320(,%eax,4)
    37a8:	40 5a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    37ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37b0:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    37b4:	7e e8                	jle    379e <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    37b6:	c7 05 9c 63 00 00 00 	movl   $0x0,0x639c
    37bd:	00 00 00 
    printf(stdout, "bigarg test\n");
    37c0:	a1 fc 62 00 00       	mov    0x62fc,%eax
    37c5:	c7 44 24 04 1d 5b 00 	movl   $0x5b1d,0x4(%esp)
    37cc:	00 
    37cd:	89 04 24             	mov    %eax,(%esp)
    37d0:	e8 a1 08 00 00       	call   4076 <printf>
    exec("echo", args);
    37d5:	c7 44 24 04 20 63 00 	movl   $0x6320,0x4(%esp)
    37dc:	00 
    37dd:	c7 04 24 44 44 00 00 	movl   $0x4444,(%esp)
    37e4:	e8 3d 07 00 00       	call   3f26 <exec>
    printf(stdout, "bigarg test ok\n");
    37e9:	a1 fc 62 00 00       	mov    0x62fc,%eax
    37ee:	c7 44 24 04 2a 5b 00 	movl   $0x5b2a,0x4(%esp)
    37f5:	00 
    37f6:	89 04 24             	mov    %eax,(%esp)
    37f9:	e8 78 08 00 00       	call   4076 <printf>
    fd = open("bigarg-ok", O_CREATE);
    37fe:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3805:	00 
    3806:	c7 04 24 33 5a 00 00 	movl   $0x5a33,(%esp)
    380d:	e8 1c 07 00 00       	call   3f2e <open>
    3812:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3815:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3818:	89 04 24             	mov    %eax,(%esp)
    381b:	e8 f6 06 00 00       	call   3f16 <close>
    exit();
    3820:	e8 c9 06 00 00       	call   3eee <exit>
  } else if(pid < 0){
    3825:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3829:	79 1a                	jns    3845 <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    382b:	a1 fc 62 00 00       	mov    0x62fc,%eax
    3830:	c7 44 24 04 3a 5b 00 	movl   $0x5b3a,0x4(%esp)
    3837:	00 
    3838:	89 04 24             	mov    %eax,(%esp)
    383b:	e8 36 08 00 00       	call   4076 <printf>
    exit();
    3840:	e8 a9 06 00 00       	call   3eee <exit>
  }
  wait();
    3845:	e8 ac 06 00 00       	call   3ef6 <wait>
  fd = open("bigarg-ok", 0);
    384a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3851:	00 
    3852:	c7 04 24 33 5a 00 00 	movl   $0x5a33,(%esp)
    3859:	e8 d0 06 00 00       	call   3f2e <open>
    385e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3861:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3865:	79 1a                	jns    3881 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    3867:	a1 fc 62 00 00       	mov    0x62fc,%eax
    386c:	c7 44 24 04 53 5b 00 	movl   $0x5b53,0x4(%esp)
    3873:	00 
    3874:	89 04 24             	mov    %eax,(%esp)
    3877:	e8 fa 07 00 00       	call   4076 <printf>
    exit();
    387c:	e8 6d 06 00 00       	call   3eee <exit>
  }
  close(fd);
    3881:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3884:	89 04 24             	mov    %eax,(%esp)
    3887:	e8 8a 06 00 00       	call   3f16 <close>
  unlink("bigarg-ok");
    388c:	c7 04 24 33 5a 00 00 	movl   $0x5a33,(%esp)
    3893:	e8 a6 06 00 00       	call   3f3e <unlink>
}
    3898:	c9                   	leave  
    3899:	c3                   	ret    

0000389a <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    389a:	55                   	push   %ebp
    389b:	89 e5                	mov    %esp,%ebp
    389d:	53                   	push   %ebx
    389e:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    38a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    38a8:	c7 44 24 04 68 5b 00 	movl   $0x5b68,0x4(%esp)
    38af:	00 
    38b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38b7:	e8 ba 07 00 00       	call   4076 <printf>

  for(nfiles = 0; ; nfiles++){
    38bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38c3:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38c7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38ca:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38cf:	89 c8                	mov    %ecx,%eax
    38d1:	f7 ea                	imul   %edx
    38d3:	c1 fa 06             	sar    $0x6,%edx
    38d6:	89 c8                	mov    %ecx,%eax
    38d8:	c1 f8 1f             	sar    $0x1f,%eax
    38db:	29 c2                	sub    %eax,%edx
    38dd:	89 d0                	mov    %edx,%eax
    38df:	83 c0 30             	add    $0x30,%eax
    38e2:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38e8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38ed:	89 d8                	mov    %ebx,%eax
    38ef:	f7 ea                	imul   %edx
    38f1:	c1 fa 06             	sar    $0x6,%edx
    38f4:	89 d8                	mov    %ebx,%eax
    38f6:	c1 f8 1f             	sar    $0x1f,%eax
    38f9:	89 d1                	mov    %edx,%ecx
    38fb:	29 c1                	sub    %eax,%ecx
    38fd:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3903:	29 c3                	sub    %eax,%ebx
    3905:	89 d9                	mov    %ebx,%ecx
    3907:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    390c:	89 c8                	mov    %ecx,%eax
    390e:	f7 ea                	imul   %edx
    3910:	c1 fa 05             	sar    $0x5,%edx
    3913:	89 c8                	mov    %ecx,%eax
    3915:	c1 f8 1f             	sar    $0x1f,%eax
    3918:	29 c2                	sub    %eax,%edx
    391a:	89 d0                	mov    %edx,%eax
    391c:	83 c0 30             	add    $0x30,%eax
    391f:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3922:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3925:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    392a:	89 d8                	mov    %ebx,%eax
    392c:	f7 ea                	imul   %edx
    392e:	c1 fa 05             	sar    $0x5,%edx
    3931:	89 d8                	mov    %ebx,%eax
    3933:	c1 f8 1f             	sar    $0x1f,%eax
    3936:	89 d1                	mov    %edx,%ecx
    3938:	29 c1                	sub    %eax,%ecx
    393a:	6b c1 64             	imul   $0x64,%ecx,%eax
    393d:	29 c3                	sub    %eax,%ebx
    393f:	89 d9                	mov    %ebx,%ecx
    3941:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3946:	89 c8                	mov    %ecx,%eax
    3948:	f7 ea                	imul   %edx
    394a:	c1 fa 02             	sar    $0x2,%edx
    394d:	89 c8                	mov    %ecx,%eax
    394f:	c1 f8 1f             	sar    $0x1f,%eax
    3952:	29 c2                	sub    %eax,%edx
    3954:	89 d0                	mov    %edx,%eax
    3956:	83 c0 30             	add    $0x30,%eax
    3959:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    395c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    395f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3964:	89 c8                	mov    %ecx,%eax
    3966:	f7 ea                	imul   %edx
    3968:	c1 fa 02             	sar    $0x2,%edx
    396b:	89 c8                	mov    %ecx,%eax
    396d:	c1 f8 1f             	sar    $0x1f,%eax
    3970:	29 c2                	sub    %eax,%edx
    3972:	89 d0                	mov    %edx,%eax
    3974:	c1 e0 02             	shl    $0x2,%eax
    3977:	01 d0                	add    %edx,%eax
    3979:	01 c0                	add    %eax,%eax
    397b:	29 c1                	sub    %eax,%ecx
    397d:	89 ca                	mov    %ecx,%edx
    397f:	89 d0                	mov    %edx,%eax
    3981:	83 c0 30             	add    $0x30,%eax
    3984:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3987:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    398b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    398e:	89 44 24 08          	mov    %eax,0x8(%esp)
    3992:	c7 44 24 04 75 5b 00 	movl   $0x5b75,0x4(%esp)
    3999:	00 
    399a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39a1:	e8 d0 06 00 00       	call   4076 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    39a6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    39ad:	00 
    39ae:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39b1:	89 04 24             	mov    %eax,(%esp)
    39b4:	e8 75 05 00 00       	call   3f2e <open>
    39b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39c0:	79 1d                	jns    39df <fsfull+0x145>
      printf(1, "open %s failed\n", name);
    39c2:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39c5:	89 44 24 08          	mov    %eax,0x8(%esp)
    39c9:	c7 44 24 04 81 5b 00 	movl   $0x5b81,0x4(%esp)
    39d0:	00 
    39d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39d8:	e8 99 06 00 00       	call   4076 <printf>
      break;
    39dd:	eb 74                	jmp    3a53 <fsfull+0x1b9>
    }
    int total = 0;
    39df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39e6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    39ed:	00 
    39ee:	c7 44 24 04 e0 8a 00 	movl   $0x8ae0,0x4(%esp)
    39f5:	00 
    39f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    39f9:	89 04 24             	mov    %eax,(%esp)
    39fc:	e8 0d 05 00 00       	call   3f0e <write>
    3a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3a04:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3a0b:	7f 2f                	jg     3a3c <fsfull+0x1a2>
        break;
    3a0d:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3a11:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a15:	c7 44 24 04 91 5b 00 	movl   $0x5b91,0x4(%esp)
    3a1c:	00 
    3a1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a24:	e8 4d 06 00 00       	call   4076 <printf>
    close(fd);
    3a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3a2c:	89 04 24             	mov    %eax,(%esp)
    3a2f:	e8 e2 04 00 00       	call   3f16 <close>
    if(total == 0)
    3a34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a38:	75 10                	jne    3a4a <fsfull+0x1b0>
    3a3a:	eb 0c                	jmp    3a48 <fsfull+0x1ae>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    3a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a3f:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3a46:	eb 9e                	jmp    39e6 <fsfull+0x14c>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3a48:	eb 09                	jmp    3a53 <fsfull+0x1b9>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a4e:	e9 70 fe ff ff       	jmp    38c3 <fsfull+0x29>

  while(nfiles >= 0){
    3a53:	e9 d7 00 00 00       	jmp    3b2f <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    3a58:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a5c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a5f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a64:	89 c8                	mov    %ecx,%eax
    3a66:	f7 ea                	imul   %edx
    3a68:	c1 fa 06             	sar    $0x6,%edx
    3a6b:	89 c8                	mov    %ecx,%eax
    3a6d:	c1 f8 1f             	sar    $0x1f,%eax
    3a70:	29 c2                	sub    %eax,%edx
    3a72:	89 d0                	mov    %edx,%eax
    3a74:	83 c0 30             	add    $0x30,%eax
    3a77:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a7a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a7d:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a82:	89 d8                	mov    %ebx,%eax
    3a84:	f7 ea                	imul   %edx
    3a86:	c1 fa 06             	sar    $0x6,%edx
    3a89:	89 d8                	mov    %ebx,%eax
    3a8b:	c1 f8 1f             	sar    $0x1f,%eax
    3a8e:	89 d1                	mov    %edx,%ecx
    3a90:	29 c1                	sub    %eax,%ecx
    3a92:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a98:	29 c3                	sub    %eax,%ebx
    3a9a:	89 d9                	mov    %ebx,%ecx
    3a9c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3aa1:	89 c8                	mov    %ecx,%eax
    3aa3:	f7 ea                	imul   %edx
    3aa5:	c1 fa 05             	sar    $0x5,%edx
    3aa8:	89 c8                	mov    %ecx,%eax
    3aaa:	c1 f8 1f             	sar    $0x1f,%eax
    3aad:	29 c2                	sub    %eax,%edx
    3aaf:	89 d0                	mov    %edx,%eax
    3ab1:	83 c0 30             	add    $0x30,%eax
    3ab4:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3ab7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3aba:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3abf:	89 d8                	mov    %ebx,%eax
    3ac1:	f7 ea                	imul   %edx
    3ac3:	c1 fa 05             	sar    $0x5,%edx
    3ac6:	89 d8                	mov    %ebx,%eax
    3ac8:	c1 f8 1f             	sar    $0x1f,%eax
    3acb:	89 d1                	mov    %edx,%ecx
    3acd:	29 c1                	sub    %eax,%ecx
    3acf:	6b c1 64             	imul   $0x64,%ecx,%eax
    3ad2:	29 c3                	sub    %eax,%ebx
    3ad4:	89 d9                	mov    %ebx,%ecx
    3ad6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3adb:	89 c8                	mov    %ecx,%eax
    3add:	f7 ea                	imul   %edx
    3adf:	c1 fa 02             	sar    $0x2,%edx
    3ae2:	89 c8                	mov    %ecx,%eax
    3ae4:	c1 f8 1f             	sar    $0x1f,%eax
    3ae7:	29 c2                	sub    %eax,%edx
    3ae9:	89 d0                	mov    %edx,%eax
    3aeb:	83 c0 30             	add    $0x30,%eax
    3aee:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3af1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3af4:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3af9:	89 c8                	mov    %ecx,%eax
    3afb:	f7 ea                	imul   %edx
    3afd:	c1 fa 02             	sar    $0x2,%edx
    3b00:	89 c8                	mov    %ecx,%eax
    3b02:	c1 f8 1f             	sar    $0x1f,%eax
    3b05:	29 c2                	sub    %eax,%edx
    3b07:	89 d0                	mov    %edx,%eax
    3b09:	c1 e0 02             	shl    $0x2,%eax
    3b0c:	01 d0                	add    %edx,%eax
    3b0e:	01 c0                	add    %eax,%eax
    3b10:	29 c1                	sub    %eax,%ecx
    3b12:	89 ca                	mov    %ecx,%edx
    3b14:	89 d0                	mov    %edx,%eax
    3b16:	83 c0 30             	add    $0x30,%eax
    3b19:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b1c:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b20:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b23:	89 04 24             	mov    %eax,(%esp)
    3b26:	e8 13 04 00 00       	call   3f3e <unlink>
    nfiles--;
    3b2b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b33:	0f 89 1f ff ff ff    	jns    3a58 <fsfull+0x1be>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b39:	c7 44 24 04 a1 5b 00 	movl   $0x5ba1,0x4(%esp)
    3b40:	00 
    3b41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b48:	e8 29 05 00 00       	call   4076 <printf>
}
    3b4d:	83 c4 74             	add    $0x74,%esp
    3b50:	5b                   	pop    %ebx
    3b51:	5d                   	pop    %ebp
    3b52:	c3                   	ret    

00003b53 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b53:	55                   	push   %ebp
    3b54:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b56:	a1 00 63 00 00       	mov    0x6300,%eax
    3b5b:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b61:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b66:	a3 00 63 00 00       	mov    %eax,0x6300
  return randstate;
    3b6b:	a1 00 63 00 00       	mov    0x6300,%eax
}
    3b70:	5d                   	pop    %ebp
    3b71:	c3                   	ret    

00003b72 <main>:

int
main(int argc, char *argv[])
{
    3b72:	55                   	push   %ebp
    3b73:	89 e5                	mov    %esp,%ebp
    3b75:	83 e4 f0             	and    $0xfffffff0,%esp
    3b78:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3b7b:	c7 44 24 04 b7 5b 00 	movl   $0x5bb7,0x4(%esp)
    3b82:	00 
    3b83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b8a:	e8 e7 04 00 00       	call   4076 <printf>

  if(open("usertests.ran", 0) >= 0){
    3b8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b96:	00 
    3b97:	c7 04 24 cb 5b 00 00 	movl   $0x5bcb,(%esp)
    3b9e:	e8 8b 03 00 00       	call   3f2e <open>
    3ba3:	85 c0                	test   %eax,%eax
    3ba5:	78 19                	js     3bc0 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3ba7:	c7 44 24 04 dc 5b 00 	movl   $0x5bdc,0x4(%esp)
    3bae:	00 
    3baf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3bb6:	e8 bb 04 00 00       	call   4076 <printf>
    exit();
    3bbb:	e8 2e 03 00 00       	call   3eee <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3bc0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3bc7:	00 
    3bc8:	c7 04 24 cb 5b 00 00 	movl   $0x5bcb,(%esp)
    3bcf:	e8 5a 03 00 00       	call   3f2e <open>
    3bd4:	89 04 24             	mov    %eax,(%esp)
    3bd7:	e8 3a 03 00 00       	call   3f16 <close>

  bigargtest();
    3bdc:	e8 90 fb ff ff       	call   3771 <bigargtest>
  bigwrite();
    3be1:	e8 ff ea ff ff       	call   26e5 <bigwrite>
  bigargtest();
    3be6:	e8 86 fb ff ff       	call   3771 <bigargtest>
  bsstest();
    3beb:	e8 0f fb ff ff       	call   36ff <bsstest>
  sbrktest();
    3bf0:	e8 2b f5 ff ff       	call   3120 <sbrktest>
  validatetest();
    3bf5:	e8 38 fa ff ff       	call   3632 <validatetest>

  opentest();
    3bfa:	e8 c8 c6 ff ff       	call   2c7 <opentest>
  writetest();
    3bff:	e8 6e c7 ff ff       	call   372 <writetest>
  writetest1();
    3c04:	e8 7e c9 ff ff       	call   587 <writetest1>
  createtest();
    3c09:	e8 84 cb ff ff       	call   792 <createtest>

  openiputtest();
    3c0e:	e8 b3 c5 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3c13:	e8 c2 c4 ff ff       	call   da <exitiputtest>
  iputtest();
    3c18:	e8 e3 c3 ff ff       	call   0 <iputtest>

  mem();
    3c1d:	e8 15 d1 ff ff       	call   d37 <mem>
  pipe1();
    3c22:	e8 4c cd ff ff       	call   973 <pipe1>
  preempt();
    3c27:	e8 34 cf ff ff       	call   b60 <preempt>
  exitwait();
    3c2c:	e8 88 d0 ff ff       	call   cb9 <exitwait>

  rmdot();
    3c31:	e8 38 ef ff ff       	call   2b6e <rmdot>
  fourteen();
    3c36:	e8 dd ed ff ff       	call   2a18 <fourteen>
  bigfile();
    3c3b:	e8 ad eb ff ff       	call   27ed <bigfile>
  subdir();
    3c40:	e8 5a e3 ff ff       	call   1f9f <subdir>
  concreate();
    3c45:	e8 07 dd ff ff       	call   1951 <concreate>
  linkunlink();
    3c4a:	e8 b5 e0 ff ff       	call   1d04 <linkunlink>
  linktest();
    3c4f:	e8 b4 da ff ff       	call   1708 <linktest>
  unlinkread();
    3c54:	e8 da d8 ff ff       	call   1533 <unlinkread>
  createdelete();
    3c59:	e8 24 d6 ff ff       	call   1282 <createdelete>
  twofiles();
    3c5e:	e8 b7 d3 ff ff       	call   101a <twofiles>
  sharedfd();
    3c63:	e8 b4 d1 ff ff       	call   e1c <sharedfd>
  dirfile();
    3c68:	e8 79 f0 ff ff       	call   2ce6 <dirfile>
  iref();
    3c6d:	e8 b6 f2 ff ff       	call   2f28 <iref>
  forktest();
    3c72:	e8 d5 f3 ff ff       	call   304c <forktest>
  bigdir(); // slow
    3c77:	e8 b6 e1 ff ff       	call   1e32 <bigdir>

  exectest();
    3c7c:	e8 a3 cc ff ff       	call   924 <exectest>

  exit();
    3c81:	e8 68 02 00 00       	call   3eee <exit>

00003c86 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c86:	55                   	push   %ebp
    3c87:	89 e5                	mov    %esp,%ebp
    3c89:	57                   	push   %edi
    3c8a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c8e:	8b 55 10             	mov    0x10(%ebp),%edx
    3c91:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c94:	89 cb                	mov    %ecx,%ebx
    3c96:	89 df                	mov    %ebx,%edi
    3c98:	89 d1                	mov    %edx,%ecx
    3c9a:	fc                   	cld    
    3c9b:	f3 aa                	rep stos %al,%es:(%edi)
    3c9d:	89 ca                	mov    %ecx,%edx
    3c9f:	89 fb                	mov    %edi,%ebx
    3ca1:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3ca4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3ca7:	5b                   	pop    %ebx
    3ca8:	5f                   	pop    %edi
    3ca9:	5d                   	pop    %ebp
    3caa:	c3                   	ret    

00003cab <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3cab:	55                   	push   %ebp
    3cac:	89 e5                	mov    %esp,%ebp
    3cae:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3cb1:	8b 45 08             	mov    0x8(%ebp),%eax
    3cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3cb7:	90                   	nop
    3cb8:	8b 45 08             	mov    0x8(%ebp),%eax
    3cbb:	8d 50 01             	lea    0x1(%eax),%edx
    3cbe:	89 55 08             	mov    %edx,0x8(%ebp)
    3cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
    3cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
    3cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3cca:	0f b6 12             	movzbl (%edx),%edx
    3ccd:	88 10                	mov    %dl,(%eax)
    3ccf:	0f b6 00             	movzbl (%eax),%eax
    3cd2:	84 c0                	test   %al,%al
    3cd4:	75 e2                	jne    3cb8 <strcpy+0xd>
    ;
  return os;
    3cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cd9:	c9                   	leave  
    3cda:	c3                   	ret    

00003cdb <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cdb:	55                   	push   %ebp
    3cdc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3cde:	eb 08                	jmp    3ce8 <strcmp+0xd>
    p++, q++;
    3ce0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3ce4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3ce8:	8b 45 08             	mov    0x8(%ebp),%eax
    3ceb:	0f b6 00             	movzbl (%eax),%eax
    3cee:	84 c0                	test   %al,%al
    3cf0:	74 10                	je     3d02 <strcmp+0x27>
    3cf2:	8b 45 08             	mov    0x8(%ebp),%eax
    3cf5:	0f b6 10             	movzbl (%eax),%edx
    3cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cfb:	0f b6 00             	movzbl (%eax),%eax
    3cfe:	38 c2                	cmp    %al,%dl
    3d00:	74 de                	je     3ce0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3d02:	8b 45 08             	mov    0x8(%ebp),%eax
    3d05:	0f b6 00             	movzbl (%eax),%eax
    3d08:	0f b6 d0             	movzbl %al,%edx
    3d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d0e:	0f b6 00             	movzbl (%eax),%eax
    3d11:	0f b6 c0             	movzbl %al,%eax
    3d14:	29 c2                	sub    %eax,%edx
    3d16:	89 d0                	mov    %edx,%eax
}
    3d18:	5d                   	pop    %ebp
    3d19:	c3                   	ret    

00003d1a <strlen>:

uint
strlen(char *s)
{
    3d1a:	55                   	push   %ebp
    3d1b:	89 e5                	mov    %esp,%ebp
    3d1d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3d20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d27:	eb 04                	jmp    3d2d <strlen+0x13>
    3d29:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3d30:	8b 45 08             	mov    0x8(%ebp),%eax
    3d33:	01 d0                	add    %edx,%eax
    3d35:	0f b6 00             	movzbl (%eax),%eax
    3d38:	84 c0                	test   %al,%al
    3d3a:	75 ed                	jne    3d29 <strlen+0xf>
    ;
  return n;
    3d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d3f:	c9                   	leave  
    3d40:	c3                   	ret    

00003d41 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d41:	55                   	push   %ebp
    3d42:	89 e5                	mov    %esp,%ebp
    3d44:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3d47:	8b 45 10             	mov    0x10(%ebp),%eax
    3d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
    3d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d51:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d55:	8b 45 08             	mov    0x8(%ebp),%eax
    3d58:	89 04 24             	mov    %eax,(%esp)
    3d5b:	e8 26 ff ff ff       	call   3c86 <stosb>
  return dst;
    3d60:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d63:	c9                   	leave  
    3d64:	c3                   	ret    

00003d65 <strchr>:

char*
strchr(const char *s, char c)
{
    3d65:	55                   	push   %ebp
    3d66:	89 e5                	mov    %esp,%ebp
    3d68:	83 ec 04             	sub    $0x4,%esp
    3d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d6e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d71:	eb 14                	jmp    3d87 <strchr+0x22>
    if(*s == c)
    3d73:	8b 45 08             	mov    0x8(%ebp),%eax
    3d76:	0f b6 00             	movzbl (%eax),%eax
    3d79:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d7c:	75 05                	jne    3d83 <strchr+0x1e>
      return (char*)s;
    3d7e:	8b 45 08             	mov    0x8(%ebp),%eax
    3d81:	eb 13                	jmp    3d96 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d87:	8b 45 08             	mov    0x8(%ebp),%eax
    3d8a:	0f b6 00             	movzbl (%eax),%eax
    3d8d:	84 c0                	test   %al,%al
    3d8f:	75 e2                	jne    3d73 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d96:	c9                   	leave  
    3d97:	c3                   	ret    

00003d98 <gets>:

char*
gets(char *buf, int max)
{
    3d98:	55                   	push   %ebp
    3d99:	89 e5                	mov    %esp,%ebp
    3d9b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3da5:	eb 4c                	jmp    3df3 <gets+0x5b>
    cc = read(0, &c, 1);
    3da7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3dae:	00 
    3daf:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3db2:	89 44 24 04          	mov    %eax,0x4(%esp)
    3db6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3dbd:	e8 44 01 00 00       	call   3f06 <read>
    3dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3dc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3dc9:	7f 02                	jg     3dcd <gets+0x35>
      break;
    3dcb:	eb 31                	jmp    3dfe <gets+0x66>
    buf[i++] = c;
    3dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dd0:	8d 50 01             	lea    0x1(%eax),%edx
    3dd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3dd6:	89 c2                	mov    %eax,%edx
    3dd8:	8b 45 08             	mov    0x8(%ebp),%eax
    3ddb:	01 c2                	add    %eax,%edx
    3ddd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3de1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3de3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3de7:	3c 0a                	cmp    $0xa,%al
    3de9:	74 13                	je     3dfe <gets+0x66>
    3deb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3def:	3c 0d                	cmp    $0xd,%al
    3df1:	74 0b                	je     3dfe <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3df6:	83 c0 01             	add    $0x1,%eax
    3df9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dfc:	7c a9                	jl     3da7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3e01:	8b 45 08             	mov    0x8(%ebp),%eax
    3e04:	01 d0                	add    %edx,%eax
    3e06:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3e09:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e0c:	c9                   	leave  
    3e0d:	c3                   	ret    

00003e0e <stat>:

int
stat(char *n, struct stat *st)
{
    3e0e:	55                   	push   %ebp
    3e0f:	89 e5                	mov    %esp,%ebp
    3e11:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3e14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3e1b:	00 
    3e1c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e1f:	89 04 24             	mov    %eax,(%esp)
    3e22:	e8 07 01 00 00       	call   3f2e <open>
    3e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3e2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e2e:	79 07                	jns    3e37 <stat+0x29>
    return -1;
    3e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3e35:	eb 23                	jmp    3e5a <stat+0x4c>
  r = fstat(fd, st);
    3e37:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e41:	89 04 24             	mov    %eax,(%esp)
    3e44:	e8 fd 00 00 00       	call   3f46 <fstat>
    3e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e4f:	89 04 24             	mov    %eax,(%esp)
    3e52:	e8 bf 00 00 00       	call   3f16 <close>
  return r;
    3e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e5a:	c9                   	leave  
    3e5b:	c3                   	ret    

00003e5c <atoi>:

int
atoi(const char *s)
{
    3e5c:	55                   	push   %ebp
    3e5d:	89 e5                	mov    %esp,%ebp
    3e5f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e69:	eb 25                	jmp    3e90 <atoi+0x34>
    n = n*10 + *s++ - '0';
    3e6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e6e:	89 d0                	mov    %edx,%eax
    3e70:	c1 e0 02             	shl    $0x2,%eax
    3e73:	01 d0                	add    %edx,%eax
    3e75:	01 c0                	add    %eax,%eax
    3e77:	89 c1                	mov    %eax,%ecx
    3e79:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7c:	8d 50 01             	lea    0x1(%eax),%edx
    3e7f:	89 55 08             	mov    %edx,0x8(%ebp)
    3e82:	0f b6 00             	movzbl (%eax),%eax
    3e85:	0f be c0             	movsbl %al,%eax
    3e88:	01 c8                	add    %ecx,%eax
    3e8a:	83 e8 30             	sub    $0x30,%eax
    3e8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e90:	8b 45 08             	mov    0x8(%ebp),%eax
    3e93:	0f b6 00             	movzbl (%eax),%eax
    3e96:	3c 2f                	cmp    $0x2f,%al
    3e98:	7e 0a                	jle    3ea4 <atoi+0x48>
    3e9a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9d:	0f b6 00             	movzbl (%eax),%eax
    3ea0:	3c 39                	cmp    $0x39,%al
    3ea2:	7e c7                	jle    3e6b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3ea7:	c9                   	leave  
    3ea8:	c3                   	ret    

00003ea9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3ea9:	55                   	push   %ebp
    3eaa:	89 e5                	mov    %esp,%ebp
    3eac:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3eaf:	8b 45 08             	mov    0x8(%ebp),%eax
    3eb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
    3eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3ebb:	eb 17                	jmp    3ed4 <memmove+0x2b>
    *dst++ = *src++;
    3ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ec0:	8d 50 01             	lea    0x1(%eax),%edx
    3ec3:	89 55 fc             	mov    %edx,-0x4(%ebp)
    3ec6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3ec9:	8d 4a 01             	lea    0x1(%edx),%ecx
    3ecc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    3ecf:	0f b6 12             	movzbl (%edx),%edx
    3ed2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3ed4:	8b 45 10             	mov    0x10(%ebp),%eax
    3ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
    3eda:	89 55 10             	mov    %edx,0x10(%ebp)
    3edd:	85 c0                	test   %eax,%eax
    3edf:	7f dc                	jg     3ebd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3ee4:	c9                   	leave  
    3ee5:	c3                   	ret    

00003ee6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ee6:	b8 01 00 00 00       	mov    $0x1,%eax
    3eeb:	cd 40                	int    $0x40
    3eed:	c3                   	ret    

00003eee <exit>:
SYSCALL(exit)
    3eee:	b8 02 00 00 00       	mov    $0x2,%eax
    3ef3:	cd 40                	int    $0x40
    3ef5:	c3                   	ret    

00003ef6 <wait>:
SYSCALL(wait)
    3ef6:	b8 03 00 00 00       	mov    $0x3,%eax
    3efb:	cd 40                	int    $0x40
    3efd:	c3                   	ret    

00003efe <pipe>:
SYSCALL(pipe)
    3efe:	b8 04 00 00 00       	mov    $0x4,%eax
    3f03:	cd 40                	int    $0x40
    3f05:	c3                   	ret    

00003f06 <read>:
SYSCALL(read)
    3f06:	b8 05 00 00 00       	mov    $0x5,%eax
    3f0b:	cd 40                	int    $0x40
    3f0d:	c3                   	ret    

00003f0e <write>:
SYSCALL(write)
    3f0e:	b8 10 00 00 00       	mov    $0x10,%eax
    3f13:	cd 40                	int    $0x40
    3f15:	c3                   	ret    

00003f16 <close>:
SYSCALL(close)
    3f16:	b8 15 00 00 00       	mov    $0x15,%eax
    3f1b:	cd 40                	int    $0x40
    3f1d:	c3                   	ret    

00003f1e <kill>:
SYSCALL(kill)
    3f1e:	b8 06 00 00 00       	mov    $0x6,%eax
    3f23:	cd 40                	int    $0x40
    3f25:	c3                   	ret    

00003f26 <exec>:
SYSCALL(exec)
    3f26:	b8 07 00 00 00       	mov    $0x7,%eax
    3f2b:	cd 40                	int    $0x40
    3f2d:	c3                   	ret    

00003f2e <open>:
SYSCALL(open)
    3f2e:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f33:	cd 40                	int    $0x40
    3f35:	c3                   	ret    

00003f36 <mknod>:
SYSCALL(mknod)
    3f36:	b8 11 00 00 00       	mov    $0x11,%eax
    3f3b:	cd 40                	int    $0x40
    3f3d:	c3                   	ret    

00003f3e <unlink>:
SYSCALL(unlink)
    3f3e:	b8 12 00 00 00       	mov    $0x12,%eax
    3f43:	cd 40                	int    $0x40
    3f45:	c3                   	ret    

00003f46 <fstat>:
SYSCALL(fstat)
    3f46:	b8 08 00 00 00       	mov    $0x8,%eax
    3f4b:	cd 40                	int    $0x40
    3f4d:	c3                   	ret    

00003f4e <link>:
SYSCALL(link)
    3f4e:	b8 13 00 00 00       	mov    $0x13,%eax
    3f53:	cd 40                	int    $0x40
    3f55:	c3                   	ret    

00003f56 <mkdir>:
SYSCALL(mkdir)
    3f56:	b8 14 00 00 00       	mov    $0x14,%eax
    3f5b:	cd 40                	int    $0x40
    3f5d:	c3                   	ret    

00003f5e <chdir>:
SYSCALL(chdir)
    3f5e:	b8 09 00 00 00       	mov    $0x9,%eax
    3f63:	cd 40                	int    $0x40
    3f65:	c3                   	ret    

00003f66 <dup>:
SYSCALL(dup)
    3f66:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f6b:	cd 40                	int    $0x40
    3f6d:	c3                   	ret    

00003f6e <getpid>:
SYSCALL(getpid)
    3f6e:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f73:	cd 40                	int    $0x40
    3f75:	c3                   	ret    

00003f76 <sbrk>:
SYSCALL(sbrk)
    3f76:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f7b:	cd 40                	int    $0x40
    3f7d:	c3                   	ret    

00003f7e <sleep>:
SYSCALL(sleep)
    3f7e:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f83:	cd 40                	int    $0x40
    3f85:	c3                   	ret    

00003f86 <uptime>:
SYSCALL(uptime)
    3f86:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f8b:	cd 40                	int    $0x40
    3f8d:	c3                   	ret    

00003f8e <gettimeofday>:
SYSCALL(gettimeofday)//defino la nueva syscall.
    3f8e:	b8 16 00 00 00       	mov    $0x16,%eax
    3f93:	cd 40                	int    $0x40
    3f95:	c3                   	ret    

00003f96 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f96:	55                   	push   %ebp
    3f97:	89 e5                	mov    %esp,%ebp
    3f99:	83 ec 18             	sub    $0x18,%esp
    3f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f9f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3fa2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3fa9:	00 
    3faa:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3fad:	89 44 24 04          	mov    %eax,0x4(%esp)
    3fb1:	8b 45 08             	mov    0x8(%ebp),%eax
    3fb4:	89 04 24             	mov    %eax,(%esp)
    3fb7:	e8 52 ff ff ff       	call   3f0e <write>
}
    3fbc:	c9                   	leave  
    3fbd:	c3                   	ret    

00003fbe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3fbe:	55                   	push   %ebp
    3fbf:	89 e5                	mov    %esp,%ebp
    3fc1:	56                   	push   %esi
    3fc2:	53                   	push   %ebx
    3fc3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3fcd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3fd1:	74 17                	je     3fea <printint+0x2c>
    3fd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3fd7:	79 11                	jns    3fea <printint+0x2c>
    neg = 1;
    3fd9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fe3:	f7 d8                	neg    %eax
    3fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fe8:	eb 06                	jmp    3ff0 <printint+0x32>
  } else {
    x = xx;
    3fea:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3ff7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3ffa:	8d 41 01             	lea    0x1(%ecx),%eax
    3ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4000:	8b 5d 10             	mov    0x10(%ebp),%ebx
    4003:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4006:	ba 00 00 00 00       	mov    $0x0,%edx
    400b:	f7 f3                	div    %ebx
    400d:	89 d0                	mov    %edx,%eax
    400f:	0f b6 80 04 63 00 00 	movzbl 0x6304(%eax),%eax
    4016:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    401a:	8b 75 10             	mov    0x10(%ebp),%esi
    401d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4020:	ba 00 00 00 00       	mov    $0x0,%edx
    4025:	f7 f6                	div    %esi
    4027:	89 45 ec             	mov    %eax,-0x14(%ebp)
    402a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    402e:	75 c7                	jne    3ff7 <printint+0x39>
  if(neg)
    4030:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4034:	74 10                	je     4046 <printint+0x88>
    buf[i++] = '-';
    4036:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4039:	8d 50 01             	lea    0x1(%eax),%edx
    403c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    403f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4044:	eb 1f                	jmp    4065 <printint+0xa7>
    4046:	eb 1d                	jmp    4065 <printint+0xa7>
    putc(fd, buf[i]);
    4048:	8d 55 dc             	lea    -0x24(%ebp),%edx
    404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    404e:	01 d0                	add    %edx,%eax
    4050:	0f b6 00             	movzbl (%eax),%eax
    4053:	0f be c0             	movsbl %al,%eax
    4056:	89 44 24 04          	mov    %eax,0x4(%esp)
    405a:	8b 45 08             	mov    0x8(%ebp),%eax
    405d:	89 04 24             	mov    %eax,(%esp)
    4060:	e8 31 ff ff ff       	call   3f96 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4065:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    406d:	79 d9                	jns    4048 <printint+0x8a>
    putc(fd, buf[i]);
}
    406f:	83 c4 30             	add    $0x30,%esp
    4072:	5b                   	pop    %ebx
    4073:	5e                   	pop    %esi
    4074:	5d                   	pop    %ebp
    4075:	c3                   	ret    

00004076 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4076:	55                   	push   %ebp
    4077:	89 e5                	mov    %esp,%ebp
    4079:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    407c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4083:	8d 45 0c             	lea    0xc(%ebp),%eax
    4086:	83 c0 04             	add    $0x4,%eax
    4089:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    408c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4093:	e9 7c 01 00 00       	jmp    4214 <printf+0x19e>
    c = fmt[i] & 0xff;
    4098:	8b 55 0c             	mov    0xc(%ebp),%edx
    409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    409e:	01 d0                	add    %edx,%eax
    40a0:	0f b6 00             	movzbl (%eax),%eax
    40a3:	0f be c0             	movsbl %al,%eax
    40a6:	25 ff 00 00 00       	and    $0xff,%eax
    40ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    40ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    40b2:	75 2c                	jne    40e0 <printf+0x6a>
      if(c == '%'){
    40b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    40b8:	75 0c                	jne    40c6 <printf+0x50>
        state = '%';
    40ba:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    40c1:	e9 4a 01 00 00       	jmp    4210 <printf+0x19a>
      } else {
        putc(fd, c);
    40c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    40c9:	0f be c0             	movsbl %al,%eax
    40cc:	89 44 24 04          	mov    %eax,0x4(%esp)
    40d0:	8b 45 08             	mov    0x8(%ebp),%eax
    40d3:	89 04 24             	mov    %eax,(%esp)
    40d6:	e8 bb fe ff ff       	call   3f96 <putc>
    40db:	e9 30 01 00 00       	jmp    4210 <printf+0x19a>
      }
    } else if(state == '%'){
    40e0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40e4:	0f 85 26 01 00 00    	jne    4210 <printf+0x19a>
      if(c == 'd'){
    40ea:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40ee:	75 2d                	jne    411d <printf+0xa7>
        printint(fd, *ap, 10, 1);
    40f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40f3:	8b 00                	mov    (%eax),%eax
    40f5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    40fc:	00 
    40fd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    4104:	00 
    4105:	89 44 24 04          	mov    %eax,0x4(%esp)
    4109:	8b 45 08             	mov    0x8(%ebp),%eax
    410c:	89 04 24             	mov    %eax,(%esp)
    410f:	e8 aa fe ff ff       	call   3fbe <printint>
        ap++;
    4114:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4118:	e9 ec 00 00 00       	jmp    4209 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    411d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4121:	74 06                	je     4129 <printf+0xb3>
    4123:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    4127:	75 2d                	jne    4156 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    4129:	8b 45 e8             	mov    -0x18(%ebp),%eax
    412c:	8b 00                	mov    (%eax),%eax
    412e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    4135:	00 
    4136:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    413d:	00 
    413e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4142:	8b 45 08             	mov    0x8(%ebp),%eax
    4145:	89 04 24             	mov    %eax,(%esp)
    4148:	e8 71 fe ff ff       	call   3fbe <printint>
        ap++;
    414d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4151:	e9 b3 00 00 00       	jmp    4209 <printf+0x193>
      } else if(c == 's'){
    4156:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    415a:	75 45                	jne    41a1 <printf+0x12b>
        s = (char*)*ap;
    415c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    415f:	8b 00                	mov    (%eax),%eax
    4161:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4164:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    416c:	75 09                	jne    4177 <printf+0x101>
          s = "(null)";
    416e:	c7 45 f4 06 5c 00 00 	movl   $0x5c06,-0xc(%ebp)
        while(*s != 0){
    4175:	eb 1e                	jmp    4195 <printf+0x11f>
    4177:	eb 1c                	jmp    4195 <printf+0x11f>
          putc(fd, *s);
    4179:	8b 45 f4             	mov    -0xc(%ebp),%eax
    417c:	0f b6 00             	movzbl (%eax),%eax
    417f:	0f be c0             	movsbl %al,%eax
    4182:	89 44 24 04          	mov    %eax,0x4(%esp)
    4186:	8b 45 08             	mov    0x8(%ebp),%eax
    4189:	89 04 24             	mov    %eax,(%esp)
    418c:	e8 05 fe ff ff       	call   3f96 <putc>
          s++;
    4191:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4195:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4198:	0f b6 00             	movzbl (%eax),%eax
    419b:	84 c0                	test   %al,%al
    419d:	75 da                	jne    4179 <printf+0x103>
    419f:	eb 68                	jmp    4209 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    41a1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    41a5:	75 1d                	jne    41c4 <printf+0x14e>
        putc(fd, *ap);
    41a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    41aa:	8b 00                	mov    (%eax),%eax
    41ac:	0f be c0             	movsbl %al,%eax
    41af:	89 44 24 04          	mov    %eax,0x4(%esp)
    41b3:	8b 45 08             	mov    0x8(%ebp),%eax
    41b6:	89 04 24             	mov    %eax,(%esp)
    41b9:	e8 d8 fd ff ff       	call   3f96 <putc>
        ap++;
    41be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    41c2:	eb 45                	jmp    4209 <printf+0x193>
      } else if(c == '%'){
    41c4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41c8:	75 17                	jne    41e1 <printf+0x16b>
        putc(fd, c);
    41ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41cd:	0f be c0             	movsbl %al,%eax
    41d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    41d4:	8b 45 08             	mov    0x8(%ebp),%eax
    41d7:	89 04 24             	mov    %eax,(%esp)
    41da:	e8 b7 fd ff ff       	call   3f96 <putc>
    41df:	eb 28                	jmp    4209 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    41e1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    41e8:	00 
    41e9:	8b 45 08             	mov    0x8(%ebp),%eax
    41ec:	89 04 24             	mov    %eax,(%esp)
    41ef:	e8 a2 fd ff ff       	call   3f96 <putc>
        putc(fd, c);
    41f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41f7:	0f be c0             	movsbl %al,%eax
    41fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    41fe:	8b 45 08             	mov    0x8(%ebp),%eax
    4201:	89 04 24             	mov    %eax,(%esp)
    4204:	e8 8d fd ff ff       	call   3f96 <putc>
      }
      state = 0;
    4209:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4210:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    4214:	8b 55 0c             	mov    0xc(%ebp),%edx
    4217:	8b 45 f0             	mov    -0x10(%ebp),%eax
    421a:	01 d0                	add    %edx,%eax
    421c:	0f b6 00             	movzbl (%eax),%eax
    421f:	84 c0                	test   %al,%al
    4221:	0f 85 71 fe ff ff    	jne    4098 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4227:	c9                   	leave  
    4228:	c3                   	ret    

00004229 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4229:	55                   	push   %ebp
    422a:	89 e5                	mov    %esp,%ebp
    422c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    422f:	8b 45 08             	mov    0x8(%ebp),%eax
    4232:	83 e8 08             	sub    $0x8,%eax
    4235:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4238:	a1 a8 63 00 00       	mov    0x63a8,%eax
    423d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4240:	eb 24                	jmp    4266 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4242:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4245:	8b 00                	mov    (%eax),%eax
    4247:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    424a:	77 12                	ja     425e <free+0x35>
    424c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    424f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4252:	77 24                	ja     4278 <free+0x4f>
    4254:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4257:	8b 00                	mov    (%eax),%eax
    4259:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    425c:	77 1a                	ja     4278 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    425e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4261:	8b 00                	mov    (%eax),%eax
    4263:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4266:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4269:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    426c:	76 d4                	jbe    4242 <free+0x19>
    426e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4271:	8b 00                	mov    (%eax),%eax
    4273:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4276:	76 ca                	jbe    4242 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4278:	8b 45 f8             	mov    -0x8(%ebp),%eax
    427b:	8b 40 04             	mov    0x4(%eax),%eax
    427e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4285:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4288:	01 c2                	add    %eax,%edx
    428a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    428d:	8b 00                	mov    (%eax),%eax
    428f:	39 c2                	cmp    %eax,%edx
    4291:	75 24                	jne    42b7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4293:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4296:	8b 50 04             	mov    0x4(%eax),%edx
    4299:	8b 45 fc             	mov    -0x4(%ebp),%eax
    429c:	8b 00                	mov    (%eax),%eax
    429e:	8b 40 04             	mov    0x4(%eax),%eax
    42a1:	01 c2                	add    %eax,%edx
    42a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42a6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    42a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42ac:	8b 00                	mov    (%eax),%eax
    42ae:	8b 10                	mov    (%eax),%edx
    42b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42b3:	89 10                	mov    %edx,(%eax)
    42b5:	eb 0a                	jmp    42c1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    42b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42ba:	8b 10                	mov    (%eax),%edx
    42bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42bf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    42c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42c4:	8b 40 04             	mov    0x4(%eax),%eax
    42c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    42ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42d1:	01 d0                	add    %edx,%eax
    42d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    42d6:	75 20                	jne    42f8 <free+0xcf>
    p->s.size += bp->s.size;
    42d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42db:	8b 50 04             	mov    0x4(%eax),%edx
    42de:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42e1:	8b 40 04             	mov    0x4(%eax),%eax
    42e4:	01 c2                	add    %eax,%edx
    42e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42e9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    42ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42ef:	8b 10                	mov    (%eax),%edx
    42f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42f4:	89 10                	mov    %edx,(%eax)
    42f6:	eb 08                	jmp    4300 <free+0xd7>
  } else
    p->s.ptr = bp;
    42f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42fe:	89 10                	mov    %edx,(%eax)
  freep = p;
    4300:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4303:	a3 a8 63 00 00       	mov    %eax,0x63a8
}
    4308:	c9                   	leave  
    4309:	c3                   	ret    

0000430a <morecore>:

static Header*
morecore(uint nu)
{
    430a:	55                   	push   %ebp
    430b:	89 e5                	mov    %esp,%ebp
    430d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4310:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4317:	77 07                	ja     4320 <morecore+0x16>
    nu = 4096;
    4319:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4320:	8b 45 08             	mov    0x8(%ebp),%eax
    4323:	c1 e0 03             	shl    $0x3,%eax
    4326:	89 04 24             	mov    %eax,(%esp)
    4329:	e8 48 fc ff ff       	call   3f76 <sbrk>
    432e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4331:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4335:	75 07                	jne    433e <morecore+0x34>
    return 0;
    4337:	b8 00 00 00 00       	mov    $0x0,%eax
    433c:	eb 22                	jmp    4360 <morecore+0x56>
  hp = (Header*)p;
    433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4341:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4344:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4347:	8b 55 08             	mov    0x8(%ebp),%edx
    434a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    434d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4350:	83 c0 08             	add    $0x8,%eax
    4353:	89 04 24             	mov    %eax,(%esp)
    4356:	e8 ce fe ff ff       	call   4229 <free>
  return freep;
    435b:	a1 a8 63 00 00       	mov    0x63a8,%eax
}
    4360:	c9                   	leave  
    4361:	c3                   	ret    

00004362 <malloc>:

void*
malloc(uint nbytes)
{
    4362:	55                   	push   %ebp
    4363:	89 e5                	mov    %esp,%ebp
    4365:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4368:	8b 45 08             	mov    0x8(%ebp),%eax
    436b:	83 c0 07             	add    $0x7,%eax
    436e:	c1 e8 03             	shr    $0x3,%eax
    4371:	83 c0 01             	add    $0x1,%eax
    4374:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4377:	a1 a8 63 00 00       	mov    0x63a8,%eax
    437c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    437f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4383:	75 23                	jne    43a8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4385:	c7 45 f0 a0 63 00 00 	movl   $0x63a0,-0x10(%ebp)
    438c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    438f:	a3 a8 63 00 00       	mov    %eax,0x63a8
    4394:	a1 a8 63 00 00       	mov    0x63a8,%eax
    4399:	a3 a0 63 00 00       	mov    %eax,0x63a0
    base.s.size = 0;
    439e:	c7 05 a4 63 00 00 00 	movl   $0x0,0x63a4
    43a5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43ab:	8b 00                	mov    (%eax),%eax
    43ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    43b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43b3:	8b 40 04             	mov    0x4(%eax),%eax
    43b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43b9:	72 4d                	jb     4408 <malloc+0xa6>
      if(p->s.size == nunits)
    43bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43be:	8b 40 04             	mov    0x4(%eax),%eax
    43c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43c4:	75 0c                	jne    43d2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    43c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43c9:	8b 10                	mov    (%eax),%edx
    43cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43ce:	89 10                	mov    %edx,(%eax)
    43d0:	eb 26                	jmp    43f8 <malloc+0x96>
      else {
        p->s.size -= nunits;
    43d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43d5:	8b 40 04             	mov    0x4(%eax),%eax
    43d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
    43db:	89 c2                	mov    %eax,%edx
    43dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43e0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    43e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43e6:	8b 40 04             	mov    0x4(%eax),%eax
    43e9:	c1 e0 03             	shl    $0x3,%eax
    43ec:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    43ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
    43f5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43fb:	a3 a8 63 00 00       	mov    %eax,0x63a8
      return (void*)(p + 1);
    4400:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4403:	83 c0 08             	add    $0x8,%eax
    4406:	eb 38                	jmp    4440 <malloc+0xde>
    }
    if(p == freep)
    4408:	a1 a8 63 00 00       	mov    0x63a8,%eax
    440d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4410:	75 1b                	jne    442d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    4412:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4415:	89 04 24             	mov    %eax,(%esp)
    4418:	e8 ed fe ff ff       	call   430a <morecore>
    441d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4424:	75 07                	jne    442d <malloc+0xcb>
        return 0;
    4426:	b8 00 00 00 00       	mov    $0x0,%eax
    442b:	eb 13                	jmp    4440 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    442d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4430:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4433:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4436:	8b 00                	mov    (%eax),%eax
    4438:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    443b:	e9 70 ff ff ff       	jmp    43b0 <malloc+0x4e>
}
    4440:	c9                   	leave  
    4441:	c3                   	ret    
