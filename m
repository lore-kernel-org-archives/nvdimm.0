Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 11 May 2015 11:18:36 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150511091836.GA29191@gmail.com>
References: <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
 <20150511082536.GP4327@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150511082536.GP4327@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dave Chinner <david@fromorbit.com> wrote:

> On Sat, May 09, 2015 at 10:45:10AM +0200, Ingo Molnar wrote:
> > 
> > * Rik van Riel <riel@redhat.com> wrote:
> > 
> > > On 05/08/2015 11:54 AM, Linus Torvalds wrote:
> > > > On Fri, May 8, 2015 at 7:40 AM, John Stoffel <john@stoffel.org> wrote:
> > > >>
> > > >> Now go and look at your /home or /data/ or /work areas, where the
> > > >> endusers are actually keeping their day to day work.  Photos, mp3,
> > > >> design files, source code, object code littered around, etc.
> > > > 
> > > > However, the big files in that list are almost immaterial from a
> > > > caching standpoint.
> > > 
> > > > The big files in your home directory? Let me make an educated guess.
> > > > Very few to *none* of them are actually in your page cache right now.
> > > > And you'd never even care if they ever made it into your page cache
> > > > *at*all*. Much less whether you could ever cache them using large
> > > > pages using some very fancy cache.
> > > 
> > > However, for persistent memory, all of the files will be "in 
> > > memory".
> > > 
> > > Not instantiating the 4kB struct pages for 2MB areas that are not 
> > > currently being accessed with small files may make a difference.
> > >
> > > For dynamically allocated 4kB page structs, we need some way to 
> > > discover where they are. It may make sense, from a simplicity point 
> > > of view, to have one mechanism that works both for pmem and for 
> > > normal system memory.
> > 
> > I don't think we need to or want to allocate page structs dynamically, 
> > which makes the model really simple and robust.
> > 
> > If we 'think big', we can create something very exciting IMHO, that 
> > also gets rid of most of the complications with DIO, DAX, etc:
> > 
> > "Directly mapped pmem integrated into the page cache":
> > ------------------------------------------------------
> > 
> >   - The pmem filesystem is mapped directly in all cases, it has device 
> >     side struct page arrays, and its struct pages are directly in the 
> >     page cache, write-through cached. (See further below about how we 
> >     can do this.)
> > 
> >     Note that this is radically different from the current approach 
> >     that tries to use DIO and DAX to provide specialized "direct
> >     access" APIs.
> > 
> >     With the 'directly mapped' approach we have numerous advantages:
> > 
> >        - no double buffering to main RAM: the device pages represent 
> >          file content.
> > 
> >        - no bdflush, no VM pressure, no writeback pressure, no
> >          swapping: this is a very simple VM model where the device is
> 
> But, OTOH, no encryption, no compression, no
> mirroring/redundancy/repair, etc. [...]

mirroring/redundancy/repair should be relatively easy to add without 
hurting the the simplicity of the scheme - but it can also be part of 
the filesystem.

Compression and encryption is not able to directly represent content 
in pram anyway. You could still do per file encryption and 
compression, if the filesystem supports it. Any block based filesystem 
can be used.

> [...] i.e. it's a model where it is impossible to do data 
> transformations in the IO path....

So the limitation is to not do destructive data transformations, so 
that we can map 'storage content' to 'user memory' directly. (FWIMBW)

But you are wrong about mirroring/redundancy/repair: these concepts do 
not require destructive data (content) transformation: they mostly 
work by transforming addresses (or at most adding extra metadata), 
they don't destroy the original content.

> >        - every read() would be equivalent a DIO read, without the
> >          complexity of DIO.
> 
> Sure, it is replaced with the complexity of the buffered read path. 
> Swings and roundabouts.

So you say this as if it was a bad thing, while the regular read() 
path is Linux's main VFS and IO path. So I'm not sure what your point 
is here.

> >        - every read() or write() done into a data mmap() area would
> >          allow device-to-device zero copy DMA.
> > 
> >        - main RAM caching would still be avilable and would work in 
> >          many cases by default: as most apps use file processing 
> >          buffers in anonymous memory into which they read() data.
> > 
> > We can achieve this by statically allocating all page structs on the 
> > device, in the following way:
> > 
> >   - For every 128MB of pmem data we allocate 2MB of struct-page
> >     descriptors, 64 bytes each, that describes that 128MB data range 
> >     in a 4K granular way. We never have to allocate page structs as 
> >     they are always there.
> 
> Who allocates them, when do they get allocated, [...]

