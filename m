Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 379C421A04830
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 15:37:57 -0700 (PDT)
Subject: [PATCH v3] axon_ram: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 15:32:13 -0700
Message-ID: <149264111867.36586.15762148888692084363.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Setup a dax_device to have the same lifetime as the axon_ram block
device and add a ->direct_access() method that is equivalent to
axon_ram_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old axon_ram_direct_access() will be removed.

Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v2:
* fix return code in the alloc_dax() failure case (Gerald)

 arch/powerpc/platforms/Kconfig |    1 +
 arch/powerpc/sysdev/axonram.c  |   48 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 7e3a2ebba29b..33244e3d9375 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -284,6 +284,7 @@ config CPM2
 config AXON_RAM
 	tristate "Axon DDR2 memory device driver"
 	depends on PPC_IBM_CELL_BLADE && BLOCK
+	select DAX
 	default m
 	help
 	  It registers one block device per Axon's DDR2 memory bank found
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index f523ac883150..171ba86a3494 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -25,6 +25,7 @@
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/dax.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -62,6 +63,7 @@ static int azfs_major, azfs_minor;
 struct axon_ram_bank {
 	struct platform_device	*device;
 	struct gendisk		*disk;
+	struct dax_device	*dax_dev;
 	unsigned int		irq_id;
 	unsigned long		ph_addr;
 	unsigned long		io_addr;
@@ -137,25 +139,47 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+static long
+__axon_ram_direct_access(struct axon_ram_bank *bank, pgoff_t pgoff, long nr_pages,
+		       void **kaddr, pfn_t *pfn)
+{
+	resource_size_t offset = pgoff * PAGE_SIZE;
+
+	*kaddr = (void *) bank->io_addr + offset;
+	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
+	return (bank->size - offset) / PAGE_SIZE;
+}
+
 /**
  * axon_ram_direct_access - direct_access() method for block device
  * @device, @sector, @data: see block_device_operations method
  */
 static long
-axon_ram_direct_access(struct block_device *device, sector_t sector,
+axon_ram_blk_direct_access(struct block_device *device, sector_t sector,
 		       void **kaddr, pfn_t *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
-	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
-	*kaddr = (void *) bank->io_addr + offset;
-	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
-	return bank->size - offset;
+	return __axon_ram_direct_access(bank, (sector * 512) / PAGE_SIZE,
+			size / PAGE_SIZE, kaddr, pfn) * PAGE_SIZE;
 }
 
 static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
-	.direct_access	= axon_ram_direct_access
+	.direct_access	= axon_ram_blk_direct_access
+};
+
+static long
+axon_ram_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
+		       void **kaddr, pfn_t *pfn)
+{
+	struct axon_ram_bank *bank = dax_get_private(dax_dev);
+
+	return __axon_ram_direct_access(bank, pgoff, nr_pages, kaddr, pfn);
+}
+
+static const struct dax_operations axon_ram_dax_ops = {
+	.direct_access = axon_ram_dax_direct_access,
 };
 
 /**
@@ -219,6 +243,7 @@ static int axon_ram_probe(struct platform_device *device)
 		goto failed;
 	}
 
+
 	bank->disk->major = azfs_major;
 	bank->disk->first_minor = azfs_minor;
 	bank->disk->fops = &axon_ram_devops;
@@ -227,6 +252,13 @@ static int axon_ram_probe(struct platform_device *device)
 	sprintf(bank->disk->disk_name, "%s%d",
 			AXON_RAM_DEVICE_NAME, axon_ram_bank_id);
 
+	bank->dax_dev = alloc_dax(bank, bank->disk->disk_name,
+			&axon_ram_dax_ops);
+	if (!bank->dax_dev) {
+		rc = -ENOMEM;
+		goto failed;
+	}
+
 	bank->disk->queue = blk_alloc_queue(GFP_KERNEL);
 	if (bank->disk->queue == NULL) {
 		dev_err(&device->dev, "Cannot register disk queue\n");
@@ -278,6 +310,8 @@ static int axon_ram_probe(struct platform_device *device)
 				del_gendisk(bank->disk);
 			put_disk(bank->disk);
 		}
+		kill_dax(bank->dax_dev);
+		put_dax(bank->dax_dev);
 		device->dev.platform_data = NULL;
 		if (bank->io_addr != 0)
 			iounmap((void __iomem *) bank->io_addr);
@@ -300,6 +334,8 @@ axon_ram_remove(struct platform_device *device)
 
 	device_remove_file(&device->dev, &dev_attr_ecc);
 	free_irq(bank->irq_id, device);
+	kill_dax(bank->dax_dev);
+	put_dax(bank->dax_dev);
 	del_gendisk(bank->disk);
 	put_disk(bank->disk);
 	iounmap((void __iomem *) bank->io_addr);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
