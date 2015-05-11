Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 11 May 2015 16:01:52 -0400
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150511200149.GA4310@gmail.com>
References: <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
 <20150511143114.GP4003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150511143114.GP4003@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 11, 2015 at 10:31:14AM -0400, Matthew Wilcox wrote:
> On Sat, May 09, 2015 at 10:45:10AM +0200, Ingo Molnar wrote:
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
> >          RAM and we don't have much dirty state. The primary kernel 
> >          cache is the dcache and the directly mapped page cache, which 
> >          is not a writeback cache in this case but essentially a 
> >          logical->physical index cache of filesystem indexing 
> >          metadata.
> > 
> >        - every binary mmap()ed would be XIP mapped in essence
> > 
> >        - every read() would be equivalent a DIO read, without the
> >          complexity of DIO.
> > 
> >        - every read() or write() done into a data mmap() area would
> >          allow device-to-device zero copy DMA.
> > 
> >        - main RAM caching would still be avilable and would work in 
> >          many cases by default: as most apps use file processing 
> >          buffers in anonymous memory into which they read() data.
> 
> I admire your big vision, but I think there are problems that it doesn't
> solve.
> 
> 1. The difference in lifetimes between filesystem blocks and page cache
> pages that represent them.  Existing filesystems have their own block
> allocators which have their own notions of when blocks are available for
> reallocation which may differ from when a page in the page cache can be
> reused for caching another block.
> 
> Concrete example: A mapped page of a file is used as the source or target
> of a direct I/O.  That file is simultaneously truncated, which in our
> current paths calls the filesystem to free the block, while leaving the
> page cache page in place in order to be the source or destination of
> the I/O.  Once the I/O completes, the page's reference count drops to
> zero and the page can be freed.
> 
> If we do not modify the filesystem, that page/block may end up referring
> to a block in a different file, with the usual security & integrity
> problems.
> 
> 2. Some of the media which currently exist (not exactly supported
> well by the current DAX framework either) have great read properties,
> but abysmal write properties.  For example, they may have only a small
> number of write cycles, or they may take milliseconds to absorb a write.
> These media might work well for mapping some read-mostly files directly,
> but be poor choices for putting things like struct page in, which contains
> cachelines which are frquently modified.

I also would like to stress that such solution would not work for me. In
my case the device memory might not even be mappable by the CPU. I admit
that it is an odd case but none the less there are hardware limitation
(PCIE bar size thought we could resize them).

Even in the case where we can map the device memory to the CPU, i would
rather not have any struct page on the device memory. Any kind of small
read to device memory will simply completely break PCIE bandwidth. Each
read and write becomes a PCIE transaction with a minimum payload (128
bytes iirc) and thus all small access will congestion the bus for all
this small transaction effectively crippling the bandwidth of PCIE.

I think the scheme i proposed is easier and can serve not only my case
but also PMEM folks. Use the zero page map read only for all struct page
that are not yet allocated. When one of the filesystem layer (GPU driver
in my case) need to expose a struct page, it does allocate a page and
initialize a valid struct page then replace the zero page with that page
for the given pfn range.

Only performance hurting change is to pfn_to_page() that would need to
test a flag inside the struct page before returning NULL if not set or
struct page otherwise. But i think even that should be fine as anyway
someone asking for the struct page from a pfn is likely to access the
struct page so if pfn_to_page() already deference it then it becomes
hot in cache, like prefetching for the caller.

We can likely avoid TLB flush here (i assume that write fault trigger
the CPU to try update its TLB entry by rewalking the page table instead
of triggering the page fault vector).

Moreover i think only very few place will want to allocate underlying
struct page and thus should be high level in the filesystem stack and
thus can more easily cope with memory starvation. Not to mention we can
design a whole new cache for such allocation.

Cheers,
J�r�me
