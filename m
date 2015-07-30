Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 03/24] cleanup IORESOURCE_CACHEABLE vs ioremap()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:53:56 -0400
Message-ID: <20150730165356.33962.41257.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Quoting Arnd:
    I was thinking the opposite approach and basically removing all uses
    of IORESOURCE_CACHEABLE from the kernel. There are only a handful of
    them.and we can probably replace them all with hardcoded
    ioremap_cached() calls in the cases they are actually useful.

All existing usages of IORESOURCE_CACHEABLE call ioremap() instead of
ioremap_nocache() if the resource is cacheable, however ioremap() is
uncached by default. Clearly none of the existing usages care about the
cacheability. Particularly devm_ioremap_resource() never worked as
advertised since it always fell back to plain ioremap().

Clean this up as the new direction we want is to convert
ioremap_<type>() usages to memremap(..., flags).

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-clps711x/board-cdb89712.c |    2 +-
 arch/powerpc/kernel/pci_of_scan.c       |    2 +-
 arch/sparc/kernel/pci.c                 |    3 +--
 drivers/pci/probe.c                     |    3 +--
 drivers/pnp/manager.c                   |    2 --
 drivers/scsi/aic94xx/aic94xx_init.c     |    7 +------
 drivers/scsi/arcmsr/arcmsr_hba.c        |    5 +----
 drivers/scsi/mvsas/mv_init.c            |   15 ++++-----------
 drivers/video/fbdev/ocfb.c              |    1 -
 lib/devres.c                            |   13 ++++---------
 lib/pci_iomap.c                         |    7 ++-----
 11 files changed, 16 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-clps711x/board-cdb89712.c b/arch/arm/mach-clps711x/board-cdb89712.c
index 1ec378c334e5..972abdb10028 100644
--- a/arch/arm/mach-clps711x/board-cdb89712.c
+++ b/arch/arm/mach-clps711x/board-cdb89712.c
@@ -95,7 +95,7 @@ static struct physmap_flash_data cdb89712_bootrom_pdata __initdata = {
 
 static struct resource cdb89712_bootrom_resources[] __initdata = {
 	DEFINE_RES_NAMED(CS7_PHYS_BASE, SZ_128, "BOOTROM", IORESOURCE_MEM |
-			 IORESOURCE_CACHEABLE | IORESOURCE_READONLY),
+			 IORESOURCE_READONLY),
 };
 
 static struct platform_device cdb89712_bootrom_pdev __initdata = {
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 42e02a2d570b..d4726addff0b 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -102,7 +102,7 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 			res = &dev->resource[(i - PCI_BASE_ADDRESS_0) >> 2];
 		} else if (i == dev->rom_base_reg) {
 			res = &dev->resource[PCI_ROM_RESOURCE];
-			flags |= IORESOURCE_READONLY | IORESOURCE_CACHEABLE;
+			flags |= IORESOURCE_READONLY;
 		} else {
 			printk(KERN_ERR "PCI: bad cfg reg num 0x%x\n", i);
 			continue;
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index c928bc64b4ba..04da147e0712 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -231,8 +231,7 @@ static void pci_parse_of_addrs(struct platform_device *op,
 			res = &dev->resource[(i - PCI_BASE_ADDRESS_0) >> 2];
 		} else if (i == dev->rom_base_reg) {
 			res = &dev->resource[PCI_ROM_RESOURCE];
-			flags |= IORESOURCE_READONLY | IORESOURCE_CACHEABLE
-			      | IORESOURCE_SIZEALIGN;
+			flags |= IORESOURCE_READONLY | IORESOURCE_SIZEALIGN;
 		} else {
 			printk(KERN_ERR "PCI: bad cfg reg num 0x%x\n", i);
 			continue;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cefd636681b6..8ed37dd04056 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -326,8 +326,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 		struct resource *res = &dev->resource[PCI_ROM_RESOURCE];
 		dev->rom_base_reg = rom;
 		res->flags = IORESOURCE_MEM | IORESOURCE_PREFETCH |
-				IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
-				IORESOURCE_SIZEALIGN;
+				IORESOURCE_READONLY | IORESOURCE_SIZEALIGN;
 		__pci_read_base(dev, pci_bar_mem32, res, rom);
 	}
 }
diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
index 9357aa779048..7ad3295752ef 100644
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -97,8 +97,6 @@ static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 	/* ??? rule->flags restricted to 8 bits, all tests bogus ??? */
 	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
 		res->flags |= IORESOURCE_READONLY;
-	if (rule->flags & IORESOURCE_MEM_CACHEABLE)
-		res->flags |= IORESOURCE_CACHEABLE;
 	if (rule->flags & IORESOURCE_MEM_RANGELENGTH)
 		res->flags |= IORESOURCE_RANGELENGTH;
 	if (rule->flags & IORESOURCE_MEM_SHADOWABLE)
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 4b135cca42a1..140cb8e6fea2 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -100,12 +100,7 @@ static int asd_map_memio(struct asd_ha_struct *asd_ha)
 				   pci_name(asd_ha->pcidev));
 			goto Err;
 		}
