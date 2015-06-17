Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 01/15] block: introduce an ->rw_bytes() block device
 operation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:54:52 -0400
Message-ID: <20150617235452.12943.27817.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Why do we need a new method in block_device_operations?

The capacities of persistent memory make it too large to map as RAM (no
struct page coverage by default), so Linux arranges for it to be managed
as a block device. The bio interface to a block device enforces sector
at a time i/o and has infrastructure for asynchronous completion of i/o.
The ->rw_page() interface is closely tied to the page cache and also
carries asynchronous i/o completion assumptions.  NVDIMM devices are
fast enough to complete i/o's synchronously (memcpy) and some in kernel
applications can take advantage of the byte-aligned (as opposed to
sector-aligned) nature of the media.  The ->rw_bytes() operation is
added to fill this role that does not fit into any existing access
method.

It could be argued that a ->rw_bytes() method makes a struct
block_device not a *block* device.  However, the applications for
persistent memory as storage devices makes them more "block" devices
than "character" devices.

The first consumer of the ->rw_bytes() capability is a stacked
block_device driver (BTT - block translation table) that adds atomic
sector update semantics on top of an nvdimm storage device.

Why enable drivers like BTT on top of a new globally visibly
block_device_operations op rather than an internal detail of nvdimm
drivers?

1/ We want ->rw_bytes() consumers to be enabled on either a per-disk or
per-partition basis.  Consider the case of enabling DAX+XFS on a single
persistent memory disk whereby the metadata needs atomic sector update
guarantees, but the data would like to be DAX capable.  Solution is to
create two partitions and enable BTT on the "metadata/XFS-logdev"
partition.

2/ We want this configuration topology to be visible to the sysfs device
model, and not an internal detail of nvdimm drivers requiring special
tooling.  For example if you ever wanted to "fsck" BTT metadata that
could be carried out on the raw nvdimm device directly rather than
require custom tooling / mechanisms to access the raw media.

3/ It becomes trivial to add new BTT like drivers without touching the
nvdimm drivers to add is_btt_mode(), is_foo_mode(), etc... checks in the
fast path.

Cc: Jens Axboe <axboe@fb.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c  |   19 +++++++++++++++++++
 include/linux/blkdev.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 90902a142e35..efa2cde7f6b6 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -96,6 +96,24 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
+static int pmem_rw_bytes(struct gendisk *disk, resource_size_t offset,
+			void *buf, size_t size, int rw)
+{
+	struct pmem_device *pmem = disk->private_data;
+
+	if (unlikely(offset + size > pmem->size)) {
+		dev_WARN_ONCE(disk_to_dev(disk), 1, "request out of range\n");
+		return -EFAULT;
+	}
+
+	if (rw == READ)
+		memcpy(buf, pmem->virt_addr + offset, size);
+	else
+		memcpy(pmem->virt_addr + offset, buf, size);
+
+	return 0;
+}
+
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 			      void **kaddr, unsigned long *pfn, long size)
 {
@@ -114,6 +132,7 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
+	.rw_bytes =		pmem_rw_bytes,
 	.direct_access =	pmem_direct_access,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516f24de..25d6034a2e62 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1602,6 +1602,8 @@ struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
+	int (*rw_bytes)(struct gendisk *, resource_size_t offset,
+			void *buf, size_t size, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	long (*direct_access)(struct block_device *, sector_t,
@@ -1625,6 +1627,48 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
 						unsigned long *pfn, long size);
+
+/**
+ * bdev_read_bytes() - synchronously read bytes from a memory-backed block dev
+ * @bdev: device to read
+ * @offset: bdev-relative starting offset
+ * @buf: buffer to fill
+ * @size: transfer length
+ *
+ * RAM and PMEM disks do not implement sectors internally.  @buf is
+ * up-to-date upon return from this routine.
+ */
+static inline int bdev_read_bytes(struct block_device *bdev,
+		resource_size_t offset, void *buf, size_t size)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	const struct block_device_operations *ops = disk->fops;
+
+	offset += get_start_sect(bdev) << 9;
+	return ops->rw_bytes(disk, offset, buf, size, READ);
+}
+
+/**
+ * bdev_write_bytes() - synchronously write bytes to a memory-backed block dev
+ * @bdev: device to read
+ * @offset: bdev-relative starting offset
+ * @buf: buffer to drain
+ * @size: transfer length
+ *
+ * RAM and PMEM disks do not implement sectors internally.  Depending on
+ * the @bdev, the contents of @buf may be in cpu cache, platform buffers,
+ * or on backing memory media upon return from this routine.  Flushing
+ * to media is handled internal to the @bdev driver, if at all.
+ */
+static inline int bdev_write_bytes(struct block_device *bdev,
+		resource_size_t offset, void *buf, size_t size)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	const struct block_device_operations *ops = disk->fops;
+
+	offset += get_start_sect(bdev) << 9;
+	return ops->rw_bytes(disk, offset, buf, size, WRITE);
+}
 #else /* CONFIG_BLOCK */
 
 struct block_device;

