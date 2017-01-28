Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BC8182010
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:42 -0800 (PST)
Subject: [RFC PATCH 06/17] axon_ram: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:36 -0800
Message-ID: <148559259666.11180.1133241048982729431.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Setup a dax_inode to have the same lifetime as the axon_ram block device
and add a ->direct_access() method that is equivalent to
axon_ram_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old axon_ram_direct_access() will be removed.
---
 arch/powerpc/platforms/Kconfig |    1 +
 arch/powerpc/sysdev/axonram.c  |   46 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

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
index ada29eaed6e2..4e1f58187726 100644
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
+	struct dax_inode	*dax_inode;
 	unsigned int		irq_id;
 	unsigned long		ph_addr;
 	unsigned long		io_addr;
@@ -137,25 +139,45 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+static long
+__axon_ram_direct_access(struct axon_ram_bank *bank, phys_addr_t offset,
+		       void **kaddr, pfn_t *pfn, long size)
+{
+	*kaddr = (void *) bank->io_addr + offset;
+	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
+	return bank->size - offset;
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
+	return __axon_ram_direct_access(bank, sector << AXON_RAM_SECTOR_SHIFT,
+			kaddr, pfn, size);
 }
 
 static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
-	.direct_access	= axon_ram_direct_access
+	.direct_access	= axon_ram_blk_direct_access
+};
+
+static long
+axon_ram_dax_direct_access(struct dax_inode *dax_inode, phys_addr_t dev_addr,
+		       void **kaddr, pfn_t *pfn, long size)
+{
+	struct axon_ram_bank *bank = dax_inode_get_private(dax_inode);
+
+	return __axon_ram_direct_access(bank, dev_addr, kaddr, pfn, size);
+}
+
+static const struct dax_operations axon_ram_dax_ops = {
+	.direct_access = axon_ram_dax_direct_access,
 };
 
 /**
@@ -219,6 +241,7 @@ static int axon_ram_probe(struct platform_device *device)
 		goto failed;
 	}
 
+
 	bank->disk->major = azfs_major;
 	bank->disk->first_minor = azfs_minor;
 	bank->disk->fops = &axon_ram_devops;
@@ -227,6 +250,11 @@ static int axon_ram_probe(struct platform_device *device)
 	sprintf(bank->disk->disk_name, "%s%d",
 			AXON_RAM_DEVICE_NAME, axon_ram_bank_id);
 
+	bank->dax_inode = alloc_dax_inode(bank, bank->disk->disk_name,
+			&axon_ram_dax_ops);
+	if (!bank->dax_inode)
+		goto failed;
+
 	bank->disk->queue = blk_alloc_queue(GFP_KERNEL);
 	if (bank->disk->queue == NULL) {
 		dev_err(&device->dev, "Cannot register disk queue\n");
@@ -276,6 +304,10 @@ static int axon_ram_probe(struct platform_device *device)
 						bank->disk->disk_name);
 			del_gendisk(bank->disk);
 		}
+		if (bank->dax_inode) {
+			kill_dax_inode(bank->dax_inode);
+			put_dax_inode(bank->dax_inode);
+		}
 		device->dev.platform_data = NULL;
 		if (bank->io_addr != 0)
 			iounmap((void __iomem *) bank->io_addr);
@@ -298,6 +330,8 @@ axon_ram_remove(struct platform_device *device)
 
 	device_remove_file(&device->dev, &dev_attr_ecc);
 	free_irq(bank->irq_id, device);
+	kill_dax_inode(bank->dax_inode);
+	put_dax_inode(bank->dax_inode);
 	del_gendisk(bank->disk);
 	iounmap((void __iomem *) bank->io_addr);
 	kfree(bank);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
