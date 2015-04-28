Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 10/20] pmem: use ida
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:06 -0400
Message-ID: <20150428182506.35812.4007.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the pmem driver attaching to pmem-namespaces emitted
by libnd, convert it to use an ida instead of an always increasing
atomic index.  This provides a bit of stability to pmem device names in
the presence of driver re-bind events.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/pmem.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index eabf4a8d0085..e3cf9142b172 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -34,10 +34,11 @@ struct pmem_device {
 	phys_addr_t		phys_addr;
 	void			*virt_addr;
 	size_t			size;
+	int			id;
 };
 
 static int pmem_major;
-static atomic_t pmem_index;
+static DEFINE_IDA(pmem_ida);
 
 static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			unsigned int len, unsigned int off, int rw,
@@ -122,20 +123,26 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
 {
 	struct pmem_device *pmem;
 	struct gendisk *disk;
-	int idx, err;
+	int err;
 
 	err = -ENOMEM;
 	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
 		goto out;
 
+	pmem->id = ida_simple_get(&pmem_ida, 0, 0, GFP_KERNEL);
+	if (pmem->id < 0) {
+		err = pmem->id;
+		goto out_free_dev;
+	}
+
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
 
 	err = -EINVAL;
 	if (!request_mem_region(pmem->phys_addr, pmem->size, "pmem")) {
 		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n", &pmem->phys_addr, pmem->size);
-		goto out_free_dev;
+		goto out_free_ida;
 	}
 
 	/*
@@ -159,15 +166,13 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
 	if (!disk)
 		goto out_free_queue;
 
-	idx = atomic_inc_return(&pmem_index) - 1;
-
 	disk->major		= pmem_major;
-	disk->first_minor	= PMEM_MINORS * idx;
+	disk->first_minor	= PMEM_MINORS * pmem->id;
 	disk->fops		= &pmem_fops;
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
-	sprintf(disk->disk_name, "pmem%d", idx);
+	sprintf(disk->disk_name, "pmem%d", pmem->id);
 	disk->driverfs_dev = dev;
 	set_capacity(disk, pmem->size >> 9);
 	pmem->pmem_disk = disk;
@@ -182,6 +187,8 @@ out_unmap:
 	iounmap(pmem->virt_addr);
 out_release_region:
 	release_mem_region(pmem->phys_addr, pmem->size);
+out_free_ida:
+	ida_simple_remove(&pmem_ida, pmem->id);
 out_free_dev:
 	kfree(pmem);
 out:
@@ -195,6 +202,7 @@ static void pmem_free(struct pmem_device *pmem)
 	blk_cleanup_queue(pmem->pmem_queue);
 	iounmap(pmem->virt_addr);
 	release_mem_region(pmem->phys_addr, pmem->size);
+	ida_simple_remove(&pmem_ida, pmem->id);
 	kfree(pmem);
 }
 

