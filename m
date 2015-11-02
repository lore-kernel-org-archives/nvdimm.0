Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 05/15] libnvdimm,
 pmem: fix size trim in pmem_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:30:10 -0500
Message-ID: <20151102043009.6610.83896.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

This masking prevents access to the end of the device via dax_do_io(),
and is unnecessary as arch_add_memory() would have rejected an unaligned
allocation.

Cc: <stable@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e46988fbdee5..93472953e231 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -100,26 +100,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, unsigned long *pfn)
+		      void __pmem **kaddr, pfn_t *pfn)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
-	resource_size_t size;
 
-	if (pmem->data_offset) {
-		/*
-		 * Limit the direct_access() size to what is covered by
-		 * the memmap
-		 */
-		size = (pmem->size - offset) & ~ND_PFN_MASK;
-	} else
-		size = pmem->size - offset;
-
-	/* FIXME convert DAX to comprehend that this mapping has a lifetime */
 	*kaddr = pmem->virt_addr + offset;
-	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+	*pfn = __phys_to_pfn(pmem->phys_addr + offset, pmem->pfn_flags);
 
-	return size;
+	return pmem->size - offset;
 }
 
 static const struct block_device_operations pmem_fops = {

