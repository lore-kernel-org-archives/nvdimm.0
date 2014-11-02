Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/4] pmem: Initial version of persistent memory driver
Date: Sun, 2 Nov 2014 03:22:37 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Knippers, Linda" <linda.knippers@hp.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Ross Zwisler
> Sent: Wednesday, 27 August, 2014 4:12 PM
> To: Jens Axboe; Matthew Wilcox; Boaz Harrosh; Nick Piggin; linux-
> fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> nvdimm@lists.01.org
> Cc: Ross Zwisler
> Subject: [PATCH 1/4] pmem: Initial version of persistent memory
> driver
> 
> PMEM is a new driver that presents a reserved range of memory as a
> block device.  This is useful for developing with NV-DIMMs, and
> can be used with volatile memory as a development platform.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  MAINTAINERS            |   6 +
>  drivers/block/Kconfig  |  41 ++++++
>  drivers/block/Makefile |   1 +
>  drivers/block/pmem.c   | 330
> +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 378 insertions(+)
>  create mode 100644 drivers/block/pmem.c
> 
...

> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 1b8094d..ac52f5a 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -404,6 +404,47 @@ config BLK_DEV_RAM_DAX
>  	  and will prevent RAM block device backing store memory from
> being
>  	  allocated from highmem (only a problem for highmem systems).
> 
> +config BLK_DEV_PMEM
> +	tristate "Persistent memory block device support"
> +	help
> +	  Saying Y here will allow you to use a contiguous range of
> reserved
> +	  memory as one or more block devices.  Memory for PMEM should
> be
> +	  reserved using the "memmap" kernel parameter.
> +
> +	  To compile this driver as a module, choose M here: the module
> will be
> +	  called pmem.
> +
> +	  Most normal users won't need this functionality, and can thus
> say N
> +	  here.
> +
> +config BLK_DEV_PMEM_START
> +	int "Offset in GiB of where to start claiming space"
> +	default "0"
> +	depends on BLK_DEV_PMEM
> +	help
> +	  Starting offset in GiB that PMEM should use when claiming
> memory.  This
> +	  memory needs to be reserved from the OS at boot time using
> the
> +	  "memmap" kernel parameter.
> +
> +	  If you provide PMEM with volatile memory it will act as a
> volatile
> +	  RAM disk and your data will not be persistent.
> +
> +config BLK_DEV_PMEM_COUNT
> +	int "Default number of PMEM disks"
> +	default "4"

For real use I think a default of 1 would be better.

> +	depends on BLK_DEV_PMEM
> +	help
> +	  Number of equal sized block devices that PMEM should create.
> +
> +config BLK_DEV_PMEM_SIZE
> +	int "Size in GiB of space to claim"
> +	depends on BLK_DEV_PMEM
> +	default "0"
> +	help
> +	  Amount of memory in GiB that PMEM should use when creating
> block
> +	  devices.  This memory needs to be reserved from the OS at
> +	  boot time using the "memmap" kernel parameter.
> +
>  config CDROM_PKTCDVD
>  	tristate "Packet writing on CD/DVD media"
>  	depends on !UML


...

> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> new file mode 100644
> index 0000000..d366b9b
> --- /dev/null
> +++ b/drivers/block/pmem.c
> @@ -0,0 +1,330 @@
> +/*
> + * Persistent Memory Driver
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but
> WITHOUT
> + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> License for
> + * more details.
> + *
> + * This driver is heavily based on drivers/block/brd.c.
> + * Copyright (C) 2007 Nick Piggin
> + * Copyright (C) 2007 Novell Inc.
> + */
> +
> +#include <linux/bio.h>
> +#include <linux/blkdev.h>
> +#include <linux/fs.h>
> +#include <linux/hdreg.h>
> +#include <linux/highmem.h>
> +#include <linux/init.h>
> +#include <linux/major.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#define SECTOR_SHIFT		9
> +#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
> +#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
> +
> +/*
> + * driver-wide physical address and total_size - one single,
> contiguous memory
> + * region that we divide up in to same-sized devices
> + */
> +phys_addr_t	phys_addr;
> +void		*virt_addr;
> +size_t		total_size;
> +
> +struct pmem_device {
> +	struct request_queue	*pmem_queue;
> +	struct gendisk		*pmem_disk;
> +	struct list_head	pmem_list;
> +
> +	phys_addr_t		phys_addr;
> +	void			*virt_addr;
> +	size_t			size;
> +};
> +
> +/*
> + * direct translation from (pmem,sector) => void*
> + * We do not require that sector be page aligned.
> + * The return value will point to the beginning of the page
> containing the
> + * given sector, not to the sector itself.
> + */
> +static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t
> sector)
> +{
> +	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
> +	size_t offset = page_offset << PAGE_SHIFT;
> +

Since page_offset is only used to calculate offset, they
could be joined to avoid relying on the compiler to
optimize it away:
	size_t offset = sector >> PAGE_SECTORS_SHIFT << PAGE_SHIFT;

> +	BUG_ON(offset >= pmem->size);

BUG_ON is severe... should this function be designed to return 
an error instead?

> +	return pmem->virt_addr + offset;
> +}

