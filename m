Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 4 Nov 2015 08:35:51 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151104153551.GA9981@linux.intel.com>
References: <20151030123657.GC54905@bfoster.bfoster>
 <20151102011433.GW19199@dastard>
 <20151102141509.GA29346@bfoster.bfoster>
 <20151102214424.GJ10656@dastard>
 <CAPcyv4i_D6TuV8B6WF-5JoBdgh9FZbeBim8=s45RnQfhWAVpYg@mail.gmail.com>
 <20151103050413.GB19199@dastard>
 <20151104005056.GA24710@linux.intel.com>
 <CAPcyv4hbrM4+P-8=SXU8BFP8tr1Dw9u1zSU9o0M=wzYjzsp8rw@mail.gmail.com>
 <20151104044613.GA29575@linux.intel.com>
 <20151104090612.GA10124@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151104090612.GA10124@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 04, 2015 at 10:06:12AM +0100, Jan Kara wrote:
> On Tue 03-11-15 21:46:13, Ross Zwisler wrote:
> > On Tue, Nov 03, 2015 at 05:02:34PM -0800, Dan Williams wrote:
> > > > Hmm...if we go this path, though, is that an argument against moving the
> > > > zeroing from DAX down into the driver?  True, with BRD it makes things nice
> > > > and efficient because you can zero and never flush, and the driver knows
> > > > there's nothing else to do.
> > > >
> > > > For PMEM, though, you lose the ability to zero the data and then queue the
> > > > flushing for later, as you would be able to do if you left the zeroing code in
> > > > DAX.  The benefit of this is that if you are going to immediately re-write the
> > > > newly zeroed data (which seems common), PMEM will end up doing an extra cache
> > > > flush of the zeroes, only to have them overwritten and marked as dirty by DAX.
> > > > If we leave the zeroing to DAX we can mark it dirty once, zero it once, write
> > > > it once, and flush it once.
> > > 
> > > Why do we lose the ability to flush later if the driver supports
> > > blkdev_issue_zeroout?
> > 
> > I think that if you implement zeroing in the driver you'd need to also
> > flush in the driver because you wouldn't have access to the radix tree to
> > be able to mark entries as dirty so you can flush them later.
> > 
> > As I think about this more, though, I'm not sure that having the zeroing
> > flush later could work.  I'm guessing that the filesystem must require a
> > sync point between the zeroing and the subsequent follow-up writes so
> > that you can sync metadata for the block allocation.  Otherwise you could
> > end up in a situation where you've got your metadata pointing at newly
> > allocated blocks but the new zeros are still in the processor cache - if
> > you lose power you've just created an information leak.   Dave, Jan, does
> > this make sense?  
> 
> So the problem you describe does not exist. Thing to keep in mind is that
> filesystem are designed to work reliably with 'non-persistent' cache in the
> disk which is common these days. That's why we bother with all that
> REQ_FLUSH | REQ_FUA and blkdev_issue_flush() stuff after all. Processor
> cache is exactly that kind of the cache attached to the PMEM storage. And
> Dave and I try to steer you to a solution that would also treat it equally
> in DAX filesystems as well :).

And I'm always grateful for the guidance. :)

> Now how the problem is currently solved: When we allocate blocks, we just
> record that information in a transaction in the journal. For DAX case we
> also submit the IO zeroing those blocks and wait for it. Now if we crash
> before the transaction gets committed, blocks won't be seen in the inode
> after a journal recovery and thus no data exposure can happen. As a part of
> transaction commit, we call blkdev_issue_flush() (or submit REQ_FLUSH
> request). We expect that to force out all the IO in volatile caches into
> the persistent storage. So this will also force the zeroing into persistent
> storage for normal disks and AFAIU if you do zeroing with non-temporal
> writes in pmem driver and then do wmb_pmem() in response to a flush request
> we get the same persistency guarantee in pmem case as well. So after a
> transaction commit we are guaranteed to see zeros in those allocated
> blocks. 
> 
> So the transaction commit and the corresponding flush request in particular
> is the sync point you speak about above but the good thing is that in most
> cases this will happen after real data gets written into those blocks so we
> save the unnecessary flush.

Cool, thank you for the explanation, that makes sense to me.

When dealing with normal SSDs and the page cache, does the filesystem keep the
zeroes in the page cache, or does it issue it directly to the driver via
sb_issue_zeroout()/blkdev_issue_zeroout()?  If we keep it in the page cache so
that the follow-up writes just update the dirty pages and we end up writing to
media once, this seems like it would flow nicely into the idea of zeroing new
blocks at the DAX level without flushing and just marking them as dirty in the
radix tree.  If the zeroing happens via sb_issue_zeroout() then this probably
doesn't make sense because the existing flow won't include a fsync/msync type
step of the newly zeroed data in the page cache.
