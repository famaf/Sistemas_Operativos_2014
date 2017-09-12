
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c5 33 10 80       	mov    $0x801033c5,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 1c 83 10 	movl   $0x8010831c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 48 4a 00 00       	call   80104a96 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 f5 49 00 00       	call   80104ab7 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 10 4a 00 00       	call   80104b19 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 c9 46 00 00       	call   801047ed <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 98 49 00 00       	call   80104b19 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 23 83 10 80 	movl   $0x80108323,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 c9 25 00 00       	call   801027a1 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 34 83 10 80 	movl   $0x80108334,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 8c 25 00 00       	call   801027a1 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 3b 83 10 80 	movl   $0x8010833b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 76 48 00 00       	call   80104ab7 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 24 46 00 00       	call   801048c6 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 6b 48 00 00       	call   80104b19 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bb:	e8 f7 46 00 00       	call   80104ab7 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 42 83 10 80 	movl   $0x80108342,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 4b 83 10 80 	movl   $0x8010834b,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 e1 45 00 00       	call   80104b19 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 52 83 10 80 	movl   $0x80108352,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 61 83 10 80 	movl   $0x80108361,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 d4 45 00 00       	call   80104b68 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 63 83 10 80 	movl   $0x80108363,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 23 47 00 00       	call   80104dda <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 25 46 00 00       	call   80104d0b <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 47 5f 00 00       	call   801066c2 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 3b 5f 00 00       	call   801066c2 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 2f 5f 00 00       	call   801066c2 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 22 5f 00 00       	call   801066c2 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007ba:	e8 f8 42 00 00       	call   80104ab7 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 7a 41 00 00       	call   80104969 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100816:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100840:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010087c:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c de 10 80    	mov    %edx,0x8010de5c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 dd 10 80    	mov    %al,-0x7fef222c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008d5:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e7:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008ec:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008f3:	e8 ce 3f 00 00       	call   801048c6 <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100914:	e8 00 42 00 00       	call   80104b19 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 7d 10 00 00       	call   801019a9 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100939:	e8 79 41 00 00       	call   80104ab7 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100959:	e8 bb 41 00 00       	call   80104b19 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 f2 0e 00 00       	call   8010185b <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100982:	e8 66 3e 00 00       	call   801047ed <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
8010098d:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 54 de 10 80    	mov    %edx,0x8010de54
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801009fe:	e8 16 41 00 00       	call   80104b19 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 4d 0e 00 00       	call   8010185b <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 7e 0f 00 00       	call   801019a9 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a32:	e8 80 40 00 00       	call   80104ab7 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6c:	e8 a8 40 00 00       	call   80104b19 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 df 0d 00 00       	call   8010185b <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 67 83 10 	movl   $0x80108367,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a96:	e8 fb 3f 00 00       	call   80104a96 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 6f 83 10 	movl   $0x8010836f,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100aaa:	e8 e7 3f 00 00       	call   80104a96 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 0c e8 10 80 1a 	movl   $0x80100a1a,0x8010e80c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 08 e8 10 80 1b 	movl   $0x8010091b,0x8010e808
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 a8 2f 00 00       	call   80103a81 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 70 1e 00 00       	call   8010295d <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_trans();
80100af8:	e8 e8 26 00 00       	call   801031e5 <begin_trans>
  if((ip = namei(path)) == 0){
80100afd:	8b 45 08             	mov    0x8(%ebp),%eax
80100b00:	89 04 24             	mov    %eax,(%esp)
80100b03:	e8 fe 18 00 00       	call   80102406 <namei>
80100b08:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0f:	75 0f                	jne    80100b20 <exec+0x31>
    commit_trans();
80100b11:	e8 18 27 00 00       	call   8010322e <commit_trans>
    return -1;
80100b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1b:	e9 e8 03 00 00       	jmp    80100f08 <exec+0x419>
  }
  ilock(ip);
80100b20:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b23:	89 04 24             	mov    %eax,(%esp)
80100b26:	e8 30 0d 00 00       	call   8010185b <ilock>
  pgdir = 0;
80100b2b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b32:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b39:	00 
80100b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b41:	00 
80100b42:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b4f:	89 04 24             	mov    %eax,(%esp)
80100b52:	e8 11 12 00 00       	call   80101d68 <readi>
80100b57:	83 f8 33             	cmp    $0x33,%eax
80100b5a:	77 05                	ja     80100b61 <exec+0x72>
    goto bad;
80100b5c:	e9 7b 03 00 00       	jmp    80100edc <exec+0x3ed>
  if(elf.magic != ELF_MAGIC)
80100b61:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b67:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6c:	74 05                	je     80100b73 <exec+0x84>
    goto bad;
80100b6e:	e9 69 03 00 00       	jmp    80100edc <exec+0x3ed>

  if((pgdir = setupkvm()) == 0)
80100b73:	e8 9b 6c 00 00       	call   80107813 <setupkvm>
80100b78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b7f:	75 05                	jne    80100b86 <exec+0x97>
    goto bad;
80100b81:	e9 56 03 00 00       	jmp    80100edc <exec+0x3ed>

  // Load program into memory.
  sz = 0;
80100b86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b94:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9d:	e9 cb 00 00 00       	jmp    80100c6d <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba5:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bac:	00 
80100bad:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb1:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bbe:	89 04 24             	mov    %eax,(%esp)
80100bc1:	e8 a2 11 00 00       	call   80101d68 <readi>
80100bc6:	83 f8 20             	cmp    $0x20,%eax
80100bc9:	74 05                	je     80100bd0 <exec+0xe1>
      goto bad;
80100bcb:	e9 0c 03 00 00       	jmp    80100edc <exec+0x3ed>
    if(ph.type != ELF_PROG_LOAD)
80100bd0:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd6:	83 f8 01             	cmp    $0x1,%eax
80100bd9:	74 05                	je     80100be0 <exec+0xf1>
      continue;
80100bdb:	e9 80 00 00 00       	jmp    80100c60 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be0:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be6:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bec:	39 c2                	cmp    %eax,%edx
80100bee:	73 05                	jae    80100bf5 <exec+0x106>
      goto bad;
80100bf0:	e9 e7 02 00 00       	jmp    80100edc <exec+0x3ed>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf5:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfb:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c01:	01 d0                	add    %edx,%eax
80100c03:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c11:	89 04 24             	mov    %eax,(%esp)
80100c14:	e8 c8 6f 00 00       	call   80107be1 <allocuvm>
80100c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c20:	75 05                	jne    80100c27 <exec+0x138>
      goto bad;
80100c22:	e9 b5 02 00 00       	jmp    80100edc <exec+0x3ed>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c27:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c41:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c44:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c48:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c4f:	89 04 24             	mov    %eax,(%esp)
80100c52:	e8 9f 6e 00 00       	call   80107af6 <loaduvm>
80100c57:	85 c0                	test   %eax,%eax
80100c59:	79 05                	jns    80100c60 <exec+0x171>
      goto bad;
80100c5b:	e9 7c 02 00 00       	jmp    80100edc <exec+0x3ed>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c60:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c67:	83 c0 20             	add    $0x20,%eax
80100c6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6d:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c74:	0f b7 c0             	movzwl %ax,%eax
80100c77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7a:	0f 8f 22 ff ff ff    	jg     80100ba2 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c83:	89 04 24             	mov    %eax,(%esp)
80100c86:	e8 54 0e 00 00       	call   80101adf <iunlockput>
  commit_trans();
80100c8b:	e8 9e 25 00 00       	call   8010322e <commit_trans>
  ip = 0;
80100c90:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100caa:	05 00 20 00 00       	add    $0x2000,%eax
80100caf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbd:	89 04 24             	mov    %eax,(%esp)
80100cc0:	e8 1c 6f 00 00       	call   80107be1 <allocuvm>
80100cc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccc:	75 05                	jne    80100cd3 <exec+0x1e4>
    goto bad;
80100cce:	e9 09 02 00 00       	jmp    80100edc <exec+0x3ed>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce2:	89 04 24             	mov    %eax,(%esp)
80100ce5:	e8 27 71 00 00       	call   80107e11 <clearpteu>
  sp = sz;
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf7:	e9 9a 00 00 00       	jmp    80100d96 <exec+0x2a7>
    if(argc >= MAXARG)
80100cfc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d00:	76 05                	jbe    80100d07 <exec+0x218>
      goto bad;
80100d02:	e9 d5 01 00 00       	jmp    80100edc <exec+0x3ed>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d11:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d14:	01 d0                	add    %edx,%eax
80100d16:	8b 00                	mov    (%eax),%eax
80100d18:	89 04 24             	mov    %eax,(%esp)
80100d1b:	e8 55 42 00 00       	call   80104f75 <strlen>
80100d20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d23:	29 c2                	sub    %eax,%edx
80100d25:	89 d0                	mov    %edx,%eax
80100d27:	83 e8 01             	sub    $0x1,%eax
80100d2a:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3d:	01 d0                	add    %edx,%eax
80100d3f:	8b 00                	mov    (%eax),%eax
80100d41:	89 04 24             	mov    %eax,(%esp)
80100d44:	e8 2c 42 00 00       	call   80104f75 <strlen>
80100d49:	83 c0 01             	add    $0x1,%eax
80100d4c:	89 c2                	mov    %eax,%edx
80100d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d51:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5b:	01 c8                	add    %ecx,%eax
80100d5d:	8b 00                	mov    (%eax),%eax
80100d5f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d71:	89 04 24             	mov    %eax,(%esp)
80100d74:	e8 5d 72 00 00       	call   80107fd6 <copyout>
80100d79:	85 c0                	test   %eax,%eax
80100d7b:	79 05                	jns    80100d82 <exec+0x293>
      goto bad;
80100d7d:	e9 5a 01 00 00       	jmp    80100edc <exec+0x3ed>
    ustack[3+argc] = sp;
80100d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d85:	8d 50 03             	lea    0x3(%eax),%edx
80100d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8b:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d92:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da3:	01 d0                	add    %edx,%eax
80100da5:	8b 00                	mov    (%eax),%eax
80100da7:	85 c0                	test   %eax,%eax
80100da9:	0f 85 4d ff ff ff    	jne    80100cfc <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db2:	83 c0 03             	add    $0x3,%eax
80100db5:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbc:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc0:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc7:	ff ff ff 
  ustack[1] = argc;
80100dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcd:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd6:	83 c0 01             	add    $0x1,%eax
80100dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de3:	29 d0                	sub    %edx,%eax
80100de5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dee:	83 c0 04             	add    $0x4,%eax
80100df1:	c1 e0 02             	shl    $0x2,%eax
80100df4:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfa:	83 c0 04             	add    $0x4,%eax
80100dfd:	c1 e0 02             	shl    $0x2,%eax
80100e00:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e04:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e11:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e18:	89 04 24             	mov    %eax,(%esp)
80100e1b:	e8 b6 71 00 00       	call   80107fd6 <copyout>
80100e20:	85 c0                	test   %eax,%eax
80100e22:	79 05                	jns    80100e29 <exec+0x33a>
    goto bad;
80100e24:	e9 b3 00 00 00       	jmp    80100edc <exec+0x3ed>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e29:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e35:	eb 17                	jmp    80100e4e <exec+0x35f>
    if(*s == '/')
80100e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3a:	0f b6 00             	movzbl (%eax),%eax
80100e3d:	3c 2f                	cmp    $0x2f,%al
80100e3f:	75 09                	jne    80100e4a <exec+0x35b>
      last = s+1;
80100e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e44:	83 c0 01             	add    $0x1,%eax
80100e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e51:	0f b6 00             	movzbl (%eax),%eax
80100e54:	84 c0                	test   %al,%al
80100e56:	75 df                	jne    80100e37 <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5e:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e61:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e68:	00 
80100e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e70:	89 14 24             	mov    %edx,(%esp)
80100e73:	e8 b3 40 00 00       	call   80104f2b <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7e:	8b 40 04             	mov    0x4(%eax),%eax
80100e81:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e8d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e96:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e99:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea1:	8b 40 18             	mov    0x18(%eax),%eax
80100ea4:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eaa:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb3:	8b 40 18             	mov    0x18(%eax),%eax
80100eb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb9:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ebc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec2:	89 04 24             	mov    %eax,(%esp)
80100ec5:	e8 3a 6a 00 00       	call   80107904 <switchuvm>
  freevm(oldpgdir);
80100eca:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 a2 6e 00 00       	call   80107d77 <freevm>
  return 0;
80100ed5:	b8 00 00 00 00       	mov    $0x0,%eax
80100eda:	eb 2c                	jmp    80100f08 <exec+0x419>

 bad:
  if(pgdir)
80100edc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ee0:	74 0b                	je     80100eed <exec+0x3fe>
    freevm(pgdir);
80100ee2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ee5:	89 04 24             	mov    %eax,(%esp)
80100ee8:	e8 8a 6e 00 00       	call   80107d77 <freevm>
  if(ip){
80100eed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ef1:	74 10                	je     80100f03 <exec+0x414>
    iunlockput(ip);
80100ef3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef6:	89 04 24             	mov    %eax,(%esp)
80100ef9:	e8 e1 0b 00 00       	call   80101adf <iunlockput>
    commit_trans();
80100efe:	e8 2b 23 00 00       	call   8010322e <commit_trans>
  }
  return -1;
80100f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f08:	c9                   	leave  
80100f09:	c3                   	ret    

80100f0a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f0a:	55                   	push   %ebp
80100f0b:	89 e5                	mov    %esp,%ebp
80100f0d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f10:	c7 44 24 04 75 83 10 	movl   $0x80108375,0x4(%esp)
80100f17:	80 
80100f18:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f1f:	e8 72 3b 00 00       	call   80104a96 <initlock>
}
80100f24:	c9                   	leave  
80100f25:	c3                   	ret    

80100f26 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f26:	55                   	push   %ebp
80100f27:	89 e5                	mov    %esp,%ebp
80100f29:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f2c:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f33:	e8 7f 3b 00 00       	call   80104ab7 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f38:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f3f:	eb 29                	jmp    80100f6a <filealloc+0x44>
    if(f->ref == 0){
80100f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f44:	8b 40 04             	mov    0x4(%eax),%eax
80100f47:	85 c0                	test   %eax,%eax
80100f49:	75 1b                	jne    80100f66 <filealloc+0x40>
      f->ref = 1;
80100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f4e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f55:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f5c:	e8 b8 3b 00 00       	call   80104b19 <release>
      return f;
80100f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f64:	eb 1e                	jmp    80100f84 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f66:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f6a:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f71:	72 ce                	jb     80100f41 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f73:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f7a:	e8 9a 3b 00 00       	call   80104b19 <release>
  return 0;
80100f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f84:	c9                   	leave  
80100f85:	c3                   	ret    

80100f86 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f86:	55                   	push   %ebp
80100f87:	89 e5                	mov    %esp,%ebp
80100f89:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f8c:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f93:	e8 1f 3b 00 00       	call   80104ab7 <acquire>
  if(f->ref < 1)
80100f98:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9b:	8b 40 04             	mov    0x4(%eax),%eax
80100f9e:	85 c0                	test   %eax,%eax
80100fa0:	7f 0c                	jg     80100fae <filedup+0x28>
    panic("filedup");
80100fa2:	c7 04 24 7c 83 10 80 	movl   $0x8010837c,(%esp)
80100fa9:	e8 8c f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fae:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb1:	8b 40 04             	mov    0x4(%eax),%eax
80100fb4:	8d 50 01             	lea    0x1(%eax),%edx
80100fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80100fba:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fbd:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fc4:	e8 50 3b 00 00       	call   80104b19 <release>
  return f;
80100fc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fcc:	c9                   	leave  
80100fcd:	c3                   	ret    

80100fce <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fce:	55                   	push   %ebp
80100fcf:	89 e5                	mov    %esp,%ebp
80100fd1:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fd4:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fdb:	e8 d7 3a 00 00       	call   80104ab7 <acquire>
  if(f->ref < 1)
80100fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe3:	8b 40 04             	mov    0x4(%eax),%eax
80100fe6:	85 c0                	test   %eax,%eax
80100fe8:	7f 0c                	jg     80100ff6 <fileclose+0x28>
    panic("fileclose");
80100fea:	c7 04 24 84 83 10 80 	movl   $0x80108384,(%esp)
80100ff1:	e8 44 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff9:	8b 40 04             	mov    0x4(%eax),%eax
80100ffc:	8d 50 ff             	lea    -0x1(%eax),%edx
80100fff:	8b 45 08             	mov    0x8(%ebp),%eax
80101002:	89 50 04             	mov    %edx,0x4(%eax)
80101005:	8b 45 08             	mov    0x8(%ebp),%eax
80101008:	8b 40 04             	mov    0x4(%eax),%eax
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7e 11                	jle    80101020 <fileclose+0x52>
    release(&ftable.lock);
8010100f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101016:	e8 fe 3a 00 00       	call   80104b19 <release>
8010101b:	e9 82 00 00 00       	jmp    801010a2 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101020:	8b 45 08             	mov    0x8(%ebp),%eax
80101023:	8b 10                	mov    (%eax),%edx
80101025:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101028:	8b 50 04             	mov    0x4(%eax),%edx
8010102b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010102e:	8b 50 08             	mov    0x8(%eax),%edx
80101031:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101034:	8b 50 0c             	mov    0xc(%eax),%edx
80101037:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010103a:	8b 50 10             	mov    0x10(%eax),%edx
8010103d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101040:	8b 40 14             	mov    0x14(%eax),%eax
80101043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101046:	8b 45 08             	mov    0x8(%ebp),%eax
80101049:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101050:	8b 45 08             	mov    0x8(%ebp),%eax
80101053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101059:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101060:	e8 b4 3a 00 00       	call   80104b19 <release>
  
  if(ff.type == FD_PIPE)
80101065:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101068:	83 f8 01             	cmp    $0x1,%eax
8010106b:	75 18                	jne    80101085 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010106d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101071:	0f be d0             	movsbl %al,%edx
80101074:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101077:	89 54 24 04          	mov    %edx,0x4(%esp)
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 ae 2c 00 00       	call   80103d31 <pipeclose>
80101083:	eb 1d                	jmp    801010a2 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101085:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101088:	83 f8 02             	cmp    $0x2,%eax
8010108b:	75 15                	jne    801010a2 <fileclose+0xd4>
    begin_trans();
8010108d:	e8 53 21 00 00       	call   801031e5 <begin_trans>
    iput(ff.ip);
80101092:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101095:	89 04 24             	mov    %eax,(%esp)
80101098:	e8 71 09 00 00       	call   80101a0e <iput>
    commit_trans();
8010109d:	e8 8c 21 00 00       	call   8010322e <commit_trans>
  }
}
801010a2:	c9                   	leave  
801010a3:	c3                   	ret    

801010a4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010aa:	8b 45 08             	mov    0x8(%ebp),%eax
801010ad:	8b 00                	mov    (%eax),%eax
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 38                	jne    801010ec <filestat+0x48>
    ilock(f->ip);
801010b4:	8b 45 08             	mov    0x8(%ebp),%eax
801010b7:	8b 40 10             	mov    0x10(%eax),%eax
801010ba:	89 04 24             	mov    %eax,(%esp)
801010bd:	e8 99 07 00 00       	call   8010185b <ilock>
    stati(f->ip, st);
801010c2:	8b 45 08             	mov    0x8(%ebp),%eax
801010c5:	8b 40 10             	mov    0x10(%eax),%eax
801010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801010cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801010cf:	89 04 24             	mov    %eax,(%esp)
801010d2:	e8 4c 0c 00 00       	call   80101d23 <stati>
    iunlock(f->ip);
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 10             	mov    0x10(%eax),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 c4 08 00 00       	call   801019a9 <iunlock>
    return 0;
801010e5:	b8 00 00 00 00       	mov    $0x0,%eax
801010ea:	eb 05                	jmp    801010f1 <filestat+0x4d>
  }
  return -1;
801010ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010f1:	c9                   	leave  
801010f2:	c3                   	ret    

801010f3 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010f3:	55                   	push   %ebp
801010f4:	89 e5                	mov    %esp,%ebp
801010f6:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010f9:	8b 45 08             	mov    0x8(%ebp),%eax
801010fc:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101100:	84 c0                	test   %al,%al
80101102:	75 0a                	jne    8010110e <fileread+0x1b>
    return -1;
80101104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101109:	e9 9f 00 00 00       	jmp    801011ad <fileread+0xba>
  if(f->type == FD_PIPE)
8010110e:	8b 45 08             	mov    0x8(%ebp),%eax
80101111:	8b 00                	mov    (%eax),%eax
80101113:	83 f8 01             	cmp    $0x1,%eax
80101116:	75 1e                	jne    80101136 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	8b 40 0c             	mov    0xc(%eax),%eax
8010111e:	8b 55 10             	mov    0x10(%ebp),%edx
80101121:	89 54 24 08          	mov    %edx,0x8(%esp)
80101125:	8b 55 0c             	mov    0xc(%ebp),%edx
80101128:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112c:	89 04 24             	mov    %eax,(%esp)
8010112f:	e8 7e 2d 00 00       	call   80103eb2 <piperead>
80101134:	eb 77                	jmp    801011ad <fileread+0xba>
  if(f->type == FD_INODE){
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 00                	mov    (%eax),%eax
8010113b:	83 f8 02             	cmp    $0x2,%eax
8010113e:	75 61                	jne    801011a1 <fileread+0xae>
    ilock(f->ip);
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 10             	mov    0x10(%eax),%eax
80101146:	89 04 24             	mov    %eax,(%esp)
80101149:	e8 0d 07 00 00       	call   8010185b <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010114e:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101151:	8b 45 08             	mov    0x8(%ebp),%eax
80101154:	8b 50 14             	mov    0x14(%eax),%edx
80101157:	8b 45 08             	mov    0x8(%ebp),%eax
8010115a:	8b 40 10             	mov    0x10(%eax),%eax
8010115d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101161:	89 54 24 08          	mov    %edx,0x8(%esp)
80101165:	8b 55 0c             	mov    0xc(%ebp),%edx
80101168:	89 54 24 04          	mov    %edx,0x4(%esp)
8010116c:	89 04 24             	mov    %eax,(%esp)
8010116f:	e8 f4 0b 00 00       	call   80101d68 <readi>
80101174:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010117b:	7e 11                	jle    8010118e <fileread+0x9b>
      f->off += r;
8010117d:	8b 45 08             	mov    0x8(%ebp),%eax
80101180:	8b 50 14             	mov    0x14(%eax),%edx
80101183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101186:	01 c2                	add    %eax,%edx
80101188:	8b 45 08             	mov    0x8(%ebp),%eax
8010118b:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010118e:	8b 45 08             	mov    0x8(%ebp),%eax
80101191:	8b 40 10             	mov    0x10(%eax),%eax
80101194:	89 04 24             	mov    %eax,(%esp)
80101197:	e8 0d 08 00 00       	call   801019a9 <iunlock>
    return r;
8010119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119f:	eb 0c                	jmp    801011ad <fileread+0xba>
  }
  panic("fileread");
801011a1:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
801011a8:	e8 8d f3 ff ff       	call   8010053a <panic>
}
801011ad:	c9                   	leave  
801011ae:	c3                   	ret    

801011af <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011af:	55                   	push   %ebp
801011b0:	89 e5                	mov    %esp,%ebp
801011b2:	53                   	push   %ebx
801011b3:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011bd:	84 c0                	test   %al,%al
801011bf:	75 0a                	jne    801011cb <filewrite+0x1c>
    return -1;
801011c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011c6:	e9 20 01 00 00       	jmp    801012eb <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 00                	mov    (%eax),%eax
801011d0:	83 f8 01             	cmp    $0x1,%eax
801011d3:	75 21                	jne    801011f6 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011d5:	8b 45 08             	mov    0x8(%ebp),%eax
801011d8:	8b 40 0c             	mov    0xc(%eax),%eax
801011db:	8b 55 10             	mov    0x10(%ebp),%edx
801011de:	89 54 24 08          	mov    %edx,0x8(%esp)
801011e2:	8b 55 0c             	mov    0xc(%ebp),%edx
801011e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801011e9:	89 04 24             	mov    %eax,(%esp)
801011ec:	e8 d2 2b 00 00       	call   80103dc3 <pipewrite>
801011f1:	e9 f5 00 00 00       	jmp    801012eb <filewrite+0x13c>
  if(f->type == FD_INODE){
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 00                	mov    (%eax),%eax
801011fb:	83 f8 02             	cmp    $0x2,%eax
801011fe:	0f 85 db 00 00 00    	jne    801012df <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101204:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010120b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101212:	e9 a8 00 00 00       	jmp    801012bf <filewrite+0x110>
      int n1 = n - i;
80101217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121a:	8b 55 10             	mov    0x10(%ebp),%edx
8010121d:	29 c2                	sub    %eax,%edx
8010121f:	89 d0                	mov    %edx,%eax
80101221:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101224:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101227:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010122a:	7e 06                	jle    80101232 <filewrite+0x83>
        n1 = max;
8010122c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010122f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101232:	e8 ae 1f 00 00       	call   801031e5 <begin_trans>
      ilock(f->ip);
80101237:	8b 45 08             	mov    0x8(%ebp),%eax
8010123a:	8b 40 10             	mov    0x10(%eax),%eax
8010123d:	89 04 24             	mov    %eax,(%esp)
80101240:	e8 16 06 00 00       	call   8010185b <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101245:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101248:	8b 45 08             	mov    0x8(%ebp),%eax
8010124b:	8b 50 14             	mov    0x14(%eax),%edx
8010124e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101251:	8b 45 0c             	mov    0xc(%ebp),%eax
80101254:	01 c3                	add    %eax,%ebx
80101256:	8b 45 08             	mov    0x8(%ebp),%eax
80101259:	8b 40 10             	mov    0x10(%eax),%eax
8010125c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101260:	89 54 24 08          	mov    %edx,0x8(%esp)
80101264:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101268:	89 04 24             	mov    %eax,(%esp)
8010126b:	e8 5c 0c 00 00       	call   80101ecc <writei>
80101270:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101273:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101277:	7e 11                	jle    8010128a <filewrite+0xdb>
        f->off += r;
80101279:	8b 45 08             	mov    0x8(%ebp),%eax
8010127c:	8b 50 14             	mov    0x14(%eax),%edx
8010127f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101282:	01 c2                	add    %eax,%edx
80101284:	8b 45 08             	mov    0x8(%ebp),%eax
80101287:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010128a:	8b 45 08             	mov    0x8(%ebp),%eax
8010128d:	8b 40 10             	mov    0x10(%eax),%eax
80101290:	89 04 24             	mov    %eax,(%esp)
80101293:	e8 11 07 00 00       	call   801019a9 <iunlock>
      commit_trans();
80101298:	e8 91 1f 00 00       	call   8010322e <commit_trans>

      if(r < 0)
8010129d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a1:	79 02                	jns    801012a5 <filewrite+0xf6>
        break;
801012a3:	eb 26                	jmp    801012cb <filewrite+0x11c>
      if(r != n1)
801012a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012ab:	74 0c                	je     801012b9 <filewrite+0x10a>
        panic("short filewrite");
801012ad:	c7 04 24 97 83 10 80 	movl   $0x80108397,(%esp)
801012b4:	e8 81 f2 ff ff       	call   8010053a <panic>
      i += r;
801012b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012bc:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c2:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c5:	0f 8c 4c ff ff ff    	jl     80101217 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ce:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d1:	75 05                	jne    801012d8 <filewrite+0x129>
801012d3:	8b 45 10             	mov    0x10(%ebp),%eax
801012d6:	eb 05                	jmp    801012dd <filewrite+0x12e>
801012d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012dd:	eb 0c                	jmp    801012eb <filewrite+0x13c>
  }
  panic("filewrite");
801012df:	c7 04 24 a7 83 10 80 	movl   $0x801083a7,(%esp)
801012e6:	e8 4f f2 ff ff       	call   8010053a <panic>
}
801012eb:	83 c4 24             	add    $0x24,%esp
801012ee:	5b                   	pop    %ebx
801012ef:	5d                   	pop    %ebp
801012f0:	c3                   	ret    

801012f1 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012f1:	55                   	push   %ebp
801012f2:	89 e5                	mov    %esp,%ebp
801012f4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101301:	00 
80101302:	89 04 24             	mov    %eax,(%esp)
80101305:	e8 9c ee ff ff       	call   801001a6 <bread>
8010130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101310:	83 c0 18             	add    $0x18,%eax
80101313:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010131a:	00 
8010131b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101322:	89 04 24             	mov    %eax,(%esp)
80101325:	e8 b0 3a 00 00       	call   80104dda <memmove>
  brelse(bp);
8010132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132d:	89 04 24             	mov    %eax,(%esp)
80101330:	e8 e2 ee ff ff       	call   80100217 <brelse>
}
80101335:	c9                   	leave  
80101336:	c3                   	ret    

80101337 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101337:	55                   	push   %ebp
80101338:	89 e5                	mov    %esp,%ebp
8010133a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010133d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101340:	8b 45 08             	mov    0x8(%ebp),%eax
80101343:	89 54 24 04          	mov    %edx,0x4(%esp)
80101347:	89 04 24             	mov    %eax,(%esp)
8010134a:	e8 57 ee ff ff       	call   801001a6 <bread>
8010134f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101355:	83 c0 18             	add    $0x18,%eax
80101358:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010135f:	00 
80101360:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101367:	00 
80101368:	89 04 24             	mov    %eax,(%esp)
8010136b:	e8 9b 39 00 00       	call   80104d0b <memset>
  log_write(bp);
80101370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101373:	89 04 24             	mov    %eax,(%esp)
80101376:	e8 0b 1f 00 00       	call   80103286 <log_write>
  brelse(bp);
8010137b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137e:	89 04 24             	mov    %eax,(%esp)
80101381:	e8 91 ee ff ff       	call   80100217 <brelse>
}
80101386:	c9                   	leave  
80101387:	c3                   	ret    

80101388 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101388:	55                   	push   %ebp
80101389:	89 e5                	mov    %esp,%ebp
8010138b:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010138e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101395:	8b 45 08             	mov    0x8(%ebp),%eax
80101398:	8d 55 d8             	lea    -0x28(%ebp),%edx
8010139b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010139f:	89 04 24             	mov    %eax,(%esp)
801013a2:	e8 4a ff ff ff       	call   801012f1 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013ae:	e9 07 01 00 00       	jmp    801014ba <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b6:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013bc:	85 c0                	test   %eax,%eax
801013be:	0f 48 c2             	cmovs  %edx,%eax
801013c1:	c1 f8 0c             	sar    $0xc,%eax
801013c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013c7:	c1 ea 03             	shr    $0x3,%edx
801013ca:	01 d0                	add    %edx,%eax
801013cc:	83 c0 03             	add    $0x3,%eax
801013cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d3:	8b 45 08             	mov    0x8(%ebp),%eax
801013d6:	89 04 24             	mov    %eax,(%esp)
801013d9:	e8 c8 ed ff ff       	call   801001a6 <bread>
801013de:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013e8:	e9 9d 00 00 00       	jmp    8010148a <balloc+0x102>
      m = 1 << (bi % 8);
801013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013f0:	99                   	cltd   
801013f1:	c1 ea 1d             	shr    $0x1d,%edx
801013f4:	01 d0                	add    %edx,%eax
801013f6:	83 e0 07             	and    $0x7,%eax
801013f9:	29 d0                	sub    %edx,%eax
801013fb:	ba 01 00 00 00       	mov    $0x1,%edx
80101400:	89 c1                	mov    %eax,%ecx
80101402:	d3 e2                	shl    %cl,%edx
80101404:	89 d0                	mov    %edx,%eax
80101406:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140c:	8d 50 07             	lea    0x7(%eax),%edx
8010140f:	85 c0                	test   %eax,%eax
80101411:	0f 48 c2             	cmovs  %edx,%eax
80101414:	c1 f8 03             	sar    $0x3,%eax
80101417:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010141a:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010141f:	0f b6 c0             	movzbl %al,%eax
80101422:	23 45 e8             	and    -0x18(%ebp),%eax
80101425:	85 c0                	test   %eax,%eax
80101427:	75 5d                	jne    80101486 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142c:	8d 50 07             	lea    0x7(%eax),%edx
8010142f:	85 c0                	test   %eax,%eax
80101431:	0f 48 c2             	cmovs  %edx,%eax
80101434:	c1 f8 03             	sar    $0x3,%eax
80101437:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010143f:	89 d1                	mov    %edx,%ecx
80101441:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101444:	09 ca                	or     %ecx,%edx
80101446:	89 d1                	mov    %edx,%ecx
80101448:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010144f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101452:	89 04 24             	mov    %eax,(%esp)
80101455:	e8 2c 1e 00 00       	call   80103286 <log_write>
        brelse(bp);
8010145a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010145d:	89 04 24             	mov    %eax,(%esp)
80101460:	e8 b2 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101465:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101468:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146b:	01 c2                	add    %eax,%edx
8010146d:	8b 45 08             	mov    0x8(%ebp),%eax
80101470:	89 54 24 04          	mov    %edx,0x4(%esp)
80101474:	89 04 24             	mov    %eax,(%esp)
80101477:	e8 bb fe ff ff       	call   80101337 <bzero>
        return b + bi;
8010147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010147f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101482:	01 d0                	add    %edx,%eax
80101484:	eb 4e                	jmp    801014d4 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101486:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010148a:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101491:	7f 15                	jg     801014a8 <balloc+0x120>
80101493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101496:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101499:	01 d0                	add    %edx,%eax
8010149b:	89 c2                	mov    %eax,%edx
8010149d:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014a0:	39 c2                	cmp    %eax,%edx
801014a2:	0f 82 45 ff ff ff    	jb     801013ed <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014ab:	89 04 24             	mov    %eax,(%esp)
801014ae:	e8 64 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014b3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c0:	39 c2                	cmp    %eax,%edx
801014c2:	0f 82 eb fe ff ff    	jb     801013b3 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014c8:	c7 04 24 b1 83 10 80 	movl   $0x801083b1,(%esp)
801014cf:	e8 66 f0 ff ff       	call   8010053a <panic>
}
801014d4:	c9                   	leave  
801014d5:	c3                   	ret    

801014d6 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014d6:	55                   	push   %ebp
801014d7:	89 e5                	mov    %esp,%ebp
801014d9:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014dc:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014df:	89 44 24 04          	mov    %eax,0x4(%esp)
801014e3:	8b 45 08             	mov    0x8(%ebp),%eax
801014e6:	89 04 24             	mov    %eax,(%esp)
801014e9:	e8 03 fe ff ff       	call   801012f1 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f1:	c1 e8 0c             	shr    $0xc,%eax
801014f4:	89 c2                	mov    %eax,%edx
801014f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014f9:	c1 e8 03             	shr    $0x3,%eax
801014fc:	01 d0                	add    %edx,%eax
801014fe:	8d 50 03             	lea    0x3(%eax),%edx
80101501:	8b 45 08             	mov    0x8(%ebp),%eax
80101504:	89 54 24 04          	mov    %edx,0x4(%esp)
80101508:	89 04 24             	mov    %eax,(%esp)
8010150b:	e8 96 ec ff ff       	call   801001a6 <bread>
80101510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101513:	8b 45 0c             	mov    0xc(%ebp),%eax
80101516:	25 ff 0f 00 00       	and    $0xfff,%eax
8010151b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010151e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101521:	99                   	cltd   
80101522:	c1 ea 1d             	shr    $0x1d,%edx
80101525:	01 d0                	add    %edx,%eax
80101527:	83 e0 07             	and    $0x7,%eax
8010152a:	29 d0                	sub    %edx,%eax
8010152c:	ba 01 00 00 00       	mov    $0x1,%edx
80101531:	89 c1                	mov    %eax,%ecx
80101533:	d3 e2                	shl    %cl,%edx
80101535:	89 d0                	mov    %edx,%eax
80101537:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153d:	8d 50 07             	lea    0x7(%eax),%edx
80101540:	85 c0                	test   %eax,%eax
80101542:	0f 48 c2             	cmovs  %edx,%eax
80101545:	c1 f8 03             	sar    $0x3,%eax
80101548:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010154b:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101550:	0f b6 c0             	movzbl %al,%eax
80101553:	23 45 ec             	and    -0x14(%ebp),%eax
80101556:	85 c0                	test   %eax,%eax
80101558:	75 0c                	jne    80101566 <bfree+0x90>
    panic("freeing free block");
8010155a:	c7 04 24 c7 83 10 80 	movl   $0x801083c7,(%esp)
80101561:	e8 d4 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101566:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101569:	8d 50 07             	lea    0x7(%eax),%edx
8010156c:	85 c0                	test   %eax,%eax
8010156e:	0f 48 c2             	cmovs  %edx,%eax
80101571:	c1 f8 03             	sar    $0x3,%eax
80101574:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101577:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010157c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010157f:	f7 d1                	not    %ecx
80101581:	21 ca                	and    %ecx,%edx
80101583:	89 d1                	mov    %edx,%ecx
80101585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101588:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010158f:	89 04 24             	mov    %eax,(%esp)
80101592:	e8 ef 1c 00 00       	call   80103286 <log_write>
  brelse(bp);
80101597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159a:	89 04 24             	mov    %eax,(%esp)
8010159d:	e8 75 ec ff ff       	call   80100217 <brelse>
}
801015a2:	c9                   	leave  
801015a3:	c3                   	ret    

801015a4 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015a4:	55                   	push   %ebp
801015a5:	89 e5                	mov    %esp,%ebp
801015a7:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015aa:	c7 44 24 04 da 83 10 	movl   $0x801083da,0x4(%esp)
801015b1:	80 
801015b2:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015b9:	e8 d8 34 00 00       	call   80104a96 <initlock>
}
801015be:	c9                   	leave  
801015bf:	c3                   	ret    

801015c0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	83 ec 38             	sub    $0x38,%esp
801015c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c9:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015cd:	8b 45 08             	mov    0x8(%ebp),%eax
801015d0:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015d3:	89 54 24 04          	mov    %edx,0x4(%esp)
801015d7:	89 04 24             	mov    %eax,(%esp)
801015da:	e8 12 fd ff ff       	call   801012f1 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015df:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015e6:	e9 98 00 00 00       	jmp    80101683 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ee:	c1 e8 03             	shr    $0x3,%eax
801015f1:	83 c0 02             	add    $0x2,%eax
801015f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801015f8:	8b 45 08             	mov    0x8(%ebp),%eax
801015fb:	89 04 24             	mov    %eax,(%esp)
801015fe:	e8 a3 eb ff ff       	call   801001a6 <bread>
80101603:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101606:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101609:	8d 50 18             	lea    0x18(%eax),%edx
8010160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	01 d0                	add    %edx,%eax
80101617:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010161a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010161d:	0f b7 00             	movzwl (%eax),%eax
80101620:	66 85 c0             	test   %ax,%ax
80101623:	75 4f                	jne    80101674 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101625:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010162c:	00 
8010162d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101634:	00 
80101635:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101638:	89 04 24             	mov    %eax,(%esp)
8010163b:	e8 cb 36 00 00       	call   80104d0b <memset>
      dip->type = type;
80101640:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101643:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101647:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164d:	89 04 24             	mov    %eax,(%esp)
80101650:	e8 31 1c 00 00       	call   80103286 <log_write>
      brelse(bp);
80101655:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101658:	89 04 24             	mov    %eax,(%esp)
8010165b:	e8 b7 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101663:	89 44 24 04          	mov    %eax,0x4(%esp)
80101667:	8b 45 08             	mov    0x8(%ebp),%eax
8010166a:	89 04 24             	mov    %eax,(%esp)
8010166d:	e8 e5 00 00 00       	call   80101757 <iget>
80101672:	eb 29                	jmp    8010169d <ialloc+0xdd>
    }
    brelse(bp);
80101674:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101677:	89 04 24             	mov    %eax,(%esp)
8010167a:	e8 98 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010167f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101683:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101689:	39 c2                	cmp    %eax,%edx
8010168b:	0f 82 5a ff ff ff    	jb     801015eb <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101691:	c7 04 24 e1 83 10 80 	movl   $0x801083e1,(%esp)
80101698:	e8 9d ee ff ff       	call   8010053a <panic>
}
8010169d:	c9                   	leave  
8010169e:	c3                   	ret    

8010169f <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010169f:	55                   	push   %ebp
801016a0:	89 e5                	mov    %esp,%ebp
801016a2:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016a5:	8b 45 08             	mov    0x8(%ebp),%eax
801016a8:	8b 40 04             	mov    0x4(%eax),%eax
801016ab:	c1 e8 03             	shr    $0x3,%eax
801016ae:	8d 50 02             	lea    0x2(%eax),%edx
801016b1:	8b 45 08             	mov    0x8(%ebp),%eax
801016b4:	8b 00                	mov    (%eax),%eax
801016b6:	89 54 24 04          	mov    %edx,0x4(%esp)
801016ba:	89 04 24             	mov    %eax,(%esp)
801016bd:	e8 e4 ea ff ff       	call   801001a6 <bread>
801016c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c8:	8d 50 18             	lea    0x18(%eax),%edx
801016cb:	8b 45 08             	mov    0x8(%ebp),%eax
801016ce:	8b 40 04             	mov    0x4(%eax),%eax
801016d1:	83 e0 07             	and    $0x7,%eax
801016d4:	c1 e0 06             	shl    $0x6,%eax
801016d7:	01 d0                	add    %edx,%eax
801016d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016dc:	8b 45 08             	mov    0x8(%ebp),%eax
801016df:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e6:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ec:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f3:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801016f7:	8b 45 08             	mov    0x8(%ebp),%eax
801016fa:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101701:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101705:	8b 45 08             	mov    0x8(%ebp),%eax
80101708:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101713:	8b 45 08             	mov    0x8(%ebp),%eax
80101716:	8b 50 18             	mov    0x18(%eax),%edx
80101719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171c:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010171f:	8b 45 08             	mov    0x8(%ebp),%eax
80101722:	8d 50 1c             	lea    0x1c(%eax),%edx
80101725:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101728:	83 c0 0c             	add    $0xc,%eax
8010172b:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101732:	00 
80101733:	89 54 24 04          	mov    %edx,0x4(%esp)
80101737:	89 04 24             	mov    %eax,(%esp)
8010173a:	e8 9b 36 00 00       	call   80104dda <memmove>
  log_write(bp);
8010173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101742:	89 04 24             	mov    %eax,(%esp)
80101745:	e8 3c 1b 00 00       	call   80103286 <log_write>
  brelse(bp);
8010174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174d:	89 04 24             	mov    %eax,(%esp)
80101750:	e8 c2 ea ff ff       	call   80100217 <brelse>
}
80101755:	c9                   	leave  
80101756:	c3                   	ret    

80101757 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101757:	55                   	push   %ebp
80101758:	89 e5                	mov    %esp,%ebp
8010175a:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010175d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101764:	e8 4e 33 00 00       	call   80104ab7 <acquire>

  // Is the inode already cached?
  empty = 0;
80101769:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101770:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
80101777:	eb 59                	jmp    801017d2 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177c:	8b 40 08             	mov    0x8(%eax),%eax
8010177f:	85 c0                	test   %eax,%eax
80101781:	7e 35                	jle    801017b8 <iget+0x61>
80101783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101786:	8b 00                	mov    (%eax),%eax
80101788:	3b 45 08             	cmp    0x8(%ebp),%eax
8010178b:	75 2b                	jne    801017b8 <iget+0x61>
8010178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101790:	8b 40 04             	mov    0x4(%eax),%eax
80101793:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101796:	75 20                	jne    801017b8 <iget+0x61>
      ip->ref++;
80101798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179b:	8b 40 08             	mov    0x8(%eax),%eax
8010179e:	8d 50 01             	lea    0x1(%eax),%edx
801017a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a4:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017a7:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017ae:	e8 66 33 00 00       	call   80104b19 <release>
      return ip;
801017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b6:	eb 6f                	jmp    80101827 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017bc:	75 10                	jne    801017ce <iget+0x77>
801017be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c1:	8b 40 08             	mov    0x8(%eax),%eax
801017c4:	85 c0                	test   %eax,%eax
801017c6:	75 06                	jne    801017ce <iget+0x77>
      empty = ip;
801017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ce:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017d2:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
801017d9:	72 9e                	jb     80101779 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017df:	75 0c                	jne    801017ed <iget+0x96>
    panic("iget: no inodes");
801017e1:	c7 04 24 f3 83 10 80 	movl   $0x801083f3,(%esp)
801017e8:	e8 4d ed ff ff       	call   8010053a <panic>

  ip = empty;
801017ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f6:	8b 55 08             	mov    0x8(%ebp),%edx
801017f9:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fe:	8b 55 0c             	mov    0xc(%ebp),%edx
80101801:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101807:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101811:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101818:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010181f:	e8 f5 32 00 00       	call   80104b19 <release>

  return ip;
80101824:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101827:	c9                   	leave  
80101828:	c3                   	ret    

80101829 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101829:	55                   	push   %ebp
8010182a:	89 e5                	mov    %esp,%ebp
8010182c:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010182f:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101836:	e8 7c 32 00 00       	call   80104ab7 <acquire>
  ip->ref++;
8010183b:	8b 45 08             	mov    0x8(%ebp),%eax
8010183e:	8b 40 08             	mov    0x8(%eax),%eax
80101841:	8d 50 01             	lea    0x1(%eax),%edx
80101844:	8b 45 08             	mov    0x8(%ebp),%eax
80101847:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010184a:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101851:	e8 c3 32 00 00       	call   80104b19 <release>
  return ip;
80101856:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101859:	c9                   	leave  
8010185a:	c3                   	ret    

8010185b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010185b:	55                   	push   %ebp
8010185c:	89 e5                	mov    %esp,%ebp
8010185e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101861:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101865:	74 0a                	je     80101871 <ilock+0x16>
80101867:	8b 45 08             	mov    0x8(%ebp),%eax
8010186a:	8b 40 08             	mov    0x8(%eax),%eax
8010186d:	85 c0                	test   %eax,%eax
8010186f:	7f 0c                	jg     8010187d <ilock+0x22>
    panic("ilock");
80101871:	c7 04 24 03 84 10 80 	movl   $0x80108403,(%esp)
80101878:	e8 bd ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010187d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101884:	e8 2e 32 00 00       	call   80104ab7 <acquire>
  while(ip->flags & I_BUSY)
80101889:	eb 13                	jmp    8010189e <ilock+0x43>
    sleep(ip, &icache.lock);
8010188b:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
80101892:	80 
80101893:	8b 45 08             	mov    0x8(%ebp),%eax
80101896:	89 04 24             	mov    %eax,(%esp)
80101899:	e8 4f 2f 00 00       	call   801047ed <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010189e:	8b 45 08             	mov    0x8(%ebp),%eax
801018a1:	8b 40 0c             	mov    0xc(%eax),%eax
801018a4:	83 e0 01             	and    $0x1,%eax
801018a7:	85 c0                	test   %eax,%eax
801018a9:	75 e0                	jne    8010188b <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018ab:	8b 45 08             	mov    0x8(%ebp),%eax
801018ae:	8b 40 0c             	mov    0xc(%eax),%eax
801018b1:	83 c8 01             	or     $0x1,%eax
801018b4:	89 c2                	mov    %eax,%edx
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018bc:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018c3:	e8 51 32 00 00       	call   80104b19 <release>

  if(!(ip->flags & I_VALID)){
801018c8:	8b 45 08             	mov    0x8(%ebp),%eax
801018cb:	8b 40 0c             	mov    0xc(%eax),%eax
801018ce:	83 e0 02             	and    $0x2,%eax
801018d1:	85 c0                	test   %eax,%eax
801018d3:	0f 85 ce 00 00 00    	jne    801019a7 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018d9:	8b 45 08             	mov    0x8(%ebp),%eax
801018dc:	8b 40 04             	mov    0x4(%eax),%eax
801018df:	c1 e8 03             	shr    $0x3,%eax
801018e2:	8d 50 02             	lea    0x2(%eax),%edx
801018e5:	8b 45 08             	mov    0x8(%ebp),%eax
801018e8:	8b 00                	mov    (%eax),%eax
801018ea:	89 54 24 04          	mov    %edx,0x4(%esp)
801018ee:	89 04 24             	mov    %eax,(%esp)
801018f1:	e8 b0 e8 ff ff       	call   801001a6 <bread>
801018f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018fc:	8d 50 18             	lea    0x18(%eax),%edx
801018ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101902:	8b 40 04             	mov    0x4(%eax),%eax
80101905:	83 e0 07             	and    $0x7,%eax
80101908:	c1 e0 06             	shl    $0x6,%eax
8010190b:	01 d0                	add    %edx,%eax
8010190d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101910:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101913:	0f b7 10             	movzwl (%eax),%edx
80101916:	8b 45 08             	mov    0x8(%ebp),%eax
80101919:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101920:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101932:	8b 45 08             	mov    0x8(%ebp),%eax
80101935:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194a:	8b 50 08             	mov    0x8(%eax),%edx
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101953:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101956:	8d 50 0c             	lea    0xc(%eax),%edx
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	83 c0 1c             	add    $0x1c,%eax
8010195f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101966:	00 
80101967:	89 54 24 04          	mov    %edx,0x4(%esp)
8010196b:	89 04 24             	mov    %eax,(%esp)
8010196e:	e8 67 34 00 00       	call   80104dda <memmove>
    brelse(bp);
80101973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101976:	89 04 24             	mov    %eax,(%esp)
80101979:	e8 99 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010197e:	8b 45 08             	mov    0x8(%ebp),%eax
80101981:	8b 40 0c             	mov    0xc(%eax),%eax
80101984:	83 c8 02             	or     $0x2,%eax
80101987:	89 c2                	mov    %eax,%edx
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010198f:	8b 45 08             	mov    0x8(%ebp),%eax
80101992:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101996:	66 85 c0             	test   %ax,%ax
80101999:	75 0c                	jne    801019a7 <ilock+0x14c>
      panic("ilock: no type");
8010199b:	c7 04 24 09 84 10 80 	movl   $0x80108409,(%esp)
801019a2:	e8 93 eb ff ff       	call   8010053a <panic>
  }
}
801019a7:	c9                   	leave  
801019a8:	c3                   	ret    

801019a9 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019a9:	55                   	push   %ebp
801019aa:	89 e5                	mov    %esp,%ebp
801019ac:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019b3:	74 17                	je     801019cc <iunlock+0x23>
801019b5:	8b 45 08             	mov    0x8(%ebp),%eax
801019b8:	8b 40 0c             	mov    0xc(%eax),%eax
801019bb:	83 e0 01             	and    $0x1,%eax
801019be:	85 c0                	test   %eax,%eax
801019c0:	74 0a                	je     801019cc <iunlock+0x23>
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	8b 40 08             	mov    0x8(%eax),%eax
801019c8:	85 c0                	test   %eax,%eax
801019ca:	7f 0c                	jg     801019d8 <iunlock+0x2f>
    panic("iunlock");
801019cc:	c7 04 24 18 84 10 80 	movl   $0x80108418,(%esp)
801019d3:	e8 62 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019d8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019df:	e8 d3 30 00 00       	call   80104ab7 <acquire>
  ip->flags &= ~I_BUSY;
801019e4:	8b 45 08             	mov    0x8(%ebp),%eax
801019e7:	8b 40 0c             	mov    0xc(%eax),%eax
801019ea:	83 e0 fe             	and    $0xfffffffe,%eax
801019ed:	89 c2                	mov    %eax,%edx
801019ef:	8b 45 08             	mov    0x8(%ebp),%eax
801019f2:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	89 04 24             	mov    %eax,(%esp)
801019fb:	e8 c6 2e 00 00       	call   801048c6 <wakeup>
  release(&icache.lock);
80101a00:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a07:	e8 0d 31 00 00       	call   80104b19 <release>
}
80101a0c:	c9                   	leave  
80101a0d:	c3                   	ret    

80101a0e <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a0e:	55                   	push   %ebp
80101a0f:	89 e5                	mov    %esp,%ebp
80101a11:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a14:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a1b:	e8 97 30 00 00       	call   80104ab7 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	8b 40 08             	mov    0x8(%eax),%eax
80101a26:	83 f8 01             	cmp    $0x1,%eax
80101a29:	0f 85 93 00 00 00    	jne    80101ac2 <iput+0xb4>
80101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a32:	8b 40 0c             	mov    0xc(%eax),%eax
80101a35:	83 e0 02             	and    $0x2,%eax
80101a38:	85 c0                	test   %eax,%eax
80101a3a:	0f 84 82 00 00 00    	je     80101ac2 <iput+0xb4>
80101a40:	8b 45 08             	mov    0x8(%ebp),%eax
80101a43:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a47:	66 85 c0             	test   %ax,%ax
80101a4a:	75 76                	jne    80101ac2 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a52:	83 e0 01             	and    $0x1,%eax
80101a55:	85 c0                	test   %eax,%eax
80101a57:	74 0c                	je     80101a65 <iput+0x57>
      panic("iput busy");
80101a59:	c7 04 24 20 84 10 80 	movl   $0x80108420,(%esp)
80101a60:	e8 d5 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a65:	8b 45 08             	mov    0x8(%ebp),%eax
80101a68:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6b:	83 c8 01             	or     $0x1,%eax
80101a6e:	89 c2                	mov    %eax,%edx
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a76:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a7d:	e8 97 30 00 00       	call   80104b19 <release>
    itrunc(ip);
80101a82:	8b 45 08             	mov    0x8(%ebp),%eax
80101a85:	89 04 24             	mov    %eax,(%esp)
80101a88:	e8 7d 01 00 00       	call   80101c0a <itrunc>
    ip->type = 0;
80101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a90:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	89 04 24             	mov    %eax,(%esp)
80101a9c:	e8 fe fb ff ff       	call   8010169f <iupdate>
    acquire(&icache.lock);
80101aa1:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101aa8:	e8 0a 30 00 00       	call   80104ab7 <acquire>
    ip->flags = 0;
80101aad:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	89 04 24             	mov    %eax,(%esp)
80101abd:	e8 04 2e 00 00       	call   801048c6 <wakeup>
  }
  ip->ref--;
80101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac5:	8b 40 08             	mov    0x8(%eax),%eax
80101ac8:	8d 50 ff             	lea    -0x1(%eax),%edx
80101acb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ace:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ad1:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ad8:	e8 3c 30 00 00       	call   80104b19 <release>
}
80101add:	c9                   	leave  
80101ade:	c3                   	ret    

80101adf <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101adf:	55                   	push   %ebp
80101ae0:	89 e5                	mov    %esp,%ebp
80101ae2:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae8:	89 04 24             	mov    %eax,(%esp)
80101aeb:	e8 b9 fe ff ff       	call   801019a9 <iunlock>
  iput(ip);
80101af0:	8b 45 08             	mov    0x8(%ebp),%eax
80101af3:	89 04 24             	mov    %eax,(%esp)
80101af6:	e8 13 ff ff ff       	call   80101a0e <iput>
}
80101afb:	c9                   	leave  
80101afc:	c3                   	ret    

80101afd <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101afd:	55                   	push   %ebp
80101afe:	89 e5                	mov    %esp,%ebp
80101b00:	53                   	push   %ebx
80101b01:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b04:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b08:	77 3e                	ja     80101b48 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b10:	83 c2 04             	add    $0x4,%edx
80101b13:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b1e:	75 20                	jne    80101b40 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b20:	8b 45 08             	mov    0x8(%ebp),%eax
80101b23:	8b 00                	mov    (%eax),%eax
80101b25:	89 04 24             	mov    %eax,(%esp)
80101b28:	e8 5b f8 ff ff       	call   80101388 <balloc>
80101b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b36:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b3c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b43:	e9 bc 00 00 00       	jmp    80101c04 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b48:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b4c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b50:	0f 87 a2 00 00 00    	ja     80101bf8 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b56:	8b 45 08             	mov    0x8(%ebp),%eax
80101b59:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b63:	75 19                	jne    80101b7e <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	8b 00                	mov    (%eax),%eax
80101b6a:	89 04 24             	mov    %eax,(%esp)
80101b6d:	e8 16 f8 ff ff       	call   80101388 <balloc>
80101b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b75:	8b 45 08             	mov    0x8(%ebp),%eax
80101b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b7b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b81:	8b 00                	mov    (%eax),%eax
80101b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b86:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b8a:	89 04 24             	mov    %eax,(%esp)
80101b8d:	e8 14 e6 ff ff       	call   801001a6 <bread>
80101b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b98:	83 c0 18             	add    $0x18,%eax
80101b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bab:	01 d0                	add    %edx,%eax
80101bad:	8b 00                	mov    (%eax),%eax
80101baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bb6:	75 30                	jne    80101be8 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bc5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcb:	8b 00                	mov    (%eax),%eax
80101bcd:	89 04 24             	mov    %eax,(%esp)
80101bd0:	e8 b3 f7 ff ff       	call   80101388 <balloc>
80101bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bdb:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be0:	89 04 24             	mov    %eax,(%esp)
80101be3:	e8 9e 16 00 00       	call   80103286 <log_write>
    }
    brelse(bp);
80101be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101beb:	89 04 24             	mov    %eax,(%esp)
80101bee:	e8 24 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf6:	eb 0c                	jmp    80101c04 <bmap+0x107>
  }

  panic("bmap: out of range");
80101bf8:	c7 04 24 2a 84 10 80 	movl   $0x8010842a,(%esp)
80101bff:	e8 36 e9 ff ff       	call   8010053a <panic>
}
80101c04:	83 c4 24             	add    $0x24,%esp
80101c07:	5b                   	pop    %ebx
80101c08:	5d                   	pop    %ebp
80101c09:	c3                   	ret    

80101c0a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c0a:	55                   	push   %ebp
80101c0b:	89 e5                	mov    %esp,%ebp
80101c0d:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c17:	eb 44                	jmp    80101c5d <itrunc+0x53>
    if(ip->addrs[i]){
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c1f:	83 c2 04             	add    $0x4,%edx
80101c22:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c26:	85 c0                	test   %eax,%eax
80101c28:	74 2f                	je     80101c59 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c30:	83 c2 04             	add    $0x4,%edx
80101c33:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c37:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3a:	8b 00                	mov    (%eax),%eax
80101c3c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c40:	89 04 24             	mov    %eax,(%esp)
80101c43:	e8 8e f8 ff ff       	call   801014d6 <bfree>
      ip->addrs[i] = 0;
80101c48:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c4e:	83 c2 04             	add    $0x4,%edx
80101c51:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c58:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c5d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c61:	7e b6                	jle    80101c19 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c63:	8b 45 08             	mov    0x8(%ebp),%eax
80101c66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c69:	85 c0                	test   %eax,%eax
80101c6b:	0f 84 9b 00 00 00    	je     80101d0c <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c71:	8b 45 08             	mov    0x8(%ebp),%eax
80101c74:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c77:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7a:	8b 00                	mov    (%eax),%eax
80101c7c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c80:	89 04 24             	mov    %eax,(%esp)
80101c83:	e8 1e e5 ff ff       	call   801001a6 <bread>
80101c88:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c8e:	83 c0 18             	add    $0x18,%eax
80101c91:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c9b:	eb 3b                	jmp    80101cd8 <itrunc+0xce>
      if(a[j])
80101c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101caa:	01 d0                	add    %edx,%eax
80101cac:	8b 00                	mov    (%eax),%eax
80101cae:	85 c0                	test   %eax,%eax
80101cb0:	74 22                	je     80101cd4 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cbf:	01 d0                	add    %edx,%eax
80101cc1:	8b 10                	mov    (%eax),%edx
80101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc6:	8b 00                	mov    (%eax),%eax
80101cc8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ccc:	89 04 24             	mov    %eax,(%esp)
80101ccf:	e8 02 f8 ff ff       	call   801014d6 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cd4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cdb:	83 f8 7f             	cmp    $0x7f,%eax
80101cde:	76 bd                	jbe    80101c9d <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce3:	89 04 24             	mov    %eax,(%esp)
80101ce6:	e8 2c e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cee:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf4:	8b 00                	mov    (%eax),%eax
80101cf6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cfa:	89 04 24             	mov    %eax,(%esp)
80101cfd:	e8 d4 f7 ff ff       	call   801014d6 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d16:	8b 45 08             	mov    0x8(%ebp),%eax
80101d19:	89 04 24             	mov    %eax,(%esp)
80101d1c:	e8 7e f9 ff ff       	call   8010169f <iupdate>
}
80101d21:	c9                   	leave  
80101d22:	c3                   	ret    

80101d23 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d23:	55                   	push   %ebp
80101d24:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d26:	8b 45 08             	mov    0x8(%ebp),%eax
80101d29:	8b 00                	mov    (%eax),%eax
80101d2b:	89 c2                	mov    %eax,%edx
80101d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d30:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d33:	8b 45 08             	mov    0x8(%ebp),%eax
80101d36:	8b 50 04             	mov    0x4(%eax),%edx
80101d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3c:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d49:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d56:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	8b 50 18             	mov    0x18(%eax),%edx
80101d60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d63:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d66:	5d                   	pop    %ebp
80101d67:	c3                   	ret    

80101d68 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d68:	55                   	push   %ebp
80101d69:	89 e5                	mov    %esp,%ebp
80101d6b:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d71:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d75:	66 83 f8 03          	cmp    $0x3,%ax
80101d79:	75 60                	jne    80101ddb <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d82:	66 85 c0             	test   %ax,%ax
80101d85:	78 20                	js     80101da7 <readi+0x3f>
80101d87:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d8e:	66 83 f8 09          	cmp    $0x9,%ax
80101d92:	7f 13                	jg     80101da7 <readi+0x3f>
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9b:	98                   	cwtl   
80101d9c:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101da3:	85 c0                	test   %eax,%eax
80101da5:	75 0a                	jne    80101db1 <readi+0x49>
      return -1;
80101da7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dac:	e9 19 01 00 00       	jmp    80101eca <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101db1:	8b 45 08             	mov    0x8(%ebp),%eax
80101db4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101db8:	98                   	cwtl   
80101db9:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101dc0:	8b 55 14             	mov    0x14(%ebp),%edx
80101dc3:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dca:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dce:	8b 55 08             	mov    0x8(%ebp),%edx
80101dd1:	89 14 24             	mov    %edx,(%esp)
80101dd4:	ff d0                	call   *%eax
80101dd6:	e9 ef 00 00 00       	jmp    80101eca <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dde:	8b 40 18             	mov    0x18(%eax),%eax
80101de1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de4:	72 0d                	jb     80101df3 <readi+0x8b>
80101de6:	8b 45 14             	mov    0x14(%ebp),%eax
80101de9:	8b 55 10             	mov    0x10(%ebp),%edx
80101dec:	01 d0                	add    %edx,%eax
80101dee:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df1:	73 0a                	jae    80101dfd <readi+0x95>
    return -1;
80101df3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101df8:	e9 cd 00 00 00       	jmp    80101eca <readi+0x162>
  if(off + n > ip->size)
80101dfd:	8b 45 14             	mov    0x14(%ebp),%eax
80101e00:	8b 55 10             	mov    0x10(%ebp),%edx
80101e03:	01 c2                	add    %eax,%edx
80101e05:	8b 45 08             	mov    0x8(%ebp),%eax
80101e08:	8b 40 18             	mov    0x18(%eax),%eax
80101e0b:	39 c2                	cmp    %eax,%edx
80101e0d:	76 0c                	jbe    80101e1b <readi+0xb3>
    n = ip->size - off;
80101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e12:	8b 40 18             	mov    0x18(%eax),%eax
80101e15:	2b 45 10             	sub    0x10(%ebp),%eax
80101e18:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e22:	e9 94 00 00 00       	jmp    80101ebb <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e27:	8b 45 10             	mov    0x10(%ebp),%eax
80101e2a:	c1 e8 09             	shr    $0x9,%eax
80101e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e31:	8b 45 08             	mov    0x8(%ebp),%eax
80101e34:	89 04 24             	mov    %eax,(%esp)
80101e37:	e8 c1 fc ff ff       	call   80101afd <bmap>
80101e3c:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3f:	8b 12                	mov    (%edx),%edx
80101e41:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e45:	89 14 24             	mov    %edx,(%esp)
80101e48:	e8 59 e3 ff ff       	call   801001a6 <bread>
80101e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e50:	8b 45 10             	mov    0x10(%ebp),%eax
80101e53:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e58:	89 c2                	mov    %eax,%edx
80101e5a:	b8 00 02 00 00       	mov    $0x200,%eax
80101e5f:	29 d0                	sub    %edx,%eax
80101e61:	89 c2                	mov    %eax,%edx
80101e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e66:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e69:	29 c1                	sub    %eax,%ecx
80101e6b:	89 c8                	mov    %ecx,%eax
80101e6d:	39 c2                	cmp    %eax,%edx
80101e6f:	0f 46 c2             	cmovbe %edx,%eax
80101e72:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e75:	8b 45 10             	mov    0x10(%ebp),%eax
80101e78:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e7d:	8d 50 10             	lea    0x10(%eax),%edx
80101e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e83:	01 d0                	add    %edx,%eax
80101e85:	8d 50 08             	lea    0x8(%eax),%edx
80101e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e8f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e96:	89 04 24             	mov    %eax,(%esp)
80101e99:	e8 3c 2f 00 00       	call   80104dda <memmove>
    brelse(bp);
80101e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea1:	89 04 24             	mov    %eax,(%esp)
80101ea4:	e8 6e e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eac:	01 45 f4             	add    %eax,-0xc(%ebp)
80101eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb2:	01 45 10             	add    %eax,0x10(%ebp)
80101eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb8:	01 45 0c             	add    %eax,0xc(%ebp)
80101ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ebe:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ec1:	0f 82 60 ff ff ff    	jb     80101e27 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ec7:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eca:	c9                   	leave  
80101ecb:	c3                   	ret    

80101ecc <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ecc:	55                   	push   %ebp
80101ecd:	89 e5                	mov    %esp,%ebp
80101ecf:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ed9:	66 83 f8 03          	cmp    $0x3,%ax
80101edd:	75 60                	jne    80101f3f <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101edf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee6:	66 85 c0             	test   %ax,%ax
80101ee9:	78 20                	js     80101f0b <writei+0x3f>
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101eee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef2:	66 83 f8 09          	cmp    $0x9,%ax
80101ef6:	7f 13                	jg     80101f0b <writei+0x3f>
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eff:	98                   	cwtl   
80101f00:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f07:	85 c0                	test   %eax,%eax
80101f09:	75 0a                	jne    80101f15 <writei+0x49>
      return -1;
80101f0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f10:	e9 44 01 00 00       	jmp    80102059 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f15:	8b 45 08             	mov    0x8(%ebp),%eax
80101f18:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f1c:	98                   	cwtl   
80101f1d:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f24:	8b 55 14             	mov    0x14(%ebp),%edx
80101f27:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f2e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f32:	8b 55 08             	mov    0x8(%ebp),%edx
80101f35:	89 14 24             	mov    %edx,(%esp)
80101f38:	ff d0                	call   *%eax
80101f3a:	e9 1a 01 00 00       	jmp    80102059 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	8b 40 18             	mov    0x18(%eax),%eax
80101f45:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f48:	72 0d                	jb     80101f57 <writei+0x8b>
80101f4a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f4d:	8b 55 10             	mov    0x10(%ebp),%edx
80101f50:	01 d0                	add    %edx,%eax
80101f52:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f55:	73 0a                	jae    80101f61 <writei+0x95>
    return -1;
80101f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f5c:	e9 f8 00 00 00       	jmp    80102059 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f61:	8b 45 14             	mov    0x14(%ebp),%eax
80101f64:	8b 55 10             	mov    0x10(%ebp),%edx
80101f67:	01 d0                	add    %edx,%eax
80101f69:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f6e:	76 0a                	jbe    80101f7a <writei+0xae>
    return -1;
80101f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f75:	e9 df 00 00 00       	jmp    80102059 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f81:	e9 9f 00 00 00       	jmp    80102025 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f86:	8b 45 10             	mov    0x10(%ebp),%eax
80101f89:	c1 e8 09             	shr    $0x9,%eax
80101f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f90:	8b 45 08             	mov    0x8(%ebp),%eax
80101f93:	89 04 24             	mov    %eax,(%esp)
80101f96:	e8 62 fb ff ff       	call   80101afd <bmap>
80101f9b:	8b 55 08             	mov    0x8(%ebp),%edx
80101f9e:	8b 12                	mov    (%edx),%edx
80101fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa4:	89 14 24             	mov    %edx,(%esp)
80101fa7:	e8 fa e1 ff ff       	call   801001a6 <bread>
80101fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101faf:	8b 45 10             	mov    0x10(%ebp),%eax
80101fb2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fb7:	89 c2                	mov    %eax,%edx
80101fb9:	b8 00 02 00 00       	mov    $0x200,%eax
80101fbe:	29 d0                	sub    %edx,%eax
80101fc0:	89 c2                	mov    %eax,%edx
80101fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc5:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fc8:	29 c1                	sub    %eax,%ecx
80101fca:	89 c8                	mov    %ecx,%eax
80101fcc:	39 c2                	cmp    %eax,%edx
80101fce:	0f 46 c2             	cmovbe %edx,%eax
80101fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fd4:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fdc:	8d 50 10             	lea    0x10(%eax),%edx
80101fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe2:	01 d0                	add    %edx,%eax
80101fe4:	8d 50 08             	lea    0x8(%eax),%edx
80101fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fea:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff5:	89 14 24             	mov    %edx,(%esp)
80101ff8:	e8 dd 2d 00 00       	call   80104dda <memmove>
    log_write(bp);
80101ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102000:	89 04 24             	mov    %eax,(%esp)
80102003:	e8 7e 12 00 00       	call   80103286 <log_write>
    brelse(bp);
80102008:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200b:	89 04 24             	mov    %eax,(%esp)
8010200e:	e8 04 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102013:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102016:	01 45 f4             	add    %eax,-0xc(%ebp)
80102019:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201c:	01 45 10             	add    %eax,0x10(%ebp)
8010201f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102022:	01 45 0c             	add    %eax,0xc(%ebp)
80102025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102028:	3b 45 14             	cmp    0x14(%ebp),%eax
8010202b:	0f 82 55 ff ff ff    	jb     80101f86 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102031:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102035:	74 1f                	je     80102056 <writei+0x18a>
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	8b 40 18             	mov    0x18(%eax),%eax
8010203d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102040:	73 14                	jae    80102056 <writei+0x18a>
    ip->size = off;
80102042:	8b 45 08             	mov    0x8(%ebp),%eax
80102045:	8b 55 10             	mov    0x10(%ebp),%edx
80102048:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010204b:	8b 45 08             	mov    0x8(%ebp),%eax
8010204e:	89 04 24             	mov    %eax,(%esp)
80102051:	e8 49 f6 ff ff       	call   8010169f <iupdate>
  }
  return n;
80102056:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102059:	c9                   	leave  
8010205a:	c3                   	ret    

8010205b <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010205b:	55                   	push   %ebp
8010205c:	89 e5                	mov    %esp,%ebp
8010205e:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102061:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102068:	00 
80102069:	8b 45 0c             	mov    0xc(%ebp),%eax
8010206c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102070:	8b 45 08             	mov    0x8(%ebp),%eax
80102073:	89 04 24             	mov    %eax,(%esp)
80102076:	e8 02 2e 00 00       	call   80104e7d <strncmp>
}
8010207b:	c9                   	leave  
8010207c:	c3                   	ret    

8010207d <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010207d:	55                   	push   %ebp
8010207e:	89 e5                	mov    %esp,%ebp
80102080:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010208a:	66 83 f8 01          	cmp    $0x1,%ax
8010208e:	74 0c                	je     8010209c <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102090:	c7 04 24 3d 84 10 80 	movl   $0x8010843d,(%esp)
80102097:	e8 9e e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010209c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020a3:	e9 88 00 00 00       	jmp    80102130 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020af:	00 
801020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b3:	89 44 24 08          	mov    %eax,0x8(%esp)
801020b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801020be:	8b 45 08             	mov    0x8(%ebp),%eax
801020c1:	89 04 24             	mov    %eax,(%esp)
801020c4:	e8 9f fc ff ff       	call   80101d68 <readi>
801020c9:	83 f8 10             	cmp    $0x10,%eax
801020cc:	74 0c                	je     801020da <dirlookup+0x5d>
      panic("dirlink read");
801020ce:	c7 04 24 4f 84 10 80 	movl   $0x8010844f,(%esp)
801020d5:	e8 60 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020da:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020de:	66 85 c0             	test   %ax,%ax
801020e1:	75 02                	jne    801020e5 <dirlookup+0x68>
      continue;
801020e3:	eb 47                	jmp    8010212c <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020e8:	83 c0 02             	add    $0x2,%eax
801020eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f2:	89 04 24             	mov    %eax,(%esp)
801020f5:	e8 61 ff ff ff       	call   8010205b <namecmp>
801020fa:	85 c0                	test   %eax,%eax
801020fc:	75 2e                	jne    8010212c <dirlookup+0xaf>
      // entry matches path element
      if(poff)
801020fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102102:	74 08                	je     8010210c <dirlookup+0x8f>
        *poff = off;
80102104:	8b 45 10             	mov    0x10(%ebp),%eax
80102107:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010210a:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010210c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102110:	0f b7 c0             	movzwl %ax,%eax
80102113:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102116:	8b 45 08             	mov    0x8(%ebp),%eax
80102119:	8b 00                	mov    (%eax),%eax
8010211b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010211e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102122:	89 04 24             	mov    %eax,(%esp)
80102125:	e8 2d f6 ff ff       	call   80101757 <iget>
8010212a:	eb 18                	jmp    80102144 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010212c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102130:	8b 45 08             	mov    0x8(%ebp),%eax
80102133:	8b 40 18             	mov    0x18(%eax),%eax
80102136:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102139:	0f 87 69 ff ff ff    	ja     801020a8 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010213f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102144:	c9                   	leave  
80102145:	c3                   	ret    

80102146 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102146:	55                   	push   %ebp
80102147:	89 e5                	mov    %esp,%ebp
80102149:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010214c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102153:	00 
80102154:	8b 45 0c             	mov    0xc(%ebp),%eax
80102157:	89 44 24 04          	mov    %eax,0x4(%esp)
8010215b:	8b 45 08             	mov    0x8(%ebp),%eax
8010215e:	89 04 24             	mov    %eax,(%esp)
80102161:	e8 17 ff ff ff       	call   8010207d <dirlookup>
80102166:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010216d:	74 15                	je     80102184 <dirlink+0x3e>
    iput(ip);
8010216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102172:	89 04 24             	mov    %eax,(%esp)
80102175:	e8 94 f8 ff ff       	call   80101a0e <iput>
    return -1;
8010217a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010217f:	e9 b7 00 00 00       	jmp    8010223b <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010218b:	eb 46                	jmp    801021d3 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102190:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102197:	00 
80102198:	89 44 24 08          	mov    %eax,0x8(%esp)
8010219c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010219f:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a3:	8b 45 08             	mov    0x8(%ebp),%eax
801021a6:	89 04 24             	mov    %eax,(%esp)
801021a9:	e8 ba fb ff ff       	call   80101d68 <readi>
801021ae:	83 f8 10             	cmp    $0x10,%eax
801021b1:	74 0c                	je     801021bf <dirlink+0x79>
      panic("dirlink read");
801021b3:	c7 04 24 4f 84 10 80 	movl   $0x8010844f,(%esp)
801021ba:	e8 7b e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021bf:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c3:	66 85 c0             	test   %ax,%ax
801021c6:	75 02                	jne    801021ca <dirlink+0x84>
      break;
801021c8:	eb 16                	jmp    801021e0 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021cd:	83 c0 10             	add    $0x10,%eax
801021d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021d6:	8b 45 08             	mov    0x8(%ebp),%eax
801021d9:	8b 40 18             	mov    0x18(%eax),%eax
801021dc:	39 c2                	cmp    %eax,%edx
801021de:	72 ad                	jb     8010218d <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021e0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021e7:	00 
801021e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801021eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801021ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f2:	83 c0 02             	add    $0x2,%eax
801021f5:	89 04 24             	mov    %eax,(%esp)
801021f8:	e8 d6 2c 00 00       	call   80104ed3 <strncpy>
  de.inum = inum;
801021fd:	8b 45 10             	mov    0x10(%ebp),%eax
80102200:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102207:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010220e:	00 
8010220f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102213:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102216:	89 44 24 04          	mov    %eax,0x4(%esp)
8010221a:	8b 45 08             	mov    0x8(%ebp),%eax
8010221d:	89 04 24             	mov    %eax,(%esp)
80102220:	e8 a7 fc ff ff       	call   80101ecc <writei>
80102225:	83 f8 10             	cmp    $0x10,%eax
80102228:	74 0c                	je     80102236 <dirlink+0xf0>
    panic("dirlink");
8010222a:	c7 04 24 5c 84 10 80 	movl   $0x8010845c,(%esp)
80102231:	e8 04 e3 ff ff       	call   8010053a <panic>
  
  return 0;
80102236:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223b:	c9                   	leave  
8010223c:	c3                   	ret    

8010223d <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010223d:	55                   	push   %ebp
8010223e:	89 e5                	mov    %esp,%ebp
80102240:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102243:	eb 04                	jmp    80102249 <skipelem+0xc>
    path++;
80102245:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102249:	8b 45 08             	mov    0x8(%ebp),%eax
8010224c:	0f b6 00             	movzbl (%eax),%eax
8010224f:	3c 2f                	cmp    $0x2f,%al
80102251:	74 f2                	je     80102245 <skipelem+0x8>
    path++;
  if(*path == 0)
80102253:	8b 45 08             	mov    0x8(%ebp),%eax
80102256:	0f b6 00             	movzbl (%eax),%eax
80102259:	84 c0                	test   %al,%al
8010225b:	75 0a                	jne    80102267 <skipelem+0x2a>
    return 0;
8010225d:	b8 00 00 00 00       	mov    $0x0,%eax
80102262:	e9 86 00 00 00       	jmp    801022ed <skipelem+0xb0>
  s = path;
80102267:	8b 45 08             	mov    0x8(%ebp),%eax
8010226a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010226d:	eb 04                	jmp    80102273 <skipelem+0x36>
    path++;
8010226f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102273:	8b 45 08             	mov    0x8(%ebp),%eax
80102276:	0f b6 00             	movzbl (%eax),%eax
80102279:	3c 2f                	cmp    $0x2f,%al
8010227b:	74 0a                	je     80102287 <skipelem+0x4a>
8010227d:	8b 45 08             	mov    0x8(%ebp),%eax
80102280:	0f b6 00             	movzbl (%eax),%eax
80102283:	84 c0                	test   %al,%al
80102285:	75 e8                	jne    8010226f <skipelem+0x32>
    path++;
  len = path - s;
80102287:	8b 55 08             	mov    0x8(%ebp),%edx
8010228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010228d:	29 c2                	sub    %eax,%edx
8010228f:	89 d0                	mov    %edx,%eax
80102291:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102294:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102298:	7e 1c                	jle    801022b6 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
8010229a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022a1:	00 
801022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ac:	89 04 24             	mov    %eax,(%esp)
801022af:	e8 26 2b 00 00       	call   80104dda <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022b4:	eb 2a                	jmp    801022e0 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022b9:	89 44 24 08          	mov    %eax,0x8(%esp)
801022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801022c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801022c7:	89 04 24             	mov    %eax,(%esp)
801022ca:	e8 0b 2b 00 00       	call   80104dda <memmove>
    name[len] = 0;
801022cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d5:	01 d0                	add    %edx,%eax
801022d7:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022da:	eb 04                	jmp    801022e0 <skipelem+0xa3>
    path++;
801022dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022e0:	8b 45 08             	mov    0x8(%ebp),%eax
801022e3:	0f b6 00             	movzbl (%eax),%eax
801022e6:	3c 2f                	cmp    $0x2f,%al
801022e8:	74 f2                	je     801022dc <skipelem+0x9f>
    path++;
  return path;
801022ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ed:	c9                   	leave  
801022ee:	c3                   	ret    

801022ef <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022ef:	55                   	push   %ebp
801022f0:	89 e5                	mov    %esp,%ebp
801022f2:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022f5:	8b 45 08             	mov    0x8(%ebp),%eax
801022f8:	0f b6 00             	movzbl (%eax),%eax
801022fb:	3c 2f                	cmp    $0x2f,%al
801022fd:	75 1c                	jne    8010231b <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801022ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102306:	00 
80102307:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010230e:	e8 44 f4 ff ff       	call   80101757 <iget>
80102313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102316:	e9 af 00 00 00       	jmp    801023ca <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010231b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102321:	8b 40 68             	mov    0x68(%eax),%eax
80102324:	89 04 24             	mov    %eax,(%esp)
80102327:	e8 fd f4 ff ff       	call   80101829 <idup>
8010232c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010232f:	e9 96 00 00 00       	jmp    801023ca <namex+0xdb>
    ilock(ip);
80102334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102337:	89 04 24             	mov    %eax,(%esp)
8010233a:	e8 1c f5 ff ff       	call   8010185b <ilock>
    if(ip->type != T_DIR){
8010233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102342:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102346:	66 83 f8 01          	cmp    $0x1,%ax
8010234a:	74 15                	je     80102361 <namex+0x72>
      iunlockput(ip);
8010234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234f:	89 04 24             	mov    %eax,(%esp)
80102352:	e8 88 f7 ff ff       	call   80101adf <iunlockput>
      return 0;
80102357:	b8 00 00 00 00       	mov    $0x0,%eax
8010235c:	e9 a3 00 00 00       	jmp    80102404 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102361:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102365:	74 1d                	je     80102384 <namex+0x95>
80102367:	8b 45 08             	mov    0x8(%ebp),%eax
8010236a:	0f b6 00             	movzbl (%eax),%eax
8010236d:	84 c0                	test   %al,%al
8010236f:	75 13                	jne    80102384 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102374:	89 04 24             	mov    %eax,(%esp)
80102377:	e8 2d f6 ff ff       	call   801019a9 <iunlock>
      return ip;
8010237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237f:	e9 80 00 00 00       	jmp    80102404 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102384:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010238b:	00 
8010238c:	8b 45 10             	mov    0x10(%ebp),%eax
8010238f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102396:	89 04 24             	mov    %eax,(%esp)
80102399:	e8 df fc ff ff       	call   8010207d <dirlookup>
8010239e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023a5:	75 12                	jne    801023b9 <namex+0xca>
      iunlockput(ip);
801023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023aa:	89 04 24             	mov    %eax,(%esp)
801023ad:	e8 2d f7 ff ff       	call   80101adf <iunlockput>
      return 0;
801023b2:	b8 00 00 00 00       	mov    $0x0,%eax
801023b7:	eb 4b                	jmp    80102404 <namex+0x115>
    }
    iunlockput(ip);
801023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bc:	89 04 24             	mov    %eax,(%esp)
801023bf:	e8 1b f7 ff ff       	call   80101adf <iunlockput>
    ip = next;
801023c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023ca:	8b 45 10             	mov    0x10(%ebp),%eax
801023cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d1:	8b 45 08             	mov    0x8(%ebp),%eax
801023d4:	89 04 24             	mov    %eax,(%esp)
801023d7:	e8 61 fe ff ff       	call   8010223d <skipelem>
801023dc:	89 45 08             	mov    %eax,0x8(%ebp)
801023df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023e3:	0f 85 4b ff ff ff    	jne    80102334 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023ed:	74 12                	je     80102401 <namex+0x112>
    iput(ip);
801023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f2:	89 04 24             	mov    %eax,(%esp)
801023f5:	e8 14 f6 ff ff       	call   80101a0e <iput>
    return 0;
801023fa:	b8 00 00 00 00       	mov    $0x0,%eax
801023ff:	eb 03                	jmp    80102404 <namex+0x115>
  }
  return ip;
80102401:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102404:	c9                   	leave  
80102405:	c3                   	ret    

80102406 <namei>:

struct inode*
namei(char *path)
{
80102406:	55                   	push   %ebp
80102407:	89 e5                	mov    %esp,%ebp
80102409:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010240c:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010240f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102413:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010241a:	00 
8010241b:	8b 45 08             	mov    0x8(%ebp),%eax
8010241e:	89 04 24             	mov    %eax,(%esp)
80102421:	e8 c9 fe ff ff       	call   801022ef <namex>
}
80102426:	c9                   	leave  
80102427:	c3                   	ret    

80102428 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102428:	55                   	push   %ebp
80102429:	89 e5                	mov    %esp,%ebp
8010242b:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010242e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102431:	89 44 24 08          	mov    %eax,0x8(%esp)
80102435:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010243c:	00 
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
80102440:	89 04 24             	mov    %eax,(%esp)
80102443:	e8 a7 fe ff ff       	call   801022ef <namex>
}
80102448:	c9                   	leave  
80102449:	c3                   	ret    

8010244a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010244a:	55                   	push   %ebp
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	83 ec 14             	sub    $0x14,%esp
80102450:	8b 45 08             	mov    0x8(%ebp),%eax
80102453:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102457:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010245b:	89 c2                	mov    %eax,%edx
8010245d:	ec                   	in     (%dx),%al
8010245e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102461:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102465:	c9                   	leave  
80102466:	c3                   	ret    

80102467 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102467:	55                   	push   %ebp
80102468:	89 e5                	mov    %esp,%ebp
8010246a:	57                   	push   %edi
8010246b:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010246c:	8b 55 08             	mov    0x8(%ebp),%edx
8010246f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102472:	8b 45 10             	mov    0x10(%ebp),%eax
80102475:	89 cb                	mov    %ecx,%ebx
80102477:	89 df                	mov    %ebx,%edi
80102479:	89 c1                	mov    %eax,%ecx
8010247b:	fc                   	cld    
8010247c:	f3 6d                	rep insl (%dx),%es:(%edi)
8010247e:	89 c8                	mov    %ecx,%eax
80102480:	89 fb                	mov    %edi,%ebx
80102482:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102485:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102488:	5b                   	pop    %ebx
80102489:	5f                   	pop    %edi
8010248a:	5d                   	pop    %ebp
8010248b:	c3                   	ret    

8010248c <outb>:

static inline void
outb(ushort port, uchar data)
{
8010248c:	55                   	push   %ebp
8010248d:	89 e5                	mov    %esp,%ebp
8010248f:	83 ec 08             	sub    $0x8,%esp
80102492:	8b 55 08             	mov    0x8(%ebp),%edx
80102495:	8b 45 0c             	mov    0xc(%ebp),%eax
80102498:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010249c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010249f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024a3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024a7:	ee                   	out    %al,(%dx)
}
801024a8:	c9                   	leave  
801024a9:	c3                   	ret    

801024aa <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024aa:	55                   	push   %ebp
801024ab:	89 e5                	mov    %esp,%ebp
801024ad:	56                   	push   %esi
801024ae:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024af:	8b 55 08             	mov    0x8(%ebp),%edx
801024b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024b5:	8b 45 10             	mov    0x10(%ebp),%eax
801024b8:	89 cb                	mov    %ecx,%ebx
801024ba:	89 de                	mov    %ebx,%esi
801024bc:	89 c1                	mov    %eax,%ecx
801024be:	fc                   	cld    
801024bf:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024c1:	89 c8                	mov    %ecx,%eax
801024c3:	89 f3                	mov    %esi,%ebx
801024c5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024c8:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret    

801024cf <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024cf:	55                   	push   %ebp
801024d0:	89 e5                	mov    %esp,%ebp
801024d2:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024d5:	90                   	nop
801024d6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024dd:	e8 68 ff ff ff       	call   8010244a <inb>
801024e2:	0f b6 c0             	movzbl %al,%eax
801024e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024eb:	25 c0 00 00 00       	and    $0xc0,%eax
801024f0:	83 f8 40             	cmp    $0x40,%eax
801024f3:	75 e1                	jne    801024d6 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024f9:	74 11                	je     8010250c <idewait+0x3d>
801024fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fe:	83 e0 21             	and    $0x21,%eax
80102501:	85 c0                	test   %eax,%eax
80102503:	74 07                	je     8010250c <idewait+0x3d>
    return -1;
80102505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010250a:	eb 05                	jmp    80102511 <idewait+0x42>
  return 0;
8010250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102511:	c9                   	leave  
80102512:	c3                   	ret    

80102513 <ideinit>:

void
ideinit(void)
{
80102513:	55                   	push   %ebp
80102514:	89 e5                	mov    %esp,%ebp
80102516:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102519:	c7 44 24 04 64 84 10 	movl   $0x80108464,0x4(%esp)
80102520:	80 
80102521:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102528:	e8 69 25 00 00       	call   80104a96 <initlock>
  picenable(IRQ_IDE);
8010252d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102534:	e8 48 15 00 00       	call   80103a81 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102539:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010253e:	83 e8 01             	sub    $0x1,%eax
80102541:	89 44 24 04          	mov    %eax,0x4(%esp)
80102545:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010254c:	e8 0c 04 00 00       	call   8010295d <ioapicenable>
  idewait(0);
80102551:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102558:	e8 72 ff ff ff       	call   801024cf <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010255d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102564:	00 
80102565:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010256c:	e8 1b ff ff ff       	call   8010248c <outb>
  for(i=0; i<1000; i++){
80102571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102578:	eb 20                	jmp    8010259a <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010257a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102581:	e8 c4 fe ff ff       	call   8010244a <inb>
80102586:	84 c0                	test   %al,%al
80102588:	74 0c                	je     80102596 <ideinit+0x83>
      havedisk1 = 1;
8010258a:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102591:	00 00 00 
      break;
80102594:	eb 0d                	jmp    801025a3 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102596:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010259a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025a1:	7e d7                	jle    8010257a <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025a3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025aa:	00 
801025ab:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025b2:	e8 d5 fe ff ff       	call   8010248c <outb>
}
801025b7:	c9                   	leave  
801025b8:	c3                   	ret    

801025b9 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025b9:	55                   	push   %ebp
801025ba:	89 e5                	mov    %esp,%ebp
801025bc:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025c3:	75 0c                	jne    801025d1 <idestart+0x18>
    panic("idestart");
801025c5:	c7 04 24 68 84 10 80 	movl   $0x80108468,(%esp)
801025cc:	e8 69 df ff ff       	call   8010053a <panic>

  idewait(0);
801025d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025d8:	e8 f2 fe ff ff       	call   801024cf <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025e4:	00 
801025e5:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025ec:	e8 9b fe ff ff       	call   8010248c <outb>
  outb(0x1f2, 1);  // number of sectors
801025f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025f8:	00 
801025f9:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102600:	e8 87 fe ff ff       	call   8010248c <outb>
  outb(0x1f3, b->sector & 0xff);
80102605:	8b 45 08             	mov    0x8(%ebp),%eax
80102608:	8b 40 08             	mov    0x8(%eax),%eax
8010260b:	0f b6 c0             	movzbl %al,%eax
8010260e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102612:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102619:	e8 6e fe ff ff       	call   8010248c <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010261e:	8b 45 08             	mov    0x8(%ebp),%eax
80102621:	8b 40 08             	mov    0x8(%eax),%eax
80102624:	c1 e8 08             	shr    $0x8,%eax
80102627:	0f b6 c0             	movzbl %al,%eax
8010262a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010262e:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102635:	e8 52 fe ff ff       	call   8010248c <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
8010263d:	8b 40 08             	mov    0x8(%eax),%eax
80102640:	c1 e8 10             	shr    $0x10,%eax
80102643:	0f b6 c0             	movzbl %al,%eax
80102646:	89 44 24 04          	mov    %eax,0x4(%esp)
8010264a:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102651:	e8 36 fe ff ff       	call   8010248c <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102656:	8b 45 08             	mov    0x8(%ebp),%eax
80102659:	8b 40 04             	mov    0x4(%eax),%eax
8010265c:	83 e0 01             	and    $0x1,%eax
8010265f:	c1 e0 04             	shl    $0x4,%eax
80102662:	89 c2                	mov    %eax,%edx
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
80102667:	8b 40 08             	mov    0x8(%eax),%eax
8010266a:	c1 e8 18             	shr    $0x18,%eax
8010266d:	83 e0 0f             	and    $0xf,%eax
80102670:	09 d0                	or     %edx,%eax
80102672:	83 c8 e0             	or     $0xffffffe0,%eax
80102675:	0f b6 c0             	movzbl %al,%eax
80102678:	89 44 24 04          	mov    %eax,0x4(%esp)
8010267c:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102683:	e8 04 fe ff ff       	call   8010248c <outb>
  if(b->flags & B_DIRTY){
80102688:	8b 45 08             	mov    0x8(%ebp),%eax
8010268b:	8b 00                	mov    (%eax),%eax
8010268d:	83 e0 04             	and    $0x4,%eax
80102690:	85 c0                	test   %eax,%eax
80102692:	74 34                	je     801026c8 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102694:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010269b:	00 
8010269c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026a3:	e8 e4 fd ff ff       	call   8010248c <outb>
    outsl(0x1f0, b->data, 512/4);
801026a8:	8b 45 08             	mov    0x8(%ebp),%eax
801026ab:	83 c0 18             	add    $0x18,%eax
801026ae:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026b5:	00 
801026b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ba:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026c1:	e8 e4 fd ff ff       	call   801024aa <outsl>
801026c6:	eb 14                	jmp    801026dc <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026c8:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026cf:	00 
801026d0:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026d7:	e8 b0 fd ff ff       	call   8010248c <outb>
  }
}
801026dc:	c9                   	leave  
801026dd:	c3                   	ret    

801026de <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026de:	55                   	push   %ebp
801026df:	89 e5                	mov    %esp,%ebp
801026e1:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026e4:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026eb:	e8 c7 23 00 00       	call   80104ab7 <acquire>
  if((b = idequeue) == 0){
801026f0:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801026f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026fc:	75 11                	jne    8010270f <ideintr+0x31>
    release(&idelock);
801026fe:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102705:	e8 0f 24 00 00       	call   80104b19 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010270a:	e9 90 00 00 00       	jmp    8010279f <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102712:	8b 40 14             	mov    0x14(%eax),%eax
80102715:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010271d:	8b 00                	mov    (%eax),%eax
8010271f:	83 e0 04             	and    $0x4,%eax
80102722:	85 c0                	test   %eax,%eax
80102724:	75 2e                	jne    80102754 <ideintr+0x76>
80102726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010272d:	e8 9d fd ff ff       	call   801024cf <idewait>
80102732:	85 c0                	test   %eax,%eax
80102734:	78 1e                	js     80102754 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102739:	83 c0 18             	add    $0x18,%eax
8010273c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102743:	00 
80102744:	89 44 24 04          	mov    %eax,0x4(%esp)
80102748:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010274f:	e8 13 fd ff ff       	call   80102467 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102757:	8b 00                	mov    (%eax),%eax
80102759:	83 c8 02             	or     $0x2,%eax
8010275c:	89 c2                	mov    %eax,%edx
8010275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102761:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102766:	8b 00                	mov    (%eax),%eax
80102768:	83 e0 fb             	and    $0xfffffffb,%eax
8010276b:	89 c2                	mov    %eax,%edx
8010276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102770:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102775:	89 04 24             	mov    %eax,(%esp)
80102778:	e8 49 21 00 00       	call   801048c6 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010277d:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102782:	85 c0                	test   %eax,%eax
80102784:	74 0d                	je     80102793 <ideintr+0xb5>
    idestart(idequeue);
80102786:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010278b:	89 04 24             	mov    %eax,(%esp)
8010278e:	e8 26 fe ff ff       	call   801025b9 <idestart>

  release(&idelock);
80102793:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010279a:	e8 7a 23 00 00       	call   80104b19 <release>
}
8010279f:	c9                   	leave  
801027a0:	c3                   	ret    

801027a1 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027a1:	55                   	push   %ebp
801027a2:	89 e5                	mov    %esp,%ebp
801027a4:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027a7:	8b 45 08             	mov    0x8(%ebp),%eax
801027aa:	8b 00                	mov    (%eax),%eax
801027ac:	83 e0 01             	and    $0x1,%eax
801027af:	85 c0                	test   %eax,%eax
801027b1:	75 0c                	jne    801027bf <iderw+0x1e>
    panic("iderw: buf not busy");
801027b3:	c7 04 24 71 84 10 80 	movl   $0x80108471,(%esp)
801027ba:	e8 7b dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027bf:	8b 45 08             	mov    0x8(%ebp),%eax
801027c2:	8b 00                	mov    (%eax),%eax
801027c4:	83 e0 06             	and    $0x6,%eax
801027c7:	83 f8 02             	cmp    $0x2,%eax
801027ca:	75 0c                	jne    801027d8 <iderw+0x37>
    panic("iderw: nothing to do");
801027cc:	c7 04 24 85 84 10 80 	movl   $0x80108485,(%esp)
801027d3:	e8 62 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027d8:	8b 45 08             	mov    0x8(%ebp),%eax
801027db:	8b 40 04             	mov    0x4(%eax),%eax
801027de:	85 c0                	test   %eax,%eax
801027e0:	74 15                	je     801027f7 <iderw+0x56>
801027e2:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027e7:	85 c0                	test   %eax,%eax
801027e9:	75 0c                	jne    801027f7 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027eb:	c7 04 24 9a 84 10 80 	movl   $0x8010849a,(%esp)
801027f2:	e8 43 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027f7:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027fe:	e8 b4 22 00 00       	call   80104ab7 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102803:	8b 45 08             	mov    0x8(%ebp),%eax
80102806:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010280d:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102814:	eb 0b                	jmp    80102821 <iderw+0x80>
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102819:	8b 00                	mov    (%eax),%eax
8010281b:	83 c0 14             	add    $0x14,%eax
8010281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102824:	8b 00                	mov    (%eax),%eax
80102826:	85 c0                	test   %eax,%eax
80102828:	75 ec                	jne    80102816 <iderw+0x75>
    ;
  *pp = b;
8010282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282d:	8b 55 08             	mov    0x8(%ebp),%edx
80102830:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102832:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102837:	3b 45 08             	cmp    0x8(%ebp),%eax
8010283a:	75 0d                	jne    80102849 <iderw+0xa8>
    idestart(b);
8010283c:	8b 45 08             	mov    0x8(%ebp),%eax
8010283f:	89 04 24             	mov    %eax,(%esp)
80102842:	e8 72 fd ff ff       	call   801025b9 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102847:	eb 15                	jmp    8010285e <iderw+0xbd>
80102849:	eb 13                	jmp    8010285e <iderw+0xbd>
    sleep(b, &idelock);
8010284b:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102852:	80 
80102853:	8b 45 08             	mov    0x8(%ebp),%eax
80102856:	89 04 24             	mov    %eax,(%esp)
80102859:	e8 8f 1f 00 00       	call   801047ed <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010285e:	8b 45 08             	mov    0x8(%ebp),%eax
80102861:	8b 00                	mov    (%eax),%eax
80102863:	83 e0 06             	and    $0x6,%eax
80102866:	83 f8 02             	cmp    $0x2,%eax
80102869:	75 e0                	jne    8010284b <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010286b:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102872:	e8 a2 22 00 00       	call   80104b19 <release>
}
80102877:	c9                   	leave  
80102878:	c3                   	ret    

80102879 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102879:	55                   	push   %ebp
8010287a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010287c:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102881:	8b 55 08             	mov    0x8(%ebp),%edx
80102884:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102886:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010288b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010288e:	5d                   	pop    %ebp
8010288f:	c3                   	ret    

80102890 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102893:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102898:	8b 55 08             	mov    0x8(%ebp),%edx
8010289b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010289d:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801028a5:	89 50 10             	mov    %edx,0x10(%eax)
}
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    

801028aa <ioapicinit>:

void
ioapicinit(void)
{
801028aa:	55                   	push   %ebp
801028ab:	89 e5                	mov    %esp,%ebp
801028ad:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028b0:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	75 05                	jne    801028be <ioapicinit+0x14>
    return;
801028b9:	e9 9d 00 00 00       	jmp    8010295b <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028be:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
801028c5:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028cf:	e8 a5 ff ff ff       	call   80102879 <ioapicread>
801028d4:	c1 e8 10             	shr    $0x10,%eax
801028d7:	25 ff 00 00 00       	and    $0xff,%eax
801028dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028e6:	e8 8e ff ff ff       	call   80102879 <ioapicread>
801028eb:	c1 e8 18             	shr    $0x18,%eax
801028ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028f1:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
801028f8:	0f b6 c0             	movzbl %al,%eax
801028fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028fe:	74 0c                	je     8010290c <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102900:	c7 04 24 b8 84 10 80 	movl   $0x801084b8,(%esp)
80102907:	e8 94 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010290c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102913:	eb 3e                	jmp    80102953 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102918:	83 c0 20             	add    $0x20,%eax
8010291b:	0d 00 00 01 00       	or     $0x10000,%eax
80102920:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102923:	83 c2 08             	add    $0x8,%edx
80102926:	01 d2                	add    %edx,%edx
80102928:	89 44 24 04          	mov    %eax,0x4(%esp)
8010292c:	89 14 24             	mov    %edx,(%esp)
8010292f:	e8 5c ff ff ff       	call   80102890 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102937:	83 c0 08             	add    $0x8,%eax
8010293a:	01 c0                	add    %eax,%eax
8010293c:	83 c0 01             	add    $0x1,%eax
8010293f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102946:	00 
80102947:	89 04 24             	mov    %eax,(%esp)
8010294a:	e8 41 ff ff ff       	call   80102890 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010294f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102956:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102959:	7e ba                	jle    80102915 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010295b:	c9                   	leave  
8010295c:	c3                   	ret    

8010295d <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010295d:	55                   	push   %ebp
8010295e:	89 e5                	mov    %esp,%ebp
80102960:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102963:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102968:	85 c0                	test   %eax,%eax
8010296a:	75 02                	jne    8010296e <ioapicenable+0x11>
    return;
8010296c:	eb 37                	jmp    801029a5 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010296e:	8b 45 08             	mov    0x8(%ebp),%eax
80102971:	83 c0 20             	add    $0x20,%eax
80102974:	8b 55 08             	mov    0x8(%ebp),%edx
80102977:	83 c2 08             	add    $0x8,%edx
8010297a:	01 d2                	add    %edx,%edx
8010297c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102980:	89 14 24             	mov    %edx,(%esp)
80102983:	e8 08 ff ff ff       	call   80102890 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102988:	8b 45 0c             	mov    0xc(%ebp),%eax
8010298b:	c1 e0 18             	shl    $0x18,%eax
8010298e:	8b 55 08             	mov    0x8(%ebp),%edx
80102991:	83 c2 08             	add    $0x8,%edx
80102994:	01 d2                	add    %edx,%edx
80102996:	83 c2 01             	add    $0x1,%edx
80102999:	89 44 24 04          	mov    %eax,0x4(%esp)
8010299d:	89 14 24             	mov    %edx,(%esp)
801029a0:	e8 eb fe ff ff       	call   80102890 <ioapicwrite>
}
801029a5:	c9                   	leave  
801029a6:	c3                   	ret    

801029a7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029a7:	55                   	push   %ebp
801029a8:	89 e5                	mov    %esp,%ebp
801029aa:	8b 45 08             	mov    0x8(%ebp),%eax
801029ad:	05 00 00 00 80       	add    $0x80000000,%eax
801029b2:	5d                   	pop    %ebp
801029b3:	c3                   	ret    

801029b4 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
801029b7:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029ba:	c7 44 24 04 ea 84 10 	movl   $0x801084ea,0x4(%esp)
801029c1:	80 
801029c2:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029c9:	e8 c8 20 00 00       	call   80104a96 <initlock>
  kmem.use_lock = 0;
801029ce:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
801029d5:	00 00 00 
  freerange(vstart, vend);
801029d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801029db:	89 44 24 04          	mov    %eax,0x4(%esp)
801029df:	8b 45 08             	mov    0x8(%ebp),%eax
801029e2:	89 04 24             	mov    %eax,(%esp)
801029e5:	e8 26 00 00 00       	call   80102a10 <freerange>
}
801029ea:	c9                   	leave  
801029eb:	c3                   	ret    

801029ec <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029ec:	55                   	push   %ebp
801029ed:	89 e5                	mov    %esp,%ebp
801029ef:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801029f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f9:	8b 45 08             	mov    0x8(%ebp),%eax
801029fc:	89 04 24             	mov    %eax,(%esp)
801029ff:	e8 0c 00 00 00       	call   80102a10 <freerange>
  kmem.use_lock = 1;
80102a04:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102a0b:	00 00 00 
}
80102a0e:	c9                   	leave  
80102a0f:	c3                   	ret    

80102a10 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a16:	8b 45 08             	mov    0x8(%ebp),%eax
80102a19:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a26:	eb 12                	jmp    80102a3a <freerange+0x2a>
    kfree(p);
80102a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2b:	89 04 24             	mov    %eax,(%esp)
80102a2e:	e8 16 00 00 00       	call   80102a49 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a33:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3d:	05 00 10 00 00       	add    $0x1000,%eax
80102a42:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a45:	76 e1                	jbe    80102a28 <freerange+0x18>
    kfree(p);
}
80102a47:	c9                   	leave  
80102a48:	c3                   	ret    

80102a49 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a49:	55                   	push   %ebp
80102a4a:	89 e5                	mov    %esp,%ebp
80102a4c:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a52:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a57:	85 c0                	test   %eax,%eax
80102a59:	75 1b                	jne    80102a76 <kfree+0x2d>
80102a5b:	81 7d 08 fc 26 11 80 	cmpl   $0x801126fc,0x8(%ebp)
80102a62:	72 12                	jb     80102a76 <kfree+0x2d>
80102a64:	8b 45 08             	mov    0x8(%ebp),%eax
80102a67:	89 04 24             	mov    %eax,(%esp)
80102a6a:	e8 38 ff ff ff       	call   801029a7 <v2p>
80102a6f:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a74:	76 0c                	jbe    80102a82 <kfree+0x39>
    panic("kfree");
80102a76:	c7 04 24 ef 84 10 80 	movl   $0x801084ef,(%esp)
80102a7d:	e8 b8 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a82:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a89:	00 
80102a8a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a91:	00 
80102a92:	8b 45 08             	mov    0x8(%ebp),%eax
80102a95:	89 04 24             	mov    %eax,(%esp)
80102a98:	e8 6e 22 00 00       	call   80104d0b <memset>

  if(kmem.use_lock)
80102a9d:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102aa2:	85 c0                	test   %eax,%eax
80102aa4:	74 0c                	je     80102ab2 <kfree+0x69>
    acquire(&kmem.lock);
80102aa6:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102aad:	e8 05 20 00 00       	call   80104ab7 <acquire>
  r = (struct run*)v;
80102ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ab8:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac1:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac6:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102acb:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102ad0:	85 c0                	test   %eax,%eax
80102ad2:	74 0c                	je     80102ae0 <kfree+0x97>
    release(&kmem.lock);
80102ad4:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102adb:	e8 39 20 00 00       	call   80104b19 <release>
}
80102ae0:	c9                   	leave  
80102ae1:	c3                   	ret    

80102ae2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ae2:	55                   	push   %ebp
80102ae3:	89 e5                	mov    %esp,%ebp
80102ae5:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102ae8:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102aed:	85 c0                	test   %eax,%eax
80102aef:	74 0c                	je     80102afd <kalloc+0x1b>
    acquire(&kmem.lock);
80102af1:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102af8:	e8 ba 1f 00 00       	call   80104ab7 <acquire>
  r = kmem.freelist;
80102afd:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b09:	74 0a                	je     80102b15 <kalloc+0x33>
    kmem.freelist = r->next;
80102b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b0e:	8b 00                	mov    (%eax),%eax
80102b10:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b15:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b1a:	85 c0                	test   %eax,%eax
80102b1c:	74 0c                	je     80102b2a <kalloc+0x48>
    release(&kmem.lock);
80102b1e:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b25:	e8 ef 1f 00 00       	call   80104b19 <release>
  return (char*)r;
80102b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b2d:	c9                   	leave  
80102b2e:	c3                   	ret    

80102b2f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b2f:	55                   	push   %ebp
80102b30:	89 e5                	mov    %esp,%ebp
80102b32:	83 ec 14             	sub    $0x14,%esp
80102b35:	8b 45 08             	mov    0x8(%ebp),%eax
80102b38:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	ec                   	in     (%dx),%al
80102b43:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b46:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b4a:	c9                   	leave  
80102b4b:	c3                   	ret    

80102b4c <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b4c:	55                   	push   %ebp
80102b4d:	89 e5                	mov    %esp,%ebp
80102b4f:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b52:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b59:	e8 d1 ff ff ff       	call   80102b2f <inb>
80102b5e:	0f b6 c0             	movzbl %al,%eax
80102b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b67:	83 e0 01             	and    $0x1,%eax
80102b6a:	85 c0                	test   %eax,%eax
80102b6c:	75 0a                	jne    80102b78 <kbdgetc+0x2c>
    return -1;
80102b6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b73:	e9 25 01 00 00       	jmp    80102c9d <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b78:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b7f:	e8 ab ff ff ff       	call   80102b2f <inb>
80102b84:	0f b6 c0             	movzbl %al,%eax
80102b87:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b8a:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b91:	75 17                	jne    80102baa <kbdgetc+0x5e>
    shift |= E0ESC;
80102b93:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102b98:	83 c8 40             	or     $0x40,%eax
80102b9b:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102ba0:	b8 00 00 00 00       	mov    $0x0,%eax
80102ba5:	e9 f3 00 00 00       	jmp    80102c9d <kbdgetc+0x151>
  } else if(data & 0x80){
80102baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bad:	25 80 00 00 00       	and    $0x80,%eax
80102bb2:	85 c0                	test   %eax,%eax
80102bb4:	74 45                	je     80102bfb <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bb6:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bbb:	83 e0 40             	and    $0x40,%eax
80102bbe:	85 c0                	test   %eax,%eax
80102bc0:	75 08                	jne    80102bca <kbdgetc+0x7e>
80102bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bc5:	83 e0 7f             	and    $0x7f,%eax
80102bc8:	eb 03                	jmp    80102bcd <kbdgetc+0x81>
80102bca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd3:	05 20 90 10 80       	add    $0x80109020,%eax
80102bd8:	0f b6 00             	movzbl (%eax),%eax
80102bdb:	83 c8 40             	or     $0x40,%eax
80102bde:	0f b6 c0             	movzbl %al,%eax
80102be1:	f7 d0                	not    %eax
80102be3:	89 c2                	mov    %eax,%edx
80102be5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bea:	21 d0                	and    %edx,%eax
80102bec:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bf1:	b8 00 00 00 00       	mov    $0x0,%eax
80102bf6:	e9 a2 00 00 00       	jmp    80102c9d <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102bfb:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c00:	83 e0 40             	and    $0x40,%eax
80102c03:	85 c0                	test   %eax,%eax
80102c05:	74 14                	je     80102c1b <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c07:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c0e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c13:	83 e0 bf             	and    $0xffffffbf,%eax
80102c16:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c1e:	05 20 90 10 80       	add    $0x80109020,%eax
80102c23:	0f b6 00             	movzbl (%eax),%eax
80102c26:	0f b6 d0             	movzbl %al,%edx
80102c29:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c2e:	09 d0                	or     %edx,%eax
80102c30:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c38:	05 20 91 10 80       	add    $0x80109120,%eax
80102c3d:	0f b6 00             	movzbl (%eax),%eax
80102c40:	0f b6 d0             	movzbl %al,%edx
80102c43:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c48:	31 d0                	xor    %edx,%eax
80102c4a:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c4f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c54:	83 e0 03             	and    $0x3,%eax
80102c57:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c61:	01 d0                	add    %edx,%eax
80102c63:	0f b6 00             	movzbl (%eax),%eax
80102c66:	0f b6 c0             	movzbl %al,%eax
80102c69:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c6c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c71:	83 e0 08             	and    $0x8,%eax
80102c74:	85 c0                	test   %eax,%eax
80102c76:	74 22                	je     80102c9a <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c78:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c7c:	76 0c                	jbe    80102c8a <kbdgetc+0x13e>
80102c7e:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c82:	77 06                	ja     80102c8a <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c84:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c88:	eb 10                	jmp    80102c9a <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c8a:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c8e:	76 0a                	jbe    80102c9a <kbdgetc+0x14e>
80102c90:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c94:	77 04                	ja     80102c9a <kbdgetc+0x14e>
      c += 'a' - 'A';
80102c96:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102c9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102c9d:	c9                   	leave  
80102c9e:	c3                   	ret    

80102c9f <kbdintr>:

void
kbdintr(void)
{
80102c9f:	55                   	push   %ebp
80102ca0:	89 e5                	mov    %esp,%ebp
80102ca2:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102ca5:	c7 04 24 4c 2b 10 80 	movl   $0x80102b4c,(%esp)
80102cac:	e8 fc da ff ff       	call   801007ad <consoleintr>
}
80102cb1:	c9                   	leave  
80102cb2:	c3                   	ret    

80102cb3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cb3:	55                   	push   %ebp
80102cb4:	89 e5                	mov    %esp,%ebp
80102cb6:	83 ec 08             	sub    $0x8,%esp
80102cb9:	8b 55 08             	mov    0x8(%ebp),%edx
80102cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cbf:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cc3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cca:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cce:	ee                   	out    %al,(%dx)
}
80102ccf:	c9                   	leave  
80102cd0:	c3                   	ret    

80102cd1 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cd1:	55                   	push   %ebp
80102cd2:	89 e5                	mov    %esp,%ebp
80102cd4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cd7:	9c                   	pushf  
80102cd8:	58                   	pop    %eax
80102cd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102cdf:	c9                   	leave  
80102ce0:	c3                   	ret    

80102ce1 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102ce1:	55                   	push   %ebp
80102ce2:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102ce4:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ce9:	8b 55 08             	mov    0x8(%ebp),%edx
80102cec:	c1 e2 02             	shl    $0x2,%edx
80102cef:	01 c2                	add    %eax,%edx
80102cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cf4:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102cf6:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102cfb:	83 c0 20             	add    $0x20,%eax
80102cfe:	8b 00                	mov    (%eax),%eax
}
80102d00:	5d                   	pop    %ebp
80102d01:	c3                   	ret    

80102d02 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d02:	55                   	push   %ebp
80102d03:	89 e5                	mov    %esp,%ebp
80102d05:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d08:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d0d:	85 c0                	test   %eax,%eax
80102d0f:	75 05                	jne    80102d16 <lapicinit+0x14>
    return;
80102d11:	e9 43 01 00 00       	jmp    80102e59 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d16:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d1d:	00 
80102d1e:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d25:	e8 b7 ff ff ff       	call   80102ce1 <lapicw>
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
//-----------------------------------------------------------------------------

  lapicw(TDCR, X1);
80102d2a:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d31:	00 
80102d32:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d39:	e8 a3 ff ff ff       	call   80102ce1 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d3e:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d45:	00 
80102d46:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d4d:	e8 8f ff ff ff       	call   80102ce1 <lapicw>
  lapicw(TICR, 10000000); ///// CUENTA HACIA ABAJO, POR LO QUE PARA DUPLICAR LAS FRECUENCIA DE INTERRUPCION
80102d52:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d59:	00 
80102d5a:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d61:	e8 7b ff ff ff       	call   80102ce1 <lapicw>
                          ///// TENDREMOS QUE DIVIDIR EL NUMERO QUE SE ENCUENTRA ADENTRO DE
                          ///// "lapicw(TICR, 10000000);" POR 2.
//-----------------------------------------------------------------------------

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d66:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d6d:	00 
80102d6e:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d75:	e8 67 ff ff ff       	call   80102ce1 <lapicw>
  lapicw(LINT1, MASKED);
80102d7a:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d81:	00 
80102d82:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d89:	e8 53 ff ff ff       	call   80102ce1 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d8e:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d93:	83 c0 30             	add    $0x30,%eax
80102d96:	8b 00                	mov    (%eax),%eax
80102d98:	c1 e8 10             	shr    $0x10,%eax
80102d9b:	0f b6 c0             	movzbl %al,%eax
80102d9e:	83 f8 03             	cmp    $0x3,%eax
80102da1:	76 14                	jbe    80102db7 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102da3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102daa:	00 
80102dab:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102db2:	e8 2a ff ff ff       	call   80102ce1 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102db7:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102dbe:	00 
80102dbf:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102dc6:	e8 16 ff ff ff       	call   80102ce1 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dd2:	00 
80102dd3:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dda:	e8 02 ff ff ff       	call   80102ce1 <lapicw>
  lapicw(ESR, 0);
80102ddf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102de6:	00 
80102de7:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dee:	e8 ee fe ff ff       	call   80102ce1 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102df3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dfa:	00 
80102dfb:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e02:	e8 da fe ff ff       	call   80102ce1 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e0e:	00 
80102e0f:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e16:	e8 c6 fe ff ff       	call   80102ce1 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e1b:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e22:	00 
80102e23:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e2a:	e8 b2 fe ff ff       	call   80102ce1 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e2f:	90                   	nop
80102e30:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e35:	05 00 03 00 00       	add    $0x300,%eax
80102e3a:	8b 00                	mov    (%eax),%eax
80102e3c:	25 00 10 00 00       	and    $0x1000,%eax
80102e41:	85 c0                	test   %eax,%eax
80102e43:	75 eb                	jne    80102e30 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e4c:	00 
80102e4d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e54:	e8 88 fe ff ff       	call   80102ce1 <lapicw>
}
80102e59:	c9                   	leave  
80102e5a:	c3                   	ret    

80102e5b <cpunum>:

int
cpunum(void)
{
80102e5b:	55                   	push   %ebp
80102e5c:	89 e5                	mov    %esp,%ebp
80102e5e:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e61:	e8 6b fe ff ff       	call   80102cd1 <readeflags>
80102e66:	25 00 02 00 00       	and    $0x200,%eax
80102e6b:	85 c0                	test   %eax,%eax
80102e6d:	74 25                	je     80102e94 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e6f:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102e74:	8d 50 01             	lea    0x1(%eax),%edx
80102e77:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102e7d:	85 c0                	test   %eax,%eax
80102e7f:	75 13                	jne    80102e94 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e81:	8b 45 04             	mov    0x4(%ebp),%eax
80102e84:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e88:	c7 04 24 f8 84 10 80 	movl   $0x801084f8,(%esp)
80102e8f:	e8 0c d5 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e94:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e99:	85 c0                	test   %eax,%eax
80102e9b:	74 0f                	je     80102eac <cpunum+0x51>
    return lapic[ID]>>24;
80102e9d:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ea2:	83 c0 20             	add    $0x20,%eax
80102ea5:	8b 00                	mov    (%eax),%eax
80102ea7:	c1 e8 18             	shr    $0x18,%eax
80102eaa:	eb 05                	jmp    80102eb1 <cpunum+0x56>
  return 0;
80102eac:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102eb1:	c9                   	leave  
80102eb2:	c3                   	ret    

80102eb3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102eb3:	55                   	push   %ebp
80102eb4:	89 e5                	mov    %esp,%ebp
80102eb6:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eb9:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ebe:	85 c0                	test   %eax,%eax
80102ec0:	74 14                	je     80102ed6 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ec2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ec9:	00 
80102eca:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ed1:	e8 0b fe ff ff       	call   80102ce1 <lapicw>
}
80102ed6:	c9                   	leave  
80102ed7:	c3                   	ret    

80102ed8 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ed8:	55                   	push   %ebp
80102ed9:	89 e5                	mov    %esp,%ebp
}
80102edb:	5d                   	pop    %ebp
80102edc:	c3                   	ret    

80102edd <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102edd:	55                   	push   %ebp
80102ede:	89 e5                	mov    %esp,%ebp
80102ee0:	83 ec 1c             	sub    $0x1c,%esp
80102ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ee6:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102ee9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ef0:	00 
80102ef1:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102ef8:	e8 b6 fd ff ff       	call   80102cb3 <outb>
  outb(IO_RTC+1, 0x0A);
80102efd:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f04:	00 
80102f05:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f0c:	e8 a2 fd ff ff       	call   80102cb3 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f11:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f1b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f23:	8d 50 02             	lea    0x2(%eax),%edx
80102f26:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f29:	c1 e8 04             	shr    $0x4,%eax
80102f2c:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f2f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f33:	c1 e0 18             	shl    $0x18,%eax
80102f36:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f3a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f41:	e8 9b fd ff ff       	call   80102ce1 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f46:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f4d:	00 
80102f4e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f55:	e8 87 fd ff ff       	call   80102ce1 <lapicw>
  microdelay(200);
80102f5a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f61:	e8 72 ff ff ff       	call   80102ed8 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f66:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f6d:	00 
80102f6e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f75:	e8 67 fd ff ff       	call   80102ce1 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f7a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f81:	e8 52 ff ff ff       	call   80102ed8 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f8d:	eb 40                	jmp    80102fcf <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102f8f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f93:	c1 e0 18             	shl    $0x18,%eax
80102f96:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f9a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fa1:	e8 3b fd ff ff       	call   80102ce1 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fa9:	c1 e8 0c             	shr    $0xc,%eax
80102fac:	80 cc 06             	or     $0x6,%ah
80102faf:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fb3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fba:	e8 22 fd ff ff       	call   80102ce1 <lapicw>
    microdelay(200);
80102fbf:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fc6:	e8 0d ff ff ff       	call   80102ed8 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fcb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102fcf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fd3:	7e ba                	jle    80102f8f <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fd5:	c9                   	leave  
80102fd6:	c3                   	ret    

80102fd7 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fd7:	55                   	push   %ebp
80102fd8:	89 e5                	mov    %esp,%ebp
80102fda:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fdd:	c7 44 24 04 24 85 10 	movl   $0x80108524,0x4(%esp)
80102fe4:	80 
80102fe5:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80102fec:	e8 a5 1a 00 00       	call   80104a96 <initlock>
  readsb(ROOTDEV, &sb);
80102ff1:	8d 45 e8             	lea    -0x18(%ebp),%eax
80102ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ff8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102fff:	e8 ed e2 ff ff       	call   801012f1 <readsb>
  log.start = sb.size - sb.nlog;
80103004:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010300a:	29 c2                	sub    %eax,%edx
8010300c:	89 d0                	mov    %edx,%eax
8010300e:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
80103013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103016:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
8010301b:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
80103022:	00 00 00 
  recover_from_log();
80103025:	e8 9a 01 00 00       	call   801031c4 <recover_from_log>
}
8010302a:	c9                   	leave  
8010302b:	c3                   	ret    

8010302c <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010302c:	55                   	push   %ebp
8010302d:	89 e5                	mov    %esp,%ebp
8010302f:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103039:	e9 8c 00 00 00       	jmp    801030ca <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010303e:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103047:	01 d0                	add    %edx,%eax
80103049:	83 c0 01             	add    $0x1,%eax
8010304c:	89 c2                	mov    %eax,%edx
8010304e:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103053:	89 54 24 04          	mov    %edx,0x4(%esp)
80103057:	89 04 24             	mov    %eax,(%esp)
8010305a:	e8 47 d1 ff ff       	call   801001a6 <bread>
8010305f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103065:	83 c0 10             	add    $0x10,%eax
80103068:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010306f:	89 c2                	mov    %eax,%edx
80103071:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103076:	89 54 24 04          	mov    %edx,0x4(%esp)
8010307a:	89 04 24             	mov    %eax,(%esp)
8010307d:	e8 24 d1 ff ff       	call   801001a6 <bread>
80103082:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103085:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103088:	8d 50 18             	lea    0x18(%eax),%edx
8010308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010308e:	83 c0 18             	add    $0x18,%eax
80103091:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103098:	00 
80103099:	89 54 24 04          	mov    %edx,0x4(%esp)
8010309d:	89 04 24             	mov    %eax,(%esp)
801030a0:	e8 35 1d 00 00       	call   80104dda <memmove>
    bwrite(dbuf);  // write dst to disk
801030a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030a8:	89 04 24             	mov    %eax,(%esp)
801030ab:	e8 2d d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030b3:	89 04 24             	mov    %eax,(%esp)
801030b6:	e8 5c d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030be:	89 04 24             	mov    %eax,(%esp)
801030c1:	e8 51 d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030ca:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801030cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030d2:	0f 8f 66 ff ff ff    	jg     8010303e <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030d8:	c9                   	leave  
801030d9:	c3                   	ret    

801030da <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030e0:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801030e5:	89 c2                	mov    %eax,%edx
801030e7:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030ec:	89 54 24 04          	mov    %edx,0x4(%esp)
801030f0:	89 04 24             	mov    %eax,(%esp)
801030f3:	e8 ae d0 ff ff       	call   801001a6 <bread>
801030f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801030fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030fe:	83 c0 18             	add    $0x18,%eax
80103101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103107:	8b 00                	mov    (%eax),%eax
80103109:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
8010310e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103115:	eb 1b                	jmp    80103132 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103117:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010311a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010311d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103121:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103124:	83 c2 10             	add    $0x10,%edx
80103127:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010312e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103132:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103137:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010313a:	7f db                	jg     80103117 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010313f:	89 04 24             	mov    %eax,(%esp)
80103142:	e8 d0 d0 ff ff       	call   80100217 <brelse>
}
80103147:	c9                   	leave  
80103148:	c3                   	ret    

80103149 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103149:	55                   	push   %ebp
8010314a:	89 e5                	mov    %esp,%ebp
8010314c:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010314f:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103154:	89 c2                	mov    %eax,%edx
80103156:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010315b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010315f:	89 04 24             	mov    %eax,(%esp)
80103162:	e8 3f d0 ff ff       	call   801001a6 <bread>
80103167:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010316d:	83 c0 18             	add    $0x18,%eax
80103170:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103173:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
80103179:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010317c:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010317e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103185:	eb 1b                	jmp    801031a2 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
80103187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010318a:	83 c0 10             	add    $0x10,%eax
8010318d:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
80103194:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103197:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010319a:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010319e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031a2:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031aa:	7f db                	jg     80103187 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031af:	89 04 24             	mov    %eax,(%esp)
801031b2:	e8 26 d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031ba:	89 04 24             	mov    %eax,(%esp)
801031bd:	e8 55 d0 ff ff       	call   80100217 <brelse>
}
801031c2:	c9                   	leave  
801031c3:	c3                   	ret    

801031c4 <recover_from_log>:

static void
recover_from_log(void)
{
801031c4:	55                   	push   %ebp
801031c5:	89 e5                	mov    %esp,%ebp
801031c7:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031ca:	e8 0b ff ff ff       	call   801030da <read_head>
  install_trans(); // if committed, copy from log to disk
801031cf:	e8 58 fe ff ff       	call   8010302c <install_trans>
  log.lh.n = 0;
801031d4:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801031db:	00 00 00 
  write_head(); // clear the log
801031de:	e8 66 ff ff ff       	call   80103149 <write_head>
}
801031e3:	c9                   	leave  
801031e4:	c3                   	ret    

801031e5 <begin_trans>:

void
begin_trans(void)
{
801031e5:	55                   	push   %ebp
801031e6:	89 e5                	mov    %esp,%ebp
801031e8:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031eb:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031f2:	e8 c0 18 00 00       	call   80104ab7 <acquire>
  while (log.busy) {
801031f7:	eb 14                	jmp    8010320d <begin_trans+0x28>
    sleep(&log, &log.lock);
801031f9:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80103200:	80 
80103201:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103208:	e8 e0 15 00 00       	call   801047ed <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
8010320d:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103212:	85 c0                	test   %eax,%eax
80103214:	75 e3                	jne    801031f9 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103216:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
8010321d:	00 00 00 
  release(&log.lock);
80103220:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103227:	e8 ed 18 00 00       	call   80104b19 <release>
}
8010322c:	c9                   	leave  
8010322d:	c3                   	ret    

8010322e <commit_trans>:

void
commit_trans(void)
{
8010322e:	55                   	push   %ebp
8010322f:	89 e5                	mov    %esp,%ebp
80103231:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103234:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103239:	85 c0                	test   %eax,%eax
8010323b:	7e 19                	jle    80103256 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010323d:	e8 07 ff ff ff       	call   80103149 <write_head>
    install_trans(); // Now install writes to home locations
80103242:	e8 e5 fd ff ff       	call   8010302c <install_trans>
    log.lh.n = 0; 
80103247:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
8010324e:	00 00 00 
    write_head();    // Erase the transaction from the log
80103251:	e8 f3 fe ff ff       	call   80103149 <write_head>
  }
  
  acquire(&log.lock);
80103256:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010325d:	e8 55 18 00 00       	call   80104ab7 <acquire>
  log.busy = 0;
80103262:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
80103269:	00 00 00 
  wakeup(&log);
8010326c:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103273:	e8 4e 16 00 00       	call   801048c6 <wakeup>
  release(&log.lock);
80103278:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010327f:	e8 95 18 00 00       	call   80104b19 <release>
}
80103284:	c9                   	leave  
80103285:	c3                   	ret    

80103286 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103286:	55                   	push   %ebp
80103287:	89 e5                	mov    %esp,%ebp
80103289:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010328c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103291:	83 f8 09             	cmp    $0x9,%eax
80103294:	7f 12                	jg     801032a8 <log_write+0x22>
80103296:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010329b:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
801032a1:	83 ea 01             	sub    $0x1,%edx
801032a4:	39 d0                	cmp    %edx,%eax
801032a6:	7c 0c                	jl     801032b4 <log_write+0x2e>
    panic("too big a transaction");
801032a8:	c7 04 24 28 85 10 80 	movl   $0x80108528,(%esp)
801032af:	e8 86 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032b4:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032b9:	85 c0                	test   %eax,%eax
801032bb:	75 0c                	jne    801032c9 <log_write+0x43>
    panic("write outside of trans");
801032bd:	c7 04 24 3e 85 10 80 	movl   $0x8010853e,(%esp)
801032c4:	e8 71 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032d0:	eb 1f                	jmp    801032f1 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d5:	83 c0 10             	add    $0x10,%eax
801032d8:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801032df:	89 c2                	mov    %eax,%edx
801032e1:	8b 45 08             	mov    0x8(%ebp),%eax
801032e4:	8b 40 08             	mov    0x8(%eax),%eax
801032e7:	39 c2                	cmp    %eax,%edx
801032e9:	75 02                	jne    801032ed <log_write+0x67>
      break;
801032eb:	eb 0e                	jmp    801032fb <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801032ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032f1:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032f9:	7f d7                	jg     801032d2 <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
801032fb:	8b 45 08             	mov    0x8(%ebp),%eax
801032fe:	8b 40 08             	mov    0x8(%eax),%eax
80103301:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103304:	83 c2 10             	add    $0x10,%edx
80103307:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
8010330e:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103317:	01 d0                	add    %edx,%eax
80103319:	83 c0 01             	add    $0x1,%eax
8010331c:	89 c2                	mov    %eax,%edx
8010331e:	8b 45 08             	mov    0x8(%ebp),%eax
80103321:	8b 40 04             	mov    0x4(%eax),%eax
80103324:	89 54 24 04          	mov    %edx,0x4(%esp)
80103328:	89 04 24             	mov    %eax,(%esp)
8010332b:	e8 76 ce ff ff       	call   801001a6 <bread>
80103330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103333:	8b 45 08             	mov    0x8(%ebp),%eax
80103336:	8d 50 18             	lea    0x18(%eax),%edx
80103339:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333c:	83 c0 18             	add    $0x18,%eax
8010333f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103346:	00 
80103347:	89 54 24 04          	mov    %edx,0x4(%esp)
8010334b:	89 04 24             	mov    %eax,(%esp)
8010334e:	e8 87 1a 00 00       	call   80104dda <memmove>
  bwrite(lbuf);
80103353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103356:	89 04 24             	mov    %eax,(%esp)
80103359:	e8 7f ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
8010335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103361:	89 04 24             	mov    %eax,(%esp)
80103364:	e8 ae ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103369:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010336e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103371:	75 0d                	jne    80103380 <log_write+0xfa>
    log.lh.n++;
80103373:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103378:	83 c0 01             	add    $0x1,%eax
8010337b:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
80103380:	8b 45 08             	mov    0x8(%ebp),%eax
80103383:	8b 00                	mov    (%eax),%eax
80103385:	83 c8 04             	or     $0x4,%eax
80103388:	89 c2                	mov    %eax,%edx
8010338a:	8b 45 08             	mov    0x8(%ebp),%eax
8010338d:	89 10                	mov    %edx,(%eax)
}
8010338f:	c9                   	leave  
80103390:	c3                   	ret    

80103391 <v2p>:
80103391:	55                   	push   %ebp
80103392:	89 e5                	mov    %esp,%ebp
80103394:	8b 45 08             	mov    0x8(%ebp),%eax
80103397:	05 00 00 00 80       	add    $0x80000000,%eax
8010339c:	5d                   	pop    %ebp
8010339d:	c3                   	ret    

8010339e <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010339e:	55                   	push   %ebp
8010339f:	89 e5                	mov    %esp,%ebp
801033a1:	8b 45 08             	mov    0x8(%ebp),%eax
801033a4:	05 00 00 00 80       	add    $0x80000000,%eax
801033a9:	5d                   	pop    %ebp
801033aa:	c3                   	ret    

801033ab <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033ab:	55                   	push   %ebp
801033ac:	89 e5                	mov    %esp,%ebp
801033ae:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033b1:	8b 55 08             	mov    0x8(%ebp),%edx
801033b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801033b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033ba:	f0 87 02             	lock xchg %eax,(%edx)
801033bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033c3:	c9                   	leave  
801033c4:	c3                   	ret    

801033c5 <main>:
// doing some setup required for memory allocator to work.


int
main(void)
{
801033c5:	55                   	push   %ebp
801033c6:	89 e5                	mov    %esp,%ebp
801033c8:	83 e4 f0             	and    $0xfffffff0,%esp
801033cb:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033ce:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033d5:	80 
801033d6:	c7 04 24 fc 26 11 80 	movl   $0x801126fc,(%esp)
801033dd:	e8 d2 f5 ff ff       	call   801029b4 <kinit1>
  kvmalloc();      // kernel page table
801033e2:	e8 e9 44 00 00       	call   801078d0 <kvmalloc>
  mpinit();        // collect info about this machine
801033e7:	e8 65 04 00 00       	call   80103851 <mpinit>
  lapicinit();
801033ec:	e8 11 f9 ff ff       	call   80102d02 <lapicinit>
  seginit();       // set up segments
801033f1:	e8 6d 3e 00 00       	call   80107263 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033fc:	0f b6 00             	movzbl (%eax),%eax
801033ff:	0f b6 c0             	movzbl %al,%eax
80103402:	89 44 24 04          	mov    %eax,0x4(%esp)
80103406:	c7 04 24 55 85 10 80 	movl   $0x80108555,(%esp)
8010340d:	e8 8e cf ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103412:	e8 98 06 00 00       	call   80103aaf <picinit>
  ioapicinit();    // another interrupt controller
80103417:	e8 8e f4 ff ff       	call   801028aa <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010341c:	e8 60 d6 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103421:	e8 8c 31 00 00       	call   801065b2 <uartinit>
  pinit();         // process table
80103426:	e8 8e 0b 00 00       	call   80103fb9 <pinit>
  tvinit();        // trap vectors
8010342b:	e8 34 2d 00 00       	call   80106164 <tvinit>
  binit();         // buffer cache
80103430:	e8 ff cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103435:	e8 d0 da ff ff       	call   80100f0a <fileinit>
  iinit();         // inode cache
8010343a:	e8 65 e1 ff ff       	call   801015a4 <iinit>
  ideinit();       // disk
8010343f:	e8 cf f0 ff ff       	call   80102513 <ideinit>
  if(!ismp)
80103444:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103449:	85 c0                	test   %eax,%eax
8010344b:	75 05                	jne    80103452 <main+0x8d>
    timerinit();   // uniprocessor timer
8010344d:	e8 5d 2c 00 00       	call   801060af <timerinit>
  startothers();   // start other processors
80103452:	e8 9e 00 00 00       	call   801034f5 <startothers>
  boottime = rtc_init(); // almaceno en bootime los segundos desde the epoch
80103457:	e8 7f 4e 00 00       	call   801082db <rtc_init>
8010345c:	a3 f0 f8 10 80       	mov    %eax,0x8010f8f0
	cprintf("RTC: boottime %d\n", boottime); // IMPRIME LA CANTIDAD DE SEGUNDOS DESDE THE EPOCH
80103461:	a1 f0 f8 10 80       	mov    0x8010f8f0,%eax
80103466:	89 44 24 04          	mov    %eax,0x4(%esp)
8010346a:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80103471:	e8 2a cf ff ff       	call   801003a0 <cprintf>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103476:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010347d:	8e 
8010347e:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103485:	e8 62 f5 ff ff       	call   801029ec <kinit2>
  userinit();      // first user process
8010348a:	e8 45 0c 00 00       	call   801040d4 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010348f:	e8 1a 00 00 00       	call   801034ae <mpmain>

80103494 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103494:	55                   	push   %ebp
80103495:	89 e5                	mov    %esp,%ebp
80103497:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010349a:	e8 48 44 00 00       	call   801078e7 <switchkvm>
  seginit();
8010349f:	e8 bf 3d 00 00       	call   80107263 <seginit>
  lapicinit();
801034a4:	e8 59 f8 ff ff       	call   80102d02 <lapicinit>
  mpmain();
801034a9:	e8 00 00 00 00       	call   801034ae <mpmain>

801034ae <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034ae:	55                   	push   %ebp
801034af:	89 e5                	mov    %esp,%ebp
801034b1:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034ba:	0f b6 00             	movzbl (%eax),%eax
801034bd:	0f b6 c0             	movzbl %al,%eax
801034c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801034c4:	c7 04 24 7e 85 10 80 	movl   $0x8010857e,(%esp)
801034cb:	e8 d0 ce ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801034d0:	e8 03 2e 00 00       	call   801062d8 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034db:	05 a8 00 00 00       	add    $0xa8,%eax
801034e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034e7:	00 
801034e8:	89 04 24             	mov    %eax,(%esp)
801034eb:	e8 bb fe ff ff       	call   801033ab <xchg>
  scheduler();     // start running processes
801034f0:	e8 50 11 00 00       	call   80104645 <scheduler>

801034f5 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034f5:	55                   	push   %ebp
801034f6:	89 e5                	mov    %esp,%ebp
801034f8:	53                   	push   %ebx
801034f9:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034fc:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103503:	e8 96 fe ff ff       	call   8010339e <p2v>
80103508:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010350b:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103510:	89 44 24 08          	mov    %eax,0x8(%esp)
80103514:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
8010351b:	80 
8010351c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010351f:	89 04 24             	mov    %eax,(%esp)
80103522:	e8 b3 18 00 00       	call   80104dda <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103527:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
8010352e:	e9 85 00 00 00       	jmp    801035b8 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103533:	e8 23 f9 ff ff       	call   80102e5b <cpunum>
80103538:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010353e:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103543:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103546:	75 02                	jne    8010354a <startothers+0x55>
      continue;
80103548:	eb 67                	jmp    801035b1 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010354a:	e8 93 f5 ff ff       	call   80102ae2 <kalloc>
8010354f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103555:	83 e8 04             	sub    $0x4,%eax
80103558:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010355b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103561:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103566:	83 e8 08             	sub    $0x8,%eax
80103569:	c7 00 94 34 10 80    	movl   $0x80103494,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010356f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103572:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103575:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
8010357c:	e8 10 fe ff ff       	call   80103391 <v2p>
80103581:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103583:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103586:	89 04 24             	mov    %eax,(%esp)
80103589:	e8 03 fe ff ff       	call   80103391 <v2p>
8010358e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103591:	0f b6 12             	movzbl (%edx),%edx
80103594:	0f b6 d2             	movzbl %dl,%edx
80103597:	89 44 24 04          	mov    %eax,0x4(%esp)
8010359b:	89 14 24             	mov    %edx,(%esp)
8010359e:	e8 3a f9 ff ff       	call   80102edd <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035a3:	90                   	nop
801035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035a7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035ad:	85 c0                	test   %eax,%eax
801035af:	74 f3                	je     801035a4 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035b1:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035b8:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801035bd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035c3:	05 20 f9 10 80       	add    $0x8010f920,%eax
801035c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035cb:	0f 87 62 ff ff ff    	ja     80103533 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035d1:	83 c4 24             	add    $0x24,%esp
801035d4:	5b                   	pop    %ebx
801035d5:	5d                   	pop    %ebp
801035d6:	c3                   	ret    

801035d7 <p2v>:
801035d7:	55                   	push   %ebp
801035d8:	89 e5                	mov    %esp,%ebp
801035da:	8b 45 08             	mov    0x8(%ebp),%eax
801035dd:	05 00 00 00 80       	add    $0x80000000,%eax
801035e2:	5d                   	pop    %ebp
801035e3:	c3                   	ret    

801035e4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035e4:	55                   	push   %ebp
801035e5:	89 e5                	mov    %esp,%ebp
801035e7:	83 ec 14             	sub    $0x14,%esp
801035ea:	8b 45 08             	mov    0x8(%ebp),%eax
801035ed:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035f1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035f5:	89 c2                	mov    %eax,%edx
801035f7:	ec                   	in     (%dx),%al
801035f8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801035fb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801035ff:	c9                   	leave  
80103600:	c3                   	ret    

80103601 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103601:	55                   	push   %ebp
80103602:	89 e5                	mov    %esp,%ebp
80103604:	83 ec 08             	sub    $0x8,%esp
80103607:	8b 55 08             	mov    0x8(%ebp),%edx
8010360a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010360d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103611:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103614:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103618:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010361c:	ee                   	out    %al,(%dx)
}
8010361d:	c9                   	leave  
8010361e:	c3                   	ret    

8010361f <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010361f:	55                   	push   %ebp
80103620:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103622:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103627:	89 c2                	mov    %eax,%edx
80103629:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
8010362e:	29 c2                	sub    %eax,%edx
80103630:	89 d0                	mov    %edx,%eax
80103632:	c1 f8 02             	sar    $0x2,%eax
80103635:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010363b:	5d                   	pop    %ebp
8010363c:	c3                   	ret    

8010363d <sum>:

static uchar
sum(uchar *addr, int len)
{
8010363d:	55                   	push   %ebp
8010363e:	89 e5                	mov    %esp,%ebp
80103640:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010364a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103651:	eb 15                	jmp    80103668 <sum+0x2b>
    sum += addr[i];
80103653:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103656:	8b 45 08             	mov    0x8(%ebp),%eax
80103659:	01 d0                	add    %edx,%eax
8010365b:	0f b6 00             	movzbl (%eax),%eax
8010365e:	0f b6 c0             	movzbl %al,%eax
80103661:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103664:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103668:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010366b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010366e:	7c e3                	jl     80103653 <sum+0x16>
    sum += addr[i];
  return sum;
80103670:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103673:	c9                   	leave  
80103674:	c3                   	ret    

80103675 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103675:	55                   	push   %ebp
80103676:	89 e5                	mov    %esp,%ebp
80103678:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010367b:	8b 45 08             	mov    0x8(%ebp),%eax
8010367e:	89 04 24             	mov    %eax,(%esp)
80103681:	e8 51 ff ff ff       	call   801035d7 <p2v>
80103686:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103689:	8b 55 0c             	mov    0xc(%ebp),%edx
8010368c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010368f:	01 d0                	add    %edx,%eax
80103691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103697:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010369a:	eb 3f                	jmp    801036db <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010369c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036a3:	00 
801036a4:	c7 44 24 04 90 85 10 	movl   $0x80108590,0x4(%esp)
801036ab:	80 
801036ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036af:	89 04 24             	mov    %eax,(%esp)
801036b2:	e8 cb 16 00 00       	call   80104d82 <memcmp>
801036b7:	85 c0                	test   %eax,%eax
801036b9:	75 1c                	jne    801036d7 <mpsearch1+0x62>
801036bb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036c2:	00 
801036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c6:	89 04 24             	mov    %eax,(%esp)
801036c9:	e8 6f ff ff ff       	call   8010363d <sum>
801036ce:	84 c0                	test   %al,%al
801036d0:	75 05                	jne    801036d7 <mpsearch1+0x62>
      return (struct mp*)p;
801036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d5:	eb 11                	jmp    801036e8 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036d7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036e1:	72 b9                	jb     8010369c <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036e8:	c9                   	leave  
801036e9:	c3                   	ret    

801036ea <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036ea:	55                   	push   %ebp
801036eb:	89 e5                	mov    %esp,%ebp
801036ed:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036f0:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036fa:	83 c0 0f             	add    $0xf,%eax
801036fd:	0f b6 00             	movzbl (%eax),%eax
80103700:	0f b6 c0             	movzbl %al,%eax
80103703:	c1 e0 08             	shl    $0x8,%eax
80103706:	89 c2                	mov    %eax,%edx
80103708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010370b:	83 c0 0e             	add    $0xe,%eax
8010370e:	0f b6 00             	movzbl (%eax),%eax
80103711:	0f b6 c0             	movzbl %al,%eax
80103714:	09 d0                	or     %edx,%eax
80103716:	c1 e0 04             	shl    $0x4,%eax
80103719:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010371c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103720:	74 21                	je     80103743 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103722:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103729:	00 
8010372a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010372d:	89 04 24             	mov    %eax,(%esp)
80103730:	e8 40 ff ff ff       	call   80103675 <mpsearch1>
80103735:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103738:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010373c:	74 50                	je     8010378e <mpsearch+0xa4>
      return mp;
8010373e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103741:	eb 5f                	jmp    801037a2 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103746:	83 c0 14             	add    $0x14,%eax
80103749:	0f b6 00             	movzbl (%eax),%eax
8010374c:	0f b6 c0             	movzbl %al,%eax
8010374f:	c1 e0 08             	shl    $0x8,%eax
80103752:	89 c2                	mov    %eax,%edx
80103754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103757:	83 c0 13             	add    $0x13,%eax
8010375a:	0f b6 00             	movzbl (%eax),%eax
8010375d:	0f b6 c0             	movzbl %al,%eax
80103760:	09 d0                	or     %edx,%eax
80103762:	c1 e0 0a             	shl    $0xa,%eax
80103765:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376b:	2d 00 04 00 00       	sub    $0x400,%eax
80103770:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103777:	00 
80103778:	89 04 24             	mov    %eax,(%esp)
8010377b:	e8 f5 fe ff ff       	call   80103675 <mpsearch1>
80103780:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103783:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103787:	74 05                	je     8010378e <mpsearch+0xa4>
      return mp;
80103789:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378c:	eb 14                	jmp    801037a2 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
8010378e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103795:	00 
80103796:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010379d:	e8 d3 fe ff ff       	call   80103675 <mpsearch1>
}
801037a2:	c9                   	leave  
801037a3:	c3                   	ret    

801037a4 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037a4:	55                   	push   %ebp
801037a5:	89 e5                	mov    %esp,%ebp
801037a7:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037aa:	e8 3b ff ff ff       	call   801036ea <mpsearch>
801037af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037b6:	74 0a                	je     801037c2 <mpconfig+0x1e>
801037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bb:	8b 40 04             	mov    0x4(%eax),%eax
801037be:	85 c0                	test   %eax,%eax
801037c0:	75 0a                	jne    801037cc <mpconfig+0x28>
    return 0;
801037c2:	b8 00 00 00 00       	mov    $0x0,%eax
801037c7:	e9 83 00 00 00       	jmp    8010384f <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037cf:	8b 40 04             	mov    0x4(%eax),%eax
801037d2:	89 04 24             	mov    %eax,(%esp)
801037d5:	e8 fd fd ff ff       	call   801035d7 <p2v>
801037da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037dd:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037e4:	00 
801037e5:	c7 44 24 04 95 85 10 	movl   $0x80108595,0x4(%esp)
801037ec:	80 
801037ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f0:	89 04 24             	mov    %eax,(%esp)
801037f3:	e8 8a 15 00 00       	call   80104d82 <memcmp>
801037f8:	85 c0                	test   %eax,%eax
801037fa:	74 07                	je     80103803 <mpconfig+0x5f>
    return 0;
801037fc:	b8 00 00 00 00       	mov    $0x0,%eax
80103801:	eb 4c                	jmp    8010384f <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103803:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103806:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010380a:	3c 01                	cmp    $0x1,%al
8010380c:	74 12                	je     80103820 <mpconfig+0x7c>
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103815:	3c 04                	cmp    $0x4,%al
80103817:	74 07                	je     80103820 <mpconfig+0x7c>
    return 0;
80103819:	b8 00 00 00 00       	mov    $0x0,%eax
8010381e:	eb 2f                	jmp    8010384f <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103823:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103827:	0f b7 c0             	movzwl %ax,%eax
8010382a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010382e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103831:	89 04 24             	mov    %eax,(%esp)
80103834:	e8 04 fe ff ff       	call   8010363d <sum>
80103839:	84 c0                	test   %al,%al
8010383b:	74 07                	je     80103844 <mpconfig+0xa0>
    return 0;
8010383d:	b8 00 00 00 00       	mov    $0x0,%eax
80103842:	eb 0b                	jmp    8010384f <mpconfig+0xab>
  *pmp = mp;
80103844:	8b 45 08             	mov    0x8(%ebp),%eax
80103847:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010384a:	89 10                	mov    %edx,(%eax)
  return conf;
8010384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010384f:	c9                   	leave  
80103850:	c3                   	ret    

80103851 <mpinit>:

void
mpinit(void)
{
80103851:	55                   	push   %ebp
80103852:	89 e5                	mov    %esp,%ebp
80103854:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103857:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
8010385e:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103861:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103864:	89 04 24             	mov    %eax,(%esp)
80103867:	e8 38 ff ff ff       	call   801037a4 <mpconfig>
8010386c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010386f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103873:	75 05                	jne    8010387a <mpinit+0x29>
    return;
80103875:	e9 9c 01 00 00       	jmp    80103a16 <mpinit+0x1c5>
  ismp = 1;
8010387a:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
80103881:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103887:	8b 40 24             	mov    0x24(%eax),%eax
8010388a:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103892:	83 c0 2c             	add    $0x2c,%eax
80103895:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103898:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010389f:	0f b7 d0             	movzwl %ax,%edx
801038a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a5:	01 d0                	add    %edx,%eax
801038a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038aa:	e9 f4 00 00 00       	jmp    801039a3 <mpinit+0x152>
    switch(*p){
801038af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b2:	0f b6 00             	movzbl (%eax),%eax
801038b5:	0f b6 c0             	movzbl %al,%eax
801038b8:	83 f8 04             	cmp    $0x4,%eax
801038bb:	0f 87 bf 00 00 00    	ja     80103980 <mpinit+0x12f>
801038c1:	8b 04 85 d8 85 10 80 	mov    -0x7fef7a28(,%eax,4),%eax
801038c8:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038d3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038d7:	0f b6 d0             	movzbl %al,%edx
801038da:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038df:	39 c2                	cmp    %eax,%edx
801038e1:	74 2d                	je     80103910 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038e6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038ea:	0f b6 d0             	movzbl %al,%edx
801038ed:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038f2:	89 54 24 08          	mov    %edx,0x8(%esp)
801038f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801038fa:	c7 04 24 9a 85 10 80 	movl   $0x8010859a,(%esp)
80103901:	e8 9a ca ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103906:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
8010390d:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103910:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103913:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103917:	0f b6 c0             	movzbl %al,%eax
8010391a:	83 e0 02             	and    $0x2,%eax
8010391d:	85 c0                	test   %eax,%eax
8010391f:	74 15                	je     80103936 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103921:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103926:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010392c:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103931:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103936:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
8010393c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103941:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103947:	81 c2 20 f9 10 80    	add    $0x8010f920,%edx
8010394d:	88 02                	mov    %al,(%edx)
      ncpu++;
8010394f:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103954:	83 c0 01             	add    $0x1,%eax
80103957:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
8010395c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103960:	eb 41                	jmp    801039a3 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010396b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010396f:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
80103974:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103978:	eb 29                	jmp    801039a3 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010397a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010397e:	eb 23                	jmp    801039a3 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103983:	0f b6 00             	movzbl (%eax),%eax
80103986:	0f b6 c0             	movzbl %al,%eax
80103989:	89 44 24 04          	mov    %eax,0x4(%esp)
8010398d:	c7 04 24 b8 85 10 80 	movl   $0x801085b8,(%esp)
80103994:	e8 07 ca ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103999:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801039a0:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039a9:	0f 82 00 ff ff ff    	jb     801038af <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039af:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	75 1d                	jne    801039d5 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039b8:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
801039bf:	00 00 00 
    lapic = 0;
801039c2:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
801039c9:	00 00 00 
    ioapicid = 0;
801039cc:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
801039d3:	eb 41                	jmp    80103a16 <mpinit+0x1c5>
  }

  if(mp->imcrp){
801039d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039d8:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039dc:	84 c0                	test   %al,%al
801039de:	74 36                	je     80103a16 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039e0:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039e7:	00 
801039e8:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039ef:	e8 0d fc ff ff       	call   80103601 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039f4:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039fb:	e8 e4 fb ff ff       	call   801035e4 <inb>
80103a00:	83 c8 01             	or     $0x1,%eax
80103a03:	0f b6 c0             	movzbl %al,%eax
80103a06:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a0a:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a11:	e8 eb fb ff ff       	call   80103601 <outb>
  }
}
80103a16:	c9                   	leave  
80103a17:	c3                   	ret    

80103a18 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a18:	55                   	push   %ebp
80103a19:	89 e5                	mov    %esp,%ebp
80103a1b:	83 ec 08             	sub    $0x8,%esp
80103a1e:	8b 55 08             	mov    0x8(%ebp),%edx
80103a21:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a24:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a28:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a2b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a2f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a33:	ee                   	out    %al,(%dx)
}
80103a34:	c9                   	leave  
80103a35:	c3                   	ret    

80103a36 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a36:	55                   	push   %ebp
80103a37:	89 e5                	mov    %esp,%ebp
80103a39:	83 ec 0c             	sub    $0xc,%esp
80103a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a3f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a43:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a47:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a4d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a51:	0f b6 c0             	movzbl %al,%eax
80103a54:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a58:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a5f:	e8 b4 ff ff ff       	call   80103a18 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a64:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a68:	66 c1 e8 08          	shr    $0x8,%ax
80103a6c:	0f b6 c0             	movzbl %al,%eax
80103a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a73:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a7a:	e8 99 ff ff ff       	call   80103a18 <outb>
}
80103a7f:	c9                   	leave  
80103a80:	c3                   	ret    

80103a81 <picenable>:

void
picenable(int irq)
{
80103a81:	55                   	push   %ebp
80103a82:	89 e5                	mov    %esp,%ebp
80103a84:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a87:	8b 45 08             	mov    0x8(%ebp),%eax
80103a8a:	ba 01 00 00 00       	mov    $0x1,%edx
80103a8f:	89 c1                	mov    %eax,%ecx
80103a91:	d3 e2                	shl    %cl,%edx
80103a93:	89 d0                	mov    %edx,%eax
80103a95:	f7 d0                	not    %eax
80103a97:	89 c2                	mov    %eax,%edx
80103a99:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103aa0:	21 d0                	and    %edx,%eax
80103aa2:	0f b7 c0             	movzwl %ax,%eax
80103aa5:	89 04 24             	mov    %eax,(%esp)
80103aa8:	e8 89 ff ff ff       	call   80103a36 <picsetmask>
}
80103aad:	c9                   	leave  
80103aae:	c3                   	ret    

80103aaf <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103aaf:	55                   	push   %ebp
80103ab0:	89 e5                	mov    %esp,%ebp
80103ab2:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ab5:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103abc:	00 
80103abd:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ac4:	e8 4f ff ff ff       	call   80103a18 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ac9:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ad0:	00 
80103ad1:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ad8:	e8 3b ff ff ff       	call   80103a18 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103add:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ae4:	00 
80103ae5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103aec:	e8 27 ff ff ff       	call   80103a18 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103af1:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103af8:	00 
80103af9:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b00:	e8 13 ff ff ff       	call   80103a18 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b05:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b0c:	00 
80103b0d:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b14:	e8 ff fe ff ff       	call   80103a18 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b19:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b20:	00 
80103b21:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b28:	e8 eb fe ff ff       	call   80103a18 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b2d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b34:	00 
80103b35:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b3c:	e8 d7 fe ff ff       	call   80103a18 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b41:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b48:	00 
80103b49:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b50:	e8 c3 fe ff ff       	call   80103a18 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b55:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b5c:	00 
80103b5d:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b64:	e8 af fe ff ff       	call   80103a18 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b69:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b70:	00 
80103b71:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b78:	e8 9b fe ff ff       	call   80103a18 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b7d:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b84:	00 
80103b85:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b8c:	e8 87 fe ff ff       	call   80103a18 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b91:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b98:	00 
80103b99:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ba0:	e8 73 fe ff ff       	call   80103a18 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103ba5:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bac:	00 
80103bad:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bb4:	e8 5f fe ff ff       	call   80103a18 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bb9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bc0:	00 
80103bc1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bc8:	e8 4b fe ff ff       	call   80103a18 <outb>

  if(irqmask != 0xFFFF)
80103bcd:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bd4:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bd8:	74 12                	je     80103bec <picinit+0x13d>
    picsetmask(irqmask);
80103bda:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103be1:	0f b7 c0             	movzwl %ax,%eax
80103be4:	89 04 24             	mov    %eax,(%esp)
80103be7:	e8 4a fe ff ff       	call   80103a36 <picsetmask>
}
80103bec:	c9                   	leave  
80103bed:	c3                   	ret    

80103bee <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bee:	55                   	push   %ebp
80103bef:	89 e5                	mov    %esp,%ebp
80103bf1:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c04:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c07:	8b 10                	mov    (%eax),%edx
80103c09:	8b 45 08             	mov    0x8(%ebp),%eax
80103c0c:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c0e:	e8 13 d3 ff ff       	call   80100f26 <filealloc>
80103c13:	8b 55 08             	mov    0x8(%ebp),%edx
80103c16:	89 02                	mov    %eax,(%edx)
80103c18:	8b 45 08             	mov    0x8(%ebp),%eax
80103c1b:	8b 00                	mov    (%eax),%eax
80103c1d:	85 c0                	test   %eax,%eax
80103c1f:	0f 84 c8 00 00 00    	je     80103ced <pipealloc+0xff>
80103c25:	e8 fc d2 ff ff       	call   80100f26 <filealloc>
80103c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c2d:	89 02                	mov    %eax,(%edx)
80103c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c32:	8b 00                	mov    (%eax),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	0f 84 b1 00 00 00    	je     80103ced <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c3c:	e8 a1 ee ff ff       	call   80102ae2 <kalloc>
80103c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c48:	75 05                	jne    80103c4f <pipealloc+0x61>
    goto bad;
80103c4a:	e9 9e 00 00 00       	jmp    80103ced <pipealloc+0xff>
  p->readopen = 1;
80103c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c52:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c59:	00 00 00 
  p->writeopen = 1;
80103c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c66:	00 00 00 
  p->nwrite = 0;
80103c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c73:	00 00 00 
  p->nread = 0;
80103c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c79:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c80:	00 00 00 
  initlock(&p->lock, "pipe");
80103c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c86:	c7 44 24 04 ec 85 10 	movl   $0x801085ec,0x4(%esp)
80103c8d:	80 
80103c8e:	89 04 24             	mov    %eax,(%esp)
80103c91:	e8 00 0e 00 00       	call   80104a96 <initlock>
  (*f0)->type = FD_PIPE;
80103c96:	8b 45 08             	mov    0x8(%ebp),%eax
80103c99:	8b 00                	mov    (%eax),%eax
80103c9b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca4:	8b 00                	mov    (%eax),%eax
80103ca6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103caa:	8b 45 08             	mov    0x8(%ebp),%eax
80103cad:	8b 00                	mov    (%eax),%eax
80103caf:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb6:	8b 00                	mov    (%eax),%eax
80103cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cbb:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc1:	8b 00                	mov    (%eax),%eax
80103cc3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ccc:	8b 00                	mov    (%eax),%eax
80103cce:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd5:	8b 00                	mov    (%eax),%eax
80103cd7:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cde:	8b 00                	mov    (%eax),%eax
80103ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ce3:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ce6:	b8 00 00 00 00       	mov    $0x0,%eax
80103ceb:	eb 42                	jmp    80103d2f <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cf1:	74 0b                	je     80103cfe <pipealloc+0x110>
    kfree((char*)p);
80103cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf6:	89 04 24             	mov    %eax,(%esp)
80103cf9:	e8 4b ed ff ff       	call   80102a49 <kfree>
  if(*f0)
80103cfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103d01:	8b 00                	mov    (%eax),%eax
80103d03:	85 c0                	test   %eax,%eax
80103d05:	74 0d                	je     80103d14 <pipealloc+0x126>
    fileclose(*f0);
80103d07:	8b 45 08             	mov    0x8(%ebp),%eax
80103d0a:	8b 00                	mov    (%eax),%eax
80103d0c:	89 04 24             	mov    %eax,(%esp)
80103d0f:	e8 ba d2 ff ff       	call   80100fce <fileclose>
  if(*f1)
80103d14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d17:	8b 00                	mov    (%eax),%eax
80103d19:	85 c0                	test   %eax,%eax
80103d1b:	74 0d                	je     80103d2a <pipealloc+0x13c>
    fileclose(*f1);
80103d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d20:	8b 00                	mov    (%eax),%eax
80103d22:	89 04 24             	mov    %eax,(%esp)
80103d25:	e8 a4 d2 ff ff       	call   80100fce <fileclose>
  return -1;
80103d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d2f:	c9                   	leave  
80103d30:	c3                   	ret    

80103d31 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d31:	55                   	push   %ebp
80103d32:	89 e5                	mov    %esp,%ebp
80103d34:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d37:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3a:	89 04 24             	mov    %eax,(%esp)
80103d3d:	e8 75 0d 00 00       	call   80104ab7 <acquire>
  if(writable){
80103d42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d46:	74 1f                	je     80103d67 <pipeclose+0x36>
    p->writeopen = 0;
80103d48:	8b 45 08             	mov    0x8(%ebp),%eax
80103d4b:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d52:	00 00 00 
    wakeup(&p->nread);
80103d55:	8b 45 08             	mov    0x8(%ebp),%eax
80103d58:	05 34 02 00 00       	add    $0x234,%eax
80103d5d:	89 04 24             	mov    %eax,(%esp)
80103d60:	e8 61 0b 00 00       	call   801048c6 <wakeup>
80103d65:	eb 1d                	jmp    80103d84 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d67:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6a:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d71:	00 00 00 
    wakeup(&p->nwrite);
80103d74:	8b 45 08             	mov    0x8(%ebp),%eax
80103d77:	05 38 02 00 00       	add    $0x238,%eax
80103d7c:	89 04 24             	mov    %eax,(%esp)
80103d7f:	e8 42 0b 00 00       	call   801048c6 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d84:	8b 45 08             	mov    0x8(%ebp),%eax
80103d87:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d8d:	85 c0                	test   %eax,%eax
80103d8f:	75 25                	jne    80103db6 <pipeclose+0x85>
80103d91:	8b 45 08             	mov    0x8(%ebp),%eax
80103d94:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d9a:	85 c0                	test   %eax,%eax
80103d9c:	75 18                	jne    80103db6 <pipeclose+0x85>
    release(&p->lock);
80103d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80103da1:	89 04 24             	mov    %eax,(%esp)
80103da4:	e8 70 0d 00 00       	call   80104b19 <release>
    kfree((char*)p);
80103da9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dac:	89 04 24             	mov    %eax,(%esp)
80103daf:	e8 95 ec ff ff       	call   80102a49 <kfree>
80103db4:	eb 0b                	jmp    80103dc1 <pipeclose+0x90>
  } else
    release(&p->lock);
80103db6:	8b 45 08             	mov    0x8(%ebp),%eax
80103db9:	89 04 24             	mov    %eax,(%esp)
80103dbc:	e8 58 0d 00 00       	call   80104b19 <release>
}
80103dc1:	c9                   	leave  
80103dc2:	c3                   	ret    

80103dc3 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103dc3:	55                   	push   %ebp
80103dc4:	89 e5                	mov    %esp,%ebp
80103dc6:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcc:	89 04 24             	mov    %eax,(%esp)
80103dcf:	e8 e3 0c 00 00       	call   80104ab7 <acquire>
  for(i = 0; i < n; i++){
80103dd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ddb:	e9 a6 00 00 00       	jmp    80103e86 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103de0:	eb 57                	jmp    80103e39 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103de2:	8b 45 08             	mov    0x8(%ebp),%eax
80103de5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103deb:	85 c0                	test   %eax,%eax
80103ded:	74 0d                	je     80103dfc <pipewrite+0x39>
80103def:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103df5:	8b 40 24             	mov    0x24(%eax),%eax
80103df8:	85 c0                	test   %eax,%eax
80103dfa:	74 15                	je     80103e11 <pipewrite+0x4e>
        release(&p->lock);
80103dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dff:	89 04 24             	mov    %eax,(%esp)
80103e02:	e8 12 0d 00 00       	call   80104b19 <release>
        return -1;
80103e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e0c:	e9 9f 00 00 00       	jmp    80103eb0 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103e11:	8b 45 08             	mov    0x8(%ebp),%eax
80103e14:	05 34 02 00 00       	add    $0x234,%eax
80103e19:	89 04 24             	mov    %eax,(%esp)
80103e1c:	e8 a5 0a 00 00       	call   801048c6 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e21:	8b 45 08             	mov    0x8(%ebp),%eax
80103e24:	8b 55 08             	mov    0x8(%ebp),%edx
80103e27:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e31:	89 14 24             	mov    %edx,(%esp)
80103e34:	e8 b4 09 00 00       	call   801047ed <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e39:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e42:	8b 45 08             	mov    0x8(%ebp),%eax
80103e45:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e4b:	05 00 02 00 00       	add    $0x200,%eax
80103e50:	39 c2                	cmp    %eax,%edx
80103e52:	74 8e                	je     80103de2 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e54:	8b 45 08             	mov    0x8(%ebp),%eax
80103e57:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e5d:	8d 48 01             	lea    0x1(%eax),%ecx
80103e60:	8b 55 08             	mov    0x8(%ebp),%edx
80103e63:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e69:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e6e:	89 c1                	mov    %eax,%ecx
80103e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e73:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e76:	01 d0                	add    %edx,%eax
80103e78:	0f b6 10             	movzbl (%eax),%edx
80103e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e82:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e89:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e8c:	0f 8c 4e ff ff ff    	jl     80103de0 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e92:	8b 45 08             	mov    0x8(%ebp),%eax
80103e95:	05 34 02 00 00       	add    $0x234,%eax
80103e9a:	89 04 24             	mov    %eax,(%esp)
80103e9d:	e8 24 0a 00 00       	call   801048c6 <wakeup>
  release(&p->lock);
80103ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea5:	89 04 24             	mov    %eax,(%esp)
80103ea8:	e8 6c 0c 00 00       	call   80104b19 <release>
  return n;
80103ead:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103eb0:	c9                   	leave  
80103eb1:	c3                   	ret    

80103eb2 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103eb2:	55                   	push   %ebp
80103eb3:	89 e5                	mov    %esp,%ebp
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebc:	89 04 24             	mov    %eax,(%esp)
80103ebf:	e8 f3 0b 00 00       	call   80104ab7 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ec4:	eb 3a                	jmp    80103f00 <piperead+0x4e>
    if(proc->killed){
80103ec6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ecc:	8b 40 24             	mov    0x24(%eax),%eax
80103ecf:	85 c0                	test   %eax,%eax
80103ed1:	74 15                	je     80103ee8 <piperead+0x36>
      release(&p->lock);
80103ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed6:	89 04 24             	mov    %eax,(%esp)
80103ed9:	e8 3b 0c 00 00       	call   80104b19 <release>
      return -1;
80103ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ee3:	e9 b5 00 00 00       	jmp    80103f9d <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80103eeb:	8b 55 08             	mov    0x8(%ebp),%edx
80103eee:	81 c2 34 02 00 00    	add    $0x234,%edx
80103ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ef8:	89 14 24             	mov    %edx,(%esp)
80103efb:	e8 ed 08 00 00       	call   801047ed <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f00:	8b 45 08             	mov    0x8(%ebp),%eax
80103f03:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f09:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f12:	39 c2                	cmp    %eax,%edx
80103f14:	75 0d                	jne    80103f23 <piperead+0x71>
80103f16:	8b 45 08             	mov    0x8(%ebp),%eax
80103f19:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f1f:	85 c0                	test   %eax,%eax
80103f21:	75 a3                	jne    80103ec6 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f2a:	eb 4b                	jmp    80103f77 <piperead+0xc5>
    if(p->nread == p->nwrite)
80103f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2f:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f35:	8b 45 08             	mov    0x8(%ebp),%eax
80103f38:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f3e:	39 c2                	cmp    %eax,%edx
80103f40:	75 02                	jne    80103f44 <piperead+0x92>
      break;
80103f42:	eb 3b                	jmp    80103f7f <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f4a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f50:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f56:	8d 48 01             	lea    0x1(%eax),%ecx
80103f59:	8b 55 08             	mov    0x8(%ebp),%edx
80103f5c:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f62:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f67:	89 c2                	mov    %eax,%edx
80103f69:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6c:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f71:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f7a:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f7d:	7c ad                	jl     80103f2c <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f82:	05 38 02 00 00       	add    $0x238,%eax
80103f87:	89 04 24             	mov    %eax,(%esp)
80103f8a:	e8 37 09 00 00       	call   801048c6 <wakeup>
  release(&p->lock);
80103f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f92:	89 04 24             	mov    %eax,(%esp)
80103f95:	e8 7f 0b 00 00       	call   80104b19 <release>
  return i;
80103f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f9d:	83 c4 24             	add    $0x24,%esp
80103fa0:	5b                   	pop    %ebx
80103fa1:	5d                   	pop    %ebp
80103fa2:	c3                   	ret    

80103fa3 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103fa3:	55                   	push   %ebp
80103fa4:	89 e5                	mov    %esp,%ebp
80103fa6:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa9:	9c                   	pushf  
80103faa:	58                   	pop    %eax
80103fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103fb1:	c9                   	leave  
80103fb2:	c3                   	ret    

80103fb3 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103fb3:	55                   	push   %ebp
80103fb4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fb6:	fb                   	sti    
}
80103fb7:	5d                   	pop    %ebp
80103fb8:	c3                   	ret    

80103fb9 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103fb9:	55                   	push   %ebp
80103fba:	89 e5                	mov    %esp,%ebp
80103fbc:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103fbf:	c7 44 24 04 f1 85 10 	movl   $0x801085f1,0x4(%esp)
80103fc6:	80 
80103fc7:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103fce:	e8 c3 0a 00 00       	call   80104a96 <initlock>
}
80103fd3:	c9                   	leave  
80103fd4:	c3                   	ret    

80103fd5 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fd5:	55                   	push   %ebp
80103fd6:	89 e5                	mov    %esp,%ebp
80103fd8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103fdb:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103fe2:	e8 d0 0a 00 00       	call   80104ab7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe7:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80103fee:	eb 50                	jmp    80104040 <allocproc+0x6b>
    if(p->state == UNUSED)
80103ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	75 42                	jne    8010403c <allocproc+0x67>
      goto found;
80103ffa:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffe:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104005:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010400a:	8d 50 01             	lea    0x1(%eax),%edx
8010400d:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104013:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104016:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104019:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104020:	e8 f4 0a 00 00       	call   80104b19 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104025:	e8 b8 ea ff ff       	call   80102ae2 <kalloc>
8010402a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010402d:	89 42 08             	mov    %eax,0x8(%edx)
80104030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104033:	8b 40 08             	mov    0x8(%eax),%eax
80104036:	85 c0                	test   %eax,%eax
80104038:	75 33                	jne    8010406d <allocproc+0x98>
8010403a:	eb 20                	jmp    8010405c <allocproc+0x87>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104040:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104047:	72 a7                	jb     80103ff0 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104049:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104050:	e8 c4 0a 00 00       	call   80104b19 <release>
  return 0;
80104055:	b8 00 00 00 00       	mov    $0x0,%eax
8010405a:	eb 76                	jmp    801040d2 <allocproc+0xfd>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010405c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104066:	b8 00 00 00 00       	mov    $0x0,%eax
8010406b:	eb 65                	jmp    801040d2 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
8010406d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104070:	8b 40 08             	mov    0x8(%eax),%eax
80104073:	05 00 10 00 00       	add    $0x1000,%eax
80104078:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010407b:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010407f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104082:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104085:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104088:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010408c:	ba 1f 61 10 80       	mov    $0x8010611f,%edx
80104091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104094:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104096:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010409a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040a0:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a6:	8b 40 1c             	mov    0x1c(%eax),%eax
801040a9:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801040b0:	00 
801040b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801040b8:	00 
801040b9:	89 04 24             	mov    %eax,(%esp)
801040bc:	e8 4a 0c 00 00       	call   80104d0b <memset>
  p->context->eip = (uint)forkret;
801040c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c4:	8b 40 1c             	mov    0x1c(%eax),%eax
801040c7:	ba c1 47 10 80       	mov    $0x801047c1,%edx
801040cc:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801040cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040d2:	c9                   	leave  
801040d3:	c3                   	ret    

801040d4 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801040d4:	55                   	push   %ebp
801040d5:	89 e5                	mov    %esp,%ebp
801040d7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801040da:	e8 f6 fe ff ff       	call   80103fd5 <allocproc>
801040df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801040e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e5:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
801040ea:	e8 24 37 00 00       	call   80107813 <setupkvm>
801040ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040f2:	89 42 04             	mov    %eax,0x4(%edx)
801040f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f8:	8b 40 04             	mov    0x4(%eax),%eax
801040fb:	85 c0                	test   %eax,%eax
801040fd:	75 0c                	jne    8010410b <userinit+0x37>
    panic("userinit: out of memory?");
801040ff:	c7 04 24 f8 85 10 80 	movl   $0x801085f8,(%esp)
80104106:	e8 2f c4 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010410b:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104113:	8b 40 04             	mov    0x4(%eax),%eax
80104116:	89 54 24 08          	mov    %edx,0x8(%esp)
8010411a:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104121:	80 
80104122:	89 04 24             	mov    %eax,(%esp)
80104125:	e8 41 39 00 00       	call   80107a6b <inituvm>
  p->sz = PGSIZE;
8010412a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412d:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104136:	8b 40 18             	mov    0x18(%eax),%eax
80104139:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104140:	00 
80104141:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104148:	00 
80104149:	89 04 24             	mov    %eax,(%esp)
8010414c:	e8 ba 0b 00 00       	call   80104d0b <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104154:	8b 40 18             	mov    0x18(%eax),%eax
80104157:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104160:	8b 40 18             	mov    0x18(%eax),%eax
80104163:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416c:	8b 40 18             	mov    0x18(%eax),%eax
8010416f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104172:	8b 52 18             	mov    0x18(%edx),%edx
80104175:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104179:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010417d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104180:	8b 40 18             	mov    0x18(%eax),%eax
80104183:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104186:	8b 52 18             	mov    0x18(%edx),%edx
80104189:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010418d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104194:	8b 40 18             	mov    0x18(%eax),%eax
80104197:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010419e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a1:	8b 40 18             	mov    0x18(%eax),%eax
801041a4:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ae:	8b 40 18             	mov    0x18(%eax),%eax
801041b1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bb:	83 c0 6c             	add    $0x6c,%eax
801041be:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801041c5:	00 
801041c6:	c7 44 24 04 11 86 10 	movl   $0x80108611,0x4(%esp)
801041cd:	80 
801041ce:	89 04 24             	mov    %eax,(%esp)
801041d1:	e8 55 0d 00 00       	call   80104f2b <safestrcpy>
  p->cwd = namei("/");
801041d6:	c7 04 24 1a 86 10 80 	movl   $0x8010861a,(%esp)
801041dd:	e8 24 e2 ff ff       	call   80102406 <namei>
801041e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e5:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801041e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041eb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801041f2:	c9                   	leave  
801041f3:	c3                   	ret    

801041f4 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801041fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104200:	8b 00                	mov    (%eax),%eax
80104202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104209:	7e 34                	jle    8010423f <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010420b:	8b 55 08             	mov    0x8(%ebp),%edx
8010420e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104211:	01 c2                	add    %eax,%edx
80104213:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104219:	8b 40 04             	mov    0x4(%eax),%eax
8010421c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104220:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104223:	89 54 24 04          	mov    %edx,0x4(%esp)
80104227:	89 04 24             	mov    %eax,(%esp)
8010422a:	e8 b2 39 00 00       	call   80107be1 <allocuvm>
8010422f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104236:	75 41                	jne    80104279 <growproc+0x85>
      return -1;
80104238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010423d:	eb 58                	jmp    80104297 <growproc+0xa3>
  } else if(n < 0){
8010423f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104243:	79 34                	jns    80104279 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104245:	8b 55 08             	mov    0x8(%ebp),%edx
80104248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424b:	01 c2                	add    %eax,%edx
8010424d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104253:	8b 40 04             	mov    0x4(%eax),%eax
80104256:	89 54 24 08          	mov    %edx,0x8(%esp)
8010425a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010425d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104261:	89 04 24             	mov    %eax,(%esp)
80104264:	e8 52 3a 00 00       	call   80107cbb <deallocuvm>
80104269:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010426c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104270:	75 07                	jne    80104279 <growproc+0x85>
      return -1;
80104272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104277:	eb 1e                	jmp    80104297 <growproc+0xa3>
  }
  proc->sz = sz;
80104279:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010427f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104282:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104284:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010428a:	89 04 24             	mov    %eax,(%esp)
8010428d:	e8 72 36 00 00       	call   80107904 <switchuvm>
  return 0;
80104292:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104297:	c9                   	leave  
80104298:	c3                   	ret    

80104299 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104299:	55                   	push   %ebp
8010429a:	89 e5                	mov    %esp,%ebp
8010429c:	57                   	push   %edi
8010429d:	56                   	push   %esi
8010429e:	53                   	push   %ebx
8010429f:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801042a2:	e8 2e fd ff ff       	call   80103fd5 <allocproc>
801042a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801042aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801042ae:	75 0a                	jne    801042ba <fork+0x21>
    return -1;
801042b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042b5:	e9 52 01 00 00       	jmp    8010440c <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801042ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c0:	8b 10                	mov    (%eax),%edx
801042c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c8:	8b 40 04             	mov    0x4(%eax),%eax
801042cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801042cf:	89 04 24             	mov    %eax,(%esp)
801042d2:	e8 80 3b 00 00       	call   80107e57 <copyuvm>
801042d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042da:	89 42 04             	mov    %eax,0x4(%edx)
801042dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042e0:	8b 40 04             	mov    0x4(%eax),%eax
801042e3:	85 c0                	test   %eax,%eax
801042e5:	75 2c                	jne    80104313 <fork+0x7a>
    kfree(np->kstack);
801042e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ea:	8b 40 08             	mov    0x8(%eax),%eax
801042ed:	89 04 24             	mov    %eax,(%esp)
801042f0:	e8 54 e7 ff ff       	call   80102a49 <kfree>
    np->kstack = 0;
801042f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801042ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104302:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010430e:	e9 f9 00 00 00       	jmp    8010440c <fork+0x173>
  }
  np->sz = proc->sz;
80104313:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104319:	8b 10                	mov    (%eax),%edx
8010431b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010431e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104320:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104327:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010432a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010432d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104330:	8b 50 18             	mov    0x18(%eax),%edx
80104333:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104339:	8b 40 18             	mov    0x18(%eax),%eax
8010433c:	89 c3                	mov    %eax,%ebx
8010433e:	b8 13 00 00 00       	mov    $0x13,%eax
80104343:	89 d7                	mov    %edx,%edi
80104345:	89 de                	mov    %ebx,%esi
80104347:	89 c1                	mov    %eax,%ecx
80104349:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010434b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010434e:	8b 40 18             	mov    0x18(%eax),%eax
80104351:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104358:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010435f:	eb 3d                	jmp    8010439e <fork+0x105>
    if(proc->ofile[i])
80104361:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104367:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010436a:	83 c2 08             	add    $0x8,%edx
8010436d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104371:	85 c0                	test   %eax,%eax
80104373:	74 25                	je     8010439a <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104375:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010437b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010437e:	83 c2 08             	add    $0x8,%edx
80104381:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104385:	89 04 24             	mov    %eax,(%esp)
80104388:	e8 f9 cb ff ff       	call   80100f86 <filedup>
8010438d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104390:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104393:	83 c1 08             	add    $0x8,%ecx
80104396:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010439a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010439e:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801043a2:	7e bd                	jle    80104361 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801043a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043aa:	8b 40 68             	mov    0x68(%eax),%eax
801043ad:	89 04 24             	mov    %eax,(%esp)
801043b0:	e8 74 d4 ff ff       	call   80101829 <idup>
801043b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043b8:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801043bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c1:	8d 50 6c             	lea    0x6c(%eax),%edx
801043c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043c7:	83 c0 6c             	add    $0x6c,%eax
801043ca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043d1:	00 
801043d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801043d6:	89 04 24             	mov    %eax,(%esp)
801043d9:	e8 4d 0b 00 00       	call   80104f2b <safestrcpy>
 
  pid = np->pid;
801043de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043e1:	8b 40 10             	mov    0x10(%eax),%eax
801043e4:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801043e7:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801043ee:	e8 c4 06 00 00       	call   80104ab7 <acquire>
  np->state = RUNNABLE;
801043f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043f6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801043fd:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104404:	e8 10 07 00 00       	call   80104b19 <release>
  
  return pid;
80104409:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010440c:	83 c4 2c             	add    $0x2c,%esp
8010440f:	5b                   	pop    %ebx
80104410:	5e                   	pop    %esi
80104411:	5f                   	pop    %edi
80104412:	5d                   	pop    %ebp
80104413:	c3                   	ret    

80104414 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010441a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104421:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104426:	39 c2                	cmp    %eax,%edx
80104428:	75 0c                	jne    80104436 <exit+0x22>
    panic("init exiting");
8010442a:	c7 04 24 1c 86 10 80 	movl   $0x8010861c,(%esp)
80104431:	e8 04 c1 ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010443d:	eb 44                	jmp    80104483 <exit+0x6f>
    if(proc->ofile[fd]){
8010443f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104445:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104448:	83 c2 08             	add    $0x8,%edx
8010444b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010444f:	85 c0                	test   %eax,%eax
80104451:	74 2c                	je     8010447f <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104453:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104459:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010445c:	83 c2 08             	add    $0x8,%edx
8010445f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104463:	89 04 24             	mov    %eax,(%esp)
80104466:	e8 63 cb ff ff       	call   80100fce <fileclose>
      proc->ofile[fd] = 0;
8010446b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104471:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104474:	83 c2 08             	add    $0x8,%edx
80104477:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010447e:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010447f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104483:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104487:	7e b6                	jle    8010443f <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_trans();
80104489:	e8 57 ed ff ff       	call   801031e5 <begin_trans>
  iput(proc->cwd);
8010448e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104494:	8b 40 68             	mov    0x68(%eax),%eax
80104497:	89 04 24             	mov    %eax,(%esp)
8010449a:	e8 6f d5 ff ff       	call   80101a0e <iput>
  commit_trans();
8010449f:	e8 8a ed ff ff       	call   8010322e <commit_trans>
  proc->cwd = 0;
801044a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044aa:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801044b1:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801044b8:	e8 fa 05 00 00       	call   80104ab7 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801044bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c3:	8b 40 14             	mov    0x14(%eax),%eax
801044c6:	89 04 24             	mov    %eax,(%esp)
801044c9:	e8 ba 03 00 00       	call   80104888 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ce:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801044d5:	eb 38                	jmp    8010450f <exit+0xfb>
    if(p->parent == proc){
801044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044da:	8b 50 14             	mov    0x14(%eax),%edx
801044dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e3:	39 c2                	cmp    %eax,%edx
801044e5:	75 24                	jne    8010450b <exit+0xf7>
      p->parent = initproc;
801044e7:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
801044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f0:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801044f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f6:	8b 40 0c             	mov    0xc(%eax),%eax
801044f9:	83 f8 05             	cmp    $0x5,%eax
801044fc:	75 0d                	jne    8010450b <exit+0xf7>
        wakeup1(initproc);
801044fe:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104503:	89 04 24             	mov    %eax,(%esp)
80104506:	e8 7d 03 00 00       	call   80104888 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010450b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010450f:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104516:	72 bf                	jb     801044d7 <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104518:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010451e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104525:	e8 b3 01 00 00       	call   801046dd <sched>
  panic("zombie exit");
8010452a:	c7 04 24 29 86 10 80 	movl   $0x80108629,(%esp)
80104531:	e8 04 c0 ff ff       	call   8010053a <panic>

80104536 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104536:	55                   	push   %ebp
80104537:	89 e5                	mov    %esp,%ebp
80104539:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010453c:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104543:	e8 6f 05 00 00       	call   80104ab7 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010454f:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104556:	e9 9a 00 00 00       	jmp    801045f5 <wait+0xbf>
      if(p->parent != proc)
8010455b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455e:	8b 50 14             	mov    0x14(%eax),%edx
80104561:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104567:	39 c2                	cmp    %eax,%edx
80104569:	74 05                	je     80104570 <wait+0x3a>
        continue;
8010456b:	e9 81 00 00 00       	jmp    801045f1 <wait+0xbb>
      havekids = 1;
80104570:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457a:	8b 40 0c             	mov    0xc(%eax),%eax
8010457d:	83 f8 05             	cmp    $0x5,%eax
80104580:	75 6f                	jne    801045f1 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104585:	8b 40 10             	mov    0x10(%eax),%eax
80104588:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010458b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458e:	8b 40 08             	mov    0x8(%eax),%eax
80104591:	89 04 24             	mov    %eax,(%esp)
80104594:	e8 b0 e4 ff ff       	call   80102a49 <kfree>
        p->kstack = 0;
80104599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a6:	8b 40 04             	mov    0x4(%eax),%eax
801045a9:	89 04 24             	mov    %eax,(%esp)
801045ac:	e8 c6 37 00 00       	call   80107d77 <freevm>
        p->state = UNUSED;
801045b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045be:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801045c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d2:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d9:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801045e0:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045e7:	e8 2d 05 00 00       	call   80104b19 <release>
        return pid;
801045ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045ef:	eb 52                	jmp    80104643 <wait+0x10d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f1:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045f5:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801045fc:	0f 82 59 ff ff ff    	jb     8010455b <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104602:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104606:	74 0d                	je     80104615 <wait+0xdf>
80104608:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010460e:	8b 40 24             	mov    0x24(%eax),%eax
80104611:	85 c0                	test   %eax,%eax
80104613:	74 13                	je     80104628 <wait+0xf2>
      release(&ptable.lock);
80104615:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010461c:	e8 f8 04 00 00       	call   80104b19 <release>
      return -1;
80104621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104626:	eb 1b                	jmp    80104643 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462e:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
80104635:	80 
80104636:	89 04 24             	mov    %eax,(%esp)
80104639:	e8 af 01 00 00       	call   801047ed <sleep>
  }
8010463e:	e9 05 ff ff ff       	jmp    80104548 <wait+0x12>
}
80104643:	c9                   	leave  
80104644:	c3                   	ret    

80104645 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104645:	55                   	push   %ebp
80104646:	89 e5                	mov    %esp,%ebp
80104648:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
8010464b:	e8 63 f9 ff ff       	call   80103fb3 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104650:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104657:	e8 5b 04 00 00       	call   80104ab7 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465c:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104663:	eb 5e                	jmp    801046c3 <scheduler+0x7e>
      if(p->state != RUNNABLE)
80104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104668:	8b 40 0c             	mov    0xc(%eax),%eax
8010466b:	83 f8 03             	cmp    $0x3,%eax
8010466e:	74 02                	je     80104672 <scheduler+0x2d>
        continue;
80104670:	eb 4d                	jmp    801046bf <scheduler+0x7a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104675:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
8010467b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467e:	89 04 24             	mov    %eax,(%esp)
80104681:	e8 7e 32 00 00       	call   80107904 <switchuvm>
      p->state = RUNNING;
80104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104689:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104696:	8b 40 1c             	mov    0x1c(%eax),%eax
80104699:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801046a0:	83 c2 04             	add    $0x4,%edx
801046a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801046a7:	89 14 24             	mov    %edx,(%esp)
801046aa:	e8 ed 08 00 00       	call   80104f9c <swtch>
      switchkvm();
801046af:	e8 33 32 00 00       	call   801078e7 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801046b4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801046bb:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046bf:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801046c3:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801046ca:	72 99                	jb     80104665 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
801046cc:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046d3:	e8 41 04 00 00       	call   80104b19 <release>

  }
801046d8:	e9 6e ff ff ff       	jmp    8010464b <scheduler+0x6>

801046dd <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801046dd:	55                   	push   %ebp
801046de:	89 e5                	mov    %esp,%ebp
801046e0:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801046e3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046ea:	e8 f2 04 00 00       	call   80104be1 <holding>
801046ef:	85 c0                	test   %eax,%eax
801046f1:	75 0c                	jne    801046ff <sched+0x22>
    panic("sched ptable.lock");
801046f3:	c7 04 24 35 86 10 80 	movl   $0x80108635,(%esp)
801046fa:	e8 3b be ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
801046ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104705:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010470b:	83 f8 01             	cmp    $0x1,%eax
8010470e:	74 0c                	je     8010471c <sched+0x3f>
    panic("sched locks");
80104710:	c7 04 24 47 86 10 80 	movl   $0x80108647,(%esp)
80104717:	e8 1e be ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
8010471c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104722:	8b 40 0c             	mov    0xc(%eax),%eax
80104725:	83 f8 04             	cmp    $0x4,%eax
80104728:	75 0c                	jne    80104736 <sched+0x59>
    panic("sched running");
8010472a:	c7 04 24 53 86 10 80 	movl   $0x80108653,(%esp)
80104731:	e8 04 be ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104736:	e8 68 f8 ff ff       	call   80103fa3 <readeflags>
8010473b:	25 00 02 00 00       	and    $0x200,%eax
80104740:	85 c0                	test   %eax,%eax
80104742:	74 0c                	je     80104750 <sched+0x73>
    panic("sched interruptible");
80104744:	c7 04 24 61 86 10 80 	movl   $0x80108661,(%esp)
8010474b:	e8 ea bd ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104750:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104756:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010475c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
8010475f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104765:	8b 40 04             	mov    0x4(%eax),%eax
80104768:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010476f:	83 c2 1c             	add    $0x1c,%edx
80104772:	89 44 24 04          	mov    %eax,0x4(%esp)
80104776:	89 14 24             	mov    %edx,(%esp)
80104779:	e8 1e 08 00 00       	call   80104f9c <swtch>
  cpu->intena = intena;
8010477e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104784:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104787:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010478d:	c9                   	leave  
8010478e:	c3                   	ret    

8010478f <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010478f:	55                   	push   %ebp
80104790:	89 e5                	mov    %esp,%ebp
80104792:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104795:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010479c:	e8 16 03 00 00       	call   80104ab7 <acquire>
  proc->state = RUNNABLE;
801047a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801047ae:	e8 2a ff ff ff       	call   801046dd <sched>
  release(&ptable.lock);
801047b3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047ba:	e8 5a 03 00 00       	call   80104b19 <release>
}
801047bf:	c9                   	leave  
801047c0:	c3                   	ret    

801047c1 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801047c1:	55                   	push   %ebp
801047c2:	89 e5                	mov    %esp,%ebp
801047c4:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801047c7:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047ce:	e8 46 03 00 00       	call   80104b19 <release>

  if (first) {
801047d3:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801047d8:	85 c0                	test   %eax,%eax
801047da:	74 0f                	je     801047eb <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801047dc:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
801047e3:	00 00 00 
    initlog();
801047e6:	e8 ec e7 ff ff       	call   80102fd7 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801047eb:	c9                   	leave  
801047ec:	c3                   	ret    

801047ed <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801047ed:	55                   	push   %ebp
801047ee:	89 e5                	mov    %esp,%ebp
801047f0:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801047f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f9:	85 c0                	test   %eax,%eax
801047fb:	75 0c                	jne    80104809 <sleep+0x1c>
    panic("sleep");
801047fd:	c7 04 24 75 86 10 80 	movl   $0x80108675,(%esp)
80104804:	e8 31 bd ff ff       	call   8010053a <panic>

  if(lk == 0)
80104809:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010480d:	75 0c                	jne    8010481b <sleep+0x2e>
    panic("sleep without lk");
8010480f:	c7 04 24 7b 86 10 80 	movl   $0x8010867b,(%esp)
80104816:	e8 1f bd ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010481b:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104822:	74 17                	je     8010483b <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104824:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010482b:	e8 87 02 00 00       	call   80104ab7 <acquire>
    release(lk);
80104830:	8b 45 0c             	mov    0xc(%ebp),%eax
80104833:	89 04 24             	mov    %eax,(%esp)
80104836:	e8 de 02 00 00       	call   80104b19 <release>
  }

  // Go to sleep.
  proc->chan = chan;
8010483b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104841:	8b 55 08             	mov    0x8(%ebp),%edx
80104844:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104847:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104854:	e8 84 fe ff ff       	call   801046dd <sched>

  // Tidy up.
  proc->chan = 0;
80104859:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104866:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
8010486d:	74 17                	je     80104886 <sleep+0x99>
    release(&ptable.lock);
8010486f:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104876:	e8 9e 02 00 00       	call   80104b19 <release>
    acquire(lk);
8010487b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010487e:	89 04 24             	mov    %eax,(%esp)
80104881:	e8 31 02 00 00       	call   80104ab7 <acquire>
  }
}
80104886:	c9                   	leave  
80104887:	c3                   	ret    

80104888 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104888:	55                   	push   %ebp
80104889:	89 e5                	mov    %esp,%ebp
8010488b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010488e:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
80104895:	eb 24                	jmp    801048bb <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104897:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010489a:	8b 40 0c             	mov    0xc(%eax),%eax
8010489d:	83 f8 02             	cmp    $0x2,%eax
801048a0:	75 15                	jne    801048b7 <wakeup1+0x2f>
801048a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048a5:	8b 40 20             	mov    0x20(%eax),%eax
801048a8:	3b 45 08             	cmp    0x8(%ebp),%eax
801048ab:	75 0a                	jne    801048b7 <wakeup1+0x2f>
      p->state = RUNNABLE;
801048ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048b0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b7:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
801048bb:	81 7d fc 54 1e 11 80 	cmpl   $0x80111e54,-0x4(%ebp)
801048c2:	72 d3                	jb     80104897 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801048c4:	c9                   	leave  
801048c5:	c3                   	ret    

801048c6 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048c6:	55                   	push   %ebp
801048c7:	89 e5                	mov    %esp,%ebp
801048c9:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801048cc:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048d3:	e8 df 01 00 00       	call   80104ab7 <acquire>
  wakeup1(chan);
801048d8:	8b 45 08             	mov    0x8(%ebp),%eax
801048db:	89 04 24             	mov    %eax,(%esp)
801048de:	e8 a5 ff ff ff       	call   80104888 <wakeup1>
  release(&ptable.lock);
801048e3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048ea:	e8 2a 02 00 00       	call   80104b19 <release>
}
801048ef:	c9                   	leave  
801048f0:	c3                   	ret    

801048f1 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801048f1:	55                   	push   %ebp
801048f2:	89 e5                	mov    %esp,%ebp
801048f4:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
801048f7:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048fe:	e8 b4 01 00 00       	call   80104ab7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104903:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010490a:	eb 41                	jmp    8010494d <kill+0x5c>
    if(p->pid == pid){
8010490c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490f:	8b 40 10             	mov    0x10(%eax),%eax
80104912:	3b 45 08             	cmp    0x8(%ebp),%eax
80104915:	75 32                	jne    80104949 <kill+0x58>
      p->killed = 1;
80104917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104924:	8b 40 0c             	mov    0xc(%eax),%eax
80104927:	83 f8 02             	cmp    $0x2,%eax
8010492a:	75 0a                	jne    80104936 <kill+0x45>
        p->state = RUNNABLE;
8010492c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104936:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010493d:	e8 d7 01 00 00       	call   80104b19 <release>
      return 0;
80104942:	b8 00 00 00 00       	mov    $0x0,%eax
80104947:	eb 1e                	jmp    80104967 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104949:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010494d:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104954:	72 b6                	jb     8010490c <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104956:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010495d:	e8 b7 01 00 00       	call   80104b19 <release>
  return -1;
80104962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104967:	c9                   	leave  
80104968:	c3                   	ret    

80104969 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104969:	55                   	push   %ebp
8010496a:	89 e5                	mov    %esp,%ebp
8010496c:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010496f:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104976:	e9 d6 00 00 00       	jmp    80104a51 <procdump+0xe8>
    if(p->state == UNUSED)
8010497b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010497e:	8b 40 0c             	mov    0xc(%eax),%eax
80104981:	85 c0                	test   %eax,%eax
80104983:	75 05                	jne    8010498a <procdump+0x21>
      continue;
80104985:	e9 c3 00 00 00       	jmp    80104a4d <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010498a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498d:	8b 40 0c             	mov    0xc(%eax),%eax
80104990:	83 f8 05             	cmp    $0x5,%eax
80104993:	77 23                	ja     801049b8 <procdump+0x4f>
80104995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104998:	8b 40 0c             	mov    0xc(%eax),%eax
8010499b:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
801049a2:	85 c0                	test   %eax,%eax
801049a4:	74 12                	je     801049b8 <procdump+0x4f>
      state = states[p->state];
801049a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049a9:	8b 40 0c             	mov    0xc(%eax),%eax
801049ac:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
801049b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801049b6:	eb 07                	jmp    801049bf <procdump+0x56>
    else
      state = "???";
801049b8:	c7 45 ec 8c 86 10 80 	movl   $0x8010868c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801049bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c2:	8d 50 6c             	lea    0x6c(%eax),%edx
801049c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c8:	8b 40 10             	mov    0x10(%eax),%eax
801049cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
801049cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801049d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801049d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801049da:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
801049e1:	e8 ba b9 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
801049e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049e9:	8b 40 0c             	mov    0xc(%eax),%eax
801049ec:	83 f8 02             	cmp    $0x2,%eax
801049ef:	75 50                	jne    80104a41 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801049f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049f4:	8b 40 1c             	mov    0x1c(%eax),%eax
801049f7:	8b 40 0c             	mov    0xc(%eax),%eax
801049fa:	83 c0 08             	add    $0x8,%eax
801049fd:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104a00:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a04:	89 04 24             	mov    %eax,(%esp)
80104a07:	e8 5c 01 00 00       	call   80104b68 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104a13:	eb 1b                	jmp    80104a30 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a18:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a20:	c7 04 24 99 86 10 80 	movl   $0x80108699,(%esp)
80104a27:	e8 74 b9 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104a2c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104a30:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104a34:	7f 0b                	jg     80104a41 <procdump+0xd8>
80104a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a39:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a3d:	85 c0                	test   %eax,%eax
80104a3f:	75 d4                	jne    80104a15 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a41:	c7 04 24 9d 86 10 80 	movl   $0x8010869d,(%esp)
80104a48:	e8 53 b9 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a4d:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104a51:	81 7d f0 54 1e 11 80 	cmpl   $0x80111e54,-0x10(%ebp)
80104a58:	0f 82 1d ff ff ff    	jb     8010497b <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104a5e:	c9                   	leave  
80104a5f:	c3                   	ret    

80104a60 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a66:	9c                   	pushf  
80104a67:	58                   	pop    %eax
80104a68:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104a6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104a6e:	c9                   	leave  
80104a6f:	c3                   	ret    

80104a70 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104a73:	fa                   	cli    
}
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret    

80104a76 <sti>:

static inline void
sti(void)
{
80104a76:	55                   	push   %ebp
80104a77:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104a79:	fb                   	sti    
}
80104a7a:	5d                   	pop    %ebp
80104a7b:	c3                   	ret    

80104a7c <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104a7c:	55                   	push   %ebp
80104a7d:	89 e5                	mov    %esp,%ebp
80104a7f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104a82:	8b 55 08             	mov    0x8(%ebp),%edx
80104a85:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a88:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a8b:	f0 87 02             	lock xchg %eax,(%edx)
80104a8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104a91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104a94:	c9                   	leave  
80104a95:	c3                   	ret    

80104a96 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a96:	55                   	push   %ebp
80104a97:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104a99:	8b 45 08             	mov    0x8(%ebp),%eax
80104a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104aab:	8b 45 08             	mov    0x8(%ebp),%eax
80104aae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ab5:	5d                   	pop    %ebp
80104ab6:	c3                   	ret    

80104ab7 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104ab7:	55                   	push   %ebp
80104ab8:	89 e5                	mov    %esp,%ebp
80104aba:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104abd:	e8 49 01 00 00       	call   80104c0b <pushcli>
  if(holding(lk))
80104ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ac5:	89 04 24             	mov    %eax,(%esp)
80104ac8:	e8 14 01 00 00       	call   80104be1 <holding>
80104acd:	85 c0                	test   %eax,%eax
80104acf:	74 0c                	je     80104add <acquire+0x26>
    panic("acquire");
80104ad1:	c7 04 24 c9 86 10 80 	movl   $0x801086c9,(%esp)
80104ad8:	e8 5d ba ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104add:	90                   	nop
80104ade:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104ae8:	00 
80104ae9:	89 04 24             	mov    %eax,(%esp)
80104aec:	e8 8b ff ff ff       	call   80104a7c <xchg>
80104af1:	85 c0                	test   %eax,%eax
80104af3:	75 e9                	jne    80104ade <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104af5:	8b 45 08             	mov    0x8(%ebp),%eax
80104af8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104aff:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104b02:	8b 45 08             	mov    0x8(%ebp),%eax
80104b05:	83 c0 0c             	add    $0xc,%eax
80104b08:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b0c:	8d 45 08             	lea    0x8(%ebp),%eax
80104b0f:	89 04 24             	mov    %eax,(%esp)
80104b12:	e8 51 00 00 00       	call   80104b68 <getcallerpcs>
}
80104b17:	c9                   	leave  
80104b18:	c3                   	ret    

80104b19 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104b19:	55                   	push   %ebp
80104b1a:	89 e5                	mov    %esp,%ebp
80104b1c:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104b22:	89 04 24             	mov    %eax,(%esp)
80104b25:	e8 b7 00 00 00       	call   80104be1 <holding>
80104b2a:	85 c0                	test   %eax,%eax
80104b2c:	75 0c                	jne    80104b3a <release+0x21>
    panic("release");
80104b2e:	c7 04 24 d1 86 10 80 	movl   $0x801086d1,(%esp)
80104b35:	e8 00 ba ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104b3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104b44:	8b 45 08             	mov    0x8(%ebp),%eax
80104b47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104b58:	00 
80104b59:	89 04 24             	mov    %eax,(%esp)
80104b5c:	e8 1b ff ff ff       	call   80104a7c <xchg>

  popcli();
80104b61:	e8 e9 00 00 00       	call   80104c4f <popcli>
}
80104b66:	c9                   	leave  
80104b67:	c3                   	ret    

80104b68 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b68:	55                   	push   %ebp
80104b69:	89 e5                	mov    %esp,%ebp
80104b6b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b71:	83 e8 08             	sub    $0x8,%eax
80104b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104b77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104b7e:	eb 38                	jmp    80104bb8 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104b84:	74 38                	je     80104bbe <getcallerpcs+0x56>
80104b86:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104b8d:	76 2f                	jbe    80104bbe <getcallerpcs+0x56>
80104b8f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104b93:	74 29                	je     80104bbe <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba2:	01 c2                	add    %eax,%edx
80104ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ba7:	8b 40 04             	mov    0x4(%eax),%eax
80104baa:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104baf:	8b 00                	mov    (%eax),%eax
80104bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bb4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104bb8:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104bbc:	7e c2                	jle    80104b80 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104bbe:	eb 19                	jmp    80104bd9 <getcallerpcs+0x71>
    pcs[i] = 0;
80104bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104bca:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bcd:	01 d0                	add    %edx,%eax
80104bcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104bd5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104bd9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104bdd:	7e e1                	jle    80104bc0 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104bdf:	c9                   	leave  
80104be0:	c3                   	ret    

80104be1 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104be1:	55                   	push   %ebp
80104be2:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104be4:	8b 45 08             	mov    0x8(%ebp),%eax
80104be7:	8b 00                	mov    (%eax),%eax
80104be9:	85 c0                	test   %eax,%eax
80104beb:	74 17                	je     80104c04 <holding+0x23>
80104bed:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf0:	8b 50 08             	mov    0x8(%eax),%edx
80104bf3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bf9:	39 c2                	cmp    %eax,%edx
80104bfb:	75 07                	jne    80104c04 <holding+0x23>
80104bfd:	b8 01 00 00 00       	mov    $0x1,%eax
80104c02:	eb 05                	jmp    80104c09 <holding+0x28>
80104c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c09:	5d                   	pop    %ebp
80104c0a:	c3                   	ret    

80104c0b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c0b:	55                   	push   %ebp
80104c0c:	89 e5                	mov    %esp,%ebp
80104c0e:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104c11:	e8 4a fe ff ff       	call   80104a60 <readeflags>
80104c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104c19:	e8 52 fe ff ff       	call   80104a70 <cli>
  if(cpu->ncli++ == 0)
80104c1e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c25:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104c2b:	8d 48 01             	lea    0x1(%eax),%ecx
80104c2e:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80104c34:	85 c0                	test   %eax,%eax
80104c36:	75 15                	jne    80104c4d <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80104c38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c41:	81 e2 00 02 00 00    	and    $0x200,%edx
80104c47:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c4d:	c9                   	leave  
80104c4e:	c3                   	ret    

80104c4f <popcli>:

void
popcli(void)
{
80104c4f:	55                   	push   %ebp
80104c50:	89 e5                	mov    %esp,%ebp
80104c52:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104c55:	e8 06 fe ff ff       	call   80104a60 <readeflags>
80104c5a:	25 00 02 00 00       	and    $0x200,%eax
80104c5f:	85 c0                	test   %eax,%eax
80104c61:	74 0c                	je     80104c6f <popcli+0x20>
    panic("popcli - interruptible");
80104c63:	c7 04 24 d9 86 10 80 	movl   $0x801086d9,(%esp)
80104c6a:	e8 cb b8 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104c6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c75:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104c7b:	83 ea 01             	sub    $0x1,%edx
80104c7e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104c84:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	79 0c                	jns    80104c9a <popcli+0x4b>
    panic("popcli");
80104c8e:	c7 04 24 f0 86 10 80 	movl   $0x801086f0,(%esp)
80104c95:	e8 a0 b8 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104c9a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ca0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ca6:	85 c0                	test   %eax,%eax
80104ca8:	75 15                	jne    80104cbf <popcli+0x70>
80104caa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cb0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cb6:	85 c0                	test   %eax,%eax
80104cb8:	74 05                	je     80104cbf <popcli+0x70>
    sti();
80104cba:	e8 b7 fd ff ff       	call   80104a76 <sti>
}
80104cbf:	c9                   	leave  
80104cc0:	c3                   	ret    

80104cc1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104cc1:	55                   	push   %ebp
80104cc2:	89 e5                	mov    %esp,%ebp
80104cc4:	57                   	push   %edi
80104cc5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cc9:	8b 55 10             	mov    0x10(%ebp),%edx
80104ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ccf:	89 cb                	mov    %ecx,%ebx
80104cd1:	89 df                	mov    %ebx,%edi
80104cd3:	89 d1                	mov    %edx,%ecx
80104cd5:	fc                   	cld    
80104cd6:	f3 aa                	rep stos %al,%es:(%edi)
80104cd8:	89 ca                	mov    %ecx,%edx
80104cda:	89 fb                	mov    %edi,%ebx
80104cdc:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104cdf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104ce2:	5b                   	pop    %ebx
80104ce3:	5f                   	pop    %edi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret    

80104ce6 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104ce6:	55                   	push   %ebp
80104ce7:	89 e5                	mov    %esp,%ebp
80104ce9:	57                   	push   %edi
80104cea:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104ceb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cee:	8b 55 10             	mov    0x10(%ebp),%edx
80104cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cf4:	89 cb                	mov    %ecx,%ebx
80104cf6:	89 df                	mov    %ebx,%edi
80104cf8:	89 d1                	mov    %edx,%ecx
80104cfa:	fc                   	cld    
80104cfb:	f3 ab                	rep stos %eax,%es:(%edi)
80104cfd:	89 ca                	mov    %ecx,%edx
80104cff:	89 fb                	mov    %edi,%ebx
80104d01:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104d04:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104d07:	5b                   	pop    %ebx
80104d08:	5f                   	pop    %edi
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    

80104d0b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d0b:	55                   	push   %ebp
80104d0c:	89 e5                	mov    %esp,%ebp
80104d0e:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104d11:	8b 45 08             	mov    0x8(%ebp),%eax
80104d14:	83 e0 03             	and    $0x3,%eax
80104d17:	85 c0                	test   %eax,%eax
80104d19:	75 49                	jne    80104d64 <memset+0x59>
80104d1b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d1e:	83 e0 03             	and    $0x3,%eax
80104d21:	85 c0                	test   %eax,%eax
80104d23:	75 3f                	jne    80104d64 <memset+0x59>
    c &= 0xFF;
80104d25:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d2c:	8b 45 10             	mov    0x10(%ebp),%eax
80104d2f:	c1 e8 02             	shr    $0x2,%eax
80104d32:	89 c2                	mov    %eax,%edx
80104d34:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d37:	c1 e0 18             	shl    $0x18,%eax
80104d3a:	89 c1                	mov    %eax,%ecx
80104d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3f:	c1 e0 10             	shl    $0x10,%eax
80104d42:	09 c1                	or     %eax,%ecx
80104d44:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d47:	c1 e0 08             	shl    $0x8,%eax
80104d4a:	09 c8                	or     %ecx,%eax
80104d4c:	0b 45 0c             	or     0xc(%ebp),%eax
80104d4f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d53:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d57:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5a:	89 04 24             	mov    %eax,(%esp)
80104d5d:	e8 84 ff ff ff       	call   80104ce6 <stosl>
80104d62:	eb 19                	jmp    80104d7d <memset+0x72>
  } else
    stosb(dst, c, n);
80104d64:	8b 45 10             	mov    0x10(%ebp),%eax
80104d67:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d72:	8b 45 08             	mov    0x8(%ebp),%eax
80104d75:	89 04 24             	mov    %eax,(%esp)
80104d78:	e8 44 ff ff ff       	call   80104cc1 <stosb>
  return dst;
80104d7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d80:	c9                   	leave  
80104d81:	c3                   	ret    

80104d82 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d82:	55                   	push   %ebp
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104d88:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d91:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104d94:	eb 30                	jmp    80104dc6 <memcmp+0x44>
    if(*s1 != *s2)
80104d96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d99:	0f b6 10             	movzbl (%eax),%edx
80104d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d9f:	0f b6 00             	movzbl (%eax),%eax
80104da2:	38 c2                	cmp    %al,%dl
80104da4:	74 18                	je     80104dbe <memcmp+0x3c>
      return *s1 - *s2;
80104da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104da9:	0f b6 00             	movzbl (%eax),%eax
80104dac:	0f b6 d0             	movzbl %al,%edx
80104daf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104db2:	0f b6 00             	movzbl (%eax),%eax
80104db5:	0f b6 c0             	movzbl %al,%eax
80104db8:	29 c2                	sub    %eax,%edx
80104dba:	89 d0                	mov    %edx,%eax
80104dbc:	eb 1a                	jmp    80104dd8 <memcmp+0x56>
    s1++, s2++;
80104dbe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104dc2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104dc6:	8b 45 10             	mov    0x10(%ebp),%eax
80104dc9:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dcc:	89 55 10             	mov    %edx,0x10(%ebp)
80104dcf:	85 c0                	test   %eax,%eax
80104dd1:	75 c3                	jne    80104d96 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dd8:	c9                   	leave  
80104dd9:	c3                   	ret    

80104dda <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104dda:	55                   	push   %ebp
80104ddb:	89 e5                	mov    %esp,%ebp
80104ddd:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104de6:	8b 45 08             	mov    0x8(%ebp),%eax
80104de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104def:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104df2:	73 3d                	jae    80104e31 <memmove+0x57>
80104df4:	8b 45 10             	mov    0x10(%ebp),%eax
80104df7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dfa:	01 d0                	add    %edx,%eax
80104dfc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104dff:	76 30                	jbe    80104e31 <memmove+0x57>
    s += n;
80104e01:	8b 45 10             	mov    0x10(%ebp),%eax
80104e04:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104e07:	8b 45 10             	mov    0x10(%ebp),%eax
80104e0a:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104e0d:	eb 13                	jmp    80104e22 <memmove+0x48>
      *--d = *--s;
80104e0f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104e13:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e1a:	0f b6 10             	movzbl (%eax),%edx
80104e1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e20:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104e22:	8b 45 10             	mov    0x10(%ebp),%eax
80104e25:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e28:	89 55 10             	mov    %edx,0x10(%ebp)
80104e2b:	85 c0                	test   %eax,%eax
80104e2d:	75 e0                	jne    80104e0f <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e2f:	eb 26                	jmp    80104e57 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e31:	eb 17                	jmp    80104e4a <memmove+0x70>
      *d++ = *s++;
80104e33:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e36:	8d 50 01             	lea    0x1(%eax),%edx
80104e39:	89 55 f8             	mov    %edx,-0x8(%ebp)
80104e3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e3f:	8d 4a 01             	lea    0x1(%edx),%ecx
80104e42:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104e45:	0f b6 12             	movzbl (%edx),%edx
80104e48:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e4a:	8b 45 10             	mov    0x10(%ebp),%eax
80104e4d:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e50:	89 55 10             	mov    %edx,0x10(%ebp)
80104e53:	85 c0                	test   %eax,%eax
80104e55:	75 dc                	jne    80104e33 <memmove+0x59>
      *d++ = *s++;

  return dst;
80104e57:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104e5a:	c9                   	leave  
80104e5b:	c3                   	ret    

80104e5c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e5c:	55                   	push   %ebp
80104e5d:	89 e5                	mov    %esp,%ebp
80104e5f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104e62:	8b 45 10             	mov    0x10(%ebp),%eax
80104e65:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e69:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e70:	8b 45 08             	mov    0x8(%ebp),%eax
80104e73:	89 04 24             	mov    %eax,(%esp)
80104e76:	e8 5f ff ff ff       	call   80104dda <memmove>
}
80104e7b:	c9                   	leave  
80104e7c:	c3                   	ret    

80104e7d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e7d:	55                   	push   %ebp
80104e7e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104e80:	eb 0c                	jmp    80104e8e <strncmp+0x11>
    n--, p++, q++;
80104e82:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104e8a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e92:	74 1a                	je     80104eae <strncmp+0x31>
80104e94:	8b 45 08             	mov    0x8(%ebp),%eax
80104e97:	0f b6 00             	movzbl (%eax),%eax
80104e9a:	84 c0                	test   %al,%al
80104e9c:	74 10                	je     80104eae <strncmp+0x31>
80104e9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea1:	0f b6 10             	movzbl (%eax),%edx
80104ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ea7:	0f b6 00             	movzbl (%eax),%eax
80104eaa:	38 c2                	cmp    %al,%dl
80104eac:	74 d4                	je     80104e82 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80104eae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104eb2:	75 07                	jne    80104ebb <strncmp+0x3e>
    return 0;
80104eb4:	b8 00 00 00 00       	mov    $0x0,%eax
80104eb9:	eb 16                	jmp    80104ed1 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebe:	0f b6 00             	movzbl (%eax),%eax
80104ec1:	0f b6 d0             	movzbl %al,%edx
80104ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec7:	0f b6 00             	movzbl (%eax),%eax
80104eca:	0f b6 c0             	movzbl %al,%eax
80104ecd:	29 c2                	sub    %eax,%edx
80104ecf:	89 d0                	mov    %edx,%eax
}
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret    

80104ed3 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ed3:	55                   	push   %ebp
80104ed4:	89 e5                	mov    %esp,%ebp
80104ed6:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80104edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104edf:	90                   	nop
80104ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80104ee3:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ee6:	89 55 10             	mov    %edx,0x10(%ebp)
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	7e 1e                	jle    80104f0b <strncpy+0x38>
80104eed:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef0:	8d 50 01             	lea    0x1(%eax),%edx
80104ef3:	89 55 08             	mov    %edx,0x8(%ebp)
80104ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ef9:	8d 4a 01             	lea    0x1(%edx),%ecx
80104efc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104eff:	0f b6 12             	movzbl (%edx),%edx
80104f02:	88 10                	mov    %dl,(%eax)
80104f04:	0f b6 00             	movzbl (%eax),%eax
80104f07:	84 c0                	test   %al,%al
80104f09:	75 d5                	jne    80104ee0 <strncpy+0xd>
    ;
  while(n-- > 0)
80104f0b:	eb 0c                	jmp    80104f19 <strncpy+0x46>
    *s++ = 0;
80104f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f10:	8d 50 01             	lea    0x1(%eax),%edx
80104f13:	89 55 08             	mov    %edx,0x8(%ebp)
80104f16:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104f19:	8b 45 10             	mov    0x10(%ebp),%eax
80104f1c:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f1f:	89 55 10             	mov    %edx,0x10(%ebp)
80104f22:	85 c0                	test   %eax,%eax
80104f24:	7f e7                	jg     80104f0d <strncpy+0x3a>
    *s++ = 0;
  return os;
80104f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f29:	c9                   	leave  
80104f2a:	c3                   	ret    

80104f2b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f2b:	55                   	push   %ebp
80104f2c:	89 e5                	mov    %esp,%ebp
80104f2e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104f31:	8b 45 08             	mov    0x8(%ebp),%eax
80104f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f3b:	7f 05                	jg     80104f42 <safestrcpy+0x17>
    return os;
80104f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f40:	eb 31                	jmp    80104f73 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80104f42:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f4a:	7e 1e                	jle    80104f6a <safestrcpy+0x3f>
80104f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4f:	8d 50 01             	lea    0x1(%eax),%edx
80104f52:	89 55 08             	mov    %edx,0x8(%ebp)
80104f55:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f58:	8d 4a 01             	lea    0x1(%edx),%ecx
80104f5b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104f5e:	0f b6 12             	movzbl (%edx),%edx
80104f61:	88 10                	mov    %dl,(%eax)
80104f63:	0f b6 00             	movzbl (%eax),%eax
80104f66:	84 c0                	test   %al,%al
80104f68:	75 d8                	jne    80104f42 <safestrcpy+0x17>
    ;
  *s = 0;
80104f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6d:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f73:	c9                   	leave  
80104f74:	c3                   	ret    

80104f75 <strlen>:

int
strlen(const char *s)
{
80104f75:	55                   	push   %ebp
80104f76:	89 e5                	mov    %esp,%ebp
80104f78:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104f7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104f82:	eb 04                	jmp    80104f88 <strlen+0x13>
80104f84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104f88:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8e:	01 d0                	add    %edx,%eax
80104f90:	0f b6 00             	movzbl (%eax),%eax
80104f93:	84 c0                	test   %al,%al
80104f95:	75 ed                	jne    80104f84 <strlen+0xf>
    ;
  return n;
80104f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f9a:	c9                   	leave  
80104f9b:	c3                   	ret    

80104f9c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f9c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fa0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104fa4:	55                   	push   %ebp
  pushl %ebx
80104fa5:	53                   	push   %ebx
  pushl %esi
80104fa6:	56                   	push   %esi
  pushl %edi
80104fa7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fa8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104faa:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104fac:	5f                   	pop    %edi
  popl %esi
80104fad:	5e                   	pop    %esi
  popl %ebx
80104fae:	5b                   	pop    %ebx
  popl %ebp
80104faf:	5d                   	pop    %ebp
  ret
80104fb0:	c3                   	ret    

80104fb1 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fb1:	55                   	push   %ebp
80104fb2:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104fb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fba:	8b 00                	mov    (%eax),%eax
80104fbc:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fbf:	76 12                	jbe    80104fd3 <fetchint+0x22>
80104fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc4:	8d 50 04             	lea    0x4(%eax),%edx
80104fc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fcd:	8b 00                	mov    (%eax),%eax
80104fcf:	39 c2                	cmp    %eax,%edx
80104fd1:	76 07                	jbe    80104fda <fetchint+0x29>
    return -1;
80104fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd8:	eb 0f                	jmp    80104fe9 <fetchint+0x38>
  *ip = *(int*)(addr);
80104fda:	8b 45 08             	mov    0x8(%ebp),%eax
80104fdd:	8b 10                	mov    (%eax),%edx
80104fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe2:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fe9:	5d                   	pop    %ebp
80104fea:	c3                   	ret    

80104feb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104feb:	55                   	push   %ebp
80104fec:	89 e5                	mov    %esp,%ebp
80104fee:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80104ff1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff7:	8b 00                	mov    (%eax),%eax
80104ff9:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ffc:	77 07                	ja     80105005 <fetchstr+0x1a>
    return -1;
80104ffe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105003:	eb 46                	jmp    8010504b <fetchstr+0x60>
  *pp = (char*)addr;
80105005:	8b 55 08             	mov    0x8(%ebp),%edx
80105008:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500b:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010500d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105013:	8b 00                	mov    (%eax),%eax
80105015:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105018:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501b:	8b 00                	mov    (%eax),%eax
8010501d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105020:	eb 1c                	jmp    8010503e <fetchstr+0x53>
    if(*s == 0)
80105022:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105025:	0f b6 00             	movzbl (%eax),%eax
80105028:	84 c0                	test   %al,%al
8010502a:	75 0e                	jne    8010503a <fetchstr+0x4f>
      return s - *pp;
8010502c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010502f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105032:	8b 00                	mov    (%eax),%eax
80105034:	29 c2                	sub    %eax,%edx
80105036:	89 d0                	mov    %edx,%eax
80105038:	eb 11                	jmp    8010504b <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010503a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010503e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105041:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105044:	72 dc                	jb     80105022 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010504b:	c9                   	leave  
8010504c:	c3                   	ret    

8010504d <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010504d:	55                   	push   %ebp
8010504e:	89 e5                	mov    %esp,%ebp
80105050:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105053:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105059:	8b 40 18             	mov    0x18(%eax),%eax
8010505c:	8b 50 44             	mov    0x44(%eax),%edx
8010505f:	8b 45 08             	mov    0x8(%ebp),%eax
80105062:	c1 e0 02             	shl    $0x2,%eax
80105065:	01 d0                	add    %edx,%eax
80105067:	8d 50 04             	lea    0x4(%eax),%edx
8010506a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105071:	89 14 24             	mov    %edx,(%esp)
80105074:	e8 38 ff ff ff       	call   80104fb1 <fetchint>
}
80105079:	c9                   	leave  
8010507a:	c3                   	ret    

8010507b <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010507b:	55                   	push   %ebp
8010507c:	89 e5                	mov    %esp,%ebp
8010507e:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105081:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105084:	89 44 24 04          	mov    %eax,0x4(%esp)
80105088:	8b 45 08             	mov    0x8(%ebp),%eax
8010508b:	89 04 24             	mov    %eax,(%esp)
8010508e:	e8 ba ff ff ff       	call   8010504d <argint>
80105093:	85 c0                	test   %eax,%eax
80105095:	79 07                	jns    8010509e <argptr+0x23>
    return -1;
80105097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509c:	eb 3d                	jmp    801050db <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010509e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050a1:	89 c2                	mov    %eax,%edx
801050a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a9:	8b 00                	mov    (%eax),%eax
801050ab:	39 c2                	cmp    %eax,%edx
801050ad:	73 16                	jae    801050c5 <argptr+0x4a>
801050af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b2:	89 c2                	mov    %eax,%edx
801050b4:	8b 45 10             	mov    0x10(%ebp),%eax
801050b7:	01 c2                	add    %eax,%edx
801050b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050bf:	8b 00                	mov    (%eax),%eax
801050c1:	39 c2                	cmp    %eax,%edx
801050c3:	76 07                	jbe    801050cc <argptr+0x51>
    return -1;
801050c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ca:	eb 0f                	jmp    801050db <argptr+0x60>
  *pp = (char*)i;
801050cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050cf:	89 c2                	mov    %eax,%edx
801050d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d4:	89 10                	mov    %edx,(%eax)
  return 0;
801050d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050db:	c9                   	leave  
801050dc:	c3                   	ret    

801050dd <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050dd:	55                   	push   %ebp
801050de:	89 e5                	mov    %esp,%ebp
801050e0:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050e3:	8d 45 fc             	lea    -0x4(%ebp),%eax
801050e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050ea:	8b 45 08             	mov    0x8(%ebp),%eax
801050ed:	89 04 24             	mov    %eax,(%esp)
801050f0:	e8 58 ff ff ff       	call   8010504d <argint>
801050f5:	85 c0                	test   %eax,%eax
801050f7:	79 07                	jns    80105100 <argstr+0x23>
    return -1;
801050f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fe:	eb 12                	jmp    80105112 <argstr+0x35>
  return fetchstr(addr, pp);
80105100:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105103:	8b 55 0c             	mov    0xc(%ebp),%edx
80105106:	89 54 24 04          	mov    %edx,0x4(%esp)
8010510a:	89 04 24             	mov    %eax,(%esp)
8010510d:	e8 d9 fe ff ff       	call   80104feb <fetchstr>
}
80105112:	c9                   	leave  
80105113:	c3                   	ret    

80105114 <syscall>:
[SYS_gettimeofday]  sys_gettimeofday, // LINEA AGREGADA
};

void
syscall(void)
{
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	53                   	push   %ebx
80105118:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010511b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105121:	8b 40 18             	mov    0x18(%eax),%eax
80105124:	8b 40 1c             	mov    0x1c(%eax),%eax
80105127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010512a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010512e:	7e 30                	jle    80105160 <syscall+0x4c>
80105130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105133:	83 f8 16             	cmp    $0x16,%eax
80105136:	77 28                	ja     80105160 <syscall+0x4c>
80105138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513b:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105142:	85 c0                	test   %eax,%eax
80105144:	74 1a                	je     80105160 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105146:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514c:	8b 58 18             	mov    0x18(%eax),%ebx
8010514f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105152:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105159:	ff d0                	call   *%eax
8010515b:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010515e:	eb 3d                	jmp    8010519d <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105160:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105166:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105169:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010516f:	8b 40 10             	mov    0x10(%eax),%eax
80105172:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105175:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105179:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010517d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105181:	c7 04 24 f7 86 10 80 	movl   $0x801086f7,(%esp)
80105188:	e8 13 b2 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010518d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105193:	8b 40 18             	mov    0x18(%eax),%eax
80105196:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010519d:	83 c4 24             	add    $0x24,%esp
801051a0:	5b                   	pop    %ebx
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret    

801051a3 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801051a3:	55                   	push   %ebp
801051a4:	89 e5                	mov    %esp,%ebp
801051a6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801051a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b0:	8b 45 08             	mov    0x8(%ebp),%eax
801051b3:	89 04 24             	mov    %eax,(%esp)
801051b6:	e8 92 fe ff ff       	call   8010504d <argint>
801051bb:	85 c0                	test   %eax,%eax
801051bd:	79 07                	jns    801051c6 <argfd+0x23>
    return -1;
801051bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c4:	eb 50                	jmp    80105216 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801051c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051c9:	85 c0                	test   %eax,%eax
801051cb:	78 21                	js     801051ee <argfd+0x4b>
801051cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d0:	83 f8 0f             	cmp    $0xf,%eax
801051d3:	7f 19                	jg     801051ee <argfd+0x4b>
801051d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051db:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051de:	83 c2 08             	add    $0x8,%edx
801051e1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801051e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051ec:	75 07                	jne    801051f5 <argfd+0x52>
    return -1;
801051ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f3:	eb 21                	jmp    80105216 <argfd+0x73>
  if(pfd)
801051f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801051f9:	74 08                	je     80105203 <argfd+0x60>
    *pfd = fd;
801051fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105201:	89 10                	mov    %edx,(%eax)
  if(pf)
80105203:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105207:	74 08                	je     80105211 <argfd+0x6e>
    *pf = f;
80105209:	8b 45 10             	mov    0x10(%ebp),%eax
8010520c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010520f:	89 10                	mov    %edx,(%eax)
  return 0;
80105211:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105216:	c9                   	leave  
80105217:	c3                   	ret    

80105218 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105218:	55                   	push   %ebp
80105219:	89 e5                	mov    %esp,%ebp
8010521b:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010521e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105225:	eb 30                	jmp    80105257 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105227:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105230:	83 c2 08             	add    $0x8,%edx
80105233:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105237:	85 c0                	test   %eax,%eax
80105239:	75 18                	jne    80105253 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010523b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105241:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105244:	8d 4a 08             	lea    0x8(%edx),%ecx
80105247:	8b 55 08             	mov    0x8(%ebp),%edx
8010524a:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010524e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105251:	eb 0f                	jmp    80105262 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105253:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105257:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010525b:	7e ca                	jle    80105227 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010525d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105262:	c9                   	leave  
80105263:	c3                   	ret    

80105264 <sys_dup>:

int
sys_dup(void)
{
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010526a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010526d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105271:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105278:	00 
80105279:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105280:	e8 1e ff ff ff       	call   801051a3 <argfd>
80105285:	85 c0                	test   %eax,%eax
80105287:	79 07                	jns    80105290 <sys_dup+0x2c>
    return -1;
80105289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528e:	eb 29                	jmp    801052b9 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105290:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105293:	89 04 24             	mov    %eax,(%esp)
80105296:	e8 7d ff ff ff       	call   80105218 <fdalloc>
8010529b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010529e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052a2:	79 07                	jns    801052ab <sys_dup+0x47>
    return -1;
801052a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a9:	eb 0e                	jmp    801052b9 <sys_dup+0x55>
  filedup(f);
801052ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ae:	89 04 24             	mov    %eax,(%esp)
801052b1:	e8 d0 bc ff ff       	call   80100f86 <filedup>
  return fd;
801052b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801052b9:	c9                   	leave  
801052ba:	c3                   	ret    

801052bb <sys_read>:

int
sys_read(void)
{
801052bb:	55                   	push   %ebp
801052bc:	89 e5                	mov    %esp,%ebp
801052be:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801052c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801052cf:	00 
801052d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052d7:	e8 c7 fe ff ff       	call   801051a3 <argfd>
801052dc:	85 c0                	test   %eax,%eax
801052de:	78 35                	js     80105315 <sys_read+0x5a>
801052e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801052ee:	e8 5a fd ff ff       	call   8010504d <argint>
801052f3:	85 c0                	test   %eax,%eax
801052f5:	78 1e                	js     80105315 <sys_read+0x5a>
801052f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801052fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105301:	89 44 24 04          	mov    %eax,0x4(%esp)
80105305:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010530c:	e8 6a fd ff ff       	call   8010507b <argptr>
80105311:	85 c0                	test   %eax,%eax
80105313:	79 07                	jns    8010531c <sys_read+0x61>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb 19                	jmp    80105335 <sys_read+0x7a>
  return fileread(f, p, n);
8010531c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010531f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105325:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105329:	89 54 24 04          	mov    %edx,0x4(%esp)
8010532d:	89 04 24             	mov    %eax,(%esp)
80105330:	e8 be bd ff ff       	call   801010f3 <fileread>
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    

80105337 <sys_write>:

int
sys_write(void)
{
80105337:	55                   	push   %ebp
80105338:	89 e5                	mov    %esp,%ebp
8010533a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010533d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105340:	89 44 24 08          	mov    %eax,0x8(%esp)
80105344:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010534b:	00 
8010534c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105353:	e8 4b fe ff ff       	call   801051a3 <argfd>
80105358:	85 c0                	test   %eax,%eax
8010535a:	78 35                	js     80105391 <sys_write+0x5a>
8010535c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010535f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105363:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010536a:	e8 de fc ff ff       	call   8010504d <argint>
8010536f:	85 c0                	test   %eax,%eax
80105371:	78 1e                	js     80105391 <sys_write+0x5a>
80105373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105376:	89 44 24 08          	mov    %eax,0x8(%esp)
8010537a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010537d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105388:	e8 ee fc ff ff       	call   8010507b <argptr>
8010538d:	85 c0                	test   %eax,%eax
8010538f:	79 07                	jns    80105398 <sys_write+0x61>
    return -1;
80105391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105396:	eb 19                	jmp    801053b1 <sys_write+0x7a>
  return filewrite(f, p, n);
80105398:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010539b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010539e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053a5:	89 54 24 04          	mov    %edx,0x4(%esp)
801053a9:	89 04 24             	mov    %eax,(%esp)
801053ac:	e8 fe bd ff ff       	call   801011af <filewrite>
}
801053b1:	c9                   	leave  
801053b2:	c3                   	ret    

801053b3 <sys_close>:

int
sys_close(void)
{
801053b3:	55                   	push   %ebp
801053b4:	89 e5                	mov    %esp,%ebp
801053b6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801053b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801053c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053ce:	e8 d0 fd ff ff       	call   801051a3 <argfd>
801053d3:	85 c0                	test   %eax,%eax
801053d5:	79 07                	jns    801053de <sys_close+0x2b>
    return -1;
801053d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dc:	eb 24                	jmp    80105402 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801053de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053e7:	83 c2 08             	add    $0x8,%edx
801053ea:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801053f1:	00 
  fileclose(f);
801053f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f5:	89 04 24             	mov    %eax,(%esp)
801053f8:	e8 d1 bb ff ff       	call   80100fce <fileclose>
  return 0;
801053fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105402:	c9                   	leave  
80105403:	c3                   	ret    

80105404 <sys_fstat>:

int
sys_fstat(void)
{
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010540a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105411:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105418:	00 
80105419:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105420:	e8 7e fd ff ff       	call   801051a3 <argfd>
80105425:	85 c0                	test   %eax,%eax
80105427:	78 1f                	js     80105448 <sys_fstat+0x44>
80105429:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105430:	00 
80105431:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105434:	89 44 24 04          	mov    %eax,0x4(%esp)
80105438:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010543f:	e8 37 fc ff ff       	call   8010507b <argptr>
80105444:	85 c0                	test   %eax,%eax
80105446:	79 07                	jns    8010544f <sys_fstat+0x4b>
    return -1;
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544d:	eb 12                	jmp    80105461 <sys_fstat+0x5d>
  return filestat(f, st);
8010544f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105455:	89 54 24 04          	mov    %edx,0x4(%esp)
80105459:	89 04 24             	mov    %eax,(%esp)
8010545c:	e8 43 bc ff ff       	call   801010a4 <filestat>
}
80105461:	c9                   	leave  
80105462:	c3                   	ret    

80105463 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105463:	55                   	push   %ebp
80105464:	89 e5                	mov    %esp,%ebp
80105466:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105469:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010546c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105477:	e8 61 fc ff ff       	call   801050dd <argstr>
8010547c:	85 c0                	test   %eax,%eax
8010547e:	78 17                	js     80105497 <sys_link+0x34>
80105480:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105483:	89 44 24 04          	mov    %eax,0x4(%esp)
80105487:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010548e:	e8 4a fc ff ff       	call   801050dd <argstr>
80105493:	85 c0                	test   %eax,%eax
80105495:	79 0a                	jns    801054a1 <sys_link+0x3e>
    return -1;
80105497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549c:	e9 42 01 00 00       	jmp    801055e3 <sys_link+0x180>

  begin_trans();
801054a1:	e8 3f dd ff ff       	call   801031e5 <begin_trans>
  if((ip = namei(old)) == 0){
801054a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801054a9:	89 04 24             	mov    %eax,(%esp)
801054ac:	e8 55 cf ff ff       	call   80102406 <namei>
801054b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054b8:	75 0f                	jne    801054c9 <sys_link+0x66>
    commit_trans();
801054ba:	e8 6f dd ff ff       	call   8010322e <commit_trans>
    return -1;
801054bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c4:	e9 1a 01 00 00       	jmp    801055e3 <sys_link+0x180>
  }

  ilock(ip);
801054c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054cc:	89 04 24             	mov    %eax,(%esp)
801054cf:	e8 87 c3 ff ff       	call   8010185b <ilock>
  if(ip->type == T_DIR){
801054d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801054db:	66 83 f8 01          	cmp    $0x1,%ax
801054df:	75 1a                	jne    801054fb <sys_link+0x98>
    iunlockput(ip);
801054e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e4:	89 04 24             	mov    %eax,(%esp)
801054e7:	e8 f3 c5 ff ff       	call   80101adf <iunlockput>
    commit_trans();
801054ec:	e8 3d dd ff ff       	call   8010322e <commit_trans>
    return -1;
801054f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f6:	e9 e8 00 00 00       	jmp    801055e3 <sys_link+0x180>
  }

  ip->nlink++;
801054fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054fe:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105502:	8d 50 01             	lea    0x1(%eax),%edx
80105505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105508:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010550c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550f:	89 04 24             	mov    %eax,(%esp)
80105512:	e8 88 c1 ff ff       	call   8010169f <iupdate>
  iunlock(ip);
80105517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551a:	89 04 24             	mov    %eax,(%esp)
8010551d:	e8 87 c4 ff ff       	call   801019a9 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105522:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105525:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105528:	89 54 24 04          	mov    %edx,0x4(%esp)
8010552c:	89 04 24             	mov    %eax,(%esp)
8010552f:	e8 f4 ce ff ff       	call   80102428 <nameiparent>
80105534:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105537:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010553b:	75 02                	jne    8010553f <sys_link+0xdc>
    goto bad;
8010553d:	eb 68                	jmp    801055a7 <sys_link+0x144>
  ilock(dp);
8010553f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105542:	89 04 24             	mov    %eax,(%esp)
80105545:	e8 11 c3 ff ff       	call   8010185b <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010554a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010554d:	8b 10                	mov    (%eax),%edx
8010554f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105552:	8b 00                	mov    (%eax),%eax
80105554:	39 c2                	cmp    %eax,%edx
80105556:	75 20                	jne    80105578 <sys_link+0x115>
80105558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555b:	8b 40 04             	mov    0x4(%eax),%eax
8010555e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105562:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105565:	89 44 24 04          	mov    %eax,0x4(%esp)
80105569:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010556c:	89 04 24             	mov    %eax,(%esp)
8010556f:	e8 d2 cb ff ff       	call   80102146 <dirlink>
80105574:	85 c0                	test   %eax,%eax
80105576:	79 0d                	jns    80105585 <sys_link+0x122>
    iunlockput(dp);
80105578:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010557b:	89 04 24             	mov    %eax,(%esp)
8010557e:	e8 5c c5 ff ff       	call   80101adf <iunlockput>
    goto bad;
80105583:	eb 22                	jmp    801055a7 <sys_link+0x144>
  }
  iunlockput(dp);
80105585:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105588:	89 04 24             	mov    %eax,(%esp)
8010558b:	e8 4f c5 ff ff       	call   80101adf <iunlockput>
  iput(ip);
80105590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105593:	89 04 24             	mov    %eax,(%esp)
80105596:	e8 73 c4 ff ff       	call   80101a0e <iput>

  commit_trans();
8010559b:	e8 8e dc ff ff       	call   8010322e <commit_trans>

  return 0;
801055a0:	b8 00 00 00 00       	mov    $0x0,%eax
801055a5:	eb 3c                	jmp    801055e3 <sys_link+0x180>

bad:
  ilock(ip);
801055a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055aa:	89 04 24             	mov    %eax,(%esp)
801055ad:	e8 a9 c2 ff ff       	call   8010185b <ilock>
  ip->nlink--;
801055b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801055b9:	8d 50 ff             	lea    -0x1(%eax),%edx
801055bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055bf:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801055c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c6:	89 04 24             	mov    %eax,(%esp)
801055c9:	e8 d1 c0 ff ff       	call   8010169f <iupdate>
  iunlockput(ip);
801055ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d1:	89 04 24             	mov    %eax,(%esp)
801055d4:	e8 06 c5 ff ff       	call   80101adf <iunlockput>
  commit_trans();
801055d9:	e8 50 dc ff ff       	call   8010322e <commit_trans>
  return -1;
801055de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e3:	c9                   	leave  
801055e4:	c3                   	ret    

801055e5 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801055e5:	55                   	push   %ebp
801055e6:	89 e5                	mov    %esp,%ebp
801055e8:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055eb:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801055f2:	eb 4b                	jmp    8010563f <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f7:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801055fe:	00 
801055ff:	89 44 24 08          	mov    %eax,0x8(%esp)
80105603:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105606:	89 44 24 04          	mov    %eax,0x4(%esp)
8010560a:	8b 45 08             	mov    0x8(%ebp),%eax
8010560d:	89 04 24             	mov    %eax,(%esp)
80105610:	e8 53 c7 ff ff       	call   80101d68 <readi>
80105615:	83 f8 10             	cmp    $0x10,%eax
80105618:	74 0c                	je     80105626 <isdirempty+0x41>
      panic("isdirempty: readi");
8010561a:	c7 04 24 13 87 10 80 	movl   $0x80108713,(%esp)
80105621:	e8 14 af ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105626:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010562a:	66 85 c0             	test   %ax,%ax
8010562d:	74 07                	je     80105636 <isdirempty+0x51>
      return 0;
8010562f:	b8 00 00 00 00       	mov    $0x0,%eax
80105634:	eb 1b                	jmp    80105651 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105639:	83 c0 10             	add    $0x10,%eax
8010563c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010563f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105642:	8b 45 08             	mov    0x8(%ebp),%eax
80105645:	8b 40 18             	mov    0x18(%eax),%eax
80105648:	39 c2                	cmp    %eax,%edx
8010564a:	72 a8                	jb     801055f4 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010564c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105651:	c9                   	leave  
80105652:	c3                   	ret    

80105653 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105653:	55                   	push   %ebp
80105654:	89 e5                	mov    %esp,%ebp
80105656:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105659:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010565c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105667:	e8 71 fa ff ff       	call   801050dd <argstr>
8010566c:	85 c0                	test   %eax,%eax
8010566e:	79 0a                	jns    8010567a <sys_unlink+0x27>
    return -1;
80105670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105675:	e9 af 01 00 00       	jmp    80105829 <sys_unlink+0x1d6>

  begin_trans();
8010567a:	e8 66 db ff ff       	call   801031e5 <begin_trans>
  if((dp = nameiparent(path, name)) == 0){
8010567f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105682:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105685:	89 54 24 04          	mov    %edx,0x4(%esp)
80105689:	89 04 24             	mov    %eax,(%esp)
8010568c:	e8 97 cd ff ff       	call   80102428 <nameiparent>
80105691:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105698:	75 0f                	jne    801056a9 <sys_unlink+0x56>
    commit_trans();
8010569a:	e8 8f db ff ff       	call   8010322e <commit_trans>
    return -1;
8010569f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a4:	e9 80 01 00 00       	jmp    80105829 <sys_unlink+0x1d6>
  }

  ilock(dp);
801056a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ac:	89 04 24             	mov    %eax,(%esp)
801056af:	e8 a7 c1 ff ff       	call   8010185b <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056b4:	c7 44 24 04 25 87 10 	movl   $0x80108725,0x4(%esp)
801056bb:	80 
801056bc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801056bf:	89 04 24             	mov    %eax,(%esp)
801056c2:	e8 94 c9 ff ff       	call   8010205b <namecmp>
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 84 45 01 00 00    	je     80105814 <sys_unlink+0x1c1>
801056cf:	c7 44 24 04 27 87 10 	movl   $0x80108727,0x4(%esp)
801056d6:	80 
801056d7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801056da:	89 04 24             	mov    %eax,(%esp)
801056dd:	e8 79 c9 ff ff       	call   8010205b <namecmp>
801056e2:	85 c0                	test   %eax,%eax
801056e4:	0f 84 2a 01 00 00    	je     80105814 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801056ea:	8d 45 c8             	lea    -0x38(%ebp),%eax
801056ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801056f1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801056f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801056f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fb:	89 04 24             	mov    %eax,(%esp)
801056fe:	e8 7a c9 ff ff       	call   8010207d <dirlookup>
80105703:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010570a:	75 05                	jne    80105711 <sys_unlink+0xbe>
    goto bad;
8010570c:	e9 03 01 00 00       	jmp    80105814 <sys_unlink+0x1c1>
  ilock(ip);
80105711:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105714:	89 04 24             	mov    %eax,(%esp)
80105717:	e8 3f c1 ff ff       	call   8010185b <ilock>

  if(ip->nlink < 1)
8010571c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010571f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105723:	66 85 c0             	test   %ax,%ax
80105726:	7f 0c                	jg     80105734 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105728:	c7 04 24 2a 87 10 80 	movl   $0x8010872a,(%esp)
8010572f:	e8 06 ae ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105737:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010573b:	66 83 f8 01          	cmp    $0x1,%ax
8010573f:	75 1f                	jne    80105760 <sys_unlink+0x10d>
80105741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105744:	89 04 24             	mov    %eax,(%esp)
80105747:	e8 99 fe ff ff       	call   801055e5 <isdirempty>
8010574c:	85 c0                	test   %eax,%eax
8010574e:	75 10                	jne    80105760 <sys_unlink+0x10d>
    iunlockput(ip);
80105750:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105753:	89 04 24             	mov    %eax,(%esp)
80105756:	e8 84 c3 ff ff       	call   80101adf <iunlockput>
    goto bad;
8010575b:	e9 b4 00 00 00       	jmp    80105814 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105760:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105767:	00 
80105768:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010576f:	00 
80105770:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105773:	89 04 24             	mov    %eax,(%esp)
80105776:	e8 90 f5 ff ff       	call   80104d0b <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010577b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010577e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105785:	00 
80105786:	89 44 24 08          	mov    %eax,0x8(%esp)
8010578a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010578d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105794:	89 04 24             	mov    %eax,(%esp)
80105797:	e8 30 c7 ff ff       	call   80101ecc <writei>
8010579c:	83 f8 10             	cmp    $0x10,%eax
8010579f:	74 0c                	je     801057ad <sys_unlink+0x15a>
    panic("unlink: writei");
801057a1:	c7 04 24 3c 87 10 80 	movl   $0x8010873c,(%esp)
801057a8:	e8 8d ad ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
801057ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801057b4:	66 83 f8 01          	cmp    $0x1,%ax
801057b8:	75 1c                	jne    801057d6 <sys_unlink+0x183>
    dp->nlink--;
801057ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057bd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801057c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801057c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801057cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ce:	89 04 24             	mov    %eax,(%esp)
801057d1:	e8 c9 be ff ff       	call   8010169f <iupdate>
  }
  iunlockput(dp);
801057d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d9:	89 04 24             	mov    %eax,(%esp)
801057dc:	e8 fe c2 ff ff       	call   80101adf <iunlockput>

  ip->nlink--;
801057e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801057e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801057eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ee:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801057f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f5:	89 04 24             	mov    %eax,(%esp)
801057f8:	e8 a2 be ff ff       	call   8010169f <iupdate>
  iunlockput(ip);
801057fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105800:	89 04 24             	mov    %eax,(%esp)
80105803:	e8 d7 c2 ff ff       	call   80101adf <iunlockput>

  commit_trans();
80105808:	e8 21 da ff ff       	call   8010322e <commit_trans>

  return 0;
8010580d:	b8 00 00 00 00       	mov    $0x0,%eax
80105812:	eb 15                	jmp    80105829 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105817:	89 04 24             	mov    %eax,(%esp)
8010581a:	e8 c0 c2 ff ff       	call   80101adf <iunlockput>
  commit_trans();
8010581f:	e8 0a da ff ff       	call   8010322e <commit_trans>
  return -1;
80105824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105829:	c9                   	leave  
8010582a:	c3                   	ret    

8010582b <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010582b:	55                   	push   %ebp
8010582c:	89 e5                	mov    %esp,%ebp
8010582e:	83 ec 48             	sub    $0x48,%esp
80105831:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105834:	8b 55 10             	mov    0x10(%ebp),%edx
80105837:	8b 45 14             	mov    0x14(%ebp),%eax
8010583a:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010583e:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105842:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105846:	8d 45 de             	lea    -0x22(%ebp),%eax
80105849:	89 44 24 04          	mov    %eax,0x4(%esp)
8010584d:	8b 45 08             	mov    0x8(%ebp),%eax
80105850:	89 04 24             	mov    %eax,(%esp)
80105853:	e8 d0 cb ff ff       	call   80102428 <nameiparent>
80105858:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010585b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010585f:	75 0a                	jne    8010586b <create+0x40>
    return 0;
80105861:	b8 00 00 00 00       	mov    $0x0,%eax
80105866:	e9 7e 01 00 00       	jmp    801059e9 <create+0x1be>
  ilock(dp);
8010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586e:	89 04 24             	mov    %eax,(%esp)
80105871:	e8 e5 bf ff ff       	call   8010185b <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105876:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105879:	89 44 24 08          	mov    %eax,0x8(%esp)
8010587d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105880:	89 44 24 04          	mov    %eax,0x4(%esp)
80105884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105887:	89 04 24             	mov    %eax,(%esp)
8010588a:	e8 ee c7 ff ff       	call   8010207d <dirlookup>
8010588f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105892:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105896:	74 47                	je     801058df <create+0xb4>
    iunlockput(dp);
80105898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589b:	89 04 24             	mov    %eax,(%esp)
8010589e:	e8 3c c2 ff ff       	call   80101adf <iunlockput>
    ilock(ip);
801058a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a6:	89 04 24             	mov    %eax,(%esp)
801058a9:	e8 ad bf ff ff       	call   8010185b <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801058ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801058b3:	75 15                	jne    801058ca <create+0x9f>
801058b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801058bc:	66 83 f8 02          	cmp    $0x2,%ax
801058c0:	75 08                	jne    801058ca <create+0x9f>
      return ip;
801058c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c5:	e9 1f 01 00 00       	jmp    801059e9 <create+0x1be>
    iunlockput(ip);
801058ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058cd:	89 04 24             	mov    %eax,(%esp)
801058d0:	e8 0a c2 ff ff       	call   80101adf <iunlockput>
    return 0;
801058d5:	b8 00 00 00 00       	mov    $0x0,%eax
801058da:	e9 0a 01 00 00       	jmp    801059e9 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801058df:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801058e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e6:	8b 00                	mov    (%eax),%eax
801058e8:	89 54 24 04          	mov    %edx,0x4(%esp)
801058ec:	89 04 24             	mov    %eax,(%esp)
801058ef:	e8 cc bc ff ff       	call   801015c0 <ialloc>
801058f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058fb:	75 0c                	jne    80105909 <create+0xde>
    panic("create: ialloc");
801058fd:	c7 04 24 4b 87 10 80 	movl   $0x8010874b,(%esp)
80105904:	e8 31 ac ff ff       	call   8010053a <panic>

  ilock(ip);
80105909:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010590c:	89 04 24             	mov    %eax,(%esp)
8010590f:	e8 47 bf ff ff       	call   8010185b <ilock>
  ip->major = major;
80105914:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105917:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010591b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010591f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105922:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105926:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010592a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010592d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105936:	89 04 24             	mov    %eax,(%esp)
80105939:	e8 61 bd ff ff       	call   8010169f <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010593e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105943:	75 6a                	jne    801059af <create+0x184>
    dp->nlink++;  // for ".."
80105945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105948:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010594c:	8d 50 01             	lea    0x1(%eax),%edx
8010594f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105952:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105959:	89 04 24             	mov    %eax,(%esp)
8010595c:	e8 3e bd ff ff       	call   8010169f <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105964:	8b 40 04             	mov    0x4(%eax),%eax
80105967:	89 44 24 08          	mov    %eax,0x8(%esp)
8010596b:	c7 44 24 04 25 87 10 	movl   $0x80108725,0x4(%esp)
80105972:	80 
80105973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105976:	89 04 24             	mov    %eax,(%esp)
80105979:	e8 c8 c7 ff ff       	call   80102146 <dirlink>
8010597e:	85 c0                	test   %eax,%eax
80105980:	78 21                	js     801059a3 <create+0x178>
80105982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105985:	8b 40 04             	mov    0x4(%eax),%eax
80105988:	89 44 24 08          	mov    %eax,0x8(%esp)
8010598c:	c7 44 24 04 27 87 10 	movl   $0x80108727,0x4(%esp)
80105993:	80 
80105994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105997:	89 04 24             	mov    %eax,(%esp)
8010599a:	e8 a7 c7 ff ff       	call   80102146 <dirlink>
8010599f:	85 c0                	test   %eax,%eax
801059a1:	79 0c                	jns    801059af <create+0x184>
      panic("create dots");
801059a3:	c7 04 24 5a 87 10 80 	movl   $0x8010875a,(%esp)
801059aa:	e8 8b ab ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801059af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b2:	8b 40 04             	mov    0x4(%eax),%eax
801059b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801059b9:	8d 45 de             	lea    -0x22(%ebp),%eax
801059bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c3:	89 04 24             	mov    %eax,(%esp)
801059c6:	e8 7b c7 ff ff       	call   80102146 <dirlink>
801059cb:	85 c0                	test   %eax,%eax
801059cd:	79 0c                	jns    801059db <create+0x1b0>
    panic("create: dirlink");
801059cf:	c7 04 24 66 87 10 80 	movl   $0x80108766,(%esp)
801059d6:	e8 5f ab ff ff       	call   8010053a <panic>

  iunlockput(dp);
801059db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059de:	89 04 24             	mov    %eax,(%esp)
801059e1:	e8 f9 c0 ff ff       	call   80101adf <iunlockput>

  return ip;
801059e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801059e9:	c9                   	leave  
801059ea:	c3                   	ret    

801059eb <sys_open>:

int
sys_open(void)
{
801059eb:	55                   	push   %ebp
801059ec:	89 e5                	mov    %esp,%ebp
801059ee:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059f1:	8d 45 e8             	lea    -0x18(%ebp),%eax
801059f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801059f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059ff:	e8 d9 f6 ff ff       	call   801050dd <argstr>
80105a04:	85 c0                	test   %eax,%eax
80105a06:	78 17                	js     80105a1f <sys_open+0x34>
80105a08:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a16:	e8 32 f6 ff ff       	call   8010504d <argint>
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	79 0a                	jns    80105a29 <sys_open+0x3e>
    return -1;
80105a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a24:	e9 5c 01 00 00       	jmp    80105b85 <sys_open+0x19a>

  begin_trans();
80105a29:	e8 b7 d7 ff ff       	call   801031e5 <begin_trans>

  if(omode & O_CREATE){
80105a2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a31:	25 00 02 00 00       	and    $0x200,%eax
80105a36:	85 c0                	test   %eax,%eax
80105a38:	74 3b                	je     80105a75 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105a3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a3d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105a44:	00 
80105a45:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105a4c:	00 
80105a4d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105a54:	00 
80105a55:	89 04 24             	mov    %eax,(%esp)
80105a58:	e8 ce fd ff ff       	call   8010582b <create>
80105a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a64:	75 6b                	jne    80105ad1 <sys_open+0xe6>
      commit_trans();
80105a66:	e8 c3 d7 ff ff       	call   8010322e <commit_trans>
      return -1;
80105a6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a70:	e9 10 01 00 00       	jmp    80105b85 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80105a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a78:	89 04 24             	mov    %eax,(%esp)
80105a7b:	e8 86 c9 ff ff       	call   80102406 <namei>
80105a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a87:	75 0f                	jne    80105a98 <sys_open+0xad>
      commit_trans();
80105a89:	e8 a0 d7 ff ff       	call   8010322e <commit_trans>
      return -1;
80105a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a93:	e9 ed 00 00 00       	jmp    80105b85 <sys_open+0x19a>
    }
    ilock(ip);
80105a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9b:	89 04 24             	mov    %eax,(%esp)
80105a9e:	e8 b8 bd ff ff       	call   8010185b <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105aaa:	66 83 f8 01          	cmp    $0x1,%ax
80105aae:	75 21                	jne    80105ad1 <sys_open+0xe6>
80105ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	74 1a                	je     80105ad1 <sys_open+0xe6>
      iunlockput(ip);
80105ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aba:	89 04 24             	mov    %eax,(%esp)
80105abd:	e8 1d c0 ff ff       	call   80101adf <iunlockput>
      commit_trans();
80105ac2:	e8 67 d7 ff ff       	call   8010322e <commit_trans>
      return -1;
80105ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acc:	e9 b4 00 00 00       	jmp    80105b85 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ad1:	e8 50 b4 ff ff       	call   80100f26 <filealloc>
80105ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ad9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105add:	74 14                	je     80105af3 <sys_open+0x108>
80105adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae2:	89 04 24             	mov    %eax,(%esp)
80105ae5:	e8 2e f7 ff ff       	call   80105218 <fdalloc>
80105aea:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105af1:	79 28                	jns    80105b1b <sys_open+0x130>
    if(f)
80105af3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105af7:	74 0b                	je     80105b04 <sys_open+0x119>
      fileclose(f);
80105af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afc:	89 04 24             	mov    %eax,(%esp)
80105aff:	e8 ca b4 ff ff       	call   80100fce <fileclose>
    iunlockput(ip);
80105b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b07:	89 04 24             	mov    %eax,(%esp)
80105b0a:	e8 d0 bf ff ff       	call   80101adf <iunlockput>
    commit_trans();
80105b0f:	e8 1a d7 ff ff       	call   8010322e <commit_trans>
    return -1;
80105b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b19:	eb 6a                	jmp    80105b85 <sys_open+0x19a>
  }
  iunlock(ip);
80105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1e:	89 04 24             	mov    %eax,(%esp)
80105b21:	e8 83 be ff ff       	call   801019a9 <iunlock>
  commit_trans();
80105b26:	e8 03 d7 ff ff       	call   8010322e <commit_trans>

  f->type = FD_INODE;
80105b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b3a:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b40:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b4a:	83 e0 01             	and    $0x1,%eax
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	0f 94 c0             	sete   %al
80105b52:	89 c2                	mov    %eax,%edx
80105b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b57:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b5d:	83 e0 01             	and    $0x1,%eax
80105b60:	85 c0                	test   %eax,%eax
80105b62:	75 0a                	jne    80105b6e <sys_open+0x183>
80105b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b67:	83 e0 02             	and    $0x2,%eax
80105b6a:	85 c0                	test   %eax,%eax
80105b6c:	74 07                	je     80105b75 <sys_open+0x18a>
80105b6e:	b8 01 00 00 00       	mov    $0x1,%eax
80105b73:	eb 05                	jmp    80105b7a <sys_open+0x18f>
80105b75:	b8 00 00 00 00       	mov    $0x0,%eax
80105b7a:	89 c2                	mov    %eax,%edx
80105b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7f:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    

80105b87 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b87:	55                   	push   %ebp
80105b88:	89 e5                	mov    %esp,%ebp
80105b8a:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105b8d:	e8 53 d6 ff ff       	call   801031e5 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b92:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b95:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ba0:	e8 38 f5 ff ff       	call   801050dd <argstr>
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 2c                	js     80105bd5 <sys_mkdir+0x4e>
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105bb3:	00 
80105bb4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105bbb:	00 
80105bbc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105bc3:	00 
80105bc4:	89 04 24             	mov    %eax,(%esp)
80105bc7:	e8 5f fc ff ff       	call   8010582b <create>
80105bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bd3:	75 0c                	jne    80105be1 <sys_mkdir+0x5a>
    commit_trans();
80105bd5:	e8 54 d6 ff ff       	call   8010322e <commit_trans>
    return -1;
80105bda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bdf:	eb 15                	jmp    80105bf6 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be4:	89 04 24             	mov    %eax,(%esp)
80105be7:	e8 f3 be ff ff       	call   80101adf <iunlockput>
  commit_trans();
80105bec:	e8 3d d6 ff ff       	call   8010322e <commit_trans>
  return 0;
80105bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bf6:	c9                   	leave  
80105bf7:	c3                   	ret    

80105bf8 <sys_mknod>:

int
sys_mknod(void)
{
80105bf8:	55                   	push   %ebp
80105bf9:	89 e5                	mov    %esp,%ebp
80105bfb:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105bfe:	e8 e2 d5 ff ff       	call   801031e5 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c06:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c11:	e8 c7 f4 ff ff       	call   801050dd <argstr>
80105c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c1d:	78 5e                	js     80105c7d <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105c1f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c2d:	e8 1b f4 ff ff       	call   8010504d <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105c32:	85 c0                	test   %eax,%eax
80105c34:	78 47                	js     80105c7d <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105c36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c39:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c3d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105c44:	e8 04 f4 ff ff       	call   8010504d <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	78 30                	js     80105c7d <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c50:	0f bf c8             	movswl %ax,%ecx
80105c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c56:	0f bf d0             	movswl %ax,%edx
80105c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105c5c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105c60:	89 54 24 08          	mov    %edx,0x8(%esp)
80105c64:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105c6b:	00 
80105c6c:	89 04 24             	mov    %eax,(%esp)
80105c6f:	e8 b7 fb ff ff       	call   8010582b <create>
80105c74:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c7b:	75 0c                	jne    80105c89 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105c7d:	e8 ac d5 ff ff       	call   8010322e <commit_trans>
    return -1;
80105c82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c87:	eb 15                	jmp    80105c9e <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8c:	89 04 24             	mov    %eax,(%esp)
80105c8f:	e8 4b be ff ff       	call   80101adf <iunlockput>
  commit_trans();
80105c94:	e8 95 d5 ff ff       	call   8010322e <commit_trans>
  return 0;
80105c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c9e:	c9                   	leave  
80105c9f:	c3                   	ret    

80105ca0 <sys_chdir>:

int
sys_chdir(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105ca6:	e8 3a d5 ff ff       	call   801031e5 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cab:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cb9:	e8 1f f4 ff ff       	call   801050dd <argstr>
80105cbe:	85 c0                	test   %eax,%eax
80105cc0:	78 14                	js     80105cd6 <sys_chdir+0x36>
80105cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc5:	89 04 24             	mov    %eax,(%esp)
80105cc8:	e8 39 c7 ff ff       	call   80102406 <namei>
80105ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cd4:	75 0c                	jne    80105ce2 <sys_chdir+0x42>
    commit_trans();
80105cd6:	e8 53 d5 ff ff       	call   8010322e <commit_trans>
    return -1;
80105cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce0:	eb 61                	jmp    80105d43 <sys_chdir+0xa3>
  }
  ilock(ip);
80105ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce5:	89 04 24             	mov    %eax,(%esp)
80105ce8:	e8 6e bb ff ff       	call   8010185b <ilock>
  if(ip->type != T_DIR){
80105ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cf4:	66 83 f8 01          	cmp    $0x1,%ax
80105cf8:	74 17                	je     80105d11 <sys_chdir+0x71>
    iunlockput(ip);
80105cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfd:	89 04 24             	mov    %eax,(%esp)
80105d00:	e8 da bd ff ff       	call   80101adf <iunlockput>
    commit_trans();
80105d05:	e8 24 d5 ff ff       	call   8010322e <commit_trans>
    return -1;
80105d0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0f:	eb 32                	jmp    80105d43 <sys_chdir+0xa3>
  }
  iunlock(ip);
80105d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d14:	89 04 24             	mov    %eax,(%esp)
80105d17:	e8 8d bc ff ff       	call   801019a9 <iunlock>
  iput(proc->cwd);
80105d1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d22:	8b 40 68             	mov    0x68(%eax),%eax
80105d25:	89 04 24             	mov    %eax,(%esp)
80105d28:	e8 e1 bc ff ff       	call   80101a0e <iput>
  commit_trans();
80105d2d:	e8 fc d4 ff ff       	call   8010322e <commit_trans>
  proc->cwd = ip;
80105d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d3b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d43:	c9                   	leave  
80105d44:	c3                   	ret    

80105d45 <sys_exec>:

int
sys_exec(void)
{
80105d45:	55                   	push   %ebp
80105d46:	89 e5                	mov    %esp,%ebp
80105d48:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d51:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d5c:	e8 7c f3 ff ff       	call   801050dd <argstr>
80105d61:	85 c0                	test   %eax,%eax
80105d63:	78 1a                	js     80105d7f <sys_exec+0x3a>
80105d65:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d76:	e8 d2 f2 ff ff       	call   8010504d <argint>
80105d7b:	85 c0                	test   %eax,%eax
80105d7d:	79 0a                	jns    80105d89 <sys_exec+0x44>
    return -1;
80105d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d84:	e9 c8 00 00 00       	jmp    80105e51 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80105d89:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105d90:	00 
80105d91:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d98:	00 
80105d99:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105d9f:	89 04 24             	mov    %eax,(%esp)
80105da2:	e8 64 ef ff ff       	call   80104d0b <memset>
  for(i=0;; i++){
80105da7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db1:	83 f8 1f             	cmp    $0x1f,%eax
80105db4:	76 0a                	jbe    80105dc0 <sys_exec+0x7b>
      return -1;
80105db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbb:	e9 91 00 00 00       	jmp    80105e51 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc3:	c1 e0 02             	shl    $0x2,%eax
80105dc6:	89 c2                	mov    %eax,%edx
80105dc8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105dce:	01 c2                	add    %eax,%edx
80105dd0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dda:	89 14 24             	mov    %edx,(%esp)
80105ddd:	e8 cf f1 ff ff       	call   80104fb1 <fetchint>
80105de2:	85 c0                	test   %eax,%eax
80105de4:	79 07                	jns    80105ded <sys_exec+0xa8>
      return -1;
80105de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105deb:	eb 64                	jmp    80105e51 <sys_exec+0x10c>
    if(uarg == 0){
80105ded:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105df3:	85 c0                	test   %eax,%eax
80105df5:	75 26                	jne    80105e1d <sys_exec+0xd8>
      argv[i] = 0;
80105df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfa:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105e01:	00 00 00 00 
      break;
80105e05:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e09:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105e0f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e13:	89 04 24             	mov    %eax,(%esp)
80105e16:	e8 d4 ac ff ff       	call   80100aef <exec>
80105e1b:	eb 34                	jmp    80105e51 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e1d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e26:	c1 e2 02             	shl    $0x2,%edx
80105e29:	01 c2                	add    %eax,%edx
80105e2b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e31:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e35:	89 04 24             	mov    %eax,(%esp)
80105e38:	e8 ae f1 ff ff       	call   80104feb <fetchstr>
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	79 07                	jns    80105e48 <sys_exec+0x103>
      return -1;
80105e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e46:	eb 09                	jmp    80105e51 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105e48:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105e4c:	e9 5d ff ff ff       	jmp    80105dae <sys_exec+0x69>
  return exec(path, argv);
}
80105e51:	c9                   	leave  
80105e52:	c3                   	ret    

80105e53 <sys_pipe>:

int
sys_pipe(void)
{
80105e53:	55                   	push   %ebp
80105e54:	89 e5                	mov    %esp,%ebp
80105e56:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e59:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105e60:	00 
80105e61:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e64:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e6f:	e8 07 f2 ff ff       	call   8010507b <argptr>
80105e74:	85 c0                	test   %eax,%eax
80105e76:	79 0a                	jns    80105e82 <sys_pipe+0x2f>
    return -1;
80105e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7d:	e9 9b 00 00 00       	jmp    80105f1d <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80105e82:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e89:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e8c:	89 04 24             	mov    %eax,(%esp)
80105e8f:	e8 5a dd ff ff       	call   80103bee <pipealloc>
80105e94:	85 c0                	test   %eax,%eax
80105e96:	79 07                	jns    80105e9f <sys_pipe+0x4c>
    return -1;
80105e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9d:	eb 7e                	jmp    80105f1d <sys_pipe+0xca>
  fd0 = -1;
80105e9f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ea9:	89 04 24             	mov    %eax,(%esp)
80105eac:	e8 67 f3 ff ff       	call   80105218 <fdalloc>
80105eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eb8:	78 14                	js     80105ece <sys_pipe+0x7b>
80105eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ebd:	89 04 24             	mov    %eax,(%esp)
80105ec0:	e8 53 f3 ff ff       	call   80105218 <fdalloc>
80105ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ec8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ecc:	79 37                	jns    80105f05 <sys_pipe+0xb2>
    if(fd0 >= 0)
80105ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ed2:	78 14                	js     80105ee8 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80105ed4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105edd:	83 c2 08             	add    $0x8,%edx
80105ee0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105ee7:	00 
    fileclose(rf);
80105ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105eeb:	89 04 24             	mov    %eax,(%esp)
80105eee:	e8 db b0 ff ff       	call   80100fce <fileclose>
    fileclose(wf);
80105ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ef6:	89 04 24             	mov    %eax,(%esp)
80105ef9:	e8 d0 b0 ff ff       	call   80100fce <fileclose>
    return -1;
80105efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f03:	eb 18                	jmp    80105f1d <sys_pipe+0xca>
  }
  fd[0] = fd0;
80105f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f0b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f10:	8d 50 04             	lea    0x4(%eax),%edx
80105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f16:	89 02                	mov    %eax,(%edx)
  return 0;
80105f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f1d:	c9                   	leave  
80105f1e:	c3                   	ret    

80105f1f <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f1f:	55                   	push   %ebp
80105f20:	89 e5                	mov    %esp,%ebp
80105f22:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105f25:	e8 6f e3 ff ff       	call   80104299 <fork>
}
80105f2a:	c9                   	leave  
80105f2b:	c3                   	ret    

80105f2c <sys_exit>:

int
sys_exit(void)
{
80105f2c:	55                   	push   %ebp
80105f2d:	89 e5                	mov    %esp,%ebp
80105f2f:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f32:	e8 dd e4 ff ff       	call   80104414 <exit>
  return 0;  // not reached
80105f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f3c:	c9                   	leave  
80105f3d:	c3                   	ret    

80105f3e <sys_wait>:

int
sys_wait(void)
{
80105f3e:	55                   	push   %ebp
80105f3f:	89 e5                	mov    %esp,%ebp
80105f41:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105f44:	e8 ed e5 ff ff       	call   80104536 <wait>
}
80105f49:	c9                   	leave  
80105f4a:	c3                   	ret    

80105f4b <sys_kill>:

int
sys_kill(void)
{
80105f4b:	55                   	push   %ebp
80105f4c:	89 e5                	mov    %esp,%ebp
80105f4e:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f5f:	e8 e9 f0 ff ff       	call   8010504d <argint>
80105f64:	85 c0                	test   %eax,%eax
80105f66:	79 07                	jns    80105f6f <sys_kill+0x24>
    return -1;
80105f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6d:	eb 0b                	jmp    80105f7a <sys_kill+0x2f>
  return kill(pid);
80105f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f72:	89 04 24             	mov    %eax,(%esp)
80105f75:	e8 77 e9 ff ff       	call   801048f1 <kill>
}
80105f7a:	c9                   	leave  
80105f7b:	c3                   	ret    

80105f7c <sys_getpid>:

int
sys_getpid(void)
{
80105f7c:	55                   	push   %ebp
80105f7d:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105f7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f85:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f88:	5d                   	pop    %ebp
80105f89:	c3                   	ret    

80105f8a <sys_sbrk>:

int
sys_sbrk(void)
{
80105f8a:	55                   	push   %ebp
80105f8b:	89 e5                	mov    %esp,%ebp
80105f8d:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f90:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f93:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f9e:	e8 aa f0 ff ff       	call   8010504d <argint>
80105fa3:	85 c0                	test   %eax,%eax
80105fa5:	79 07                	jns    80105fae <sys_sbrk+0x24>
    return -1;
80105fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fac:	eb 24                	jmp    80105fd2 <sys_sbrk+0x48>
  addr = proc->sz;
80105fae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fb4:	8b 00                	mov    (%eax),%eax
80105fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fbc:	89 04 24             	mov    %eax,(%esp)
80105fbf:	e8 30 e2 ff ff       	call   801041f4 <growproc>
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	79 07                	jns    80105fcf <sys_sbrk+0x45>
    return -1;
80105fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcd:	eb 03                	jmp    80105fd2 <sys_sbrk+0x48>
  return addr;
80105fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105fd2:	c9                   	leave  
80105fd3:	c3                   	ret    

80105fd4 <sys_sleep>:

int
sys_sleep(void)
{
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80105fda:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fe8:	e8 60 f0 ff ff       	call   8010504d <argint>
80105fed:	85 c0                	test   %eax,%eax
80105fef:	79 07                	jns    80105ff8 <sys_sleep+0x24>
    return -1;
80105ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff6:	eb 6c                	jmp    80106064 <sys_sleep+0x90>
  acquire(&tickslock);
80105ff8:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80105fff:	e8 b3 ea ff ff       	call   80104ab7 <acquire>
  ticks0 = ticks;
80106004:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010600c:	eb 34                	jmp    80106042 <sys_sleep+0x6e>
    if(proc->killed){
8010600e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106014:	8b 40 24             	mov    0x24(%eax),%eax
80106017:	85 c0                	test   %eax,%eax
80106019:	74 13                	je     8010602e <sys_sleep+0x5a>
      release(&tickslock);
8010601b:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106022:	e8 f2 ea ff ff       	call   80104b19 <release>
      return -1;
80106027:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602c:	eb 36                	jmp    80106064 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010602e:	c7 44 24 04 60 1e 11 	movl   $0x80111e60,0x4(%esp)
80106035:	80 
80106036:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010603d:	e8 ab e7 ff ff       	call   801047ed <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106042:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106047:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010604a:	89 c2                	mov    %eax,%edx
8010604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604f:	39 c2                	cmp    %eax,%edx
80106051:	72 bb                	jb     8010600e <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106053:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
8010605a:	e8 ba ea ff ff       	call   80104b19 <release>
  return 0;
8010605f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106064:	c9                   	leave  
80106065:	c3                   	ret    

80106066 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106066:	55                   	push   %ebp
80106067:	89 e5                	mov    %esp,%ebp
80106069:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010606c:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106073:	e8 3f ea ff ff       	call   80104ab7 <acquire>
  xticks = ticks;
80106078:	a1 a0 26 11 80       	mov    0x801126a0,%eax
8010607d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106080:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106087:	e8 8d ea ff ff       	call   80104b19 <release>
  return xticks;
8010608c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010608f:	c9                   	leave  
80106090:	c3                   	ret    

80106091 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106091:	55                   	push   %ebp
80106092:	89 e5                	mov    %esp,%ebp
80106094:	83 ec 08             	sub    $0x8,%esp
80106097:	8b 55 08             	mov    0x8(%ebp),%edx
8010609a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010609d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801060a1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801060a8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801060ac:	ee                   	out    %al,(%dx)
}
801060ad:	c9                   	leave  
801060ae:	c3                   	ret    

801060af <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801060af:	55                   	push   %ebp
801060b0:	89 e5                	mov    %esp,%ebp
801060b2:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801060b5:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801060bc:	00 
801060bd:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801060c4:	e8 c8 ff ff ff       	call   80106091 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801060c9:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801060d0:	00 
801060d1:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801060d8:	e8 b4 ff ff ff       	call   80106091 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801060dd:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801060e4:	00 
801060e5:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801060ec:	e8 a0 ff ff ff       	call   80106091 <outb>
  picenable(IRQ_TIMER);
801060f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060f8:	e8 84 d9 ff ff       	call   80103a81 <picenable>
}
801060fd:	c9                   	leave  
801060fe:	c3                   	ret    

801060ff <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801060ff:	1e                   	push   %ds
  pushl %es
80106100:	06                   	push   %es
  pushl %fs
80106101:	0f a0                	push   %fs
  pushl %gs
80106103:	0f a8                	push   %gs
  pushal
80106105:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106106:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010610a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010610c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010610e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106112:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106114:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106116:	54                   	push   %esp
  call trap
80106117:	e8 d8 01 00 00       	call   801062f4 <trap>
  addl $4, %esp
8010611c:	83 c4 04             	add    $0x4,%esp

8010611f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010611f:	61                   	popa   
  popl %gs
80106120:	0f a9                	pop    %gs
  popl %fs
80106122:	0f a1                	pop    %fs
  popl %es
80106124:	07                   	pop    %es
  popl %ds
80106125:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106126:	83 c4 08             	add    $0x8,%esp
  iret
80106129:	cf                   	iret   

8010612a <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010612a:	55                   	push   %ebp
8010612b:	89 e5                	mov    %esp,%ebp
8010612d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106130:	8b 45 0c             	mov    0xc(%ebp),%eax
80106133:	83 e8 01             	sub    $0x1,%eax
80106136:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010613a:	8b 45 08             	mov    0x8(%ebp),%eax
8010613d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106141:	8b 45 08             	mov    0x8(%ebp),%eax
80106144:	c1 e8 10             	shr    $0x10,%eax
80106147:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010614b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010614e:	0f 01 18             	lidtl  (%eax)
}
80106151:	c9                   	leave  
80106152:	c3                   	ret    

80106153 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106153:	55                   	push   %ebp
80106154:	89 e5                	mov    %esp,%ebp
80106156:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106159:	0f 20 d0             	mov    %cr2,%eax
8010615c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010615f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106162:	c9                   	leave  
80106163:	c3                   	ret    

80106164 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010616a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106171:	e9 c3 00 00 00       	jmp    80106239 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106179:	8b 04 85 9c b0 10 80 	mov    -0x7fef4f64(,%eax,4),%eax
80106180:	89 c2                	mov    %eax,%edx
80106182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106185:	66 89 14 c5 a0 1e 11 	mov    %dx,-0x7feee160(,%eax,8)
8010618c:	80 
8010618d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106190:	66 c7 04 c5 a2 1e 11 	movw   $0x8,-0x7feee15e(,%eax,8)
80106197:	80 08 00 
8010619a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619d:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
801061a4:	80 
801061a5:	83 e2 e0             	and    $0xffffffe0,%edx
801061a8:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
801061af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b2:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
801061b9:	80 
801061ba:	83 e2 1f             	and    $0x1f,%edx
801061bd:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
801061c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c7:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
801061ce:	80 
801061cf:	83 e2 f0             	and    $0xfffffff0,%edx
801061d2:	83 ca 0e             	or     $0xe,%edx
801061d5:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
801061dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061df:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
801061e6:	80 
801061e7:	83 e2 ef             	and    $0xffffffef,%edx
801061ea:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
801061f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f4:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
801061fb:	80 
801061fc:	83 e2 9f             	and    $0xffffff9f,%edx
801061ff:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106209:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106210:	80 
80106211:	83 ca 80             	or     $0xffffff80,%edx
80106214:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
8010621b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621e:	8b 04 85 9c b0 10 80 	mov    -0x7fef4f64(,%eax,4),%eax
80106225:	c1 e8 10             	shr    $0x10,%eax
80106228:	89 c2                	mov    %eax,%edx
8010622a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622d:	66 89 14 c5 a6 1e 11 	mov    %dx,-0x7feee15a(,%eax,8)
80106234:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106235:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106239:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106240:	0f 8e 30 ff ff ff    	jle    80106176 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106246:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
8010624b:	66 a3 a0 20 11 80    	mov    %ax,0x801120a0
80106251:	66 c7 05 a2 20 11 80 	movw   $0x8,0x801120a2
80106258:	08 00 
8010625a:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
80106261:	83 e0 e0             	and    $0xffffffe0,%eax
80106264:	a2 a4 20 11 80       	mov    %al,0x801120a4
80106269:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
80106270:	83 e0 1f             	and    $0x1f,%eax
80106273:	a2 a4 20 11 80       	mov    %al,0x801120a4
80106278:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
8010627f:	83 c8 0f             	or     $0xf,%eax
80106282:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106287:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
8010628e:	83 e0 ef             	and    $0xffffffef,%eax
80106291:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106296:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
8010629d:	83 c8 60             	or     $0x60,%eax
801062a0:	a2 a5 20 11 80       	mov    %al,0x801120a5
801062a5:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801062ac:	83 c8 80             	or     $0xffffff80,%eax
801062af:	a2 a5 20 11 80       	mov    %al,0x801120a5
801062b4:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
801062b9:	c1 e8 10             	shr    $0x10,%eax
801062bc:	66 a3 a6 20 11 80    	mov    %ax,0x801120a6
  
  initlock(&tickslock, "time");
801062c2:	c7 44 24 04 78 87 10 	movl   $0x80108778,0x4(%esp)
801062c9:	80 
801062ca:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801062d1:	e8 c0 e7 ff ff       	call   80104a96 <initlock>
}
801062d6:	c9                   	leave  
801062d7:	c3                   	ret    

801062d8 <idtinit>:

void
idtinit(void)
{
801062d8:	55                   	push   %ebp
801062d9:	89 e5                	mov    %esp,%ebp
801062db:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801062de:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801062e5:	00 
801062e6:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
801062ed:	e8 38 fe ff ff       	call   8010612a <lidt>
}
801062f2:	c9                   	leave  
801062f3:	c3                   	ret    

801062f4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062f4:	55                   	push   %ebp
801062f5:	89 e5                	mov    %esp,%ebp
801062f7:	57                   	push   %edi
801062f8:	56                   	push   %esi
801062f9:	53                   	push   %ebx
801062fa:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801062fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106300:	8b 40 30             	mov    0x30(%eax),%eax
80106303:	83 f8 40             	cmp    $0x40,%eax
80106306:	75 3f                	jne    80106347 <trap+0x53>
    if(proc->killed)
80106308:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010630e:	8b 40 24             	mov    0x24(%eax),%eax
80106311:	85 c0                	test   %eax,%eax
80106313:	74 05                	je     8010631a <trap+0x26>
      exit();
80106315:	e8 fa e0 ff ff       	call   80104414 <exit>
    proc->tf = tf;
8010631a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106320:	8b 55 08             	mov    0x8(%ebp),%edx
80106323:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106326:	e8 e9 ed ff ff       	call   80105114 <syscall>
    if(proc->killed)
8010632b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106331:	8b 40 24             	mov    0x24(%eax),%eax
80106334:	85 c0                	test   %eax,%eax
80106336:	74 0a                	je     80106342 <trap+0x4e>
      exit();
80106338:	e8 d7 e0 ff ff       	call   80104414 <exit>
    return;
8010633d:	e9 2d 02 00 00       	jmp    8010656f <trap+0x27b>
80106342:	e9 28 02 00 00       	jmp    8010656f <trap+0x27b>
  }

  switch(tf->trapno){
80106347:	8b 45 08             	mov    0x8(%ebp),%eax
8010634a:	8b 40 30             	mov    0x30(%eax),%eax
8010634d:	83 e8 20             	sub    $0x20,%eax
80106350:	83 f8 1f             	cmp    $0x1f,%eax
80106353:	0f 87 bc 00 00 00    	ja     80106415 <trap+0x121>
80106359:	8b 04 85 20 88 10 80 	mov    -0x7fef77e0(,%eax,4),%eax
80106360:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106362:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106368:	0f b6 00             	movzbl (%eax),%eax
8010636b:	84 c0                	test   %al,%al
8010636d:	75 31                	jne    801063a0 <trap+0xac>
      acquire(&tickslock);
8010636f:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106376:	e8 3c e7 ff ff       	call   80104ab7 <acquire>
      ticks++;
8010637b:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106380:	83 c0 01             	add    $0x1,%eax
80106383:	a3 a0 26 11 80       	mov    %eax,0x801126a0
      wakeup(&ticks);
80106388:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010638f:	e8 32 e5 ff ff       	call   801048c6 <wakeup>
      release(&tickslock);
80106394:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
8010639b:	e8 79 e7 ff ff       	call   80104b19 <release>
    }
    lapiceoi();
801063a0:	e8 0e cb ff ff       	call   80102eb3 <lapiceoi>
    break;
801063a5:	e9 41 01 00 00       	jmp    801064eb <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801063aa:	e8 2f c3 ff ff       	call   801026de <ideintr>
    lapiceoi();
801063af:	e8 ff ca ff ff       	call   80102eb3 <lapiceoi>
    break;
801063b4:	e9 32 01 00 00       	jmp    801064eb <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801063b9:	e8 e1 c8 ff ff       	call   80102c9f <kbdintr>
    lapiceoi();
801063be:	e8 f0 ca ff ff       	call   80102eb3 <lapiceoi>
    break;
801063c3:	e9 23 01 00 00       	jmp    801064eb <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801063c8:	e8 97 03 00 00       	call   80106764 <uartintr>
    lapiceoi();
801063cd:	e8 e1 ca ff ff       	call   80102eb3 <lapiceoi>
    break;
801063d2:	e9 14 01 00 00       	jmp    801064eb <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063d7:	8b 45 08             	mov    0x8(%ebp),%eax
801063da:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801063dd:	8b 45 08             	mov    0x8(%ebp),%eax
801063e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063e4:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801063e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063ed:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063f0:	0f b6 c0             	movzbl %al,%eax
801063f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801063f7:	89 54 24 08          	mov    %edx,0x8(%esp)
801063fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801063ff:	c7 04 24 80 87 10 80 	movl   $0x80108780,(%esp)
80106406:	e8 95 9f ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010640b:	e8 a3 ca ff ff       	call   80102eb3 <lapiceoi>
    break;
80106410:	e9 d6 00 00 00       	jmp    801064eb <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106415:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010641b:	85 c0                	test   %eax,%eax
8010641d:	74 11                	je     80106430 <trap+0x13c>
8010641f:	8b 45 08             	mov    0x8(%ebp),%eax
80106422:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106426:	0f b7 c0             	movzwl %ax,%eax
80106429:	83 e0 03             	and    $0x3,%eax
8010642c:	85 c0                	test   %eax,%eax
8010642e:	75 46                	jne    80106476 <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106430:	e8 1e fd ff ff       	call   80106153 <rcr2>
80106435:	8b 55 08             	mov    0x8(%ebp),%edx
80106438:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010643b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106442:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106445:	0f b6 ca             	movzbl %dl,%ecx
80106448:	8b 55 08             	mov    0x8(%ebp),%edx
8010644b:	8b 52 30             	mov    0x30(%edx),%edx
8010644e:	89 44 24 10          	mov    %eax,0x10(%esp)
80106452:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106456:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010645a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010645e:	c7 04 24 a4 87 10 80 	movl   $0x801087a4,(%esp)
80106465:	e8 36 9f ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010646a:	c7 04 24 d6 87 10 80 	movl   $0x801087d6,(%esp)
80106471:	e8 c4 a0 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106476:	e8 d8 fc ff ff       	call   80106153 <rcr2>
8010647b:	89 c2                	mov    %eax,%edx
8010647d:	8b 45 08             	mov    0x8(%ebp),%eax
80106480:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106483:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106489:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010648c:	0f b6 f0             	movzbl %al,%esi
8010648f:	8b 45 08             	mov    0x8(%ebp),%eax
80106492:	8b 58 34             	mov    0x34(%eax),%ebx
80106495:	8b 45 08             	mov    0x8(%ebp),%eax
80106498:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010649b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064a1:	83 c0 6c             	add    $0x6c,%eax
801064a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064ad:	8b 40 10             	mov    0x10(%eax),%eax
801064b0:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801064b4:	89 7c 24 18          	mov    %edi,0x18(%esp)
801064b8:	89 74 24 14          	mov    %esi,0x14(%esp)
801064bc:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801064c0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801064c4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801064c7:	89 74 24 08          	mov    %esi,0x8(%esp)
801064cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801064cf:	c7 04 24 dc 87 10 80 	movl   $0x801087dc,(%esp)
801064d6:	e8 c5 9e ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801064db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064e1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801064e8:	eb 01                	jmp    801064eb <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801064ea:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801064eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064f1:	85 c0                	test   %eax,%eax
801064f3:	74 24                	je     80106519 <trap+0x225>
801064f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064fb:	8b 40 24             	mov    0x24(%eax),%eax
801064fe:	85 c0                	test   %eax,%eax
80106500:	74 17                	je     80106519 <trap+0x225>
80106502:	8b 45 08             	mov    0x8(%ebp),%eax
80106505:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106509:	0f b7 c0             	movzwl %ax,%eax
8010650c:	83 e0 03             	and    $0x3,%eax
8010650f:	83 f8 03             	cmp    $0x3,%eax
80106512:	75 05                	jne    80106519 <trap+0x225>
    exit();
80106514:	e8 fb de ff ff       	call   80104414 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106519:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010651f:	85 c0                	test   %eax,%eax
80106521:	74 1e                	je     80106541 <trap+0x24d>
80106523:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106529:	8b 40 0c             	mov    0xc(%eax),%eax
8010652c:	83 f8 04             	cmp    $0x4,%eax
8010652f:	75 10                	jne    80106541 <trap+0x24d>
80106531:	8b 45 08             	mov    0x8(%ebp),%eax
80106534:	8b 40 30             	mov    0x30(%eax),%eax
80106537:	83 f8 20             	cmp    $0x20,%eax
8010653a:	75 05                	jne    80106541 <trap+0x24d>
    yield();
8010653c:	e8 4e e2 ff ff       	call   8010478f <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106541:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106547:	85 c0                	test   %eax,%eax
80106549:	74 24                	je     8010656f <trap+0x27b>
8010654b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106551:	8b 40 24             	mov    0x24(%eax),%eax
80106554:	85 c0                	test   %eax,%eax
80106556:	74 17                	je     8010656f <trap+0x27b>
80106558:	8b 45 08             	mov    0x8(%ebp),%eax
8010655b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010655f:	0f b7 c0             	movzwl %ax,%eax
80106562:	83 e0 03             	and    $0x3,%eax
80106565:	83 f8 03             	cmp    $0x3,%eax
80106568:	75 05                	jne    8010656f <trap+0x27b>
    exit();
8010656a:	e8 a5 de ff ff       	call   80104414 <exit>
}
8010656f:	83 c4 3c             	add    $0x3c,%esp
80106572:	5b                   	pop    %ebx
80106573:	5e                   	pop    %esi
80106574:	5f                   	pop    %edi
80106575:	5d                   	pop    %ebp
80106576:	c3                   	ret    

80106577 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106577:	55                   	push   %ebp
80106578:	89 e5                	mov    %esp,%ebp
8010657a:	83 ec 14             	sub    $0x14,%esp
8010657d:	8b 45 08             	mov    0x8(%ebp),%eax
80106580:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106584:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106588:	89 c2                	mov    %eax,%edx
8010658a:	ec                   	in     (%dx),%al
8010658b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010658e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106592:	c9                   	leave  
80106593:	c3                   	ret    

80106594 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106594:	55                   	push   %ebp
80106595:	89 e5                	mov    %esp,%ebp
80106597:	83 ec 08             	sub    $0x8,%esp
8010659a:	8b 55 08             	mov    0x8(%ebp),%edx
8010659d:	8b 45 0c             	mov    0xc(%ebp),%eax
801065a0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801065a4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065a7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801065ab:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801065af:	ee                   	out    %al,(%dx)
}
801065b0:	c9                   	leave  
801065b1:	c3                   	ret    

801065b2 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801065b2:	55                   	push   %ebp
801065b3:	89 e5                	mov    %esp,%ebp
801065b5:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801065b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065bf:	00 
801065c0:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801065c7:	e8 c8 ff ff ff       	call   80106594 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801065cc:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801065d3:	00 
801065d4:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801065db:	e8 b4 ff ff ff       	call   80106594 <outb>
  outb(COM1+0, 115200/9600);
801065e0:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801065e7:	00 
801065e8:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801065ef:	e8 a0 ff ff ff       	call   80106594 <outb>
  outb(COM1+1, 0);
801065f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065fb:	00 
801065fc:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106603:	e8 8c ff ff ff       	call   80106594 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106608:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010660f:	00 
80106610:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106617:	e8 78 ff ff ff       	call   80106594 <outb>
  outb(COM1+4, 0);
8010661c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106623:	00 
80106624:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010662b:	e8 64 ff ff ff       	call   80106594 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106630:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106637:	00 
80106638:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010663f:	e8 50 ff ff ff       	call   80106594 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106644:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010664b:	e8 27 ff ff ff       	call   80106577 <inb>
80106650:	3c ff                	cmp    $0xff,%al
80106652:	75 02                	jne    80106656 <uartinit+0xa4>
    return;
80106654:	eb 6a                	jmp    801066c0 <uartinit+0x10e>
  uart = 1;
80106656:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
8010665d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106660:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106667:	e8 0b ff ff ff       	call   80106577 <inb>
  inb(COM1+0);
8010666c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106673:	e8 ff fe ff ff       	call   80106577 <inb>
  picenable(IRQ_COM1);
80106678:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010667f:	e8 fd d3 ff ff       	call   80103a81 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106684:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010668b:	00 
8010668c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106693:	e8 c5 c2 ff ff       	call   8010295d <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106698:	c7 45 f4 a0 88 10 80 	movl   $0x801088a0,-0xc(%ebp)
8010669f:	eb 15                	jmp    801066b6 <uartinit+0x104>
    uartputc(*p);
801066a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a4:	0f b6 00             	movzbl (%eax),%eax
801066a7:	0f be c0             	movsbl %al,%eax
801066aa:	89 04 24             	mov    %eax,(%esp)
801066ad:	e8 10 00 00 00       	call   801066c2 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801066b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b9:	0f b6 00             	movzbl (%eax),%eax
801066bc:	84 c0                	test   %al,%al
801066be:	75 e1                	jne    801066a1 <uartinit+0xef>
    uartputc(*p);
}
801066c0:	c9                   	leave  
801066c1:	c3                   	ret    

801066c2 <uartputc>:

void
uartputc(int c)
{
801066c2:	55                   	push   %ebp
801066c3:	89 e5                	mov    %esp,%ebp
801066c5:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801066c8:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801066cd:	85 c0                	test   %eax,%eax
801066cf:	75 02                	jne    801066d3 <uartputc+0x11>
    return;
801066d1:	eb 4b                	jmp    8010671e <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066da:	eb 10                	jmp    801066ec <uartputc+0x2a>
    microdelay(10);
801066dc:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801066e3:	e8 f0 c7 ff ff       	call   80102ed8 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066ec:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801066f0:	7f 16                	jg     80106708 <uartputc+0x46>
801066f2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801066f9:	e8 79 fe ff ff       	call   80106577 <inb>
801066fe:	0f b6 c0             	movzbl %al,%eax
80106701:	83 e0 20             	and    $0x20,%eax
80106704:	85 c0                	test   %eax,%eax
80106706:	74 d4                	je     801066dc <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106708:	8b 45 08             	mov    0x8(%ebp),%eax
8010670b:	0f b6 c0             	movzbl %al,%eax
8010670e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106712:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106719:	e8 76 fe ff ff       	call   80106594 <outb>
}
8010671e:	c9                   	leave  
8010671f:	c3                   	ret    

80106720 <uartgetc>:

static int
uartgetc(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106726:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
8010672b:	85 c0                	test   %eax,%eax
8010672d:	75 07                	jne    80106736 <uartgetc+0x16>
    return -1;
8010672f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106734:	eb 2c                	jmp    80106762 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106736:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010673d:	e8 35 fe ff ff       	call   80106577 <inb>
80106742:	0f b6 c0             	movzbl %al,%eax
80106745:	83 e0 01             	and    $0x1,%eax
80106748:	85 c0                	test   %eax,%eax
8010674a:	75 07                	jne    80106753 <uartgetc+0x33>
    return -1;
8010674c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106751:	eb 0f                	jmp    80106762 <uartgetc+0x42>
  return inb(COM1+0);
80106753:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010675a:	e8 18 fe ff ff       	call   80106577 <inb>
8010675f:	0f b6 c0             	movzbl %al,%eax
}
80106762:	c9                   	leave  
80106763:	c3                   	ret    

80106764 <uartintr>:

void
uartintr(void)
{
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010676a:	c7 04 24 20 67 10 80 	movl   $0x80106720,(%esp)
80106771:	e8 37 a0 ff ff       	call   801007ad <consoleintr>
}
80106776:	c9                   	leave  
80106777:	c3                   	ret    

80106778 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $0
8010677a:	6a 00                	push   $0x0
  jmp alltraps
8010677c:	e9 7e f9 ff ff       	jmp    801060ff <alltraps>

80106781 <vector1>:
.globl vector1
vector1:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $1
80106783:	6a 01                	push   $0x1
  jmp alltraps
80106785:	e9 75 f9 ff ff       	jmp    801060ff <alltraps>

8010678a <vector2>:
.globl vector2
vector2:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $2
8010678c:	6a 02                	push   $0x2
  jmp alltraps
8010678e:	e9 6c f9 ff ff       	jmp    801060ff <alltraps>

80106793 <vector3>:
.globl vector3
vector3:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $3
80106795:	6a 03                	push   $0x3
  jmp alltraps
80106797:	e9 63 f9 ff ff       	jmp    801060ff <alltraps>

8010679c <vector4>:
.globl vector4
vector4:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $4
8010679e:	6a 04                	push   $0x4
  jmp alltraps
801067a0:	e9 5a f9 ff ff       	jmp    801060ff <alltraps>

801067a5 <vector5>:
.globl vector5
vector5:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $5
801067a7:	6a 05                	push   $0x5
  jmp alltraps
801067a9:	e9 51 f9 ff ff       	jmp    801060ff <alltraps>

801067ae <vector6>:
.globl vector6
vector6:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $6
801067b0:	6a 06                	push   $0x6
  jmp alltraps
801067b2:	e9 48 f9 ff ff       	jmp    801060ff <alltraps>

801067b7 <vector7>:
.globl vector7
vector7:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $7
801067b9:	6a 07                	push   $0x7
  jmp alltraps
801067bb:	e9 3f f9 ff ff       	jmp    801060ff <alltraps>

801067c0 <vector8>:
.globl vector8
vector8:
  pushl $8
801067c0:	6a 08                	push   $0x8
  jmp alltraps
801067c2:	e9 38 f9 ff ff       	jmp    801060ff <alltraps>

801067c7 <vector9>:
.globl vector9
vector9:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $9
801067c9:	6a 09                	push   $0x9
  jmp alltraps
801067cb:	e9 2f f9 ff ff       	jmp    801060ff <alltraps>

801067d0 <vector10>:
.globl vector10
vector10:
  pushl $10
801067d0:	6a 0a                	push   $0xa
  jmp alltraps
801067d2:	e9 28 f9 ff ff       	jmp    801060ff <alltraps>

801067d7 <vector11>:
.globl vector11
vector11:
  pushl $11
801067d7:	6a 0b                	push   $0xb
  jmp alltraps
801067d9:	e9 21 f9 ff ff       	jmp    801060ff <alltraps>

801067de <vector12>:
.globl vector12
vector12:
  pushl $12
801067de:	6a 0c                	push   $0xc
  jmp alltraps
801067e0:	e9 1a f9 ff ff       	jmp    801060ff <alltraps>

801067e5 <vector13>:
.globl vector13
vector13:
  pushl $13
801067e5:	6a 0d                	push   $0xd
  jmp alltraps
801067e7:	e9 13 f9 ff ff       	jmp    801060ff <alltraps>

801067ec <vector14>:
.globl vector14
vector14:
  pushl $14
801067ec:	6a 0e                	push   $0xe
  jmp alltraps
801067ee:	e9 0c f9 ff ff       	jmp    801060ff <alltraps>

801067f3 <vector15>:
.globl vector15
vector15:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $15
801067f5:	6a 0f                	push   $0xf
  jmp alltraps
801067f7:	e9 03 f9 ff ff       	jmp    801060ff <alltraps>

801067fc <vector16>:
.globl vector16
vector16:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $16
801067fe:	6a 10                	push   $0x10
  jmp alltraps
80106800:	e9 fa f8 ff ff       	jmp    801060ff <alltraps>

80106805 <vector17>:
.globl vector17
vector17:
  pushl $17
80106805:	6a 11                	push   $0x11
  jmp alltraps
80106807:	e9 f3 f8 ff ff       	jmp    801060ff <alltraps>

8010680c <vector18>:
.globl vector18
vector18:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $18
8010680e:	6a 12                	push   $0x12
  jmp alltraps
80106810:	e9 ea f8 ff ff       	jmp    801060ff <alltraps>

80106815 <vector19>:
.globl vector19
vector19:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $19
80106817:	6a 13                	push   $0x13
  jmp alltraps
80106819:	e9 e1 f8 ff ff       	jmp    801060ff <alltraps>

8010681e <vector20>:
.globl vector20
vector20:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $20
80106820:	6a 14                	push   $0x14
  jmp alltraps
80106822:	e9 d8 f8 ff ff       	jmp    801060ff <alltraps>

80106827 <vector21>:
.globl vector21
vector21:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $21
80106829:	6a 15                	push   $0x15
  jmp alltraps
8010682b:	e9 cf f8 ff ff       	jmp    801060ff <alltraps>

80106830 <vector22>:
.globl vector22
vector22:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $22
80106832:	6a 16                	push   $0x16
  jmp alltraps
80106834:	e9 c6 f8 ff ff       	jmp    801060ff <alltraps>

80106839 <vector23>:
.globl vector23
vector23:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $23
8010683b:	6a 17                	push   $0x17
  jmp alltraps
8010683d:	e9 bd f8 ff ff       	jmp    801060ff <alltraps>

80106842 <vector24>:
.globl vector24
vector24:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $24
80106844:	6a 18                	push   $0x18
  jmp alltraps
80106846:	e9 b4 f8 ff ff       	jmp    801060ff <alltraps>

8010684b <vector25>:
.globl vector25
vector25:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $25
8010684d:	6a 19                	push   $0x19
  jmp alltraps
8010684f:	e9 ab f8 ff ff       	jmp    801060ff <alltraps>

80106854 <vector26>:
.globl vector26
vector26:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $26
80106856:	6a 1a                	push   $0x1a
  jmp alltraps
80106858:	e9 a2 f8 ff ff       	jmp    801060ff <alltraps>

8010685d <vector27>:
.globl vector27
vector27:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $27
8010685f:	6a 1b                	push   $0x1b
  jmp alltraps
80106861:	e9 99 f8 ff ff       	jmp    801060ff <alltraps>

80106866 <vector28>:
.globl vector28
vector28:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $28
80106868:	6a 1c                	push   $0x1c
  jmp alltraps
8010686a:	e9 90 f8 ff ff       	jmp    801060ff <alltraps>

8010686f <vector29>:
.globl vector29
vector29:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $29
80106871:	6a 1d                	push   $0x1d
  jmp alltraps
80106873:	e9 87 f8 ff ff       	jmp    801060ff <alltraps>

80106878 <vector30>:
.globl vector30
vector30:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $30
8010687a:	6a 1e                	push   $0x1e
  jmp alltraps
8010687c:	e9 7e f8 ff ff       	jmp    801060ff <alltraps>

80106881 <vector31>:
.globl vector31
vector31:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $31
80106883:	6a 1f                	push   $0x1f
  jmp alltraps
80106885:	e9 75 f8 ff ff       	jmp    801060ff <alltraps>

8010688a <vector32>:
.globl vector32
vector32:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $32
8010688c:	6a 20                	push   $0x20
  jmp alltraps
8010688e:	e9 6c f8 ff ff       	jmp    801060ff <alltraps>

80106893 <vector33>:
.globl vector33
vector33:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $33
80106895:	6a 21                	push   $0x21
  jmp alltraps
80106897:	e9 63 f8 ff ff       	jmp    801060ff <alltraps>

8010689c <vector34>:
.globl vector34
vector34:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $34
8010689e:	6a 22                	push   $0x22
  jmp alltraps
801068a0:	e9 5a f8 ff ff       	jmp    801060ff <alltraps>

801068a5 <vector35>:
.globl vector35
vector35:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $35
801068a7:	6a 23                	push   $0x23
  jmp alltraps
801068a9:	e9 51 f8 ff ff       	jmp    801060ff <alltraps>

801068ae <vector36>:
.globl vector36
vector36:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $36
801068b0:	6a 24                	push   $0x24
  jmp alltraps
801068b2:	e9 48 f8 ff ff       	jmp    801060ff <alltraps>

801068b7 <vector37>:
.globl vector37
vector37:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $37
801068b9:	6a 25                	push   $0x25
  jmp alltraps
801068bb:	e9 3f f8 ff ff       	jmp    801060ff <alltraps>

801068c0 <vector38>:
.globl vector38
vector38:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $38
801068c2:	6a 26                	push   $0x26
  jmp alltraps
801068c4:	e9 36 f8 ff ff       	jmp    801060ff <alltraps>

801068c9 <vector39>:
.globl vector39
vector39:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $39
801068cb:	6a 27                	push   $0x27
  jmp alltraps
801068cd:	e9 2d f8 ff ff       	jmp    801060ff <alltraps>

801068d2 <vector40>:
.globl vector40
vector40:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $40
801068d4:	6a 28                	push   $0x28
  jmp alltraps
801068d6:	e9 24 f8 ff ff       	jmp    801060ff <alltraps>

801068db <vector41>:
.globl vector41
vector41:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $41
801068dd:	6a 29                	push   $0x29
  jmp alltraps
801068df:	e9 1b f8 ff ff       	jmp    801060ff <alltraps>

801068e4 <vector42>:
.globl vector42
vector42:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $42
801068e6:	6a 2a                	push   $0x2a
  jmp alltraps
801068e8:	e9 12 f8 ff ff       	jmp    801060ff <alltraps>

801068ed <vector43>:
.globl vector43
vector43:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $43
801068ef:	6a 2b                	push   $0x2b
  jmp alltraps
801068f1:	e9 09 f8 ff ff       	jmp    801060ff <alltraps>

801068f6 <vector44>:
.globl vector44
vector44:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $44
801068f8:	6a 2c                	push   $0x2c
  jmp alltraps
801068fa:	e9 00 f8 ff ff       	jmp    801060ff <alltraps>

801068ff <vector45>:
.globl vector45
vector45:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $45
80106901:	6a 2d                	push   $0x2d
  jmp alltraps
80106903:	e9 f7 f7 ff ff       	jmp    801060ff <alltraps>

80106908 <vector46>:
.globl vector46
vector46:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $46
8010690a:	6a 2e                	push   $0x2e
  jmp alltraps
8010690c:	e9 ee f7 ff ff       	jmp    801060ff <alltraps>

80106911 <vector47>:
.globl vector47
vector47:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $47
80106913:	6a 2f                	push   $0x2f
  jmp alltraps
80106915:	e9 e5 f7 ff ff       	jmp    801060ff <alltraps>

8010691a <vector48>:
.globl vector48
vector48:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $48
8010691c:	6a 30                	push   $0x30
  jmp alltraps
8010691e:	e9 dc f7 ff ff       	jmp    801060ff <alltraps>

80106923 <vector49>:
.globl vector49
vector49:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $49
80106925:	6a 31                	push   $0x31
  jmp alltraps
80106927:	e9 d3 f7 ff ff       	jmp    801060ff <alltraps>

8010692c <vector50>:
.globl vector50
vector50:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $50
8010692e:	6a 32                	push   $0x32
  jmp alltraps
80106930:	e9 ca f7 ff ff       	jmp    801060ff <alltraps>

80106935 <vector51>:
.globl vector51
vector51:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $51
80106937:	6a 33                	push   $0x33
  jmp alltraps
80106939:	e9 c1 f7 ff ff       	jmp    801060ff <alltraps>

8010693e <vector52>:
.globl vector52
vector52:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $52
80106940:	6a 34                	push   $0x34
  jmp alltraps
80106942:	e9 b8 f7 ff ff       	jmp    801060ff <alltraps>

80106947 <vector53>:
.globl vector53
vector53:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $53
80106949:	6a 35                	push   $0x35
  jmp alltraps
8010694b:	e9 af f7 ff ff       	jmp    801060ff <alltraps>

80106950 <vector54>:
.globl vector54
vector54:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $54
80106952:	6a 36                	push   $0x36
  jmp alltraps
80106954:	e9 a6 f7 ff ff       	jmp    801060ff <alltraps>

80106959 <vector55>:
.globl vector55
vector55:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $55
8010695b:	6a 37                	push   $0x37
  jmp alltraps
8010695d:	e9 9d f7 ff ff       	jmp    801060ff <alltraps>

80106962 <vector56>:
.globl vector56
vector56:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $56
80106964:	6a 38                	push   $0x38
  jmp alltraps
80106966:	e9 94 f7 ff ff       	jmp    801060ff <alltraps>

8010696b <vector57>:
.globl vector57
vector57:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $57
8010696d:	6a 39                	push   $0x39
  jmp alltraps
8010696f:	e9 8b f7 ff ff       	jmp    801060ff <alltraps>

80106974 <vector58>:
.globl vector58
vector58:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $58
80106976:	6a 3a                	push   $0x3a
  jmp alltraps
80106978:	e9 82 f7 ff ff       	jmp    801060ff <alltraps>

8010697d <vector59>:
.globl vector59
vector59:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $59
8010697f:	6a 3b                	push   $0x3b
  jmp alltraps
80106981:	e9 79 f7 ff ff       	jmp    801060ff <alltraps>

80106986 <vector60>:
.globl vector60
vector60:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $60
80106988:	6a 3c                	push   $0x3c
  jmp alltraps
8010698a:	e9 70 f7 ff ff       	jmp    801060ff <alltraps>

8010698f <vector61>:
.globl vector61
vector61:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $61
80106991:	6a 3d                	push   $0x3d
  jmp alltraps
80106993:	e9 67 f7 ff ff       	jmp    801060ff <alltraps>

80106998 <vector62>:
.globl vector62
vector62:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $62
8010699a:	6a 3e                	push   $0x3e
  jmp alltraps
8010699c:	e9 5e f7 ff ff       	jmp    801060ff <alltraps>

801069a1 <vector63>:
.globl vector63
vector63:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $63
801069a3:	6a 3f                	push   $0x3f
  jmp alltraps
801069a5:	e9 55 f7 ff ff       	jmp    801060ff <alltraps>

801069aa <vector64>:
.globl vector64
vector64:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $64
801069ac:	6a 40                	push   $0x40
  jmp alltraps
801069ae:	e9 4c f7 ff ff       	jmp    801060ff <alltraps>

801069b3 <vector65>:
.globl vector65
vector65:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $65
801069b5:	6a 41                	push   $0x41
  jmp alltraps
801069b7:	e9 43 f7 ff ff       	jmp    801060ff <alltraps>

801069bc <vector66>:
.globl vector66
vector66:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $66
801069be:	6a 42                	push   $0x42
  jmp alltraps
801069c0:	e9 3a f7 ff ff       	jmp    801060ff <alltraps>

801069c5 <vector67>:
.globl vector67
vector67:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $67
801069c7:	6a 43                	push   $0x43
  jmp alltraps
801069c9:	e9 31 f7 ff ff       	jmp    801060ff <alltraps>

801069ce <vector68>:
.globl vector68
vector68:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $68
801069d0:	6a 44                	push   $0x44
  jmp alltraps
801069d2:	e9 28 f7 ff ff       	jmp    801060ff <alltraps>

801069d7 <vector69>:
.globl vector69
vector69:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $69
801069d9:	6a 45                	push   $0x45
  jmp alltraps
801069db:	e9 1f f7 ff ff       	jmp    801060ff <alltraps>

801069e0 <vector70>:
.globl vector70
vector70:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $70
801069e2:	6a 46                	push   $0x46
  jmp alltraps
801069e4:	e9 16 f7 ff ff       	jmp    801060ff <alltraps>

801069e9 <vector71>:
.globl vector71
vector71:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $71
801069eb:	6a 47                	push   $0x47
  jmp alltraps
801069ed:	e9 0d f7 ff ff       	jmp    801060ff <alltraps>

801069f2 <vector72>:
.globl vector72
vector72:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $72
801069f4:	6a 48                	push   $0x48
  jmp alltraps
801069f6:	e9 04 f7 ff ff       	jmp    801060ff <alltraps>

801069fb <vector73>:
.globl vector73
vector73:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $73
801069fd:	6a 49                	push   $0x49
  jmp alltraps
801069ff:	e9 fb f6 ff ff       	jmp    801060ff <alltraps>

80106a04 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $74
80106a06:	6a 4a                	push   $0x4a
  jmp alltraps
80106a08:	e9 f2 f6 ff ff       	jmp    801060ff <alltraps>

80106a0d <vector75>:
.globl vector75
vector75:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $75
80106a0f:	6a 4b                	push   $0x4b
  jmp alltraps
80106a11:	e9 e9 f6 ff ff       	jmp    801060ff <alltraps>

80106a16 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $76
80106a18:	6a 4c                	push   $0x4c
  jmp alltraps
80106a1a:	e9 e0 f6 ff ff       	jmp    801060ff <alltraps>

80106a1f <vector77>:
.globl vector77
vector77:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $77
80106a21:	6a 4d                	push   $0x4d
  jmp alltraps
80106a23:	e9 d7 f6 ff ff       	jmp    801060ff <alltraps>

80106a28 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $78
80106a2a:	6a 4e                	push   $0x4e
  jmp alltraps
80106a2c:	e9 ce f6 ff ff       	jmp    801060ff <alltraps>

80106a31 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $79
80106a33:	6a 4f                	push   $0x4f
  jmp alltraps
80106a35:	e9 c5 f6 ff ff       	jmp    801060ff <alltraps>

80106a3a <vector80>:
.globl vector80
vector80:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $80
80106a3c:	6a 50                	push   $0x50
  jmp alltraps
80106a3e:	e9 bc f6 ff ff       	jmp    801060ff <alltraps>

80106a43 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $81
80106a45:	6a 51                	push   $0x51
  jmp alltraps
80106a47:	e9 b3 f6 ff ff       	jmp    801060ff <alltraps>

80106a4c <vector82>:
.globl vector82
vector82:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $82
80106a4e:	6a 52                	push   $0x52
  jmp alltraps
80106a50:	e9 aa f6 ff ff       	jmp    801060ff <alltraps>

80106a55 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $83
80106a57:	6a 53                	push   $0x53
  jmp alltraps
80106a59:	e9 a1 f6 ff ff       	jmp    801060ff <alltraps>

80106a5e <vector84>:
.globl vector84
vector84:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $84
80106a60:	6a 54                	push   $0x54
  jmp alltraps
80106a62:	e9 98 f6 ff ff       	jmp    801060ff <alltraps>

80106a67 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $85
80106a69:	6a 55                	push   $0x55
  jmp alltraps
80106a6b:	e9 8f f6 ff ff       	jmp    801060ff <alltraps>

80106a70 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $86
80106a72:	6a 56                	push   $0x56
  jmp alltraps
80106a74:	e9 86 f6 ff ff       	jmp    801060ff <alltraps>

80106a79 <vector87>:
.globl vector87
vector87:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $87
80106a7b:	6a 57                	push   $0x57
  jmp alltraps
80106a7d:	e9 7d f6 ff ff       	jmp    801060ff <alltraps>

80106a82 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $88
80106a84:	6a 58                	push   $0x58
  jmp alltraps
80106a86:	e9 74 f6 ff ff       	jmp    801060ff <alltraps>

80106a8b <vector89>:
.globl vector89
vector89:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $89
80106a8d:	6a 59                	push   $0x59
  jmp alltraps
80106a8f:	e9 6b f6 ff ff       	jmp    801060ff <alltraps>

80106a94 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $90
80106a96:	6a 5a                	push   $0x5a
  jmp alltraps
80106a98:	e9 62 f6 ff ff       	jmp    801060ff <alltraps>

80106a9d <vector91>:
.globl vector91
vector91:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $91
80106a9f:	6a 5b                	push   $0x5b
  jmp alltraps
80106aa1:	e9 59 f6 ff ff       	jmp    801060ff <alltraps>

80106aa6 <vector92>:
.globl vector92
vector92:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $92
80106aa8:	6a 5c                	push   $0x5c
  jmp alltraps
80106aaa:	e9 50 f6 ff ff       	jmp    801060ff <alltraps>

80106aaf <vector93>:
.globl vector93
vector93:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $93
80106ab1:	6a 5d                	push   $0x5d
  jmp alltraps
80106ab3:	e9 47 f6 ff ff       	jmp    801060ff <alltraps>

80106ab8 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $94
80106aba:	6a 5e                	push   $0x5e
  jmp alltraps
80106abc:	e9 3e f6 ff ff       	jmp    801060ff <alltraps>

80106ac1 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $95
80106ac3:	6a 5f                	push   $0x5f
  jmp alltraps
80106ac5:	e9 35 f6 ff ff       	jmp    801060ff <alltraps>

80106aca <vector96>:
.globl vector96
vector96:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $96
80106acc:	6a 60                	push   $0x60
  jmp alltraps
80106ace:	e9 2c f6 ff ff       	jmp    801060ff <alltraps>

80106ad3 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $97
80106ad5:	6a 61                	push   $0x61
  jmp alltraps
80106ad7:	e9 23 f6 ff ff       	jmp    801060ff <alltraps>

80106adc <vector98>:
.globl vector98
vector98:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $98
80106ade:	6a 62                	push   $0x62
  jmp alltraps
80106ae0:	e9 1a f6 ff ff       	jmp    801060ff <alltraps>

80106ae5 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $99
80106ae7:	6a 63                	push   $0x63
  jmp alltraps
80106ae9:	e9 11 f6 ff ff       	jmp    801060ff <alltraps>

80106aee <vector100>:
.globl vector100
vector100:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $100
80106af0:	6a 64                	push   $0x64
  jmp alltraps
80106af2:	e9 08 f6 ff ff       	jmp    801060ff <alltraps>

80106af7 <vector101>:
.globl vector101
vector101:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $101
80106af9:	6a 65                	push   $0x65
  jmp alltraps
80106afb:	e9 ff f5 ff ff       	jmp    801060ff <alltraps>

80106b00 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $102
80106b02:	6a 66                	push   $0x66
  jmp alltraps
80106b04:	e9 f6 f5 ff ff       	jmp    801060ff <alltraps>

80106b09 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $103
80106b0b:	6a 67                	push   $0x67
  jmp alltraps
80106b0d:	e9 ed f5 ff ff       	jmp    801060ff <alltraps>

80106b12 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $104
80106b14:	6a 68                	push   $0x68
  jmp alltraps
80106b16:	e9 e4 f5 ff ff       	jmp    801060ff <alltraps>

80106b1b <vector105>:
.globl vector105
vector105:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $105
80106b1d:	6a 69                	push   $0x69
  jmp alltraps
80106b1f:	e9 db f5 ff ff       	jmp    801060ff <alltraps>

80106b24 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $106
80106b26:	6a 6a                	push   $0x6a
  jmp alltraps
80106b28:	e9 d2 f5 ff ff       	jmp    801060ff <alltraps>

80106b2d <vector107>:
.globl vector107
vector107:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $107
80106b2f:	6a 6b                	push   $0x6b
  jmp alltraps
80106b31:	e9 c9 f5 ff ff       	jmp    801060ff <alltraps>

80106b36 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $108
80106b38:	6a 6c                	push   $0x6c
  jmp alltraps
80106b3a:	e9 c0 f5 ff ff       	jmp    801060ff <alltraps>

80106b3f <vector109>:
.globl vector109
vector109:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $109
80106b41:	6a 6d                	push   $0x6d
  jmp alltraps
80106b43:	e9 b7 f5 ff ff       	jmp    801060ff <alltraps>

80106b48 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $110
80106b4a:	6a 6e                	push   $0x6e
  jmp alltraps
80106b4c:	e9 ae f5 ff ff       	jmp    801060ff <alltraps>

80106b51 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $111
80106b53:	6a 6f                	push   $0x6f
  jmp alltraps
80106b55:	e9 a5 f5 ff ff       	jmp    801060ff <alltraps>

80106b5a <vector112>:
.globl vector112
vector112:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $112
80106b5c:	6a 70                	push   $0x70
  jmp alltraps
80106b5e:	e9 9c f5 ff ff       	jmp    801060ff <alltraps>

80106b63 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $113
80106b65:	6a 71                	push   $0x71
  jmp alltraps
80106b67:	e9 93 f5 ff ff       	jmp    801060ff <alltraps>

80106b6c <vector114>:
.globl vector114
vector114:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $114
80106b6e:	6a 72                	push   $0x72
  jmp alltraps
80106b70:	e9 8a f5 ff ff       	jmp    801060ff <alltraps>

80106b75 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $115
80106b77:	6a 73                	push   $0x73
  jmp alltraps
80106b79:	e9 81 f5 ff ff       	jmp    801060ff <alltraps>

80106b7e <vector116>:
.globl vector116
vector116:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $116
80106b80:	6a 74                	push   $0x74
  jmp alltraps
80106b82:	e9 78 f5 ff ff       	jmp    801060ff <alltraps>

80106b87 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $117
80106b89:	6a 75                	push   $0x75
  jmp alltraps
80106b8b:	e9 6f f5 ff ff       	jmp    801060ff <alltraps>

80106b90 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $118
80106b92:	6a 76                	push   $0x76
  jmp alltraps
80106b94:	e9 66 f5 ff ff       	jmp    801060ff <alltraps>

80106b99 <vector119>:
.globl vector119
vector119:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $119
80106b9b:	6a 77                	push   $0x77
  jmp alltraps
80106b9d:	e9 5d f5 ff ff       	jmp    801060ff <alltraps>

80106ba2 <vector120>:
.globl vector120
vector120:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $120
80106ba4:	6a 78                	push   $0x78
  jmp alltraps
80106ba6:	e9 54 f5 ff ff       	jmp    801060ff <alltraps>

80106bab <vector121>:
.globl vector121
vector121:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $121
80106bad:	6a 79                	push   $0x79
  jmp alltraps
80106baf:	e9 4b f5 ff ff       	jmp    801060ff <alltraps>

80106bb4 <vector122>:
.globl vector122
vector122:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $122
80106bb6:	6a 7a                	push   $0x7a
  jmp alltraps
80106bb8:	e9 42 f5 ff ff       	jmp    801060ff <alltraps>

80106bbd <vector123>:
.globl vector123
vector123:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $123
80106bbf:	6a 7b                	push   $0x7b
  jmp alltraps
80106bc1:	e9 39 f5 ff ff       	jmp    801060ff <alltraps>

80106bc6 <vector124>:
.globl vector124
vector124:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $124
80106bc8:	6a 7c                	push   $0x7c
  jmp alltraps
80106bca:	e9 30 f5 ff ff       	jmp    801060ff <alltraps>

80106bcf <vector125>:
.globl vector125
vector125:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $125
80106bd1:	6a 7d                	push   $0x7d
  jmp alltraps
80106bd3:	e9 27 f5 ff ff       	jmp    801060ff <alltraps>

80106bd8 <vector126>:
.globl vector126
vector126:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $126
80106bda:	6a 7e                	push   $0x7e
  jmp alltraps
80106bdc:	e9 1e f5 ff ff       	jmp    801060ff <alltraps>

80106be1 <vector127>:
.globl vector127
vector127:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $127
80106be3:	6a 7f                	push   $0x7f
  jmp alltraps
80106be5:	e9 15 f5 ff ff       	jmp    801060ff <alltraps>

80106bea <vector128>:
.globl vector128
vector128:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $128
80106bec:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bf1:	e9 09 f5 ff ff       	jmp    801060ff <alltraps>

80106bf6 <vector129>:
.globl vector129
vector129:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $129
80106bf8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bfd:	e9 fd f4 ff ff       	jmp    801060ff <alltraps>

80106c02 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $130
80106c04:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c09:	e9 f1 f4 ff ff       	jmp    801060ff <alltraps>

80106c0e <vector131>:
.globl vector131
vector131:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $131
80106c10:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c15:	e9 e5 f4 ff ff       	jmp    801060ff <alltraps>

80106c1a <vector132>:
.globl vector132
vector132:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $132
80106c1c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c21:	e9 d9 f4 ff ff       	jmp    801060ff <alltraps>

80106c26 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $133
80106c28:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c2d:	e9 cd f4 ff ff       	jmp    801060ff <alltraps>

80106c32 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $134
80106c34:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c39:	e9 c1 f4 ff ff       	jmp    801060ff <alltraps>

80106c3e <vector135>:
.globl vector135
vector135:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $135
80106c40:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c45:	e9 b5 f4 ff ff       	jmp    801060ff <alltraps>

80106c4a <vector136>:
.globl vector136
vector136:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $136
80106c4c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c51:	e9 a9 f4 ff ff       	jmp    801060ff <alltraps>

80106c56 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $137
80106c58:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c5d:	e9 9d f4 ff ff       	jmp    801060ff <alltraps>

80106c62 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $138
80106c64:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c69:	e9 91 f4 ff ff       	jmp    801060ff <alltraps>

80106c6e <vector139>:
.globl vector139
vector139:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $139
80106c70:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c75:	e9 85 f4 ff ff       	jmp    801060ff <alltraps>

80106c7a <vector140>:
.globl vector140
vector140:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $140
80106c7c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c81:	e9 79 f4 ff ff       	jmp    801060ff <alltraps>

80106c86 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $141
80106c88:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c8d:	e9 6d f4 ff ff       	jmp    801060ff <alltraps>

80106c92 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $142
80106c94:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c99:	e9 61 f4 ff ff       	jmp    801060ff <alltraps>

80106c9e <vector143>:
.globl vector143
vector143:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $143
80106ca0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ca5:	e9 55 f4 ff ff       	jmp    801060ff <alltraps>

80106caa <vector144>:
.globl vector144
vector144:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $144
80106cac:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106cb1:	e9 49 f4 ff ff       	jmp    801060ff <alltraps>

80106cb6 <vector145>:
.globl vector145
vector145:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $145
80106cb8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cbd:	e9 3d f4 ff ff       	jmp    801060ff <alltraps>

80106cc2 <vector146>:
.globl vector146
vector146:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $146
80106cc4:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106cc9:	e9 31 f4 ff ff       	jmp    801060ff <alltraps>

80106cce <vector147>:
.globl vector147
vector147:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $147
80106cd0:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cd5:	e9 25 f4 ff ff       	jmp    801060ff <alltraps>

80106cda <vector148>:
.globl vector148
vector148:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $148
80106cdc:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ce1:	e9 19 f4 ff ff       	jmp    801060ff <alltraps>

80106ce6 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $149
80106ce8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106ced:	e9 0d f4 ff ff       	jmp    801060ff <alltraps>

80106cf2 <vector150>:
.globl vector150
vector150:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $150
80106cf4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cf9:	e9 01 f4 ff ff       	jmp    801060ff <alltraps>

80106cfe <vector151>:
.globl vector151
vector151:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $151
80106d00:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d05:	e9 f5 f3 ff ff       	jmp    801060ff <alltraps>

80106d0a <vector152>:
.globl vector152
vector152:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $152
80106d0c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d11:	e9 e9 f3 ff ff       	jmp    801060ff <alltraps>

80106d16 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $153
80106d18:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d1d:	e9 dd f3 ff ff       	jmp    801060ff <alltraps>

80106d22 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $154
80106d24:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d29:	e9 d1 f3 ff ff       	jmp    801060ff <alltraps>

80106d2e <vector155>:
.globl vector155
vector155:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $155
80106d30:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d35:	e9 c5 f3 ff ff       	jmp    801060ff <alltraps>

80106d3a <vector156>:
.globl vector156
vector156:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $156
80106d3c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d41:	e9 b9 f3 ff ff       	jmp    801060ff <alltraps>

80106d46 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $157
80106d48:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d4d:	e9 ad f3 ff ff       	jmp    801060ff <alltraps>

80106d52 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $158
80106d54:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d59:	e9 a1 f3 ff ff       	jmp    801060ff <alltraps>

80106d5e <vector159>:
.globl vector159
vector159:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $159
80106d60:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d65:	e9 95 f3 ff ff       	jmp    801060ff <alltraps>

80106d6a <vector160>:
.globl vector160
vector160:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $160
80106d6c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d71:	e9 89 f3 ff ff       	jmp    801060ff <alltraps>

80106d76 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $161
80106d78:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d7d:	e9 7d f3 ff ff       	jmp    801060ff <alltraps>

80106d82 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $162
80106d84:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d89:	e9 71 f3 ff ff       	jmp    801060ff <alltraps>

80106d8e <vector163>:
.globl vector163
vector163:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $163
80106d90:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d95:	e9 65 f3 ff ff       	jmp    801060ff <alltraps>

80106d9a <vector164>:
.globl vector164
vector164:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $164
80106d9c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106da1:	e9 59 f3 ff ff       	jmp    801060ff <alltraps>

80106da6 <vector165>:
.globl vector165
vector165:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $165
80106da8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dad:	e9 4d f3 ff ff       	jmp    801060ff <alltraps>

80106db2 <vector166>:
.globl vector166
vector166:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $166
80106db4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106db9:	e9 41 f3 ff ff       	jmp    801060ff <alltraps>

80106dbe <vector167>:
.globl vector167
vector167:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $167
80106dc0:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106dc5:	e9 35 f3 ff ff       	jmp    801060ff <alltraps>

80106dca <vector168>:
.globl vector168
vector168:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $168
80106dcc:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106dd1:	e9 29 f3 ff ff       	jmp    801060ff <alltraps>

80106dd6 <vector169>:
.globl vector169
vector169:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $169
80106dd8:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106ddd:	e9 1d f3 ff ff       	jmp    801060ff <alltraps>

80106de2 <vector170>:
.globl vector170
vector170:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $170
80106de4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106de9:	e9 11 f3 ff ff       	jmp    801060ff <alltraps>

80106dee <vector171>:
.globl vector171
vector171:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $171
80106df0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106df5:	e9 05 f3 ff ff       	jmp    801060ff <alltraps>

80106dfa <vector172>:
.globl vector172
vector172:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $172
80106dfc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e01:	e9 f9 f2 ff ff       	jmp    801060ff <alltraps>

80106e06 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $173
80106e08:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e0d:	e9 ed f2 ff ff       	jmp    801060ff <alltraps>

80106e12 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $174
80106e14:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e19:	e9 e1 f2 ff ff       	jmp    801060ff <alltraps>

80106e1e <vector175>:
.globl vector175
vector175:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $175
80106e20:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e25:	e9 d5 f2 ff ff       	jmp    801060ff <alltraps>

80106e2a <vector176>:
.globl vector176
vector176:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $176
80106e2c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e31:	e9 c9 f2 ff ff       	jmp    801060ff <alltraps>

80106e36 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $177
80106e38:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e3d:	e9 bd f2 ff ff       	jmp    801060ff <alltraps>

80106e42 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $178
80106e44:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e49:	e9 b1 f2 ff ff       	jmp    801060ff <alltraps>

80106e4e <vector179>:
.globl vector179
vector179:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $179
80106e50:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e55:	e9 a5 f2 ff ff       	jmp    801060ff <alltraps>

80106e5a <vector180>:
.globl vector180
vector180:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $180
80106e5c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e61:	e9 99 f2 ff ff       	jmp    801060ff <alltraps>

80106e66 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $181
80106e68:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e6d:	e9 8d f2 ff ff       	jmp    801060ff <alltraps>

80106e72 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $182
80106e74:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e79:	e9 81 f2 ff ff       	jmp    801060ff <alltraps>

80106e7e <vector183>:
.globl vector183
vector183:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $183
80106e80:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e85:	e9 75 f2 ff ff       	jmp    801060ff <alltraps>

80106e8a <vector184>:
.globl vector184
vector184:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $184
80106e8c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e91:	e9 69 f2 ff ff       	jmp    801060ff <alltraps>

80106e96 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $185
80106e98:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e9d:	e9 5d f2 ff ff       	jmp    801060ff <alltraps>

80106ea2 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $186
80106ea4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ea9:	e9 51 f2 ff ff       	jmp    801060ff <alltraps>

80106eae <vector187>:
.globl vector187
vector187:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $187
80106eb0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106eb5:	e9 45 f2 ff ff       	jmp    801060ff <alltraps>

80106eba <vector188>:
.globl vector188
vector188:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $188
80106ebc:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ec1:	e9 39 f2 ff ff       	jmp    801060ff <alltraps>

80106ec6 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ec6:	6a 00                	push   $0x0
  pushl $189
80106ec8:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ecd:	e9 2d f2 ff ff       	jmp    801060ff <alltraps>

80106ed2 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $190
80106ed4:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ed9:	e9 21 f2 ff ff       	jmp    801060ff <alltraps>

80106ede <vector191>:
.globl vector191
vector191:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $191
80106ee0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ee5:	e9 15 f2 ff ff       	jmp    801060ff <alltraps>

80106eea <vector192>:
.globl vector192
vector192:
  pushl $0
80106eea:	6a 00                	push   $0x0
  pushl $192
80106eec:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ef1:	e9 09 f2 ff ff       	jmp    801060ff <alltraps>

80106ef6 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $193
80106ef8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106efd:	e9 fd f1 ff ff       	jmp    801060ff <alltraps>

80106f02 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $194
80106f04:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f09:	e9 f1 f1 ff ff       	jmp    801060ff <alltraps>

80106f0e <vector195>:
.globl vector195
vector195:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $195
80106f10:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f15:	e9 e5 f1 ff ff       	jmp    801060ff <alltraps>

80106f1a <vector196>:
.globl vector196
vector196:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $196
80106f1c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f21:	e9 d9 f1 ff ff       	jmp    801060ff <alltraps>

80106f26 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $197
80106f28:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f2d:	e9 cd f1 ff ff       	jmp    801060ff <alltraps>

80106f32 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $198
80106f34:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f39:	e9 c1 f1 ff ff       	jmp    801060ff <alltraps>

80106f3e <vector199>:
.globl vector199
vector199:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $199
80106f40:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f45:	e9 b5 f1 ff ff       	jmp    801060ff <alltraps>

80106f4a <vector200>:
.globl vector200
vector200:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $200
80106f4c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f51:	e9 a9 f1 ff ff       	jmp    801060ff <alltraps>

80106f56 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $201
80106f58:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f5d:	e9 9d f1 ff ff       	jmp    801060ff <alltraps>

80106f62 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $202
80106f64:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f69:	e9 91 f1 ff ff       	jmp    801060ff <alltraps>

80106f6e <vector203>:
.globl vector203
vector203:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $203
80106f70:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f75:	e9 85 f1 ff ff       	jmp    801060ff <alltraps>

80106f7a <vector204>:
.globl vector204
vector204:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $204
80106f7c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f81:	e9 79 f1 ff ff       	jmp    801060ff <alltraps>

80106f86 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $205
80106f88:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f8d:	e9 6d f1 ff ff       	jmp    801060ff <alltraps>

80106f92 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $206
80106f94:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f99:	e9 61 f1 ff ff       	jmp    801060ff <alltraps>

80106f9e <vector207>:
.globl vector207
vector207:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $207
80106fa0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fa5:	e9 55 f1 ff ff       	jmp    801060ff <alltraps>

80106faa <vector208>:
.globl vector208
vector208:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $208
80106fac:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fb1:	e9 49 f1 ff ff       	jmp    801060ff <alltraps>

80106fb6 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $209
80106fb8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fbd:	e9 3d f1 ff ff       	jmp    801060ff <alltraps>

80106fc2 <vector210>:
.globl vector210
vector210:
  pushl $0
80106fc2:	6a 00                	push   $0x0
  pushl $210
80106fc4:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fc9:	e9 31 f1 ff ff       	jmp    801060ff <alltraps>

80106fce <vector211>:
.globl vector211
vector211:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $211
80106fd0:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fd5:	e9 25 f1 ff ff       	jmp    801060ff <alltraps>

80106fda <vector212>:
.globl vector212
vector212:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $212
80106fdc:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fe1:	e9 19 f1 ff ff       	jmp    801060ff <alltraps>

80106fe6 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $213
80106fe8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fed:	e9 0d f1 ff ff       	jmp    801060ff <alltraps>

80106ff2 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $214
80106ff4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ff9:	e9 01 f1 ff ff       	jmp    801060ff <alltraps>

80106ffe <vector215>:
.globl vector215
vector215:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $215
80107000:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107005:	e9 f5 f0 ff ff       	jmp    801060ff <alltraps>

8010700a <vector216>:
.globl vector216
vector216:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $216
8010700c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107011:	e9 e9 f0 ff ff       	jmp    801060ff <alltraps>

80107016 <vector217>:
.globl vector217
vector217:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $217
80107018:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010701d:	e9 dd f0 ff ff       	jmp    801060ff <alltraps>

80107022 <vector218>:
.globl vector218
vector218:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $218
80107024:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107029:	e9 d1 f0 ff ff       	jmp    801060ff <alltraps>

8010702e <vector219>:
.globl vector219
vector219:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $219
80107030:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107035:	e9 c5 f0 ff ff       	jmp    801060ff <alltraps>

8010703a <vector220>:
.globl vector220
vector220:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $220
8010703c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107041:	e9 b9 f0 ff ff       	jmp    801060ff <alltraps>

80107046 <vector221>:
.globl vector221
vector221:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $221
80107048:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010704d:	e9 ad f0 ff ff       	jmp    801060ff <alltraps>

80107052 <vector222>:
.globl vector222
vector222:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $222
80107054:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107059:	e9 a1 f0 ff ff       	jmp    801060ff <alltraps>

8010705e <vector223>:
.globl vector223
vector223:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $223
80107060:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107065:	e9 95 f0 ff ff       	jmp    801060ff <alltraps>

8010706a <vector224>:
.globl vector224
vector224:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $224
8010706c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107071:	e9 89 f0 ff ff       	jmp    801060ff <alltraps>

80107076 <vector225>:
.globl vector225
vector225:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $225
80107078:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010707d:	e9 7d f0 ff ff       	jmp    801060ff <alltraps>

80107082 <vector226>:
.globl vector226
vector226:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $226
80107084:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107089:	e9 71 f0 ff ff       	jmp    801060ff <alltraps>

8010708e <vector227>:
.globl vector227
vector227:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $227
80107090:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107095:	e9 65 f0 ff ff       	jmp    801060ff <alltraps>

8010709a <vector228>:
.globl vector228
vector228:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $228
8010709c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070a1:	e9 59 f0 ff ff       	jmp    801060ff <alltraps>

801070a6 <vector229>:
.globl vector229
vector229:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $229
801070a8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070ad:	e9 4d f0 ff ff       	jmp    801060ff <alltraps>

801070b2 <vector230>:
.globl vector230
vector230:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $230
801070b4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070b9:	e9 41 f0 ff ff       	jmp    801060ff <alltraps>

801070be <vector231>:
.globl vector231
vector231:
  pushl $0
801070be:	6a 00                	push   $0x0
  pushl $231
801070c0:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070c5:	e9 35 f0 ff ff       	jmp    801060ff <alltraps>

801070ca <vector232>:
.globl vector232
vector232:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $232
801070cc:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070d1:	e9 29 f0 ff ff       	jmp    801060ff <alltraps>

801070d6 <vector233>:
.globl vector233
vector233:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $233
801070d8:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070dd:	e9 1d f0 ff ff       	jmp    801060ff <alltraps>

801070e2 <vector234>:
.globl vector234
vector234:
  pushl $0
801070e2:	6a 00                	push   $0x0
  pushl $234
801070e4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070e9:	e9 11 f0 ff ff       	jmp    801060ff <alltraps>

801070ee <vector235>:
.globl vector235
vector235:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $235
801070f0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070f5:	e9 05 f0 ff ff       	jmp    801060ff <alltraps>

801070fa <vector236>:
.globl vector236
vector236:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $236
801070fc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107101:	e9 f9 ef ff ff       	jmp    801060ff <alltraps>

80107106 <vector237>:
.globl vector237
vector237:
  pushl $0
80107106:	6a 00                	push   $0x0
  pushl $237
80107108:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010710d:	e9 ed ef ff ff       	jmp    801060ff <alltraps>

80107112 <vector238>:
.globl vector238
vector238:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $238
80107114:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107119:	e9 e1 ef ff ff       	jmp    801060ff <alltraps>

8010711e <vector239>:
.globl vector239
vector239:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $239
80107120:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107125:	e9 d5 ef ff ff       	jmp    801060ff <alltraps>

8010712a <vector240>:
.globl vector240
vector240:
  pushl $0
8010712a:	6a 00                	push   $0x0
  pushl $240
8010712c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107131:	e9 c9 ef ff ff       	jmp    801060ff <alltraps>

80107136 <vector241>:
.globl vector241
vector241:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $241
80107138:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010713d:	e9 bd ef ff ff       	jmp    801060ff <alltraps>

80107142 <vector242>:
.globl vector242
vector242:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $242
80107144:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107149:	e9 b1 ef ff ff       	jmp    801060ff <alltraps>

8010714e <vector243>:
.globl vector243
vector243:
  pushl $0
8010714e:	6a 00                	push   $0x0
  pushl $243
80107150:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107155:	e9 a5 ef ff ff       	jmp    801060ff <alltraps>

8010715a <vector244>:
.globl vector244
vector244:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $244
8010715c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107161:	e9 99 ef ff ff       	jmp    801060ff <alltraps>

80107166 <vector245>:
.globl vector245
vector245:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $245
80107168:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010716d:	e9 8d ef ff ff       	jmp    801060ff <alltraps>

80107172 <vector246>:
.globl vector246
vector246:
  pushl $0
80107172:	6a 00                	push   $0x0
  pushl $246
80107174:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107179:	e9 81 ef ff ff       	jmp    801060ff <alltraps>

8010717e <vector247>:
.globl vector247
vector247:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $247
80107180:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107185:	e9 75 ef ff ff       	jmp    801060ff <alltraps>

8010718a <vector248>:
.globl vector248
vector248:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $248
8010718c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107191:	e9 69 ef ff ff       	jmp    801060ff <alltraps>

80107196 <vector249>:
.globl vector249
vector249:
  pushl $0
80107196:	6a 00                	push   $0x0
  pushl $249
80107198:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010719d:	e9 5d ef ff ff       	jmp    801060ff <alltraps>

801071a2 <vector250>:
.globl vector250
vector250:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $250
801071a4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071a9:	e9 51 ef ff ff       	jmp    801060ff <alltraps>

801071ae <vector251>:
.globl vector251
vector251:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $251
801071b0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071b5:	e9 45 ef ff ff       	jmp    801060ff <alltraps>

801071ba <vector252>:
.globl vector252
vector252:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $252
801071bc:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071c1:	e9 39 ef ff ff       	jmp    801060ff <alltraps>

801071c6 <vector253>:
.globl vector253
vector253:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $253
801071c8:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071cd:	e9 2d ef ff ff       	jmp    801060ff <alltraps>

801071d2 <vector254>:
.globl vector254
vector254:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $254
801071d4:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071d9:	e9 21 ef ff ff       	jmp    801060ff <alltraps>

801071de <vector255>:
.globl vector255
vector255:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $255
801071e0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071e5:	e9 15 ef ff ff       	jmp    801060ff <alltraps>

801071ea <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801071ea:	55                   	push   %ebp
801071eb:	89 e5                	mov    %esp,%ebp
801071ed:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801071f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801071f3:	83 e8 01             	sub    $0x1,%eax
801071f6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801071fa:	8b 45 08             	mov    0x8(%ebp),%eax
801071fd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107201:	8b 45 08             	mov    0x8(%ebp),%eax
80107204:	c1 e8 10             	shr    $0x10,%eax
80107207:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010720b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010720e:	0f 01 10             	lgdtl  (%eax)
}
80107211:	c9                   	leave  
80107212:	c3                   	ret    

80107213 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107213:	55                   	push   %ebp
80107214:	89 e5                	mov    %esp,%ebp
80107216:	83 ec 04             	sub    $0x4,%esp
80107219:	8b 45 08             	mov    0x8(%ebp),%eax
8010721c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107220:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107224:	0f 00 d8             	ltr    %ax
}
80107227:	c9                   	leave  
80107228:	c3                   	ret    

80107229 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107229:	55                   	push   %ebp
8010722a:	89 e5                	mov    %esp,%ebp
8010722c:	83 ec 04             	sub    $0x4,%esp
8010722f:	8b 45 08             	mov    0x8(%ebp),%eax
80107232:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107236:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010723a:	8e e8                	mov    %eax,%gs
}
8010723c:	c9                   	leave  
8010723d:	c3                   	ret    

8010723e <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010723e:	55                   	push   %ebp
8010723f:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107241:	8b 45 08             	mov    0x8(%ebp),%eax
80107244:	0f 22 d8             	mov    %eax,%cr3
}
80107247:	5d                   	pop    %ebp
80107248:	c3                   	ret    

80107249 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107249:	55                   	push   %ebp
8010724a:	89 e5                	mov    %esp,%ebp
8010724c:	8b 45 08             	mov    0x8(%ebp),%eax
8010724f:	05 00 00 00 80       	add    $0x80000000,%eax
80107254:	5d                   	pop    %ebp
80107255:	c3                   	ret    

80107256 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107256:	55                   	push   %ebp
80107257:	89 e5                	mov    %esp,%ebp
80107259:	8b 45 08             	mov    0x8(%ebp),%eax
8010725c:	05 00 00 00 80       	add    $0x80000000,%eax
80107261:	5d                   	pop    %ebp
80107262:	c3                   	ret    

80107263 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107263:	55                   	push   %ebp
80107264:	89 e5                	mov    %esp,%ebp
80107266:	53                   	push   %ebx
80107267:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010726a:	e8 ec bb ff ff       	call   80102e5b <cpunum>
8010726f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107275:	05 20 f9 10 80       	add    $0x8010f920,%eax
8010727a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010727d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107280:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107286:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107289:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010728f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107292:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107299:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010729d:	83 e2 f0             	and    $0xfffffff0,%edx
801072a0:	83 ca 0a             	or     $0xa,%edx
801072a3:	88 50 7d             	mov    %dl,0x7d(%eax)
801072a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072ad:	83 ca 10             	or     $0x10,%edx
801072b0:	88 50 7d             	mov    %dl,0x7d(%eax)
801072b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b6:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072ba:	83 e2 9f             	and    $0xffffff9f,%edx
801072bd:	88 50 7d             	mov    %dl,0x7d(%eax)
801072c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072c7:	83 ca 80             	or     $0xffffff80,%edx
801072ca:	88 50 7d             	mov    %dl,0x7d(%eax)
801072cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072d4:	83 ca 0f             	or     $0xf,%edx
801072d7:	88 50 7e             	mov    %dl,0x7e(%eax)
801072da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072dd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072e1:	83 e2 ef             	and    $0xffffffef,%edx
801072e4:	88 50 7e             	mov    %dl,0x7e(%eax)
801072e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ea:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072ee:	83 e2 df             	and    $0xffffffdf,%edx
801072f1:	88 50 7e             	mov    %dl,0x7e(%eax)
801072f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072fb:	83 ca 40             	or     $0x40,%edx
801072fe:	88 50 7e             	mov    %dl,0x7e(%eax)
80107301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107304:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107308:	83 ca 80             	or     $0xffffff80,%edx
8010730b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010730e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107311:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107318:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010731f:	ff ff 
80107321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107324:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010732b:	00 00 
8010732d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107330:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107341:	83 e2 f0             	and    $0xfffffff0,%edx
80107344:	83 ca 02             	or     $0x2,%edx
80107347:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010734d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107350:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107357:	83 ca 10             	or     $0x10,%edx
8010735a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107363:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010736a:	83 e2 9f             	and    $0xffffff9f,%edx
8010736d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107376:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010737d:	83 ca 80             	or     $0xffffff80,%edx
80107380:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107389:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107390:	83 ca 0f             	or     $0xf,%edx
80107393:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073a3:	83 e2 ef             	and    $0xffffffef,%edx
801073a6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073af:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073b6:	83 e2 df             	and    $0xffffffdf,%edx
801073b9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073c9:	83 ca 40             	or     $0x40,%edx
801073cc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073dc:	83 ca 80             	or     $0xffffff80,%edx
801073df:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e8:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f2:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801073f9:	ff ff 
801073fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073fe:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107405:	00 00 
80107407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740a:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107411:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107414:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010741b:	83 e2 f0             	and    $0xfffffff0,%edx
8010741e:	83 ca 0a             	or     $0xa,%edx
80107421:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107431:	83 ca 10             	or     $0x10,%edx
80107434:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010743a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107444:	83 ca 60             	or     $0x60,%edx
80107447:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010744d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107450:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107457:	83 ca 80             	or     $0xffffff80,%edx
8010745a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107463:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010746a:	83 ca 0f             	or     $0xf,%edx
8010746d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107476:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010747d:	83 e2 ef             	and    $0xffffffef,%edx
80107480:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107489:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107490:	83 e2 df             	and    $0xffffffdf,%edx
80107493:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107499:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801074a3:	83 ca 40             	or     $0x40,%edx
801074a6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801074ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074af:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801074b6:	83 ca 80             	or     $0xffffff80,%edx
801074b9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801074bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c2:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074cc:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801074d3:	ff ff 
801074d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d8:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801074df:	00 00 
801074e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e4:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801074eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ee:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801074f5:	83 e2 f0             	and    $0xfffffff0,%edx
801074f8:	83 ca 02             	or     $0x2,%edx
801074fb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107504:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010750b:	83 ca 10             	or     $0x10,%edx
8010750e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107517:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010751e:	83 ca 60             	or     $0x60,%edx
80107521:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107531:	83 ca 80             	or     $0xffffff80,%edx
80107534:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010753a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107544:	83 ca 0f             	or     $0xf,%edx
80107547:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010754d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107550:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107557:	83 e2 ef             	and    $0xffffffef,%edx
8010755a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107563:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010756a:	83 e2 df             	and    $0xffffffdf,%edx
8010756d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107576:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010757d:	83 ca 40             	or     $0x40,%edx
80107580:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107589:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107590:	83 ca 80             	or     $0xffffff80,%edx
80107593:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759c:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801075a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a6:	05 b4 00 00 00       	add    $0xb4,%eax
801075ab:	89 c3                	mov    %eax,%ebx
801075ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b0:	05 b4 00 00 00       	add    $0xb4,%eax
801075b5:	c1 e8 10             	shr    $0x10,%eax
801075b8:	89 c1                	mov    %eax,%ecx
801075ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075bd:	05 b4 00 00 00       	add    $0xb4,%eax
801075c2:	c1 e8 18             	shr    $0x18,%eax
801075c5:	89 c2                	mov    %eax,%edx
801075c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ca:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801075d1:	00 00 
801075d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d6:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801075dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e0:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801075e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e9:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801075f0:	83 e1 f0             	and    $0xfffffff0,%ecx
801075f3:	83 c9 02             	or     $0x2,%ecx
801075f6:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801075fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ff:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107606:	83 c9 10             	or     $0x10,%ecx
80107609:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010760f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107612:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107619:	83 e1 9f             	and    $0xffffff9f,%ecx
8010761c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107625:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010762c:	83 c9 80             	or     $0xffffff80,%ecx
8010762f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107638:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010763f:	83 e1 f0             	and    $0xfffffff0,%ecx
80107642:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764b:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107652:	83 e1 ef             	and    $0xffffffef,%ecx
80107655:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010765b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107665:	83 e1 df             	and    $0xffffffdf,%ecx
80107668:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010766e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107671:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107678:	83 c9 40             	or     $0x40,%ecx
8010767b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107684:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010768b:	83 c9 80             	or     $0xffffff80,%ecx
8010768e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107697:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010769d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a0:	83 c0 70             	add    $0x70,%eax
801076a3:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801076aa:	00 
801076ab:	89 04 24             	mov    %eax,(%esp)
801076ae:	e8 37 fb ff ff       	call   801071ea <lgdt>
  loadgs(SEG_KCPU << 3);
801076b3:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801076ba:	e8 6a fb ff ff       	call   80107229 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801076bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c2:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801076c8:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801076cf:	00 00 00 00 
}
801076d3:	83 c4 24             	add    $0x24,%esp
801076d6:	5b                   	pop    %ebx
801076d7:	5d                   	pop    %ebp
801076d8:	c3                   	ret    

801076d9 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076d9:	55                   	push   %ebp
801076da:	89 e5                	mov    %esp,%ebp
801076dc:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801076df:	8b 45 0c             	mov    0xc(%ebp),%eax
801076e2:	c1 e8 16             	shr    $0x16,%eax
801076e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801076ec:	8b 45 08             	mov    0x8(%ebp),%eax
801076ef:	01 d0                	add    %edx,%eax
801076f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801076f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076f7:	8b 00                	mov    (%eax),%eax
801076f9:	83 e0 01             	and    $0x1,%eax
801076fc:	85 c0                	test   %eax,%eax
801076fe:	74 17                	je     80107717 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107700:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107703:	8b 00                	mov    (%eax),%eax
80107705:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010770a:	89 04 24             	mov    %eax,(%esp)
8010770d:	e8 44 fb ff ff       	call   80107256 <p2v>
80107712:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107715:	eb 4b                	jmp    80107762 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107717:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010771b:	74 0e                	je     8010772b <walkpgdir+0x52>
8010771d:	e8 c0 b3 ff ff       	call   80102ae2 <kalloc>
80107722:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107729:	75 07                	jne    80107732 <walkpgdir+0x59>
      return 0;
8010772b:	b8 00 00 00 00       	mov    $0x0,%eax
80107730:	eb 47                	jmp    80107779 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107732:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107739:	00 
8010773a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107741:	00 
80107742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107745:	89 04 24             	mov    %eax,(%esp)
80107748:	e8 be d5 ff ff       	call   80104d0b <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010774d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107750:	89 04 24             	mov    %eax,(%esp)
80107753:	e8 f1 fa ff ff       	call   80107249 <v2p>
80107758:	83 c8 07             	or     $0x7,%eax
8010775b:	89 c2                	mov    %eax,%edx
8010775d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107760:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107762:	8b 45 0c             	mov    0xc(%ebp),%eax
80107765:	c1 e8 0c             	shr    $0xc,%eax
80107768:	25 ff 03 00 00       	and    $0x3ff,%eax
8010776d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107777:	01 d0                	add    %edx,%eax
}
80107779:	c9                   	leave  
8010777a:	c3                   	ret    

8010777b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010777b:	55                   	push   %ebp
8010777c:	89 e5                	mov    %esp,%ebp
8010777e:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107781:	8b 45 0c             	mov    0xc(%ebp),%eax
80107784:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010778c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010778f:	8b 45 10             	mov    0x10(%ebp),%eax
80107792:	01 d0                	add    %edx,%eax
80107794:	83 e8 01             	sub    $0x1,%eax
80107797:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010779c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010779f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801077a6:	00 
801077a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801077ae:	8b 45 08             	mov    0x8(%ebp),%eax
801077b1:	89 04 24             	mov    %eax,(%esp)
801077b4:	e8 20 ff ff ff       	call   801076d9 <walkpgdir>
801077b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801077bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801077c0:	75 07                	jne    801077c9 <mappages+0x4e>
      return -1;
801077c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077c7:	eb 48                	jmp    80107811 <mappages+0x96>
    if(*pte & PTE_P)
801077c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801077cc:	8b 00                	mov    (%eax),%eax
801077ce:	83 e0 01             	and    $0x1,%eax
801077d1:	85 c0                	test   %eax,%eax
801077d3:	74 0c                	je     801077e1 <mappages+0x66>
      panic("remap");
801077d5:	c7 04 24 a8 88 10 80 	movl   $0x801088a8,(%esp)
801077dc:	e8 59 8d ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801077e1:	8b 45 18             	mov    0x18(%ebp),%eax
801077e4:	0b 45 14             	or     0x14(%ebp),%eax
801077e7:	83 c8 01             	or     $0x1,%eax
801077ea:	89 c2                	mov    %eax,%edx
801077ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801077ef:	89 10                	mov    %edx,(%eax)
    if(a == last)
801077f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801077f7:	75 08                	jne    80107801 <mappages+0x86>
      break;
801077f9:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801077fa:	b8 00 00 00 00       	mov    $0x0,%eax
801077ff:	eb 10                	jmp    80107811 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107801:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107808:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010780f:	eb 8e                	jmp    8010779f <mappages+0x24>
  return 0;
}
80107811:	c9                   	leave  
80107812:	c3                   	ret    

80107813 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107813:	55                   	push   %ebp
80107814:	89 e5                	mov    %esp,%ebp
80107816:	53                   	push   %ebx
80107817:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010781a:	e8 c3 b2 ff ff       	call   80102ae2 <kalloc>
8010781f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107826:	75 0a                	jne    80107832 <setupkvm+0x1f>
    return 0;
80107828:	b8 00 00 00 00       	mov    $0x0,%eax
8010782d:	e9 98 00 00 00       	jmp    801078ca <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107832:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107839:	00 
8010783a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107841:	00 
80107842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107845:	89 04 24             	mov    %eax,(%esp)
80107848:	e8 be d4 ff ff       	call   80104d0b <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010784d:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107854:	e8 fd f9 ff ff       	call   80107256 <p2v>
80107859:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010785e:	76 0c                	jbe    8010786c <setupkvm+0x59>
    panic("PHYSTOP too high");
80107860:	c7 04 24 ae 88 10 80 	movl   $0x801088ae,(%esp)
80107867:	e8 ce 8c ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010786c:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107873:	eb 49                	jmp    801078be <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107878:	8b 48 0c             	mov    0xc(%eax),%ecx
8010787b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787e:	8b 50 04             	mov    0x4(%eax),%edx
80107881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107884:	8b 58 08             	mov    0x8(%eax),%ebx
80107887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788a:	8b 40 04             	mov    0x4(%eax),%eax
8010788d:	29 c3                	sub    %eax,%ebx
8010788f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107892:	8b 00                	mov    (%eax),%eax
80107894:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107898:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010789c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801078a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801078a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078a7:	89 04 24             	mov    %eax,(%esp)
801078aa:	e8 cc fe ff ff       	call   8010777b <mappages>
801078af:	85 c0                	test   %eax,%eax
801078b1:	79 07                	jns    801078ba <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801078b3:	b8 00 00 00 00       	mov    $0x0,%eax
801078b8:	eb 10                	jmp    801078ca <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078ba:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801078be:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
801078c5:	72 ae                	jb     80107875 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801078c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801078ca:	83 c4 34             	add    $0x34,%esp
801078cd:	5b                   	pop    %ebx
801078ce:	5d                   	pop    %ebp
801078cf:	c3                   	ret    

801078d0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801078d6:	e8 38 ff ff ff       	call   80107813 <setupkvm>
801078db:	a3 f8 26 11 80       	mov    %eax,0x801126f8
  switchkvm();
801078e0:	e8 02 00 00 00       	call   801078e7 <switchkvm>
}
801078e5:	c9                   	leave  
801078e6:	c3                   	ret    

801078e7 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801078e7:	55                   	push   %ebp
801078e8:	89 e5                	mov    %esp,%ebp
801078ea:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801078ed:	a1 f8 26 11 80       	mov    0x801126f8,%eax
801078f2:	89 04 24             	mov    %eax,(%esp)
801078f5:	e8 4f f9 ff ff       	call   80107249 <v2p>
801078fa:	89 04 24             	mov    %eax,(%esp)
801078fd:	e8 3c f9 ff ff       	call   8010723e <lcr3>
}
80107902:	c9                   	leave  
80107903:	c3                   	ret    

80107904 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107904:	55                   	push   %ebp
80107905:	89 e5                	mov    %esp,%ebp
80107907:	53                   	push   %ebx
80107908:	83 ec 14             	sub    $0x14,%esp
  pushcli();
8010790b:	e8 fb d2 ff ff       	call   80104c0b <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107910:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107916:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010791d:	83 c2 08             	add    $0x8,%edx
80107920:	89 d3                	mov    %edx,%ebx
80107922:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107929:	83 c2 08             	add    $0x8,%edx
8010792c:	c1 ea 10             	shr    $0x10,%edx
8010792f:	89 d1                	mov    %edx,%ecx
80107931:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107938:	83 c2 08             	add    $0x8,%edx
8010793b:	c1 ea 18             	shr    $0x18,%edx
8010793e:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107945:	67 00 
80107947:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
8010794e:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107954:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010795b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010795e:	83 c9 09             	or     $0x9,%ecx
80107961:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107967:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010796e:	83 c9 10             	or     $0x10,%ecx
80107971:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107977:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010797e:	83 e1 9f             	and    $0xffffff9f,%ecx
80107981:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107987:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010798e:	83 c9 80             	or     $0xffffff80,%ecx
80107991:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107997:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010799e:	83 e1 f0             	and    $0xfffffff0,%ecx
801079a1:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801079a7:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801079ae:	83 e1 ef             	and    $0xffffffef,%ecx
801079b1:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801079b7:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801079be:	83 e1 df             	and    $0xffffffdf,%ecx
801079c1:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801079c7:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801079ce:	83 c9 40             	or     $0x40,%ecx
801079d1:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801079d7:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801079de:	83 e1 7f             	and    $0x7f,%ecx
801079e1:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801079e7:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801079ed:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079f3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801079fa:	83 e2 ef             	and    $0xffffffef,%edx
801079fd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107a03:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a09:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107a0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a15:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107a1c:	8b 52 08             	mov    0x8(%edx),%edx
80107a1f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107a25:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107a28:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107a2f:	e8 df f7 ff ff       	call   80107213 <ltr>
  if(p->pgdir == 0)
80107a34:	8b 45 08             	mov    0x8(%ebp),%eax
80107a37:	8b 40 04             	mov    0x4(%eax),%eax
80107a3a:	85 c0                	test   %eax,%eax
80107a3c:	75 0c                	jne    80107a4a <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107a3e:	c7 04 24 bf 88 10 80 	movl   $0x801088bf,(%esp)
80107a45:	e8 f0 8a ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80107a4d:	8b 40 04             	mov    0x4(%eax),%eax
80107a50:	89 04 24             	mov    %eax,(%esp)
80107a53:	e8 f1 f7 ff ff       	call   80107249 <v2p>
80107a58:	89 04 24             	mov    %eax,(%esp)
80107a5b:	e8 de f7 ff ff       	call   8010723e <lcr3>
  popcli();
80107a60:	e8 ea d1 ff ff       	call   80104c4f <popcli>
}
80107a65:	83 c4 14             	add    $0x14,%esp
80107a68:	5b                   	pop    %ebx
80107a69:	5d                   	pop    %ebp
80107a6a:	c3                   	ret    

80107a6b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107a6b:	55                   	push   %ebp
80107a6c:	89 e5                	mov    %esp,%ebp
80107a6e:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107a71:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107a78:	76 0c                	jbe    80107a86 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107a7a:	c7 04 24 d3 88 10 80 	movl   $0x801088d3,(%esp)
80107a81:	e8 b4 8a ff ff       	call   8010053a <panic>
  mem = kalloc();
80107a86:	e8 57 b0 ff ff       	call   80102ae2 <kalloc>
80107a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107a8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a95:	00 
80107a96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a9d:	00 
80107a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa1:	89 04 24             	mov    %eax,(%esp)
80107aa4:	e8 62 d2 ff ff       	call   80104d0b <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aac:	89 04 24             	mov    %eax,(%esp)
80107aaf:	e8 95 f7 ff ff       	call   80107249 <v2p>
80107ab4:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107abb:	00 
80107abc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107ac0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ac7:	00 
80107ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107acf:	00 
80107ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad3:	89 04 24             	mov    %eax,(%esp)
80107ad6:	e8 a0 fc ff ff       	call   8010777b <mappages>
  memmove(mem, init, sz);
80107adb:	8b 45 10             	mov    0x10(%ebp),%eax
80107ade:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aec:	89 04 24             	mov    %eax,(%esp)
80107aef:	e8 e6 d2 ff ff       	call   80104dda <memmove>
}
80107af4:	c9                   	leave  
80107af5:	c3                   	ret    

80107af6 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107af6:	55                   	push   %ebp
80107af7:	89 e5                	mov    %esp,%ebp
80107af9:	53                   	push   %ebx
80107afa:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107afd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b00:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b05:	85 c0                	test   %eax,%eax
80107b07:	74 0c                	je     80107b15 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107b09:	c7 04 24 f0 88 10 80 	movl   $0x801088f0,(%esp)
80107b10:	e8 25 8a ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b1c:	e9 a9 00 00 00       	jmp    80107bca <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b24:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b27:	01 d0                	add    %edx,%eax
80107b29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107b30:	00 
80107b31:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b35:	8b 45 08             	mov    0x8(%ebp),%eax
80107b38:	89 04 24             	mov    %eax,(%esp)
80107b3b:	e8 99 fb ff ff       	call   801076d9 <walkpgdir>
80107b40:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107b43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b47:	75 0c                	jne    80107b55 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107b49:	c7 04 24 13 89 10 80 	movl   $0x80108913,(%esp)
80107b50:	e8 e5 89 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b58:	8b 00                	mov    (%eax),%eax
80107b5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b65:	8b 55 18             	mov    0x18(%ebp),%edx
80107b68:	29 c2                	sub    %eax,%edx
80107b6a:	89 d0                	mov    %edx,%eax
80107b6c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107b71:	77 0f                	ja     80107b82 <loaduvm+0x8c>
      n = sz - i;
80107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b76:	8b 55 18             	mov    0x18(%ebp),%edx
80107b79:	29 c2                	sub    %eax,%edx
80107b7b:	89 d0                	mov    %edx,%eax
80107b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b80:	eb 07                	jmp    80107b89 <loaduvm+0x93>
    else
      n = PGSIZE;
80107b82:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8c:	8b 55 14             	mov    0x14(%ebp),%edx
80107b8f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107b95:	89 04 24             	mov    %eax,(%esp)
80107b98:	e8 b9 f6 ff ff       	call   80107256 <p2v>
80107b9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107ba0:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107ba4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bac:	8b 45 10             	mov    0x10(%ebp),%eax
80107baf:	89 04 24             	mov    %eax,(%esp)
80107bb2:	e8 b1 a1 ff ff       	call   80101d68 <readi>
80107bb7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107bba:	74 07                	je     80107bc3 <loaduvm+0xcd>
      return -1;
80107bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bc1:	eb 18                	jmp    80107bdb <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107bc3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcd:	3b 45 18             	cmp    0x18(%ebp),%eax
80107bd0:	0f 82 4b ff ff ff    	jb     80107b21 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107bdb:	83 c4 24             	add    $0x24,%esp
80107bde:	5b                   	pop    %ebx
80107bdf:	5d                   	pop    %ebp
80107be0:	c3                   	ret    

80107be1 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107be1:	55                   	push   %ebp
80107be2:	89 e5                	mov    %esp,%ebp
80107be4:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107be7:	8b 45 10             	mov    0x10(%ebp),%eax
80107bea:	85 c0                	test   %eax,%eax
80107bec:	79 0a                	jns    80107bf8 <allocuvm+0x17>
    return 0;
80107bee:	b8 00 00 00 00       	mov    $0x0,%eax
80107bf3:	e9 c1 00 00 00       	jmp    80107cb9 <allocuvm+0xd8>
  if(newsz < oldsz)
80107bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80107bfb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107bfe:	73 08                	jae    80107c08 <allocuvm+0x27>
    return oldsz;
80107c00:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c03:	e9 b1 00 00 00       	jmp    80107cb9 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c0b:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107c18:	e9 8d 00 00 00       	jmp    80107caa <allocuvm+0xc9>
    mem = kalloc();
80107c1d:	e8 c0 ae ff ff       	call   80102ae2 <kalloc>
80107c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c29:	75 2c                	jne    80107c57 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107c2b:	c7 04 24 31 89 10 80 	movl   $0x80108931,(%esp)
80107c32:	e8 69 87 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107c37:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c3e:	8b 45 10             	mov    0x10(%ebp),%eax
80107c41:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c45:	8b 45 08             	mov    0x8(%ebp),%eax
80107c48:	89 04 24             	mov    %eax,(%esp)
80107c4b:	e8 6b 00 00 00       	call   80107cbb <deallocuvm>
      return 0;
80107c50:	b8 00 00 00 00       	mov    $0x0,%eax
80107c55:	eb 62                	jmp    80107cb9 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107c57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c5e:	00 
80107c5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c66:	00 
80107c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c6a:	89 04 24             	mov    %eax,(%esp)
80107c6d:	e8 99 d0 ff ff       	call   80104d0b <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c75:	89 04 24             	mov    %eax,(%esp)
80107c78:	e8 cc f5 ff ff       	call   80107249 <v2p>
80107c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c80:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107c87:	00 
80107c88:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107c8c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c93:	00 
80107c94:	89 54 24 04          	mov    %edx,0x4(%esp)
80107c98:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9b:	89 04 24             	mov    %eax,(%esp)
80107c9e:	e8 d8 fa ff ff       	call   8010777b <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107ca3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	3b 45 10             	cmp    0x10(%ebp),%eax
80107cb0:	0f 82 67 ff ff ff    	jb     80107c1d <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107cb6:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107cb9:	c9                   	leave  
80107cba:	c3                   	ret    

80107cbb <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107cbb:	55                   	push   %ebp
80107cbc:	89 e5                	mov    %esp,%ebp
80107cbe:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107cc1:	8b 45 10             	mov    0x10(%ebp),%eax
80107cc4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cc7:	72 08                	jb     80107cd1 <deallocuvm+0x16>
    return oldsz;
80107cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ccc:	e9 a4 00 00 00       	jmp    80107d75 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107cd1:	8b 45 10             	mov    0x10(%ebp),%eax
80107cd4:	05 ff 0f 00 00       	add    $0xfff,%eax
80107cd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107ce1:	e9 80 00 00 00       	jmp    80107d66 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107cf0:	00 
80107cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf8:	89 04 24             	mov    %eax,(%esp)
80107cfb:	e8 d9 f9 ff ff       	call   801076d9 <walkpgdir>
80107d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107d03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d07:	75 09                	jne    80107d12 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107d09:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107d10:	eb 4d                	jmp    80107d5f <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d15:	8b 00                	mov    (%eax),%eax
80107d17:	83 e0 01             	and    $0x1,%eax
80107d1a:	85 c0                	test   %eax,%eax
80107d1c:	74 41                	je     80107d5f <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d21:	8b 00                	mov    (%eax),%eax
80107d23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107d2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107d2f:	75 0c                	jne    80107d3d <deallocuvm+0x82>
        panic("kfree");
80107d31:	c7 04 24 49 89 10 80 	movl   $0x80108949,(%esp)
80107d38:	e8 fd 87 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80107d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d40:	89 04 24             	mov    %eax,(%esp)
80107d43:	e8 0e f5 ff ff       	call   80107256 <p2v>
80107d48:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d4e:	89 04 24             	mov    %eax,(%esp)
80107d51:	e8 f3 ac ff ff       	call   80102a49 <kfree>
      *pte = 0;
80107d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107d5f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d69:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d6c:	0f 82 74 ff ff ff    	jb     80107ce6 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107d72:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d75:	c9                   	leave  
80107d76:	c3                   	ret    

80107d77 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d77:	55                   	push   %ebp
80107d78:	89 e5                	mov    %esp,%ebp
80107d7a:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107d7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107d81:	75 0c                	jne    80107d8f <freevm+0x18>
    panic("freevm: no pgdir");
80107d83:	c7 04 24 4f 89 10 80 	movl   $0x8010894f,(%esp)
80107d8a:	e8 ab 87 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107d8f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107d96:	00 
80107d97:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107d9e:	80 
80107d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80107da2:	89 04 24             	mov    %eax,(%esp)
80107da5:	e8 11 ff ff ff       	call   80107cbb <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107daa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107db1:	eb 48                	jmp    80107dfb <freevm+0x84>
    if(pgdir[i] & PTE_P){
80107db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80107dc0:	01 d0                	add    %edx,%eax
80107dc2:	8b 00                	mov    (%eax),%eax
80107dc4:	83 e0 01             	and    $0x1,%eax
80107dc7:	85 c0                	test   %eax,%eax
80107dc9:	74 2c                	je     80107df7 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd8:	01 d0                	add    %edx,%eax
80107dda:	8b 00                	mov    (%eax),%eax
80107ddc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de1:	89 04 24             	mov    %eax,(%esp)
80107de4:	e8 6d f4 ff ff       	call   80107256 <p2v>
80107de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107def:	89 04 24             	mov    %eax,(%esp)
80107df2:	e8 52 ac ff ff       	call   80102a49 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107df7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107dfb:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107e02:	76 af                	jbe    80107db3 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107e04:	8b 45 08             	mov    0x8(%ebp),%eax
80107e07:	89 04 24             	mov    %eax,(%esp)
80107e0a:	e8 3a ac ff ff       	call   80102a49 <kfree>
}
80107e0f:	c9                   	leave  
80107e10:	c3                   	ret    

80107e11 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e11:	55                   	push   %ebp
80107e12:	89 e5                	mov    %esp,%ebp
80107e14:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e1e:	00 
80107e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e22:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e26:	8b 45 08             	mov    0x8(%ebp),%eax
80107e29:	89 04 24             	mov    %eax,(%esp)
80107e2c:	e8 a8 f8 ff ff       	call   801076d9 <walkpgdir>
80107e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107e38:	75 0c                	jne    80107e46 <clearpteu+0x35>
    panic("clearpteu");
80107e3a:	c7 04 24 60 89 10 80 	movl   $0x80108960,(%esp)
80107e41:	e8 f4 86 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80107e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e49:	8b 00                	mov    (%eax),%eax
80107e4b:	83 e0 fb             	and    $0xfffffffb,%eax
80107e4e:	89 c2                	mov    %eax,%edx
80107e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e53:	89 10                	mov    %edx,(%eax)
}
80107e55:	c9                   	leave  
80107e56:	c3                   	ret    

80107e57 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107e57:	55                   	push   %ebp
80107e58:	89 e5                	mov    %esp,%ebp
80107e5a:	53                   	push   %ebx
80107e5b:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107e5e:	e8 b0 f9 ff ff       	call   80107813 <setupkvm>
80107e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e6a:	75 0a                	jne    80107e76 <copyuvm+0x1f>
    return 0;
80107e6c:	b8 00 00 00 00       	mov    $0x0,%eax
80107e71:	e9 fd 00 00 00       	jmp    80107f73 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80107e76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e7d:	e9 d0 00 00 00       	jmp    80107f52 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e8c:	00 
80107e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e91:	8b 45 08             	mov    0x8(%ebp),%eax
80107e94:	89 04 24             	mov    %eax,(%esp)
80107e97:	e8 3d f8 ff ff       	call   801076d9 <walkpgdir>
80107e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107e9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ea3:	75 0c                	jne    80107eb1 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80107ea5:	c7 04 24 6a 89 10 80 	movl   $0x8010896a,(%esp)
80107eac:	e8 89 86 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80107eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107eb4:	8b 00                	mov    (%eax),%eax
80107eb6:	83 e0 01             	and    $0x1,%eax
80107eb9:	85 c0                	test   %eax,%eax
80107ebb:	75 0c                	jne    80107ec9 <copyuvm+0x72>
      panic("copyuvm: page not present");
80107ebd:	c7 04 24 84 89 10 80 	movl   $0x80108984,(%esp)
80107ec4:	e8 71 86 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ecc:	8b 00                	mov    (%eax),%eax
80107ece:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ed3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ed9:	8b 00                	mov    (%eax),%eax
80107edb:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107ee3:	e8 fa ab ff ff       	call   80102ae2 <kalloc>
80107ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107eeb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107eef:	75 02                	jne    80107ef3 <copyuvm+0x9c>
      goto bad;
80107ef1:	eb 70                	jmp    80107f63 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80107ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ef6:	89 04 24             	mov    %eax,(%esp)
80107ef9:	e8 58 f3 ff ff       	call   80107256 <p2v>
80107efe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f05:	00 
80107f06:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f0d:	89 04 24             	mov    %eax,(%esp)
80107f10:	e8 c5 ce ff ff       	call   80104dda <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80107f15:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107f18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f1b:	89 04 24             	mov    %eax,(%esp)
80107f1e:	e8 26 f3 ff ff       	call   80107249 <v2p>
80107f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f26:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107f2e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f35:	00 
80107f36:	89 54 24 04          	mov    %edx,0x4(%esp)
80107f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f3d:	89 04 24             	mov    %eax,(%esp)
80107f40:	e8 36 f8 ff ff       	call   8010777b <mappages>
80107f45:	85 c0                	test   %eax,%eax
80107f47:	79 02                	jns    80107f4b <copyuvm+0xf4>
      goto bad;
80107f49:	eb 18                	jmp    80107f63 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107f4b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f55:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f58:	0f 82 24 ff ff ff    	jb     80107e82 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80107f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f61:	eb 10                	jmp    80107f73 <copyuvm+0x11c>

bad:
  freevm(d);
80107f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f66:	89 04 24             	mov    %eax,(%esp)
80107f69:	e8 09 fe ff ff       	call   80107d77 <freevm>
  return 0;
80107f6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f73:	83 c4 44             	add    $0x44,%esp
80107f76:	5b                   	pop    %ebx
80107f77:	5d                   	pop    %ebp
80107f78:	c3                   	ret    

80107f79 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f79:	55                   	push   %ebp
80107f7a:	89 e5                	mov    %esp,%ebp
80107f7c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f86:	00 
80107f87:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80107f91:	89 04 24             	mov    %eax,(%esp)
80107f94:	e8 40 f7 ff ff       	call   801076d9 <walkpgdir>
80107f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9f:	8b 00                	mov    (%eax),%eax
80107fa1:	83 e0 01             	and    $0x1,%eax
80107fa4:	85 c0                	test   %eax,%eax
80107fa6:	75 07                	jne    80107faf <uva2ka+0x36>
    return 0;
80107fa8:	b8 00 00 00 00       	mov    $0x0,%eax
80107fad:	eb 25                	jmp    80107fd4 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	8b 00                	mov    (%eax),%eax
80107fb4:	83 e0 04             	and    $0x4,%eax
80107fb7:	85 c0                	test   %eax,%eax
80107fb9:	75 07                	jne    80107fc2 <uva2ka+0x49>
    return 0;
80107fbb:	b8 00 00 00 00       	mov    $0x0,%eax
80107fc0:	eb 12                	jmp    80107fd4 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80107fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc5:	8b 00                	mov    (%eax),%eax
80107fc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fcc:	89 04 24             	mov    %eax,(%esp)
80107fcf:	e8 82 f2 ff ff       	call   80107256 <p2v>
}
80107fd4:	c9                   	leave  
80107fd5:	c3                   	ret    

80107fd6 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107fd6:	55                   	push   %ebp
80107fd7:	89 e5                	mov    %esp,%ebp
80107fd9:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107fdc:	8b 45 10             	mov    0x10(%ebp),%eax
80107fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107fe2:	e9 87 00 00 00       	jmp    8010806e <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80107fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80107ffc:	89 04 24             	mov    %eax,(%esp)
80107fff:	e8 75 ff ff ff       	call   80107f79 <uva2ka>
80108004:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108007:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010800b:	75 07                	jne    80108014 <copyout+0x3e>
      return -1;
8010800d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108012:	eb 69                	jmp    8010807d <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108014:	8b 45 0c             	mov    0xc(%ebp),%eax
80108017:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010801a:	29 c2                	sub    %eax,%edx
8010801c:	89 d0                	mov    %edx,%eax
8010801e:	05 00 10 00 00       	add    $0x1000,%eax
80108023:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108026:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108029:	3b 45 14             	cmp    0x14(%ebp),%eax
8010802c:	76 06                	jbe    80108034 <copyout+0x5e>
      n = len;
8010802e:	8b 45 14             	mov    0x14(%ebp),%eax
80108031:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108034:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108037:	8b 55 0c             	mov    0xc(%ebp),%edx
8010803a:	29 c2                	sub    %eax,%edx
8010803c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010803f:	01 c2                	add    %eax,%edx
80108041:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108044:	89 44 24 08          	mov    %eax,0x8(%esp)
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010804f:	89 14 24             	mov    %edx,(%esp)
80108052:	e8 83 cd ff ff       	call   80104dda <memmove>
    len -= n;
80108057:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010805a:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010805d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108060:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108063:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108066:	05 00 10 00 00       	add    $0x1000,%eax
8010806b:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010806e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108072:	0f 85 6f ff ff ff    	jne    80107fe7 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108078:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010807d:	c9                   	leave  
8010807e:	c3                   	ret    

8010807f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010807f:	55                   	push   %ebp
80108080:	89 e5                	mov    %esp,%ebp
80108082:	83 ec 14             	sub    $0x14,%esp
80108085:	8b 45 08             	mov    0x8(%ebp),%eax
80108088:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010808c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108090:	89 c2                	mov    %eax,%edx
80108092:	ec                   	in     (%dx),%al
80108093:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108096:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010809a:	c9                   	leave  
8010809b:	c3                   	ret    

8010809c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010809c:	55                   	push   %ebp
8010809d:	89 e5                	mov    %esp,%ebp
8010809f:	83 ec 08             	sub    $0x8,%esp
801080a2:	8b 55 08             	mov    0x8(%ebp),%edx
801080a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801080ac:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801080af:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801080b3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801080b7:	ee                   	out    %al,(%dx)
}
801080b8:	c9                   	leave  
801080b9:	c3                   	ret    

801080ba <UIP_status>:
extern int boottime;


uint
UIP_status(void)
{
801080ba:	55                   	push   %ebp
801080bb:	89 e5                	mov    %esp,%ebp
801080bd:	83 ec 18             	sub    $0x18,%esp
  uint uip = 0;
801080c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  outb(RTC_ADDR, UIP_ADDR);
801080c7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801080ce:	00 
801080cf:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801080d6:	e8 c1 ff ff ff       	call   8010809c <outb>
  uip = inb(RTC_DATA);
801080db:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801080e2:	e8 98 ff ff ff       	call   8010807f <inb>
801080e7:	0f b6 c0             	movzbl %al,%eax
801080ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  uip = uip & 0x80;
801080ed:	81 65 fc 80 00 00 00 	andl   $0x80,-0x4(%ebp)
  uip = uip >> 7;
801080f4:	c1 6d fc 07          	shrl   $0x7,-0x4(%ebp)

  return uip;
801080f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801080fb:	c9                   	leave  
801080fc:	c3                   	ret    

801080fd <bcd_to_binary>:


uint
bcd_to_binary(uint num_bcd)
{
801080fd:	55                   	push   %ebp
801080fe:	89 e5                	mov    %esp,%ebp
80108100:	83 ec 10             	sub    $0x10,%esp

  uint digit_one = num_bcd & 15;
80108103:	8b 45 08             	mov    0x8(%ebp),%eax
80108106:	83 e0 0f             	and    $0xf,%eax
80108109:	89 45 fc             	mov    %eax,-0x4(%ebp)
  uint digit_two = (num_bcd >> 4) & 15;
8010810c:	8b 45 08             	mov    0x8(%ebp),%eax
8010810f:	c1 e8 04             	shr    $0x4,%eax
80108112:	83 e0 0f             	and    $0xf,%eax
80108115:	89 45 f8             	mov    %eax,-0x8(%ebp)
  uint result = digit_one + (10*digit_two);
80108118:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010811b:	89 d0                	mov    %edx,%eax
8010811d:	c1 e0 02             	shl    $0x2,%eax
80108120:	01 d0                	add    %edx,%eax
80108122:	01 c0                	add    %eax,%eax
80108124:	89 c2                	mov    %eax,%edx
80108126:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108129:	01 d0                	add    %edx,%eax
8010812b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  return result;
8010812e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80108131:	c9                   	leave  
80108132:	c3                   	ret    

80108133 <mktime>:


uint mktime(const uint year, const uint month,
                   const uint day, const uint hour,
                   const uint min, const uint sec)
{
80108133:	55                   	push   %ebp
80108134:	89 e5                	mov    %esp,%ebp
80108136:	83 ec 10             	sub    $0x10,%esp

  uint mon = month;
80108139:	8b 45 0c             	mov    0xc(%ebp),%eax
8010813c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  uint year1 = year;
8010813f:	8b 45 08             	mov    0x8(%ebp),%eax
80108142:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(0 >= (int) (mon = mon - 2))
80108145:	83 6d fc 02          	subl   $0x2,-0x4(%ebp)
80108149:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010814c:	85 c0                	test   %eax,%eax
8010814e:	7f 08                	jg     80108158 <mktime+0x25>
  {
    mon = mon + 12;
80108150:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
    year1 = year1 - 1;
80108154:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  }

  uint total_seconds = ((((year1/4 - year1/100 + year1/400 + (367*mon)/12 + day) +
80108158:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010815b:	c1 e8 02             	shr    $0x2,%eax
8010815e:	89 c1                	mov    %eax,%ecx
80108160:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108163:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80108168:	f7 e2                	mul    %edx
8010816a:	89 d0                	mov    %edx,%eax
8010816c:	c1 e8 05             	shr    $0x5,%eax
8010816f:	29 c1                	sub    %eax,%ecx
80108171:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108174:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80108179:	f7 e2                	mul    %edx
8010817b:	89 d0                	mov    %edx,%eax
8010817d:	c1 e8 07             	shr    $0x7,%eax
80108180:	01 c1                	add    %eax,%ecx
80108182:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108185:	69 c0 6f 01 00 00    	imul   $0x16f,%eax,%eax
8010818b:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
80108190:	f7 e2                	mul    %edx
80108192:	89 d0                	mov    %edx,%eax
80108194:	c1 e8 03             	shr    $0x3,%eax
80108197:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010819a:	8b 45 10             	mov    0x10(%ebp),%eax
8010819d:	01 c2                	add    %eax,%edx
                           year1*365 - 719499)*24 + hour)*60 + min)*60 + sec;
8010819f:	8b 45 f8             	mov    -0x8(%ebp),%eax
801081a2:	69 c0 6d 01 00 00    	imul   $0x16d,%eax,%eax
  {
    mon = mon + 12;
    year1 = year1 - 1;
  }

  uint total_seconds = ((((year1/4 - year1/100 + year1/400 + (367*mon)/12 + day) +
801081a8:	01 c2                	add    %eax,%edx
                           year1*365 - 719499)*24 + hour)*60 + min)*60 + sec;
801081aa:	89 d0                	mov    %edx,%eax
801081ac:	01 c0                	add    %eax,%eax
801081ae:	01 d0                	add    %edx,%eax
801081b0:	c1 e0 03             	shl    $0x3,%eax
801081b3:	89 c2                	mov    %eax,%edx
801081b5:	8b 45 14             	mov    0x14(%ebp),%eax
801081b8:	01 d0                	add    %edx,%eax
801081ba:	c1 e0 02             	shl    $0x2,%eax
801081bd:	89 c2                	mov    %eax,%edx
801081bf:	c1 e2 04             	shl    $0x4,%edx
801081c2:	29 c2                	sub    %eax,%edx
801081c4:	8b 45 18             	mov    0x18(%ebp),%eax
801081c7:	01 d0                	add    %edx,%eax
801081c9:	c1 e0 02             	shl    $0x2,%eax
801081cc:	89 c2                	mov    %eax,%edx
801081ce:	c1 e2 04             	shl    $0x4,%edx
801081d1:	29 c2                	sub    %eax,%edx
801081d3:	8b 45 1c             	mov    0x1c(%ebp),%eax
801081d6:	01 d0                	add    %edx,%eax
  {
    mon = mon + 12;
    year1 = year1 - 1;
  }

  uint total_seconds = ((((year1/4 - year1/100 + year1/400 + (367*mon)/12 + day) +
801081d8:	2d 80 40 4e 79       	sub    $0x794e4080,%eax
801081dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
                           year1*365 - 719499)*24 + hour)*60 + min)*60 + sec;

  return total_seconds;
801081e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801081e3:	c9                   	leave  
801081e4:	c3                   	ret    

801081e5 <rtc_data>:


uint
rtc_data(const ushort port)
{
801081e5:	55                   	push   %ebp
801081e6:	89 e5                	mov    %esp,%ebp
801081e8:	83 ec 1c             	sub    $0x1c,%esp
801081eb:	8b 45 08             	mov    0x8(%ebp),%eax
801081ee:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  outb(RTC_ADDR, port);
801081f2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801081f6:	0f b6 c0             	movzbl %al,%eax
801081f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801081fd:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80108204:	e8 93 fe ff ff       	call   8010809c <outb>
  uint result = inb(RTC_DATA);
80108209:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80108210:	e8 6a fe ff ff       	call   8010807f <inb>
80108215:	0f b6 c0             	movzbl %al,%eax
80108218:	89 45 fc             	mov    %eax,-0x4(%ebp)

  result = bcd_to_binary(result);
8010821b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010821e:	89 04 24             	mov    %eax,(%esp)
80108221:	e8 d7 fe ff ff       	call   801080fd <bcd_to_binary>
80108226:	89 45 fc             	mov    %eax,-0x4(%ebp)

  return result;
80108229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010822c:	c9                   	leave  
8010822d:	c3                   	ret    

8010822e <rtc_read>:


int
rtc_read(void)
{
8010822e:	55                   	push   %ebp
8010822f:	89 e5                	mov    %esp,%ebp
80108231:	83 ec 38             	sub    $0x38,%esp
  int result = 0;
80108234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  
	while(UIP_status() == 1)
8010823b:	90                   	nop
8010823c:	e8 79 fe ff ff       	call   801080ba <UIP_status>
80108241:	83 f8 01             	cmp    $0x1,%eax
80108244:	74 f6                	je     8010823c <rtc_read+0xe>
  {
    ;
  } 
 
  uint seg = rtc_data(RTC_SEG); // SEGUNDOS
80108246:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010824d:	e8 93 ff ff ff       	call   801081e5 <rtc_data>
80108252:	89 45 f8             	mov    %eax,-0x8(%ebp)
  uint min = rtc_data(RTC_MIN); // MINUTOS
80108255:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010825c:	e8 84 ff ff ff       	call   801081e5 <rtc_data>
80108261:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint hour = rtc_data(RTC_HOUR); // HORAS
80108264:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010826b:	e8 75 ff ff ff       	call   801081e5 <rtc_data>
80108270:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint day = rtc_data(RTC_DAY); // DIAS
80108273:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
8010827a:	e8 66 ff ff ff       	call   801081e5 <rtc_data>
8010827f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint month = rtc_data(RTC_MONTH);// MESES
80108282:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80108289:	e8 57 ff ff ff       	call   801081e5 <rtc_data>
8010828e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint year = rtc_data(RTC_YEAR) + 2000; // AÑO
80108291:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80108298:	e8 48 ff ff ff       	call   801081e5 <rtc_data>
8010829d:	05 d0 07 00 00       	add    $0x7d0,%eax
801082a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  result = mktime(year, month, day, hour, min, seg);
801082a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801082a8:	89 44 24 14          	mov    %eax,0x14(%esp)
801082ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082af:	89 44 24 10          	mov    %eax,0x10(%esp)
801082b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801082ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082bd:	89 44 24 08          	mov    %eax,0x8(%esp)
801082c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801082c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082cb:	89 04 24             	mov    %eax,(%esp)
801082ce:	e8 60 fe ff ff       	call   80108133 <mktime>
801082d3:	89 45 fc             	mov    %eax,-0x4(%ebp)

  return result;
801082d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801082d9:	c9                   	leave  
801082da:	c3                   	ret    

801082db <rtc_init>:


int
rtc_init(void)
{
801082db:	55                   	push   %ebp
801082dc:	89 e5                	mov    %esp,%ebp
801082de:	83 ec 10             	sub    $0x10,%esp
  uint second = rtc_read();
801082e1:	e8 48 ff ff ff       	call   8010822e <rtc_read>
801082e6:	89 45 fc             	mov    %eax,-0x4(%ebp)

  return second;
801082e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801082ec:	c9                   	leave  
801082ed:	c3                   	ret    

801082ee <sys_gettimeofday>:


int
sys_gettimeofday(void)
{
801082ee:	55                   	push   %ebp
801082ef:	89 e5                	mov    %esp,%ebp
801082f1:	83 ec 10             	sub    $0x10,%esp
	uint boottime2 = 0;
801082f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	
	boottime2 = boottime + ticks/100; // a boottime le sumo el tiempo de inicio
801082fb:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80108300:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80108305:	f7 e2                	mul    %edx
80108307:	c1 ea 05             	shr    $0x5,%edx
8010830a:	a1 f0 f8 10 80       	mov    0x8010f8f0,%eax
8010830f:	01 d0                	add    %edx,%eax
80108311:	89 45 fc             	mov    %eax,-0x4(%ebp)
																		// del sistema (ticks/100)
	return boottime2;
80108314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108317:	c9                   	leave  
80108318:	c3                   	ret    
