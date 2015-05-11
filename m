Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 11 May 2015 10:31:14 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150511143114.GP4003@linux.intel.com>
References: <20150507173641.GA21781@gmail.com>
 <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150509084510.GA10587@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, May 09, 2015 at 10:45:10AM +0200, Ingo Molnar wrote:
> If we 'think big', we can create something very exciting IMHO, that 
> also gets rid of most of the complications with DIO, DAX, etc:
> 
> "Directly mapped pmem integrated into the page cache":
> ------------------------------------------------------
> 
>   - The pmem filesystem is mapped directly in all cases, it has device 
>     side struct page arrays, and its struct pages are directly in the 
>     page cache, write-through cached. (See further below about how we 
>     can do this.)
> 
>     Note that this is radically different from the current approach 
>     that tries to use DIO and DAX to provide specialized "direct
>     access" APIs.
> 
>     With the 'directly mapped' approach we have numerous advantages:
> 
>        - no double buffering to main RAM: the device pages represent 
>          file content.
> 
>        - no bdflush, no VM pressure, no writeback pressure, no
>          swapping: this is a very simple VM model where the device is
>          RAM and we don't have much dirty state. The primary kernel 
>          cache is the dcache and the directly mapped page cache, which 
>          is not a writeback cache in this case but essentially a 
>          logical->physical index cache of filesystem indexing 
>          metadata.
> 
>        - every binary mmap()ed would be XIP mapped in essence
> 
>        - every read() would be equivalent a DIO read, without the
>          complexity of DIO.
> 
>        - every read() or write() done into a data mmap() area would
>          allow device-to-device zero copy DMA.
> 
>        - main RAM caching would still be avilable and would work in 
>          many cases by default: as most apps use file processing 
>          buffers in anonymous memory into which they read() data.

I admire your big vision, but I think there are problems that it doesn't
solve.

1. The difference in lifetimes between filesystem blocks and page cache
pages that represent them.  Existing filesystems have their own block
allocators which have their own notions of when blocks are available for
reallocation which may differ from when a page in the page cache can be
reused for caching another block.

Concrete example: A mapped page of a file is used as the source or target
of a direct I/O.  That file is simultaneously truncated, which in our
current paths calls the filesystem to free the block, while leaving the
page cache page in place in order to be the source or destination of
the I/O.  Once the I/O completes, the page's reference count drops to
zero and the page can be freed.

If we do not modify the filesystem, that page/block may end up referring
to a block in a different file, with the usual security & integrity
problems.

2. Some of the media which currently exist (not exactly supported
well by the current DAX framework either) have great read properties,
but abysmal write properties.  For example, they may have only a small
number of write cycles, or they may take milliseconds to absorb a write.
These media might work well for mapping some read-mostly files directly,
but be poor choices for putting things like struct page in, which contains
cachelines which are frquently modified.

> We can achieve this by statically allocating all page structs on the 
> device, in the following way:
> 
>   - For every 128MB of pmem data we allocate 2MB of struct-page
>     descriptors, 64 bytes each, that describes that 128MB data range 
>     in a 4K granular way. We never have to allocate page structs as 
>     they are always there.
> 
>   - Filesystems don't directly see the preallocated page arrays, they
>     still get a 'logical block space' presented that to them looks
>     like a continuous block device (which is 1.5% smaller than the 
>     true size of the device): this allows arbitrary filesystems to be 
>     put into such pmem devices, fsck will just work, etc.
> 
>     I.e. no special pmem filesystem: the full range of existing block 
>     device based Linux filesystems can be used.

I think the goal of "use any Linux filesystem" is laudable, but
impractical.  Since we're modifying filesystems anyway, is there an
advantage to doing this in the block device instead of just allocating the
struct pages in a special file in the filesystem (like modern filesystems
do for various structures)?

