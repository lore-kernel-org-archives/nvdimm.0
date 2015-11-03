Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 16:04:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151103050413.GB19199@dastard>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
 <1445225238-30413-4-git-send-email-david@fromorbit.com>
 <20151029142950.GE11663@bfoster.bfoster>
 <20151029233756.GS19199@dastard>
 <20151030123657.GC54905@bfoster.bfoster>
 <20151102011433.GW19199@dastard>
 <20151102141509.GA29346@bfoster.bfoster>
 <20151102214424.GJ10656@dastard>
 <CAPcyv4i_D6TuV8B6WF-5JoBdgh9FZbeBim8=s45RnQfhWAVpYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4i_D6TuV8B6WF-5JoBdgh9FZbeBim8=s45RnQfhWAVpYg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Brian Foster <bfoster@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 02, 2015 at 07:53:27PM -0800, Dan Williams wrote:
> On Mon, Nov 2, 2015 at 1:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> > [add people to the cc list]
> >
> > On Mon, Nov 02, 2015 at 09:15:10AM -0500, Brian Foster wrote:
> >> On Mon, Nov 02, 2015 at 12:14:33PM +1100, Dave Chinner wrote:
> >> > On Fri, Oct 30, 2015 at 08:36:57AM -0400, Brian Foster wrote:
> >> > > Unless there is some
> >> > > special mixed dio/mmap case I'm missing, doing so for DAX/DIO basically
> >> > > causes a clear_pmem() over every page sized chunk of the target I/O
> >> > > range for which we already have the data.
> >> >
> >> > I don't follow - this only zeros blocks when we do allocation of new
> >> > blocks or overwrite unwritten extents, not on blocks which we
> >> > already have written data extents allocated for...
> >> >
> >>
> >> Why are we assuming that block zeroing is more efficient than unwritten
> >> extents for DAX/dio? I haven't played with pmem enough to know for sure
> >> one way or another (or if hw support is imminent), but I'd expect the
> >> latter to be more efficient in general without any kind of hardware
> >> support.
> >>
> >> Just as an example, here's an 8GB pwrite test, large buffer size, to XFS
> >> on a ramdisk mounted with '-o dax:'
> >>
> >> - Before this series:
> >>
> >> # xfs_io -fc "truncate 0" -c "pwrite -b 10m 0 8g" /mnt/file
> >> wrote 8589934592/8589934592 bytes at offset 0
> >> 8.000 GiB, 820 ops; 0:00:04.00 (1.909 GiB/sec and 195.6591 ops/sec)
> >>
> >> - After this series:
> >>
> >> # xfs_io -fc "truncate 0" -c "pwrite -b 10m 0 8g" /mnt/file
> >> wrote 8589934592/8589934592 bytes at offset 0
> >> 8.000 GiB, 820 ops; 0:00:12.00 (659.790 MiB/sec and 66.0435 ops/sec)
> >
> > That looks wrong. Much, much slower than it should be just zeroing
> > pages and then writing to them again while cache hot.
> >
> > Oh, hell - dax_clear_blocks() is stupidly slow. A profile shows this
> > loop spending most of the CPU time:
> >
> >        �     � jbe    ea
> >        � de:   clflus %ds:(%rax)
> >  84.67 �       add    %rsi,%rax
> >        �       cmp    %rax,%rdx
> >        �     � ja     de
> >        � ea:   add    %r13,-0x38(%rbp)
> >        �       sub    %r12,%r14
> >        �       sub    %r12,-0x40(%rbp)
> >
> > That is the overhead of __arch_wb_cache_pmem() i.e. issuing CPU
> > cache flushes after each memset.
> 
> Ideally this would be non-temporal and skip the second flush loop
> altogether.  Outside of that another problem is that this cpu does not
> support the clwb instruction and is instead using the serializing and
> invalidating clflush instruction.

Sure, it can be optimised to improve behaviour, and other hardware
will be more performant, but we'll still be doing synchronous cache
flushing operations here and so the fundamental problem still
exists.

> > This comes back to the comments I made w.r.t. the pmem driver
> > implementation doing synchronous IO by immediately forcing CPU cache
> > flushes and barriers. it's obviously correct, but it looks like
> > there's going to be a major performance penalty associated with it.
> > This is why I recently suggested that a pmem driver that doesn't do
> > CPU cache writeback during IO but does it on REQ_FLUSH is an
> > architecture we'll likely have to support.
> >
> 
> The only thing we can realistically delay is wmb_pmem() i.e. the final
> sync waiting for data that has *left* the cpu cache.  Unless/until we
> get a architecturally guaranteed method to write-back the entire
> cache, or flush the cache by physical-cache-way we're stuck with
> either non-temporal cycles or looping on potentially huge virtual
> address ranges.

I'm missing something: why won't flushing the address range returned
by bdev_direct_access() during a fsync operation work? i.e. we're
working with exactly the same address as dax_clear_blocks() and
dax_do_io() use, so why can't we look up that address and flush it
from fsync?

> > This, however, is not really a problem for the filesystem - it's
> > a pmem driver architecture problem. ;)
> >
> 
> It's a platform problem.  Let's see how this looks when not using
> clflush instructions.

Yes, clflush vs clwb is that's a platform problem.

However, the architectural problem I've refered to is that is we've
designed the DAX infrastructure around a CPU implementation that
requires synchronous memory flushes for persistence, and so driven
that synchronous flush requirement into the DAX implementation
itself....

> Also, another benefit of pushing zeroing down into the driver is that
> for brd, as used in this example, it will rightly be a nop because
> there's no persistence to guarantee there.

Precisely my point - different drivers and hardware have different
semantics and optimisations, and only by separating the data copying
from the persistence model do we end up with infrastructure that is
flexible enough to work with different hardware/driver pmem models...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
