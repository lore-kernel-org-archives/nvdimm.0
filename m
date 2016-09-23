From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Fri, 23 Sep 2016 15:02:37 -0600
Message-ID: <20160923210237.GA23346@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
 <20160909225557.GF30056@dastard> <20160910073646.GA18547@lst.de>
 <20160913155126.GA10622@linux.intel.com>
 <20160914070633.GA17278@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914070633.GA17278-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 09:06:33AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 13, 2016 at 09:51:26AM -0600, Ross Zwisler wrote:
> > I'm working on this right now.  I expect that most/all of the infrastructure
> > between the bh+get_block_t version and the iomap version to be shared, it'll
> > just be a matter of having a PMD version of the iomap fault handler.  This
> > should be pretty minor.
> 
> Yes, I looked at it (although I didn't do any work yet), and the work
> should be fairly easy.
> 
> > Let's see how it goes, but right now my plan is to have both - I'd like to
> > keep feature parity between ext2/ext4 and XFS, and that means having PMD
> > faults in ext4 via bh+get_block_t until they move over to iomap.
> > 
> > Regarding coordination, the PMD v2 series hasn't gotten much review so far, so
> > I'm not sure it'll go in for v4.9.  At this point I'm planning on just
> > rebasing on top of your iomap series, though if it gets taken sooner I
> > wouldn't object.
> 
> So let's do iomap first.  I've got stable ext2 support, as well as support
> for the block device, although I'm not sure what the proper testing
> protocol for that is.  I've started ext4 and read / zero was easy, but
> now I'm stuck in the convoluted mess that is the ext4 direct I/O and
> DAX path.
> 
> Maybe we should get the iomap work into 4.9 and then convert over ext4
> as well as adding PMD fault support in the next release.

I was doing some testing of my PMD patches, and was surprised to see that
ext4 + PMDs + generic/074 now takes 23 minutes to complete.  With ext4 and
PTEs faults this test takes ~50 seconds in the same setup, and XFS + PMDs
takes 27 seconds.

The root cause is that ext4 is using the direct I/O path for reads and writes,
and that the DIO path thinks it needs to flush dirty data from the radix tree
on each I/O.

Each read ends up writing back PMDs via:

  vfs_read()
    __vfs_read()
      new_sync_read
        generic_file_read_iter()
          filemap_write_and_wait_range()

I believe we have an analogous problem for writes.

This results in us flushing 12 TiB worth of data during the generic/074 test,
one cache line at a time...

With your recent changes to detangle the DAX and DIO faults paths in XFS, we
avoid this because XFS no longer uses generic_file_read_iter(), but instead
uses xfs_file_write_iter() which skips the writeback and instead just calls
xfs_file_dax_write() to do the I/O.

This is obviously an existing issue in ext4 that we need to address.  Even
with the PTE path we are doing tons of unnecessary flushing, but the move from
flushing PTEs to flushing PMDs is what killed us.

I can just add a hack to hop over the writeback in generic_file_read_iter(),
but I hesitate to do this because it seems like the correct thing to do is to
separate the ext4 DAX & DIO paths, which I think you are already doing.

I believe that my DAX PMD patches are ready to go, but because of this issue
they currently only support XFS.  I'm tempted to send them out as they are
right now since they add a bunch of complexity to DAX that we need to review,
and that review can fully happen with only XFS support. We can add ext4
support back in later when it's ready.

Thoughts?