-		if (io_handle->flags & IORESOURCE_CACHEABLE)
-			io_handle->addr = ioremap(io_handle->start,
-						  io_handle->len);
-		else
-			io_handle->addr = ioremap_nocache(io_handle->start,
-							  io_handle->len);
+		io_handle->addr = ioremap(io_handle->start, io_handle->len);
 		if (!io_handle->addr) {
 			asd_printk("couldn't map MBAR%d of %s\n", i==0?0:1,
 				   pci_name(asd_ha->pcidev));
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 914c39f9f388..e4f77cad9fd8 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -259,10 +259,7 @@ static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
 		addr = (unsigned long)pci_resource_start(pdev, 0);
 		range = pci_resource_len(pdev, 0);
 		flags = pci_resource_flags(pdev, 0);
-		if (flags & IORESOURCE_CACHEABLE)
-			mem_base0 = ioremap(addr, range);
-		else
-			mem_base0 = ioremap_nocache(addr, range);
+		mem_base0 = ioremap(addr, range);
 		if (!mem_base0) {
 			pr_notice("arcmsr%d: memory mapping region fail\n",
 				acb->host->host_no);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index d40d734aa53a..e654b5cec69e 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -324,13 +324,9 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 			goto err_out;
 
 		res_flag_ex = pci_resource_flags(pdev, bar_ex);
-		if (res_flag_ex & IORESOURCE_MEM) {
-			if (res_flag_ex & IORESOURCE_CACHEABLE)
-				mvi->regs_ex = ioremap(res_start, res_len);
-			else
-				mvi->regs_ex = ioremap_nocache(res_start,
-						res_len);
-		} else
+		if (res_flag_ex & IORESOURCE_MEM)
+			mvi->regs_ex = ioremap(res_start, res_len);
+		else
 			mvi->regs_ex = (void *)res_start;
 		if (!mvi->regs_ex)
 			goto err_out;
@@ -342,10 +338,7 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 		goto err_out;
 
 	res_flag = pci_resource_flags(pdev, bar);
-	if (res_flag & IORESOURCE_CACHEABLE)
-		mvi->regs = ioremap(res_start, res_len);
-	else
-		mvi->regs = ioremap_nocache(res_start, res_len);
+	mvi->regs = ioremap(res_start, res_len);
 
 	if (!mvi->regs) {
 		if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
diff --git a/drivers/video/fbdev/ocfb.c b/drivers/video/fbdev/ocfb.c
index de9819660ca0..c9293aea8ec3 100644
--- a/drivers/video/fbdev/ocfb.c
+++ b/drivers/video/fbdev/ocfb.c
@@ -325,7 +325,6 @@ static int ocfb_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "I/O resource request failed\n");
 		return -ENXIO;
 	}
-	res->flags &= ~IORESOURCE_CACHEABLE;
 	fbdev->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(fbdev->regs))
 		return PTR_ERR(fbdev->regs);
diff --git a/lib/devres.c b/lib/devres.c
index fbe2aac522e6..f13a2468ff39 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -119,10 +119,9 @@ EXPORT_SYMBOL(devm_iounmap);
  * @dev: generic device to handle the resource for
  * @res: resource to be handled
  *
- * Checks that a resource is a valid memory region, requests the memory region
- * and ioremaps it either as cacheable or as non-cacheable memory depending on
- * the resource's flags. All operations are managed and will be undone on
- * driver detach.
+ * Checks that a resource is a valid memory region, requests the memory
+ * region and ioremaps it. All operations are managed and will be undone
+ * on driver detach.
  *
  * Returns a pointer to the remapped memory or an ERR_PTR() encoded error code
  * on failure. Usage example:
@@ -153,11 +152,7 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 		return IOMEM_ERR_PTR(-EBUSY);
 	}
 
-	if (res->flags & IORESOURCE_CACHEABLE)
-		dest_ptr = devm_ioremap(dev, res->start, size);
-	else
-		dest_ptr = devm_ioremap_nocache(dev, res->start, size);
-
+	dest_ptr = devm_ioremap(dev, res->start, size);
 	if (!dest_ptr) {
 		dev_err(dev, "ioremap failed for resource %pR\n", res);
 		devm_release_mem_region(dev, res->start, size);
diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index bcce5f149310..e1930dbab2da 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -41,11 +41,8 @@ void __iomem *pci_iomap_range(struct pci_dev *dev,
 		len = maxlen;
 	if (flags & IORESOURCE_IO)
 		return __pci_ioport_map(dev, start, len);
-	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
-	}
+	if (flags & IORESOURCE_MEM)
+		return ioremap(start, len);
 	/* What? */
 	return NULL;
 }

