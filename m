Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 21:46:13 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151104044613.GA29575@linux.intel.com>
References: <20151029142950.GE11663@bfoster.bfoster>
 <20151029233756.GS19199@dastard>
 <20151030123657.GC54905@bfoster.bfoster>
 <20151102011433.GW19199@dastard>
 <20151102141509.GA29346@bfoster.bfoster>
 <20151102214424.GJ10656@dastard>
 <CAPcyv4i_D6TuV8B6WF-5JoBdgh9FZbeBim8=s45RnQfhWAVpYg@mail.gmail.com>
 <20151103050413.GB19199@dastard>
 <20151104005056.GA24710@linux.intel.com>
 <CAPcyv4hbrM4+P-8=SXU8BFP8tr1Dw9u1zSU9o0M=wzYjzsp8rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hbrM4+P-8=SXU8BFP8tr1Dw9u1zSU9o0M=wzYjzsp8rw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 03, 2015 at 05:02:34PM -0800, Dan Williams wrote:
> On Tue, Nov 3, 2015 at 4:50 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Tue, Nov 03, 2015 at 04:04:13PM +1100, Dave Chinner wrote:
> >> On Mon, Nov 02, 2015 at 07:53:27PM -0800, Dan Williams wrote:
> >> > On Mon, Nov 2, 2015 at 1:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> > <>
> >> > > This comes back to the comments I made w.r.t. the pmem driver
> >> > > implementation doing synchronous IO by immediately forcing CPU cache
> >> > > flushes and barriers. it's obviously correct, but it looks like
> >> > > there's going to be a major performance penalty associated with it.
> >> > > This is why I recently suggested that a pmem driver that doesn't do
> >> > > CPU cache writeback during IO but does it on REQ_FLUSH is an
> >> > > architecture we'll likely have to support.
> >> > >
> >> >
> >> > The only thing we can realistically delay is wmb_pmem() i.e. the final
> >> > sync waiting for data that has *left* the cpu cache.  Unless/until we
> >> > get a architecturally guaranteed method to write-back the entire
> >> > cache, or flush the cache by physical-cache-way we're stuck with
> >> > either non-temporal cycles or looping on potentially huge virtual
> >> > address ranges.
> >>
> >> I'm missing something: why won't flushing the address range returned
> >> by bdev_direct_access() during a fsync operation work? i.e. we're
> >> working with exactly the same address as dax_clear_blocks() and
> >> dax_do_io() use, so why can't we look up that address and flush it
> >> from fsync?
> >
> > I could be wrong, but I don't see a reason why DAX can't use the strategy of
> > writing data and marking it dirty in one step and then flushing later in
> > response to fsync/msync.  I think this could be used everywhere we write or
> > zero data - dax_clear_blocks(), dax_io() etc.  (I believe that lots of the
> > block zeroing code will go away once we have the XFS and ext4 patches in that
> > guarantee we will only get written and zeroed extents from the filesystem in
> > response to get_block().)  I think the PMEM driver, lacking the ability to
> > mark things as dirty in the radix tree, etc, will need to keep doing things
> > synchronously.
> 
> Not without numbers showing the relative performance of dirtying cache
> followed by flushing vs non-temporal + pcommit.

Sorry - do you mean that you want to make sure that we get a performance
benefit from the "dirty and flush later" path vs the "write and flush now"
path?  Sure, that seems reasonable.

> > Hmm...if we go this path, though, is that an argument against moving the
> > zeroing from DAX down into the driver?  True, with BRD it makes things nice
> > and efficient because you can zero and never flush, and the driver knows
> > there's nothing else to do.
> >
> > For PMEM, though, you lose the ability to zero the data and then queue the
> > flushing for later, as you would be able to do if you left the zeroing code in
> > DAX.  The benefit of this is that if you are going to immediately re-write the
> > newly zeroed data (which seems common), PMEM will end up doing an extra cache
> > flush of the zeroes, only to have them overwritten and marked as dirty by DAX.
> > If we leave the zeroing to DAX we can mark it dirty once, zero it once, write
> > it once, and flush it once.
> 
> Why do we lose the ability to flush later if the driver supports
> blkdev_issue_zeroout?

I think that if you implement zeroing in the driver you'd need to also flush
in the driver because you wouldn't have access to the radix tree to be able to
mark entries as dirty so you can flush them later.

As I think about this more, though, I'm not sure that having the zeroing flush
later could work.  I'm guessing that the filesystem must require a sync point
between the zeroing and the subsequent follow-up writes so that you can sync
metadata for the block allocation.  Otherwise you could end up in a situation
where you've got your metadata pointing at newly allocated blocks but the new
zeros are still in the processor cache - if you lose power you've just created
an information leak.   Dave, Jan, does this make sense?  

> > This would make us lose the ability to do hardware-assisted flushing in the
> > future that requires driver specific knowledge, though I don't think that
> > exists yet.
> 
> ioatdma has supported memset() for a while now, but I would prioritize
> a non-temporal SIMD implementation first.

Sweet, didn't know about that, obviously.  :)  Thanks for the pointer.

> > Perhaps we should leave the zeroing in DAX for now to take
> > advantage of the single flush, and then move it down if a driver can improve
> > performance with hardware assisted PMEM zeroing?
> 
> Not convinced.  I think we should implement the driver zeroing
> solution and take a look at performance.

I agree, this should all be driven by performance measurements.  Thanks for
the feedback.
