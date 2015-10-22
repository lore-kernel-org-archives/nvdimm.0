Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 22 Oct 2015 23:08:18 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
Message-ID: <20151022210818.GC8670@quack.suse.cz>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022093549.GE14445@quack.suse.cz>
 <1445529945.17208.4.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1445529945.17208.4.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "david@fromorbit.com" <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 22-10-15 16:05:46, Williams, Dan J wrote:
> On Thu, 2015-10-22 at 11:35 +0200, Jan Kara wrote:
> > On Thu 22-10-15 02:42:11, Dan Williams wrote:
> > > If an application wants exclusive access to all of the persistent memory
> > > provided by an NVDIMM namespace it can use this raw-block-dax facility
> > > to forgo establishing a filesystem.  This capability is targeted
> > > primarily to hypervisors wanting to provision persistent memory for
> > > guests.
> > > 
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Jeff Moyer <jmoyer@redhat.com>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Dave Chinner <david@fromorbit.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  fs/block_dev.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 53 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > index 3255dcec96b4..c27cd1a21a13 100644
> > > --- a/fs/block_dev.c
> > > +++ b/fs/block_dev.c
> > > @@ -1687,13 +1687,65 @@ static const struct address_space_operations def_blk_aops = {
> > >  	.is_dirty_writeback = buffer_check_dirty_writeback,
> > >  };
> > >  
> > > +#ifdef CONFIG_FS_DAX
> > > +/*
> > > + * In the raw block case we do not need to contend with truncation nor
> > > + * unwritten file extents.  Without those concerns there is no need for
> > > + * additional locking beyond the mmap_sem context that these routines
> > > + * are already executing under.
> > > + *
> > > + * Note, there is no protection if the block device is dynamically
> > > + * resized (partition grow/shrink) during a fault. A stable block device
> > > + * size is already not enforced in the blkdev_direct_IO path.
> > > + *
> > > + * For DAX, it is the responsibility of the block device driver to
> > > + * ensure the whole-disk device size is stable while requests are in
> > > + * flight.
> > > + *
> > > + * Finally, these paths do not synchronize against freezing
> > > + * (sb_start_pagefault(), etc...) since bdev_sops does not support
> > > + * freezing.
> > 
> > Well, for devices freezing is handled directly in the block layer code
> > (blk_stop_queue()) since there's no need to put some metadata structures
> > into a consistent state. So the comment about bdev_sops is somewhat
> > strange.
> 
> This text was aimed at the request from Ross to document the differences
> vs the generic_file_mmap() path.  Is the following incremental change
> more clear?

Well, not really. I thought you'd just delete that paragraph :) The thing
is: When doing IO directly to the block device, it makes no sense to look
at a filesystem on top of it - hopefully there is none since you'd be
corrupting it. So the paragraph that would make sense to me would be:

 * Finally, in contrast to filemap_page_mkwrite(), we don't bother calling
 * sb_start_pagefault(). There is no filesystem which could be frozen here
 * and when bdev gets frozen, IO gets blocked in the request queue.

But when spelled out like this, I've realized that with DAX, this blocking
of requests in the request queue doesn't really block the IO to the device.
So block device freezing (aka blk_queue_stop()) doesn't work reliably with
DAX. That should be fixed but it's not easy as the only way to do that
would be to hook into blk_stop_queue() and unmap (or at least
write-protect) all the mappings of the device. Ugh...

Ugh2: Now I realized that DAX mmap isn't safe wrt fs freezing even for
filesystems since there's nothing which writeprotects pages that are
writeably mapped. In normal path, page writeback does this but that doesn't
happen for DAX. I remember we once talked about this but it got lost.
We need something like walk all filesystem inodes during fs freeze and
writeprotect all pages that are mapped. But that's going to be slow...

								Honza

> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 840acd4380d4..4ae8fa55bd1e 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1702,9 +1702,15 @@ static const struct address_space_operations def_blk_aops = {
>   * ensure the whole-disk device size is stable while requests are in
>   * flight.
>   *
> - * Finally, these paths do not synchronize against freezing
> - * (sb_start_pagefault(), etc...) since bdev_sops does not support
> - * freezing.
> + * Finally, in contrast to the generic_file_mmap() path, there are no
> + * calls to sb_start_pagefault().  That is meant to synchronize write
> + * faults against requests to freeze the contents of the filesystem
> + * hosting vma->vm_file.  However, in the case of a block device special
> + * file, it is a 0-sized device node usually hosted on devtmpfs, i.e.
> + * nothing to do with the super_block for bdev_file_inode(vma->vm_file).
> + * We could call get_super() in this path to retrieve the right
> + * super_block, but the generic_file_mmap() path does not do this for
> + * the CONFIG_FS_DAX=n case.
>   */
>  static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