Multiple models can be used for that: the simplest would be at device 
creation time with some exceedingly simple tooling that just sets a 
superblock to make it easy to autodetect. (Should the superblock get 
corrupted, it can be re-created with the same parameters, 
non-destructively, etc.)

There's nothing unusual here, there are no extra tradeoffs that I can 
see.

> [...] what happens when they get corrupted?

Nothing unexpected should happen, they get reinitialized on every 
reboot, see the lazy initialization scheme I describe later in the 
proposal.

> >   - Filesystems don't directly see the preallocated page arrays, they
> >     still get a 'logical block space' presented that to them looks
> >     like a continuous block device (which is 1.5% smaller than the 
> >     true size of the device): this allows arbitrary filesystems to be 
> >     put into such pmem devices, fsck will just work, etc.
> 
> Again, what happens when the page arrays get corrupted? You can't 
> just reboot to make the corruption go away.

That's exactly what you can do - just like what you do when the 
regular DRAM page array gets corrupted.

> i.e. what's the architecture of the supporting userspace utilities 
> that are needed to manage this persistent page array area?

The structure is so simple and is essentially lazy initialized again 
from scratch on bootup (like regular RAM page arrays) so that no 
utilities are needed for the kernel to make use of them.

> >     I.e. no special pmem filesystem: the full range of existing block 
> >     device based Linux filesystems can be used.
> > 
> >   - These page structs are initialized in three layers:
> > 
> >        - a single bit at 128MB data granularity: the first struct page
> >          of the 2MB large array (32,768 struct page array members) 
> >          represents the initialization state of all of them.
> > 
> >        - a single bit at 2MB data granularity: the first struct page
> >          of every 32K array within the 2MB array represents the whole
> >          2MB data area. There are 64 such bits per 2MB array.
> > 
> >        - a single bit at 4K data granularity: the whole page array.
> 
> Why wouldn't you just initialise them for the whole device in one 
> go? If they are transparent to the filesystem address space, then 
> you have to reserve space for the entire pmem range up front, so why 
> wouldn't you just initialise them when you reserve the space?

Partly because we don't want to make the contents of struct page an 
ABI, and also because this fits the regular 'memory zone' model 
better.

> >     A page marked uninitialized at a higher layer means all lower
> >     layer struct pages are in their initial state.
> > 
> >     This is a variant of your suggestion: one that keeps everything
> >     2MB aligned, so that a single kernel side 2MB TLB covers a
> >     continuous chunk of the page array. This allows us to create a
> >     linear VMAP physical memory model to simplify index mapping.
> 
> What is doing this aligned allocation of the persistent memory 
> extents? The filesystem, right?

No, it happens at the (block) device level, the filesystem does not 
see anything from this, it's transparent.

> All this talk about page arrays and aligned allocation of pages for 
> mapping as large pages has to come from the filesystem allocating 
> large aligned extents. IOWs, the only way we can get large page 
> mappings in the VM for persistent memory is if the filesystem 
> managing the persistent memory /does the right thing/.

No, it does not come from the filesystem, in my suggested scheme it's 
allocated at the pmem device level.

> And, of course, different platforms have different page sizes, so 
> designing page array structures to be optimal for x86-64 is just a 
> wee bit premature.

4K is the smallest one on x86 and ARM, and it's also a IMHO pretty 
sane default from a human workflow point of view.

But oddball configs with larger page sizes could also be supported at 
device creation time (via a simple superblock structure).

> What we need to do is work out how we are going to tell the 
> filesystem that is managing the persistent memory what the alignment 
> constraints it needs to work under are.

The filesystem does not need to know about any of this: it sees a 
linear, continuous range of storage space - the page arrays are hidden 
from it.

> [...]
> 
> Which comes back to my original question: if the struct page arrays 
> are outside the visibility of the filesystem, how do we manage them 
> in a safe and consistent manner? How do we verify they areD correct 
> coherent with the filesystem using the device when the filesystem 
> knows nothing about page mapping space, and the page mapping space 
> knowns nothing about the contents of the pmem device?

The page arrays are outside the filessystem's visibility just like the 
management of regular main RAM page arrays are outside the 
filesystem's visibility.

> [...] Indeed, how do we do transactionally safe updates to thea page 
> arrays to mark them initialised so that they are atomic w.r.t. the 
> associated filesystem free space state changes?

We don't need transaction safe updates of the 'initialized' bits, as 
the highest level is marked to zero at bootup, we only need them to be 
SMP coherent - which the regular page flag ops guaantee.

> [...] And dare I say "truncate"?

truncate has no relation to this: the filesystem manages its free 
space like it did previously.

Really, I'd be blind to not notice your hostility and I'd like to 
understand its source. What's the problem?

Thanks,

	Ingo