> +
> +/*
> + * sector is not required to be page aligned.
> + * n is at most a single page, but could be less.
> + */
> +static void copy_to_pmem(struct pmem_device *pmem, const void *src,
> +			sector_t sector, size_t n)
> +{
> +	void *dst;
> +	unsigned int offset = (sector & (PAGE_SECTORS - 1)) <<
> SECTOR_SHIFT;
> +	size_t copy;
> +
> +	BUG_ON(n > PAGE_SIZE);
> +
> +	copy = min_t(size_t, n, PAGE_SIZE - offset);
> +	dst = pmem_lookup_pg_addr(pmem, sector);
> +	memcpy(dst + offset, src, copy);
> +
> +	if (copy < n) {
> +		src += copy;
> +		sector += copy >> SECTOR_SHIFT;
> +		copy = n - copy;
> +		dst = pmem_lookup_pg_addr(pmem, sector);
> +		memcpy(dst, src, copy);
> +	}
> +}
> +
> +/*
> + * sector is not required to be page aligned.
> + * n is at most a single page, but could be less.
> + */
> +static void copy_from_pmem(void *dst, struct pmem_device *pmem,
> +			  sector_t sector, size_t n)
> +{
> +	void *src;
> +	unsigned int offset = (sector & (PAGE_SECTORS - 1)) <<
> SECTOR_SHIFT;
> +	size_t copy;
> +
> +	BUG_ON(n > PAGE_SIZE);
> +
> +	copy = min_t(size_t, n, PAGE_SIZE - offset);
> +	src = pmem_lookup_pg_addr(pmem, sector);
> +
> +	memcpy(dst, src + offset, copy);
> +
> +	if (copy < n) {
> +		dst += copy;
> +		sector += copy >> SECTOR_SHIFT;
> +		copy = n - copy;
> +		src = pmem_lookup_pg_addr(pmem, sector);
> +		memcpy(dst, src, copy);
> +	}
> +}
> +
> +static void pmem_do_bvec(struct pmem_device *pmem, struct page
> *page,
> +			unsigned int len, unsigned int off, int rw,
> +			sector_t sector)
> +{
> +	void *mem = kmap_atomic(page);
> +
> +	if (rw == READ) {
> +		copy_from_pmem(mem + off, pmem, sector, len);
> +		flush_dcache_page(page);

Why does READ flush the dcache after reading?  It's fine to 
leave data in dcache.

> +	} else {
> +		/*
> +		 * FIXME: Need more involved flushing to ensure that
> writes to
> +		 * NVDIMMs are actually durable before returning.
> +		 */
> +		flush_dcache_page(page);
> +		copy_to_pmem(pmem, mem + off, sector, len);

Why is this flushing before the write to pmem? That might flush
data that's going to be overwritten.  I'd expect a flush AFTER
the write, to push data to a durable location that will survive 
surprise power loss.

> +	}
> +
> +	kunmap_atomic(mem);
> +}

If a read or write of a pmem address gets an uncorrectable
error, the system should not crash; just report this IO is bad.  
That reflects a difference in storage philosophy vs. memory
philosophy.  All the rest of the data in the pmem might be
fine, and many users prefer to recover 99% of their data
than lose it all.

pmem_do_bvec needs a way to turn off normal DRAM "crash on
error" handling for its accesses, and provide a return value
indicating success or failure.

Also, most storage devices automatically remap bad sectors
when they are overwritten or remap them on command (e.g.,
REASSIGN BLOCKS in SCSI), rather than leave that sector 
bad forever.  I don't know how many filesystems and
applications rely on that feature now, vs. maintain their
own bad block tables; this may be something that pmem
needs to provide.

> +
> +static void pmem_make_request(struct request_queue *q, struct bio
> *bio)
> +{
> +	struct block_device *bdev = bio->bi_bdev;
> +	struct pmem_device *pmem = bdev->bd_disk->private_data;
> +	int rw;
> +	struct bio_vec bvec;
> +	sector_t sector;
> +	struct bvec_iter iter;
> +	int err = 0;
> +
> +	sector = bio->bi_iter.bi_sector;
> +	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
> +		err = -EIO;
> +		goto out;
> +	}
> +
> +	BUG_ON(bio->bi_rw & REQ_DISCARD);
> +

Since discard (i.e., unmap, trip) is just a hint, it could just 
be ignored rather than trigger a drastic BUG.

