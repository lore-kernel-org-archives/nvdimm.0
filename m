Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143]) by ml01.01.org (Postfix) with ESMTP id F28961A1DF3
 for <linux-nvdimm@lists.01.org>; Mon,  8 Aug 2016 22:58:52 -0700 (PDT)
Date: Tue, 9 Aug 2016 15:58:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160809055848.GE19025@dastard>
References: <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard>
 <1470335997.8908.128.camel@hpe.com>
 <20160805112739.GG16044@dastard>
 <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808231225.GD19025@dastard>
 <1470704418.32015.51.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470704418.32015.51.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 09, 2016 at 01:00:30AM +0000, Kani, Toshimitsu wrote:
> On Tue, 2016-08-09 at 09:12 +1000, Dave Chinner wrote:
> > On Fri, Aug 05, 2016 at 07:58:33PM +0000, Boylston, Brian wrote:
> > > =

> > > Dave Chinner wrote on 2016-08-05:
> > > > =

> > > > [ cut to just the important points ]
> > > > On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
> > > > > =

> > > > > On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
> > > > > > =

> > > > > > If I drop the fsync from the
> > > > > > buffered IO path, bandwidth remains the same but runtime
> > > > > > drops to 0.55-0.57s, so again the buffered IO write path is
> > > > > > faster than DAX while doing more work.
> > > > > =

> > > > > I do not think the test results are relevant on this point
> > > > > because both buffered and dax write() paths use uncached copy
> > > > > to avoid clflush. =A0The buffered path uses cached copy to the
> > > > > page cache and then use uncached copy to PMEM via writeback.
> > > > > =A0Therefore, the buffered IO path also benefits from using
> > > > > uncached copy to avoid clflush.
> > > > =

> > > > Except that I tested without the writeback path for buffered IO,
> > > > so there was a direct comparison for single cached copy vs single
> > > > uncached copy.
> > > > =

> > > > The undenial fact is that a write() with a single cached copy
> > > > with all the overhead of dirty page tracking is /faster/ than a
> > > > much shorter, simpler IO path that uses an uncached copy. That's
> > > > what the numbers say....
> > > > =

> > > > > =

> > > > > Cached copy (req movq) is slightly faster than uncached copy,
> > > > =

> > > > Not according to Boaz - he claims that uncached is 20% faster
> > > > than cached. How about you two get together, do some benchmarking
> > > > and get your story straight, eh?
> > > > =

> > > > > and should be used for writing to the page cache. =A0For writing
> > > > > to PMEM, however, additional clflush can be expensive, and
> > > > > allocating cachelines for PMEM leads to evict application's
> > > > > cachelines.
> > > > =

> > > > I keep hearing people tell me why cached copies are slower, but
> > > > no-one is providing numbers to back up their statements. The only
> > > > numbers we have are the ones I've published showing cached copies
> > > > w/ full dirty tracking is faster than uncached copy w/o dirty
> > > > tracking.
> > > > =

> > > > Show me the numbers that back up your statements, then I'll
> > > > listen to you.
> > > =

> > > Here are some numbers for a particular scenario, and the code is
> > > below.
> > > =

> > > Time (in seconds) to copy a 16KiB buffer 1M times to a 4MiB NVDIMM
> > > buffer (1M total memcpy()s).=A0=A0For the cached+clflush case, the
> > > flushes are done every 4MiB (which seems slightly faster than
> > > flushing every 16KiB):
> > > =

> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0NUMA local=A0=
=A0=A0=A0NUMA remote
> > > Cached+clflush=A0=A0=A0=A0=A0=A013.5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
37.1
> > > movnt=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A01.0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A01.3=A0
> > =

> > So let's put that in memory bandwidth terms. You wrote 16GB to the
> > NVDIMM.=A0=A0That means:
> > =

> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0NUMA local=A0=A0=
=A0=A0NUMA remote
> > Cached+clflush=A0=A0=A0=A0=A0=A01.2GB/s=A0=A0=A0=A0=A0=A0=A0=A0=A00.43G=
B/s
> > movnt=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A016.0GB/s=A0=A0=A0=A0=A0=
=A0=A0=A0=A012.3GB/s
> > =

