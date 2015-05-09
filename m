Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sat, 9 May 2015 10:45:10 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: "Directly mapped persistent memory page cache"
Message-ID: <20150509084510.GA10587@gmail.com>
References: <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
 <20150507173641.GA21781@gmail.com>
 <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554CEB5D.90209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Rik van Riel <riel@redhat.com> wrote:

> On 05/08/2015 11:54 AM, Linus Torvalds wrote:
> > On Fri, May 8, 2015 at 7:40 AM, John Stoffel <john@stoffel.org> wrote:
> >>
> >> Now go and look at your /home or /data/ or /work areas, where the
> >> endusers are actually keeping their day to day work.  Photos, mp3,
> >> design files, source code, object code littered around, etc.
> > 
> > However, the big files in that list are almost immaterial from a
> > caching standpoint.
> 
> > The big files in your home directory? Let me make an educated guess.
> > Very few to *none* of them are actually in your page cache right now.
> > And you'd never even care if they ever made it into your page cache
> > *at*all*. Much less whether you could ever cache them using large
> > pages using some very fancy cache.
> 
> However, for persistent memory, all of the files will be "in 
> memory".
> 
> Not instantiating the 4kB struct pages for 2MB areas that are not 
> currently being accessed with small files may make a difference.
>
> For dynamically allocated 4kB page structs, we need some way to 
> discover where they are. It may make sense, from a simplicity point 
> of view, to have one mechanism that works both for pmem and for 
> normal system memory.

I don't think we need to or want to allocate page structs dynamically, 
which makes the model really simple and robust.

If we 'think big', we can create something very exciting IMHO, that 
also gets rid of most of the complications with DIO, DAX, etc:

"Directly mapped pmem integrated into the page cache":
------------------------------------------------------

  - The pmem filesystem is mapped directly in all cases, it has device 
    side struct page arrays, and its struct pages are directly in the 
    page cache, write-through cached. (See further below about how we 
    can do this.)

    Note that this is radically different from the current approach 
    that tries to use DIO and DAX to provide specialized "direct
    access" APIs.

    With the 'directly mapped' approach we have numerous advantages:

       - no double buffering to main RAM: the device pages represent 
         file content.

       - no bdflush, no VM pressure, no writeback pressure, no
         swapping: this is a very simple VM model where the device is
         RAM and we don't have much dirty state. The primary kernel 
         cache is the dcache and the directly mapped page cache, which 
         is not a writeback cache in this case but essentially a 
         logical->physical index cache of filesystem indexing 
         metadata.

       - every binary mmap()ed would be XIP mapped in essence

       - every read() would be equivalent a DIO read, without the
         complexity of DIO.

       - every read() or write() done into a data mmap() area would
         allow device-to-device zero copy DMA.

       - main RAM caching would still be avilable and would work in 
         many cases by default: as most apps use file processing 
         buffers in anonymous memory into which they read() data.

We can achieve this by statically allocating all page structs on the 
device, in the following way:

  - For every 128MB of pmem data we allocate 2MB of struct-page
    descriptors, 64 bytes each, that describes that 128MB data range 
    in a 4K granular way. We never have to allocate page structs as 
    they are always there.

  - Filesystems don't directly see the preallocated page arrays, they
    still get a 'logical block space' presented that to them looks
    like a continuous block device (which is 1.5% smaller than the 
    true size of the device): this allows arbitrary filesystems to be 
    put into such pmem devices, fsck will just work, etc.

    I.e. no special pmem filesystem: the full range of existing block 
    device based Linux filesystems can be used.

  - These page structs are initialized in three layers:

       - a single bit at 128MB data granularity: the first struct page
         of the 2MB large array (32,768 struct page array members) 
         represents the initialization state of all of them.

       - a single bit at 2MB data granularity: the first struct page
         of every 32K array within the 2MB array represents the whole
         2MB data area. There are 64 such bits per 2MB array.

       - a single bit at 4K data granularity: the whole page array.

    A page marked uninitialized at a higher layer means all lower
    layer struct pages are in their initial state.

    This is a variant of your suggestion: one that keeps everything
    2MB aligned, so that a single kernel side 2MB TLB covers a
    continuous chunk of the page array. This allows us to create a
    linear VMAP physical memory model to simplify index mapping.

  - Looking up such a struct page (from a pfn) involves two simple,
    easily computable indirections. With locality of access
    present, 'hot' struct pages will be in the CPU cache. Them being
    64 bytes each will help this. The on-device format is so simple
    and so temporary that no fsck is needed for it.

  - 2MB mappings, where desired, are 'natural' in such a layout:
    everything's 2MB aligned both for kernel and user space use, while
    4K granularity is still a first class citizen as well.

  - For TB range storage we could make it 1GB granular: We'd allocate 
    a 1GB array for every 64 GB of data. This would also allow gbpage 
    TLBs to be taken advantage of: especially on the kernel side 
    (vmapping the 1GB page array) this might be useful, even if all 
    actual file usage is 4KB granular. The last block would be allowed
    to be smaller than 64GB, but size would still be rounded to 1GB to
    keep the mapping simple.

What do you think?

Thanks,

	Ingo
