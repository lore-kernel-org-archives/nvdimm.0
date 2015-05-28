Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/6] pmem: add force casts to avoid __iomem annotation
Date: Thu, 28 May 2015 16:35:48 -0600
Message-Id: <1432852553-24865-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Even though we use ioremap_nocache() to map our persistent memory in the
pmem driver, the memory we are mapping behaves like normal memory and
not I/O memory in that it can be accessed using regular memcpy()
operations and doesn't need to go through memcpy_toio() and
memcpy_fromio().  Force casting the pointers received from
ioremap_nocache() and given to iounmap() gives us the correct behavior
and makes sparse happy.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
---
 drivers/block/nd/pmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nd/pmem.c b/drivers/block/nd/pmem.c
index 5e8c9c629f22..a8712e41e7f5 100644
--- a/drivers/block/nd/pmem.c
+++ b/drivers/block/nd/pmem.c
@@ -163,7 +163,8 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res,
 	 * of the CPU caches in case of a crash.
 	 */
 	err = -ENOMEM;
-	pmem->virt_addr = ioremap_nocache(pmem->phys_addr, pmem->size);
+	pmem->virt_addr = (__force void *)ioremap_nocache(pmem->phys_addr,
+			pmem->size);
 	if (!pmem->virt_addr)
 		goto out_release_region;
 
@@ -195,7 +196,7 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res,
 out_free_queue:
 	blk_cleanup_queue(pmem->pmem_queue);
 out_unmap:
-	iounmap(pmem->virt_addr);
+	iounmap((__force void __iomem *)pmem->virt_addr);
 out_release_region:
 	release_mem_region(pmem->phys_addr, pmem->size);
 out_free_dev:
@@ -209,7 +210,7 @@ static void pmem_free(struct pmem_device *pmem)
 	del_gendisk(pmem->pmem_disk);
 	put_disk(pmem->pmem_disk);
 	blk_cleanup_queue(pmem->pmem_queue);
-	iounmap(pmem->virt_addr);
+	iounmap((__force void __iomem *)pmem->virt_addr);
 	release_mem_region(pmem->phys_addr, pmem->size);
 	kfree(pmem);
 }
-- 
1.9.3

