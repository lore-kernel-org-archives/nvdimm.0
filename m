Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 4 Nov 2015 18:21:48 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151104172148.GB20212@quack.suse.cz>
References: <20151102011433.GW19199@dastard>
 <20151102141509.GA29346@bfoster.bfoster>
 <20151102214424.GJ10656@dastard>
 <CAPcyv4i_D6TuV8B6WF-5JoBdgh9FZbeBim8=s45RnQfhWAVpYg@mail.gmail.com>
 <20151103050413.GB19199@dastard>
 <20151104005056.GA24710@linux.intel.com>
 <CAPcyv4hbrM4+P-8=SXU8BFP8tr1Dw9u1zSU9o0M=wzYjzsp8rw@mail.gmail.com>
 <20151104044613.GA29575@linux.intel.com>
 <20151104090612.GA10124@quack.suse.cz>
 <20151104153551.GA9981@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151104153551.GA9981@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 04-11-15 08:35:51, Ross Zwisler wrote:
> On Wed, Nov 04, 2015 at 10:06:12AM +0100, Jan Kara wrote:
> > Now how the problem is currently solved: When we allocate blocks, we just
> > record that information in a transaction in the journal. For DAX case we
> > also submit the IO zeroing those blocks and wait for it. Now if we crash
> > before the transaction gets committed, blocks won't be seen in the inode
> > after a journal recovery and thus no data exposure can happen. As a part of
> > transaction commit, we call blkdev_issue_flush() (or submit REQ_FLUSH
> > request). We expect that to force out all the IO in volatile caches into
> > the persistent storage. So this will also force the zeroing into persistent
> > storage for normal disks and AFAIU if you do zeroing with non-temporal
> > writes in pmem driver and then do wmb_pmem() in response to a flush request
> > we get the same persistency guarantee in pmem case as well. So after a
> > transaction commit we are guaranteed to see zeros in those allocated
> > blocks. 
> > 
> > So the transaction commit and the corresponding flush request in particular
> > is the sync point you speak about above but the good thing is that in most
> > cases this will happen after real data gets written into those blocks so we
> > save the unnecessary flush.
> 
> Cool, thank you for the explanation, that makes sense to me.
> 
> When dealing with normal SSDs and the page cache, does the filesystem keep the
> zeroes in the page cache, or does it issue it directly to the driver via
> sb_issue_zeroout()/blkdev_issue_zeroout()?  If we keep it in the page cache so

Currently we use sb_issue_zeroout() for zeroing out blocks in ext4 (for DAX
and in some other cases to avoid splitting extents too much).  Note that
zeroing blocks in page cache won't work on it's own - blkdev_issue_flush()
doesn't force out any dirty pages from page cache so transaction commit
wouldn't make sure stale block contents is not exposed.

However we actually do have a mechanism in ext4 to force out data from page
cache during transaction commit - that is what data=ordered mode is all
about - we can attach inode to a transaction and all dirty data of that
inode that has underlying blocks allocated is flushed as a part of
transaction commit. So this makes sure stale data cannot be seen after a
crash in data=ordered mode. XFS doesn't have this mechanism and thus it
normally has to put allocated blocks in unwritten extents, submit IO to
write data to those blocks, and convert extent to written once IO finishes.

> that the follow-up writes just update the dirty pages and we end up
> writing to media once, this seems like it would flow nicely into the idea
> of zeroing new blocks at the DAX level without flushing and just marking
> them as dirty in the radix tree.

So for ext4 you could make this work the same way data=ordered mode works -
just store zeroes into allocated blocks, mark page as dirty in the radix
tree, attach inode to the running transaction, and on transaction commit do
the flush. However note that for DAX page faults zeroing needs to happen
under fs lock serializing faults to the same page which effectively means
it happens inside filesystem's block mapping function and at that place we
don't have a page to zero out. So it would require considerable plumbing to
make this work even for ext4 and I'm not even speaking of XFS where the
flushing mechanism on transaction commit doesn't currently exist AFAIK.

Frankly since the savings would be realized only for allocating writes into
mmaped file which aren't than common, I'm not convinced this would be worth
it.

> If the zeroing happens via sb_issue_zeroout() then this probably doesn't
> make sense because the existing flow won't include a fsync/msync type
> step of the newly zeroed data in the page cache.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