Related suggestion: keep track of each sector that has been 
discarded, and whether it has been written after discard.
This would tell flash-backed DRAM which sectors don't need 
to be flushed to flash on a power failure.

Related suggestion: Adding WRITE SAME support would be useful
for some software (for at least the writing zeros subset) - 
that command is not just a hint.  It would result in a memset.

> +	rw = bio_rw(bio);
> +	if (rw == READA)
> +		rw = READ;
> +
> +	bio_for_each_segment(bvec, bio, iter) {
> +		unsigned int len = bvec.bv_len;
> +
> +		BUG_ON(len > PAGE_SIZE);
> +		pmem_do_bvec(pmem, bvec.bv_page, len,
> +			    bvec.bv_offset, rw, sector);
> +		sector += len >> SECTOR_SHIFT;
> +	}
> +
> +out:
> +	bio_endio(bio, err);
> +}
> +
> +static const struct block_device_operations pmem_fops = {
> +	.owner =		THIS_MODULE,
> +};
> +
> +/* Kernel module stuff */
> +static int pmem_start_gb = CONFIG_BLK_DEV_PMEM_START;
> +module_param(pmem_start_gb, int, S_IRUGO);
> +MODULE_PARM_DESC(pmem_start_gb, "Offset in GB of where to start
> claiming space");
> +
> +static int pmem_size_gb = CONFIG_BLK_DEV_PMEM_SIZE;
> +module_param(pmem_size_gb,  int, S_IRUGO);
> +MODULE_PARM_DESC(pmem_size_gb,  "Total size in GB of space to claim
> for all disks");
> +

These modparam variable names and description scripts use gb 
and GB when they mean GiB.  The storage market generally uses 
correct SI units; please don't follow JEDEC's misuse.  The
Kconfig descriptions use the right IEC binary units.

Using GiB as the base unit prevents having persistent memory 
blocks < 1 GiB or not multiples of 1 GiB.  For RAID controller 
caches, 256 MiB and 512 MiB are still used.  Smaller units
may be warranted.  Accepting the number and unit would be
the most flexible and clear: allow strings like 512MiB, 
2GiB, 1GB, and 4096B.

> +static int pmem_count = CONFIG_BLK_DEV_PMEM_COUNT;
> +module_param(pmem_count, int, S_IRUGO);
> +MODULE_PARM_DESC(pmem_count, "Number of pmem devices to evenly split
> allocated space");
> +
> +static LIST_HEAD(pmem_devices);
> +static int pmem_major;
> +
> +/* FIXME: move phys_addr, virt_addr, size calls up to caller */

It is unclear what that wants to fix.

> +static struct pmem_device *pmem_alloc(int i)
> +{
> +	struct pmem_device *pmem;
> +	struct gendisk *disk;
> +	size_t disk_size = total_size / pmem_count;

There is no protection for pmem_count being 0 and causing
divide-by-zero.

There is no check for disk_size being 0.  That might
cause problems in pmem_init.

> +	size_t disk_sectors = disk_size / 512;
> +
> +	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
> +	if (!pmem)
> +		goto out;
> +
> +	pmem->phys_addr = phys_addr + i * disk_size;
> +	pmem->virt_addr = virt_addr + i * disk_size;
> +	pmem->size = disk_size;
> +
> +	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
> +	if (!pmem->pmem_queue)
> +		goto out_free_dev;
> +

General comment:
This driver should be blk-mq based.  Not doing so loses
out on a number of SMP and NUMA performance improvements.
For example, blk_alloc_queue calls blk_alloc_queue_node
with NUMA_NO_NODE.  If it called blk_mq_init_queue, then
each CPU would get structures located on its node.

> +	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
> +	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);

Many storage controllers support 1 MiB IOs now, and increasing
amounts of software feel comfortable generating those sizes.  
That means this should be at least 2048.

> +	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
> +

It might be appropriate to call blk_queue_rq_timeout
and set up a very short timeout, since persistent memory is
very fast.  I'm not sure what the default is for non-blk-mq
drivers; for blk-mq, I think it is 30 seconds, which is
far too long for memory based storage.

> +	disk = pmem->pmem_disk = alloc_disk(0);
> +	if (!disk)
> +		goto out_free_queue;
> +	disk->major		= pmem_major;
> +	disk->first_minor	= 0;
> +	disk->fops		= &pmem_fops;
> +	disk->private_data	= pmem;
> +	disk->queue		= pmem->pmem_queue;
> +	disk->flags		= GENHD_FL_EXT_DEVT;
> +	sprintf(disk->disk_name, "pmem%d", i);
> +	set_capacity(disk, disk_sectors);
> +
> +	return pmem;
> +
> +out_free_queue:
> +	blk_cleanup_queue(pmem->pmem_queue);
> +out_free_dev:
> +	kfree(pmem);
> +out:
> +	return NULL;
> +}
> +
> +static void pmem_free(struct pmem_device *pmem)
> +{
> +	put_disk(pmem->pmem_disk);
> +	blk_cleanup_queue(pmem->pmem_queue);
> +	kfree(pmem);
> +}
> +
> +static void pmem_del_one(struct pmem_device *pmem)
> +{
> +	list_del(&pmem->pmem_list);
> +	del_gendisk(pmem->pmem_disk);
> +	pmem_free(pmem);
> +}
> +
> +static int __init pmem_init(void)
> +{
> +	int result, i;
> +	struct resource *res_mem;
> +	struct pmem_device *pmem, *next;
> +
> +	phys_addr  = (phys_addr_t) pmem_start_gb * 1024 * 1024 * 1024;
> +	total_size = (size_t)	   pmem_size_gb  * 1024 * 1024 * 1024;
> +

There is no check for start+size wrapping around the
address space. 

Although modparams are a fine starting point, some way to
automatically load drivers based on e820 table and other ACPI
content will be needed.  pmem may not be the only driver
vying for use of persistent memory regions; some sort of
arbiter will be needed to implement the user's choice (the
same way each boot).

> +	res_mem = request_mem_region_exclusive(phys_addr, total_size,
> "pmem");
> +	if (!res_mem)
> +		return -ENOMEM;
> +

Does the call to request_mem_region_exclusive, which uses:
	#define IORESOURCE_EXCLUSIVE    0x08000000      /* Userland may not map this resource */
mean that userspace cannot mmap files and directly access
persistent memory?  There are only 3 drivers that use
request.*exclusive functions: drivers/net/ethernet/intel/e1000e
and drivers/watchdog/sp5100-tco. None of the storage drivers 
do so.

> +	virt_addr = ioremap_cache(phys_addr, total_size);
> +	if (!virt_addr) {
> +		result = -ENOMEM;
> +		goto out_release;
> +	}
> +

ioremap_cache maps the addresses as writeback cacheable.  How 
about offering all the cache attributes as modparams?
* writeback (WB): costly cache flushes to preserve data
* write combining (WC): must flush the WC buffers
* writethrough (WT): safe, good for cases where the application
  expects to read the data again soon
* uncacheable (UC): safe, good for cases where the application
  does not expect to read the data

There are some use cases for persistence across reboots
that don't care about persistence across power cycles;
for these, separate options could be provided for:
* WB
* WB+flush
* WC
* WC+flush


> +	result = register_blkdev(0, "pmem");
> +	if (result < 0) {
> +		result = -EIO;
> +		goto out_unmap;
> +	} else
> +		pmem_major = result;
> +

In comparison, if sd fails register_blkdev, it returns
-ENODEV.  Since no pmem device is created, -ENODEV might
be more appropriate.

The pmem_major variable might be unsafe/racy if multiple
concurrent module loads are possible.  The value is stored in 
disk->major; that's the only place it should be stored,
and pmem_exit should pull the value from that location to
later pass into unregister_blkdev before deleting its
containing structure.  This might not be an issue until
you get to 16 Ki modules.

Should this function call blk_register_region after
calling register_blkdev?

> +	for (i = 0; i < pmem_count; i++) {
> +		pmem = pmem_alloc(i);
> +		if (!pmem) {
> +			result = -ENOMEM;
> +			goto out_free;
> +		}
> +		list_add_tail(&pmem->pmem_list, &pmem_devices);
> +	}
> +
> +	list_for_each_entry(pmem, &pmem_devices, pmem_list)
> +		add_disk(pmem->pmem_disk);
> +
> +	pr_info("pmem: module loaded\n");
> +	return 0;
> +
> +out_free:
> +	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list)
> {
> +		list_del(&pmem->pmem_list);
> +		pmem_free(pmem);
> +	}
> +	unregister_blkdev(pmem_major, "pmem");
> +
> +out_unmap:
> +	iounmap(virt_addr);
> +
> +out_release:
> +	release_mem_region(phys_addr, total_size);
> +	return result;
> +}
> +
> +static void __exit pmem_exit(void)
> +{
> +	struct pmem_device *pmem, *next;
> +
> +	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list)
> +		pmem_del_one(pmem);
> +
> +	unregister_blkdev(pmem_major, "pmem");
> +	iounmap(virt_addr);
> +	release_mem_region(phys_addr, total_size);
> +
> +	pr_info("pmem: module unloaded\n");
> +}
> +
> +MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
> +MODULE_LICENSE("GPL");
> +module_init(pmem_init);
> +module_exit(pmem_exit);


---
Rob Elliott    HP Server Storage



