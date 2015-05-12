Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 12 May 2015 10:53:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150512005347.GQ4327@dastard>
References: <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
 <20150511082536.GP4327@dastard>
 <20150511091836.GA29191@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150511091836.GA29191@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 11, 2015 at 11:18:36AM +0200, Ingo Molnar wrote:
> 
> * Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Sat, May 09, 2015 at 10:45:10AM +0200, Ingo Molnar wrote:
> > > 
> > > * Rik van Riel <riel@redhat.com> wrote:
> > > 
> > > > On 05/08/2015 11:54 AM, Linus Torvalds wrote:
> > > > > On Fri, May 8, 2015 at 7:40 AM, John Stoffel <john@stoffel.org> wrote:
> > > > >>
> > > > >> Now go and look at your /home or /data/ or /work areas, where the
> > > > >> endusers are actually keeping their day to day work.  Photos, mp3,
> > > > >> design files, source code, object code littered around, etc.
> > > > > 
> > > > > However, the big files in that list are almost immaterial from a
> > > > > caching standpoint.
> > > > 
> > > > > The big files in your home directory? Let me make an educated guess.
> > > > > Very few to *none* of them are actually in your page cache right now.
> > > > > And you'd never even care if they ever made it into your page cache
> > > > > *at*all*. Much less whether you could ever cache them using large
> > > > > pages using some very fancy cache.
> > > > 
> > > > However, for persistent memory, all of the files will be "in 
> > > > memory".
> > > > 
> > > > Not instantiating the 4kB struct pages for 2MB areas that are not 
> > > > currently being accessed with small files may make a difference.
> > > >
> > > > For dynamically allocated 4kB page structs, we need some way to 
> > > > discover where they are. It may make sense, from a simplicity point 
> > > > of view, to have one mechanism that works both for pmem and for 
> > > > normal system memory.
> > > 
> > > I don't think we need to or want to allocate page structs dynamically, 
> > > which makes the model really simple and robust.
> > > 
> > > If we 'think big', we can create something very exciting IMHO, that 
> > > also gets rid of most of the complications with DIO, DAX, etc:
> > > 
> > > "Directly mapped pmem integrated into the page cache":
> > > ------------------------------------------------------
> > > 
> > >   - The pmem filesystem is mapped directly in all cases, it has device 
> > >     side struct page arrays, and its struct pages are directly in the 
> > >     page cache, write-through cached. (See further below about how we 
> > >     can do this.)
> > > 
> > >     Note that this is radically different from the current approach 
> > >     that tries to use DIO and DAX to provide specialized "direct
> > >     access" APIs.
> > > 
> > >     With the 'directly mapped' approach we have numerous advantages:
> > > 
> > >        - no double buffering to main RAM: the device pages represent 
> > >          file content.
> > > 
> > >        - no bdflush, no VM pressure, no writeback pressure, no
> > >          swapping: this is a very simple VM model where the device is
> > 
> > But, OTOH, no encryption, no compression, no
> > mirroring/redundancy/repair, etc. [...]
> 
> mirroring/redundancy/repair should be relatively easy to add without 
> hurting the the simplicity of the scheme - but it can also be part of 
> the filesystem.

We already have it in the filesystems and block layer, but the
persistent page cache infrastructure you are proposing makes it
impossible for the existing infrastructure to be used for this
purpose.

> Compression and encryption is not able to directly represent content 
> in pram anyway. You could still do per file encryption and 
> compression, if the filesystem supports it. Any block based filesystem 
> can be used.

Right, but they require a buffered IO path through volatile RAM,
which means treating it just like a normal storage device. IOWs,
if we add persistent page cache paths, the filesystem now will have
to support 3 different IO paths for persistent memory - a) direct
map page cache, b) buffered page cache with readahead and writeback,
and c) direct IO bypassing the page cache.

IOWs, it's not anywhere near as simple as you are implying it will
be. One of the main reasons we chose to use direct IO for DAX was so
we didn't need to add a third IO path to filesystems that wanted to
make use of DAX....

> But you are wrong about mirroring/redundancy/repair: these concepts do 
> not require destructive data (content) transformation: they mostly 
> work by transforming addresses (or at most adding extra metadata), 
> they don't destroy the original content.

You're missing the fact that such data transformations all require
synchronisation of some kind at the IO level - it's way more complex
than just writing to RAM.  e.g. parity/erasure codes need to be
calculated before any update hits the persistent storage, otherwise
the existing codes on disk are invalidated and incorrect. Hence you
cannot use direct mapped page cache (or DAX, for that matter) if the
storage path requires syncronised data updates to multiple locations
to be done.

> > >        - every read() would be equivalent a DIO read, without the
> > >          complexity of DIO.
> > 
> > Sure, it is replaced with the complexity of the buffered read path. 
> > Swings and roundabouts.
> 
> So you say this as if it was a bad thing, while the regular read() 
> path is Linux's main VFS and IO path. So I'm not sure what your point 
> is here.

Just pointing out that the VFS read path is not as simple and fast
as you are implying it is, especially the fact that it is not
designed for low latency, high bandwidth storage.

e.g. the VFS page IO paths are designed completely around hiding the
latency of slow, low bandwidth storage. All that readahead cruft,
dirty page throttling, writeback tracking, etc are all there to hide
crappy storage performance.  In comparison, the direct IO paths have
very little overhead, are optimised for high IOPS and high bandwidth
storage, and are already known to scale to the limits of any storage
subsystem we put under it.  The DIO path is currently a much better
match to the characteristics of persistent memory storage than the
VFS page IO path.

