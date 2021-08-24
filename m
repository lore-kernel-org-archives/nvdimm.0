Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB673FCC
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:47 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="278355856"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="278355856"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:47 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="425515146"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:47 -0700
Subject: [PATCH v3 15/28] cxl/pci: Make 'struct cxl_mem' device type generic
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:47 -0700
Message-ID: <162982120696.1124374.11635718440690909189.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for adding a unit test provider of a cxl_memdev, convert
the 'struct cxl_mem' driver context to carry a generic device rather
than a pci device.

Note, some dev_dbg() lines needed extra reformatting per clang-format.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/memdev.c |    3 +-
 drivers/cxl/cxlmem.h      |    4 ++-
 drivers/cxl/pci.c         |   60 ++++++++++++++++++++++-----------------------
 3 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index a9c317e32010..40789558f8c2 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -149,7 +149,6 @@ static void cxl_memdev_unregister(void *_cxlmd)
 static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
 					   const struct file_operations *fops)
 {
-	struct pci_dev *pdev = cxlm->pdev;
 	struct cxl_memdev *cxlmd;
 	struct device *dev;
 	struct cdev *cdev;
@@ -166,7 +165,7 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
 
 	dev = &cxlmd->dev;
 	device_initialize(dev);
-	dev->parent = &pdev->dev;
+	dev->parent = cxlm->dev;
 	dev->bus = &cxl_bus_type;
 	dev->devt = MKDEV(cxl_mem_major, cxlmd->id);
 	dev->type = &cxl_memdev_type;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 6c0b1e2ea97c..8397daea9d9b 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -68,7 +68,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
 
 /**
  * struct cxl_mem - A CXL memory device
- * @pdev: The PCI device associated with this CXL device.
+ * @dev: The device associated with this CXL device.
  * @cxlmd: Logical memory device chardev / interface
  * @regs: Parsed register blocks
  * @payload_size: Size of space for payload
@@ -82,7 +82,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
  * @ram_range: Volatile memory capacity information.
  */
 struct cxl_mem {
-	struct pci_dev *pdev;
+	struct device *dev;
 	struct cxl_memdev *cxlmd;
 
 	struct cxl_regs regs;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 651e8d4ec974..24d84b69227a 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -250,7 +250,7 @@ static int cxl_mem_wait_for_doorbell(struct cxl_mem *cxlm)
 		cpu_relax();
 	}
 
-	dev_dbg(&cxlm->pdev->dev, "Doorbell wait took %dms",
+	dev_dbg(cxlm->dev, "Doorbell wait took %dms",
 		jiffies_to_msecs(end) - jiffies_to_msecs(start));
 	return 0;
 }
@@ -268,7 +268,7 @@ static bool cxl_is_security_command(u16 opcode)
 static void cxl_mem_mbox_timeout(struct cxl_mem *cxlm,
 				 struct mbox_cmd *mbox_cmd)
 {
-	struct device *dev = &cxlm->pdev->dev;
+	struct device *dev = cxlm->dev;
 
 	dev_dbg(dev, "Mailbox command (opcode: %#x size: %zub) timed out\n",
 		mbox_cmd->opcode, mbox_cmd->size_in);
@@ -300,6 +300,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
 				   struct mbox_cmd *mbox_cmd)
 {
 	void __iomem *payload = cxlm->regs.mbox + CXLDEV_MBOX_PAYLOAD_OFFSET;
+	struct device *dev = cxlm->dev;
 	u64 cmd_reg, status_reg;
 	size_t out_len;
 	int rc;
@@ -325,8 +326,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
 
 	/* #1 */
 	if (cxl_doorbell_busy(cxlm)) {
-		dev_err_ratelimited(&cxlm->pdev->dev,
-				    "Mailbox re-busy after acquiring\n");
+		dev_err_ratelimited(dev, "Mailbox re-busy after acquiring\n");
 		return -EBUSY;
 	}
 
@@ -345,7 +345,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
 	writeq(cmd_reg, cxlm->regs.mbox + CXLDEV_MBOX_CMD_OFFSET);
 
 	/* #4 */
-	dev_dbg(&cxlm->pdev->dev, "Sending command\n");
+	dev_dbg(dev, "Sending command\n");
 	writel(CXLDEV_MBOX_CTRL_DOORBELL,
 	       cxlm->regs.mbox + CXLDEV_MBOX_CTRL_OFFSET);
 
@@ -362,7 +362,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
 		FIELD_GET(CXLDEV_MBOX_STATUS_RET_CODE_MASK, status_reg);
 
 	if (mbox_cmd->return_code != 0) {
-		dev_dbg(&cxlm->pdev->dev, "Mailbox operation had an error\n");
+		dev_dbg(dev, "Mailbox operation had an error\n");
 		return 0;
 	}
 
@@ -399,7 +399,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
  */
 static int cxl_mem_mbox_get(struct cxl_mem *cxlm)
 {
-	struct device *dev = &cxlm->pdev->dev;
+	struct device *dev = cxlm->dev;
 	u64 md_status;
 	int rc;
 
@@ -502,7 +502,7 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
 					u64 in_payload, u64 out_payload,
 					s32 *size_out, u32 *retval)
 {
-	struct device *dev = &cxlm->pdev->dev;
+	struct device *dev = cxlm->dev;
 	struct mbox_cmd mbox_cmd = {
 		.opcode = cmd->opcode,
 		.size_in = cmd->info.size_in,
@@ -925,12 +925,12 @@ static int cxl_mem_setup_mailbox(struct cxl_mem *cxlm)
 	 */
 	cxlm->payload_size = min_t(size_t, cxlm->payload_size, SZ_1M);
 	if (cxlm->payload_size < 256) {
-		dev_err(&cxlm->pdev->dev, "Mailbox is too small (%zub)",
+		dev_err(cxlm->dev, "Mailbox is too small (%zub)",
 			cxlm->payload_size);
 		return -ENXIO;
 	}
 
-	dev_dbg(&cxlm->pdev->dev, "Mailbox payload sized %zu",
+	dev_dbg(cxlm->dev, "Mailbox payload sized %zu",
 		cxlm->payload_size);
 
 	return 0;
@@ -948,7 +948,7 @@ static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
 	}
 
 	mutex_init(&cxlm->mbox_mutex);
-	cxlm->pdev = pdev;
+	cxlm->dev = dev;
 	cxlm->enabled_cmds =
 		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
 				   sizeof(unsigned long),
@@ -964,9 +964,9 @@ static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
 static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
 					  u8 bar, u64 offset)
 {
-	struct pci_dev *pdev = cxlm->pdev;
-	struct device *dev = &pdev->dev;
 	void __iomem *addr;
+	struct device *dev = cxlm->dev;
+	struct pci_dev *pdev = to_pci_dev(dev);
 
 	/* Basic sanity check that BAR is big enough */
 	if (pci_resource_len(pdev, bar) < offset) {
@@ -989,7 +989,7 @@ static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
 
 static void cxl_mem_unmap_regblock(struct cxl_mem *cxlm, void __iomem *base)
 {
-	pci_iounmap(cxlm->pdev, base);
+	pci_iounmap(to_pci_dev(cxlm->dev), base);
 }
 
 static int cxl_mem_dvsec(struct pci_dev *pdev, int dvsec)
@@ -1018,7 +1018,7 @@ static int cxl_mem_dvsec(struct pci_dev *pdev, int dvsec)
 static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
 			  struct cxl_register_map *map)
 {
-	struct pci_dev *pdev = cxlm->pdev;
+	struct pci_dev *pdev = to_pci_dev(cxlm->dev);
 	struct device *dev = &pdev->dev;
 	struct cxl_component_reg_map *comp_map;
 	struct cxl_device_reg_map *dev_map;
@@ -1057,7 +1057,7 @@ static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
 
 static int cxl_map_regs(struct cxl_mem *cxlm, struct cxl_register_map *map)
 {
-	struct pci_dev *pdev = cxlm->pdev;
+	struct pci_dev *pdev = to_pci_dev(cxlm->dev);
 	struct device *dev = &pdev->dev;
 
 	switch (map->reg_type) {
@@ -1096,8 +1096,8 @@ static void cxl_decode_register_block(u32 reg_lo, u32 reg_hi,
  */
 static int cxl_mem_setup_regs(struct cxl_mem *cxlm)
 {
-	struct pci_dev *pdev = cxlm->pdev;
-	struct device *dev = &pdev->dev;
+	struct pci_dev *pdev = to_pci_dev(cxlm->dev);
+	struct device *dev = cxlm->dev;
 	u32 regloc_size, regblocks;
 	void __iomem *base;
 	int regloc, i, n_maps;
@@ -1226,7 +1226,7 @@ static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
 		struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
 
 		if (!cmd) {
-			dev_dbg(&cxlm->pdev->dev,
+			dev_dbg(cxlm->dev,
 				"Opcode 0x%04x unsupported by driver", opcode);
 			continue;
 		}
@@ -1323,7 +1323,7 @@ static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
 static int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm)
 {
 	struct cxl_mbox_get_supported_logs *gsl;
-	struct device *dev = &cxlm->pdev->dev;
+	struct device *dev = cxlm->dev;
 	struct cxl_mem_command *cmd;
 	int i, rc;
 
@@ -1418,15 +1418,14 @@ static int cxl_mem_identify(struct cxl_mem *cxlm)
 	cxlm->partition_align_bytes = le64_to_cpu(id.partition_align);
 	cxlm->partition_align_bytes *= CXL_CAPACITY_MULTIPLIER;
 
-	dev_dbg(&cxlm->pdev->dev, "Identify Memory Device\n"
+	dev_dbg(cxlm->dev,
+		"Identify Memory Device\n"
 		"     total_bytes = %#llx\n"
 		"     volatile_only_bytes = %#llx\n"
 		"     persistent_only_bytes = %#llx\n"
 		"     partition_align_bytes = %#llx\n",
-			cxlm->total_bytes,
-			cxlm->volatile_only_bytes,
-			cxlm->persistent_only_bytes,
-			cxlm->partition_align_bytes);
+		cxlm->total_bytes, cxlm->volatile_only_bytes,
+		cxlm->persistent_only_bytes, cxlm->partition_align_bytes);
 
 	cxlm->lsa_size = le32_to_cpu(id.lsa_size);
 	memcpy(cxlm->firmware_version, id.fw_revision, sizeof(id.fw_revision));
@@ -1453,19 +1452,18 @@ static int cxl_mem_create_range_info(struct cxl_mem *cxlm)
 					&cxlm->next_volatile_bytes,
 					&cxlm->next_persistent_bytes);
 	if (rc < 0) {
-		dev_err(&cxlm->pdev->dev, "Failed to query partition information\n");
+		dev_err(cxlm->dev, "Failed to query partition information\n");
 		return rc;
 	}
 
-	dev_dbg(&cxlm->pdev->dev, "Get Partition Info\n"
+	dev_dbg(cxlm->dev,
+		"Get Partition Info\n"
 		"     active_volatile_bytes = %#llx\n"
 		"     active_persistent_bytes = %#llx\n"
 		"     next_volatile_bytes = %#llx\n"
 		"     next_persistent_bytes = %#llx\n",
-			cxlm->active_volatile_bytes,
-			cxlm->active_persistent_bytes,
-			cxlm->next_volatile_bytes,
-			cxlm->next_persistent_bytes);
+		cxlm->active_volatile_bytes, cxlm->active_persistent_bytes,
+		cxlm->next_volatile_bytes, cxlm->next_persistent_bytes);
 
 	cxlm->ram_range.start = 0;
 	cxlm->ram_range.end = cxlm->active_volatile_bytes - 1;

