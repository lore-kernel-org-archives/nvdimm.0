Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103003234.GM10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102043053.6610.43948.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103003234.GM10656@dastard>
Date: Mon, 2 Nov 2015 23:35:04 -0800
Message-ID: <CAPcyv4j8=_LdfK_TjJfEP0aA-1d3wSaLwBcpmrTobijpcRk1Dw@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] block, dax: make dax mappings opt-in by default
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 2, 2015 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Nov 01, 2015 at 11:30:53PM -0500, Dan Williams wrote:
>> Now that we have the ability to dynamically enable DAX for a raw block
>> inode, make the behavior opt-in by default.  DAX does not have feature
>> parity with pagecache backed mappings, so applications should knowingly
>> enable DAX semantics.
>>
>> Note, this is only for mappings returned to userspace.  For the
>> synchronous usages of DAX, dax_do_io(), there is no semantic difference
>> with the bio submission path, so that path remains default enabled.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  block/ioctl.c      |    3 +--
>>  fs/block_dev.c     |   33 +++++++++++++++++++++++----------
>>  include/linux/fs.h |    8 ++++++++
>>  3 files changed, 32 insertions(+), 12 deletions(-)
>>
>> diff --git a/block/ioctl.c b/block/ioctl.c
>> index 205d57612fbd..c4c3a09d9ca9 100644
>> --- a/block/ioctl.c
>> +++ b/block/ioctl.c
>> @@ -298,13 +298,12 @@ static inline int is_unrecognized_ioctl(int ret)
>>  #ifdef CONFIG_FS_DAX
>>  static int blkdev_set_dax(struct block_device *bdev, int n)
>>  {
>> -     struct gendisk *disk = bdev->bd_disk;
>>       int rc = 0;
>>
>>       if (n)
>>               n = S_DAX;
>>
>> -     if (n && !disk->fops->direct_access)
>> +     if (n && !blkdev_dax_capable(bdev))
>>               return -ENOTTY;
>>
>>       mutex_lock(&bdev->bd_inode->i_mutex);
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 13ce6d0ff7f6..ee34a31e6fa4 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -152,16 +152,37 @@ static struct inode *bdev_file_inode(struct file *file)
>>       return file->f_mapping->host;
>>  }
>>
>> +#ifdef CONFIG_FS_DAX
>> +bool blkdev_dax_capable(struct block_device *bdev)
>> +{
>> +     struct gendisk *disk = bdev->bd_disk;
>> +
>> +     if (!disk->fops->direct_access)
>> +             return false;
>> +
>> +     /*
>> +      * If the partition is not aligned on a page boundary, we can't
>> +      * do dax I/O to it.
>> +      */
>> +     if ((bdev->bd_part->start_sect % (PAGE_SIZE / 512))
>> +                     || (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
>> +             return false;
>> +
>> +     return true;
>
> Where do you check that S_DAX has been enabled on the block device
> now?
>

Only in the mmap path:

static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
{
        struct inode *bd_inode = bdev_file_inode(file);
        struct block_device *bdev = I_BDEV(bd_inode);

        file_accessed(file);
        mutex_lock(&bd_inode->i_mutex);
        bdev->bd_map_count++;
        if (IS_DAX(bd_inode)) {
                vma->vm_ops = &blkdev_dax_vm_ops;
                vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
        } else {
                vma->vm_ops = &blkdev_default_vm_ops;
        }
        mutex_unlock(&bd_inode->i_mutex);

        return 0;
}