> > That smells wrong.=A0=A0The DAX code (using movnt) is not 1-2 orders of
> > magnitude faster than a page cache copy, so I don't believe your
> > benchmark reflects what I'm proposing.
> >
> > What I think you're getting wrong is that we are not doing a clflush
> > after every 16k write when we use the page cache, nor will we do
> > that if we use cached copies, dirty tracking and clflush on fsync().
> =

> As I mentioned before, we do not use clflush on the write path. =A0So,
> your tests did not issue clflush at all.

Uh, yes, I made that clear by saying "using volatile, cached
copies through the page cache, then using fsync() for integrity".
This results in the page cache being written to the nvdimm via
the writeback paths through bios, which the pmem driver does via
movnt() instructions.

And then we send a REQ_FLUSH bio to the device during fsync(), and
that runs nvdimm_flush() which makes sure all the posted writes
are flushed to persistent storage.

I'll also point out that the writeback of the page cache doubled
the runtime of the test, so the second memcpy() using movnt had
basically the same cost as the volatile page cache copy up front.

> > IOWs, the correct equivalent "cached + clflush" loop to a volatile
> > copy with dirty tracking + fsync would be:
> > =

> > 	dstp =3D dst;
> > 	while (--nloops) {
> > 		memcpy(dstp, src, src_sz);	// pwrite();
> > 		dstp +=3D src_sz;
> > 	}
> > =A0=A0=A0=A0=A0=A0=A0=A0pmem_persist(dst, dstsz);	// fsync();
> > =

> > i.e. The cache flushes occur only at the user defined
> > synchronisation point not on every syscall.
> =

> Brian's test is (16 KiB pwrite + fsync) repeated 1M times. =A0It compared
> two approaches in the case of 16 KiB persistent write.

Yes, Brian tested synchronous writes. But:

THAT WAS NOT WHAT I WAS TESTING, PROPOSING OR DISCUSSING!

Seriously, compare apples to apples, don't try to justify comparing
apples to oranges by saying "but we like oranges better".

> I do not
> cosider it wrong, but it indicated that cached copy + clflush will lead
> much higher overhead when sync'd in a finer granularity.

That's true, but only until the next gen CPUs optimise clflush, and
then it will have negliable difference in overhead. IOWs, you are
advocating we optimise for existing, sub-optimal CPU design
constraints, rather than architect a sane data integrity model. A model
which, not by coincidence, will be much better suited to the
capabilities of the next generation of CPUs and so will perform
better than any micro-optimisations we could make now for existing
CPUs.

> I agree that it should have less overhead in total when clflush is done
> at once since it only has to evict as much as the cache size.
> =

> > Yes, if you want to make your copy slow and safe, use O_SYNC to
> > trigger clflush on every write() call - that's what we do for
> > existing storage and the mechanisms are already there; we just need
> > the dirty tracking to optimise it.
> =

> Perhaps, you are referring flushing on disk write cache? =A0I do not
> think clflush as a x86 instruction is used for exisiting storage.

I'm talking about *whatever volatile caches are in layers below the
filesystem*. Stop thinking that pmem is some special little
snowflake - it's not. It's no different to the existing storage
architectures we have to deal with - it has volatile domains that we
have to flush to ensure are flushed to the persistent domain when a
data integrity synchronisation point occurs.

For DAX we use the kernel writeback infrastructure to issue clflush.
We use REQ_FLUSH to get the pmem driver to guarantee persistence of the
posted writes that result from the clflush. That's no different to
writing data via a bio to the SSD and then send REQ_FLUSH to ensure
it is on stable media inside the SSD. These a /generic primitives/
we use to guarantee data integrity, and they apply equally to pmem
as the do all other block and network based storage.

And let's not forget that we can't guarantee data persistence just
though a cache flush or synchronous data write. There is no
guarantee that the filesystem metadata points to the location the
data was written to until a data synchronisation command is given to
the filesystem. The filesystem may have allocated a new block (e.g.
due to a copy-on-write event in a reflinked file) for that data
write so even overwrites are not guaranteed to be persistent until a
fsync/msync/sync/O_[D]SYNC action takes place.

Arguments that movnt is the fastest way to copy data into the
persistent domain completely ignore the the context of the copy in
the data integrity model filesystems present to applications.
Microbenchmarks are good for comparing micro-optimisations, but they
are useless for comparing the merits of high level architecture
decisions.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
