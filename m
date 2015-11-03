Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 4 Nov 2015 07:20:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 13/15] block, dax: make dax mappings opt-in by default
Message-ID: <20151103202041.GG19199@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102043053.6610.43948.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151103003234.GM10656@dastard>
 <CAPcyv4j8=_LdfK_TjJfEP0aA-1d3wSaLwBcpmrTobijpcRk1Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j8=_LdfK_TjJfEP0aA-1d3wSaLwBcpmrTobijpcRk1Dw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 02, 2015 at 11:35:04PM -0800, Dan Williams wrote:
> On Mon, Nov 2, 2015 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Nov 01, 2015 at 11:30:53PM -0500, Dan Williams wrote:
> >> Now that we have the ability to dynamically enable DAX for a raw block
> >> inode, make the behavior opt-in by default.  DAX does not have feature
> >> parity with pagecache backed mappings, so applications should knowingly
> >> enable DAX semantics.
> >>
> >> Note, this is only for mappings returned to userspace.  For the
> >> synchronous usages of DAX, dax_do_io(), there is no semantic difference
> >> with the bio submission path, so that path remains default enabled.
> >>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  block/ioctl.c      |    3 +--
> >>  fs/block_dev.c     |   33 +++++++++++++++++++++++----------
> >>  include/linux/fs.h |    8 ++++++++
> >>  3 files changed, 32 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/block/ioctl.c b/block/ioctl.c
> >> index 205d57612fbd..c4c3a09d9ca9 100644
> >> --- a/block/ioctl.c
> >> +++ b/block/ioctl.c
> >> @@ -298,13 +298,12 @@ static inline int is_unrecognized_ioctl(int ret)
> >>  #ifdef CONFIG_FS_DAX
> >>  static int blkdev_set_dax(struct block_device *bdev, int n)
> >>  {
> >> -     struct gendisk *disk = bdev->bd_disk;
> >>       int rc = 0;
> >>
> >>       if (n)
> >>               n = S_DAX;
> >>
> >> -     if (n && !disk->fops->direct_access)
> >> +     if (n && !blkdev_dax_capable(bdev))
> >>               return -ENOTTY;
> >>
> >>       mutex_lock(&bdev->bd_inode->i_mutex);
> >> diff --git a/fs/block_dev.c b/fs/block_dev.c
> >> index 13ce6d0ff7f6..ee34a31e6fa4 100644
> >> --- a/fs/block_dev.c
> >> +++ b/fs/block_dev.c
> >> @@ -152,16 +152,37 @@ static struct inode *bdev_file_inode(struct file *file)
> >>       return file->f_mapping->host;
> >>  }
> >>
> >> +#ifdef CONFIG_FS_DAX
> >> +bool blkdev_dax_capable(struct block_device *bdev)
> >> +{
> >> +     struct gendisk *disk = bdev->bd_disk;
> >> +
> >> +     if (!disk->fops->direct_access)
> >> +             return false;
> >> +
> >> +     /*
> >> +      * If the partition is not aligned on a page boundary, we can't
> >> +      * do dax I/O to it.
> >> +      */
> >> +     if ((bdev->bd_part->start_sect % (PAGE_SIZE / 512))
> >> +                     || (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
> >> +             return false;
> >> +
> >> +     return true;
> >
> > Where do you check that S_DAX has been enabled on the block device
> > now?
> >
> 
> Only in the mmap path:

which means blkdev_direct_IO() is now always going to go down the
dax_do_io() path for any driver with a ->direct_access method rather
than the direct IO path, regardless of whether DAX is enabled on the
device or not.

That really seems wrong to me - you've replace explicit "is DAX
enabled" checks with "is DAX possible" checks, and so DAX paths are
used regardless of whether DAX is enabled or not. And it's not
obvious why this is done, nor is it now obvious how DAX interacts
with the block device.

This really seems like a step backwards to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
