Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 08:44:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151102214424.GJ10656@dastard>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
 <1445225238-30413-4-git-send-email-david@fromorbit.com>
 <20151029142950.GE11663@bfoster.bfoster>
 <20151029233756.GS19199@dastard>
 <20151030123657.GC54905@bfoster.bfoster>
 <20151102011433.GW19199@dastard>
 <20151102141509.GA29346@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20151102141509.GA29346@bfoster.bfoster>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Brian Foster <bfoster@redhat.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

[add people to the cc list]

On Mon, Nov 02, 2015 at 09:15:10AM -0500, Brian Foster wrote:
> On Mon, Nov 02, 2015 at 12:14:33PM +1100, Dave Chinner wrote:
> > On Fri, Oct 30, 2015 at 08:36:57AM -0400, Brian Foster wrote:
> > > Unless there is some
> > > special mixed dio/mmap case I'm missing, doing so for DAX/DIO basically
> > > causes a clear_pmem() over every page sized chunk of the target I/O
> > > range for which we already have the data.
> > 
> > I don't follow - this only zeros blocks when we do allocation of new
> > blocks or overwrite unwritten extents, not on blocks which we
> > already have written data extents allocated for...
> > 
> 
> Why are we assuming that block zeroing is more efficient than unwritten
> extents for DAX/dio? I haven't played with pmem enough to know for sure
> one way or another (or if hw support is imminent), but I'd expect the
> latter to be more efficient in general without any kind of hardware
> support.
> 
> Just as an example, here's an 8GB pwrite test, large buffer size, to XFS
> on a ramdisk mounted with '-o dax:'
> 
> - Before this series:
> 
> # xfs_io -fc "truncate 0" -c "pwrite -b 10m 0 8g" /mnt/file
> wrote 8589934592/8589934592 bytes at offset 0
> 8.000 GiB, 820 ops; 0:00:04.00 (1.909 GiB/sec and 195.6591 ops/sec)
> 
> - After this series:
> 
> # xfs_io -fc "truncate 0" -c "pwrite -b 10m 0 8g" /mnt/file
> wrote 8589934592/8589934592 bytes at offset 0
> 8.000 GiB, 820 ops; 0:00:12.00 (659.790 MiB/sec and 66.0435 ops/sec)

That looks wrong. Much, much slower than it should be just zeroing
pages and then writing to them again while cache hot.

Oh, hell - dax_clear_blocks() is stupidly slow. A profile shows this
loop spending most of the CPU time:

       �     � jbe    ea
       � de:   clflus %ds:(%rax)
 84.67 �       add    %rsi,%rax
       �       cmp    %rax,%rdx
       �     � ja     de
       � ea:   add    %r13,-0x38(%rbp)
       �       sub    %r12,%r14
       �       sub    %r12,-0x40(%rbp)

That is the overhead of __arch_wb_cache_pmem() i.e. issuing CPU
cache flushes after each memset.

None of these pmem memory operations are optimised yet - the
implementations are correct, but performance still needs work. The
conversion to non-temporal stores should get rid of this cache flush
overhead (somewhat), but I was still expecting this code to be much
closer to memset speed and not reduce performance to bugger all...

> The impact is less with a smaller buffer size so the above is just meant
> to illustrate the point. FWIW, I'm also fine with getting this in as a
> matter of "correctness before performance" since this stuff is clearly
> still under development, but as far as I can see so far we should
> probably ultimately prefer unwritten extents for DAX/DIO (or at least
> plan to run some similar tests on real pmem hw). Thoughts?

We're going to have these problems initially, but from the XFS
persepective those problems don't matter because we have a different
problem to solve.  That is, we need to move towards an architecture
that is highly efficient for low latency, high IOPS storage
subsystems.  The first step towards that is to be able to offload
block zeroing to the hardware so we can avoid using unwritten
extents.

In the long run, we don't want to use unwritten extents on DAX if we
can avoid it - the CPU overhead of unwritten extent conversion isn't
constant (i.e. it grows with the size of the BMBT) and it isn't
deterministic (e.g. split/merge take much more CPU than a simple
record write to clear an unwritten flag). We don't notice this
overhead much with normal IO because of the fact that the CPU time
for conversion is much less than the CPU time for the IO to
complete, hence it's a win.

But for PMEM, directly zeroing a 4k chunk of data should take *much
less CPU* than synchronously starting a transaction, reserving
space, looking up the extent in the BMBT, loading the buffers from
cache, modifying the buffers, logging the changes and committing the
transaction (which in itself will typically copy more than a single
page of metadata into the CIL buffers).

Realistically, dax_clear_blocks() should probably be implemented at
the pmem driver layer through blkdev_issue_zeroout() because all it
does is directly map the sector/len to pfn via bdev_direct_access()
and then zero it - it's a sector based, block device operation. We
don't actually need a special case path for DAX here. Optimisation
of this operation has little to do with the filesystem.

This comes back to the comments I made w.r.t. the pmem driver
implementation doing synchronous IO by immediately forcing CPU cache
flushes and barriers. it's obviously correct, but it looks like
there's going to be a major performance penalty associated with it.
This is why I recently suggested that a pmem driver that doesn't do
CPU cache writeback during IO but does it on REQ_FLUSH is an
architecture we'll likely have to support.

In this case, the block device won't need to flush CPU cache lines
for the zeroed blocks until the allocation transaction is actually
committed to the journal. In that case, there's a good chance that
we'd end up also committing the new data as well, hence avoiding two
synchronous memory writes. i.e. the "big hammer" REQ_FLUSH
implementation may well be *much* faster than fine-grained
synchronous "stable on completion" writes for persistent memory.

This, however, is not really a problem for the filesystem - it's
a pmem driver architecture problem. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