Also, the page IO has significant issues with large pages - no
persistent filesystem actually supports the use of large pages in
the page IO path. i.e all are dependent on PAGE_CACHE_SIZE struct
pages in this path, and that is not easy to change to be dynamic.

IOWs the VFS IO paths will require a fair bit of change to work
well with PRAM class storage, whereas we've only had to make minor
tweaks to the DIO paths to do the same thing...

(And I haven't even mentioned the problems related to filesystems
dependent on bufferheads in the page IO paths!)

> > >        - every read() or write() done into a data mmap() area would
> > >          allow device-to-device zero copy DMA.
> > > 
> > >        - main RAM caching would still be avilable and would work in 
> > >          many cases by default: as most apps use file processing 
> > >          buffers in anonymous memory into which they read() data.
> > > 
> > > We can achieve this by statically allocating all page structs on the 
> > > device, in the following way:
> > > 
> > >   - For every 128MB of pmem data we allocate 2MB of struct-page
> > >     descriptors, 64 bytes each, that describes that 128MB data range 
> > >     in a 4K granular way. We never have to allocate page structs as 
> > >     they are always there.
> > 
> > Who allocates them, when do they get allocated, [...]
> 
> Multiple models can be used for that: the simplest would be at device 
> creation time with some exceedingly simple tooling that just sets a 
> superblock to make it easy to autodetect. (Should the superblock get 
> corrupted, it can be re-created with the same parameters, 
> non-destructively, etc.)

OK, if there's persistent metadata than there's a need for mkfs,
fsck, init tooling, persistent formatting with versioning,
configuration information, etc. Seeing as it will require userspace
tools to manage, it will need a block device to be presented - it's
effectively a special partition. That means libblkid will need to
know about it so various programs won't allow users to accidently
overwrite that partition...

That's kind of my point - you're glossing over this as "simple", but
history and experience tells me that people who think persistent
device management is "simple" get it badly wrong.

> > [...] what happens when they get corrupted?
> 
> Nothing unexpected should happen, they get reinitialized on every 
> reboot, see the lazy initialization scheme I describe later in the 
> proposal.

That was not clear at all from your proposal. "lazy initialisation"
of structures in preallocated persistent storage areas does not mean
"structures are volatile" to anyone who deals with persistent
storage on a day to day basis. Case in point: ext4 lazy inode table
initialisation.

Anyway, I think others have covered the fact that "PRAM as RAM is
not desirable from write latency and endurance POV. That's another
one of the main reasons we didn't go down the persistent page cache
path with DAX ~2 years ago...

> > And, of course, different platforms have different page sizes, so 
> > designing page array structures to be optimal for x86-64 is just a 
> > wee bit premature.
> 
> 4K is the smallest one on x86 and ARM, and it's also a IMHO pretty 
> sane default from a human workflow point of view.
> 
> But oddball configs with larger page sizes could also be supported at 
> device creation time (via a simple superblock structure).

Ok, so now I know it's volatile, why do we need a persistent
superblock? Why is *anything* persistent required?  And why would
page size matter if the reserved area is volatile?

And if it is volatile, then the kernel is effectively doing dynamic
allocation and initialisation of the struct pages, so why wouldn't
we just do dynamic allocation out of a slab cache in RAM and free
them when the last reference to the page goes away? Applications
aren't going to be able to reference every page in persistent
memory at the same time...

Keep in mind we need to design for tens of TB of PRAM at minimum
(400GB NVDIMMS and tens of them in a single machine are not that far
away), so static arrays of structures that index 4k blocks is not a
design that scales to these sizes - it's like using 1980s filesystem
algorithms for a new filesystem designed for tens of terabytes of
storage - it can be made to work, but it's just not efficient or
scalable in the long term.

As an example, look at the current problems with scaling the
initialisation for struct pages for large memory machines - 16TB
machines are taking 10 minutes just to initialise the struct page
arrays on startup. That's the scale of overhead that static page
arrays will have for PRAM, whether they are lazily initialised or
not. IOWs, static page arrays are not scalable, and hence aren't a
viable long term solution to the PRAM problem.

IMO, we need to be designing around the concept that the filesytem
manages the pmem space, and the MM subsystem simply uses the block
mapping information provided to it from the filesystem to decide how
it references and maps the regions into the user's address space or
for DMA. The mm subsystem does not manage the pmem space, it's
alignment or how it is allocated to user files. Hence page mappings
can only be - at best - reactive to what the filesystem does with
it's free space. The mm subsystem already has to query the block
layer to get mappings on page faults, so it's only a small stretch
to enhance the DAX mapping request to ask for a large page mapping
rather than a 4k mapping.  If the fs can't do a large page mapping,
you'll get a 4k aligned mapping back.

What I'm trying to say is that the mapping behaviour needs to be
designed with the way filesystems and the mm subsystem interact in
mind, not from a pre-formed "direct Io is bad, we must use the page
cache" point of view. The filesystem and the mm subsystem must
co-operate to allow things like large page mappings to be made and
hence looking at the problem purely from a mm<->pmem device
perspective as you are ignores an important chunk of the system:
the part that actually manages the pmem space...

> Really, I'd be blind to not notice your hostility and I'd like to 
> understand its source. What's the problem?

Hostile? Take a chill pill, please, Ingo, you've got entirely the
wrong impression.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
