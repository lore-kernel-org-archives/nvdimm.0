Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 12 May 2015 10:47:54 -0400
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150512144752.GA4003@gmail.com>
References: <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
 <20150511082536.GP4327@dastard>
 <20150511091836.GA29191@gmail.com>
 <20150512005347.GQ4327@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150512005347.GQ4327@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 12, 2015 at 10:53:47AM +1000, Dave Chinner wrote:
> On Mon, May 11, 2015 at 11:18:36AM +0200, Ingo Molnar wrote:
> 
> > > And, of course, different platforms have different page sizes, so 
> > > designing page array structures to be optimal for x86-64 is just a 
> > > wee bit premature.
> > 
> > 4K is the smallest one on x86 and ARM, and it's also a IMHO pretty 
> > sane default from a human workflow point of view.
> > 
> > But oddball configs with larger page sizes could also be supported at 
> > device creation time (via a simple superblock structure).
> 
> Ok, so now I know it's volatile, why do we need a persistent
> superblock? Why is *anything* persistent required?  And why would
> page size matter if the reserved area is volatile?
> 
> And if it is volatile, then the kernel is effectively doing dynamic
> allocation and initialisation of the struct pages, so why wouldn't
> we just do dynamic allocation out of a slab cache in RAM and free
> them when the last reference to the page goes away? Applications
> aren't going to be able to reference every page in persistent
> memory at the same time...
> 
> Keep in mind we need to design for tens of TB of PRAM at minimum
> (400GB NVDIMMS and tens of them in a single machine are not that far
> away), so static arrays of structures that index 4k blocks is not a
> design that scales to these sizes - it's like using 1980s filesystem
> algorithms for a new filesystem designed for tens of terabytes of
> storage - it can be made to work, but it's just not efficient or
> scalable in the long term.

On having easy pfn<->struct page relation i would agree with Ingo. I
thin it is important. For instance in my case when migrating system
memory to device memory i store a pfn in special swap entry. While
right now i use my own adhoc structure i would rather directly use
a struct page that i can easily find back from the pfn.

In the scheme i proposed you only need to allocate PUD & PMD directory
and use a huge zero page map read only for the whole array at boot time.
When you need a struct page for a given pfn you allocate 2 page, one for
the PMD directory and one for the struct page array for given range of
pfn. Once the struct page is no longer needed you free both page and
turn back to the zero huge page.

So you get dynamic allocation and keep the nice pfn<->struct page mapping
working.

> 
> As an example, look at the current problems with scaling the
> initialisation for struct pages for large memory machines - 16TB
> machines are taking 10 minutes just to initialise the struct page
> arrays on startup. That's the scale of overhead that static page
> arrays will have for PRAM, whether they are lazily initialised or
> not. IOWs, static page arrays are not scalable, and hence aren't a
> viable long term solution to the PRAM problem.

With solution i describe above all you need to initialize is PUD & PMD
directory to point to a zero huge page. I would think this should be
fast enough even for 1TB 2^(40 - 12 - 9 - 9) = 2^10 so you need 1024
PUD and 512K PMD (4M of PUD and 256M of PMD). You can even directly
share PMD and have to dynamicly allocate 3 pages (1 for the PMD level,
1 for the PTE level, 1 for struct page array) effectively reducing to
static 4M allocation for all PUD. Rest being dynamicly allocated/freed
upon useage.

> IMO, we need to be designing around the concept that the filesytem
> manages the pmem space, and the MM subsystem simply uses the block
> mapping information provided to it from the filesystem to decide how
> it references and maps the regions into the user's address space or
> for DMA. The mm subsystem does not manage the pmem space, it's
> alignment or how it is allocated to user files. Hence page mappings
> can only be - at best - reactive to what the filesystem does with
> it's free space. The mm subsystem already has to query the block
> layer to get mappings on page faults, so it's only a small stretch
> to enhance the DAX mapping request to ask for a large page mapping
> rather than a 4k mapping.  If the fs can't do a large page mapping,
> you'll get a 4k aligned mapping back.
> 
> What I'm trying to say is that the mapping behaviour needs to be
> designed with the way filesystems and the mm subsystem interact in
> mind, not from a pre-formed "direct Io is bad, we must use the page
> cache" point of view. The filesystem and the mm subsystem must
> co-operate to allow things like large page mappings to be made and
> hence looking at the problem purely from a mm<->pmem device
> perspective as you are ignores an important chunk of the system:
> the part that actually manages the pmem space...

I am all for letting the filesystem manage pmem, but i think having
struct page expose to mm allow the mm side to stay ignorant of what
is really behind. Also if i could share more code with other i would
be happier :)

Cheers,
J�r�me
